<% 
	
	'if now() < cdate("10/22/2010") then
			session("Admin")=0
			session("AccountID")=5
			session("lSessionID")=session.SessionID
			'Response.Redirect "selectPerformance.asp?ShowID=1451"
			'Response.Redirect "selectPerformance.asp?ShowID=1506"
			'Response.Redirect "selectPerformance.asp?ShowID=1522"
			Response.Redirect "selectPerformance.asp?ShowID=" & Request.QueryString("ShowID")
	'end if

%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>


<p><b><font face="Arial">PRE-ORDER SALES ARE CLOSED.</font></b></p>


</HTML>