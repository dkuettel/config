import nn.xp_config as xpc
import nn.gan
import numpy as np
try:
	import xp
except ImportError as e:
	pass
import nn.xpman as xm
from copy import deepcopy
from nn.xp_config import Struct
if xpc.has():
	c = xpc.load()
import nn.nn_utils as nnu

import nn.nn_logging
nn.nn_logging.setup_stdout_only()

def divert_mm(modelfile='./model.pickle'):
	import nn.fs
	modelfile = nn.fs.realpath(modelfile)
	m = xpc.load(modelfile)
	m.instance = xm.get_local_instance()
	m.instance.update()
	xpc.save(m, modelfile)
	return m


def disable_mm(modelfile='./model.pickle'):
	import nn.fs
	modelfile = nn.fs.realpath(modelfile)
	m = xpc.load(modelfile)
	m.instance = None
	xpc.save(m, modelfile)
	return m
