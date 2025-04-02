#!/bin/bash

sudo dnf install nginx -y
sudo rm -rf /usr/share/nginx/html/*
echo "<h1>Hello-world one </h1>" > /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx