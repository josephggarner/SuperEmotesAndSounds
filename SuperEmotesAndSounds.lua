-- Author      : khris(chris) Xo-Malfurion
--SuperEmotes works in tandem with ReactiveEmotes.
--SuperEmotes allows an in game soundboard through use of custom emotes.
local superframe = SuperEmotesFrame

superframe:Hide()
superframe:SetScale(1)
superframe:SetBackdrop( {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", 
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
});

--###Slash command Handler###--
SLASH_SES1, SLASH_SES2 = '/ses', '/superemotes';
local commandlist = {
	 "help", "list" --, "fav", "listfavs", "toggle", "listfunctions", "rand"
}
local helplist = {
	{ "++----------------------------", "++------------------------------++" },
	{ "--", "Invoke SES with '/ses', '/superemotes'" },
    { "--/ses help", "You're here!" },
    --{ "--/ses rand", "Performs a random Emote. NYI" },
	{ "--/ses 'emote'", "Plays the assigned Audio Emote." },
    { "--/ses list", "Lists available Audio emotes." },
	--{ "--/ses fav 'emote' 'customcommand'", "Set an emote to a custom command. NYI" },
	--{ "--/ses listfavs", "Lists favorite emotes. NYI" },
	--{ "--/ses toggle 'function'", "Turns on/off function. NYI" },
	--{ "--/ses listfunctions", "Lists functions. NYI" }
	--{"--/ses opt","Opens options in Interface Panel"}
}
local function handler(msg, editBox) 
		local _, _, cmd, argsString = string.find(msg, "%s?(%w+)%s?(.*)")	--disect the slashcommand call into usable parts
		local args={}														--create args table

		if argsString ~= nil and argsString ~= "" then	--process args into a table
			for word in argsString:gmatch("%S+") do table.insert(args, word) end	  
		end
		if SEScheckCommands(cmd) > 0 then				--check command table for existing command that matches
			--#############COMMANDS BELOW##############--
			---------------------------
			if cmd =='help' then
				for i=1, #helplist do
					if i < 3 then 
						print(helplist[i][1], helplist[i][2])
					else
						print(helplist[i][1], "-", helplist[i][2])
					end
				end					-- Print Helplist to chat
			end
			----------------------------
			if cmd =='list' then						-- Show the audio emote window
				superframe:Show();
			end
			----------------------------

			--#############COMMANDS ABOVE##############--
		else --check if emote command
			local innerTable = SEScheckEmotes(cmd)
			if innerTable > 0 then
				emotemsg = "EMOTE-"..innerTable
				broadcastSES(emotemsg)
				print("Playing Emote.")
				SESPlayEmoteSound(SESEmotesLIB,innerTable)
			end
		end
end

SlashCmdList["SES"] = handler;
function SEScheckCommands(cmd)
       local index = 1;
       while commandlist[index] do
               if ( cmd == commandlist[index] ) then
                       return 1;
               end
               index = index + 1;
       end
       return 0;
end
function SEScheckEmotes(cmd)
		if cmd == nil then return 0 end;
       local index = 1;
       while index <= getn(SESEmotesLIB) do
               if ( cmd == SESEmotesLIB[index][1] ) then
                       return index;
               end
               index = index + 1;
       end
	   -- if not found in emote library return 0
       return 0;
end
--############################--

-- Event watchers
local events =  {};			--watches player events
local SESevents =  {};		--watches SESevents
local AddonEvents =  {};	--watches addon events that trigger SESevents

local EventListener = CreateFrame("FRAME")		--SOLO events
local SESeventListener = CreateFrame("FRAME")	--SHARED events
local SESAddonListener = CreateFrame("FRAME")	--Addon events
--Local Variables
local broadcastEnabled = true;
local debugmode = false;
--#####SOLO EVENTS######
--		SOLO EVENTS	- These are what you do when you trigger a certain event
--######################
local playername = GetUnitName("player");
local servername = GetRealmName("player");
local fullname = playername.."-"..servername:gsub("%s", "");

	function events:PLAYER_ENTERING_WORLD(...)
		local event = "PLAYER_ENTERING_WORLD"
		if debugmode then print("I entered the world") end
		G_SES_RE:QueueEmote("/hi","none")	--call queue emote function in ReactiveEmotes
		broadcastSES(event)
	end
	-------------------------------------
	function events:PLAYER_LEAVING_WORLD(...)
		if debugmode then print("I left the world") end
		G_SES_RE:QueueEmote("/bye","none")
		--SESPlaySoundFile(SESTriggersLIB.Leave)
	end
	------------------------------------
	function events:PLAYER_DEAD(...)		
		local event = "PLAYER_DEAD"
		if debugmode then print(event) end
		--G_SES_RE:QueueEmote("/hi","target")	--call queue emote function in ReactiveEmotes
		do	--Send Emote and Sounds
		local emoteQueueTable = {}
			emoteQueueTable = {"/point","/laugh","/cry"}
			G_SES_RE:QueueEmote(emoteQueueTable[math.random(1, #emoteQueueTable)],"none")
		end --Send Emote and Sounds
		SESPlaySoundFile(SESTriggersLIB.Triggered)
		broadcastSES(event)
	end
	-----------------------TEMPLATE-----------------------------
	--function events:TEMPLATE_TEMP(...)								--SEE BLIZZ API GUIDE FOR ARGs
	--	--if debugmode then print(arg1.." "..playername) end			--necessary in some functions
	--	--if arg1 ~= "player" then return end							--Avoid this event when you yourself do it
	--	local event = "PLAYER_DEAD"										-- The events string to pass to broadcast function
	--	if debugmode then print(event) end
		--do	--Send Emote and Sounds
		--	local emoteQueueTable = {}
		--	emoteQueueTable = {"/point","/laugh","/cry"}
		--	G_SES_RE:QueueEmote(emoteQueueTable[math.random(1, #emoteQueueTable)],"none")	--call queue emote function in ReactiveEmotes
		--end --Send Emote and Sounds
	--	SESPlaySoundFile(SESTriggersLIB.Triggered)						--Play a sound file, random or specific
	--	broadcastSES(event)												--Broadcasts to other players the event
	--end
	---------------------------------------------------------------
--#############LISTENERS SOLO#######################--
	EventListener:SetScript("OnEvent", function(self, event, ...)
		events[event](self, ...); -- call one of the functions above
	end);
	for k, v in pairs(events) do
		EventListener:RegisterEvent(k); -- Register all events for which handlers have been defined
	end
--###############SOLO END###########################--
--################broadcast - broadcast your solo events to others################
function broadcastSES(event)
	if broadcastEnabled ~= true then return end						--if broadcast is turned off don't share
	if IsInGroup() then
			C_ChatInfo.SendAddonMessage("SES6969", event, "RAID");
		else if debugmode then
			C_ChatInfo.SendAddonMessage("SES6969", event, "GUILD");
		end 
	end
end
--########################
--		SHARED EVENTS	-- Your response to solo events that get broadcasted
--########################

if broadcastEnabled == true then
C_ChatInfo.RegisterAddonMessagePrefix("SES6969")	--registers the chat traffic from this addon to be received
local SESsender;
	function AddonEvents:CHAT_MSG_ADDON(prefix, message, channel, sender)
		if prefix ~= "SES6969" then return end	--ignore if not an SES message
		if sender == fullname then return end	--ignore if from yourself
		local msg = SESnamesplit(message)[1]
		local emoteTableLoc= tonumber(SESnamesplit(message)[2])
		if setContains(SESevents,message) == nil and msg ~= "EMOTE" then print("Event not found, and no EMOTE string found. Please report this bug#: 001-No Valid Events") return end	
		if debugmode then 
			print(prefix..", "..message..", "..channel..", "..sender)	--event..", "..prefix..", "..message..", "..channel..", "..sender
			print(fullname)
			print(setContains(SESevents,message))
		end
		SESsender = SESnamesplit(sender)[1]

		if msg ~= "EMOTE" then
		SESevents[message](self); -- call one of the functions
		else
			if SESEmotesLIB[emoteTableLoc] ~= nil then
			SESPlayEmoteSound(SESEmotesLIB,emoteTableLoc) -- call emote sound
			end
		end
	end

		function setContains(SESevents, event)
			return SESevents[event] ~= nil
		end
--#################################
-- RESPONSES TO EVENTS SENT BY OTHERS--------------
	function SESevents:PLAYER_ENTERING_WORLD(...)		-- TODO Fix so this doesn't interrupt casting (summoning stone)
		local event = "PLAYER_ENTERING_WORLD"
		if debugmode then print("SES_"..event) end
		local emoteQueueTable = {}
			emoteQueueTable = {"thanks %N for finally joining the group.","licks %N.","/taunt","/whistle","/greet","/flex"}
		G_SES_RE:QueueEmote(emoteQueueTable[math.random(1, #emoteQueueTable)],SESsender)
	end
	----------------------
	function SESevents:PLAYER_DEAD(...)					-- When another player dies
		local event = "PLAYER_DEAD"
		if debugmode then print("SES_"..event.."called.".." Target is:"..SESsender) end
		local emoteQueueTable = {}
			emoteQueueTable = {
			"/point",
			"/laugh",
			"/cry",
			"teabags %N.",
			"/mourn",
			"/pity",
			"/violin",
			"bumped into %N's dead body. Oops!",
			"yells at %N for sleeping on the job!",
			"asks %N if they've ever tried -\"Not Dying\""}
		G_SES_RE:QueueEmote(emoteQueueTable[math.random(1, #emoteQueueTable)],SESsender)
	end
	------------------------TEMPLATE------------------------------------------
	--function SESevents:TEMPLATE_TEMP(...)												--Use BLIZZ API for event name and args
	--	local event = "PLAYER_DEAD"														--Only used for debugging in this context
	--	if debugmode then print("SES_"..event.."called.".." Target is:"..SESsender) end	--Debugging
	--	local emoteQueueTable = {}														--Create table to hold emote responses
	--		emoteQueueTable = {"/point","/laugh","/cry"}								--put emotes into the emotetable
	--	local random_emote = math.random(1, #emoteQueueTable)							--
	--	G_SES_RE:QueueEmote(emoteQueueTable[math.random(1, #emoteQueueTable)],SESsender)
	--end
	--------------------------------------------------------------------------------
--####Listeners	############

	----register the above events to frame
		SESAddonListener:SetScript("OnEvent", function(self, event, ...)
		AddonEvents[event](self, ...); -- call one of the functions above
		end);
		SESAddonListener:RegisterEvent("CHAT_MSG_ADDON"); -- Register the ADDON CHAT to this frame
		
		for k, v in pairs(SESevents) do
		SESeventListener:RegisterEvent(k); -- Register all events for which handlers have been defined
		end
end
--######SHARED END########

--#############STRING SPLIT FUNCTION FOR SERVER NAMES####################--
function SESnamesplit (name, sep)
        if sep == nil then
                sep = "-"
        end
        local t={}
        for str in string.gmatch(name, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

--#############Play random sound file from Dir####################--
function SESPlaySoundFile(libTable) 
	if libTable == nill then print("There was an error with SES, aborting play.") return end
	PlaySoundFile(libTable[random(1,#libTable)])
end
--#############Play sound file from Dir####################--
function SESPlayEmoteSound(LibraryTable,InnerTable) 
	if LibraryTable == nill then print("There was an error with SES, aborting play.") return end
	if InnerTable == nill then print("There was an error with SES, aborting play.") return end
	-- can make libraryTable a variable so we can have mroe libraries than SESEmotesLIB
	PlaySoundFile(SESEmotesLIB[tonumber(InnerTable)][2])
end
