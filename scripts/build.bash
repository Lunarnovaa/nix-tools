# Checking differences between remote and local
git fetch
behindCount = $(git rev-list --count HEAD..@{u}) #checks how far behind the current local branch is behind the remote
aheadCount = $(git rev-list --count @{u}..HEAD) #checks how far ahead it is


if [[ $(git diff --cached) ]]; then
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

exit 1