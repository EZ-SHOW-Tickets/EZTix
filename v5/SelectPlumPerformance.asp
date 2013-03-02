<!--#INCLUDE file="common.asp"-->

<% 
 
dim rsShow,rsPerf,rsCost,rsAccount
dim strCosts,strShows,strPerf,strCost(2)
dim intPerf,ReservedFor
dim j,i,x,iCost,strPriceRange
dim strPerformances
dim strSeatingCategory
dim strSoldOut
dim nTix
if isempty(session("Admin")) then
	Response.Redirect "expiredpage.htm"
end if

'INITIALIZE
strShowName=""
strShowNote=""
ShowID=0
j=0
strSoldOut=""
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   from events.asp => ShowID									'
'   from SetupPerformance.asp* => ReleaseSeats,SessionID		'

'                                                               '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''EXECUTE RELEASE SEAT REQUEST'''''''''''''''''''''''
if not isempty(Request.QueryString("ReleaseSeats")) then
	ReleaseSeats(Request.QueryString("SessionID"))
	session("AccountID")="3"
end if
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'''Check if a show has been selected''''''''''''''''''''''''''''
if not isempty(Request.QueryString("ShowSelected")) then
	'' a show was selected
	PerformanceID=Request.QueryString("ShowSelected")
	'' get performance info
	set rsPerformance = getrecordset("")
end if

'Clear previous selections
if isempty(Request.QueryString("Reselect")) then
	session("Show")=empty
end if
session("PerformanceID")=empty
'Brings up the Performances for show
if not isempty(Request.form("ShowID")) then
	'Requested show
	ShowID=Request.form("ShowID")
	nTix=cint(Request.form("numCerts"))*2
	'Get Cert Numbers
	for i=1 to 5
		if not isempty(Request.Form("Cert" & cstr(i))) then
		   session("Cert"& cstr(i))=Request.Form("Cert" & cstr(i))
		else
		   session("Cert"& cstr(i))=0
        end if
	next
elseif not isempty(session("ShowID")) then
	ShowID=session("ShowID")
'else
'	rsShow.movefirst
'	ShowID=rsShow("ShowID")
end if
session("ShowID")=ShowID
getShowInformation(ShowID)
getTheaterInformation(TheaterID)

getAccountInformationFromShow(ShowID)
    session("AccountID")=AccountID
	'session("AccountName")=AccountName
	'session("AccountLogo")=AccountLogo
	'session("AccountReturnURL")=AccountReturnURL
'if not isnull(strShowNote) then strShowNote="<br>" & strShowNote
if not isnull(strShowNote) then strShowName=strShowName & "<br>" & strShowNote
'Get Price Range
GetMinMaxPriceForShow(ShowID)
if cdbl(minPrice)< 0.1 then
	minPrice=0.00
	maxPrice=0.00
end if

if minPrice=maxPrice then
	strPriceRange="  " & formatcurrency(minPrice,2)
else
	strPriceRange="  " & formatcurrency(minPrice,2) & "-" & formatcurrency(maxPrice,2)
end if

'Bring up ALL performances for Admin
	set rsPerf = GetAllPerformanceForShow(ShowID)
	strPerf=""
	intPerf=0
	'Set up performances
	do until rsPerf.eof
			if session("Admin") <> "0" or datediff("h",now(),(rsPerf("ShowDate") & " " & rsPerf("ShowTime"))) > ShowHoldHours then
				intPerf=intPerf+1
				GetAvailableSeatsForPerformance rsPerf("PerformanceID")
				'if (rsPerf("PerformanceOpen")=0 or not isempty(session("Admin"))) and totalSeatsAvailable > 0 then
				if (rsPerf("PerformanceOpen")=0 or session("Admin")="1") and totalSeatsAvailable > 0 then
					'strperf=strperf & "<option value='" & rsPerf("PerformanceID") & "'>" & rsPerf("ShowDate") & " " & DayOfWeek(weekday(rsPerf("ShowDate"))) & " " & rsPerf("ShowTime") & "</option>"
					strPerf=strPerf & "<tr><td width='24' align='right'><font face='Arial' size='2'><input type='radio' name='sPerformance' id='sPerformance' value='" & rsPerf("PerformanceID") & "' onclick='javascript:SelectPerformanceNew(" & j & "," & nTix & ");'></font></td>"
					j=j+1
				else
					'Sold Out
					if session("AccountID")=5 then
						strSoldOut="*This performance is SOLD OUT"
					else
						strSoldOut="*Tickets for date not available on-line.<br>Please call " & TheaterPhone & " for details"
					end if
					'strperf=strperf & "<option value='" & rsPerf("PerformanceID") & "' disabled>*" & rsPerf("ShowDate") & " " & DayOfWeek(weekday(rsPerf("ShowDate"))) & " " & rsPerf("ShowTime") & "</option>"
					strPerf=strPerf & "<tr><td width='24' align='right'><font face='Arial' size='2'>NA*</font></td>"				
				end if
				strPerf=strPerf & "<td width='200' align='left'><b><font face='Arial' size='2' color='#003399'>" & trim(DayOfWeek(weekday(rsPerf("ShowDate"))) & " " & rsPerf("ShowDate") & " " & rsPerf("ShowTime")) & "</font></b></td></tr>"
			end if
			'strPerf=strPerf & "<td width='77' align='center' bgcolor='#C0C0C0'><b><font face='Arial' size='2' color='#003399'>Friday</font></b></td>"
			'strPerf=strPerf & "<td width='60' align='center' bgcolor='#C0C0C0'><b><font face='Arial' size='2' color='#003399'>8:00</font></b></td></tr>"
			rsPerf.movenext
	loop
	'strPerf="<tr><td width='24' align='right'></td><td width='200' align='left' colspan='2'><b><font face='Arial' size='1' color='#003399'>PLEASE SELECT DATE AND TIME</font></b></td></tr>" & strPerf
	strPerf="<td width='24' bgcolor='#003399'></td><td width='200' align='center' bgcolor='#003399'><b><font face='Arial' size='2' color=white>PLEASE SELECT DATE & TIME</font></b></td></tr>" & strPerf
	strPerf=strPerf & "<td width='24' bgcolor='#003399'></td><td width='200' align='center' bgcolor='#003399'><b><font face='Arial' size='1' color=white>" & strSoldOut & "</font></b></td></tr>"
	'if intPerf > 1 then strPerf ="<option value='-1'>-----Select-----</option>" & strPerf
'	strPerf ="<option value='-1'>-----Select-----</option>" & strPerf
'Theater Information
'getTheaterInformation(TheaterID)
session("TheaterID")=TheaterID
session("NumTix")=nTix
'Clear Recordsets
set rsPerf=nothing

%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>SELECT A SHOW FOR <%=AccountName%> v060807</title>
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

<body onLoad="MM_preloadImages('images/SelectDifEventON.gif')">
<script language="javascript"> 

function ReturnToAdmin(){
document.location='admin/AccountAdmin.asp';
}

function GoBack(){
document.location='events.asp';
}

function SelectPerformanceNew(n,t)
{
	//alert(document.fSelectPerformance.sPerformance[n].value);
	//alert(document.fSelectPerformance.sPerformance[document.fSelectPerformance.sPerformance.selectedIndex].value);
	if (document.fSelectPerformance.NumPerf.value=="1")
	{document.location="ProcessPlumPerformance.asp?PerformanceID="+document.fSelectPerformance.sPerformance.value+"&numTix="+t;}
	else
	{document.location="ProcessPlumPerformance.asp?PerformanceID="+document.fSelectPerformance.sPerformance[n].value+"&numTix="+t;}
}

function SelectPerformance(n,t) {
var i;
var show;
// Verifies that performance was selected
// redirects to ProcessPerformance
show=0;
if (document.fSelectPerformance.sShowDate[document.fSelectPerformance.sShowDate.selectedIndex].disabled)
	{return;}
for (i=1;i<=n;i++) {
      if (document.fSelectPerformance.sShowDate[i].selected) 
           {show = document.fSelectPerformance.sShowDate[i].value;}
				   }
if (show==0) {alert("Please select a performance date");}
	else{document.location="ProcessPlumPerformance.asp?PerformanceID="+show+"&NumTix="+t;}				 
}

</script>
<table width="100%" height="400">
	<tr>
		<td width="100%" height="400" align="middle">
			<table border="0" width="600" height="11">
  				<tr>
    				<td width="150" height="7"><IMG src="images/<%=AccountLogo%>" border=0 ></td>
    				<td width="450" valign="center" align="middle" height="7">
    					<b><font face="Verdana" color="#000080" size="2">
    						Venue Address:</font></b> <br><b><font face="Verdana" size="2"><%=TheaterName%><br></font>
      						<font face="Verdana" size="1"><%=TheaterAddress%><br>
      						<%=TheaterCity%>            , <%=TheaterState%> <%=TheaterZip%></font></b>
      						<p>
      						<a target="_blank" href="<%=TheaterMapQuest%>"><b><font face="Verdana" color="#000080" size="1">Click here for a map</font></b></a><br>&nbsp;</p>
      				</td>
  				</tr>
			</table>
			<table border="0" width="600" height="16">
  				<!--<tr>
    				<td width="600" height="12"><%=strShows%><p align="center">
       				<A onmouseover="MM_swapImage('Image0','','images/SelectDifEventON.gif',1)" onmouseout=MM_swapImgRestore() href="javascript:GoBack();"><IMG height=32 src="images/SelectDifEvent.gif" width=200 border=0 name=Image0></a></p></td>
  				
  				</tr>-->
			</table>
			<table border="0" width="600" height="9">
  				<tr>
    				<td width="600" bgcolor="#c0c0c0" height="5">
    					<p align="center">
    					<b><font face="Verdana" color="#000080" size="4">
    						Select Date of Performance
    					</font></b></p></td>
  				</tr>
			</table>
			<table border="0" width="600">
  				<tr>
    				<td width="100%">&nbsp;</td>
  					</tr>
			</table>
			<table border="0" width="600">
  				<tr>
    				<td width="100%">
     					<table border="0" width="100%" height="86">
        					<tr>
          						<td width="40%" height="82" valign="top"><IMG src="images/<%=strShowLogo%>" border=0 ><p>
                                <br><font face="Arial" size="1"><%=strShowSummary%></font></p></td>
          						<td width="60%" valign="top" align="left" height="115">
            						<table border="0" width="100%" height="291">
              							<tr>
                							<td width="95%" height="16"><b><font color="#000080" face="Verdana" size="5"><%=strShowName%></font></b></td>
                							<td width="5%" height="16"></td>
              							</tr>
              							<tr>
                							<td width="95%" height="31" valign="top"><font face="verdana,arial,helvetica,sans-serif" size="2"><b>
                                            <br></b></font>

                					<br><font face="verdana,arial,helvetica,sans-serif" size="1" color="#000080"></font>
                  					<!--<p></p>-->
                  				</td>
                				<td width="5%" height="31"></td>
              				</tr>
              				<tr>
                				<td width="95%" height="236" valign="top" align="left">
                  					<table border="0" width="100%" height="49">
                    					<tr>
                      						<!--<td width="102" height="1" valign="top" align="left" colspan="2">
                      							<font face="Verdana" size="2"><b>
                      							Select Date
                      							 
                      							</b></font>
                      						</td>-->
                      						<td width="100%" height="20" align="left"><!--<form name="fSelectPerformance">-->
                          						        <div style="OVERFLOW: auto; WIDTH: 320px; HEIGHT: 350px">
															<table border="1" cellpadding="0" cellspacing="0" width="300">
															<form name="fSelectPerformance">
															<input type="hidden" name="NumPerf" value="<%=j%>">
															<%=strPerf%>
															</form>
															</table>
														</div>
                        					</td>
                    					</tr>
                    					<tr>
                      						<!--<td width="102" height="1" valign="top" align="left" colspan="2">
                      							<font face="Verdana" size="2"><b>
                      							
                      							</b></font>
                      						</td>-->
                      						<td width="100%" height="20">
											<font face="Verdana" size="1"><%=strSoldOut%></font>
                        					</td>
                    					</tr>
                      					<tr>
                      						<td width="661" height="6" colspan="3"></td>
                    					</tr>
                  					
                    					
                  					</table>
                				</td>
                				<td width="5%" height="236"></td>
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
    <td width="100%" valign="top" align="middle"></td>
  </tr>
</table><!--#INCLUDE file="bottom_page.inc"-->
		</td>
	</tr>
</table>
</body>

</html>
<script src="webstatscript.js"></script>