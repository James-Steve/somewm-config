local M = {}

function M.setup(opts)
	local gears = opts.gears
	local beautiful = opts.beautiful
	local wibox = opts.wibox
	local modkey = opts.modkey
	local terminal = opts.terminal
	local mymainmenu = opts.mymainmenu
	local dpi = opts.dpi
	local screen = opts.screen
	local widgetbar = nil
	local mytextclock = nil
	-- Wibar
	mytextclock = wibox.widget({
		{
			{
				format = "%a %b %d  %H:%M",
				widget = wibox.widget.textclock,
			},
			left = dpi(8),
			right = dpi(8),
			widget = wibox.container.margin,
		},
		bg = beautiful.clock_bg or beautiful.bg_focus,
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, dpi(4))
		end,
		widget = wibox.container.background,
	})
	widgetbar = {
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			screen.mytaglist,
			screen.mypromptbox,
			screen.mytasklist,
		},
		nil, -- Middle Widget
		{ --Right Widgets
			layout = wibox.layout.align.horizontal,
			{
				mytextclock,
				halign = "center",
				widget = wibox.container.place,
			},
			{
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.systray(),
				screen.mylayoutbox,
			},
		},
	}
	return widgetbar
end
return M
