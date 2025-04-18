--[[pod_format="raw",created="2025-04-18 14:14:25",modified="2025-04-18 20:52:32",revision=1444]]
-- projectile
-- cubee

Projectile = setmetatable({
	projectiles = {},
	garbage = {},
	gfx = fetch("gfx/projectile.gfx"),
	bullet = function(_ENV, init)
		if init then
			return
		end
		sprite = 0
		x += xv
		y += yv

	end,

	fire = function(_ENV, init)
		if init then
			lifespan = 60
			return
		end
		sprite = 2
		yv = -0.2
		xv *= 0.97
		x += xv
		y += yv

		sprite = 6 - (lifespan / lifespanMax * 3.9) \ 1
		s = 0.5 + (lifespan / lifespanMax)
	end,

	downBullet = function(_ENV, init)
		if init then
			return
		end
		y += yv
		sprite = 1

	end,

	laser = function(_ENV, init)
		if init then
			return
		end
		sprite = 2
		x += xv
		y += yv

		a = deltaToAngle(xv, yv)
	end,

	spectre = function(_ENV, init)
		if init then
			collideGround = false
			return
		end
		sprite = 3

		local target = Entity.closest(_ENV, Enemy.enemies)
		if target then
			xv += (target.x - x) / 400
			yv += (target.y - y) / 400

			local m = 5
			xv = mid(-m, xv, m)
			yv = mid(-m, yv, m)
		else
			--lifespan = 0
		end

		x += xv
		y += yv

		a = deltaToAngle(xv, yv)
	end,

}, {__index = Entity})

-- create projectile
function Projectile:create(u, x, y, xv, yv, damage)
	x = x or 128
	y = y or 16

	local p = setmetatable({
		t = 0,
		x = x,
		y = y,
		xv = xv or 0,
		yv = yv or 0,
		a = 0,
		av = 0,
		hitbox = {w = 4, h = 4},
		hitboxDamage = {w = 0, h = 0},

		myUpdate = u or Projectile.bullet,
		sprite = 0,
		lifespan = 600,
		lifespanMax = 600,
		damage = damage or 1,
		friendly = true,
		collideGround = true,

	}, {__index = Projectile})

	-- run one update for init
	p:myUpdate(true)
	p.lifespanMax = p.lifespan

	add(Projectile.projectiles, p)

	return en
end

-- update all projectiles and handle garbage
function Projectile.updateAll()
	Projectile.garbage = {}

	for p in all(Projectile.projectiles) do
		Projectile.update(p)
	end

	-- clear old projectiles
	for p in all(Projectile.garbage) do
		del(Projectile.projectiles, p)
	end

end

-- draw all particles
function Projectile.drawAll(foreground)
	for p in all(Projectile.projectiles) do
		p:draw(foreground)
	end
end

-- base update
function Projectile.update(_ENV)

	myUpdate(_ENV)

	lifespan -= #Projectile.projectiles > 100 and 30 or 1

	if lifespan <= 0 or (fget(cmget(x, y), 0) and collideGround) then
		add(garbage, _ENV)
		for i = 1, 5 do
			Particle:create(Particle.dust, x, y)
		end
	end

	-- damage things
	if friendly then
		-- enemies, enemy projectiles
		for e in all(Enemy.enemies) do
			if aabb(_ENV, e) then
				lifespan = 0
				e:damage(damage)
				break
			end
		end
	else
		-- player, exits
	end

	t = max(t + 1)

end

-- base draw
function Projectile.draw(_ENV)

	local bmp = gfx[sprite \ 1] and gfx[sprite \ 1].bmp or gfx[0].bmp
	s = s or 1
	local w, h = bmp:width() * s, bmp:height() * s
	if a == 0 then
		sspr(bmp, 0, 0, bmp:width(), bmp:height(), x - w / 2, y - h / 2, w, h)
	else
		rspr(bmp, x, y, s, s, a + 0.25)
	end
	--?lifespan,x,y,7
end
