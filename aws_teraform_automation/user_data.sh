#!/bin/bash
apt-get update
apt-get install -y docker.io
systemctl start docker
docker run -d -p 3000:3000 bkimminich/juice-shop
