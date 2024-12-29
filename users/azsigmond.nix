{ ... }:

{
  users.extraUsers.azsigmond = {
    isNormalUser = true;
    home = "/home/azsigmond";
    createHome = true;
    description = "Zsigmond Ádám Olivér";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "titkos";
    uid = 1000;
  };
}
