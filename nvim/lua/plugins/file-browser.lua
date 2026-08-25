return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      telescope.setup({
        extensions = {
          file_browser = {
            display_stat = {
              date = true,
              size = true,
              mode = false,
            },
            dir_icon = "/ ",
            dir_icon_hl = "Directory",
            disable_devicons = true,
            git_status = false,
            prompt_prefix = "",
            selection_caret = "",
            entry_prefix = "",
          },
        },
      })

      telescope.load_extension("file_browser")
      local fb = telescope.extensions.file_browser
      local fb_actions = fb.actions

      local function doom_find_file()
        fb.file_browser({
          prompt_title = "",
          path = "%:p:h",
          cwd = "%:p:h",
          prompt_path = true,
          grouped = true,
          hidden = true,
          theme = "ivy",
          border = false,
          sorting_strategy = "ascending",

          display_stat = {
            date = true,
            size = true,
            mode = false,
          },

          dir_icon = "/ ",
          dir_icon_hl = "Directory",
          disable_devicons = true,
          git_status = false,
          prompt_prefix = "▶ ",
          selection_caret = "▶ ",
          entry_prefix = "  ",

          attach_mappings = function(prompt_bufnr, map)
            -- Bind Shift-Tab to go to parent folder:
            map("i", "<S-Tab>", function()
              fb_actions.goto_parent_dir(prompt_bufnr)
            end)
            map("n", "<S-Tab>", function()
              fb_actions.goto_parent_dir(prompt_bufnr)
            end)

            -- Bind Ctrl-y to copy path to clipboard:
            map("i", "<C-y>", function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local path = picker.finder.path
              vim.fn.setreg("+", path)
              vim.notify("Copied path: " .. path)
            end)

            return true
          end,

          layout_config = {
            height = 0.6,
            prompt_position = "top",
            preview_width = 0.6,
          },
        })
      end

      vim.keymap.set("n", "<leader>fs", doom_find_file, { desc = "Find file (Doom Emacs style)" })
    end,
  },
}
