-- Use `s` to quickly jump around a page. Type the following two letters and you
-- will leap there

return {
  "ggandor/leap.nvim",
  config = function()
    require('leap').add_default_mappings()
  end
}
