-- The first line is required for Lua to correctly identify the module and create its scope.
module("luci.controller.tinyportmapper", package.seeall)


local model = require "luci.model.tinyportmapper"

--  The index-Function will be used to register actions in the dispatching tree.
function index()

   if not nixio.fs.access("/etc/config/tinyportmapper") then
       return
   end

   entry({"admin", "services", "tinyportmapper"},
      firstchild(),
      _("tinyPortMapper")).dependent = false

   entry({"admin", "services", "tinyportmapper", "settings"},
      cbi("tinyportmapper/settings"), _("Settings"), 1)

   entry({"admin", "services", "tinyportmapper", "servers"},
      arcombine(cbi("tinyportmapper/servers"),cbi("tinyportmapper/server-detail")), -- Create a combined dispatching target for non argv and argv requests.
      _("Server Manager"), 2).leaf = true

   entry({"admin", "services", "tinyportmapper", "status"}, call("action_status"))
end


function action_status()
   luci.http.prepare_content("application/json")
   luci.http.write_json({
         running = model.is_running(model.get_config_option("client_file","tinyvpn"))
   })
end
