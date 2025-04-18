--[[pod_format="raw",created="2025-04-17 02:18:50",modified="2025-04-18 16:22:43",revision=2334]]
-- gamemode
-- cubee

GameMode = {
	current = false,
	last = false,
	go = function(next)
		GameMode.last = GameMode.current
		GameMode.current = next
		if next.init then
			next.init()
		end
	end,
	goTemp = function(next)
		GameMode.last = GameMode.current
		GameMode.current = next
	end,
	goBack = function()
		GameMode.current = GameMode.last
	end,
}
