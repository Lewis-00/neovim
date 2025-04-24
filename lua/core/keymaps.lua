----------------------------------------------------------------------------
-- KEYMAPS

vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- exit insert mode map
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

--NVIM-TREE
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" }) -- focus file explorer
keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
keymap.set("n", "<leader>et", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

-- -- NEOGIT
-- keymap.set("n", "<leader>go", "<cmd>Neogit<CR>", { desc = "Neogit Open" })
-- keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Neogit commit" })
-- keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", { desc = "Neogit push" })
-- keymap.set("n", "<leader>gl", "<cmd>Neogit pull<CR>", { desc = "Neogit pull" })
