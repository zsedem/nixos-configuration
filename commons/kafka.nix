{config, lib, ...}:
with lib;
let
  pkgs = (import <nixos-unstable> { config = config.nixpkgs.config; });
  kafka-enabled = config.zsedem.kafka;
in {
  options.zsedem.kafka = mkOption { type = types.bool; default = false; };

  config = {
    environment.systemPackages = with pkgs; 
        if (kafka-enabled) 
        then [apacheKafka kafkacat] 
        else [];

    networking = if (kafka-enabled)
      then {
          extraHosts = ''
          127.0.0.1 localhost kafka zookeeper
          '';
      } else {};
  };
}
