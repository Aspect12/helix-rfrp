
FACTION.name = "Ultor Guard"
FACTION.description = "A guard tasked with securing the Ultor Corporation's mining complex on Mars."
FACTION.color = Color(100, 115, 190)
FACTION.models = {
	"models/josephfra/npc/hev_blue.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	character:SetName("RcT. " .. character:GetName())

	inventory:Add("control_baton", 1)
	inventory:Add("pistol", 1)
	inventory:Add("pistol_ammo", 2)
end

FACTION_GUARD = FACTION.index
