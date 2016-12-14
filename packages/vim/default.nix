{ pkgs, lib, ... }:

let
  customization = {
    vimrcConfig = (import ./customization.nix { pkgs = pkgs; });
  } // { name = "vim"; };

  custom_vim = pkgs.vim_configurable.customize customization;

in 
  lib.overrideDerivation custom_vim (o: {
    aclSupport              = false;
    cscopeSupport           = false;
    darwinSupport           = false;
    fontsetSupport          = false;
    ftNixSupport            = false;
    gpmSupport              = false;
    gui                     = false;
    hangulinputSupport      = false;
    luaSupport              = false;
    multibyteSupport        = false;
    mzschemeSupport         = false;
    netbeansSupport         = false;
    nlsSupport              = false;
    perlSupport             = false;
    pythonSupport           = false;
    rubySupport             = false;
    sniffSupport            = false;
    tclSupport              = false;
    ximSupport              = false;
    xsmpSupport             = false;
    xsmp_interactSupport    = false;
  })

