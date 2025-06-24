# Proyecto Terraform - Infraestructura en AWS

Este proyecto define y despliega una infraestructura básica en AWS utilizando Terraform. Incluye la creación de una VPC, subredes públicas y privadas, un gateway de Internet, una tabla de ruteo, un grupo de seguridad y instancias EC2 accesibles por SSH.

## 🆓 AWS Free Tier Optimizado

Este proyecto está configurado para ser **compatible con AWS Free Tier**, utilizando recursos que no generan costos durante el primer año:

### ✅ Recursos Free Tier Elegibles:
- **AMI**: Amazon Linux 2023 (automáticamente seleccionada)
- **Instance Type**: t2.micro (750 horas/mes gratis)
- **EBS Storage**: 30 GB incluidos en free tier
- **Data Transfer**: 15 GB de salida incluidos
- **VPC**: Gratis (sin límites)
- **Internet Gateway**: Gratis
- **Security Groups**: Gratis

### 📊 Límites Free Tier:
- **750 horas/mes** de instancias t2.micro
- **30 GB** de almacenamiento EBS
- **15 GB** de transferencia de datos de salida
- **2 instancias** máximas (este proyecto crea 2 instancias)

### 🔄 AMI Dinámica:
El proyecto utiliza un **data source** que automáticamente obtiene la última versión de Amazon Linux 2023, eliminando la necesidad de actualizar manualmente los IDs de AMI.

## 🔐 Gestión Segura de Secretos con 1Password

Este proyecto integra **1Password CLI** para la gestión segura de secretos y credenciales:

### ✅ Características de Seguridad:
- **1Password CLI** instalado automáticamente en las instancias
- **Service Account Token** configurado para acceso programático
- **Secretos dinámicos** en lugar de valores hardcodeados
- **Variables de entorno seguras** con `sensitive = true`
- **Configuración persistente** en perfiles de usuario

### 🔧 Configuración de 1Password:

#### **1. Configurar el Service Account Token**:
```bash
# Exportar el token de 1Password
export TF_VAR_op_service_account_token=$(op read "op://Terraform/6behtiu53jvqlkh5w5b7ho72wy/credencial")

# O usar directamente
TF_VAR_op_service_account_token=$(op read "op://Terraform/6behtiu53jvqlkh5w5b7ho72wy/credencial") terraform apply
```

#### **2. Secretos Requeridos en 1Password**:
El proyecto requiere los siguientes secretos en tu vault de 1Password:

```
Terraform/Passwords SPC/
├── Postgres username
├── Postgres Password
├── Postgress DB
└── JWT secret key
```

#### **3. Estructura de Secretos**:
- **Base de datos**: Usuario, contraseña y nombre de DB
- **JWT**: Clave secreta para autenticación
- **Variables de entorno**: Configuración automática en `.env`

### 🚀 Automatización de Secretos:

El user data script automáticamente:
1. **Instala 1Password CLI** con repositorio oficial
2. **Configura el service account token** como variable de entorno
3. **Crea el archivo .env** con secretos reales de 1Password
4. **Configura persistencia** en `.bashrc` y `.bash_profile`

## 📋 Requisitos

Antes de ejecutar este proyecto, asegúrate de tener:

- Una cuenta de AWS y credenciales configuradas (por ejemplo, mediante `aws configure`)
- [Terraform instalado](https://developer.hashicorp.com/terraform/downloads)
- Una clave SSH generada para acceder a la instancia EC2
- **1Password CLI** instalado localmente
- **Service Account Token** de 1Password configurado
- **Secretos requeridos** creados en tu vault de 1Password

## 🔐 Clave SSH requerida

Es necesario contar con un par de llaves SSH (pública y privada) generadas previamente. La **clave pública** (`.pub`) debe colocarse en el **directorio raíz del proyecto**, con el siguiente nombre:

Este archivo se usará para registrar la clave en AWS y permitir el acceso a la instancia EC2 a través de SSH.

Ejemplo de generación de clave (si aún no la tienes):

```bash
ssh-keygen -t rsa -b 4096 -f leonard-tf-key
```

Esto generará dos archivos:

* `leonard-tf-key` → clave privada 

* `leonard-tf-key.pub` → clave pública (necesaria en este proyecto)

## 🚀 Uso

### **1. Configurar 1Password**:
```bash
# Configurar el token de service account
export TF_VAR_op_service_account_token=$(op read "op://Terraform/6behtiu53jvqlkh5w5b7ho72wy/credencial")
```

### **2. Inicializar Terraform**:
```bash
terraform init
```

### **3. Revisar el plan**:
```bash
terraform plan
```

### **4. Aplicar la infraestructura**:
```bash
terraform apply
```

## 🔍 Verificación del Sistema

Una vez conectado a la instancia, puedes verificar los detalles del sistema operativo y las dependencias instaladas:

### 📊 Información del Sistema Operativo:
```bash
# Ver la versión del sistema operativo
cat /etc/os-release

# Ver información detallada de Amazon Linux
cat /etc/system-release

# Ver la versión del kernel
uname -a

# Ver información de la distribución
cat /etc/redhat-release
```

### 📦 Dependencias Instaladas:
```bash
# Ver paquetes instalados con dnf
sudo dnf list installed

# Ver paquetes específicos instalados
sudo dnf list installed | grep -E "(git|dotnet|nodejs)"

# Ver información detallada de un paquete
sudo dnf info git
sudo dnf info dotnet-sdk-8.0
sudo dnf info nodejs
```

### 📋 Logs de Cloud-Init:
Para ver el proceso de instalación y configuración automática:

```bash
# Ver el log completo de cloud-init
sudo cat /var/log/cloud-init-output.log

# Ver solo las últimas líneas del log
sudo tail -f /var/log/cloud-init-output.log

# Ver logs de cloud-init en tiempo real
sudo journalctl -u cloud-init -f

# Ver el estado de cloud-init
sudo cloud-init status
```

### 💾 Verificación de Almacenamiento:
```bash
# Ver el espacio de disco disponible
df -h

# Ver información detallada de los volúmenes
lsblk

# Ver el uso de espacio en el directorio raíz
du -sh /*
```

### 🔐 Verificación de 1Password:
```bash
# Verificar que 1Password CLI está instalado
op --version

# Verificar que el token está configurado
echo $OP_SERVICE_ACCOUNT_TOKEN

# Leer secretos de prueba
op read "op://Terraform/Passwords SPC/Postgres username"
```

## 📁 Estructura del Proyecto
El proyecto está organizado siguiendo una arquitectura modular para facilitar su reutilización, mantenimiento y escalabilidad. La estructura de carpetas es la siguiente:

```bash 
terraform/
├── main.tf              # Archivo principal donde se orquestan los módulos
├── variables.tf         # Definición de variables globales utilizadas por los módulos
├── outputs.tf           # Exportación de salidas útiles (por ejemplo, IP pública de la instancia)
├── README.md            # Documentación del proyecto
├── leonard-tf-key.pub   # Clave pública SSH requerida (debe estar en la raíz)
├── scripts/
│   └── user_data.sh     # Script de configuración automática con 1Password
└── modules/             # Módulos reutilizables para componentes de infraestructura
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### Descripción de módulos
`vpc/`: Crea la red VPC con soporte para DNS.

`network/`: Define subredes públicas y privadas, gateway de internet, y ruteo.

`security/`: Establece reglas de seguridad para acceso SSH e ICMP (ping).

`ec2/`: Crea instancias EC2 utilizando una clave SSH y AMI dinámica (free tier elegible).

## Salida esperada después de aplicar los cambios a la infraestructura

```bash

module.ec2.aws_key_pair.key: Creating...
module.vpc.aws_vpc.this: Creating...
module.ec2.aws_key_pair.key: Creation complete after 0s [id=leonard-tf-key]
module.vpc.aws_vpc.this: Still creating... [00m10s elapsed]
module.vpc.aws_vpc.this: Creation complete after 12s [id=vpc-0862c8ae147b200df]
module.network.aws_internet_gateway.this: Creating...
module.network.aws_subnet.private: Creating...
module.network.aws_subnet.public: Creating...
module.security.aws_security_group.ssh_icmp: Creating...
module.network.aws_internet_gateway.this: Creation complete after 1s [id=igw-0b858ecce3e6808bd]
module.network.aws_route_table.public: Creating...
module.network.aws_subnet.private: Creation complete after 2s [id=subnet-0739a88fc03858268]
module.network.aws_route_table.public: Creation complete after 2s [id=rtb-0c0245e7ddbbd508d]
module.security.aws_security_group.ssh_icmp: Creation complete after 4s [id=sg-06cb261b9575d72ac]
module.network.aws_subnet.public: Still creating... [00m10s elapsed]
module.network.aws_subnet.public: Creation complete after 12s [id=subnet-036554ff114da3726]
module.network.aws_route_table_association.public_assoc: Creating...
module.ec2.aws_instance.server: Creating...
module.network.aws_route_table_association.public_assoc: Creation complete after 1s [id=rtbassoc-0851977bfe59ca778]
module.ec2.aws_instance.server: Still creating... [00m10s elapsed]
module.ec2.aws_instance.server: Creation complete after 14s [id=i-0518012082dfa2303]

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

ec2_public_ip = "3.237.188.221"

```
> NOTA: la ip es variable

## Conectarse a la instancia creada

```bash 
ssh -i "leonard-tf-key.pem" ec2-user@<ip-generada>
```

## 🔧 Comandos útiles

### Transferir una llave desde un servidor a otro
```bash
scp -i ec2-user.pem ec2-user.pem ec2-user@<public-IP>:~/
```

### Leer la llave privada directamente desde 1password
```bash
op read --out-file token.txt op://development/GitHub/credentials/personal_token
```

### Comando completo para transferir clave desde 1password
```bash
scp -i "leonard-tf-key.pem" $(op read --out-file leonard-tf-key.pem "op://Personal/tomsawyer-key/private key") ec2-user@44.203.219.213:~/
```

### Comando que funciona sin crear el archivo de salida intermedio
```bash
op read "op://Personal/tomsawyer-key/private key" | ssh -i leonard-tf-key.pem ec2-user@44.203.219.213 'cat > leonard-tf-key.pem'
```

### Configurar credenciales AWS desde 1password
```bash
export AWS_ACCESS_KEY_ID=$(op read "op://Personal/Tomsawyer aws/ACCES_KEY")
export AWS_SECRET_ACCESS_KEY=$(op read "op://Personal/Tomsawyer aws/SECRET_ACCES_KEY")
```

```
export AWS_ACCESS_KEY_ID=$(op read "op://Personal/Key Nodo G2/username")
export AWS_SECRET_ACCESS_KEY=$(op read "op://Personal/Key Nodo G2/password")
```

### Configurar token de 1Password para Terraform
```bash
export TF_VAR_op_service_account_token=$(op read "op://Terraform/6behtiu53jvqlkh5w5b7ho72wy/credencial")
```

## 💰 Costos y Free Tier

Este proyecto está diseñado para ser **gratis** durante el primer año de AWS Free Tier. Los recursos utilizados son:

- **VPC y Networking**: Gratis
- **2x t2.micro instances**: 750 horas/mes cada una (gratis)
- **EBS Storage**: 30 GB incluidos (gratis)
- **Data Transfer**: 15 GB de salida (gratis)

⚠️ **Importante**: Después del primer año o si excedes los límites del free tier, se aplicarán cargos estándar de AWS.

## 🔐 Seguridad y Mejores Prácticas

### **Gestión de Secretos**:
- ✅ **1Password CLI** para gestión segura de secretos
- ✅ **Service Account Token** para acceso programático
- ✅ **Variables sensibles** en Terraform
- ✅ **Sin secretos hardcodeados** en el código

### **Configuración de Red**:
- ✅ **VPC privada** para aislamiento de red
- ✅ **Security Groups** con reglas mínimas necesarias
- ✅ **Puertos específicos** habilitados (22, 3000)
- ✅ **EBS encriptado** para almacenamiento seguro

### **Monitoreo y Logs**:
- ✅ **Cloud-init logs** para debugging
- ✅ **Docker logs** para monitoreo de aplicaciones
- ✅ **Verificación de servicios** automática
