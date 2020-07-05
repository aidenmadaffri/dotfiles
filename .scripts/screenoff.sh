#!/bin/bash
sleep 0.5
xset dpms force off
/home/aiden/.scripts/lock.sh
# sleep 1 adds a small delay to prevent possible race conditions with suspend
sleep 1
