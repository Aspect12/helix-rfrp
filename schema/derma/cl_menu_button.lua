
local PANEL = {}

local buttonMat =  Material("materials/redfactionrp/button.png") -- 204 x 61
local buttonMatSelectedBackground = Material("materials/redfactionrp/button_selected_background.png") -- 129 x 46
local buttonMatSelectedGlow = Material("materials/redfactionrp/button_selected_glow.png", "smooth") -- 13 x 28
local arrowMat = Material("materials/redfactionrp/arrow.png", "smooth") -- 19 x 26

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()
	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)
	local width = 204 * 3.25 * scale

	self:SetSize(width, 61 * 2.3 * scale)
	self:SetX(-width) -- Starting off-screen
	self:SetFont("ixRedFactionRegular")

	self.buttonDarkness = 225
end

function PANEL:Toggle(bEnabled, text, onClickCallback, delay, onToggledCallback)
	delay = delay or 0

	if (bEnabled) then
		self:SetText(text)
		self.OnClick = onClickCallback

		self:MoveTo(0, self:GetY(), math.Rand(0.35, 0.4), delay, -1, function()
			if (onToggledCallback) then
				onToggledCallback()
			end
		end)
	else
		self:MoveTo(-self:GetWide(), self:GetY(), math.Rand(0.35, 0.4), delay, -1, function()
			self.altMode = false

			if (onToggledCallback) then
				onToggledCallback()
			end
		end)
	end
end

function PANEL:Paint(width, height)
	local scrW, scrH = ScrW(), ScrH()
	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)
	local isHovered = self:IsHovered()

	if (!isHovered) then
		surface.SetDrawColor(Color(0, 0, 0, self.buttonDarkness))
		surface.DrawRect(width * 0.15, 0, width * 0.7, height)
	else
		surface.SetDrawColor(Color(255, 255, 255, self.buttonDarkness))
		surface.SetMaterial(buttonMatSelectedBackground)
		surface.DrawTexturedRect(width * 0.2, height * 0.1, width - width * 0.39, height - height * 0.2)
	end

	surface.SetDrawColor(color_white)
	surface.SetMaterial(buttonMat)
	surface.DrawTexturedRect(0, 0, width, height)

	if (self.altMode) then
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(arrowMat)
		surface.DrawTexturedRect(width * 0.823, height - height * 0.75, 45 * scale, 70 * scale)
	end

	if (isHovered) then
		surface.SetDrawColor(Color(255, 255, 255, 150))
		surface.SetMaterial(buttonMatSelectedGlow)
		surface.DrawTexturedRect(width - width * 0.11, height - height * 0.75, 45 * scale, 70 * scale)
	end
end

function PANEL:DoClick()
	surface.PlaySound("redfactionrp/menu/menu_select.wav")

	self.OnClick(self)
end

function PANEL:OnCursorEntered()
	surface.PlaySound("redfactionrp/menu/menu_highlight.wav")
end

vgui.Register("ixREDMenuButton", PANEL, "DButton")
