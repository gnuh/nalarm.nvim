local helper = require("helper")
local M = {}
local api = vim.api

local Menu = require("nui.menu")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local Popup = require("nui.popup")
local NuiLine = require("nui.line")

function M.screen_blocker()
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "60%",
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

function M.set_alarm()
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
    default_value = "",
    on_close = function()
      print("Input Closed!")
    end,
    on_submit = function(value)
      local hour_str, minute_str = string.match(value, "(%d+):(%d+)")
      local hourSplit = tonumber(hour_str)
      local minuteSplit = tonumber(minute_str)
      local timer = vim.loop.new_timer()
      vim.g.beep_alarm = true
      vim.g.beep_alart_time = value
      timer:start(
        0,
        600,
        vim.schedule_wrap(function()
          if vim.g.beep_alarm == false then
            vim.notify("Alarm canceled", vim.log.levels.ERROR, {})
            timer:stop()
            timer:close()
            return
          end
          local hour = tonumber(os.date("%H"))
          local minute = tonumber(os.date("%M"))
          if hourSplit == hour and minuteSplit == minute then
            M.screen_blocker()
            vim.g.beep_alarm = false
            timer:stop()
            timer:close()
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

function M.open_option_menu()
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

function M.beep()
  M.open_option_menu()
end

return M
