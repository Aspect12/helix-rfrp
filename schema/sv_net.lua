
util.AddNetworkString("ixREDCreateCharacter")
util.AddNetworkString("ixCharacterAuthedRED")
util.AddNetworkString("ixREDCharCreationFailed")
util.AddNetworkString("ixREDFrequency")
util.AddNetworkString("ixREDPlaySound")
util.AddNetworkString("ixREDDamageEffect")

-- I couldn't be arsed figuring out how the normal character creation goes lol
-- In hindsight I realized that it would've been easier to just make it work with the payload system, but, whatever.
net.Receive("ixREDCreateCharacter", function(_, client)
	local name = net.ReadString()
	local description = net.ReadString()
	local faction = net.ReadUInt(3)
	local strength = net.ReadUInt(4)
	local stamina = net.ReadUInt(4)
	local endurance = net.ReadUInt(4)
	local dexterity = net.ReadUInt(4)

	if (!name or name == "") then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("That is not a valid Character Name!")
		net.Send(client)

		return
	end

	name = tostring(name):gsub("\r\n", ""):gsub("\n", "")
	name = string.Trim(name)

	local minLength = ix.config.Get("minNameLength", 4)
	local maxLength = ix.config.Get("maxNameLength", 32)

	if (name:utf8len() < minLength) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("nameMinLen")
			net.WriteString(tostring(minLength))
		net.Send(client)

		return
	elseif (!name:find("%S")) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("That is not a valid Character Name!")
		net.Send(client)

		return
	elseif (name:gsub("%s", ""):utf8len() > maxLength) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("nameMaxLen")
			net.WriteString(tostring(maxLength))
		net.Send(client)

		return
	end

	name = hook.Run("GetDefaultCharacterName", client, faction) or name:utf8sub(1, 70)

	description = string.Trim(tostring(description)):gsub("\r\n", ""):gsub("\n", "")
	minLength = ix.config.Get("minDescriptionLength", 16)

	if (description:utf8len() < minLength) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("descMinLen")
			net.WriteString(tostring(minLength))
		net.Send(client)

		return
	elseif (!description:find("%s+") or !description:find("%S")) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("That is not a valid Character Description!")
		net.Send(client)

		return
	end

	if (!client:HasWhitelist(faction)) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("You are not whitelisted for this faction!")
		net.Send(client)

		return
	end

--[[ 	if (faction) then
		local models = faction:GetModels(client)

		if (!models[model]) then
			Derma_Query(L("needModel"), "ERROR", "OK")

			return
		end
	end ]]

	if (strength + stamina + endurance + dexterity > (hook.Run("GetDefaultAttributePoints", client) or 10)) then
		net.Start("ixREDCharCreationFailed")
			net.WriteString("You have exceeded the maximum amount of attribute points!")
		net.Send(client)

		return
	end

	local characterInfo = {
		name = name,
		description = description,
		faction = ix.faction.indices[faction].uniqueID,
		model = table.Random(ix.faction.indices[faction].models or CITIZEN_MODELS),
		steamID = client:SteamID64(),
		attributes = {
			str = strength,
			stm = stamina,
			["end"] = endurance,
			dex = dexterity
		}
	}
	
	ix.char.Create(characterInfo, function(id)
		if (IsValid(!client)) then return end

		ix.char.loaded[id]:Sync(client)

		net.Start("ixCharacterAuthedRED")
			net.WriteUInt(#client.ixCharList, 6)
			
			for _, v in ipairs(client.ixCharList) do
				net.WriteUInt(v, 32)
			end
		net.Send(client)

		MsgN("Created character '" .. id .. "' for " .. client:SteamName() .. ".")
		hook.Run("OnCharacterCreated", client, ix.char.loaded[id])
	end)
end)
