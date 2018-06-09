#!/bin/bash
MIN_BODY_SIZE=24

OPTIONS="-s -6 -L"
CONNECT_TIMEOUT="--connect-timeout 6"
MAX_TIME="-m 10"
MAX_REDIRS="--max-redirs 2"
WRITE_OUT="-w %{size_download} "
URL="http://www.$1/"

bytecount=$(curl $OPTIONS $CONNECT_TIMEOUT $MAX_TIME $MAX_REDIRS $WRITE_OUT -o /dev/null $URL)

if [[ $bytecount -ge $MIN_BODY_SIZE ]]; then
  exit 0;
else
  exit 1;
fi
