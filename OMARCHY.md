# Moving to Omarchy

The `omarchy` branch adapts these dotfiles to [Omarchy](https://github.com/omacom/omarchy) v4.0.x, whose Hyprland config is Lua (the same `hl.*` API as the old `hyprland.lua`). `main` still holds the current Arch + Hyprland setup.

> **Don't check out `omarchy` on the current machine.** `~/.config/hypr` is stowed as a symlink into this checkout, so Hyprland would immediately reload the Omarchy config, which needs `/usr/share/omarchy` to exist.

## Before installing

Omarchy only installs from its ISO (omarchy.org): either it takes a whole drive, or it installs into unpartitioned space. There is no script to run on top of an existing Arch install.

The plan below installs onto `nvme1n1` (465.8 GB: the current `/boot`, `/` and `/home`). `sda` (Steam library, `/mnt/steam`) isn't touched, so the backups go there. Windows (`nvme0n1`, 931.5 GB) is being dropped. Its bootloader lives on `nvme1n1`'s EFI partition, so it stops booting once Omarchy is installed. Its drive becomes a second games drive afterwards.

1. **Push this branch:** `git -C ~/.dotfiles push -u origin omarchy`.
2. **Back up keys and the package list** to the Steam drive:
   ```fish
   mkdir -p /mnt/steam/omarchy-backup
   tar -czf /mnt/steam/omarchy-backup/keys.tar.gz -C ~ .ssh .gnupg
   pacman -Qqe  > /mnt/steam/omarchy-backup/pkglist.txt       # everything explicitly installed
   pacman -Qqem > /mnt/steam/omarchy-backup/pkglist-aur.txt   # the AUR / foreign subset
   tar -tzf /mnt/steam/omarchy-backup/keys.tar.gz             # check the archive lists both dirs
   ```
   `sda` isn't encrypted. That's acceptable for `id_ed25519` because it has a passphrase. `~/.gnupg` holds no secret keys, only imported public keys, so it's backed up just in case.
3. **Copy anything else from `/home`** you want to keep (documents, browser profiles, game saves outside Steam) to `sda` or another drive. Everything on `nvme1n1` is wiped.
4. **Copy anything you want from Windows.** It won't boot after the install, and its drive is wiped later. Mount it read-only from here:
   ```fish
   sudo mkdir -p /mnt/win && sudo mount -o ro /dev/nvme0n1p2 /mnt/win
   ```
5. **Turn Secure Boot off** in the BIOS. It's currently on, with your own sbctl keys.
6. **Write the ISO** to a USB stick and install onto the **465.8 GB** drive. Pick by size: drive names can change between boots. Use a wired or 2.4GHz keyboard, since the disk password is asked for at boot.

Omarchy installs Limine in place of rEFInd, the `linux-omarchy` kernel, LUKS encryption, and btrfs with snapper snapshots.

## After installing

1. **Mount the Steam drive.** It holds the backups. The UUID is from the old `/etc/fstab`; confirm it with `lsblk -f`.
   ```bash
   sudo mkdir -p /mnt/steam
   echo 'UUID=deb8085e-5c13-4097-bbc7-8c8ac8e1376d /mnt/steam ext4 rw,relatime 0 2' | sudo tee -a /etc/fstab
   sudo systemctl daemon-reload && sudo mount /mnt/steam
   ```
2. **Restore keys:**
   ```bash
   tar -xzf /mnt/steam/omarchy-backup/keys.tar.gz -C ~
   chmod 700 ~/.ssh ~/.gnupg && chmod 600 ~/.ssh/id_ed25519
   ```
3. **Clone the dotfiles.** The repo and both submodules (nvim, opencode) clone over SSH.
   ```bash
   git clone git@github.com:k4ttitude/.dotfiles.git ~/.dotfiles
   cd ~/.dotfiles && git checkout omarchy && git submodule update --init
   ```
4. **Install the packages the dotfiles need:**
   ```bash
   yay -S --needed stow vicinae-bin fcitx5-bamboo fish kitty yazi mangohud ttf-meslo-nerd
   ```
5. **Stow:**
   ```bash
   ./omarchy-prestow.sh -n   # preview what gets moved aside
   ./omarchy-prestow.sh      # moves Omarchy's copies to ~/omarchy-defaults-<timestamp>/
   ./install.sh
   ```
6. **Configure Omarchy:**
   - `omarchy default terminal kitty`, since `SUPER + RETURN` opens foot by default.
   - `omarchy-setup-security-ssh-agent`. It replaces the `SSH_AUTH_SOCK` line that used to be in `uwsm/env`.
   - **Input method:** `sudo pacman -S fcitx5-configtool` (Omarchy doesn't ship the GUI), then add Bamboo next to `keyboard-us`. `SUPER + CTRL + I` or fcitx5's own `CTRL + SPACE` switches between them.
   - **Input method on the bar:** `omarchy plugin enable katt.input-method --after omarchy.keyboard-layout`. It shows EN / VI, and clicking it switches.
   - **Shell:** `chsh -s /usr/bin/fish`, then run `fisher update` inside fish.
   - **tmux:** move `~/.config/tmux/tmux.conf` (Omarchy's) into the `~/omarchy-defaults-*` folder so only your `~/.tmux.conf` applies.
   - **Wallpaper:** copy `~/.config/hypr/backgrounds/interstellar.jpg` into `~/.config/omarchy/backgrounds/<current theme>/` and pick it with `SUPER + CTRL + W`.
   - **Corners:** leave *Appearance > corners* on **theme**. Picking sharp or rounded there overrides `looknfeel.lua`.
7. **Log out and back in.** `uwsm/env` is only read at login.
8. **Check:**
   - `omarchy menu keybindings --print` shows no key bound twice.
   - `ALT + SPACE` opens vicinae, and `SUPER + H/J/K/L` move focus.
   - Window corners are rounded, and kitty recolors when you switch themes (`SUPER + CTRL + T`).
   - `kitty_mod+h` opens the scrollback in nvim.
9. **Games:** `yay -S steam`, then add `/mnt/steam/SteamLibrary` under *Steam > Settings > Storage*.
10. **Turn the old Windows drive into a games drive.** Find it by size (931.5 GB). The `nvmeXn1` name may have changed, so the commands use `$DISK`. Check it with `lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS` before wiping.
    ```bash
    DISK=/dev/nvmeXn1                                # the 931.5 GB drive
    sudo wipefs -a "$DISK"                           # removes Windows' partition table
    printf 'label: gpt\ntype=L, name=games\n' | sudo sfdisk "$DISK"   # one Linux partition spanning the drive
    sudo mkfs.ext4 -L games "${DISK}p1"
    sudo mkdir -p /mnt/games
    echo "UUID=$(sudo blkid -s UUID -o value "${DISK}p1") /mnt/games ext4 rw,relatime 0 2" | sudo tee -a /etc/fstab
    sudo systemctl daemon-reload && sudo mount /mnt/games && sudo chown katt:katt /mnt/games
    ```
    Then add `/mnt/games` as a second Steam library, and in Heroic and Lutris set it as the install folder.
    Clean up the dead rEFInd and Windows Boot Manager entries in the firmware: list them with `efibootmgr` and delete each with `sudo efibootmgr -b XXXX -B`.
11. **Everything else:** reinstall from `/mnt/steam/omarchy-backup/pkglist.txt` and `pkglist-aur.txt` as you need it. Don't feed the whole list to `yay`. It contains things Omarchy replaces or conflicts with: rEFInd, cosmic-greeter, waybar, dunst, swayosd, wofi, rofi, bemenu, hyprswitch, hyprpaper, hypridle, hyprpolkitagent, iwd, and the stock `linux` kernel. Pick out the apps you use, such as discord, vesktop, obs-studio, nordvpn-bin, coolercontrol-bin, lact, zen-browser-bin, heroic, lutris and docker.

## Keybindings

Personal binds are in `hypr/.config/hypr/bindings.lua`. Everything else is Omarchy's default.

| Keys | Action | Omarchy's action it displaced |
|---|---|---|
| `ALT + SPACE` | vicinae | — (`SUPER + SPACE` stays the Omarchy menu) |
| `SUPER + H/J/K/L` | Focus left/down/up/right | J toggle split, K cheatsheet, L cycle layout (moved below) |
| `SUPER + SHIFT + H/J/K/L` | Swap window | — (same as Omarchy's `SUPER + SHIFT + arrows`) |
| `SUPER + '` | Toggle split (rotate the dwindle split 90°) | — |
| `SUPER + ;` / `SUPER + ALT + ;` | Cycle workspace layout: tiling → scrolling → floating / back | `SUPER + ALT + L` unbound |
| `SUPER + SHIFT + /` | Keybindings cheatsheet | 1Password |
| `SUPER + E` | File manager | — (`SUPER + SHIFT + F` still works too) |
| `SUPER + I` | Toggle idle locking | — (moved from `SUPER + CTRL + I`) |
| `SUPER + CTRL + I` | Switch input method (`fcitx5-remote -t`) | Toggle idle locking → `SUPER + I` |

Omarchy defaults that replace old habits:

| Old | Omarchy |
|---|---|
| `SUPER + C` terminal | `SUPER + RETURN` (`SUPER + C` / `V` are universal copy/paste) |
| `SUPER + V` float | `SUPER + T`; `SUPER + O` pops a window out (float + pin) |
| `SUPER + M` move submap | `SUPER + SHIFT + H/J/K/L` swap; `SUPER + M` minimizes to the dock |
| `SUPER + SHIFT + R` resize submap | `SUPER + minus` / `equal` (± `SHIFT` for height, `ALT` fine, `CTRL` coarse) |
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
- `kitty/kitty.conf`:
  - **Colors:** the hardcoded Monokai colors (and `cursor none`, `background_opacity 1`) are replaced with an include of the current Omarchy theme, so theme switches and the glassy look reach kitty.
  - **Socket:** `listen_on unix:/tmp/kitty` is dropped in favour of Omarchy's per-process socket. Omarchy uses that socket to open a new terminal in the same folder, and kitty-scrollback.nvim works with it too, since the plugin only needs `listen_on` to be set.
  - **Defaults:** Omarchy's `/etc/xdg/kitty/kitty.conf` is loaded underneath this file, which adds 14px padding, a powerline tab bar, and a non-blinking block cursor. Set `window_padding_width 0` to remove the padding.

**Added:** `omarchy-prestow.sh`, this file, and `omarchy/`:

- `katt.input-method`: a bar widget that shows the current fcitx5 input method. Omarchy's own keyboard-layout widget only shows xkb layouts.
- `themes/artzen/colors.toml`: the Artzen palette with a real green (`color2`/`color10`), so lazygit and git diffs show additions in green instead of the theme's pink. It lives under `.copy/` because Omarchy ignores symlinks inside a theme cloned from git, so `stow.sh` copies it into the clone. Install the theme first (`omarchy theme install https://github.com/tahfizhabib/omarchy-artzen-theme`), then run `./stow.sh omarchy` and `omarchy theme set artzen`. Reinstalling the theme deletes the copy, so run both again afterwards.
- `.mkdir` creates `~/.config/omarchy/plugins` before stowing, so stow links only the `katt.input-method` folder and never all of `plugins/`. Otherwise plugins Omarchy installs later could end up inside this repo.

**Unchanged:** fish, nvim, tmux, yazi, MangoHud, fontconfig, opencode.

## Not verified yet

- **Testing:** this config hasn't run in a real Omarchy session. The Lua passes `luac -p`, and `omarchy-prestow.sh` + `install.sh` were tested against a mock home seeded with Omarchy's default files.
- **Theming:** vicinae has no Omarchy theme integration, so theme switches won't recolour it.
- **Omarchy edits stowed files:** the font menu (`omarchy-font-set`) and the text-size setting rewrite `font_family` / `font_size` in `kitty.conf` using `sed --follow-symlinks`, which edits the file in this repo. Expect a `git diff` after using them.
- **Workspace numbers:** Omarchy numbers workspaces per monitor (monitor 1 gets 1–10), so the Steam (4) and games (3) rules assume a single monitor.
- **Shell:** Omarchy's shell aliases and functions are bash-only, so fish doesn't get them.
