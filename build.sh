#!/bin/bash
green='\033[1;32m'
cyan='\033[1;36m'
red='\033[1;31m'
noColor='\033[0m'

fCommit() {
    echo -e "\n${green}Please write commit message: ${noColor}"
    read commitmsg
    git commit -a -m "${commitmsg}"
}
echo -e "${cyan}Welcome to the NixBuild script.${noColor}"
sleep 1

cd ~/nixconf

select testType in "Build Test" "Flake Update Test"
do
    case $testType in
        "Build Test")
            until [ "${test}" = "n" ]; do
                    echo -e "${green}Adding all to working directory.${noColor}"
                    git add . 

                    echo -e "${green}Formatting Nix code.${noColor}"
                    alejandra .

                    rm ${HOME}/.gtkrc-2.0 #removing the backup of the annoying file :(
                    
                    echo -e "${green}Running build test.${noColor}"
                    nh os test

                    echo -e "${cyan}Would you like to commit the changes? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
                    read -n 1 commit
                    if [ "${commit}" != "n" ]; then
                        fCommit
                    fi

                echo -e "${cyan}Would you like to test again? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
                read -n 1 test
            done
        break;;
        "Flake Update Test")
            until [ "${test}" = "n" ]; do
                rm ${HOME}/.gtkrc-2.0 #removing the backup of the annoying file :(

                echo -e "${green}Running flake update test.${noColor}"
                nh os test --update

                echo -e "${green}Adding all to working directory.${noColor}"
                git add . 
                
                echo -e "${green}Formatting Nix code.${noColor}"
                alejandra .
                
                echo -e "${green}Running build test.${noColor}"
                nh os test

                echo -e "${cyan}Would you like to commit the changes? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
                read -n 1 commit
                if [ "${commit}" != "n" ]; then
                    fCommit
                fi

                echo -e "${cyan}Would you like to test again? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
                read -n 1 test
            done
        break;;
        *)
            echo "Invalid Option";;
    esac
done

    if [ "${commit}" = "n" ]; then
        fCommit
    fi

    echo -e "${cyan}Switch now or at boot? [${red}switch${cyan}/${green}boot${cyan}]${noColor}"
    read switch

    echo -e "${cyan}Update? [${red}y${cyan}/${green}N${cyan}]${noColor}"
    read -n 1 update

    rm ${HOME}/.gtkrc-2.0

    if [ "${update}" = "y" ]; then
        nh os ${switch} --update --ask #asks so you dont get shocked by everything restarting

        echo -e "${green}Committing update.${noColor}"
        git commit -a -m "Flake Update"
    else
        nh os ${switch}
    fi

    echo -e "${cyan}Would you like to push to remote? [${red}Y${cyan}/${green}n${cyan}]${noColor}"
    read -n 1 push

    if [ "${push}" != "n" ]; then
        echo -e "${cyan}Rebase before pushing? [${red}y${cyan}/${green}N${cyan}]${noColor}"
        read -n 1 rebase

        if [ "${rebase}" = "y" ]; then
            git rebase --interactive
        fi

        git push
    fi

    echo -e "${green}Cleaning NixOS.${noColor}"
    nh clean all --keep 5 --ask #asking so i can verify it doesn't do smthn i dont want

    exit