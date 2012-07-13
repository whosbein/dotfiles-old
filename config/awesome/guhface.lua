-------------------------------
--  "Guhface" awesome theme  --
--    By William Hosbein     --
-------------------------------

-- {{{ Main
theme = {}
theme.confdir       = awful.util.getdir("config")
theme.wallpaper_cmd = { "awsetbg /usr/share/awesome/themes/zenburn/zenburn-background.png" }
-- }}}

-- {{{ Styles
theme.font      = "sans 8"

-- {{{ Colors
theme.bg_normal     = "#121212"
-- theme.bg_focus      = "#a6e32d"
theme.bg_focus      = "#859133"
theme.bg_urgent     = "#fa2573"
theme.bg_minimize   = "#121212"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#d0d0d0"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#888888"
-- theme.fg_normal = "#DCDCCC"
-- theme.fg_focus  = "#F0DFAF"
-- theme.fg_urgent = "#CC9393"
-- theme.bg_normal = "#3F3F3F"
-- theme.bg_focus  = "#1E2320"
-- theme.bg_urgent = "#3F3F3F"
-- }}}

-- {{{ Borders
theme.border_width  = 2
theme.border_normal = "#121212"
-- theme.border_focus  = "#bddb01"
theme.border_focus  = "#859133"
theme.border_marked = "#91231c"
-- theme.border_width  = "1"
-- theme.border_focus  = "#6F6F6F"
-- theme.border_normal = "#3F3F3F"
-- theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
-- theme.titlebar_bg_focus  = "#3F3F3F"
-- theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "100"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.confdir .. "/icons/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.confdir .. "/icons/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.confdir .. "/icons/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.confdir .. "/icons/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/icons/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/icons/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/icons/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/icons/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/icons/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/icons/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/icons/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/icons/layouts/floating.png"
-- }}}

-- {{{ Widget
theme.widget_bat_full   = theme.confdir .. "/icons/baf_full.png"
theme.widget_bat_low    = theme.confdir .. "/icons/baf_low.png"
theme.widget_bat_empty  = theme.confdir .. "/icons/baf_empty.png"
theme.widget_bluetooth  = theme.confdir .. "/icons/bluetooth.png"
theme.widget_bug        = theme.confdir .. "/icons/bug.png"
theme.widget_bug_alert  = theme.confdir .. "/icons/bug_alert.png"
theme.widget_chat       = theme.confdir .. "/icons/chat.png"
theme.widget_clock      = theme.confdir .. "/icons/clock.png"
theme.widget_cpu        = theme.confdir .. "/icons/cpu.png"
theme.widget_email      = theme.confdir .. "/icons/email.png"
theme.widget_email_new  = theme.confdir .. "/icons/email_new.png"
theme.widget_empty      = theme.confdir .. "/icons/empty.png"
theme.widget_full       = theme.confdir .. "/icons/full.png"
theme.widget_half       = theme.confdir .. "/icons/half.png"
theme.widget_headphones = theme.confdir .. "/icons/headphones.png"
theme.widget_info_cir   = theme.confdir .. "/icons/info_circle.png"
theme.widget_info_sq    = theme.confdir .. "/icons/info_square.png"
theme.widget_mem        = theme.confdir .. "/icons/mem.png"
theme.widget_mus_next   = theme.confdir .. "/icons/mus_next.png"
theme.widget_mus_note   = theme.confdir .. "/icons/mus_note.png"
theme.widget_mus_pause  = theme.confdir .. "/icons/mus_pause.png"
theme.widget_mus_play   = theme.confdir .. "/icons/mus_play.png"
theme.widget_mus_prev   = theme.confdir .. "/icons/mus_prev.png"
theme.widget_mus_rwd    = theme.confdir .. "/icons/mus_rwd.png"
theme.widget_mus_stop   = theme.confdir .. "/icons/mus_stop.png"
theme.widget_net_down   = theme.confdir .. "/icons/net_down.png"
theme.widget_net_up     = theme.confdir .. "/icons/net_up.png"
theme.widget_net_wired  = theme.confdir .. "/icons/net_wired.png"
theme.widget_pacman     = theme.confdir .. "/icons/pacman.png"
theme.widget_pacman_new = theme.confdir .. "/icons/pacman_new.png"
theme.widget_spkr_full  = theme.confdir .. "/icons/spkr_full.png"
theme.widget_spkr_med   = theme.confdir .. "/icons/spkr_med.png"
theme.widget_spkr_mute  = theme.confdir .. "/icons/spkr_mute.png"
theme.widget_usb_drive  = theme.confdir .. "/icons/usb_drive.png"
theme.widget_usb_icon   = theme.confdir .. "/icons/usb_icon.png"
theme.widget_wifi_horiz = theme.confdir .. "/icons/wifi_horiz.png"
theme.widget_wifi_curve = theme.confdir .. "/icons/wifi_curve.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.confdir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.confdir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
