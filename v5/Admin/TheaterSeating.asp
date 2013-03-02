<!--#INCLUDE file="../common.asp"-->

<%
dim red,white,grey
dim rs,rsRes,rsShow,rsTheater,rsRowLetter
dim perfID
dim strTheater,strErrMessage
dim Row,Seat,numSeats,RowLetter,TotalTheater,TotalWidth
dim i,j,x,n,numseat,seatNumber
Response.Expires=-1

x=1

grey ="#C0C0C0"

'Set PerformanceID
	'session("PerformanceID")=293
	if isempty(Request.QueryString("PerformanceID")) then 'session("PerformanceID")=Request.QueryString("PerformanceID")
		performanceID=session("PerformanceID")
	else
		PerformanceID=Request.QueryString("PerformanceID")
		session("PerformanceID")=PerformanceID
	end if
'Get basic information for this performance
	'Show information
	GetShowInformationFromPerformance(PerformanceID)
	'session("ShowID")=ShowID
	'Set Theater information
	GetTheaterInformation(TheaterID)
	'session("TheaterID") =TheaterID
	'Performance information
	GetPerformanceInformation(PerformanceID)
	'Get Account information
	GetAccountInformation(session("AccountID"))
'Process Request
	for i = 1 to Request.QueryString.Count
		if Request.QueryString.key(i)<>"SeatType" then 
			SeatNumber=Request.QueryString.key(i)
			if Request.QueryString("SeatType")="100" then
				'Unset seats to make available
				'loop thru each seat and delete from table (make it available)
				deleterecord "DELETE FROM SHOW_SEATING where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'"
			elseif Request.QueryString("SeatType")="110" then
			    set rs=getrecordset("select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'") 
				if rs.eof then
					strSQL="INSERT INTO SHOW_SEATING (PerformanceID,ShowID,SeatNumber,ReservationForID,PaymentID,CostBasis)"
					strSQL=strSQL & " values(" & PerformanceID & "," & ShowID & ",'" & SeatNumber & "',-1,-1,110)"
					x=insertrecord(strSQL,"SHOW_SEATING","PerformanceID")
				else
					strSQL="UPDATE SHOW_SEATING set CostBasis=110 where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'" 
					updaterecord strSQL
				end if
			elseif Request.QueryString("SeatType")="120" then
			    set rs=getrecordset("select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'") 
				if rs.eof then
					strSQL="INSERT INTO SHOW_SEATING (PerformanceID,ShowID,SeatNumber,ReservationForID,PaymentID,CostBasis)"
					strSQL=strSQL & " values(" & PerformanceID & "," & ShowID & ",'" & SeatNumber & "',-1,-1,120)"
					x=insertrecord(strSQL,"SHOW_SEATING","PerformanceID")
				else
					strSQL="UPDATE SHOW_SEATING set CostBasis=120 where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'" 
					updaterecord strSQL
				end if	
			elseif Request.QueryString("SeatType")="130" then
			    set rs=getrecordset("select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'") 
				if rs.eof then
					strSQL="INSERT INTO SHOW_SEATING (PerformanceID,ShowID,SeatNumber,ReservationForID,PaymentID,CostBasis)"
					strSQL=strSQL & " values(" & PerformanceID & "," & ShowID & ",'" & SeatNumber & "',-1,-1,130)"
					x=insertrecord(strSQL,"SHOW_SEATING","PerformanceID")
				else
					strSQL="UPDATE SHOW_SEATING set CostBasis=130 where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'" 
					updaterecord strSQL
				end if	
			end if	
		end if
	next		

	

%>
<!--#INCLUDE file="SetUpSeating.asp"-->

<%
'Clean
'set rs=nothing
'set rsSeats=nothing
'set rsSections=nothing
'set rsAreas=nothing
'set rsSections=nothing
'set rsTheater=nothing
%>

<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title><%=TheaterName%> Seating</title>
</head>

<script language="javascript"> 
function ChangeColor(x,Seat){
//alert(x.checked & "  " & Seat.name);
//alert(x.checked & "  " & Seat.name);
//alert(document.SeatingForm.tCheckbox.parentElement.style.backgroundColor);
if(x.checked==true)
	{Seat.style.backgroundColor='#CC6699';
	 //document.SeatingForm.NumberOfClicks.value=parseInt(document.SeatingForm.NumberOfClicks.value)+1;
	}
else
	{Seat.style.backgroundColor='#009999';
     //document.SeatingForm.NumberOfClicks.value=parseInt(document.SeatingForm.NumberOfClicks.value)-1
     }
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function SubmitSelection(){
//if (document.SeatingForm.NumberOfClicks.value==0)
//	{alert("Please select your seats!");}
//else
	//{document.SeatingForm.action='verifySeats.asp';
//	{
//	document.SeatingForm.action='selectseattype.asp';
	 document.SeatingForm.submit();

	}

function SubmitGASelection(){
document.SeatingForm.action='verifyGASeats.asp';
document.SeatingForm.submit();
}
function BackToSelection(){
document.location='SelectShow.asp?Reselect=1';
}

function GoBack(){
document.location='SelectPerformance.asp';
}

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
</script>
<body onLoad="MM_preloadImages('../images/CloseON.gif,../images/SelectSeatsAboveON.gif,../images/SelectSeatsBelowON.gif')">

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1">
	<form name="SeatingForm" type="Post" action="TheaterSeating.asp">
	<!--<input type="hidden" name="NumberOfClicks" value="0">-->
	<tr>
		<td width="100%" align="center" valign="top">
			<table border="0" width="600" height="11">
  				<tr>
    				<td width="150" height="7"><img border="0" src="../images/<%=AccountLogo%>"></td>
    				<td width="450" valign="middle" align="center" height="7">
    					<b><font face="Verdana" color="#000080" size="2">
    						Venue:</font></b> <br><b><font face="Verdana" size="2"><%=TheaterName%><br></font>
      						<font face="Verdana" size="1"><%=TheaterAddress%><br>
      						<%=TheaterCity%>, <%=TheaterState%> <%=TheaterZip%></font></b>
       				</td>
  				</tr>
			</table>
<!--			<table border="0" width="600" height="42">  				<tr>    				<td width="600" height="38"></td>  				</tr>			</table>-->
			<table border="0" width="600" height="9" align="center">
  				<tr>
    				<td width="600" height="5" align="center">
    					<!--<input type="button" value="SELECT A DIFFERENT PERFORMANCE" onclick="javascript:GoBack();">-->
        				<a href="javascript:window.close();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/CloseON.gif',1)"><img name="Image0" border="0" src="../images/Close.gif" WIDTH="100" HEIGHT="32"></a>
        				<!--<a href="EventSetUp.asp?" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/SelectDifPerfON.gif',1)"><img name="Image0" border="0" src="../images/SelectDifPerf.gif" WIDTH="200" HEIGHT="32"></a>-->

    				</td>
  				</tr>
  				<tr>
    				<td width="600" bgcolor="#C0C0C0" height="5" align="center">
    					<b><font face="Verdana" color="#000080" size="4">
    						SET SEATS BELOW
    					</font></b></td>
  				</tr>
			</table>
			<table border="0" width="600" height="39" align="center">
  				<tr>
    				<td width="100%" height="35">
    				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
                      <tr>
                        <td width="10%">&nbsp;</td>
                        <td width="90%" align="center"><b>
                        <font face="Arial" size="4" color="#000080"><%=strShowName%></font></b></td>
                      </tr>
                      <tr>
                        <td width="10%">&nbsp;</td>
                        <td width="90%" align="center"><b><font face="Arial"><%=DayOfWeek(weekday(strPerformanceDate))%> , <%=formatdatetime(strPerformanceDate,vbShortDate)%>
                                                <font face="Arial">at <%=strPerformanceTime%></font></b></td>
                      </tr>
                      </table>
				   </td>
  				</tr>
			</table>
			</td></tr>
				<tr>
					<td width="100%" height="8" align="center" valign="top">
						<table border="0" cellspacing="0" width="<%=TotalWidth%>" cellpadding="0" align="center">
								<%=strTheater%>
        
							<tr>
								<td width="10" height="33" bgcolor="#003366">&nbsp;</td>
								<!--<td width='" & TotalTheater & "' height='33' align='center' bgcolor='#FFFFCC'>-->
								<td width="<%=TotalWidth%>" height="33" align="center" bgcolor="#FFFFCC">
									<p align="center">
									    <!--<input type="button" value="PLEASE SELECT SEATS ABOVE AND PRESS HERE" onclick="javascript:SubmitSelection();">-->
       			        				<a href="javascript:SubmitSelection();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/SelectSeatsAboveON.gif',1)"><img name="Image2" border="0" src="../images/SelectSeatsAbove.gif" WIDTH="350" HEIGHT="32"></a>
										<!--<b><font face="Arial"><a href="javascript:SubmitSelection();">PLEASE SELECT SEATS ABOVE AND PRESS HERE</a></font></b>-->
									</p>
								</td>
								<td width="10" height="33" bgcolor="#003366">&nbsp;</td>
							</tr>
							<tr>
								<td width="10" height="2" bgcolor="#003366">&nbsp;</td>
								<td width="&quot; &amp; TotalTheater &amp; &quot;" height="2" align="center" bgcolor="#003366">
									<p align="center">
										
								</td>
								<td width="10" height="2" bgcolor="#003366">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</form>
 </table>
</body>
</html>