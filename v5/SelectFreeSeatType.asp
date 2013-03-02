
<!--#INCLUDE file="common.asp"-->

<% 
dim rsSeatingTypes
dim rsPerformancePrices
dim rsTicketPrices
dim rsSpecialValue
dim rsShow,rsPerf,rsCost,rsGA,rsDiscount
dim strCosts,strShows,strPerf
dim intPerf,ReservedFor
dim j,x,iCost,strPriceRange,bSelectTickets,numGASeats
dim bGA,bReserved, strTicket
dim strPerformances,PerfID,sType
dim SpecialValue
dim i
dim SeatNumber
dim rsVerifySeat,rsSeats,rsSeatingCategories,rsSeatInfo,rsPrices
dim strCost
dim num170, num171, num172, num173, numTEA

'dim totalSeats
'INITIALIZE
strShowName=""
strShowNote=""
totalSeats=0
ShowID=0
bSelectTickets=false
j=0

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'GET SHOW INFORMATION
	ShowID=session("ShowID")
	GetShowInformation(ShowID)
'GET ACCOUNT INFORMATION
getAccountInformation session("AccountID")
'GET PERFORMANCE INFORMATION
	PerformanceID=session("PerformanceID")
	getPerformanceInformation(PerformanceID)
'GET THEATER INFORMATION
	getTheaterInformation(TheaterID)
'	session("TheaterID")=TheaterID
	'''''''''''''FOR BOT
	'''''''''''''check if TEA is sold out
	NumTea=0
	if session("AccountID")="5" then
		Num170=getFromRecord("SELECT Count(SHOW_SEATING.SeatNumber) AS CountOfSeatNumber FROM SHOW_SEATING WHERE SHOW_SEATING.CostBasis=170  AND SHOW_SEATING.PerformanceID=" & PerformanceID)
		Num171=getFromRecord("SELECT Count(SHOW_SEATING.SeatNumber) AS CountOfSeatNumber FROM SHOW_SEATING WHERE SHOW_SEATING.CostBasis=171  AND SHOW_SEATING.PerformanceID=" & PerformanceID)
		Num172=getFromRecord("SELECT Count(SHOW_SEATING.SeatNumber) AS CountOfSeatNumber FROM SHOW_SEATING WHERE SHOW_SEATING.CostBasis=172  AND SHOW_SEATING.PerformanceID=" & PerformanceID)
		Num173=getFromRecord("SELECT Count(SHOW_SEATING.SeatNumber) AS CountOfSeatNumber FROM SHOW_SEATING WHERE SHOW_SEATING.CostBasis=173  AND SHOW_SEATING.PerformanceID=" & PerformanceID)
	end if
'DETERMINE SEATING TYPE
'GO TO APPROPRIATE PLACE/DO APPROPRIATE THING
select case getSeatingTypeForPerformance(PerformanceID)
case 1 ' Reserved only
	sType=1
	if Request.QueryString.Count > 0 then
		'loop thru Reserved Seats
		for i = 1 to Request.QueryString.Count
			if Request.QueryString.key(i)<>"NumberOfClicks" then
				SeatNumber=Request.QueryString.key(i)
			    'VERIFY THAT SEATS ARE STILL AVALABLE!
			    set rsVerifySeat=GetSeatForPerformanceOtherPending(PerformanceID,session.SessionID,SeatNumber)
			    'getrecordset("Select SeatNumber from SHOW_SEATING where PerformanceID=" & rsShow("PerformanceID") & " and SeatNumber='" & SeatNumber & "' and ReservationForID <>" & session.SessionID)
				if rsVerifySeat.eof then
				'Seats are available
					'Set seat to PENDING
					SetPendingSeat ShowID,PerformanceID,SeatNumber,session.SessionID 
			else
					'Seat is TAKEN!  Release all the seats and return
					deleterecord "DELETE FROM SHOW_SEATING where ShowID=" & rsShow("ShowID") & " and PerformanceID=" & rsShow("PerformanceID") & " and ReservationForID=" & session.sessionID							
					Response.Redirect "TheaterSeating.asp?ErrMessage=WE ARE SORRY! One or more of these seats are currently reserved by another patron and are pending purchase completion. Please select alternate seats."
				end if
			end if
		next
		if isempty(session("lSessionID")) then session("lSessionID")=session.SessionID
		SetupPendingSeats PerformanceID,session.SessionID
		j=0
		for i=1 to ubound(Seats,2)
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' height='6' colspan='3'>"
			strCost= strCost & "<b><font face='Verdana' size='2'></font></b></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' height='6' colspan='3'>"
			strCost= strCost & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='420'>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' align='left'>"
			strCost= strCost & "<b><font face='Verdana' size='2'>Total Tickets Selected: " & Seats(2,i) & " Reserved Seats</font></b></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' align='left'></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' align='left'>"
			strCost= strCost & "<b><font face='Verdana' size='2'>Reserved Seat Numbers: " & Seats(4,i) & "</font></b></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "</table>"
			strCost= strCost & "</td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420'></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' height='6' colspan='3'>"
			strCost= strCost & "<b><font face='Verdana' size='2'>Select number in each category</font></b></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' height='6' colspan='3'>"
			strCost= strCost & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>"
			'get ticket prices
			set rsPrices=GetSeatPriceFromSeatCategoryID(PerformanceID,Seats(1,i),Seats(5,i))
			do until rsPrices.eof
				
				j=j+1
				strCost= strCost & "<tr>"
				'if session("AccountID")="3" and numTEA > 160 and PerformanceID<>6060 and PerformanceID<>6054 and rsPrices("PriceCategoryID")=6 and session("Admin")="0" then
				'if session("AccountID")="3" and numTEA > 185 and PerformanceID<>6060 and PerformanceID<>6058 and PerformanceID<>6056 and PerformanceID<>6054 and rsPrices("PriceCategoryID")=6 and session("Admin")="0" then
				if session("AccountID")="5" and num170 > 150  and rsPrices("PriceCategoryID")=170 and session("Admin")>="0" then
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>SOLD OUT</font></b></td>"
				elseif session("AccountID")="5" and num171 > 80  and rsPrices("PriceCategoryID")=171 and session("Admin")="0" then
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>SOLD OUT</font></b></td>"
				elseif session("AccountID")="5" and num172 > 30  and rsPrices("PriceCategoryID")=172 and session("Admin")="0" then
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>SOLD OUT</font></b></td>"
				elseif session("AccountID")="5" and num173 > 80  and rsPrices("PriceCategoryID")=173 and session("Admin")="0" then
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>SOLD OUT</font></b></td>"
	
				else	
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0'></td>"
					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (" & formatcurrency(rsPrices("TicketPrice"),2) & " each)</font></b></td>"
				end if
				
				
'				if session("AccountID")="3" and numTEA > 180  and rsPrices("PriceCategoryID")=6 and session("Admin")="0" then
'					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
'					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>TEA SOLD OUT</font></b></td>"
'				elseif session("AccountID")="3" and (PerformanceID=6060 or PerformanceID=6058 or PerformanceID=6056 or PerformanceID=6054)  and rsPrices("PriceCategoryID")=6 and session("Admin")="0" then
'				'elseif session("AccountID")="3" and PerformanceID=6060  and rsPrices("PriceCategoryID")=6 and session("Admin")="0" then
'					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
'					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>TEA SOLD OUT</font></b></td>"
'				
'				else	
'					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0'></td>"
'					strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (" & formatcurrency(rsPrices("TicketPrice"),2) & " each)</font></b></td>"
'				end if
				strCost= strCost & "</tr>"
				rsPrices.movenext
			loop
		next

		strCost= strCost & "<input type='hidden' name='TicketCategories' value='" & j & "'>"
		strCost= strCost & "</table>"
		strCost= strCost & "</td>"
		strCost= strCost & "</tr>"
		
	end if
case 2 'Unreserved only
	if isempty(session("lSessionID")) then session("lSessionID")=session.SessionID
	sType=2
    GetAvailableSeatsForPerformance PerformanceID
    totalSeats=totalSeatsAvailable
	set rsSeatingCategories=getAllSeatingCategoriesForPerformance(PerformanceID)
	i=0
	do until rsSeatingCategories.eof
		i=i+1
		redim preserve Seats(5,i)
		seats(1,i)=rsSeatingCategories("SeatingCategoryID")
		seats(3,i)=rsSeatingCategories("SeatingCategory")
		seats(5,i)=rsSeatingCategories("SeatCategoryID")
		rsSeatingCategories.movenext
	loop
	j=0
	'totalSeats=0
	for i=1 to ubound(Seats,2)
	        if showID <> 1413 then
				strCost= strCost & "<tr>"
				strCost= strCost & "<td width='420' height='6' colspan='2'>"
				'if showid=1597 then
				'	strCost= strCost & "<b><font face='Verdana' size='2'>General Admission </font></b></td>"
				'else
				'	strCost= strCost & "<b><font face='Verdana' size='2'>General Admission (" & totalSeatsAvailable & " on-line tickets remaining)</font></b></td>"
				'end if
				strCost= strCost & "</tr>"
			end if
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420'>&nbsp;</td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' height='6' colspan='2'>"
			'strCost= strCost & "<b><font face='Verdana' size='2'>Select number in each category</font></b></td>"
			strCost= strCost & "<b><font face='Verdana' size='2'>Select up to 2 seats in ONLY one Category</font></b></td>"
			strCost= strCost & "</tr>"
			strCost= strCost & "<tr>"
			strCost= strCost & "<td width='420' height='6' colspan='2'>"
			strCost= strCost & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>"




		'strCost= strCost & "<tr>"
		'strCost= strCost & "<td width='392' height='6' colspan='3'>"
		'strCost= strCost & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>"
		set rsPrices=GetSeatPriceFromSeatCategoryID(PerformanceID,Seats(1,i),Seats(5,i))
		do until rsPrices.eof
			j=j+1
			strCost= strCost & "<tr>"
			if showid=1289 then
			    if rsPrices(0)=149 then
					Specialvalue=0
				else
					Specialvalue=0
				end if
				set rsSpecialValue=getrecordset("SELECT Count(SHOW_SEATING.SeatNumber) AS CountOfSeatNumber FROM SHOW_SEATING WHERE SHOW_SEATING.CostBasis=" & rsPrices(0) & " AND SHOW_SEATING.ShowID=1289")
				if rsSpecialValue(0) < SpecialValue then
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0'></td>"
					strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (" & formatcurrency(rsPrices("TicketPrice"),2) & " each)</font></b></td>"
					strCost= strCost & "</tr>"
				else
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><font face='Verdana' size='0'>SOLD OUT</font></td>"
					strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (" & formatcurrency(rsPrices("TicketPrice"),2) & " each)</font></b></td>"
					strCost= strCost & "</tr>"				
				end if
				rsPrices.movenext
			else
				if rsPrices("TicketPrice") < 0.1 then
						if session("AccountID")="5" and num170 > 150  and rsPrices("PriceCategoryID")=170 and session("Admin")>="0" then
							strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
							strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (SOLD OUT)</font></b></td>"
						elseif session("AccountID")="5" and num171 > 80  and rsPrices("PriceCategoryID")=171 and session("Admin")="0" then
							strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
							strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (SOLD OUT)</font></b></td>"
						elseif session("AccountID")="5" and num172 > 30  and rsPrices("PriceCategoryID")=172 and session("Admin")="0" then
							strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
							strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (SOLD OUT)</font></b></td>"
						elseif session("AccountID")="5" and num173 > 80  and rsPrices("PriceCategoryID")=173 and session("Admin")="0" then
							strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0' readonly></td>"
							strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (SOLD OUT)</font></b></td>"
	
'						else	
'							strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0'></td>"
'							strCost= strCost & "<td width='342'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (" & formatcurrency(rsPrices("TicketPrice"),2) & " each)</font></b></td>"
'						end if
				
				
				
				
					else
						strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0'></td>"
						strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (Free)</font></b></td>"
						strCost= strCost & "</tr>"
					end if
				else
	
					strCost= strCost & "<td width='50'><input type='hidden' name='PriceCategoryType" & j & "' value='" & rsPrices("PriceCategoryID") & "'><input name='PriceCategory" & j & "' size='2' maxlength='2' value='0'></td>"
					strCost= strCost & "<td width='370'><b><font face='Verdana' size='2'>" & rsPrices("PriceCategory") & " (" & formatcurrency(rsPrices("TicketPrice"),2) & " each)</font></b></td>"
					strCost= strCost & "</tr>"
				end if
				rsPrices.movenext
			end if
		loop
	next
	strCost= strCost & "<input type='hidden' name='TicketCategories' value='" & j & "'>"
	strCost= strCost & "</table>"
	strCost= strCost & "</td>"
	strCost= strCost & "</tr>"

end select
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>SELECT SEAT TYPES FOR <%=strShowName%> v060807</title>
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
//-->
</script>
</head>

<body onLoad="MM_preloadImages('images/PurchaseSeatsON.gif','images/CancelTicketsON.gif')">
<script language="javascript"> 

function GoBack(){
//document.location='SelectPerformance.asp';
document.location='events.asp?ReleaseSeats=1';

}

function ReturnToAdmin(){
document.location='admin/AccountAdmin.asp';
}

function ReturnToSite(strSite){
alert(strSite);
document.location=strSite;
}

function PurchaseTickets(n,totalSeats,k,t) 
{
	var i;
	var tot;
	//var test=document.getElementsByName("PriceCategory1")
	//alert(test[0].value);
	//alert(parseInt(document.getElementsByName("PriceCategory1").value));
	//alert(t);
	//Determine if each category is numeric
	tot=0;
	document.fTickets.MoreTicks.value=k;
	for (i=1;i<=n;i++) 
	{
		if (isNaN(parseInt(document.getElementsByName("PriceCategory"+i)[0].value)))
		  {	alert("Please enter a valid number");
			document.getElementsByName("PriceCategory"+i)[0].value="";
			return;
		  }
		else
		  {
			tot=tot+ parseInt(document.getElementsByName("PriceCategory"+i)[0].value)
		  }
	}
	//Be sure that reserved add up to total seats selected
	//if(totalSeats==0)
	//{
	//	if(tot>0)
	//		{document.fTickets.submit();}
	//	else
	//		{
	//		alert("Please enter the number of seats in each price category.");
	//		}	
	//}
	//else
	//{	
	 if(t==1)
		{	
			if(tot==totalSeats)
				{document.fTickets.submit();}
			else
				{
				alert("Please be sure that the number of seats add up to "+totalSeats);
				}
		}
		else
		{
				
			if(tot==0)
				{alert("Please select the number of seats that you wish to purchase");
				 return;
				}	
			else if (tot > 2)
			    {alert("Maxium number of tickets is 2");
			    
			    document.getElementsByName("PriceCategory"+1)[i].value=0;
			    return;}
			else if(tot<=totalSeats)
				{document.fTickets.submit();}
			else
				{
				alert("Please be sure that the number of seats are not more than "+totalSeats);
				}
		}
}


</script>
<table width="100%" height="400">
	<tr>
		<td width="100%" height="400" align="center">
			<table border="0" width="600" height="11">
  				<tr>
    				<td width="150" height="7"><img border="0" src="images/<%=session("AccountLogo")%>"></td>
    				<td width="450" valign="middle" align="center" height="7">
    					<b><font face="Verdana" color="#000080" size="2">
    						Venue Address:</font></b> <br><b><font face="Verdana" size="2"><%=TheaterName%><br></font>
      						<font face="Verdana" size="1"><%=TheaterAddress%><br>
      						<%=TheaterCity%>, <%=TheaterState%> <%=TheaterZip%></font></b>
      						<p>
      						<a target="_blank" href="<%=TheaterMapQuest%>"><b><font face="Verdana" color="#000080" size="1">Click here for a map</font></b></a><br>&nbsp;</p>
      				</td>
  				</tr>
			</table>
			<!--<table border="0" width="600" height="42">  				<tr>    				<td width="600" height="38"><%=strShows%></td>  				</tr>			</table>-->
			<table border="0" width="600" height="9">
  				<!--<tr>
    				<td width="600" height="5" align="center">
					<a href="javascript:GoBack();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/CancelTicketsON.gif',1)"><img name="Image1" border="0" src="images/CancelTickets.gif" WIDTH="350" HEIGHT="32"></a>
    				</td>
  				</tr>-->
  				<tr>
    				<td width="600" bgcolor="#C0C0C0" height="5" align="center">
    					<b><font face="Verdana" color="#000080" size="4">
    						Select Seating Preference
    					</font></b></td>
  				</tr>
			</table>
			<table border="0" width="600">
  				<tr>
    				<td width="600">&nbsp;</td>
  					</tr>
			</table>
			<table border="0" width="600">
  				<tr>
    				<td width="600">
     					<table border="0" width="600" height="86">
        					<tr>
          						<td width="180" height="82" valign="top"><img border="0" src="images/<%=strShowLogo%>"><p align="justify">
                                <br><font face="Arial" size="1"><%=strShowSummary%></font></td>
          						<td width="420" valign="top" align="left" height="115">
            						<table border="0" width="420" height="291">
              							<tr>
                							<td width="420" height="16"><b><font color="#000080" face="Verdana" size="5"><%=strShowName%></font></b></td>
              							</tr>
              							<tr>
                							<td width="420" height="236" valign="top" align="left">
                  								<table border="0" width="420" height="49" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" cellspacing="0">
                    								<tr>
                      					<!--				<td width="120" height="1" valign="top" align="left" colspan="1">                      										<font face="Verdana" size="2"><b>Performance:</b></font>                      									</td>-->
                      									<td width="420" height="20" align="left">
                          									<!--<p><b><font face="Verdana" size="2">Performance:&nbsp;&nbsp;  <%=DayOfWeek(weekday(strPerformanceDate))%> , <%=formatdatetime(strPerformanceDate,vbShortDate)%> at <%=strPerformanceTime%></font></b></p>-->
                         									<p><b><font face="Verdana" size="2"><%=DayOfWeek(weekday(strPerformanceDate))%> , <%=formatdatetime(strPerformanceDate,vbShortDate)%> at <%=strPerformanceTime%></font></b></p>
                        								</td>
                    								</tr>
                                      					<form name="fTickets" method="POST" action="ProcessFreeSeats.asp">
                    										<input type="hidden" name="MoreTicks" value="0" )>
                    										<%=strCost%>
														</form>
                     								<%if showid<>1289 then%>
                     								<tr>
                     				
                      								<td width="420" height="6" colspan="2">
                      									<p align="center">
                      									<!--<input type="button" value="Press HERE to purchase these SEATS" onclick="javascript:PurchaseTickets(<j>,<totalSeats>,0);" id=button1 name=button1>-->
														<a href="javascript:PurchaseTickets(<%=j%>,<%=totalSeats%>,0,<%=sType%>);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','images/PurchaseSeatsON.gif',1)"><img name="Image0" border="0" src="images/PurchaseSeats.gif" WIDTH="200" HEIGHT="32"></a>
                                            		</td>
                    								</tr>
                    								<%end if%>
                    								<!--<tr>
                      								<td width="420" height="6" colspan="2">
                      									<p align="center">
                      									<a href="javascript:PurchaseTickets(<%=j%>,<%=totalSeats%>,1,<%=sType%>);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','images/SelectAnotherPerfON.gif',1)"><img name="Image2" border="0" src="images/SelectAnotherPerf.gif" WIDTH="350" HEIGHT="32"></a>
                                            		</td>
                    								</tr>-->
                    								<tr>
                      									<td width="420" height="6" colspan="2"></td>
                    								</tr>
                  								</table>
                							</td>
              							</tr>
            			</table>
          			</td>
        		</tr>
      		</table>
    	</td>
  	</tr>
</table>

<table border="0" width="100%">
  <tr>
    <td width="100%" valign="top" align="center"></td>
  </tr>
</table>
  <!--#INCLUDE file="bottom_page.inc"-->

		</td>
	</tr>
</table>
</body>

</html>
<script src="webstatscript.js"></script>