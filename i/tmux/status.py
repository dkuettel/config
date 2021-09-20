#!ltstatus
from pathlib import Path

from ltstatus import RateLimitedMonitors, RegularGroupMonitor, StdoutStatus, monitors, indicators

monitor = RateLimitedMonitors(
    rate=1,
    monitors=[
        monitors.nvidia.Monitor(),
        monitors.dropbox.Monitor(),
        RegularGroupMonitor(
            interval=1,
            monitors=[
                monitors.cpu.Monitor(),
                monitors.diskspace_alerts.Monitor(
                    limits={
                        Path("/var/lib/docker"): 2.0,
                        Path("/"): 10.0,
                        Path("~"): 5.0,
                    },
                ),
            ],
        ),
    ],
)

status = StdoutStatus(
    monitor=monitor,
    order=[
        "diskspace-alerts",
        "dropbox",
        "cpu",
        "nvidia",
    ],
)

status.run()
