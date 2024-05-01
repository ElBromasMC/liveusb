#!/bin/bash

YELLOW='\033[1;33m'
NC='\033[0m'

# List of all non-removable devices
DEVICES=$(sudo lsblk -d -n -o name,rm,rota,serial | awk '$2 == 0 && $3 == 1 {print $1,$4}')

echo -e "${YELLOW}Se procesaran los siguientes discos"
echo $DEVICES

# Loop the process for all device in devices
while read -r DEVICE SERIAL; do
    # Set the disk device
    DISK_DEVICE="/dev/$DEVICE"

    # Restore DCO to factory defaults
    echo -e "${YELLOW}Restaurando el DCO en el disco $DEVICE (${SERIAL})${NC}"
    sudo hdparm --yes-i-know-what-i-am-doing --dco-restore $DISK_DEVICE
    echo -e "\n"

    sleep 5

    # Verify if HPA is enabled
    echo -e "${YELLOW}Verificando la existencia de HPA en el disco $DEVICE (${SERIAL})${NC}"
    HPA_STATUS=$(sudo hdparm -N $DISK_DEVICE | grep -o "HPA is enabled")
    echo -e "\n"

    if [ -n "$HPA_STATUS" ]; then
        # Remove HPA
        echo -e "${YELLOW}Eliminando los sectores ocultos en el disco $DEVICE (${SERIAL})${NC}"
        sudo hdparm --yes-i-know-what-i-am-doing -N p$(sudo hdparm -N $DISK_DEVICE | grep -Po '\d+/\d+' | cut -d '/' -f 2) $DISK_DEVICE
        echo -e "\n\n\n"
    fi
done <<< "$DEVICES"

echo -e "${YELLOW}Se requiere un reinicio para continuar con el proceso, reiniciando en 5 segundos"
sleep 5
sudo reboot
