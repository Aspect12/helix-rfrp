
function Schema:PostPlayerLoadout(client)
	if (client:Team() != FACTION_GUARD) then return end
	
	client:SetArmor(75)
end

local vcClasses = {
	["ic"] = true,
	["w"] = true,
	["y"] = true,
	["broadcast"] = true
}

function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if (!vcClasses[chatType]) then return end

	local class = self.voices.GetClass(speaker)

	for _, v in ipairs(class) do
		local info = self.voices.Get(v, rawText)
		if (!info) then continue end

		local volume = 80

		if (chatType == "w") then
			volume = 60
		elseif (chatType == "y") then
			volume = 150
		end

		if (info.sound) then
			if (info.global) then
				net.Start("ixREDPlaySound")
					net.WriteString(info.sound)
				net.Broadcast()
			else
				local sounds = {info.sound}

				ix.util.EmitQueuedSounds(speaker, sounds, nil, nil, volume)
			end
		end

		return info.text
	end
end

function Schema:CanAutoFormatMessage(client, chatType, message)
	if (chatType == "broadcast") then
		return true
	end
end

function Schema:GetPlayerPainSound(client)
	if (client:Team() == FACTION_MINER) then
		return "redfactionrp/painsounds/miner_pain0" .. math.random(1, 9) .. ".wav"
	elseif (client:Team() == FACTION_GUARD) then
		if (self:IsRank(client, "CmD")) then
			return "redfactionrp/painsounds/commander_pain0" .. math.random(1, 5) .. ".wav"
		else
			return "redfactionrp/painsounds/guard_pain0" .. math.random(1, 5) .. ".wav"
		end
	end
end

function Schema:GetPlayerDeathSound(client)
	if (client:Team() == FACTION_MINER) then
		return "redfactionrp/deathsounds/miner_death0" .. math.random(1, 9) .. ".wav"
	elseif (client:Team() == FACTION_GUARD) then
		if (self:IsRank(client, "CmD")) then
			return "redfactionrp/deathsounds/commander_death0" .. math.random(1, 5) .. ".wav"
		else
			return "redfactionrp/deathsounds/guard_death0" .. math.random(1, 5) .. ".wav"
		end
	end
end

function Schema:PlayerHurt(client, attacker, health, damage)
	if (health <= 0) then return end

	net.Start("ixREDDamageEffect")
	net.Send(client)
end
