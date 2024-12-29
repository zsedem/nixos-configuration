{ config, lib, pkgs, ... }:
with lib;
let
  zs-steam-enabled = config.zsedem.steam-enabled;
in {
  options.zsedem.steam-enabled = mkOption { type = types.bool; default = false; };
  config = {
    users.extraUsers.zsedem = {
      isNormalUser = true;
      home = "/home/zsedem";
      createHome = true;
      description = "ZsEdem Steam";
      extraGroups = [ "networkmanager" ];
      initialPassword = "titkos";
      uid = 1002;
    };
    programs = mkIf (zs-steam-enabled) {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        gamescopeSession.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };
    environment = mkIf (zs-steam-enabled) {
      systemPackages = [ pkgs.mangohud ];
    };
  };
}
