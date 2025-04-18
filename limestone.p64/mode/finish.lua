--[[pod_format="raw",created="2025-04-17 02:27:51",modified="2025-04-18 20:52:32",revision=3185]]
-- finish screen
-- cubee

GameMode.finish = {
	init = function()

	end,

	update = function()
		if btnp(4) then
			GameMode.go(GameMode.title)
		end
		
	end,

	draw = function()
		cls(0)
		print("A winner is you!", 64, 64, gt % 30 < 15 and 7 or 10)
		print("You built your perfect self (hopefully others agree)")
		print("and survived all rounds (yippee!)")
		print("Press (Z or C) to return to title.", 64, 200, 7)
	end,
}
