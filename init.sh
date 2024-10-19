#!/bin/bash

# Mettre à jour le système
sudo apt-get update

# Installer Docker
sudo apt-get install -y docker.io

# Installer Docker Compose
sudo apt-get install -y docker-compose

# Cloner le dépôt Git contenant les fichiers nécessaires
sudo git clone https://github.com/pierre9009/slave-startup.git /home/pierre/slave-startup

# Vérifier si le fichier .env existe, sinon le créer
if [ ! -f /home/pierre/slave-startup/.env ]; then
  echo "Création du fichier .env..."
  cat <<EOF > /home/pierre/slave-startup/.env
# Ajouter vos variables d'environnement ici
EOF
fi

# Créer le fichier de service systemd pour Docker Compose
cat <<EOF | sudo tee /etc/systemd/system/docker_compose_containers.service
[Unit]
Description=Run Docker Compose at Startup
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/home/pierre/slave-startup/start_docker_compose.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Recharger les fichiers de configuration systemd
sudo systemctl daemon-reload

# Activer le service Docker Compose pour démarrer au démarrage
sudo systemctl enable docker_compose_containers.service

# Démarrer le service
sudo systemctl start docker_compose_containers.service
