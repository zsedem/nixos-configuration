{ config, pkgs, ... }:

{
  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    loader.systemd-boot.enable = true;
  };
}
