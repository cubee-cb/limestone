--[[pod_format="raw",created="2025-04-13 16:51:05",modified="2025-04-15 17:34:54",revision=2375]]
-- map helpers
-- cubee

-- collision mget
function cmget(x, y)
	return levelCollision.bmp:get(x \ 8, y \ 8)
end
