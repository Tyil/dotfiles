import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
             [ className =? "Gimp" --> doFloat
             ]

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmonad $ defaultConfig
         { modMask    = mod4Mask
         , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
         , layoutHook = avoidStruts  $  layoutHook defaultConfig
         , logHook    = dynamicLogWithPP xmobarPP
           { ppOutput = hPutStrLn xmproc }
         } `additionalKeys`
         [ ((mod4Mask .|. shiftMask, xK_z), spawn "notify-send 'sheeeet'")
         ]

