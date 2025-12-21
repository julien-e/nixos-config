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
      ];
    })
  ];

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

  # Persist critical data between reboots (bookmarks, passwords, extensions, WideVine)
  # Create directory first
  systemd.tmpfiles.rules = [
    "d /persist/chromium 0700 julien users -"
    "d /persist/chromium/Default 0700 julien users -"
  ];

  # Bind mount persistent data from disk into tmpfs
  fileSystems."/home/julien/.config/chromium/Default/Bookmarks" = {
    device = "/persist/chromium/Default/Bookmarks";
    options = [ "bind" "nofail" ];
  };

  fileSystems."/home/julien/.config/chromium/Default/Login Data" = {
    device = "/persist/chromium/Default/Login Data";
    options = [ "bind" "nofail" ];
  };

  fileSystems."/home/julien/.config/chromium/Default/Preferences" = {
    device = "/persist/chromium/Default/Preferences";
    options = [ "bind" "nofail" ];
  };

  fileSystems."/home/julien/.config/chromium/Default/Extensions" = {
    device = "/persist/chromium/Default/Extensions";
    options = [ "bind" "nofail" ];
  };

  fileSystems."/home/julien/.config/chromium/WidevineCdm" = {
    device = "/persist/chromium/WidevineCdm";
    options = [ "bind" "nofail" ];
  };

  fileSystems."/home/julien/.config/chromium/Local State" = {
    device = "/persist/chromium/Local State";
    options = [ "bind" "nofail" ];
  };
}
