<!--#INCLUDE file="common.asp"-->

<% 
	dim rsPendingSeats
	dim i,j
	'GET PERFORMANCE INFORMATION
	PerformanceID=session("PerformanceID")
	UpdateTimeForPendingTickets session("lSessionID") 
	select case getSeatingTypeForPerformance(PerformanceID)
	case 1 ' Reserved only
		for i = 1 to Request.Form("TicketCategories")
			if cint(Request.Form("PriceCategory" & trim(cstr(i))))>0 then
				set rsPendingSeats=GetPendingSeatsWithoutCostBasis(PerformanceID,session("lSessionID"))
				'set seat to correct cost basis
				for j=1 to cint(Request.Form("PriceCategory" & trim(cstr(i))))
					SetSeatCostBasis PerformanceID,rsPendingSeats("SeatNumber"),Request.Form("PriceCategoryType" & trim(cstr(i)))
					rsPendingSeats.movenext
				next
			end if
		next
		
	case 2 'Unreserved ONLY
	    dim SeatsAvailable
		for i = 1 to Request.Form("TicketCategories")
			if cint(Request.Form("PriceCategory" & trim(cstr(i))))>0 then
			    'Get tickets available for unreserved
				''SeatsAvailable=GetAvailableSeatsForUnreserved(PerformanceID)
				'set seat to correct cost basis
				'for j=1 to cint(Request.Form("PriceCategory" & trim(cstr(i))))
				'SetUnreservedSeatCostBasis session("ShowID"),PerformanceID,session("TheaterID"),cint(Request.Form("PriceCategory" & trim(cstr(i)))),session.SessionID,Request.Form("PriceCategoryType" & trim(cstr(i))),SeatsAvailable
				'SaveUnreservedSeats session("ShowID"),PerformanceID,session("TheaterID"),cint(Request.Form("PriceCategory" & trim(cstr(i)))),session.SessionID,Request.Form("PriceCategoryType" & trim(cstr(i)))
				SaveUnreservedSeats session("ShowID"),PerformanceID,session("TheaterID"),cint(Request.Form("PriceCategory" & trim(cstr(i)))),session("lSessionID"),Request.Form("PriceCategoryType" & trim(cstr(i)))
				'	rsPendingSeats.movenext
				'next
			end if
		next				
	
	end select
	'''''
	if Request.Form("MoreTicks")="0" then
		Response.Redirect "https://www.cgc-services.com/eztv5/SetupPayment.asp?PerfomanceID=" & PerformanceID & "&AccountID=" & session("AccountID") & "&Admin=" & session("Admin") & "&lSessionID=" & session("lSessionID")	
		''''''''TEST MODE
		'Response.Redirect "SecureSite/SetupPayment.asp?PerfomanceID=" & PerformanceID & "&AccountID=" & session("AccountID") & "&Admin=" & session("Admin") & "&lSessionID=" & session.sessionID	
		''''''''''''''''
	else
		Response.Redirect "events.asp?Admin=" & session("Admin") & "&lSessionID=" & session("lSessionID")		
	end if
%>
<html>

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Process Seats</title>
</head>

<body>

</body>

</html>
