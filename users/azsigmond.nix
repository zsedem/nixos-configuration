{ ... }:

{
  users.extraUsers.azsigmond = {
    isNormalUser = true;
    description = "Zsigmond Ádám Olivér";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "titkos";
    uid = 1000;
  };
}
