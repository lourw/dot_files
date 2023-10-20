return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  event = "VeryLazy",
  build = function() vim.fn["mkdp#util#install"]() end,
}
