c.TerminalInteractiveShell.autoindent = False
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.display_completions = 'column'
c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.editor = 'nvim'
c.TerminalInteractiveShell.true_color = True
c.TerminalInteractiveShell.show_rewritten_input = False

# TODO https://github.com/ipython/ipython/issues/13443
# should make escpae work a bit better, but it's somehow broken since 8.0.0 or so
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.TerminalInteractiveShell.timeoutlen = 0.2
# c.TerminalInteractiveShell.ttimeoutlen = 0.01

# see template.py for options
# last check for 8.2.0
# 'ipython profile create template' to get a new one and diff
