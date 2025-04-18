--[[pod_format="raw",created="2025-04-17 11:45:14",modified="2025-04-18 16:22:43",revision=2110]]
-- store item
-- cubee

StoreItem = setmetatable({
	items = {},
	garbage = {},
	gfx = fetch("gfx/items.gfx")
}, {__index = Entity})

-- create pickup
function StoreItem:create(itemData, x, y)
	x = x or 128
	y = y or 16

	local en = setmetatable({
		t = rnd(200),
		x = x,
		y = y,
		xv = 0,
		yv = -2,
		hitbox = {w = 8, h = 8},
		hitboxDamage = {w = 0, h = 0},
		interactionRange = 24,
		collectable = false,

		data = itemData or {},
		value = itemData.value or 0,

	}, {__index = StoreItem})

	add(StoreItem.items, en)

	return en
end

-- update all pickups and handle garbage pickups
function StoreItem.updateAll()
	StoreItem.garbage = {}

	for p in all(StoreItem.items) do
		p:update()
	end

	-- clear old items
	for p in all(StoreItem.garbage) do
		del(StoreItem.items, p)
	end

end

-- draw all pickups
function StoreItem.drawAll()
	for e in all(StoreItem.items) do
		e:draw()
	end
end

-- base update
function StoreItem.update(_ENV)
	local closestPlayer, distance = closest(_ENV, Player.players)

	-- outside interaction range
	if distance > interactionRange + 16 or not closestPlayer then
		collectable = false

	-- inside interaction range
	elseif distance <= interactionRange and not collectable then
		collectable = true
		sfx(0)

	end
	collectable = distance <= interactionRange

	if collectable and closestPlayer then
	end

	xv *= 0.9
	yv += 0.2
	yv = min(yv, 6)

	if fget(cmget(x - 3, y), 0) or fget(cmget(x + 3, y), 0) then
		xv = 0
	end
	if yv > 0 and (fget(cmget(x, y), 0) or fget(cmget(x, y), 2)) then
		if yv > 1.5 then
			yv = -yv * 0.3
			sfx(8)
		else
			yv = 0
		end
		xv *= 0.5
		y = y \ 8 * 8
	end

	x += xv
	y += yv

	t = max(t + 1)
end

-- base draw
function StoreItem.draw(_ENV)
	local s = 1
	local a = sin(t / 100) / 20
	rspr(gfx[data.sprite].bmp, x + a * 32, y - 8 - abs(a * 20), s, s, a)
	fillp(0b0111110101111101)
	fillp(0b1010010110100101)
	circ(x, y - 8, interactionRange + sin(t / 120) * 1.5, collectable and 11 or 0x001d)
	fillp()
	--debugVisuals(_ENV)
	--?a,x,y
end

function StoreItem.expireAll()
	for i in all(StoreItem.items) do
		for a = 0, 5 do
			Particle:create(Particle.dust, i.x + rnd(4) - 2, i.y + rnd(4) - 10)
		end
	end
	sfx(10)

	StoreItem.items = {}
end

function StoreItem.purchase(owner, item)
	if owner.points["normal"] >= item.value then
		add(StoreItem.garbage, item)
		local slot = item.data.name -- item.data.slot
		local slotItem = owner.equipment[slot]

		-- upgrade existing item
		if slotItem and slotItem.name == item.data.name then
			-- max level reached
			if slotItem.level >= item.data.maxLevel then
				sfx(7)

			-- add a level
			else
				owner.equipment[slot].level += 1
				sfx(6)
				owner.points["normal"] -= item.value
				return item.data
			end
		else
			-- add new item
			owner.equipment[slot] = item.data
			owner.equipment[slot].level = 1
			sfx(5)
			owner.points["normal"] -= item.value
			return item.data
		end

	else
		sfx(4)
	end

	return false
end

function StoreItem.spawnThem(x, y)

	local pool = {}
	for k,v in pairs(Item) do
		if not v.hideFromPool then
			add(pool, k)
		end
	end

	for i=-1, 1 do
		local item = del(pool, rnd(pool))
		StoreItem:create(Item[item], x + 56 * i, y)
	end

end
