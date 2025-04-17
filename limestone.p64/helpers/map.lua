--[[pod_format="raw",created="2025-04-13 16:51:05",modified="2025-04-17 02:36:37",revision=3564]]
-- map helpers
-- cubee

-- collision mget
function cmget(x, y)
	return levelCollision.bmp:get(x \ 8, y \ 8)
end
