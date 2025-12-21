{ inputs, outputs, lib, config, pkgs, ... }:

{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = false;
  };
  
  home.activation.setupDmsConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DMS_DIR="$HOME/.config/niri/dms"
    mkdir -p "$DMS_DIR"
    
    for file in ${./dms-config}/*.kdl; do
      filename=$(basename "$file")
      if [ ! -f "$DMS_DIR/$filename" ]; then
        $DRY_RUN_CMD cp "$file" "$DMS_DIR/$filename"
      fi
    done
  '';
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Arc-Dark";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{name}";
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = false;
    };
  };
  
  home.file.".config/rofi/dms-theme.rasi".text = ''
    * {
      bg: #1e1e2e;
      bg-alt: #313244;
      fg: #cdd6f4;
      fg-alt: #a6adc8;
      accent: #89b4fa;
      urgent: #f38ba8;
      
      background-color: @bg;
      text-color: @fg;
    }
    
    window {
      transparency: "real";
      background-color: @bg;
      border: 2px;
      border-color: @accent;
      border-radius: 8px;
      width: 50%;
    }
    
    mainbox {
      children: [inputbar, listview];
      padding: 12px;
    }
    
    inputbar {
      children: [prompt, entry];
      background-color: @bg-alt;
      border-radius: 6px;
      padding: 8px;
      margin: 0 0 12px 0;
    }
    
    prompt {
      text-color: @accent;
      padding: 0 8px 0 0;
    }
    
    entry {
      placeholder: "Search...";
      placeholder-color: @fg-alt;
    }
    
    listview {
      lines: 10;
      scrollbar: false;
    }
    
    element {
      padding: 8px;
      border-radius: 4px;
    }
    
    element selected {
      background-color: @accent;
      text-color: @bg;
    }
    
    element-text {
      background-color: inherit;
      text-color: inherit;
    }
  '';
}
