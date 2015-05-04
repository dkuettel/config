import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import System.IO

main = do
	xmonad $ defaultConfig
		{ manageHook = manageDocks <+> manageHook defaultConfig
		, layoutHook = avoidStruts $ layoutHook defaultConfig
		, modMask = mod4Mask -- bind mod to windows key (default was alt)
		, borderWidth = 2
		} `additionalKeysP`
		[ ("<F8>",spawn "/home/kuettel/playerctl/playerctl/playerctl play-pause")
		, ("<F9>",spawn "/home/kuettel/playerctl/playerctl/playerctl next")
		, ("<F7>",spawn "/home/kuettel/playerctl/playerctl/playerctl previous")
		]
