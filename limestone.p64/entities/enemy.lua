--[[pod_format="raw",created="2025-04-15 01:28:55",modified="2025-04-16 17:31:12",revision=2733]]
-- enemies base
-- cubee

include("entities/entity.lua")

Enemy = setmetatable({
	enemies = {},
	garbage = {},
	gfx = fetch("gfx/default.gfx")
}, {__index = Entity})

-- create exit
function Enemy:create(x, y)
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

		hp = 10,
		value = 10,

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
	updateTarget(_ENV, closest(_ENV, Exit.exits))

	local gs = 1
	local grv = 0.1
	local dec = 0.5
	local acc = 0.1
	local frc = acc
	local top = 1
	local jmp = 3
	local max_jumps = 1

	local static = false
	local gravity = true
	local friction = true

	local canturn = true

	if air then
		acc /= 3
		frc /= 3
		dec = frc * 2
	end

	-- left
	if target.x < x then

		if (xv >- top) xv -= (xv > 0 and dec or acc) * gs
		if (canturn) flip = true

	-- right
	elseif target.y then

		if (xv < top) xv += (xv < 0 and dec or acc) * gs
		if (canturn) flip = false

	elseif xv ~= 0 then
		-- friction
		xv -= sgn(xv) * frc * gs
		if abs(xv) <= frc * gs then
			xv = 0
		end
	end
	


	if (gravity) yv += grv * gs

	-- jumping and wall jumping
	if target.y < y - 8 then
		if jumps > 0 and not air then
			yv = -jmp * 1 / (0.5 + (max_jumps + 1 - jumps) / 2)
			jumps -= 1
		end
	end

	--i.xv=mid(-mxv,i.xv,mxv)
	--i.yv=mid(-myv,i.yv,myv)
	
	-- collisions
	air, left, right, up, left_g, right_g = true
	local cy = max(0, y)

	local standOnPlatforms = target.y >= y + 8

   local standingTile = cmget(x, y + hitbox.h - 1)


	-- right
	local d = 0
	if xv > 0 then
		repeat
			local ix, iy = (x + hitbox.w + d), (cy - 1)
			if fget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or fget(cmget(ix, iy), 0) then
				xv, right = 0, true
				x += d
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
				break
			end
			d -= 1
		until d < yv
	end

   -- move
	x += xv * gs
   y += yv * gs


	-- collide with other entities
	if aabb(_ENV, target) then
		hp = 0
		target:damage(1)
	end

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
