return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
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
          hijack_netrw = true,
          sorting_strategy = "ascending",
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
