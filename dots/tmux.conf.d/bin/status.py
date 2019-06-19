import contextlib


class status_dropbox:
    def __init__(self):
        pass

    def __enter__(self):
        import socket

        self.s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.f = None
        return self.status

    def connect(self):
        import os

        try:
            self.s.connect(os.path.expanduser("~/.dropbox/command_socket"))
            self.f = self.s.makefile("rw")
        except FileNotFoundError:
            self.f = None

    def status(self):
        if self.f is None:
            self.connect()
        if self.f is None:
            return None
        try:
            self.f.write("get_dropbox_status\ndone\n")
            self.f.flush()
            idle = False
            for l in self.f:
                if l == "done\n":
                    break
                idle |= l == "status\tUp to date\n"
            return "✓" if idle else "x"
        except:
            self.f = None
            return "?"

    def __exit__(self, *args):
        if self.f:
            self.f.close()
        self.s.close()


@contextlib.contextmanager
def status_cpu():
    import psutil

    def status():
        compute = round(psutil.cpu_percent())
        memory = psutil.virtual_memory()
        return f"{compute:2}% {round(memory.used/1e9)}/{round(memory.total/1e9)}G"

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
                    return f"{compute.gpu:2}% {round(memory.used/1e9)}/{round(memory.total/1e9)}G"

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
