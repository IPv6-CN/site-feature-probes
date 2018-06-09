#!/bin/bash
dnslist=$( dig -6 +nssearch $1 )
ipv6dnscount=$( echo -n "$dnslist" | grep ^SOA | grep -v 'server ::ffff' | grep -v ^$ | wc -l )
# Step 1: find all NS records of the given domain
# Step 2: filter out IPv4 mapped IPv6 addresses
# Step 3: count total lines, excluding empty lines

if [[ $ipv6dnscount -gt 0 ]]; then
  exit 0;
else
  exit 1;
fi
