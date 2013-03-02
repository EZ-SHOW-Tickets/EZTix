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
ShowsID(1)="1540"
ShowsID(2)="1541"
ShowsID(3)="1542"
ShowsID(4)="1543"
ii=0
strSentTo=""
Set rsData = GetRecordSet("select PersonFirstName,PersonLastName,Personemail,NumberOfTickets,PackagePersonID from PACKAGE_PERSON,Person where PACKAGE_PERSON.PersonID=Person.PersonID and PackageID=18 and TransactionNumber > 0 and PACKAGE_PERSON.PackagepersonID= 1026")
'Set rsData = GetRecordSet("select PersonFirstName,PersonLastName,Personemail,NumberOfTickets,PackagePersonID from PACKAGE_PERSON,Person where PACKAGE_PERSON.PersonID=Person.PersonID and PackageID=18 and person.personemail is not null and TransactionNumber > 0 Order by PERSON.PersonLastName")
do until rsdata.eof or ii > 0  'end
	ii=ii+1
    if ii > 0 then    'start
			Set rsData2 = GetRecordSet("select PackageSeatType from PACKAGE_SEAT_TYPES where PackagePersonID = " & rsData(4))
			if len(rsData(2)) > 0 then
					If InStr(1, rsData2(0), "Tea") > 0 Then
					    bTea=true
					Else
					    bTea=False
					End If
					for i=1 to 4
						Set rsShow = GetRecordSet("Select Show,ShowDate,ShowTime, SHOWS.ShowID from SHOWS,PERFORMANCES,PERFORMANCE_RESERVATIONS where SHOWS.ShowID=PERFORMANCES.ShowID and PERFORMANCES.PerformanceID=PERFORMANCE_RESERVATIONS.PerformanceID and PERFORMANCE_RESERVATIONS.PackagePersonID = " & rsData(4) & " and PERFORMANCES.ShowID=" & ShowsID(i))
						DOW(i)=weekdayname(weekday(rsShow(1)))
						show(i)=rsShow(0)
						if bTea and (i= 2 or i=3) then
							Times(i)="1:00PM*"
						else
							Times(i)=rsShow(2)
						end if
						dates(i)=rsShow(1)		
					next		
							strHTML="<html><head><title></title></head><body>"
							strHTML=strHTML & "<table border='0' width=600 cellspacing='0' cellpadding='0' id='table1' height='731'>"
							strHTML=strHTML & "<tr><td align='left' valign='top'>"
							strHTML=strHTML & "<table border='0' width='100%' cellspacing='0' cellpadding='0' id='table2' height='387'>"
							strHTML=strHTML & "<tr><td height='84' align='left' valign='top'><font face='Arial'>"
							strHTML=strHTML & rsData(0) & " " & rsData(1) & "<br>"
							strHTML=strHTML & "<br>Presented below are your dates for the remainder of the Broadway On Tour 2010-2011 season. You have " & rsData(3) & " seats reserved for each of these shows:</font></td>"
							'strHTML=strHTML & "<br>Presented below is your date for the final show of the Broadway On Tour 2009-2010 season. You have " & rsData(3) & " seats reserved for this show:</font></td>"
							strHTML=strHTML & "</tr><tr><td height='75' align='left' valign='top'>"
							strHTML=strHTML & "<table border='1' width='100%' id='table3' cellspacing='0' cellpadding='0' bordercolor='#000000'>"
							strHTML=strHTML & "<tr>"
							strHTML=strHTML & "<td width='300' align='center'><b>SHOW</b></td>"
							strHTML=strHTML & "<td width='200' align='center'><b>DATE</b></td>"
							strHTML=strHTML & "<td align='center'><b>TIME</b></td>"
							strHTML=strHTML & "</tr>"
							'strHTML=strHTML & "<tr>"
							'strHTML=strHTML & "<td width='300' align='center'>" & show(1) & "</td>"
							'strHTML=strHTML & "<td width='200' align='center'>" & DOW(1) & " " & dates(1) & "</td>"
							'strHTML=strHTML & "<td align='center'>" & times(1) & "</td>"
							'strHTML=strHTML & "</tr>"
							strHTML=strHTML & "<tr>"
							strHTML=strHTML & "<td width='300' align='center'>" & show(2) & "</td>"
							strHTML=strHTML & "<td width='200' align='center'>" & DOW(2) & " " & dates(2) & "</td>"
							strHTML=strHTML & "<td align='center'>" & times(2) & "</td>"
							strHTML=strHTML & "</tr>"
							strHTML=strHTML & "<tr>"
							strHTML=strHTML & "<td width='300' align='center'>" & show(3) & "</td>"
							strHTML=strHTML & "<td width='200' align='center'>" & DOW(3) & " " & dates(3) & "</td>"
							strHTML=strHTML & "<td align='center'>" & times(3) & "</td>"
							strHTML=strHTML & "</tr>"
							strHTML=strHTML & "<tr>"
							strHTML=strHTML & "<td width='300' align='center'>" & show(4) & "</td>"
							strHTML=strHTML & "<td width='200' align='center'>" & DOW(4) & " " & dates(4) & "</td>"
							strHTML=strHTML & "<td align='center'>" & times(4) & "</td>"
							strHTML=strHTML & "</tr>"
							strHTML=strHTML & "</table>"
							strHTML=strHTML & "</td>"
							strHTML=strHTML & "</tr>"
							if bTea then
								strHTML=strHTML & "<tr>"
								strHTML=strHTML & "<td valign='top' align='right'><font face='Arial' size='1'><b>*Tea Time</b></td></tr>" 
							end if
							''strHTML=strHTML & "<br>"
							strHTML=strHTML & "<tr>"
							strHTML=strHTML & "<td valign='top'><font face='Arial'>Please note that season ticket holders can change their dates UP TO 10 DAYS BEFORE the show opens (no later than January 19th for Snoopy!!!). " 
							strHTML=strHTML & "<br>Simply go to the special season ticket holder web site at <a href='http://www.broadwayontour.org/seasonticket.htm'>http://www.broadwayontour.org/seasonticket.htm</a>  to view and/or change your tickets."
							strHTML=strHTML & "<br>After the run of the show begins, you can change your designated date but there is no guarantee that you will seated in our preferred season tickets seats for that performance."
							strHTML=strHTML & "<p>We value our season ticket holders and their continued support of Broadway On Tour.  However, as our theater grows it has become extremely time consuming for our volunteers to satisfy every request for date changes."
							strHTML=strHTML & "  We hope that this proceedure will give you the flexibilty that you need to continue to enjoy the BOT experience."
							strHTML=strHTML & "<p>We are looking forward to seeing you at "
							strHTML=strHTML & "the up-coming performances.</p>"
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
							myMail.Subject="Broadway On Tour Season Ticket Reservations"
							'myMail.Subject="Broadway On Tour Season Ticket Holders"
							myMail.HTMLBody=strHTML
							myMail.Send
							strSentTo=strSentTo & " " & rsdata(2) & "(" & err.Description & ")"
							set mymail=nothing
				end if
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
    <%=strSentTo%>
	<%=strHTML%>
</body>

</html>
