{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    
    history = {
      size = 5000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      save = 5000;
      extended = true;
    };
    
    defaultKeymap = "emacs";
    
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    
    sessionVariables = {
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      XCURSOR_SIZE = "36";
    };
    
    shellAliases = {
      ls = "eza -a --icons=always";
      ll = "eza -al --icons=always";
      lt = "eza -a --tree --level=1 --icons=always";
      cat = "bat --style plain --theme=base16";
      vim = "nvim";
      c = "clear";
      man = "tldr";
      shutdown = "systemctl poweroff";
      rebuild = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .#nixos";
      dstatus = "systemctl status docker --no-pager -l";
    };
    
    initExtra = ''
      git() {
        if [ -z "$1" ]; then
          lazygit
        else
          command git "$@"
        fi
      }
      
      docker() {
        if [ -z "$1" ]; then
          lazydocker
        else
          command docker "$@"
        fi
      }
      
      nvim() {
        kitty @ set-spacing padding=0 margin=0 2>/dev/null || true
        command nvim "$@"
        kitty @ set-spacing padding=10 margin=0 2>/dev/null || true
      }
      
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^[w' kill-region
      
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"
      eval "$(mise activate zsh)"
    '';
  };
  
  xdg.enable = true;
}
