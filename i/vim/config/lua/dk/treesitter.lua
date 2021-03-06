local M = {}

function M.setup()
    -- https://github.com/nvim-treesitter/nvim-treesitter
    vim.cmd("packadd nvim-treesitter")
    -- https://github.com/nvim-treesitter/playground
    vim.cmd("packadd playground")

    require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
            enable = true,
            disable = function(lang, bufnr)
                if lang == "markdown" and string.sub(vim.api.nvim_buf_get_name(bufnr), -16) == "standup.markdown" then
                    return true
                end
                return false
            end,
            -- TODO I still see some old-fashioned highlights, for example python imports are gruvbox blue or so
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = { enable = false },
        indent = { enable = false },
        -- TODO most here are probably defaults, so make it shorter?
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = "o",
                toggle_hl_groups = "i",
                toggle_injected_languages = "t",
                toggle_anonymous_nodes = "a",
                toggle_language_display = "I",
                focus_language = "f",
                unfocus_language = "F",
                update = "R",
                goto_node = "<cr>",
                show_help = "?",
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
    })

    -- TODO is this useful for some custom colors in python?
    -- require("nvim-treesitter.highlight").set_custom_captures({
    --     -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    --     ["foo.bar"] = "Identifier",
    -- })

    -- could be cool
    -- nvim_treesitter#statusline(opts)
end

function M.play()
    -- TODO see also :help show_tree, something similar is now built-in to nvim
    local queries = [[
        (import_statement) @ErrorMsg
    ]]

    vim.treesitter.query.set_query("python", "highlights", queries)

    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buffer = vim.api.nvim_win_get_buf(window)
        local filetype = vim.api.nvim_buf_get_option(buffer, "filetype")
        if filetype == "python" then
            vim.api.nvim_win_call(window, function()
                vim.cmd(":edit")
            end)
        elseif filetype == "tsplayground" then
            vim.api.nvim_win_call(window, function()
                vim.cmd(":normal R")
            end)
        end
    end

    -- gruvbox doesnt seem to really set all highlights? or TS doesnt map all?
    -- can we dump it into a file and look at the structure of the highlights?
end


function M.refresh()
    -- used in i/nvim/plugins, to make sure all is up-to-date again
    vim.cmd([[
        TSInstallSync all
        TSUpdateSync
        helptags ALL
    ]])
end

return M
