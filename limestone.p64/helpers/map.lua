--[[pod_format="raw",created="2025-04-13 16:51:05",modified="2025-04-18 16:22:43",revision=5796]]
-- map helpers
-- cubee

-- collision mget
function cmget(x, y)
	return levelCollision.bmp:get(x \ 8, y \ 8)
end

function pfget(i, f)
	return not fget(i, 7) and fget(i, f)
end
