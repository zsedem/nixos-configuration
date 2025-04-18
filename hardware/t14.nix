{ config, lib, pkgs, mkDerivation, ... }:

let
  latest-pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
in {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixos-hardware/lenovo/thinkpad/t14/amd>
  ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = latest-pkgs.linuxPackages_zen;
  boot.extraModulePackages = [ ];
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
  ];
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.hostName = "azsigmond-t14";
  nix.settings.max-jobs = lib.mkDefault 4;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 98;
      START_CHARGE_THRESH_BAT1 = 85;
      STOP_CHARGE_THRESH_BAT1 = 98;
    };
  };
  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.gdm-password.fprintAuth = true;
}
