{ inputs, outputs, lib, config, pkgs, ... }:

let
  maple-font = pkgs.callPackage ../../home-manager/programs/maple-font.nix {};
in
{
  imports = [
    ../../home-manager/programs/kitty.nix
    ../../home-manager/programs/zsh.nix
    ../../home-manager/programs/starship.nix
    ../../home-manager/programs/neovim.nix
    ../../home-manager/programs/mango.nix
    ../../home-manager/programs/dms.nix
    ../../home-manager/programs/kanshi.nix
  ];

  home = {
    username = "julien";
    homeDirectory = "/home/julien";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    eza bat fzf zoxide tldr mise
    lazygit lazydocker git
    maple-font nerd-fonts.symbols-only
    nautilus grim slurp wl-clipboard libnotify
    rofi  # Application launcher and dmenu
    ferdium
    kanshi wlr-randr
  ];

  home.file.".config/nix-shells/haskell.nix".text = ''
    { pkgs ? import <nixpkgs> {} }:

    pkgs.mkShell {
      name = "haskell-shell";
      buildInputs = with pkgs; [
        ghc
        cabal-install
        haskell-language-server
        haskellPackages.fourmolu
        haskellPackages.hlint
        haskellPackages.hoogle
        zlib
        pkg-config
      ];

      shellHook = '''
        export NIX_SHELL_NAME="haskell-shell"
      ''';
    }
  '';

  home.file.".local/bin/haskell-shell" = {
    executable = true;
    text = ''
      nix-shell ~/.config/nix-shells/haskell.nix --run $SHELL
    '';
  };

  home.file.".config/nix-shells/gleam.nix".text = ''
    { pkgs ? import <nixpkgs> {} }:

    pkgs.mkShell {
      name = "gleam-shell";
      buildInputs = with pkgs; [
        gleam
        erlang
        rebar3
        nodejs
      ];

      shellHook = '''
        export NIX_SHELL_NAME="gleam-shell"
      ''';
    }
  '';

  home.file.".local/bin/gleam-shell" = {
    executable = true;
    text = ''
      nix-shell ~/.config/nix-shells/gleam.nix --run $SHELL
    '';
  };



  fonts.fontconfig.enable = true;
  dconf.enable = true;
  
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Documents"
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/Music"
      "file://${config.home.homeDirectory}/Pictures"
      "file://${config.home.homeDirectory}/Videos"
    ];
  };
  
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
  };
  
  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Julien Enard";
        email = "julien.enard@next-op.com";
        signingkey = "";
      };
      commit.gpgsign = false;
      tag.gpgsign = false;
      init.defaultBranch = "main";
    };
  };
  
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
    defaultCacheTtl = 345600;
    maxCacheTtl = 345600;
  };
 
  # direnv - Automatic environment loading for nix-shell
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
