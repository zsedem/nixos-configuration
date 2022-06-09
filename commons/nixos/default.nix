{ config, lib, pkgs, ... }:

{
  imports = [
    ./upgrade.nix
    ./certs.nix
  ];
  system = {
    stateVersion = "22.05";
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 20d";
    dates = "Mon 12:00:00";
  };
  nix.allowedUsers = [ "@users" ];
  nix.autoOptimiseStore = true;

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
  };

  security.sudo = {
    enable = true;
  };

  services.usbguard = {
    enable = false;
    # Generate a file with
    #   $ sudo usbguard generate-policy > commons/usbguard.rules
    rules = lib.readFile ./usbguard.rules;
    IPCAllowedGroups = [ "wheel" ];
  };

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Budapest";

  programs.bash.enableCompletion = true;
  boot.tmpOnTmpfs = true;
  networking.firewall.allowedUDPPortRanges = [
    { from = 27960; to = 27969; } # Urban terror
  ];
  services.journald.extraConfig = "SystemMaxUse=256M";

}
