<!--#INCLUDE file="../common.asp"-->
<% 

dim SectionsAcross(5,10),SectionsBack(5),LocationName(5),i,j,numSectionsAcross,numSectionsBack
dim Alpha(100),s,r,iSeat,iRow,x,FrontRow(5),LeftSeat(5,10),Seq(5,10),SeatNumber
dim rsRowLetters,k


if isempty(Request.QueryString("Theater")) then
	TheaterName="Theater"
else
	TheaterName=Request.QueryString("Theater")
end if

TheaterID=insertrecord("Insert into THEATERS (TheaterName,TheaterLabelType) values('" & TheaterName & "',0)","THEATERS","TheaterID")
x=insertrecord("Insert into ACCOUNT_THEATERS (AccountID,TheaterID) values(" & Request.QueryString("account") & "," & TheaterID & ")","ACCOUNT_THEATERS","TheaterID")
for j=1 to 3
	SectionsBack(j)=cint(Request.QueryString("B" & trim(cstr(j))))
	LocationName(j)=Request.QueryString("L" & trim(cstr(j)))
	'FrontRow(j)=cint(Request.QueryString("FR" & trim(cstr(j))))
	for i=1 to 10
		SectionsAcross(j,i)=cint(Request.QueryString("A" & trim(cstr(j)) & trim(cstr(i))))
		LeftSeat(j,i)=cint(Request.QueryString("LS" & trim(cstr(j)) & trim(cstr(i))))
		Seq(j,i)=cint(Request.QueryString("Seq" & trim(cstr(j)) & trim(cstr(i))))
	next
next
IRow = 0
ISeat = 0
for j=1 to 3
	if SectionsBack(j) >0 then
		'Insert Section Names
		x=insertrecord("Insert into THEATER_SECTIONS (TheaterID,SectionID,SectionName) values(" & TheaterID & "," & cstr(j) & ",'" & LocationName(j) & "')","THEATER_SECTIONS","TheaterID")
	   	set rsRowLetters=getrecordset("Select * from GENERAL_ROW_LETTERS where GeneralID=" & Request.QueryString("FR" & trim(cstr(j))) & " order by row")
		k=IRow
		do until rsRowLetters.eof
			k=k+1
			Alpha(k)=rsRowLetters("RowLetter")
			rsRowLetters.movenext
		loop
	   	for r=1 to SectionsBack(j) 'for each row
	   		Irow=Irow+1
			x=insertrecord("INSERT INTO THEATER_ROW_LETTERS (TheaterID,Row,RowLetter) values(" & TheaterID & "," & Irow & ",'" & Alpha(Irow) & "')","THEATER_ROW_LETTERS","TheaterID")
	   		Iseat=0
			for i=1 to 10 'for each section across in the row
				if SectionsAcross(j,i) > 0 then
				    'Add Area Section
				    x=insertrecord("INSERT INTO THEATER_SEAT_CATEGORY (TheaterID,Area,TSection,SeatCategoryID) values(" & TheaterID & "," & i & "," & j & ",1)","THEATER_SEAT_CATEGORY","TheaterID")
					for s=1 to SectionsAcross(j,i) ' for each seat across a row
					    'Put seat in database
					     Iseat=Iseat + 1 ' seat number
					     'Determine Seat number
					     if LeftSeat(j,i)+(s-1)*seq(j,i) > 0 then
					        if LeftSeat(j,i)+(s-1)*seq(j,i) <10 then
								'SeatNumber=Alpha(FrontRow(j)+r-2) & "0" & trim(cstr(LeftSeat(j,i)+(s-1)*seq(j,i)))
								SeatNumber=Alpha(IRow) & "0" & trim(cstr(LeftSeat(j,i)+(s-1)*seq(j,i)))
							else
								'SeatNumber=Alpha(FrontRow(j)+r-2) & trim(cstr(LeftSeat(j,i)+(s-1)*seq(j,i)))
								SeatNumber=Alpha(IRow) & trim(cstr(LeftSeat(j,i)+(s-1)*seq(j,i)))
							end if
						 else
					        if abs(seq(j,i))*s-(LeftSeat(j,i)+1) <10 then
								'SeatNumber=Alpha(FrontRow(j)+r-2) & "0" & trim(cstr(abs(seq(j,i))*s-(LeftSeat(j,i)+1)))						 
								SeatNumber=Alpha(IRow) & "0" & trim(cstr(abs(seq(j,i))*s-(LeftSeat(j,i)+1)))						 
							else
								'SeatNumber=Alpha(FrontRow(j)+r-2) & trim(cstr(abs(seq(j,i))*s-(LeftSeat(j,i)+1)))						 
								SeatNumber=Alpha(IRow) & trim(cstr(abs(seq(j,i))*s-(LeftSeat(j,i)+1)))						 
							end if
						 end if
					     strSQL="Insert into THEATER_SEATING values(" & TheaterID & ",'" & SeatNumber & "'," & Irow & "," & Iseat & "," & i & "," & j & ")"
					     x= insertrecord(strSQL,"THEATER_SEATING","SeatNumber") 
					next
				end if
			next
		next
	end if
next
Response.Redirect "Config1Seating.asp?TheaterID=" & TheaterID
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>BOT</title>
</head>

<body>
<%=x%> <%=strSQL%><%="B" & trim(cstr(1))%>
</body>

</html>