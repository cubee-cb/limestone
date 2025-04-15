--[[pod_format="raw",created="2025-04-15 02:01:34",modified="2025-04-15 17:34:54",revision=1555]]
-- exit
-- cubee

include("entities/entity.lua")

Exit = setmetatable({
	exits = {},
	gfx = fetch("gfx/exit.gfx")
}, {__index = Entity})

-- create exit
function Exit:create(x, y)
	local ex = setmetatable({
		t = 0,
		x = x or 128,
		y = y or 16,
		xv = 0,
		yv = 0,
		hitbox = {w = 6, h = 10},
		hitboxDamage = {w = 5, h = 13},
		
		hp = 100,
		
	}, {__index = Exit})

	add(Exit.exits, ex)

	return ex
end

function Exit.updateAll()
	local cx, cy = 0, 0
	for e in all(Exit.exits) do
		local cx2, cy2 = e:update()
		cx += cx2
		cy += cy2
	end
	cx /= #Exit.exits
	cy /= #Exit.exits

	return cx, cy
end

function Exit.drawAll()
	for e in all(Exit.exits) do
		e:draw()
	end
end

function Exit.update(_ENV)

	while not (fget(cmget(x, y), 0) or fget(cmget(x, y), 2)) and y < 1000 do
		y += 1
	end

	t = max(t + 1)

	-- return camera position
	return x, y - hitbox.h
end

function Exit.draw(_ENV)
	spr(gfx[1].bmp, x - 16, y - 82.5 + sin(t / 240) * 3)
	spr(gfx[0].bmp, x - 24, y - 80)

	debugVisuals(_ENV)

	print("hp: " .. hp, x + 16, y, 9)
end
