# see also https://docs.nvidia.com/deploy/nvml-api/index.html
import pynvml as nv
import time
import sys


# notes:
# check if tmux kills the process when not needed?
# or only when it stopped on its own?
# question is should we run forever, listen to signals, or only run for "some" time?


try:
    nv.nvmlInit()
    count = nv.nvmlDeviceGetCount()
    if count > 0:
        handle = nv.nvmlDeviceGetHandleByIndex(0)
        while True:
            memory = nv.nvmlDeviceGetMemoryInfo(handle)
            # .total/used/free in bytes
            compute = nv.nvmlDeviceGetUtilizationRates(handle)
            # .gpu/memory usage in percent
            print(f"[{compute.gpu}% {round(memory.used/1e9)}/{round(memory.total/1e9)}G]")
            time.sleep(3)
    else:
        pass
finally:
    nv.nvmlShutdown()
