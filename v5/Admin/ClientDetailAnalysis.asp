<!--#INCLUDE file="../common.asp"-->
<%
dim rsAccounts,rsEvents
dim strEvents
dim percentTickets,openClose
dim EventID
dim strPeriods
dim TodayDate
dim TotalTicketRevenue
dim nEvents
dim TotalAllRevenue,TotalAllTicketsSold
dim BeginDate,EndDate
BeginDate=Request.QueryString("BDate")
EndDate=Request.QueryString("EDate")
AccountID=Request.QueryString("AccountID")
TodayDate=formatdatetime(now(),vbShortDate)
'GetAccountInformation AccountID
'Check if an event has been selected
	'Populate the event information
'	EventID=Request.QueryString("EventID")
	
	'set rsAccounts=GetAllAccountsForManager(1) ' TTO for now
	TotalAllRevenue=0
	TotalAllTicketsSold=0
	'set rsAccounts=getrecordset("Select ACCOUNTS.AccountID,ACCOUNTS.AccountName from ACCOUNTS,MANAGEMENT_ACCOUNT_ACCOUNTS where ACCOUNTS.AccountID=MANAGEMENT_ACCOUNT_ACCOUNTS.AccountID and ManagementAccountID=1") ' TTO for now
	'do until rsAccounts.eof
	    TotalTicketRevenue=0
	    'Get revenue/tickets sold for an account
		'set rsEvents =GetEveryEventForAnAccount(rsAccounts("AccountID"))
		set rsEvents =GetEveryEventForAnAccountForTimePeriod(AccountID,BeginDate,EndDate)
		nEvents=0
		do until rsEvents.eof
			nEvents=nEvents+1
			TicketRevenue=0
			SeatsTaken=0
			'GetTicketSummaryForEvent rsEvents("ShowID")
			GetTicketSummaryForEventDuringTimePeriod rsEvents("ShowID"),BeginDate,EndDate
			if not isnull(ticketRevenue) then 
				TotalTicketRevenue = TotalTicketRevenue + TicketRevenue
				TotalAllRevenue=TotalAllRevenue + TicketRevenue
				if ticketrevenue > 0 then TotalAllTicketsSold=TotalAllTicketsSold+SeatsTaken
			end if
			strEvents=strEvents & "<tr><td width='55%' align='center'><font face='Arial' size='2'><b>" & rsEvents("Show") & "</b></font></td><td width='10%' align='center'><font face='Arial' size='2'>" & nEvents & "</font></td><td width='10%' align='center'><font face='Arial' size='2'>" & SeatsTaken & "</font></td><td width='10%' align='center'><font face='Arial' size='2'></font></td><td width='15%' align='center'><font face='Arial'  size='2'>" & formatcurrency(TicketRevenue,2) & "</font></td></tr>"	
			rsEvents.movenext
		loop
		'if totalseatsavailable > 0 then
		'else
		'	strAccounts=strAccounts & "<tr><td width='28%' align='center'><font face='Arial' size='2'><a href='PerformanceTicketSales.asp?PerformanceID=" & rsPerformances("PerformanceID") & "'><b>" & strPerformanceDate & "</b></a></font></td><td width='14%' align='center'><font face='Arial' size='2'>" & strPerformanceTime & "</font></td><td width='14%' align='center'><font face='Arial' size='2'>" & SeatsTaken & "</font></td><td width='14%' align='center'><font face='Arial' size='2'>0%</font></td><td width='14%' align='center'><font face='Arial'  size='2'>" & formatcurrency(TicketRevenue,2) & "</font></td><td width='15%' align='center'><a href='TheaterSeating.asp?performanceID=" & rsPerformances("PerformanceID") & "' target='_blank'><font face='Arial'  size='2'>" & TicketInventory & "</font></a></td></tr>"	
		'end if		
'		rsAccounts.movenext
'	loop
'strPeriods="<option value='1'>NOW</option>"
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

function SubmitDates()
{
		document.fDates.submit();
}


//-->
</script>

</head>

<body onLoad="MM_preloadImages('../images/BackToAdminON.gif')">


<div align="center">
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
                    <td width="5%" bgcolor="#CCCCCC">&nbsp;</td>
                    <td width="95%" bgcolor="#CCCCCC">
                    <p align="center"><b><font face="Arial">CLIENT ANALYSIS</font></b></td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                      <tr>
                        <td width="100%">
                        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="107%" id="AutoNumber6" align="right">
                          <!--<tr>
                            <td width="16%"><b><font face="Arial">Select Time Period:</font></b></td>
                            <td width="84%"><b><font face="Arial"><select name="sPeriod" onchange="GetClientInfo();"><option value="0">SELECT</option></select></font></b></td>
                          </tr>-->
                          <!--<tr>
                          	<form name="fDates" method="post" action="ClientAnalysis.asp">
                            <td width="22%"><b><font face="Arial">Select Time Period:</font></b></td>
                            <td width="8%"><b><font face="Arial">From:</font></b></td>
                            <td width="22%"><b><font face="Arial">
                              <input name="FromDate" value="=BeginDate" size="17"></font></b></td>
                            <td width="5%"><b><font face="Arial">To:</font></b></td>
                            <td width="51%"><b><font face="Arial">
                            <input name="ToDate" value="=EndDate" size="17">&nbsp; 
                            <input type="button" value="SUBMIT" onclick="javascript:SubmitDates();"></font></b></td>
							</form>                         
 							</tr>-->
                        </table>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%">
                        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber7">
                          <tr>
                            <td width="55%" align="center"><b>
                            <font face="Arial">Event</font></b></td>
                            <td width="10%" align="center"><b>
                            <font face="Arial">Number</font></b></td>
                            <td width="10%" align="center"><b>
                            <font face="Arial" size="2">Tickets Sold</font></b></td>
                            <td width="10%" align="center"><b>
                            <font face="Arial" size="2"></font></b></td>
                            <td width="15%" align="center"><b>
                            <font face="Arial">Revenue</font></b></td>
                          </tr>
<!--                          <tr>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="14%">&nbsp;</td>                            <td width="15%">&nbsp;</td>                          </tr>-->
                          <%=strEvents%>
                            <tr>
                            <td width="55%" align="center"><b>
                            <font face="Arial"></font></b></td>
                            <td width="10%" align="center"><b>
                            <font face="Arial"></font></b></td>
                            <td width="10%" align="center"><b>
                            <font face="Arial" size="2"><%=TotalAllTicketsSold%></font></b>&nbsp;</td>
                            <td width="10%" align="center"><b>
                            <font face="Arial" size="2"></font></b></td>
                            <td width="15%" align="center"><b>
                            <font face="Arial"><%=formatcurrency(TotalAllRevenue,2)%></font></b>&nbsp;</td>
                          </tr>
                        </table>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%"><font face="Ariel" size="2"><b>*Press for details</b></font></td>
                      </tr>
                   </table>
                    </td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <p align="center">
                    <a href="ClientAnalysis.asp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/BackToAdminON.gif',1)"><img name="Image0" border="0" src="../images/BackToAdmin.gif" WIDTH="250" HEIGHT="32"></a>
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
</div>

</body>

</html>