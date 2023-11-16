#!/bin/bash
##########################################
####Copyright: BluePlanet Organization####
###########Author: RizeKishimaro##########
##########################################
read -p "SoundFile Directory~> " sound_files

read -p "Extension to be Check~> " ext

for file in "$sound_files"/*$ext; do
    if [ -f "$file" ]; then
        wav_length=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")
        millie_second=$(awk -v d="$wav_length" 'BEGIN { print d * 1000 + 15 }'| cut -f1 -d"." )
        echo -e "$file length is $millie_second \n"
    fi
done

figlet "GoodBye"
