<!-- #include file = "../securesite/common.asp" -->

<%

dim strHTML,myMail 
dim rsData, rsData2,rsShow
dim bTea
dim Dates(4), Times(4),DOW(4)
dim ShowsID(4),Show(4)
dim strSentTo
dim i,ii
server.ScriptTimeout = 600
ii=0
strSentTo=""
Set rsData = GetRecordSet("select distinct PersonFirstName,PersonLastName,Personemail from PACKAGE_PERSON,Person where PACKAGE_PERSON.PersonID=Person.PersonID and (PackageID=16 or PackageID=17) and person.personemail is not null and TransactionNumber > 0 Order by PERSON.PersonLastName")
do until rsdata.eof 'or ii > 143
	ii=ii+1
    if ii > 144 then
					strHTML="<html><head><title></title></head><body>"
					strHTML=strHTML & "<table border='0' width=600 cellspacing='0' cellpadding='0' id='table1' height='731'>"
					strHTML=strHTML & "<tr><td align='left' valign='top'>"
					strHTML=strHTML & "<table border='0' width='100%' cellspacing='0' cellpadding='0' id='table2' height='387'>"
					strHTML=strHTML & "<tr><td  align='left' valign='top'><font face='Arial'>"
					strHTML=strHTML & rsData(0) & " " & rsData(1)  & "<br><br>"
					strHTML=strHTML & "<tr>"
					strHTML=strHTML & "<td valign='top'><font face='Arial'>Broadway On Tour is looking forward to an exciting 2010-2011 season.  <br><br>Starting in October, we will present the classic Broadway show ANNIE. Our winter and spring shows will be one hour productions of SNOOPY and WONDERLAND.  Each of these shows has an optional tea party.  We are pleased to be able to " 
					strHTML=strHTML & "present the world premier of PRINCESSES as our summer 2011 two hour show."
					strHTML=strHTML & "<p>As a past season ticket holder, we want to remind you that, if you haven't done so, please remember to order your season tickets on-line by going to <a href='www.broadwayontour.org'>www.broadwayontour.org</a> and following the links to our season ticket order site."
					strHTML=strHTML & "<br>Remember, season ticket holders not only save money, but they get assigned the best seats in the house!</p>"
					'strHTML=strHTML & "<p>We value our season ticket holders and their continued support of Broadway On Tour.  However, as our theater grows it has become extremely time consuming for our volunteers to satisfy every request for date changes."
					''strHTML=strHTML & "  We hope that this proceedure will give you the flexibilty that you need to continue to enjoy the BOT experience."
					strHTML=strHTML & "<p>We are looking forward to seeing you at the up-coming performances.</p>"
					strHTML=strHTML & "<p>Sincerely,</p>"
					strHTML=strHTML & "<p>Julie Onken<br>"
					strHTML=strHTML & "Broadway On Tour</td>"
					strHTML=strHTML & "</tr>"
					strHTML=strHTML & "</table>"
					strHTML=strHTML & "</td>"
					strHTML=strHTML & "</tr></font>"
					strHTML=strHTML & "</table>"
					strHTML=strHTML & "</body></html>"
						    
				    set myMail=createObject("CDO.message")
						    
				'    myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail2.cgc-intl.com"
				'    myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
				'    myMail.Configuration.Fields.Item(cdoSendUsingMethod) = cdoSendUsingPort  
				  	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "96.229.152.43" 
					'myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "stan.broadwayontour.org" 
				''	myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "207.171.1.164" 
					myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25  
					myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2  
				'	myMail.Configuration.Fields.Item(cdoSMTPAuthenticate) = cdoBasic 
				' Specify the authentication mechanism 
				' to use. 
				'myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1

				' The username for authenticating to an SMTP server using basic (clear-text) authentication
				''myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = 	"harvey.goodman"

				' The password used to authenticate 
				' to an SMTP server using authentication
				'myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") =	"harvey"

				'Use SSL for the connection (False or True)
				'myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False

				' Set the number of seconds to wait for a valid socket to be established with the SMTP service before timing out.
				myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") =	60

						
					on error resume next
				    myMail.Configuration.Fields.Update
					''Set myMail = CreateObject("CDONTS.NewMail")
					myMail.From="bot.seasontickets@broadwayontour.org"
					''myMail.From="hgoodman@cgc-intl.com"
					myMail.To=rsdata(2)
					'myMail.To="hgoodman@cgc-intl.com"
					myMail.BCC="hgoodman@cgc-intl.com"
					myMail.Subject="Broadway On Tour 2010-2011 Season Tickets"
					'myMail.Subject="Broadway On Tour Season Ticket Holders"
					myMail.HTMLBody=strHTML
					myMail.Send
							
					strSentTo=strSentTo & " " & rsdata(2) & "(" & err.Description & ")"
					set mymail=nothing
				''end if
			end if
	rsData.movenext
 loop
%>
<html>
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Email</title>
</head>
<body>
    <%=ii%>
    <%=strSentTo%>
	<%=strHTML%>
</body>

</html>
