--[[pod_format="raw",created="2025-04-17 02:29:30",modified="2025-04-20 12:14:37",revision=3691]]
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
		print("You are not a winner today...", 64, 64, 8)
		color(7)
		print("You failed to defend your source,")
		print("which made it very sad and caused you to perish.")
		print("Your vessel is now free.")
		print("Press (Z or C) to return to the title.", 64, 200, 7)
	end,
}
