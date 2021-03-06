-- Author      : khris(chris) Xo-Malfurion
--SuperEmotes works in tandem with ReactiveEmotes."]={};
--ReactiveEmotes ..react.. to other emotes by queue'ing up emote responses."]={};
--Queue up emotes from other addons with 'G_SES_RE:QueueEmote(emote,target)' command."]={};

local MinDelay=1;--         Response delay in seconds."]={};
local Cooldown=3;--         Minimal time between queued emotes in seconds."]={};
local defaultTriggerCD=20;
local emoteCounter = 0;
local MAX_EMOTES_CHAIN = 4;
local globalResponseCD = 15;
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

	--ANIMATED EMOTES
	--Angry & Mad
    ["fist in anger at you."]={"GASP", "APOLOGIZE", "GROVEL", "PLEAD"};
    --Applaud, Applause & Bravo
    ["applauds at you"]={"THANK", "BOW", "CURTSEY"};
    --Attacktarget
    ["tells everyone to attack you."]={"SURRENDER", "ROAR", "TAUNT","CRY"};
    --Bashful
    ["is so bashful...too bashful to get your attention."]={"HUG","INTRODUCE","FIDGET"};
    --Beg
    ["begs you.  How pathetic."]={"MOAN","SHOO","SIGH","DOH"};
    --Blow & Kiss
    ["blows you a kiss."]={"NOSEPICK","KISS","FLIRT","BLUSH","SLAP","PURR"};
	--Blush
	["blushes at you."]={"CURIOUS","FLIRT","QUESTION","PONDER"};
	--Boggle
	["boggles at you."]={"BOW","GROVEL"};
	--Bow
	["bows before you."]={"HI","CURTSEY","BLUSH","GLOAT"};
	--Bye, Goodbye & Farewell
	["waves goodbye to you.  Farewell!"]={"waves farewell to %N!"};
	--Cackle
	["cackles maniacally at you."]={"CRY","HELPME","FLOP"};
	--Cheer
	["cheers at you."]={"DROOL"};
	--Chew, Eat & Feast
	["begins to eat rations in front of you."]={"THREATEN", "DROOL"};
	--Chicken, Flap & Strut
	--With arms flapping, %Name
	["struts around you.  Cluck, Cluck, Chicken."]={"CHICKEN", "CHICKEN", "CHICKEN", "incites a \"Cluck-Off!\""};
	--Chuckle
	["chuckles at you."]={"CRINGE"};
	--Clap
	["claps excitedly for you."]={"THANK","wonders why %N is clapping and nobody else is...","BOW"};
	--Commend
	["commends you on a job well done."]={"BOW","thanks %N for proving their mother true.","THANK"};
	--Confused
	["looks at you with a confused look."]={"PONDER","WAVE"};
	--Congrats & Congratulate
	["congratulates you."]={"SALUTE","HAIL"};
	--Cower & Fear
	["cowers in fear at the sight of you."]={"CACKLE","JK"};
	--Cry, Sob & Weep
	["cries on your shoulder."]={"COMFORT"};
	--Curious
	["is curious what you are up to."]={"SNARL","SHINDIG","SCRATCH"};
	--Curtsey
	["curtsies before you."]={"BOW","KISS","FART","SHY"};
	--Dance
    ["dances with you."]={"DANCE", "thinks %N needs to go watch Footloose.", "has never seen moves like %N's before!", "asks if %N knows Kevin Bacon.", "challenges everybody here to a dance off!"};
	--Drink & Shindig
	["raises a drink to you.  Cheers."]={"HAIL","FOOD","OOM"};
	--Flee
	["yells for you to flee."]={"flees from %N with a tear in their eye!","PRAY","GUFFAW"};
	--Flex & Strong
	["flexes at you.  Oooooh so strong."]={"GROVEL","PEER","COMMEND","YAWN","COWER"};
	--Flirt
	["flirts with you."]={"GLOAT", "READY", "POUNCE","VETO","KISS","hides their left hand before saying they are single and ready to mingle..."};
	--Followme
	["motions for you to follow."]={"LOST","SALUTE"};
	--Gasp
	["gasps at you."]={"GASP","SHRUG","RUDE","FLEX"};
	--Giggle
	["giggles at you."]={"TALKQ","INTRODUCE","TICKLE","SURPRISED"};
	--Gloat
	["gloats over your misfortune."]={"SPIT","STARE","THREATEN","MAD"};
	--Golfclap
	["claps for you, clearly unimpressed."]={"is unimpressed with %N's Mom.","CRY","CURTSEY","BITE"};
	--Greet & Greetings
	["greets you warmly."]={"HAPPY", "INTRODUCE"};
	--Grovel & Peon
	["grovels before you like a subservient peon."]={"SIGH", "SHOO", "PITY"};
	--Guffaw
	["takes one look at you and lets out a guffaw."]={"BLINK"};
	--Hail
	["hails you."]={"HELLO"};
	--Healme
	["calls out for healing."]={"LOL", "VETO", "SOOTHE"};
	--Hello & Hi
	["greets you with a hearty hello."]={"WAVE"};
	--Helpme (No Target Emote)
	["cries out for help."]={"VOLUNTEER"};
	--Incoming
	["points you out as an incoming enemy."]={"NO"};
	--Insult
	["thinks you are the son of a motherless ogre."]={"SNARL", "SURPRISED"};
	--Kneel
	["kneels before you."]={"FLEX", "BORED"};
	--Lay, Laydown, Lie & Liedown
	["lies down before you."]={"CUDDLE", "GROAN"};
	--Lol
	["laughs at you."]={"FART", "SMILE", "QUESTION"};
	--Lost
	["wants you to know that he is hopelessly lost."]={"FACEPALM"};
	--Mourn
	--In quiet contemplation, %Name
	["mourns your death."]={"COMFORT", "SOOTHE"};
	--Nod & Yes
	["nods at you."]={"NO"};
	--OOM
	["is low on mana."]={"FROWN"};
	--Openfire
	["orders you to open fire."]={"NOD"};
	--Plead
	["pleads with you."]={"WRATH", "NO", "SNUB"};
	--Point
	["points at you."]={"MOON"};
	--Ponder
	["ponders your actions."]={"SMIRK"};
	--Pray
	["says a prayer for you."]={"THANK"};
	--Puzzled
	["puzzled by you. What are you doing."]={"SNICKER"};
	--Question & Talkq
	["questions you."]={"SHRUG", "SMILE", "REAR"};
	--Rasp & Rude
	["makes a rude gesture at you."]={"PUNCH"};
	--Roar
	["roars with bestial vigor at you.  So fierce!"]={"BOGGLE", "YAWN", "FEAR", "BONK"};
	--Rofl
	["rolls on the floor laughing at you."]={"CRY"};
	--Salute
	["salutes you with respect."]={"HAIL", "BOW"};
	--Shrug (Default Reply, do not react)
	--["shrugs at you.  Who knows."]={};
	--Shy
	["smiles shyly at you."]={"SMILE", "BLUSH"};
	--Sleep (No Target Emote)
	["falls asleep. Zzzzzzz."]={"CUDDLE", "YAWN", "TAP"};
	--Surrender
	["surrenders before you.  Such is the agony of defeat..."]={"ROAR", "LAUGH"};
	--Talk
	["wants to talk things over with you."]={"NO", "LISTEN"};
	--Talkex
	["talks excitedly with you."]={"BLINK", "NOSEPICK", "SHOO"};
	--Taunt
	["makes a taunting gesture at you. Bring it."]={"RASP", "INSULT", "THREATEN"};
	--Victory
	["basks in the glory of victory with you."]={"CHEER", "ROAR"};
	--Violin
	["plays the world's smallest violin for you."]={"CRY"};
	--Wave
	["waves at you."]={"GREET"};
	--Welcome
	["welcomes you."]={"THANK", "INTRODUCE"};

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
	--Catty & Scratch
	--Cold
	--Comfort
	--Cough
	--Crack & Knuckles
	--Cringe
	--Cuddle & Spoon
	--Disappointed & Frown
	--Doh
	--Doom, Threaten & Wrath
	--Drool
	--Duck
	--Eye
	["eyes you up and down."]={"FART"};
	--Fart
	--Fidget
	--Flop
	--Food, Hungry & Pizza
	--"EAT"
	--Gaze
	--Glad
	--Glare
	["glares angrily at you."]={"GUFFAW", "JK"};
	--Grin
	--Groan
	--Happy
	--Hug
	--Impatient
	--Introduce
	--JK
	--Lavish
	--Lick
	["licks you."]={"COWER","CRY","GIGGLE"};
	--Listen
	--Massage
	["massages your shoulders."]={"MOAN"};
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
	--Poke
	--Pounce
	--Praise
	--Purr
	--Raise
	--Rdy
	--Ready
	--Rear & Shake
	--Sexy
	["thinks you are a sexy devil."]={"gasps in shock at %N!"};
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
	--Wicked & Wickedly
	--Work
	--Yawn

	--NO MESSAGE EMOTES
	--Sit
	--Train

	--NO REPONSE
	["begins charging alongside"]={"NOREPLY"};

	--GLOBAL RESPONSE
	["challenges everybody here to a dance off!"]={"DANCE"};
	["yells \"FOOTLOOSE!\""]={"DANCE"};
	--Charge (No Target Emote)
	["starts to charge."]={"begins charging alongside %N."};
	["incites a \"Cluck Off!\""]={"CHICKEN"};
	["cheers for the Horde!"]={"FORTHEHORDE"};
	["cheers for the Alliance!"]={"FORTHEALLIANCE"};
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

local globalTriggers = {"challenges everybody here to a dance off!",
						"yells \"FOOTLOOSE!\"",
						"starts to charge.",
						"incites a \"Cluck Off!\"",
						"cheers for the Horde!",
						"cheers for the Alliance!"};

function checkForGlobal(msg)
	for key, value in pairs(globalTriggers) do
		local found = string.find(msg, value)
		if found ~= nil then
			return true
		end
	end
	return false
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
				if response[1] == "NOREPLY" then return end
				--print(checkForGlobal(msg))
				if checkForGlobal(msg) and now-lastemote<globalResponseCD then return end
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