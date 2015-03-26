import XMonad
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Script
import XMonad.Hooks.SetWMName
import XMonad.Layout.Circle
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.SpawnOnce
import XMonad.Util.Loggers
import Control.Monad
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H

col1 = "#fcfcfc"
col2 = "#252525"
col3 = "#C0392B"
col4 = "#27ae60"
col5 = "#f39c12"
col6 = "#2980b9"
col7 = "#8e44ad"
col8 = "#16a085"
bar1 = "dzen2 -p -ta l -e 'button3=' -fn 'Exo 2-8' -fg '" ++ col1 ++ "' -bg '" ++ col2 ++ "' -h 20 -w 750"
bar2 = "sh /home/crucia/.xmonad/scripts/dzen_info_1.sh"
bar3 = "dzen2 -p -ta l -e 'button3=' -fn 'Exo 2-8' -fg '" ++ col1 ++ "' -bg '" ++ col2 ++ "' -h 20 -w 750 -y 750 -x 60"
bar4 = "sh /home/crucia/.xmonad/scripts/dzen_info_2.sh"
bar5 = "sh /home/crucia/.xmonad/scripts/dzen_menu.sh"
cal_ic = "^ca(1,xdotool key alt+space)^i(/home/crucia/.xmonad/icons/"
vtitle = "^bg(" ++ col8 ++ ")    "
vtitle_end = "    ^bg()"

startup = do
		spawnOnce "sh /home/crucia/.xmonad/scripts/autostart.sh"

myLogHook h = do
		dynamicLogWithPP $ tryPP h
tryPP :: Handle -> PP
tryPP h = defaultPP
		{ ppOutput		= hPutStrLn h
		, ppSep			= ""
		, ppTitle		= wrap vtitle vtitle_end . shorten 50
		, ppLayout		= dzenColor col1 col7 . pad . 
			( \t -> case t of
			"Spacing 10 Grid"			-> "  " ++ cal_ic ++ "grid.xbm)  ^ca()"
			"Spacing 10 Spiral"			-> "  " ++ cal_ic ++ "spiral.xbm)  ^ca()"
			"Spacing 10 Circle"			-> "  " ++ cal_ic ++ "circle.xbm)  ^ca()"
			"Spacing 10 Tall"			-> "  " ++ cal_ic ++ "sptall.xbm)  ^ca()"
			"Mirror Spacing 10 Tall"	-> "  " ++ cal_ic ++ "mptall.xbm)  ^ca()"
			"Full"						-> "  " ++ cal_ic ++ "full.xbm)  ^ca()"
			)					
		, ppOrder		= \(ws:l:t:_) -> [l,t]
		}

myLogHook2 h = do
		dynamicLogWithPP $ tryPP2 h

tryPP2 :: Handle -> PP
tryPP2 h = defaultPP
		{ ppOutput		= hPutStrLn h
		, ppCurrent		= dzenColor col1 col5 . pad
		, ppVisible		= dzenColor col1 col6 . pad
		, ppHidden		= dzenColor col1 col6 . pad
		, ppHiddenNoWindows	= dzenColor col1 col6 . pad
		, ppWsSep		= ""
		, ppSep			= ""
		, ppOrder		= \(ws:l:t:_) -> [ws]
		}

myWorkspace :: [String]
myWorkspace = clickable $ [ " Net "
		, " Term "
		, " Web "
		, " Edit "
		, " Other "
		]
		where clickable l = [ "^ca(1,xdotool key alt+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
			(i,ws) <- zip [1..] l,
			let n = i ]

myKeys = [ ((mod1Mask, xK_p), spawn "dmenu_run -b") 
		, ((mod1Mask, xK_q), spawn "killall dzen2; xmonad --recompile; xmonad --restart")]

myLayout = avoidStruts $ smartBorders (  sGrid ||| sSpiral ||| sCircle ||| sTall ||| Mirror sTall ||| Full )
		where 
			sTall = spacing 10 $ Tall 1 (1/2) (1/2)
			sGrid = spacing 10 $ Grid
			sCircle = spacing 10 $ Circle
			sSpiral = spacing 10 $ spiral (toRational (2/(1+sqrt(5)::Double)))

myApps = composeAll 
		[ className =? "Gimp" --> doFloat
		, className =? "mplayer2" --> doFloat 
		, className =? "Oblogout" --> doFullFloat
		, className =? "Viewnior" --> doFullFloat ]

main = do
		barAtas <- spawnPipe bar1
		barAtasKanan <- spawnPipe bar2
		barBawah <- spawnPipe bar3
		barBawahKanan <- spawnPipe bar4
		barMenu <- spawnPipe bar5
		xmonad $ defaultConfig
			{ manageHook = myApps <+> manageDocks <+> manageHook defaultConfig
			, layoutHook = myLayout
			, modMask = mod1Mask
			, workspaces = myWorkspace
			, terminal = "urxvtc"
			, focusedBorderColor = "#4c4c4c"
			, normalBorderColor = "" ++ col2 ++ ""
			, borderWidth = 3
			, startupHook = startup <+> setWMName "LG3D"
			, logHook = myLogHook barAtas <+> myLogHook2 barBawah
			} `additionalKeys` myKeys

