# Proyecto Terraform - Infraestructura en AWS

Este proyecto define y despliega una infraestructura básica en AWS utilizando Terraform. Incluye la creación de una VPC, subredes públicas y privadas, un gateway de Internet, una tabla de ruteo, un grupo de seguridad y una instancia EC2 accesible por SSH.

## 📋 Requisitos

Antes de ejecutar este proyecto, asegúrate de tener:

- Una cuenta de AWS y credenciales configuradas (por ejemplo, mediante `aws configure`)
- [Terraform instalado](https://developer.hashicorp.com/terraform/downloads)
- Una clave SSH generada para acceder a la instancia EC2

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


1. Inicializa Terraform:

```bash
terraform init
```
2. Revisa el plan de ejecución:

```bash
terraform plan
```
3. Aplica la infraestructura

```bash
terraform apply
```



📁 Estructura del Proyecto
El proyecto está organizado siguiendo una arquitectura modular para facilitar su reutilización, mantenimiento y escalabilidad. La estructura de carpetas es la siguiente:

bash

```bash 
terraform/
├── main.tf              # Archivo principal donde se orquestan los módulos
├── variables.tf         # Definición de variables globales utilizadas por los módulos
├── outputs.tf           # Exportación de salidas útiles (por ejemplo, IP pública de la instancia)
├── README.md            # Documentación del proyecto
├── leonard-tf-key.pub   # Clave pública SSH requerida (debe estar en la raíz)
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

`ec2/`: Crea una instancia EC2 utilizando una clave SSH y las configuraciones definidas.