{ config, lib, pkgs, ... }:

{
  # Enable hardware video acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # AMD GPU support (detected from hardware-configuration.nix)
      mesa
      libva
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };

  # Chromium with optimized flags for GPU + Wayland
  environment.systemPackages = [
    (pkgs.chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        # GPU acceleration
        "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,UseSkiaRenderer"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-accelerated-video-decode"
        "--ignore-gpu-blocklist"
        
        # Wayland native
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--enable-wayland-ime"
        
        # Performance
        "--disable-gpu-driver-bug-workarounds"
        "--enable-oop-rasterization"
        "--enable-raw-draw"
        
        # Smooth scrolling
        "--enable-smooth-scrolling"
        "--enable-features=WebUIDarkMode"
        
        # Privacy/Security optimizations
        "--disable-search-engine-choice-screen"
        
        # DuckDuckGo as default search engine
        "--search-engine-choice-country"
      ];
    })
  ];

  # Set DuckDuckGo as default search engine
  programs.chromium = {
    enable = true;
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    defaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
  };

  # Environment variables for GPU acceleration
  environment.sessionVariables = {
    # Force VA-API for video acceleration (AMD)
    LIBVA_DRIVER_NAME = "radeonsi";
    
    # Enable Wayland for all Chromium-based apps
    NIXOS_OZONE_WL = "1";
  };

  # Create tmpfs mount for Chromium cache/profile in RAM
  # This makes Chromium entirely run from RAM for maximum performance
  fileSystems."/home/julien/.cache/chromium" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ 
      "noatime" 
      "nodiratime"
      "size=4G"      # 4GB for cache
      "mode=0700"
      "uid=1000"     # julien's UID
      "gid=100"      # users GID
    ];
  };

  fileSystems."/home/julien/.config/chromium" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ 
      "noatime" 
      "nodiratime"
      "size=2G"      # 2GB for profile
      "mode=0700"
      "uid=1000"
      "gid=100"
    ];
  };

  # Persist critical data between reboots
  systemd.tmpfiles.rules = [
    "d /persist/chromium 0700 julien users -"
  ];

  # Sync service: load from disk to RAM on boot
  systemd.user.services.chromium-load = {
    description = "Load Chromium profile from disk to RAM";
    wantedBy = [ "default.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "chromium-load" ''
        if [ -d /persist/chromium ]; then
          ${pkgs.rsync}/bin/rsync -avL --delete /persist/chromium/ ~/.config/chromium/
        fi
      '';
    };
  };

  # Sync service: save from RAM to disk periodically
  systemd.user.services.chromium-save = {
    description = "Save Chromium profile from RAM to disk";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "chromium-save" ''
        if [ -d ~/.config/chromium ]; then
          ${pkgs.rsync}/bin/rsync -avL --delete --copy-unsafe-links ~/.config/chromium/ /persist/chromium/
        fi
      '';
    };
  };

  # Timer: auto-save every 5 minutes
  systemd.user.timers.chromium-save = {
    description = "Save Chromium profile to disk every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
      Unit = "chromium-save.service";
    };
  };

  # Save on shutdown
  systemd.user.services.chromium-shutdown = {
    description = "Save Chromium profile on shutdown";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = pkgs.writeShellScript "chromium-shutdown" ''
        if [ -d ~/.config/chromium ]; then
          ${pkgs.rsync}/bin/rsync -av --delete ~/.config/chromium/ /persist/chromium/
        fi
      '';
    };
  };
}
