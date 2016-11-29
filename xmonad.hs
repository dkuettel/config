import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
	xmonad $ ewmh defaultConfig
		{ manageHook = manageDocks <+> manageHook defaultConfig
		, layoutHook = avoidStruts $ layoutHook defaultConfig
		, modMask = mod4Mask -- bind mod to windows key (default was alt)
		, borderWidth = 2
		, normalBorderColor = "#073642"
		, focusedBorderColor = "#b58900"
		, handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook -- chrome and others don't support proper x11 anymore
		} `additionalKeysP`
		[ ("<F8>",spawn "~/plugins/playerctl/playerctl/playerctl play-pause")
		, ("<F9>",spawn "~/plugins/playerctl/playerctl/playerctl next")
		, ("<F7>",spawn "~/plugins/playerctl/playerctl/playerctl previous")
		, ("M-S-l",spawn "/usr/bin/slock")
		, ("M-S-h",sendMessage Expand) -- when running virtual in windows host, win-L doesn't work well
		] `additionalKeys`
		[ ((mod4Mask, xK_p), spawn "PATH=~/config/bin:~/bin:~/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin dmenu_run -i -l 50 -p '>'")
		]
