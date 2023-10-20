return {
    { 
        'nvim-treesitter/nvim-treesitter', 
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    "python",
                    "rust",
                    "ruby",
                    "json",
                    "css"
                },
                auto_install = true,
                autotag = {
                    enable = true,
                },
            }
        end
    }
}
