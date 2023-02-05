local M = {}

function M.setup()
    -- https://github.com/kyazdani42/nvim-web-devicons
    -- also requires patched fonts, like nerdfonts
    vim.cmd("packadd nvim-web-devicons")

    -- https://github.com/nvim-lualine/lualine.nvim
    vim.cmd("packadd lualine.nvim")

    vim.cmd([[
        highlight AlwaysOnWindowNumber guibg=#8ab9e0
        " highlight AlwaysOnWindowNumber guibg=#458588
    ]])

    vim.cmd("packadd lsp-indicator.nvim")
    local lsp_indicator = require("lsp-indicator")
    lsp_indicator.setup {
        on_update = function()
            vim.cmd("redrawstatus") -- only current window
            -- vim.cmd("redrawstatus!") -- all windows
            vim.cmd("redrawtabline")
        end,
    }

    require("lualine").setup {
        options = {
            -- see https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
            -- "auto" uses vim.g.colors_name, usually what's set with :colorscheme
            theme = "auto",
            icons_enabled = true,
            component_separators = "",
            section_separators = { left = "", right = "" },
            globalstatus = false, -- doesnt really save space
        },
        sections = {
            lualine_a = { M.show_window, M.show_file },
            lualine_b = { { "diff", icon = "", colored = false } },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { { "diagnostics", sources = { "nvim_lsp" }, colored = false } },
            lualine_z = {
                function()
                    return lsp_indicator.get_state(0)
                end,
                { "filetype", icons_enabled = false },
                M.show_progress,
            },
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
                M.show_context,
            },
            lualine_b = {
                {
                    "tabs",
                    max_length = vim.o.columns,
                    component_separators = { left = " " },
                    section_separators = { left = "" },
                },
            },
            lualine_c = {
                M.tablist,
            },
            lualine_z = {
                -- TODO because documentation doesnt say what those params are that it passes ...
                function()
                    return lsp_indicator.get_named_progress()
                end,
            },
        },
        extensions = {},
    }
end

function M.show_window()
    return "%#AlwaysOnWindowNumber#藍" .. vim.api.nvim_win_get_number(0)
end

function M.show_context()
    return "[" .. (vim.g.funky_context or "...") .. "]"
end

-- zen low-flicker indication of file status (unsaved, saved, read-only)
M.file_icons = {
    modified = "",
    unmodified = "",
    read_only = "",
    autosave = "",
    no_autosave = " ",
}

function M.show_file()
    local icon = nil
    if vim.bo.modifiable then
        if vim.bo.modified then
            icon = M.file_icons.modified
        else
            icon = M.file_icons.unmodified
        end
    else
        icon = M.file_icons.read_only
    end

    local autosave = nil
    if vim.b.autosave == true then
        autosave = M.file_icons.autosave
    else
        autosave = M.file_icons.no_autosave
    end

    local name = vim.api.nvim_buf_get_name(0)
    local protocol = string.match(name, "^(.+)://")
    if protocol == nil then
    elseif protocol == "fugitive" then
        -- fugitive:///home/dkuettel/config/.git// (fugitive summary)
        local summary = string.match(name, "git//$")
        -- fugitive:///home/dkuettel/config/.git//3a345fe9e565ba14ed8967927cd4f991af2fe9e3/i/git/setup (at commit)
        -- fugitive:///home/dkuettel/config/.git//0/i/git/setup (thats always [index] in a diff?)
        local at = string.match(name, "git//(%w+)/")
        if summary ~= nil then
            protocol = protocol .. "@summary"
        elseif at ~= nil then
            protocol = protocol .. "@" .. string.sub(at, 1, 7)
        else
            protocol = protocol .. "@?"
        end
    else
        protocol = protocol .. "?"
    end

    if protocol == nil then
        protocol = ""
    else
        protocol = protocol .. "://"
    end

    -- NOTE we might have to escape things that we dont control
    -- like require("lualine.utils.utils").stl_escape(vim.fn.expand("%:t"))
    -- TODO but wondering if lualine is even necessary, statusline gives enough control already
    return icon .. autosave .. " " .. protocol .. "%t"
end

-- zen low-flicker indicator of progress in file (location as percentage)
-- M.progress_icons = "█▇▆▅▄▃▂▁ "
-- M.progress_icons = ""
M.progress_icons = "꜍꜎꜏꜐꜑"
function M.show_progress()
    -- strcharpart index is 0-based
    local first_icon = 0
    local last_icon = vim.fn.strcharlen(M.progress_icons) - 1
    -- vim lines are 1-based
    local first_line = 1
    local last_line = vim.fn.line("$")
    -- we want first_line -> first_icon and last_line -> last_icon
    local at_line = vim.fn.line(".")
    local at_icon = math.floor(
        0.5 + first_icon + (at_line - first_line) / (last_line - first_line) * (last_icon - first_icon)
    )
    -- strcharpart index is 0-based
    return vim.fn.strcharpart(M.progress_icons, at_icon, 1)
    -- NOTE g<c-g> shows the current position including col and line
end

function M.tablist()
    local inactive = ""
    local active = ""
    local tab_ids = vim.api.nvim_list_tabpages()
    local current_tab = vim.api.nvim_tabpage_get_number(0)
    local format = ""
    for i, _ in ipairs(tab_ids) do
        if i > 9 then
            break
        end
        if i == current_tab then
            format = format .. vim.fn.strcharpart(active, i, 1)
        else
            format = format .. vim.fn.strcharpart(inactive, i, 1)
        end
    end
    return format
    -- NOTE ideas
    -- add window count for tab
    -- show how tabs "forked" from each other?
    -- show names of windows if not too much?
end

return M
