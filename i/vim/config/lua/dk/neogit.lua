local M = {}

local function split_mixed_lines(mixed_lines)
    mixed_lines = mixed_lines or {}
    local all_lines = {}
    for _, mixed_line in ipairs(mixed_lines) do
        for line in vim.gsplit(mixed_line, "[\r\n]") do
            table.insert(all_lines, line)
        end
    end
    return all_lines
end

local function view(item)
    vim.cmd([[
        tabnew
        setlocal buftype=nofile
        file last-git-commit-log
    ]])
    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "command: " .. item.cmd, "returns " .. tostring(item.code), "", "" })
    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "--------------- stdout ---------------", "" })
    vim.api.nvim_buf_set_lines(0, -1, -1, true, split_mixed_lines(item.stdout))
    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "" })
    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "--------------- stderr ---------------", "" })
    vim.api.nvim_buf_set_lines(0, -1, -1, true, split_mixed_lines(item.stderr))
    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "" })
end

local function get_last_commit_log()
    local history = require("neogit.lib.git.cli").history
    for i = #history, 1, -1 do
        local item = history[i]
        if string.sub(item.cmd, 1, 10) == "git commit" then
            return item
        end
    end
end

local function show_last_commit_log()
    local item = get_last_commit_log()
    if item then
        view(item)
    end
end

local function show_last_commit_log_if_failed()
    local item = get_last_commit_log()
    print("checking")
    print(item.code)
    if item.code ~= 0 then
        print("uuh")
        view(item)
    end
end

function M.setup()
    vim.cmd("packadd plenary.nvim")

    -- https://github.com/sindrets/diffview.nvim
    -- has much to offer independent of neogit
    -- TODO but I dont know yet how to use it to stage stuff, craft commits
    -- TODO in a video or picture the filename included [index] or so to know what is what, I dont see it, because of lualine?
    vim.cmd("packadd diffview.nvim")
    require("diffview").setup({
        file_panel = {
            win_config = { position = "right" },
        },
    })

    -- https://github.com/TimUntersberger/neogit
    -- before I used https://github.com/tpope/vim-fugitive
    vim.cmd("packadd neogit")
    local neogit = require("neogit")
    neogit.setup({
        signs = {
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
        },
        integrations = { diffview = true },
        disable_commit_confirmation = true,
        disable_builtin_notifications = true,
        disable_insert_on_commit = false,
        sections = { recent = { folded = false } },
    })
    vim.keymap.set("n", ",GG", neogit.open, { desc = "neogit open" })
    vim.keymap.set("n", ",Ge", show_last_commit_log, { desc = "show last commit log" })

    -- TODO doesnt work currently
    -- neogit reports success, even when failure, but then doesnt call the event
    -- so it's not useful for showing the errors currently
    -- local group = vim.api.nvim_create_augroup("MyCustomNeogitEvents", { clear = true })
    -- vim.api.nvim_create_autocmd("User", {
    --     pattern = "NeogitCommitComplete",
    --     group = group,
    --     callback = show_last_commit_log_if_failed,
    -- })
end

return M
