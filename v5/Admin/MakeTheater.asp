<!--#INCLUDE file="../common.asp"-->
<% 
dim rs
dim strRowLetters
dim strAccounts
set rs=getrecordset("Select * from GENERAL_ROW_LETTER_NAME")
strRowLetters="<option value='0' selected>---Select---</option>"
do until rs.eof
	strRowLetters=strRowLetters & "<option value='" & rs("GeneralID") & "'>" & rs("GeneralRowLetterName") & "</option>"
	rs.movenext
loop
set rs=getrecordset("Select * from ACCOUNTS")
do until rs.eof
	strAccounts=strAccounts & "<option value='" & rs("AccountID") & "'>" & rs("AccountName") & "</option>"
	rs.movenext
loop

%>
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Make Theater</title>
</head>

<body>
<form name='form1' type="post" action='processTheater.asp'>
<table border="1" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="700" id="AutoNumber1" height="600">
  <tr>
    <td width="175" align="right" height="22">Theater Name:</td>
    <td width="525" height="22"><input name='Theater' size="28"><br> Account: <select name="account"><option value="0">---SELECT---</option><%=strAccounts%></select></td>
  </tr>
  <tr>
    <td width="175" align="right" valign="top" height="138">
      <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
        <tr>
          <td width="80" align="right"><font size="2">Section Name:</font></td>
          <td width="95"><input name="L1" size="10"></td>
        </tr>
        <tr>
          <td width="80" align="right"><font size="2">.</font></td>
          <td width="95"><font size="2">Left Seat No</font></td>
        </tr>
        <tr>
          <td width="80" align="right">&nbsp;</td>
          <td width="95"><font size="2">Number Seq:</font></td>
        </tr>
        <tr>
          <td width="80" align="right"><font size="2">Row at front</font></td>
          <!--<td width="95"><input name="FR1" size="7" value="1"></td>-->
          <td width="95"><select name="FR1"><%=strRowLetters%></select></td>
        </tr>
      </table>
    </td>
    <td width="525" height="138" valign="top">
    <table border="1" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="502" id="AutoNumber2">
      <tr>
        <td width="51"><input name='A11' value="-1"  size="5" ></td>
        <td width="51"><input name='A12' value="-1" size="5" ></td>
        <td width="50"><input name='A13' value="-1" size="5" ></td>
        <td width="50"><input name='A14' value="-1" size="5" ></td>
        <td width="50"><input name='A15' value="-1" size="5" ></td>
        <td width="50"><input name='A16' value="-1" size="5" ></td>
        <td width="50"><input name='A17' value="-1" size="5" ></td>
        <td width="50"><input name='A18' value="-1" size="5" ></td>
        <td width="50"><input name='A19' value="-1" size="5" ></td>
        <td width="50"><input name='A110' value="-1" size="5" ></td>
      </tr>
      <tr>
        <td width="51"><input name='LS11' value="-1"  size="5" ></td>
        <td width="51"><input name='LS12' value="-1" size="5" ></td>
        <td width="50"><input name='LS13' value="-1" size="5" ></td>
        <td width="50"><input name='LS14' value="-1" size="5" ></td>
        <td width="50"><input name='LS15' value="-1" size="5" ></td>
        <td width="50"><input name='LS16' value="-1" size="5" ></td>
        <td width="50"><input name='LS17' value="-1" size="5" ></td>
        <td width="50"><input name='LS18' value="-1" size="5" ></td>
        <td width="50"><input name='LS19' value="-1" size="5" ></td>
        <td width="50"><input name='LS110' value="-1" size="5" ></td>
      </tr>
      <tr>
        <td width="51"><input name='Seq11' value="-1"  size="5" ></td>
        <td width="51"><input name='Seq12' value="-1" size="5" ></td>
        <td width="50"><input name='Seq13' value="-1" size="5" ></td>
        <td width="50"><input name='Seq14' value="-1" size="5" ></td>
        <td width="50"><input name='Seq15' value="-1" size="5" ></td>
        <td width="50"><input name='Seq16' value="-1" size="5" ></td>
        <td width="50"><input name='Seq17' value="-1" size="5" ></td>
        <td width="50"><input name='Seq18' value="-1" size="5" ></td>
        <td width="50"><input name='Seq19' value="-1" size="5" ></td>
        <td width="50"><input name='Seq110' value="-1" size="5" ></td>
      </tr>

      <tr>
        <td width="51"><input name='B1' value="-1"  size="5" ></td>
        <td width="51"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
      </tr>
    </table>
    </td>
  </tr>
 <tr>
    <td width="175" align="right" height="163">
       <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
        <tr>
          <td width="80" align="right"><font size="2">Section Name:</font></td>
          <td width="95"><input name="L2" size="10"></td>
        </tr>
        <tr>
          <td width="80" align="right"><font size="2">.</font></td>
          <td width="95"><font size="2">Left Seat No</font></td>
        </tr>
        <tr>
          <td width="80" align="right">&nbsp;</td>
          <td width="95"><font size="2">Number Seq:</font></td>
        </tr>
        <tr>
          <td width="80" align="right"><font size="2">Row at front</font></td>
          <td width="95"><Select name="FR2"><%=strRowLetters%></select></td>
        </tr>
      </table>
    
    </td>
    <td width="525" height="163">
    <table border="1" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="502" id="AutoNumber2">
      <tr>
        <td width="51"><input name='A21' value="-1"  size="5" ></td>
        <td width="51"><input name='A22' value="-1" size="5" ></td>
        <td width="50"><input name='A23' value="-1" size="5" ></td>
        <td width="50"><input name='A24' value="-1" size="5" ></td>
        <td width="50"><input name='A25' value="-1" size="5" ></td>
        <td width="50"><input name='A26' value="-1" size="5" ></td>
        <td width="50"><input name='A27' value="-1" size="5" ></td>
        <td width="50"><input name='A28' value="-1" size="5" ></td>
        <td width="50"><input name='A29' value="-1" size="5" ></td>
        <td width="50"><input name='A210' value="-1" size="5" ></td>
      </tr>
      <tr>
        <td width="51"><input name='LS21' value="-1"  size="5" ></td>
        <td width="51"><input name='LS22' value="-1" size="5" ></td>
        <td width="50"><input name='LS23' value="-1" size="5" ></td>
        <td width="50"><input name='LS24' value="-1" size="5" ></td>
        <td width="50"><input name='LS25' value="-1" size="5" ></td>
        <td width="50"><input name='LS26' value="-1" size="5" ></td>
        <td width="50"><input name='LS27' value="-1" size="5" ></td>
        <td width="50"><input name='LS28' value="-1" size="5" ></td>
        <td width="50"><input name='LS29' value="-1" size="5" ></td>
        <td width="50"><input name='LS210' value="-1" size="5" ></td>
      </tr>
      <tr>
        <td width="51"><input name='Seq21' value="-1"  size="5" ></td>
        <td width="51"><input name='Seq22' value="-1" size="5" ></td>
        <td width="50"><input name='Seq23' value="-1" size="5" ></td>
        <td width="50"><input name='Seq24' value="-1" size="5" ></td>
        <td width="50"><input name='Seq25' value="-1" size="5" ></td>
        <td width="50"><input name='Seq26' value="-1" size="5" ></td>
        <td width="50"><input name='Seq27' value="-1" size="5" ></td>
        <td width="50"><input name='Seq28' value="-1" size="5" ></td>
        <td width="50"><input name='Seq29' value="-1" size="5" ></td>
        <td width="50"><input name='Seq210' value="-1" size="5" ></td>
      </tr>

      <tr>
        <td width="51"><input name='B2' value="-1"  size="5" ></td>
        <td width="51"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
      </tr>
    </table>
    </td>
  </tr>
 <tr>
    <td width="175" align="right" height="163">
       <table border="1" cellspacing="1" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
        <tr>
          <td width="80" align="right"><font size="2">Section Name:</font></td>
          <td width="95"><input name="L3" size="10"></td>
        </tr>
        <tr>
          <td width="80" align="right"><font size="2">.</font></td>
          <td width="95"><font size="2">Left Seat No</font></td>
        </tr>
        <tr>
          <td width="80" align="right">&nbsp;</td>
          <td width="95"><font size="2">Number Seq:</font></td>
        </tr>
        <tr>
          <td width="80" align="right"><font size="2">Row at front</font></td>
          <td width="95"><Select name="FR3"><%=strRowLetters%></select></td>
        </tr>
      </table>
    </td>
    <td width="525" height="163">
    <table border="1" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="502" id="AutoNumber2">
      <tr>
        <td width="51"><input name='A31' value="-1"  size="5" ></td>
        <td width="51"><input name='A32' value="-1" size="5" ></td>
        <td width="50"><input name='A33' value="-1" size="5" ></td>
        <td width="50"><input name='A34' value="-1" size="5" ></td>
        <td width="50"><input name='A35' value="-1" size="5" ></td>
        <td width="50"><input name='A36' value="-1" size="5" ></td>
        <td width="50"><input name='A37' value="-1" size="5" ></td>
        <td width="50"><input name='A38' value="-1" size="5" ></td>
        <td width="50"><input name='A39' value="-1" size="5" ></td>
        <td width="50"><input name='A310' value="-1" size="5" ></td>
      </tr>
      <tr>
        <td width="51"><input name='LS31' value="-1"  size="5" ></td>
        <td width="51"><input name='LS32' value="-1" size="5" ></td>
        <td width="50"><input name='LS33' value="-1" size="5" ></td>
        <td width="50"><input name='LS34' value="-1" size="5" ></td>
        <td width="50"><input name='LS35' value="-1" size="5" ></td>
        <td width="50"><input name='LS36' value="-1" size="5" ></td>
        <td width="50"><input name='LS37' value="-1" size="5" ></td>
        <td width="50"><input name='LS38' value="-1" size="5" ></td>
        <td width="50"><input name='LS39' value="-1" size="5" ></td>
        <td width="50"><input name='LS310' value="-1" size="5" ></td>
      </tr>
      <tr>
        <td width="51"><input name='Seq31' value="-1"  size="5" ></td>
        <td width="51"><input name='Seq32' value="-1" size="5" ></td>
        <td width="50"><input name='Seq33' value="-1" size="5" ></td>
        <td width="50"><input name='Seq34' value="-1" size="5" ></td>
        <td width="50"><input name='Seq35' value="-1" size="5" ></td>
        <td width="50"><input name='Seq36' value="-1" size="5" ></td>
        <td width="50"><input name='Seq37' value="-1" size="5" ></td>
        <td width="50"><input name='Seq38' value="-1" size="5" ></td>
        <td width="50"><input name='Seq39' value="-1" size="5" ></td>
        <td width="50"><input name='Seq310' value="-1" size="5" ></td>
      </tr>

      <tr>
        <td width="51"><input name='B3' value="-1"  size="5" ></td>
        <td width="51"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
        <td width="50"></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td width="175" align="right" height="19">&nbsp;</td>
    <td width="525" height="19">&nbsp;</td>
  </tr>
  <tr>
    <td width="175" align="right" height="19">&nbsp;</td>
    <td width="525" height="19">&nbsp;</td>
  </tr>
  <tr>
    <td width="175" align="right" height="19">&nbsp;</td>
    <td width="525" height="19">&nbsp;</td>
  </tr>
  <tr>
    <td width="175" align="right" height="26">&nbsp;</td>
    <td width="525" height="26"><input type="submit" value="SUBMIT"></td>
  </tr>
</table>
</form>
</body>

</html>