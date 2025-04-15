--[[pod_format="raw",created="2025-04-15 05:09:42",modified="2025-04-15 17:34:54",revision=1129]]
-- ability
-- cubee

Ability = {
	dash = {
		name = "Dash",
		desc = "Dash by double-tapping a direction",
		dash = function(_ENV)
			xv = flip and -5 or 5
			yv = -1
		end
	},

	wings = {
		name = "Wings",
		desc = "Grants 2 extra jumps",
		equip = function(_ENV)
			_ENV.maxJumps += 2 -- this doesn't work somehow
			maxJumps = 4
		end
	},

	wallJump = {
		name = "Magnet Fingers",
		desc = "Grants the ability to slide and jump on walls",
	},

	monkeyBars = {
		name = "Portable Monkey Bars",
		desc = "Hold UP to climb along ceilings",
	},

	dive = {
		name = "Dive",
		desc = "",
	},

	push = {
		name = "Push",
		desc = "push things idk",
	},

	homingAttack = {
		name = "Homing Attack",
		desc = "Home into enemies by dashing in the air",
		dash = function(_ENV)
			xv, yv = 1, 1
			local closest = closest(_ENV, Enemy.enemies)
		end
	},

}
