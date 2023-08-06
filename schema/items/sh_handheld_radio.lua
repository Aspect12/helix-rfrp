
ITEM.name = "Handheld Radio"
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"
ITEM.description = "A small handheld radio with a frequency tuner.\nIt is currently turned %s%s."

-- Inventory drawing
function ITEM:PaintOver(item, w, h)
	if (!item:GetData("enabled")) then return end

	surface.SetDrawColor(110, 255, 110, 100)
	surface.DrawRect(w - 14, h - 14, 8, 8)
end

function ITEM:GetDescription()
	local enabled = self:GetData("enabled")

	return string.format(self.description, enabled and "on" or "off", enabled and (" and tuned to " .. self:GetData("frequency", "100.0")) or "")
end

function ITEM.postHooks.drop(item, status)
	item:SetData("enabled", false)
end

ITEM.functions.Frequency = {
	OnRun = function(itemTable)
		net.Start("ixREDFrequency")
			net.WriteString(itemTable:GetData("frequency", "000.0"))
		net.Send(itemTable.player)

		return false
	end
}

ITEM.functions.Toggle = {
	OnRun = function(itemTable)
		local character = itemTable.player:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true)
		local bCanToggle = true

		-- don't allow someone to turn on another radio when they have one on already
		if (#radios > 1) then
			for k, v in ipairs(radios) do
				if (v == itemTable or !v:GetData("enabled", false)) then continue end
				bCanToggle = false

				break
			end
		end

		if (bCanToggle) then
			itemTable:SetData("enabled", !itemTable:GetData("enabled", false))
			itemTable.player:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
		else
			itemTable.player:NotifyLocalized("You already have a radio that is turned on!")
		end

		return false
	end
}
