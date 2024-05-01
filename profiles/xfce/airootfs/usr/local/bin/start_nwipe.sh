#!/bin/bash
DEFAULT_DESKTOP=$(xdg-user-dir DESKTOP)
PC_SERIES=$(sudo dmidecode -s system-serial-number)
if [ -z "$PC_SERIES" ]; then
    PC_SERIES="SIN_SERIE"
fi
DEFAULT_LOG_DIRECTORY=$DEFAULT_DESKTOP/nwipe_logs/$PC_SERIES

sudo mkdir -p $DEFAULT_LOG_DIRECTORY
cd $DEFAULT_LOG_DIRECTORY
filename=nwipe_$(date +"%Y%m%d%H%M%S%3N").log
sudo nwipe --method=ops2 --logfile=$filename --rounds=1 --nousb --nowait

sudo mkdir -p /boot/Certificados
sudo cp -rf $DEFAULT_DESKTOP/nwipe_logs/$PC_SERIES /boot/Certificados