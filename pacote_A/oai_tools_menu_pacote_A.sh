#!/bin/bash

set -e

WORK_DIR=$PWD
LOG_DIR="$WORK_DIR/logs"
mkdir -p "$LOG_DIR"

TMUX_CONF_FILE="$HOME/.tmux.conf"
[[ ! -f "$TMUX_CONF_FILE" ]] && echo "set -g mouse on" > "$TMUX_CONF_FILE"

log_exec() {
    local log_name="$1"
    shift
    bash -c "$@" 2>&1 | tee "$LOG_DIR/${log_name}_$(date +%Y%m%d_%H%M%S).log"
}

function open_terminal() {
    TMUX_CONF_FILE="$HOME/.tmux.conf"
    [[ ! -f "$TMUX_CONF_FILE" ]] && echo "set -g mouse on" > "$TMUX_CONF_FILE"

    if [[ -n "$SSH_CONNECTION" ]]; then
        tmux new-session -d -s session_$2 "$1; echo -e '\n\nPressione qualquer tecla para sair...'; read -n 1 -s; exit"
        tmux attach-session -t session_$2
    else
        if [[ -n "$DISPLAY" && $XDG_SESSION_TYPE == "x11" ]]; then
            if command -v gnome-terminal &> /dev/null; then
                gnome-terminal -- bash -c "$1; echo -e '\n\nPressione qualquer tecla para sair...'; read -n 1 -s; exit" & disown
            else
                x-terminal-emulator -e bash -c "$1; echo -e '\n\nPressione qualquer tecla para sair...'; read -n 1 -s; exit" & disown
            fi
        else
            tmux new-session -d -s session_$2 "$1; echo -e '\n\nPressione qualquer tecla para sair...'; read -n 1 -s; exit"
            tmux attach-session -t session_$2
        fi
    fi
}

run_oai() {
    local option="$1"
    open_terminal "./core-scripts/oai_tools.sh $option" "$(echo $option | tr -d -- -)"
}

menu() {
    while true; do
        echo -e "\n===================== 🛠 \e[1;36m oai_tools Pacote_A \e[0m🛠 ====================="
        echo  "1) Instalar componentes Git, Docker e UHD"
        echo  "3) Modo performance 🚀"
        echo  "4) Dependências 5GC"
        echo  "5) Dependências RAN"
        #echo  "6) Iniciar Core 5G - Pacote_E - local"
        echo  "7) Iniciar Core 5G macvlan - pacote_A:DNN lanceA"
        echo  "9) Logs Core 5G - amf-A"
        echo "11) Parar Core 5G"
        echo "========================================================"
        echo "13) Instalar FlexRIC"
        echo "14) Iniciar nearRT-RIC"
        echo "15) Iniciar E2 Node Agent"
        echo "16) Iniciar gNB rfsim"
        echo "17) Iniciar UE rfsim"
        echo "18) Iniciar xApps"
        echo "========================================================"
        echo "22) Iniciar gNB Pacote_A - MIMO_2x2 51_PRBs"
        echo "========================================================"
        echo -e "26) \e[1;31mSair\e[0m"

        read -p "Escolha uma opção: " opt
        case $opt in
            1) run_oai --install ;;
            2) run_oai --install_UHD ;;
            3) run_oai --performance ;;
            4) run_oai --install_5g_core ;;
            5) run_oai --install_5g_ran ;;
            6) run_oai --start_5g_mono ;;
            7) run_oai --start_5g_macvlan ;;
            8) run_oai --start_4g ;;
            9) run_oai --logs_5g ;;
            10) run_oai --logs_4g ;;
            11) run_oai --stop_5g ;;
            12) run_oai --stop_4g ;;
            13) run_oai --FlexRIC ;;
            14) run_oai --start_nearRT-RIC ;;
            15) run_oai --start_E2Agent ;;
            16) run_oai --start_gNB_rfsim ;;
            17) run_oai --start_UE_rfsim ;;
            18) run_oai --xApps ;;
            22) run_oai --gNB_n106 ;;
            26) echo "Saindo..."; break ;;
            *) echo "Opção inválida!" ;;
        esac
    done
}

menu
