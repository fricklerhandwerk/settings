{ pkgs, ... }:
with builtins;
with lib;
{
  home.packages = with pkgs; [
    dmenu
    qutebrowser
    pass
    gnupg
  ];
  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        import XMonad.Util.EZConfig(additionalKeys)
        main = xmonad $ defaultConfig
          { terminal = "uxterm -fa 'Ubuntu Mono' -ls -xrm 'UXTerm*selectToClipboard: true'"
          , borderWidth = 3
	  , focusFollowsMouse = False
          } `additionalKeys`
          [ ((mod1Mask, xK_Return), spawn "dmenu_run")
          ]
      '';
    };
  };
  services.gpg-agent.enable = true;
}
