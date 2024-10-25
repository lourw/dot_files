-- Use `jj` to enter escape mode instead of the `esc` key

return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup()
  end,
}
