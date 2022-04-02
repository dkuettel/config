local M = {}

function M.setup()
    -- https://github.com/Pocco81/AutoSave.nvim
    -- also seems to check for new content on FocusGained
    vim.cmd("packadd AutoSave.nvim")

    -- controls CursorHold event delay
    -- but also other things, plus some completion plugins set that too
    -- not sure it will persist
    vim.opt.updatetime = 500

    require("autosave").setup({
        execution_message = "",
        -- FocusLost doesnt seem to trigger
        events = { "InsertLeave", "TextChanged", "CursorHold", "CursorHoldI", "FocusLost" },
        debounce_delay = 500,
    })
end

function M.legacy()
    vim.cmd([[
        """ autosave and -read
        " interesting events:
        " InsertLeave, TextChanged, CursorHold
        " TextChangedI, CursorHoldI
        " FocusGained, FocusLost
        " (needs events configured coming from the terminal or tmux, check if that works)
        set autoread
        set updatetime=500
        augroup autosave
            autocmd!
            autocmd InsertLeave,TextChanged * silent! w
            autocmd CursorHold,CursorHoldI * silent! update
            autocmd FocusLost * silent! wa
            autocmd FocusGained * silent! checktime
        augroup END
        " problems:
        " should not run :w when buffer has no file
        " silent! surpressed that error messages
        " but would be nicer not to try at all
        " CursorHoldI doesn't seem to trigger update currently
        " how to enable/disable when editing slow files (efs), 'autocmd! autosave' disables, but now way to get back
    ]])
end

return M
