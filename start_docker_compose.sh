#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker-compose

cd /home/pierre/slave-startup
docker compose pull  # Pull les dernières versions des images
docker compose up -d # Lancer les conteneurs en mode détaché
