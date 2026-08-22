vim.keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Go to Left Window" })

vim.keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Go to Lower Window" })

vim.keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Go to Upper Window" })

vim.keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Go to Right Window" })
-- Ergonomic Line Start & End (Normal + Visual mode)
vim.keymap.set({ "n", "v" }, "ga", "^", { desc = "Go to line start" })

vim.keymap.set({ "n", "v" }, "ge", "$", { desc = "Go to line end" })
-- Delete selected text without clobbering the unnamed/clipboard register
-- Delete without yanking into clipboard/register
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete without copying" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line without copying" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete character without copying" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without copying" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end of line without copying" })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting clipboard" })
-- (Optional) Add a dedicated 'Cut' command when you DO want to cut to clipboard
vim.keymap.set({ "n", "v" }, "<leader>x", '"+d', { desc = "Cut to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>X", '"+D', { desc = "Cut line to clipboard" })
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

-- Create a new file relative to the current buffer's directory
vim.keymap.set("n", "<leader>fn", function()
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.input("New file: " .. dir .. "/")
  if name ~= "" then
    vim.cmd.edit(dir .. "/" .. name)
  end
end, { desc = "New file (buffer dir)" })

-- Create a new directory relative to the current buffer's directory
vim.keymap.set("n", "<leader>dn", function()
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.input("New directory: " .. dir .. "/")
  if name ~= "" then
    local path = dir .. "/" .. name
    vim.fn.mkdir(path, "p")
    vim.notify("Created: " .. path)
  end
end, { desc = "New directory (buffer dir)" })
