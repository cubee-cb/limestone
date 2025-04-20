--[[pod_format="raw",created="2025-04-17 01:48:27",modified="2025-04-20 12:14:37",revision=3955]]
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
		if target.x < x then
	
			if (xv >- top) xv -= acc
			flip = true

		-- right
		elseif target.x > x then

			if (xv < top) xv += acc
			flip = false

		end

		yv += grv

		-- jumping
		if not air and target.y < y - 8 and fget(cmget(x - 16, y - 4), 0) or fget(cmget(x + 16, y - 4), 0) then
			yv = -jmp
		end

		standOnPlatforms = target.y <= y + 8
   	--local standingTile = cmget(x, y + hitbox.h - 1)

		-- collisions
		collideTiles(_ENV)

	   -- move
		x += xv
	   y += yv

		sprite = 1 + t % 20 \ 5
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
