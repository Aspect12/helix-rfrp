
ITEM.name = "Zip Tie"
ITEM.description = "An orange zip-tie used to restrict people."
ITEM.model = "models/items/crossbowrounds.mdl"
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (!IsValid(target) or !target:IsPlayer() or !target:GetCharacter() or target:GetNetVar("tying") or target:IsRestricted()) then
			itemTable.player:Notify("You are not looking at a valid player!")

			return false
		end

		itemTable.bBeingUsed = true

		client:SetAction("Tying...", 5)

		client:DoStaredAction(target, function()
			target:SetRestricted(true)
			target:SetNetVar("tying")
			target:NotifyLocalized("You have been tied up.")

			itemTable:Remove()
		end, 5, function()
			client:SetAction()

			target:SetAction()
			target:SetNetVar("tying")

			itemTable.bBeingUsed = false
		end)

		target:SetNetVar("tying", true)
		target:SetAction("You are being tied up.", 5)

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end
