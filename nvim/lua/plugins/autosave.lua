return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true, -- start auto-save automatically
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" }, -- save immediately when switching buffers/windows
      defer_save = { "InsertLeave", "TextChanged" }, -- save after finishing typing (with a small delay)
    },
    debounce_delay = 1000, -- delay in ms before saving on TextChanged
    condition = function(buf)
      local fn = vim.fn

      -- Do not save unnamed buffers, special buffers (like Telescope, Neo-tree, terminal),
      -- read-only or non-modifiable ones
      if
        fn.bufname(buf) == ""
        or fn.getbufvar(buf, "&buftype") ~= ""
        or fn.getbufvar(buf, "&readonly") == 1
        or fn.getbufvar(buf, "&modifiable") == 0
      then
        return false
      end
      return true
    end,
  },
}
