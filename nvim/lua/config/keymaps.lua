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

-- Find files in the current working directory (overrides LazyVim's
-- default "Find Config File" on <leader>fc)
vim.keymap.set("n", "<leader>fc", function()
  LazyVim.pick.open("files", { root = false })
end, { desc = "Find Files (cwd)" })

-- Grep / Search text in the current working directory (cwd)
vim.keymap.set("n", "<leader>sc", function()
  LazyVim.pick.open("live_grep", { root = false })
end, { desc = "Grep (cwd)" })

-- Toggle auto-save (auto-save.nvim)
vim.keymap.set("n", "<leader>uS", "<cmd>ASToggle<cr>", { desc = "Toggle auto-save" })

vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path" })

-- Helper to wipe out all match and search highlights
local function clear_highlights(match_id)
  if match_id then
    pcall(vim.fn.matchdelete, match_id)
  end
  vim.v.hlsearch = 0
  pcall(vim.cmd, "nohlsearch")
  vim.cmd.redraw()
end

local function input_with_live_highlight(prompt)
  local match_id = nil
  local group = vim.api.nvim_create_augroup("ReplaceLiveHighlight_" .. vim.loop.hrtime(), { clear = true })

  -- Live highlight while typing
  vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = group,
    pattern = "@",
    callback = function()
      if match_id then
        pcall(vim.fn.matchdelete, match_id)
        match_id = nil
      end
      local text = vim.fn.getcmdline()
      if text ~= "" then
        local pattern = "\\V" .. vim.fn.escape(text, [[\]])
        local ok, id = pcall(vim.fn.matchadd, "IncSearch", pattern, 10)
        if ok then
          match_id = id
        end
      end
      vim.cmd.redraw()
    end,
  })

  -- Cleanup match on leaving prompt
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    pattern = "@",
    once = true,
    callback = function()
      if match_id then
        pcall(vim.fn.matchdelete, match_id)
        match_id = nil
      end
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end,
  })

  local ok, result = pcall(vim.fn.input, { prompt = prompt, cancelreturn = "\0" })

  -- Cleanup match
  if match_id then
    pcall(vim.fn.matchdelete, match_id)
    match_id = nil
  end
  pcall(vim.api.nvim_del_augroup_by_id, group)

  -- If aborted (Esc / C-c) or empty, clear everything and exit
  if not ok or result == "\0" or result == "" then
    clear_highlights(nil)
    return nil
  end

  return result
end

local function replace_in_file(in_selection)
  if in_selection then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  end

  -- 1. Target input
  local old = input_with_live_highlight("Replace: ")
  if not old then
    clear_highlights()
    return
  end

  -- 2. Highlight matches while asking for replacement
  vim.fn.setreg("/", "\\V" .. vim.fn.escape(old, [[\]]))
  vim.o.hlsearch = true
  vim.cmd.redraw()

  -- 3. Replacement input
  local ok, new = pcall(vim.fn.input, { prompt = "With: ", cancelreturn = "\0" })
  if not ok or new == "\0" then
    clear_highlights()
    return
  end

  local range = in_selection and "'<,'>" or "%"
  local pat = "\\V" .. vim.fn.escape(old, [[/\]])
  local rep = vim.fn.escape(new, [[/\&~]])

  -- 4. Execute substitution wrapped in pcall so quitting with 'q', Esc, or Ctrl+C is caught
  pcall(vim.cmd, string.format("%ss/%s/%s/gc", range, pat, rep))

  -- 5. Always wipe out the highlights when done or when 'q'/Esc is pressed
  clear_highlights()
end

vim.keymap.set("n", "<leader>r", function()
  replace_in_file(false)
end, { desc = "Replace string in file" })

vim.keymap.set("x", "<leader>r", function()
  replace_in_file(true)
end, { desc = "Replace string in selection" })

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
