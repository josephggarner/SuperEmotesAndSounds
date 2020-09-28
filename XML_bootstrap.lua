MyModData = {}

function XML_PopulateList()
	
	for i=1,#SESEmotesLIB do
    MyModData[i] = SESEmotesLIB[i][1].." - "..SESEmotesLIB[i][3]
	end
	MyModScrollBar:Show()
end

function MyModScrollBar_Update()
  local line; -- 1 through 5 of our window to scroll
  local lineplusoffset; -- an index into our data calculated from the scroll offset
  FauxScrollFrame_Update(MyModScrollBar,#SESEmotesLIB,10,16);
  for line=1,10 do
    lineplusoffset = line + FauxScrollFrame_GetOffset(MyModScrollBar);
    if lineplusoffset <= #SESEmotesLIB then
      getglobal("MyModEntry"..line):SetText(MyModData[lineplusoffset]);
      getglobal("MyModEntry"..line):Show();
    else
      getglobal("MyModEntry"..line):Hide();
    end
  end
end