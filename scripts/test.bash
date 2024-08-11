
echo -e "${cyan}"
select testOption in "Basic Test" "Flake Update Test" "Return"
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

            echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
            read -n 1 commit

            if [ "${commit}" = "y" ]; then
                echo -e "\n${green}Please write commit message: ${noColor}"
                read commitmsg
                git commit -a -m "${commitmsg}"
            fi
        fi
    ;;
    "Flake Update Test")
    
        echo -e "${green}Rebuilding with flake update.${noColor}"
        if (nh os test --update) then

            echo -e "${cyan}Would you like to commit the changes? [${red}y${cyan}/${green}N${cyan}]${noColor}"
            read -n 1 commit

            if [ "${commit}" = "y" ]; then
                echo -e "\n${green}Please write commit message: ${noColor}"
                read commitmsg
                git commit -a -m "${commitmsg} + Flake Update"
            fi
        fi

    ;;
    "Return")
        break;;
    esac
done
exit 0