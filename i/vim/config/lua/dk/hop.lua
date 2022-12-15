local M = {}

function M.setup()
    -- https://github.com/phaazon/hop.nvim
    vim.cmd("packadd hop.nvim")

    local hop = require("hop")
    hop.setup({
        multi_windows = true, -- this means more targets, potentially longer sequence to reach
        -- multi_windows is broken https://github.com/phaazon/hop.nvim/issues/244
        -- because they use signs (arguably better than easymotion)
        -- but signs are attached to a buffer, not to a window
        -- commented there with a possible solution
        char2_fallback_key = "<enter>",
        jump_on_sole_occurrence = false,
    })

    vim.keymap.set("n", "s", hop.hint_char1, { desc = "hop char1" })
    vim.keymap.set("n", "S", hop.hint_char2, { desc = "hop char2" })

    vim.cmd([[
        highlight! link HopUnmatched EndOfBuffer
        highlight! HopNextKey gui=bold guibg=#3c3836 guifg=#fbf1c7  " inverse normal
        highlight! HopNextKey1 gui=bold,underline guifg=#3c3836 guibg=#fbf1c7  " normal
        highlight! HopNextKey2 gui=underline guifg=#3c3836 guibg=#fbf1c7  " normal
    ]])
end

function M.legacy()
    -- https://github.com/easymotion/vim-easymotion
    vim.cmd([[
        """ easymotion
        " todo: light weight version that only support f and f2?
        let g:EasyMotion_do_mapping = 0
        nmap s <Plug>(easymotion-overwin-f)
        nmap S <Plug>(easymotion-overwin-f2)
        "nmap s <Plug>(easymotion-bd-f)
        "nmap S <Plug>(easymotion-bd-f2)
        hi EasyMotionShade cterm=none ctermfg=10 ctermbg=none
        hi EasyMotionTarget cterm=bold ctermfg=3 ctermbg=none
        hi EasyMotionTarget2First cterm=bold ctermfg=3 ctermbg=none
        hi EasyMotionTarget2Second cterm=none ctermfg=4 ctermbg=none
        " todo the overwin command currently ignores First and Second :/ only the easymotion-bd-f uses it nicely
        " its a bug see https://github.com/easymotion/vim-easymotion/issues/364
    ]])
end

return M
