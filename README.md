## This script does a few things:

1. Allows you to continuously perform a **"test,"** where the following is performed:
    1. Adds any new files to the Git Repo
    2. Formats the code using [Alejandra](https://github.com/kamadorueda/alejandra)
    3. Removes a certain auto-generated file because Nix will through a fit when it and the backup file is there. *Remove this if it is not necessary for you.*
    4. Runs `nh os test`
2. Then will ask you for a commit message, and **commits**
3. Asks if you want to switch to your config **now or on next boot**
4. Asks if you want to **update your flake** through `nh` *(defaults to no)*
5. Asks if you want to **push** *(yes by default)*
6. **Cleans** your NixOS config keeping 5 boot saves.