#!/bin/bash
sudo apt-get update

cd /home/pierre/worker-startup
docker compose pull  # Pull les dernières versions des images
docker compose up -d # Lancer les conteneurs en mode détaché
