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

    lsp_progress = require("dk.lsp-progress")
    lsp_progress.setup {
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
                    return lsp_progress.get_state(0)
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
            lualine_z = {
                -- TODO because documentation doesnt say what those params are that it passes ...
                function()
                    return lsp_progress.get_named_progress()
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

-- zen low-flicker indication of lsp activity (no lsp, busy lsp, idle lsp)
M.lsp_activity_icons = { missing = "", busy = "", idle = "" }
function M.show_lsp_activity()
    if #vim.lsp.buf_get_clients() == 0 then
        return M.lsp_activity_icons.missing
    end
    -- TODO same here is it progress for the buffer or anything else? which LSP is it?
    -- there is also vim.lsp.util.server_ready() but seems to return true also when still indexing
    -- sometimes it seems stuck on "busy" forever, when I do start/stop lsp to reload things?
    -- TODO ok maybe that would make it unnecessary to attach my listener?
    -- looks like it's a final aggregated list of things in flight
    -- kinda exactly what I need :)
    if #vim.lsp.util.get_progress_messages() == 0 then
        return M.lsp_activity_icons.idle
    end
    return M.lsp_activity_icons.busy
end

-- zen low-flicker indicator of progress in file (location as percentage)
-- M.progress_icons = { "█", "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " }
M.progress_icons = { "", "", "", "", "", "", "", "", "", "", "", "", "", "" }
function M.show_progress()
    local i = 1 + math.floor(vim.fn.line(".") / vim.fn.line("$") * (#M.progress_icons - 1))
    return M.progress_icons[i]
    -- NOTE g<c-g> shows the current position including col and line
end

return M
