import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Circle
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)

import System.IO

myLayoutHook = Circle
               ||| (gaps [ (U, 16)
                         , (R, 16)
                         , (L, 16)
                         , (D, 16)
                         ] $ avoidStruts (spacing 2 $ ResizableTall 1 (2/100) (1/2) []))
               ||| noBorders (fullscreenFull Full)

myManageHook = composeAll
             [ className =? "Gimp" --> doFloat
             ]

myWorkspaces = ["work", "social", "web", "entertainment", "games", "6", "7", "8", "9"]

-- dzen
myDzenStatus = "dzen2 -x '0' -w 1920 -ta 'l'" ++ myDzenStyle
myDzenStyle  = " -y '0' -fg '#777777' -bg '#222222' -fn 'Liberation Mono-10'"
myDzenPP  = dzenPP
    { ppCurrent = dzenColor "#000000" "#5778c1" . wrap " " " "
    , ppVisible = dzenColor "#000000" "#96a967" . wrap " " " "
    , ppHidden  = dzenColor "#ffffff" "" . wrap " " " "
    , ppHiddenNoWindows = dzenColor "#999999" "" . wrap " " " "
    , ppUrgent  = dzenColor "#ff0000" "" . wrap " " " "
    , ppSep     = " ║ "
    , ppLayout = \y -> "" -- hide layout indicator
--    , ppLayout  = ( \t -> case t of
--                    "Spacing 2 ResizableTall" -> " TALL "
--                    "Full" -> " FULL "
--                    "Circle" -> " CIRC "
--                    _ -> " WHO KNOWS "
--                  )
    , ppTitle   = dzenColor "#ffffff" "" . wrap " " " "
    }
myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }

main = do
  status <- spawnPipe myDzenStatus
  xmonad $ defaultConfig
         { focusedBorderColor = "#5778c1"
         , normalBorderColor  = "#393939"
         , modMask    = mod4Mask
         , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
         , layoutHook = avoidStruts $ windowArrange myLayoutHook
         , logHook    = myLogHook status
         , terminal   = "urxvt"
         , workspaces = myWorkspaces
         } `additionalKeys`
         [ ((mod4Mask .|. shiftMask, xK_z), spawn "notify-send 'sheeeet'")
         ]

