import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
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
		[ ("<F8>",spawn "/home/kuettel/plugins/playerctl/playerctl/playerctl play-pause")
		, ("<F9>",spawn "/home/kuettel/plugins/playerctl/playerctl/playerctl next")
		, ("<F7>",spawn "/home/kuettel/plugins/playerctl/playerctl/playerctl previous")
		, ("M-S-l",spawn "/usr/bin/slock")
		]
