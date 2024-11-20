#!/bin/bash

# Função para verificar o sucesso da última operação
check_success() {
  if [ $? -ne 0 ]; then
    echo "Erro ao executar $1"
    exit 1
  fi
}

# Verifica se VirtualBox já está instalado
if command -v virtualbox &> /dev/null; then
  echo "VirtualBox já está instalado. Versão: $(virtualbox --help | grep 'VirtualBox VM')"
  if command -v vagrant &> /dev/null; then
    echo "Vagrant já está instalado. Versão: $(vagrant --version)"
  fi
  exit 0
fi

# Verifica se Vagrant já está instalado
if command -v vagrant &> /dev/null; then
  echo "Vagrant já está instalado. Versão: $(vagrant --version)"
  if command -v virtualbox &> /dev/null; then
    echo "VirtualBox já está instalado. Versão: $(virtualbox --help | grep 'VirtualBox VM')"
  fi
  exit 0
fi

# Atualiza a lista de pacotes
echo "Atualizando a lista de pacotes..."
sudo apt update
check_success "apt update"

# Instala dependências necessárias para adicionar repositórios
echo "Instalando dependências..."
sudo apt install -y curl gnupg apt-transport-https
check_success "dependências"

# Instalação do VirtualBox versão 7.0
echo "Instalando VirtualBox 7.0..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
check_success "chave do VirtualBox"
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
check_success "chave do VirtualBox"
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
check_success "repositório do VirtualBox"
sudo apt install -y virtualbox-7.0
check_success "VirtualBox 7.0"

# Instalação do Vagrant (última versão)
echo "Instalando a versão mais recente do Vagrant..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
check_success "chave do Vagrant"
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
check_success "repositório do Vagrant"
sudo apt install -y vagrant
check_success "Vagrant"

# Verificação das instalações
echo "Verificando versões instaladas..."
virtualbox --help | grep "VirtualBox VM"
vagrant --version

echo "Instalação do VirtualBox 7.0 e Vagrant concluída com sucesso."