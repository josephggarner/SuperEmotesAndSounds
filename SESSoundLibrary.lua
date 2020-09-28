-- Author      : Chris Xo-Malfurion
--updated: 4/25/2020
local SESpath = "Interface/AddOns/SuperEmotesAndSounds/Sounds/"		--ROOT for sound files

SESTriggersLIB = 
{
	Triggered = 
	{
		SESpath .. "TRIGGERS/TRIGGERED/gofyourself.mp3",
		SESpath .. "TRIGGERS/TRIGGERED/kid.mp3",
		SESpath .. "Emotes/nailedit.mp3",
		SESpath .. "Emotes/whatswrongwithme.mp3",
		SESpath .. "Emotes/wheresmybackup.mp3",
		SESpath .. "Emotes/justgetgot.mp3",
	},
	Sad = 
	{
		SESpath .. "TRIGGERS/TRIGGERED/gofyourself.mp3",
		SESpath .. "TRIGGERS/TRIGGERED/kid.mp3"
	},
	Happy = 
	{
		SESpath .. "TRIGGERS/TRIGGERED/gofyourself.mp3",
		SESpath .. "TRIGGERS/TRIGGERED/kid.mp3"
	},
	Leave = 
	{
		SESpath .. "TRIGGERS/TRIGGERED/gofyourself.mp3",
		SESpath .. "TRIGGERS/TRIGGERED/kid.mp3"
	},
	Join = 
	{
		SESpath .. "TRIGGERS/TRIGGERED/gofyourself.mp3",
		SESpath .. "TRIGGERS/TRIGGERED/kid.mp3"
	}
	

}

SESEmotesLIB =				--{Default Command, Clip Path, description of clip}
{
	--kris
	{'gfy'		,SESpath .. "Triggers/Triggered/gofyourself.mp3","Go F*K yourself"},
	{'scrm'		,SESpath .."Emotes/level9scream.mp3","Scream"},
	{'1v1'		,SESpath .."Emotes/oneonone.mp3","1v1 me B*tches"},
	{'epic'		,SESpath .."Emotes/epicspeech.mp3","Epic Loot Event"},
	{'gkick'	,SESpath .."Emotes/gkick.mp3","Guild Kick"},
	{'dam'	,SESpath .."Emotes/mwahaha.mp3","Dayum"},

	-------~*~*~*~*~*~*~**~*~----------
	--jas
	{'jhah'	,SESpath .."Emotes/JayHah.mp3","Short Ha"},
	{'oyb'	,SESpath .."Emotes/megaohyeababy.mp3","Oh Yea baby"},
	{'ayd'	,SESpath .."Emotes/awhyeadaddy.mp3","Ah Yea daddy"},
	{'yas'	,SESpath .."Emotes/Yahs.mp3","Yesh"},
	{'ynmm'	,SESpath .."Emotes/yourenotmymom.mp3","Your not my mom"},
	{'wwm'	,SESpath .."Emotes/whatswrongwithme.mp3","What is wrong"},
	{'bit'	,SESpath .."Emotes/bches.mp3","B*tches"},
	{'augh'	,SESpath .."Emotes/augh.mp3","Aughh"},
	{'sad'	,SESpath .."Emotes/makesmesad.mp3","That makes me sad"},
	{'ughh'	,SESpath .."Emotes/megaugh.mp3","Ughhh"},
	{'nailed'	,SESpath .."Emotes/nailedit.mp3","Nailed it"},
	
	-------~*~*~*~*~*~*~**~*~----------
	--CLIFF
	{'obey'	,SESpath .."Emotes/tentacleoverlords.mp3","Obey tentacle lords"},
	{'backup'	,SESpath .."Emotes/wheresmybackup.mp3","Where's my backup"},

	-------~*~*~*~*~*~*~**~*~----------
	--Fred
	{'gotgot'	,SESpath .."Emotes/justgetgot.mp3","Did I get got"},

	-------~*~*~*~*~*~*~**~*~----------
	--andrw
	{'cookie'	,SESpath .."Emotes/forthecookie.mp3","For the Cookie"},

	-------~*~*~*~*~*~*~**~*~----------
	--Joey
	{'needhelp'	,SESpath .."Emotes/ineedhelp.mp3","I need help"},
	{'wow'	,SESpath .."Emotes/wowow.mp3","wow^7"},
	{'huh'	,SESpath .."Emotes/whuh.mp3","Huh?"},

	-------~*~*~*~*~*~*~**~*~----------
	--misc
	{'fall'	,SESpath .."Emotes/fallingasleep.mp3","Smack Noise"},
	{'ngl'	,SESpath .."Emotes/notgettinglaid.mp3","Not getting laid"},
	{'trap'	,SESpath .."Emotes/itsatrap.mp3","Its a trap!"},
	{'fap'	,SESpath .."Emotes/savagefap.mp3","Auugh auugh auugh"},
	{'dundun'	,SESpath .."Emotes/dundundun.mp3","Dun dun \/ dunnn"},
	{'triple'	,SESpath .."Emotes/triple.mp3","Oh Baby a Tripple"},
	{'bye'	,SESpath .."Emotes/byehaveagreattime.mp3","Bye Great Time"},
	{'turtles'	,SESpath .."Emotes/turtles.mp3","I <3 Turtles"},
	
	

}

--for key, val, level, tab in pairsdeep(SESEmotesLIB) do
--    print(key, val, level, tab)
--    -- key is the element key in its table, val is the element
--    -- level is how many subtables deep we are, tab is the table containing current element
--end

--function pairsdeep(t)
--    local stack = {{k = nil, t = t}}
--    local iter, nval
--    iter = function()
--        local top = stack[#stack]
--        if not top then return nil end
--        top.k, nval = next(top.t, top.k)
--        if not top.k then
--            stack[#stack] = nil
--            return iter()
--        elseif type(nval) == 'table' then
--            stack[#stack+1] = {k = nil, t = nval}
--            return iter()
--        else
--            return top.k, nval, #stack, top.t
--        end
--    end
--    return iter
--end