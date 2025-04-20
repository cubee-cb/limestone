--[[pod_format="raw",created="2025-04-17 02:19:17",modified="2025-04-20 14:43:34",revision=3788]]
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
		cls(1)
		print("\^pMidlink", 64, 64, 7)
		print(" ")
		print("Jump with (Z or C) and basic attack with (X or V).")
		print("Protect the crystal: defeat enemies, collect points, buy upgrades.")
		print("You can start rounds early by pressing btn 5 (X or V) on the crystal.")
		print("Press (Z or C) to start.", 64, 200, 7)
	end,
}
