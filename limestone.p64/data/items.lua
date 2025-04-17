--[[pod_format="raw",created="2025-04-17 11:53:59",modified="2025-04-17 17:37:05",revision=678]]
-- items
-- cubee

Item = {
	testificate = {
		sprite = 0,
		name = "Villager dude",
		desc = "Does things. Press up to ascend.",
		value = 5,
		slot = "pet",
		maxLevel = 10,
		init = function(owner, origin)
			owner.yv = -5

			for i = 1, 5 do
				Particle:create(Particle.dust, origin.x, origin.y, rnd(2) - 1, (rnd(2) - 1) / 5)
				sfx(2)
			end
		end,
		update = function(self, owner)
			if (btn(2)) owner.yv = -1
			if (btn(0) and owner.xv < 0 or btn(1) and owner.xv > 0) owner.xv *= 1 + self.level / 100
		end,
		draw = function(self, owner)
			circ(owner.x, owner.y, 48 + sin(owner.t / 10) * 8, 11)
		end,
	},
	wings = {
		sprite = 1,
		name = "Wings",
		desc = "Hold up to fly. Levels increase vertical speed.", -- "Adds to your maximum jumps.",
		value = 300,
		slot = "back",
		maxLevel = 3,
		init = function(owner, origin)
		end,
		update = function(self, owner)
			if (btn(2)) owner.yv = -(self.level + 1)
		end,
		draw = function(self, owner)
			circ(owner.x, owner.y, 48, 11)
		end,
	},
	stilts = {
		sprite = 2,
		name = "Stilts",
		desc = "Become taller. Walking deals contact damage.", -- "Adds to your maximum jumps.",
		value = 50,
		slot = "feet",
		maxLevel = 5,
		init = function(owner, origin)
			owner.hitbox.h += level == 1 and 12 or 2
		end,
		update = function(self, owner)
			local damage = abs(owner.xv) * self.level
			local range = 18 + 6 * self.level

			-- deal velocity-based damage to the closest enemy
			if damage > 0 and owner.t % 4 == 0 then
				local closest, distance = Entity.closest(owner, Enemy.enemies)
				if distance < range then
					-- i was healing them when going left lol
					closest:damage(damage)
				end
			end
		end,
		draw = function(self, owner)
			spr(owner.gfx[80].bmp, owner.x - 12, owner.y - owner.hitbox.h*2 + 21, owner.flip)
			spr(owner.gfx[80].bmp, owner.x - 20, owner.y - owner.hitbox.h*2 + 21, owner.flip)
		end,
	},
}
