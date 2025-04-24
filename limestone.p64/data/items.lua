--[[pod_format="raw",created="2025-04-17 11:53:59",modified="2025-04-24 13:10:07",revision=4503]]
-- items
-- cubee

Item = {
	testificate = {
		hideFromPool = true,
		sprite = 3,
		name = "Villager dude",
		desc = "Bypass the speed cap.",
		value = 150,
		slot = "pet",
		maxLevel = 10,
		incompatible = {"stilts", "longClawDash", "spectre", "wings", "thrusters"},
		init = function(self, owner, origin)
			owner.yv = -5

			for i = 1, 5 do
				Particle:create(Particle.dust, origin.x, origin.y, rnd(2) - 1, (rnd(2) - 1) / 5)
				sfx(2)
			end
		end,
		update = function(self, owner)
			if (btn(0) and owner.xv < 0 or btn(1) and owner.xv > 0) owner.xv *= 1 + self.level / 100
		end,
		draw = function(self, owner)
			circ(owner.x, owner.y, 48 + sin(owner.t / 10) * 8, 11)
		end,
	},

	wings = {
		sprite = 1,
		name = "Wings",
		desc = "Grants an extra jump.", -- "Adds to your maximum jumps.",
		value = 40,
		slot = "back",
		maxLevel = 3,
		incompatible = {"thrusters", "gunboots"},
		init = function(self, owner, origin)
			owner.maxJumps += 1
		end,
	},

	stilts = {
		sprite = 2,
		name = "Stilts",
		desc = "Become taller. Walking deals contact damage.", -- "Adds to your maximum jumps.",
		value = 50,
		slot = "feet",
		maxLevel = 5,
		incompatible = {"gunboots", "iceSkates"},
		init = function(self, owner, origin)
			owner.hitbox.h += level == 1 and 12 or 2
		end,
		update = function(self, owner)
			local damage = abs(owner.xv) * self.level / 4
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
			spr(owner.gfx[87 + self.level].bmp, owner.x - 12, owner.y - owner.hitbox.h*2 + 21, owner.flip)
			spr(owner.gfx[87 + self.level].bmp, owner.x - 20, owner.y - owner.hitbox.h*2 + 21, owner.flip)
		end,
	},

	flameBreath = {
		hideFromPool = true,
		sprite = 4,
		name = "Red Hot Chili Pepper",
		desc = "Breath fire.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	grappleTongue = {
		hideFromPool = true,
		sprite = 5,
		name = "Really long tongue",
		desc = "Grapple enemies.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	impostorTongue = {
		hideFromPool = true,
		sprite = 6,
		name = "Really Pointy Tongue",
		desc = "Impale enemies.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	laserEyes = {
		hideFromPool = true,
		sprite = 7,
		name = "Laser Eyes",
		desc = "Shoot lasers from your eyes.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	shoulderCannon = {
		hideFromPool = true,
		sprite = 8,
		name = "Shoulder-Mount Cannon",
		desc = "Fires explosive cannonballs.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	jawExtension = {
		hideFromPool = true,
		sprite = 9,
		name = "Mechanical Jaw",
		desc = "Is that the bite of '87!?",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	malletFist = {
		hideFromPool = true,
		sprite = 10,
		name = "Brass Mallets",
		desc = "Like brass knuckles, but with a lot more mass.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	longClawDash = {
		sprite = 27, --11,
		name = "Telefragger",
		desc = "Press attack in the air to Telefrag targeted enemies.",
		value = 75,
		--slot = "arms",
		maxLevel = 5,
		incompatible = {"grappleTongue"},
		init = function(self, owner, origin)
			self.target = false
			self.cooldown = 60
			self.ticks = 0
		end,
		update = function(self, owner)
			local distance = 0
			self.target, distance = Entity.closest(owner, Enemy.enemies, self.ticks == 0 and (64 + self.level * 16) or (24 + self.level * 4))
			if ((not owner.air or self.cooldown > 0) and self.ticks <= 0) self.target = false

			-- start teleports
			if btnp(5) and self.target and self.ticks <= 0 then
				self.ticks = self.level
				self.cooldown = 80 + (self.level * 20)
			end

			-- use however many ticks it requires to smite this enemy
			local baseDamage = 4 + self.level
			local ticksToSmite = 1
			if self.target then
				ticksToSmite = max(ceil(self.target.hp / baseDamage), 1)
			end

			-- teleport to closest target
			if self.cooldown % 5 == 0 and self.ticks >= ticksToSmite then
				if self.target then
					sfx(24)
					owner.x = self.target.x
					owner.y = self.target.y - self.target.hitbox.h + 4
					owner.yv = -3.5
					owner.xv = self.target.x < owner.x and -2 or 2
					self.target:damage(baseDamage * ticksToSmite, owner)
				else
					--sfx()
				end
				self.ticks -= ticksToSmite
			end

			self.cooldown = max(self.cooldown - 1, -1)
			if self.cooldown == 0 then
				sfx(23)
			end
		end,
		draw = function(self, owner)
			-- target
			if self.target then
				--spr(owner.gfx[136 + owner.t % 20 \ 10].bmp, self.target.x, self.target.y - self.target.hitbox.h)
				local s = 1 + sin(owner.t / 15) * 0.1
				rspr(owner.gfx[136 + owner.t % 20 \ 10].bmp, self.target.x, self.target.y - self.target.hitbox.h, s, s, owner.t / 100)
			end
			--print(self.ticks, owner.x, owner.y)
			
		end,
	},

	revolver = {
		hideFromPool = true,
		sprite = 12,
		name = "Old-timey Revolver",
		desc = "Gun.",
		value = 70,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},
	
	tentacles = {
		hideFromPool = true,
		sprite = 13,
		name = "Item",
		desc = "Long range melee.",
		value = 25,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	autoGuns = {
		hideFromPool = true,
		sprite = 14,
		name = "Autoguns",
		desc = "Unmanned turrets fly around autonomously.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	gunboots = {
		sprite = 15,
		name = "Gunboots",
		desc = "Great for a safely descending down wells.",
		value = 80,
		--slot = "arms",
		maxLevel = 5,
		incompatible = {"stilts", "wings"},
		init = function(self, owner, origin)
			self.maxAmmo = 7 + self.level
			self.ammo = self.maxAmmo
			self.canFire = false
		end,
		update = function(self, owner)
			if self.ammo > 0 and self.canFire and btnp(4) then
				owner.yv = min(owner.yv, -0.5)
				self.ammo -= 1
				sfx(self.ammo > 2 and 15 or self.ammo > 0 and 16 or self.ammo <= 0 and 17)
			
				for i = -1, 1, 2 do
					Projectile:create(Projectile.downBullet, owner.x + i * 4, owner.y, i, 8, 0.5 + self.level / 2, owner)
				end
			end
		
			if not owner.air and self.ammo < self.maxAmmo then
				self.ammo = self.maxAmmo
				sfx(13)
			end
			
			self.canFire = owner.air and owner.wallslide == 0
		
			self.ammo = mid(0, self.ammo, self.maxAmmo)
		end,
		draw = function(self, owner)
			if (not owner.air) return
			local s = 2
			for i = self.maxAmmo, 1, -1 do
				circfill(owner.x + i * s - self.maxAmmo * s / 2, owner.y + 4, 1, i <= self.ammo and 7 or 24)
			end
		end,
	},
	
	spectre = {
		sprite = 16,
		name = "Spectral Impulse",
		desc = "Defeated enemies launch spectres that damage other enemies.",
		value = 60,
		--slot = "arms",
		maxLevel = 5,
		onKill = function(self, owner, victim)
			Projectile:create(Projectile.spectre, victim.x, victim.y - victim.hitbox.h * 2, 0, -3, self.level / 2, owner)
		end,
	},

	thrusters = {
		sprite = 17,
		name = "Rocket Thrusters",
		desc = "Hold Up to fly. Fuel recharges on the ground.",
		value = 120,
		--slot = "arms",
		maxLevel = 5,
		incompatible = {"wings"},
		init = function(self, owner, origin)
			self.maxFuel = 30 + 30 * self.level
			self.fuel = self.maxFuel
		end,
		update = function(self, owner)
			if self.fuel > 0 and btn(4) and not btn(3) then
				owner.yv = min(owner.yv, -1 - (self.level / 3))
				self.fuel -= 1
			end

			if not owner.air then
				self.fuel += 2
			end

			self.fuel = mid(0, self.fuel, self.maxFuel)
		end,
		draw = function(self, owner)
			if self.fuel > 0 and btn(4) then
				Particle:create(Particle.fireJet, owner.x, owner.y, rnd(2) - 1, 3 + rnd(4))
			end
		end,
	},
	
	iceSkates = {
		hideFromPool = true,
		sprite = 18,
		name = "Ice Skates",
		desc = "Leave an ice trail. Slippery.",
		value = 20,
		--slot = "arms",
		maxLevel = 5,
		incompatible = {"stilts", "flameTrail"},
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},

	bladeAura = {
		hideFromPool = true,
		sprite = 19,
		name = "Blade Aura",
		desc = "Spinning blades shred nearby enemies.",
		value = 75,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
			self.flameLevel = 0
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},
	
	flameTrail = {
		sprite = 20,
		name = "Flame Trail",
		desc = "Leave behind flames as you move.",
		value = 35,
		--slot = "arms",
		maxLevel = 5,
		incompatible = {"iceSkates"},
		init = function(self, owner, origin)
			self.active = true
		end,
		update = function(self, owner)
			if owner.equipment.bladeAura then
				owner.equipment.bladeAura.flameLevel = self.level
				self.active = false
				return
			else
				self.active = true

				if owner.t % (11 - self.level) == 0 then
					local s = 0.75
					Projectile:create(Projectile.flame, owner.x, owner.y - owner.hitbox.h, owner.xv / 2, owner.yv * s, self.level * s, owner)
				end
			end
		end,
		draw = function(self, owner)
			if (not self.active) return
		end,
	},
	
	afterImage = {
		hideFromPool = true,
		sprite = 21,
		name = "Afterimage",
		desc = "Duplicates actions.",
		value = 350,
		--slot = "arms",
		maxLevel = 1,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},
	
	magnesis = {
		sprite = 22,
		name = "Magnetism",
		desc = "Draw in pickups from further away.",
		value = 20,
		--slot = "arms",
		maxLevel = 10,
		init = function(self, owner, origin)
			owner.bonusPickupRange += 16
		end,
	},
	
	bigRock = {
		hideFromPool = true,
		sprite = 23,
		name = "Big rock",
		desc = "Big rock.",
		value = 120,
		--slot = "arms",
		maxLevel = 500,
		init = function(self, owner, origin)
			self.cooldown = 0
		end,
		update = function(self, owner)
			if btnp(5) and self.cooldown <= 0 then
				local s = 8 + self.level * 2
				local damage = 7 + self.level * 3
				Projectile:create(Projectile.bigRock, owner.x, owner.y, owner.flip and -s or s, -1, damage, owner)
				self.cooldown = 60 * 5
			end

			self.cooldown = max(self.cooldown - 1)
		end,
		draw = function(self, owner)
		end,
	},
	
	bouncy = {
		hideFromPool = true,
		sprite = 24,
		name = "Bouncy",
		desc = "Bounce idk.",
		value = 20,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
		end,
		update = function(self, owner)
			if owner.yv > 1 then
			end
		end,
		draw = function(self, owner)
		end,
	},

	spinDash = {
		sprite = 25,
		name = "Charge Dash",
		desc = "Hold Down and tap Jump to charge a dash.",
		value = 40,
		--slot = "arms",
		maxLevel = 4,
		init = function(self, owner, origin)
			owner.spinCharge = 0
		end,
		update = function(self, owner)
			if btn(3) and not owner.air and btnp(4) then
				owner.spinCharge += 0.5 + (self.level * 0.5)
				sfx(owner.spinCharge > 4 and 13 or 12)
			end
			owner.spinCharge -= 0.01
			owner.spinCharge = mid(0, owner.spinCharge, 4)
			if owner.spinCharge > 0 then
				owner.xv = 0
			end

			if (owner.spinCharge > 0 and not btn(3)) then
				owner.spinCharge = 0
				owner.xv = (4 + owner.spinCharge + self.level * 2) * (owner.flip and -1 or 1)
			end
		end,
		draw = function(self, owner)
			if(owner.spinCharge > 0)Particle:create(Particle.dust, owner.x, owner.y, owner.flip and 2 + owner.spinCharge or -2 - owner.spinCharge)
		end,
	},

	nemesis = {
		sprite = 26,
		name = "Nemesis",
		--desc = "A rather large yellow bird with a laser gun. May request salary.",
		desc = "A rather large yellow bird, with a laser gun.",
		value = 80,
		--slot = "arms",
		maxLevel = 5,
		init = function(self, owner, origin)
			self.x = self.x or owner.x
			self.y = self.y or owner.y - 64
			self.xv = self.xv or 0
			self.yv = self.yv or -0.5
			self.flip = false
			self.cooldown = 60
			self.target = false

		end,
		update = function(self, owner)
			local distance = 0
			self.target, distance = Entity.closest(self, Enemy.enemies)

			local xt, yt =
				owner.x + cos(owner.t / 600) * 48,
				owner.y - owner.hitbox.h * 2 - 16 + sin(owner.t / 600) * 24
			self.xv += (xt - self.x) / 200
			self.yv += (yt - self.y) / 200

			local s = 2 + self.level / 3
			self.xv = mid(-s, self.xv, s)
			self.yv = mid(-s, self.yv, s)
	
			self.x += self.xv
			self.y += self.yv

			if self.target and distance <= 120 then
				self.flip = self.target.x < self.x
				
				-- shoot
				self.cooldown -= self.level
				if self.cooldown <= 0 then
					local xv, yv = normalise(self.target.x - self.x, self.target.y - self.y, 8)

					Particle:create(Particle.dust, self.x + (self.flip and -8 or 8), self.y - 9, self.flip and -3 or 3, -1)
					Projectile:create(Projectile.laser, self.x, self.y, xv, yv, self.level, owner)

					self.cooldown = 60
					sfx(19)
				end
				
			else
				self.flip = self.xv < 0
			end

		end,
		draw = function(self, owner)
			local s = 128
			if self.target then
				s = 131 + owner.t % 10 \ 5
			else
				s = 129 + owner.t % 10 \ 5
			end
			spr(owner.gfx[s].bmp, self.x - 8, self.y - 8, self.flip)
		end,
	},

	--[[
	item = {
		sprite = 0,
		name = "Item",
		desc = "Blank.",
		value = 50,
		--slot = "arms",
		maxLevel = 5,
		init = function(owner, origin)
		end,
		update = function(self, owner)
		end,
		draw = function(self, owner)
		end,
	},]]
}
