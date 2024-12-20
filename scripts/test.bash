commitRequest () {
    echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
    read -n 1 commit

    if [ "${commit}" = "y" ]; then
        echo -e "\n${green}Please write commit message: ${noColor}"
        read commitmsg
        git commit -a -m "${commitmsg}"
    fi
}

echo -e "${cyan}"
select testOption in "Basic Test" "Boot Test" "Refresh Tofi-Drun Cache" "Special Case" "Return"
do
    echo -e "${green}Adding all to working directory.${noColor}"
    git add . 

    echo -e "${green}Formatting Nix code.${noColor}"
    alejandra .

    rm ${HOME}/.gtkrc-2.0 #removing the backup of the annoying file :(

    case $testOption in
    "Basic Test")
        echo -e "${green}Running build test.${noColor}"
        if (nh os test) then
            commitRequest
        fi
    ;;
    "Boot Test")
        echo -e "${cyan}Would you like to update the flake as well? [${red}y${cyan}/${green}N${cyan}]${noColor}"
        read -n 1 testUpdate

        if [ "${testUpdate}" = "y" ]; then
            echo -e "${green}Running boot test plus flake update.${noColor}"
            if (nh os boot --update) then
                commitRequest
            fi
        else
            echo -e "${green}Running boot test.${noColor}"
            if (nh os boot) then
                commitRequest
            fi
        fi
    ;;
    "Refresh Tofi-Drun Cache")
        echo -e "${green}Clearing tofi-drun cache.${noColor}"
        rm ${HOME}/.cache/tofi-drun #deleting cache for tofi-drun so that the desktop apps actually update
        
        echo -e "${green}Rebuilding to update cache.${noColor}"
        nh os test
    ;;
    "Special Case")
        echo -e "${cyan}Input command:${noColor}"
        read specialCase

        if (${specialCase}) then
            commitRequest
        fi
    ;;
    "Return")
        break;;
    esac
done
exit 0