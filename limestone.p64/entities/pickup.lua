--[[pod_format="raw",created="2025-04-15 05:50:13",modified="2025-04-17 02:36:37",revision=2248]]
-- pickup
-- cubee

Pickup = setmetatable({
	pickups = {},
	garbage = {},
	gfx = fetch("gfx/pickup.gfx")
}, {__index = Entity})

-- create pickup
function Pickup:create(x, y, v)
	x = x or 128
	y = y or 16

	local en = setmetatable({
		t = 0,
		x = x,
		y = y,
		xv = rnd(4) - 2,
		yv = -1 - rnd(2),
		hitbox = {w = 4, h = 4},
		hitboxDamage = {w = 0, h = 0},

		type = "normal",
		value = 1 or v,
		lifespan = 6000,
		intangible = 5, -- intangible duration so they can init before being collected

		latchTime = 0,
		lastX = y,
		lastY = x,
		latching = false,

	}, {__index = Pickup})

	add(Pickup.pickups, en)

	Particle:create(Particle.dust, x, y)

	return en
end

-- update all pickups and handle garbage pickups
function Pickup.updateAll()
	Pickup.garbage = {}

	for p in all(Pickup.pickups) do
		p:update()
	end

	-- clear old pickups
	for p in all(Pickup.garbage) do
		del(Pickup.pickups, p)
	end

end

-- draw all pickups
function Pickup.drawAll()
	for e in all(Pickup.pickups) do
		e:draw()
	end
end

-- base update
function Pickup.update(_ENV)
	local closestPlayer, distance = false, 4096
	if intangible <= 0 then
		closestPlayer, distance = closest(_ENV, Player.players)
	end

	local collectionRange = 48

	if intangible > 0 or distance > collectionRange + 16 or not closestPlayer then
		latching = false
	elseif distance <= collectionRange and not latching then
		latching = true
		sfx(0)
	end

	if latching and closestPlayer then
		--xv = sgn(closestPlayer.x - x) / 3
		--yv = sgn(closestPlayer.y - y) / 3

		latchTime += 0.05
		latchTime = mid(0, latchTime, 1)

		x = lastX + (closestPlayer.x - lastX) * easeBack(latchTime)
		y = lastY + (closestPlayer.y - lastY) * easeBack(latchTime)

		-- collect pickup
		if latchTime == 1 then
			sfx(1)
			Player.collect(closestPlayer, type, value)
			add(garbage, _ENV)
		end
	else
		xv *= 0.99
		yv += 0.075
		yv = min(yv, 6)
		latchTime = 0

		if fget(cmget(x - 3, y), 0) or fget(cmget(x + 3, y), 0) then
			xv = 0
		end
		if yv > 0 and (fget(cmget(x, y), 0) or fget(cmget(x, y), 2)) then
			yv = yv > 1 and (-yv * 0.3) or (0)
			xv *= 0.5
			y = y \ 8 * 8
		end

		x += xv
		y += yv
			
		lastX = x
		lastY = y

		lifespan -= #Pickup.pickups > 250 and 60 or 1
		
		if lifespan <= 0 then
			add(garbage, _ENV)
		end
	end

	t = max(t + 1)
	intangible = max(intangible - 1)

	-- return camera position
	return x, y - hitbox.h
end

-- base draw
function Pickup.draw(_ENV)
	spr(gfx[0].bmp, x - 4, y - 8)
	--debugVisuals(_ENV)
	--?lifespan,x,y
end
