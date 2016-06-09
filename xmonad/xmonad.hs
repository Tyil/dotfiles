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
import qualified Data.Map as M
import qualified XMonad.StackSet as W

import System.Exit
import System.IO

myLayoutHook = Circle
               ||| (gaps [ (U, 16)
                         , (R, 16)
                         , (L, 16)
                         , (D, 16)
                         ] $ avoidStruts (spacing 2 $ ResizableTall 1 (2/100) (1/2) []))
               ||| noBorders (fullscreenFull Full)

myManageHook = composeAll
             [ className =? "explorer.exe" --> doFloat
             ]

myWorkspaces = ["work", "social", "web", "entertainment", "games", "6", "7", "8", "9"]

-- xmobar
myXmobarPP  = xmobarPP
    { ppCurrent = xmobarColor "#6eb5f3" "" . wrap " " " "
    , ppVisible = xmobarColor "#96a967" "" . wrap " " " "
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

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmonad $ defaultConfig
         { focusedBorderColor = "#5778c1"
         , normalBorderColor  = "#393939"
         , modMask    = mod4Mask
         , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
         , keys = \conf@(XConfig { XMonad.modMask = modMask }) -> M.fromList $
                  [ ((modMask, xK_x     ), kill) -- %! Close the focused window
                  , ((modMask, xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
                  , ((modMask, xK_n     ), refresh) -- %! Resize viewed windows to the correct size

                  -- move focus up or down the window stack
                  , ((modMask, xK_j ), windows W.focusDown) -- %! Move focus to the next window
                  , ((modMask, xK_k ), windows W.focusUp  ) -- %! Move focus to the previous window

                  -- modifying the window order
                  , ((modMask .|. shiftMask, xK_Return ), windows W.swapMaster  ) -- %! Move focus to the master window
                  , ((modMask .|. shiftMask, xK_j      ), windows W.swapDown  ) -- %! Swap the focused window with the next window
                  , ((modMask .|. shiftMask, xK_k      ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

                  -- resizing the master/slave ratio
                  , ((modMask, xK_h ), sendMessage Shrink) -- %! Shrink the master area
                  , ((modMask, xK_l ), sendMessage Expand) -- %! Expand the master area

                  -- floating layer support
                  , ((modMask, xK_t ), withFocused $ windows . W.sink) -- %! Push window back into tiling

                  -- increase or decrease number of windows in the master area
                  , ((modMask .|. shiftMask, xK_h ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
                  , ((modMask .|. shiftMask, xK_l ), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

                  -- restart/quit
                  , ((modMask .|. shiftMask, xK_r ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
                  , ((modMask .|. shiftMask, xK_x ), io (exitWith ExitSuccess))
                  ]
                  ++
                  -- switch focus to workspace
                  [((m .|. modMask, k), windows $ f i)
                    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
                    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
                  ++
                  -- switch focus to screen and move client to screen
                  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
                    | (key, sc) <- zip [xK_q, xK_w, xK_e] [0..]
                    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
         , layoutHook = avoidStruts $ windowArrange myLayoutHook
         , logHook    = dynamicLogWithPP myXmobarPP
           { ppOutput = hPutStrLn xmproc }
         , terminal   = "urxvt"
         , workspaces = myWorkspaces
         }

