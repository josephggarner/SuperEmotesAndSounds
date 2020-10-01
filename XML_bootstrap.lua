MyModData = {}

function XML_PopulateList()
	
	for i=1,#SESEmotesLIB do
    MyModData[i] = {SESEmotesLIB[i][1],SESEmotesLIB[i][3]}
	end
	MyModScrollBar:Show()
	MyModScrollBar_Update()
end

function MyModScrollBar_Update()
  local line; -- 1 through 5 of our window to scroll
  local lineplusoffset; -- an index into our data calculated from the scroll offset

  FauxScrollFrame_Update(MyModScrollBar,#SESEmotesLIB,10,16);
  for line=1,10 do
    lineplusoffset = line + FauxScrollFrame_GetOffset(MyModScrollBar);
    if lineplusoffset <= #SESEmotesLIB then
      getglobal("MyModEntry"..line):SetText(MyModData[lineplusoffset][1].." - "..MyModData[lineplusoffset][2]);
	  getglobal("MyModEntry"..line):SetScript("OnClick", function(self) 
				emotemsg = "EMOTE-"..lineplusoffset-(10-line)
				broadcastSES(emotemsg)
					--print(emotemsg)
					--print("line "..line.."    lineplusoffset "..lineplusoffset.."    Offset "..FauxScrollFrame_GetOffset(MyModScrollBar))
					--print("calc'd line "..lineplusoffset-(10-line))
				print("Playing Emote.")
				SESPlayEmoteSound(SESEmotesLIB,lineplusoffset-(10-line))
		end)

      getglobal("MyModEntry"..line):Show();
    else
      getglobal("MyModEntry"..line):Hide();
    end
  end
end