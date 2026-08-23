-- ~/.config/nvim/lua/config/autocmds.lua

-- Per-mode cursor colors. These are custom highlight groups referenced by the
-- 'guicursor' mapping below; they must be re-applied after every colorscheme
-- load because `:hi clear` wipes them.
local function apply_cursor_colors()
  vim.api.nvim_set_hl(0, "CursorNormal", { bg = "#dddddd", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorInsert", { bg = "#7ac5cd", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorVisual", { bg = "#fafad2", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorReplace", { bg = "#fafad2", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorCommand", { bg = "#8fbc8f", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorOperator", { bg = "#7ac5cd", fg = "#000000" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_cursor_colors,
})
apply_cursor_colors()

-- guicursor mode-to-highlight-group mapping (shape/blink can be tuned here too,
-- see :help guicursor)
vim.opt.guicursor = table.concat({
  "n:CursorNormal",
  "i-ci-ve:CursorInsert",
  "v:CursorVisual",
  "r-cr:CursorReplace",
  "c:CursorCommand",
  "o:CursorOperator",
}, ",")

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.bo.buflisted = true
  end,
})
