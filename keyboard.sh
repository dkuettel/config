#!/bin/bash -eux
set -o pipefail

keyboard/install.sh
# todo somehow [key left of z] and [key left of 1] are not always right
# someetimes they are right, sometimes swapped, not sure where
# is it because of inside virtual i flip twice? in host and in client
# same for vnc sessions? could be

# in case we are running in an X right now set it for the current session
keyboard/use_layout.sh
keyboard/set_rate.sh

# todo still need fn_keys for apple keyboards it seems, how to know if we have one? or do it always?
# could be okay, probably has no effect on non-apple keyboards
