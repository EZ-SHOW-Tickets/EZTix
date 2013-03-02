<!--#INCLUDE file="common.asp"-->
<% 
dim currentMonth,currentYear,strMonths,strYears
dim lSessionID
dim strPeople
dim i
dim strReserveForFN,strReserveForLN
dim strPurchase
dim rsCreditCard,rsPerson
dim strPaymentMethod
dim strReferenceNote
dim noPaymentMethods
dim Admin
'''Test if this is a redo''''
if not isempty(Request.QueryString("ReDo")) then
		
else

end if


'SET UP Session Information
'Clear Person info if coming from unsecured site
if not isempty(Request.QueryString("AccountID")) then 
	session("PersonID")=empty
	session("AccountID")=Request.QueryString("AccountID")
end if
if isempty(session("AccountID")) then session("AccountID")=Request.QueryString("AccountID")
if isempty(session("Admin")) then session("Admin")=Request.QueryString("Admin")
if isempty(session("lSessionID")) then session("lSessionID")=Request.QueryString("lSessionID")

lSessionID=session("lSessionID")
AccountID=session("AccountID")
Admin=session("Admin")
GetAccountInformation AccountID 

UpdateTimeForPendingTickets session("lSessionID") 


'''TEST
'session("Admin")=2
''''
''''PUT IN REFERENCE NOTE
'if AccountID="5" then 
'	strReferenceNote="<br>(Performer you are supporting)"
'else
if Request.QueryString("PerfomanceID")="6241" then
	strReferenceNote="<br>" & "Please enter in any special seating requests or instructions"
else
	strReferenceNote="<br>" & AccountReferenceMessage
end if
'end if
'''''''''''''''''''''''''

'Set up Expiration Date on CC
currentMonth=month(now())
currentYear=year(now())
for i=1 to 12
	if currentMonth=i then
		strMonths=strMonths & "<option value='" & cstr(i) & "' selected>" & MonthName(i) & "</option>"
	else
		strMonths=strMonths & "<option value='" & cstr(i) & "'>" & MonthName(i) & "</option>"
	end if
next
strYears="<option value='" & cstr(currentYear) & "' selected>" & currentYear & "</option>"
for i=1 to 7
		strYears=strYears & "<option value='" & cstr(currentYear+i) & "'>" & currentYear+i & "</option>"
next

'Check if email of person was entered
if isempty(request.querystring("ErrMessage")) then
	strEMailMessage=""
else
	strEMailMessage=request.querystring("ErrMessage")	
end if
strRegEmail=""

if not isempty(Request.QueryString("TestEMail")) and len(trim(Request.QueryString("TestEMail"))) > 0 then
	set rsPerson=getrecordset("Select * from PERSON where PersonEMail='" & Request.QueryString("TestEMail") & "'")
	if rsPerson.eof then
	'Not registered
		session("PersonID")=empty
		Response.Redirect "SetUpPayment.asp?ErrMessage=Sorry, this is not a valid E-Mail.  Either reenter or enter information below."
	else
	'Registered
		session("PersonID")=rsPerson("PersonID")
		strEMailMessage="Thank You for visiting us again.  Please enter Credit Card information below."
		strRegEmail=Request.QueryString("TestEMail")
	end if
end if

'CHECK IF A PERSON WAS ENTERED BY ADMIN FROM LIST
if not isempty(Request.QueryString("PersonID")) then session("PersonID") =Request.QueryString("PersonID")
'CHECK IF PERSON IS ALREADY IN DATABASE
if not isempty(session("PersonID")) then
	'Person in database - get info
	GetPerson session("PersonID") 
	strReserveForFN=strFname
	strReserveForLN=strLname
	
else
	'No person was selected, null values
	strFname=""
	strLName=""
	strAddress=""
	strCity=""
	strState=""
	strPhone=""
	strEMail=""
	strReserveForFN=""
	strReserveForLN=""
	session("PersonID")=-1
end if
getnames()
TotalTicketCost=0
TotalTickets =0		

%>
<!--#INCLUDE file="ConstructPurchase.asp"-->

<%
		'Credit Card info
		 set rsCreditCard= GetCreditCardsForAccount(AccountID)
		'Value = 1 Credit Card
		'      = 2 Paid
		'      = 3 Unpaid
		'      = 4 Comp	
		'noPayments=0
		i=-1
		do until rsCreditCard.eof
			i=i+1
'			noPayments=noPayments + 1
			if i=0 then
				strPaymentMethod=strPaymentMethod & "<input type='radio' name='PaymentMethod' value='1' onclick='javascript:ResetTotalPrice(" & i & ");' checked><font face='Arial' size='1'>" & rsCreditCard("CreditCardName") & "</font>" 
			else	
				strPaymentMethod=strPaymentMethod & "<input type='radio' name='PaymentMethod' value='1' onclick='javascript:ResetTotalPrice(" & i & ");'><font face='Arial' size='1'>" & rsCreditCard("CreditCardName") & "</font>" 
			end if
			rsCreditCard.movenext
		loop
		noPaymentMethods=i

		'IF ADMINISTRATOR - add special payments
		if session("Admin")="1" then
			strPaymentMethod=strPaymentMethod & "<input type='radio' name='PaymentMethod' value='2' onclick='javascript:ResetTotalPrice(" & i+1 & ");'><font face='Arial' size='1'>Paid</font><input type='radio' name='PaymentMethod' value='3' onclick='javascript:ResetTotalPrice(" & i+2 & ")';><font face='Arial' size='1'>unPaid</font><input type='radio' name='PaymentMethod' value='4' onclick='javascript:ResetTotalPrice(" & i+3 & ");'><font face='Arial' size='1'>Comp</font>"
			noPaymentMethods=noPaymentMethods+3
		end if 

		
'			noPayments=noPayments + 4
'		rsCreditCard.movefirst
'		strCreditCard="<input type='radio' name='CreditCard' value='1' onclick='javascript:ResetTotalPrice(" & NumSeats & "," & ServiceCharge & "," & npayment & "," & rsServiceCharge("ServiceChargeType") & ");' checked><font face='Arial' size='1'>" & rsCreditCard("CreditCardName") & "</font>" 
'		rsCreditCard.movenext
'		do until rsCreditCard.eof
'			strCreditCard=strCreditCard & "<input type='radio' name='CreditCard' value='1' onclick='javascript:ResetTotalPrice(" & NumSeats & "," & ServiceCharge & "," & npayment & "," & rsServiceCharge("ServiceChargeType") & ");'><font face='Arial' size='1'>" & rsCreditCard("CreditCardName") & "</font>" 
'			rsCreditCard.movenext
'		loop
'		if session("Admin")="-2" then
'			strCreditCard=strCreditCard & "<input type='radio' name='CreditCard' value='2' onclick='javascript:ResetTotalPrice(" & NumSeats & ",0.0," & npayment & ",0);'><font face='Arial' size='1'>Paid</font><input type='radio' name='CreditCard' value='3' onclick='javascript:ResetTotalPrice(" & NumSeats & ",0.0," & npayment & ",0);'><font face='Arial' size='1'>unPaid</font><input type='radio' name='CreditCard' value='4' onclick='javascript:ResetTotalPrice(" & NumSeats & ",-1," & npayment & ",0);'><font face='Arial' size='1'>Comp</font><input type='radio' name='CreditCard' value='5' onclick='javascript:ResetTotalPrice(" & NumSeats & ",-1," & npayment & ",0);'><font face='Arial' size='1'>Season Tickets</font>"
'		end if

function GetNames()
dim rsPeople
if session("Admin")="-2" then
	'CHECK IF NAME HAS BEEN ENTERED FOR SEARCH
	if not isempty(Request.QueryString("PersonLastName")) then
		'Name entered, get names
		set rsPeople=getrecordset("Select PERSON.PersonID,PersonFirstName,PersonLastName from PERSON,PERSON_ACCOUNT where PERSON.PersonID=PERSON_ACCOUNT.PersonID and PersonLastName Like '" &  Replace(Request.QueryString("PersonLastName"),"'","''") & "%"  & "' and AccountID=" & session("AccountID") & " Order By PersonLastName" )
		if rsPeople.eof then
			'No matches
			strPeople="No matches"
		else
			'Populate list to select
			numPeople=1
			strPeople="<option value='0'>---SELECT---</option>"
			do until rsPeople.eof
				numPeople=numPeople+1
				strPeople=strPeople & "<option value='" & rsPeople("PersonID") & "'>" & rsPeople("PersonFirstName") & " " & rsPeople("PersonLastName") & "</option>"
				rsPeople.movenext
			loop
			strPeople="<select name='namelist' onchange='javascript:FillInPerson(" & numPeople & ");'>" & strPeople & "<input type='button' value='Search' id=button1 name=button1 onclick='javascript:GetPeople();'>"
		end if
	else
		strPeople="<input type='button' value='Search' id=button1 name=button1 onclick='javascript:GetPeople();'>"
	end if
else
	strPeople=""
end if
set rsPeople=nothing
end function
%>
<html>
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 6.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Payment Information v060807</title>
</head>
<script language="javascript"> 

function CheckPayment(n){
    var i
    var iCard
	for (i=0;i<n;i++) {
      //alert (document.fProcessPayment.PaymentMethod[i].checked);
      if (document.fProcessPayment.PaymentMethod[i].checked)
		{iCard=document.fProcessPayment.PaymentMethod[i].value;}
					  }

      if (document.fProcessPayment.CardMemberFName.value=='') 
			{alert("Please enter first name");} 
      else if (document.fProcessPayment.CardMemberLName.value=='') 
			{alert("Please enter last name");} 
      else if (document.fProcessPayment.CardMemberAddress.value==''&&iCard<2) 
			{alert("Please enter Address");} 
      else if (document.fProcessPayment.CardMemberCity.value==''&&iCard<2) 
			{alert("Please enter City");} 
      else if (document.fProcessPayment.CardMemberState.value==''&&iCard<2) 
			{alert("Please enter State");} 
      else if (document.fProcessPayment.CardMemberZip.value==''&&iCard<2) 
			{alert("Please enter Zip Code");} 
      else if (document.fProcessPayment.CardMemberEMail.value==''&&iCard<2) 
			{alert("Please enter e-mail");} 
	  else if (document.fProcessPayment.CardNumber.value==''&&iCard<2) 
			{alert("Please enter Credit Card Number");} 
 //       else if (selected==false) 
//			{alert("Please enter Payment Type");} 
	  else 
		
	      {document.fProcessPayment.submit();}
}

function ResetTotalPrice(n)
{
	
	var pType=document.fProcessPayment.PaymentMethod[n].value;
	
	//document.fProcessPayment.tServiceCharge.readonly=false;
	if (pType < 4)
		{
		document.CostInfo.tServiceCharge.value=currency(document.fProcessPayment.actualServiceCharge.value);
		document.CostInfo.tTicketCost.value=currency(document.fProcessPayment.actualTicketPrice.value);
		}
	else
		{
		document.CostInfo.tServiceCharge.value=currency(0.00);
		document.CostInfo.tTicketCost.value=currency(0.00);
		}
	
}


function currency(anynum) {
   //-- Returns passed number as string in $xxx,xxx.xx format.
   anynum=eval(anynum)
   workNum=Math.abs((Math.round(anynum*100)/100));workStr=""+workNum
   if (workStr.indexOf(".")==-1){workStr+=".00"}
   dStr=workStr.substr(0,workStr.indexOf("."));dNum=dStr-0
   pStr=workStr.substr(workStr.indexOf("."))
   while (pStr.length<3){pStr+="0"}

   //--- Adds comma in thousands place.
   if (dNum>=1000) {
      dLen=dStr.length
      dStr=parseInt(""+(dNum/1000))+","+dStr.substring(dLen-3,dLen)
   }

   //-- Adds comma in millions place.
   if (dNum>=1000000) {
      dLen=dStr.length
      dStr=parseInt(""+(dNum/1000000))+","+dStr.substring(dLen-7,dLen)
   }
   retval = dStr + pStr 
   //-- Put numbers in parentheses if negative.
   if (anynum<0) {retval="("+retval+")"}
   return "$"+retval
}

function FillInPerson(n){
	for (i=0;i<n;i++) {
      if (document.fProcessPayment.namelist[i].selected) 
           {if (i>0){
			document.location='SetupPayment.asp?PersonID='+document.fProcessPayment.namelist[i].value;} }
					  }
		}
function GetPeople(){
      if (document.fProcessPayment.CardMemberLName.value=="")
		{alert("Please enter first few characters of last name");}
	  else
		{document.location='SetupPayment.asp?PersonLastName='+document.fProcessPayment.CardMemberLName.value} 
	}
		
function CheckEMail(){
	if (document.RegisteredEMail.regEmail.value=="")
		{alert("Please enter an email");}
	else
		{document.location='SetupPayment.asp?TestEmail='+document.RegisteredEMail.regEmail.value;}

		}
function ReselectSeats() {
	//document.location='http://www.ez-show-tickets.com/v4/SelectShow.asp?ReleaseSeats=1&AID='+document.fProcessPayment.AccountID.value+'&SessionID='+document.fProcessPayment.lSessionID.value;
	document.location='http://www.ez-show-tickets.com/v5/events.asp?ReleaseSeats=1&AID='+document.fProcessPayment.AccountID.value+'&SessionID='+document.fProcessPayment.lSessionID.value+'&Admin='+document.fProcessPayment.Admin.value;
}
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

function popUp(url) {
	sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=500,height=450');
	self.name = "mainWin";
	}

//-->
</script>
<body onLoad="MM_preloadImages('images/CancelTicketsON.gif','images/PurchaseSeatsON.gif','images/PressHereON.gif')">
  
     <table width="100%" height="400">
		<tr>
			<td width="100%" height="100" align="center">
			<table border="0" width="650" height="11">
  				<tr>
    				<td width="200" height="7"><img border="0" src="images/<%=AccountLogo%>"></td>
    				<td width="450" valign="middle" align="center" height="7">
      				</td>
  				</tr>
			</table>
			<table border="0" width="650" height="9">
  				<tr>
    				<td width="650" bgcolor="#FFFFFF" height="5" align="center">
    					<b><font face="Verdana" size="4" color="#000080">
                        <!--<input type="button" value="CANCEL THESE SEATS AND MAKE ANOTHER SELECTION" onclick="javascript:ReselectSeats();"></font></b>-->
                   		<a href="javascript:ReselectSeats();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image0','','images/CancelTicketsON.gif',1)"><img name="Image0" border="0" src="images/CancelTickets.gif" WIDTH="350" HEIGHT="32"></a>
        </td>
  				</tr>
  				<tr>
    				<td width="650" bgcolor="#C0C0C0" height="5" align="center">
    					<b><font face="Verdana" color="#000080" size="4">
    						VERIFY THE FOLLOWING AND ENTER PAYMENT INFORMATION
    					</font></b></td>
  				</tr>
			</table>
			<form name="CostInfo">
			<%=strPurchase%>
			</form>
          <table border="0" cellpadding="0" cellspacing="0" width="650">
           <tbody>
            <tr>
              <td width="140" bgcolor="#C0C0C0"></td>
              <td width="10" bgcolor="#C0C0C0"></td>
              <td width="500" bgcolor="#C0C0C0"></td>
            </tr>
             <tr>
              <td width="140" bgcolor="#C0C0C0"></td>
              <td width="10" bgcolor="#C0C0C0"></td>
              <td width="500" bgcolor="#C0C0C0"></td>
            </tr>
             <tr height="20">
              <td width="140"></td>
              <td width="10"></td>
              <td width="500">
              <p align="center"><b><font face="Arial" size="2" color="#FF0000">YOU HAVE 10 MINUTES TO COMPLETE THIS TRANSACTION</font></b></td>
            </tr>
            <form name="RegisteredEMail">
            <tr>
 <!--             <td width="140" bgcolor="#FFFFFF">&nbsp;</td>              <td width="10" bgcolor="#FFFFFF">&nbsp;</td>-->
              <td width="650" bgcolor="#C0C0C0" colspan="3">
                <p align="center"><b>
                <font face="Arial" size="2" color="#000080">
                If you have purchased tickets here before, just enter your e-mail address:</font></b></td>
            </tr>
            <tr>
              <td width="140" bgcolor="#FFFFFF">
              <p align="right">
              <font face="Arial" size="3" color="#000080"><b>E-Mail:</b></font></p>
              </td>
              <td width="10" bgcolor="#FFFFFF">&nbsp;</td>
              <td width="500" height="30" bgcolor="#FFFFFF">
              <input name="regEmail" size="40" height="28" value="<%=strRegEmail%>">
              <!--<input type="button" value="Then Press Here" onclick="javascript:CheckEMail();">-->
              <a href="javascript:CheckEMail();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','images/PressHereON.gif',1)"><img name="Image3" border="0" src="images/PressHere.gif" align="middle" WIDTH="200" HEIGHT="32"></a>
			</td>
            </tr>
            </form>
            <tr>
              <td width="140" bgcolor="#FFFFFF">
              &nbsp;
              </td>
              <td width="10" bgcolor="#FFFFFF">&nbsp;</td>
              <td width="500" bgcolor="#FFFFFF">
				<p align="center"><b>
                <font face="Arial" size="2" color="#000080"><%=strEMailMessage%></font></b></p></td>
            </tr>
			<form method="post" name="fProcessPayment" action="ProcessPayment.asp">
			<!--<form method="post" name="fProcessPayment" action="ProcessPaymentwithResponse.asp">-->
          <input type="hidden" value="<%=lSessionID%>" name="lSessionID">
          <input type="hidden" value="<%=actualTicketCost%>" name="actualTicketPrice">
          <input type="hidden" value="<%=totServiceCharge%>" name="actualServiceCharge">
          <input type="hidden" value="<%=AccountID%>" name="AccountID">
          <input type="hidden" value="<%=Admin%>" name="Admin">
          <input type="hidden" value="<%=strReceiptMessage%>" name="ReceiptMessage">
           
            <tr>
              <td width="140" bgcolor="#C0C0C0">
              &nbsp;</td>
              <td width="10" bgcolor="#C0C0C0">&nbsp;</td>
              <td width="500" bgcolor="#C0C0C0">
				<p align="center">
        		<b><font face="Arial" color="#000080">ENTER CREDIT CARD 
                INFORMATION</font></b></p>
				</td>
            </tr>
            <tr>
              <td width="140" align="right" bgcolor="#FFFFFF">
              <font face="Arial" size="3" color="#000080"><b>Card Type:</b></font></td>
              <td width="10" bgcolor="#FFFFFF"></td>
              <td width="500" bgcolor="#FFFFFF"><%=strPaymentMethod%></td>
            </tr>
            <tr>
              <td width="140" align="right" bgcolor="#FFFFFF">
              <font face="Arial" size="3" color="#000080"><b>Card
                Number:</b></font></td>
              <td width="10" bgcolor="#FFFFFF"></td>
              <td width="500" bgcolor="#FFFFFF"><font color="#00FF00"><input name="CardNumber" size="34" style="WIDTH: 252px; HEIGHT: 22px;"></td></font>
            </tr>
            <tr>
              <td width="140" align="right" bgcolor="#FFFFFF">
              <font face="Arial" size="3" color="#000080"><b>Card Expires:</b></font></td>
              <td width="10" bgcolor="#FFFFFF"></td>
              <td width="500" bgcolor="#FFFFFF">
              <select name="CardMonth">
					<%=strMonths%>
              </select>
              <select name="CardYear">
					<%=strYears%>
              </select>
              </td>
            </tr>
         </table>
		<table width="650">
            <tr>
              <td width="140" align="right">
              &nbsp;</td>
              <td width="10">&nbsp;</td>
              <td width="500">
              <b><font face="Arial" size="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#336699"> 
              First&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Last</font></font></b></td>
            </tr>
          <tr>
              <td width="140" align="right">
              <font face="Arial" size="3" color="#000080"><b>Name
                on Card:</b></font></td>
              <td width="10"></td>
              <td width="500">
              <input name="CardMemberFName" size="16" value="<%=strFName%>"> <input name="CardMemberLName" size="18" value="<%=strLName%>"><%=strPeople%></td>
            </tr>
            <tr>
              <td width="140" align="right">
              <font face="Arial" size="3" color="#000080"><b>Billing
                Address:</b></font></td>
              <td width="10"></td>
              <td width="500"><input name="CardMemberAddress" size="34" style="WIDTH: 252px; HEIGHT: 22px" value="<%=strAddress%>"></td>
            </tr>
            <tr>
              <td width="140" align="right">
              <font face="Arial" size="3" color="#000080"><b>City:</b></font></td>
              <td width="10"></td>
              <td width="500"><input name="CardMemberCity" size="34" style="WIDTH: 252px; HEIGHT: 22px" value="<%=strCity%>"></td>
            </tr>
            <tr>
              <td width="140" align="right">
              <font face="Arial" size="3" color="#000080"><b>State:</b></font></td>
              <td width="10"></td>
              <td width="500"><input name="CardMemberState" style="WIDTH: 53px; HEIGHT: 22px" size="6" maxlength="2" value="<%=strState%>"></td>
            </tr>
            <tr>
              <td width="140" align="right">
              <font face="Arial" size="3" color="#000080"><b>Zip
                Code:</b></font></td>
              <td width="10"></td>
              <td width="500"><input name="CardMemberZip" size="22" style="WIDTH: 168px; HEIGHT: 22px" value="<%=strZip%>"></td>
            </tr>
            <tr>
              <td width="140" align="right">
              <font face="Arial" size="3" color="#000080"><b>E-Mail:</b></font></td>
              <td width="10"></td>
              <td width="500"><input name="CardMemberEMail" size="34" style="WIDTH: 252px; HEIGHT: 22px" value="<%=strEMail%>"></td>
            </tr>
            <tr>
              <td width="140" align="right"><b>
              <font face="Arial" size="3" color="#000080">Phone
                Number:</font></b></td>
              <td width="10"></td>
              <td width="500"><input name="CardMemberPhone" size="23" style="WIDTH: 175px; HEIGHT: 22px" maxlength="20" value="<%=strPhone%>"></td>
            </tr>
            <tr>
              <td width="140" align="right">&nbsp;</td>
              <td width="10">&nbsp;</td>
              <td width="500"><b><font face="Arial" size="2" color="#336699">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;First&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last</font></b></td>
            </tr>
            <tr>
              <td width="140" align="right"><b>
              <font face="Arial" size="3" color="#000080">Reserve For:</font></b></td>
              <td width="10"></td>
              <td width="500"><input name="ReserveForFName" size="16" value="<%=strReserveForFN%>">&nbsp;<input name="ReserveForLName" size="16" value="<%=strReserveForLN%>">
              <b><font color="#336699" face="Arial" size="2"><br>
              (change if different name than on Credit Card)</font></b></td>
            </tr>
            <tr>
              <td width="140" align="right"><b>
              <font face="Arial" color="#000080">Reference:</font></b></td>
              <td width="10">&nbsp;</td>
              <td width="500"><input name="Reference" size="37" value=""><font color="#336699" face="Arial" size="2"><%=strReferenceNote%></font></td>
            </tr>
            <tr>
              <td width="140" align="right"></td>
              <td width="10"></td>
              <td width="500"></td>
            </tr>
            <tr>
              <td width="140" align="right"></td>
              <td width="10"></td>
              <td width="500">
                <p align="left">
        		<!--<a href="javascript:CheckPayment(npayment);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/YPurchaseTicketsButtonON.gif',1)"><img name="Image1" border="0" src="images/YPurchaseTicketsButton.gif" WIDTH="198" HEIGHT="25"></a>-->
        		<font face="Arial"><b>
        		<!--<input type="button" value="PRESS HERE to purchase tickets" onclick="javascript:CheckPayment('<=noPaymentMethods>');" width="320"></b></font>-->
                 <a href="javascript:CheckPayment('<%=noPaymentMethods%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','images/PurchaseSeatsON.gif',1)"><img name="Image1" border="0" src="images/PurchaseSeats.gif" WIDTH="200" HEIGHT="32"></a>
               </p>
              </td>
            </tr>
            <tr>
              <td width="140" align="center">
					<div id="digicertsitesealcode" style="width: 81px; margin: 5px auto 5px 5px;" align="center">
						<script language="javascript" type="text/javascript" src="https://www.digicert.com/custsupport/sealtable.php?order_id=00134699&amp;seal_type=b&amp;seal_size=large&amp;seal_color=blue&amp;new=1"></script>
						<a href="http://www.digicert.com/">SSL Certificate</a>
						<script language="javascript" type="text/javascript">coderz();</script>
					</div>               
              </td>
              <td width="10">&nbsp;</td>
              <td width="500">
                &nbsp;</td>
            </tr>
                        <tr>
              <td width="140" bgcolor="#336699"></td>
              <td width="10" bgcolor="#336699">
              </td>
              <td width="500" bgcolor="#336699"></td>
            </tr>
		</table>
      </form>
      </td>
</tr>
</table>
</body>

</html>
<!--<script src="webstatscript.js"></script>-->