{ config, lib, pkgs, ... }:

{
  services.xserver.desktopManager.gnome3.extraGSettingsOverrides = ''
          [org.gnome.desktop.input-sources]
          sources=[('xkb', 'us'), ('xkb', 'hu')]

          [org.gnome.desktop.peripherals.touchpad]
          natural-scroll=false
          tap-to-click=true

          [org.gnome.desktop.wm.keybindings]
          switch-to-workspace-right=[""]
          switch-to-workspace-left=[""]

          [org.gnome.desktop.interface]
          clock-show-date=true

          [org.gnome.desktop.background]
          picture-uri='file:///home/zsedem/Pictures/1473440846117.jpg'
          color-shading-type='solid'
          primary-color='#000000000000'
          picture-options='zoom'
          secondary-color='#000000000000'

          [org.gnome.desktop.screensaver]
          picture-uri='file:///home/zsedem/Pictures/1473440846117.jpg'
          color-shading-type='solid'
          primary-color='#000000000000'
          picture-options='zoom'
          secondary-color='#000000000000'

          [org.gnome.shell]
          enabled-extensions=['alternate-tab@gnome-shell-extensions.gcampax.github.com']

          [org.gnome.shell.window-switcher]
          current-workspace-only=false
         '';
  services.gnome3 = {
      gnome-keyring.enable = true;
      gnome-documents.enable = false;
      gnome-user-share.enable = false;
      gnome-online-accounts.enable = false;
      seahorse.enable = false;
      tracker.enable = false;
    };
  services.telepathy.enable = false;
  services.geoclue2.enable = false;
  services.packagekit.enable = false;
}
