--[[pod_format="raw",created="2025-04-18 16:15:13",modified="2025-04-20 14:48:46",revision=1596]]
-- strobe enemy
-- cubee

Strobe = {
	hp = 5,
	value = 6,
	update = function(_ENV)
		local grv = 0.1
		local acc = 0.02
		local top = 0.3
		local jmp = 2.5

		if hp <= 0 and not dyingWish or dyingWish and hp > 0 then
			dyingWish = true
			hp = 0
			deathTimer = 120
			sfx(20)
		end

		if dyingWish then
			invulnerable = true
			deathTimer -= 1

			sprite = deathTimer % 10 < 5 and 15 or 13

			yv += grv
			collideTiles(_ENV)
	  		y += yv

			if deathTimer <= 0 then
				dyingWish = false

				sfx(21)
				local player, distance = Entity.closest(_ENV, Player.players)
				local r = 48
				if player and distance <= r then
					--player:damage(5)
					player.yv -= 12 * (1 - distance / r)
					player.xv += 12 * (1 - distance / r) * (player.x < x and -1 or 1)
				end

				local exit, distance = Entity.closest(_ENV, Exit.exits)
				if exit and distance <= r then
					exit:damage(10, _ENV)
					sfx(3)
				end

				r *= 0.6
				for i = 1, 8 do
					Particle:create(Particle.smoke, x + rnd(r * 2) - r, y + rnd(r * 2) - r)
				end
			end

			return
		end

		updateTarget(_ENV, closest(_ENV, Exit.exits))
		if (not target) return

		if air then
			acc /= 3
		end

		-- left
		if target.x < x and jumpTimer < 0 then
	
			if (xv >- top) xv -= acc
			flip = true

		-- right
		elseif target.x > x and jumpTimer < 0 then

			if (xv < top) xv += acc
			flip = false

		elseif xv ~= 0 then
			-- friction
			xv -= sgn(xv) / 15
			if abs(xv) <= 0.07 then
				xv = 0
			end
		end

		yv += grv

		-- jumping
		if not air and jumpTimer <= 0 and target.y < y - 8 and (fget(cmget(x - 16, y - 4), 0) or fget(cmget(x + 16, y - 4), 0)) then
			jumpTimer = 60
		end
		jumpTimer = max(jumpTimer - 1, -1)
		if jumpTimer == 0 then
			yv = -jmp
			xv = flip and -top or top
		end

		standOnPlatforms = target.y <= y + 8 or abs(target.x - x) > 32
   	--local standingTile = cmget(x, y + hitbox.h - 1)

		-- collisions
		collideTiles(_ENV)

	   -- move
		x += xv
	   y += yv

		sprite = 9 + t % 40 \ 10
		if (jumpTimer > 0) sprite = 13
		if (air) sprite = 14

		-- contact damage to exits
		if aabb(_ENV, target) then
			dyingWish = true
			-- sd doesn't give points
			value = 0
		end

	end,
	draw = function(_ENV)
		spr(gfx[sprite].bmp, x - 12, y - 24, flip)

	end,
}

ProudStrobe = {
	hp = 10,
	value = 12,
	update = Strobe.update,
	draw = function(_ENV)
		local bpal = {10, 11, 28, 29, 23, 8, 9}
		local dpal = {9, 11, 12, 30, 14, 24, 25}
		local i = t % 70 \ 10 + 1
		pal(9, bpal[i])
		pal(10, dpal[i])
		spr(gfx[sprite].bmp, x - 12, y - 24, flip)
		pal(9, 9)
		pal(10, 10)

	end,
}

Strobe2 = {
	hp = 15,
	value = 20,
	update = Strobe.update,
	draw = Strobe.draw
}

ProudStrobe2 = {
	hp = 30,
	value = 40,
	update = Strobe.update,
	draw = ProudStrobe.draw
}
