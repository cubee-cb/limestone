--[[pod_format="raw",created="2025-04-16 00:37:01",modified="2025-04-30 23:39:06",revision=5828]]
-- round information
-- cubee

Round = {
	tick = 0,
	index = 1,
	handlers = {},
	garbage = {},
	minDuration = 100,
	intermission = 0,
	flawless = true,
	warning = 0,
}

function Round.createHandler(data)
	local handler = {
		data = data,
		t = 0,
		entranceIndex = 1, -- entrance this handler is currently spawning enemies at
	}

	add(Round.handlers, handler)
end

function Round.beginNext()
	-- return if there is not a valid round here
	if (Round.index > #rounds) return
	local r = rounds[Round.index]

	Round.tick = 0
	Round.handlers = {}
	Round.minDuration = Round.getDuration(r)
	Round.flawless = true
	Round.warning = 0
end

function Round.getDuration(roundData)
	if (not roundData) return 0

	local length = 0
	for data in all(roundData) do
		length += (data.amount - 1) * data.spacing + 1
	end

	return length
end

-- tick all rounds and clear finished ones
-- returns amount of handlers currently running
function Round.updateAll()
	Round.garbage = {}

	-- return if there is not a valid round here
	if (Round.index > #rounds) return -1

	local thisRound = rounds[Round.index]
	if (thisRound.endGame) return -1

	-- create handlers for this tick
	for h in all(thisRound) do
		if (h.tick == Round.tick) Round.createHandler(h)
	end

	for h in all(Round.handlers) do
		Round.update(h)
	end

	-- clear finished rounds
	for h in all(Round.garbage) do
		del(Round.handlers, h)
	end

	Round.tick += 1
	Round.warning = max(Round.warning - 1, 0)

	if Round.tick >= Round.minDuration and (#Enemy.enemies == 0) then
		return 0
	end

	return Round.tick
end

function Round.update(h)
	local data = h.data
	if (Round.index > #rounds) return

	if h.t < data.amount * data.spacing then

		if h.t % data.spacing == 0 then
			local enID = data.entrances[h.entranceIndex]
			local entrance = Entrance.entrances[enID]

			Enemy:create(data.type, entrance.x, entrance.y)
			h.entranceIndex += 1
		end

		if h.entranceIndex > #data.entrances then
			h.entranceIndex = 1
		end

	else
		add(Round.garbage, _ENV)
	end

	h.t += 1
end

rounds = {
--[[
	{
		tip = "test round",
		{
			tick = 0, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 5, -- amount to spawn
			spacing = 40, -- interval between spawns
			entrances = {1}, -- entrances to spawn at
		},
		{
			tick = 0, -- tick to create this spawner at
			type = Strobe, -- enemy class to spawn
			amount = 5, -- amount to spawn
			spacing = 40, -- interval between spawns
			entrances = {2}, -- entrances to spawn at
		},
		{
			tick = 120, -- tick to create this spawner at
			type = Cannon, -- enemy class to spawn
			amount = 5, -- amount to spawn
			spacing = 40, -- interval between spawns
			entrances = {3, 4}, -- entrances to spawn at
		},
		{
			tick = 200, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 100, -- amount to spawn
			spacing = 1, -- interval between spawns
			entrances = {1, 2, 3, 4}, -- entrances to spawn at
		},
	},
]]
	{
		tip = "Enemies appear from the upper right portal for now.",
		{
			tick = 0, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 15, -- amount to spawn
			spacing = 20, -- interval between spawns
			entrances = {1}, -- entrances to spawn at
		},
	},

	{
		tip = "The store below the crystal opens during intermissions.",
		{
			tick = 0, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 15, -- amount to spawn
			spacing = 20, -- interval between spawns
			entrances = {1}, -- entrances to spawn at
		},
	},

	{
		tip = "This time, enemies enter through the upper left portal.",
		{
			tick = 0,
			type = Pop,
			amount = 25,
			spacing = 15,
			entrances = {2},
		},
	},

	{
		tip = "Enemies can arrive packed together more tightly.",
		{
			tick = 0,
			type = Pop,
			amount = 20,
			spacing = 20,
			entrances = {2},
		},
		{
			tick = 400,
			type = Pop,
			amount = 20,
			spacing = 10,
			entrances = {2},
		},
	},

	{
		tip = "This round, enemies come from both lower portals.",
		{
			tick = 0,
			type = Pop,
			amount = 20,
			spacing = 15,
			entrances = {3},
		},
		{
			tick = 350,
			type = Pop,
			amount = 20,
			spacing = 30,
			entrances = {4},
		},
		{
			tick = 600,
			type = Pop,
			amount = 20,
			spacing = 20,
			entrances = {3},
		},
	},

	

	{
		tip = "A new enemy type appears. These ones explode.",
		{
			tick = 0,
			type = Strobe,
			amount = 2,
			spacing = 600,
			entrances = {3, 4},
		},
	},


	{
		tip = "This round, enemies enter from both upper portals. Prepare accordingly!",
		{
			tick = 0,
			type = Pop,
			amount = 30,
			spacing = 20,
			entrances = {1, 2},
		},
		{
			tick = 300,
			type = Strobe,
			amount = 2,
			spacing = 300,
			entrances = {1},
		},
		{
			tick = 600,
			type = Pop,
			amount = 20,
			spacing = 20,
			entrances = {2},
		},
	},

	{
		tip = "A mix of more enemies, coming from the lower portals.",
		{
			tick = 0,
			type = Strobe,
			amount = 1,
			spacing = 0,
			entrances = {3},
		},
		{
			tick = 120,
			type = Strobe,
			amount = 1,
			spacing = 0,
			entrances = {4},
		},
		{
			tick = 300,
			type = Pop,
			amount = 10,
			spacing = 30,
			entrances = {3},
		},
		{
			tick = 420,
			type = Pop,
			amount = 30,
			spacing = 10,
			entrances = {4},
		},
	},

	{
		tip = "The enemies will use up to 3 portals from now on.",
		{
			tick = 0,
			type = Strobe,
			amount = 3,
			spacing = 120,
			entrances = {1},
		},
		{
			tick = 120,
			type = Pop,
			amount = 30,
			spacing = 60,
			entrances = {3},
		},
		{
			tick = 500,
			type = Pop,
			amount = 20,
			spacing = 10,
			entrances = {4},
		},
	},

	{
		tip = "Did someone say disco? ...No? Well... there's something going on downstairs.",
		{
			tick = 60,
			type = ProudStrobe,
			amount = 10,
			spacing = 100,
			entrances = {3, 4},
		},
	},

	{
		tip = "Introducing: Cannons! These ones shoot heavy ice chunks at the player.",
		{
			tick = 0,
			type = CryoCannon,
			amount = 2,
			spacing = 600,
			entrances = {3, 4},
		},
		{
			tick = 1200,
			type = Pop,
			amount = 64,
			spacing = 20,
			entrances = {1, 2},
		},
	},

	{
		-- game crashes when encountering a missing round,
		-- so just tell it to end using an extra round
		endGame = true,
		tip = "That's all the rounds for now! The game will end once intermission finishes.",

	},
}
