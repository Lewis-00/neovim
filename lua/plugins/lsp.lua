return {
   "VonHeikemen/lsp-zero.nvim",
   branch = "v2.x",
   dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { -- Optional
         "williamboman/mason.nvim",
         build = function()
            pcall(vim.cmd, "MasonUpdate")
         end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
      { "rafamadriz/friendly-snippets" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
   },
   config = function()
      local lsp = require("lsp-zero")

      lsp.on_attach(function(client, bufnr)
         local opts = { buffer = bufnr, remap = false }
         local keymap = vim.keymap -- for conciseness

         -- set keybinds
         opts.desc = "Show LSP references"
         keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

         opts.desc = "Go to declaration"
         keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

         opts.desc = "Show LSP definitions"
         keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

         opts.desc = "Show LSP implementations"
         keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

         opts.desc = "Show LSP type definitions"
         keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

         opts.desc = "See available code actions"
         keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

         opts.desc = "Smart rename"
         keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

         opts.desc = "Show buffer diagnostics"
         keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

         opts.desc = "Show line diagnostics"
         keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

         opts.desc = "Go to previous diagnostic"
         keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

         opts.desc = "Go to next diagnostic"
         keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

         opts.desc = "Show documentation for what is under cursor"
         keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

         opts.desc = "Restart LSP"
         keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end)

      require("mason").setup({
         ui = {
            icons = {
               package_installed = "✓",
               package_pending = "➜",
               package_uninstalled = "✗",
            },
         },
      })
      require("mason-lspconfig").setup({
         ensure_installed = {
            "eslint",
            "lua_ls",
            "jsonls",
            "html",
            "tailwindcss",
            "pylsp",
            "dockerls",
            "astro",
         },
         handlers = {
            lsp.default_setup,
            lua_ls = function()
               local lua_opts = lsp.nvim_lua_ls()
               require("lspconfig").lua_ls.setup(lua_opts)
            end,
         },
      })

      require("mason-tool-installer").setup({
         ensure_installed = {
            "prettier", -- prettier formatter
            "stylua", -- lua formatter
            "isort", -- python formatter
            "black", -- python formatter
            "pylint",
            -- "eslint_d", --[[ custom install @13.1.2 with MasonInstall ]]
         },
      })

      local cmp_action = require("lsp-zero").cmp_action()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      require("luasnip.loaders.from_vscode").lazy_load()

      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
            { name = "buffer" },
         },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({
            { name = "path" },
         }, {
            {
               name = "cmdline",
               option = {
                  ignore_cmds = { "Man", "!" },
               },
            },
         }),
      })

      cmp.setup({
         snippet = {
            expand = function(args)
               require("luasnip").lsp_expand(args.body)
            end,
         },
         sources = {
            { name = "nvim_lsp", priority = 1000 },
            { name = "copilot", priority = 750 },
            { name = "luasnip", keyword_length = 2 },
            { name = "buffer", keyword_length = 3 },
            { name = "path" },
         },
         mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-f>"] = cmp_action.luasnip_jump_forward(),
            ["<C-b>"] = cmp_action.luasnip_jump_backward(),
            ["<Tab>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item()
               else
                  fallback()
               end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item()
               else
                  fallback()
               end
            end, { "i", "s" }),
         }),
      })
   end,
}
