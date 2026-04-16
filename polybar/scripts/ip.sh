#!/bin/bash
# IP address
hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A"