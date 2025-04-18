--[[pod_format="raw",created="2025-04-17 02:27:51",modified="2025-04-18 16:22:43",revision=2265]]
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
		print("a winner is you!", 64, 64, gt % 30 < 15 and 7 or 10)
		print("you grew to be the best")
		print("and survived all rounds")
		print("Press btn 4 (Z) to return to title", 64, 200, 7)
	end,
}
