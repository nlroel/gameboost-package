-- Copyright 2020 Tiou <dourokinga@gmail.com>
-- Licensed to the public under the MIT License.

local fs   = require "nixio.fs"
local sys  = require "luci.sys"
local uci  = require "luci.model.uci".cursor()
local util = require "luci.util"
local i18n = require "luci.i18n"

module("luci.model.tinyportmapper", package.seeall)

function is_running(client)
   if client and client ~= "" then
      local file_name = client:match(".*/([^/]+)$") or ""
      if file_name ~= "" then
         return sys.call("pidof %s >/dev/null" % file_name) == 0
      end
   end
   return false
end

function get_version(name)
   local info = luci.util.split(luci.sys.exec("%s -h 2>/dev/null" %{name}), "\n")
   if table.getn(info) > 3 then
      local version = string.match(info[3], "git version:%s*(%w+)")
      local build = string.match(info[3], "build date:(.+)")
      return info[2] == "tinyPortMapper" and version or "", info[2] == "tinyPortMapper" and build or ""
   else
      return "",""
   end
end

function get_config_option(option, default)
	return uci:get("tinyportmapper", "general", option) or default
end
