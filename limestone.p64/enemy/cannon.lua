--[[pod_format="raw",created="2025-04-18 17:09:45",modified="2025-04-21 07:29:33",revision=1582]]
-- cannon enemy
-- cubee

Cannon = {
	hp = 12,
	value = 20,
	update = function(_ENV)
		local grv = 0.2
		local acc = 0.01
		local top = 0.8
		local jmp = 4

		updateTarget(_ENV, closest(_ENV, Player.players))
		if (not target) return

		if air then
			acc /= 3
		end

		local goLeft, goRight = false, false

		-- normal
		if state == 0 then
			goLeft = target.x < x
			goRight = target.x > x

			-- fire at player
			if abs(target.x - x) <= 80 and abs(target.y - y) <= 24 then
				stateTimer = 60
				state = 1
			end

		-- shooting
		elseif state == 1 then
			-- fire
			if stateTimer <= 0 then
				local s = 6
				Projectile:create(Projectile.snowball, x + (flip and -12 or 12), y - 18, flip and -s or s, -0.25, 10, _ENV)
				state = 2
				stateTimer = 30
			end

		-- recovery
		elseif state == 2 then
			-- return to normal
			if stateTimer <= 0 then
				state = 0
			end
		end

		-- left
		if goLeft and jumpTimer < 0 then
	
			if (xv >- top) xv -= acc
			flip = true

		-- right
		elseif goRight and jumpTimer < 0 then

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

		standOnPlatforms = true -- target.y <= y + 8
   	--local standingTile = cmget(x, y + hitbox.h - 1)

		-- collisions
		collideTiles(_ENV)

	   -- move
		x += xv
	   y += yv

		sprite = 24 + t % 50 \ 25
		if (jumpTimer > 0) sprite = 29
		if (air) sprite = 30

		if state == 1 then
			sprite = 27 + t % 20 \ 10
		elseif state == 2 then
			sprite = ({25, 29, 26, 26})[stateTimer \ 10 + 1]
		end

		stateTimer = max(stateTimer - 1)
	end,
	draw = function(_ENV)
		spr(gfx[sprite].bmp, x - 16, y - 32, flip)

	end
}
