local m, s, o
local sid = arg[1]

local raw_modes = {
	"faketcp",
	"udp",
	"icmp",
}

local cipher_modes = {
        "aes128cfb",
	"aes128cbc",
	"xor",
	"none",
}

local auth_modes = {
        "hmac_sha1",
	"md5",
	"crc32",
	"simple",
	"none",
}


local log_level = {
   "never",
   "fatal",
   "error",
   "warn",
   "info",
   "debug",
   "trace",
}

m = Map("udp2raw", "%s - %s" %{translate("udp2raw-tunnel"), translate("Edit Server")})
m.redirect = luci.dispatcher.build_url("admin/services/udp2raw/servers")
m.sid = sid

if m.uci:get("udp2raw", sid) ~= "servers" then
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

o = s:option(ListValue, "raw_mode", translate("Raw Mode"))
for _, v in ipairs(raw_modes) do o:value(v, v:lower()) end
o.default = "faketcp"
o.rmempty = false

o = s:option(Value, "key", translate("Password"))
o.password = true

o = s:option(ListValue, "cipher_mode", translate("Cipher Mode"))
for k, v in ipairs(cipher_modes) do o:value(v,v:lower()) end
o.default = "aes128cbc"

o = s:option(ListValue, "auth_mode", translate("Auth Mode"))
for _, v in ipairs(auth_modes) do o:value(v, v:lower()) end
o.default = "md5"

o = s:option(Flag, "auto_rule", translate("Auto Rule"), translate("Auto add (and delete) iptables rule."))
o.default = "1"

o = s:option(Flag, "keep_rule", translate("Keep Rule"), translate("Monitor iptables and auto re-add if necessary."))
o:depends("auto_rule", "1")

o = s:option(Flag, "fix_gro", translate("Fix GRO"), translate("Try to fix huge packet caused by GRO. this option is at an early stage."))
o.default = "0"

o = s:option(Flag, "disable_anti_replay", translate("Disable Anti-replay"), translate("disable anti-replay,not suggested."))
o.default = "0"


o = s:option(Value, "seq_mode", translate("seq Mode"), translate("seq increase mode for faketcp."))
o.datatype = "range(0,4)"
o.placeholder = "3"

o = s:option(Value, "lower_level", translate("Lower Level"), translate("Send packets at OSI level 2, format: \"eth0#00:11:22:33:44:55\", or \"auto\"."))

o = s:option(Value, "source_ip", translate("Source-IP"), translate("Force source-ip for Raw Socket."))
o.datatype = "ipaddr"

o = s:option(Value, "source_port", translate("Source-Port"), translate("Force source-port for Raw Socket, TCP/UDP only."))
o.datatype = "port"

o = s:option(Value, "dev", translate("dev"), translate("bind raw socket to a device, not necessary but improves performance. ex:\"eth0\""))
o = s:option(Value, "sock_buf", translate("Sock Buf"), translate("buf size for socket,>=10 and <=10240,unit:kbyte,default:1024"))
o.datatype = "range(10,10240)"
o.placeholder = "1024"

o = s:option(Flag, "force_sock_buf", translate("Force Sock Buf"), translate("bypass system limitation while setting sock-buf"))
o.default = "0"

o = s:option(ListValue, "log_level", translate("Log Level"))
for k, v in ipairs(log_level) do o:value(k-1, "%s:%s" %{k-1, v:lower()}) end
o.default = "4"

return m
