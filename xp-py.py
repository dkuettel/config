import nn.xp_config as xpc
import nn.gan
import numpy as np
import xp
import nn.xpman as xm
from copy import deepcopy
if xpc.has():
	c = xpc.load()
