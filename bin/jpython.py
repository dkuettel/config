
import exceptions
import sys
import traceback                                              
import os
import imp

try:                                                               
	del sys.argv[0]
	execfile(sys.argv[0])
except:                                                            
	ex_type, ex, tb = sys.exc_info()                               
	print ''.join(traceback.format_exception(ex_type, ex, tb))     
	if isinstance(ex, exceptions.SyntaxError):
		os.system('tmux split-window -h zsh -c "stty -ixon; vim +%d %s"' % (ex.lineno, ex.filename))
	else:
		locs = traceback.extract_tb(tb)                                
		loc = locs[-1]                                                 
		os.system('tmux split-window -h zsh -c "stty -ixon; vim +%d %s"' % (loc[1], loc[0]))
	raise
