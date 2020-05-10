local headers = ngx.req.get_headers()
local token = headers["token"]
if token != "123456" then
	ngx.print("Token error")
	return
end
local redis = require "resty.redis"
local cache = redis.new()
local ok,err = cache.connect(cache, "127.0.0.1", "6379")
cache:set_timeout(60000)
if not ok then
	return path
end
local request_uri = ngx.var.request_uri
ipns, ipfs = string.match(request_uri, "/set/(%w+)/(%w+)$")
local res, err = cache:set(string.format("IPNSCACHE_%s",ipns), ipfs)
ngx.print(res)
