<!--#INCLUDE file="common.asp"-->

<%
dim red,white,grey
dim rs,rsRes,rsShow,rsTheater,rsRowLetter
dim perfID
dim strTheater,strErrMessage
dim Row,Seat,numSeats,RowLetter,TotalTheater,TotalWidth
dim i,j,x,n,numseat
'Response.Buffer = False
Response.Expires=-1

x=1

'red="'#FF0000'"
'white="'#FFFFFF'"
grey ="#C0C0C0"

'Set PerformanceID
	'session("PerformanceID")=220
	if isempty(session("PerformanceID")) then session("PerformanceID")=Request.QueryString("PerformanceID")
	performanceID=session("PerformanceID")


'Return all seats not confirmed in last 10 minutes
	deleterecord "Delete from SHOW_SEATING where PaymentID =-1 and ResearveTime < '" & dateadd("n",-10,now()) & "'"

'Return all seats pending for this session for this performance
	deleterecord "Delete from SHOW_SEATING where PaymentID =-1 and ReservationForID=" & session.SessionID & " and PerformanceID=" & PerformanceID

'Get basic information for this performance
	'Show information
	GetShowInformationFromPerformance(PerformanceID)
	'session("ShowID")=ShowID
	'Set Theater information
	GetTheaterInformation(TheaterID)
	'session("TheaterID") =TheaterID
	'Performance information
	GetPerformanceInformation(PerformanceID)
%>
<!--#INCLUDE file="ConstructSeating.asp"-->

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
<title><%=TheaterName%> Seating v060807</title>
</head>

<script language="javascript"> 
function ChangeColor(x,Seat){
//alert(x.name);
//alert(Seat.name);
//alert(Seat.style.backgroundColor);
//alert(x.parentNode.style.backgroundColor);
//alert(document.SeatingForm.tCheckbox.parentElement.style.backgroundColor);
//alert(parseInt("0",10)+1);
//alert(parseInt(document.SeatingForm.NumberOfClicks.value),10);
//alert(document.SeatingForm.NumberOfClicks.value+1);
//alert(document.getElementsByTagName("td")["TC30"].style.backgroundColor);
//alert(document.getElementById("TC30").style.backgroundColor);
//alert(document.getElementById("TC30").style.backgroundColor);
//document.getElementById("TC30").style.backgroundColor='#CC6699';
if(x.checked==true)
	{//Seat.style.backgroundColor='#CC6699';
	 document.getElementById("T"+x.name).style.backgroundColor='#CC6699';
	 document.SeatingForm.NumberOfClicks.value=parseInt(document.SeatingForm.NumberOfClicks.value,10)+1;}
else
	{//Seat.style.backgroundColor='#009999';
	 document.getElementById("T"+x.name).style.backgroundColor='#008000';
     document.SeatingForm.NumberOfClicks.value=parseInt(document.SeatingForm.NumberOfClicks.value,10)-1}
}

function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}

function SubmitSelection(){
if (document.SeatingForm.NumberOfClicks.value==0)
	{alert("Please select your seats!");}
else
	//{document.SeatingForm.action='verifySeats.asp';
	{document.SeatingForm.action='selectseattype.asp';
	 document.SeatingForm.submit();}
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
<body onLoad="MM_preloadImages('images/SelectAnotherPerfON.gif,images/SelectSeatsAboveON.gif,images/SelectSeatsBelowON.gif')">
<style>
<!--
.hide { position:absolute; visibility:hidden; }
.show { position:absolute; visibility:visible; }
-->
</style>

<SCRIPT LANGUAGE="JavaScript">

//Progress Bar script- by Todd King (tking@igpp.ucla.edu)
//Modified by JavaScript Kit for NS6, ability to specify duration
//Visit JavaScript Kit (http://javascriptkit.com) for script

var duration=3 // Specify duration of progress bar in seconds
var _progressWidth = 50;	// Display width of progress bar

var _progressBar = new String("");
var _progressEnd = 10;
var _progressAt = 0;


// Create and display the progress dialog.
// end: The number of steps to completion
function ProgressCreate(end) {
	// Initialize state variables
	_progressEnd = end;
	_progressAt = 0;

	// Move layer to center of window to show
	if (document.all) {	// Internet Explorer
		progress.className = 'show';
		progress.style.left = (document.body.clientWidth/2) - (progress.offsetWidth/2);
		progress.style.top = document.body.scrollTop+(document.body.clientHeight/2) - (progress.offsetHeight/2);
	} else if (document.layers) {	// Netscape
		document.progress.visibility = true;
		document.progress.left = (window.innerWidth/2) - 100;
		document.progress.top = pageYOffset+(window.innerHeight/2) - 40;
	} else if (document.getElementById) {	// Netscape 6+
		document.getElementById("progress").className = 'show';
		document.getElementById("progress").style.left = (window.innerWidth/2)- 100;
		document.getElementById("progress").style.top = pageYOffset+(window.innerHeight/2) - 40;
	}

	ProgressUpdate();	// Initialize bar
}

// Hide the progress layer
function ProgressDestroy() {
	// Move off screen to hide
	if (document.all) {	// Internet Explorer
		progress.className = 'hide';
	} else if (document.layers) {	// Netscape
		document.progress.visibility = false;
	} else if (document.getElementById) {	// Netscape 6+
		document.getElementById("progress").className = 'hide';
	}
}

// Increment the progress dialog one step
function ProgressStepIt() {
	_progressAt++;
	if(_progressAt > _progressEnd) _progressAt = _progressAt % _progressEnd;
	ProgressUpdate();
}

// Update the progress dialog with the current state
function ProgressUpdate() {
	var n = (_progressWidth / _progressEnd) * _progressAt;
	if (document.all) {	// Internet Explorer
		var bar = dialog.bar;
 	} else if (document.layers) {	// Netscape
		var bar = document.layers["progress"].document.forms["dialog"].bar;
		n = n * 0.55;	// characters are larger
	} else if (document.getElementById){
                var bar=document.dialog.bar
        }
	var temp = _progressBar.substring(0, n);
	bar.value = temp;
}

// Demonstrate a use of the progress dialog.
function Demo() {
	ProgressCreate(10);
	window.setTimeout("Click()", 100);
}

function Click() {
	if(_progressAt >= _progressEnd) {
		ProgressDestroy();
		return;
	}
	ProgressStepIt();
	window.setTimeout("Click()", (duration-1)*1000/10);
}

function CallJS(jsStr) { //v2.0
  return eval(jsStr)
}

</script>

<SCRIPT LANGUAGE="JavaScript">

// Create layer for progress dialog
document.write("<span id=\"progress\" class=\"hide\">");
	document.write("<FORM name=dialog>");
	document.write("<TABLE border=2  bgcolor=\"#FFFFCC\">");
	document.write("<TR><TD ALIGN=\"center\">");
	document.write("Progress<BR>");
	document.write("<input type=text name=\"bar\" size=\"" + _progressWidth/2 + "\"");
	if(document.all||document.getElementById) 	// Microsoft, NS6
		document.write(" bar.style=\"color:navy;\">");
	else	// Netscape
		document.write(">");
	document.write("</TD></TR>");
	document.write("</TABLE>");
	document.write("</FORM>");
document.write("</span>");
ProgressDestroy();	// Hides

</script>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1">
	<form name="SeatingForm" type="Post">
	<input type="hidden" name="NumberOfClicks" value="0">
	<tr>
		<td width="100%" align="center" valign="top">
			<table border="0" width="600" height="11">
  				<tr>
    				<td width="150" height="7"><img border="0" src="images/<%=session("AccountLogo")%>"></td>
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
        				<a href="javascript:GoBack();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','images/SelectDifPerfON.gif',1)"><img name="Image0" border="0" src="images/SelectDifPerf.gif" WIDTH="200" HEIGHT="32"></a>

    				</td>
  				</tr>
  				<tr>
    				<td width="600" bgcolor="#C0C0C0" height="5" align="center">
    					<b><font face="Verdana" color="#000080" size="4">
    						Select Seats Below
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
								<td width="100%" height="33" align="center" bgcolor="#FFFFCC">
									<p align="center">
									    <!--<input type="button" value="PLEASE SELECT SEATS ABOVE AND PRESS HERE" onclick="javascript:SubmitSelection();">-->
       			        				<a href="javascript:SubmitSelection();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','images/SelectSeatsAboveON.gif',1)"><img name="Image2" border="0" src="images/SelectSeatsAbove.gif" WIDTH="350" HEIGHT="32"></a>
										<!--<b><font face="Arial"><a href="javascript:SubmitSelection();">PLEASE SELECT SEATS ABOVE AND PRESS HERE</a></font></b>-->
									</p>
								</td>
								<td width="10" height="33" bgcolor="#003366">&nbsp;</td>
							</tr>
							<tr>
								<td width="10" height="2" bgcolor="#003366">&nbsp;</td>
								<td width="<%=TotalTheater%>" height="2" align="center" bgcolor="#003366">
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