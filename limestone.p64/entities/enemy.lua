--[[pod_format="raw",created="2025-04-15 01:28:55",modified="2025-04-17 02:16:50",revision=2897]]
-- enemies base
-- cubee

include("entities/entity.lua")
include("enemy/pop.lua")

Enemy = setmetatable({
	enemies = {},
	garbage = {},
	gfx = fetch("gfx/default.gfx")
}, {__index = Entity})

-- create exit
function Enemy:create(data, x, y)
	local myData = data or {hp = 1, value = 0, update = function()end}

	local enemy = setmetatable({
		t = 0,
		x = x or 128,
		y = y or 16,
		xv = 0,
		yv = 0,
		hitbox = {w = 6, h = 10},
		hitboxDamage = {w = 10, h = 12},
		flip = false,
		jumps = 0,
		target = {x = 0, y = 0},

		data = myData,
		hp = myData.hpMax or 1,
		value = myData.value or 10,
		myUpdate = myData.update or function()end,

	}, {__index = Enemy})

	add(Enemy.enemies, enemy)

	return enemy
end

-- set target of enemy
function Enemy.updateTarget(_ENV, targ)
	target = targ
	if not target then
		target = {x = x, y = y}
	end
end

-- update all enemies and averge camera position
function Enemy.updateAll()
	local cx, cy = 0, 0

	Enemy.garbage = {}

	for e in all(Enemy.enemies) do
		local cx2, cy2 = e:update()
		cx += cx2
		cy += cy2
	end
	cx /= #Enemy.enemies
	cy /= #Enemy.enemies

	for p in all(Enemy.garbage) do
		del(Enemy.enemies, p)
	end

	return cx, cy
end

-- draw all enemies
function Enemy.drawAll()
	for e in all(Enemy.enemies) do
		e:draw()
	end
end

-- base update
function Enemy.update(_ENV)

	myUpdate(_ENV)

	-- contact damage to exits
	if aabb(_ENV, target) then
		sfx(3)
		target:damage(1)
		add(garbage, _ENV)
	end

	-- die
	if hp <= 0 then
		sfx(4)
		for i = 0, value do
			Pickup:create(x, y - hitbox.h)
		end
		add(garbage, _ENV)
	end

	t = max(t + 1)

	-- return camera position
	return x, y - hitbox.h
end

-- base draw
function Enemy.draw(_ENV)
	spr(gfx[0].bmp, x - 4, y - 16)

	debugVisuals(_ENV)

	print(cmget((x)/8,(y+4)/8), x + 16, y, 9)
	print(target.x .." " .. target.y, x + 16, y+8, 9)
end
