--[[pod_format="raw",created="2025-04-15 02:20:17",modified="2025-04-15 17:34:54",revision=1492]]
-- entity
-- cubee

Entity = setmetatable({
	entities = {},
	gfx = fetch("gfx/default.gfx")
}, {__index = _ENV})

-- create entity
function Entity.create(x, y)
	local en = setmetatable({
		t = 0,
		x = x or 128,
		y = y or 16,
		xv = 0,
		yv = 0,
		hitbox = {w = 6, h = 10},
		hitboxDamage = {w = 4, h = 6},
		
		hp = 100,
		
	}, {__index = Entity})

	add(Entity.entities, en)

	return en
end

function Entity.updateAll()
	local cx, cy = 0, 0
	for e in all(Entity.entities) do
		local cx2, cy2 = e:update()
		cx += cx2
		cy += cy2
	end
	cx /= #Entity.entities
	cy /= #Entity.entities

	return cx, cy
end

function Entity.drawAll()
	for e in all(Entity.entities) do
		e:draw()
	end
end

function Entity.update(_ENV)

	t = max(t + 1)

	-- return camera position
	return x, y - hitbox.h
end

function Entity.draw(_ENV)
	spr(gfx[0].bmp, x - 16, y - 32)

	debugVisuals(_ENV)

	print("hp: " .. hp, x + 16, y, 9)
end

function closest(me, pool, range)
	local near = false
	local range = range or 256
	for o in all(pool) do
		local dist = sqrt((me.x - o.x)^2 + (me.y - o.y)^2)
		if dist < range then
			near = o
			range = dist
		end
	end
	return near, range
end

function Entity.debugVisuals(_ENV)
	if (not debug) return

	if (debug.collision) rect(x - hitbox.w, y - hitbox.h * 2 + 1, x + hitbox.w - 1, y, 7)
	if (debug.entityCollision) rect(x - hitboxDamage.w, y - hitboxDamage.h * 2 + 1, x + hitboxDamage.w - 1, y, 8)

	if (target) line(x, y, target.x, target.y, 12)

	pset(x, y, 8)
end