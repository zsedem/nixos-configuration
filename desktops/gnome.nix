{ config, lib, pkgs, ... }:

{
  imports = [
    ../commons/networkmanager.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false; # Screensharing is broken, also flameshot does not work
    };
    desktopManager.gnome = {
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
          picture-uri='file://${ ./assets/background.jpg }'
          color-shading-type='solid'
          primary-color='#000000000000'
          picture-options='zoom'
          secondary-color='#000000000000'

          [org.gnome.desktop.screensaver]
          picture-uri='file://${ ./assets/background.jpg }'
          color-shading-type='solid'
          primary-color='#000000000000'
          picture-options='zoom'
          secondary-color='#000000000000'

          [org.gnome.shell.window-switcher]
          current-workspace-only=false
         '';
     };
  };
  services.gnome = {
      gnome-keyring.enable = true;
      gnome-user-share.enable = false;
      gnome-online-accounts.enable = true;
      tracker.enable = false;
  };
  programs = {
      dconf.enable = true;
      geary.enable = false;
      seahorse.enable = false;
  };
  services.telepathy.enable = false;
  services.geoclue2.enable = false;
  services.udisks2.enable = true;
  environment.systemPackages = [ pkgs.glib.dev pkgs.pinentry-gnome pkgs.gnome3.gnome-tweaks ];
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
}
