local M = {}

M.opts = {
  compile_cmd = { "typst", "watch" },
  split = "vsplit",
}

local state = {}

local function render_preview()
  if not state.src or not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  local pdf = state.src:gsub("%.typ$", ".pdf")
  if vim.fn.filereadable(pdf) ~= 1 then
    return
  end

  -- Get the preview window dimensions for sizing
  local width, height
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    width = vim.api.nvim_win_get_width(state.win)
    height = vim.api.nvim_win_get_height(state.win)
  else
    width = 80
    height = 40
  end

  local tmp = vim.fn.tempname() .. ".png"

  -- PDF → PNG via pdftoppm
  local convert = vim.system({ "pdftoppm", "-png", "-r", "150", "-singlefile", pdf, tmp:gsub("%.png$", "") }):wait()
  if convert.code ~= 0 then
    return
  end

  -- PNG → terminal text via chafa
  local chafa = vim.system({ "chafa", "--size", width .. "x" .. height, "--animate=off", tmp }):wait()
  vim.fn.delete(tmp)
  if chafa.code ~= 0 or not chafa.stdout then
    return
  end

  local lines = vim.split(chafa.stdout, "\n", { trimempty = true })
  vim.api.nvim_set_option_value("modifiable", true, { buf = state.buf })
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = state.buf })
end

function M.stop()
  if state.compile_job then
    state.compile_job:kill(9)
    state.compile_job = nil
  end
  if state.autocmd_id then
    vim.api.nvim_del_autocmd(state.autocmd_id)
    state.autocmd_id = nil
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state = {}
end

function M.start()
  M.stop()

  local src = vim.api.nvim_buf_get_name(0)
  if src == "" then
    vim.notify("typst-preview: buffer has no file", vim.log.levels.ERROR)
    return
  end
  state.src = src
  state.src_buf = vim.api.nvim_get_current_buf()

  -- Compile once so the PDF exists
  local result = vim.system({ "typst", "compile", src }):wait()
  if result.code ~= 0 then
    vim.notify("typst-preview: compile failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
    state = {}
    return
  end

  -- Start typst watch for live updates
  local watch = vim.deepcopy(M.opts.compile_cmd)
  table.insert(watch, src)
  state.compile_job = vim.system(watch, { detach = true })

  -- Create preview buffer in a split
  vim.cmd(M.opts.split)
  vim.cmd("enew")
  state.win = vim.api.nvim_get_current_win()
  state.buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = state.buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = state.buf })
  vim.api.nvim_buf_set_name(state.buf, "typst-preview")
  vim.cmd("wincmd p")

  -- Initial render
  render_preview()

  -- Re-render on save
  state.autocmd_id = vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = state.src_buf,
    callback = function()
      -- Small delay to let typst watch recompile
      vim.defer_fn(render_preview, 500)
    end,
  })
end

function M.setup(user_opts)
  if user_opts then
    M.opts = vim.tbl_deep_extend("force", M.opts, user_opts)
  end

  vim.api.nvim_create_user_command("TypstPreview", M.start, { desc = "Start Typst live preview" })
  vim.api.nvim_create_user_command("TypstPreviewStop", M.stop, { desc = "Stop Typst live preview" })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    callback = function()
      vim.keymap.set("n", "<leader>tp", M.start, { buffer = true, desc = "Typst preview" })
      vim.keymap.set("n", "<leader>ts", M.stop, { buffer = true, desc = "Typst preview stop" })
    end,
  })
end

return M
