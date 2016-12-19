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
