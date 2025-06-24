#!/bin/bash
echo "Configurando 1Password CLI"
# Exportar el token de 1Password
export OP_SERVICE_ACCOUNT_TOKEN="${op_service_account_token}"

# Agregar la exportación al perfil del usuario para que persista
echo "export OP_SERVICE_ACCOUNT_TOKEN='${op_service_account_token}'" >> /home/ec2-user/.bashrc
echo "export OP_SERVICE_ACCOUNT_TOKEN='${op_service_account_token}'" >> /home/ec2-user/.bash_profile

echo "Instalando 1Password CLI"
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf check-update -y 1password-cli && sudo dnf install -y 1password-cli

echo "Verificando instalación de 1Password CLI"
op --version

echo "Actualizando el sistema"
sudo dnf update -y

echo "Instalando git"
sudo dnf install -y git

echo "Instalando Docker"
sudo dnf install -y docker

echo "Instalando Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Verificando instalación de Docker Compose"
docker-compose --version

echo "Iniciando y habilitando Docker"
sudo systemctl start docker
sudo systemctl enable docker

echo "Verificando que Docker esté corriendo"
sudo systemctl status docker

echo "Agregando usuario ec2-user al grupo docker"
sudo usermod -aG docker ec2-user

echo "Creando swap para manejar memoria limitada"
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Verificando memoria y swap"
free -h

echo "Clonando repositorio SPC"
cd /home/ec2-user
git clone https://github.com/l3onardVG/SPC.git

echo "Creando archivo .env en la carpeta SPC usando 1Password"
cat > /home/ec2-user/SPC/.env << EOF
# Database Configuration
POSTGRES_USER=$(op read "op://Terraform/Passwords SPC/Postgres username")
POSTGRES_PASSWORD=$(op read "op://Terraform/Passwords SPC/Postgres Password")
POSTGRES_DB=$(op read "op://Terraform/Passwords SPC/Postgress DB")
POSTGRES_PORT=5432

# JWT Configuration
JWT_SECRET_KEY=$(op read "op://Terraform/Passwords SPC/JWT secret key")
JWT_VALID_AUDIENCE=http://localhost:5197
JWT_VALID_ISSUER=http://localhost:5197

# Application Configuration
ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_URLS=http://+:5197

# Database Connection String
NIKOLA_DATABASE=Host=db;Port=5432;Database=$(op read "op://Terraform/Passwords SPC/Postgress DB");Username=$(op read "op://Terraform/Passwords SPC/Postgres username");Password=$(op read "op://Terraform/Passwords SPC/Postgres Password")
EOF

echo "Verificando contenido del directorio SPC"
ls -la /home/ec2-user/SPC/

echo "Entrando a la carpeta SPC"
cd /home/ec2-user/SPC
echo "Directorio actual: $(pwd)"

echo "Configurando Docker para usar menos memoria"
sudo tee /etc/docker/daemon.json << EOF
{
  "default-shm-size": "64M",
  "storage-driver": "overlay2"
}
EOF

echo "Reiniciando Docker con nueva configuración"
sudo systemctl restart docker

echo "Haciendo build y levantando contenedores en un solo paso (con timeout de 20 minutos)"
timeout 1200 sudo docker-compose --progress=plain up --build -d || echo "Build y levantado timeout o error - continuando..."

echo "Verificando si los contenedores están corriendo"
sudo docker-compose ps

echo "Verificando logs de los contenedores"
sudo docker-compose logs --tail=20

echo "Configuración completada" 