--[[pod_format="raw",created="2025-04-23 03:06:27",modified="2025-04-24 13:10:07",revision=364]]
-- the epic multispr function
-- by cubee
-- ported to picotron, also by cubee
--[[
since token limits aren't a concern,
 and picotron does some things differently,
 this version does the following:
- data is a raw table instead of a formatted string
- additionally takes in a spritesheet userdata
- doesn't write to map for rotated sprites

sample frame:
-- index, x, y, rotation, part scale, <part name>
local frame = {
	{0, 0, -32, 0, 1, "part1"},
	{1, 8, -24, -0.125, 1.5, "part2"},
}
--]]

Multispr = {}

--uses sspr when ang == 0,
--otherwise uses rspr
function Multispr.drawFrame(sheet, frame, x, y, scale)
	scale = scale or 1
	
	for part in all(frame) do
		
		local i, sx, sy, r, s, bone = unpack(part)
		r, s = r or 0, s or 1
		if (frame.flip) sx, r= -sx, -r
		local sc, tx, ty = scale * s, flr(x + sx * scale), flr(y + sy * scale)

		-- draw
		local gfx = sheet[i].bmp
		if (not gfx) print("no gfx!", tx, ty) return
		local w, h = gfx:width(), gfx:height()
		if r == 0 and false then
			local tw, th = ceil(w * sc), ceil(h * sc)
			sspr(gfx, 0, 0, w, h, tx - tw * 0.5, ty - th * 0.5, tw, th, frame.flip)
		else
			--rspr(frame,tx,ty,r,0,0,w,h,flip,sc)
			rspr(gfx, tx, ty, sc, sc, r, frame.flip)
		end
		
		--pset(tx,ty,8)
	
	end
	--pset(x,y,7)
end

function Multispr.getPart(frame, part, flip)
	for i in all(frame) do
		local i, x, y, r, s, partName = unpack(i)
		if partName and partName == part then
			return {i, frame.flip and -x or x, y, r, s, partName}
		end
	end
	return {-1, 0, 0, 0, 0}
end
