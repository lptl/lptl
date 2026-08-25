-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- -- ~/.config/nvim/lua/config/options.lua

-- 1. Enable full mouse support (click, drag to select, scroll)
vim.opt.mouse = "a"
vim.opt.termguicolors = true
-- 2. Sync Neovim's clipboard with your operating system's clipboard
vim.opt.clipboard = "unnamedplus"

-- Clipboard over SSH/tmux: send yanks to the local machine's clipboard via
-- OSC 52 escape sequences (works through tmux and remote servers without
-- pbcopy/xclip). Paste falls back to the internal unnamed register, since
-- terminals usually block clipboard reads — this keeps `p` reliable and
-- prevents the "second paste is empty" issue on remotes.
-- Requires Neovim >= 0.10 and, inside tmux, `set -g set-clipboard on`.
if vim.env.SSH_CONNECTION ~= nil then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return function()
      return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
    end
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste(), ["*"] = paste() },
  }
end
vim.opt.foldenable = false
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

vim.diagnostic.config({
  virtual_text = false, -- Removes the red/yellow text trailing your code lines
  underline = true, -- Keeps subtle underline under the error
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
})

vim.opt.wildmode = "full" -- 1st Tab completes match 1, next Tabs cycle, typing continues
vim.opt.wildmenu = true
