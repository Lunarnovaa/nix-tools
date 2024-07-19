## This script does a few things:

1. Allows you to repeatedly perform a **"test,"** where the following is performed:
    1. Adds any new files to the Git Repo
    2. Formats the code using [Alejandra](https://github.com/kamadorueda/alejandra)
    3. Removes a certain auto-generated file because Nix will through a fit when it and the backup file is there. *Remove this if it is not necessary for you*
    4. Runs `nh os test`
    5. Optionally **commits** your changes with a given message
2. If committing was not performed on last test, **commits** with given message
3. Asks if you want to switch to your config **now or on next boot**
4. Asks if you want to **update your flake** using [nh](https://github.com/viperML/nh)  *(defaults to no)*
5. **Rebuilds**
6. *If chose to update, **commits** with specific msg*
7. Asks if you want to **push** *(yes by default)*
    1. If you choose to push, asks if you would like to **rebase** *(no by default)*
8. **Cleans** your NixOS config keeping 5 boot saves.