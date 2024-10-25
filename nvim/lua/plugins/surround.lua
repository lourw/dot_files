-- Quickly handle wrapping things in quotes or brackets
--  - `cs` to change
--  - `ys` to add
--  - `ds` to delete

return {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup {}
    end
}
