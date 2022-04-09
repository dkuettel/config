local M = {}

function M.setup()
    -- https://github.com/kyazdani42/nvim-web-devicons
    -- also requires patched fonts, like nerdfonts
    vim.cmd("packadd nvim-web-devicons")

    -- https://github.com/nvim-lualine/lualine.nvim
    vim.cmd("packadd lualine.nvim")

    local function show_window()
        return "藍" .. vim.api.nvim_win_get_number(0)
    end

    local U = require("lualine.utils.utils")

    -- zen low-flicker indication of file status (unsaved, saved, read-only)
    local function show_file()
        -- based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filename.lua
        local f = vim.fn.expand("%:t")
        f = U.stl_escape(f)
        local icon = ""
        if vim.bo.modified then
            icon = ""
        end
        if not vim.bo.modifiable then
            icon = ""
        end
        return icon .. " " .. f
    end

    -- zen low-flicker indication of lsp activity (no lsp, busy lsp, idle lsp)
    local lsp_activity_icons = { missing = "", busy = "", idle = "" }
    local function lsp_activity()
        if #vim.lsp.get_active_clients() == 0 then
            return lsp_activity_icons.missing
        end
        if #vim.lsp.util.get_progress_messages() == 0 then
            return lsp_activity_icons.idle
        end
        return lsp_activity_icons.busy
    end

    require("lualine").setup({
        options = {
            theme = "auto", -- TODO how to keep in sync with themes?
            icons_enabled = true,
            component_separators = "",
            section_separators = { left = "", right = "" },
            globalstatus = false, -- true not working yet?
        },
        sections = {
            lualine_a = { show_window, show_file },
            lualine_b = { { "diff", icon = "", colored = false } },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { { "diagnostics", sources = { "nvim_lsp" }, colored = false } },
            lualine_z = { lsp_activity, { "filetype", icons_enabled = false } },
        },
        inactive_sections = {
            lualine_a = { show_window, show_file },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {
            lualine_a = {
                {
                    "tabs",
                    max_length = vim.o.columns,
                    component_separators = { left = " " },
                    section_separators = { left = "" },
                },
            },
        },
        extensions = {},
    })
    -- TODO in insert mode would be nice to not have the location info update nervously, replace with [insert] indicator?
end

return M
