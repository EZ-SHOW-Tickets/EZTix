<!--#INCLUDE file="common.asp"-->
<%


dim x_login	
dim x_tran_key
dim rsLog
dim bTest
bTest=false
	
'**************************************************************
set rsLog = getrecordset("select AccountANUN,AccountANtxnkey from ACCOUNT_INFO where AccountID=" & Request.form("AccountID"))
x_login=rsLog(0)	
x_tran_key=rsLog(1)

'**************************************************************
' VARIABLES USED THROUGHOUT THIS SCRIPT
'**************************************************************
Dim x_version
Dim x_test_request
Dim x_delim_data
Dim x_delim_char
Dim x_relay_response
Dim x_first_name
Dim x_last_name
Dim x_company
Dim x_address
Dim x_city
Dim x_state
Dim x_zip
Dim x_country
Dim x_phone
Dim x_cust_id
Dim x_email
Dim x_email_customer
Dim x_merchant_email
Dim x_invoice_num
Dim x_description
Dim x_amount
Dim x_currency_code
Dim x_method
Dim x_type
dim x_recurring_billing
Dim x_card_num
Dim x_exp_date
Dim x_card_code
Dim x_trans_id
Dim x_auth_code
Dim x_authentication_indicator
Dim x_cardholder_authentication_value
'''''
Dim rsShortName
set rsShortName = getrecordset("select AccountShortName from ACCOUNTS where AccountID=" & Request.form("AccountID"))

x_version = "3.1"
x_test_request = Request.Form("x_test_request")
x_delim_data = "true"
x_delim_char = "|"
x_relay_response = "false"
x_first_name = Request.Form("x_first_name")
x_last_name = Request.Form("x_last_name")
x_address = Request.Form("x_Address")
x_city = Request.Form("x_City")
x_state = Request.Form("x_State")
x_zip = Request.Form("x_Zip")
x_country = Request.Form("Country")
x_phone = Request.Form("x_phone")
x_cust_id = Request.Form("x_Cust_ID")
x_email = Request.Form("x_email")
x_email_customer = "true"
'x_merchant_email = "youremailaddress@yourdomain.com"
'x_invoice_num = Request.Form("x_last_name") & "/" & Request.Form("x_first_name")
'x_invoice_num =rsShortName("AccountShortName") &  "/" & Request.Form("x_last_name")
x_invoice_num =rsShortName("AccountShortName") &  "/" & Request.Form("lSessionID")
x_description = Request.Form("x_description")
x_amount = Request.Form("x_Amount")
x_currency_code = "USD"
x_method = "CC"
x_type = "AUTH_CAPTURE"
x_recurring_billing = "no"
x_card_num = Request.Form("x_Card_Num")
x_exp_date = Request.Form("x_exp_date")
'x_card_code = Request.Form("x_first_name")
x_trans_id = ""
x_auth_code = ""
x_authentication_indicator = "2"

Dim my_own_variable_name
Dim another_field_name

'my_own_variable_name = "Inkjet Cartridge 22 DPI"
'another_field_name = "Color: Black"

'**************************************************************
' REQUEST STRING THAT WILL BE SUBMITTED BY WAY OF
' THE HTTPS POST OPERATION
'**************************************************************
		dim Response_code
		dim Reason_code
		dim Reason_text
		dim Authorization_code
		dim Transaction_id

    		Response_Code="1"
		    Reason_Code="1"
		    Reason_Text="ACCEPTED"
		    Authorization_Code="0"
		    Transaction_id="NoCharge"

'if Response_Code ="1" then
		dim TotalCost
		dim ReserveForFName,ReserveForLName
		dim strReference
		dim ReceiptID
		dim rsShowMessage,strShowMessage,rsSeating
		dim pFName,pLName
		dim lSessionID
		dim strPurchase
		dim i
		dim Admin
		strShowMessage=""
		Response.Expires=-1
		AccountID=Request.form("AccountID")
		PersonID=Request.form("PersonID")
		TotalCost=x_Amount
		pFName=x_First_Name
		pLName=x_Last_Name
		stremail=x_EMail
		ReserveForFName=	Request.form("ReserveForFName")
		ReserveForLName=	Request.form("ReserveForLName")
		strReference=Request.form("ShowReference")
		PaymentType=Request.form("PaymentType")
		AccountName=Request.form("AccountName")		
		lSessionID = Request.Form("lSessionID")
		Admin=Request.Form("Admin")
		GetAccountInformation AccountID
		if Admin <> "0" then 
			AccountReturnURL="http://www.ez-show-tickets.com/v5/EZTLogin.asp"
		else
			if AccountID <> "78" then
				AccountReturnURL="javascript:window.close();"
			end if		
		end if
		TotalTicketCost=0
		TotalTickets =0		
 
%>
<!--#INCLUDE file="ConstructFreePurchase.asp"-->

<%
		'Update seating for this PersonID
		ReceiptID=insertrecord("Insert Into PAYMENT_RECEIPTS (AmountPaid,AmountDue,PaymentBy,ReservedForFN,ReservedForLN,TransactionID,PurchaseReference) values(" & TotalCost & ",0.00," & PersonID & ",'" & ReserveForFName & "','" & ReserveForLName & "'," & Transaction_ID & ",'" & strReference & "')","PAYMENT_RECEIPTS","PaymentReceiptID")
		set rsSeating=getAllPendingSeatsForThisPerson(lSessionID)
		setPersonIDandPaymentForPendingTickets PersonID,lSessionID,ReceiptID
		''''''''''''
'else
'		lSessionID = Request.Form("lSessionID")
'		PersonID=Request.form("PersonID")
'		Admin=Request.Form("Admin")
'		AccountID=Request.form("AccountID")
'		UpdateTimeForPendingTickets lSessionID
'		set rsSeating=getAllPendingSeatsForThisPerson(lSessionID)
'		'setPersonIDForPendingTickets PersonID,lSessionID
'		do until rsSeating.eof
'			UpdatePendingSeatForPerson rsSeating("PerformanceID"),rsSeating("SeatNumber"),PersonID,Authorization_Code
'			rsSeating.movenext
'		loop

'end if
%>

<html>
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Receipt</title>
</head>
<script language="javascript"> 

function BackToSetup(sess,acc,admin){
		document.location='https://www.cgc-services.com/EZTv5/SetupPayment.asp?AccountID='+acc+'&lSessionID='+sess+'&Admin='+admin;
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

</script>
<body onLoad="MM_preloadImages('https://www.cgc-services.com/EZTv5/images/ResubmitON.gif,https://www.cgc-services.com/EZTv5/images/ReturnON.gif')">
<%if Response_Code="1" then%>
  <table border="0" cellpadding="0" cellspacing="0" width="650" height="172">
    <tr>
      <td width="100%" height="1">
			<table border="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="650" id="AutoNumber1" cellpadding="0">
				<tr>
				    <td width="650">
				        <%if AccountID="64" then%>
							<p align="center"><b><font face="Arial">*****TAKE THIS TO ON-LINE TICKET GATE***** </font></b></p>				        
				        <%else%>
							<p align="center"><b><font face="Arial">*****RECEIPT***** </font></b></p>
						<%end if%>
					</td>
				</tr>
				<tr>
					<td width="650">
						<p align="center"><font face="Arial" size="2"><a href="javascript:print();">(Press Here to Print for your Records)</a></font></p>
					</td>
				</tr>
				<tr>
					<td width="650"><%=strShowMessage%></td>
				</tr>
				<tr>
					<td width="650"></td>
			    </tr>
				<tr>
					<td width="650"><font face="Arial" size="2"><%=formatdatetime(now(),vblongdate)%></font>
					</td>
				</tr>
				<tr>
					<td width="650"><font face="Arial" size="2"><%=pFName%>&nbsp; <%=pLName%></font>
					</td>
				</tr>
				<tr>
					<td width="650"><font face="Arial" size="2">Transaction Number: <%=Transaction_id%></font>
					</td>
				</tr>
				<tr>
					<td width="650">
						<%=strPurchase%>
					</td>
				</tr>
				<tr>
				    <td width="650">&nbsp;</td>
				</tr>
				<tr>
					<td width="650">
						<p align="center">
						      <a href="<%=AccountReturnURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','https://www.cgc-services.com/EZTv5/images/ReturnON.gif',1)"><img name="Image0" border="0" src="https://www.cgc-services.com/EZTv5/images/Return.gif" align="middle" WIDTH="200" HEIGHT="32"></a>
						<!--<b><font face="Arial" size="4"><a href="<AccountReturnURL>">CONTINUE </a></font></b>-->
						</p>
					  </td>
				</tr>
				<tr>
					<td width="650">&nbsp;</td>
				</tr>
		</table>
	</td>
	</tr>
</table>
<%else%>
  <table border="0" cellpadding="0" cellspacing="0" width="700" height="172">
    <tr>
      <td width="100%" height="1"><b><font face="Arial" color="#000080">We are sorry but your transaction could not be completed for the following reason:
      </font></b> </td>
    </tr>
    <tr>
      <td width="100%" height="1"><b><font face="Arial">Code:	<%=Reason_Code%></font></b></td>
    </tr>
    <tr>
      <td width="100%" height="1"><%=Reason_Text%> </td>
    </tr>
     <tr>
      <td width="100%" height="1">
      <p align="center"><b><font face="Arial" size="2" color="#FF0000">DO NOT 
      PRESS THE BROWSER BACK BUTTON.&nbsp; CLICK THE BUTTON BELOW.</font></b></td>
    </tr>
   <tr>
      <td width="100%" height="1">
      <p align="center">
      <a href="javascript:BackToSetup(<%=lSessionID%>,<%=AccountID%>,<%=Admin%>);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','https://www.cgc-services.com/EZTv5/images/ResubmitON.gif',1)"><img name="Image1" border="0" src="https://www.cgc-services.com/EZTv5/images/Resubmit.gif" align="middle" WIDTH="350" HEIGHT="32"></a>

      <!--<input type="button" value="Please click here to review your information and resubmit" onclick="javascript:BackToSetup(<lSessionID>,<AccountID>,<Admin>);">      </td>    </tr>      </table>  	<end if></body></html><script src="../common/webstatscript.js"></script>-->
      </td>
         </tr>
    
  </table>  	

<%end if%>
</body>

</html>
<script src="webstatscript.js"></script>