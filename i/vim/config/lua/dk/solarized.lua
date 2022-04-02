local M = {}


function M.packer(use)
    use {
        -- https://github.com/altercation/vim-colors-solarized
        'altercation/vim-colors-solarized',
        commit='528a59f',
        setup=M.before,
        config=M.after,
    }
end


function M.setup()
    -- TODO hm ok its not true color, so best option is 16 colors, but maybe other plugins dont play nice
    -- TODO does tmux let it thru? or does it to color translation?
    vim.opt.termguicolors = true
    vim.cmd("packadd vim-colors-solarized")
    M.after()
end


function M.after()
    vim.opt.background = 'light'
    vim.cmd('colorscheme solarized')
end


return M
