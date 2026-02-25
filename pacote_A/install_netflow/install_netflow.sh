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
apt install softflowd vim nfdump -y

# 3. Configura o softflowd para usar a interface 'tun0'
echo "Configurando o softflowd para a interface tun0..."
sed -i 's/^INTERFACE=""/INTERFACE="tun0"/' /etc/default/softflowd

# 4. Configura o softflowd para enviar fluxos para 127.0.0.1:2055
echo "Configurando o softflowd para enviar fluxos para 127.0.0.1:2055..."
sed -i "s/^OPTIONS=\"\"/OPTIONS='-n 127.0.0.1:2055'/" /etc/default/softflowd

# 5. Inicia e verifica o status do serviço softflowd
echo "Iniciando e verificando o status do softflowd..."
/etc/init.d/softflowd start
/etc/init.d/softflowd status

# 6. Cria o diretório de log para o nfdump
echo "Criando o diretório de log para o nfdump..."
mkdir -p /var/log/nfdump

# 7. Inicia o nfcapd para coletar os fluxos NetFlow
echo "Iniciando o nfcapd para coletar os fluxos..."
nfcapd -w -D -l /var/cache/nfdump/ -p 2055 -t 60

# 8. Inicia o softflowd com os parâmetros de coleta
echo "Iniciando o softflowd com os parâmetros de coleta..."
softflowd -i tun0 -n 127.0.0.1:2055 -D

# 9. Exemplo de uso do nfdump para ler e filtrar um arquivo de fluxo
# Nota: O nome do arquivo 'nfcapd.202508272005' deve ser alterado, pois ele é dinâmico (com base na data e hora da captura)
#echo "Exemplo de comando de leitura e filtro com nfdump..."
# Este comando é apenas um exemplo e pode não funcionar sem um arquivo de fluxo com o nome exato.
#nfdump -r /var/cache/nfdump/nfcapd.202508272005 "src ip 10.20.0.2 and dst ip 12.1.1.4 or src ip 12.1.1.4 and dst ip 10.20.0.2"

echo "Script concluído."
~                           