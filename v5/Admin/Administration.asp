<!--#INCLUDE file="../common.asp"-->
<%  
dim AccountUN,AccountPW,rsAccount',AccountID
'dim AccountName,AccountLogo
AccountName=""
if isempty(session("AccountID")) and isempty(session("ManagementAccountID")) then
	if isempty(Request.Form("username")) or isempty(Request.Form("password")) then
		Response.Redirect "../EZTLogin.asp?ErrMessage=Please enter your User Name and Password"
	else
		'Check for Account
		'set rsAccount=getrecordset("Select ACCOUNTS.AccountID,AccountName,AccountLogo from ACCOUNTS,ACCOUNT_REGISTER,ACCOUNT_INFO where ACCOUNTS.AccountID=ACCOUNT_REGISTER.AccountID and ACCOUNTS.AccountID=ACCOUNT_INFO.AccountID and UserName= '" & lcase(Request.Form("username")) & "' and password='" & lcase(Request.Form("password")) & "'")
		'SPECIAL JUSTIN ONLY
		'if lcase(Request.Form("username"))="tto" and lcase(Request.Form("password"))="justin" then
		'	session("AccountName")="Rockwall Community Playhouse"
		'	session("AccountID")=11
		'	session("Admin")=1
		'	session("Justin")=1
		'	GetAccountInformation 11
		'elseif getAccountInfoFromUNandPW(lcase(Request.Form("username")),lcase(Request.Form("password"))) then
		if getAccountInfoFromUNandPW(lcase(Request.Form("username")),lcase(Request.Form("password"))) then
			session("AccountName")=AccountName
			session("AccountID")=AccountID
			session("Admin")=1
			session("Role")=Role
		elseif VerifyManagementLogin(lcase(Request.Form("username")),lcase(Request.Form("password"))) then
			session("ManagementAccountID")=ManagementAccountID
			session("ManagementAccountUserID")=ManagementAccountUserID
			session("Admin")=2
			getManagementInformation session("ManagementAccountID")
		else	
			set rsAccount=nothing
			Response.Redirect "../EZTLogin.asp?ErrMessage=This User Name and Password is not valid"
		end if
	end if
else
	if not isempty(session("AccountID")) then
		getAccountInformation session("AccountID")
	elseif not isempty(session("ManagementAccountID")) then
		getManagementInformation session("ManagementAccountID")
	end if
end if
set rsAccount=nothing
session("ShowID")=empty
session("PersonID")=empty
session("PerformanceID")=empty
%>
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>EZ-SHOW-TICKETS.com v060807</title>
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

function fSeating()
{
	document.location="../events.asp"
}

function fshow()
{
	document.location="eventSetup.asp"
}
function fperformance()
{
	document.location="PerformanceAnalysis.asp"
}

function LogOut()
{
	document.location="../EZTLogin.asp?Clear=1"
}


//-->
</script>

</head>

<body onLoad="MM_preloadImages('../images/seatingON.gif,../images/PerformanceON.gif,../images/eventsON.gif,../images/LogOutON.gif')">


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
                    <td width="5%">&nbsp;</td>
                    <td width="95%"><img border="0" src="../images/<%=AccountLogo%>"></td>
                  </tr>
                  <tr>
                    <td width="5%" bgcolor="#CCCCCC">&nbsp;</td>
                    <td width="95%" bgcolor="#CCCCCC">
                    <p align="center"><b><font face="Arial">ACCOUNT ADMINISTRATION</font></b></td>
                  </tr>

                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                      <!--<form name="subscriber" method="post" action="admin/AccountAdmin.asp">-->

                      <tr>
                        <td width="20%" align="center">
                        <!--<b><font face="Arial" size="2"><input type="button" value="Seating" onclick="javascript:fSeating();" STYLE="width:127; height:20"></font></b>-->
                        <a href="javascript:fSeating();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','../images/seatingON.gif',1)"><img name="Image0" border="0" src="../images/seating.gif" WIDTH="100" HEIGHT="32"></a>

                        </td>
                        <td width="80%"><b><font face="Arial" size="2">Purchase 
                        Tickets</font></b></td>
                      </tr>
                      <tr>
                        <td width="20%" align="center">&nbsp;</td>
                        <td width="80%">
                        &nbsp;</td>
                      </tr>
                      <tr>
                        <td width="20%" align="center">
                        <!--<b><font face="Arial" size="2"><input type="button" value="Performance" onclick="javascript:fPerformance();" STYLE="width:127; height:20"></font></b>-->
                        <a href="javascript:fperformance();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','../images/performanceON.gif',1)"><img name="Image1" border="0" src="../images/performance.gif" WIDTH="100" HEIGHT="32"></a>
                        
                        </td>
                        <td width="80%"><b><font face="Arial" size="2">
                        Performance Analysis</font></b></td>
                      </tr>
                      <tr>
                        <td width="20%" align="center">&nbsp;</td>
                        <td width="80%">
                        &nbsp;</td>
                      </tr>
                      <%if session("Role")="2" then%>
                       <tr>
                        <td width="20%" align="center">
                        <!--<b><font face="Arial" size="2"><input type="button" value="Event" onclick="javascript:fShow();" STYLE="width:127; height:20" id=button1 name=button1></font></b>-->
                        <a href="javascript:fshow();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','../images/eventsON.gif',1)"><img name="Image2" border="0" src="../images/events.gif" WIDTH="100" HEIGHT="32"></a>                        
                        </td>
                        <td width="80%"><b><font face="Arial" size="2">
                        Set/Modify Event information</font></b></td>
                      </tr>
                      <%end if%>
                       <tr>
                        <td width="20%" align="center">&nbsp;</td>
                        <td width="80%">&nbsp;</td>
                      </tr>
                      
                       <tr>
                        <td width="20%" align="center">
                         <a href="javascript:LogOut();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ImageLO','','../images/LogOutON.gif',1)"><img name="ImageLO" border="0" src="../images/LogOut.gif" WIDTH="124" HEIGHT="32"></a>                        

                        </td>
                        <td width="80%">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="20%" align="center">&nbsp;</td>
                        <td width="80%">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="20%" align="right"></td>
                        <td width="80%">&nbsp;</td>
                      </tr>
                      </form>
                    </table>
                    </td>
                  </tr>
                </table>
                </td>
              </tr>
			  <tr>
			    <td width="100%" height="1">
			  </td>        
			  </tr>
 
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>

</body>

</html>