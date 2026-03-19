return {
  (function()
    local theme = require("nix-theme")
    return {
      theme.plugin,
      name = "colorscheme",
      priority = 1000,
      config = function()
        local name = theme.colorscheme:match("([^-]+)")
        -- Some themes use vim.g options instead of/alongside setup()
        vim.g[name .. "_transparent_background"] = 2
        vim.g[name .. "_background"] = theme.variant
        local ok, mod = pcall(require, name)
        if ok and type(mod) == "table" and mod.setup then
          mod.setup({
            variant = theme.variant,
            dark_variant = theme.variant,
            styles = { transparency = true },
            transparent_background = true,
          })
        end
        local cs_ok, cs_err = pcall(vim.cmd, "colorscheme " .. theme.colorscheme)
        if not cs_ok then
          -- Plugin may not be installed yet (first launch after theme switch);
          -- Lazy will install it, then we retry via lazy-bootstrap.lua
          vim.notify("Colorscheme not yet available, installing...", vim.log.levels.INFO)
          return
        end
        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      end,
    }
  end)(),

  -- {
  --   "nvim-telescope/telescope.nvim",
  --   branch = "master",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = {
  --     { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  --     { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  --     { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  --     { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
  --   },
  -- },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nix-treesitter-parsers")
      local ts = require("nvim-treesitter")
      local languages = {
        "lua",
        "vim",
        "vimdoc",
        "nix",
        "bash",
        "nu",
        "markdown",
        "markdown_inline",
        "rust",
        "go",
        "ocaml",
        "html",
        "css",
        "javascript",
        "typescript",
        "jinja",
        "toml",
        "json",
        "yaml",
        "nim",
        "typst",
      }
      -- Org mode
      org = {
        install_info = {
          url = "https://github.com/milisims/tree-sitter-org",
          revision = "main",
          files = { "src/parser.c", "src/scanner.cc" },
        },
        filetype = "org",
      }

      -- Yuck
      yuck =
        {
          install_info = {
            url = "https://github.com/philipkari/tree-sitter-yuck",
            files = { "src/parser.c" },
          },
          filetype = "yuck",
        }, vim.api.nvim_create_autocmd("FileType", {
          pattern = languages,
          callback = function()
            vim.treesitter.start()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    after = "nvim-treesitter",
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false, -- Enable multiwindow support.
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })

      -- Experimental LSP support
      vim.lsp.enable("org")
    end,
  },

  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",

      -- Only one of these is needed.
      "sindrets/diffview.nvim",
      --"esmuellert/codediff.nvim",

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim",
      --"ibhagwan/fzf-lua",
      --"nvim-mini/mini.pick",
      --"folke/snacks.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
  },

  {
    "numToStr/Comment.nvim",
    {
      -- add any options here
    },
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
