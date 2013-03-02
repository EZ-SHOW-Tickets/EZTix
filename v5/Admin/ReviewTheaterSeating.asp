<%@ Language=VBScript %>
<%Option Explicit%>
<!--#INCLUDE file="../../DBConnect.vbs"-->
<% 
dim rs,rsRes,rsShow,rsSeats,rsSections,rsAreas,TheaterName
dim strEbell,strEbellB,red,white,grey,rsTheater,ShowName
dim Row,Seat,Rows(100),strSQL,strTheater,TheaterID,numSeats
dim perfID,showID,x,strErrMessage,TotalWidth,TotalTheater
dim i,j,rsRowLetter
'Initialize
x=1
Rows(0) = "A"
Rows(1) = "B"
Rows(2) = "C"
Rows(3) = "D"
Rows(4) = "E"
Rows(5) = "F"
Rows(6) = "G"
Rows(7) = "H"
Rows(8) = "I"
Rows(9) = "J"
Rows(10) = "K"
Rows(11) = "L"
Rows(12) = "M"
Rows(13) = "N"
Rows(14) = "O"
Rows(15) = "P"
Rows(16) = "Q"
Rows(17) = "R"
Rows(18) = "S"
Rows(19) = "T"
Rows(20) = "U"
Rows(21) = "V"
Rows(22) = "W"
Rows(23) = "X"
Rows(24) = "Y"
Rows(25) = "Z"
Rows(26) = "AA"
Rows(27) = "BB"
Rows(28) = "CC"
Rows(29) = "DD"
Rows(30) = "EE"
Rows(31) = "FF"
Rows(32) = "GG"
Rows(33) = "HH"
red="'#FF0000'"
white="'#FFFFFF'"
grey ="'#C0C0C0'"
if isempty(Request.QueryString("ErrMessage")) then
	strErrMessage=""
else
	strErrMessage="<tr><td width='10' height='33' bgcolor='#003366'>&nbsp;</td><td width='780' height='33' align='Right'  bgcolor='#003366'><p align='center'><font face='Arial' size='2' color='#FF0000'><b>" & Request.QueryString("ErrMessage") & "</b></font></p></td><td width='10' height='33'  bgcolor='#003366'>&nbsp;</td></tr>"
end if
if isempty(session("PerformanceID")) then
'	if isempty(Request.QueryString("Show")) then
'		session("PerformanceID")=2
'		session("Show")="2"
'	else
		session("PerformanceID")=Request.QueryString("PerformanceID")
'		session("Show")=Request.QueryString("Show")
'	end if
end if
perfID=session("PerformanceID")
set rsShow=getrecordset("Select PERFORMANCES.*,Show,TheaterID from SHOWS,PERFORMANCES where SHOWS.ShowID=PERFORMANCES.ShowID and PerformanceID=" & perfID)
deleterecord "Delete from SHOW_SEATING where PaymentID =-1 and ResearveTime < '" & dateadd("n",-10,now()) & "'"
updaterecord "Update SHOW_SEATING set PaymentID=-2,ReservationForID=-2 where ReservationForID > 10000000 and PaymentID=-2 and ResearveTime < '" & dateadd("n",-10,now()) & "'"
TheaterID=rsShow("TheaterID")
'session("TheaterID") =TheaterID
set rsTheater=getrecordset("select * from THEATERS where TheaterID=" & TheaterID)
if not rsTheater.eof then
	TheaterName=rsTheater("TheaterName")
else
	TheaterName=TheaterID
end if
'Get maximum width (Areas)
set rsAreas=getrecordset("Select max(Area) as TotAreas from THEATER_SEATING where TheaterID=" & TheaterID)
'Get Most seats across
set rsSeats=getrecordset("Select max(seat) as TotSeats from THEATER_SEATING where TheaterID=" & TheaterID)
'need 200 for each area
'TotalWidth=34*(rsSeats("TotSeats"))
'TotalWidth=14*(rsSeats("TotSeats"))
TotalWidth=24*(rsSeats("TotSeats"))
TotalTheater=TotalWidth-20
'loop thru each Section
set rsSections=getrecordset("Select SectionID,SectionName from THEATER_SECTIONS where TheaterID=" & TheaterID)
do until rsSections.eof 'Sections
	'loop thru each Area
	strTheater=strTheater & "<tr><td width='10' height='16' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='16' align='center' bgcolor='#FFFFCC'><b>" & rsSections("SectionName") & "<b></td> <td width='10' height='16'  bgcolor='#003366'>&nbsp;</td></tr>"
	strTheater=strTheater & "<tr><td width='10' height='16' bgcolor='#003366'>&nbsp;</td><td width='" & TotalTheater & "' height='16'><table width='" & TotalTheater & "'  bgcolor='#FFFFCC'><tr>"
	set rsAreas=getrecordset("Select distinct Area from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " order by Area")
    do until rsAreas.eof 'Areas
			'Get Most seats across for this section
			set rsSeats=getrecordset("Select max(abs(seat)) as HiSeats,min(abs(seat)) as LoSeats from THEATER_SEATING where TheaterID=" & TheaterID & " and Area=" & rsAreas("Area")& " and TSection=" & rsSections("SectionID"))
			numSeats=rsSeats("HiSeats")-rsSeats("LoSeats")
			'strTheater=strTheater & "<td width='" & numSeats*13  & "'><table border='1' cellspacing='0' width='" & numSeats*13  & "' cellpadding='0' height='32' align='center'>"
			'strTheater=strTheater & "<td width='" & numSeats*33  & "'><table border='1' cellspacing='0' width='" & numSeats*33  & "' cellpadding='0' height='32' align='center'>"
			'strTheater=strTheater & "<td width='" & numSeats*13  & "'><table border='1' cellspacing='0' width='" & numSeats*13  & "' cellpadding='0' height='32' align='center'>"
			strTheater=strTheater & "<td width='" & numSeats*23  & "'><table border='1' cellspacing='0' width='" & numSeats*23  & "' cellpadding='0' height='32' align='center'>"
			set rs=getrecordset("Select distinct Row from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " and Area=" & rsAreas("Area") & " order by Row")
				do until rs.eof 'Rows
				    set rsRowLetter=getrecordset("Select RowLetter from THEATER_ROW_LETTERS where TheaterID=" & TheaterID & " and Row=" & rs("Row"))
					strTheater=strTheater & "<tr><td width='10' bgcolor='#666666'><font face='Arial' size='1' color='#FFFFFF'>" & rsRowLetter("RowLetter") & "</font></td>"
					strSQL="Select E.*,S.ReservationForID,S.PerformanceID,S.CostBasis FROM (select * from SHOW_SEATING where PerformanceID=" & perfID & ") as S RIGHT OUTER JOIN (Select seat,SeatNumber from THEATER_SEATING where TheaterID=" & TheaterID & " and TSection=" & rsSections("SectionID") & " and Area=" & rsAreas("Area") & " and row =" & rs("row") & ") as E ON S.SeatNumber = E.SeatNumber order by abs(Seat)"
					set rsSeats=getrecordset(strSQL)
					do until rsSeats.eof 'Seats
						if rsSeats("seat") > 0 then
							if isnull(rsSeats("ReservationForID")) then
								'Available
								strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='20' height='16' align='middle' bgcolor='#FFFFFF'><font face='Arial' size='1'>" & trim(right(rsSeats("SeatNumber"),2)) & "</font></td>"
								'strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='10' height='16' align='middle' bgcolor='#FFFFFF'><font face='Arial' size='1'>" & trim(right(rsSeats("SeatNumber"),2)) & "</font></td>"
								'strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='15' height='16' align='middle' bgcolor='#FFFFFF'><font face='Arial' size='1'>" & trim(right(rsSeats("SeatNumber"),2)) & "</font></td>"
							elseif rsSeats("CostBasis")=8 then
							'General Admission
								strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='10' height='16' align='middle' bgcolor='#00CC99'><font face='Arial' size='1'>" & trim(right(rsSeats("SeatNumber"),2)) & "</font></td>"
								else
								'Reserved
								'strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='10' height='16' align='middle' bgcolor='#009999'><font face='Arial' size='1' color='#FFFFFF'>" & trim(right(rsSeats("SeatNumber"),2)) & "</font></td>"
								strTheater=strTheater & "<td id='T" & rsSeats("SeatNumber") & "' name='T" & rsSeats("SeatNumber") & "' width='20' height='16' align='middle' bgcolor='#009999'><font face='Arial' size='1' color='#FFFFFF'>" & trim(right(rsSeats("SeatNumber"),2)) & "</font></td>"
							end if
						else
							'Not avalable
							'strTheater=strTheater & "<td width='10' height='16' align='middle'></td>"
							strTheater=strTheater & "<td width='15' height='16' align='middle'></td>"
					    end if
					    rsSeats.movenext
					loop				 'Seats
					strTheater=strTheater & "<td width='10' bgcolor='#666666'><font face='Arial' size='1' color='#FFFFFF'>" & rsRowLetter("RowLetter") & "</font></td></tr>"
					rs.movenext
				loop  'Rows
			strTheater=strTheater & "</table></td>"
			rsAreas.movenext
		loop   'Areas
		strTheater=strTheater & "</tr></table></td><td width='10' height='16'  bgcolor='#003366'>&nbsp;</td></tr>"
		rsSections.movenext
loop 'Sections
'Clean
set rs=nothing
set rsSeats=nothing
set rsSections=nothing
set rsAreas=nothing
set rsSections=nothing
%>
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>SELECT SEATS FOR <%=TheaterName%></title>
</head>

<body bgcolor="#FFFFCC">
<script language="javascript"> 
function ChangeColor(x,Seat){
//alert(x.checked);
//alert(Seat.name);
//alert(document.SeatingForm.tCheckbox.parentElement.style.backgroundColor);
if(x.checked==true)
	{Seat.style.backgroundColor='#CC6699';}
else
	{Seat.style.backgroundColor='#009999';}
	}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function SubmitSelection(){
document.SeatingForm.submit();
}
function BackToSelection(){
document.location='SelectShowForReport.asp';
}

</script>
<table width="100%">
<tr>
<td width="100%" align="center">
<table border="0" cellspacing="0" width="<%=TotalWidth%>" cellpadding="0">
<form name="SeatingForm" type="Post" action="verify_selection.asp">
  <!--<tr>
    <td width="20" height="20" bgcolor="#003366">&nbsp;</td>
    <td width="<%=TotalTheater%>" height="20" align="Right" bgcolor="#003366">
     </td>
    <td width="10" height="20" bgcolor="#003366">&nbsp;</td>
  </tr> --> 
  <tr>
    <td width="10" height="16" bgcolor="#003366">&nbsp;</td>
    <td width="<%=TotalTheater%>" height="16" align="Right"   bgcolor="#003366">
      <p align="center"><input type="button" Value="Select Another Performance" onclick="javascript:BackToSelection();" id=button1 name=button1>&nbsp;&nbsp;<input type="button" value="Print" onclick="javascript:print();" id=button3 name=button3>
       </p>
	</td>
    <td width="10" height="16"  bgcolor="#003366">&nbsp;</td>
 <!-- </tr>  <tr>
    <td width="10" height="33" bgcolor="#003366">&nbsp;</td>
    <td width="<%=TotalTheater%>" height="33" align="Right"   bgcolor="#003366">
      <p align="center"><font face="Arial" size="6" color="#FFFFFF"><b><%=TheaterName%></b></font></p>
	</td>
    <td width="10" height="33"  bgcolor="#003366">&nbsp;</td>
  </tr>-->
   <tr>
    <td width="10" height="16" bgcolor="#003366"></td>
    <td width="<%=TotalTheater%>" height="16" align="Center"  bgcolor="#003366">
    <font face="Arial" size="3" color="#FFFFFF"><b><%=rsShow("Show") & " " & rsShow("ShowDate") & " " & rsShow("ShowTime")%>
	</b></font></td>
    <td width="10" height="16" bgcolor="#003366"></td>
  </tr>
    <tr>
    <td width="10" height="16" bgcolor="#003366"></td>
    <td width="<%=TotalTheater%>" height="16" align="Center"  bgcolor="#003366">
	<table width="<%=TotalTheater%>">
	<tr>
	<td width="35%" bgcolor="#003366"></td>
	<td width="10%" bgcolor="#FFFFFF" align="center"><font face='Arial' size='2'><b>Available</b></font></td>
	<td width="10%" bgcolor="#009999" align="center"><font face='Arial' size='2' color='#FFFFFF'><b>Reserved</b></font></td>
	<td width="10%" bgcolor="#00CC99" align="center"><font face='Arial' size='2' color='#FFFFFF'><b>Open Seating</b></font></td>
	<td width="35%"bgcolor="#003366"></td>
	</tr>
	</table>
	</td>
    <td width="10" height="16" bgcolor="#003366"></td>
  </tr>   <!--<tr>
    <td width="10" height="33" bgcolor="#003366">&nbsp;</td>
    <td width="<%=TotalTheater%>" height="33" align="Right"  bgcolor="#003366">
      <table border="0" cellspacing="0" width="100%" id="AutoNumber1">
        <tr>
          <td width="50">&nbsp;</td>
          <td width=<%=TotalTheater-100%>   bgcolor="#CC9900">
          <p align="center"><font face="Impact" size="5" color="#663300"><b>STAGE</b></font></p>
			</td>
          <td width="50">&nbsp;</td>
        </tr>
      </table>
	</td>
    <td width="10" height="33"  bgcolor="#003366">&nbsp;</td>
  </tr>-->
    <%=strTheater%>
  </tr> 
    </form>
</table>
</td></tr></table>
</body>

</html>