local Menu = require("nui.menu")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local Popup = require("nui.popup")
local NuiLine = require("nui.line")
local timer = vim.loop.new_timer()

local M = {}
M.screen_blocker = function()
	local popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
		},
		position = "30%",
		size = {
			width = "98%",
			height = "90%",
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	})
	popup:map("n", "<Esc>", function()
		popup:unmount()
	end, { noremap = true })
	popup:mount()
	popup:on(event.BufLeave, function()
		popup:unmount()
	end)
	local line = NuiLine()
	line:append("ALARM: " .. os.date("%H") .. ":" .. os.date("%M"), "Error")
	local bufnr, ns_id, linenr_start = 0, -1, 1
	line:render(bufnr, ns_id, linenr_start)
end

M.stop_alarm = function(msg, log)
	if log == nil then
		log = vim.log.levels.WARN
	end
	vim.notify(msg, log, {})
	timer:stop()
	vim.g.beep_alart_time = ""
	vim.g.beep_alarm = false
end

M.set_alarm = function()
	local input = Input({
		position = "50%",
		size = {
			width = 20,
		},
		border = {
			style = "single",
			text = {
				top = "[Set Alarm][" .. os.date("%H") .. ":" .. os.date("%M") .. "],",
				top_align = "center",
			},
		},
		keymap = {
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		prompt = "> ",
		default_value = vim.g.beep_alart_time or "",
		on_close = function()
			print("Input Closed!")
		end,
		on_submit = function(value)
			local hour_str, minute_str = string.match(value, "(%d+):(%d+)")
			local hourSplit = tonumber(hour_str)
			local minuteSplit = tonumber(minute_str)
			if vim.g.beep_alarm then
				M.stop_alarm("New alarm set " .. value)
			else
				vim.notify("Alarm SET " .. value, vim.log.levels.INFO, {})
			end
			vim.g.beep_alarm = true
			vim.g.beep_alart_time = value
			timer:start(
				0,
				600,
				vim.schedule_wrap(function()
					local hour = tonumber(os.date("%H"))
					local minute = tonumber(os.date("%M"))
					if hour >= hourSplit and minute >= minuteSplit then
						M.stop_alarm("ALARM", vim.log.levels.INFO)
						M.screen_blocker()
					end
					if vim.g.beep_alarm == false then
						M.stop_alarm("Alarm canceled", vim.log.levels.ERROR)
					end
				end)
			)
		end,
	})
	input:map("n", "<Esc>", function()
		input:unmount()
	end, { noremap = true })
	input:mount()
	input:on(event.BufLeave, function()
		input:unmount()
	end)
end

M.open_option_menu = function()
	local menu = Menu({
		position = "50%",
		size = {
			width = 25,
			height = 5,
		},
		border = {
			style = "double",
			text = {
				top = vim.g.beep_alarm and "[" .. os.date("%H") .. ":" .. os.date("%M") .. "]" or "[Set Alarm]",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		lines = { Menu.item("Set Alarm"), Menu.item("Cancel Alarm") },
		max_width = 20,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_submit = function(item)
			if item.text == "Set Alarm" then
				M.set_alarm()
			end
			if item.text == "Cancel Alarm" then
				vim.g.beep_alarm = false
			end
		end,
	})
	menu:mount()
end

M.beep = function()
	M.open_option_menu()
end

return M
