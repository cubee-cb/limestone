--[[pod_format="raw",created="2025-04-17 02:19:17",modified="2025-04-17 02:36:38",revision=95]]
-- title screen
-- cubee

GameMode.title = {
	init = function()

	end,

	update = function()
		if btnp(4) then
			GameMode.go(GameMode.game)
		end
		
	end,

	draw = function()
		cls(2)
	end,
}
