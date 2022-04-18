local M = {}

function M.setup()
    -- dependencies
    do
        -- https://github.com/kyazdani42/nvim-web-devicons
        -- also requires patched fonts, like nerdfonts
        vim.cmd("packadd nvim-web-devicons")
    end

    -- https://github.com/nvim-lualine/lualine.nvim
    vim.cmd("packadd lualine.nvim")

    require("lualine").setup({
        options = {
            -- see https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
            -- "auto" uses vim.g.colors_name, usually what's set with :colorscheme
            theme = "auto",
            icons_enabled = true,
            component_separators = "",
            section_separators = { left = "", right = "" },
            globalstatus = false, -- could be cool, but looks broken when I try it
        },
        sections = {
            lualine_a = { M.show_window, M.show_file },
            lualine_b = { { "diff", icon = "", colored = false } },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { { "diagnostics", sources = { "nvim_lsp" }, colored = false } },
            lualine_z = { M.show_lsp_activity, { "filetype", icons_enabled = false }, M.show_progress },
        },
        inactive_sections = {
            lualine_a = { M.show_window, M.show_file },
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
end

function M.show_window()
    return "藍" .. vim.api.nvim_win_get_number(0)
end

-- zen low-flicker indication of file status (unsaved, saved, read-only)
M.file_icons = { missing = "", modified = "", unmodified = "", read_only = "" }
function M.show_file()
    local icon = nil
    if vim.bo.modifiable then
        if vim.fn.filereadable(vim.fn.expand("%")) == 1 then
            if vim.bo.modified then
                icon = M.file_icons.modified
            else
                icon = M.file_icons.unmodified
            end
        else
            icon = M.file_icons.missing
        end
    else
        icon = M.file_icons.read_only
    end
    -- based on https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filename.lua
    local name = require("lualine.utils.utils").stl_escape(vim.fn.expand("%:t"))
    return icon .. " " .. name
end

-- zen low-flicker indication of lsp activity (no lsp, busy lsp, idle lsp)
M.lsp_activity_icons = { missing = "", busy = "", idle = "" }
function M.show_lsp_activity()
    if #vim.lsp.buf_get_clients() == 0 then
        return M.lsp_activity_icons.missing
    end
    -- TODO same here is it progress for the buffer or anything else? which LSP is it?
    if #vim.lsp.util.get_progress_messages() == 0 then
        return M.lsp_activity_icons.idle
    end
    return M.lsp_activity_icons.busy
end

-- zen low-flicker indicator of progress in file (location as percentage)
M.progress_icons = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }
function M.show_progress()
    local i = 1 + math.floor(vim.fn.line(".") / vim.fn.line("$") * (#M.progress_icons - 1))
    return M.progress_icons[i]
end

return M
