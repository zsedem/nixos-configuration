# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  services.snapper.configs = {
    "home" = {
      subvolume = "/home";
      extraConfig = ''
        ALLOW_GROUPS="users"
        TIMELINE_MIN_AGE="1800"
        TIMELINE_LIMIT_HOURLY="5"
        TIMELINE_LIMIT_DAILY="2"
        TIMELINE_LIMIT_WEEKLY="1"
        TIMELINE_LIMIT_MONTHLY="0"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "root" = {
      subvolume = "/";
      extraConfig = ''
        ALLOW_GROUPS="wheel"
        TIMELINE_MIN_AGE="1800"
        TIMELINE_LIMIT_HOURLY="3"
        TIMELINE_LIMIT_DAILY="3"
        TIMELINE_LIMIT_WEEKLY="1"
        TIMELINE_LIMIT_MONTHLY="1"
        TIMELINE_LIMIT_YEARLY="0"
       '';
    };
  };
}
