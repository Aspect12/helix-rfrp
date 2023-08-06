
ITEM.name = "Bandage"
ITEM.model = "models/props_wasteland/prison_toiletchunk01f.mdl"
ITEM.description = "A small roll of hand-made gauze."
ITEM.category = "Medical"

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, 100))
	end
}
