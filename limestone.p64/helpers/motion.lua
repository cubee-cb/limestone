--[[pod_format="raw",created="2025-04-13 15:59:04",modified="2025-04-20 12:14:37",revision=7495]]
-- motion helpers
-- cubee
-- ref:
-- https://easings.net/

function elasticFollow(_env, xt, yt)
	x += (xt - x) / 10
	y += (yt - y) / 10
end

function angleToVelocity(a)
	return sin(a), cos(a)
end

function deltaToAngle(xv, yv)
	return -0.25-atan2(xv, yv)
end

function posToAngle(x1, y1, x2, y2)
	return -0.25-atan2(x2 - x1, y2 - y1)
end

function normalise(xv, yv, v)
	local a = -0.25-atan2(xv, yv)
	return sin(a) * (v or 1), cos(a) * (v or 1)
end

function lerpExpo(t)
	return t == 0 and 0 or 2 ^ (10 * t - 10);
end

function easeInOut(t)
	return t < 0.5 and 16 * (t ^ 5) or 1 - ((-2 * t + 2) ^ 5) / 2;
end

function easeBack(t)
	local c1 = 1.70158;
	local c3 = c1 + 1;

	return c3 * (t ^ 3) - c1 * (t ^ 2);
end