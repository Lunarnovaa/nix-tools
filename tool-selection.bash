echo -e "${green}Welcome to Nix-Tools."

cd ${FLAKE}

echo -e "${red}Current branches on repo:"
git show-branch --list

echo -e "${cyan}"

select toolOption in "Test" "Fetch" "Reset to Commit" "Build"
do
    case $toolOption in
        "Test")
            bash ${toolsDir}/scripts/test.bash
        ;;
        "Fetch")
            bash ${toolsDir}/scripts/fetch.bash
        ;;
        "Reset to Commit")
            lastCommit=$(git log -1 --format=%s)
            echo -e "${cyan}Warning: This action cannot be undone. Are you sure you would like to reset to: ${red}'${lastCommit}'${cyan}? [${red}y${cyan}/${green}N${cyan}]${noColor}"
            read -n 1 reset
            if [ "$reset" = "y" ]; then
                git add .
                git reset --hard HEAD
            else
                echo -e "${green}Reset cancelled.${noColor}"
            fi
        ;;
        "Build")
            bash ${toolsDir}/scripts/build.bash
        ;;
    esac
done
exit 0