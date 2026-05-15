local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")
local menubar = require("menubar")

local M = {}

function M.setup(opts)
	local modkey = opts.modkey
	local terminal = opts.terminal
	local mymainmenu = opts.mymainmenu

	-- Mouse bindings
	awful.mouse.append_global_mousebindings({
		awful.button({}, 3, function()
			mymainmenu:toggle()
		end),
		awful.button({}, 4, awful.tag.viewprev),
		awful.button({}, 5, awful.tag.viewnext),
	})

	-- somewm
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			key = "s",
			on_press = hotkeys_popup.show_help,
			description = "show help",
			group = "somewm",
		}),
		awful.key({
			modifiers = { modkey },
			key = "w",
			on_press = function()
				mymainmenu:show()
			end,
			description = "show main menu",
			group = "somewm",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "r",
			on_press = awesome.restart,
			description = "reload somewm",
			group = "somewm",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "q",
			on_press = awesome.quit,
			description = "quit somewm",
			group = "somewm",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "Escape",
			on_press = function()
				awesome.lock()
			end,
			description = "lock screen",
			group = "somewm",
		}),
		awful.key({
			modifiers = { modkey },
			key = "x",
			on_press = function()
				awful.prompt.run({
					prompt = "Run Lua code: ",
					textbox = awful.screen.focused().mypromptbox.widget,
					exe_callback = awful.util.eval,
					history_path = awful.util.get_cache_dir() .. "/history_eval",
				})
			end,
			description = "lua execute prompt",
			group = "somewm",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "d",
			on_press = function()
				naughty.suspended = not naughty.suspended
				naughty.notification({
					title = "Notifications",
					text = naughty.suspended and "Do Not Disturb" or "Resumed",
					timeout = 2,
					ignore_suspend = true,
				})
			end,
			description = "toggle do-not-disturb",
			group = "somewm",
		}),
	})

	-- launcher
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "Return",
			on_press = function()
				awful.spawn(terminal)
			end,
			description = "open a terminal",
			group = "launcher",
		}),
		awful.key({
			modifiers = { modkey },
			key = "r",
			on_press = function()
				awful.screen.focused().mypromptbox:run()
			end,
			description = "run prompt",
			group = "launcher",
		}),
		awful.key({
			modifiers = { modkey },
			key = "p",
			on_press = function()
				menubar.show()
			end,
			description = "show the menubar",
			group = "launcher",
		}),
	})

	-- tag
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			key = "Left",
			on_press = awful.tag.viewprev,
			description = "view previous",
			group = "tag",
		}),
		awful.key({
			modifiers = { modkey },
			key = "Right",
			on_press = awful.tag.viewnext,
			description = "view next",
			group = "tag",
		}),
		awful.key({
			modifiers = { modkey },
			key = "Escape",
			on_press = awful.tag.history.restore,
			description = "go back",
			group = "tag",
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			key = "r",
			on_press = function()
				local s = awful.screen.focused()
				local t = s.selected_tag
				if not t then
					return
				end
				awful.prompt.run({
					prompt = "Rename tag: ",
					text = t.name,
					textbox = s.mypromptbox.widget,
					exe_callback = function(new_name)
						if new_name and new_name ~= "" then
							t.name = new_name
						end
					end,
				})
			end,
			description = "rename current tag",
			group = "tag",
		}),
	})

	-- client
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			key = "j",
			on_press = function()
				awful.client.focus.byidx(1)
			end,
			description = "focus next by index",
			group = "client",
		}),
		awful.key({
			modifiers = { modkey },
			key = "k",
			on_press = function()
				awful.client.focus.byidx(-1)
			end,
			description = "focus previous by index",
			group = "client",
		}),
        --change this to used workspaces (tag)
		awful.key({
			modifiers = { modkey },
			key = "Tab",
			on_press = function()
				awful.client.focus.history.previous()
				if client.focus then
					client.focus:raise()
				end
			end,
			description = "go back",
			group = "client",
		}),
		awful.key({
			modifiers = { modkey },
			key = "u",
			on_press = awful.client.urgent.jumpto,
			description = "jump to urgent client",
			group = "client",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "j",
			on_press = function()
				awful.client.swap.byidx(1)
			end,
			description = "swap with next client by index",
			group = "client",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "k",
			on_press = function()
				awful.client.swap.byidx(-1)
			end,
			description = "swap with previous client by index",
			group = "client",
		}),
        --todo
        --one binding for restore
        --one bindging for minimize
		awful.key({
			modifiers = { modkey, "Control" },
			key = "n",
			on_press = function()
				local c = awful.client.restore()
				if c then
					c:activate({ raise = true, context = "key.unminimize" })
				end
			end,
			description = "restore minimized",
			group = "client",
		}),
	})

	-- screen
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey, "Control" },
			key = "j",
			on_press = function()
				awful.screen.focus_relative(1)
			end,
			description = "focus the next screen",
			group = "screen",
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			key = "k",
			on_press = function()
				awful.screen.focus_relative(-1)
			end,
			description = "focus the previous screen",
			group = "screen",
		}),
	})

	-- audio (requires wpctl from wireplumber)
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = {},
			key = "XF86AudioRaiseVolume",
			on_press = function()
				awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
			end,
			description = "raise volume",
			group = "audio",
		}),
		awful.key({
			modifiers = {},
			key = "XF86AudioLowerVolume",
			on_press = function()
				awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
			end,
			description = "lower volume",
			group = "audio",
		}),
		awful.key({
			modifiers = {},
			key = "XF86AudioMute",
			on_press = function()
				awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
			end,
			description = "mute output",
			group = "audio",
		}),
		awful.key({
			modifiers = {},
			key = "XF86AudioMicMute",
			on_press = function()
				awful.spawn("wpctl set-mute @DEFAULT_SOURCE@ toggle")
			end,
			description = "mute microphone",
			group = "audio",
		}),
	})

	-- brightness (requires brightnessctl)
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = {},
			key = "XF86MonBrightnessUp",
			on_press = function()
				awful.spawn("brightnessctl set 5%+")
			end,
			description = "raise brightness",
			group = "brightness",
		}),
		awful.key({
			modifiers = {},
			key = "XF86MonBrightnessDown",
			on_press = function()
				awful.spawn("brightnessctl set 5%-")
			end,
			description = "lower brightness",
			group = "brightness",
		}),
	})

	-- screenshot (requires grim, slurp)
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = {},
			key = "Print",
			on_press = function()
				awful.spawn.with_shell("mkdir -p ~/Pictures && grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png")
			end,
			description = "screenshot full output",
			group = "screenshot",
		}),
		awful.key({
			modifiers = { "Shift" },
			key = "Print",
			on_press = function()
				awful.spawn.with_shell(
					"mkdir -p ~/Pictures && slurp | grim -g - ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
				)
			end,
			description = "screenshot region",
			group = "screenshot",
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			key = "p",
			on_press = function()
				local s = awful.screenshot({ interactive = true })
				s:connect_signal("snipping::start", function(self)
					if self._private.frame then
						self._private.imagebox.visible = false
						self._private.frame.bg = "#00000040"
						self._private.frame.surface_scale = 1.0
					end
				end)
				s:refresh()
			end,
			description = "interactive screenshot (region/window)",
			group = "screenshot",
		}),
	})

	-- layout
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			key = "l",
			on_press = function()
				awful.tag.incmwfact(0.05)
			end,
			description = "increase master width factor",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey },
			key = "h",
			on_press = function()
				awful.tag.incmwfact(-0.05)
			end,
			description = "decrease master width factor",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "h",
			on_press = function()
				awful.tag.incnmaster(1, nil, true)
			end,
			description = "increase the number of master clients",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "l",
			on_press = function()
				awful.tag.incnmaster(-1, nil, true)
			end,
			description = "decrease the number of master clients",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			key = "h",
			on_press = function()
				awful.tag.incncol(1, nil, true)
			end,
			description = "increase the number of columns",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			key = "l",
			on_press = function()
				awful.tag.incncol(-1, nil, true)
			end,
			description = "decrease the number of columns",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey },
			key = "space",
			on_press = function()
				awful.layout.inc(1)
			end,
			description = "select next",
			group = "layout",
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			key = "space",
			on_press = function()
				awful.layout.inc(-1)
			end,
			description = "select previous",
			group = "layout",
		}),
	})

	-- tag (numrow)
	--
	-- These bindings work as four Mod variants:
	--   Mod+N            view only this tag
	--   Mod+Ctrl+N       toggle viewing this tag (multi-tag view)
	--   Mod+Shift+N      move focused client to this tag
	--   Mod+Ctrl+Shift+N toggle focused client on this tag (one client, many tags)
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			keygroup = "numrow",
			description = "only view tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					tag:view_only()
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control" },
			keygroup = "numrow",
			description = "toggle tag",
			group = "tag",
			on_press = function(index)
				local screen = awful.screen.focused()
				local tag = screen.tags[index]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Shift" },
			keygroup = "numrow",
			description = "move focused client to tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
		}),
		awful.key({
			modifiers = { modkey, "Control", "Shift" },
			keygroup = "numrow",
			description = "toggle focused client on tag",
			group = "tag",
			on_press = function(index)
				if client.focus then
					local tag = client.focus.screen.tags[index]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
		}),
	})

	-- layout (numpad)
	awful.keyboard.append_global_keybindings({
		awful.key({
			modifiers = { modkey },
			keygroup = "numpad",
			description = "select layout directly",
			group = "layout",
			on_press = function(index)
				local t = awful.screen.focused().selected_tag
				if t then
					t.layout = t.layouts[index] or t.layout
				end
			end,
		}),
	})
end

return M
