return {
  {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    opts = {},
    config = function()
      local neorg_workspace = "~/neorg"

      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
              icons = {
                code_block = {
                  conceal = true
                }
              }
            }
          }, -- Adds pretty icons to your documents
          ["core.ui.calendar"] = {},
          ["core.journal"] = {
            config = {
              journal_folder = neorg_workspace .. "/journal",
              workspace = neorg_workspace
            },
          },
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = neorg_workspace .. "/notes",
                learning = neorg_workspace .. "/learning",
              },
              default_workspace = "notes",
            },
          },
        }
      }
    end
  }
}
