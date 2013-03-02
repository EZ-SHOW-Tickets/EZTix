<!--#INCLUDE file="common.asp"-->

<% 
dim rsSeatingTypes
dim rsPerformancePrices
dim rsTicketPrices

dim rsShow,rsPerf,rsCost,rsGA,rsDiscount
dim strCosts,strShows,strPerf,strCost(2)
dim intPerf,ReservedFor
dim j,i,x,iCost,strPriceRange,bSelectTickets,numGASeats
dim bGA,bReserved, strTicket
dim strPerformances,PerfID
dim strMessage
'Response.Buffer = False

'INITIALIZE
strShowName=""
strShowNote=""
ShowID=0
bSelectTickets=false
j=0
strMessage=""
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'GET SHOW INFORMATION
	ShowID=session("ShowID")
	GetShowInformation(ShowID)
'GET ACCOUNT INFORMATION
	GetAccountInformationFromShow(ShowID)
	session("AccountName")=AccountName
	session("AccountLogo")=AccountLogo
'GET PERFORMANCE INFORMATION
	PerformanceID=Request.QueryString("PerformanceID")
	session("PerformanceID")=PerformanceID
'	getPerformanceInformation(PerformanceID)
'GET THEATER INFORMATION
'	getTheaterInformation(TheaterID)
'DETERMINE SEATING TYPE
	SeatingType = getSeatingTypeForPerformance(PerformanceID)
'GO TO APPROPRIATE PLACE/DO APPROPRIATE THING
	select case SeatingType
	case 1 'reserved only
		strMessage="...Please Wait"
''		Response.Redirect "TheaterSeating.asp"
	case 2 'unreserved only
		'Get number of seats that are left
		Response.Redirect "SelectSeatType.asp"		
	case 3 'not used
	
	case 4 'Best Available
		Response.Redirect "SelectTheaterLocation.asp"		
	end select

%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>SELECT A SHOW FOR <%=AccountName%></title>
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

<body onLoad="javascript:Demo();">
<script language="javascript"> 

function SelectSeats(n){
// Verifies that a performance was selected
// Redirects to Theater Seating with PerformanceID
var show,i,Selected
selected=false
if (n==1)
      {if (document.SelectShow.sPerformance.checked) 
           {show = document.SelectShow.sPerformance.value;
			selected= 
				   true;}}
	  else{
	  for (i=0;i<n;i++) {
      if (document.SelectShow.sPerformance[i].checked) 
           {show = document.SelectShow.sPerformance[i].value;
			selected= 
				   true;}
}}
 if
			(selected)
			{document.location='TheaterSeating.asp?PerformanceID='+show;} 
			else 
			{
			alert("Please select a performance");}
}

function EditSeats(n){
var show,i,Selected
selected=false
if (n==1)
      {if (document.SelectShow.sPerformance.checked) 
           {show = document.SelectShow.sPerformance.value;
			selected= 
				   true;}}
	  else{
	  for (i=0;i<n;i++) {
      if (document.SelectShow.sPerformance[i].checked) 
           {show = document.SelectShow.sPerformance[i].value;
			selected= 
				   true;}
}}
	 if (selected)
			{document.location='admin/SelectToEdit.asp?PerformanceID='+show;} 
			else 
			{
			alert("Please select a performance");}
}

function fSelShow(){
if (document.SelectAShow.selShows.value>0) 
//if (1>0) 
		{
		document.location='SelectShow.asp?ShowID='+document.SelectAShow.selShows.value;} 
else 
		{alert("Please select a Show");}
	}

//function NotThePerson(){
//document.location='sign_in.asp';
//}
function ReturnToAdmin(){
document.location='admin/AccountAdmin.asp';
}
function ProcessPayment(){
document.location='SetupPayment.asp';
}

function ReturnToSite(strSite){
alert(strSite);
document.location=strSite;
}

function SelectPerformance(n) {
var i;
var show;
show=0;
for (i=0;i<n;i++) {
      if (document.fSelectPerformance.sShowDate[i].selected) 
           {show = document.fSelectPerformance.sShowDate[i].value;}
				   }
if (show==0)
	{alert("Please select a performance date");}
	else
	{document.location="SelectPerformance.asp?ShowSelected="+show;}				 
}

</script>
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
		document.location='PlumTheaterSeating.asp';

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
	document.write("Loading Seating Chart<BR>");
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

<table width="100%" height="400">
	<tr>
		<td width="100%" height="400" align="center" valign="top">
			<table border="0" width="600" height="11">
  				<tr>
    				<td width="150" height="7"><img border="0" src="images/<%=session("AccountLogo")%>"></td>
    				<td width="450" valign="middle" align="center" height="7">
      				</td>
  				</tr>
			</table>
			<!--<table border="0" width="600" height="42">
  				<tr>
    				<td width="600" height="38"><%=strShows%></td>
  				</tr>
			</table>-->
			<table border="0" width="600" height="9">
  				<tr>
    				<td width="600" bgcolor="#C0C0C0" height="5">
    					<p align="center"><b>
                        <font face="Verdana" size="4" color="#000080">
                        <%=strMessage%>
                        </font></b>
					</td>
  				</tr>
			</table>
			<table border="0" width="600">
  				<tr>
    				<td width="100%">
     					&nbsp;</td>
  	</tr>
</table>

  <!--#INCLUDE file="bottom_page.inc"-->

		</td>
	</tr>
</table>
</body>

</html>
