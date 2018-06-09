#!/bin/bash
mxservernames=$( dig +short mx $1 | awk '{print $2}' )
mxserveripv6addresses=$( echo -n "$mxservernames" | xargs -L1 dig +short aaaa )
mxserveripv6count=$( echo -n "$mxserveripv6addresses" | wc -l )

# Step 1: find all MX records of the given domain
# Step 2: find all AAAA records of servers listed in MX records
# Step 3: count total lines
#
# To debug, uncomment 2 lines below
# echo -n "$mxservernames"
# echo -n "$mxserveripv6addresses"
# echo $mxserveripv6count

if [[ $mxserveripv6count -gt 0 ]]; then
  exit 0;
else
  exit 1;
fi
