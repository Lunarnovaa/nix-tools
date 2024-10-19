# nix-tools

This is a collection of scripts I have written over the course of developing my [nixconf](https://github.com/Lunarnovaa/nixconf) to make working on my system easier, with shortcuts and aliases. It may grow over time.

## What can it do?

The fundamental options this script offers are to have easy-to-access fetching utils for working on your system, testing your config while you're working on it, and rebuilding it when you're ready to switch and push.

Let's take a deeper dive into each of these.

### Fetching Utils

1. **Fetch URL:** Uses [nix-prefetch](https://github.com/msteen/nix-prefetch) to prefetch a hash for using fetchURL in your system config.
2. **nurl:** Uses [nurl](https://github.com/nix-community/nurl) to generate fetch code for any URL. Mainly useful for sourcing projects from remote Git repos.
3. **Fetch pkg Tree:** Builds a package in a temporary directory, and fetches its pkg tree using [eza](https://github.com/eza-community/eza)

### Testing

This script will automatically `git add .`, format the code with [alejandra](https://github.com/kamadorueda/alejandra), and deletes a gtk file that home-manager likes to have issues with before prompting the following options:

1. **Basic Test:** Runs a test rebuild. Prompts for commit if successful.
2. **Boot Test:** Asks if you want to update the flake, then runs a boot rebuild. Prompts for commit if successful.
3. **Refresh Tofi-Drun Cache:** Tofi-Drun will not work properly unless the cache is cleared before application changes, so this option will perform a test rebuild after clearing it so that it will be refreshed.
4. **Special Case:** Prompts you for a custom command for special situations.

### Rebuilding

Here's where the only real logic of the scripts come into play: the script will test with `git diff` if a commit is needed, then will check to see if the local is behind, ahead, or divergent from the remote branch with `git rev-list`. Then, according to that, the script will perform the following options:

- **Behind Case:** Pulls and rebuilds, switching either now or at boot.
- **Ahead Case:** Rebuilds, either at switch or at boot, optionally updating the flake. Then pushes, with optional rebase.
- **Divergent Case:** Tries to pull, if merge conflict, runs `git mergetool`. Then test builds, and if it is successful, it will run the script again to run the Ahead Case.

## Can I Use It?

Idk tbh, I designed it for me. If you're actually interested in it and know how I can make it easier for others to use, go ahead and leave either a PR or an issue. I currently don't have a reason to invest the time in it myself.

## Projects In Use

- [nurl](https://github.com/nix-community/nurl)
- [eza](https://github.com/eza-community/eza)
- [nh](https://github.com/viperML/nh)
- [alejandra](https://github.com/kamadorueda/alejandra)
- [nix-prefetch](https://github.com/msteen/nix-prefetch)
  