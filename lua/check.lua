local headers=ngx.req.get_headers()
local current_remote_addr=headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"
local ip_decimal = 0
local postion = 3
for i in string.gmatch(current_remote_addr, [[%d+]]) do
	ip_decimal = ip_decimal + math.pow(256, postion) * i
	postion = postion - 1
end
if ip_decimal >= 0x7f000000 and ip_decimal <= 0x7fffffff or
	ip_decimal >= 0x0a000000 and ip_decimal <= 0x0affffff or
	ip_decimal >= 0xac100000 and ip_decimal <= 0xac1fffff or
	ip_decimal >= 0xc0a80000 and ip_decimal <= 0xc0a8ffff then
	return
else
	local redis = require "resty.redis"
	local cache = redis.new()
	local ok, err = cache.connect(cache, "127.0.0.1", "6379")
	cache:set_timeout(60000)
	local res, err = cache:get(string.format("NGINXBLACK_%s", current_remote_addr))
	if ngx.null ~= res then
		local i = string.find(res, " ")
		local num = tonumber(string.sub(res, 1, i-1))
		local time = string.sub(res, i+1, string.len(res))
		local now = os.time()
		if now - time < 3600 then
			if num > 10 then
				ngx.default_type 'text/plain';
				ngx.print(string.format("Waiting %s seconds to unlock.", 3600 - (now - time)))
			else
				return
			end
		else
			cache:del(string.format("NGINXBLACK_%s", current_remote_addr))
		end
	else
		return
	end
end
