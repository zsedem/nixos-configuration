{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
  environment = {
    systemPackages = let
        vim = import ./packages/vim/default.nix pkgs;
        termContent = ''#!/bin/sh
exec st -f "monofur:pixelsize=27:antialias=true:autohint=true" "$@"
'';
        attachTmux = ''#!/bin/sh
unset TMUX
exec term -e sh -c "tmux -q has-session && exec tmux attach-session || exec tmux"
'';

        term = pkgs.stdenv.lib.overrideDerivation pkgs.st  (attrs: {
           installPhase = ''
             TERMINFO=$out/share/terminfo make install PREFIX=$out
             echo '${termContent}' > $out/bin/term
             chmod +x $out/bin/term
             echo '${attachTmux}' > $out/bin/attach-tmux
             chmod +x $out/bin/attach-tmux
           '';
        });
      in
        (with pkgs; [
          gnome3.gnome_terminal gnome3.file-roller gnome3.gnome-tweak-tool
          xclip zsh fzf tmux tldr
          git tig
          zip unzip
          vim
          chromium
          htop
          term
        ]);
    gnome3 = {
      excludePackages = pkgs.gnome3.optionalPackages;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.chromium.enableAdobeFlash = true;
  boot = {
    cleanTmpDir = true;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    plymouth.enable = true;
    initrd.luks.devices = [
      { name = "LinuxDrive"; device = "/dev/sda2"; preLVM = true; }
    ];
  };

  security.sudo = {
    enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Budapest";

  # List packages installed in system profile. To search by name, run: $ nix-env -qaP | grep wget

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = [
      # fonts for gnome
      pkgs.dejavu_fonts pkgs.cantarell_fonts
      (import ./packages/monofur.nix)
    ];
  };
  services = {
    openssh.enable = true;
    printing.enable = true;
    udisks2.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        autoLogin = {
          enable = true;
          user = "zsedem";
        };
      };
      desktopManager.gnome3 = {
        enable = true;
     };
    };
    gnome3 = {
      gnome-documents.enable = false;
      gnome-user-share.enable = false;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = false;
      seahorse.enable = false;
      tracker.enable = false;
    };
    telepathy.enable = false;
    geoclue2.enable = false;
    packagekit.enable = false;
  };

  virtualisation.docker.enable = true;

  users.extraUsers.zsedem = {
    isNormalUser = true;
    description = "Zsigmond Ádám Olivér";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "titkos";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system = {
    stateVersion = "16.09";
    autoUpgrade.enable = true;
  };
}
