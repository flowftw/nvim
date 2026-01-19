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
            -- configure neogit colors to better match rose-pine
            local ok, neogit_colors = pcall(require, "config.neogit_colors")
            if ok and neogit_colors and type(neogit_colors.setup) == "function" then
                neogit_colors.setup()
            end
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                no_italic = true
            })
        end
    },
    -- {
    --     "shaunsingh/nord.nvim",
    --     config = function ()
    --         vim.cmd("colorscheme nord")
    --     end
    -- },
}
