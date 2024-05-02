#!/bin/bash

sudo apt update && sudo apt install nginx python3-certbot-nginx -y

sudo tee /etc/nginx/sites-available/skyline-rt.com > /dev/null <<'EOT'
server {
    listen 80;
    server_name skyline-rt.com www.skyline-rt.com;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name skyline-rt.com www.skyline-rt.com;
    ssl_certificate /etc/letsencrypt/live/skyline-rt.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/skyline-rt.com/privkey.pem;

    location / {
        root /var/www/html;
        index index.html index.htm;
    }
}
EOT

sudo ln -s /etc/nginx/sites-available/skyline-rt.com /etc/nginx/sites-enabled/

sudo nginx -t && sudo systemctl restart nginx

sudo certbot --nginx -d skyline-rt.com -d www.skyline-rt.com --redirect --agree-tos --no-eff-email -m nk@skyline-rt.com

sudo systemctl reload nginx
