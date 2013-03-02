<% 
	dim i
	dim strString
	dim nCerts
	if now() < cdate("10/14/2012") then
			session("Admin")=0
			session("AccountID")=5
			session("lSessionID")=session.SessionID
			'Response.Redirect "selectPerformance.asp?ShowID=1771"
	
		if isempty(Request.form("nCerts")) then 
			'First time
			strString=""
			nCerts=0
		else
			nCerts=cint(Request.form("nCerts"))
			sel1=""
			sel2=""
			sel3=""
			sel4=""
			sel5=""
			
			select case nCerts
			   case 1
				sel1="selected"
			   case 2
				sel2="selected"
			   case 3
				sel3="selected"
			   case 4
				sel4="selected"
			   case 5
				sel5="selected"
			end select   
			'nCerts=5
			strString="<tr><td width='10%'>&nbsp;</td><td width='25%'>&nbsp;</td><td width='40%'><font face='Arial'>Please enter certificate Numbers</font></td><td width='25%'>&nbsp;</td></tr>"
			for i = 1 to nCerts
				strString=strString &  "<tr><td width='10%'>&nbsp;</td><td width='25%'><p align='right'><font face='Arial'>Certificate" & i & "</font></td><td width='40%'><font face='Arial'><input name='cert" & i & "' size='37'></font></td><td width='25%'>&nbsp;</td></tr>"
			next
	
		end if
	
	end if

%>
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>
<script language="javascript">
<!--

	function GotNCerts(){
		{

			document.frmNCerts.action = 'PlumOrder.asp';
			document.frmNCerts.submit();
		}
	}
	
	
	function SubmitCerts() 
	{
			var n;
			n=document.theCerts.numCerts.value;
			//alert(n);
			//alert(document.theCerts.cert1.value);
			//Check if all have been filled in
			for (i=1;i<=n;i++) 
			{
			if (document.getElementsByName("cert"+i)[0].value=="")
			//if (document.theCerts.cert1.value =="")
				{alert("Please enter a Certificate number for all entries");
				 return;
					  }
			 }
			//if (n>1)
			//	{if (document.theCerts.cert2.value =="")
			//		  {	alert("Please enter a Certifacate number for all Cert 2");
			//			return;
			//		  }
			//	}
			//document.theCerts.action = 'PlumOrder.asp';
			document.theCerts.submit();
	}
	
	
	
	function popUp(url) {
	sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=500,height=450');
	self.name = "mainWin";
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


<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
  <tr>
    <td width="100%">
    <p align="center"><b><font face="Arial" size="5">Welcome to </font></b></td>
  </tr>
  <tr>
    <td width="100%">
    <p align="center"><img border="0" src="images/BOTLogo.gif" WIDTH="424" HEIGHT="72"></td>
  </tr>
  <tr>
    <td width="100%" align="center"><b><font face="Arial" size="2">Please have 
    your Plum District Certificates ready to enter the codes so you can select 
    the date and seats for </font></b></td>
  </tr>
  <tr>
    <td width="100%" align="center"><font face="Arial" size="4">Disney's The Little Mermaid</font></td>
  </tr>
  <tr>
    <td width="100%">&nbsp;</td>
  </tr>
  
  <tr>
    <td width="100%">

    <form name="frmNCerts" method="POST">
    <p align="center"><b><font face="Arial">How many certificates do you have?&nbsp; 
    <select name="nCerts" onchange="javascript:GotNCerts();"><option value="0">Select...</option>
															<option value="1" <%=Sel1%>>1</option><option value="2" <%=Sel2%>>2</option><option value="3" <%=Sel3%>>3</option><option value="4" <%=Sel4%>>4</option><option value="5" <%=Sel5%>>5</option>
    </select>
    </font></b>
    </form>
    </td>
  </tr>
  <tr>
    <td width="100%">
    <form method='POST' name='theCerts' action="selectPlumPerformance.asp">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" align="right">
			<input type='hidden' name='numCerts' value='<%=nCerts%>'>
			<input type='hidden' name='ShowID' value='1820'>
			<%=strString%>
    </table>
    </form>
    </td>
  </tr>
  <tr>
    <td width="100%">&nbsp;</td>
  </tr>
  <tr>
    <td width="100%">&nbsp;</td>
  </tr>
  <tr>
    <td width="100%">&nbsp;</td>
  </tr>
  <tr>
    <td width="100%">
        <%if ncerts > 0 then%>
    <p align="center"><img border="0" src="images/submit.gif" WIDTH="80" HEIGHT="25" onclick='javascript:SubmitCerts();'>
        <%end if%>
    </td>
  </tr>
</table>


</html>