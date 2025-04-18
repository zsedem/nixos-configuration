{ config, lib, pkgs, ... }:

with lib;
let
  btrfs-root-partition = config.zsedem.btrfs-root;
in
{
  options.zsedem.btrfs-root = mkOption { type = types.str; };
  config = {
    fileSystems."/" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@" ];
      };

    fileSystems."/.snapshots" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@snapshots" ];
      };

    fileSystems."/nix/store" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@nix-store" ];
      };


    fileSystems."/var/lib/docker" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@docker" ];
      };

    fileSystems."/var/log" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@logs" ];
      };



    fileSystems."/home" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@home" ];
      };

    fileSystems."/home/.snapshots" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,space_cache,compress=lzo,noatime,nodiratime,subvol=@home-snapshots" ];
      };

    fileSystems."/btrfs" =
      {
        device = btrfs-root-partition;
        fsType = "btrfs";
        options = [ "ssd,ro" ];
      };

    services.snapper.configs = {
      "home" = {
        SUBVOLUME = "/home";

        ALLOW_GROUPS = [ "users" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = 1800;
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "2";
        TIMELINE_LIMIT_WEEKLY = "1";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";

      };
      "root" = {
        SUBVOLUME = "/";

        ALLOW_GROUPS = [ "wheel" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = 1800;
        TIMELINE_LIMIT_HOURLY = "3";
        TIMELINE_LIMIT_DAILY = "3";
        TIMELINE_LIMIT_WEEKLY = "1";
        TIMELINE_LIMIT_MONTHLY = "1";
        TIMELINE_LIMIT_YEARLY = "0";

      };
    };

    swapDevices = [ ];
  };
}
