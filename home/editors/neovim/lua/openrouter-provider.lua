-- Custom OpenRouter provider for ThePrimeagen/99
-- Bypasses opencode CLI entirely, calling OpenRouter API directly via curl.
-- The script extracts <TEMP_FILE> from the query, calls the API, and writes
-- the response to that file — fulfilling 99's provider contract.

local M = {}

--- Build the OpenRouter provider once 99 is loaded.
--- Must be called after require("99") so BaseProvider is available.
function M.build()
  local BaseProvider = require("99.providers").BaseProvider

  --- @class OpenRouterProvider : _99.Providers.BaseProvider
  local OpenRouterProvider = setmetatable({}, { __index = BaseProvider })

  function OpenRouterProvider._get_provider_name()
    return "OpenRouterProvider"
  end

  function OpenRouterProvider._get_default_model()
    return "moonshotai/kimi-k2.5"
  end

  --- Build a command that:
  ---   1. Calls OpenRouter chat completions API via curl
  ---   2. Extracts the response content with jq
  ---   3. Writes it to the temp file parsed from <TEMP_FILE>...</TEMP_FILE> in the query
  function OpenRouterProvider._build_command(_, query, context)
    -- Extract the temp file path from the query text
    local tmp_file = context.tmp_file

    -- We use a nu script inline to handle the API call and file write.
    -- The query is passed via a temp prompt file to avoid shell escaping issues.
    local prompt_file = tmp_file .. "-prompt"

    -- Write the query to the prompt file so bash can read it safely
    local f = io.open(prompt_file, "w")
    if f then
      f:write(query)
      f:close()
    end

    -- Write the system message to its own file to avoid shell escaping issues
    local system_file = tmp_file .. "-system"
    local system_msg = "You are a code-writing assistant. "
      .. "Output ONLY raw code or raw text as requested. "
      .. "NEVER wrap output in markdown code fences (```) or only add commentary in comments. "
      .. "When asked to write to a file path, output the exact file contents only."
    local sf = io.open(system_file, "w")
    if sf then
      sf:write(system_msg)
      sf:close()
    end

    -- Use nu's open command to read prompt and system message directly from disk.
    -- This avoids shell variable expansion, ARG_MAX limits, and escaping issues
    -- with large prompts that contain file contents and special characters.
    local script = string.format([[
let model = %q
let tmp_file = %q
let prompt_file = %q
let system_file = %q

let api_key = (if ($env | get -i OPENROUTER_API_KEY | is-empty) { 
  print -e "OPENROUTER_API_KEY not set"
  exit 1
} else { 
  $env.OPENROUTER_API_KEY 
})

let prompt_content = (open --raw $prompt_file)
let system_content = (open --raw $system_file)

let payload = {
  model: $model,
  messages: [
    {role: "system", content: $system_content},
    {role: "user", content: $prompt_content}
  ]
} | to json

let response = (http post https://openrouter.ai/api/v1/chat/completions --content-type application/json --header [Authorization $"Bearer ($api_key)"] $payload)

let content = ($response | get -i choices.0.message.content | default "")

if ($content | is-empty) {
  print -e "Error: empty response from OpenRouter"
  print -e $response
  exit 1
}

# Strip markdown code fences if the LLM still wraps output
let content = ($content | str replace -r '^```[a-z]*\n' '' | str replace -r '\n```$' '')

$content | save -f $tmp_file
]], context.model, tmp_file, prompt_file, system_file)

    return { "nu", "-c", script }
  end

  --- Fetch available models from the OpenRouter API
  function OpenRouterProvider.fetch_models(callback)
    vim.system(
      {
        "nu", "-c",
        [[http get https://openrouter.ai/api/v1/models | get data.id | sort]],
      },
      { text = true },
      vim.schedule_wrap(function(obj)
        if obj.code ~= 0 then
          callback(nil, "Failed to fetch models from OpenRouter: " .. (obj.stderr or ""))
          return
        end
        local models = vim.split(obj.stdout, "\n", { trimempty = true })
        callback(models, nil)
      end)
    )
  end

  return OpenRouterProvider
end

return M
