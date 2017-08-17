theme      = {}
theme.icon = {}

theme.icon_dir                      = os.getenv("HOME") .. "/.icons/awesome-tyil"

theme.font                          = "Liberation Mono 10"
theme.taglist_font                  = "Liberation Mono 10"
theme.fg_normal                     = "#eeeeee"
theme.fg_focus                      = "#0099CC"
theme.bg_normal                     = "#242424"
theme.fg_urgent                     = "#CC9393"
theme.bg_urgent                     = "#2A1F1E"
theme.border_width                  = 2
theme.border_normal                 = "#252525"
theme.border_focus                  = "#4d679a"
theme.taglist_fg_focus              = "#eeeeee"
theme.taglist_bg_focus              = "#5778c1"
theme.tasklist_bg_normal            = "#242424"
theme.tasklist_fg_focus             = "#eeeeee"
theme.tasklist_bg_focus             = "#5778c1"
theme.textbox_widget_margin_top     = 1
theme.awful_widget_height           = 14
theme.awful_widget_margin_top       = 2
theme.menu_height                   = "20"
theme.menu_width                    = "600"

theme.awesome_icon                  = theme.icon_dir .. "/awesome.png"
theme.submenu_icon                  = theme.icon_dir .. "/submenu.png"

theme.layout_tile                   = theme.icon_dir .. "/layouts/tile.png"
theme.layout_tilegaps               = theme.icon_dir .. "/layouts/tilegaps.png"
theme.layout_tileleft               = theme.icon_dir .. "/layouts/tileleft.png"
theme.layout_tilebottom             = theme.icon_dir .. "/layouts/tilebottom.png"
theme.layout_tiletop                = theme.icon_dir .. "/layouts/tiletop.png"
theme.layout_fairv                  = theme.icon_dir .. "/layouts/fairv.png"
theme.layout_fairh                  = theme.icon_dir .. "/layouts/fairh.png"
theme.layout_spiral                 = theme.icon_dir .. "/layouts/spiral.png"
theme.layout_dwindle                = theme.icon_dir .. "/layouts/dwindle.png"
theme.layout_max                    = theme.icon_dir .. "/layouts/max.png"
theme.layout_fullscreen             = theme.icon_dir .. "/layouts/fullscreen.png"
theme.layout_magnifier              = theme.icon_dir .. "/layouts/magnifier.png"
theme.layout_floating               = theme.icon_dir .. "/layouts/floating.png"

theme.tasklist_disable_icon         = true
theme.tasklist_floating             = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical   = ""

-- lain related
theme.useless_gap_width      = 32

theme.layout_uselesstile     = theme.icon_dir .. "/layouts/uselesstile.png"
theme.layout_uselesstileleft = theme.icon_dir .. "/layouts/uselesstileleft.png"
theme.layout_uselesstiletop  = theme.icon_dir .. "/layouts/uselesstiletop.png"
theme.layout_tilebottom      = theme.icon_dir .. "/layouts/tilebottom.png"
theme.layout_tileleft        = theme.icon_dir .. "/layouts/tileleft.png"
theme.layout_tile            = theme.icon_dir .. "/layouts/tile.png"
theme.layout_tiletop         = theme.icon_dir .. "/layouts/tiletop.png"
theme.layout_spiral          = theme.icon_dir .. "/layouts/spiral.png"
theme.layout_uselesspiral    = theme.icon_dir .. "/layouts/spiral.png"
theme.layout_dwindle         = theme.icon_dir .. "/layouts/dwindle.png"

return theme

