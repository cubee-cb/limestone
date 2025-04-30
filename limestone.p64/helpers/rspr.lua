--[[pod_format="raw",created="2025-04-17 04:00:46",modified="2025-04-30 23:39:06",revision=3858]]
-- rspr.lua
-- fletch_pico
-- https://www.lexaloffle.com/bbs/?tid=141706
--[[
edits by cubee:
- make rspr use texture directly
- don't clip tquad to screen height
- add horizontal and vertical texture flipping
]]

function rspr(tex,cx,cy,sx,sy,rot,hflip,vflip)
	sx = sx and sx or 1
	sy = sy and sy or 1
	rot = rot and rot or 0
	local dx,dy = tex:width()*sx,tex:height()*sy
	local u0, v0, u1, v1 =
		(hflip and (tex:width()-0.001) or 0), (vflip and (tex:height()-0.001) or 0),
		(hflip and 0 or (tex:width()-0.001)), (vflip and 0 or (tex:height()-0.001))
	local quad = {
		{x=0, y=0, u=u0, v=v0},
		{x=dx, y=0, u=u1, v=v0},
		{x=dx, y=dy, u=u1, v=v1},
		{x=0, y=dy, u=u0, v=v1},
	}
	local c,s = cos(rot),-sin(rot)
	local w,h = (dx-1)/2, (dy-1)/2
	for _,v in pairs(quad) do
		local x,y = v.x-w,v.y-h
		v.x = c*x-s*y
		v.y = s*x+c*y	
	end
	tquad(quad, tex, cx, cy, hflip)
end

function tquad(coords,tex,dx,dy)
	local screen_max = get_display():height()-1
	local p0,spans = coords[#coords],{}
	local x0,y0,u0,v0=p0.x+dx,p0.y+dy,p0.u,p0.v
	for i=1,#coords do
		local p1 = coords[i]
		local x1,y1,u1,v1=p1.x+dx,p1.y+dy,p1.u,p1.v
		local _x1,_y1,_u1,_v1=x1,y1,u1,v1
		if(y0>y1) x0,y0,x1,y1,u0,v0,u1,v1=x1,y1,x0,y0,u1,v1,u0,v0
		local dy=y1-y0
		local dx,du,dv=(x1-x0)/dy,(u1-u0)/dy,(v1-v0)/dy
		if(y0<0) x0-=y0*dx u0-=y0*du v0-=y0*dv y0=0
		local cy0=ceil(y0)
		local sy=cy0-y0
		x0+=sy*dx
		u0+=sy*du
		v0+=sy*dv
		for y=cy0,ceil(y1)-1 do
			local span=spans[y]
			if span then tline3d(tex,span.x,y,x0,y,span.u,span.v,u0,v0)
			else spans[y]={x=x0,u=u0,v=v0} end
			x0+=dx
			u0+=du
			v0+=dv
		end
		x0,y0,u0,v0=_x1,_y1,_u1,_v1
	end
end