import contextlib


class status_dropbox:
    def __init__(self):
        import os

        self.path = os.path.expanduser("~/.dropbox/command_socket")

    def __enter__(self):
        self.socket = None
        self.stream = None
        return self.status

    def connect(self):
        import socket

        try:
            self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            self.socket.connect(self.path)
            self.stream = self.socket.makefile("rw")
        except:
            self.stream = None
            self.socket = None
            raise

    def status(self):
        if not self.stream:
            try:
                self.connect()
            except FileNotFoundError:
                return None
            except ConnectionRefusedError:
                return "?"

        try:
            self.stream.write("get_dropbox_status\ndone\n")
            self.stream.flush()

            idle = False
            for l in self.stream:
                if l == "done\n":
                    break
                idle |= l == "status\tUp to date\n"

            return "✓" if idle else "x"

        except:
            self.stream = None
            self.socket = None
            return "?"

    def __exit__(self, *args):
        if self.stream:
            self.stream.close()
        del self.stream

        if self.socket:
            self.socket.close()
        del self.socket


@contextlib.contextmanager
def status_cpu():
    import psutil

    def status():
        compute = round(psutil.cpu_percent())
        memory = psutil.virtual_memory()
        # using GiB=2**30 instead of GB=1e9, because thats what most other tools show
        return f"{compute:2}% {round(memory.used/2**30)}/{round(memory.total/2**30)}G"

    yield status


@contextlib.contextmanager
def status_gpu():
    import pynvml as nv

    try:
        try:
            nv.nvmlInit()
        except:

            def status():
                return None

        else:
            count = nv.nvmlDeviceGetCount()
            if count > 0:
                handle = nv.nvmlDeviceGetHandleByIndex(0)

                def status():
                    # memory has .total, .used, .free; in bytes
                    memory = nv.nvmlDeviceGetMemoryInfo(handle)
                    # compute has .gpu, .memory; in percent
                    compute = nv.nvmlDeviceGetUtilizationRates(handle)
                    # using GiB=2**30 instead of GB=1e9, because thats also what nvidia-smi shows
                    return f"{compute.gpu:2}% {round(memory.used/2**30)}/{round(memory.total/2**30)}G"

            else:

                def status():
                    return None

        yield status

    finally:
        nv.nvmlShutdown()


def main(interval=3):
    import time

    with status_dropbox() as db, status_cpu() as cpu, status_gpu() as gpu:
        while True:
            stati = [db(), cpu(), gpu()]
            stati = [s for s in stati if s is not None]
            print("[" + "] [".join(stati) + "]")
            time.sleep(interval)


if __name__ == "__main__":
    main()
