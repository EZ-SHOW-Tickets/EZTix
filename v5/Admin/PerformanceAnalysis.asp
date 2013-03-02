<!--#INCLUDE file="../common.asp"-->
<%
dim rsEvents,rsPerformances
dim strEvents,strPerformance
dim percentTickets,openClose
dim EventID 
'Set ACCOUNTID
if isempty(Session("AccountID")) then
	AccountID="1"
else
	AccountID=Session("AccountID")
end if
GetAccountInformation AccountID
EventID="0"
'Check if an event has been selected
if not isempty(Request.QueryString("EventID")) then
	'Populate the event information
	EventID=Request.QueryString("EventID")
	set rsPerformances=GetAllPerformanceForShow(EventID)
	do until rsPerformances.eof
	    TicketRevenue=0
	    SeatsTaken=0
		GetPerformanceInformation rsPerformances("PerformanceID")
		GetTicketSummaryForPerformance rsPerformances("PerformanceID")
		if isnull(ticketRevenue) then TicketRevenue=0
		if totalseatsavailable > 0 then
			strPerformance=strPerformance & "<tr><td width='14%' align='center'><font face='Arial' size='2'><a href='PerformanceTicketSales.asp?PerformanceID=" & rsPerformances("PerformanceID") & "'><b>" & strPerformanceDate & "</b></a></font></td><td width='14%' align='center'><font face='Arial' size='2'>" & strPerformanceTime & "</font></td><td width='14%' align='center'><font face='Arial' size='2'>" & SeatsTaken & "</font></td><td width='14%' align='center'><font face='Arial' size='2'>" & formatpercent(SeatsTaken/TotalSeatsAvailable,0) & "</font></td><td width='14%' align='center'><font face='Arial'  size='2'>" & formatcurrency(TicketRevenue,2) & "</font></td><td width='15%' align='center'><a href='TheaterSeating.asp?performanceID=" & rsPerformances("PerformanceID") & "' target='_blank'><font face='Arial'  size='2'>" & TicketInventory & "</font></a></td></tr>"	
		else
			strPerformance=strPerformance & "<tr><td width='14%' align='center'><font face='Arial' size='2'><a href='PerformanceTicketSales.asp?PerformanceID=" & rsPerformances("PerformanceID") & "'><b>" & strPerformanceDate & "</b></a></font></td><td width='14%' align='center'><font face='Arial' size='2'>" & strPerformanceTime & "</font></td><td width='14%' align='center'><font face='Arial' size='2'>" & SeatsTaken & "</font></td><td width='14%' align='center'><font face='Arial' size='2'>0%</font></td><td width='14%' align='center'><font face='Arial'  size='2'>" & formatcurrency(TicketRevenue,2) & "</font></td><td width='15%' align='center'><a href='TheaterSeating.asp?performanceID=" & rsPerformances("PerformanceID") & "' target='_blank'><font face='Arial'  size='2'>" & TicketInventory & "</font></a></td></tr>"	
		end if		
		rsPerformances.movenext
	loop
end if
'Get All events for this Account
if AccountID = "5" then
	set rsEvents=GetEveryEventForAnAccountForTimePeriod(AccountID,"6/30/2012","6/30/2013")
else
	set rsEvents=GetEveryEventForAnAccount(AccountID)
end if
'Populate Events
do until rsEvents.eof
	if cint(EventID)=rsEvents("ShowID") then
		strEvents="<option value='" & rsEvents("ShowID") & "' selected>" & rsEvents("Show") & "</option>" & strEvents
	else	
		strEvents="<option value='" & rsEvents("ShowID") & "'>" & rsEvents("Show") & "</option>" & strEvents
	end if
	rsEvents.movenext
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

<body onLoad="MM_preloadImages('../images/BackToAdminON.gif')">


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
                    <p align="center"><b><font face="Arial">EVENT ANALYSIS</font></b></td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                      <tr>
                        <td width="100%">
                        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber6" align="right">
                          <tr>
                            <td width="16%"><b><font face="Arial">Select Event:</font></b></td>
                            <td width="84%"><b><font face="Arial"><select name="sEvent" onchange="GetEvent();"><option value="0">----Select---</option><%=strEvents%></select%></font></b></td>
                          </tr>
                        </table>
                        </td>
                      </tr>
                      <%if EventID<>"0" then%>
                      <tr>
                        <td width="100%">
                        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber7">
                          <tr>
                            <td width="14%" align="center"><b>
                            <font face="Arial">Date*</font></b></td>
                            <td width="14%" align="center"><b>
                            <font face="Arial">Time</font></b></td>
                            <td width="14%" align="center"><b>
                            <font face="Arial" size="2">Tickets Sold</font></b></td>
                            <td width="14%" align="center"><b>
                            <font face="Arial" size="2">% of Inventory</font></b></td>
                            <td width="14%" align="center"><b>
                            <font face="Arial">Revenue</font></b></td>
                            <td width="15%" align="center"><b>
                            <font face="Arial" size="2">Inventory**</font></b></td>
                          </tr>
<!--                          <tr>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="15%">&nbsp;</td>                          </tr>-->
                          <%=strPerformance%>
                        </table>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%"><font face="Ariel" size="2"><b>*Press for details<br>**Press to view/edit</b></font></td>
                      </tr>
                       <%end if%>
                   </table>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <p align="center">
                    <a href="administration.asp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/BackToAdminON.gif',1)"><img name="Image0" border="0" src="../images/BackToAdmin.gif" WIDTH="250" HEIGHT="32"></a>
                 </tr>
                  <tr>
                    <td width="5%"></td>
                    <td width="95%">
<!--                    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">                      <tr>                        <td width="20%" align="center">                        <a href="javascript:fSeating();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/seatingON.gif',1)"><img name="Image0" border="0" src="../images/seating.gif" WIDTH="100" HEIGHT="32"></a>                        </td>                        <td width="80%"><b><font face="Arial" size="2">Purchase                         Tickets, Edit Seating</font></b></td>                      </tr>                      <tr>                        <td width="20%" align="center">&nbsp;</td>                        <td width="80%">                        &nbsp;</td>                      </tr>                      <tr>                        <td width="20%" align="center">                        <a href="javascript:fperformance();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','../images/performanceON.gif',1)"><img name="Image1" border="0" src="../images/performance.gif" WIDTH="100" HEIGHT="32"></a>                                                </td>                        <td width="80%"><b><font face="Arial" size="2">                        Performance Analysis</font></b></td>                      </tr>                      <tr>                        <td width="20%" align="center">&nbsp;</td>                        <td width="80%">                        &nbsp;</td>                      </tr>                       <tr>                        <td width="20%" align="center">                        <a href="javascript:fshow();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/eventsON.gif',1)"><img name="Image2" border="0" src="../images/events.gif" WIDTH="100" HEIGHT="32"></a>                                                </td>                        <td width="80%"><b><font face="Arial" size="2">                        Set/Modify Event information</font></b></td>                      </tr>                      <tr>                        <td width="20%" align="center">&nbsp;</td>                        <td width="80%">                        &nbsp;</td>                      </tr>                      <tr>                        <td width="20%" align="center">&nbsp;</td>                        <td width="80%">&nbsp;</td>                      </tr>                      <tr>                        <td width="20%" align="right"></td>                        <td width="80%">&nbsp;</td>                      </tr>                      </form>                    </table>                    </td>                  </tr>                </table>                </td>              </tr>			  <tr>			    <td width="100%" height="1">			  </td>        			  </tr>               </table>-->
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