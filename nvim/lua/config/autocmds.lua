-- ~/.config/nvim/lua/config/autocmds.lua

local function apply_lackluster_overrides()
  -- Transparent backgrounds across core UI + plugin floats
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",
    "WhichKeyFloat",
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "SnacksPicker",
    "SnacksPickerBorder",
  }
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
  end

  -- Noice cmdline popup: foreground/background overrides
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { fg = "#dddddd" }) -- gray9 / gray3
  vim.api.nvim_set_hl(0, "NoiceCmdline", { fg = "#232425" })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#dddddd" })

  -- Per-mode cursor colors
  vim.api.nvim_set_hl(0, "CursorNormal", { bg = "#dddddd", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorInsert", { bg = "#7ac5cd", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorVisual", { bg = "#fafad2", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorReplace", { bg = "#fafad2", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorCommand", { bg = "#8fbc8f", fg = "#000000" })
  vim.api.nvim_set_hl(0, "CursorOperator", { bg = "#7ac5cd", fg = "#000000" })
end

-- Re-apply on every colorscheme load (covers reloads, :colorscheme switches, etc.)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply_lackluster_overrides,
})

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
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api
