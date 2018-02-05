-- $Id: plotterutils.lua 8864 2017-11-01 01:08:07Z gloominati $
--[[
	Cool stuff
--]]

function OnHelp ()
  world.Note (world.GetPluginInfo (world.GetPluginID (), 3))
end

function cppList()
	for k, v in pairs (GetVariableList()) do 
		Note (k, " = ", v) 
	end --for

	tl = GetTriggerList()
	if tl then
	  for k, v in ipairs (tl) do 
		Note (GetTriggerInfo(v, 1)) 
	  end  -- for
	end -- if we have any triggers
	
	--ColourNote("blue","black","cpPlotter:","red","black"," Heal Potion      = ","darkred","black",GetVariable("healpot"))
end --function   

function cleanMobName(raw_name)
	if raw_name ~= nil then
		local badCharacters = {",%s", "-%s*"}
		local badPronouns = {"^The%s", "^the%s", "^A%s", "^a%s", "^the%s", "%sof%s", "%sthe%s", "^an%s", "^An%s"}
		local trim = {"^%s"}
		local text = raw_name

		for _,delim in ipairs(badCharacters) do
			text = string.gsub(text, delim, " ")
			report ( Err.log, "cleanMobName:badCharacters", { delim = delim, raw_name = raw_name, text = text } )
		end --for

		for _,delim in ipairs(badPronouns) do
			text = string.gsub(text, delim, " ")
			report ( Err.log, "cleanMobName:badPronouns", { delim = delim, raw_name = raw_name, text = text } )
		end --for

		for _,delim in ipairs(trim) do
			text = string.gsub(text, delim, "")
			report ( Err.log, "cleanMobName:trim", { delim = delim, raw_name = raw_name, text = text } )
		end --for
		return text
	end --if
end -- CleanMobName

function setContains(set, key)
    return set[key] ~= nil
end -- setContains(set, key)

-- implode(separator, table)
function implode(d,p)
  local newstr
  newstr = ""
  if(#p == 1) then
    return p[1]
  end
  for ii = 1, (#p-1) do
    newstr = newstr .. p[ii] .. d
  end
  newstr = newstr .. p[#p]
  return newstr
end