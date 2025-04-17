--[[pod_format="raw",created="2025-04-13 16:01:05",modified="2025-04-17 17:37:05",revision=5169]]
-- player
-- cubee

include("entities/entity.lua")
include("player/ability.lua")

Player = setmetatable({
	players = {},
	gfx = fetch("gfx/player.gfx")
}, {__index = Entity})

-- create player
function Player:create(x, y)
	local player = setmetatable({
		t = 0,
		x = x or 128,
		y = y or 16,
		xv = 0,
		yv = 0,
		hitbox = {w = 8, h = 16},
		hitboxDamage = {w = 4, h = 4},
		
		flip = false,
		ground_last_y = 16,
		fall_distance = 0,
		wallslide = 0,
		canWallJump = false,
		jumps = 0,
		maxJumps = 2,
		
		slope = "a",
		slopeType = 0,
		slopeOffset = 0,
		lastPlatformY = 0,

		points = {
			normal = 0,
		},
		
		abilities = {
			Ability.dash,
			--Ability.wings,
			Ability.wallJump,
			Ability.monkeyBars,
			Ability.dive,
			Ability.push,
			Ability.homingAttack,
		},

		equipment = {
			mouth = nil,
			arms = nil,
			feet = nil,
			aura = nil,
			roll = nil,
		},
		
	}, {__index = Player})

	add(Player.players, player)

	return player
end

function Player.collect(_ENV, type, value)
	if (not points[type]) points[type] = 0

	points[type] += value
end

-- update all players and average returned camera values
function Player.updateAll()
	local cx, cy = 0, 0
	for p in all(Player.players) do
		local cx2, cy2 = p:update()
		cx += cx2
		cy += cy2
	end
	cx /= #Player.players
	cy /= #Player.players

	return cx, cy
end

-- draw all players
function Player.drawAll()
	for p in all(Player.players) do
		p:draw()
	end
end

-- base update
function Player.update(_ENV)

	-- update abilities
	for a in all(abilities) do
		if not a.inited and a.equip then
			a.equip(_ENV)
			a.inited = true
		end
	end

	local gs = 1
	local grv = 0.125
	local dec = 1
	local acc = 0.3
	local frc = acc
	local top = 4
	local jmp = 4

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
	if btn(0) then
		if (xv > 0 and not air)	Particle:create(Particle.dust, x, y, 1 + rnd(2), -0.5)

		if (xv >- top) xv -= (xv > 0 and dec or acc) * gs
		if (canturn) flip = true

	-- right
	elseif btn(1) then
		if (xv < 0 and not air)	Particle:create(Particle.dust, x, y, -1 - rnd(2), -0.5)

		if (xv < top) xv += (xv < 0 and dec or acc) * gs
		if (canturn) flip = false

	elseif xv ~= 0 then
		-- friction
		xv -= sgn(xv) * frc * gs
		if abs(xv) <= frc * gs then
			xv = 0
		end

	end

	-- kick up dust
	if not air then
		if abs(xv) >= top then
			if t % 3 == 0 then
				Particle:create(Particle.dust, x + xv, y - 1, -xv / 2, -rnd())
			end
		elseif abs(xv) > top / 2 then
			if t % 5 == 0 then
				Particle:create(Particle.dust, x + xv, y - 1, -xv / 2, -rnd())
			end
		end
	end

	-- idle smoke
	if abs(xv) > 0.5 and t % 30 == 0 or t % 8 == 0 then
		Particle:create(Particle.smoke, x + xv + rnd(8) - 4, y - hitbox.h - rnd(16), xv / 2 + rnd() - 0.5, 0)
	end


	if (gravity) yv += grv * (btn(3) and 3 or 1) * gs
	if (canWallJump and wallslide ~= 0) yv = min(yv, btn(3) and 1.5 or 0.5)

	-- jumping and wall jumping
	if btnp(4) then
		if canWallJump and wallslide ~= 0 then
			for i = 1, 5 do
				Particle:create(Particle.dust, x + hitbox.w * wallslide, y - 2, rnd(1) * -wallslide, rnd() + 0.5)
			end
			xv = 3 * -wallslide
			yv = -jmp * 0.75
			wallslide = 0
			jumping = true
		elseif jumps > 0 then
			for i = 1, 5 do
				Particle:create(Particle.dust, x + hitbox.w * wallslide, y - 2, rnd(2) - 1, (rnd(2) - 1) / 5)
			end
			yv = -jmp * 1 / (0.5 + (maxJumps + 1 - jumps) / 2)
			jumps -= 1
			jumping = true
		end
	end

	-- limit jump height
	if not btn(4) and jumping then
		yv = max(yv, -1)
	end

	--i.xv=mid(-mxv,i.xv,mxv)
	--i.yv=mid(-myv,i.yv,myv)
	
	-- collisions
	air, left, right, up, left_g, right_g = true
	local cy = max(0, y)

	local standOnPlatforms =    not btn(3) -- y \ 8 <= lastPlatformY
	--if (btn(3)) lastPlatformY = y \ 8 - 1
	--if (y \ 8 > lastPlatformY) standOnPlatforms = true






	slopeOffset = 0








   --[[ slopes
   local ty = (y + 3) \ 1
   local yo, stile = 0, cmget(x, ty)
   local xo = flr(x) % 8
   local onslope = false
   if yv >= 0 and fget(stile, 1) then
		if slopes[stile] then
			local ls, rs = slopes[stile][1], slopes[stile][2]
			local col = x % 8 + (rs > ls and 1 or 0)
			local offset = ls - rs
			yo = -offset / 8 * col
			onslope = true

			slopeOffset = yo

			--y-=yo

			yv, air = 0
			fall_distance = 0
			jumps = maxJumps
			wallslide = 0
			y = ty + ls + yo
		
		end
	end
	
	slopeType = 0
--]]
--[[
   local standingTile = cmget(x, y + hitbox.h - 1)
  	slope = slopes[standingTile]
  	slopeType = 0
   slopeOffset = 0
   if slope then
   	-- 1 right is higher side
   	-- -1 left is higher side
   	slopeType = sgn(slope[1] - slope[2])
   	--if (slope[1] < slope[2]) slopeType = 1
   	--if (slope[1] > slope[2]) slopeType = -1

   	slopeOffset = slope[1] + slope[2] * (x % 8 / 8)
   end
--]]

	if not onslope then

	-- right
	local d = 0
	if xv > 0 then
		wallslide = 0
		repeat
			local ix, iy = (x + hitbox.w + d), (cy - 1)
			if pfget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or (pfget(cmget(ix, iy), 0) and slopeType < 1) then
				xv, right = 0, true
				if (air) wallslide = 1
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
		wallslide = 0
		repeat
			local ix, iy = (x - hitbox.w + d), (cy - 1)
			if pfget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or (pfget(cmget(ix, iy), 0) and slopeType > -1) then
				xv, left = 0, true
				if (air) wallslide = -1
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
			local iy = (cy + d + slopeOffset)
			local il, ir = cmget((x - hitbox.w + 1), iy), cmget((x + hitbox.w - 1), iy)
			left_g = pfget(il, 0) or pfget(il, 2) and iy % 8 < 1 and standOnPlatforms
			right_g = pfget(ir, 0) or pfget(ir, 2) and iy % 8 < 1 and standOnPlatforms
			if left_g or right_g then
				yv, air = 0
				fall_distance = 0
				jumps = maxJumps
				wallslide = 0
				y += d
				lastPlatformY = y \ 8
				jumping = false
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
			if pfget(cmget((x - hitbox.w + 1), iy), 0) or pfget(cmget((x + hitbox.w - 1), iy), 0) then
				yv, up = 0, true
				y += d
				y = y \ 1
				break
			end
			d -= 1
		until d < yv
	end

	end

	if wallslide ~= 0 then
		if(t % 5 == 0)Particle:create(Particle.dust, x + hitbox.w * wallslide, y - 8, rnd(1) * -wallslide, 0)
	end

   -- move
	x += xv * gs
   y += yv * gs
	fall_distance += yv * gs

	if not air or fall_distance > 48 or fall_distance < -80 then
		ground_last_y = y
	end

	-- attack enemies
	if (btnp(5)) then
		for e in all(Enemy.enemies) do
			if aabb(_ENV, e) then
				e:damage(1)
			end
		end
	end

	-- buy item
	local closestStoreItem = Entity.closest(_ENV, StoreItem.items)
	if closestStoreItem and closestStoreItem.collectable and btnp(5) then
		local item = StoreItem.purchase(_ENV, closestStoreItem)
		if (item) item.init(_ENV, closestStoreItem)
	end

	-- run item updates
	for slot, content in pairs(equipment) do
		content:update(_ENV)
	end

	t = max(t + 1)

	-- return camera position
	return x, ground_last_y - hitbox.h - 32
end

-- base draw
function Player.draw(_ENV)

	-- rear arm
	spr(gfx[73].bmp, x - 16, y - hitbox.h*2 - 8.5 + sin((t - 20) / 150) * 2, flip)

	-- main body
	spr(gfx[64].bmp, x - 16, y - hitbox.h*2 - 8.5 + sin(t / 150) * 2, flip)
	
	-- leg
	spr(gfx[82].bmp, x - 12, y - hitbox.h*2 + 16.5, flip)
	spr(gfx[82].bmp, x - 20, y - hitbox.h*2 + 16.5, flip)

	-- kim/vessel
	spr(gfx[0].bmp, x - 8, y - hitbox.h*2 + 4.5 + sin(t / 150) * 2, flip)
	--spr(gfx[1].bmp, x - 8, y - hitbox.h - 8)

	-- front arm
	spr(gfx[72].bmp, x - 16, y - hitbox.h*2 - 8.5 + sin((t - 20) / 150) * 2, flip)

	-- run item draws
	for slot, content in pairs(equipment) do
		content:draw(_ENV)
	end

	debugVisuals(_ENV)

	cursor(x + 16, y - hitbox.h * 2 - 16)
	--print(cmget((x)/8,(y+4)/8), x + 16, y, 9)
	--print(x\8 .." " .. (y+4)\8, x + 16, y+8, 9)
	--print(slopeOffset)
	print(jumps.."/"..maxJumps)
	print("P:"..points.normal)
end
