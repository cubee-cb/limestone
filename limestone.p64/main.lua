--[[pod_format="raw",created="2024-03-18 18:22:30",modified="2025-04-17 17:37:05",revision=5091]]
-- limestone (internal)
-- by cubee

--[[
still in the habit of token optimisaiton, so I use _ENV everywhere.
will use better inheritance in the future.
]]

--[[
db = {
	--collision = true,
	--entityCollision = true,
}
--]]

include("entities/entity.lua")
include("entities/player.lua")
include("entities/enemy.lua")
include("entities/exit.lua")
include("entities/entrance.lua")
include("entities/pickup.lua")
include("entities/particle.lua")
include("entities/storeItem.lua")

include("helpers/motion.lua")
include("helpers/map.lua")
include("helpers/rspr.lua")

include("data/rounds.lua")
include("data/items.lua")
include("mode/gamemode.lua")
include("mode/title.lua")
include("mode/game.lua")
include("mode/finish.lua")
include("mode/dead.lua")

function _init()
	poke(0x5f5c, 255)
	
	gt = 0
	GameMode.go(GameMode.title)
	GameMode.go(GameMode.game)

end

function _update()

	GameMode.current.update()


	gt = max(gt + 1, 0)
end

function _draw()
	cls(1)

	GameMode.current.draw()

end
