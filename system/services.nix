{ config, lib, pkgs, ... }:

{
  services.dbus.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.fwupd.enable = true;

  # Avahi pour la d\u00e9couverte d'imprimantes r\u00e9seau
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.upower.enable = true;
  services.power-profiles-daemon = {
    enable = true;
  };
  
  systemd.services.power-profiles-daemon.serviceConfig = {
    Environment = "PPD_DISABLE_PERFORMANCE=1";
  };
  
  services.getty.autologinUser = "julien";
  
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "net.hadess.PowerProfiles.switch-profile" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
  
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  
  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec mango
    fi
  '';
  
  programs.dconf.enable = true;
}
