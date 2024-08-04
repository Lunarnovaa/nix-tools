## This script does a few things:

1. Loops a prompt that allows you to run some useful functions in your nixconf:
    1. **Build Test:** *The standard test for most cases*
        1. Adds any new files to the Git Repo
        2. Formats the code using [Alejandra](https://github.com/kamadorueda/alejandra)
        3. Removes a certain auto-generated file because Nix will through a fit when it and the backup file is there. *Remove this if it is not necessary for you*
        4. Runs `nh os test`
        5. Optionally **commits** your changes with a given message
    2. **Flake Update Test:** *This is in cases where an update may fix an issue being faced*
        1. Removes a certain auto-generated file because Nix will through a fit when it and the backup file is there. *Remove this if it is not necessary for you*
        2. Runs `nh os test --update`
        3. Adds any new files to the Git Repo
        4. Formats the code using [Alejandra](https://github.com/kamadorueda/alejandra)
        5. Runs `nh os test`
        6. Optionally **commits** your changes with a given message
    3. **Pull and Rebuild:** *When you've made a change on another system and want those changes on your current system*
    4. **Switch Branch:** *When you would like to switch to a different branch of your configuration to edit and/or rebuild*
        1. Lists the branches
        2. Asks what branch you would like to switch to *(Hint: You can prepend `-c` to create a new branch with a given name)*
        3. Optionally allows you to rebuild with the branch
    5. **Reset to Commit:** *When you've tested a change and are unhappy with it*
        1. Simply resets to your last commits
2. If there are uncommitted changes, asks if you would like to **commit**.
3. Asks if you want to switch to your config **now or on next boot**
4. Asks if you want to **update your flake** using [nh](https://github.com/viperML/nh)  *(defaults to no)*
5. **Rebuilds**
6. *If chose to update, **commits** with specific msg*
7. Asks if you want to **push** *(yes by default)*
    - If you choose to push, asks if you would like to **rebase** *(no by default)*
8. **Cleans** your NixOS config keeping 5 boot saves.