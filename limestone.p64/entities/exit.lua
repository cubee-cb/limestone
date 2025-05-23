--[[pod_format="raw",created="2025-04-15 02:01:34",modified="2025-04-20 14:43:34",revision=6254]]
-- exit
-- cubee

include("entities/entity.lua")

Exit = setmetatable({
	exits = {},
	garbage = {},
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
		hitbox = {w = 10, h = 32},
		hitboxDamage = {w = 10, h = 30},
		
		hp = 100,
		
	}, {__index = Exit})

	add(Exit.exits, ex)

	return ex
end

function Exit.damage(t, damage, source)
	if (t.hp <= 0) return
	Round.flawless = false

	if Round.warning <= 0 then
		sfx(22)
	end
	sfx(3)

	t.hp -= damage

	Round.warning = 60 * 3
end

-- update all exits and return amount of exits
function Exit.updateAll()
	Exit.garbage = {}

	for e in all(Exit.exits) do
		e:update()
	end

	for e in all(Exit.garbage) do
		del(Exit.exits, e)
	end

	return #Exit.exits
end

-- draw all exits
function Exit.drawAll()
	for e in all(Exit.exits) do
		e:draw()
	end
end

-- base update
function Exit.update(_ENV)

	while not (fget(cmget(x, y), 0) or fget(cmget(x, y), 2)) and y < 1000 do
		y += 1
	end

	if hp <= 0 then
		hp = 0
		add(garbage, _ENV)
	end

	t = max(t + 1)

	-- return camera position
	return x, y - hitbox.h
end

-- base draw
function Exit.draw(_ENV)
	spr(gfx[1].bmp, x - 16, y - 82.5 + sin(t / 240) * 3)
	spr(gfx[0].bmp, x - 24, y - 80)

	debugVisuals(_ENV)

	print("\#2HP: " .. hp, x - 16, y - hitbox.h * 2 - 32, hp > 50 and 11 or hp <= 10 and 8 or 9)
end
