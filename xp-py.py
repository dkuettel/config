import nn.xp_config as xpc
import nn.gan
import numpy as np
try:
	import xp
except:
	pass
import nn.xpman as xm
from copy import deepcopy
from nn.xp_config import Struct
if xpc.has():
	c = xpc.load()
import nn.nn_utils as nnu
