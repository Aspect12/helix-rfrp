
local mainTitleMat = Material("materials/redfactionrp/main_title.png", "smooth alphatest") -- 436 x 366

local PANEL = {}

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH()

	local mainPanelHeight = scrH - scrH / (8.5 / 2)
	local mainPanelWidth = (575 / 366) * mainPanelHeight -- Stretching it a bit because this was made in 2001

	self:SetSize(mainPanelWidth, mainPanelHeight)
	self:SetPos(scrW, scrH / 8.5)
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(mainTitleMat)
	surface.DrawTexturedRect(0, 0, width, height)

	draw.SimpleText("Helix " .. GAMEMODE.Version, "ixRedFactionMini", width - 330, height - 55, color_black)
end

function PANEL:Toggle(bEnabled, delay, callback)
	local scrW, scrH = ScrW(), ScrH()
	local mainPanelHeight = scrH - scrH / (8.5 / 2)
	local mainPanelWidth = (575 / 366) * mainPanelHeight -- Stretching it a bit because this was made in 2001

	delay = delay or 0

	local parent = self:GetParent()

	if (bEnabled) then
		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_out.wav")
		end)

		local extraText = ix.config.Get("communityText", "@community")

		if (extraText:sub(1, 1) == "@") then
			extraText = L(extraText:sub(2))
		end

		self:MoveTo(scrW - mainPanelWidth, scrH / 8.5, math.Rand(0.35, 0.4), delay)

		parent.button1:Toggle(true, "NEW CHARACTER", function(panel)
			local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)

			-- don't allow creation if we've hit the character limit
			if (#ix.characters >= maximum) then
				Derma_Query(L("maxCharacters"), "ERROR", "OK")
				
				return
			end

			self:Toggle(false, 0, function()
				parent.newCharacterPanel:Toggle(true)
			end)
		end, delay)
		parent.button2:Toggle(true, "LOAD CHARACTER", function(panel)
			self:Toggle(false, 0, function()
				parent.loadCharacterPanel:Toggle(true)
			end)
		end, delay)
		parent.button3:Toggle(true, extraText:upper(), function(panel)
			gui.OpenURL(ix.config.Get("communityURL", ""))
		end, delay)
		parent.button4:Toggle(true, "CREDITS", function(panel)
			self:Toggle(false, 0, function()
				parent.creditsPanel:Toggle(true)
			end)
		end, delay)
		parent.button5:Toggle(true, "DISCONNECT", function(panel)
			Derma_Query("Are you sure you wish to disconnect from the server?", "DISCONNECT", "Disconnect", function()
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
						RunConsoleCommand("disconnect")
					end)
				end)
			end, "Cancel")
		end, delay)

		local bHasCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		parent.button6:Toggle(true, bHasCharacter and "RETURN" or "QUIT", function(panel)
			if (!bHasCharacter) then
				Derma_Query("Are you sure you wish to Quit to Desktop?", "QUIT GAME", "Quit", function()
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
							RunConsoleCommand("gamemenucommand", "quit")
						end)
					end)
				end, "Cancel")
			else
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
						parent:Remove()

						fade:AlphaTo(0, 0.5, 0, function()
							fade:Remove()
						end)
					end)
				end)
			end
		end, delay, callback)
	else
		timer.Simple(delay, function()
			surface.PlaySound("redfactionrp/menu/sweep_in.wav")
		end)

		self:MoveTo(scrW, scrH / 8.5, math.Rand(0.35, 0.4), delay)
		parent.button1:Toggle(false, nil, nil, delay)
		parent.button2:Toggle(false, nil, nil, delay)
		parent.button3:Toggle(false, nil, nil, delay)
		parent.button4:Toggle(false, nil, nil, delay)
		parent.button5:Toggle(false, nil, nil, delay)
		parent.button6:Toggle(false, nil, nil, delay, callback)
	end
end

-- This is in here for backwards compatibility, mainly
function PANEL:UpdateReturnButton(bValue) end

vgui.Register("ixREDMainMenu", PANEL, "DPanel")
