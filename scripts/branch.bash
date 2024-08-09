echo -e "${red}Current branches on repo:"
git show-branch --list

select branchOption in "Switch Branch" "Create New" "Return"
do
    case $branchOption in
    "Switch Branch")
        echo -e "${green}Name the branch to switch to:${noColor}"
        read branch
        git switch ${branch}
    ;;
    "Create New")
        echo -e "${green}Name the new branch:${noColor}"
        read branchName
        if (git switch -c ${branchName}) then
            git commit -a -m "Init New Branch: ${branchName}"
            git push -u
        fi
    ;;
    "Return")
        break;;
    esac
done
exit 1