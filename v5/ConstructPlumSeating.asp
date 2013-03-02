<% 
''''''''''''''''''
' INPUT
'   TheaterID
'   PerformanceID
dim rsAreas
dim rsSeats
dim rsSections
dim rsSeatCategories
dim iSeatWidth, iEachSeat, iSeatHeight,strSeatNumber
dim rsSeatingTypes,rsSeatingType,strLegend
dim Orange,Blue,Green
Red="#FF0000"
Orange="#FF6600"
Blue="#0000FF"
Green="#008000"
white="#FFFFFF"
grey="#C0C0C0"
iSeatWidth=24
iEachSeat=10
''iSeatHeight= 25
iSeatHeight= 35
'SET UP THEATER PARAMETERS
set rsAreas=getrecordset("Select max(Area) as TotAreas from THEATER_SEATING where TheaterID=" & TheaterID)
'Get Most seats across
set rsSeats=getrecordset("Select max(seat) as TotSeats from THEATER_SEATING where TheaterID=" & TheaterID)
'' 0623 TotalWidth=34*(rsSeats("TotSeats"))
''TotalWidth=iSeatWidth*(rsSeats("TotSeats"))
TotalWidth=600
TotalTheater=TotalWidth-20
'''''''''''''
''' Legends
'Get all ticket types for this performance
	set rsSeatingTypes=getAllSeatingCategoriesForPerformance(PerformanceID)
	strLegend="<table><tr><td bgcolor='#C0C0C0'><font face='Arial' size='2'>Taken</font></td>"    '<td bgcolor='#00CC99'><font face='Arial' size='2'>General Admission</font></td><td  bgcolor='#C0C0C0'><font face='Arial' size='2'>Taken</font></td><td  bgcolor='#0066CC'><font face='Arial' size='2' color='white'>Season Tickets</font></td></tr></table>"
	do until rsSeatingTypes.eof
		if rsSeatingTypes("SeatingCategoryID")=1 then
			strLegend=strLegend & "<td bgcolor='" & rsSeatingTypes("SeatingCategoryColor") & "'><font face='Arial' size='2'>Available</font></td>"
		else
			strLegend=strLegend & "<td bgcolor='" & rsSeatingTypes("SeatingCategoryColor") & "'><font face='Arial' size='2'>" & rsSeatingTypes("SeatingCategory") & "</font></td>"
		end if
		rsSeatingTypes.movenext
	loop
	'''put in Season Tickets  legend if appropriate
	if isSeasonTickets(PerformanceID) then
			strLegend=strLegend & "<td bgcolor='" & Blue & "'><font face='Arial' size='2' color='#FFFFFF'>Season Tickets</font></td>"
	end if
	if isHCTickets(PerformanceID) then
			strLegend=strLegend & "<td bgcolor='" & Orange & "'><font face='Arial' size='2' color='#FFFFFF'>Handicap</font></td>"
	end if
	
	strLegend=strLegend & "</tr></table>"
'Button to select seats (need a GA version)
strTheater= strTheater & "<tr><td width='10' height='33' bgcolor='#003366'>&nbsp;</td><td width='100%' height='33' align='center' bgcolor='#FFFFCC'><p align='center'><a href='javascript:SubmitSelection(" & numTix & ");' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('Image1','','images/SelectSeatsBelowON.gif',1)""><img name='Image1' border='0' src='images/SelectSeatsBelow.gif'></a></p></td> <td width='10' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
'strTheater= strTheater & "<tr><td width='10' height='33' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='33' align='center' bgcolor='#FFFFCC'><p align='center'><a href='javascript:SubmitSelection();' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('Image1','','images/SelectSeatsBelowON.gif',1)""><img name='Image1' border='0' src='images/SelectSeatsBelow.gif'></a></p></td> <td width='10' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
'<b><font face='Arial'><a href='javascript:SubmitSelection();'>PLEASE SELECT YOUR SEATS BELOW AND PRESS HERE</a></font></b></p></td> <td width='10' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
'Legend
'strTheater= "<tr><td width='" & iEachSeat & "' height='2' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='2' align='center' bgcolor='#003366'><p align='center'>" & strLegend & "</td> <td width='" & iEachSeat & "' height='2'  bgcolor='#003366'>&nbsp;</td></tr>" & strTheater
strTheater= "<tr><td width='" & iEachSeat & "' height='2' bgcolor='#003366'>&nbsp;</td><td width='100%' height='2' align='center' bgcolor='#003366'><p align='center'>" & strLegend & "</td> <td width='" & iEachSeat & "' height='2'  bgcolor='#003366'>&nbsp;</td></tr>" & strTheater
'Loop thru each Section
set rsSections=getrecordset("Select SectionID,SectionName from THEATER_SECTIONS where TheaterID=" & TheaterID)
do until rsSections.eof 'Sections
	'loop thru each Section
	'SECTION Name
	'strTheater=strTheater & "<tr><td width='" & iEachSeat & "' height='33' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='33' align='center' bgcolor='#FFFFCC'><b>" & rsSections("SectionName") & "<b></td> <td width='" & iEachSeat & "' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
	strTheater=strTheater & "<tr><td width='" & iEachSeat & "' height='33' bgcolor='#003366'>&nbsp;</td><td width='100%' height='33' align='center' bgcolor='#FFFFCC'><b>" & rsSections("SectionName") & "<b></td> <td width='" & iEachSeat & "' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
	strTheater=strTheater & "<tr><td width='" & iEachSeat & "' height='33' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='33'><table width='" & TotalTheater & "'  bgcolor='#FFFFCC' align='center'><tr>"
	'Areas
	set rsAreas=getrecordset("Select distinct Area from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " order by Area")
    do until rsAreas.eof
    'loop thru each Area
			'Get Most seats across for this section
			set rsSeats=getrecordset("Select max(abs(seat)) as HiSeats,min(abs(seat)) as LoSeats from THEATER_SEATING where TheaterID=" & TheaterID & " and Area=" & rsAreas("Area")& " and TSection=" & rsSections("SectionID"))
			numSeats=rsSeats("HiSeats")-rsSeats("LoSeats")
			'Table for this Area
			''strTheater=strTheater & "<td width='" & numSeats*iSeatWidth  & "'><table border='1' cellspacing='0' width='" & numSeats*25  & "' cellpadding='0' height='32' align='center'>"
			strTheater=strTheater & "<td width='" & TotalTheater  & "'><table border='1' cellspacing='0' width='" & numSeats*25  & "' cellpadding='0' height='32' align='center'>"
			'Get rows for this Section/Area
			set rs=getrecordset("Select distinct Row from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " and Area=" & rsAreas("Area") & " order by Row")
			if TheaterLabelType=0 then  'Test if seat numbers are to list across page or on each seat
				'Get Seat Numbers to list across page
				strSQL="Select SeatNumber from THEATER_SEATING where TSection=" & rsSections("SectionID") & " and Area=" & rsAreas("Area") & " and Row=" & rs("Row") & " and TheaterID=" & TheaterID  & " order by abs(Seat)"
				set rsSeats=getrecordset(strSQL)
				'Seat numbers across page
				strTheater=strTheater & "<td width='" & iSeatWidth & "' height='10' align='middle' bgcolor='#666666'></td>"
				do until rsSeats.eof
					'n=len(rsSeats("SeatNumber"))
					n=1
					'do until isnumeric(trim(right(rsSeats("SeatNumber"),n)))
					do while (isnumeric(trim(right(rsSeats("SeatNumber"),n))) and mid(rsSeats("SeatNumber"),len(rsSeats("SeatNumber"))-n+1,1) <> "-")
						n=n+1
					loop
					numSeat=trim(right(rsSeats("SeatNumber"),n-1))				
					strTheater=strTheater & "<td width='" & iSeatWidth & "' height='10' align='middle' bgcolor='#666666'><font face='Arial' size='1' color='#FFFFFF'>" & numSeat & "</td>"
					rsSeats.movenext	
				loop
				strSeatNumber=""
			end if
			strTheater=strTheater & "<td width='" & iSeatWidth & "' height='10' align='middle' bgcolor='#666666'></td>"
			do until rs.eof
			'Loop through each row of SECTION/AREA
			       'Get Row Letter
				    set rsRowLetter=getrecordset("Select RowLetter from THEATER_ROW_LETTERS where TheaterID=" & TheaterID & " and Row=" & rs("Row"))
					'Row Number on side
					strTheater=strTheater & "<tr><td width='10' bgcolor='#666666'><font face='Arial' size='1' color='#FFFFFF'>" & rsRowLetter("RowLetter") & "</font></td>"
				'Get Type of seating for this SECTION/AREA
				set rsSeatingType=getSeatingCategoryForPerformanceAndLocation(PerformanceID,rsAreas("Area"),rsSections("SectionID"))
				if rsSeatingType("SeatingCategoryID")=1 then
				'Reserved Seats
					'Get all seats including those that have been reserved for this show
					strSQL="Select E.*,S.ReservationForID,S.PerformanceID,S.CostBasis,S.PaymentID FROM (select * from SHOW_SEATING where PerformanceID=" & PerformanceID & ") as S RIGHT OUTER JOIN (Select seat,SeatNumber from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " and Area=" & rsAreas("Area") & " and row =" & rs("row") & ") as E ON S.SeatNumber = E.SeatNumber order by abs(Seat)"
					set rsSeats=getrecordset(strSQL)
					do until rsSeats.eof 
					'Loop through each seat
						if TheaterLabelType = 1 then  'Check if Seat number is to be	printed
						    	n=len(rsSeats("SeatNumber"))
								do until isnumeric(trim(right(rsSeats("SeatNumber"),n)))
									n=n-1
								loop
								numSeat=trim(right(rsSeats("SeatNumber"),n))	
								strSeatNumber="<br><font face='Arial' size='1' color='#FFFFFF'>" & numSeat & "</font>"						    
						end if
						if rsSeats("seat") > 0 then 'if not a BLOCKED seat
								'if isnull(rsSeats("ReservationForID")) then 
								'No person assigned to seat - it is Avalable
								'	strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & rsSeatingType("SeatingCategoryColor") & "'><input type='checkbox' name='" & rsSeats("SeatNumber") & "' onclick=javascript:ChangeColor(this,this.parentElement);>" & strSeatNumber & "</td>"
								if isnull(rsSeats("ReservationForID")) or rsSeats("ReservationForID")=-1 then 
								'No person assigned to seat - it is Avalable
									'Check Seat Category and display
									if isnull(rsSeats("CostBasis")) then
										strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & Green & "'><input type='checkbox' name='" & rsSeats("SeatNumber") & "' onclick=javascript:ChangeColor(this,this.parentElement);>" & strSeatNumber & "</td>"
									elseif rsSeats("CostBasis")=110 then
									'    if cint(session("Admin"))>0 then
									'		strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & Red & "'><input type='checkbox' name='" & rsSeats("SeatNumber") & "' onclick=javascript:ChangeColor(this,this.parentElement);>" & strSeatNumber & "</td>"
									'	else
											strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & grey & "'>" & strSeatNumber & "</td>"
									'	end if
									elseif rsSeats("CostBasis")=120 then
									'    if cint(session("Admin"))>0 then
									'		strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & Blue & "'><input type='checkbox' name='" & rsSeats("SeatNumber") & "' onclick=javascript:ChangeColor(this,this.parentElement);>" & strSeatNumber & "</td>"
									'	else
											strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & Blue & "'>" & strSeatNumber & "</td>"
									'	end if
									elseif rsSeats("CostBasis")=130 then
									'    if cint(session("Admin"))>0 then
											strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & Orange & "'><input type='checkbox' name='" & rsSeats("SeatNumber") & "' onclick=javascript:ChangeColor(this,this.parentElement);>" & strSeatNumber & "</td>"
									'	else
									'		strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & grey & "'>" & strSeatNumber & "</td>"
									'	end if
									end if
								else
								'Reserved - seat is taken
									'if rsSeats("CostBasis")=110 then
									'    if cint(session("Admin"))>0 then
									'		strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & Red & "'>" & strSeatNumber & "</td>"
									'	else
									'		strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & grey & "'>" & strSeatNumber & "</td>"
									'	end if
									'else
										strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='#C0C0C0'>" & strSeatNumber & "</td>"
									'end if
								end if
						else
								'strTheater=strTheater & "<td width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle'><font color='#FFFFCC' size='1'>xxx<</font></td>"
								strTheater=strTheater & "<td width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle'><font color='#FFFFCC' size='3'>XX</font></td>"
						end if
						rsSeats.movenext
					loop				 'Seats			
				else
				'Not selectable seats (unreserved, season tickets)
					'Get all seats in this SECTION/AREA's row
					strSQL="Select seat,SeatNumber from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " and Area=" & rsAreas("Area") & " and row =" & rs("row") & " order by abs(Seat)"
					set rsSeats=getrecordset(strSQL)
					do until rsSeats.eof 
						if rsSeats("seat") > 0 then 'if not a BLOCKED seat
							strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & rsSeatingType("SeatingCategoryColor") & "'></td>"
						else
							strTheater=strTheater & "<td width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle'><font color='#FFFFCC' size='3'>XX</font></td>"
						end if
						rsSeats.movenext
					loop				 'Seats					
				end if
				strTheater=strTheater & "<td width='10' bgcolor='#666666'><font face='Arial' size='1' color='#FFFFFF'>" & rsRowLetter("RowLetter") & "</font></td></tr>"
				rs.movenext
			loop             'Rows
			strTheater=strTheater & "</table></td>"
			rsAreas.movenext
		loop   'Areas
		strTheater=strTheater & "</tr></table></td><td width='10' height='23'  bgcolor='#003366'>&nbsp;</td></tr>"
		rsSections.movenext
loop 'Sections
%>
