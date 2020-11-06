-- Author      : khris(chris) Xo-Malfurion
--SuperEmotes works in tandem with ReactiveEmotes."]={};
--ReactiveEmotes ..react.. to other emotes by queue'ing up emote responses."]={};
--Queue up emotes from other addons with 'G_SES_RE:QueueEmote(emote,target)' command."]={};

local MinDelay=1;--         Response delay in seconds."]={};
local Cooldown=3;--         Minimal time between queued emotes in seconds."]={};
local defaultTriggerCD=20;
local emoteCounter = 0;
local MAX_EMOTES_CHAIN = 4;
local lastDefaultTriggerTime=GetTime();
local CrossFactionEmote="FORTHEHORDE";-- Emote sent to cross-faction players."]={};
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
local Triggers={--      This table contains the trigger phrases and reply type/messages."]={};

--["is so bashful...too bashful to get your attention."]={};
--["begs you.  How pathetic."]={};
--["blows you a kiss."]={};
--["blushes at you."]={};
--["boggles at you."]={};
--["bows before you."]={};
--["applauds at you.  Bravo."]={};
--["waves goodbye to you.  Farewell."]={};
--["applauds at you.  Bravo."]={};

 

	--ANIMATED EMOTES
	--Angry & Mad
    ["fist in anger at you."]={"GASP", "APOLOGIZE", "GROVEL", "PLEAD"};
    --Applaud, Applause & Bravo
    --["applauds at you"]={"THANK", "BOW", "CURTSEY"};
	["applauds at you"]={"Angry"};
    --Attacktarget
    ["tells everyone to attack you."]={"SURRENDER", "ROAR", "TAUNT","CRY"};
    --Bashful
    ["is so bashful...too bashful to get your attention."]={"HUG","INTRODUCE","FIDGET"};
    --Beg
    ["begs you.  How pathetic."]={"MOAN","SHOO","SIGH","DOH"};
    --Blow & Kiss
    ["blows you a kiss."]={"NOSEPICK","KISS","FLIRT","BLUSH","SLAP","PURR"};
	--Blush
	["blushes at you."]={};
	--Boggle
	["boggles at you."]={};
	--Bow
	["bows before you."]={};
	--Bye, Goodbye & Farewell
	["waves goodbye to you.  Farewell!"]={};
	--Cackle
	["cackles maniacally at you."]={};
	--Charge (No Target Emote)
	["starts to charge."]={};
	--Cheer
	["cheers at you."]={};
	--Chew, Eat & Feast
	["begins to eat rations in front of you."]={};
	--Chicken, Flap & Strut
	--With arms flapping, %Name
	["struts around you.  Cluck, Cluck, Chicken."]={};
	--Chuckle
	["chuckles at you."]={};
	--Clap
	["claps excitedly for you."]={};
	--Commend
	["commends you on a job well done."]={};
	--Confused
	["looks at you with a confused look."]={};
	--Congrats & Congratulate
	["congratulates you."]={};
	--Cry, Sob & Weep
	["cries on your shoulder."]={};
	--Curious
	["is curious what you are up to."]={};
	--Curtsey
	["curtsies before you."]={};
	--Dance
    ["dances with you."]={"DANCE", "thinks %N needs to go watch Footloose.", "has never seen moves like %N's before!", "asks if %N knows Kevin Bacon."};
	--Drink & Shindig
	["raises a drink to you.  Cheers."]={};
	--Flee
	["yells for you to flee."]={};
	--Flex & Strong
	["flexes at you.  Oooooh so strong."]={};
	--Flirt
	["flirts with you."]={"GLOAT", "READY", "POUNCE","VETO"};
	--Followme
	["motions for you to follow."]={};
	--Gasp
	["gasps at you."]={};
	--Giggle
	["giggles at you."]={};
	--Gloat
	["gloats over your misfortune."]={};
	--Golfclap
	["claps for you, clearly unimpressed."]={};
	--Greet & Greetings
	["greets you warmly."]={};
	--Grovel & Peon
	["grovels before you like a subservient peon."]={};
	--Guffaw
	["takes one look at you and lets out a guffaw."]={};
	--Hail
	["hails you."]={};
	--Healme
	["calls out for healing."]={};
	--Hello & Hi
	["greets you with a hearty hello."]={};
	--Helpme (No Target Emote)
	["cries out for help."]={};
	--Incoming
	["points you out as an incoming enemy."]={};
	--Insult
	["thinks you are the son of a motherless ogre."]={};
	--Kneel
	["kneels before you."]={};
	--Lay, Laydown, Lie & Liedown
	["lies down before you."]={};
	--Lol
	["laughs at you."]={};
	--Lost
	["wants you to know that he is hopelessly lost."]={};
	--Mourn
	--In quiet contemplation, %Name
	["mourns your death."]={};
	--Nod & Yes
	["nods at you."]={};
	--OOM
	["is low on mana."]={};
	--Openfire
	["orders you to open fire."]={};
	--Plead
	["pleads with you."]={};
	--Point
	["points at you."]={};
	--Ponder
	["ponders your actions."]={};
	--Pray
	["says a prayer for you."]={};
	--Puzzled
	["puzzled by you. What are you doing."]={};
	--Question
	["questions you."]={};
	--Rasp & Rude
	["makes a rude gesture at you."]={};
	--Roar
	["roars with bestial vigor at you.  So fierce!"]={"BOGGLE", "YAWN"};
	--Rofl
	["rolls on the floor laughing at you."]={};
	--Salute
	["salutes you with respect."]={};
	--Shrug (Default Reply, do not react)
	--["shrugs at you.  Who knows."]={};
	--Shy
	["smiles shyly at you."]={};
	--Sleep (No Target Emote)
	["falls asleep. Zzzzzzz."]={};
	--Surrender
	["surrenders before you.  Such is the agony of defeat..."]={};
	--Talk
	["wants to talk things over with you."]={};
	--Talkex
	["talks excitedly with you."]={};
	--Talkq
	["questions you."]={};
	--Taunt
	["makes a taunting gesture at you. Bring it."]={};
	--Victory
	["basks in the glory of victory with you."]={};
	--Violin
	["plays the world's smallest violin for you."]={};
	--Wave
	["waves at you."]={};
	--Welcome
	["welcomes you."]={};

	--NON-ANIMATED EMOTES
	--Agree
	--Amaze
	--Apologize
	--Bark
	--Beckon
	--Belch
	--Bite
	--Bleed
	--Blink
	--Blood
	--Bonk
	--Bored
	--Bounce
	--BRB
	--Burp
	--Calm
	--Cat
	--Catty
	--Cold
	--Comfort
	--Cough
	--Cower
	--Crack
	--Cringe
	--Cuddle
	--Disappointed
	--Doh
	--Doom
	--Drool
	--Duck
	--Eye
	["eyes you up and down."]={"FART"};
	--Fart
	--Fear
	--Fidget
	--Flop
	--Food
	--Frown
	--Gaze
	--Glad
	--Glare
	["glares angrily at you."]={"GUFFAW", "JK"};
	--Grin
	--Groan
	--Happy
	--Hug
	--Hungry
	--Impatient
	--Introduce
	--JK
	--Knuckles
	--Lavish
	--Lick
	["licks you."]={"COWER","CRY","GIGGLE"};
	--Listen
	--Massage
	--Moan
	--Mock
	--Moon
	--No
	--Nod
	--Nosepick
	--Panic
	--Pat
	--Peer
	--Pest
	--Pet
	["pets you."]={"BARK","PURR","MOO"};
	--Pick
	--Pity
	--Pizza
	--Poke
	--Pounce
	--Praise
	--Purr
	--Raise
	--Rdy
	--Ready
	--Rear
	--Scratch
	--Sexy
	["thinks you are a sexy devil."]={"gasps in shock at %N!"};
	--Shake
	--Shimmy
	--Shiver
	--Shoo
	--Sigh
	--Slap
	--Smell
	--Smirk
	--Snarl
	--Snicker
	--Sniff
	--Snub
	--Soothe
	--Sorry
	--Spit
	--Spoon
	--Stare
	--Stink
	--Surprised
	--Tap
	--Tease
	--Thank
	--Thanks
	--Thirsty
	--Threat
	--Tickle
	--Threaten
	--Tired
	--TY
	--Veto
	--Volunteer
	--Whine
	--Whistle
	--Wicked
	--Wickedly
	--Work
	--Wrath
	--Yawn

	--NO MESSAGE EMOTES
	--Sit
	--Train
}
local pandarenTriggers = {"/gasp", "/puzzled", "/question", "/drool", "/panic", "/shoo"};
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

function findEmoteIndex(msg)
	for key, value in pairs(Triggers) do
		local found = string.find(msg, key)
		if found ~= nil then
			return key
		end
	end
end

 --listens to messages and determines how to respond if at all
SES_RE:SetScript("OnEvent",function(self,event,...)
--  We'll tag one of these events to update our GUID when it's needed
	if not PlayerGUID then PlayerGUID=UnitGUID("player"); end
	local now=GetTime();	
    local guid,msg,sender=select(12,...),...;
	local response=Triggers[findEmoteIndex(msg)];
	if type(response) == "table" then
		if next(response) == nil then
			response = nil;
		end
	end
	--print("response is a table: "..type(response))
	--print("response: "..response)
	--print(msg:match("%a*%s(.*)"))
	--print("guid: "..guid)
	--print("msg: "..msg)
	--print("msg: "..type(msg))
	--print("sender: "..sender)
		
	if guid~=PlayerGUID then--  Don't respond to emotes the player sent."]={};

		if FactionRaces[select(4,GetPlayerInfoByGUID(guid)) or ""]==PLAYER_FACTION then
--          Queue cross-faction response
			if select(4,GetPlayerInfoByGUID(guid)) == "Pandaren" then	--Pandarens are abominations
				self:QueueEmote(pandarenTriggers[math.random(1, #pandarenTriggers)],sender);

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
				--print(emoteCounter)
				if emoteCounter < MAX_EMOTES_CHAIN then
					SES_RE:QueueEmote(response[math.random(1, #response)],sender);
					emoteCounter = emoteCounter + 1;
				else emoteCounter = 0 end
	
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
	if now-lastemote > 10 then emoteCounter = 0 end
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