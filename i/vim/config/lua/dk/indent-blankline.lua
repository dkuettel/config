local M = {}

function M.setup()
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    vim.cmd("packadd indent-blankline.nvim")
    M.simple()
end

function M.simple()
    vim.opt.list = true
    -- vim.opt.listchars:append("eol:↴")
    vim.cmd([[highlight IndentBlanklineIndent1 guifg=#d5c4a1 gui=nocombine]])
    require("indent_blankline").setup({
        show_end_of_line = false,
        char = "",
        char_highlight_list = {
            "IndentBlanklineIndent1",
        },
    })
end

function M.with_spaces()
    vim.opt.list = true
    -- TODO not sure if that keeps old entries intact
    vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")
    require("indent_blankline").setup({
        show_end_of_line = false,
        space_char_blankline = " ",
    })
end

function M.rainbows()
    vim.opt.termguicolors = true
    vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

    vim.opt.list = true
    vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")

    -- TODO could be cool, but the lines are too thin to see the color
    require("indent_blankline").setup({
        space_char_blankline = " ",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        },
    })
end

function M.bands()
    vim.opt.termguicolors = true
    -- TODO colors select now for gruvbox light
    vim.cmd([[highlight IndentBlanklineIndent1 guibg=#f5ebc2 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent2 guibg=#ebdbb2 gui=nocombine]])

    -- TODO doesnt do well yet with cursorline, and with inactive windows
    require("indent_blankline").setup({
        char = "",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
    })
end

function M.with_context()
    vim.opt.list = true
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")

    require("indent_blankline").setup({
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
    })
end

function M.with_blocks()
    vim.opt.termguicolors = true
    vim.cmd([[
        highlight IndentBlanklineIndent1 guibg=#f9f5d7 gui=nocombine
        highlight IndentBlanklineIndent2 guibg=#f2e5bc gui=nocombine
    ]])

    require("indent_blankline").setup({
        char = "",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
    })
end

return M
