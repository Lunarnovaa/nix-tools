select branchOption in "Fetch URL" "Return"
do
    case $branchOption in
    "Fetch URL")
        echo -e "${green}URL:${noColor}"
        read url
        nix-prefetch-url "${url}"
    ;;
    "Return")
        break;;
    esac
done
exit 1