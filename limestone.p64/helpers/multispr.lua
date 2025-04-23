--[[pod_format="raw",created="2025-04-23 03:06:27",modified="2025-04-23 04:01:27",revision=221]]
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
-- index, x, y, rotation, part scale
local frame = {
	{0, 0, -32, 0, 1},
	{1, 8, -24, -0.125, 1.5},
}
--]]

--uses sspr when ang == 0,
--otherwise uses rspr
function multispr(sheet, frame, x, y, flip, scale)
	scale = scale or 1
	
	for part in all(frame) do
		
		local i, sx, sy, r, s, bone = unpack(part)
		r, s = r or 0, s or 1
		if (flip) sx, r= -sx, -r
		local sc, tx, ty = scale * s, flr(x + sx * scale), flr(y + sy * scale)

		-- draw
		local frame = sheet[i].bmp
		if (not frame) print("no gfx!", tx, ty) return
		local w, h = frame:width(), frame:height()
		if r == 0 then
			local tw, th = ceil(w * sc), ceil(h * sc)
			sspr(frame, 0, 0, w, h, tx - tw * 0.5, ty - th * 0.5, tw, th, flip)
		else
			--rspr(frame,tx,ty,r,0,0,w,h,flip,sc)
			rspr(frame, tx, ty, sc, sc, r)
		end
		
		--pset(tx,ty,8)
	
	end
	--pset(x,y,7)
end
