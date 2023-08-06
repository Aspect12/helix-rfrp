
local buttonMatSelectedBackground = Material("materials/redfactionrp/button_selected_background.png") -- 129 x 46
local buttonMatSelectedGlow = Material("materials/redfactionrp/button_selected_glow.png", "smooth") -- 13 x 28
local newMenuMat = Material("materials/redfactionrp/newcharacter_panel.png") -- 436 x 366
local arrowButtonMat, arrowButtonMatSelected = Material("materials/redfactionrp/arrow.png", "smooth"), Material("materials/redfactionrp/arrow_selected.png", "smooth") -- 19 x 26

local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	local newPanelHeight = scrH - scrH / (8.5 / 2)
	local newPanelWidth = (575 / 366) * newPanelHeight -- Stretching it a bit because this was made in 2001

	self:SetSize(newPanelWidth, newPanelHeight)
	self:SetPos(scrW, scrH / 8.5)

	local client = LocalPlayer()

	self.name = self:Add("DPanel")
	self.name:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.02)
	self.name:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.106)
	self.name.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.063, height * 0.28, width * 0.542, height * 0.625)

		if (panel:IsHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.18, 45 * scale, 70 * scale)
		end
	end
	self.name.OnCursorEntered = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end

	local nameWidth, nameHeight = self.name:GetSize()

	self.name.entry = self.name:Add("DTextEntry")
	self.name.entry:SetPos(nameWidth * 0.07, nameHeight * 0.28)
	self.name.entry:SetSize(nameWidth * 0.53, nameHeight * 0.625)
	self.name.entry:SetPaintBackground(false)
	self.name.entry:SetFont("ixRedFactionMedium")
	self.name.entry:SetTextColor(color_white)

	self.description = self:Add("DPanel")
	self.description:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.125)
	self.description:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.088)
	self.description.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.072, height * 0.235, width * 0.523, height * 0.525)

		if (panel:IsHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.04, 45 * scale, 70 * scale)
		end
	end
	self.description.OnCursorEntered = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end

	local descriptionWidth, descriptionHeight = self.description:GetSize()

	self.description.entry = self.description:Add("DTextEntry")
	self.description.entry:SetPos(descriptionWidth * 0.08, descriptionHeight * 0.235)
	self.description.entry:SetSize(descriptionWidth * 0.509, descriptionHeight * 0.525)
	self.description.entry:SetPaintBackground(false)
	self.description.entry:SetFont("ixRedFactionRegular")
	self.description.entry:SetTextColor(color_white)

	self.faction = self:Add("DPanel")
	self.faction:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.213)
	self.faction:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.088)
	self.faction.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.133, height * 0.235, width * 0.402, height * 0.53)

		if (panel:IsHovered() or panel:IsChildHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.04, 45 * scale, 70 * scale)
		end

		draw.SimpleText(panel.text or "", "ixRedFactionRegular", width * 0.133 + width * 0.402 / 2, height * 0.26, color_white, TEXT_ALIGN_CENTER)
	end
	self.faction.OnCursorEntered = function(panel)
		if (panel.hovered) then return end
		panel.hovered = true

		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.faction.OnCursorExited = function(panel)
		if (panel:IsChildHovered()) then return end

		panel.hovered = false
	end

	local factionWidth, factionHeight = self.faction:GetSize()

	self.faction.buttonLeft = self.faction:Add("DButton")
	self.faction.buttonLeft:SetPos(factionWidth * 0.064, factionHeight * 0.15)
	self.faction.buttonLeft:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.faction.buttonLeft:SetText("")
	self.faction.buttonLeft.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 180)
	end
	self.faction.buttonLeft.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		local factions = ix.faction.indices

		if (self.faction.currSelection == 1) then
			self.faction.currSelection = #factions
		else
			self.faction.currSelection = self.faction.currSelection - 1
		end

		self.faction.text = factions[self.faction.currSelection].name
		self.faction.faction = factions[self.faction.currSelection].uniqueID
	end

	self.faction.buttonRight = self.faction:Add("DButton")
	self.faction.buttonRight:SetPos(factionWidth * 0.555, factionHeight * 0.15)
	self.faction.buttonRight:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.faction.buttonRight:SetText("")
	self.faction.buttonRight.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 0)
	end
	self.faction.buttonRight.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		local factions = ix.faction.indices

		if (self.faction.currSelection == #factions) then
			self.faction.currSelection = 1
		else
			self.faction.currSelection = self.faction.currSelection + 1
		end

		self.faction.text = factions[self.faction.currSelection].name
		self.faction.faction = factions[self.faction.currSelection].uniqueID
	end

	self.model = self:Add("DPanel")
	self.model:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.3)
	self.model:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.167)
	self.model.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.072, height * 0.14, width * 0.522, height * 0.74)

		if (panel:IsHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.27, 45 * scale, 70 * scale)
		end
	end
	self.model.OnCursorEntered = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end

	self.attributeCounter = self:Add("DPanel")
	self.attributeCounter:SetPos(newPanelWidth * 0.525, newPanelHeight * 0.477)
	self.attributeCounter:SetSize(newPanelWidth * 0.034, newPanelHeight * 0.047)
	self.attributeCounter.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(0, 0, width, height)

		draw.SimpleText(panel.text or "0", "ixRedFactionRegular", width / 2, height / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local maxAttributes = hook.Run("GetDefaultAttributePoints", client) or 10
	self.attributeCounter.text = maxAttributes

	self.attribute1 = self:Add("DPanel")
	self.attribute1:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.536)
	self.attribute1:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.088)
	self.attribute1.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.133, height * 0.235, width * 0.402, height * 0.53)

		if (panel:IsHovered() or panel:IsChildHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.04, 45 * scale, 70 * scale)
		end

		draw.SimpleText(panel.text or "", "ixRedFactionRegular", width * 0.133 + width * 0.402 / 2, height * 0.26, color_white, TEXT_ALIGN_CENTER)
	end
	self.attribute1.OnCursorEntered = function(panel)
		if (panel.hovered) then return end
		panel.hovered = true

		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.attribute1.OnCursorExited = function(panel)
		if (panel:IsChildHovered()) then return end

		panel.hovered = false
	end

	self.attribute1.buttonLeft = self.attribute1:Add("DButton")
	self.attribute1.buttonLeft:SetPos(factionWidth * 0.064, factionHeight * 0.15)
	self.attribute1.buttonLeft:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute1.buttonLeft:SetText("")
	self.attribute1.buttonLeft.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 180)
	end
	self.attribute1.buttonLeft.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute1.text <= 0 or self.attributeCounter.text >= maxAttributes) then return end

		self.attribute1.text = self.attribute1.text - 1
		self.attributeCounter.text = self.attributeCounter.text + 1
	end

	self.attribute1.buttonRight = self.attribute1:Add("DButton")
	self.attribute1.buttonRight:SetPos(factionWidth * 0.555, factionHeight * 0.15)
	self.attribute1.buttonRight:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute1.buttonRight:SetText("")
	self.attribute1.buttonRight.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 0)
	end
	self.attribute1.buttonRight.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute1.text >= maxAttributes or self.attributeCounter.text <= 0) then return end

		self.attribute1.text = self.attribute1.text + 1
		self.attributeCounter.text = self.attributeCounter.text - 1
	end

	self.attribute1.text = 0

	self.attribute2 = self:Add("DPanel")
	self.attribute2:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.623)
	self.attribute2:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.088)
	self.attribute2.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.133, height * 0.235, width * 0.402, height * 0.53)	

		if (panel:IsHovered() or panel:IsChildHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.04, 45 * scale, 70 * scale)
		end

		draw.SimpleText(panel.text or "", "ixRedFactionRegular", width * 0.133 + width * 0.402 / 2, height * 0.26, color_white, TEXT_ALIGN_CENTER)
	end
	self.attribute2.OnCursorEntered = function(panel)
		if (panel.hovered) then return end
		panel.hovered = true

		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.attribute2.OnCursorExited = function(panel)
		if (panel:IsChildHovered()) then return end

		panel.hovered = false
	end

	self.attribute2.buttonLeft = self.attribute2:Add("DButton")
	self.attribute2.buttonLeft:SetPos(factionWidth * 0.064, factionHeight * 0.15)
	self.attribute2.buttonLeft:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute2.buttonLeft:SetText("")
	self.attribute2.buttonLeft.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 180)
	end
	self.attribute2.buttonLeft.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute2.text <= 0 or self.attributeCounter.text >= maxAttributes) then return end

		self.attribute2.text = self.attribute2.text - 1
		self.attributeCounter.text = self.attributeCounter.text + 1
	end

	self.attribute2.buttonRight = self.attribute2:Add("DButton")
	self.attribute2.buttonRight:SetPos(factionWidth * 0.555, factionHeight * 0.15)
	self.attribute2.buttonRight:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute2.buttonRight:SetText("")
	self.attribute2.buttonRight.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 0)
	end
	self.attribute2.buttonRight.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute2.text >= maxAttributes or self.attributeCounter.text <= 0) then return end

		self.attribute2.text = self.attribute2.text + 1
		self.attributeCounter.text = self.attributeCounter.text - 1
	end

	self.attribute2.text = 0

	self.attribute3 = self:Add("DPanel")
	self.attribute3:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.71)
	self.attribute3:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.088)
	self.attribute3.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.133, height * 0.235, width * 0.402, height * 0.53)

		if (panel:IsHovered() or panel:IsChildHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.04, 45 * scale, 70 * scale)
		end

		draw.SimpleText(panel.text or "", "ixRedFactionRegular", width * 0.133 + width * 0.402 / 2, height * 0.26, color_white, TEXT_ALIGN_CENTER)
	end
	self.attribute3.OnCursorEntered = function(panel)
		if (panel.hovered) then return end
		panel.hovered = true

		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.attribute3.OnCursorExited = function(panel)
		if (panel:IsChildHovered()) then return end

		panel.hovered = false
	end

	self.attribute3.buttonLeft = self.attribute3:Add("DButton")
	self.attribute3.buttonLeft:SetPos(factionWidth * 0.064, factionHeight * 0.15)
	self.attribute3.buttonLeft:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute3.buttonLeft:SetText("")
	self.attribute3.buttonLeft.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 180)
	end
	self.attribute3.buttonLeft.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute3.text <= 0 or self.attributeCounter.text >= maxAttributes) then return end

		self.attribute3.text = self.attribute3.text - 1
		self.attributeCounter.text = self.attributeCounter.text + 1
	end

	self.attribute3.buttonRight = self.attribute3:Add("DButton")
	self.attribute3.buttonRight:SetPos(factionWidth * 0.555, factionHeight * 0.15)
	self.attribute3.buttonRight:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute3.buttonRight:SetText("")
	self.attribute3.buttonRight.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 0)
	end
	self.attribute3.buttonRight.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute3.text >= maxAttributes or self.attributeCounter.text <= 0) then return end

		self.attribute3.text = self.attribute3.text + 1
		self.attributeCounter.text = self.attributeCounter.text - 1
	end

	self.attribute3.text = 0

	self.attribute4 = self:Add("DPanel")
	self.attribute4:SetPos(newPanelWidth * 0.08, newPanelHeight * 0.797)
	self.attribute4:SetSize(newPanelWidth * 0.8, newPanelHeight * 0.088)
	self.attribute4.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 225)
		surface.DrawRect(width * 0.133, height * 0.235, width * 0.402, height * 0.53)

		if (panel:IsHovered() or panel:IsChildHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(0, height * 0.04, 45 * scale, 70 * scale)
		end

		draw.SimpleText(panel.text or "", "ixRedFactionRegular", width * 0.133 + width * 0.402 / 2, height * 0.26, color_white, TEXT_ALIGN_CENTER)
	end
	self.attribute4.OnCursorEntered = function(panel)
		if (panel.hovered) then return end
		panel.hovered = true

		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.attribute4.OnCursorExited = function(panel)
		if (panel:IsChildHovered()) then return end

		panel.hovered = false
	end

	self.attribute4.buttonLeft = self.attribute4:Add("DButton")
	self.attribute4.buttonLeft:SetPos(factionWidth * 0.064, factionHeight * 0.15)
	self.attribute4.buttonLeft:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute4.buttonLeft:SetText("")
	self.attribute4.buttonLeft.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 180)
	end
	self.attribute4.buttonLeft.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute4.text <= 0 or self.attributeCounter.text >= maxAttributes) then return end

		self.attribute4.text = self.attribute4.text - 1
		self.attributeCounter.text = self.attributeCounter.text + 1
	end

	self.attribute4.buttonRight = self.attribute4:Add("DButton")
	self.attribute4.buttonRight:SetPos(factionWidth * 0.555, factionHeight * 0.15)
	self.attribute4.buttonRight:SetSize(factionWidth * 0.049, factionHeight * 0.7)
	self.attribute4.buttonRight:SetText("")
	self.attribute4.buttonRight.Paint = function(panel, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(panel:IsHovered() and arrowButtonMatSelected or arrowButtonMat)
		surface.DrawTexturedRectRotated(width / 2, height / 2, width, height, 0)
	end
	self.attribute4.buttonRight.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		if (self.attribute4.text >= maxAttributes or self.attributeCounter.text <= 0) then return end

		self.attribute4.text = self.attribute4.text + 1
		self.attributeCounter.text = self.attributeCounter.text - 1
	end

	self.attribute4.text = 0

	local createHeight = scrH - scrH / (8.5 / 2)
	local createWidth = (575 / 366) * createHeight -- Stretching it a bit because this was made in 2001

	self.createButton = self:Add("DButton")
	self.createButton:SetPos(createWidth * 0.118, createHeight * 0.897)
	self.createButton:SetSize(createWidth * 0.35, createHeight * 0.065)
	self.createButton:SetText("     Create Character") -- lol
	self.createButton:SetFont("ixRedFactionRegular")
	self.createButton.Paint = function(panel, width, height)
		local isHovered = panel:IsHovered()

		if (!isHovered) then
			surface.SetDrawColor(Color(0, 0, 0, 225))
			surface.DrawRect(width * 0.17, 0, width - width * 0.17, height)
		else
			surface.SetDrawColor(Color(255, 255, 255, 225))
			surface.SetMaterial(buttonMatSelectedBackground)
			surface.DrawTexturedRect(width * 0.17, 0, width - width * 0.17, height)

			surface.SetDrawColor(Color(255, 255, 255, 150))
			surface.SetMaterial(buttonMatSelectedGlow)
			surface.DrawTexturedRect(width - width * 0.98, height - height * 1.15, 45 * scale, 70 * scale)
		end
	end
	self.createButton.OnCursorEntered = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.createButton.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		net.Start("ixREDCreateCharacter")
			net.WriteString(self.name.entry:GetValue())
			net.WriteString(self.description.entry:GetValue())
			net.WriteUInt(self.faction.currSelection, 3)
			net.WriteUInt(self.attribute1.text, 4)
			net.WriteUInt(self.attribute2.text, 4)
			net.WriteUInt(self.attribute3.text, 4)
			net.WriteUInt(self.attribute4.text, 4)
		net.SendToServer()
	end
end

function PANEL:Populate()
	if (self.populated) then return end

	self.faction.selection = {}
	self.faction.currSelection = FACTION_MINER

	for _, data in pairs(ix.faction.teams) do
		if (!LocalPlayer():HasWhitelist(data.index)) then continue end

		self.faction.selection[data.index] = data.name
	end

	self.faction.text = self.faction.selection[self.faction.currSelection]
	self.faction.faction = ix.faction.indices[self.faction.currSelection].uniqueID

	self.populated = true
end

function PANEL:Reset()
	self.faction.currSelection = FACTION_MINER
	self.faction.text = self.faction.selection[self.faction.currSelection]
	self.faction.faction = ix.faction.indices[self.faction.currSelection].uniqueID

	self.name.entry:SetText("")
	self.description.entry:SetText("")
	self.attribute1.text = 0
	self.attribute2.text = 0
	self.attribute3.text = 0
	self.attribute4.text = 0
	self.attributeCounter.text = hook.Run("GetDefaultAttributePoints", LocalPlayer()) or 10
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(newMenuMat)
	surface.DrawTexturedRect(0, 0, width, height)

	draw.SimpleText("Character Name", "ixRedFactionRegular", width * 0.58, height * 0.062, color_black)
	draw.SimpleText("Physical Description", "ixRedFactionRegular", width * 0.58, height * 0.147, color_black)
	draw.SimpleText("Faction", "ixRedFactionRegular", width * 0.58, height * 0.235, color_black)
	draw.SimpleText("Character Model", "ixRedFactionRegular", width * 0.58, height * 0.365, color_black)
	draw.SimpleText("Remaining Character Attributes", "ixRedFactionRegular", width * 0.13, height * 0.482, color_black)
	draw.SimpleText("Strength", "ixRedFactionRegular", width * 0.58, height * 0.56, color_black)
	draw.SimpleText("Stamina", "ixRedFactionRegular", width * 0.58, height * 0.648, color_black)
	draw.SimpleText("Endurance", "ixRedFactionRegular", width * 0.58, height * 0.735, color_black)
	draw.SimpleText("Dexterity", "ixRedFactionRegular", width * 0.58, height * 0.824, color_black)
end

function PANEL:Toggle(bEnabled, delay, callback)
	local scrW, scrH = ScrW(), ScrH()

	local newPanelHeight = scrH - scrH / (8.5 / 2)
	local newPanelWidth = (575 / 366) * newPanelHeight -- Stretching it a bit because this was made in 2001

	delay = delay or 0

	local parent = self:GetParent()

	if (bEnabled) then
		if (!self.populated) then
			self:Populate()
		end

		self:Reset()

		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")
		end)

		parent.titleBar:Toggle(true, delay, "Create Character")
		self:MoveTo(scrW - newPanelWidth, scrH / 8.5, 0.35, delay)
		parent.button1:Toggle(bEnabled, "BACK", function(panel)
			self:Toggle(false, 0, function()
				parent.mainPanel:Toggle(true)
			end)
		end, delay, callback)
	else
		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_in.wav")
		end)

		parent.titleBar:Toggle(bEnabled, delay)
		self:MoveTo(scrW, scrH / 8.5, 0.35, delay)
		parent.button1:Toggle(bEnabled, nil, nil, delay, callback)
	end
end

vgui.Register("ixREDNewMenu", PANEL, "DPanel")
