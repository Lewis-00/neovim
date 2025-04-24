return {
   "sbdchd/neoformat",

   config = function()
      vim.keymap.set("n", "<leader>lf", "<cmd>Neoformat<CR>")

      vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

      vim.api.nvim_create_autocmd("BufWritePre", {
         group = "FormatOnSave",
         pattern = "*",
         callback = function()
            vim.cmd("undojoin")
            vim.cmd("Neoformat")
         end,
      })
   end,
}
