local dsp = require "luci.dispatcher"
local m, s, o

local sid = arg[1]


local log_level = {
   "never",
   "fatal",
   "error",
   "warn",
   "info",
   "debug",
   "trace",
}

m = Map("tinyportmapper", "%s - %s" %{translate("tinyportmapper"), translate("Edit Server")})
m.redirect = luci.dispatcher.build_url("admin/services/tinyportmapper/servers")
m.sid = sid

if m.uci:get("tinyportmapper", sid) ~= "servers" then
	luci.http.redirect(m.redirect)
	return
end

s = m:section(NamedSection, sid, "servers")
s.anonymous = true
s.addremove = false

o = s:option(Value, "alias", translate("Alias(optional)"))

o = s:option(Value, "server_addr", translate("Server"))
o.datatype = "host"
o.rmempty = false

o = s:option(Value, "server_port", translate("Server Port"))
o.datatype = "port"
o.placeholder = "8080"

o = s:option(Value, "listen_addr", translate("Local Listen Host"))
o.datatype = "ipaddr"
o.placeholder = "127.0.0.1"
o = s:option(Value, "listen_port", translate("Local Listen Port"))
o.datatype = "port"
o.placeholder = "2080"

o = s:option(Flag, "tcp", "TCP", translate("enable TCP forwarding/mapping."))
o.default = "1"

o = s:option(Flag, "udp", "UDP", translate("enable UDP forwarding/mapping."))
o.default = "1"

o = s:option(Value, "sock_buf", translate("Sock Buf"), translate("buf size for socket,>=10 and <=10240,unit:kbyte,default:1024"))
o.datatype = "range(10,10240)"
o.placeholder = "1024"

o = s:option(ListValue, "log_level", translate("Log Level"))
for k, v in ipairs(log_level) do o:value(k-1, "%s:%s" %{k-1, v:lower()}) end
o.default = "4"

return m
