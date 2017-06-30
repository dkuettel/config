
import exceptions
import sys
import traceback                                              
import os
import imp
from ipdb import launch_ipdb_on_exception

with launch_ipdb_on_exception():
	try:                                                               
		print
		del sys.argv[0]
		execfile(sys.argv[0])
	except:                                                            
		ex_type, ex, tb = sys.exc_info()
		if isinstance(ex, exceptions.SyntaxError):
			os.system('tmux split-window -h zsh -c "stty -ixon; cd $nn; vim +%d %s"' % (ex.lineno, ex.filename))
			raise
		else:
			locs = traceback.extract_tb(tb)
			loc = locs[-1]
			open('/data/xps/metric/dev/nn/err.out', 'w').write('\n'.join('%s:%d:0' % (l[0], l[1]) for l in locs[::-1]))
			# os.system('tmux split-window -h zsh -c "stty -ixon; vim +%d %s"' % (loc[1], loc[0]))
			os.system('tmux split-window -h zsh -c "stty -ixon; cd $nn; vim -q err.out"')
			# print ''.join(traceback.format_exception(ex_type, ex, tb)) # todo no needed because of later raise does it again
			raise # todo above we already print it, somehow that print contains more info than reraising (?)
