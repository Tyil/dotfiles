--[[
                                
     Holo Awesome WM config 2.0 
     github.com/copycat-killer  
                                
--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
                  require("awful.autofocus")
				  require("awful.remote")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratchdrop")

-- 3rd party libraries
local lain      = require("lain")

-- custom libraries
local sharedtags = require("sharedtags")
-- }}}

-- helper functions {{{
function sToHMS(secs, show_hours)
	local s = secs

	if tonumber(s) == nil then
		return "N/A"
	end

	h = math.floor(s/3600)
	s = s - (h*3600)

	m = math.floor(s/60)
	s = s - math.floor(m*60)

	if h == 0 then
		if m < 10 then
			return string.format("%d:%02d", m, s)
		end

		return string.format("%02d:%02d", m, s)
	end

	return string.format("%d:%02d:%02d", h, m, s)
end

function centerMouse(c)
	local geometry = c:geometry()
	local x = geometry.x + geometry.width / 2
	local y = geometry.y + geometry.height / 2

	mouse.coords({
		x = x,
		y = y
	}, true)
end
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- run_once("unclutter -root")
run_once("/usr/libexec/polkit-gnome-authentication-agent-1")
-- }}}

-- {{{ Local extensions
local sharedtags = require("sharedtags")
-- }}}

-- {{{ Variable definitions

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/tyil.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "st" or "urxvtc" or "urxvt" or "xterm"
editor     = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- user defined
browser    = "qutebrowser"
browser2   = "palemoon"
gui_editor = "gvim"
graphics   = "gimp"
musicplr   = terminal .. " -e ncmpc "

local layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	lain.layout.uselesspiral,
	lain.layout.uselesstile,
	lain.layout.uselesstile.left,
	awful.layout.suit.max
--	awful.layout.suit.fair,
--	awful.layout.suit.fair.horizontal,
--	awful.layout.suit.spiral,
--	awful.layout.suit.spiral.dwindle,
--	awful.layout.suit.max.fullscreen,
--	awful.layout.suit.magnifier,
	-- awesome/lain
--	lain.layout.termfair,
--	lain.layout.centerfair,
--	lain.layout.cascade,
--	lain.layout.cascadetile,
--	lain.layout.cascadework,
--	lain.layout.uselessfair,
}
-- }}}

-- {{{ Tags
local tags = sharedtags({
	{ name = " work ",    layout = layouts[2] },
	{ name = " social ",  layout = layouts[7] },
	{ name = " web ",     layout = layouts[9] },
	{ name = " email ",   layout = layouts[6] },
	{ name = " media ",   layout = layouts[9] },
	{ name = " vms ",     layout = layouts[6] },
	{ name = " games ",   layout = layouts[1] },
	{ name = " viii ",    layout = layouts[6] },
	{ name = " ix ",      layout = layouts[6] }
})
-- }}}

-- {{{ Menu
mymainmenu = awful.menu.new({
	items = require("menugen").build_menu(),
	theme = { height = 16, width = 130 }
})
mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})
-- }}}

-- {{{ create widgets
markup = lain.util.markup
blue   = "#5778c1"

-- Clock
mytextclock = awful.widget.textclock(markup("#eeeeee", "%H:%M"))
clockwidget = wibox.widget.background()
clockwidget:set_widget(mytextclock)

-- Calendar
mytextcalendar = awful.widget.textclock(markup("#eeeeee", "%Y-%m-%d"))
calendarwidget = wibox.widget.background()
calendarwidget:set_widget(mytextcalendar)
lain.widgets.calendar:attach(calendarwidget, { fg = "#eeeeee", position = "top_right" })

-- Battery
widget_battery = wibox.widget.background()
widget_battery:set_widget(
	lain.widgets.bat({
	battery = "BAT1",
		settings = function()
			bat_header = ""
			bat_p      = bat_now.perc .. "%"

			if bat_now.status == "Not present" then
				bat_header = ""
				bat_p      = ""
			end

			widget:set_markup(markup(blue, bat_header) .. bat_p)
		end
	})
)

widget_battery_img = wibox.widget.imagebox()
widget_battery_img:set_image(beautiful.icon.battery)

widget_battery_icon = wibox.widget.background()
widget_battery_icon:set_widget(widget_battery_img)

-- CPU
cpu_widget = lain.widgets.cpu({
    settings = function()
        widget:set_markup(string.format("%02s%%", cpu_now.usage))
    end
})
cpuwidget = wibox.widget.background()
cpuwidget:set_widget(cpu_widget)

-- network
widget_network_up_icon = wibox.widget.imagebox()
widget_network_up_icon:set_image(beautiful.icon.arrow_down)
widget_network_up_content = lain.widgets.net({
	settings = function()
		widget:set_markup(net_now.received)
	end
})

widget_network_down_icon = wibox.widget.imagebox()
widget_network_down_icon:set_image(beautiful.icon.arrow_up)
widget_network_down_content = lain.widgets.net({
	settings = function()
		widget:set_markup(net_now.sent)
	end
})

widget_network_up = wibox.widget.background()
widget_network_up:set_widget(widget_network_up_content)

widget_network_down = wibox.widget.background()
widget_network_down:set_widget(widget_network_down_content)

-- Weather
myweather = lain.widgets.weather({
    city_id = 123456 -- placeholder
})

-- Separators
wibox_space = wibox.widget.textbox("  ")
wibox_seperator = wibox.widget.textbox(" ║ ")

-- Create a wibox for each screen and add it
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
widget_taglist = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- }}}

-- {{{ create the bars

-- initialize empty tables for use inside the loop
wibox_top       = {}
wibox_bot       = {}
widget_layout   = {}
widget_prompt   = {}
widget_taglist  = {}
widget_taglist_content = {}
widget_tasklist = {}

for s = 1, screen.count() do
	-- create a promptbox for each screen
	widget_prompt[s] = awful.widget.prompt()

	-- create a widget to show an icon for the layout we're using
	widget_layout[s] = awful.widget.layoutbox(s)
	widget_layout[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function()
			awful.layout.inc(layouts, 1)
		end),
		awful.button({ }, 3, function()
			awful.layout.inc(layouts, -1)
		end),
		awful.button({ }, 4, function()
			awful.layout.inc(layouts, 1)
		end),
		awful.button({ }, 5, function()
			awful.layout.inc(layouts, -1)
		end)
	))

	-- create a taglist widget
	widget_taglist[s] = wibox.widget.background()
	widget_taglist[s]:set_widget(awful.widget.taglist(
		s,
		awful.widget.taglist.filter.all,
		mytaglist.buttons
	))

	-- create a tasklist for each screen
	widget_tasklist[s] = wibox.widget.background()
	widget_tasklist[s]:set_widget(awful.widget.tasklist(
		s,
		awful.widget.tasklist.filter.currenttags,
		mytasklist.buttons
	))

	-- create the top bar
	wibox_top[s] = awful.wibox({
		position = "top",
		screen   = s,
		height   = 16
	})

	wibox_bot = wibox.layout.fixed.horizontal()

	-- create the left side of the top bar
	wibox_top_left = wibox.layout.fixed.horizontal()

	-- add elements to the top left bar
	wibox_top_left:add(wibox_space)
	wibox_top_left:add(mylauncher)
	wibox_top_left:add(wibox_seperator)
	wibox_top_left:add(widget_taglist[s])
	wibox_top_left:add(wibox_seperator)
	wibox_top_left:add(widget_layout[s])
	wibox_top_left:add(wibox_seperator)
	wibox_top_left:add(widget_prompt[s])

	-- create the right side of the top bar
	wibox_top_right = wibox.layout.fixed.horizontal()

	-- only show a systray on the first screen
	if s == 1 then
		widget_systray = wibox.widget.background()

		widget_systray:set_widget(wibox.widget.systray({
			height = 16
		}))

		wibox_top_right:add(widget_systray)
		wibox_top_right:add(wibox_seperator)
	end

	-- network
	wibox_top_right:add(widget_network_up)
	wibox_top_right:add(wibox_space)
	wibox_top_right:add(widget_network_down)
	wibox_top_right:add(wibox_seperator)

	-- cpu
	wibox_top_right:add(cpu_widget)
	wibox_top_right:add(wibox_seperator)

	-- battery
	wibox_top_right:add(widget_battery)
	wibox_top_right:add(wibox_seperator)

	-- calendar
	wibox_top_right:add(calendarwidget)
	wibox_top_right:add(wibox_space)
	wibox_top_right:add(clockwidget)

	-- create layout to hold the left and the right side together
	wibox_top_layout = wibox.layout.align.horizontal()
	wibox_top_layout:set_left(wibox_top_left)
	wibox_top_layout:set_right(wibox_top_right)

	wibox_top[s]:set_widget(wibox_top_layout)

	-- create the bottom wibox
	wibox_bot[s] = awful.wibox({
		position = "bottom",
		screen = s,
		height = 16
	})

	-- now bring it all together (with the tasklist in the middle)
	wibox_bot_layout = wibox.layout.fixed.horizontal()
	wibox_bot_layout:add(widget_tasklist[s])

	wibox_bot[s]:set_widget(wibox_bot_layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey, }, "Escape", awful.tag.history.restore),

	-- awful.key({ modkey, }, "[",  awful.tag.viewprev),
	-- awful.key({ modkey, }, "]",  awful.tag.viewnext),

	awful.key({ modkey, }, "j", function ()
		awful.client.focus.byidx( 1)
		if client.focus then
			client.focus:raise()
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, }, "k", function ()
		awful.client.focus.byidx(-1)
		if client.focus then
			client.focus:raise()
			centerMouse(client.focus)
		end
	end),

	-- layout manipulation
	awful.key({ modkey, "Shift" }, "j", function ()
		awful.client.swap.byidx(  1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Shift" }, "k", function ()
		awful.client.swap.byidx( -1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Control" }, "j", function ()
		awful.screen.focus_relative( 1)
--		if client.focus then
--			centerMouse(client.focus)
--		end
	end),
	awful.key({ modkey, "Control" }, "k", function ()
		awful.screen.focus_relative(-1)
--		if client.focus then
--			centerMouse(client.focus)
--		end
	end),
	awful.key({ modkey, }, "u", function ()
		awful.client.urgent.jumpto()
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, }, "Tab", function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
			centerMouse(client.focus)
		end
	end),
--	end),

	-- awesome functionality
	awful.key({ modkey, "Shift" }, "r", awesome.restart),
	awful.key({ modkey, "Shift" }, "x", awesome.quit),

	awful.key({ modkey, }, "l", function ()
		awful.tag.incmwfact( 0.05)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, }, "h", function ()
		awful.tag.incmwfact(-0.05)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Shift" }, "h", function ()
		awful.tag.incnmaster( 1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Shift" }, "l", function ()
		awful.tag.incnmaster(-1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Control" }, "h", function ()
		awful.tag.incncol( 1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Control" }, "l", function ()
		awful.tag.incncol(-1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, }, "space", function ()
		awful.layout.inc(layouts,  1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),
	awful.key({ modkey, "Shift" }, "space", function ()
		awful.layout.inc(layouts, -1)
		if client.focus then
			centerMouse(client.focus)
		end
	end),

	awful.key({ modkey, "Control" }, "n", awful.client.restore),

-- prompts
	awful.key({ modkey }, "c", function ()
		awful.prompt.run(
			{ prompt = "Calculate: " },
			mypromptbox[mouse.screen].widget,
			function (e)
				local result = awful.util.eval("return ("..e..")")
				naughty.notify({
					title = e,
					text  = result
				})
			end
		)
	end),
	awful.key({ modkey }, "x", function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
		widget_prompt[mouse.screen].widget,
		awful.util.eval, nil,
		awful.util.getdir("cache") .. "/history_eval")
	end),

	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey, }, "f", function (c)
		c.fullscreen = not c.fullscreen
		centerMouse(c)
	end),
	awful.key({ modkey, "Shift", }, "q", function (c)
		c:kill()
	end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Shift" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey, }, "o", awful.client.movetoscreen),
	awful.key({ modkey, }, "t", function (c)
		c.ontop = not c.ontop
	end),
	awful.key({ modkey, }, "n", function (c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end),
	awful.key({ modkey, }, "t", function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
			-- View tag only.
			awful.key({ modkey }, "#" .. i + 10,
				function ()
					local tag = tags[i]
					if tag then
						sharedtags.viewonly(tag)
					end
				end),
			-- Toggle tag.
			awful.key({ modkey, "Control" }, "#" .. i + 10,
				function ()
					local tag = tags[i]
					if tag then
						sharedtags.viewtoggle(tag)
					end
				end),
			-- Move client to tag.
			awful.key({ modkey, "Shift" }, "#" .. i + 10,
				function ()
					if client.focus then
						local tag = tags[i]
						if tag then
							awful.client.movetotag(tag)
						end
					end
				end),
		-- Toggle tag.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 10, function ()
			if client.focus then
				local tag = tags[i]
				if tag then
					awful.client.toggletag(tag)
				end
			end
		end)
	)
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	-- general rules
	{
		rule = { },
		properties = {
			buttons          = clientbuttons,
			focus            = awful.client.focus.filter,
			keys             = clientkeys,
			size_hints_honor = false
		}
	},

	-- make certain apps floating by default
	{ properties = { floating = true }, rule = { class = "feh" } },

	-- spawn the following apps on certain tags
	{ properties = { tag = tags[1] }, rule = { class = "jetbrains-idea" } },
	{ properties = { tag = tags[1] }, rule = { class = "atom" } },
	{ properties = { tag = tags[2] }, rule = { class = "mumble" } },
	{ properties = { tag = tags[2] }, rule = { class = "qtox" } },
	{ properties = { tag = tags[3] }, rule = { class = "Chromium-browser-chromium" } },
	{ properties = { tag = tags[3] }, rule = { class = "Pale moon" } },
	{ properties = { tag = tags[3] }, rule = { class = "qutebrowser" } },
	{ properties = { tag = tags[4] }, rule = { class = "Thunderbird" } },
	{ properties = { tag = tags[5] }, rule = { class = "mpv" } },
	{ properties = { tag = tags[6] }, rule = { class = "VirtualBox" } },
	{ properties = { tag = tags[6] }, rule = { class = "virt-manager" } },
	{ properties = { tag = tags[7] }, rule = { class = "Steam" } },
	{ properties = { tag = tags[7] }, rule = { class = "Wine" } },
	{ properties = { tag = tags[7] }, rule = { class = "dota2" } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
local sloppyfocus_last = {c=nil}
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    client.connect_signal("mouse::enter", function(c)
         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
             -- Skip focusing the client if the mouse wasn't moved.
             if c ~= sloppyfocus_last.c then
                 client.focus = c
                 sloppyfocus_last.c = c
             end
         end
     end)

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=16}):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    c.border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}

