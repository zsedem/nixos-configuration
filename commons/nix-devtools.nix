{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nil
  ];
}
