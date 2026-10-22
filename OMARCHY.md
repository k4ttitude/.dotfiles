# Moving to Omarchy

The `omarchy` branch adapts these dotfiles to [Omarchy](https://github.com/omacom/omarchy) v4.0.x, whose Hyprland config is Lua (the same `hl.*` API as the old `hyprland.lua`). `main` still holds the current Arch + Hyprland setup.

> **Don't check out `omarchy` on the current machine.** `~/.config/hypr` is stowed as a symlink into this checkout, so Hyprland would immediately reload the Omarchy config, which needs `/usr/share/omarchy` to exist.

## Before installing

Omarchy only installs from its ISO (omarchy.org): either it takes a whole drive, or it installs into unpartitioned space. There is no script to run on top of an existing Arch install.

- **Pick a drive.** `nvme1n1` holds `/boot`, `/` *and* `/home`, `nvme0n1` is Windows, `sda` is the Steam library (`/mnt/steam`). None has free space, so a full-disk install wipes whichever drive you choose. Back up `/home` (including `~/.ssh`, needed to clone the submodules) if it's `nvme1n1`.
- **Turn Secure Boot off.** The Omarchy installer requires it. It's currently on, with your own sbctl keys.
- **Expect a different boot and disk setup.** Omarchy installs Limine in place of rEFInd, the `linux-omarchy` kernel, LUKS encryption, and btrfs with snapper snapshots. Windows then boots from the Limine menu.
- Save the package list: `pacman -Qqe > pkglist.txt`, kept with the backup.
- Push this branch.

## After installing

```bash
# 1. Dotfiles
git clone git@github.com:k4ttitude/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git checkout omarchy
git submodule update --init

# 2. Packages Omarchy doesn't ship
yay -S stow vicinae-bin fcitx5-bamboo fish kitty yazi mangohud ttf-meslo-nerd

# 3. Move aside the Omarchy defaults stow would collide with, then stow
./omarchy-prestow.sh -n       # preview
./omarchy-prestow.sh          # moves them to ~/omarchy-defaults-<timestamp>/
./install.sh
```

Then:

- **Terminal:** `omarchy default terminal kitty`, since `SUPER + RETURN` opens foot by default.
- **SSH agent:** run `omarchy-setup-security-ssh-agent`. It replaces the `SSH_AUTH_SOCK` line that used to be in `uwsm/env`.
- **Input method:** add Bamboo next to `keyboard-us` in `fcitx5-configtool`. `SUPER + I` / `SUPER + SHIFT + I` cycle between them.
- **Shell:** `chsh -s /usr/bin/fish`, then `fisher update`.
- **tmux:** Omarchy writes `~/.config/tmux/tmux.conf`, and yours is `~/.tmux.conf`. Move Omarchy's into the `~/omarchy-defaults-*` folder so only yours applies.
- **Wallpaper:** copy `~/.config/hypr/backgrounds/interstellar.jpg` into `~/.config/omarchy/backgrounds/<current theme>/` and pick it with `SUPER + CTRL + W`.
- **Corners:** leave *Appearance > corners* on **theme**. Picking sharp or rounded there overrides `looknfeel.lua`.
- Log out and back in, because `uwsm/env` is only read at session start.
- Check for clashing binds: `omarchy menu keybindings --print`.

## Keybindings

Personal binds are in `hypr/.config/hypr/bindings.lua`. Everything else is Omarchy's default.

| Keys | Action | Omarchy's action it displaced |
|---|---|---|
| `SUPER + SPACE`, `ALT + SPACE` | vicinae | Omarchy menu → `SUPER + ALT + SPACE` |
| `SUPER + ALT + SPACE` | Omarchy menu | Apps launcher (vicinae covers it) |
| `SUPER + H/J/K/L` | Focus left/down/up/right | J toggle split, K cheatsheet, L cycle layout (moved below) |
| `SUPER + SHIFT + H/J/K/L` | Swap window | — (same as Omarchy's `SUPER + SHIFT + arrows`) |
| `SUPER + '` | Toggle split (rotate the dwindle split 90°) | — |
| `SUPER + ;` / `SUPER + ALT + ;` | Cycle workspace layout: tiling → scrolling → floating / back | `SUPER + ALT + L` unbound |
| `SUPER + SHIFT + /` | Keybindings cheatsheet | 1Password |
| `SUPER + E` | File manager | — (`SUPER + SHIFT + F` still works too) |

Omarchy defaults that replace old habits:

| Old | Omarchy |
|---|---|
| `SUPER + C` terminal | `SUPER + RETURN` (`SUPER + C` / `V` are universal copy/paste) |
| `SUPER + V` float | `SUPER + T`; `SUPER + O` pops a window out (float + pin) |
| `SUPER + M` move submap | `SUPER + SHIFT + H/J/K/L` swap; `SUPER + M` minimizes to the dock |
| `SUPER + SHIFT + R` resize submap | `SUPER + minus` / `equal` (± `SHIFT` for height, `ALT` fine, `CTRL` coarse) |
| `SUPER + CTRL + I` input toggle | `SUPER + I` (`SUPER + CTRL + I` toggles idle locking) |
| `ALT + TAB` hyprswitch | `ALT + TAB` cycles windows |
| `SUPER + TAB` cycle windows | `SUPER + TAB` next workspace |
| `Print` / `SUPER + CTRL + SHIFT + 3/4` hyprshot | `Print` (`TAB`/arrows pick a window, `RETURN` captures it) |
| `SUPER + CTRL + 0` / `minus` OBS recording | `ALT + Print` screen recording (gpu-screen-recorder) |
| waybar volume popup | `SUPER + CTRL + A` audio panel |
| `SUPER + SHIFT + SPACE` wofi run | `SUPER + SHIFT + SPACE` toggles the bar |

## What changed on this branch

**Removed** (Omarchy replaces them, or they were only used by removed bindings):

| Removed | Replaced by |
|---|---|
| `waybar/`, `bin/volume-popup.sh` | Omarchy shell bar and audio panel |
| `dunst/` | Omarchy shell notifications |
| `wofi/`, `bin/menu/` (bemenu run + Steam launcher on `SUPER + R → S`) | vicinae, Omarchy menu |
| `pam/`, `tuigreet/` (greetd/cosmic-greeter + gnome-keyring unlock) | SDDM and the keyring Omarchy sets up |
| `hypr/hypridle.conf` (hyprsaver after 5 min) | Omarchy idle, lock and screensaver (`SUPER + CTRL + O` toggles) |
| `hypr/hyprpaper.conf` | Omarchy backgrounds (`SUPER + CTRL + W`) |
| `bin/input.sh` | `SUPER + I` |
| `bin/obs/` | `ALT + Print` recording |
| `bin/autostart-gsr.sh` | — (wasn't called from anywhere) |

hyprswitch and swayosd also drop out: they were started from the old `hyprland.lua`, and Omarchy's `ALT + TAB` and OSD replace them.

**Rewritten:**

- `hypr/`: the single `hyprland.lua` is now split into Omarchy's user files (`hyprland.lua`, `bindings.lua`, `monitors.lua`, `input.lua`, `looknfeel.lua`, `autostart.lua`).
  - **Kept:** monitor mode and HDR, `follow_mouse = 0`, mouse sensitivity, 6px corners, game and Steam workspace rules, mpv/Lutris floating, zen size, vicinae layer rules.
  - **Now from Omarchy and its theme:** gaps, borders, blur, shadows and animations.
  - **Dropped as redundant:** environment variables, the PiP and suppress-maximize rules (Omarchy has both), the firefox and flameshot rules (neither is installed), the pwvucontrol popup rule, and `WLR_USE_DAMAGE` (Hyprland no longer uses wlroots).
  - `GDK_SCALE` is set to `1` for the 1440p monitor. Omarchy's template sets `2`.
- `uwsm/env`: trimmed to the variables Omarchy doesn't set.

**Added:** `omarchy-prestow.sh` and this file.

**Unchanged:** fish, kitty, nvim, tmux, yazi, MangoHud, fontconfig, opencode.

## Not verified yet

- **Testing:** this config hasn't run in a real Omarchy session. The Lua passes `luac -p`, and `omarchy-prestow.sh` + `install.sh` were tested against a mock home seeded with Omarchy's default files.
- **Theming:** kitty keeps its own Monokai colours, so theme switches won't recolour it. Add `include ~/.local/state/omarchy/current/theme/kitty.conf` to the top of `kitty.conf` to opt in. vicinae has no Omarchy theme integration.
- **Workspace numbers:** Omarchy numbers workspaces per monitor (monitor 1 gets 1–10), so the Steam (4) and games (3) rules assume a single monitor.
- **Shell:** Omarchy's shell aliases and functions are bash-only, so fish doesn't get them.
