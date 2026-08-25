vim.keymap.set("n", "<S-Left>", "<C-w>h", { desc = "Go to Left Window" })

vim.keymap.set("n", "<S-Down>", "<C-w>j", { desc = "Go to Lower Window" })

vim.keymap.set("n", "<S-Up>", "<C-w>k", { desc = "Go to Upper Window" })

vim.keymap.set("n", "<S-Right>", "<C-w>l", { desc = "Go to Right Window" })
-- Ergonomic Line Start & End (Normal + Visual mode)
-- (ga/ge would clobber the built-in :ascii and prev-word-end motions)
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Go to line start" })

vim.keymap.set({ "n", "v" }, "L", "$", { desc = "Go to line end" })
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

vim.keymap.set("n", "<leader>fY", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path (relative)" })

-- Replace in file / selection (`<leader>r`)
-- Live-highlights the target while typing and clears ALL highlights on every
-- exit path: aborting either prompt (Esc / <C-c>), quitting the confirm
-- dialog (q / Esc / <C-c>), or finishing normally.

-- Tracks the one transient matchadd() id used for live highlighting.
local replace_state = { match_id = nil }

local function replace_clear()
  if replace_state.match_id then
    pcall(vim.fn.matchdelete, replace_state.match_id)
    replace_state.match_id = nil
  end
  vim.v.hlsearch = 0
  pcall(vim.cmd, "nohlsearch")
  vim.cmd.redraw()
end

-- input() wrapper. Returns the entered text, or nil when aborted
-- (Esc / <C-c>). With highlight=true, matches of the text typed so far
-- are live-highlighted in the buffer until the prompt closes.
local function replace_input(prompt, highlight)
  local group = vim.api.nvim_create_augroup("ReplacePrompt_" .. vim.uv.hrtime(), { clear = true })

  if highlight then
    vim.api.nvim_create_autocmd("CmdlineChanged", {
      group = group,
      pattern = "@",
      callback = function()
        if replace_state.match_id then
          pcall(vim.fn.matchdelete, replace_state.match_id)
          replace_state.match_id = nil
        end
        local text = vim.fn.getcmdline()
        if text ~= "" then
          local ok, id = pcall(vim.fn.matchadd, "IncSearch", "\\V" .. vim.fn.escape(text, [[\]]), 10)
          replace_state.match_id = ok and id or nil
        end
        vim.cmd.redraw()
      end,
    })
  end

  local ok, result = pcall(vim.fn.input, { prompt = prompt, cancelreturn = "\0" })

  -- Prompt closed: live highlight and autocmds are no longer needed
  pcall(vim.api.nvim_del_augroup_by_id, group)
  if replace_state.match_id then
    pcall(vim.fn.matchdelete, replace_state.match_id)
    replace_state.match_id = nil
  end

  if not ok or result == "\0" then
    return nil
  end
  return result
end

local function replace_in_file(in_selection)
  if in_selection then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  end

  -- xpcall guarantees highlight cleanup no matter how the flow is aborted
  xpcall(function()
    -- 1. Target (empty = abort)
    local old = replace_input("Replace: ", true)
    if not old or old == "" then
      return
    end

    -- 2. Keep matches highlighted (via 'hlsearch') for the next steps
    vim.fn.setreg("/", "\\V" .. vim.fn.escape(old, [[\]]))
    vim.o.hlsearch = true
    vim.cmd.redraw()

    -- 3. Replacement (empty = delete matches; nil = aborted)
    local new = replace_input("With: ", false)
    if not new then
      return
    end

    -- 4. Interactive substitute; pcall catches q / Esc / <C-c> at the confirm
    local range = in_selection and "'<,'>" or "%"
    local pat = "\\V" .. vim.fn.escape(old, [[/\]])
    local rep = vim.fn.escape(new, [[/\&~]])
    pcall(vim.cmd, string.format("%ss/%s/%s/gc", range, pat, rep))
  end, function(err)
    vim.notify("Replace aborted: " .. tostring(err), vim.log.levels.DEBUG)
  end)

  replace_clear()
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
