{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system/boot.nix
    ./system/networking.nix
    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/security.nix
    ./system/services.nix
    ./system/thinkpad.nix
    ./system/virtualization.nix
    ./system/power-management.nix
    ./system/wayland.nix
    ./system/chromium.nix
  ];

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/9b1fb5c2-1835-445d-8497-2014ca34c640";
    fsType = "f2fs";
    options = [ "defaults" ];
  };

  networking.hostName = "nixos";

  time.timeZone = "Europe/Paris";
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  #console.keyMap = "us";
  #services.xserver.xkb.layout = "us";
  #services.xserver.xkb.variant = "intl";

  console = {
    useXkbConfig = true; # use xkbOptions in tty.
  };
  services.xserver = {
    enable = false;
    xkb = {
      layout = "us";
      variant = "intl";
      options = "compose:ralt";
    };
  };

  users.users.julien = {
    isNormalUser = true;
    description = "Julien Enard";
    extraGroups = [ "networkmanager" "wheel" "video" "input" "seat" "docker" "vmware" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim nano git wget curl claude-code postman ffmpeg
    github-cli github-copilot-cli
    kitty foot wl-clipboard wl-clip-persist cliphist wlr-randr
    bitwarden-cli jq gnupg openssh exercism evtest alsa-utils 
    zsh eza bat fzf ripgrep fd cloudflared cider-2
    discord grim slurp playwright
    pgadmin4 direnv
    (pkgs.writeScriptBin "don" ''
      sudo systemctl start docker.socket docker.service
      echo "Docker started"
    '')
    (pkgs.writeScriptBin "doff" ''
      sudo systemctl stop docker.socket docker.service
      echo "Docker stopped"
    '')
  ];

  xdg.portal.enable = true; 
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
  ];

  system.stateVersion = "25.11";
}
