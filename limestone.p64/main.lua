--[[pod_format="raw",created="2024-03-18 18:22:30",modified="2025-04-16 17:31:12",revision=3876]]
-- limestone (internal)
-- by cubee

debug = {
	--collision = true,
	--entityCollision = true,
}

include("entities/entity.lua")
include("entities/player.lua")
include("entities/enemy.lua")
include("entities/exit.lua")
include("entities/entrance.lua")
include("entities/pickup.lua")
include("entities/particle.lua")

include("helpers/motion.lua")
include("helpers/map.lua")

include("data/rounds.lua")

function _init()
	poke(0x5f5c, 255)
	
	gt = 0

	levelCollision = false
	levelVisual = false

	levelMap = fetch("map/0.map")
	for i in all(levelMap) do
		if i.name == "solid" then
			levelCollision = i
		elseif i.name == "visual" then
			levelVisual = i
		end
	end

	player = Player:create(8 * 128, 128)
	--Enemy:create(7.5*128 + 64, 0)
	--Enemy:create(9*128 + 64, 0)
	--Enemy:create(10*128 + 64, 0)

	Exit:create(8*128, 0)
	--Exit:create(9*128, 0)
	--Exit:create(10*128, 0)

	Entrance:create(8*128 + 768 + 192, 15 * 8)
	Entrance:create(8*128 - 768 - 192, 15 * 8)
	Entrance:create(8*128 + 768, 36 * 8)
	Entrance:create(8*128 - 768, 36 * 8)
--[[
	for i = 0, 100 do
		Pickup:create(8 * 128 + i * 8, 100)
	end--]]

	cam_x = 0
	cam_y = 0
	cam_xt = 0
	cam_yt = 0

	intermissionTimer = 60 * 5 -- 3600 * 0.5 --(minutes)
	intermission = intermissionTimer

	-- vertical offset from top, see:
	-- http://higherorderfun.com/blog/2012/05/20/the-guide-to-implementing-2d-platformers/
	slopes = {
		--[193] = {0, 0},
		[194] = {0, 8},
		[195] = {8, 0},
		[196] = {0, 4},
		[197] = {4, 8},
		[198] = {8, 4},
		[199] = {4, 0},
	}
end

function _update()

	-- rounds
	if intermission > 0 then
		intermission -= 1

		-- start next round
		if intermission <= 0 then

			-- stop if there is not a valid round here
			if Round.index > #rounds then
				stop()
			else
				Round.beginNext()
				intermission = 0
			end
		end

	else
		-- update round
		local roundTime = Round.updateAll()

		-- round is finished
		if roundTime == 0 then
			intermission = intermissionTimer
			Round.index += 1

		-- there are no more rounds
		elseif roundTime == -1 then
			stop()
		end
	end

	cam_xt, cam_yt = Player.updateAll()
	Enemy.updateAll()

	Pickup.updateAll()
	Particle.updateAll()

	Entrance.updateAll()
	Exit.updateAll()

	--Pickup:create(8 * 128 + sin(gt/ 150) * 100, 100)

	cam_x += (cam_xt - cam_x) / 8
	cam_y += (cam_yt - cam_y) / 8

	gt = max(gt + 1, 0)
end

function _draw()
	cls(1)
	
	camera(cam_x - 240, cam_y - 120)


	--[[
	for i = #levelMap, 1, -1 do
		map(levelMap[i].bmp)
	end
	--]]
	-- background particles
	Particle.drawAll(false)

	-- map layers
	map(levelVisual.bmp)
	if(debug and debug.collision)map(levelCollision.bmp)

	-- entities
	Entrance.drawAll()
	Exit.drawAll()
	Enemy.drawAll()
	Pickup.drawAll()
	Player.drawAll()
	
	-- foreground particles
	Particle.drawAll(true)

	camera(0, 0)
	cursor(32, 16)
	color(12)

	--[[ tilemap debug
	for k,a in pairs(levelMap[1]) do
		print(k.." "..tostr(a), 7)
	end
	--]]
	--print(cmget(2, 33), 32, 16, 12)
	print("Round: " .. Round.index .. " (" .. Round.tick .. "/" .. Round.minDuration .. ")")
--[[
	print(pod(rounds[Round.index]))
	for k,i in ipairs(rounds[Round.index]) do
		print(k)
		print(pod(i.tick))
	end]]

	if intermission > 0 then
		print("Intermission: " .. (intermission \ 60), 64, 64, 7)
		print("" .. rounds[Round.index].tip)
	end
end
