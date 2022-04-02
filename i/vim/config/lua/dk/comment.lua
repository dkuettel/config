local M = {}

function M.setup()
    -- https://github.com/numToStr/Comment.nvim
    -- before used https://github.com/preservim/nerdcommenter
    vim.cmd("packadd Comment.nvim")
    require("Comment").setup({
        -- TODO when I set my shortcuts, then operator pending doesnt work anymore
        -- like comment inner paragraph: ",cip"
        --toggler = { line = ",cc", block = ",CC" },
        --opleader = { line = ",c", block = ",C" },
    })
end

return M
