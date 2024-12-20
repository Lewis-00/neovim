return {
   {
      "github/copilot.vim",
   },
   {
      "nvim-tree/nvim-tree.lua",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         local nvimtree = require("nvim-tree")

         -- recommended settings from nvim-tree documentation
         vim.g.loaded_netrw = 1
         vim.g.loaded_netrwPlugin = 1

         nvimtree.setup({
            view = {
               width = 32,
               relativenumber = true,
            },
            -- change folder arrow icons
            renderer = {
               indent_markers = {
                  enable = true,
               },
               icons = {
                  glyphs = {
                     folder = {
                        arrow_closed = "", -- arrow when folder is closed
                        arrow_open = "", -- arrow when folder is open
                     },
                  },
               },
            },
            -- disable window_picker for
            -- explorer to work well with
            -- window splits
            actions = {
               open_file = {
                  window_picker = {
                     enable = false,
                  },
               },
            },
            filters = {
               custom = { ".DS_Store" },
            },
            git = {
               ignore = false,
            },
         })
      end,
   },
   {
      "stevearc/conform.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
         local conform = require("conform")
         local util = require("conform.util")
         local prettier = require("conform.formatters.prettier")

         -- Adding Prettier arguments
         util.add_formatter_args(prettier, {
            "--print-width",
            "120", -- Set max line width
            "--trailing-comma",
            "none", -- No trailing commas
            "--single-quote",
            "true", -- Use single quotes
            "--tab-width",
            "2", -- Set indentation to 2 spaces
            "--semi",
            "true", -- Ensure semicolons are used
            "--bracketSpacing",
            "true", -- Add space between brackets in object literals
            "--arrow-parens",
            "avoid", -- Avoid parentheses when there's a single parameter in arrow function
         })

         conform.setup({
            formatters_by_ft = {
               lua = { "stylua" },
               svelte = { { "prettierd", "prettier", stop_after_first = true } },
               astro = { { "prettierd", "prettier", stop_after_first = true } },
               javascript = { { "prettierd", "prettier", stop_after_first = true } },
               typescript = { { "prettierd", "prettier", stop_after_first = true } },
               javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },
               typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
               json = { { "prettierd", "prettier", stop_after_first = true } },
               graphql = { { "prettierd", "prettier", stop_after_first = true } },
               java = { "google-java-format" },
               kotlin = { "ktlint" },
               ruby = { "standardrb" },
               markdown = { { "prettierd", "prettier", stop_after_first = true } },
               erb = { "htmlbeautifier" },
               html = { "htmlbeautifier" },
               bash = { "beautysh" },
               proto = { "buf" },
               rust = { "rustfmt" },
               yaml = { "yamlfix" },
               toml = { "taplo" },
               css = { { "prettierd", "prettier", stop_after_first = true } },
               scss = { { "prettierd", "prettier", stop_after_first = true } },
               sh = { "shellcheck" },
               go = { "gofmt" },
               xml = { "xmllint" },
            },
            format_on_save = {
               lsp_fallback = true,
               async = false,
               timeout_ms = 1000,
            },
         })

         vim.keymap.set({ "n", "v" }, "<leader>l", function()
            conform.format({
               lsp_fallback = true,
               async = false,
               timeout_ms = 1000,
            })
         end, { desc = "Format file or range (in visual mode)" })
      end,
   },
   {
      "christoomey/vim-tmux-navigator",
      cmd = {
         "TmuxNavigateLeft",
         "TmuxNavigateDown",
         "TmuxNavigateUp",
         "TmuxNavigateRight",
         "TmuxNavigatePrevious",
      },
      keys = {
         { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
         { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
         { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
         { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
         { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
   },
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 500
      end,
   },
   {
      "folke/noice.nvim",
      opts = function(_, opts)
         opts.routes = opts.routes or {}
         opts.presets = opts.presets or {}

         table.insert(opts.routes, {
            filter = {
               event = "notify",
               find = "No information available",
            },
            opts = { skip = true },
         })

         local focused = true
         vim.api.nvim_create_autocmd("FocusGained", {
            callback = function()
               focused = true
            end,
         })

         vim.api.nvim_create_autocmd("FocusLost", {
            callback = function()
               focused = false
            end,
         })

         table.insert(opts.routes, 1, {
            filter = {
               cond = function()
                  return not focused
               end,
            },
            view = "notify_send",
            opts = { stop = false },
         })

         opts.commands = {
            all = {
               view = "split",
               opts = { enter = true, format = "details" },
               filter = {},
            },
         }

         opts.presets.lsp_doc_border = true
      end,
   },

   {
      "rcarriga/nvim-notify",
      opts = {
         render = "wrapped-default",
         timeout = 5000,
         stages = "slide",
      },
   },
   {
      "rmagatti/auto-session",
      config = function()
         local auto_session = require("auto-session")

         auto_session.setup({
            auto_restore_enabled = false,
            auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
         })

         local keymap = vim.keymap

         keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
         keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
      end,
   },
   {
      "NeogitOrg/neogit",
      dependencies = {
         "nvim-lua/plenary.nvim", -- required
         "sindrets/diffview.nvim", -- optional - Diff integration

         -- Only one of these is needed, not both.
         "nvim-telescope/telescope.nvim", -- optional
         "ibhagwan/fzf-lua", -- optional
      },
      config = true,
   },
}
