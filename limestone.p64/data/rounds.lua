--[[pod_format="raw",created="2025-04-16 00:37:01",modified="2025-04-16 17:31:12",revision=1001]]
-- round information
-- cubee

Round = {
	tick = 0,
	index = 1,
	handlers = {},
	garbage = {},
	minDuration = 100,
	tip = "",
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
		local roundData = rounds[Round.index]

		if h.t % data.spacing == 0 then
			local enID = roundData.entrances[h.entranceIndex]
			local entrance = Entrance.entrances[enID]

			Enemy:create(entrance.x, entrance.y)
			h.entranceIndex += 1
		end

		if h.entranceIndex > #roundData.entrances then
			h.entranceIndex = 1
		end

	else
		add(Round.garbage, _ENV)
	end

	h.t += 1
end

rounds = {
	[1] = { -- round number
		tip = "Enemies start from the first entrance.",
		entrances = {1}, -- entrances to spawn at
		{
			tick = 0, -- tick to create this spawner at
			type = Pop, -- enemy class to spawn
			amount = 15, -- amount to spawn
			spacing = 20, -- interval between spawns
		},
	},
	

	[2] = {
		tip = "Enemies come through the second entrance this time.",
		entrances = {2},
		{
			tick = 0,
			type = Pop,
			amount = 25,
			spacing = 15,
		},
	},
	

	[3] = {
		tip = "A new enemy type appears.",
		entrances = {1},
		{
			tick = 0,
			type = Pop,
			amount = 15,
			spacing = 30,
		},
		{
			tick = 0,
			type = Cannon,
			amount = 4,
			spacing = 240,
		},
		{
			tick = 450,
			type = Pop,
			amount = 15,
			spacing = 30,
		},
	},


	[4] = {
		tip = "This round, enemies come from multiple entrances. Prepare accordingly!",
		entrances = {1, 2},
		{
			tick = 0,
			type = Pop,
			amount = 30,
			spacing = 20,
		},
		{
			tick = 600,
			type = Pop,
			amount = 20,
			spacing = 10,
		},
		{
			tick = 600,
			type = Cannon,
			amount = 8,
			spacing = 40,
		},
	},
}
