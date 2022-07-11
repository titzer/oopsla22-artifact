#!/usr/bin/env awk -f
{ sum += $1 }
END { printf "%s\n", (sum / NR) }
