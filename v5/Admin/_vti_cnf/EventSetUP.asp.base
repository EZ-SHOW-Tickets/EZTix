<!--#INCLUDE file="../common.asp"-->
<%
dim i ,x,j
dim rsShows,rsShow,rsTheaters,rsPrices,rsPrice,rsPerformance,rsTicketInfo
dim numShows,numPerformances  ',ShowName,ShowStartDate,ShowEndDate,TheaterName,TheaterID,intOtherPriceID
dim strShows,strPerformance,strTheaters,strPrices,strNewPerformance
dim strOnLine   ',strPID,rsServiceCharge,strServiceCharge,intPrimaryPriceID,strOnLine,intServiceChargeType
dim rsCategories
dim strCategories
dim strSeatLocation,strSeatingCategory,strPriceCategory,strPerformanceCheck,strChecked
dim strNEWDate,strNEWTime,strNEWSeatLocation,strNEWSeatingCategory
dim PerformanceArray(),bNotEOF,TicketPriceCat,PerfID
dim numPrices,TicketsSold
dim AddNew
dim rs,rs2
dim strOpenClose(3),cShowOpen(2),pOpenClose(3)
'strOpenClose(1)="Open"
'strOpenClose(2)="Closed On-Line"
'strOpenClose(3)="Sold Out"
strOpenClose(0)="Open"
strOpenClose(1)="Closed On-Line"
strOpenClose(2)="Sold Out"

'Initialize
numShows=0
numPerformances=0
TheaterID=0
strTheaters=""
ServiceCharge=0.00
ServiceChargeType=0
ShowOnLine=0
numPrices=0
ShowHoldHours=24
strShowSummary=""
bNotEOF=false
AddNew=true
cShowOpen(1)=""
cShowOpen(2)=""

''''''''For testing
if isempty(session("AccountID")) then 
	session("AccountID")=10
	session("AccountName")="TEST"
end if
''''''''''
AccountID=session("AccountID")
''''''''''''''''
getAccountInformation AccountID
'Get all currently open shows
set rsShows=GetAllEventsForAnAccount(AccountID)
if rsShows.eof then
	bNotEOF = false
else
	bNotEOF = true
end if
'''''''''SET SHOW ID''''''''''''''
'
'

	if isempty(Request.QueryString("ShowID")) and isempty(session("ShowID")) then
		'no option selected
		ShowID=-1
		'ShowID=107 'TTTTTTTEST
	elseif not isempty(Request.QueryString("ShowID")) then   'and not isempty(session("ShowID")) then
		'A show has been selected
			ShowID=cint(Request.QueryString("ShowID"))
			session("ShowID")=Request.QueryString("ShowID")		
	elseif not isempty(session("ShowID")) then
		'A show has been selected
			ShowID=cint(session("ShowID"))
	else
		'option selected
		if isempty(Request.QueryString("ShowID")) then
			'Same Show
			ShowID=cint(session("ShowID"))
		else
			'Existing Show
			ShowID=cint(Request.QueryString("ShowID"))
			session("ShowID")=Request.QueryString("ShowID")
		end if
	end if
'
'
''''''''''''''''


'if not rsShows.eof then
	'There are shows to edit
'''''CHECK REQUEST''''''''''''''''''''''''''
'
' AddDate=1: Add New Event Date
' AddDate=2: Update/Save Event
'        
'
	if Request.Form("AddDate")="2" then
		'Update/Save Event
		if ShowID=0 then
			'new Event - insert event
			strSQL="INSERT INTO SHOWS (AccountID,TheaterID,Show,StartDate,EndDate,HoldHours,ShowOpen,ShowLogo,ShowSummary)"
			strSQL=strSQL & " values(" & AccountID & "," & Request.Form("SelectTheater") & ",'" & replace(Request.Form("Showname"),"'","`")& "','" & Request.Form("StartDate") & "','"
			strSQL=strSQL & Request.Form("EndDate") & "'," & Request.Form("iRemoveHours") & ",0,'_spacer.gif','" & replace(Request.Form("ShowSummary"),"'","`") & "')"
			ShowID=insertrecord(strSQL,"SHOWS","ShowID")
			session("ShowID")=ShowID
			ShowID=cint(session("ShowID"))
			x=insertrecord("INSERT INTO SERVICE_CHARGE (ShowID,ServiceCharge,ServiceChargeType) values(" & ShowID & "," & Request.Form("ServiceCharge") & "," & Request.Form("SCType") & ")","SERVICE_CHARGE","ShowID")
		else
			'Update
			strSQL="UPDATE SHOWS set TheaterID=" & Request.Form("SelectTheater") & ",Show='" & replace(Request.Form("Showname"),"'","`") & "'"
			strSQL=strSQL & ",StartDate='" & Request.Form("StartDate") & "',EndDate='" & Request.Form("EndDate") & "'"
			strSQL=strSQL & ",HoldHours=" & Request.Form("iRemoveHours") & ",ShowOpen=" & Request.Form("rOnLine")
			strSQL=strSQL& ",ShowSummary='" & replace(Request.Form("ShowSummary"),"'","`") & "' where ShowID=" & ShowID
			updaterecord strSQL
			strSQL="UPDATE SERVICE_CHARGE set ServiceCharge=" & Request.Form("ServiceCharge") & ",ServiceChargeType=" & Request.Form("SCType") & " where ShowID=" & ShowID
			updaterecord strSQL
		end if
	elseif Request.Form("AddDate")="1" then
		'Add a new date
		strSQL="Insert INTO PERFORMANCES (ShowID,ShowDate,ShowTime,PerformanceOpen) values(" & ShowID & ",'" & Request.form("nPerformanceDate") & "','" & Request.form("nPerformanceTime") & "',0)"
		PerformanceID=insertrecord(strSQL,"PERFORMANCES","PerformanceID")
		'Inventory
		'strSQL="Insert INTO PERFORMANCE_TICKETS_AVAILABLE (PerformanceID,SeatCategoryID,TicketInventory,TicketsAvailable) values(" & PerformanceID & "," & Request.Form("sSeatCategory") & "," & Request.form("TicketInventory")  & "," & Request.form("TicketInventory") & ")"
		'x=insertrecord(strSQL,"PERFORMANCE_TICKETS_AVAILABLE","PerformanceID")
		'Pricing
		for i= 1 to cint(Request.Form("NewPrices"))
			strSQL="Insert INTO PERFORMANCE_TICKET_PRICE (PerformanceID,SeatCategoryID,SeatingCategoryID,PriceCategoryID,TicketPrice) values("
			strSQL=strSQL & PerformanceID & "," & Request.Form("sSeatCategory") & "," & Request.Form("sSeatingCategory") & "," & Request.Form("sPriceCategory" & trim(cstr(i)))  & "," & Request.Form("iTicketPrice" & trim(cstr(i))) & ")"
			x=insertrecord(strSQL,"PERFORMANCE_TICKET_PRICE","PerformanceID")
		next
		'Check if NEW price was added
		if Request.Form("sPriceCategoryNEW")<>"0" and Request.Form("iTicketPriceNEW")<>"" then
			strSQL="Insert INTO PERFORMANCE_TICKET_PRICE (PerformanceID,SeatCategoryID,SeatingCategoryID,PriceCategoryID,TicketPrice) values("
			strSQL=strSQL & PerformanceID & "," & Request.Form("sSeatCategory") & "," & Request.Form("sSeatingCategory") & "," & Request.Form("sPriceCategoryNEW") & "," & Request.Form("iTicketPriceNEW") & ")"
			x=insertrecord(strSQL,"PERFORMANCE_TICKET_PRICE","PerformanceID")		
		end if
		'CLUDGE!!!
		if ShowID > 0 then
			GetShowInformation ShowID 
			set rs=getrecordset("Select * from THEATER_SEAT_CATEGORY where TheaterID=" & TheaterID)
			do until rs.eof
				strSQL="INSERT INTO THEATER_PERFORMANCE_SEAT_CATEGORY (PerformanceID,TheaterID,Area,tSection,SeatCategoryID)"
				strSQL=strSQL & " values(" & PerformanceID & "," & TheaterID & "," & rs("Area") & "," & rs("tSection") & "," & Request.Form("sSeatCategory") & ")"
				x=insertrecord(strSQL,"THEATER_PERFORMANCE_SEAT_CATEGORY","PerformanceID")
				rs.movenext
			loop
		end if
	elseif Request.Form("AddDate")="5" then
		'Delete a PERFORMANCE Date
		deleterecord "DELETE FROM PERFORMANCES where PerformanceID=" & Request.form("EditPerf")
		deleterecord "DELETE FROM PERFORMANCE_TICKETS_AVAILABLE where PerformanceID=" & Request.form("EditPerf")
		deleterecord "DELETE FROM PERFORMANCE_TICKET_PRICE where PerformanceID=" & Request.form("EditPerf")
		deleterecord "DELETE FROM THEATER_PERFORMANCE_SEAT_CATEGORY where PerformanceID=" & Request.form("EditPerf")
	end if
'
'
''''''''''''''''''''''''''''''''''''
	if ShowID > 0 then   '''''A
''''''DISPLAY EXISTING SHOW/PERFORMANCE INFORMATION''''
'
'
'	 Get and display Show Information
		GetShowInformation ShowID 
		if ShowOnLine=1 then
			cShowOpen(1)="checked"
		else
			cShowOpen(2)="checked"
		end if
	'Service Charge
		GetServiceCharge(ShowID)
	'Get all performances for this show
		set rsShow=getAllPerformanceForShow(ShowID)
		do until rsShow.eof
			'loop thru each Performance
				numPerformances=numPerformances + 1
			    getPerformanceInformation rsShow("PerformanceID")
				pOpenClose(0)=""
				pOpenClose(1)=""
				pOpenClose(2)=""
			    if PerformanceStatus=0 then
					pOpenClose(0)="checked"
			    elseif PerformanceStatus=1 then
					pOpenClose(1)="checked"
			    else
					pOpenClose(2)="checked"
				end if
			    'Ticket information for performance
				set rsTicketInfo=GetAllSeatInformationForAPerformance(rsShow("PerformanceID"))
			''''''CHECK IF THIS EVENT DATE IS TO BE EDITED'''
			'
			'
				if rsTicketInfo.eof then
				'''Missing ticketing data - delete
					deleterecord "Delete from PERFORMANCES where PerformanceID=" & rsShow("PerformanceID")
				else
					if cstr(rsShow("PerformanceID"))=Request.form("EditPerf") then
					  if Request.Form("AddDate")="3" then
						'''''''''''Edit/Update a performance
						'
						'
							  	AddNew=false
							  	set rsCategories=getSeatCategoriesForATheater(TheaterID)
								numPrices=0
								do until rsCategories.eof
									'numPrices=numPrices+1
									if rsCategories("SeatCategoryID")=rsTicketInfo("SeatCategoryID") then
										strSeatLocation=strSeatLocation & "<option value='" & rsCategories("SeatCategoryID") & "' selected>" & rsCategories("SeatCategory") & "</option>"
									else	
										strSeatLocation=strSeatLocation & "<option value='" & rsCategories("SeatCategoryID") & "'>" & rsCategories("SeatCategory") & "</option>"
									end if
									rsCategories.movenext
								loop
								if i>1 then
										strSeatLocation="<option value='0'>---Select---</option>" & strSeatLocation
								end if
								set rsCategories=getSeatingCategories()
								i=0
								do until rsCategories.eof
									i=i+1
									if rsCategories("SeatingCategoryID")=rsTicketInfo("SeatCategoryID") then
										strSeatingCategory=strSeatingCategory & "<option value='" & rsCategories("SeatingCategoryID") & "' selected>" & rsCategories("SeatingCategory") & "</option>"
									else	
										strSeatingCategory=strSeatingCategory & "<option value='" & rsCategories("SeatingCategoryID") & "'>" & rsCategories("SeatingCategory") & "</option>"
									end if
									rsCategories.movenext
								loop
								if i>1 then
											strSeatingCategory="<option value='0'>---Select---</option>" & strSeatingCategory
								end if
								GetInventoryForPerformance rsShow("PerformanceID")
								'strCategories="<td colspan='2' width='55%'><select name='sSeatCategoryE'>" & strSeatLocation & "</select><select name='sSeatingCategoryE'>" & strSeatingCategory & "</select><br>Inventory:<input name='TicketInventoryE' value='" & GetTicketInventoryForPerformanceAndCategory(rsShow("PerformanceID"),rsTicketInfo("SeatCategory")) & "' size='5'></td>"
								'trCategories="<td colspan='2' width='55%'><select name='sSeatCategoryE'>" & strSeatLocation & "</select><select name='sSeatingCategoryE'>" & strSeatingCategory & "</select><br>Inventory:" & TicketInventory & "<input type='button' value='EDIT' onclick='javascript:EditInventory(" & rsShow("PerformanceID") & ");' id='button'1 name='button'1></td>"
								strCategories="<td colspan='2' width='55%' valign='top'><select name='sSeatCategoryE'>" & strSeatLocation & "</select><select name='sSeatingCategoryE'>" & strSeatingCategory & "</select><br><font face='Arial' size='2'>Inventory:&nbsp;" & TicketInventory & "</font>&nbsp;&nbsp;<a href='javascript:EditInventory(" & rsShow("PerformanceID") & ");' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('ImageM','','../images/ModifyON.gif',1)""><img name='ImageM' border='0' src='../images/Modify.gif'></a></td>"
							
							  i=0 
							  strPrices=""
							  do until rsTicketInfo.eof
							    'number of prices
							    i=i+1
								strPrices=strPrices & "<tr>"
								strPrices=strPrices & "<td width='5%' align='right'></td>"
								strPriceCategory=""
								set rsCategories=getPricingCategories()
								j=0
								do until rsCategories.eof
									j=j+1
									if rsCategories("PriceCategoryID")= rsTicketInfo("PriceCategoryID") then
										strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "' selected>" & rsCategories("PriceCategory") & "</option>"
										numPrices=numPrices+1
									else	
										strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "'>" & rsCategories("PriceCategory") & "</option>"
									end if
									rsCategories.movenext
								loop
								if j>1 then
											strPriceCategory="<option value='0'>---Select---</option>" & strPriceCategory
								end if
								strPrices=strPrices & "<td width='50%' align='right'><select name='sPriceCategoryE" & trim(cstr(numPrices)) & "'>" & strPriceCategory & "</select></td>"
								strPrices=strPrices & "<td width='45%' align='left' valign='top'><input name='iTicketPriceE" & trim(cstr(numPrices)) & "' size='6' value='" & rsTicketInfo("TicketPrice") & "'></td>"
								strPrices=strPrices & "</tr>"				
								rsTicketInfo.movenext
							loop
								strPerformance=strPerformance & "<tr><td width='100%'>"
								strPerformance=strPerformance & "<table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber9'>"
								strPerformance=strPerformance & "<tr>"
								strPerformance=strPerformance & "<td width='10%' align='center' bgcolor='#FFFF66'><font face='Arial' size='2'><b>DATE</b></font></td>"
								strPerformance=strPerformance & "<td width='10%' align='center' bgcolor='#FFFF66'><font face='Arial' size='2'><b>TIME</b></font></td>"
								strPerformance=strPerformance & "<td width='25%' align='center' bgcolor='#FFFF66'><b><font face='Arial' size='2'>Status</font></b></td>"
								strPerformance=strPerformance & "<td width='55%' align='center' bgcolor='#FFFF66'><b><font face='Arial' size='2'>Tickets (" & getNumberOfPurchasedSeatsForAPerformance(rsShow("PerformanceID")) & " sold)</font></b></td>"


								strPerformance=strPerformance & "</tr>"
								strPerformance=strPerformance & "<tr>"
								
								strPerformance=strPerformance & "<td width='10%' align='center' valign='top'><input name='nPerformanceDateE' size='8' value='" & formatdatetime(strPerformanceDate,vbshortdate) & "'></td>"
								strPerformance=strPerformance & "<td width='10%' align='center' valign='top'><input name='nPerformanceTimeE' size='6' value='" & strPerformanceTime & "'></td>"
								strPerformance=strPerformance & "<td width='25%' align='left'><b><font face='Arial' size='1'><input type='radio' name='OpenCloseE' value='0' " & pOpenClose(0) & ">Open<br><input type='radio' name='OpenCloseE' value='1' " & pOpenClose(1) & ">Closed On-Line<br><input type='radio' name='OpenCloseE' value='2' " & pOpenClose(2) & ">Sold Out</font></b></td>"
								strPerformance=strPerformance & "<td width='55%' align='left' valign='top'>"
								strPerformance=strPerformance & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber10'>"
								strPerformance=strPerformance & "<tr>"
								strPerformance=strPerformance & strCategories
								strPerformance=strPerformance & "</tr>"
								strPerformance=strPerformance & strPrices

								strPerformance=strPerformance & "</table>"
								strPerformance=strPerformance & "</td>"
								strPerformance=strPerformance & "</tr>"
								strPerformance=strPerformance & "<tr>"
								strPerformance=strPerformance & "<td width='100%' colspan='4' align='center' bgcolor='#FFFF66'><a href='javascript:fUpdatePerformance(" & rsShow("PerformanceID") & "," & numPrices & ");' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('ImageUD','','../images/UpdateON.gif',1)""><img name='ImageUD' border='0' src='../images/Update.gif'></a>  <a href='javascript:fDeletePerformance(" & rsShow("PerformanceID") & ");' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('ImageDel','','../images/DeleteON.gif',1)""><img name='ImageDel' border='0' src='../images/Delete.gif'></a>  <a href='javascript:CancelUpdate();' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('ImageC','','../images/CancelON.gif',1)""><img name='ImageC' border='0' src='../images/Cancel.gif'></a></td>"
								strPerformance=strPerformance & "</tr>"
								strPerformance=strPerformance & "</table>"
								strPerformance=strPerformance & "</td>"
								strPerformance=strPerformance & "</tr>"	
							else
							'''''''Save updated Performance''''''''
							'
								strSQL="UPDATE PERFORMANCES set ShowDate='" & Request.form("nPerformanceDateE") & "',ShowTime='" & Request.form("nPerformanceTimeE") & "',PerformanceOpen=" & Request.form("OpenCloseE") & " where PerformanceID=" & rsShow("PerformanceID")
								updaterecord(strSQL)
								'Inventory
								strSQL="UPDATE PERFORMANCE_TICKETS_AVAILABLE set TicketInventory=" & Request.Form("TicketInventoryE")  & " where PerformanceID=" & rsShow("PerformanceID") 
								updaterecord strSQL
								'Pricing
								'first DELETE all pricing and then reINSERT
								deleterecord "DELETE From PERFORMANCE_TICKET_PRICE where PerformanceID= " & rsShow("PerformanceID")
								for i= 1 to cint(Request.Form("NewPrices"))
									strSQL="Insert INTO PERFORMANCE_TICKET_PRICE (PerformanceID,SeatCategoryID,SeatingCategoryID,PriceCategoryID,TicketPrice) values("
									strSQL=strSQL & rsShow("PerformanceID") & "," & Request.Form("sSeatCategoryE") & "," & Request.Form("sSeatingCategoryE") & "," & Request.Form("sPriceCategoryE" & trim(cstr(i)))  & "," & Request.Form("iTicketPriceE" & trim(cstr(i))) & ")"
									x=insertrecord(strSQL,"PERFORMANCE_TICKET_PRICE","PerformanceID")
								next
								'CLUDGE!!!
								GetShowInformation ShowID 
								set rs=getrecordset("Select * from THEATER_SEAT_CATEGORY where TheaterID=" & TheaterID)
								set rs2=getrecordset("Select * from THEATER_PERFORMANCE_SEAT_CATEGORY where PerformanceID=" & rsShow("PerformanceID") & " and TheaterID=" & TheaterID & " and Area=" & rs("Area") & " and tSection=" & rs("tSection") & " and SeatCategoryID=" & Request.Form("sSeatCategoryE"))
								if rs2.eof then
									strSQL="INSERT INTO THEATER_PERFORMANCE_SEAT_CATEGORY (PerformanceID,TheaterID,Area,tSection,SeatCategoryID)"
									strSQL=strSQL & " values(" & rsShow("PerformanceID") & "," & TheaterID & "," & rs("Area") & "," & rs("tSection") & "," & Request.Form("sSeatCategoryE") & ")"
									x=insertrecord(strSQL,"THEATER_PERFORMANCE_SEAT_CATEGORY","PerformanceID")
								end if					
								Response.Redirect "EventSetUp.asp"
							'
							''''''''''''''''''''''''''''''''''''''''
							end if			
					else
					'''''PUT UP EVENT DATE
					'
					'
						strPerformance=strPerformance & "<tr><td width='100%'>"
						strPerformance=strPerformance & "<table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber9'>"
						strPerformance=strPerformance & "<tr>"
						strPerformance=strPerformance & "<td width='10%' align='center' bgcolor='#CCCCCC'><font face='Arial' size='2'><b>DATE</b></font></td>"
						strPerformance=strPerformance & "<td width='10%' align='center' bgcolor='#CCCCCC'><font face='Arial' size='2'><b>TIME</b></font></td>"
						strPerformance=strPerformance & "<td width='25%' align='center' bgcolor='#CCCCCC'><b><font face='Arial' size='2'>Status</font></b></td>"
						strPerformance=strPerformance & "<td width='55%' align='center' bgcolor='#CCCCCC'><b><font face='Arial' size='2'>Tickets (" & getNumberOfPurchasedSeatsForAPerformance(rsShow("PerformanceID")) & " sold)</font></b></td>"
						strPerformance=strPerformance & "</tr>"
						strPerformance=strPerformance & "<tr>"
						strPerformance=strPerformance & "<td width='10%' align='center' valign='top'><font face='Arial' size='2'><b>" & formatdatetime(strPerformanceDate,vbshortdate) & "</b></font></td>"
						strPerformance=strPerformance & "<td width='10%' align='center' valign='top'><font face='Arial' size='2'><b>" & strPerformanceTime & "</b></font></td>"
						'strPerformance=strPerformance & "<td width='25%' align='left'><b><font face='Arial' size='1'><input type='radio' name='OpenClose" & rsShow("PerformanceID") & "' value='1'>Open<br><input type='radio' name='OpenClose" & rsShow("PerformanceID") & "' value='2'>Closed On-Line<br><input type='radio' name='OpenClose" & rsShow("PerformanceID") & "' value='3'>Sold Out</font></b></td>"
						strPerformance=strPerformance & "<td width='25%' align='center'><b><font face='Arial' size='1'>" & strOpenClose(PerformanceStatus) & "</font></b></td>"
						strPerformance=strPerformance & "<td width='55%' align='left' valign='top'>"
						strPerformance=strPerformance & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber10'>"
						strPerformance=strPerformance & "<tr>"
						strPerformance=strPerformance & "<td colspan='2' width='55%'><font face='Arial' size='2'>" & rsTicketInfo("SeatCategory") & " " & rsTicketInfo("SeatingCategory") &"</font></td>"
						'strPerformance=strPerformance & "<td width='45%' align='left'><font face='Arial' size='2'>Inventory:" & GetTicketInventoryForPerformanceAndCategory(rsShow("PerformanceID"),rsTicketInfo("SeatCategory")) & "</font></td>"
						GetInventoryForPerformance rsShow("PerformanceID")
						strPerformance=strPerformance & "<td width='45%' align='left'><font face='Arial' size='2'>Inventory:" & TicketInventory & "</font></td>"
						strPerformance=strPerformance & "</tr>"
						do until rsTicketInfo.eof
								strPerformance=strPerformance & "<tr>"
								strPerformance=strPerformance & "<td width='5%' align='right'><font face='Arial'></font></td>"
								strPerformance=strPerformance & "<td width='50%' align='left'><font face='Arial' size='2'>" & rsTicketInfo("PriceCategory") & "</font></td>"
								strPerformance=strPerformance & "<td width='45%' align='left'><font face='Arial' size='2'>" & formatcurrency(rsTicketInfo("TicketPrice"),2) & "</font></td>"
								strPerformance=strPerformance & "</tr>"
								rsTicketInfo.movenext
						loop
						strPerformance=strPerformance & "</table>"
						strPerformance=strPerformance & "</td>"
						strPerformance=strPerformance & "</tr>"
						strPerformance=strPerformance & "<tr>"
						strPerformance=strPerformance & "<td width='100%' colspan='4' align='center'><a href='javascript:fEditDelete(" & rsShow("PerformanceID") & ");' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('Image" & cstr(numPerformances) & "','','../images/EditDeleteON.gif',1)""><img name='Image" & cstr(numPerformances) & "' border='0' src='../images/EditDelete.gif'></a></td>"
						strPerformance=strPerformance & "</tr>"
						strPerformance=strPerformance & "</table>"
						strPerformance=strPerformance & "</td>"
						strPerformance=strPerformance & "</tr>"
					end if
				end if
				rsShow.movenext
			loop
		strPerformance=strPerformance & "<tr>"
		''''NEW PERFORMANCE INPUT''''''''''''
		'
		'		
		 if not isempty(Request.Form("AddDate")) then
			if Request.Form("AddDate")="0" then
			   ''''''Add price only''''
			   '
			   '
				strNEWDate=Request.Form("nPerformanceDate")
				strNEWTime=Request.Form("nPerformanceTime")
				strNEWSeatLocation=Request.Form("sSeatCategory")
				strNEWSeatingCategory=Request.Form("sSeatingCategory")
				numPrices = cint(Request.Form("NewPrices"))+1
				strPrices=""					
				for i= 1 to cint(Request.Form("NewPrices"))
					strPrices=strPrices & "<tr>"
					strPrices=strPrices & "<td width='5%' align='right'></td>"
					strPriceCategory=""
					set rsCategories=getPricingCategories()
					j=0
					do until rsCategories.eof
						j=j+1
						if rsCategories("PriceCategoryID")= cint(Request.Form("sPriceCategory" & trim(cstr(i)))) then
							strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "' selected>" & rsCategories("PriceCategory") & "</option>"
						else	
							strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "'>" & rsCategories("PriceCategory") & "</option>"
						end if
						rsCategories.movenext
					loop
					if j>1 then
								strPriceCategory="<option value='0'>---Select---</option>" & strPriceCategory
					end if
					strPrices=strPrices & "<td width='50%' align='right'><select name='sPriceCategory" & trim(cstr(i)) & "'>" & strPriceCategory & "</select></td>"
					strPrices=strPrices & "<td width='45%' align='left' valign='top'><input name='iTicketPrice" & trim(cstr(i)) & "' size='6' value='" & Request.Form("iTicketPrice" & trim(cstr(i))) & "'></td>"
					strPrices=strPrices & "</tr>"				
				next
				strPrices=strPrices & "<tr>"
				strPrices=strPrices & "<td width='5%' align='right'></td>"
				strPriceCategory=""
				set rsCategories=getPricingCategories()
				j=0
				do until rsCategories.eof
					j=j+1
					if rsCategories("PriceCategoryID")= cint(Request.Form("sPriceCategoryNEW")) then
						strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "' selected>" & rsCategories("PriceCategory") & "</option>"
					else	
						strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "'>" & rsCategories("PriceCategory") & "</option>"
					end if
					rsCategories.movenext
				loop
				if j>1 then
							strPriceCategory="<option value='0'>---Select---</option>" & strPriceCategory
				end if
				strPrices=strPrices & "<td width='50%' align='right'><select name='sPriceCategory" & trim(cstr(numPrices)) & "'>" & strPriceCategory & "</select></td>"
				strPrices=strPrices & "<td width='45%' align='left' valign='top'><input name='iTicketPrice" & trim(cstr(numPrices)) & "' size='6' value='" & Request.Form("iTicketPriceNEW") & "'></td>"
				strPrices=strPrices & "</tr>"
	        end if
	
		end if
		'''''get options
		set rsCategories=getSeatCategoriesForATheater(TheaterID)
		'set rsCategories=GetSeatingCategories()
		i=0
		do until rsCategories.eof
			i=i+1
			if rsCategories("SeatCategoryID")=cint(strNEWSeatLocation) then
				strSeatLocation=strSeatLocation & "<option value='" & rsCategories("SeatCategoryID") & "' selected>" & rsCategories("SeatCategory") & "</option>"
			else	
				strSeatLocation=strSeatLocation & "<option value='" & rsCategories("SeatCategoryID") & "'>" & rsCategories("SeatCategory") & "</option>"
			end if
			rsCategories.movenext
		loop
		if i>1 then
					strSeatLocation="<option value='0'>---Select---</option>" & strSeatLocation
		end if
		set rsCategories=getSeatingCategories()
		i=0
		do until rsCategories.eof
			i=i+1
			if rsCategories("SeatingCategoryID")=cint(strNEWSeatingCategory) then
				strSeatingCategory=strSeatingCategory & "<option value='" & rsCategories("SeatingCategoryID") & "' selected>" & rsCategories("SeatingCategory") & "</option>"
			else	
				strSeatingCategory=strSeatingCategory & "<option value='" & rsCategories("SeatingCategoryID") & "'>" & rsCategories("SeatingCategory") & "</option>"
			end if
			rsCategories.movenext
		loop
		if i>1 then
					strSeatingCategory="<option value='0'>---Select---</option>" & strSeatingCategory
		end if
		set rsCategories=getPricingCategories()
		i=0
		strPriceCategory=""
		do until rsCategories.eof
			i=i+1
			strPriceCategory=strPriceCategory & "<option value='" & rsCategories("PriceCategoryID") & "'>" & rsCategories("PriceCategory") & "</option>"
			rsCategories.movenext
		loop
		if i>1 then
					strPriceCategory="<option value='0'>---Select---</option>" & strPriceCategory
		end if
		'''''''''''''''
		if addNew then
			GetSeatsAtTheater TheaterID
			strNEWPerformance=strNEWPerformance & "<tr><td width='100%'>"
			strNEWPerformance=strNEWPerformance & "<table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber9'>"
			strNEWPerformance=strNEWPerformance & "<tr>"
			strNEWPerformance=strNEWPerformance & "<td width='10%' align='center' bgcolor='#CCCCCC'><font face='Arial' size='2'><b>NEW<br>DATE</b></font></td>"
			strNEWPerformance=strNEWPerformance & "<td width='10%' align='center' bgcolor='#CCCCCC'><font face='Arial' size='2'><b>NEW<br>TIME</b></font></td>"
			strNEWPerformance=strNEWPerformance & "<td width='25%' align='center' bgcolor='#CCCCCC'><b><font face='Arial' size='2'>Status</font></b></td>"
			strNEWPerformance=strNEWPerformance & "<td width='55%' align='center' bgcolor='#CCCCCC'><b><font face='Arial' size='2'>Tickets</font></b></td>"
			strNEWPerformance=strNEWPerformance & "</tr>"
			strNEWPerformance=strNEWPerformance & "<tr>"
			strNEWPerformance=strNEWPerformance & "<td width='10%' align='center' valign='top'><input name='nPerformanceDate' size='8' value='" & strNEWDate & "'><br><font face='Arial' size='1'>(eg 6/4/2005)</font.</td>"
			strNEWPerformance=strNEWPerformance & "<td width='10%' align='center' valign='top'><input name='nPerformanceTime' size='6' value='" & strNEWTime & "'><br><font face='Arial' size='1'>(eg 7:30PM)</font></td>"
			strNEWPerformance=strNEWPerformance & "<td width='25%' align='left'><b><font face='Arial' size='1'><input type='radio' name='NEWOpenClose' value='0'>Open<br><input type='radio' name='NEWOpenClose' value='1' checked>Closed On-Line<br><input type='radio' name='NEWOpenClose' value='2'>Sold Out</font></b></td>"
			strNEWPerformance=strNEWPerformance & "<td width='55%' align='left' valign='top'>"
			strNEWPerformance=strNEWPerformance & "<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber10'>"
			strNEWPerformance=strNEWPerformance & "<tr>"
			strNEWPerformance=strNEWPerformance & "<td colspan='3' width='100%'><select name='sSeatCategory'>" & strSeatLocation & "</select><select name='sSeatingCategory'>" & strSeatingCategory & "</select></td>"'<br>Inventory:" & TicketInventory & "</td>"
			strNEWPerformance=strNEWPerformance & "</tr>"
			strNEWPerformance=strNEWPerformance & strPrices
			strNEWPerformance=strNEWPerformance & "<tr>"
			strNEWPerformance=strNEWPerformance & "<td width='5%' align='right'></font><input type='button' value='+' onclick='javascript:NewPrice(" & numPrices & ");' id='button'1 name='button'1></td>"
			strNEWPerformance=strNEWPerformance & "<td width='50%' align='right'><select name='sPriceCategoryNEW'>" & strPriceCategory & "</select></td>"
			strNEWPerformance=strNEWPerformance & "<td width='45%' align='left' valign='top'><input name='iTicketPriceNEW' size='6'><font face='Arial' size='1'>(eg 15.00)</td>"
			strNEWPerformance=strNEWPerformance & "</tr>"
			strNEWPerformance=strNEWPerformance & "</table>"
					
			strNEWPerformance=strNEWPerformance & "</td>"
			strNEWPerformance=strNEWPerformance & "</tr>"

			strNEWPerformance=strNEWPerformance & "<tr>"
			strNEWPerformance=strNEWPerformance & "<td width='100%' colspan='4' align='center'><a href='javascript:fAddDate(" & numPrices & ");' onMouseOut='MM_swapImgRestore()' onMouseOver=""MM_swapImage('Image0','','../images/AddDateON.gif',1)""><img name='Image0' border='0' src='../images/AddDate.gif'></a></td>"
			strNEWPerformance=strNEWPerformance & "</tr>"
			strNEWPerformance=strNEWPerformance & "</table>"
			strNEWPerformance=strNEWPerformance & "</td>"
			strNEWPerformance=strNEWPerformance & "</tr>"		
		end if
	'
	'''''''''''''''''''''''''''
	end if  ''''''''''A
''else
''	'There are no shows to edit
''	strShows="<select name='SelectShows' onchange='javascript:SelectShow(" & numShows+1 & ");'><option value='0' selected>Add New</option>" & strShows & "</select>"
''	session("ShowID")=0
''end if
''POPULATE SHOW SELECTION
do until rsShows.eof
	numShows=numShows+1
	if rsShows("ShowID")=cint(ShowID) then
		strShows=strShows & "<option value='" & rsShows("ShowID") & "' selected>" & rsShows("Show") & "</option>"
	else
		strShows=strShows & "<option value='" & rsShows("ShowID") & "'>" & rsShows("Show") & "</option>"
	end if
	rsShows.movenext
loop
if ShowID=-1 then
	strShows="<select name='SelectShows' onchange='javascript:SelectShow(" & numShows+2 & ");'><option value='-1' selected>---SELECT---</option><option value='0'>Add New</option>" & strShows & "</select>"
'elseif showID=0 then
else
	strShows="<select name='SelectShows' onchange='javascript:SelectShow(" & numShows+1 & ");'><option value='0' selected>Add New</option>" & strShows & "</select>"
end if
'Put up Theaters
set rsTheaters=getrecordset("Select THEATERS.TheaterID,TheaterName from THEATERS,ACCOUNT_THEATERS where THEATERS.TheaterID=ACCOUNT_THEATERS.TheaterID and AccountID=" & AccountID)
strTheaters="<select name='SelectTheater'>" & strTheaters 
do until rsTheaters.eof
   if rsTheaters("TheaterID")=TheaterID then
   	strTheaters=strTheaters & "<option value='" & rsTheaters("TheaterID") & "' selected>" & rsTheaters("TheaterName") & "</option>"
   else
   	strTheaters=strTheaters & "<option value='" & rsTheaters("TheaterID") & "'>" & rsTheaters("TheaterName") & "</option>"
   end if
   rsTheaters.Movenext
loop
strTheaters=strTheaters & "</select>"
''''''''''''''''''''''''''''''''''''

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

function SelectShow(n){
var show,i,selected
selected=false
for (i=0;i<n;i++) {
      if (document.fSelectShow.SelectShows[i].selected) 
           {show = document.fSelectShow.SelectShows[i].value;
			selected=true;} 
				   }
if (selected&&show>=0)
			{document.location='EventSetup.asp?ShowID='+show;} 
else if (selected&&number(show)<0) 
			{
			alert("Please select a Show");}
}



function AddAPerformance(ShowDate,ShowTime){
if (document.fUpdateShow.PDateNew.value==''||document.fUpdateShow.PTimeNew.value=='')
{alert("Please enter both date and time of performance");}
else
{document.location='EventSetup.asp?AddNewPerformance=1&ShowDate='+document.fUpdateShow.PDateNew.value+'&ShowTime='+document.fUpdateShow.PTimeNew.value;}
}

function ConfigureTheater(){
document.location='ConfigureTheaterSeating.asp';
}

function UpdateSave(n)
{
	if (n==1)
		document.fUpdateShow.sSeatLocation
	document.fUpdateShow.submit();
}

function DeleteCategory(i,j,k,p)
{
 document.location="EventSetUp.asp?SeatCatID="+i+"&SeatingCatID="+j+"&PriceCatID="+k+"&Price="+p;	

}

function UpdatePerformances(tpc,i,j,k,p)
{
 document.fPrices.SCID.value=i;
 document.fPrices.SingCID.value=j;
 document.fPrices.PCID.value=k;
 document.fPrices.TP.value=p;
 document.fPrices.TPC.value=tpc;
 document.fPrices.submit();	

}

function AddPricing()
{
	if (document.fPrices.sSeatLocation[document.fPrices.sSeatLocation.selectedIndex].value==0)
		{alert("Select Seating Location");
		 return;}
	if (document.fPrices.sSeatCategory[document.fPrices.sSeatCategory.selectedIndex].value==0)
		{alert("Select Seating Category");
		 return;}
	if (document.fPrices.sPriceCategory[document.fPrices.sPriceCategory.selectedIndex].value==0)
		{alert("Select Price Category");
		 return;}
	if (document.fPrices.TicketPrice.value=='')
		{alert("Enter Ticket Price");
		 return;}
	document.fPrices.submit();	 
}

function BackToAdmin(){
document.location='AccountAdmin.asp';
}

function NewPrice(n)
{
	//Test first
	document.fNewDate.AddDate.value=0;
	document.fNewDate.NewPrices.value=n;
	
	document.fNewDate.submit();
}

function fAddDate(n)
{
	if (document.fNewDate.nPerformanceDate.value==""||isNaN(Date.parse(document.fNewDate.nPerformanceDate.value))==true)
		{alert("Please enter the DATE");
		 return;
		}
	else if (document.fNewDate.nPerformanceTime.value=="")
		{alert("Please enter the Time");
		 return;
		}
	else if (document.fNewDate.sSeatingCategory[document.fNewDate.sSeatingCategory.selectedIndex].value==0)
		{alert("Please enter Ticket Category");
		 return;
		}
	//else if (document.fNewDate.TicketInventory.value=="")
	//	{alert("Please enter Ticket Inventory");
	//	 return;
	//	}
	else if (document.fNewDate.sPriceCategoryNEW[document.fNewDate.sPriceCategoryNEW.selectedIndex].value==0)
		{alert("Please enter Ticket Price Category");
		 return;
		}
	else if (document.fNewDate.iTicketPriceNEW.value=="")
		{alert("Please enter Ticket Price");
		 return;
		}
	else
	{
		document.fNewDate.AddDate.value=1;
		document.fNewDate.NewPrices.value=n;
		document.fNewDate.submit();
	}
}

function SaveUpdateEvent(n)
{
	//Validate data
	if (document.fNewDate.ShowName.value=="")
		{alert("Please enter the Event name");
		 return;}
    else if (document.fNewDate.StartDate.value==""||isNaN(Date.parse(document.fNewDate.StartDate.value))==true)
		{alert("Please enter the Event Start Date");
		 return;}

    else if (document.fNewDate.EndDate.value==""||isNaN(Date.parse(document.fNewDate.EndDate.value))==true)
		{alert("Please enter the Event End Date");
		 return;}
	else
		{document.fNewDate.AddDate.value=2;
		 document.fNewDate.NewPrices.value=n;
	     document.fNewDate.submit();}
}

function fEditDelete(n)
{
	document.fNewDate.AddDate.value=3;
	document.fNewDate.EditPerf.value=n;
	//alert(document.fNewDate.AddDate.value);
	//document.location="EventSetUP.asp?UpdatePerformance="+n;
	document.fNewDate.submit();
}

function fUpdatePerformance(p,n)
{
	document.fNewDate.NewPrices.value=n;
	document.fNewDate.AddDate.value=4;
	document.fNewDate.EditPerf.value=p;
	//document.location="EventSetUP.asp?UpdatePerformance="+p;
	document.fNewDate.submit();
	
}

function CancelUpdate()
{
	document.location="EventSetUP.asp?";
}

function fDeletePerformance(p)
{
	document.fNewDate.AddDate.value=5;
	document.fNewDate.EditPerf.value=p;
	document.fNewDate.submit();
}

function EditInventory(p)
 {
	//document.location="TheaterSeating.asp?PerformanceID="+p; 
	window.open("TheaterSeating.asp?PerformanceID="+p,"ConfigureTheater","width=600,height=600,resizable=yes"); 
 }
//-->
</script>

</head>

<body onLoad="MM_preloadImages('../images/EditDeleteON.gif','../images/AddDateON.gif','../images/BackToAdminON.gif','../images/UpdateSaveON.gif','../images/UpdateON.gif','../images/CancelON.gif','../images/DeleteON.gif','../images/ModifyON.gif')">


<div align="center">
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1" height="91%">
    <tr>
      <td height="91%" align="center" width="100%">
        <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="700" id="AutoNumber2" align="center" height="347">
          <tr>
            <td height="347">
              <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3" height="346">
                <tr>
                  <td width="100%" height="345">
                    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
                     <tr>
                       <td width="5%">&nbsp;</td>
                       <td width="95%"><img border="0" src="../images/<%=AccountLogo%>"></td>
                     </tr>
                    <tr>
                      <td width="5%" bgcolor="#CCCCCC">&nbsp;</td>
                      <td width="95%" bgcolor="#CCCCCC"><p align="center"><b><font face="Arial">EVENT ADMINISTRATION</font></b></td>
                    </tr>
                    <tr>
                      <td width="5%">&nbsp;</td>
                      <td width="95%">
                         <table border="0" cellspacing="0" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="691" cellpadding="0" id="AutoNumber2">
                           <tr>
                             <form name="fSelectShow">
                            <td width="121" align="right"><b><font face="Arial" size="2">Event: </font></b> </td>
                            <td width="570"><%=strShows%></td>
                             </form>
                           </tr>
                           <%if ShowID >= 0 then%> 
                            <!--<form name="fUpdateShow" method="post" action="EventSetUp.asp">-->

                           <tr>
                             <td width="121" align="right">&nbsp;</td>
                             <td width="570">
                                <table border="0" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
                                  <tr>
                                     <td width="49%"></td>
                                     <td width="24%" align="middle"><b><font face="Arial" size="2">Begin Date</font></b></td>
                                     <td width="27%" align="middle"><b><font face="Arial" size="2">End Date</font></b></td>
                                 </tr>
                               </table>
                             </td>
                           </tr>
                           <tr>
                             <td width="121" align="right">&nbsp;</td>
                             <td width="570">
                                 <table border="0" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
									<tr>
									   <td width="49%"></td>
									   <td width="24%" align="middle"><font face="Arial" size="2">(e.g. 1/25/2003)</font></td>
									   <td width="27%" align="middle"><font face="Arial" size="2">(e.g. 2/5/2003)</font></td>
									</tr>
								 </table>
                              </td>
                            </tr>
                            <tr>
                            <form name="fNewDate" method="post" action="EventSetUP.asp">
									<input type="hidden" name="AddDate" value="-1">
									<input type="hidden" name="NewPrices" value="0">
									<input type="hidden" name="EditPerf" value="0">
                              <td width="121" align="right"><b><font face="Arial" size="2">Event Name:</font></b></td>
                              <td width="570">
                                  <table border="1" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="105%" id="AutoNumber4">
                                    <tr>
                                      <td width="47%"><font face="Arial"><input name="ShowName" size="39" value="<%=strShowName%>"></font></td>
                                      <td width="23%"><font face="Arial"><input name="StartDate" value="<%=strShowStartDate%>" size="17"></font></td>
                                      <td width="36%"><font face="Arial"><input name="EndDate" value="<%=strShowEndDate%>" size="20"></font></td>
                                    </tr>
                                  </table>
                              </td>
                            </tr>
                            <tr>
                            <td width="121" align="left"><b>
                            <font face="Arial" size="2">Event Summary:</font></b></td>
                            <td width="570" align="left">
                            <font face="Arial" size="2">
                            <textarea rows="3" cols="68" name="ShowSummary"><%=strShowSummary%></textarea>
                            </font>
                            </td>
                           </tr>
 
                            <tr>
                              <td width="121" align="right" valign="top"><b><font face="Arial" size="2">Service Charge:</font></b></td>
                              <td width="570">
                                  <table border="1" cellspacing="1" style="BORDER-COLLAPSE: collapse" bordercolor="#111111" width="100%" id="AutoNumber7">
                                     <tr>
                                       <td width="100%" align="left"><input name="ServiceCharge" value="<%=formatnumber(ServiceCharge,3)%>" size="20"><font size="2"></font><input type="radio" name="SCType" value="0" <%if ServiceChargeType=0 then%>checked<%end if%>><font size="2">% of Price&nbsp;</font><input type="radio" name="SCType" value="1" <%if ServiceChargeType<>0 then%>checked<%end if%>><font size="2">Charge per ticket<br> (e.g. .07 for 7%, .75 for $.75)</font></font></td>
                                     </tr>
                                  </table>
                              </td>
                            </tr>       
                            <tr>
                              <td width="121" align="right"><b>
                              <font face="Arial" size="2">Status:</font></b></td>
                              <td width="570" border="1">
								<font face="Arial" size="2">
								<input type="radio" name="rOnLine" value="1" <%=cShowOpen(1)%>>Available On-Line 
								&nbsp;&nbsp;
								<input type="radio" name="rOnLine" value="0" <%=cShowOpen(2)%>>Not Available On-Line</font>
							</td>
                            </tr>
                            <tr>
                              <td width="121" align="right">
								<b><font face="Arial" size="2">Remove On-Line:</font></b>
                              </td>
                              <td width="570">
								<font face="Arial" size="2">
									<input name="iRemoveHours" size="20" value="<%=ShowHoldHours%>">&nbsp;Hours before event
								</font>
							</td>
                            </tr>
                            <tr>
                              <td width="121" align="right"><b><font face="Arial" size="2">Venue:</font></b></td>
                              <td width="570"><%=strTheaters%></td>
                            </tr>
                            <%if ShowID>0 then%>
                            <tr>
                              <td width="121" align="right" valign="top"><b>
                              <font face="Arial" size="2">Dates:</font></b></td>
                              <td width="570">
			                     <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber8">
			                        <%=strPerformance%>

			                        <%=strNEWPerformance%>
									</form>
                                 
                                </table>
                              </td>
                            </tr>
                            <%end if%>
							<%if AddNew then%>
                              <tr>
                             <td width="121">
                             
                             </td>
                             <td width="570">
                             <p align="center">
                             <!--<a href="javascript:SaveUpdateEvent(<=numPrices>);">SAVE/UPDATE EVENT</a>-->
 							 <a href="javascript:SaveUpdateEvent(<%=numPrices%>);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ImageU','','../images/UpdateSaveON.gif',1)"><img name="ImageU" border="0" src="../images/UpdateSave.gif" WIDTH="200" HEIGHT="32"></a>
                            </td>
                            </tr>
                            <%end if%>
                            <%end if%>
                              <tr>
                             <td width="121">
                             
                             </td>
                             <td width="570" align="center">
								<a href="administration.asp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ImageB','','../images/BackToAdminON.gif',1)"><img name="ImageB" border="0" src="../images/BackToAdmin.gif" WIDTH="250" HEIGHT="32"></a>
                             </td>
                            </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
           </tr>
        </table>
</div>

</body>

</html>