{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vanta-agent;
  vanta-pkg = import ./package.nix { inherit pkgs lib; stdenv = pkgs.stdenv; fetchurl = pkgs.fetchurl; };
in
{
  options = {
    services.vanta-agent = {
      enable = lib.mkEnableOption "Vanta Agent";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ vanta-pkg ];

    # Vanta doesn't recognize NIXos, so we pretend to be Ubuntu.
    environment.etc."ubuntu-os-release".text = ''
      NAME="Ubuntu"
      VERSION="24.04 LTS (Noble Numbat)"
      ID=ubuntu
      ID_LIKE=debian
      PRETTY_NAME="Ubuntu 24.04 LTS"
      VERSION_ID="24.04"
      HOME_URL="https://www.ubuntu.com/"
      SUPPORT_URL="https://help.ubuntu.com/"
      BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
      PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
      VERSION_CODENAME=noble
      UBUNTU_CODENAME=noble
    '';

    systemd.packages = [ vanta-pkg ];

    systemd.tmpfiles.rules = [
      "d /var/vanta/osquery.db"
      "L /var/vanta/ - - - - /var/lib/vanta"
      "L+ /var/lib/vanta/cert.pem - - - - ${vanta-pkg}/var/vanta/cert.pem"
    ];

    systemd.services.vanta = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PrivateTmp = true;
        NoNewPrivileges = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        CapabilityBoundingSet = "CAP_DAC_OVERRIDE CAP_SYS_ADMIN CAP_WRITE CAP_CREATE CAP_FOWNER CAP_CHOWN";
        ProtectSystem = "strict";
        PrivateDevices = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = false;
        ProtectKernelTunables = true;
        ProtectProc = "default";
        ProtectHome = "read-only";
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        SystemCallErrorNumber = "EPERM";
        MemoryDenyWriteExecute = true;
        ProcSubset = "all";
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        ReadWritePaths = [
          "/var/vanta"
          "/var/vanta/log"
          "/var/vanta/osquery.db"
        ];

        # vanta expects to find its many files in /var/vanta, but it also expects to be able to
        # write other files (and a log directory) in the same directory
        StateDirectory = "vanta";
        RuntimeDirectory = "vanta/log";
        BindReadOnlyPaths = [
          "${vanta-pkg}/var/vanta/launcher:/var/vanta/launcher:norbind"
          "${vanta-pkg}/var/vanta/metalauncher:/var/vanta/metalauncher:norbind"
          "${vanta-pkg}/var/vanta/vanta-cli:/var/vanta/vanta-cli:norbind"
          "${vanta-pkg}/var/vanta/osqueryd:/var/vanta/osqueryd:norbind"
          "${vanta-pkg}/var/vanta/osquery-vanta.ext:/var/vanta/osquery-vanta.ext:norbind"
          "/etc/ubuntu-os-release:/etc/os-release"
        ];
      };
    };
  };
}
