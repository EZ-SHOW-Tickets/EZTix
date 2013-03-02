<!-- #include file = "common.asp" -->
<%
	dim strQueryVariables	
	dim strPaymentMethod
	dim intAmount	
	dim strName
	dim InsertID
	dim i,x
	dim PathBack
	dim personData(8)
	dim ReserveForFName,ReserveForLName
	dim rsSeating,ShowDesc,ShowReference
	dim rsSeating2
	dim lSessionID
	dim ReceiptID
	dim strMessage
	dim strSeatNumbers
	
	ShowReference=""
	lSessionID=Request.Form("lSessionID")
	ShowDesc=Request.Form("ReceiptMessage")

	if session("AccountID")="70" then
		strPaymentMethod = "PP"
	elseif session("AccountID")="75" then
		strPaymentMethod = "USA"
	else
		strPaymentMethod = "CC"
	end if
	
	strFName=replace(Request.Form("cardmemberFName"),"'","''")
	strLName=replace(Request.Form("cardmemberLName"),"'","''")
	strAddress = left(replace(Request.Form("cardmemberaddress"),"'","''"),50)
	strCity = Request.Form("cardmembercity")
	strState = Request.Form("cardmemberstate")
	strZip = Request.Form("cardmemberzip")
	strEMail = Request.Form("cardmemberemail")
	strPhone =Request.Form("cardmemberphone")
	strCountry = "USA"
	if len(trim(Request.Form("ReserveForLName"))) = 0 then
		ReserveForFName=strFName
		ReserveForLName=strLName
	else
		ReserveForFName=replace(Request.Form("ReserveForFName"),"'","`")
		ReserveForLName=replace(Request.Form("ReserveForLName"),"'","`")
	end if
	' --- For query string
	ShowReference=replace(Request.Form("Reference"),"'","`")
	if isempty(session("PersonID")) or session("PersonID")="-1" then
		personData(1)=strLName
		personData(2)=strFName
		personData(3)=left(replace(Request.Form("cardmemberaddress"),"'","''"),50)
		personData(4)=Request.Form("cardmembercity")
		personData(5)=Request.Form("cardmemberstate")
		personData(6)=Request.Form("cardmemberzip")
		personData(7)=Request.Form("cardmemberphone")
		personData(8)=Request.Form("cardmemberemail")
		PersonID=insertrecord("Insert Into PERSON (PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail) values ('" & personData(1) & "','" & personData(2) & "','" & personData(3) & "','" & personData(4) & "','" & personData(5) & "','" & personData(6) & "','" & personData(7) & "','" & personData(8) & "')","PERSON","PersonID")

		x=insertrecord("INSERT INTO PERSON_ACCOUNT (PersonID,AccountID) values(" & PersonID & "," & session("AccountID") & ")","PERSON_ACCOUNT","PersonID")
	else
		PersonID=session("PersonID")
	end if
	intAmount=formatnumber(Request.Form("actualTicketPrice"),2)
	set rsSeating=getAllPendingSeatsForThisPerson(lSessionID)
	if rsSeating.eof then
	'Seats no longer exist
		'strMessage="We are sorry but 10 minutes has elapsed and these seats are no longer available"
		Response.Redirect "TooLatePage.asp"
    '''''''''''''
	else
		if session("Unreserved")="F" then
			strSeatNumbers="["
		    set rsSeating2=getAllPendingSeatsForThisPerson(lSessionID)
			do until rsSeating2.eof
			    strSeatNumbers=strSeatNumbers & " " & rsSeating2("SeatNumber")
				rsSeating2.movenext
			loop
			strSeatNumbers=strSeatNumbers & "]"
	    else
			strSeatNumbers=""
	    end if
	end if
	PaymentType=Request.Form("PaymentMethod")
	if cint(PaymentType) >1 then
	'For non credit card - save Receipt
		if PaymentType="2" then
			ReceiptID=insertrecord("Insert Into PAYMENT_RECEIPTS (AmountPaid,AmountDue,PaymentBy,ReservedForFN,ReservedForLN,PurchaseReference) values(" & intAmount & ",0.00," & PersonID & ",'" & strFName & "','" & strLName & "','" & ShowReference & "')","PAYMENT_RECEIPTS","PaymentReceiptID")
		elseif PaymentType="3" then
			ReceiptID=insertrecord("Insert Into PAYMENT_RECEIPTS (AmountPaid,AmountDue,PurchaseReference) values(0.00," & intAmount & ",'" & ShowReference & "')","PAYMENT_RECEIPTS","PaymentReceiptID")
		elseif PaymentType="4" then
			ReceiptID=insertrecord("Insert Into PAYMENT_RECEIPTS (AmountPaid,AmountDue,PurchaseReference) values(0.00,0.00,'" & ShowReference & "')","PAYMENT_RECEIPTS","PaymentReceiptID")
		elseif PaymentType="5" then
			ReceiptID=insertrecord("Insert Into PAYMENT_RECEIPTS (AmountPaid,AmountDue,PurchaseReference) values(0.00,0.00,'" & ShowReference & "')","PAYMENT_RECEIPTS","PaymentReceiptID")
		end if
		do until rsSeating.eof
			strSQL="Update SHOW_SEATING set ReservationForID=" & PersonID & ",PaymentID=" & PaymentType & ",PaymentReceiptID=" & ReceiptID & " where  ReservationForID=" & lSessionID
			updateRecord strSQL
			'setPersonIDandPaymentForPendingTickets PersonID,lSessionID,ReceiptID
			'setPendingSeatForPerson rsSeating("PerformanceID"),rsSeating("SeatNumber"),PersonID,rsSeating("CostBasis")
			rsSeating.movenext
		loop
		session("PersonID")=empty
		Response.Redirect "http://www.ez-show-tickets.com/v5/admin/Administration.asp?AccountID=" & session("AccountID")
	else
	'Set pending 
		do until rsSeating.eof
			setPendingSeatForPerson rsSeating("PerformanceID"),rsSeating("SeatNumber"),PersonID,rsSeating("CostBasis")
			rsSeating.movenext
		loop
	end if


UpdateTimeForPendingTickets lSessionID
Dim aCCInfo
Response.Expires=0 

Dim strFirstName
Dim strLastName
Dim strInput
aCCInfo = Array( _
	"3.1", _
	"UN", _
	"PW", _
	"AUTH_CAPTURE", _
	strPaymentMethod, _
	intAmount, _
	Request("cardnumber"), _
	Request("cardmonth"), _
	Request("cardyear"), _
	strFName, _
	strLName, _
	Request("cardmemberaddress"),_
	Request("cardmembercity"),_
	Request("cardmemberstate"),_
	Request("cardmemberzip"),_
	"USA", _
	Request("cardmemberemail"))
 
%>
<html>
<head>
<title>Payment Review v0607</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<script language="javascript">
<!--

	function CheckMethod(sPaymentMethod){
		if(sPaymentMethod == "CC")
		{
			document.kspaymentreview.action = "PlumPaymentAndReceipt.asp";
			//document.kspaymentreview.action = "https://secure.authorize.net/gateway/transact.dll";
			document.kspaymentreview.submit();
		}
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
<body bgcolor="#ffffff" background="images/joinowbckgrn.jpg" onLoad="MM_preloadImages('images/Submit2ON.gif','images/BackON.gif')">
<!--<form method="post" action="https://secure.authorize.net/gateway/transact.dll" name="kspaymentreview">-->
<form method="post" action="Plumpaymentandreceipt.asp" name="kspaymentreview">
<table width="400" border="0" cellspacing="1" cellpadding="1" align="center">
          <tr bgcolor="#006699" align="middle"> 
            <td><font face="Arial, Helvetica, sans-serif"><b><font color="#ffffff">Review Customer Information</font></b></font></td>
          </tr>
          <tr bgcolor="#33ccff"> 
            <td> 
              <table width="443" border="0" cellspacing="0" cellpadding="1" bgcolor="#ffffff">
               <!-- <tr> 
                  <td align="right" valign="center" width="111" nowrap>&nbsp;</td>
                  <td width="78">&nbsp;</td>        
                  
                  <td width="65" align="right" valign="center" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Amount:</font></td>                            
                  <td width="177"><label><%=FormatCurrency(aCCInfo(5))%></label></td>
				  <td width="2" align="left" valign="center"> 
                    &nbsp;
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Card 
                    Number:</font></td>
                  <td width="78" align="left" valign="center"> 
                    <label size="16"><%=aCCInfo(6)%></label>
                  </td>
                  <td width="65" align="right" valign="center" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Card 
                    Expr:</font></td>
                  <td width="177" align="left" valign="center"> 
                    <label size="5"><%=aCCInfo(7)%>/<%=aCCInfo(8)%></label> 
                  </td>
                </tr>-->
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Name:</font></td>
                  <td colspan="3" align="left" valign="center" width="324"> 
					<label size="32"><%=aCCInfo(9) & " " & aCCInfo(10)%></label>
					<!--<LABEL size="32"><%=strName%></LABEL>-->
                    &nbsp;</td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Billing
                    Address:</font></td>
                  <td colspan="3" align="left" valign="center" width="324"> 
					<label size="32"><%=aCCInfo(11)%></label>                   
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">City:</font></td>
                  <td width="78" align="left" valign="center"> 
					<label size="16"><%=aCCInfo(12)%></label>                     
                  </td>
                  <td width="65" align="right" valign="center">
                  <font face="Arial, Helvetica, sans-serif" size="2">State:</font></td>
                  <td width="177">
                  <label><%=aCCInfo(13)%></label>                   									
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Zip:</font></td>
                  <td width="78" align="left" valign="center"> 
					<label><%=aCCInfo(14)%></label>                     
                  </td>
                  <td width="65" align="right" valign="center"><font face="Arial, Helvetica, sans-serif" size="2">Country:</font></td>
                  <td width="177"> 
					<label size="16"><%=aCCInfo(15)%></label>                                
                  </td>
                </tr>
                <tr>
                  <td colspan="4" align="center" valign="middle" width="459">&nbsp; 
                  <font face="Arial" size="2">E-Mail Address:</font><label size="34"><%=aCCInfo(16)%></td>
                </tr>
                <tr> 
                  <td colspan="4" align="middle" valign="center" width="437">&nbsp; </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
 
		<div align="center">
          <center>
 
		<table width="400" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="#111111">
			<tr>
				<td>
					<p align="left">
						<font face="Verdana" size="2"><b>Note:</b> Please click on the following button to proceed
        				</font><font color="#FF0000" face="Verdana"> <i><b> </b></i></font><font face="Verdana" size="2">. If there is an error, please click the button to go back and correct the information and then re-submit again.
        				</font>
        		</td>
			</tr>
        	<tr>              
				<td align="center"> 
				<a href="javascript:CheckMethod('<%=strPaymentMethod%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','images/Submit2ON.gif',1)"><img name="Image0" border="0" src="images/Submit2.gif" align="middle" WIDTH="124" HEIGHT="32"></a>
				<a href="setupPlumPayment.asp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/BackON.gif',1)"><img name="Image1" border="0" src="images/Back.gif" align="middle" WIDTH="103" HEIGHT="32"></a>
				
             		<!--<input align="right" id="txtSubmit" name="txtSubmit" type="button" value="Submit" onclick="javascript:CheckMethod('<strPaymentMethod>');">-->
        		</td>
		  	 </tr>
        	<!--<tr align="middle">              
				<td> 
					<b><font color="#FF0000" face="Verdana" size="2">PLEASE WAIT UNTIL YOU GET A RESPONSE... THIS PROCESS 
                    COULD TAKE SEVERAL MINUTES! </font></b>
      			</td>
			</tr>-->
        	<tr align="middle">              
				<td> 
        		</td>
			</tr></table>
		  </center>
</div>
		<%
'			dim sequence
'			dim ret
'			Dim loginid
'			Dim txnkey
'			dim rsAccount
'			if cint(session("Admin"))<= 2 then
'				set rsAccount=getrecordset("Select AccountANUN,AccountANtxnkey from ACCOUNT_INFO where AccountID=" & Request.Form("AccountID"))
'				if len(rsAccount("AccountANUN")) > 0 then
'					loginid=rsAccount("AccountANUN")
'					txnkey=rsAccount("AccountANtxnkey")
'					randomize
'					sequence=int(1000*Rnd)
'					ret=InsertFP(loginid,txnkey,intamount,sequence)
'				else
'					loginid="000"
'				end if
'			else
'				loginid="000"
'			end if		
		%>
		
		<input type="hidden" name="x_Amount" value="<%=aCCInfo(5)%>">
		<input type="hidden" name="x_Card_Num" value="<%=aCCInfo(6)%>">
		<% if session("AccountID") = "70" then%>
			<input type="hidden" name="x_Exp_Month" value="<%=aCCInfo(7)%>">		
			<input type="hidden" name="x_Exp_Year" value="<%=aCCInfo(8)%>">		
		<%else%>
			<input type="hidden" name="x_Exp_Date" value="<%=aCCInfo(7) & "/" & aCCInfo(8)%>">	
		<%end if%>	
		<input type="hidden" name="x_First_Name" value="<%=aCCInfo(9)%>">
		<input type="hidden" name="x_Last_Name" value="<%=aCCInfo(10)%>">
		<input type="hidden" name="x_Address" value="<%=aCCInfo(11)%>">
		<input type="hidden" name="x_City" value="<%=aCCInfo(12)%>">
		<input type="hidden" name="x_State" value="<%=aCCInfo(13)%>">
		<input type="hidden" name="x_Zip" value="<%=aCCInfo(14)%>">
		<input type="hidden" name="x_Country" value="<%=aCCInfo(15)%>">
		<input type="hidden" name="x_Cust_ID" value="<%=PersonID%>">
		<input type="hidden" name="x_Phone" value="<%=strPhone%>">
		<input type="hidden" name="x_Invoice_Num" value="<%=PersonID%>">

		<%if aCCInfo(6)="4007000000027" then%>
			<input type="hidden" name="x_Test_Request" value="TRUE">
	    <%else%>
			<input type="hidden" name="x_Test_Request" value="FALSE">
		<%end if%>		
		<% '--- Email the receipt to customer %>
		<input type="hidden" name="x_Email" value="<%=aCCInfo(16)%>">
		<input type="hidden" name="x_Description" value="<%=ShowDesc & " " & strSeatNumbers%>">
		<input type="hidden" name="AccountID" value="<%=session("AccountID")%>">
		<input type="hidden" name="AccountName" value="<%=session("AccountName")%>">
		<input type="hidden" name="PaymentType" value="<%=session("PaymentType")%>">
		<input type="hidden" name="PersonID" value="<%=PersonID%>">
		<input type="hidden" name="lSessionID" value="<%=lSessionID%>">
		<input type="hidden" name="ReserveForFName" value="<%=ReserveForFName%>">
		<input type="hidden" name="ReserveForLName" value="<%=ReserveForLName%>">
		<input type="hidden" name="ShowReference" value="<%=ShowReference%>">
		<input type="hidden" name="Admin" value="<%=session("Admin")%>">
		
</form>
</body>
</html>
<script src="webstatscript.js"></script>