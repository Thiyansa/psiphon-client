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
    echo -e "${BOLD}${PURPLE}                    Psiphon Multi-Client Manager                  ${NC}"
    echo -e "${CYAN}==================================================================${NC}"
}

show_menu() {
    show_header
    echo -e "   ${BOLD}${YELLOW}MAIN MENU:${NC}"
    echo -e "   ${BLUE}1)${NC} Install Psiphon & Tools"
    echo -e "   ${BLUE}2)${NC} Start ${GREEN}ALL${NC} Regions"
    echo -e "   ${BLUE}3)${NC} Start ${YELLOW}SELECTED${NC} Regions (Custom)"
    echo -e "   ${BLUE}4)${NC} Stop ${RED}ALL${NC} Regions"
    echo -e "   ${BLUE}5)${NC} Stop ${RED}SPECIFIC${NC} Region"
    echo -e "   ${BLUE}6)${NC} ${BOLD}Live Status Dashboard${NC}"
    echo -e "   ${BLUE}7)${NC} ${RED}${BOLD}Uninstall Psiphon (Full Clean)${NC}"
    echo -e "   ${BLUE}8)${NC} Exit"
    echo -e "${CYAN}------------------------------------------------------------------${NC}"
}

install_psiphon() {
    show_header
    echo -e "${YELLOW}[*] Preparing system installation...${NC}"
    
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
        echo -e "${YELLOW}[*] Installing dependencies (screen, procps)...${NC}"
        sudo apt update -y && sudo apt install screen procps -y
        
        echo -e "\n${GREEN}[✓] Psiphon client installed successfully!${NC}"
    else
        echo -e "${YELLOW}[!] Psiphon is already installed.${NC}"
    fi
}

uninstall_psiphon() {
    show_header
    echo -e "${RED}${BOLD}[!] WARNING: This will STOP all running Psiphon screens and COMPLETELY DELETE all files & folders!${NC}"
    read -rp "Are you absolutely sure you want to uninstall? (y/N): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n${YELLOW}[*] Step 1: Stopping all running Psiphon screen sessions...${NC}"
        for r in "${REGIONS[@]}"; do
            # Screen එක පිරිසිදුව quit කරලා දානවා
            sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
        done
        # සේරම screen quit වෙන්න පොඩි වෙලාවක් දෙනවා
        sleep 1
        
        echo -e "${YELLOW}[*] Step 2: Deleting directory $BASE_DIR and all subfolders...${NC}"
        if [ -d "$BASE_DIR" ]; then
            sudo rm -rf "$BASE_DIR"
        fi
        
        # Screen sessions ලිස්ට් එක refresh කරනවා
        sudo screen -wipe >/dev/null 2>&1
        
        echo -e "\n${GREEN}[✓] Psiphon and all its components have been uninstalled successfully! (System is clean)${NC}"
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
    
    echo -e "  - Region ${GREEN}$r${NC} started on Port: ${BOLD}${CYAN}$port${NC}"
    
    sleep 0.5 
}

start_all_regions() {
    show_header
    if [ ! -f "$CONFIG_TEMPLATE" ]; then
        echo -e "${RED}[!] Error: Template config not found. Please run Option 1 first.${NC}"
        return
    fi

    echo -e "${YELLOW}[*] Starting all ${#REGIONS[@]} regions safely with isolated environments. Please wait...${NC}"
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

    echo -e "Available Regions: ${CYAN}${REGIONS[*]}${NC}"
    echo
    read -rp "Enter regions to start (comma-separated, e.g., US,GB,JP,IN): " input
    
    input=$(echo "$input" | tr '[:lower:]' '[:upper:]' | tr -d ' ')
    
    if [ -z "$input" ]; then
        echo -e "${RED}[!] No regions specified.${NC}"
        return
    fi

    IFS=',' read -ra selected_arr <<< "$input"
    
    echo -e "\n${YELLOW}[*] Starting selected regions safely...${NC}"
    for r in "${selected_arr[@]}"; do
        if [[ " ${REGIONS[*]} " =~ " ${r} " ]]; then
            start_region "$r"
        else
            echo -e "  - Region ${RED}$r${NC} is invalid. ${YELLOW}Skipping...${NC}"
        fi
    done
    echo -e "\n${GREEN}[✓] Custom regions configuration loaded!${NC}"
}

stop_all_regions() {
    show_header
    echo -e "${YELLOW}[*] Stopping all Psiphon clients...${NC}"
    for r in "${REGIONS[@]}"; do
        sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
    done
    echo -e "${GREEN}[✓] All clients stopped.${NC}"
}

stop_specific_region() {
    show_header
    read -rp "Enter region to STOP (e.g., US): " r
    r=$(echo "$r" | tr '[:lower:]' '[:upper:]' | tr -d ' ')
    
    if [[ " ${REGIONS[*]} " =~ " ${r} " ]]; then
        sudo screen -S "psiphon_$r" -X quit >/dev/null 2>&1
        echo -e "${GREEN}[✓] Region $r has been stopped successfully.${NC}"
    else
        echo -e "${RED}[!] Invalid region name.${NC}"
    fi
}

psiphon_status() {
    show_header
    
    # Header Table Border
    echo -e "${BOLD}${YELLOW}┌────────┬──────┬────────────────┬───────────────┬────────────┐${NC}"
    echo -e "${BOLD}${YELLOW}│${NC} ${BOLD}REGION${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}PORT${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}SCREEN SESSION${NC} ${BOLD}${YELLOW}│${NC} ${BOLD}    STATUS    ${NC}${BOLD}${YELLOW}│${NC} ${BOLD}   PID     ${NC}${BOLD}${YELLOW}│${NC}"
    echo -e "${BOLD}${YELLOW}├────────┼──────┼────────────────┼───────────────┼────────────┤${NC}"
    
    local port=$START_PORT
    for r in "${REGIONS[@]}"; do
        local session_name="psiphon_$r"
        local pid=""
        
        pid=$(sudo screen -ls | grep "$session_name" | cut -d. -f1 | awk '{print $1}' | head -n 1)
        
        if [ -n "$pid" ]; then
            # Color string එක කලින් සාදාගන්නවා
            local status_str="${GREEN}● RUNNING${NC}"
            # Alignment එක හරියන්න spaces ප්‍රමාණය ගණනය කර ප්‍රින්ට් කිරීම
            printf "${BOLD}${YELLOW}│${NC} %-6s ${BOLD}${YELLOW}│${NC} %-4s ${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} %b     ${BOLD}${YELLOW}│${NC} %-10s ${BOLD}${YELLOW}│${NC}\n" "$r" "$port" "$session_name" "$status_str" "$pid"
        else
            local status_str="${RED}○ STOPPED${NC}"
            printf "${BOLD}${YELLOW}│${NC} %-6s ${BOLD}${YELLOW}│${NC} %-4s ${BOLD}${YELLOW}│${NC} %-14s ${BOLD}${YELLOW}│${NC} %b     ${BOLD}${YELLOW}│${NC} %-10s ${BOLD}${YELLOW}│${NC}\n" "$r" "$port" "$session_name" "$status_str" "N/A"
        fi
        ((port++))
    done
    
    # Bottom Table Border
    echo -e "${BOLD}${YELLOW}└────────┴──────┴────────────────┴───────────────┴────────────┘${NC}"
    echo -e "\n${CYAN}Total Available Regions: ${#REGIONS[@]} | Starting Port: $START_PORT${NC}"
}

# Ensure root access
if [ "$EUID" -ne 0 ]; then
    echo -e "\n${RED}[!] You must run this script as the ROOT user! (Use sudo)${NC}\n"
    exit 1
fi

while true; do
    show_menu
    read -rp "Enter choice [1-8]: " OPTION
    case "$OPTION" in
        1) install_psiphon ;;
        2) start_all_regions ;;
        3) start_custom_regions ;;
        4) stop_all_regions ;;
        5) stop_specific_region ;;
        6) psiphon_status ;;
        7) uninstall_psiphon ;;
        8) echo -e "\n${GREEN}Thank you for using Psiphon Manager. Goodbye!${NC}\n"; exit 0 ;;
        *) echo -e "\n${RED}[!] Invalid option. Choose 1-8.${NC}" ;;
    esac
    echo
    read -rp "Press Enter to return to main menu..." _
done
