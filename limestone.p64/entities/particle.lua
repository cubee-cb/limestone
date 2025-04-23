--[[pod_format="raw",created="2025-04-15 13:09:27",modified="2025-04-23 04:01:27",revision=6024]]
-- particle
-- cubee

Particle = setmetatable({
	particles = {},
	garbage = {},
	gfx = fetch("gfx/particles.gfx"),
	dust = function(_ENV, init)
		if init then
			fg = true
			lifespan = 20 + rnd(20)
			return
		end
		sprite = 2
		yv -= 0.05
		xv *= 0.97
		yv *= 0.97
		x += xv
		y += yv

		s = (lifespan / 30) ^ 2
	end,
	
	smoke = function(_ENV, init)
		if init then
			lifespan = 80 + rnd(60)
			--a = rnd()
			--av = (rnd(2)-1) / 500
			s = 0.8 + rnd(0.4)
			return
		end
		sprite = 2
		yv = -0.2
		xv *= 0.97
		x += xv
		y += yv
		a += av

		sprite = 6 - (lifespan / lifespanMax * 3.9) \ 1
		s = 0.5 + (lifespan / lifespanMax)
	end,
	
	smokeLight = function(_ENV, init)
		if init then
			lifespan = 80 + rnd(60)
			--a = rnd()
			--av = (rnd(2)-1) / 500
			s = 0.8 + rnd(0.4)
			return
		end
		sprite = 2
		yv = -0.2
		xv *= 0.97
		x += xv
		y += yv
		a += av

		sprite = 14 - (lifespan / lifespanMax * 3.9) \ 1
		s = 0.5 + (lifespan / lifespanMax)
	end,
}, {__index = Entity})

-- create particle
function Particle:create(u, x, y, xv, yv)
	x = x or 128
	y = y or 16

	local p = setmetatable({
		t = 0,
		x = x,
		y = y,
		xv = xv or rnd(4) - 2,
		yv = yv or rnd(4) - 2,
		a = 0,
		av = 0,
		hitbox = {w = 4, h = 4},
		hitboxDamage = {w = 0, h = 0},

		myUpdate = u or Particle.dust,
		sprite = 0,
		lifespan = 60,
		lifespanMax = 60,
		fg = false,

	}, {__index = Particle})

	-- run one update for init
	p:myUpdate(true)
	p.lifespanMax = p.lifespan

	add(Particle.particles, p)

	return en
end

-- update all particles and handle garbage particles
function Particle.updateAll()
	Particle.garbage = {}

	for p in all(Particle.particles) do
		Particle.update(p)
	end

	-- clear old pickups
	for p in all(Particle.garbage) do
		del(Particle.particles, p)
	end

end

-- draw all particles
function Particle.drawAll(foreground)
	for p in all(Particle.particles) do
		p:draw(foreground)
	end
end

-- base update
function Particle.update(_ENV)

	myUpdate(_ENV)

	lifespan -= #Particle.particles > 250 and 60 or 1

	if lifespan <= 0 then
		add(garbage, _ENV)
	end

	t = max(t + 1)

	-- return camera position
	return x, y - hitbox.h
end

-- base draw
function Particle.draw(_ENV, foreground)
	if (fg != foreground) return

	local bmp = gfx[sprite \ 1] and gfx[sprite \ 1].bmp or gfx[0].bmp
	s = s or 1
	local w, h = bmp:width() * s, bmp:height() * s
	if a == 0 then
		sspr(bmp, 0, 0, bmp:width(), bmp:height(), x - w / 2, y - h / 2, w, h)
	else
		rspr(bmp, x, y, s, s, a)
	end
	--?lifespan,x,y,7
end
