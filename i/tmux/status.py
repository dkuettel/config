#!/usr/bin/env ltstatus
from pathlib import Path

from ltstatus import formats, monitors as m, outputs, run

diskspace_alerts = m.diskspace_alerts(
    limits={
        Path("/var/lib/docker"): 2.0,
        Path("/"): 10.0,
        Path("~"): 5.0,
    },
)

run(
    monitors=[
        diskspace_alerts,
        m.dropbox(),
        m.cpu(),
        m.nvidia(),
    ],
    polling_interval=1,
    format=formats.tmux(),
    output=outputs.stdout(),
)
