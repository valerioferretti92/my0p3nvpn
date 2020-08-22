# Streams openvpn container's log

#!/bin/bash
set -e

sudo docker logs openvpn --follow

