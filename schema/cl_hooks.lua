
local cursorMat = Material("materials/redfactionrp/cursor.png")

function Schema:PostRenderVGUI()
	local cursorX, cursorY = gui.MousePos()
	if (cursorX == 0 and cursorY == 0) then return end -- We're tabbed out or not in a menu
	
	surface.SetDrawColor(color_white)
	surface.SetMaterial(cursorMat)
	surface.DrawTexturedRect(cursorX, cursorY, 50, 50)
end

function Schema:Think() -- Eh
	local hoveredPanel = vgui.GetHoveredPanel()
	if (!IsValid(hoveredPanel)) then return end

	hoveredPanel:SetCursor("blank")
end

function Schema:ForceDermaSkin()
	return "redfaction"
end

function Schema:ShouldHideBars()
	return true -- Health and armor refused to be removed individually, so stamina can go fuck itself I guess
end

function Schema:PopulateCharacterInfo(client, character, tooltip)
	if (client:IsRestricted()) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText("They have been tied up.")
		panel:SizeToContents()
	elseif (client:GetNetVar("tying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText("They are being tied up.")
		panel:SizeToContents()
	elseif (client:GetNetVar("untying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText("They are being untied.")
		panel:SizeToContents()
	end
end

function Schema:PopulateHelpMenu(tabs)
	tabs["voices"] = function(container)
		local classes = {}

		for k, v in pairs(Schema.voices.classes) do
			if (v.condition(LocalPlayer())) then
				classes[#classes + 1] = k
			end
		end

		if (#classes < 1) then
			local info = container:Add("DLabel")
			info:SetFont("ixSmallFont")
			info:SetText("You do not have access to any voice lines!")
			info:SetContentAlignment(5)
			info:SetTextColor(color_white)
			info:SetExpensiveShadow(1, color_black)
			info:Dock(TOP)
			info:DockMargin(0, 0, 0, 8)
			info:SizeToContents()
			info:SetTall(info:GetTall() + 16)

			info.Paint = function(_, width, height)
				surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", info), 160))
				surface.DrawRect(0, 0, width, height)
			end

			return
		end

		table.sort(classes, function(a, b) return a < b end)

		for _, class in ipairs(classes) do
			local category = container:Add("Panel")
			category:Dock(TOP)
			category:DockMargin(0, 0, 0, 8)
			category:DockPadding(8, 8, 8, 8)
			category.Paint = function(_, width, height)
				surface.SetDrawColor(Color(0, 0, 0, 66))
				surface.DrawRect(0, 0, width, height)
			end

			local categoryLabel = category:Add("DLabel")
			categoryLabel:SetFont("ixMediumLightFont")
			categoryLabel:SetText(class:upper())
			categoryLabel:Dock(FILL)
			categoryLabel:SetTextColor(color_white)
			categoryLabel:SetExpensiveShadow(1, color_black)
			categoryLabel:SizeToContents()
			category:SizeToChildren(true, true)

			for command, info in SortedPairs(self.voices.stored[class]) do
				local title = container:Add("DLabel")
				title:SetFont("ixMediumLightFont")
				title:SetText(command:upper())
				title:Dock(TOP)
				title:SetTextColor(ix.config.Get("color"))
				title:SetExpensiveShadow(1, color_black)
				title:SizeToContents()

				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(info.text)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			end
		end
	end
end

function Schema:BuildBusinessMenu()
	return false
end

function Schema:CanDrawAmmoHUD(weapon)
	return false
end

-- Dumb.
local armorPolyCords = {
	[0] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350},
		{x = 56, y = 228},
		{x = 56, y = 106},
		{x = 150, y = 56},
		{x = 300, y = 56},
		{x = 400, y = 106},
		{x = 400, y = 228}
	},
	[100] = {},
	["1"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350},
		{x = 56, y = 228},
		{x = 56, y = 106},
		{x = 150, y = 56},
		{x = 300, y = 56},
		{x = 400, y = 106}
	},
	["2"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350},
		{x = 56, y = 228},
		{x = 56, y = 106},
		{x = 150, y = 56},
		{x = 300, y = 56}
	},
	["3"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350},
		{x = 56, y = 228},
		{x = 56, y = 106},
		{x = 150, y = 56}
	},
	["4"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350},
		{x = 56, y = 228},
		{x = 56, y = 106}
	},
	["5"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350},
		{x = 56, y = 228}
	},
	["6"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400},
		{x = 56, y = 350}
	},
	["7"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400},
		{x = 150, y = 400}
	},
	["8"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350},
		{x = 300, y = 400}
	},
	["9"] = {
		{x = 228, y = 228},
		{x = 400, y = 228},
		{x = 400, y = 350}
	}
}

local armorLines = Material("redfactionrp/armor_lines.png")
local TEX_SIZE = 512
local tex = GetRenderTargetEx("RedFactionMaskRT", TEX_SIZE, TEX_SIZE, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888)
local mask = Material("redfactionrp/silhouette")
local outline = Material("redfactionrp/silhouette_outline.png", "smooth")
local myMat = CreateMaterial("RedFactionMaskRTMat", "UnlitGeneric", {
	["$basetexture"] = tex:GetName(),
	["$translucent"] = "1"
})

local function RenderMaskedRT()
	local healthMask = circles.New(CIRCLE_FILLED, ((TEX_SIZE / 2) * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth())), TEX_SIZE / 2, TEX_SIZE / 2)
	surface.SetDrawColor(255, 255, 0, 100)
	draw.NoTexture()
	healthMask()

	-- Draw the actual mask
	render.SetWriteDepthToDestAlpha(false)
		render.OverrideBlend(true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, BLENDFUNC_MIN)
			surface.SetMaterial(mask)
			surface.DrawTexturedRect(0, 0, TEX_SIZE, TEX_SIZE)
		render.OverrideBlend(false)
	render.SetWriteDepthToDestAlpha(true)
end

function Schema:HUDPaintBackground()
	local scrW, scrH = ScrW(), ScrH()
	local client = LocalPlayer()
	local weapon = client:GetActiveWeapon()
	local health = client:Health()
	local armor = client:Armor()

	-- AMMUNITION --
	if (weapon and weapon:IsValid() and weapon:Clip1() > 0) then
		local matrix = Matrix()
		local matrixCenter = Vector(scrW, 0)

		matrix:Translate(matrixCenter)
		matrix:Scale(Vector(0.75, 0.75, 0.75))
		matrix:Translate(-matrixCenter)

		cam.PushModelMatrix(matrix)
			surface.SetDrawColor(255, 255, 0, 50)
			surface.DrawOutlinedRect(scrW - 250, 50, 225, 100)
			surface.DrawRect(scrW - 375, 50, 125, 100)

			-- HALF-CIRCLE OUTLINE --
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.SetDrawColor(color_white)
			surface.DrawRect(1545, 50, 50, 100)

			local filledMask = circles.New(CIRCLE_FILLED, 48.5, 1545, 100)
			draw.NoTexture()
			filledMask()
			
			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local filledOutline = circles.New(CIRCLE_FILLED, 50, 1545, 100)
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 0, 50)
			filledOutline()

			render.SetStencilEnable(false)
			-- HALF-CIRCLE OUTLINE --

			-- HALF-CIRCLE --
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.SetDrawColor(color_white)
			surface.DrawRect(1545, 50, 50, 100)
			
			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local filledFinal = circles.New(CIRCLE_FILLED, 50, 1545, 100)
			draw.NoTexture()
			surface.SetDrawColor(0, 200, 0, 50)
			filledFinal()

			render.SetStencilEnable(false)
			-- HALF-CIRCLE --

			surface.DrawLine(1545, 50, 1545, 150)

			draw.SimpleText(weapon:Clip1(), "ixRedFactionAmmoHUD", scrW - 312, 96, Color(0, 150, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(client:GetAmmoCount(weapon:GetPrimaryAmmoType()), "ixRedFactionAmmoHUD", scrW - 137, 96, Color(175, 175, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.PopModelMatrix()
	end
	-- AMMUNITION --

	-- HEALTH --
	if (health > 0) then
		local matrix = Matrix()
		local matrixCenter = Vector(0, 0)

		matrix:Translate(matrixCenter)
		matrix:Scale(Vector(0.75, 0.75, 0.75))
		matrix:Translate(-matrixCenter)

		cam.PushModelMatrix(matrix)
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.SetDrawColor(color_white)
			surface.DrawRect(228, 228 - 30, 250, 60)

			local healthCircle = circles.New(CIRCLE_FILLED, 30, 228, 228)
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 255, 255)
			healthCircle()

			local healthCircle2 = circles.New(CIRCLE_FILLED, 30, 228 + 250, 228)
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 255, 255)
			healthCircle2()

			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			render.PushRenderTarget(tex)
			cam.Start2D()
				render.Clear(0, 0, 0, 0)
				RenderMaskedRT()
			cam.End2D()
			render.PopRenderTarget()

			-- Silhouette Circle Mask
			surface.SetDrawColor(color_white)
			surface.SetMaterial(myMat)
			surface.DrawTexturedRect(100, 100, TEX_SIZE / 2, TEX_SIZE / 2)
			
			-- Silhouette Outline
			surface.SetDrawColor(Color(0, 150, 0))
			surface.SetMaterial(outline)
			surface.DrawTexturedRect(100, 100, TEX_SIZE / 2, TEX_SIZE / 2)

			render.SetStencilEnable(false)

			-- LEFT HALF CIRCLE --
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.DrawRect(228, 228 - 30, 30, 60)

			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local healthCircle = circles.New(CIRCLE_FILLED, 30, 228, 228)
			draw.NoTexture()
			surface.SetDrawColor(health > 35 and Color(0, 200, 0, 50) or health > 15 and Color(255, 150, 0, 50) or Color(255, 0, 0, 50))
			healthCircle()

			render.SetStencilEnable(false)
			-- LEFT HALF CIRCLE --

			-- RIGHT HALF CIRCLE --
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.DrawRect(228 + 250 - 30, 228 - 30, 30, 60)

			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local healthCircle2 = circles.New(CIRCLE_FILLED, 30, 228 + 250, 228)
			draw.NoTexture()
			surface.SetDrawColor(0, 200, 0, 50)
			healthCircle2()

			render.SetStencilEnable(false)
			-- RIGHT HALF CIRCLE --

			-- HALF-CIRCLE OUTLINE LEFT --
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.DrawRect(228, 228 - 30, 30, 60)

			local healthCircle = circles.New(CIRCLE_FILLED, 28, 228, 228)
			healthCircle()

			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local healthCircle = circles.New(CIRCLE_FILLED, 30, 228, 228)
			draw.NoTexture()
			surface.SetDrawColor(0, 0, 0, 150)
			healthCircle()

			render.SetStencilEnable(false)
			-- HALF-CIRCLE OUTLINE LEFT --

			-- HALF-CIRCLE OUTLINE RIGHT --
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			surface.DrawRect(228 + 250 - 30, 228 - 30, 30, 60)

			local healthCircle2 = circles.New(CIRCLE_FILLED, 28, 228 + 250, 228)
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 0, 50)
			healthCircle2()

			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local healthCircle2 = circles.New(CIRCLE_FILLED, 30, 228 + 250, 228)
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 0, 50)
			healthCircle2()

			render.SetStencilEnable(false)
			-- HALF-CIRCLE OUTLINE RIGHT --
			
			-- LEFT BACKGROUND -- 
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			local circleMask = circles.New(CIRCLE_FILLED, 128, 228, 228)
			circleMask()
			
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			surface.SetDrawColor(255, 255, 0, 10)
			surface.DrawRect(230, 228 - 30, 128, 60)

			render.SetStencilEnable(false)
			-- LEFT BACKGROUND --

			-- RIGHT BACKGROUND -- 
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			local circleMask = circles.New(CIRCLE_FILLED, 128, 228, 228)
			circleMask()
			
			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(350, 228 - 30, 128, 60)

			render.SetStencilEnable(false)
			-- RIGHT BACKGROUND --

			surface.SetDrawColor(0, 0, 0, 150)
			-- Up Black
			surface.DrawLine(228, 228 - 30, 350, 228 - 30)
			surface.DrawLine(228, 228 - 29, 350, 228 - 29)
			
			-- Down Black
			surface.DrawLine(228, 228 + 30, 350, 228 + 30)
			surface.DrawLine(228, 228 + 29, 350, 228 + 29)
			
			surface.SetDrawColor(255, 255, 0, 50)
			-- Up Yellow
			surface.DrawLine(350, 228 - 30, 480, 228 - 30)
			surface.DrawLine(350, 228 - 29, 480, 228 - 29)
			
			-- Down Yellow
			surface.DrawLine(350, 228 + 30, 480, 228 + 30)
			surface.DrawLine(350, 228 + 29, 480, 228 + 29)

			-- CIRCLE OUTLINE -- 
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			local circleMask = circles.New(CIRCLE_FILLED, 126.5, 228, 228)
			circleMask()
			
			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local circleOutline = circles.New(CIRCLE_FILLED, 128, 228, 228)
			surface.SetDrawColor(Color(255, 255, 0, 50))
			draw.NoTexture()
			circleOutline()

			render.SetStencilEnable(false)
			-- CIRCLE OUTLINE --

			-- ARMOR BARS -- 
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			local circleMask = circles.New(CIRCLE_FILLED, 128, 228, 228)
			circleMask()
			
			draw.NoTexture()
			surface.SetDrawColor(color_white)
			surface.DrawPoly(armorPolyCords[armor] and armorPolyCords[armor] or armor <= 10 and armorPolyCords["1"] or armorPolyCords[tostring(armor)[1]])
			surface.DrawRect(350, 228 - 30, 50, 60)

			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local circleOutline = circles.New(CIRCLE_FILLED, 170, 228, 228)
			surface.SetDrawColor(Color(0, 200, 0, 50))
			draw.NoTexture()
			circleOutline()

			render.SetStencilEnable(false)
			-- ARMOR BARS --

			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(armorLines)
			surface.DrawTexturedRectRotated(228, 228, 345, 345, 0)

			-- ARMOR OUTLINE -- 
			render.SetStencilWriteMask(0xFF)
			render.SetStencilTestMask(0xFF)
			render.SetStencilReferenceValue(0)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			render.ClearStencil()

			render.SetStencilEnable(true)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_NEVER)
			render.SetStencilFailOperation(STENCIL_REPLACE)
			
			local circleMask = circles.New(CIRCLE_FILLED, 169, 228, 228)
			circleMask()

			surface.DrawRect(350, 228 - 30, 128, 60)
			
			render.SetStencilReferenceValue(0)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilFailOperation(STENCIL_KEEP)

			local circleOutline = circles.New(CIRCLE_FILLED, 170, 228, 228)
			surface.SetDrawColor(Color(255, 255, 0, 50))
			draw.NoTexture()
			circleOutline()

			render.SetStencilEnable(false)
			-- ARMOR OUTLINE --

			draw.SimpleText(health, "ixRedFactionVitalsHUD", 295, 226, Color(0, 150, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(armor, "ixRedFactionVitalsHUD", 415, 226, Color(175, 175, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			-- HEALTH --
		cam.PopModelMatrix()
	end
end
