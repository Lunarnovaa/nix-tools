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

cd ~/nixconf

echo -e "${green}Welcome to the NixBuild script."

echo -e "${red}Current branches on repo:"
git show-branch --list

echo -e "${cyan}"
sleep 1

select testType in "Build Test" "Flake Update Test" "Pull and Rebuild" "Switch Branch" "Reset to Commit" "Build and Switch"
do
    case $testType in
        "Build Test")
            echo -e "${green}Adding all to working directory.${noColor}"
            git add . 

            echo -e "${green}Formatting Nix code.${noColor}"
            alejandra .

            rm ${HOME}/.gtkrc-2.0 #removing the backup of the annoying file :(
            
            echo -e "${green}Running build test.${noColor}"
            nh os test

            echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
            read -n 1 commit
            if [ "${commit}" = "y" ]; then
                fCommit
            fi
        ;;
        "Flake Update Test")
            rm ${HOME}/.gtkrc-2.0 #removing the backup of the annoying file :(

            echo -e "${green}Running flake update test.${noColor}"
            nh os test --update

            echo -e "${green}Adding all to working directory.${noColor}"
            git add . 
            
            echo -e "${green}Formatting Nix code.${noColor}"
            alejandra .
            
            echo -e "${green}Running build test.${noColor}"
            rm ${HOME}/.gtkrc-2.0
            nh os test

            echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
            read -n 1 commit
            if [ "${commit}" = "y" ]; then
                fCommit
            fi
        ;;
        "Pull and Rebuild")
            echo -e "${green}Pulling from remote.${noColor}"
            git pull
            
            echo -e "${green}Rebuilding.${noColor}"
            rm ${HOME}/.gtkrc-2.0
            nh os switch
        ;;        
        "Switch Branch")           
            echo -e "${red}Current branches on repo:"
            git show-branch --list
        
            echo -e "${green}Name the branch to switch to:${noColor}"
            read branch
            git switch ${branch}

            echo -e "${cyan}Do you wanna rebuild? [${red}y${cyan}/${green}N${cyan}]${noColor}"
            read -n 1 rebuildSwitch
            
            if [ "${rebuildSwitch}" = "y" ]; then
                rm ${HOME}/.gtkrc-2.0
                nh os test
            fi
        ;;    
        "Reset to Commit")
            echo -e "${green}Resetting to last commit.${noColor}"
            git add .
            git reset --hard HEAD
        ;;
        "Build and Switch")
        break;;
    esac
done

    if [[ $(git diff) ]]; then
        echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
        read -n 1 commit
        if [ "${commit}" = "y" ]; then
            fCommit
        fi
    fi

    echo -e "${green}Switch now or at boot?${cyan}"
    select switch in switch boot
    do 
        case $switch in
            "switch")
                export switch="switch"
            break;;
            "boot")
                export switch="boot"
            break;;
        esac
    done

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