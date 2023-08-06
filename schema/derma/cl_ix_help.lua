
local backgroundColor = Color(0, 0, 0, 66)
local helpBlacklist = { -- This is so dumb
	["help"] = true,
	["inv"] = true,
	["scoreboard"] = true,
	["you"] = true,
	["settings"] = true
}

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)

	self.categories = {}
	self.categorySubpanels = {}
	self.categoryPanel = self:Add("ixHelpMenuCategories")

	self.canvasPanel = self:Add("EditablePanel")
	self.canvasPanel:Dock(FILL)

	self.idlePanel = self.canvasPanel:Add("Panel")
	self.idlePanel:Dock(FILL)
	self.idlePanel:DockMargin(8, 0, 0, 0)
	self.idlePanel.Paint = function(_, width, height)
		surface.SetDrawColor(backgroundColor)
		surface.DrawRect(0, 0, width, height)

		derma.SkinFunc("DrawHelixCurved", width * 0.5, height * 0.5, width * 0.25)

		surface.SetFont("ixIntroSubtitleFont")
		local text = L("helix"):lower()
		local textWidth, textHeight = surface.GetTextSize(text)

		surface.SetTextColor(color_white)
		surface.SetTextPos(width * 0.5 - textWidth * 0.5, height * 0.5 - textHeight * 0.75)
		surface.DrawText(text)

		surface.SetFont("ixMediumLightFont")
		text = L("helpIdle")
		local infoWidth, _ = surface.GetTextSize(text)

		surface.SetTextColor(color_white)
		surface.SetTextPos(width * 0.5 - infoWidth * 0.5, height * 0.5 + textHeight * 0.25)
		surface.DrawText(text)
	end

	local categories = {}
	hook.Run("PopulateHelpMenu", categories)
	hook.Run("CreateMenuButtons", categories)

	-- Stupid
	for k, v in pairs(categories) do
		if (isfunction(v) or !v.Sections) then continue end

		for k2, v2 in pairs(v.Sections) do
			categories[k2] = v2
			categories[k2].parentPanelName = k
		end
	end

	for k, v in SortedPairs(categories) do
		if (!isstring(k)) then
			ErrorNoHalt("expected string for help menu key\n")
			continue
		elseif (helpBlacklist[k]) then
			continue
		elseif (!isfunction(v) and !v.Create) then
			ErrorNoHalt(string.format("expected function for help menu entry '%s'\n", k))
			continue
		end

		self:AddCategory(k)
		self.categories[k] = v
	end

	self.categoryPanel:SizeToContents()

	if (ix.gui.lastHelpMenuTab) then
		self:OnCategorySelected(ix.gui.lastHelpMenuTab)
	end
end

function PANEL:AddCategory(name)
	local button = self.categoryPanel:Add("ixMenuButton")
	button:SetText(L(name))
	button:SizeToContents()
	-- @todo don't hardcode this but it's the only panel that needs docking at the bottom so it'll do for now
	button:Dock(name == "credits" and BOTTOM or TOP)
	button.DoClick = function()
		self:OnCategorySelected(name)
	end

	local panel = self.canvasPanel:Add("DScrollPanel")
	panel:SetVisible(false)
	panel:Dock(FILL)
	panel:DockMargin(8, 0, 0, 0)
	panel:GetCanvas():DockPadding(8, 8, 8, 8)

	panel.Paint = function(_, width, height)
		surface.SetDrawColor(backgroundColor)
		surface.DrawRect(0, 0, width, height)
	end

	-- reverts functionality back to a standard panel in the case that a category will manage its own scrolling
	panel.DisableScrolling = function()
		panel:GetCanvas():SetVisible(false)
		panel:GetVBar():SetVisible(false)
		panel.OnChildAdded = function() end
	end

	self.categorySubpanels[name] = panel
end

function PANEL:OnCategorySelected(name)
	local panel = self.categorySubpanels[name]

	if (!IsValid(panel)) then return end

	if (!panel.bPopulated) then
		if (isfunction(self.categories[name])) then
			self.categories[name](panel)
		else
			local subPanel

			panel.OnChildAdded = function(_, child)
				subPanel = child
			end

			self.categories[name]:Create(panel)

			panel.OnChildAdded = function() end

			if (self.categories[name].parentPanelName) then
				hook.Run("MenuSubpanelCreated", self.categories[name].parentPanelName .. "/" .. name, subPanel)
			end
			
			if (IsValid(subPanel.searchEntry)) then
				subPanel.searchEntry:RequestFocus()
			end

			if (self.categories[name].OnSelected) then
				self.categories[name]:OnSelected(panel)
			end
		end

		panel.bPopulated = true
	end

	if (IsValid(self.activeCategory)) then
		self.activeCategory:SetVisible(false)
	end

	panel:SetVisible(true)
	self.idlePanel:SetVisible(false)

	self.activeCategory = panel
	ix.gui.lastHelpMenuTab = name
end

vgui.Register("ixREDHelpMenu", PANEL, "EditablePanel")
