--[[pod_format="raw",created="2025-04-17 01:48:27",modified="2025-04-17 02:36:38",revision=255]]
-- pop enemy
-- cubee

Pop = {
	hp = 1,
	value = 5,
	update = function(_ENV)
		updateTarget(_ENV, closest(_ENV, Exit.exits))

		local gs = 1
		local grv = 0.1
		local dec = 0.5
		local acc = 0.1
		local frc = acc
		local top = 1
		local jmp = 3
		local max_jumps = 1
	
		local static = false
		local gravity = true
		local friction = true
	
		local canturn = true
	
		if air then
			acc /= 3
			frc /= 3
			dec = frc * 2
		end

		-- left
		if target.x < x then
	
			if (xv >- top) xv -= (xv > 0 and dec or acc) * gs
			if (canturn) flip = true
	
		-- right
		elseif target.y then
	
			if (xv < top) xv += (xv < 0 and dec or acc) * gs
			if (canturn) flip = false
	
		elseif xv ~= 0 then
			-- friction
			xv -= sgn(xv) * frc * gs
			if abs(xv) <= frc * gs then
				xv = 0
			end
		end
		
	
	
		if (gravity) yv += grv * gs
	
		-- jumping and wall jumping
		if target.y < y - 8 then
			if jumps > 0 and not air then
				yv = -jmp * 1 / (0.5 + (max_jumps + 1 - jumps) / 2)
				jumps -= 1
			end
		end
	
		--i.xv=mid(-mxv,i.xv,mxv)
		--i.yv=mid(-myv,i.yv,myv)
		
		-- collisions
		air, left, right, up, left_g, right_g = true
		local cy = max(0, y)
	
		local standOnPlatforms = target.y >= y + 8
	
	   local standingTile = cmget(x, y + hitbox.h - 1)
	
	
		-- right
		local d = 0
		if xv > 0 then
			repeat
				local ix, iy = (x + hitbox.w + d), (cy - 1)
				if fget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or fget(cmget(ix, iy), 0) then
					xv, right = 0, true
					x += d
					break
				end
				d += 1
			until d > xv
		end
		
		-- left
		d = 0
		if xv < 0 then
			repeat
				local ix, iy = (x - hitbox.w + d), (cy - 1)
				if fget(cmget(ix, (cy - hitbox.h * 2 + 1)), 0) or fget(cmget(ix, iy), 0) then
					xv, left = 0, true
					x += d
					break
				end
				d -= 1
			until d < xv
		end
		
		-- down
		d = 0
		if yv > 0 then
			repeat
				local iy = (cy + d)
				local il, ir = cmget((x - hitbox.w + 1), iy), cmget((x + hitbox.w - 1), iy)
				left_g = fget(il, 0) or fget(il, 2) and standOnPlatforms
				right_g = fget(ir, 0) or fget(ir, 2) and standOnPlatforms
				if left_g or right_g then
					yv, air = 0
					jumps = max_jumps
					y += d
					break
				end
				d += 1
			until d > yv
		end
	
		-- up
		d = 0
		if yv < 0 then
			repeat
				local iy = (cy - hitbox.h * 2 + d)
				if fget(cmget((x - hitbox.w + 1), iy), 0) or fget(cmget((x + hitbox.w - 1), iy), 0) then
					yv, up = 0, true
					y += d
					break
				end
				d -= 1
			until d < yv
		end
	
	   -- move
		x += xv * gs
	   y += yv * gs

	end,
}
