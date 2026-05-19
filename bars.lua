local awful = require("awful")
local M = {}

function M.setup(opts)
    local gears = opts.gears
    local beautiful = opts.beautiful
    local wibox = opts.wibox
	local modkey = opts.modkey
	local terminal = opts.terminal
	local mymainmenu = opts.mymainmenu
    local dpi = opts.dpi
	-- Tag persistence across monitor hotplug
	-- The save handler lives in awful.permissions.tag_screen and stores tag
	-- metadata into awful.permissions.saved_tags keyed by connector name.
	-- To disable or replace it:
	--   tag.disconnect_signal("request::screen", awful.permissions.tag_screen)

	-- Wibar

	local mytextclock = wibox.widget({
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

	-- Fires once per screen at startup AND on monitor hotplug. Restore saved tags
	-- if this connector was previously seen; otherwise create the default set.
	screen.connect_signal("request::desktop_decoration", function(s)
		-- Restore saved tags if this output was previously removed
		local output_name = s.output and s.output.name
		local restore = output_name and awful.permissions.saved_tags[output_name]
		if restore then
			awful.permissions.saved_tags[output_name] = nil
			local client_tags = {}
			for _, td in ipairs(restore) do
				local t = awful.tag.add(td.name, {
					screen = s,
					layout = td.layout,
					master_width_factor = td.master_width_factor,
					master_count = td.master_count,
					gap = td.gap,
					selected = td.selected,
				})
				for _, c in ipairs(td.clients) do
					if c.valid then
						if not client_tags[c] then
							client_tags[c] = {}
						end
						table.insert(client_tags[c], t)
					end
				end
			end
			for c, tags in pairs(client_tags) do
				c:move_to_screen(s)
				c:tags(tags)
			end
		else
			awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
		end

		s.mypromptbox = awful.widget.prompt()

		s.mylayoutbox = awful.widget.layoutbox({
			screen = s,
			buttons = {
				awful.button({}, 1, function()
					awful.layout.inc(1)
				end),
				awful.button({}, 3, function()
					awful.layout.inc(-1)
				end),
				awful.button({}, 4, function()
					awful.layout.inc(-1)
				end),
				awful.button({}, 5, function()
					awful.layout.inc(1)
				end),
			},
		})

		s.mytaglist = awful.widget.taglist({
			screen = s,
			filter = awful.widget.taglist.filter.all,
			buttons = {
				awful.button({}, 1, function(t)
					t:view_only()
				end),
				awful.button({ modkey }, 1, function(t)
					if client.focus then
						client.focus:move_to_tag(t)
					end
				end),
				awful.button({}, 3, awful.tag.viewtoggle),
				awful.button({ modkey }, 3, function(t)
					if client.focus then
						client.focus:toggle_tag(t)
					end
				end),
				awful.button({}, 4, function(t)
					awful.tag.viewprev(t.screen)
				end),
				awful.button({}, 5, function(t)
					awful.tag.viewnext(t.screen)
				end),
			},
		})

		s.mytasklist = awful.widget.tasklist({
			screen = s,
			filter = awful.widget.tasklist.filter.currenttags,
			buttons = {
				awful.button({}, 1, function(c)
					c:activate({ context = "tasklist", action = "toggle_minimization" })
				end),
				awful.button({}, 3, function()
					awful.menu.client_list({ theme = { width = 250 } })
				end),
				awful.button({}, 4, function()
					awful.client.focus.byidx(-1)
				end),
				awful.button({}, 5, function()
					awful.client.focus.byidx(1)
				end),
			},
			layout = {
				spacing = dpi(4),
				layout = wibox.layout.fixed.horizontal,
			},
			widget_template = {
				{
					{
						{ id = "icon_role", widget = awful.widget.clienticon },
						id = "icon_margin_role",
						left = dpi(6),
						right = dpi(2),
						top = dpi(4),
						bottom = dpi(4),
						widget = wibox.container.margin,
					},
					{
						{ id = "text_role", widget = wibox.widget.textbox },
						id = "text_margin_role",
						right = dpi(6),
						widget = wibox.container.margin,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
		})

		s.mywibox = awful.wibar({
			position = "top",
			screen = s,
			widget = {
				layout = wibox.layout.stack,
				{
					layout = wibox.layout.align.horizontal,
					{
						layout = wibox.layout.fixed.horizontal,
						mylauncher,
						s.mytaglist,
						s.mypromptbox,
						s.mytasklist,
					},
					{ widget = wibox.container.background },
					{
						layout = wibox.layout.fixed.horizontal,
						wibox.widget.systray(),
						s.mylayoutbox,
					},
				},
				{
					mytextclock,
					halign = "center",
					widget = wibox.container.place,
				},
			},
		})
	end)
end

return M
