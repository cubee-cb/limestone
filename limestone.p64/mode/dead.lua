--[[pod_format="raw",created="2025-04-17 02:29:30",modified="2025-04-17 17:37:05",revision=951]]
-- game over screen
-- cubee

GameMode.dead = {
	init = function()

	end,

	update = function()
		if btnp(4) then
			GameMode.go(GameMode.title)
		end
		
	end,

	draw = function()
		cls(0)
		print("you are not a winner today...", 64, 64, 8)
		color(7)
		print("you failed to defend your source,")
		print("which made it very sad and you died")
		print("Press btn 4 (Z) to return to title", 64, 200, 7)
	end,
}
