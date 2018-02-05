-- $Id: plottermoves.lua 8865 2017-11-01 01:08:07Z gloominati $
--[[
	Cool stuff
--]]

function getRoom(sName, sLine, wildcards)
	sendDebug("In getRoom()")
	EnableTrigger("trig_getRoom", false)
	Execute("mapper area " .. wildcards.room)
end --function

function whereCP()
	Send("where " .. GetVariable("cp_target"))
end --function

function cppCommand(sName, sLine, wildcards)
	sendDebug("cppCommand() wildcards: " .. wildcards.command)
	local command = wildcards.command
	local arg = wildcards.arg
	
	local action = {
		--["rt"] = function (x) EnableTrigger("rtFail", true) Send("rt " .. current_mob.location) end,
		["w"] = function (x) Execute("where " .. cleanMobName(current_mob.name)) end,
		["run"] = function (x) Execute("mapper next") end,
		["kill"] = function (x) Execute("initiate_attack " .. cleanMobName(current_mob.name)) end,
		["debug"] = function (x) _DEBUG = (_DEBUG and false or true) end,
	}
	
	function action.rt()
		EnableTrigger("rtFail", true)
		Send("rt " .. current_mob.location)
	end --action.rt()
	
	if setContains(action, command) == true then
		action[wildcards.command]()
	end --if
end -- cppRT

function whereOverload(sName, sLine, wildcards)
	SetVariable("where_target", wildcards.mob)
	EnableTrigger("trig_getRoom", true)
	Send("where " .. wildcards.mob)
end -- whereOverLoad()

function whereFail()
	EnableTrigger("trig_getRoom", false)
end -- whereFail()

function rtFail()
	sendDebug("In rtFail()")
	EnableTrigger("rtFail", false)
	Execute("mapper find " .. current_mob.location)
end -- rtFail()

function cleanupMob()
	current_mob = nil
end -- cleanup()