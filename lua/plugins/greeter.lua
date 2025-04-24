return {
   "goolord/alpha-nvim",
   event = "VimEnter",
   dependencies = {
      "nvim-tree/nvim-web-devicons",
   },
   config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Personalizzazione dei pulsanti
      dashboard.section.buttons.val = {
         dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
         dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
         dashboard.button("g", "  Find Text", ":Telescope live_grep<CR>"),
         dashboard.button("s", "  Restore Session", ":SessionRestore<CR>"),
         dashboard.button("l", "  Lazy", ":Lazy<CR>"),
         dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Personalizzazione del footer
      dashboard.section.footer.val = function()
         local stats = require("lazy").stats()
         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
         return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
      end

      -- Impostazione della configurazione
      alpha.setup(dashboard.config)
   end,
}
