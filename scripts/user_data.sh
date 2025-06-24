#!/bin/bash
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

echo "Creando archivo .env en la carpeta SPC"
cat > /home/ec2-user/SPC/.env << 'EOF'
# Database Configuration
POSTGRES_USER=secretos
POSTGRES_PASSWORD=secretos
POSTGRES_DB=spc
POSTGRES_PORT=5432

# JWT Configuration
JWT_SECRET_KEY=WkC6hIjDEATTWWxdHlcEbnGd5hallhY6
JWT_VALID_AUDIENCE=http://localhost:5197
JWT_VALID_ISSUER=http://localhost:5197

# Application Configuration
ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_URLS=http://+:5197

# Database Connection String
NIKOLA_DATABASE=Host=db;Port=5432;Database=spc;Username=secretos;Password=secretos
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