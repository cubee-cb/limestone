--[[pod_format="raw",created="2025-04-16 14:00:22",modified="2025-04-17 02:04:10",revision=583]]
-- entrance
-- cubee

include("entities/entity.lua")

Entrance = setmetatable({
	entrances = {},
	gfx = fetch("gfx/entrance.gfx")
}, {__index = Entity})

-- create exit
function Entrance:create(x, y)
	local ex = setmetatable({
		t = 0,
		x = x or 128,
		y = y or 16,
		xv = 0,
		yv = 0,
		hitbox = {w = 10, h = 32},
		hitboxDamage = {w = 10, h = 30},

	}, {__index = Entrance})

	add(Entrance.entrances, ex)

	return ex
end

-- update all exits and average camera position
function Entrance.updateAll()
	for e in all(Entrance.entrances) do
		e:update()
	end
end

-- draw all exits
function Entrance.drawAll()
	for e in all(Entrance.entrances) do
		e:draw()
	end
end

-- base update
function Entrance.update(_ENV)
	t = max(t + 1)
end

-- base draw
function Entrance.draw(_ENV)
	spr(gfx[t%40\10].bmp, x - 32, y - 32.5 + sin(t / 240) * 3)
end
