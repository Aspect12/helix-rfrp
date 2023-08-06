
local buttonMatSelectedBackground = Material("materials/redfactionrp/button_selected_background.png", "alphatest smooth") -- 129 x 46
local buttonMatSelectedGlow = Material("materials/redfactionrp/button_selected_glow.png", "smooth") -- 13 x 28
local loadMenuMat = Material("materials/redfactionrp/loadcharacter_panel.png", "alphatest smooth") -- 599 x 366

local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	local loadHeight = scrH - scrH / (8.5 / 2)
	local loadWidth = (575 / 366) * loadHeight -- Stretching it a bit because this was made in 2001

	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	self:SetSize(loadWidth, loadHeight)
	self:SetPos(scrW, scrH / 8.5)

	self.characterList = self:Add("DPanel")
	self.characterList:SetSize(loadWidth * 0.731, loadHeight * 0.59)
	self.characterList:SetPos(loadWidth * 0.138, loadHeight * 0.162)
	self.characterList:SetPaintBackground(false)
	self.characterList.OnCursorEntered = function(panel)
		if (panel.hovered) then return end
		panel.hovered = true

		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.characterList.OnCursorExited = function(panel)
		if (panel:IsChildHovered()) then return end

		panel.hovered = false
	end

	self.characterList.characters = {}

	self.loadButton = self:Add("DButton")
	self.loadButton:SetPos(loadWidth * 0.12, loadHeight - loadHeight * 0.19)
	self.loadButton:SetSize(loadWidth * 0.35, loadHeight * 0.065)
	self.loadButton:SetText("     Load") -- lol
	self.loadButton:SetFont("ixRedFactionRegular")
	self.loadButton.Paint = function(panel, width, height)
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
	self.loadButton.OnCursorEntered = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.loadButton.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		local target = self.characterList.selected
		if (!IsValid(target)) then return end

		local currChar = LocalPlayer():GetCharacter()

		if (currChar and currChar:GetID() == target.character:GetID()) then
			Derma_Query("You are already using this character.", "ERROR", "OK")
			
			return
		end

		self:Toggle(false, 0, function()
			local fade = vgui.Create("DPanel")
			fade:SetSize(scrW, scrH)
			fade:SetPos(0, 0)
			fade:SetAlpha(0)
			fade:MakePopup()

			fade.Paint = function(this, width, height)
				surface.SetDrawColor(color_black)
				surface.DrawRect(0, 0, width, height)
			end

			fade:AlphaTo(255, 0.5, 0, function()
				net.Start("ixCharacterChoose")
					net.WriteUInt(target.character:GetID(), 32)
				net.SendToServer()

				timer.Simple(0.5, function()
					fade:AlphaTo(0, 0.5, 0, function()
						fade:Remove()
					end)
				end)
			end)
		end)
	end

	self.deleteButton = self:Add("DButton")
	self.deleteButton:SetPos(loadWidth * 0.12, loadHeight - loadHeight * 0.097)
	self.deleteButton:SetSize(loadWidth * 0.35, loadHeight * 0.065)
	self.deleteButton:SetText("     Delete") -- lol
	self.deleteButton:SetFont("ixRedFactionRegular")
	self.deleteButton.Paint = function(panel, width, height)
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
	self.deleteButton.OnCursorEntered = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
	end
	self.deleteButton.DoClick = function(panel)
		surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

		local target = self.characterList.selected
		if (!IsValid(target)) then return end

		Derma_Query("Are you sure you wish to delete this character? This action is irreversible.", "DELETE CHARACTER", "Delete", function()
			net.Start("ixCharacterDelete")
				net.WriteUInt(target.character:GetID(), 32)
			net.SendToServer()
		end, "Cancel")
	end

	self:Populate()
end

function PANEL:Populate()
	for _, panel in ipairs(self.characterList.characters) do
		if (!IsValid(panel)) then continue end

		panel:Remove()
	end

	for i = 1, #ix.characters do
		local id = ix.characters[i]
		local character = ix.char.loaded[id]

		if (!character) then continue end

		local index = character:GetFaction()
		local faction = ix.faction.indices[index]
		local color = Color(58, 159, 155)

		local lastJoinStamp = os.date("%m/%d/%Y", character:GetLastJoinTime())

		local charPanel = self.characterList:Add("DButton")
		charPanel:SetTall(30)
		charPanel:Dock(TOP)
		charPanel:SetText("")
		charPanel.character = character
		charPanel.Paint = function(panel, width, height)
			local selected = self.characterList.selected == panel or panel:IsHovered()

			if (selected) then
				surface.SetDrawColor(color)
				surface.DrawRect(0, 0, width, height)
			end

			draw.SimpleText(character:GetName(), "ixRedFactionRegularBold", width * 0.01, 0, !selected and color or color_black)
			draw.SimpleText(faction.name, "ixRedFactionRegularBold", width * 0.35, 0, !selected and color or color_black)
			draw.SimpleText(lastJoinStamp, "ixRedFactionRegularBold", width * 0.725, 0, !selected and color or color_black)
		end
		charPanel.DoClick = function(panel)
			surface.PlaySound("redfactionrp/menu/panel_button_click.wav")

			self.characterList.selected = panel
		end

		if (!self.characterList.selected) then
			self.characterList.selected = charPanel
		end

		self.characterList.characters[#self.characterList.characters + 1] = charPanel
	end
end

function PANEL:Paint(width, height)
	local scrW, scrH = ScrW(), ScrH()
	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	surface.SetDrawColor(Color(0, 0, 0, 225))
	surface.DrawRect(width * 0.1, 0, width, height * 0.78)

	surface.SetDrawColor(color_white)
	surface.SetMaterial(loadMenuMat)
	surface.DrawTexturedRect(0, 0, width, height)

	if (self.characterList:IsHovered() or self.characterList:IsChildHovered(true)) then
		surface.SetDrawColor(Color(255, 255, 255, 150))
		surface.SetMaterial(buttonMatSelectedGlow)
		surface.DrawTexturedRect(width * 0.128, height - height * 0.933, 45 * scale, 70 * scale)
	end

	draw.SimpleText("Name", "ixRedFactionRegular", width * 0.23, height - height * 0.91, color_black)
	draw.SimpleText("Faction", "ixRedFactionRegular", width * 0.48, height - height * 0.91, color_black)
	draw.SimpleText("Last Played", "ixRedFactionRegular", width * 0.7, height - height * 0.91, color_black)
end

function PANEL:Toggle(bEnabled, delay, callback)
	local scrW, scrH = ScrW(), ScrH()
	local loadHeight = scrH - scrH / (8.5 / 2)
	local loadWidth = (575 / 366) * loadHeight -- Stretching it a bit because this was made in 2001

	delay = delay or 0

	local parent = self:GetParent()

	if (bEnabled) then
		self:Populate()
	
		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")
		end)

		parent.titleBar:Toggle(true, delay, "Load Character")
		self:MoveTo(scrW - loadWidth, scrH / 8.5, 0.35, delay)
		parent.button1:Toggle(bEnabled, "BACK", function(panel)
			self:Toggle(false, 0, function()
				parent.mainPanel:Toggle(true)
			end)
		end, delay, callback)
	else
		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_in.wav")
		end)

		parent.titleBar:Toggle(false, delay)
		self:MoveTo(scrW, scrH / 8.5, 0.35, delay)
		parent.button1:Toggle(bEnabled, nil, nil, delay, callback)
	end
end

vgui.Register("ixREDLoadMenu", PANEL, "DPanel")
