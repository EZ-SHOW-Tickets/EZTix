<!--#INCLUDE file="../common.asp"-->
<%
dim rsShows,strShows
dim rsPerf,strPerfs
dim rsSeats,strSeats
dim rsSubscribers,strSubscribers
dim rsSeating,rsSeatType,SeatType()
dim i,j,nselected,SeatsSelected(),ReserveFor,nSeats
dim PackageID
PackageID="20"
if not isempty(Request.Form("rAssign")) then
	for i= 1 to Request.Form.count
		if Request.Form.Key(i) <> "rAssign" and Request.Form.Key(i) <> "sShow" and Request.Form.Key(i) <> "sPerf" then
			nselected=nselected + 1
			redim preserve SeatsSelected(nselected)
			SeatsSelected(nselected)=Request.Form(Request.Form.Key(i))
		end if
	next
	redim SeatType(nselected)
	ReserveFor=Request.Form("rAssign")
	'Determine Seat Types
	set rsSeatType=getrecordset("Select PACKAGE_SEAT_TYPES.* from PACKAGE_SEAT_TYPES,PACKAGE_PERSON,PERFORMANCE_RESERVATIONS where PACKAGE_SEAT_TYPES.PackagePersonID=PACKAGE_PERSON.PackagePersonID and PACKAGE_PERSON.TransactionNumber > 0 and PACKAGE_PERSON.PackagePersonID=PERFORMANCE_RESERVATIONS.PackagePersonID and PersonID=" & ReserveFor & " and PerformanceID=" & session("PerformanceID"))
	set rsSeating=GetSeatPricesForAPerformance(session("PerformanceID"))
	do until rsSeatType.eof
			for j= 1 to rsSeatType("NumberOfSeats")
				nSeats=nSeats + 1
				if rsSeating("PriceCategoryID") =1 or rsSeating("PriceCategoryID") =2 then
				'No tea
					if left(rsSeatType("PackageSeatType"),1)="A" then
						SeatType(nSeats)=1
					else
						SeatType(nSeats)=2
					end if
				else
				'Tea
					if instr(1,rsSeatType("PackageSeatType"),"Tea") then
						SeatType(nSeats)=6
					else
						SeatType(nSeats)=5
					end if							
				end if
			next
			rsSeatType.movenext
		loop
	'Get number of seats to assign
	set rsSubscribers=getrecordset("Select SeatAssignedID from SEASON_TICKETS_ASSIGN where PerformanceID=" & session("PerformanceID") & " and SeatNumberAssigned=0 and PersonID=" & ReserveFor)	
	i=0
	nSeats=0
	do until rsSubscribers.eof
		i=i+1
		if i<=nselected then
			updaterecord "UPDATE SHOW_SEATING set ReservationForID=" & ReserveFor & ",PaymentID=5,PaymentReceiptID=1,ResearveTime='" & now() & "',CostBasis=" & SeatType(i) & " where PerformanceID=" & session("PerformanceID") & " and SeatNumber='" & SeatsSelected(i) & "'"
			updaterecord "UPDATE SEASON_TICKETS_ASSIGN set SeatNumberAssigned=1 where SeatAssignedID=" & rsSubscribers("SeatAssignedID")
		end if
		rsSubscribers.movenext
	loop
end if
'Get all shows for this account that have season tickets
if not isempty(Request.QueryString("ShowID")) then
	ShowID=Request.QueryString("ShowID")
	'get Performances
	set rsPerf=getrecordset("Select PERFORMANCES.* from PERFORMANCES where ShowID=" & ShowID)
	do until rsPerf.eof
		strPerfs=strPerfs & "<option value='" & rsPerf("PerformanceID") & "'>" & rsPerf("ShowDate") & " " & rsPerf("ShowTime") & "</option>"
		rsPerf.movenext
	loop
elseif not isempty(Request.QueryString("PerformanceID")) then
	'Get SeasonTicket Seats
	PerformanceID=Request.QueryString("PerformanceID")
	session("PerformanceID")=PerformanceID
	set rsPerf=getrecordset("Select PERFORMANCES.* from PERFORMANCES where PerformanceID=" & PerformanceID)
	ShowID=rsPerf("ShowID")
	set rsPerf=getrecordset("Select PERFORMANCES.* from PERFORMANCES where ShowID=" & ShowID)
	do until rsPerf.eof
		if cint(PerformanceID)=rsPerf("PerformanceID") then
			strPerfs=strPerfs & "<option value='" & rsPerf("PerformanceID") & "' selected>" & rsPerf("ShowDate") & " " & rsPerf("ShowTime") & "</option>"
		else	
			strPerfs=strPerfs & "<option value='" & rsPerf("PerformanceID") & "'>" & rsPerf("ShowDate") & " " & rsPerf("ShowTime") & "</option>"
		end if
		rsPerf.movenext
	loop
	set rsSeats=getrecordset("Select * from SHOW_SEATING where PerformanceID=" & PerformanceID & " and CostBasis=120 order by SeatNumber")
	session("ShowID")=ShowID
	do until rsSeats.eof	
			strSeats = strSeats & "<tr><td width='22%'>" & rsSeats("SeatNumber") & "</td><td width='78%'><input type='Checkbox' name='U" & rsSeats("SeatNumber") & "' value='" & rsSeats("SeatNumber") & "'>Assign</td></tr>"
		rsSeats.movenext
	loop
	'Get Season Ticket Holders
	set rsSubscribers=getrecordset("Select PERSON.PersonID,PersonFirstName,PersonLastName,count(SeatAssignedID) as SeatsRequired from PERSON,SEASON_TICKETS_ASSIGN,PACKAGE_PERSON where PERSON.PersonID=SEASON_TICKETS_ASSIGN.PersonID and PERSON.PersonID=PACKAGE_PERSON.PersonID and PACKAGE_PERSON.TransactionNumber > 0 and PerformanceID=" & PerformanceID & " and SeatNumberAssigned=0 Group By PERSON.PersonID,PersonFirstName,PersonLastName")	
	do until rsSubscribers.eof
		strSubscribers=strSubscribers &  "<tr><td width='50' align='center'><input type='radio' name='rAssign' Value='" & rsSubscribers("PersonID") & "'></td><td width='50' align='center'>" & rsSubscribers("SeatsRequired") & "</td><td width='202' align='center'>" & rsSubscribers("PersonFirstName") & " " & rsSubscribers("PersonLastName") & "</td></tr>"	
		rsSubscribers.movenext
	loop	
else
	ShowID="-1"
end if
set rsShows=getrecordset("Select SHOWS.* from SHOWS,PACKAGE_SHOWS where  SHOWS.ShowID=PACKAGE_SHOWS.ShowID and PackageID=" & PackageID)
do until rsShows.eof
    if rsShows("ShowID")=cint(ShowID) then
		strShows=strShows & "<option value='" & rsShows("ShowID") & "' selected>" & rsShows("Show") & "</option>"
	else
		strShows=strShows & "<option value='" & rsShows("ShowID") & "'>" & rsShows("Show") & "</option>"
	end if
	rsShows.movenext
loop

%>

<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Edit Seating</title>
</head>

<body>
<script language="javascript"> 

function Getperformances()
{
//alert(document.FSeats.sShow.selectedIndex);
document.location='SeasonTicketSeating.asp?ShowID='+document.FSeats.sShow[document.FSeats.sShow.selectedIndex].value;

}

function GetSeats()
{
document.location='SeasonTicketSeating.asp?PerformanceID='+document.FSeats.sPerf[document.FSeats.sPerf.selectedIndex].value;

}
</script>
<table width="100%">
<form name="FSeats" Method="Post" action="SeasonTicketSeating.asp">

<tr>
<td width="100%" align="center">
  <table border="0" cellpadding="0" cellspacing="0" width="656">
    <tr>
      <td width="181" align="right" bgcolor="#003366">&nbsp;</td>
      <td width="150" bgcolor="#003366">&nbsp;</td>
      <td width="302" bgcolor="#003366">&nbsp;</td>
      <td width="23" bgcolor="#003366">&nbsp;</td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366">
      <font face="Arial" color="#FFFFFF" size="2"><b>Show:&nbsp; </b></font></td>
      <td width="150" bgcolor="#FFFFCC"><select name="sShow" onchange="javascript:Getperformances();"><option value="0">---Select---</option><%=strShows%></select></td>
     <td width="302" bgcolor="#FFFFCC">&nbsp;</td>
    <td width="23" bgcolor="#003366">&nbsp;</td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366">
      <font face="Arial" color="#FFFFFF" size="2"><b>Performance:&nbsp; </b>
      </font></td>
      <td width="150" bgcolor="#FFFFCC"><select name="sPerf" onchange="javascript:GetSeats();"><option value="0">---Select---</option><%=strPerfs%></select>
      </td>
       <td width="302" bgcolor="#FFFFCC">&nbsp;</td>
     <td width="23" bgcolor="#003366">&nbsp;</td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366"><b>
      <font face="Arial" color="#FFFFFF" size="1">Reservation For</font><font face="Arial" color="#FFFFFF" size="2">:</font></b></td>
      <td width="150" bgcolor="#FFFFCC"><FirstName & " " & LastName></td>
      <td width="302" bgcolor="#FFFFCC">&nbsp;</td>
      <td width="23" bgcolor="#003366"></td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366">&nbsp;</td>
      <td width="150" bgcolor="#FFFFCC">
		<strAmountDue></td>
      <td width="302" bgcolor="#FFFFCC">&nbsp;</td>
      <td width="23" bgcolor="#003366">
      &nbsp;</td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366">&nbsp;</td>
      <td width="150" bgcolor="#FFFFCC">
      
      
      <table border="0" cellspacing="1" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1">

        <tr>
          <td width="22%"><b><font face="Arial" size="2">Seat Number</font></b></td>
          <td width="78%">&nbsp;</td>
        </tr>
        <%=strSeats%>

        <tr>
          <td width="22%" align="left"><strSecondaryNote></td>
          <td width="78%"></td>
        </tr>

        <tr>
          <td width="22%">&nbsp;</td>
          <td width="78%"><input type="submit" value="SUBMIT"></td>
        </tr>
        </table>
      </td>
      <td width="302" bgcolor="#FFFFCC" valign="top">
      <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#999999" width="100%" id="AutoNumber2">
        <tr>
          <td width="50" align="center"><b><font face="Arial" size="2">Select</font></b></td>
          <td width="50" align="center"><b><font face="Arial" size="2">Seats</font></b></td>
          <td width="202" align="center"><b><font face="Arial" size="2">Name</font></b></td>
        </tr>
			<%=strSubscribers%>
      </table>
      </td>
      <td width="23" bgcolor="#003366"></td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366"></td>
      <td width="150" bgcolor="#FFFFCC"></td>
      <td width="302" bgcolor="#FFFFCC">&nbsp;</td>
      <td width="23" bgcolor="#003366">&nbsp;</td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366"></td>
      <td width="250">
        <div align="left">
          <table border="1" cellpadding="0" cellspacing="0" width="250" bordercolor="#0000FF">
          </table>
        </div>
      </td>
      <td width="302" bgcolor="#FFFFCC">&nbsp;</td>
      <td width="23" bgcolor="#003366">
        &nbsp;</td>
    </tr>
    <tr>
      <td width="181" align="right" bgcolor="#003366">&nbsp;</td>
      <td width="250" bgcolor="#003366">
        &nbsp;</td>
       <td width="302" bgcolor="#003366">&nbsp;</td>
     <td width="23" bgcolor="#003366">
        &nbsp;</td>
    </tr>
  </table>
</td></tr>
        </form>
</table>
</body>

</html>