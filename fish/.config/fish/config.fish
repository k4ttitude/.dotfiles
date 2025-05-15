if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx PAGER less
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # ---- paths ----
    fish_add_path /usr/local/bin
    fish_add_path $HOME/.local/bin
    fish_add_path $HOME/.cargo/bin

    # pyenv
    pyenv init - | source

    # java
    fish_add_path /usr/lib/jvm/java-11-openjdk/bin

    # ---- aliases ----
    alias g=git
    alias p=pnpm
    alias nv=nvim

    # aliases:dotfiles
    alias config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

    # ---- key bindings ----
    fish_vi_key_bindings

    bind yy fish_clipboard_copy
    bind p fish_clipboard_paste

    bind -M insert \ce forward-bigword
    # bind -M insert \ch backward-kill-bigword
    bind -M insert \cn history-prefix-search-forward
    bind -M insert \cp history-prefix-search-backward
    bind -M insert \ck 'clear; commandline -f repaint'
    bind -M normal \ck 'clear; commandline -f repaint'

    # fzf key bindings
    # fzf key bindings
    # fzf --fish | source
    _fzf_uninstall_bindings
    bind -m fzf \cf ''
    bind -M insert -m fzf \cf ''

    bind -M fzf -m insert p _fzf_search_processes
    bind -M fzf -m insert v _fzf_search_variables
    bind -M fzf -m insert d _fzf_search_directory
    bind -M fzf -m insert l _fzf_search_git_log
    bind -M fzf -m insert s _fzf_search_git_status
    bind -M fzf -m insert z _fzf_search_zoxide
    bind -M fzf -m insert \e cancel-commandline
end

# pnpm
set -gx PNPM_HOME "/home/katt/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
