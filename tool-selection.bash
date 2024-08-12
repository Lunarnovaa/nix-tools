export green='\033[1;32m'
export cyan='\033[1;36m'
export red='\033[1;31m'
export noColor='\033[0m'

echo -e "${green}Welcome to Nix-Tools."

cd ~/nixconf

echo -e "${red}Current branches on repo:"
git show-branch --list

echo -e "${cyan}"

select toolOption in "Test" "Branch" "Fetch" "Reset to Commit" "Build"
do
    case $toolOption in
        "Test")
            bash ~/nixbuild/scripts/test.bash
        ;;
        "Branch")           
            bash ~/nixbuild/scripts/branch.bash
        ;;
        "Fetch")
            bash ~/nixbuild/scripts/fetch.bash
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
            bash ~/nixbuild/scripts/build.bash
        ;;
    esac
done
exit 0