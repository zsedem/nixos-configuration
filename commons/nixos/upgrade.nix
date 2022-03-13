{ config, lib, pkgs, ... }:

{
  systemd.services.nixos-upgrade = {
    description = "Custom NixOS Upgrade";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    serviceConfig.Type = "oneshot";
    environment = config.nix.envVars //
      { inherit (config.environment.sessionVariables) NIX_PATH;
        HOME = "/root";
      } // config.networking.proxy.envVars ;

    path = [ pkgs.coreutils pkgs.gnutar pkgs.xz.bin pkgs.gzip pkgs.gitMinimal config.nix.package.out ];
    script = let
        nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        sudo = "/run/wrappers/bin/sudo";
        bash = "${pkgs.bash}/bin/bash";
      in
        ''
        nix-channel --update
        if ${nixos-rebuild} boot --upgrade --no-build-output; then
          ${sudo} -u azsigmond \
            ${bash} -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus DISPLAY=:1 ${notify-send} "Successful System Update"'
        else
          ${sudo} -u azsigmond \
            ${bash} -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus DISPLAY=:1 ${notify-send} "FAILED System Update"'
        fi
        '';
    startAt = "12:00";
  };
}
