return {
  -- Treesitter: syntax highlighting + code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "go", "gomod", "gowork", "gosum",
        "c_sharp",
        "yaml",
        "bash",
        "json", "jsonc",
        "toml",
        "markdown", "markdown_inline",
      },
    },
  },

  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Formatting (with format-on-save)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- Mason: auto-install LSPs, formatters, and DAP adapters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "gopls",
        "omnisharp",
        "yaml-language-server",
        "bash-language-server",
        -- Formatters / linters
        "goimports",
        "csharpier",
        "prettier",
        "shfmt",
        "stylua",
        -- DAP adapters
        "delve",       -- Go debugger
        "netcoredbg",  -- .NET debugger
      },
    },
  },

  -- Diagnostics panel
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      signs = {
        error   = "",
        warn    = "",
        hint    = "",
        info    = "",
      },
    },
  },

  -- Floating terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = { [[<C-\>]] },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
    },
  },

  -- Lazygit inside Neovim
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- DAP core + UI
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",  -- required by dap-ui
      "leoluz/nvim-dap-go",
    },
    config = function()
      require "configs.dap"

      -- Auto-open/close DAP UI with debug sessions
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"]  = dapui.open
      dap.listeners.before.event_terminated["dapui_config"]  = dapui.close
      dap.listeners.before.event_exited["dapui_config"]      = dapui.close
    end,
  },

  -- Highlight TODO/FIXME/HACK/NOTE comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
  },

  -- Harpoon2: quick-jump between pinned files per project
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<leader>ha",
        function() require("harpoon"):list():add() end,
        desc = "Harpoon: add file",
      },
      {
        "<leader>hh",
        function()
          local h = require("harpoon")
          h.ui:toggle_quick_menu(h:list())
        end,
        desc = "Harpoon: quick menu",
      },
      {
        "<leader>1",
        function() require("harpoon"):list():select(1) end,
        desc = "Harpoon: file 1",
      },
      {
        "<leader>2",
        function() require("harpoon"):list():select(2) end,
        desc = "Harpoon: file 2",
      },
      {
        "<leader>3",
        function() require("harpoon"):list():select(3) end,
        desc = "Harpoon: file 3",
      },
      {
        "<leader>4",
        function() require("harpoon"):list():select(4) end,
        desc = "Harpoon: file 4",
      },
      {
        "<leader>]",
        function() require("harpoon"):list():next() end,
        desc = "Harpoon: next file",
      },
      {
        "<leader>[",
        function() require("harpoon"):list():prev() end,
        desc = "Harpoon: prev file",
      },
    },
  },

  -- ── AI ───────────────────────────────────────────────────────────────────────

  -- Avante: AI sidebar chat + inline editing (DeepSeek)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "deepseek",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-v4-pro",
          extra_request_body = { temperature = 0, max_tokens = 32000 },
        },
      },
      input = { provider = "dressing" },
      behaviour = {
        auto_approve_tool_permissions = false,
        confirmation_ui_style = "popup",
      },
    },
    config = function(_, opts)
      require("avante").setup(opts)
      -- DeepSeek is a REST API provider, not an ACP agent — remove ACP-only keys
      pcall(vim.keymap.del, "n", "<leader>aM")
      pcall(vim.keymap.del, "n", "<leader>am")
    end,
  },

  -- Minuet: inline ghost-text completions (DeepSeek via OpenAI-compat endpoint)
  {
    "milanglacier/minuet-ai.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          api_key_name = "DEEPSEEK_API_KEY",
          end_point = "https://api.deepseek.com/chat/completions",
          model = "deepseek-v4-pro",
          name = "DeepSeek",
          optional = { max_tokens = 256, top_p = 0.9 },
        },
      },
      virtualtext = {
        auto_trigger_ft = {},  -- manual trigger only
        keymap = {
          accept      = "<A-l>",
          accept_line = "<A-j>",
          prev        = "<A-[>",
          next        = "<A-]>",
          dismiss     = "<A-e>",
        },
      },
    },
  },

  -- Expose minuet as a nvim-cmp source
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "minuet" })
      return opts
    end,
  },

  -- Oil: edit the filesystem like a buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- Keep nvim-tree as the default explorer; oil opens on demand via `-`
      default_file_explorer = false,
      columns = { "icon", "permissions", "size", "mtime" },
      view_options = { show_hidden = true },
      -- Don't clobber window-navigation keys
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
    },
  },
}
