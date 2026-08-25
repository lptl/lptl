-- ~/.config/nvim/lua/plugins/blink.lua
return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local width_ratio = 0.35
      local dynamic_width = math.max(30, math.floor(vim.o.columns * width_ratio))

      -- Clean up LazyVim's custom compat prop to prevent schema errors
      if opts.sources then
        opts.sources.compat = nil
      end

      return vim.tbl_deep_extend("force", opts or {}, {
        ----------------------------------------------------------------
        -- ⚡ Tab Cycling & Keymaps
        ----------------------------------------------------------------
        keymap = {
          preset = "none",

          -- 1st Tab selects & inserts match 1; repeated Tabs cycle next matches
          ["<Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.snippet_forward()
              else
                return cmp.select_next()
              end
            end,
            "snippet_forward",
            "fallback",
          },

          -- Shift-Tab cycles backward
          ["<S-Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.snippet_backward()
              else
                return cmp.select_prev()
              end
            end,
            "snippet_backward",
            "fallback",
          },

          -- Enter ONLY makes a newline (never commits popups)
          ["<CR>"] = { "fallback" },

          ["<C-e>"] = { "hide", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        },

        ----------------------------------------------------------------
        -- ⚡ Auto-Insert into buffer as you cycle
        ----------------------------------------------------------------
        completion = {
          list = {
            selection = {
              preselect = false, -- Don't select anything until Tab is pressed
              auto_insert = true, -- Automatically write the candidate into the buffer
            },
          },

          menu = {
            min_width = dynamic_width,
            border = "none",
            scrollbar = false,
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
              },
            },
          },

          documentation = {
            window = {
              border = "none",
            },
          },
        },
      })
    end,

    -- Transparent UI Highlights
    init = function()
      local function set_transparent()
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpLabel", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = "none" })
        vim.api.nvim_set_hl(0, "BlinkCmpScrollBarGutter", { bg = "none" })
      end

      set_transparent()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparent })
    end,
  },
}
