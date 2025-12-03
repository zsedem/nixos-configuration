{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../commons/networkmanager.nix
  ];

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
  };
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.desktop.input-sources]
      sources=[('xkb', 'us'), ('xkb', 'hu')]

      [org.gnome.desktop.peripherals.touchpad]
      natural-scroll=false
      tap-to-click=true

      [org.gnome.desktop.wm.keybindings]
      switch-to-workspace-right=[""]
      switch-to-workspace-up=[""]
      switch-to-workspace-down=[""]
      switch-to-workspace-left=[""]

      [org.gnome.desktop.interface]
      clock-show-date=true

      [org.gnome.desktop.background]
      picture-uri='file://${./assets/background.jpg}'
      color-shading-type='solid'
      primary-color='#000000000000'
      picture-options='zoom'
      secondary-color='#000000000000'

      [org.gnome.desktop.screensaver]
      picture-uri='file://${./assets/background.jpg}'
      color-shading-type='solid'
      primary-color='#000000000000'
      picture-options='zoom'
      secondary-color='#000000000000'

      [org.gnome.shell.window-switcher]
      current-workspace-only=false
    '';
  };
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-user-share.enable = false;
    gnome-online-accounts.enable = true;
    tinysparql.enable = false;
  };
  programs = {
    dconf.enable = true;
    geary.enable = false;
    seahorse.enable = false;
  };
  services.telepathy.enable = false;
  services.geoclue2.enable = false;
  services.udisks2.enable = true;
  environment.systemPackages = [
    pkgs.glib.dev
    pkgs.pinentry-gnome3
    pkgs.gnome-tweaks
  ];
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];
}
