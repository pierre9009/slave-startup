#!/bin/bash

# Mettre à jour le système
sudo apt-get update

# Installer Docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove -y $pkg; done
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Installer Docker Compose
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker login
# Cloner le dépôt Git contenant les fichiers nécessaires
sudo git clone https://github.com/pierre9009/slave-startup.git /home/pierre/slave-startup

if [ ! -f /home/pierre/slave-startup/.env ]; then
    echo "The .env file doesn't exist. Please paste the entire .env content (press Ctrl+D when finished):"
    cat > /home/pierre/slave-startup/.env
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
echo "starting and maybe pulling (take time)"
# Recharger les fichiers de configuration systemd
sudo systemctl daemon-reload

# Activer le service Docker Compose pour démarrer au démarrage
sudo systemctl enable docker_compose_containers.service

# Démarrer le service
sudo systemctl start docker_compose_containers.service
