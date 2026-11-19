#!/bin/bash

# --- Colors for beautiful UI ---
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Configuration ---
BASE_DIR="/root/psiphon"
CONFIG_TEMPLATE="$BASE_DIR/psiphon.config"
START_PORT=1081
TOR_PORT=9050

# Supported regions
REGIONS=("AT" "BE" "CA" "CH" "CZ" "DE" "DK" "ES" "FI" "FR" "GB" "IE" "IN" "IT" "JP" "NL" "NO" "PL" "RO" "RS" "SE" "SG" "US")

# Function to calculate port for a given region
get_region_port() {
    local target_r="$1"
    local idx=0
    for r in "${REGIONS[@]}"; do
        if [ "$r" == "$target_r" ]; then
            echo $((START_PORT + idx))
            return
        fi
        ((idx++))
    done
    echo 0
}

show_header() {
    clear
    echo -e "${CYAN}==================================================================${NC}"
    echo -e "${BOLD}${PURPLE}              Psiphon & Tor Multi-Proxy Manager                   ${NC}"
    echo -e "${CYAN}==================================================================${NC}"
}

show_menu() {
    show_header
    echo -e "   ${BOLD}${YELLOW}MAIN MENU:${NC}"
    echo -e "   ${BLUE}1)${NC} Install Psiphon, Tor & Tools"
    echo -e "   ${BLUE}2)${NC} Enable ${GREEN}${BOLD}ALL${NC} Psiphon Regions"
    echo -e "   ${BLUE}3)${NC} Enable ${GREEN}SPECIFIC / MULTIPLE${NC} Psiphon Regions"
    echo -e "   ${BLUE}4)${NC} Disable ${RED}${BOLD}ALL${NC} Psiphon Regions"
    echo -e "   ${BLUE}5)${NC} Disable ${RED}SPECIFIC / MULTIPLE${NC} Psiphon Regions"
    echo -e "   ${CYAN}--------------------------------------------------------------${NC}"
    echo -e "   ${BLUE}6)${NC} Enable ${GREEN}${BOLD}Tor Proxy${NC} (Port: $TOR_PORT)"
    echo -e "   ${BLUE}7)${NC} Disable ${RED}${BOLD}Tor Proxy${NC}"
    echo -e "   ${CYAN}--------------------------------------------------------------${NC}"
    echo -e "   ${BLUE}8)${NC} ${BOLD}Live Status Dashboard${NC}"
    echo -e "   ${BLUE}9)${NC} ${RED}${BOLD}Uninstall Everything (100% Clean Cleanup)${NC}"
    echo -e "   ${BLUE}0)${NC} Exit"
    echo -e "${CYAN}==================================================================${NC}"
}

install_psiphon() {
    show_header
    echo -e "${YELLOW}[*] Preparing system installation...${NC}"
    
    sudo apt update -y && sudo apt install screen procps tor -y
    
    # Install කළ පසු Tor auto-start වීම නවතා ඔබට අවශ්‍ය විට පමණක් Enable කිරීමට සැකසීම
    sudo systemctl stop tor >/dev/null 2>&1
    sudo systemctl disable tor >/dev/null 2>&1

    if [ ! -d "$BASE_DIR" ]; then
        sudo mkdir -p "$BASE_DIR"
        echo -e "${YELLOW}[*] Downloading Psiphon Client Binary...${NC}"
        if [[ "$(uname -m)" == "x86_64" ]]; then
            sudo wget -4 -q --show-progress -O "$BASE_DIR/psiphon" 'https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/psiphon-x86_64'
        else
            sudo wget -4 -q --show-progress -O "$BASE_DIR/psiphon" 'https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/psiphon-aarch64'
        fi
        
        echo -e "${YELLOW}[*] Downloading Default Config...${NC}"
        sudo wget -4 -q --show-progress -O "$CONFIG_TEMPLATE" 'https://raw.githubusercontent.com/Thiyansa/psiphon-client/main/psiphon.config'
        
        sudo chmod +x "$BASE_DIR/psiphon"
        echo -e "\n${GREEN}[✓] Psiphon & Tor installed successfully!${NC}"
    else
        echo -e "\n${GREEN}[✓] Psiphon is already installed. Tor & tools verified!${NC}"
    fi
}

enable_tor() {
    show_header
    if ! command -v tor >/dev/null 2>&1; then
        echo -e "${RED}[!] Tor is not installed. Please run Option 1 first.${NC}"
        return
    fi

    echo -e "${YELLOW}[*] Enabling Tor Proxy on 127.0.0.1:$TOR_PORT...${NC}"
    sudo systemctl enable tor >/dev/null 2>&1
    sudo systemctl start tor
    sleep 1.5

    if systemctl is-active --quiet tor; then
        echo -e "${GREEN}[✓] Tor Proxy is now RUNNING on Port: ${BOLD}${CYAN}$TOR_PORT${NC}"
    else
        echo -e "${RED}[!] Failed to start Tor Proxy. Please check system logs.${NC}"
    fi
}

disable_tor() {
    show_header
    echo -e "${YELLOW}[*] Disabling Tor Proxy...${NC}"
    sudo systemctl stop tor >/dev/null 2>&1
    sudo systemctl disable tor >/dev/null 2>&1
    echo -e "${GREEN}[✓] Tor Proxy has been STOPPED & DISABLED.${NC}"
}

uninstall_psiphon() {
    show_header
    echo -e "${RED}${BOLD}[!] WARNING: This will STOP all running Psiphon screens, Tor Proxy and COMPLETELY DELETE all files!${NC}"
    read -rp "Are you absolutely sure you want to uninstall? (y/N): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n${YELLOW}[*] Step 1: Stopping all running Psiphon screen sessions...${NC}"
        for r in "${REGIONS[@]}"; do
            sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
        done
        sleep 1.5
        
        echo -e "${YELLOW}[*] Step 2: Stopping & Removing Tor Proxy...${NC}"
        sudo systemctl stop tor >/dev/null 2>&1
        sudo systemctl disable tor >/dev/null 2>&1
        sudo apt purge tor -y >/dev/null 2>&1
        sudo apt autoremove -y >/dev/null 2>&1

        echo -e "${YELLOW}[*] Step 3: Deleting directory $BASE_DIR and all subfolders...${NC}"
        if [ -d "$BASE_DIR" ]; then
            sudo rm -rf "$BASE_DIR"
        fi
        
        sudo screen -wipe >/dev/null 2>&1
        
        echo -e "\n${GREEN}[✓] Psiphon, Tor and all components have been uninstalled successfully! (VPS is 100% clean)${NC}"
    else
        echo -e "\n${YELLOW}[*] Uninstallation canceled.${NC}"
    fi
}

start_region() {
    local r="$1"
    local port=$(get_region_port "$r")
    
    if [ "$port" -eq 0 ]; then
        echo -e "${RED}[-] Invalid Region: $r${NC}"
        return
    fi

    local r_dir="$BASE_DIR/$r"
    sudo mkdir -p "$r_dir"

    local conf_file="$r_dir/psiphon.config"
    
    cp "$CONFIG_TEMPLATE" "$conf_file"
    sed -i "s/\"EgressRegion\":[[:space:]]*\"[^\"]*\"/\"EgressRegion\": \"$r\"/" "$conf_file"
    sed -i "s/\"LocalSocksProxyPort\":[[:space:]]*[0-9]*/\"LocalSocksProxyPort\": $port/" "$conf_file"

    sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
    sudo screen -dmS "psiphon_$r" bash -c "cd $r_dir && exec $BASE_DIR/psiphon -config $conf_file"
    
    echo -e "  - Region ${GREEN}$r${NC} enabled on Port: ${BOLD}${CYAN}$port${NC}"
    sleep 0.5 
}

start_all_regions() {
    show_header
    if [ ! -f "$CONFIG_TEMPLATE" ]; then
        echo -e "${RED}[!] Error: Template config not found. Please run Option 1 first.${NC}"
        return
    fi

    echo -e "${YELLOW}[*] Starting all ${#REGIONS[@]} regions safely. Please wait...${NC}"
    for r in "${REGIONS[@]}"; do
        start_region "$r"
    done
    echo -e "\n${GREEN}[✓] All requested regions initiated successfully!${NC}"
}

start_custom_regions() {
    show_header
    if [ ! -f "$CONFIG_TEMPLATE" ]; then
        echo -e "${RED}[!] Error: Template config not found. Please run Option 1 first.${NC}"
        return
    fi

    local stopped_regions=()
    for r in "${REGIONS[@]}"; do
        if ! sudo screen -list | grep -q "psiphon_$r"; then
            stopped_regions+=("$r")
        fi
    done

    if [ ${#stopped_regions[@]} -eq 0 ]; then
        echo -e "${GREEN}[✓] All regions are already RUNNING!${NC}"
        return
    fi

    echo -e "${BOLD}${YELLOW}Inactive/Stopped Regions:${NC} ${CYAN}${stopped_regions[*]}${NC}"
    echo -e "------------------------------------------------------------------"
    echo -e "Tips: Enter single region (e.g. ${GREEN}US${NC}) or multiple separated by comma (e.g. ${GREEN}US,GB,JP${NC})"
    echo
    read -rp "Enter region(s) to START: " input
    
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]' | tr -d ' ')
    
    if [ -z "$input" ]; then
        echo -e "${RED}[!] No regions specified.${NC}"
        return
    fi

    IFS=',' read -ra selected_arr <<< "$input"
    
    echo -e "\n${YELLOW}[*] Enabling selected regions...${NC}"
    for r in "${selected_arr[@]}"; do
        if [[ " ${REGIONS[*]} " =~ " ${r} " ]]; then
            start_region "$r"
        else
            echo -e "  - Region ${RED}$r${NC} is invalid or unsupported. ${YELLOW}Skipping...${NC}"
        fi
    done
}

stop_all_regions() {
    show_header
    echo -e "${YELLOW}[*] Disabling all Psiphon clients...${NC}"
    for r in "${REGIONS[@]}"; do
        sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
    done
    echo -e "${GREEN}[✓] All clients stopped successfully.${NC}"
}

stop_specific_region() {
    show_header
    
    local running_regions=()
    for r in "${REGIONS[@]}"; do
        if sudo screen -list | grep -q "psiphon_$r"; then
            running_regions+=("$r")
        fi
    done

    if [ ${#running_regions[@]} -eq 0 ]; then
        echo -e "${YELLOW}[!] No regions are currently running.${NC}"
        return
    fi

    echo -e "${BOLD}${GREEN}Active/Running Regions:${NC} ${CYAN}${running_regions[*]}${NC}"
    echo -e "------------------------------------------------------------------"
    echo -e "Tips: Enter single region (e.g. ${RED}US${NC}) or multiple separated by comma (e.g. ${RED}US,GB,JP${NC})"
    echo
    read -rp "Enter region(s) to STOP: " input
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]' | tr -d ' ')
    
    if [ -z "$input" ]; then
        echo -e "${RED}[!] No regions specified.${NC}"
        return
    fi

    IFS=',' read -ra selected_arr <<< "$input"
    echo -e "\n${YELLOW}[*] Disabling selected regions...${NC}"
    for r in "${selected_arr[@]}"; do
        if [[ " ${running_regions[*]} " =~ " ${r} " ]]; then
            sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
            echo -e "  - Region ${RED}$r${NC} disabled successfully."
        else
            echo -e "  - Region ${YELLOW}$r${NC} is not running or invalid. ${YELLOW}Skipping...${NC}"
        fi
    done
}

psiphon_status() {
    show_header
    
    # --- Tor Proxy Status Section ---
    echo -e "${BOLD}${YELLOW}┌────────────────┬──────┬────────────────┬───────────────┬────────────┐${NC}"
    echo -e "${BOLD}${YELLOW}│${NC} ${BOLD}SERVICE        ${NC}${BOLD}${YELLOW}│${NC} ${BOLD}PORT${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}TYPE           ${NC}${BOLD}${YELLOW}│${NC} ${BOLD}    STATUS    ${NC}${BOLD}${YELLOW}│${NC} ${BOLD}   PID     ${NC}${BOLD}${YELLOW}│${NC}"
    echo -e "${BOLD}${YELLOW}├────────────────┼──────┼────────────────┼───────────────┼────────────┤${NC}"
    
    if systemctl is-active --quiet tor; then
        local tor_pid=$(pgrep -x tor | head -n 1)
        printf "${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} %-4s ${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} \033[1;32m● RUNNING\033[0m     ${BOLD}${YELLOW}│${NC} %-10s ${BOLD}${YELLOW}│${NC}\n" "Tor Proxy" "$TOR_PORT" "SOCKS5" "${tor_pid:-Active}"
    else
        printf "${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} %-4s ${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} \033[1;31m○ STOPPED\033[0m     ${BOLD}${YELLOW}│${NC} %-10s ${BOLD}${YELLOW}│${NC}\n" "Tor Proxy" "$TOR_PORT" "SOCKS5" "N/A"
    fi
    echo -e "${BOLD}${YELLOW}└────────────────┴──────┴────────────────┴───────────────┴────────────┘${NC}\n"

    # --- Psiphon Regions Status Section ---
    echo -e "${BOLD}${YELLOW}┌────────┬──────┬────────────────┬───────────────┬────────────┐${NC}"
    echo -e "${BOLD}${YELLOW}│${NC} ${BOLD}REGION${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}PORT${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}SCREEN SESSION${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}    STATUS    ${NC}${BOLD}${YELLOW}│${NC} ${BOLD}   PID     ${NC}${BOLD}${YELLOW}│${NC}"
    echo -e "${BOLD}${YELLOW}├────────┼──────┼────────────────┼───────────────┼────────────┤${NC}"
    
    local port=$START_PORT
    for r in "${REGIONS[@]}"; do
        local session_name="psiphon_$r"
        local pid=""
        
        pid=$(sudo screen -ls | grep "$session_name" | cut -d. -f1 | awk '{print $1}' | head -n 1)
        
        if [ -n "$pid" ]; then
            printf "${BOLD}${YELLOW}│${NC} %-6s ${BOLD}${YELLOW}│${NC} %-4s ${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} \033[1;32m● RUNNING\033[0m     ${BOLD}${YELLOW}│${NC} %-10s ${BOLD}${YELLOW}│${NC}\n" "$r" "$port" "$session_name" "$pid"
        else
            printf "${BOLD}${YELLOW}│${NC} %-6s ${BOLD}${YELLOW}│${NC} %-4s ${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} \033[1;31m○ STOPPED\033[0m     ${BOLD}${YELLOW}│${NC} %-10s ${BOLD}${YELLOW}│${NC}\n" "$r" "$port" "$session_name" "N/A"
        fi
        ((port++))
    done
    
    echo -e "${BOLD}${YELLOW}└────────┴──────┴────────────────┴───────────────┴────────────┘${NC}"
    echo -e "\n${CYAN}Total Psiphon Regions: ${#REGIONS[@]} (Ports: $START_PORT+) | Tor Proxy Port: $TOR_PORT${NC}"
}

# Ensure root access
if [ "$EUID" -ne 0 ]; then
    echo -e "\n${RED}[!] You must run this script as the ROOT user! (Use sudo)${NC}\n"
    exit 1
fi

while true; do
    show_menu
    read -rp "Enter choice [0-9]: " OPTION
    case "$OPTION" in
        1) install_psiphon ;;
        2) start_all_regions ;;
        3) start_custom_regions ;;
        4) stop_all_regions ;;
        5) stop_specific_region ;;
        6) enable_tor ;;
        7) disable_tor ;;
        8) psiphon_status ;;
        9) uninstall_psiphon ;;
        0) echo -e "\n${GREEN}Thank you for using Psiphon & Tor Manager. Goodbye!${NC}\n"; exit 0 ;;
        *) echo -e "\n${RED}[!] Invalid option. Choose 0-9.${NC}" ;;
    esac
    echo
    read -rp "Press Enter to return to main menu..." _
done
