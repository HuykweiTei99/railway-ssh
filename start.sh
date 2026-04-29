#!/bin/bash

set -e

echo "=== START SSH ==="
/usr/sbin/sshd

echo "=== START NGROK ==="
# thêm token của bạn
ngrok config add-authtoken YOUR_NGROK_TOKEN

# mở SSH qua ngrok
ngrok tcp 22 > /tmp/ngrok.log &

# optional: web keep alive (Railway thích port 8080)
python3 -m http.server 8080 &

echo "=== CONTAINER READY ==="

# giữ container sống
tail -f /dev/null