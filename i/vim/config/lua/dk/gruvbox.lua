local M = {}


function M.packer(use)
    use {
        -- https://github.com/morhetz/gruvbox
        'morhetz/gruvbox',
        commit='bf2885a',
        setup=M.before,
        config=M.after,
    }
end


function M.setup()
    M.before()
    vim.cmd("packadd gruvbox")
    M.after()
end


function M.before()
    -- TODO does tmux let it thru? or does it to color translation?
    vim.opt.termguicolors = true
end


function M.after()
    vim.opt.background = 'light'
    vim.g.gruvbox_italic = 1
    vim.cmd('colorscheme gruvbox')
end


return M
