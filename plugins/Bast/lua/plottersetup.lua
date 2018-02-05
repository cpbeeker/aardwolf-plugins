-- $Id: plottersetup.lua 8867 2017-11-01 01:08:07Z gloominati $
--[[
	Cool stuff
--]]

	-- error messages for debug
Err = {
	log = "000: here at",
	good = "001: as expected",
	empty = "002: variable is empty",
	unkown = "003: unkown",
}
	
-- debug compiler
-- string err, string fnc, key=>value vars
DebugReport = {
	err = "",
	fnc = "",
	vars = { },
}
	function DebugReport:new (err, fnc, vars)
		self.err = err
		self.fnc = fnc
		self.vars = vars
	return self
	end

-- table: Mob
-- str name, str clean, str location, bool dead
Mob = {
	selfName = "Mob",
	name = "name",
	location = "location",
	debugReport = {},
}
		-- name, clean, location, mobdead
		-- returns a debug
	function Mob:new ( n, l )
		local table = { name = n, location = l }
		if anyEmpty( table ) then
			debugNote( DebugReport:new( Err.empty, self.selfName .. ":new ()", table ) )
			return nil
		end

		self.name = table.name
		self.location = table.location
	
		debugNote( DebugReport:new( Err.good, self.selfName .. ":new ()", self:getValues() ) )
	
		return self
	end

	function Mob:setDefault ()
		self.name = "name"
		self.location = "location"
	end

	function Mob:getValues ()
		return { name = self.name, location = self.location }
	end
-- Mob

function report ( err, fnc, arg )
	debugNote( DebugReport:new( err, fnc, arg ) )
end

-- Catch broadcasts
function OnPluginBroadcast (msg, id, name, text)
	-- broadcast_cp
	if id == "aaa66f81c50828bbbfda7100" and msg == 1 then
		local pvar = GetPluginVariable( "aaa66f81c50828bbbfda7100", "mobs" )

		-- get the mobs
		loadstring( pvar )()
		setCurrentMob( "cp", mobs )
	end
	-- broadcast_quest
	if id == "aaa8a9eda20fa11787c6b438" and msg == 2 then
		local pvar = GetPluginVariable(  "aaa8a9eda20fa11787c6b438" , "quest_info")

		--get the mob info
		loadstring( pvar )()
		setCurrentMob ( "quest", quest_info )
	end
	-- broadcast_gq
    if id == "aaa77f81c5408278ccda7100" and msg == 3 then
      local pvar = GetPluginVariable(  "aaa77f81c5408278ccda7100", "mobs" )

      -- get the mobs
      loadstring( pvar )()
      setCurrentMob( "gq", mobs )
    end
end

SwitchTask = { }
	
	function SwitchTask.cp ( mobs )
		for _,mob in ipairs(mobs) do
			if not mob.mobdead then
				current_mob = Mob:new(mob.name, mob.location)
				report ( Err.good, "setCurrentMob:tasks.cp", current_mob:getValues() )
				return
			end
		end		
	end

	function SwitchTask.quest ( quest_info )
		current_mob = Mob:new( quest_info.mobname, quest_info.mobarea )
		report ( Err.good, "setCurrentMob:tasks.quest", current_mob:getValues() )
	end

	function SwitchTask.gq ( mobs )
		for _,mob in ipairs(mobs) do
			if not mob.mobdead then
				current_mob = Mob:new(mob.name, mob.location)
				report ( Err.good, "setCurrentMob:tasks.cp", current_mob:getValues() )
				return
			end
		end		
	end

-- assignCurrentMob
function setCurrentMob ( task, mobs )
	if not mobs or mobs == "" then report ( Err.empty, "setCurrentMob()", { mobs = "nil" } ) return end
	report ( Err.unkown, "setCurrentMob", { t = task } )
	SwitchTask[task] ( mobs )
		
	--ColourNote("teal", "", "Target: ", "yellow", "", current_mob.name)
	--ColourNote("teal", "", "Area: ", "yellow", "", current_mob.location)
end -- setCurrentMob()

-- utilities
function isEmpty (s)
	if not s or s == '' then return true end
end

function anyEmpty (t)
	for v in pairs(t) do 
		if isEmpty(t[v]) then return true end
	end
end

function debugNote (dReport)
	if _DEBUG then
		local dColor = "white"
		local sColor = "red"
		local bColor = ""
		
		local argString = implodeKeyValue ( dReport.vars )
		
		ColourNote(
				dColor, bColor, "debug: '",
				sColor, bColor, dReport.fnc,
				dColor, bColor, "' returned '",
				sColor, bColor, dReport.err,
				dColor, bColor, "' | arguments: ",
				sColor, bColor, argString
				--sColor, bColor, implodeKeyValue(dReport.vars)
		)
	end
end

function implodeKeyValue( table )
	local string = ""
	for k in pairs (table) do
		string = string .. k .. " '" .. table[k] .. "', "
	end
	return string
end

function cleanupMob()
	current_mob = nil
end -- cleanup()