#!/bin/bash

# Define colors and formatting using ANSI escape codes
BOLD=$(tput bold)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

while true; do
    echo "${BOLD}Select an option:${RESET}"
    echo "${GREEN}1.${RESET} Start Producer"
    echo "${YELLOW}2.${RESET} Start Consumer"
    echo "${BLUE}3.${RESET} Start Consumer from Consumer Group (mygroup)"
    echo "${BOLD}0. Quit${RESET}"

    read choice

    case $choice in
        1) if [ -e producing ]; then
               echo "${RED}Producer already running${RESET}"
           else
               echo "${GREEN}Starting producer...${RESET}"
               touch producing
               docker exec -it k-python python producer.py
               rm producing
           fi
           ;;
        2) echo "${BLUE}Starting consumer...${RESET}"
           docker exec -it k-python python consumer.py
           ;;
        3) echo "${BLUE}Starting consumer...${RESET}"
           docker exec -it k-python python consumer.py --group_id mygroup
           ;;
        0) echo "Exiting..."
           exit;;
        *) echo "Invalid option";;
    esac
done
