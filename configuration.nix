{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./desktops/gnome.nix
      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];
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


  environment = {
    systemPackages = let
        vim = import ./packages/vim/default.nix pkgs;
        terminal = import ./packages/terminal.nix pkgs;
      in
        (with pkgs; [
          gnome3.file-roller gnome3.gnome-tweak-tool google-chrome
          xclip zsh fzf tmux tldr
          (git.override {
             guiSupport = true;
             svnSupport = false;
             sendEmailSupport = false;
             pythonSupport = false;
             withManual = false;
          }) tig git-review
          zip unzip openssl
          oraclejdk8
          vim
          htop
          terminal
        ]);
    gnome3 = {
      excludePackages = pkgs.gnome3.optionalPackages;
    };
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "12:30";
  };

  nixpkgs.config = {
    allowUnfree = true;
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
  };
  programs.bash.enableCompletion = true;

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
    autoUpgrade = {
      enable = true;
      dates = "12:00";
    };
  };

  virtualisation.docker.enable = true;
}
