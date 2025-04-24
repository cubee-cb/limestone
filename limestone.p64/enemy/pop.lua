--[[pod_format="raw",created="2025-04-17 01:48:27",modified="2025-04-24 12:59:23",revision=4714]]
-- pop enemy
-- cubee

Pop = {
	hp = 1,
	value = 2,
	update = function(_ENV)
		updateTarget(_ENV, closest(_ENV, Exit.exits))
		if (not target) return

		local grv = 0.05
		local acc = 0.1
		local top = 1
		local jmp = 2

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
			xv -= sgn(xv) / 5
			if abs(xv) <= 0.05 then
				xv = 0
			end
		end

		yv += grv

		-- jumping
		if not air and jumpTimer <= 0 and fget(cmget(x + (flip and -16 or 16), y - 4), 0) then
			jumpTimer = 10
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

		sprite = 1 + t % 20 \ 5
		if (jumpTimer > 0) sprite = 6
		if (air) sprite = yv < 0 and 2 or 5

		-- contact damage to target
		if aabb(_ENV, target) then
			target:damage(1, _ENV)
			add(garbage, _ENV)
		end

	end,
	draw = function(_ENV)
		spr(gfx[sprite].bmp, x - 8, y - 16, flip)

	end
}

ChunkyPop = {
	hp = 5,
	value = 4,
	update = Pop.update,
	draw = function(_ENV)
		spr(gfx[sprite + 64].bmp, x - 8, y - 16, flip)

	end
}
