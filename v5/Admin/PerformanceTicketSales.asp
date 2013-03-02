<!--#INCLUDE file="../common.asp"-->
<%
dim rsPriceCategory,rsPurchasers,rsTickets
dim PerformanceInformation
dim strTickets,strTypes,totDue
dim n,i
dim Prices(),totTickets,seatNumbers
dim Totals(),TotalAllTickets,strAllTypes
dim totalAllDue,totalAllPaid,indivPayment
dim rsSeatingCategory
dim strPurchasedFor
totalAllDue=-0
totalAllPaid=0

'Set ACCOUNTID
if isempty(Session("AccountID")) then
	AccountID="10"
else
	AccountID=Session("AccountID")
end if
GetAccountInformation AccountID

If isempty(Request.QueryString("PerformanceID")) then
	PerformanceID=292
else
	PerformanceID=Request.QueryString("PerformanceID")
end if
getPerformanceInformation PerformanceID
getShowInformation ShowID
PerformanceInformation=strShowName & " " & strPerformanceDate & " " & strPerformanceTime
set rsPriceCategory=getSeatPricesForAPerformance(PerformanceID)
redim prices(3,0)
n=0
do until rsPriceCategory.eof
	n=n+1
	redim preserve prices(3,n)
	prices(1,n)=rsPriceCategory("PriceCategoryID")
	prices(2,n)=rsPriceCategory("TicketPrice")
	prices(3,n)=rsPriceCategory("PriceCategory")
	rsPriceCategory.movenext	
loop
redim Totals(n)
set rsPurchasers=GetAllPeopleAtAPerformance(PerformanceID)
do until rsPurchasers.eof
	redim Seats(4,0)
	for i=1 to ubound(prices,2)
		redim preserve seats(4,i)
		seats(2,i)=prices(1,i)
		seats(3,i)=prices(2,i)
	next
	set rsTickets=GetPurchasedSeatsForAPerformancesForPerson(PerformanceID,rsPurchasers("PersonID"))
	do until rsTickets.eof
		for i=1 to ubound(seats,2)
			if seats(2,i)=rsTickets("CostBasis") then
				set rsSeatingCategory=getSeatingCategoryForPerformanceAndSeat(PerformanceID,TheaterID,rsTickets("seatnumber"))	
				if rsSeatingCategory("SeatingCategoryID")=1 then
					seats(1,i)=seats(1,i) & " " & rsTickets("seatnumber")
				end if
				seats(4,i)=seats(4,i)+1
				TotalAllTickets=TotalAllTickets+1
				Totals(i)=Totals(i)+1
			end if
		next
		rsTickets.movenext
	loop
	totTickets=0

	seatNumbers=""
	strTypes=""
	for i=1 to ubound(seats,2)
		totTickets=totTickets+seats(4,i)
		seatNumbers=seatNumbers & seats(1,i)
		if seats(4,i) > 0 then
			strTypes=strTypes & seats(4,i) & " " & prices(3,i) & "<br>"
		end if
	next
	if totTickets > 0 then
		GetAmountDuePaidForPerformancePerson PerformanceID,rsPurchasers("PersonID")
		totalAllDue=totalAllDue-totalAmountDue
		totalAllPaid=totalAllPaid+totalAmountPaid
		if totalAmountPaid > 0 then
			indivPayment=totalAmountpaid
		else
			indivPayment=-totalAmountDue
		end if
		if strcomp(rsPurchasers("PersonFirstName") & " " & rsPurchasers("PersonlastName"),PaymentFor)<>0 and len(trim(PaymentFor)) > 0 then
			strPurchasedFor="<br><font face='Arial' size='1'>(For " & PaymentFor & ")</font>"
		else
			strPurchasedFor=""
		end if
		'strTickets=strTickets & "<tr><td width='14%' align='center'><font face='Arial' size='2'><a href='EditTickets.asp?PerformanceID=" & PerformanceID & "&PersonID=" & rsPurchasers("PersonID") & "'>" & rsPurchasers("PersonLastName") & "," & rsPurchasers("PersonFirstName") & strPurchasedFor & "</a></font></td><td width='8%' align='center'><font face='Arial'  size='2'>" & totTickets & "</font></td><td width='20%' align='center'><font face='Arial' size='1'>" & SeatNumbers & "</font></td><td width='22%' align='center'><font face='Arial'  size='2'>" & strTypes & "</font></td><td width='10%' align='center'><font face='Arial'  size='2'>" & formatcurrency(totalAmountDue,2) & "</font></td><td width='11%' align='center'><font face='Arial'  size='2'>" & formatcurrency(totalAmountPaid,2) & "</font></td><td width='21%' align='center'>" & PaymentType & "</td></tr>"
		strTickets=strTickets & "<tr><td width='14%' align='center'><font face='Arial' size='2'><a href='EditTickets.asp?PerformanceID=" & PerformanceID & "&PersonID=" & rsPurchasers("PersonID") & "'>" & rsPurchasers("PersonLastName") & "," & rsPurchasers("PersonFirstName") & strPurchasedFor & "</a></font></td><td width='8%' align='center'><font face='Arial'  size='2'>" & totTickets & "</font></td><td width='20%' align='center'><font face='Arial' size='1'>" & SeatNumbers & "</font></td><td width='22%' align='center'><font face='Arial'  size='2'>" & strTypes & "</font></td><td width='10%' align='center'><font face='Arial'  size='2'>" & formatcurrency(indivPayment,2) & "</font></td><td width='11%' align='center'><font face='Arial'  size='2'>" & formatdatetime(ReserveTime,vbshortdate) & "</font></td><td width='21%' align='center'>" & PaymentType & "</td></tr>"
	end if
	rsPurchasers.movenext
loop
for i=1 to ubound(prices,2)
    if Totals(i) > 0 then
		strAllTypes=strAllTypes & Totals(i) & " " & prices(3,i) & "<br>"
	end if
next

if TotalAllTickets > 0 then
	if totalAllDue > 0 then
		totalAllDue=formatcurrency(totalalldue,2)
	else
		totalAllDue="($0.00)"
	end if
	strTickets=strTickets & "<tr><td width='14%' align='center'><font face='Arial' size='2'><b>TOTAL</b></font></td><td width='8%' align='center'><font face='Arial'  size='2'>" & TotalAllTickets & "</font></td><td width='20%' align='center'><font face='Arial' size='1'></font></td><td width='22%' align='center'><font face='Arial'  size='2'>" & strAllTypes & "</font></td><td width='10%' align='center'><font face='Arial'  size='2'>" & formatcurrency(totalAllPaid,2) &  totalAllDue & "</font></td><td width='11%' align='center'></td><td width='21%' align='center'></td></tr>"
else
	strTickets="<tr><td width='100%' align='center'><font face='Arial' size='2'><b>No Tickets Sold</b></font></td></tr>"
end if
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

function GetEvent()
{
	if (document.fPA.sEvent.selectedIndex==0)
		{alert("Please select an Event");}
		else
		{document.location="PerformanceAnalysis.asp?EventID="+document.fPA.sEvent[document.fPA.sEvent.selectedIndex].value;}
}
//-->
</script>

</head>

<body onLoad="MM_preloadImages('../images/BackON.gif')">


<div align="center">
<form name="fPA">
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
                    <p align="center"><b><font face="Arial"><%=PerformanceInformation%></font></b></td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                      <tr>
                        <td width="100%">
                        </td>
                      </tr>
                      <tr>
                        <td width="100%">
                        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber7">
                          <%if totalAllTickets> 0 then%>
                          <tr>
                            <td width="14%" align="center"><b>
                            <font face="Arial" size="2">Name</font></b></td>
                            <td width="8%" align="center"><b>
                            <font face="Arial" size="2">Quantity</font></b></td>
                            <td width="20%" align="center"><b>
                            <font face="Arial" size="2">Reserved Seats</font></b></td>
                            <td width="22%" align="center"><b>
                            <font face="Arial" size="2">Type</font></b></td>
                            <td width="10%" align="center"><b>
                            <font face="Arial" size="2">Amount<br>Paid(Due)</font></b></td>
                            <td width="12%" align="center"><b>
                            <font face="Arial" size="2">Date<br>Reserved</font></b></td>
                            <td width="21%" align="center"><b>
                            <font face="Arial" size="2">Payment</font></b></td>
                          </tr>

                          <%end if%>
<!--                          <tr>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="15%">&nbsp;</td>                          </tr>-->
                          <%=strTickets%>
                        </table>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%">&nbsp;</td>
                      </tr>
                    </table>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%" align="center">
						<a href="PerformanceAnalysis.asp?EventID=<%=ShowID%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/BackON.gif',1)"><img name="Image0" border="0" src="../images/Back.gif" WIDTH="103" HEIGHT="32"></a>                        
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