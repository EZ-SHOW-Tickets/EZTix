<!--#INCLUDE file="common.asp"-->
<% 
session("AccountID")=empty
session("ManagementAccountID")=empty
session("PersonID")=empty

%>
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>EZ-SHOW-TICKETS.com v3</title>
<script language="JavaScript">
<!--
function SubmitAccount(){
if (document.subscriber.username.value=="")
	{alert("Please enter your UserName");}
else if (document.subscriber.password.value=="")
	{alert("Please enter your Password");}
else
	{document.subscriber.submit();}
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
//-->
</script>
<link rel="shortcut icon" href="favicon.ico">
</head>

<body onLoad="MM_preloadImages('images/loginON.gif')">


<div align="center">
  <table border="0" cellpadding="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" height="91%">
    <tr>
      <td height="91%" align="middle" width="100%">
        <table border="1" cellpadding="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="700" id="AutoNumber2" align="center" height="347">
          <tr>
            <td height="347">
            <table border="1" cellpadding="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="346">
              <tr>
                <td width="100%" height="345">
                <table border="0" cellpadding="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%"><IMG height=77 src="images/EZLogo.gif" width=250 border=0></td>
                  </tr>
                  <tr>
                    <td width="5%" bgcolor="#cccccc">&nbsp;</td>
                    <td width="95%" bgcolor="#cccccc">&nbsp;</td>
                  </tr>
                  <tr>
                    <td width="5%">&nbsp;</td>
                    <td width="95%">
                    <table border="0" cellpadding="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                      <form name="subscriber" method="post" action="admin/Administration.asp">
                          <TBODY>

                      <tr>
                        <td width="27%" align="right">&nbsp;</td>
                        <td width="73%">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="27%" align="right"><b><font face="Arial">USER 
                        NAME:</font></b></td>
                        <td width="73%"><input name="username" size="21"></td>
                      </tr>
                      <tr>
                        <td width="27%" align="right"><b><font face="Arial">
                        PASSWORD:</font></b></td>
                        <td width="73%">
                        <input type="password" name="password" size="21"></td>
                      </tr>
                      <tr>
                        <td width="27%" align="right">&nbsp;</td>
                        <td width="73%">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="27%" align="right"></td>
                        <td width="73%"><!--<input type="button" onclick="javascript:SubmitAccount();" value="SUBMIT">-->
       					<A onmouseover="MM_swapImage('Image0','','images/loginON.gif',1)" onmouseout=MM_swapImgRestore() href="javascript:SubmitAccount();"><IMG height=25 src="images/login.gif" width=80 border=0 name=Image0></a>
                        
                        </td>
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
			  <font color="#FFFFFF"><%=Session("AccountID")%></font>
			  </td>        
			  </tr>
        </table>
      </td>
    </tr>
  </table></TD></TR></TBODY></TABLE>
</div>

</body>

</html>