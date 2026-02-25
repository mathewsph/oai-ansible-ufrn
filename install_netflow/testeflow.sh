#!/bin/bash
apt update && apt install tcpdump -y

tcpdump -i any -n -l -tttt '(tcp or udp) and (host 10.20.0.2 or net 12.1.1.0/24)' | awk '
function print_report() {
    if (contagem > 0) {
        report_ts = last_packet_date " " current_second_marker;
        for (fluxo in bytes_count) {
            # Extrai os componentes do ID do fluxo
            split(fluxo, partes, " ");
            src_full = partes[1];
            dst_full = partes[3];

            # Separa IP e porta de origem
            n_src = split(src_full, src, ".");
            porta_origem = src[n_src];
            ip_origem = src[1];
            for(i=2; i < n_src; i++) ip_origem = ip_origem "." src[i];

            # Separa IP e porta de destino
            n_dst = split(dst_full, dst, ".");
            porta_destino = dst[n_dst];
            ip_destino = dst[1];
            for(i=2; i < n_dst; i++) ip_destino = ip_destino "." dst[i];

            # Imprime a linha do CSV
            print report_ts, ip_origem, porta_origem, ip_destino, porta_destino, fluxo, bytes_count[fluxo];
        }
    }
}
BEGIN {
    OFS=",";
    print "timestamp,ip_origem,porta_origem,ip_destino,porta_destino,id_fluxo,bytes_no_intervalo";
    current_second_marker = "";
    contagem = 0;
}
/IP/ && /length/ {
    packet_date = $1;
    split($2, time_parts, ".");
    packet_second = time_parts[1];

    if (current_second_marker == "") {
        current_second_marker = packet_second;
    }

    if (packet_second != current_second_marker) {
        print_report();
        delete bytes_count;
        current_second_marker = packet_second;
        contagem = 0;
    }

    last_packet_date = packet_date;
    gsub(/:$/, "", $6);
    fluxo_id = $4 " > " $6;
    
    packet_length = 0;
    for (i=NF; i>0; i--) {
        if ($i == "length") {
            packet_length = $(i+1);
            break;
        }
    }

    if (packet_length > 0) {
        bytes_count[fluxo_id] += packet_length;
        contagem++;
    }
}
END {
    print_report();
}
' > relatorio_filtrado2.csv
