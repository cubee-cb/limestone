--[[pod_format="raw",created="2025-04-15 05:50:13",modified="2025-04-15 17:47:24",revision=1076]]
-- pickup
-- cubee

Pickup = setmetatable({
	pickups = {},
	garbage = {},
	gfx = fetch("gfx/pickup.gfx")
}, {__index = Entity})

-- create pickup
function Pickup:create(x, y)
	x = x or 128
	y = y or 16

	local en = setmetatable({
		t = 0,
		x = x,
		y = y,
		xv = rnd(4) - 1,
		yv = -1 - rnd(2),
		hitbox = {w = 4, h = 4},
		hitboxDamage = {w = 0, h = 0},

		type = "normal",
		value = 1,
		lifespan = 6000,
		
		latchTime = 0,
		lastX = y,
		lastY = x,
		latching = false,

	}, {__index = Pickup})

	add(Pickup.pickups, en)

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

	local closestPlayer, distance = closest(_ENV, Player.players)
	
	local collectionRange = 48

	if distance > collectionRange + 16 or not closestPlayer then
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
		yv += 0.075
		latchTime = 0

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

	-- return camera position
	return x, y - hitbox.h
end

-- base draw
function Pickup.draw(_ENV)
	spr(gfx[0].bmp, x - 4, y - 8)
	--debugVisuals(_ENV)
	--?lifespan,x,y
end
