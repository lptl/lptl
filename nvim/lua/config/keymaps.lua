vim.keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Go to Left Window" })

vim.keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Go to Lower Window" })

vim.keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Go to Upper Window" })

vim.keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Go to Right Window" })
-- Ergonomic Line Start & End (Normal + Visual mode)
vim.keymap.set({ "n", "v" }, "ga", "^", { desc = "Go to line start" })

vim.keymap.set({ "n", "v" }, "ge", "$", { desc = "Go to line end" })
-- Delete selected text without clobbering the unnamed/clipboard register

vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader><leader>", function()
  require("snacks").picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>cy", function()
  vim.fn.setreg("+", vim.fn.getcwd())
  vim.notify("Copied cwd: " .. vim.fn.getcwd())
end, { desc = "Copy cwd to clipboard" })

-- Toggle auto-save (auto-save.nvim)
vim.keymap.set("n", "<leader>uS", "<cmd>ASToggle<cr>", { desc = "Toggle auto-save" })

vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path" })
