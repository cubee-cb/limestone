--[[pod_format="raw",created="2025-04-15 05:09:42",modified="2025-04-17 02:16:50",revision=2217]]
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
		-- todo: add dash binding
	},

	wings = {
		name = "Wings",
		desc = "Grants 2 extra jumps",
		equip = function(_ENV)
			--_ENV.maxJumps += 2 -- this doesn't work somehow
			maxJumps = 4
		end
	},

	wallJump = {
		name = "Magnet Fingers",
		desc = "Grants the ability to slide and jump on walls",
		equip = function(_ENV)
			canWallJump = true
		end
	},

	monkeyBars = {
		name = "Portable Monkey Bars",
		desc = "Hold UP to climb along ceilings",
		-- todo: add roof climbing
	},

	dive = {
		name = "Dive",
		desc = "",
		-- todo
	},

	push = {
		name = "Push",
		desc = "push things idk",
		-- todo
	},

	homingAttack = {
		name = "Homing Attack",
		desc = "Home into enemies by dashing in the air",
		dash = function(_ENV)
			xv, yv = 1, 1
			local closest = closest(_ENV, Enemy.enemies)
		end
		-- todo: implement dash properly
	},

}
