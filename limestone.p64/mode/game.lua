--[[pod_format="raw",created="2025-04-17 02:21:14",modified="2025-04-30 23:39:06",revision=4720]]
-- game screen
-- cubee

GameMode.game = {
	init = function()
		Player.players = {}
		Enemy.enemies = {}
		Exit.exits = {}
		Entrance.entrances = {}
		Pickup.pickups = {}
		Particle.particles = {}
		StoreItem.items = {}


		levelCollision = false
		levelVisual = false
		levelFore = false
		levelBack = false

		levelMap = fetch("map/0.map")
		for i in all(levelMap) do
			if i.name == "solid" then
				levelCollision = i
			elseif i.name == "visual" then
				levelVisual = i
			elseif i.name == "foreground" then
				levelFore = i
			elseif i.name == "background" then
				levelBack = i
			end
		end

		player = Player:create(8 * 128, 128)
		--Enemy:create(7.5*128 + 64, 0)
		--Enemy:create(9*128 + 64, 0)
		--Enemy:create(10*128 + 64, 0)

		Exit:create(8*128, 64)
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

		--StoreItem:create(Item.wings, 128 * 8, 360)
		--StoreItem:create(Item.testificate, 128 * 8, 120)
		--StoreItem.spawnThem(128 * 8, 360)
		
		--Enemy:create(Strobe, 10*128 + 64, 0)

		cam_x = 0
		cam_y = 0
		cam_xt = 0
		cam_yt = 0

		intermissionTimer = 3600 * 0.5 --(minutes)
		Round.intermission = intermissionTimer -- 60 * 5 --

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
		
	

---[[
		local i = 0
		for k,_ in pairs(Item) do
			local item = StoreItem:create(Item[k], 128 * 2 + i * 48, 120)
			item.value = 0
			i += 1
			Round.intermission = 99999
		end
--]]
	end,

	update = function()

		-- rounds
		if Round.intermission > 0 then
			Round.intermission -= 1

			-- start next round
			if Round.intermission <= 0 then

				-- stop if there is not a valid round here
				if Round.index > #rounds then
					stop()
				else
					Round.beginNext()
					StoreItem.expireAll()
					Round.intermission = 0
				end
			end

		else
			-- update round
			local roundTime = Round.updateAll()

			-- round is finished
			if roundTime == 0 then
				Round.intermission = intermissionTimer
				Round.index += 1

				-- create store items
				StoreItem.spawnThem(128 * 8, 360)

			-- there are no more rounds
			elseif roundTime == -1 then
				GameMode.go(GameMode.finish)
			end
		end

		Projectile.updateAll()
		Enemy.updateAll()

		cam_xt, cam_yt = Player.updateAll()

		Pickup.updateAll()
		Particle.updateAll()
		StoreItem.updateAll()

		Entrance.updateAll()
		local aliveExits = Exit.updateAll()
		if aliveExits <= 0 then
			GameMode.go(GameMode.dead)
		end

		--Pickup:create(8 * 128 + sin(gt/ 150) * 100, 100)

		cam_x += (cam_xt - cam_x) / 8
		cam_y += (cam_yt - cam_y) / 8
	end,

	draw = function()
		camera(cam_x - 240, cam_y - 120)
		palt()

		--[[
		for i = #levelMap, 1, -1 do
			map(levelMap[i].bmp)
		end
		--]]

		-- background
		map(levelBack.bmp)
		palt(0, false)
		palt(17, true)
		Entrance.drawAll()
		Exit.drawAll()

		Particle.drawAll(false)

		-- middleground
		-- map layers
		palt()
		map(levelVisual.bmp)
		if(db and db.collision)map(levelCollision.bmp)
		palt(0, false)
		palt(17, true)

		-- entities
		Enemy.drawAll()
		Pickup.drawAll()
		StoreItem.drawAll()
		Projectile.drawAll()
		Player.drawAll()

		-- foreground
		Particle.drawAll(true)
		palt()
		map(levelFore.bmp)
		palt(0, false)
		palt(17, true)

		camera(0, 0)
		cursor(32, 16)
		color(12)

		--[[ tilemap debug
		for k,a in pairs(levelMap[1]) do
			print(k.." "..tostr(a), 7)
		end
		--]]
		--print(cmget(2, 33), 32, 16, 12)
		print("\#1Round: " .. Round.index .. " (" .. Round.tick .. "/" .. Round.minDuration .. ")")
		print("\#1Points: " .. player.points["normal"])
	--[[
		print(pod(rounds[Round.index]))
		for k,i in ipairs(rounds[Round.index]) do
			print(k)
			print(pod(i.tick))
		end]]

		if Round.intermission > 0 then
			print("\#2Intermission: " .. (Round.intermission \ 6 / 10), 32, 220, 7)
			print("\#2" .. (rounds[Round.index].tip or ""))
			print("\#2\f6Press (X or V) near the crystal to end intermission early.")
		end
		
		?"C: "..stat(1),1,1,13
	end,
}
