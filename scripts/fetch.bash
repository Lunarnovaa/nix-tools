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

        if (nix build nixpkgs#${pkg}); then
            cd result
            nix run nixpkgs#eza -- --tree
        fi
    ;;
    "Return")
        break;;
    esac
done
exit 0