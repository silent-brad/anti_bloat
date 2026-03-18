local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  install = { missing = true },
  checker = { enabled = false },
})

-- Synchronously install any missing plugins (e.g. after a theme switch)
-- so colorscheme configs don't fail on first launch
local plugins = require("lazy").plugins()
local missing = false
for _, plugin in ipairs(plugins) do
  if not plugin._.installed then
    missing = true
    break
  end
end
if missing then
  require("lazy").install({ wait = true })
  -- Reload the colorscheme after install
  local ok, theme = pcall(require, "nix-theme")
  if ok then
    pcall(vim.cmd, "colorscheme " .. theme.colorscheme)
  end
end
