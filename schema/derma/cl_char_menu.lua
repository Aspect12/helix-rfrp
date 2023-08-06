
local background = Material("materials/redfactionrp/background.png")
local barLeft, barRight = Material("materials/redfactionrp/bar_left.png"), Material("materials/redfactionrp/bar_right.png") -- 64 x 480

local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.loading)) then
		ix.gui.loading:Remove()
	end

	if (IsValid(ix.gui.characterMenu)) then
		if (IsValid(ix.gui.characterMenu.channel)) then
			ix.gui.characterMenu.channel:Stop()
		end

		ix.gui.characterMenu:Remove()
	end

	local scrW, scrH = ScrW(), ScrH()
	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	self:SetSize(scrW, scrH)
	self:SetPos(0, 0)
	self:MakePopup()

	self.titleBar = self:Add("ixREDTitle")
	self.mainPanel = self:Add("ixREDMainMenu")
	self.newCharacterPanel = self:Add("ixREDNewMenu")
	self.loadCharacterPanel = self:Add("ixREDLoadMenu")
	self.creditsPanel = self:Add("ixREDCreditsScreen")

	for i = 0, 5 do
		self["button" .. i + 1] = self:Add("ixREDMenuButton")
		self["button" .. i + 1]:SetY(scrH / 8.5 + (i * (61 * 2.3 - 2.5) * scale))
	end

	self.mainPanel:Toggle(true)

	self.currentAlpha = 255 -- Redundant, kept to avoid errors
	self.volume = 0

	ix.gui.characterMenu = self

	if (!IsValid(ix.gui.intro)) then
		self:PlayMusic()
	end

	hook.Run("OnCharacterMenuCreated", self)
end

local scrollSpeed = -30

function PANEL:Paint()
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(color_black)
	surface.DrawRect(0, 0, scrW, scrH)

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(background)

	local x = (RealTime() * scrollSpeed) % scrW

	surface.DrawTexturedRect(x, 0, scrW, scrH)
	surface.DrawTexturedRect(x - scrW, 0, scrW, scrH)
end

function PANEL:PaintOver()
	local scrW, scrH = ScrW(), ScrH()
	local barWidth = (64 / 480) * scrH

	surface.SetDrawColor(color_white)
	surface.SetMaterial(barLeft)
	surface.DrawTexturedRect(0, 0, barWidth, scrH)

	surface.SetMaterial(barRight)
	surface.DrawTexturedRect(scrW - barWidth, 0, barWidth, scrH)
end

function PANEL:PlayMusic()
	local path = "sound/" .. ix.config.Get("music")
	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay", function(channel, error, message)
		if (!IsValid(self) or !IsValid(channel)) then
			return
		end

		channel:SetVolume(self.volume or 0)
		channel:Play()

		self.channel = channel

		self:CreateAnimation(2, {
			index = 10,
			target = {volume = 1},
			Think = function(animation, panel)
				if (IsValid(panel.channel)) then
					panel.channel:SetVolume(self.volume * 0.5)
				end
			end
		})
	end)
end

function PANEL:ShowNotice(type, text)
	Derma_Query(text, "NOTICE", "OK")
end

function PANEL:HideNotice() end

function PANEL:OnCharacterDeleted(character)
	self.loadCharacterPanel:Populate()
end

function PANEL:OnCharacterLoadFailed(error)
	Derma_Query(error, "ERROR", "OK")

	self.loadCharacterPanel:Toggle(true, 0.5)
end

function PANEL:IsClosing()
	return self.bClosing
end

function PANEL:Close(bFromMenu)
	self.bClosing = true

	self:Remove()
end

function PANEL:OnRemove()
	if (self.channel) then
		self.channel:Stop()
		self.channel = nil
	end
end

vgui.Register("ixCharMenu", PANEL, "EditablePanel")

if (IsValid(ix.gui.characterMenu)) then
	ix.gui.characterMenu:Remove()

	--TODO: REMOVE ME
	ix.gui.characterMenu = vgui.Create("ixCharMenu")
end
