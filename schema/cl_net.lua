
net.Receive("ixREDFrequency", function()
	local oldFrequency = net.ReadString()

	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)

net.Receive("ixCharacterAuthedRED", function()
	local panel = ix.gui.characterMenu

	local indices = net.ReadUInt(6)
	local charList = {}

	for _ = 1, indices do
		charList[#charList + 1] = net.ReadUInt(32)
	end

	ix.characters = charList

	if (!IsValid(panel)) then return end

	panel.newCharacterPanel:Toggle(false, 0, function()	
		panel.loadCharacterPanel:Toggle(true, 0.5)
	end)
end)

net.Receive("ixREDCharCreationFailed", function()
	local panel = ix.gui.characterMenu

	if (!IsValid(panel)) then return end

	local error = net.ReadString()
	local argument = net.ReadString()

	Derma_Query(argument and L(error, argument) or L(error), "ERROR", "OK")
end)

net.Receive("ixREDPlaySound", function()
	local sound = net.ReadString()

	surface.PlaySound(sound)
end)

net.Receive("ixREDDamageEffect", function()
	if (!IsValid(ix.gui.damageEffect)) then
		ix.gui.damageEffect = vgui.Create("DPanel")
		ix.gui.damageEffect:SetSize(ScrW(), ScrH())
		ix.gui.damageEffect:Center()
		ix.gui.damageEffect:SetAlpha(0)

		ix.gui.damageEffect.Paint = function(this, width, height)
			surface.SetDrawColor(255, 0, 0)
			surface.DrawRect(0, 0, width, height)
		end
	end

	ix.gui.damageEffect:SetAlpha(255)
	ix.gui.damageEffect:AlphaTo(0, 0.5, 0)
end)
