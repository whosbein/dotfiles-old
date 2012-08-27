-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
vicious = require("vicious")
-- require("scratch")
-- Custom widget things
require("calendar2")
require("prettybytes")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
local modkey = "Mod4"
local altkey = "Mod1"

local home = os.getenv("HOME")

-- Beautiful theme
beautiful.init(home .. "/.config/awesome/guhface.lua")
-- beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
-- terminal = "xterm -fg green -bg black"
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor


-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = { names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        layouts = { layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[1] }
    }
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layouts)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Containers
topbar = {}
bottombar = {}

-- Generic Widgets
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, "%a %b %d, %l:%M %p")
calendar2.addCalendarToWidget(mytextclock, '<span bgcolor="#f92672" font_weight="bold">%s</span>')

mysystray = widget({ type = "systray" })
separator = widget({ type = "textbox" })
separator.text = " | "
spacer = widget({ type = "textbox" })
spacer.width = 6

-- Set all the icons needed
-- pacman stuff
pacicon = widget ({ type = "textbox" })
pacicon.bg_image = image(beautiful.widget_pacman)
pacicon.bg_align = "middle"
pacicon.width = 8

-- net up/down
netdownicon = widget ({ type = "textbox" })
netdownicon.bg_image = image(beautiful.widget_net_down)
netdownicon.bg_align = "middle"
netdownicon.width = 8
-- netdownicon.align = "right"
netupicon = widget ({ type = "textbox" })
netupicon.bg_image = image(beautiful.widget_net_up)
netupicon.bg_align = "middle"
netupicon.width = 8
-- netupicon.align = "left"

-- clock
clockicon = widget ({ type = "textbox" })
clockicon.bg_image = image(beautiful.widget_clock)
clockicon.bg_align = "middle"
clockicon.width = 8

-- email
emailicon = widget ({ type = "textbox" })
emailicon.bg_image = image(beautiful.widget_email)
emailicon.bg_align = "middle"
emailicon.width = 8

-- ram
memicon = widget ({ type = "textbox" })
memicon.bg_image = image(beautiful.widget_mem)
memicon.bg_align = "middle"
memicon.width = 8

-- cpu
cpuicon = widget ({ type = "textbox" })
cpuicon.bg_image = image(beautiful.widget_cpu)
cpuicon.bg_align = "middle"
cpuicon.width = 8

-- 9209 cal
calicon = widget ({ type = "textbox" })
calicon.bg_image = image(beautiful.widget_info_sq)
calicon.bg_align = "middle"
calicon.width = 8

-- Create the widgets...
netinfo = widget({ type = "textbox" })
-- When the down/up rate changes it will rezie the area which may be distracting
-- this will foce a width of 80 for the actual printed numbers part and "fix" that.
-- However, the up and down arrow icons are then placed at either side of this
-- 80 pixel width, which makes it look silly. Leaving it commented for now
-- but can uncomment if it gets too distracting.
-- netinfo.width = 80
netinfo.align = "center"
-- netdowninfo = widget ({ type = "textbox" })
-- netupinfo = widget ({ type = "textbox" })
pacinfo = widget ({ type = "textbox" })
emailinfo = widget ({ type = "textbox" })
meminfo = widget ({ type = "textbox" })
cpuinfo = widget ({ type = "textbox" })
calinfo = widget ({ type = "textbox" })

-- Tooltips
meminfo_t = awful.tooltip({objects = { meminfo},})
cpuinfo_t = awful.tooltip({objects = { cpuinfo},})
netinfo_t = awful.tooltip({objects = { netinfo},})
pacinfo_t = awful.tooltip({objects = { pacinfo},})
calinfo_t = awful.tooltip({objects = { calicon},})

-- Register widgets
-- 9209 calendar
function get_9209cal()
    local io = io.popen("/home/whosbein/bin/pyscrape.py -d now -n 1")
    local str = io:read("*all")
    str = (str:gsub("^%s*(.-)%s*$", "%1"))
    return str
end
calinfo_t:set_text(get_9209cal())
-- timer
cal_timer = timer({ timeout = 600 })
cal_timer:add_signal("timeout", function () calinfo_t:set_text(get_9209cal()) end)
cal_timer:start()

-- cpu input is $1, $2, $3, etc where $1 is total cpu usage and rest are
-- individual cores: $2 = 1st core, $3 = 2nd core, $4 = 3rd core, etc
-- single core
vicious.register(cpuinfo, vicious.widgets.cpu, -- "$2%")
    function (widget, args)
        local io = { popen = io.popen }
        local s = io.popen("ps -u $USER -o pcpu,comm | grep -v \"%CPU COMMAND\" | sort -r -n | head -n 10 | awk \'{printf \"%s%% %s\\n\", $1, $2 }\'")
        local str = ''
        
        for line in s:lines() do str = str .. line .. "\n" end

        cpuinfo_t:set_text(string.sub(str, 1, -2))
        s:close()
        return string.format('%s%% : %s%%', args[1], args[2])
    end)
-- quad core
-- vicious.register(cpuinfo, vicious.widgets.cpu, "$2% $3% $4% $5%")
-- vicious.register(netinfo, vicious.widgets.net, "${eth0 down_kb} ${eth0 up_kb}", 1)
vicious.register(netinfo, vicious.widgets.net, 
    function (widget, args)
        local io = { popen = io.popen }
        local down = io.popen("ip -s -o link show dev eth0 | awk '{print $26}'")
        local up = io.popen("ip -s -o link show dev eth0 | awk '{print $41}'")
        local local_ip = io.popen("ip addr | grep inet | grep eth0 | awk '{print $2}' | rev | cut -c 4- | rev")
        local external_ip = io.popen("curl -s http://icanhazip.com")
        local down_bytes = ''
        local up_bytes = ''
        local loc_ip = ''
        local ext_ip = ''

        for line in down:lines() do
            down_bytes = line
        end
        for line in up:lines() do
            up_bytes = line
        end
        for line in local_ip:lines() do
            loc_ip = line
        end
        for line in external_ip:lines() do
            ext_ip = line
        end

        down_bytes = prettybytes.prettify( tonumber(down_bytes) )
        up_bytes = prettybytes.prettify( tonumber(up_bytes) )

        -- popup = "down: " .. prettybytes.prettify(down_bytes) .. "\nup: " .. up_bytes
        popup = "down: " .. down_bytes .. "\nup: " .. up_bytes .. "\nlocal ip: " .. loc_ip .. "\nexternal ip: " .. ext_ip
        netinfo_t:set_text(popup)
        down:close()
        up:close()

        str = string.format('%s %s', args["{eth0 down_kb}"], args["{eth0 up_kb}"])
        return str
    end
    , 1)
-- "${eth0 down_kb} ${eth0 up_kb}", 1)
-- vicious.register(meminfo, vicious.widgets.mem, "$1% ($2Mb)", 5)
vicious.register(meminfo, vicious.widgets.mem, 
    function (widget, args)
        local io = { popen = io.popen }
        local s = io.popen("ps -u $USER -o pmem,comm | grep -v \"%MEM COMMAND\" | sort -r -n | head -n 10 | awk \'{printf \"%s%% %s\\n\", $1, $2 }\'")
        local str = ''
        
        for line in s:lines() do str = str .. line .. "\n" end

        meminfo_t:set_text(string.sub(str, 1, -2))
        s:close()
        return string.format('%s%% (%sMb)', args[1], args[2])
    end, 5)

--"$1% ($2Mb)", 5)
vicious.register(emailinfo, vicious.widgets.gmail,
  function (widget, args)
    if args["{count}"] == 0 then
      emailicon.bg_image = image(beautiful.widget_email)
      return 0
    else
      emailicon.bg_image = image(beautiful.widget_email_new)
      return args["{count}"]
    end
  end, 61)
vicious.register(pacinfo, vicious.widgets.pkg,
    function (widget, args)
        local io = { popen = io.popen }
        local s = io.popen("pacman -Qu")
        local str = ''
        
        for line in s:lines() do str = str .. line .. "\n" end

        pacinfo_t:set_text(str)
        s:close()

        if args[1] == 0 then
            pacicon.bg_image = image(beautiful.widget_pacman)
            return 0
        else
            pacicon.bg_image = image(beautiful.widget_pacman_new)
            return args[1]
        end
    end, 301, "Arch")

-- Create a wibox for each screen and add it
-- mywibox = {}
mypromptbox = {}

mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 5, awful.tag.viewnext),
                    awful.button({ }, 4, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Set a screen margin, for borders
    -- If I add borders, I'll need this
    -- awful.screen.padding( screen[s], {top = 1, bottom = 1} )

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the bars
    topbar[s] = awful.wibox({
                position = "top", screen = s --, height = 14
    })
    bottombar[s] = awful.wibox({
                position = "bottom", screen = s --, height = 14
    })

    -- Create a table of widgets
    -- right_aligned = { layout = awful.widget.layout.horizontal.rightleft}
    -- if s == 1 then table.insert(right_aligned, mysystray) end
    -- table.insert(right_aligned, mylayoutbox[s])
    topbar[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright,
            -- height = 14
        },
        spacer,
        mytextclock, spacer, clockicon, separator,
        pacinfo, spacer, pacicon, separator,
        netupicon, spacer, netinfo, spacer, netdownicon, separator,
        emailinfo, spacer, emailicon, separator,
        meminfo, spacer, memicon, separator,
        cpuinfo, spacer, cpuicon, separator,
        calicon, spacer, calinfo,
        s == 1 and mysystray or nil,
        -- mytaglist[s],
        -- mytasklist[s],
        -- right_aligned,
        layout = awful.widget.layout.horizontal.rightleft,
        -- height = 14
    }

    bottombar[s].widgets = {
        -- nil,
        mylayoutbox[s],
        mytasklist[s],
        -- mytextclock,
        layout = awful.widget.layout.horizontal.rightleft,
    }

    -- Create the wibox
    -- mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    -- mywibox[s].widgets = {
    --     {
    --         mylauncher,
    --         mytaglist[s],
    --         mypromptbox[s],
    --         layout = awful.widget.layout.horizontal.leftright
    --     },
    --     mylayoutbox[s],
    --     mytextclock,
    --     s == 1 and mysystray or nil,
    --     mytasklist[s],
    --     layout = awful.widget.layout.horizontal.rightleft
    -- }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewprev),
    awful.button({ }, 4, awful.tag.viewnext)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    -- awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal .. " -e tmux") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- lock screen & screensaver
    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),

    -- mocp
    awful.key({ modkey, "Control" }, "m", function () awful.util.spawn_with_shell("urxvt -name mocp -e mocp") end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { 
        class = "URxvt", 
        instance = "mocp" 
      },
      properties = { 
          floating = true, 
          tag = tags[1][9] 
      },
      callback = function(c)
          local w_area = screen[ c.screen ].workarea
          local winwidth = 800
          local winheight = 400
          c:geometry( { 
              x = 0,
              width = winwidth,
              y = w_area.height - winheight,
              height = winheight
              -- width = 800, 
              -- height = 400,
              -- x = 100,
              -- y = 200
          } )
      end
    },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    -- { rule = { class = "gimp" },
    --   properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
