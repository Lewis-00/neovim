return {
   {
      "github/copilot.vim",
   },

   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true,
   },

   {
      "stevearc/oil.nvim",
      opts = {
         default_file_explorer = true,
         columns = {
            "icon",
         },
         buf_options = {
            buflisted = false,
            bufhidden = "hide",
         },
         win_options = {
            wrap = false,
            signcolumn = "no",
            cursorcolumn = false,
            foldcolumn = "0",
            number = false,
            relativenumber = false,
         },
         delete_hidden_buffers_after = 2000,
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
         { "-", "<cmd>Oil<cr>", desc = "Open Oil in main buffer" },
         { "<leader>ef", "<cmd>Oil --float<cr>", desc = "Open Oil in floating window" },
         { "q", "<cmd>close<cr>", desc = "Close Oil window", mode = "n" },
      },
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

         table.insert(opts.routes, {
            filter = {
               event = "msg_show",
               find = "written",
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

   -- {
   --    "rcarriga/nvim-notify",
   --    opts = {
   --       render = "wrapped-default",
   --       timeout = 5000,
   --       stages = "slide",
   --    },
   -- },

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
      "kdheepak/lazygit.nvim",
      cmd = {
         "LazyGit",
         "LazyGitConfig",
         "LazyGitCurrentFile",
         "LazyGitFilter",
         "LazyGitFilterCurrentFile",
      },
      -- optional for floating window border decoration
      dependencies = {
         "nvim-lua/plenary.nvim",
      },
      -- setting the keybinding for LazyGit with 'keys' is recommended in
      -- order to load the plugin when the command is run for the first time
      keys = {
         { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
      },
   },
}
