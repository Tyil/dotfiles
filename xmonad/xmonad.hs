import XMonad
import XMonad.Layout.WindowArranger
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Circle
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import System.IO

myLayoutHook = Circle
               ||| (gaps [ (U, 16)
                         , (R, 16)
                         , (L, 16)
                         , (D, 16)
                         ] $ avoidStruts (spacing 2 $ ResizableTall 1 (2/100) (1/2) []))
               ||| Circle
               ||| noBorders (fullscreenFull Full)

myManageHook = composeAll
             [ className =? "Gimp" --> doFloat
             ]

myWorkspaces = ["work", "social", "web", "entertainment", "games", "6", "7", "8", "9"]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmonad $ defaultConfig
         { focusedBorderColor = "#5778c1"
         , normalBorderColor  = "#393939"
         , modMask    = mod4Mask
         , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
         , layoutHook = avoidStruts $ windowArrange myLayoutHook
         , logHook    = dynamicLogWithPP xmobarPP
           { ppOutput = hPutStrLn xmproc }
         , terminal   = "urxvt"
         , workspaces = myWorkspaces
         } `additionalKeys`
         [ ((mod4Mask .|. shiftMask, xK_z), spawn "notify-send 'sheeeet'")
         ]

