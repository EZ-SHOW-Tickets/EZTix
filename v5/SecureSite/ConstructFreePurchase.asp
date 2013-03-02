<% 
	dim rsPerformances
	dim strNumberEach
	dim totServiceCharge
	dim strReceiptMessage
	dim actualTicketCost
	dim actualServiceCharge
	dim j
	''''''''''''''''''''
	'   lSession
	'	
	strNumberEach=""
	''Heading
	strPurchase="<table border='1' cellspacing='1' style='border-collapse: collapse'  width='650' id='AutoNumber2'>"
	strPurchase=strPurchase &  "<tr>"
	strPurchase=strPurchase &  "<td width='203' align='center' ><b><font face='Arial' >EVENT</font></b></td>"
	strPurchase=strPurchase &  "<td width='96' align='center' ><b><font face='Arial' >Date/Time</font></b></td>"
	strPurchase=strPurchase &  "<td width='67' align='center' ><b><font face='Arial'  size='2'>Number<br>of Seats</font></b></td>"
	strPurchase=strPurchase &  "<td width='191' align='center' ><b><font face='Arial' >Reserved Seats</font></b></td>"
	strPurchase=strPurchase &  "<td width='71' align='center' ><b><font face='Arial' >Cost</font></b></td>"
	strPurchase=strPurchase &  "</tr>"
	'Get number of seats reserved for this person in this session for each Performance
	set rsPerformances=GetAllPendingSeatsForAllPerformancesForPerson(lSessionID)
	i=0
	actualServiceCharge=0
	totServiceCharge=0
	'For each Performance
	do until rsPerformances.eof
		'i=i	+ 1
		i= 1
		'Get info for this show & performance
		PerformanceID=rsPerformances("PerformanceID")
		getPerformanceInformation PerformanceID 
		'GET SHOW INFORMATION
	    GetShowInformation ShowID 
		'Get Reserved Seats selected
		SetupPendingSeats PerformanceID,lSessionID 
			'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			'	
			'	Seats(1,i) Seating CategoryID (reserved, unreserved...)
			'	Seats(2,i) number of seats in that category
			'	Seats(3,i) Seating Category Name
			'	Seats(4,i) Seat Numbers
			'	Seats(5,i) Seat Category (All seats, balcony,...)
			''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		'Get Prices
		GetPricesForSelectedSeats PerformanceID,lSessionID
			'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			'Price(1,i) PriceCategoryID
			'Price(2,i) PriceCategory Name
			'Price(3,i) Number in Price Category
			'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		''strNumberEach=price(3,1)
		''for j=2 to ubound(price,2)
		''	strNumberEach=strNumberEach & "/" & price(3,j)
		''next
		strNumberEach=price(3,1) & " " & price(2,1) 
		for j=2 to ubound(price,2)
			strNumberEach=strNumberEach & "<br>" & price(3,j) & " " & price(2,j) 
		next
		'How does i get involved?	
		'strPurchase=strPurchase & "<tr><td width='115'>" & strShowName & "</td><td width='141'>" & formatdatetime(strPerformanceDate,vbshortdate) & " " & strPerformanceTime & "</td><td width='110'>" & totalTickets & "(" & strNumberEach & ")</td><td width='191'>" & Seats(4,i) & "</td><td width='71'>" & totalTicketPrice & "</td></tr>"
		if seats(1,i)=2 then 'Unreserved
			strPurchase=strPurchase & "<tr><td width='203'><font face='Arial' size='2'>" & strShowName & "</td><td width='96'><font face='Arial' size='2'>" & formatdatetime(strPerformanceDate,vbshortdate) & " " & strPerformanceTime & "</td><td width='67'><font face='Arial' size='2'>" & totalTickets & "</font><br><font face='Arial' size='1'>(" & strNumberEach & ")</font></td><td width='191'><font face='Arial' size='2'>Unreserved</td><td width='71'><font face='Arial' size='2'>Free</td></tr>"
			session("Unreserved")="T"
		else
			strPurchase=strPurchase & "<tr><td width='203'><font face='Arial' size='2'>" & strShowName & "</td><td width='96'><font face='Arial' size='2'>" & formatdatetime(strPerformanceDate,vbshortdate) & " " & strPerformanceTime & "</td><td width='67'><font face='Arial' size='2'>" & totalTickets & "</font><br><font face='Arial' size='1'>(" & strNumberEach & ")</font></td><td width='191'><font face='Arial' size='1'>" & Seats(4,i) & "</td><td width='71'><font face='Arial' size='2'>" & formatcurrency(totalTicketCost,2) & "</td></tr>"
			session("Unreserved")="F"
		end if		
		strReceiptMessage=strReceiptMessage & " " & totalTickets & " tickets for " & strShowName & " on " & formatdatetime(strPerformanceDate,vbshortdate) & " at " & strPerformanceTime
		'Service Charge
		GetServiceCharge ShowID
		if ServiceChargeType=0 then
			'totServiceCharge=totServiceCharge + totalTicketCost*ServiceCharge
			totServiceCharge=totalTicketCost*ServiceCharge
		elseif ServiceChargeType=1 then
			'totServiceCharge=totServiceCharge + totalTickets*ServiceCharge
			totServiceCharge=totalTickets*ServiceCharge
		end if

		GetSpecialServiceCharge ShowID
		if SpecialServiceChargeType=0 then
			'totServiceCharge=totServiceCharge + totalTicketCost*ServiceCharge
			totServiceCharge=totServiceCharge + totalTicketCost*SpecialServiceCharge
		elseif SpecialServiceChargeType=1 then
			'totServiceCharge=totServiceCharge + totalTickets*ServiceCharge
			totServiceCharge=totServiceCharge + totalTickets*SpecialServiceCharge
		end if

		actualTicketCost=0.00
		actualServiceCharge=actualServiceCharge+ totServiceCharge
	    rsPerformances.movenext
	loop
	 'actualTicketCost=totalTicketCost + totServiceCharge
	 strPurchase=strPurchase &  "<tr>"
	 strPurchase=strPurchase &  "<td width='203' align='center' ></td>"
	 strPurchase=strPurchase &  "<td width='96' align='center' ></td>"
	 strPurchase=strPurchase &  "<td width='67' align='center' ></td>"
	 strPurchase=strPurchase &  "<td width='191' align='right' ><b><font face='Arial' >Service Charge</font></b></td>"
	 strPurchase=strPurchase &  "<td width='71' align='center' ><b><font face='Arial' ><input name='tServiceCharge' value='" & formatcurrency(actualServiceCharge,2) & "' size='5' readonly></font></b></td>"
	 strPurchase=strPurchase &  "</tr>"
	 strPurchase=strPurchase &  "<tr>"
	 strPurchase=strPurchase &  "<td width='203' align='center' ></td>"
	 strPurchase=strPurchase &  "<td width='96' align='center' ></td>"
	 strPurchase=strPurchase &  "<td width='67' align='center' ></td>"
	 strPurchase=strPurchase &  "<td width='191' align='right' ><b><font face='Arial' >TOTAL</font></b></td>"
	 'strPurchase=strPurchase &  "<td width='71' align='center' ><b><font face='Arial' ><input name='tTicketCost' value='" & formatcurrency(totalTicketCost + totServiceCharge,2) & "' size='5' readonly></font></b></td>"
	 strPurchase=strPurchase &  "<td width='71' align='center' ><b><font face='Arial' ><input name='tTicketCost' value='0.00' size='5' readonly></font></b></td>"
	 strPurchase=strPurchase &  "</tr>"
%>