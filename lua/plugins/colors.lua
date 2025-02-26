return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        -- config = function()
        --     require('rose-pine').setup({
        --         disable_background = true
        --     })
        --
        --     vim.cmd("colorscheme rose-pine")
        -- end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
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
