#!/bin/bash

#!/bin/bash

# Este script automatiza a instalação, configuração e teste das ferramentas softflowd e nfdump.

# 1. Atualiza a lista de pacotes e instala pacotes essenciais
echo "Atualizando a lista de pacotes e instalando certificados..."
apt-get update
apt-get install -y ca-certificates

# 2. Atualiza a lista de pacotes e instala softflowd, vim e nfdump
echo "Atualizando a lista de pacotes novamente e instalando softflowd, vim e nfdump..."
apt-get update
apt-get upgrade python3 -y
apt-get install python3-pip libpcap-dev vim -y

#3. Instala e atualiza os pacotes relacionados ao python3-pip

apt-get install python3-pip -y
python3 -m pip install --upgrade pip
pip3 install --upgrade cryptography
pip3 install scapy
