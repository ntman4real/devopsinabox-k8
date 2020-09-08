#!/usr/local/bin/bash
echo "Building base Util container"
docker build -t util_base ./base_container/. &
wait
echo "Building main Util container"
docker build -t util_main ./util_container/. &
