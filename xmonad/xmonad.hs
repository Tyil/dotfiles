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

-- xmobar
myXmobarPP  = xmobarPP
    { ppCurrent = xmobarColor "#000000" "#5778c1" . wrap " " " "
    , ppVisible = xmobarColor "#000000" "#96a967" . wrap " " " "
    , ppHidden  = xmobarColor "#ffffff" "" . wrap " " " "
    , ppHiddenNoWindows = xmobarColor "#999999" "" . wrap " " " "
    , ppUrgent  = xmobarColor "#ff0000" "" . wrap " " " "
    , ppSep     = " ║ "
    , ppLayout = \y -> "" -- hide layout indicator
--    , ppLayout  = ( \t -> case t of
--                    "Spacing 2 ResizableTall" -> " TALL "
--                    "Full" -> " FULL "
--                    "Circle" -> " CIRC "
--                    _ -> " WHO KNOWS "
--                  )
    , ppTitle   = xmobarColor "#ffffff" "" . wrap " " " "
    }
myLogHook h = dynamicLogWithPP $ myXmobarPP { ppOutput = hPutStrLn h }

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmonad $ defaultConfig
         { focusedBorderColor = "#5778c1"
         , normalBorderColor  = "#393939"
         , modMask    = mod4Mask
         , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
         , layoutHook = avoidStruts $ windowArrange myLayoutHook
         , logHook    = dynamicLogWithPP myXmobarPP
           { ppOutput = hPutStrLn xmproc }
         , terminal   = "urxvt"
         , workspaces = myWorkspaces
         } `additionalKeys`
         [ ((mod4Mask .|. shiftMask, xK_z), spawn "notify-send 'sheeeet'")
         ]

