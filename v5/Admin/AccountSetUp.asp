<!--#INCLUDE file="../common.asp"-->
<% 
dim ttoUN,ttoPW 
dim x,rs
set rs=getrecordset("Select UserName from ACCOUNT_REGISTER where UserName like 'tto%' order by AccountID DESC")
ttoPW="justin"
ttoUN="tto" &   cint(right(rs("userName"),len(rs("userName")) - instr(1,rs("userName"),"o")))+1
if not isempty(Request.Form("AName")) then
	AccountID=insertrecord("INSERT INTO ACCOUNTS (AccountName) values('" & replace(Request.Form("AName"),"'","`") & "')","ACCOUNTS","AccountID")
	strSQL="INSERT INTO ACCOUNT_INFO (AccountID,AccountURL,AccountLogo,AccountANUN,AccountANPW,AccountANtxnkey,AccountReferenceMessage)"
	strSQL=strSQL & " values(" & AccountID & ",'" & Request.Form("AURL") & "','" & Request.Form("ALogo") & "','justin84','12Can3','ug042UQeKxXJqV6P','" & Request.Form("ARMessage") & "')"
	x=insertrecord(strSQL,"ACCOUNT_INFO","AccountID")
	x=insertrecord("Insert into ACCOUNT_CREDIT_CARD (AccountID,CreditCardID) values(" & AccountID & ",1)","ACCOUNT_CREDIT_CARD","AccountID")
	x=insertrecord("Insert into ACCOUNT_CREDIT_CARD (AccountID,CreditCardID) values(" & AccountID & ",2)","ACCOUNT_CREDIT_CARD","AccountID")
	x=insertrecord("Insert into ACCOUNT_REGISTER (AccountID,UserName,Password,Role) values(" & AccountID & ",'" & Request.Form("CUN") & "','" & Request.Form("CPW") & "',1)","ACCOUNT_REGISTER","AccountID")
	x=insertrecord("Insert into ACCOUNT_REGISTER (AccountID,UserName,Password,Role) values(" & AccountID & ",'" &   Request.Form("TUN") & "','" & Request.Form("TPW") & "',2)","ACCOUNT_REGISTER","AccountID")
	x=insertrecord("Insert into MANAGEMENT_ACCOUNT_ACCOUNTS (ManagementAccountID,AccountID) values(1," & AccountID & ")","MANAGEMENT_ACCOUNT_ACCOUNTS","AccountID")
	Response.Redirect "../EZTLogin.asp"
end if

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

function SAccount()
{
	
	if (document.fAccount.AName.value=="")
		{alert("Please enter full Account NAME");
		 return;}
	else if (document.fAccount.AURL.value=="")
		{alert("Please enter Account URL");
		 return;}	
	else if (document.fAccount.CUN.value=="")
		{alert("Please enter Client USER NAME");
		 return;}	
	else if (document.fAccount.CPW.value=="")
		{alert("Please enter Client PASSWORD");
		 return;}
    else
		{document.fAccount.submit();}	
}
//-->
</script>

</head>

<body>


<div align="center">
<form name="fAccount" method="post" action="AccountSetup.asp">
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" height="91%">
    <tr>
      <td height="91%" align="center" width="100%">
        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="700" id="AutoNumber2" align="center" height="347">
          <tr>
            <td height="347" align="left" valign="top">


            <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="37">
              <tr>
                <td width="100%" bgcolor="#C0C0C0" align="center" height="19">
                <b><font face="Arial">ACCOUNT SETUP</font></b></td>
              </tr>
              <tr>
                <td width="100%" height="18">
                <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">Account 
                    Name:</font></b></td>
                    <td width="64%"><input name="AName" value="" width="20"></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">Account 
                    URL:</font></b></td>
                    <td width="64%"><input name="AURL" value=""></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">Account 
                    Logo:</font></b></td>
                    <td width="64%"><input name="ALogo" value="_spacer.gif"></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">Account 
                    Reference Message:</font></b></td>
                    <td width="64%"><input name="ARMessage" value="(if applicable)"></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">TTO User 
                    Name:</font></b></td>
                    <td width="64%"><input name="TUN" value="<%=ttoUN%>"></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">TTO 
                    Password:</font></b></td>
                    <td width="64%"><input name="TPW" value="<%=ttoPW%>"></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">Client 
                    User Name:</font></b></td>
                    <td width="64%"><input name="CUN" value=""></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right"><b><font face="Arial">Client 
                    Password:</font></b></td>
                    <td width="64%"><input name="CPW" value=""></td>
                  </tr>
                  <tr>
                    <td width="36%" align="right">&nbsp;</td>
                    <td width="64%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="36%" align="right">&nbsp;</td>
                    <td width="64%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="36%" align="right">&nbsp;</td>
                    <td width="64%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="36%" align="right">&nbsp;</td>
                    <td width="64%">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="36%" align="right">&nbsp;</td>
                    <td width="64%"><input type="button" value="SUBMIT" onclick="javascript:SAccount();"></td>
                  </tr>
                </table>
                </td>
              </tr>
            </table>


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