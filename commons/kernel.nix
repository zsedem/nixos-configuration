{ config, ... }:

let
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
in {
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_lqx;
}
