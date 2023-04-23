+++
title = "Moving from Homebrew to Nix Package Manager"
date = 2019-02-16T18:30:40-07:00
description = "Moving from Homebrew to Nix Package manager on my macbook pro"
featured = true
draft = false
toc = true
featureImage = "/img/via/Screen-Shot-2019-02-17-13-04-16.png"
keywords = ["nix", "nixos", "macos", "macbook", "package manager", "functional programming"]
tags = ["nix", "nixos", "macos", "functional programming"]
categories = ["nix", "nixos", "macos"]
+++

As all my friends, colleagues and followers know I am very big on functional programming, so when I heard about nixOS and the nix package manager (A Purely Functional package manager) I really wanted to find out more about it.

**Quote from** [Nix](https://nixos.org/nix/)

> Nix is a powerful package manager for Linux and other Unix systems that makes package management reliable and reproducible. It provides atomic upgrades and rollbacks, side-by-side installation of multiple versions of a package, multi-user package management and easy setup of build environments.

Finally this weekend I got the chance to dig in, find  out more about it and try my hand at it by moving from using [Homebrew](https://brew.sh/) as my preferred choice for package management to Nix.

Note that this not a detailed tutorial on Nix as I will leave that to the Nix documentation (see: [References and Recommended Resources](https://www.softinio.com/post/moving-from-homebrew-to-nix-package-manager/#references-and-recommended-resources)), this is more of an account of how to get started with Nix fast  to be productive quickly whilst you learn all about Nix. 

## Getting started with Nix
The documentation for Nix is pretty detailed and extensive. Though I plan to read all of it, I wanted a quick overview of what I am getting myself into. To achieve that in timely fashion I read this fantastic overview [Adelblog - My journey into Nix](https://adelbertc.github.io/posts/2017-04-03-nix-journey.html) by  [Adelbert Chang](https://twitter.com/adelbertchang).  This blog left me super excited to carry on.

### Lets Install Nix
Nix gives you two installation  options: single user or multi-user.  Even though I am the only user of  my  macbook I decided to go with the multiuser option so that Nix will be the defacto source of truth for everything on the whole laptop. Even if I never create another user for my laptop my software developer OCD is better satisfied by the way everything will be organized, setup and used on my laptop. 

To install open your terminal  and run:

```bash
sh <(curl https://nixos.org/nix/install) --daemon
```
Follow the on screen instructions and you will have Nix Package manager installed on your  macbook.
### Installing Nix Darwin
Nix Package manager is part of NixOS which is its own Linux based OS. With NixOS you can even configure your hardware and OS options using Nix . I was thinking to myself I wish I could do the same above just package management with MacOS. Luckily I found the Nix Darwin project  [nix-darwin](https://github.com/LnL7/nix-darwin)which is trying to achieve that for macbooks and macOS. So after a successful installation of Nix Package manager I set off installing Nix Darwin:
#### Backup a few files first

```bash
sudo mv /etc/zprofile /etc/zprofile.orig
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.orig
sudo mv /etc/zshrc /etc/zshrc.orig
```
#### Install Nix Darwin

```bash
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

## Moving the packages I have with homebrew to Nix
Once Nix and Nix-Darwin are installed you will have new configuration file here: `~/.nixpkgs/darwin-configuration.nix` 
I followed the following steps to move my packages across:

- run `brew list` to get a list of what  packages I have that was installed using homebrew

    **tip:** If you want to see what each package  you have with homebrew depends on run this: 
```bash
brew list -1 | while read cask; do echo -ne "\x1B[1;34m $cask \x1B[0m"; brew uses $cask --installed | awk '{printf(" %s ", $0)}'; echo ""; done
```
- Check if package you want to move across exists in Nix:

    ```bash
    nix-env -qaP | grep -i <packagename>
    ```
    alternatively you can visit: [Search NixOS packages](https://nixos.org/nixos/packages.html#)

- Add your package to `~/.nixpkgs/darwin-configuration.nix` to the `environment.systemPackages` list (its space separated list).
- Install the nix packages you added to your config file by running:

    ```bash
    darwin-rebuild switch
    ```

- Remove the packages you successfully moved by running:

    ```bash
    brew uninstall <packagename> --force
    ```

I started off by moving the packages one at a time , then in groups to completion. Last I run `brew cleanup`

You can take a look at my configuration here: [Salar Rahmanian's darwin-configuration.nix](https://github.com/softinio/dotfiles/blob/master/nix/darwin-configuration.nix)

## Useful Aliases in my zsh profile

I added the following to my `.zshrc` profile to make it easier for me to use
nix:

```
alias nixre="darwin-rebuild switch"
alias nixgc="nix-collect-garbage -d"
alias nixq="nix-env -qaP"
alias nixupgrade="sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'"
alias nixup="nix-env -u"
alias nixcfg="nvim ~/.nixpkgs/darwin-configuration.nix"
```

## What am I doing next?
This certainly has got me started with Nix and have me excited to use it more as much as possible so next I am looking at:

- Moving my neovim/vim configuration to using Nix.
- Learn and move my development workflow to using Nix shell. I currently develop using Scala, Haskell and Python I would love to hear from everyone on what tools you are using and what your workflow is
- Create some nix packages for anything I notice missing

Of course I will share all my learnings here on my blog so keep an eye on my blog or follow me on Twitter.

## References and Recommended Resources
- [Nix package manager manual](https://nixos.org/nix/manual/)
- [nix-darwin: nix modules for darwin](https://github.com/LnL7/nix-darwin)
- [Search NixOS packages](https://nixos.org/nixos/packages.html#)
- [How up to date are NixOS channels?](https://howoldis.herokuapp.com/)
- [Adelblog - My journey into Nix](https://adelbertc.github.io/posts/2017-04-03-nix-journey.html)
- [Nix Pills](https://nixos.org/nixos/nix-pills/)
- [Salar Rahmanian dotfiles](https://github.com/softinio/dotfiles)
- [Homebrew](https://brew.sh/)
