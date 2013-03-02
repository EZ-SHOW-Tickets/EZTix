<!--#INCLUDE file="common.asp"-->
<% 
dim strEvents
dim rsShows
'if Request.QueryString("AID")=3 then Response.Redirect "TempDown.html"
''ClearAllInfo
'Check if RELEASE SEATS
'''getContiguousSeats 1,4059,3 
if not isempty(Request.QueryString("ReleaseSeats")) then
	'Set SessionID
	if isempty(session("lSessionID")) then session("lSessionID")=Request.QueryString("SessionID")
	'Set AccountID
	if isempty(session("AccountID")) then session("AccountID")=Request.QueryString("AID")
	'set Admin
	if isempty(session("Admin")) then session("Admin")=Request.QueryString("Admin")	
	'Release the seats
	ReleaseSeats(session("lSessionID"))
end if
''' Check entry point and set parameters
'Check if session has been set
if isempty(session("lSessionID")) then session("lSessionID")=session.SessionID
if not isempty(session("ManagementAccountID")) then
		'From Management Account Login
		AccountLogo="logomini1.gif"	
		ManagementAccountID=session("ManagementAccountID")
elseif not isempty(session("AccountID")) then
	'From Account Login
	AccountID=session("AccountID")
	GetAccountInformation(AccountID)
	'session("lSessionID")=session.sessionID
elseif not isempty(Request.QueryString("Admin")) then
	'From elsewhere in the system
	session("Admin")=Request.QueryString("Admin")
	session("AccountID")=Request.QueryString("AccountID")
	session("lSessionID")=Request.QueryString("iSessionID")
elseif not isempty(Request.QueryString("AID")) then
	'From Account Site
	session("Admin")=0
	AccountID=Request.QueryString("AID")
	session("AccountID")=AccountID
	GetAccountInformation(AccountID)
	session("lSessionID")=session.sessionID
elseif not isempty(Request.QueryString("MAuserName"))and not isempty(Request.Form("MApassword"))  then
	'From Management Account Login
	if VerifyManagementLogin(Request.Form("MAusername"),Request.Form("MApassword")) then
		session("Admin")=2
		session("lSessionID")=session.sessionID
		session("ManagementAccountID")=ManagementAccountID
		AccountLogo="logomini1.gif"
	else
		Response.Redirect "EXTLogin.asp?ErrMessage=This User Name and Password are not valid"	
	end if
elseif not isempty(Request.Form("username")) and not isempty(Request.Form("password")) then
	'From Account Administrator 
	'get Account from username & password
	if getAccountInfoFromUNandPW(Request.Form("username"),Request.Form("password")) then
		session("Admin")=1
		session("lSessionID")=session.sessionID
		session("AccountID")=AccountID
	else
		Response.Redirect "index.asp?ErrMessage=This User Name and Password are not valid"
	end if
''''TEST - REMOVE WHEN NOT TESTING
'else
'		'session("Admin")=2
'		session("Admin")=0
'		'session("lSessionID")=session.sessionID
'		'ManagementAccountID=1
'		'session("ManagementAccountID")=1
'		'AccountLogo="logomini1.gif"
'		AccountID=5
'		session("AccountID")=AccountID
'		GetAccountInformation(AccountID)
'		session("lSessionID")=session.sessionID
end if
''if session("AccountID")="64" then 
	Response.Redirect "SelectPerformanceDC.asp"
''end if

'end if	
if session("Admin")=1 then
	'If administrator, show all shows for that Account
	set rsShows = GetAllEventsForAnAccount(session("AccountID"))
elseif session("Admin")=2 then
	'If Sales, show all shows for all Accounts
	'set rsShows = GetAllCurrentOpenEventsForAllAccounts()
	set rsShows = GetAllCurrentOpenEventsForManagementAccounts(ManagementAccountID)
else
	'If public and Account specified, show all shows for that Account
	set rsShows = GetAllCurrentOpenEventsForAnAccount(session("AccountID"))
'else
'	'If public and Account NOT specified, show all shows for all Account
'	set rsShows = GetAllCurrentOpenEventsForAllAccounts()
end if
if rsShows.eof then
	strEvents="<font face='Arial' size='3'>NO CURRENT EVENTS</font>"
else
		do until rsShows.eof
		    GetMinMaxPriceForShow(rsShows("ShowID"))
		    if MaxPrice > 0 then
				strEvents= strEvents & "<tr>"
				strEvents= strEvents & "<td align='left' valign='middle' height='36' width='10' bgcolor='#eeeeee' colspan='2'></td>"
				if rsShows("StartDate")=rsShows("EndDate") then
					strEvents= strEvents & "<td align='left' valign='middle' nowrap height='36' width='121'><font face='Arial' size='1'>" & rsShows("StartDate") & "</font.</td>"
				else
					strEvents= strEvents & "<td align='left' valign='middle' nowrap height='36' width='121'><font face='Arial' size='1'>" & rsShows("StartDate") & "<br>" & rsShows("EndDate") & "</font.</td>"
				end if
				strEvents= strEvents & "<td height='36' width='10'  bgcolor='#eeeeee' colspan='2'></td>"
				strEvents= strEvents & "<td align='left' valign='middle' height='36' width='272'><font face='Arial' size='2'><a href='selectPerformance.asp?ShowID=" & rsShows("ShowID") & "'  onclick=''><b>" & rsShows("Show") & "</b></a><br><i> " & rsShows("AccountName") & "</font></td>"
				strEvents= strEvents & "<td height='36' bgcolor='#eeeeee' colspan='2' width='9'></td>"
				strEvents= strEvents & "<td align='left' valign='middle' nowrap height='36' width='166'><font face='verdana,arial,helvetica,sans-serif' size='1'><a target='_blank' href=" & rsShows("TheaterMapQuest") & ">" & rsShows("TheaterName") & "</a><br>" & rsShows("TheaterCity") & "," & rsShows("TheaterState") & "</td>"
				strEvents= strEvents & "<td height='36' bgcolor='#eeeeee' colspan='2' width='7'></td>"
				if minPrice=MaxPrice then
					strEvents= strEvents & "<td align='left' valign='middle' nowrap height='36' width='70'><font face='verdana,arial,helvetica,sans-serif' size='1'>" & formatcurrency(minPrice,2) & "</td>"	
				else
					strEvents= strEvents & "<td align='left' valign='middle' nowrap height='36' width='70'><font face='verdana,arial,helvetica,sans-serif' size='1'>" & formatcurrency(minPrice,2) & " -<br>" & formatcurrency(maxPrice,2) & "</td>"
				end if
				strEvents= strEvents & "</tr>"
			end if	
			rsShows.movenext
		loop
end if
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>SELECT A SHOW</title>
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

<body onLoad="MM_preloadImages('images/BackToAdminON.gif')">
<script language="javascript"> 

function fSelShow(){
if (document.SelectAShow.selShows.value>0) 
//if (1>0) 
		{
		document.location='SelectShow.asp?ShowID='+document.SelectAShow.selShows.value;} 
else 
		{alert("Please select a Event");}
	}

</script>


<div align="center">
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" height="100%">
    <tr>
      <td height="100%" align="center" width="100%">
        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="700" id="AutoNumber2" align="center" height="400">
          <tr>
            <td height="400">
            <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="400">
              <tr>
                <td width="100%" height="50">
                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
						<img border="0" src="images/<%=AccountLogo%>">
					</td>
                  </tr>
                  <tr>
                    <td width="5%" bgcolor="#CCCCCC">&nbsp;</td>
                    <td width="95%" bgcolor="#CCCCCC">
                    <p align="center"><b><font face="Arial"><%=AccountName%></font></b></td>
                  </tr>

                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">&nbsp;</td>
                  </tr>
                </table>
                </td>
              </tr>
			  <tr>
			    <td width="100%">
			    <table width="706" height="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111">
             <tr>
							<td align="center" valign="middle" width="117" height="1" bgcolor="#EEEEEE"><font face="verdana,arial,helvetica,sans-serif" size="1"><b>DATE<br>RANGE</b></td>
							<td height="1" width="12" align="center" bgcolor="#C0C0C0"></td>
							<td align="center" valign="middle" width="228" height="1" bgcolor="#EEEEEE"><font face="verdana,arial,helvetica,sans-serif" size="1"><b>EVENT<br>ORG</b></b></td>
							<td height="1" width="8" align="center" bgcolor="#C0C0C0"></td>
							<td align="center" valign="middle" width="142" height="1" bgcolor="#EEEEEE"><font face="verdana,arial,helvetica,sans-serif" size="1"><b>VENUE<br>CITY</b></td>
							<td height="1" width="5" align="center" bgcolor="#C0C0C0"></td>
							<td align="center" valign="middle" width="66" height="1" bgcolor="#EEEEEE"><font face="verdana,arial,helvetica,sans-serif" size="1"><b>PRICE<br>RANGE</b></td>
			  </tr></table>
			  </td>        
			  </tr>
               <tr>
                    <td valign="top" align="left" width="100%" height="300">
                    <!--<div style="OVERFLOW: auto; SCROLLBAR-BASE-COLOR: #ccffff; HEIGHT: 300">-->
                    <div style="OVERFLOW: auto; HEIGHT: 300">
						<table width="702">
						<form name="SelectAShow">
						<%=strEvents%>
					<tr><td bgcolor="#cccccc" width="696" height="3" colspan="15"></td>	</tr>
                    </div>
                    </table>
                    </td>
               </tr>
              <tr>
                <td width="100%" height="50" align="center">
                <%if session("Admin")>0 then%>
					<a href="admin/administration.asp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','images/BackToAdminON.gif',1)"><img name="Image0" border="0" src="images/BackToAdmin.gif" WIDTH="250" HEIGHT="32"></a>
				<%else%>
					<a href="javascript:window.close();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/CloseON.gif',1)"><img name="Image1" border="0" src="images/Close.gif" WIDTH="124" HEIGHT="32"></a>					           
                <%end if%>
                
                </td>
              </tr>
            </table>
            </td>
          </tr>
        </table>
			<!--#INCLUDE file="bottom_page.inc"-->
      </td>
    </tr>
  </table>
</div>
</body>
</html>
<script src="webstatscript.js"></script>
