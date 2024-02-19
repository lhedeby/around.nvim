local M = {}

local MATCH_TABLE = {
	['"'] = { symbol = '"', closing = false },
	["'"] = { symbol = "'", closing = false },
	["("] = { symbol = ")", closing = false },
	[")"] = { symbol = "(", closing = true },
	["["] = { symbol = "]", closing = false },
	["]"] = { symbol = "[", closing = true },
	["<"] = { symbol = ">", closing = false },
	[">"] = { symbol = "<", closing = true },
	["{"] = { symbol = "}", closing = false },
	["}"] = { symbol = "{", closing = true },
}

M.around = function()
	local visual_start    = vim.fn.getpos("v");
	local cursor          = vim.fn.getpos(".");
	local selection_start = (visual_start[3] < cursor[3] or visual_start[2] < cursor[2]) and visual_start or cursor
	local selection_end   = (visual_start[3] < cursor[3] or visual_start[2] < cursor[2]) and cursor or visual_start


	local sr = selection_start[2] - 1
	local sc = selection_start[3] - 1
	local er = selection_end[2] - 1
	local ec = selection_end[3]

	local user_input = vim.fn.getcharstr()
	local match = MATCH_TABLE[user_input]
	local start_chars, end_chars = user_input, user_input
	if user_input == "t" or user_input == "<" then
		local text = ""
		local c = ""
		while c:match("^[%w]*$") do
			text = text .. c
			vim.api.nvim_echo({ { "<" }, { text } }, false, {})
			c = vim.fn.getcharstr()
		end
		start_chars = "<" .. text .. ">"
		end_chars = "</" .. text .. ">"
	elseif match ~= nil then
		if match.closing == true then
			end_chars = start_chars
			start_chars = match.symbol
		else
			end_chars = match.symbol
		end
	elseif not user_input:match("%A") then
		return
	end

	local mode = vim.api.nvim_get_mode().mode
	if mode == "V" then
		vim.api.nvim_buf_set_lines(0, er + 1, er + 1, false, { end_chars })
		vim.api.nvim_buf_set_lines(0, sr, sr, false, { start_chars })
	else
		vim.api.nvim_buf_set_text(0, er, ec, er, ec, { end_chars })
		vim.api.nvim_buf_set_text(0, sr, sc, sr, sc, { start_chars })
	end
	vim.api.nvim_input("<esc>")
end

return M
