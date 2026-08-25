return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").load_extension("file_browser")
      local fb = require("telescope").extensions.file_browser

      local function doom_find_file()
        fb.file_browser({
          prompt_title = "Find file",
          path = "%:p:h",
          cwd = "%:p:h",
          prompt_path = true,
          grouped = true, -- Folders first, files below
          hidden = true, -- Show dotfiles (.doom.d, .config)
          display_stat = { mode = true, size = true, date = true },
          theme = "ivy",
          sorting_strategy = "ascending",
          attach_mappings = function(prompt_bufnr, map)
            -- <C-y>: copy the currently browsed/typed directory path to the clipboard
            map({ "i", "n" }, "<C-y>", function()
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local path = picker.finder.path
              vim.fn.setreg("+", path)
              vim.notify("Copied path: " .. path)
            end, { desc = "Copy current path to clipboard" })
            return true -- keep the default file-browser mappings
          end,
          layout_config = {
            height = 0.6,
            prompt_position = "top", -- 👈 Moves the input bar to the top
          },
        })
      end

      vim.keymap.set("n", "<leader>fs", doom_find_file, { desc = "Find file (Doom Emacs style)" })
    end,
  },
}
