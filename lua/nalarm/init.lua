local nalarm = require("nalarm.nalarm-module")
local keymap = vim.api.nvim_set_keymap
local default_config = {
	auto_cmd = {
		enable = true,
		which_key = false,
	},
}

local setup = function(config)
	config = config or default_config
	if config.auto_cmd.enable and config.auto_cmd.which_key and pcall(require, "which-key") then
		local wk = require("which-key")
		wk.register({
			["o"] = {
				name = "NAlarm",
				i = { "<cmd>NAlarm<CR>", "Set Alarm" },
			},
		}, { prefix = "<leader>" })
	else
		local opts = { noremap = true, silent = true }
		keymap("n", "<leader>oi", ":NAlarm<CR>", opts)
	end

	vim.cmd([[
    command! NAlarm lua require'nalarm'.beep()
  ]])
end

return {
	beep = nalarm.beep,
	setup = setup,
}
