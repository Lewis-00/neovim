return {
   "windwp/nvim-ts-autotag",
   event = "VeryLazy",
   config = function()
      require("nvim-ts-autotag").setup({
         filetypes = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "astro",
            "svelte",
            "vue",
            "tsx",
            "jsx",
         },
         autotag = {
            enable = true,
            enable_rename = true,
            enable_close = true,
            enable_close_on_slash = true,
            filetypes = {
               "html",
               "javascript",
               "typescript",
               "javascriptreact",
               "typescriptreact",
               "astro",
               "svelte",
               "vue",
               "tsx",
               "jsx",
            },
         },
      })
   end,
}
