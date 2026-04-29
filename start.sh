#!/bin/bash

set -e

echo "=== START SSH ==="
/usr/sbin/sshd

echo "=== START WEB 8080 (KEEP ALIVE) ==="
python3 -m http.server 8080 >/dev/null 2>&1 &

echo "=== START NGROK ==="
ngrok config add-authtoken 2T8riBjhCDBVhDMHGMBQO6ndiJM_44pFVKWYni7pdinqwGJf8

# chạy ngrok nền
ngrok tcp 22 >/dev/null 2>&1 &

# đợi ngrok lên
sleep 3

echo "=== NGROK INFO ==="
curl -s http://127.0.0.1:4040/api/tunnels

echo ""
echo "=== SSH CONNECT ==="
# parse ra link gọn
URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'tcp://[^"]*')
HOST=$(echo $URL | cut -d'/' -f3 | cut -d':' -f1)
PORT=$(echo $URL | cut -d':' -f3)

echo "Host: $HOST"
echo "Port: $PORT"
echo ""
echo "SSH:"
echo "ssh trthaodev@$HOST -p $PORT"

echo "=== CONTAINER READY ==="

# giữ container sống + xem log realtime nếu cần
tail -f /dev/null