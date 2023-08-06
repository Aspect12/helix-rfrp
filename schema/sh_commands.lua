
do
	local COMMAND = {}
	COMMAND.description = "Transmit a message over the radio frequency that you are tuned into."
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true)
		local item

		for _, v in ipairs(radios) do
			if (!v:GetData("enabled", false)) then continue end
			
			item = v
			
			break
		end

		if (item) then
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "radio", message)
				ix.chat.Send(client, "radio_eavesdrop", message)
			else
				return "You cannot radio while restrained!"
			end
		elseif (#radios > 0) then
			return "Your radio is not on!"
		else
			return "You do not have a radio!"
		end
	end

	ix.command.Add("Radio", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.description = "Set the frequency of your radio."
	COMMAND.arguments = ix.type.number

	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("handheld_radio")

		if (!itemTable) then
			return "You do not have a radio!"
		end

		if (!string.find(frequency, "^%d%d%d%.%d$")) then
			return "That is not a valid frequency! Format: XXX.X"
		end

		character:SetData("frequency", frequency)
		itemTable:SetData("frequency", frequency)

		client:Notify(string.format("You have set your radio frequency to %s.", frequency))
	end

	ix.command.Add("SetFreq", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.description = "Use the PA System to broadcast to a message to all characters."
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (client:IsRestricted()) then
			return "You cannot use the PA system while restrained!"
		end

		ix.chat.Send(client, "broadcast", message)
	end

	ix.command.Add("Broadcast", COMMAND)
end
