--[[pod_format="raw",created="2025-04-13 15:59:04",modified="2025-04-17 17:37:05",revision=4734]]
-- motion helpers
-- cubee
-- ref:
-- https://easings.net/

function elasticFollow(_env, xt, yt)
	x += (xt - x) / 10
	y += (yt - y) / 10
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