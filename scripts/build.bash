# Checking if repo needs a commit
if [[ $(git diff --cached) ]]; then
    echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
    read -n 1 commit
    if [ "${commit}" = "y" ]; then
        echo -e "\n${green}Please write commit message: ${noColor}"
        read commitmsg
        git commit -a -m "${commitmsg}"
    fi
fi

# Checking differences between remote and local
git fetch
behindCount=$(git rev-list --count HEAD..@{u}) #checks how far behind the current local branch is behind the remote
aheadCount=$(git rev-list --count @{u}..HEAD) #checks how far ahead it is

aheadSum=(${aheadCount} - ${behindCount}) #evaluates whether local is ahead or behind of remote

rm ${HOME}/.gtkrc-2.0

if [ "${behindCount}" -gt 0 ] && [ "$aheadCount" -gt 0 ]; then #diverge case
    if ! (git pull) then
        git mergetool #in case of merge conflict, opens configured mergetool to resolve
    fi

    if (nh os test) then
        # Here the script is restarted, now that the local branch is up to date it will result in the ahead case, rebuilding and pushing
        bash ./build.bash
        exit 0
    fi
    
elif [ "${aheadSum}" -gt 0 ]; then #ahead case
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

elif [ "${aheadSum}" -lt 0 ]; then #behind case
    echo -e "${green}Pulling from remote.${noColor}"
    git pull

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

    nh os $switch

else
    echo -e "${green}Everything is up to date."
    exit 0
fi

echo -e "${green}Cleaning NixOS.${noColor}"
nh clean all --keep 5 --ask #asking so i can verify it doesn't do smthn i dont want

exit 0