local function loadout(ply)
	if gmod.GetGamemode().Name == "Sandbox" then
		ply:Give("weapon_shield_scanner")
		ply:Give("magic")
	end
end

aowl.AddCommand("rpg=boolean", function(ply, _, cheat)
	jrpg.SetRPG(ply,not ply:GetNWBool("rpg",false), cheat)
end)

aowl.AddCommand("level=string", function(ply, what)
	local res = jlevel.LevelAttribute(ply, what)
	if res == false then
		ply:ChatPrint("Valid attributes to upgrade:")
		for k,v in pairs(jattributes.types) do
			ply:ChatPrint(k)
		end
		return false,"no such stat"
	elseif res == nil then
		return false,"not enough attribute points"
	end

	ply:ChatPrint(ply:GetNWInt("jlevel_attribute_points", 0) .. " attribute points left")
end)

aowl.AddCommand("element", function(ply, _, ...)
	local elements = {...}

	local ok = true

	if not elements[1] then
		ok = false
	end

	for k,v in pairs(elements) do
		if not wepstats.registered[v] then
			ok = false
			break
		end
	end

	if elements[1] == "all" then
		elements = {}
		ok = true
		for k,v in pairs(wepstats.registered) do
			if v.Elemental then
				table.insert(elements, v.ClassName)
			end
		end
	end

	if ok then
		wepstats.AddToWeapon(ply:GetActiveWeapon(),nil,nil,unpack(elements))
	else
		ply:ChatPrint("valid:")
		for k,v in pairs(wepstats.registered) do
			local name = v.ClassName
			if v.Elemental then
				name = name .. " (elemental)"
			end
			ply:ChatPrint(name)
		end
	end
end)

hook.Add("PlayerSpawn", "rpg_loadout", function(ply)
	if not ply:GetNWBool("rpg") then return end
	timer.Simple(0.1, function()
		loadout(ply)
	end)
end)
