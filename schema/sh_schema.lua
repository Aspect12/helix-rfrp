
Schema.name = "Red Faction RP"
Schema.author = "Aspect™"
Schema.description = "A roleplaying Schema based on Red Faction 1."

ix.util.Include("libs/thirdparty/cl_circles.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_net.lua")
ix.util.Include("cl_schema.lua")
ix.util.Include("cl_skin.lua")
ix.util.Include("sh_chat_classes.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sh_configs.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sh_voices.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sv_net.lua")
ix.util.Include("sv_schema.lua")

-- Overriding to make it networked
ix.char.RegisterVar("lastJoinTime", {
	field = "last_join_time",
	fieldType = ix.type.number,
	bNoDisplay = true,
	bNotModifiable = true,
	bSaveLoadInitialOnly = true
})

-- Literally just string.find
function Schema:IsRank(target, rank)
	local name = isstring(target) and target or target:GetName()

	return string.find(name, rank)
end
