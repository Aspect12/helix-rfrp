
local titleBarMat = Material("materials/redfactionrp/title_bar.png", "alphatest smooth") -- 512 x 64

local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	local titleBarHeight = scrH / 7.5
	local titleBarWidth = (675 / 64) * titleBarHeight -- Stretching it a bit because this was made in 2001

	self:SetSize(titleBarWidth, titleBarHeight)
	self:SetPos(scrW, 0)
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(titleBarMat)
	surface.DrawTexturedRect(0, 0, width, height)

	draw.SimpleText(self.text or "", "ixRedFactionBigBold", width / 3.6, height / 7, color_black)
end

function PANEL:Toggle(bEnabled, delay, text, callback)
	local scrW, scrH = ScrW(), ScrH()
	local titleBarHeight = scrH / 7.5
	local titleBarWidth = (675 / 64) * titleBarHeight -- Stretching it a bit because this was made in 2001

	delay = delay or 0

	if (bEnabled) then
		self.text = text
		self:MoveTo(scrW - titleBarWidth, 0, 0.4, delay)
	else
		self:MoveTo(scrW, self:GetY(), 0.4, delay)
	end
end

vgui.Register("ixREDTitle", PANEL, "DPanel")
