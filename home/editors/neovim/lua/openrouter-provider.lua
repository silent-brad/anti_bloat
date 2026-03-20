-- Custom OpenRouter provider for ThePrimeagen/99
-- Uses curl via vim.system instead of Nushell.
-- API key is loaded from secrets/secrets.lua (symlinked into nvim config, gitignored).

local M = {}

local function get_api_key()
  local ok, secrets = pcall(require, "secrets")
  if ok and secrets.openrouter_api_key and secrets.openrouter_api_key ~= "YOUR_KEY_HERE" then
    return secrets.openrouter_api_key
  end
  local env_key = os.getenv("OPENROUTER_API_KEY")
  if env_key and env_key ~= "" then
    return env_key
  end
  return nil
end

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

  -- Required by pickers.lua for provider discovery; unused since make_request is overridden
  function OpenRouterProvider._build_command(_, _, _)
    return { "true" }
  end

  function OpenRouterProvider:make_request(query, context, observer)
    observer.on_start()

    local api_key = get_api_key()
    if not api_key then
      observer.on_stderr("OPENROUTER_API_KEY not set (check secrets.lua or env)\n")
      observer.on_complete("failed", "OPENROUTER_API_KEY not set")
      return
    end

    local system_msg = "You are a code-writing assistant. "
      .. "Output ONLY raw code or raw text as requested. "
      .. "NEVER wrap output in markdown code fences (```) or only add commentary in comments. "
      .. "When asked to write to a file path, output the exact file contents only."

    local payload = vim.json.encode({
      model = context.model,
      messages = {
        { role = "system", content = system_msg },
        { role = "user", content = query },
      },
    })

    local payload_file = os.tmpname()
    local pf = io.open(payload_file, "w")
    pf:write(payload)
    pf:close()

    local accumulated = {}

    local proc = vim.system(
      {
        "curl",
        "-sS",
        "https://openrouter.ai/api/v1/chat/completions",
        "-H",
        "Authorization: Bearer " .. api_key,
        "-H",
        "Content-Type: application/json",
        "-d",
        "@" .. payload_file,
      },
      {
        text = true,
        stdout = vim.schedule_wrap(function(_, data)
          if context:is_cancelled() or not data then
            return
          end
          table.insert(accumulated, data)
          observer.on_stdout(data)
        end),
        stderr = vim.schedule_wrap(function(_, data)
          if data then
            observer.on_stderr(data)
          end
        end),
      },
      vim.schedule_wrap(function(obj)
        os.remove(payload_file)
        if context:is_cancelled() then
          observer.on_complete("cancelled", "")
          return
        end

        if obj.code ~= 0 then
          observer.on_complete("failed", "curl exit code: " .. obj.code .. "\n" .. (obj.stderr or ""))
          return
        end

        local raw = table.concat(accumulated)
        local ok, decoded = pcall(vim.json.decode, raw)
        if not ok then
          observer.on_complete("failed", "Failed to parse API response: " .. raw)
          return
        end

        local content = ""
        if decoded.choices and decoded.choices[1] and decoded.choices[1].message then
          content = decoded.choices[1].message.content or ""
        end

        if content == "" then
          observer.on_complete("failed", "Empty response from OpenRouter: " .. raw)
          return
        end

        -- Strip markdown code fences if the LLM still wraps output
        content = content:gsub("^```[a-z]*\n", ""):gsub("\n```$", "")

        -- Write to tmp_file so _retrieve_response works
        local f = io.open(context.tmp_file, "w")
        if f then
          f:write(content)
          f:close()
        end

        observer.on_complete("success", content)
      end)
    )

    context:_set_process(proc)
  end

  function OpenRouterProvider.fetch_models(callback)
    vim.system(
      {
        "curl",
        "-sS",
        "https://openrouter.ai/api/v1/models",
      },
      { text = true },
      vim.schedule_wrap(function(obj)
        if obj.code ~= 0 then
          callback(nil, "Failed to fetch models from OpenRouter: " .. (obj.stderr or ""))
          return
        end
        local ok, decoded = pcall(vim.json.decode, obj.stdout)
        if not ok then
          callback(nil, "Failed to parse models response")
          return
        end
        local models = {}
        if decoded.data then
          for _, m in ipairs(decoded.data) do
            if m.id then
              table.insert(models, m.id)
            end
          end
        end
        table.sort(models)
        callback(models, nil)
      end)
    )
  end

  return OpenRouterProvider
end

return M
