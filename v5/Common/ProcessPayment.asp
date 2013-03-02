<%@ Language=VBScript %>
<!-- #include file = "../Common/DBConnect.vbs" -->
<!-- #include file = "../Common/simLib.asp" -->
<%
	dim strSQL
	dim i
	dim PathBack
	dim personData(8)
	''pathBack = "http://www.ez-show-tickets.com/v4/ANTicketReceipt.asp"
	'strPaymentMethod = "CC"
	strPaymentMethod = "XX"
	intAmount=formatnumber(Request.Form("totCost"),2)
	' --- For query string
	if isempty(session("PersonID")) then
		personData(1)=replace(Request.Form("CCFName"),"'","''")
		personData(2)=replace(Request.Form("CCLName"),"'","''")
		personData(3)=replace(Request.Form("CCaddress1"),"'","''")
		personData(4)=Request.Form("CCcity")
		personData(5)=Request.Form("CCstate")
		personData(6)=Request.Form("CCzipCode")
		personData(7)=Request.Form("CCphone")
		personData(8)=Request.Form("CCemail")
		PersonID=insertrecord("Insert Into PERSON (PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail) values ('" & personData(1) & "','" & personData(2) & "','" & personData(3) & "','" & personData(4) & "','" & personData(5) & "','" & personData(6) & "','" & personData(7) & "','" & personData(8) & "')","PERSON","PersonID")
		'x=insertrecord("INSERT INTO PERSON_ACCOUNT (PersonID,AccountID) values(" & cstr(PersonID) & "," & session("AccountID") & ")","PERSON_ACCOUNT","PersonID")
		session("PersonID")=PersonID
	else
		PersonID=session("PersonID")
		set rsPerson=getrecordset("Select * from PERSON where PersonID=" & PersonID)
	end if
Dim aCCInfo
Response.Expires=0 
aCCInfo = Array( _
	"3.1", _
	"UN", _
	"PW", _
	"AUTH_CAPTURE", _
	strPaymentMethod, _
	intAmount, _
	Request("CCnumber"), _
	Request("CCmonth"), _
	Request("CCyear"), _
	Request("CCFName"), _
	Request("CCLName"), _
	personData(3),_
	personData(4),_
	personData(5),_
	personData(6),_
	"USA", _
	personData(8))
 
%>
<html>
<head>
<title>Payment Review</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<script language="javascript">
<!--

	function CheckMethod(sPaymentMethod){
		if(sPaymentMethod == "CC"){
			document.kspaymentreview.action = "https://secure.authorize.net/gateway/transact.dll";
			document.kspaymentreview.submit();
		}
		else{
			document.kspaymentreview.action = "../SeasonTickets/SeasonTicketReceipts.asp";
			document.kspaymentreview.submit();
		}
	}
//-->
</script>
<body bgcolor="#ffffff" background="images/joinowbckgrn.jpg">
<!--<form method="post" action="https://secure.authorize.net/gateway/transact.dll" name="kspaymentreview">-->
<form method="post" action="SeasonTickets/SeasonTicketReceipts.asp" name="kspaymentreview">
<table width="400" border="0" cellspacing="1" cellpadding="1" align="center">
          <tr bgcolor="#006699" align="middle"> 
            <td><font face="Arial, Helvetica, sans-serif"><b><font color="#ffffff">Review 
              Payment Information</font></b></font></td>
          </tr>
          <tr bgcolor="#33ccff"> 
            <td> 
              <table width="443" border="0" cellspacing="0" cellpadding="1" bgcolor="#ffffff">
                <tr> 
                  <td align="right" valign="center" width="111" nowrap>&nbsp;</td>
                  <td width="78">&nbsp;</td>        
                  
                  <td width="65" align="right" valign="center" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Amount:</font></td>                            
                  <td width="177"><LABEL><%=FormatCurrency(aCCInfo(5))%></LABEL></td>
				  <td width="2" align="left" valign="center"> 
                    &nbsp;
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Card 
                    Number:</font></td>
                  <td width="78" align="left" valign="center"> 
                    <LABEL size="16"><%=aCCInfo(6)%></LABEL>
                  </td>
                  <td width="65" align="right" valign="center" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Card 
                    Expr:</font></td>
                  <td width="177" align="left" valign="center"> 
                    <LABEL size="5"><%=aCCInfo(7)%>/<%=aCCInfo(8)%></LABEL> 
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Name:</font></td>
                  <td colspan="3" align="left" valign="center" width="324"> 
					<LABEL size="32"><%=aCCInfo(9) & " " & aCCInfo(10)%></LABEL>
					<!--<LABEL size="32"><%=strName%></LABEL>-->
                    &nbsp;</td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Billing
                    Address:</font></td>
                  <td colspan="3" align="left" valign="center" width="324"> 
					<LABEL size="32"><%=aCCInfo(11)%></LABEL>                   
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">City:</font></td>
                  <td width="78" align="left" valign="center"> 
					<LABEL size="16"><%=aCCInfo(12)%></LABEL>                     
                  </td>
                  <td width="65" align="right" valign="center">
                  <font face="Arial, Helvetica, sans-serif" size="2">State:</font></td>
                  <td width="177">
                  <LABEL><%=aCCInfo(13)%></LABEL>                   									
                  </td>
                </tr>
                <tr> 
                  <td align="right" valign="center" width="111" nowrap><font face="Arial, Helvetica, sans-serif" size="2">Zip:</font></td>
                  <td width="78" align="left" valign="center"> 
					<LABEL><%=aCCInfo(14)%></LABEL>                     
                  </td>
                  <td width="65" align="right" valign="center"><font face="Arial, Helvetica, sans-serif" size="2">Country:</font></td>
                  <td width="177"> 
					<LABEL size="16"><%=aCCInfo(15)%></LABEL>                                
                  </td>
                </tr>
                <tr>
                  <td colspan="4" align="center" valign="middle" width="459">&nbsp; 
                  <font face="Arial" size="2">E-Mail Address:</font><LABEL size="34"><%=aCCInfo(16)%></td>
                </tr>
                <tr> 
                  <td colspan="4" align="middle" valign="center" width="437">&nbsp; </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
 
		<table width="400" border="0" cellspacing="1" cellpadding="1" align="center">
		<tr><td>
		<font face="Verdana" size="2"><b>Note:</b> Please click on the following button
        </font><font color="#FF0000" face="Verdana"> <i><b> ONLY ONCE</b></i></font><font face="Verdana" size="2">. If there is an error while authorizing the payment information, please 
        click the button to go back and correct the information and then re-submit again.
        </font>
		</td>
		</tr>
        <tr align="middle">              
		<TD> 
          <p align="center"> 
             <INPUT align=right id=txtSubmit name=txtSubmit style="WIDTH: 100px; HEIGHT: 24px" type="button" value="Submit" onclick="javascript:CheckMethod('<%=strPaymentMethod%>');"></p>
        </TD>
		</tr></table>
		<%
			dim sequence
			dim ret
			Dim loginid
			Dim txnkey
			dim rsAccount
			'''''TEST
			'set rsAccount=getrecordset("Select AccountANUN,AccountANtxnkey from ACCOUNT_INFO where AccountID=" & session("AccountID"))
			loginid="ZZZZZZ"
			'txnkey=rsAccount("AccountANtxnkey")
			'randomize
			'sequence=int(1000*Rnd)
			'ret=InsertFP(loginid,txnkey,intamount,sequence)
			'''''''''''		
		%>
		<input type="hidden" name="x_Version" value=<%=aCCInfo(0)%>>
		<input type="hidden" name="x_Login" value=<%=loginid%>>
		<input type="hidden" name="x_Type" value=<%=aCCInfo(3)%>>
		<input type="hidden" name="x_Method" value="<%=aCCInfo(4)%>">
		
		<input type="hidden" name="x_Amount" value="<%=aCCInfo(5)%>">
		<input type="hidden" name="x_Card_Num" value="<%=aCCInfo(6)%>">
		<input type="hidden" name="x_Exp_Date" value="<%=aCCInfo(7) & "/" & aCCInfo(8)%>">		
		<input type="hidden" name="x_First_Name" value="<%=aCCInfo(9)%>">
		<input type="hidden" name="x_Last_Name" value="<%=aCCInfo(10)%>">
		<input type="hidden" name="x_Address" value="<%=aCCInfo(11)%>">
		<input type="hidden" name="x_City" value="<%=aCCInfo(12)%>">
		<input type="hidden" name="x_State" value="<%=aCCInfo(13)%>">
		<input type="hidden" name="x_Zip" value="<%=aCCInfo(14)%>">
		<input type="hidden" name="x_Country" value="<%=aCCInfo(15)%>">
		<input type="hidden" name="x_Cust_ID" value="<%=PersonID%>">
		<%' -- Receipt Link parameters %>
		<input type="hidden" name="x_Receipt_Link_Method" value="POST">
		<input type="hidden" name="x_Receipt_Link_Text" value="CLICK HERE TO COMPLETE TICKETING PROCESS!">
		<!--<input type="hidden" name="x_Receipt_Link_URL" value="<%=server.URLEncode(pathBack)%>">	-->
		<!--<input type="hidden" name="x_Receipt_Link_URL" value="<%=pathBack%>">-->
		<input type="hidden" name="x_Header_Html_Receipt" value="Your tickets have been reserved.">		
		<%' -- Relay Response parameters %>
		<input type="hidden" name="x_Relay_Response" value="TRUE">
		<input type="hidden" name="x_Relay_URL" value="<%=pathBack%>">
		<%if aCCInfo(6)="4007000000027" then%>
			<input type="hidden" name="x_Test_Request" value="TRUE">
		<%end if%>		
		<% '--- Email the receipt to customer %>
		<input type="hidden" name="x_Email_Customer" value="TRUE">
		<input type="hidden" name="x_Email" value="<%=aCCInfo(16)%>">
		
		<!--<input type="hidden" name="x_Description" value="<%=ShowDesc%>">
		<input type="hidden" name="AccountID" value="<%=session("AccountID")%>">
		<input type="hidden" name="AccountName" value="<%=session("AccountName")%>">
		<input type="hidden" name="PaymentType" value="<%=session("PaymentType")%>">
		<input type="hidden" name="PersonID" value="<%=PersonID%>">
		<input type="hidden" name="ReserveForFName" value="<%=ReserveForFName%>">
		<input type="hidden" name="ReserveForLName" value="<%=ReserveForLName%>">-->
</form>
</body>
</html>
