--[[pod_format="raw",created="2025-04-15 01:28:55",modified="2025-04-23 04:01:27",revision=7215]]
-- enemies base
-- cubee

include("entities/entity.lua")

Enemy = setmetatable({
	enemies = {},
	garbage = {},
	gfx = fetch("gfx/enemies.gfx")
}, {__index = Entity})

-- create enemy
function Enemy:create(data, x, y)
	local myData = data or {hp = 1, value = 0, update = function()end}

	local enemy = setmetatable({
		t = rnd(200),
		x = x or 128,
		y = y or 16,
		xv = 0,
		yv = 0,
		hitbox = {w = 6, h = 10},
		hitboxDamage = {w = 10, h = 12},
		standOnPlatforms = false,
		flip = false,
		jumps = 0,
		target = {x = 0, y = 0},
		sprite = 0,

		data = myData,
		hp = myData.hp or 1,
		value = myData.value or 10,
		myUpdate = myData.update,
		myDraw = myData.draw,

		state = 0,
		stateTimer = 0,
		jumpTimer = 0,
		deathTimer = 120,
		dyingWish = false,

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

	for e in all(Enemy.garbage) do
		del(Enemy.enemies, e)
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

	-- die
	if hp <= 0 and not dyingWish then
		sfx(7)
		for i = 1, value do
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
	if myDraw then
		myDraw(_ENV)
	else
		spr(gfx[sprite].bmp, x - 4, y - hitbox.h, flip)
	end

	debugVisuals(_ENV)
--[[
	print(cmget((x)/8,(y+4)/8), x + 16, y, 9)
	print(target.x .." " .. target.y, x + 16, y+8, 9)]]
end

function Enemy.damage(t, damage, source)
	if (t.hp <= 0) return
	t.hp -= damage
	sfx(8)

	if t.hp <= 0 and source and source.equipment then
		for slot, item in pairs(source.equipment) do
			if (item.onKill) item:onKill(t)
		end
	end
end
