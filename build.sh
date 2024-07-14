#!/bin/bash
green='\033[1;32m'
cyan='\033[1;36m'
red='\033[1;31m'
noColor='\033[0m'
test=true

echo -e "${cyan}Welcome to the NixBuild script.${noColor}"
sleep 1

cd ~/nixconf

until [ "${test}" = false ]; do

    echo -e "${cyan}Would you like to test? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
    read -n 1 test

    if [ "${test}" = "n" ]; then
        test=false
    else
        echo -e "${green}Adding all to working directory.${noColor}"
        git add . 

        echo -e "${green}Formatting Nix code.${noColor}"
        alejandra .

        rm ${HOME}/.gtkrc-2.0 #removing the backup of the annoying file :(

        nh os test
    fi
done

echo -e "\n${green}Please write commit message: ${noColor}"
read commitmsg

echo -e "${cyan}Switch now or at boot? [${red}switch${cyan}/${green}boot${cyan}]${noColor}"
read switch

echo -e "${cyan}Update? [${red}y${cyan}/${green}N${cyan}]${noColor}"
read -n 1 update

rm ${HOME}/.gtkrc-2.0

if [ "${update}" = "y" ]; then
    nh os ${switch} --update --ask #asks so you dont get shocked by everything restarting
else
    nh os ${switch}
fi

git commit -a -m "${commitmsg}"

echo -e "${cyan}Would you like to push your changes? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
read -n 1 push
push=${push:-"y"} #sets default value to yes

if [ "${push}" = "y" ]; then
    git push
fi

echo -e "${green}Cleaning NixOS.${noColor}"
nh clean all --keep 5 --ask #asking so i can verify it doesn't do smthn i dont want

exit