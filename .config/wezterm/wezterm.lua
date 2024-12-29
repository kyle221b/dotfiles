-- Pull in the Wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration builder
local config = wezterm.config_builder()
local act = wezterm.action

-- Appearance stuff
config.color_scheme = "GruvboxDarkHard"
config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font_size = 11.0

-- Odds and ends
config.skip_close_confirmation_for_processes_named = {
	"zsh",
	"bash",
}

-- Set up local multiplexing
-- THIS IS BROKEN (not all the time, but domain will randomly hang and I need to kill socket to start up)
-- config.unix_domains = {
-- 	{ name = "unix" },
-- }
-- config.default_gui_startup_args = { "connect", "unix" }

-- Keybindings
config.keys = {
	-- Quick selection action for URLs
	{
		key = "k",
		mods = "SUPER|SHIFT",
		action = act.QuickSelectArgs({
			label = "open url",
			patterns = {
				"https?://\\S+",
				"([a-z]+-){3}[a-z0-9-]+",
			},
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.log_info("opening: " .. url)
				wezterm.open_with(url)
			end),
		}),
	},
	-- Pane Management
	-- Create/Delete panes
	{
		key = "d",
		mods = "SUPER",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "d",
		mods = "SUPER|SHIFT",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "w",
		mods = "SUPER",
		action = act.CloseCurrentPane({ confirm = false }),
	},
	-- Move around panes
	{
		key = "h",
		mods = "SUPER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "SUPER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "SUPER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "SUPER",
		action = act.ActivatePaneDirection("Down"),
	},
}

return config
