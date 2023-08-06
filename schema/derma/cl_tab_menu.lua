
local barLeft, barRight = Material("materials/redfactionrp/bar_left.png"), Material("materials/redfactionrp/bar_right.png") -- 64 x 480
local mainTitleMat, mainTitleEmptyMat = Material("materials/redfactionrp/main_title.png", "smooth alphatest"), Material("materials/redfactionrp/tab_empty.png") -- 436 x 366

local PANEL = {}

AccessorFunc(PANEL, "bCharacterOverview", "CharacterOverview", FORCE_BOOL)

function PANEL:Init()
	if (IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

	local scrW, scrH = ScrW(), ScrH()

	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)
	self:MakePopup()

	self.darkenBackground = self:Add("DPanel")
	self.darkenBackground:SetSize(scrW, scrH)
	self.darkenBackground:SetPos(0, 0)
	self.darkenBackground:SetZPos(-1)
	self.darkenBackground.Paint = function(this, width, height)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, width, height)
	end
	self.darkenBackground:SetAlpha(0)
	self.darkenBackground:AlphaTo(150, 0.4)

	self:SetPaintBackground(false)

	self:PopulateTabs()

	self.currentAlpha = 255
	ix.gui.menu = self
end

function PANEL:SetupTab(name, info, sectionParent) end

function PANEL:PopulateTabs()
	local scrW, scrH = ScrW(), ScrH()
	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	local barWidth = (64 / 480) * scrH

	self.titleBar = self:Add("ixREDTitle")

	self.leftBar = self:Add("DPanel")
	self.leftBar:SetPos(-barWidth, 0)
	self.leftBar:SetSize(barWidth, scrH)
	self.leftBar:SetZPos(999)
	self.leftBar.Paint = function(this, width, height)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(barLeft)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	self.leftBar:MoveTo(0, 0, 0.4)

	self.rightBar = self:Add("DPanel")
	self.rightBar:SetPos(scrW, 0)
	self.rightBar:SetSize(barWidth, scrH)
	self.rightBar:SetZPos(999)
	self.rightBar.Paint = function(this, width, height)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(barRight)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	self.rightBar:MoveTo(scrW - barWidth, 0, 0.4)

	local mainPanelHeight = scrH - scrH / (8.5 / 2)
	local mainPanelWidth = (575 / 366) * mainPanelHeight -- Stretching it a bit because this was made in 2001

	self.contentWindow = self:Add("DPanel")
	self.contentWindow:SetPos(scrW, scrH / 8.5)
	self.contentWindow:SetSize(mainPanelWidth, mainPanelHeight)
	self.contentWindow:DockPadding(scrW * 0.076, scrH * 0.07, scrW * 0.053, scrH * 0.065)
	self.contentWindow.Paint = function(this, width, height)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(IsValid(this.content) and mainTitleEmptyMat or mainTitleMat)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	self.contentWindow:MoveTo(scrW - mainPanelWidth, scrH / 8.5, 0.4)

	self.button1 = self:Add("ixREDMenuButton")
	self.button1:SetY(scrH / 8.5 + (0 * (61 * 2.3 - 2.5) * scale))
	self.button1.buttonDarkness = 150
	self.button1:Toggle(true, "DIRECTORY", function()
		if (self.titleBar.text == "Directory") then return end

		surface.PlaySound("redfactionrp/menu/sweep_in.wav")

		self.titleBar:Toggle(false)

		self.contentWindow:MoveTo(scrW, scrH / 8.5, 0.4, 0, -1, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")

			if (IsValid(self.contentWindow.content)) then
				self.contentWindow.content:Remove()
			end

			self.contentWindow.content = self.contentWindow:Add("ixREDHelpMenu")
			self.contentWindow.content:Dock(FILL)

			self.titleBar:Toggle(true, 0, "Directory")

			self.contentWindow:MoveTo(scrW - mainPanelWidth, scrH / 8.5, 0.4)
		end)
	end, 0.1)

	self.button2 = self:Add("ixREDMenuButton")
	self.button2:SetY(scrH / 8.5 + (1 * (61 * 2.3 - 2.5) * scale))
	self.button2.buttonDarkness = 150
	self.button2:Toggle(true, "INVENTORY", function()
		if (self.titleBar.text == "Inventory") then return end

		surface.PlaySound("redfactionrp/menu/sweep_in.wav")

		self.titleBar:Toggle(false)

		self.contentWindow:MoveTo(scrW, scrH / 8.5, 0.4, 0, -1, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")

			if (IsValid(self.contentWindow.content)) then
				self.contentWindow.content:Remove()
			end

			self.contentWindow.content = self.contentWindow:Add("DTileLayout")
			local canvasLayout = self.contentWindow.content.PerformLayout
			
			self.contentWindow.content.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
			self.contentWindow.content:SetBorder(0)
			self.contentWindow.content:SetSpaceX(2)
			self.contentWindow.content:SetSpaceY(2)
			self.contentWindow.content:Dock(FILL)

			ix.gui.menuInventoryContainer = self.contentWindow.content

			local panel = self.contentWindow.content:Add("ixInventory")
			panel:SetPos(0, 0)
			panel:SetDraggable(false)
			panel:SetSizable(false)
			panel:SetTitle(nil)
			panel.bNoBackgroundBlur = true
			panel.childPanels = {}

			local inventory = LocalPlayer():GetCharacter():GetInventory()

			if (inventory) then
				panel:SetInventory(inventory)
			end

			ix.gui.inv1 = panel

			if (ix.option.Get("openBags", true)) then
				for _, v in pairs(inventory:GetItems()) do
					if (!v.isBag) then continue end

					v.functions.View.OnClick(v)
				end
			end

			self.contentWindow.content.PerformLayout = canvasLayout
			self.contentWindow.content:Layout()

			self.titleBar:Toggle(true, 0, "Inventory")

			self.contentWindow:MoveTo(scrW - mainPanelWidth, scrH / 8.5, 0.4)
		end)
	end, 0.1)

	self.button3 = self:Add("ixREDMenuButton")
	self.button3:SetY(scrH / 8.5 + (2 * (61 * 2.3 - 2.5) * scale))
	self.button3.buttonDarkness = 150
	self.button3:Toggle(true, "SCOREBOARD", function()
		if (self.titleBar.text == "Scoreboard") then return end

		surface.PlaySound("redfactionrp/menu/sweep_in.wav")

		self.titleBar:Toggle(false)

		self.contentWindow:MoveTo(scrW, scrH / 8.5, 0.4, 0, -1, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")

			if (IsValid(self.contentWindow.content)) then
				self.contentWindow.content:Remove()
			end

			self.contentWindow.content = self.contentWindow:Add("ixScoreboard")
			self.contentWindow.content:Dock(FILL)

			self.titleBar:Toggle(true, 0, "Scoreboard")

			self.contentWindow:MoveTo(scrW - mainPanelWidth, scrH / 8.5, 0.4)
		end)
	end, 0.1)

	self.button4 = self:Add("ixREDMenuButton")
	self.button4:SetY(scrH / 8.5 + (3 * (61 * 2.3 - 2.5) * scale))
	self.button4.buttonDarkness = 150
	self.button4:Toggle(true, "CHARACTER", function()
		if (self.titleBar.text == "Character") then return end

		surface.PlaySound("redfactionrp/menu/sweep_in.wav")

		self.titleBar:Toggle(false)

		self.contentWindow:MoveTo(scrW, scrH / 8.5, 0.4, 0, -1, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")

			if (IsValid(self.contentWindow.content)) then
				self.contentWindow.content:Remove()
			end

			self.contentWindow.content = self.contentWindow:Add("ixCharacterInfo")
			self.contentWindow.content:Dock(FILL)
			self.contentWindow.content:Update(LocalPlayer():GetCharacter())

			self.titleBar:Toggle(true, 0, "Character")

			self.contentWindow:MoveTo(scrW - mainPanelWidth, scrH / 8.5, 0.4)
		end)
	end, 0.1)

	self.button5 = self:Add("ixREDMenuButton")
	self.button5:SetY(scrH / 8.5 + (4 * (61 * 2.3 - 2.5) * scale))
	self.button5.buttonDarkness = 150
	self.button5:Toggle(true, "OPTIONS", function()
		if (self.titleBar.text == "Options") then return end
		
		surface.PlaySound("redfactionrp/menu/sweep_in.wav")

		self.titleBar:Toggle(false)

		self.contentWindow:MoveTo(scrW, scrH / 8.5, 0.4, 0, -1, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")

			if (IsValid(self.contentWindow.content)) then
				self.contentWindow.content:Remove()
			end
			
			self.contentWindow.content = self.contentWindow:Add("ixSettings")
			self.contentWindow.content:SetSearchEnabled(true)

			for category, options in SortedPairs(ix.option.GetAllByCategories(true)) do
				category = L(category)
				self.contentWindow.content:AddCategory(category)

				-- sort options by language phrase rather than the key
				table.sort(options, function(a, b)
					return L(a.phrase) < L(b.phrase)
				end)

				for _, data in pairs(options) do
					local key = data.key
					local row = self.contentWindow.content:AddRow(data.type, category)
					local value = ix.util.SanitizeType(data.type, ix.option.Get(key))

					row:SetText(L(data.phrase))
					row:Populate(key, data)

					-- type-specific properties
					if (data.type == ix.type.number) then
						row:SetMin(data.min or 0)
						row:SetMax(data.max or 10)
						row:SetDecimals(data.decimals or 0)
					end

					row:SetValue(value, true)
					row:SetShowReset(value != data.default, key, data.default)
					row.OnValueChanged = function()
						local newValue = row:GetValue()

						row:SetShowReset(newValue != data.default, key, data.default)
						ix.option.Set(key, newValue)
					end

					row.OnResetClicked = function()
						row:SetShowReset(false)
						row:SetValue(data.default, true)

						ix.option.Set(key, data.default)
					end

					row:GetLabel():SetHelixTooltip(function(tooltip)
						local title = tooltip:AddRow("name")
						title:SetImportant()
						title:SetText(key)
						title:SizeToContents()
						title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

						local description = tooltip:AddRow("description")
						description:SetText(L(data.description))
						description:SizeToContents()
					end)
				end
			end

			self.contentWindow.content:SizeToContents()
			self.contentWindow.content:Dock(FILL)

			self.titleBar:Toggle(true, 0, "Options")

			self.contentWindow:MoveTo(scrW - mainPanelWidth, scrH / 8.5, 0.4)
		end)
	end, 0.1)

	self.button6 = self:Add("ixREDMenuButton")
	self.button6:SetY(scrH / 8.5 + (5 * (61 * 2.3 - 2.5) * scale))
	self.button6.buttonDarkness = 150
	self.button6:Toggle(true, "BACK TO MENU", function()
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
			self:Remove()
			vgui.Create("ixCharMenu")	

			fade:MakePopup()

			fade:AlphaTo(0, 1, 0, function()
				fade:Remove()
			end)
		end)
	end, 0.1)

	LocalPlayer():EmitSound("redfactionrp/menu/sweep_out.wav", 75, 90)
end

function PANEL:OnKeyCodePressed(key)
	if (key != KEY_TAB) then return end
	local scrW, scrH = ScrW(), ScrH()

	self.darkenBackground:AlphaTo(0, 0.4)

	for i = 1, 6 do
		if (!IsValid(self["button" .. i])) then continue end

		self["button" .. i]:Toggle(false)
	end

	self.contentWindow:MoveTo(scrW, scrH / 8.5, 0.4)
	self.titleBar:Toggle(false)

	self.leftBar:MoveTo(-self.leftBar:GetWide(), 0, 0.5)
	self.rightBar:MoveTo(scrW, 0, 0.5, 0, -1, function()
		self:AlphaTo(0, 0.5, 0, function()
			
		end)
	end)

	timer.Simple(0.5, function()
		self:Remove()
	end)

	surface.PlaySound("redfactionrp/menu/sweep_in.wav")
end

function PANEL:GetActiveTab() end

vgui.Register("ixMenu", PANEL, "DPanel")

if (IsValid(ix.gui.menu)) then
	ix.gui.menu:Remove()
end
