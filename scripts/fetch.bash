select branchOption in "Fetch URL" "Fetch pkg Tree" "Return"
do
    case $branchOption in
    "Fetch URL")
        echo -e "${green}URL:${noColor}"
        read url
        nix-prefetch-url "${url}"
    ;;
    "Fetch pkg Tree")
        echo -e "${green}pkg:${noColor}"
        read pkg

        mkdir $HOME/.cache/nix-tools
        cd $HOME/.cache/nix-tools
        if (nix build nixpkgs#${pkg}); then
            cd result
            nix run nixpkgs#eza -- --tree
        fi
        cd ${FLAKE}
        rm -rf $HOME/.cache/nix-tools
    ;;
    "Return")
        break;;
    esac
done
exit 0