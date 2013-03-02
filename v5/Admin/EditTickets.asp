<!--#INCLUDE file="../common.asp"-->
<% 
dim rsSeats,PerformanceInformation,strEdit,rsSeat,TicketPrice
dim strTicket,i
dim strPurchaseReference
GetAccountInformation session("AccountID")
PerformanceID=Request.QueryString("PerformanceID")
PersonID=Request.QueryString("PersonID")
getPerson PersonID
getPerformanceInformation PerformanceID
getShowInformation ShowID
GetServiceCharge ShowID
PerformanceInformation=strShowName & " " & strPerformanceDate & " " & strPerformanceTime
'check if tickets are to be cancelled
for i = 1 to Request.Form.Count
	strTicket=request.form(Request.Form.key(i))
	deleterecord "DeLETE FROM SHOW_SEATING where PerformanceID=" & PerformanceID & " and SeatNumber='" & strTicket & "'"
next
'Get Tickets for this person
set rsSeats=GetPurchasedSeatsForAPerformancesForPerson(PerformanceID,PersonID)
if not rsSeats.eof then
	strPurchaseReference=GetDBItem("Select PurchaseReference from PAYMENT_RECEIPTS where PaymentReceiptID=" & rsSeats("PaymentReceiptID"))
end if
'Loop through each one
do until rsSeats.eof
	set rsSeat = getSeatingCategoryForPerformanceAndSeat(PerformanceID,TheaterID,rsSeats("SeatNumber"))	
	strEdit=strEdit & "<tr>"
	if rsSeat("SeatingCategoryID")=1 then
		strEdit=strEdit & "<td width='20%' align='center'><font face='Arial' size='2'>" & rsSeats("SeatNumber") & "</font></td>"
	else
		strEdit=strEdit & "<td width='20%' align='center'><font face='Arial' size='2'>&nbsp;</font></td>"
	end if
	strEdit=strEdit & "<td width='20%' align='center'><font face='Arial' size='2'>" & GetPriceCategory(rsSeats("CostBasis")) & "</font></td>"
	if ServiceChargeType=1 then
		TicketPrice=getPriceForASeatAndPerformance(PerformanceID,rsSeats("SeatNumber"))+ ServiceCharge
	else
		TicketPrice=getPriceForASeatAndPerformance(PerformanceID,rsSeats("SeatNumber"))*(1+ serviceCharge)
	end if
	If rsSeats("PaymentID")=1 or rsSeats("PaymentID")=2 then
		strEdit=strEdit & "<td width='22%' align='center'><font face='Arial' size='2'>" & formatcurrency(TicketPrice,2) & "</font></td>"
	elseIf rsSeats("PaymentID")=3  then
		strEdit=strEdit & "<td width='22%' align='center'><font face='Arial' size='2'>(" & formatcurrency(TicketPrice,2) & ")</font></td>"
	elseIf rsSeats("PaymentID")=4 or rsSeats("PaymentID")=5 then
		strEdit=strEdit & "<td width='22%' align='center'><font face='Arial' size='2'>$0.00</font></td>"
	end if	
	if session("Role")="2" then
		strEdit=strEdit & "<td width='22%' align='center'><font face='Arial' size='2'><input type='checkbox' name='cancel" & rsSeats("SeatNumber") & "' value='" & rsSeats("SeatNumber") & "'></font></td>"
	else
		strEdit=strEdit & "<td width='22%' align='center'><font face='Arial' size='2'></font></td>"	
	end if
	strEdit=strEdit & "<td width='16%' align='center'><font face='Arial' size='2'>&nbsp;</font></td>"
	strEdit=strEdit & "</tr>"
	rsSeats.movenext
loop


%>
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>EZ-SHOW-TICKETS.com</title>
<script language="JavaScript">
<!--

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v3.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function CancelTicket()
{
	document.fCancelTickets.submit();
}
//-->
</script>

</head>

<body onLoad="MM_preloadImages('../images/BackON.gif','../images/submitON.gif')">


<div align="center" style="width: 700; height: 353">
<form name="fCancelTickets" method="post" action="EditTickets.asp?PerformanceID=<%=PerformanceID%>&amp;PersonID=<%=PersonID%>">
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" height="91%">
    <tr>
      <td height="91%" align="center" width="100%">
        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="700" id="AutoNumber2" align="center" height="347">
          <tr>
            <td height="347">
            <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="346">
              <tr>
                <td width="100%" height="345">
                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%"><img border="0" src="../images/<%=AccountLogo%>"></td>
                  </tr>
                  <tr>
                    <td width="5%" bgcolor="#CCCCCC">&nbsp;</td>
                    <td width="95%" bgcolor="#CCCCCC">
                    <p align="center"></td>
                  </tr>
                  <tr>
                    <td width="5%" bgcolor="#CCCCCC">&nbsp;</td>
                    <td width="95%">
                    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber6">
                      <tr>
                        <td width="20%" align="right"><b>
                        <font face="Arial" color="#000080">Name:&nbsp; </font></b></td>
                        <td width="80%"><b><font face="Arial"><%=strFName & " " & strLName%></font></b></td>
                      </tr>
                      <tr>
                        <td width="20%" align="right"><b>
                        <font face="Arial" color="#000080">Address:&nbsp; </font></b></td>
                        <td width="80%"><font face="Arial" size="2"><%=strAddress%></font></td>
                      </tr>
                      <tr>
                        <td width="20%" align="right"><b>
                        <font face="Arial" color="#000080">City&nbsp; State Zip:&nbsp; </font></b></td>
                        <td width="80%"><font face="Arial" size="2"><%=strCity & ", " & strState & " " & strZip%></font></td>
                      </tr>
                      <tr>
                        <td width="20%" align="right"><b>
                        <font face="Arial" color="#000080">Phone:&nbsp; </font>
                        </b></td>
                        <td width="80%"><font face="Arial" size="2"><%=strPhone%></font></td>
                      </tr>
                      <tr>
                        <td width="20%" align="right"><b>
                        <font face="Arial" color="#000080">E-Mail address:&nbsp; </font></b></td>
                        <td width="80%"><font face="Arial" size="2"><%=strEMail%></font></td>
                      </tr>
                      <tr>
                        <td width="20%" align="right"><b>
                        <font face="Arial" color="#000080">Reference:&nbsp; </font></b></td>
                        <td width="80%"><font face="Arial" size="2"><%=strPurchaseReference%></font></td>
                      </tr>
                      <tr>
                        <td width="20%" bgcolor="#CCCCCC">&nbsp;</td>
                        <td width="80%" bgcolor="#CCCCCC" align="center"><font face="Arial" size="3"><b><%=PerformanceInformation%></b></font></td>
                      </tr>
                    </table>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                      <tr>
                        <td width="20%" align="center"><b><font face="Arial">
                        Seat</font></b></td>
                        <td width="20%" align="center"><b><font face="Arial">
                        Category</font></b></td>
                        <td width="22%" align="center"><b><font face="Arial">
                        Amount Paid (Due)</font></b></td>
                        <td width="22%" align="center"><b><font face="Arial">
                        <%if session("Role")="2" then%>Cancel Ticket<%end if%></font></b></td>
                        <td width="16%" align="center">&nbsp;</td>
                      </tr>
                      <%=strEdit%>
                      <tr>
                        <td width="20%" align="center"><font face="Arial" size="2">&nbsp;</font></td>
                        <td width="20%" align="center"><font face="Arial" size="2">&nbsp;</font></td>
                        <td width="22%" align="center"><font face="Arial" size="2">&nbsp;</font></td>
                        <td width="22%" align="center"><font face="Arial" size="2"><%if session("Role")="2" then%><a href="javascript:CancelTicket();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','../images/SubmitON.gif',1)"><img name="Image1" border="0" src="../images/Submit.gif" WIDTH="80" HEIGHT="25"></a><%end if%></font></td>
                        <td width="16%" align="center"><font face="Arial" size="2">&nbsp;</font></td>
                      </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%" align="center">
						<a href="PerformanceTicketSales.asp?PerformanceID=<%=PerformanceID%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/BackON.gif',1)"><img name="Image0" border="0" src="../images/Back.gif" WIDTH="103" HEIGHT="32"></a>                        
					</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
</div>

</body>

</html>