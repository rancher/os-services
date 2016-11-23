#!/bin/bash

rm -f /tmp/.X0-lock
mkdir -p /var/run/dbus /etc/respawn.conf.d /run/lock
cat > /etc/respawn.conf.d/desktop << EOF
dbus-daemon --system --nofork --nopidfile
slim
EOF

exec console
