
# dotfiles

![Screenshot](assets/preview_0.png)

A unified collection of configuration files for my development environment, organized by tool and deployed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## Repository Structure

- **assets/** – Misc graphics, icons, or imagery  
- **hypr/** – Hyprland config files  
- **kitty/** – Kitty terminal configuration  
- **nvim/** – Neovim setup (Lua)  
- **rofi/** – Rofi theme and launcher config  
- **waybar/** – Waybar panel setup  
- **zsh/** – Zsh shell configuration  
- **stow.sh** – Helper script for deploying configs  
- **README.md** – You're reading it  

---

## Installation

Clone and deploy in one command:

```bash
git clone https://github.com/devk0n/dotfiles.git ~/dotfiles
cd ~/dotfiles
./stow.sh
```

The included stow.sh script symlinks each folder into your ~/.config directory.
You can also run it again to restow any updates.

## Font
** FiraCode **

## Enable autologin on TTY1
Run:
```bash
sudo systemctl edit getty@tty1.service
```
Paste this override:

```bash

[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin USERNAME --noclear %I $TERM
```
(replace USERNAME with your username)

Then reload systemd:
```bash
sudo systemctl daemon-reexec
```

