#!/bin/bash
# Emit hooks to keep it updating
while true; do
  herbstclient emit_hook REFRESH_PANEL BIG
  for i in {1..10}; do
    herbstclient emit_hook REFRESH_PANEL SMALL
    sleep 5
  done
done
