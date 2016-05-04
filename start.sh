#!/usr/bin/env bash
echo "Starting nginx-proxy..."
docker-compose -p proxy -f /home/vagrant/test/docker-compose.proxy.yml up -d
echo "Starting web app..."
docker-compose -f /home/vagrant/test/docker-compose.yml up -d