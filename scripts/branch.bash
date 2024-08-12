echo -e "${red}Current branches on repo:"
git show-branch --list

echo -e "${cyan}"

select branchOption in "Switch Branch" "Create New" "Delete Branch" "Return"
do
    case $branchOption in
    "Switch Branch")
        echo -e "${green}Name the branch to switch to:${noColor}"
        read branch
        git switch ${branch}
    ;;
    "Create New")
        echo -e "${green}Name the new branch:${noColor}"
        read newBranch
        if (git switch -c ${newBranch}) then
            git commit -a -m "Init New Branch: ${newBranch}"
            git push -u
        fi
    ;;
    "Delete Branch")
        echo -e "${green}Name of the branch to delete:${noColor}"
        read delBranch

        echo -e "${cyan}Warning: This action cannot be undone. Are you sure you would like to delete branch ${red}'${delbranch}'${cyan}? [${red}y${cyan}/${green}N${cyan}]${noColor}"
        read -n 1 delete
        if [ "$delete" = "y" ]; then
            git push -d origin ${delBranch}
            git branch -d ${delBranch}
        else
            echo -e "${green}Branch deletion cancelled.${noColor}"
        fi
    ;;
    "Return")
        break;;
    esac
done
exit 0