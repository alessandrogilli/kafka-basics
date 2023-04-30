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
    # Print menu with colored and formatted text
    echo "${BOLD}Select an option:${RESET}"
    echo "${GREEN}1.${RESET} Create topic"
    echo "${YELLOW}2.${RESET} List topics"
    echo "${RED}3.${RESET} Delete topic"
    echo "${BLUE}4.${RESET} Describe topic"
    echo "${MAGENTA}5.${RESET} List consumer groups"
    echo "${CYAN}6.${RESET} Describe consumer group"
    echo "${BOLD}0. Quit${RESET}"

    read choice

    printf "\n"

    case $choice in
        1) echo "Enter the name of the topic to create: "
           read topic_name
           echo "Enter the number of partition for the topic: "
           read partitions
           echo "${GREEN}Creating topic '$topic_name'...${RESET}"
           docker exec k-broker kafka-topics --create \
               --bootstrap-server localhost:9092 \
               --replication-factor 1 \
               --partitions "$partitions" \
               --topic "$topic_name";;

        2) echo "${YELLOW}Listing topics...${RESET}"
           docker exec k-broker kafka-topics --bootstrap-server localhost:9092 --list;;

        3) echo "Enter the name of the topic to delete: "
           read topic_name
           echo "${RED}Deleting topic '$topic_name'...${RESET}"
           docker exec k-broker kafka-topics --bootstrap-server localhost:9092 --delete --topic "$topic_name";;
           
        4) echo "Enter the name of the topic to describe: "
           read topic_name
           echo "${BLUE}Describing topic '$topic_name'...${RESET}"
           docker exec k-broker kafka-topics --bootstrap-server localhost:9092 --describe --topic "$topic_name";;

        5) echo "${MAGENTA}Listing consumer groups...${RESET}"
           docker exec k-broker kafka-consumer-groups --bootstrap-server localhost:9092 --list;;

        6) echo "Enter the name of the consumer group to describe:"
           read consumer_group_name
           echo "${CYAN}Describing consumer group '$consumer_group_name'...${RESET}"
           watch -n 1 docker exec k-broker kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group "$consumer_group_name";;

        0) echo "${BOLD}Exiting...${RESET}"
           exit;;

        *) echo "${RED}Invalid option${RESET}";;
        
    esac

    printf "Press enter to continue...\n"
    read 
done
