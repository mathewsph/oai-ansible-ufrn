from scapy.all import sniff, wrpcap
from datetime import datetime

# Substitua 'tun0' pelo nome da sua interface de rede
interface = "tun0"

# O filtro de captura
filtro = "net 12.1.1.0/24"

# O nome do arquivo de saída
arquivo_saida = "captura_de_trafego.pcap"

print(f"Iniciando a captura na interface '{interface}' com o filtro '{filtro}' por 300 segundos (5 minutos)...")

# A função sniff irá capturar pacotes por 30 segundos
pacotes_capturados = sniff(iface=interface, filter=filtro, timeout=300)

print(f"\nCaptura concluida. Foram capturados {len(pacotes_capturados)} pacotes.")

# --- Novo Bloco de Código ---
print("\n--- Detalhes dos pacotes capturados ---")
if pacotes_capturados:
    for i, pacote in enumerate(pacotes_capturados, 1):
        # O timestamp do pacote é um atributo 'time' em formato Unix
        timestamp_unix = pacote.time
        # Converte o timestamp Unix para um formato legível
        data_hora = datetime.fromtimestamp(timestamp_unix).strftime('%Y-%m-%d %H:%M:%S.%f')
        
        # A quantidade de bytes é obtida com a função len()
        tamanho_bytes = len(pacote)
        
        # Exibe as informações
        print(f"Pacote {i}:")
        print(f"  Timestamp: {data_hora}")
        print(f"  Tamanho: {tamanho_bytes} bytes")
        print(f"  Resumo: {pacote.summary()}")
        print("-" * 30)

# --- Fim do Novo Bloco ---

# Salva a lista de pacotes no arquivo .pcap
wrpcap(arquivo_saida, pacotes_capturados)

print(f"\nPacotes salvos com sucesso no arquivo '{arquivo_saida}'.")

