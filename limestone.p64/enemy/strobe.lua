--[[pod_format="raw",created="2025-04-18 16:15:13",modified="2025-04-18 16:22:43",revision=51]]
-- strobe enemy
-- cubee

Strobe = {
	hp = 4,
	value = 6,
	jumpTimer = 0,
	strobeTimer = 0,
	update = function(_ENV)
		updateTarget(_ENV, closest(_ENV, Exit.exits))
		if (not target) return

		local grv = 0.05
		local acc = 0.05
		local top = 0.75
		local jmp = 1

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

		end

		yv += grv

		-- jumping
		if not air and jumpTimer == 0 and target.y < y - 8 and fget(cmget(x - 12, y - 4), 0) or fget(cmget(x + 12, y - 4), 0) then
			jumpTimer = 20
		end
		jumpTimer = max(jumpTimer - 1, -1)
		if jumpTimer == 0 then
			yv = -jmp
		end

		standOnPlatforms = target.y <= y + 8
   	--local standingTile = cmget(x, y + hitbox.h - 1)

		-- collisions
		collideTiles(_ENV)

	   -- move
		x += xv
	   y += yv

		sprite = 9 + t % 20 \ 5
		if (jumpTimer > 0) sprite = 13
		if (air) sprite = 14

	end,
	draw = function(_ENV)
		spr(gfx[sprite].bmp, x - 4, y - 16, flip)

	end
}
