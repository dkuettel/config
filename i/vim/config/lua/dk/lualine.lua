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

    require("lualine").setup({
        options = {
            theme = "auto", -- TODO how to keep in sync with themes?
            icons_enabled = true,
            component_separators = "",
            section_separators = { left = "", right = "" },
            globalstatus = false, -- true not working yet?
        },
        sections = {
            lualine_a = { { show_window, separator = { left = "" } }, show_file },
            lualine_b = { { "diagnostics", sources = { "nvim_lsp" }, colored = false } },
            lualine_c = { { "diff", icon = "", colored = false } },
            lualine_x = {},
            lualine_y = { { "filetype", icons_enabled = false } },
            lualine_z = { "progress", { "location", icon = "", separator = { right = "" } } },
        },
        inactive_sections = {
            lualine_a = { { show_window, separator = { left = "" } }, show_file },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "progress", { "location", icon = "", separator = { right = "" } } },
        },
        tabline = {
            lualine_a = { "tabs" },
        },
        extensions = {},
    })
    -- TODO in insert mode would be nice to not have the location info update nervously, replace with [insert] indicator?
end

return M
