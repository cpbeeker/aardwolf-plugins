-- $Id: plottermoves.lua 8865 2017-11-01 01:08:07Z gloominati $
--[[
	Cool stuff
--]]

function getRoom(sName, sLine, wildcards)
	report ( Err.log, "getRoom ()", wildcards )
	EnableTrigger("trig_getRoom", false)
	Execute("mapper area " .. wildcards.room)
end --function

function whereCP()
	Send("where " .. GetVariable("cp_target"))
end --function

function cppCommand(sName, sLine, wildcards)
	report ( Err.log, "cppCommand()", wildcards )
	local command = wildcards.command
	local arg = wildcards.arg
	
	local action = {
		--["rt"] = function (x) EnableTrigger("rtFail", true) Send("rt " .. current_mob.location) end,
		["w"] = function (x) Execute("where " .. cleanMobName( current_mob and current_mob.name or "no name" ) ) end,
		["run"] = function (x) Execute("mapper next") end,
		["kill"] = function (x) Execute("initiate_attack " .. cleanMobName(current_mob.name)) end,
		["debug"] = function (x) _DEBUG = not _DEBUG and true or false end,
		["list"] = function (x) Note ( "_DEBUG = " .. tostring(_DEBUG), " | current_mob = " .. (current_mob and implodeKeyValue( current_mob:getValues() ) or "nil")) end,
		["gmcpInfo"] = function (x) Note( GetPluginInfo( "3e7dedbe37e44942dd46d264", 6 ) ) end,
		["gmcpRoom"] = function (x) Note( CallPlugin("3e7dedbe37e44942dd46d264","gmcpval","room.info") )end,
		["set"] = function (x) current_mob = { name = x, location = "nowhere" } tprint(current_mob) end
	}
	
	function action.mval ( arg )
	  Note( GetPluginVariableList("b6eae87ccedd84f510b74714").arg )
	end
	function action.wval ( arg )
	  Note( GetPluginVariableList( "" ).arg )
	end
	
	function action.rt()
		EnableTrigger("rtFail", true)
		local name_zone = table.concat({ current_mob.name, current_mob.location }, "~" )
		Note("name_zone: " .. name_zone)
		local response, room_number  = CallPlugin( "d8031569892141fe0ca6a683","outsideGetMob", name_zone )
		
		if room_number == nil or room_number == "" then
			Send( "rt " .. current_mob.location )
		else
			Execute( "mapper goto " .. room_number )
		end
	end --action.rt()
	
	if setContains(action, command) == true then
		action[wildcards.command](wildcards[2])
	end --if
end -- cppRT

function toLower(str)
  return string.lower(str)
end

function whereOverload(sName, sLine, wildcards)
	SetVariable("where_target", wildcards.mob)
	EnableTrigger("trig_getRoom", true)
	Send("where " .. wildcards.mob)
end -- whereOverLoad()

function whereFail()
	EnableTrigger("trig_getRoom", false)
end -- whereFail()

function rtFail()
	report ( Err.log, "rtFail ()", nil )
	EnableTrigger("rtFail", false)
	Execute("mapper find " .. current_mob.location)
end -- rtFail()