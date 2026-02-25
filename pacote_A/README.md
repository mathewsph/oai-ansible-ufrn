# Pacote A

<div style="display: flex; align-items: center;">
  <img src="https://openairinterface.org/wp-content/uploads/2020/11/cropped-oai_final_logo-trans.png" width="280px">
</div>


---

![Pacote_A](../../docs/figs/Pacote_A.png)

## Instruções Rápidas de Implantação do OpenAirInterface do Pacote A

### Se logar no Servidor Artemis:

```bash
ssh lancetelecom@192.168.160.5
```

#### Baixar repositório:

```bash
git clone https://github.com/lance-ufrn/lsu-oai-advanced.git
```
ou 

```bash
git clone git@github.com:lance-ufrn/lsu-oai-advanced.git
```

#### Instalar dependências do Pacote A

> ⚠️ Se for a primeira instalação é necessário instalar as dependências do OAI, para isso execute o script `oai_tools_menu.sh`, na pasta principal do repositório.

```bash
cd lsu-oai-advanced/
```

```bash
./oai_tools_menu.sh
```

> ⚠️ Execute as opções 1, 3 e 4.

```bash
===================== 🛠  oai_tools 🛠 =====================
1) Instalar componentes Git, Docker e UHD
3) Modo performance 🚀
4) Dependências 5GC e RAN
```

> Após concluir a instalação das dependências, deve-se copiar os conteúdo da pasta `core-scripts`, presente no endereço `lsu-oai-advanced/pacotes_maestro/pacote_A/` para a pasta `core-scripts` do diretório principal do repositório.

> Isso feito, já podemos iniciar o OAI 5GC.

### Iniciar o OAI 5GC

> Primeiramente selecione a opção 7 do `oai_tools_menu.sh`. 

```bash
===================== 🛠  oai_tools 🛠 =====================
7) Iniciar Core 5G Macvlan
```
Após o deployment dos containers do 5GC, aperte Ctrl+C e ative os logs do container oai-amf-A. 

```bash
docker logs -f oai-amf-A
```

> Após esta ação, espera-se o seguinte resultado:

![AMF](../../docs/figs/amf_pacote_a.png)

### Iniciar gNB

> Logar no Desktop Bell:

```bash
ssh lancetelecom@172.31.0.56
```

#### Baixar repositório:

```bash
git clone https://github.com/lance-ufrn/lsu-oai-advanced.git
```
ou 

```bash
git clone git@github.com:lance-ufrn/lsu-oai-advanced.git
```

#### Instalar dependências da gNB

> ⚠️ Se for a primeira instalação é necessário instalar as dependências do OAI, para isso execute o script `oai_tools_menu.sh`, na pasta principal do repositório.

```bash
cd lsu-oai-advanced/
```

```bash
./oai_tools_menu.sh
```

> ⚠️ Execute as opções 1, 3 e 4.

```bash
===================== 🛠  oai_tools 🛠 =====================
1) Instalar componentes Git, Docker e UHD
3) Modo performance 🚀
4) Dependências 5GC e RAN
```

> Após concluir a instalação das dependências já podemos iniciar a gNB. Abra um terminal na pasta principal do repositório e acesse a seguinte pasta:

```bash
cd openairinterface5g/cmake_targets/ran_build/build
```

Execute o comando abaixo:

```bash
sudo ./nr-softmodem -E --sa -O /home/lancetelecom/lsu-oai-advanced/pacotes_maestro/pacote_A/conf_gnb/gnb.51PRBs.mimo2x2.usrpb210.pacoteA.conf --gNBs.[0].min_rxtxtime 6 --continuous-txd
```
Espera-se o seguinte comportamento no terminal de logs do core: 

![gNB_Connected](../../docs/figs/amf_pacote_a_2.png)

### Conectando UE

Com o 5GC e a gNB funcionando, agora se pode tirar o Moto G50 do modo avião. Esse celular deve possuir um SIM Card do UE configurado com o seguinte IMSI: `001010000000002`

> O UE receberá o seguinte IP: `10.44.0.2`

O comportamento esperado no log do core corresponde ao da figura abaixo:

![UE_Connected](../../docs/figs/amf_pacote_a_3.png)

### Encerrar os processos.

> Para derrubar a gNB basta apertar Ctrl+C em seu terminal, ou simplesmente fecha-lo.

> Para encerrar o core, deve-se abrir o script `oai_tools_menu.sh` no terminal aberto no servidor Artemis e então selecionar a opção 11.

```bash
===================== 🛠  oai_tools 🛠 =====================
11) Parar Core 5G
```
