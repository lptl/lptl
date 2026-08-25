vim.g.mapleader = " "
dofile("/Users/k/lptl/nvim/lua/config/keymaps.lua")

local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(buf)

-- stub vim.fn.input with a scripted queue; "ERR" simulates <C-c>
local queue = {}
vim.fn.input = function()
  local v = table.remove(queue, 1)
  if v == "ERR" then
    error("Keyboard interrupt")
  end
  return v
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "x", false)
end

local results = {}
local function run(case, script, keys)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "foo one", "foo two", "three" })
  queue = script
  feed(keys or "<leader>r")
  local m = #vim.fn.getmatches()
  local hl = vim.v.hlsearch
  local lines = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "|")
  results[#results + 1] = string.format("%s: matches=%d hlsearch=%d lines=[%s]", case, m, hl, lines)
end

run("abort-prompt-1  ", { "\0" })
run("abort-prompt-2  ", { "foo", "\0" })
run("ctrlc-prompt-1  ", { "ERR" })
run("ctrlc-prompt-2  ", { "foo", "ERR" })
run("no-match        ", { "zzz", "bar" })
run("quit-confirm    ", { "foo", "bar" }, "<leader>rq")
run("accept-all      ", { "foo", "bar" }, "<leader>ra")

vim.fn.writefile(results, "/Users/k/lptl/nvim/.test_replace_results.txt")
vim.cmd("qa!")
