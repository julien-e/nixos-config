# MangoWC Window Manager configuration
{ inputs, outputs, lib, config, pkgs, ... }:

{
  # Systemd tray target
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  # Mango session target that starts graphical-session.target
  systemd.user.targets.mango-session = {
    Unit = {
      Description = "mango compositor session";
      Documentation = "man:systemd.special(7)";
      Wants = [ "graphical-session-pre.target" "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  wayland.windowManager.mango = {
    enable = true;
    
    settings = ''
      # ===== Startup =====
      exec-once=~/.config/mango/autostart.sh
      
      # ===== Window Effects =====
      blur=1
      blur_optimized=1
      blur_params_radius=5
      shadows=1
      shadow_only_floating=1
      border_radius=8
      focused_opacity=1.0
      unfocused_opacity=0.95
      
      # ===== Animations =====
      animations=1
      animation_type_open=slide
      animation_type_close=slide
      animation_duration_open=300
      animation_duration_close=400
      
      # ===== Appearance =====
      gappih=8
      gappiv=8
      gappoh=12
      gappov=12
      borderpx=2
      bordercolor=0x444444ff
      focuscolor=0x89b4faff
      
      # ===== Keyboard =====
      repeat_rate=25
      repeat_delay=600
      xkb_rules_layout=us
      
      # ===== Input Devices =====
      # Accept all input devices by default
      devicerule=enable:1,type:keyboard
      devicerule=enable:1,type:pointer
      devicerule=enable:1,type:touch
      
      # ===== Scroller Layout =====
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=0
      scroller_proportion_preset=0.5,0.6,0.7,0.8,0.9,1.0
      
      # ===== Layout Cycling =====
      circle_layout=scroller,tile,vertical_tile,monocle
      
      # ===== Multi-Monitor =====
      focus_cross_monitor=1
      warpcursor=1
      sloppyfocus=1
      
      # ===== Monitor Configuration =====
      # Monitor configuration is now handled by Kanshi (see kanshi.nix)
      # Default settings for all monitors
      mfact=0.55
      nmaster=1
      
      # ===== Window Rules =====
      windowrule=isnamedscratchpad:1,scratchpad_width:1500,scratchpad_height:900,appid:scratchpad-term
      windowrule=allow_csd:0,appid:ferdium
      windowrule=isfloating:1,title:^rofi
      
      # ===== Workspace Layout =====
      tagrule=id:1,layout_name:scroller
      tagrule=id:2,layout_name:scroller
      tagrule=id:3,layout_name:scroller
      tagrule=id:4,layout_name:scroller
      tagrule=id:5,layout_name:scroller
      tagrule=id:6,layout_name:scroller
      tagrule=id:7,layout_name:scroller
      tagrule=id:8,layout_name:scroller
      tagrule=id:9,layout_name:scroller

      # ===== Overview Mode =====
      ov_tab_mode=1
      
      # ===== KEYBINDINGS =====
      
      # System
      # Reload config and restart
      bind=SUPER,r,spawn_shell,mmsg -d reload_config && sleep 0.2 && mmsg -d setlayout,scroller
      # Restart DankMaterialShell
      bind=SUPER+SHIFT,r,spawn,dms restart
      
      # Open terminal
      bind=SUPER,Return,spawn,kitty
      # Open browser
      bind=SUPER,b,spawn,chromium
      # Open file manager
      bind=SUPER,e,spawn,nautilus
      
      # Toggle dashboard overview
      bind=SUPER,d,spawn,dms ipc call dash toggle overview
      # Application launcher
      bind=ALT,space,spawn,dms ipc call spotlight toggle
      # Clipboard manager
      bind=SUPER,v,spawn,dms ipc call clipboard toggle
      # Notification center
      bind=SUPER,i,spawn,dms ipc call notifications toggle
      # Power menu
      bind=SUPER,BackSpace,spawn,dms ipc call powermenu toggle
      # Lock screen
      bind=SUPER,l,spawn,dms ipc call lock lock
      
      # Show all keybindings
      bind=SUPER,slash,spawn,show-keybinds
      
      # Close focused window
      bind=SUPER,q,killclient,
      # Toggle floating mode
      bind=SUPER,f,togglefloating,
      # Monocle layout (single window fullscreen)
      bind=SUPER,m,setlayout,monocle
      # Toggle fullscreen
      bind=SUPER+SHIFT,m,togglefullscreen,
      # Toggle overview mode
      bind=SUPER,a,toggleoverview,
      
      # Cycle through windows
      bind=SUPER,Tab,focusstack,next
      # Focus window to the left
      bind=SUPER,Left,focusstack,prev
      # Focus window to the right
      bind=SUPER,Right,focusstack,next
      # Focus window above
      bind=SUPER,Up,focusstack,prev
      # Focus window below
      bind=SUPER,Down,focusstack,next
      
      # Swap window left
      bind=SUPER+SHIFT,Left,exchange_client,left
      # Swap window right
      bind=SUPER+SHIFT,Right,exchange_client,right
      # Swap window up
      bind=SUPER+SHIFT,Up,exchange_client,up
      # Swap window down
      bind=SUPER+SHIFT,Down,exchange_client,down
      
      # Resize floating left
      bind=CTRL+SUPER,Left,smartresizewin,left
      # Resize floating right
      bind=CTRL+SUPER,Right,smartresizewin,right
      # Resize floating up
      bind=CTRL+SUPER,Up,smartresizewin,up
      # Resize floating down
      bind=CTRL+SUPER,Down,smartresizewin,down
      # Increase window size
      bind=SUPER,equal,resizewin,80,80
      # Decrease window size
      bind=SUPER,minus,resizewin,-80,-80
      
      # Decrease master area
      bind=ALT,Left,setmfact,-0.05
      # Increase master area
      bind=ALT,Right,setmfact,+0.05
      # Cycle through width presets
      bind=ALT,p,switch_proportion_preset
      
      # Move floating window left
      bind=ALT+SUPER,Left,smartmovewin,left
      # Move floating window right
      bind=ALT+SUPER,Right,smartmovewin,right
      # Move floating window up
      bind=ALT+SUPER,Up,smartmovewin,up
      # Move floating window down
      bind=ALT+SUPER,Down,smartmovewin,down
      
      # Scroller layout
      bind=SUPER,s,setlayout,scroller
      # Tile layout
      bind=SUPER,t,setlayout,tile
      # Vertical tile layout
      bind=SUPER,y,setlayout,vertical_tile
      # Cycle layouts
      bind=SUPER,n,switch_layout
      
      # Screenshot full screen
      bind=CTRL,Print,spawn_shell,filename="screenshot-$(date +%Y%m%d-%H%M%S).png" && grim ${config.home.homeDirectory}/Pictures/$filename && notify-send "Screenshot" "Saved: $filename"
      # Screenshot area to file
      bind=SUPER,Print,spawn_shell,filename="screenshot-$(date +%Y%m%d-%H%M%S).png" && grim -g "$(slurp)" ${config.home.homeDirectory}/Pictures/$filename && notify-send "Screenshot" "Area saved: $filename"
      # Screenshot area to clipboard
      bind=SUPER+SHIFT,Print,spawn_shell,grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Area copied to clipboard"
      
      # Media keys (no comments - will be hidden from viewer)
      bind=none,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind=none,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind=none,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=none,XF86AudioMicMute,spawn_shell,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo 1 || echo 0) | sudo tee /sys/class/leds/platform::micmute/brightness > /dev/null
      bind=none,XF86MonBrightnessUp,spawn,brightnessctl set 5%+
      bind=none,XF86MonBrightnessDown,spawn,brightnessctl set 5%-
      
      # Toggle terminal scratchpad
      bind=ALT,z,toggle_named_scratchpad,scratchpad-term,none,kitty --class scratchpad-term
      
      # Focus monitor left
      bind=SUPER,code:112,focusmon,right
      # Focus monitor right
      bind=SUPER,code:117,focusmon,left
      # Move window to left monitor
      bind=SUPER+SHIFT,code:112,tagmon,right,0
      # Move window to right monitor
      bind=SUPER+SHIFT,code:117,tagmon,left,0
      
      # Swipe left with 3 fingers
      gesturebind=none,left,3,focusstack,prev
      # Swipe right with 3 fingers
      gesturebind=none,right,3,focusstack,next
      
      # View all workspaces
      bind=SUPER,0,view,0,0
      # View workspace 1
      bind=SUPER,1,view,1,0
      # View workspace 2
      bind=SUPER,2,view,2,0
      # View workspace 3
      bind=SUPER,3,view,3,0
      # View workspace 4
      bind=SUPER,4,view,4,0
      # View workspace 5
      bind=SUPER,5,view,5,0
      # View workspace 6
      bind=SUPER,6,view,6,0
      # View workspace 7
      bind=SUPER,7,view,7,0
      # View workspace 8
      bind=SUPER,8,view,8,0
      # View workspace 9
      bind=SUPER,9,view,9,0
      
      # Move to all workspaces
      bind=SUPER+SHIFT,0,tag,0,0
      # Move to workspace 1
      bind=SUPER+SHIFT,1,tag,1,0
      # Move to workspace 2
      bind=SUPER+SHIFT,2,tag,2,0
      # Move to workspace 3
      bind=SUPER+SHIFT,3,tag,3,0
      # Move to workspace 4
      bind=SUPER+SHIFT,4,tag,4,0
      # Move to workspace 5
      bind=SUPER+SHIFT,5,tag,5,0
      # Move to workspace 6
      bind=SUPER+SHIFT,6,tag,6,0
      # Move to workspace 7
      bind=SUPER+SHIFT,7,tag,7,0
      # Move to workspace 8
      bind=SUPER+SHIFT,8,tag,8,0
      # Move to workspace 9
      bind=SUPER+SHIFT,9,tag,9,0
      
      # Drag to move window
      mousebind=SUPER,btn_left,moveresize,curmove
      # Drag to resize window
      mousebind=SUPER,btn_right,moveresize,curresize
    '';
    
    autostart_sh = ''
      # Start kanshi for monitor configuration with delay
      (sleep 1 && kanshi) &
      
      # Start DankMaterialShell with delay to ensure compositor is ready
      (sleep 2 && dms run) &
      
      # Clipboard utilities
      wl-clip-persist --clipboard regular --reconnect-tries 0 &
      wl-paste --type text --watch cliphist store &
      
      # Start Ferdium minimized (for notifications)
      sleep 3 && ferdium --hidden --disable-frame &
    '';
  };
  
  # Show keybindings script
  home.file.".local/bin/show-keybinds" = {
    source = ./show-keybinds.sh;
    executable = true;
  };
  
  # Toggle layout script
  home.file.".config/mango/toggle-layout.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Toggle between tile and scroller layouts
      
      current=$(mmsg -g | grep "layout" | grep -v "kb_layout" | head -1 | awk '{print $3}')
      
      if [ "$current" = "S" ]; then
          mmsg -d setlayout,tile
      else
          mmsg -d setlayout,scroller
      fi
    '';
    executable = true;
  };
}
