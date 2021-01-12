#!/bin/bash

CPU_USAGE=`top -b -n 1 | grep Cpu | awk '{print $2}'`

printf "%6s" "$CPU_USAGE% "
