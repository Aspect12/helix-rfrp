
local popupTop = Material("materials/redfactionrp/popup_top.png", "alphatest smooth") -- 400 x 132
local popupButtons = Material("materials/redfactionrp/popup_buttons.png", "alphatest smooth") -- 400 x 183
local buttonMatSelectedBackground = Material("materials/redfactionrp/button_selected_background.png") -- 129 x 46
local buttonMatSelectedGlow = Material("materials/redfactionrp/button_selected_glow.png", "smooth") -- 13 x 28

function Derma_Query(strText, strTitle, ...)
	surface.PlaySound("redfactionrp/menu/menu_select.wav")

	local window = vgui.Create("EditablePanel")
	window:SetSize(ScrW(), ScrH())
	window:SetPos(0, 0)
	window:SetDrawOnTop(true)

	window.Paint = function(panel, width, height)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, width, height)
	end

	local arguments = {...}
	local buttonCount = (#arguments / 2) % 2 == 0 and #arguments / 2 or (#arguments / 2) + 0.5

	local innerWidth, innerHeight = 1200, (145 / 650) * 1200 + ((38 / 650) * 1200) * buttonCount
	local buttonHeight = (183 / 650) * innerWidth
	local coverHeight = (132 / 650) * innerWidth

	local words = string.Explode(" ", strText)
	local lines = {}
	local curLine = ""

	for _, word in ipairs(words) do
		if (string.len(curLine) + string.len(word) + 1 > 65) then
			table.insert(lines, curLine)

			curLine = ""
		end

		curLine = curLine .. word .. " "
	end

	if (curLine != "") then
		table.insert(lines, curLine)
	end

	strText = ""

	for _, line in ipairs(lines) do
		strText = strText .. string.Trim(line) .. "\n"
	end

	strText = string.sub(strText, 1, -2)
	
	local innerPanel = window:Add("DPanel")
	innerPanel:SetSize(innerWidth, innerHeight)
	innerPanel:Center()
	innerPanel.Paint = function(panel, width, height)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(popupButtons)
		surface.DrawTexturedRect(0, height - buttonHeight, width, buttonHeight)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(popupTop)
		surface.DrawTexturedRect(0, 0, width, coverHeight)

		surface.SetDrawColor(color_black)
		draw.SimpleText(strTitle:upper(), "ixRedFactionMediumBold", width * 0.05, coverHeight * 0.05, color_black)
		draw.DrawText(strText, "ixRedFactionRegular", width * 0.05, coverHeight * 0.3, color_black)
	end

	local scrW, scrH = ScrW(), ScrH()
	local scaleX, scaleY = scrW / 1920, scrH / 1080
	local scale = math.min(scaleX, scaleY)

	local heightOffset = 0

	for i = 1, buttonCount do
		local button = innerPanel:Add("DButton")
		button:SetPos(innerWidth - innerWidth * 0.709, buttonHeight - buttonHeight * 0.265 + heightOffset)
		button:SetSize(innerWidth * 0.41, buttonHeight * 0.18)
		button:SetText("   " .. arguments[i * 2 - 1])
		button:SetFont("ixRedFactionRegular")
		button.Paint = function(panel, width, height)
			local isHovered = panel:IsHovered()

			if (!isHovered) then
				surface.SetDrawColor(Color(0, 0, 0, 150))
				surface.DrawRect(width * 0.16, height * 0.15, width - width * 0.2, height - height * 0.28)
			else
				surface.SetDrawColor(Color(255, 255, 255, 150))
				surface.SetMaterial(buttonMatSelectedBackground)
				surface.DrawTexturedRect(width * 0.16, height * 0.15, width - width * 0.2, height - height * 0.28)

				surface.SetDrawColor(Color(255, 255, 255, 150))
				surface.SetMaterial(buttonMatSelectedGlow)
				surface.DrawTexturedRect(width - width * 0.975, height - height * 1.1, 45 * scale, 70 * scale)
			end
		end
		button.OnCursorEntered = function(panel)
			surface.PlaySound("redfactionrp/menu/panel_highlight.wav")
		end
		button.DoClick = function(panel)
			surface.PlaySound("redfactionrp/menu/panel_button_click.wav")
			surface.PlaySound("redfactionrp/menu/sweep_in.wav")

			if (arguments[i * 2]) then
				arguments[i * 2]()
			end

			window:Remove()
		end

		heightOffset = heightOffset + buttonHeight * 0.207
	end

	window:MakePopup()
	window:DoModal()

	if (buttonCount == 0) then
		window:Remove()
		Error("Derma_Query: Created Query with no Options!?")

		return nil
	end

	return window
end
