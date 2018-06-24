#!/usr/in/bash
/usr/local/bin/mpc | /usr/local/bin/mpc status | awk 'NR==2 { split($3, a, " "); print a[1]}'
