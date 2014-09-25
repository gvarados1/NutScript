PLUGIN.name = "Chatbox"
PLUGIN.author = "Chessnut"
PLUGIN.desc = "Adds a chatbox that replaces the default one."

if (CLIENT) then
	function PLUGIN:createChat()
		self.panel = vgui.Create("nutChatBox")
	end

	function PLUGIN:InitPostEntity()
		self:createChat()
	end

	function PLUGIN:PlayerBindPress(client, bind, pressed)
		bind = bind:lower()

		if (bind:find("messagemode") and pressed) then
			self.panel:setActive(true)

			return true
		end
	end

	function PLUGIN:HUDShouldDraw(element)
		if (element == "CHudChat") then
			return false
		end
	end

	if (IsValid(PLUGIN.panel)) then
		PLUGIN.panel:Remove()
		PLUGIN:createChat()
	end

	chat.nutAddText = chat.nutAddText or chat.AddText

	local PLUGIN = PLUGIN

	function chat.AddText(...)
		if (IsValid(PLUGIN.panel)) then
			PLUGIN.panel:addText(...)
		end

		chat.nutAddText(...)
	end
else
	netstream.Hook("msg", function(client, text)
		if ((client.nutNextChat or 0) < CurTime()) then
			hook.Run("PlayerSay", client, text)
			client.nutNextChat = CurTime() + math.max(#text / 250, 0.4)
		end
	end)
end