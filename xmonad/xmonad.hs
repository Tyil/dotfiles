import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Circle
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

import System.Exit
import System.IO

myLayoutHook = Circle
               ||| (gaps [ (U, 8)
                         , (R, 8)
                         , (L, 8)
                         , (D, 8)
                         ] $ (spacing 4 $ ResizableTall 1 (2/100) (0.6) []))
               ||| noBorders (fullscreenFull Full)
               ||| simplestFloat

myManageHook = composeAll
             [ className =? "Pale moon" --> doShift "web"
             , className =? "chromium-browser-chromium" --> doShift "web"
             , className =? "Steam" --> doShift "games"
             , className =? "dota2" --> doShift "games"
             , className =? "jetbrains-idea" --> doShift "work"
             , className =? "mpv" --> doFloat
             , className =? "mumble" --> doShift "social"
             , className =? "qutebrowser" --> doShift "web"
             , appName   =? "urxvt_ncmpc" --> doShift "entertainment"
             ]

myWorkspaces = ["work", "social", "web", "entertainment", "games", "six", "seven", "eight", "nine"]

-- xmobar
myXmobarPP  = xmobarPP
    { ppCurrent         = xmobarColor "#6eb5f3" "" . wrap " " " "
    , ppVisible         = xmobarColor "#96a967" "" . wrap " " " "
    , ppHidden          = xmobarColor "#ffffff" "" . wrap " " " "
    , ppHiddenNoWindows = xmobarColor "#999999" "" . wrap " " " "
    , ppUrgent          = xmobarColor "#ff0000" "" . wrap " " " "
    , ppSep             = " ║ "
    , ppLayout          = \y -> "" -- hide layout indicator
    , ppWsSep           = ""       -- no seperator between layouts
    , ppTitle           = \y -> "" -- hide window title
    }

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
         { focusedBorderColor = "#5778c1"
         , normalBorderColor  = "#393939"
         , modMask    = mod4Mask
         , manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
         , handleEventHook = docksEventHook <+> handleEventHook defaultConfig
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

