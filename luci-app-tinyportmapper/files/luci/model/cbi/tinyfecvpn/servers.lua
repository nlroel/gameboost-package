local dsp = require "luci.dispatcher"
local http = require "luci.http"

local m, s, o

m = Map("tinyportmapper", "%s - %s" %{translate("tinyportmapper"), translate("Servers Manage")})

s = m:section(TypedSection, "servers")
s.anonymous = true
s.addremove = true
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = luci.dispatcher.build_url("admin/services/tinyportmapper/servers/%s")
function s.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(s.extedit % sid)
		return
	end
end

o = s:option(DummyValue, "alias", translate("Alias"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end

o = s:option(DummyValue, "_server_address", translate("Server Address"))
function o.cfgvalue(self, section)
	local server_addr = m.uci:get("tinyportmapper", section, "server_addr") or "?"
	local server_port = m.uci:get("tinyportmapper", section, "server_port") or "8080"
	return "%s:%s" %{server_addr, server_port}
end

o = s:option(DummyValue, "_listen_address", translate("Listen Address"))
function o.cfgvalue(self, section)
	local listen_addr = m.uci:get("tinyportmapper", section, "listen_addr") or "127.0.0.1"
	local listen_port = m.uci:get("tinyportmapper", section, "listen_port") or "2080"
	return "%s:%s" %{listen_addr, listen_port}
end

o = s:option(DummyValue, "tcp", "TCP")
function o.cfgvalue(...)
	local v = Value.cfgvalue(...)
	return v
end

o = s:option(DummyValue, "udp", "UDP")
function o.cfgvalue(...)
	local v = Value.cfgvalue(...)
	return v
end

return m
