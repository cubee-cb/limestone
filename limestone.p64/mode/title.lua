--[[pod_format="raw",created="2025-04-17 02:19:17",modified="2025-04-18 16:22:43",revision=2331]]
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
		print("that old limestone mine down the road", 64, 64, 7)
		print("Press btn 4 (Z) to start", 64, 200, 7)
	end,
}
