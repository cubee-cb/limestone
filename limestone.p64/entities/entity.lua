--[[pod_format="raw",created="2025-04-15 02:20:17",modified="2025-04-18 20:52:32",revision=5890]]
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
		standOnPlatforms = false,
		
		hp = 100,
		value = 10,

	}, {__index = Entity})

	add(Entity.entities, en)

	return en
end

-- update all entities
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

-- draw all entities
function Entity.drawAll()
	for e in all(Entity.entities) do
		e:draw()
	end
end

-- base update
function Entity.update(_ENV)

	

	t = max(t + 1)

	-- return camera position
	return x, y - hitbox.h
end

-- base draw
function Entity.draw(_ENV)
	spr(gfx[0].bmp, x - 16, y - 32)

	debugVisuals(_ENV)
end

-- find nearest object in pool, optional range limit
-- returns found object or false, and shortest range
function Entity.closest(me, pool, range)
	local near = false
	local range = range or 4096
	for o in all(pool) do
		local dist = sqrt((me.x - o.x)^2 + (me.y - o.y)^2)
		if dist < range and (not o.hp or o.hp > 0) and not o.dyingWish then
			near = o
			range = dist
		end
	end
	return near, range
end

-- general debug visuals: hitboxes, origins, aim, etc
function Entity.debugVisuals(_ENV)
	if (not db) return

	if (db.collision) rect(x - hitbox.w, y - hitbox.h * 2 + 1, x + hitbox.w - 1, y, 7)
	if (db.entityCollision) rect(x - hitboxDamage.w, y - hitboxDamage.h * 2 + 1, x + hitboxDamage.w - 1, y, 8)

	if (target) line(x, y, target.x, target.y, 12)

	pset(x, y, 8)
end

function Entity.aabb(a, b)
	return a.hitbox and b.hitbox and not (
		a.x + a.hitbox.w < b.x - b.hitbox.w or
		a.x - a.hitbox.w > b.x + b.hitbox.w or
		a.y + a.hitbox.h < b.y - b.hitbox.h or
		a.y - a.hitbox.h > b.y + b.hitbox.h
	)
end

function Entity.damage(t, damage)
	t.hp -= damage
	sfx(8)
end

function Entity.collideTiles(_ENV)
	air, left, right, up, left_g, right_g = true
	local cy = max(0, y)

	-- right
	local d = 0
	if xv > 0 then
		repeat
			local ix, iy = (x + hitbox.w + d), (cy - 1)
			if fget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or fget(cmget(ix, iy), 0) then
				xv, right = 0, true
				x += d
				x = x \ 1
				break
			end
			d += 1
		until d > xv
	end
	
	-- left
	d = 0
	if xv < 0 then
		repeat
			local ix, iy = (x - hitbox.w + d), (cy - 1)
			if fget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or fget(cmget(ix, iy), 0) then
				xv, left = 0, true
				x += d
				x = x \ 1
				break
			end
			d -= 1
		until d < xv
	end
	
	-- down
	d = 0
	if yv > 0 then
		repeat
			local iy = (cy + d)
			local il, ir = cmget((x - hitbox.w + 1), iy), cmget((x + hitbox.w - 1), iy)
			left_g = fget(il, 0) or fget(il, 2) and standOnPlatforms
			right_g = fget(ir, 0) or fget(ir, 2) and standOnPlatforms
			if left_g or right_g then
				yv, air = 0
				jumps = max_jumps
				y += d
				y = y \ 1
				break
			end
			d += 1
		until d > yv
	end

	-- up
	d = 0
	if yv < 0 then
		repeat
			local iy = (cy - hitbox.h * 2 + d)
			if fget(cmget((x - hitbox.w + 1), iy), 0) or fget(cmget((x + hitbox.w - 1), iy), 0) then
				yv, up = 0, true
				y += d
				y = y \ 1
				break
			end
			d -= 1
		until d < yv
	end
end