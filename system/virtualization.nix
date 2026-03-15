{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  users.users.julien.extraGroups = [ "libvirtd" ];
}
