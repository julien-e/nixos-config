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

      scan() {
        local out="''${1:-$HOME/scan_$(date +%Y%m%d_%H%M%S).jpg}"
        echo "Scan en cours..."
        local job
        job=$(curl -s -X POST -H "Content-Type: text/xml" \
          -d '<?xml version="1.0"?><scan:ScanSettings xmlns:scan="http://schemas.hp.com/imaging/escl/2011/05/03" xmlns:pwg="http://www.pwg.org/schemas/2010/12/sm"><pwg:Version>2.0</pwg:Version><scan:Intent>Document</scan:Intent><pwg:InputSource>Platen</pwg:InputSource><pwg:DocumentFormat>image/jpeg</pwg:DocumentFormat><scan:ColorMode>Grayscale8</scan:ColorMode><scan:XResolution>300</scan:XResolution><scan:YResolution>300</scan:YResolution></scan:ScanSettings>' \
          -D - http://192.168.1.113:8080/eSCL/ScanJobs | grep -i location | sed 's/Location: //' | tr -d '\r\n')
        sleep 6
        curl -s -o "$out" "''${job}/NextDocument"
        echo "Scanné: $out"
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
