-- this should work with plain nvim
-- no dependencies, no plugins
local M = {}

function M.setup()
    M.options()
    M.mappings()
    M.cursorline()
    M.iabbrevs()
    M.session()
    M.new_zsh()
    M.move()
    -- M.active_window()
end

function M.options()
    local opt = vim.opt

    -- general options
    -- see :help options
    opt.swapfile = false
    opt.scrolloff = 8
    opt.sidescrolloff = 5
    opt.backspace = { "indent", "eol", "start", "nostop" }
    opt.splitbelow = true
    opt.splitright = true
    opt.wildmode = "longest:full"
    opt.virtualedit = "all"
    --opt.lazyredraw = true

    -- search (/?) ignores case
    -- unless some upper case letters are in the pattern
    opt.ignorecase = true
    opt.smartcase = true

    -- never timeout and show the so-far shortcut in the status line ('showcmd')
    -- TODO not sure if that makes problems with escape or something
    opt.timeout = false
    opt.ttimeout = true

    -- tab options
    opt.tabstop = 4
    opt.softtabstop = 4
    opt.shiftwidth = 4
    opt.expandtab = true
    opt.smarttab = true
    opt.autoindent = true
    opt.copyindent = true

    -- indicators
    -- TODO could look at some nerdfont icons
    opt.listchars = { tab = "› ", trail = "•", precedes = "◂", extends = "▸", nbsp = "¿" }
    opt.list = true

    -- fillchars for diff
    -- NOTE that's not a normal forward slash, but a tile-able one
    opt.fillchars:append { diff = "" }

    -- wrapped lines
    opt.wrap = false
    opt.linebreak = true
    opt.breakat = " "
    opt.breakindent = true
    -- TODO could look at some nerdfont icons
    opt.showbreak = "▸"

    -- modeline security
    -- see https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
    -- fixed by now, but no reason to keep it enabled usually
    opt.modeline = false
    opt.modelines = 0

    -- mouse
    opt.mouse = ""
end

function M.mappings()
    local map = vim.keymap.set

    -- originally used to repeat last ftFT commands backwards
    vim.g.mapleader = ","
    --vim.g.maplocalleader = '?'

    --map('i', 'jj', '<esc>')

    -- command mode
    map({ "n", "v" }, ";", ":") -- originally used to repeat last ftFT commands
    map({ "n", "v" }, "q;", "q:") -- originally q also starts recording

    -- wrap mode
    map("n", ",w", function()
        vim.o.wrap = not vim.o.wrap
    end, { desc = "toggle wrapping" })

    -- window navigation
    -- ',#' goes to window #
    -- original is '#<c-w>w', not so bad either
    -- alternatives ',w#', or just '<c-w>', or just 'w' like tabs go with 't'?
    for i = 1, 9 do
        map("n", "," .. i, i .. "<c-w>w")
    end

    -- tab navigation
    -- note 't' was originally until
    map("n", "tt", "<cmd>tab split<enter>")
    map("n", "tT", "<c-w>T")
    map("n", "tc", "<cmd>tabclose<enter>")
    map("n", "tp", "<cmd>tabprevious<enter>")
    map("n", "tn", "<cmd>tabnext<enter>")
    map("n", "to", "<cmd>tabonly<enter>")
    local function move_current_tab_to(i)
        local current_tab = vim.api.nvim_tabpage_get_number(0)
        if i < current_tab then
            vim.cmd("tabmove " .. (i - 1))
        elseif i > current_tab then
            vim.cmd("tabmove " .. i)
        end
    end
    for i = 1, 9 do
        map("n", "t" .. i, "<cmd>tabnext " .. i .. "<enter>")
        map("n", "tm" .. i, function()
            move_current_tab_to(i)
        end, { desc = "move tab to " .. i })
    end
    map("n", "tl", "<cmd>tabmove +1<enter>")
    map("n", "th", "<cmd>tabmove -1<enter>")
    map("n", "t-", "g<tab>")

    -- browse moves
    map("n", "<down>", "1<c-d>")
    map("n", "<up>", "1<c-u>")
    map("n", "<left>", "zh")
    map("n", "<right>", "zl")

    -- disable search highlights
    -- note: this makes a first '/' wait unless you type more, because it's not prefix-free
    map("n", "//", "<cmd>nohlsearch<enter>")
    -- no highlights on startup
    vim.cmd("nohlsearch")

    -- save all and exit
    -- 'Q' is also ex-mode, 'gQ' is an alternative for the same
    map("n", "Q", "<cmd>xa<enter>")

    -- execute current line / visual as vim command
    -- map("n", ",v", 'yy:@"<enter>')
    -- map("v", ",v", 'y:@"<enter>')

    -- duplicate visual as a copy below
    -- TODO with this "y" is not prefix-free anymore and can delay a bit
    map("v", "yp", "y`>p")
end

function M.cursorline()
    -- TODO problems
    -- highlighting groups dont always combine well, eg TODO seems to define a background color
    -- then cursorline cannot change that and it gives ugly results
    -- also with true color now we can make the backround just a tiny bit darker or lighter? not the same as status line
    -- maybe switch it off for insert mode?
    -- would underline+overline work? not actually touching colors then
    vim.cmd([[
        "hi CursorLine cterm=NONE ctermbg=0 ctermfg=NONE
        "hi CursorColumn cterm=NONE ctermbg=0 ctermfg=NONE
        set cursorline nocursorcolumn
        nnoremap ,x :set cursorline!<enter>
        nnoremap ,X :set cursorcolumn!<enter>
        " have cursorline/column only in active window
        " problem, only do when actually activated (,x)
        "augroup CursorLineOnlyInActiveWindow
        "    autocmd!
        "    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline nocursorcolumn
        "    autocmd WinLeave * setlocal nocursorline nocursorcolumn
        "augroup END
    ]])
end

function M.iabbrevs()
    vim.cmd([[
        iabbrev <expr> today<< strftime("%F")
        iabbrev <expr> today+1<< strftime("%F", localtime() + 1*24*60*60)
        iabbrev <expr> today+2<< strftime("%F", localtime() + 2*24*60*60)
        iabbrev <expr> today+3<< strftime("%F", localtime() + 3*24*60*60)
        iabbrev <expr> today+4<< strftime("%F", localtime() + 4*24*60*60)
    ]])
end

function M.active_window()
    local C = require("dk.hsluv")
    local fg = C.hex_to_hsluv(string.format("#%06x", vim.api.nvim_get_hl_by_name("Normal", true).background))
    local shade = {
        fg[1] + (fg[1] < 50 and 1 or -1) * 0,
        fg[2] + (fg[2] < 50 and 1 or -1) * 25,
        fg[3] + (fg[3] < 50 and 1 or -1) * 2.5,
    }
    shade = C.hsluv_to_hex(shade)
    -- manually I for gruvbox I chose #f5ebc2 which is 75.1, 46.9, 92.9
    -- based on Normal on gruvbox as #fbf1c7 which is 75.4, 70.1, 95
    vim.cmd(string.format(
        [[
      highlight NormalNC guibg=%s
      highlight CursorLine guibg=%s
      highlight CursorColumn guibg=%s
    ]],
        shade,
        shade,
        shade
    ))
    -- TODO some highlights overwrite background, so cursorline is not always nice
end

function M.session()
    -- save session on exit when in "session mode"
    -- TODO ideally there should ever be only one vim in session mode per location (similar to per workspace)
    if os.getenv("vim_is_in_session") == "yes" then
        vim.cmd("autocmd VimLeave * execute 'mksession!'")
    end
end

local function cmd_new_zsh(args)
    local reply = vim.fn.system { "new-zsh", args.args }
    if vim.v.shell_error ~= 0 then
        print("new-zsh failed: " .. reply)
    else
        vim.cmd("edit + " .. args.args)
    end
end

function M.new_zsh()
    vim.api.nvim_create_user_command(
        "NewZsh",
        cmd_new_zsh,
        { nargs = 1, complete = "file", desc = "Create an executable zsh script and open for editing." }
    )
end

local function cmd_move(args)
    -- NOTE use %:h/new-file to put in the same folder
    local before = vim.api.nvim_buf_get_name(0)
    vim.cmd("saveas " .. args.args)
    vim.fn.system { "rm", before }
end

function M.move()
    vim.api.nvim_create_user_command(
        "Move",
        cmd_move,
        { nargs = 1, complete = "file", desc = "Move current buffer's file." }
    )
end

return M

--[=[

local autocommand = vim.api.nvim_create_autocmd


-- statusline
-- TODO with a long filename the window number disappears
opt.statusline = '%#StatusLineWinNr#[%{winnr()}]%* %q%h%w%f%m%r%=%{mode(1)} %p%% @%l:%v'
vim.cmd([[
    highlight StatusLine ctermfg=15 ctermbg=4 cterm=bold
    highlight StatusLineNC ctermfg=10 ctermbg=15 cterm=none
    highlight StatusLineWinNr ctermfg=15 ctermbg=4
]])

-- tabline
-- TODO those colors dont apply, but above for statusline it worked
vim.cmd([[
    highlight TabLine cterm=inverse
    highlight TabLineSel cterm=bold ctermbg=15 ctermfg=10
    highlight TablineFill cterm=inverse
]])
function _G.custom_tabline()
    local current_tab = vim.api.nvim_tabpage_get_number(0)
    local i = 1
    local status = ''
    while vim.api.nvim_tabpage_is_valid(i) do
        if i == current_tab then
            status = status..'%#TabLineSel#/'..i..' '
        else
            status = status..'%#TabLine#/'..i..' '
        end
        i = i+1
    end
    return status..'%#TabLine#'
end
opt.tabline = '%!v:lua.custom_tabline()'

-- Q for exit, but it also runs the last recording (?), kinda useful
-- on the other hand do with @1 and then . to keep on doing it
-- note we have that probably still in the "experimental" section
-- could clean that up now as well, here we are still in the baseline file
-- it should all work with vanilla nvim
-- remember :set! shows all options that are different from default

-- filetypes
-- see :help filetype
-- see :help g:do_filetype_lua
-- I guess this happens after init.lua?
-- I dont know what filetypes are registered there
-- but useful if I wanna add types via lua directly?
-- used to be that we put it in ~/.config/nvim/after/[ftplugin|indent]/name.vim
-- if we wanted to just adapt what the main filetype plugin did
-- see :help lua-filetype
-- might make things easy for adding filetypes?
--vim.g.do_filetype_lua = 1

-- capitalize after typing
-- first attempt: imap <c-u> <esc>mmvB~`ma, to be used after the fact
-- note this works in insert mode, not in command mode or other "typing modes"

-- soft caps-lock
-- see https://vim.fandom.com/wiki/Insert-mode_only_Caps_Lock
for c in ('abcdefghijklmnopqrstuvwxyz'):gmatch('.') do
    map('l', c, c:upper())
    map('l', c:upper(), c)
end
-- <c-^> switches the language map
-- note the indicator "(lang)" in the status line
-- alternative mappings
--   <c-h> but that one is also a convenient backspace
--   <c-l> but that one is documented as something I dont understand
--   <c-u> but that one also delete the whole current line
map('i', '<c-l>', '<c-^>')
-- note the above mapping only happens in insert mode, so command mode does not have soft capslock right now
-- for soft-capslock switch off language mapping when leaving
-- but when using language mapping for its original use, then we probably dont want that
autocommand('InsertLeave', {callback=function() vim.o.iminsert = 0 end})
--]=]
