return {
  "ThePrimeagen/99",
  config = function()
    local _99 = require("99")
    local OpenRouterProvider = require("openrouter-provider").build()
    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup({
      provider = OpenRouterProvider,
      model = "moonshotai/kimi-k2.5",
      tmp_dir = "./tmp",
      md_files = { "AGENT.md" },
      completion = {
        source = "cmp",
      },
      logger = {
        level = _99.DEBUG,
        path = "/tmp/" .. basename .. ".99.debug",
        print_on_error = true,
      },
    })

    vim.keymap.set("v", "<leader>9v", function()
      _99.visual()
    end, { desc = "99: Visual replace" })

    vim.keymap.set("n", "<leader>9s", function()
      _99.search()
    end, { desc = "99: Search" })

    vim.keymap.set("n", "<leader>9x", function()
      _99.stop_all_requests()
    end, { desc = "99: Stop all requests" })

    vim.keymap.set("n", "<leader>9m", function()
      require("99.extensions.telescope").select_model()
    end, { desc = "99: Select model" })

    vim.keymap.set("n", "<leader>9p", function()
      require("99.extensions.telescope").select_provider()
    end, { desc = "99: Select provider" })
  end,
}
