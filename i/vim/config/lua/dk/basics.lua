-- this should work with plain nvim
-- no dependencies, no plugins
local M = {}

function M.config()
    M.options()
    M.mappings()
    M.cursorline()
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
end

function M.mappings()
    local map = vim.keymap.set

    -- originally used to repeat last ftFT commands backwards
    vim.g.mapleader = ","
    --vim.g.maplocalleader = '?'

    --vim.keymap.set('i', 'jj', '<esc>')

    -- command mode
    map({ "n", "v" }, ";", ":") -- originally used to repeat last ftFT commands
    map({ "n", "v" }, "q;", "q:") -- originally q also starts recording

    -- wrap mode
    map("n", ",w", function()
        vim.o.wrap = not vim.o.wrap
    end)

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
        end)
    end
    map("n", "tl", "<cmd>tabmove +1<enter>")
    map("n", "th", "<cmd>tabmove -1<enter>")

    -- browse moves
    map("n", "<down>", "1<c-d>")
    map("n", "<up>", "1<c-u>")
    map("n", "<left>", "zh")
    map("n", "<right>", "zl")

    -- disable search highlights
    -- note: this makes a first '/' wait unless you type more, because it's not prefix-free
    map("n", "//", "<cmd>nohlsearch<enter>")

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

function M.active_window()
    -- TODO experimental
    -- same problem with background color priorities as cursorline
    -- but with true color now more feasible, can make it only slightly darker
    -- probably best revised when we are using lush
    -- now it's hardcoded for gruvbox theme
    -- maybe with active window we dont need the cursorline?
    -- or show the cursorline in the sign column?
    -- would be very cool to use the same color for cursorline and inactive, then cursorline disappears
    -- TODO ok that is replaced later by application of a theme currently :/
    -- so we call it last, but anyway should eventually go with the theme, because colors depend on it
    -- and this file here should not theme around!
    vim.cmd([[
      highlight NormalNC guibg=#f5ebc2
    ]])
    -- used https://www.developmenttools.com/color-picker/
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

-- insert dates
-- TODO no lua api yet
vim.cmd([[
    iabbrev <expr> today<< strftime("%F")
    iabbrev <expr> today+1<< strftime("%F", localtime() + 1*24*60*60)
    iabbrev <expr> today+2<< strftime("%F", localtime() + 2*24*60*60)
    iabbrev <expr> today+3<< strftime("%F", localtime() + 3*24*60*60)
    iabbrev <expr> today+4<< strftime("%F", localtime() + 4*24*60*60)
]])
--]=]
