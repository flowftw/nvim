return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                extend_background_behind_borders = false,
                styles = {
                    italic = false,
                    transparency = false,
                },
            })

            vim.cmd("colorscheme rose-pine")
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                no_italic = true
            })
            vim.cmd("colorscheme catppuccin")
        end
    },
    -- {
    --     "shaunsingh/nord.nvim",
    --     config = function ()
    --         vim.cmd("colorscheme nord")
    --     end
    -- },
}
