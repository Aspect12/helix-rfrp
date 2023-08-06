
local blankMenuMat = Material("materials/redfactionrp/tab_empty_credits.png") -- 599 x 366
local creditsMat = Material("materials/redfactionrp/credits_page.png", "smooth alphatest") -- 599 x 366

local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	local creditsHeight = scrH - scrH / (8.5 / 2)
	local creditsWidth = (575 / 366) * creditsHeight -- Stretching it a bit because this was made in 2001

	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	self:SetSize(creditsWidth, creditsHeight)
	self:SetPos(scrW, scrH / 8.5)
	self:DockPadding(scrW * 0.076, scrH * 0.07, scrW * 0.053, scrH * 0.065)

	self.helixCredits = self:Add("DScrollPanel")
	self.helixCredits:Dock(FILL)
	self.helixCredits:Add("ixREDCredits"):Dock(FILL)
	self.helixCredits:Hide()

	self.showHelixCredits = false
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(self.showHelixCredits and blankMenuMat or creditsMat)
	surface.DrawTexturedRect(0, 0, width, height)
end

function PANEL:Toggle(bEnabled, delay, callback)
	local scrW, scrH = ScrW(), ScrH()
	local creditsHeight = scrH - scrH / (8.5 / 2)
	local creditsWidth = (575 / 366) * creditsHeight -- Stretching it a bit because this was made in 2001

	delay = delay or 0

	local parent = self:GetParent()

	if (bEnabled) then	
		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")
		end)

		parent.titleBar:Toggle(true, delay, "Credits")
		self:MoveTo(scrW - creditsWidth, scrH / 8.5, 0.35, delay)
		parent.button1:Toggle(true, "SCHEMA CREDITS", function(panel)
			if (!self.showHelixCredits) then return end

			surface.PlaySound("redfactionrp/menu/sweep_in.wav")
			self:MoveTo(scrW, scrH / 8.5, 0.35, delay, -1, function()
				self.helixCredits:Hide()
				self.showHelixCredits = false

				timer.Simple(delay, function()
					surface.PlaySound("redfactionrp/menu/sweep_out.wav")
				end)
				
				self:MoveTo(scrW - creditsWidth, scrH / 8.5, 0.35, delay)
			end)
		end, delay)
		parent.button1.altMode = true
		parent.button2:Toggle(true, "FRAMEWORK CREDITS", function(panel)
			if (self.showHelixCredits) then return end

			surface.PlaySound("redfactionrp/menu/sweep_in.wav")
			self:MoveTo(scrW, scrH / 8.5, 0.35, delay, -1, function()
				self.helixCredits:Show()
				self.showHelixCredits = true

				timer.Simple(delay, function()
					surface.PlaySound("redfactionrp/menu/sweep_out.wav")
				end)

				self:MoveTo(scrW - creditsWidth, scrH / 8.5, 0.35, delay)
			end)
		end, delay)
		parent.button2.altMode = true
		parent.button3:Toggle(true, "BACK", function(panel)
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
		parent.button1:Toggle(false, nil, nil, delay)
		parent.button2:Toggle(false, nil, nil, delay)
		parent.button3:Toggle(false, nil, nil, delay, callback)
	end
end

vgui.Register("ixREDCreditsScreen", PANEL, "DPanel")
