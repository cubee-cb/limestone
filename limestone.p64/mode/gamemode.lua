--[[pod_format="raw",created="2025-04-17 02:18:50",modified="2025-04-17 03:00:35",revision=164]]
-- gamemode
-- cubee

GameMode = {
	current = false,
	go = function(next)
		GameMode.current = next
		if GameMode.current.init then
			GameMode.current.init()
		end
	end,
}
