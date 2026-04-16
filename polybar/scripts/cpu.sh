#!/bin/bash
# CPU usage
cat /proc/stat | grep "^cpu " | awk '{total=$2+$3+$4+$5+$6+$7+$8; idle=$5; printf "▣ %.0f%%\n", (100*(total-idle)/total)}'