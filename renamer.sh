#!/bin/bash
##########################################
####Copyright: BluePlanet Organization####
###########Author: RizeKishimaro##########
##########################################
spinner() {
    local pid=$1
    local delay=0.2
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
  }
handle_SIGINT(){
  echo -e "\n\nGOODBYE XD"
}

trap 'handle_SIGINT;exit' INT
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
os_name=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')

  if [ "$os_name" == "Ubuntu" ]; then
      echo "🐨 Operating system is Ubuntu"
      sleep 1 & spinner $!
    if which ffmpeg >/dev/null 2>&1; then
        echo "🟢 FFmpeg is installed.Skipping ................"
        sleep 1 & spinner $!
    else
        echo "🟢 FFmpeg is not installed.Installing ................"
        sudo apt install ffmpeg >/dev/null &
        spinner $!
    fi
    echo "🐋 Installation Successfully completed Jumping to Figlet installation"

    # Check if Deno is installed
    if which figlet >/dev/null 2>&1; then
        echo "🥟 Figlet is installed.Skipping ................"
        sleep 1 & spinner $!
    else
        echo "🥟 Figlet is not installed.Installing ................"
        sudo apt install figlet >/dev/null &
        spinner $!
    fi
  elif [ "$os_name" == "CentOS Linux" ]; then
    echo "🎭 Operating system is CentOS.Checkig base Packages"
    yum install -y gcc-c++ make >/dev/null 2>&1 &
    spinner $!
    if which ffmpeg >/dev/null 2>&1; then
        echo "🟢 FFmpeg is installed.Skipping ................"
        sleep 1 & spinner $!
    else
        echo "🟢 FFmpeg is not installed.Installing ................"
        sudo yum install epel-release
        sudo yum localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
        sudo yum install figlet
    fi
  else
    echo "Unsupported operating system: $os_name"
    exit 1
  fi

clear
figlet "RENAMER"
echo "WAV Converter......"
echo "Version 0.1.1"
read -p "Directory to be Change~> " source_directory

read -p "Destiantion Directory~> " destination_directory

read -p "Extension to be Change~> " ext

read -p "Volume to be set~> " volume_adjustment
mkdir -p "$destination_directory"



for file in "$source_directory"/*$ext; do
  echo $file
  if [[ -f "$file" && "${file##*.}" == "mp3" ]]; then
    current_filename=$(basename -- "$file")

    echo "Enter a custom name for the processed file '$current_filename' (without extension):"
    read custom_name

    output_filepath="$destination_directory/$custom_name.wav"

    ffmpeg -i "$file" -af "volume=$volume_adjustment" -b:a 64k -ac 1 -sample_fmt s16 -ar 8000 "$output_filepath" > /dev/null 2>&1
    clear
    echo "File '$current_filename' processed and saved as '$custom_name.wav' in '$destination_directory'"
  elif [[ -f "$file" && "${file##*.}" == "wav" ]]; then
        current_filename=$(basename -- "$file")

        echo "Enter a custom name for the processed file '$current_filename' (without extension):"
        read -p "Name~> " custom_name

        output_filepath="$destination_directory/$custom_name$ext"

        ffmpeg -i "$file" -af "volume=$volume_adjustment" -b:a 64k -ac 1 -sample_fmt s16 -ar 8000 "$output_filepath" > /dev/null 2>&1


        clear
        echo "File '$current_filename' processed and saved as '$custom_name$ext' in '$destination_directory'"
    else
      echo "Unsupported File"
      exit 1
    fi
done

figlet "GoodBye"
