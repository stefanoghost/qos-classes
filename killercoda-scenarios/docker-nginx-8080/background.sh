#!/bin/bash
set -e

mkdir -p /root/docker-lab
cd /root/docker-lab

cat > Dockerfile <<'EOF'
FROM nginx:alpine

RUN sed -i 's/listen       80;/listen 8080;/' /etc/nginx/conf.d/default.conf

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 8080
EOF

cat > index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>Docker Lab</title>
</head>
<body>
  <h1>Docker custom image works!</h1>
  <p>Nginx gira sulla porta 8080</p>
</body>
</html>
EOF
