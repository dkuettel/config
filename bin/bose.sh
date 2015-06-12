#!/bin/bash

bluez-test-audio connect 00:0C:8A:69:3B:C4
pactl list cards short
pactl set-default-sink bluez_sink.00_0C_8A_69_3B_C4

# notes:
# also needed to Disable=Headset in section [General] in /etc/bluetooth/audio.conf
# and sudo restart bluetooth
# otherwise it's in headset mode and the mic and sound share bandwidth
# maybe also pactl set-card-profile x a2dp
