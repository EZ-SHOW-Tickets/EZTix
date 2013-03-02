<!--#INCLUDE file="common.asp"-->
<% 
	
	if now() < cdate("11/1/2012") then
'		dim rsPendingSeats
'		dim i,j
'		'GET PERFORMANCE INFORMATION
'			session("Admin")=0
'			session("AccountID")=5
'			session("lSessionID")=session.SessionID
'
'			PerformanceID="6902"
'			AccountID="5"
'
'			i = 1 
'			j=1
'			SetPendingSeat "1712",PerformanceID,"C01",session.sessionID
'			SetSeatCostBasis PerformanceID,"C01","8"
'			SetPendingSeat "1712",PerformanceID,"C02",session.sessionID
'			SetSeatCostBasis PerformanceID,"C02","8"
'			
'		'''''
'		Response.Redirect "SetupFreeTickets.asp?PerfomanceID=" & PerformanceID & "&AccountID=" & AccountID & "&Admin=2&lSessionID=" & session.sessionID	

			session("Admin")=0
			session("AccountID")=5
			session("lSessionID")=session.SessionID
			Response.Redirect "selectFreePerformance.asp?ShowID=1854"
end if
	
	
	
			
			


%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>


<p><b><font face="Arial">PRE-ORDER SALES ARE CLOSED.</font></b></p>


</HTML>