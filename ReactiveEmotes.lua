-- Author      : khris(chris) Xo-Malfurion
--SuperEmotes works in tandem with ReactiveEmotes.
--ReactiveEmotes ..react.. to other emotes by queue'ing up emote responses.
--Queue up emotes from other addons with 'G_SES_RE:QueueEmote(emote,target)' command.

local MinDelay=1;--         Response delay in seconds.
local Cooldown=3;--         Minimal time between queued emotes in seconds.
local defaultTriggerCD=20;
local lastDefaultTriggerTime=GetTime();
local CrossFactionEmote="FORTHEHORDE";-- Emote sent to cross-faction players.
local playername = GetUnitName("player");
local servername = GetRealmName("player");
local fullname = playername.."-"..servername;
local lastemote=GetTime();
local NamePattern="%%N";--  Pattern for string.gsub() to replace with the sender's name
local PlayerGUID;-- We'll store this later when it's available
local PlayerFaction=UnitFactionGroup("player");--   This should be available on load
local FactionRaces={
	--Pandarens are abominations
	--Alliance
    Dwarf			 ="Alliance";
    Draenei			 ="Alliance";
    Gnome			 ="Alliance";
    Human			 ="Alliance";
    NightElf		 ="Alliance";
    Worgen			 ="Alliance";
	VoidElf			 ="Alliance";
	LightforgedDraenei="Alliance";
	DarkIronDwarf	="Alliance";
	KulTiran		="Alliance";
	Mechagnome		="Aliiance";
	--Horde
    BloodElf		 ="Horde";
    Orc				 ="Horde";
    Goblin			 ="Horde";
    Scourge			 ="Horde";
    Tauren			 ="Horde";
    Troll			 ="Horde";
	ZandalariTroll   ="Horde";
	Nightborne		 ="Horde";
	Vulpera			 ="Horde";
	HighmountainTauren="Horde";
	MagharOrc		="Horde";
}				--EDIT THIS TO ADD NEW ALLIED RACES AS AVAILABLE

--########--TRIGGERS / RESPONSES-------EDIT/ADD TRIGGERS/RESPONSES HERE---------------------------######--
--##---##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##
local Triggers={--      This table contains the trigger phrases and reply type/messages.
	
    ["licks you."]={"COWER","CRY","GIGGLE"};									--Don't use cower as a trigger so that chains end here
    ["thinks you are a sexy devil."]={"gasps in shock at %N!"};
    ["dances with you."]={"DANCE", "thinks %N needs to go watch Footloose.", "has never seen moves like %N's before!", "asks if %N knows Kevin Bacon."};
	["pets you."]={"BARK","PURR","MOO"};
	["eyes you up and down."]={"FART"};
	["flirts with you."]={"GLOAT", "READY", "POUNCE","VETO"};
	["glares angrily at you."]={"GUFFAW", "JK"};
	["roars at you."]={"BOGGLE", "YAWN"};

}
local defaultTrigger = "SHRUG";
--########--TRIGGERS / RESPONSES-------EDIT/ADD TRIGGERS/RESPONSES ABOVE---------------------------######--
--##---##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##-##--##--##

local debugmode = false;
-----------Frames&EventListener-----------------------
local SES_RE=CreateFrame("Frame");
	G_SES_RE=CreateFrame("Frame");
SES_RE:RegisterEvent("CHAT_MSG_TEXT_EMOTE");-- Built-in emotes
SES_RE:RegisterEvent("CHAT_MSG_EMOTE");--  Custom emotes
 
SES_RE.ResponseQueue={};
SES_RE.Recycled={};

local tbl= {};
 --Function to add responses to the queue
function SES_RE:QueueEmote(emote,target)
	--print(emote.." queued. Target="..target)
--  Get a table from our recycled tables or create a new one
    if table.getn(tbl) > 0 then
	table.wipe(tbl)
	end
 
--  Setup data and insert
    tbl[1]=emote
	tbl[2]=target
	tbl[3]=GetTime()
				--if tbl[1] then print("tbl1:"..tbl[1]) else print("tbl[1] is nil") return end
				--if tbl[2] then print("tbl2:"..tbl[2]) else print("tbl[2] is nil") return end
				--if tbl[3] then print("tbl3:"..tbl[3]) else print("tbl[3] is nil") return end
    table.insert(self.ResponseQueue,tbl);
	--print("# in response Queue: "..#self.ResponseQueue)
end

 --listens to messages and determines how to respond if at all
SES_RE:SetScript("OnEvent",function(self,event,...)
--  We'll tag one of these events to update our GUID when it's needed
	if not PlayerGUID then PlayerGUID=UnitGUID("player"); end
	local now=GetTime();	
    local guid,msg,sender=select(12,...),...;
	local response=Triggers[msg:match("^%S+%s*(.-)$")];
		
	if guid~=PlayerGUID then--  Don't respond to emotes the player sent.

		if FactionRaces[select(4,GetPlayerInfoByGUID(guid)) or ""]==PLAYER_FACTION then
--          Queue cross-faction response
			if select(4,GetPlayerInfoByGUID(guid)) == "Pandaren" then	--Pandarens are abominations
				self:QueueEmote("/gasp",sender);
				return
			end
            self:QueueEmote(CrossFactionEmote,sender);
			else if response == nil then
				local heardname
				if string.match(msg, playername) then heardname=true end	-- if name heard acknowledge
				if string.match(msg, fullname) then heardname=true end		-- if name+server name heard acknowledge
				if string.match(msg, "you") then heardname=true end			-- if 'you' heard acknowledge 
				if now - lastDefaultTriggerTime < defaultTriggerCD then return end
				response = defaultTrigger
				sender = "none"
				if heardname == true then
					lastDefaultTriggerTime=GetTime();
					self:QueueEmote(response,sender);
				end
			elseif type(response)=="table" then	
				--if response[1] then print("response1:"..response[1]) else print("Response[1] is nil")  end
				--if response[2] then print("response2:"..response[2]) else print("Response[2] is nil")  end
				--if response[3] then print("response3:"..response[3]) else print("Response[3] is nil")  end
				--print("response is a table: "..type(response))
				--G_SES_RE:QueueEmote(emoteQueueTable[math.random(1, #emoteQueueTable)],SESsender)
				--for i,j in ipairs(response) do self:QueueEmote(j,sender); 
				--	--print("i="..i..", j ="..j.." , Sender="..sender)
				--end
				SES_RE:QueueEmote(response[math.random(1, #response)],sender)
	
			elseif type(response)=="string" then--   Handle single (shouldnt trigger)
				--print("response is a string?!@?")
                self:QueueEmote(response,sender);
			end		
		end       
	end
end)

--runs all Queued commands
SES_RE:SetScript("OnUpdate",function(self)
	local playSuccess = false;
    local now=GetTime();
	if self.ResponseQueue[1] == nil then return end
--  Check against our global cooldown and if we have messages waiting
	if table.getn(self.ResponseQueue)>0 and now-lastemote>Cooldown then   
		--print("Response Que not empty & offcd")
		--if now-lastemote>Cooldown then 
			--print("offcd")
			--if #self.ResponseQueue>0 then
			--if ResponseQueue[1] == nil then return end

			local ptr=self.ResponseQueue[1];

			if ptr[3] == nil then 
				--print("ptr3 was nill removing nil")
				table.remove(self.ResponseQueue,1); 
				return 
			end
			--print("ptr set")
			--print("time now is:"..now)
			--print(ptr[1]..":Emote ,"..ptr[2]..":Target ,  Time queued:"..ptr[3])
			--print("delay: "..MinDelay)
		
			if now-ptr[3]>MinDelay then--   Check for individual delay
				--print("off cd, continue")
	--          First attempt to check if it's a slash command for an emote
				local token=hash_EmoteTokenList[ptr[1]:upper()];
				--print("check token against emote list. Searched for: "..ptr[1]:upper())
	--          If not, check if it's an actual token
				if not token then
					--print("not token")
					for i,j in pairs(hash_EmoteTokenList) do
						--print(i..","..j)	--print entire emote table
						if ptr[1]:upper()==j then token=j;
							--print("Found it. "..ptr[1]:upper().." = j ="..j)
							break; end
					end
				end
			
	--          Token should be detected now if it's being referenced
				if token then
					--print("found token, sending normal emote")
					DoEmote(token,ptr[2]);--                Perform token emote with no target
					playSuccess = true;
					else
						--print("No token found in hash list, sending custom emote")
						SendChatMessage(ptr[1]:gsub(NamePattern,ptr[2]),"EMOTE");-- Custom emote
						playSuccess = true;
					end	
				lastemote=now;--    Reset our timestamp
				--cleanup
				if playSuccess == true then 
					--print("before remove "..self.ResponseQueue[1][1])
					table.remove(self.ResponseQueue,1);--       Shift the queue
					self.ResponseQueue = self.ResponseQueue
					--print("after remove "..self.ResponseQueue[1][1])
					--print("# in response Queue after wipe: "..table.getn(self.ResponseQueue))
					table.wipe(ptr);--  Clean and recycle table
					--print("playSuccess was:... ")
					--print(playSuccess)
					else
					--print("playSuccess was:... ")
					--print(playSuccess)
				end
			end
			
			
		--end
	end
	
end);

--~###GLOBAL CALLS###~--
function G_SES_RE:QueueEmote(emote,target)
	SES_RE:QueueEmote(emote,target)
end