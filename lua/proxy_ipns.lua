local request_uri = ngx.var.request_uri
local path = string.sub(request_uri, 7)
local f = string.find(path, "/")
if not f then
	ipns = path
else
	ipns = string.sub(path,0,f-1)
end
local redis = require "resty.redis"
local cache = redis.new()
local ok, err = cache.connect(cache, "127.0.0.1", "6379")
cache:set_timeout(60000)
if not ok then
	ngx.var.path = "ipns/"..path
	return
end
local res, err = cache:get(string.format("IPNSCACHE_%s",ipns))
if ngx.null ~= res then
	ngx.var.path = "ipfs/"..string.gsub(path, ipns, res)
else
	ngx.var.path = "ipns/"..path
end
