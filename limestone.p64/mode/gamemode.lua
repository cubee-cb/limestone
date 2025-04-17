--[[pod_format="raw",created="2025-04-17 02:18:50",modified="2025-04-17 02:35:24",revision=94]]
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
