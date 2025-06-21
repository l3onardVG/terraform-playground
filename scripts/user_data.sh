#!/bin/bash
echo "Actualizando el sistema"
sudo dnf update -y
echo "Instalando git"
sudo dnf install -y git
echo "Instalando dotnet"
sudo dnf install -y dotnet-sdk-8.0
echo "Instalando nodejs"
sudo dnf install -y nodejs 