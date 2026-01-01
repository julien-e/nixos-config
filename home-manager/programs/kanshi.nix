{ config, pkgs, lib, ... }:

{
  services.kanshi = {
    enable = true;

    systemdTarget = "";

    settings = [
      {
        profile.name = "triple-N07-Koorui-laptop";
        profile.outputs = [
          {
            criteria = "HKC OVERSEAS LIMITED N07 0000000000001";
            scale = 1.5;
            mode = "3840x2160@59.997002Hz";
            position = "0,0";
            status = "enable";
          }
          {
            criteria = "HKC OVERSEAS LIMITED GN10 0000000000001";
            scale = 1.0;
            mode = "2560x1440@60.000000Hz";
            position = "2560,0";
            status = "enable";
          }
          {
            criteria = "Lenovo Group Limited 0x41B5 *";
            scale = 1.3;
            mode = "1920x1200@60.001999Hz";
            position = "5120,0";
            status = "enable";
          }
        ];
      }

      {
        profile.name = "dual-BenQ-laptop";
        profile.outputs = [
          {
            criteria = "BNQ BenQ XL2411Z JAE06139SL0";
            scale = 1.0;
            mode = "1920x1080@60.000000Hz";
            position = "0,0";
            status = "enable";
          }
          {
            criteria = "BNQ BenQ XL2411Z R7E00577SL0";
            scale = 1.0;
            mode = "1920x1080@60.000000Hz";
            position = "1920,0";
            status = "enable";
          }
          {
            criteria = "Lenovo Group Limited 0x41B5 *";
            scale = 1.3;
            mode = "1920x1200@60.001999Hz";
            position = "3840,0";
            status = "enable";
          }
        ];
      }

      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "Lenovo Group Limited 0x41B5 *";
            scale = 1.3;
            mode = "2560x1600@60.000999Hz";
            position = "0,0";
            status = "enable";
          }
        ];
        profile.exec = "${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --on --mode 2560x1600@60.000999Hz --scale 1.3 --pos 0,0";
      }
    ];
  };

  systemd.user.services.kanshi.Install.WantedBy = lib.mkForce [ ];
}
