--[[pod_format="raw",created="2025-04-16 00:37:01",modified="2025-04-17 02:16:50",revision=1160]]
-- round information
-- cubee

Round = {
	tick = 0,
	index = 5,
	handlers = {},
	garbage = {},
	minDuration = 100,
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
end

function Round.getDuration(roundData)
	if (not roundData) return 0

	local length = 0
	for data in all(roundData) do
		length += data.amount * data.spacing
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

	if Round.tick >= Round.minDuration and (#Enemy.enemies == 0) then
		return 0
	end

	return Round.tick
end

function Round.update(h)
	local data = h.data
	if (Round.index > #rounds) return

	if h.t <= data.amount * data.spacing then

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
	[1] = { -- round number
		tip = "test round",
		{
			tick = 0, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 5, -- amount to spawn
			spacing = 40, -- interval between spawns
			entrances = {1}, -- entrances to spawn at
		},
		{
			tick = 120, -- tick to create this spawner at
			type = Cannon, -- enemy class to spawn
			amount = 5, -- amount to spawn
			spacing = 40, -- interval between spawns
			entrances = {3, 4}, -- entrances to spawn at
		},
	},
	
	[1.1] = { -- round number
		tip = "Enemies start from the first entrance.",
		{
			tick = 0, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 15, -- amount to spawn
			spacing = 20, -- interval between spawns
			entrances = {1}, -- entrances to spawn at
		},
	},
	

	[2] = {
		tip = "Enemies come through the second entrance this time.",
		{
			tick = 0,
			type = Pop,
			amount = 25,
			spacing = 15,
			entrances = {2},
		},
	},
	

	[3] = {
		tip = "A new enemy type appears.",
		{
			tick = 0,
			type = Pop,
			amount = 15,
			spacing = 30,
			entrances = {1},
		},
		{
			tick = 0,
			type = Cannon,
			amount = 4,
			spacing = 240,
			entrances = {1},
		},
		{
			tick = 450,
			type = Pop,
			amount = 15,
			spacing = 30,
			entrances = {1},
		},
	},


	[4] = {
		tip = "This round, enemies come from multiple entrances. Prepare accordingly!",
		{
			tick = 0,
			type = Pop,
			amount = 30,
			spacing = 20,
			entrances = {1, 2},
		},
		{
			tick = 600,
			type = Pop,
			amount = 20,
			spacing = 10,
			entrances = {1},
		},
		{
			tick = 600,
			type = Cannon,
			amount = 8,
			spacing = 40,
			entrances = {2},
		},
	},


	[5] = {
		endGame = true,

	},
}
