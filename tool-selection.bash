export green='\033[1;32m'
export cyan='\033[1;36m'
export red='\033[1;31m'
export noColor='\033[0m'

echo -e "${green}Welcome to Nix-Tools."

cd ~/nixconf

echo -e "${red}Current branches on repo:"
git show-branch --list

echo -e "${cyan}"

select toolOption in "Test" "Branch" "Fetch" "Pull and Rebuild" "Reset to Commit" "Build"
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
        "Pull and Rebuild")
            echo -e "${green}Pulling from remote.${noColor}"
            git pull
            
            echo -e "${green}Rebuilding.${noColor}"
            rm ${HOME}/.gtkrc-2.0
            nh os switch
        ;;        
        "Reset to Commit")
            echo -e "${green}Resetting to last commit.${noColor}"
            git add .
            git reset --hard HEAD
        ;;
        "Build")
            bash ~/nixbuild/scripts/build.bash
        ;;
    esac
done
exit 1