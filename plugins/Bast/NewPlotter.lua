<!DOCTYPE script>
<script>
<![CDATA[

-- Globals
_DEBUG = true
current_mob = nil

	-- error messages for debug
Err = {
	good = "000: as expected",
	empty = "001: variable is empty",
	unkown = "002: unkown",
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
		Note(anyEmpty(table))
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

-- Catch broadcasts
function OnPluginBroadcast (msg, id, name, text)
	-- broadcast_cp
	if id == "aaa66f81c50828bbbfda7100" and msg == 1 then
		local pvar = GetPluginVariable( "aaa66f81c50828bbbfda7100", "mobs" )

		-- get the mobs
		loadstring( pvar )()
		setCurrentMob( "cp", mobs )
	end
end

-- assignCurrentMob
function setCurrentMob ( task, mobs )
	if not mobs or mobs == "" then debugNote( DebugReport:new( Err.empty, "setCurrentMob()", { mobs = nil } ) return end
	
	local tasks = {	}			
	local function tasks.cp ( mobs )
		for _,mob in ipairs(mobs) do
			if not mob.mobdead then
				current_mob = Mob:new(mob.name, mob.location)
				debugNote( DebugReport:new( Err.good, "setCurrentMob:tasks.cp", current_mob:getValues() )
				return
			end
		end
	end
			
	if setContains( tasks, task ) then tasks.task ( mobs ) end
		
	ColourNote("teal", "", "Target: ", "yellow", "", current_mob.name)
	ColourNote("teal", "", "Area: ", "yellow", "", current_mob.location)
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
		
		Note( dReport.vars.name, dReport.vars[location] )

		ColourNote(
				dColor, bColor, "debug: '",
				sColor, bColor, dReport.fnc,
				dColor, bColor, "' returned '",
				sColor, bColor, dReport.err,
				dColor, bColor, "' | arguments: ",
				sColor, bColor, implodeKeyValue( dReport.vars )
				--sColor, bColor, implodeKeyValue(dReport.vars)
		)
	end
end

function implodeKeyValue( table)
	local string = ""
	for k in pairs (table) do
		string = string .. k .. " '" .. table[k] .. "', "
	end
	return string
end

]]>
</script>