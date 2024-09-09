return {
  {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    opts = {},
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            icon_preset = "diamond"
          }, -- Adds pretty icons to your documents
          ["core.journal"] = {
            config = {
              journal_folder = "~/neorg/journal",
            },
          },
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/neorg/notes",
                learning = "~/neorg/learning",
              },
              default_workspace = "notes",
            },
          },
        }
      }
    end
  }
}
