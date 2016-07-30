#!/bin/bash
# cannot use set -xeu and set -o pipefail
# because that adds output that's unexpected
shift
eval $@
