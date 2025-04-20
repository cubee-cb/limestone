--[[pod_format="raw",created="2025-04-18 17:09:45",modified="2025-04-20 14:59:39",revision=1333]]
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

	end,
	draw = function(_ENV)
		spr(gfx[sprite].bmp, x - 16, y - 32, flip)

	end
}
