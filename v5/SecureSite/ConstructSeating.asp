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

iSeatWidth=24
iEachSeat=10
iSeatHeight= 25
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
	strLegend="<table><tr><td bgcolor='#C0C0C0'><font face='Arial' size='2'>Not Available</font></td>"    '<td bgcolor='#00CC99'><font face='Arial' size='2'>General Admission</font></td><td  bgcolor='#C0C0C0'><font face='Arial' size='2'>Taken</font></td><td  bgcolor='#0066CC'><font face='Arial' size='2' color='white'>Season Tickets</font></td></tr></table>"
	do until rsSeatingTypes.eof
		strLegend=strLegend & "<td bgcolor='" & rsSeatingTypes("SeatingCategoryColor") & "'><font face='Arial' size='2'>" & rsSeatingTypes("SeatingCategory") & "</font></td>"
		rsSeatingTypes.movenext
	loop
	strLegend=strLegend & "</tr></table>"
'Button to select seats (need a GA version)
strTheater= strTheater & "<tr><td width='10' height='33' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='33' align='center' bgcolor='#FFFFCC'><p align='center'><input type='button' value='PLEASE SELECT SEATS BELOW AND PRESS HERE' onclick='javascript:SubmitSelection();'></p></td> <td width='10' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
'<b><font face='Arial'><a href='javascript:SubmitSelection();'>PLEASE SELECT YOUR SEATS BELOW AND PRESS HERE</a></font></b></p></td> <td width='10' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
'Legend
strTheater= "<tr><td width='" & iEachSeat & "' height='2' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='2' align='center' bgcolor='#003366'><p align='center'>" & strLegend & "</td> <td width='" & iEachSeat & "' height='2'  bgcolor='#003366'>&nbsp;</td></tr>" & strTheater
'Loop thru each Section
set rsSections=getrecordset("Select SectionID,SectionName from THEATER_SECTIONS where TheaterID=" & TheaterID)
do until rsSections.eof 'Sections
	'loop thru each Section
	'SECTION Name
	strTheater=strTheater & "<tr><td width='" & iEachSeat & "' height='33' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='33' align='center' bgcolor='#FFFFCC'><b>" & rsSections("SectionName") & "<b></td> <td width='" & iEachSeat & "' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
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
					n=len(rsSeats("SeatNumber"))
					do until isnumeric(trim(right(rsSeats("SeatNumber"),n)))
						n=n-1
					loop
					numSeat=trim(right(rsSeats("SeatNumber"),n))				
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
								if isnull(rsSeats("ReservationForID")) then 
								'No person assigned to seat - it is Avalable
									strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='" & rsSeatingType("SeatingCategoryColor") & "'><input type='checkbox' name='" & rsSeats("SeatNumber") & "' onclick=javascript:ChangeColor(this,this.parentElement);>" & strSeatNumber & "</td>"
								else
								'Reserved - seat is taken
									strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle' bgcolor='#C0C0C0'>" & strSeatNumber & "</td>"
								end if
						else
								strTheater=strTheater & "<td width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle'><font color='#FFFFCC' size='1'>xxx<</font></td>"
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
							strTheater=strTheater & "<td width='" & iSeatWidth & "' height='" & iSeatHeight & "' align='middle'><font color='#FFFFCC' size='1'>xxx<</font></td>"
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
