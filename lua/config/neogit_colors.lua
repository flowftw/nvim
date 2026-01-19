-- neogit_colors.lua
-- Configure Neogit highlight groups to better match the Rose Pine colorscheme.
-- This module should not live under `lua/plugins` because that folder is used
-- for lazy.nvim plugin specs. Place it under `lua/config` and require it from
-- the plugin config.

local M = {}

local function link(group, target)
    pcall(vim.api.nvim_set_hl, 0, group, { link = target })
end

local function apply()
    -- Map Neogit highlight groups to existing scheme groups
    local mapping = {
        NeogitPopupTitle = "Title",
        NeogitPopupStatus = "Comment",
        NeogitPopupContent = "Normal",
        NeogitPopupPrompt = "PmenuSel",
        NeogitKeybind = "Identifier",
        NeogitComment = "Comment",
        NeogitItem = "Normal",

        NeogitBranch = "Identifier",
        NeogitRemote = "Constant",

        NeogitHunkHeader = "Title",
        NeogitHunkHeaderHighlight = "Title",
        NeogitHunkSummary = "Comment",
        NeogitHunkDetail = "Normal",

        -- Keep context lines using the Normal background so neutral lines don't get a colored bg
        NeogitDiffContext = "Normal",
        -- Changed lines keep DiffAdd/DiffDelete for clear highlight
        NeogitDiffAdd = "DiffAdd",
        NeogitDiffDelete = "DiffDelete",

        NeogitCommitHeading = "Statement",
        NeogitCommitViewHeader = "Title",

        NeogitNotificationInfo = "MoreMsg",
        NeogitNotificationWarning = "WarningMsg",
        NeogitNotificationError = "ErrorMsg",

        NeogitStaged = "DiffAdd",
        NeogitUnstaged = "DiffChange",
    }

    for group, target in pairs(mapping) do
        link(group, target)
    end
end

function M.setup()
    -- Apply immediately
    apply()

    -- Re-apply whenever the colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "rose-pine",
        callback = function()
            apply()
        end,
        desc = "Reapply Neogit color links after colorscheme changes",
    })
end

return M
