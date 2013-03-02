<%@ Language=VBScript %>
<%Option Explicit%>

<% 
dim strSQL
Dim m_oConnection
Dim oCommand 
dim oRS
''''Show Information
dim ShowID,strShowName,strShowNote,strShowLogo,strShowStartDate,strShowEndDate,strShowSummary,ShowOnLine
dim ShowHoldHours
dim ServiceCharge,ServiceChargeType
dim SpecialServiceCharge,SpecialServiceChargeType	

''''Account Information
dim AccountID,AccountName,AccountReturnURL,AccountLogo,Role,AccountReferenceMessage
dim ManagementAccountID,ManagementAccountUserID
''''Pricing Information
dim maxPrice,minPrice
'''Theater Information
dim TheaterID,TheaterName,TheaterAddress,TheaterCity,TheaterState,TheaterZip,TheaterLabelType,TheaterMapQuest,TheaterPhone
'''Performance Information
dim PerformanceID,strPerformanceDate, strPerformanceTime,PerformanceStatus
dim SeatingType, totalSeatsAvailable, SeatsLeft, SeatsTaken,TicketInventory
dim TicketRevenue
''Purchaser information
dim strFname,strLName,strAddress,strCity,strState,strZip,strCountry,strPhone,strEMail
dim strEMailMessage,strRegEmail
dim PersonID
'''Seats
dim Seats(),Price()
dim totalAmountDue
dim totalAmountPaid
dim PaymentFor
dim PaymentType
dim totalSeats
dim totalTickets
dim totalTicketCost
dim ContiguousSeats()
dim ReserveTime
'Connection
dim connection_string
'connection_string="DRIVER={SQL Server};SERVER=209.204.62.15;DATABASE=EZT;UID=EZTicketing;PWD=ezt0023"
'connection_string="DRIVER={SQL Server};SERVER=207.171.1.66;DATABASE=EZT;UID=EZTicketing;PWD=ezt0023"
''connection_string="DRIVER={SQL Server};SERVER=129.47.1.162;DATABASE=EZT;UID=EZTicketing;PWD=ezt0023"
connection_string="DRIVER={SQL Server};SERVER=207.171.1.162;DATABASE=EZT;UID=EZTicketing;PWD=ezt0023"
''' General Information
dim DayOfWeek(7)
dim isTTO
DayOfWeek(1)="Sunday"
DayOfWeek(2)="Monday"
DayOfWeek(3)="Tuesday"
DayOfWeek(4)="Wednesday"
DayOfWeek(5)="Thursday"
DayOfWeek(6)="Friday"
DayOfWeek(7)="Saturday"
''''''''''''''''''''''''''''''''''
sub ClearAllInfo()
	session("ShowID")=empty
	session("AccountID")=empty
end sub
''''''''DATA BASE '''''''''''''''''
function GetRecordSet(strSQL)
	on error resume next
	Dim m_oConnection
	Dim oCommand 
	dim oRS
	'if TestInput(strSQL) then
	'    Response.Redirect "ErrorPage.asp"
	'	exit function
	'else
		on error resume next
			'// Create Recordset
		set oRS = Server.CreateObject("ADODB.Recordset")
		'// Open recordset
		Set m_oConnection = Server.CreateObject("ADODB.Connection")
		m_oConnection.ConnectionString = connection_string
		m_oConnection.CommandTimeout=100000
		m_oConnection.ConnectionTimeout=100000
		m_oConnection.Open
		Set oCommand = Server.CreateObject("ADODB.Command")
		oCommand.ActiveConnection = m_oConnection
		'// Get RecordSet
		oCommand.CommandText = strSQL
		Set oRS = oCommand.Execute()
		if err.number <> 0 then
			GenerateErrorMessage
			exit function
		end if
		set GetRecordSet=oRS
		'm_oConnection.close
		set m_oConnection=nothing
		set oCommand=nothing
		set oRS=nothing
	'end if
end function

function GetDBItem(strSQL)
	on error resume next
	Dim m_oConnection
	Dim oCommand 
	dim oRS
	if TestInput(strSQL) then
	    'insertRecord=-1
	    Response.Redirect "ErrorPage.asp"
		exit function
	else

		on error resume next
			'// Create Recordset
		set oRS = Server.CreateObject("ADODB.Recordset")
		'// Open recordset
		Set m_oConnection = Server.CreateObject("ADODB.Connection")
		m_oConnection.ConnectionString = connection_string
		m_oConnection.CommandTimeout=100000
		m_oConnection.ConnectionTimeout=100000
		m_oConnection.Open
		Set oCommand = Server.CreateObject("ADODB.Command")
		oCommand.ActiveConnection = m_oConnection
		'// Get RecordSet
		oCommand.CommandText = strSQL
		Set oRS = oCommand.Execute()
		if err.number <> 0 then
			GenerateErrorMessage
			exit function
		end if
		GetDBItem=oRS(0)
		'm_oConnection.close
		set m_oConnection=nothing
		set oCommand=nothing
		set oRS=nothing
	end if
end function

function oldInsertRecord(strSQL,InsertTable,NewID)
	Dim m_oConnection
	Dim oCommand 
	dim oRS
	on error resume next
	set oRS = Server.CreateObject("ADODB.Recordset")
	Set m_oConnection = Server.CreateObject("ADODB.Connection")
	m_oConnection.ConnectionString = connection_string
	m_oConnection.CommandTimeout=100000
	m_oConnection.ConnectionTimeout=100000
	m_oConnection.Open
	'Set oCommand = Server.CreateObject("ADODB.Command")
	'oCommand.ActiveConnection = m_oConnection
	'oCommand.CommandText = strSQL & " SELECT @@IDENTITY AS 'Identity'"
	'Set oRS = oCommand.Execute()
	Set oRS = m_oConnection.Execute("SET NOCOUNT ON;" & strSQL & ";SELECT @@IDENTITY AS 'NewID';")
	if err.number > 0 then
		GenerateErrorMessage
		exit function
	end if
	InsertRecord =oRS.Fields("NewID").value
	'oCommand.CommandText = "select max(" & newID & ") as NewID from " & insertTable
	'Set oRS = oCommand.Execute()	
	'InsertRecord=oRS(0)
	m_oConnection.Close
	set m_oConnection=nothing
	'set oCommand=nothing
	set oRS=nothing
end function

function InsertRecord(strSQL,InsertTable,NewID)
	Dim m_oConnection
	Dim oCommand 
	dim oRS
	if TestInput(strSQL) then
	    insertRecord=-1
	    Response.Redirect "ErrorPage.asp"
		exit function
	else
		on error resume next
		set oRS = Server.CreateObject("ADODB.Recordset")
		Set m_oConnection = Server.CreateObject("ADODB.Connection")
		m_oConnection.ConnectionString = connection_string
		m_oConnection.CommandTimeout=100000
		m_oConnection.ConnectionTimeout=100000
		m_oConnection.Open
		'Set oCommand = Server.CreateObject("ADODB.Command")
		'oCommand.ActiveConnection = m_oConnection
		'oCommand.CommandText = strSQL & " SELECT @@IDENTITY AS 'Identity'"
		'Set oRS = oCommand.Execute()
		'''''''''''''''''''''''''''''''
		Set oRS = m_oConnection.Execute("SET NOCOUNT ON;" & strSQL & ";SELECT @@IDENTITY AS 'NewID';")
		if err.number > 0 then
			GenerateErrorMessage
			exit function
		end if
		InsertRecord =oRS.Fields("NewID").value
		'oCommand.CommandText = "select max(" & newID & ") as NewID from " & insertTable
		'Set oRS = oCommand.Execute()	
		'InsertRecord=oRS(0)
		m_oConnection.Close
		set m_oConnection=nothing
		'set oCommand=nothing
		set oRS=nothing
	end if
end function

function UpdateRecord(strSQL)
	Dim m_oConnection
	Dim oCommand 
	dim oRS
		if TestInput(strSQL) then
	    'insertRecord=-1
	    Response.Redirect "ErrorPage.asp"
		exit function
	else
		on error resume next
		set oRS = Server.CreateObject("ADODB.Recordset")
		Set m_oConnection = Server.CreateObject("ADODB.Connection")
		m_oConnection.ConnectionString = connection_string
		m_oConnection.Open
		Set oCommand = Server.CreateObject("ADODB.Command")
		oCommand.ActiveConnection = m_oConnection
		oCommand.CommandText = strSQL
		Set oRS = oCommand.Execute()
		if err.number > 0 then
			GenerateErrorMessage
			exit function
		end if
		set m_oConnection=nothing
		set oCommand=nothing
		set oRS=nothing
	end if
end function

sub GenerateErrorMessage()
	Response.Redirect ErrorPage.asp
end sub

sub DeleteRecord(strSQL)
	Dim m_oConnection
	Dim oCommand 
	dim oRS
	on error resume next
	set oRS = Server.CreateObject("ADODB.Recordset")
	Set m_oConnection = Server.CreateObject("ADODB.Connection")
	m_oConnection.ConnectionString = connection_string
	m_oConnection.Open
	Set oCommand = Server.CreateObject("ADODB.Command")
	oCommand.ActiveConnection = m_oConnection
	oCommand.CommandText = strSQL
	Set oRS = oCommand.Execute()
	if err.number > 0 then
		GenerateErrorMessage
		exit sub
	end if
	set m_oConnection=nothing
	set oCommand=nothing
	set oRS=nothing
end sub

function getFromRecord(strSQL)
dim oRSGet
set oRsGet=GetRecordSet(strSQL)
if oRsGet.eof then
	getFromRecord=""
else
	getFromRecord=oRsGet(0)
end if
set oRsGet=nothing
end function


'''''''''''''''''''''''''''''''''''''''''''

'''''TICKET PRICE INFORMATION''''''''''''''''''

function GetSeatCategory(SeatCategoryID)
	strSQL="Select SeatCategory from SEAT_CATEGORY where SeatCategoryID=" & SeatCategoryID
	set oRs=getrecordset(strSQL)
	GetSeatCategory=oRs("SeatCategory")	
	set oRs=nothing
end function

function GetSeatingCategory(SeatingCategoryID)
	strSQL="Select SeatingCategory from SEATING_CATEGORY where SeatingCategoryID=" & SeatingCategoryID
	set oRs=getrecordset(strSQL)
	GetSeatingCategory=oRs("SeatingCategory")	
	set oRs=nothing
end function

function GetPriceCategory(PriceCategoryID)
	strSQL="Select PriceCategory from PRICE_CATEGORY where PriceCategoryID=" & PriceCategoryID
	set oRs=getrecordset(strSQL)
	GetPriceCategory=oRs("PriceCategory")	
	set oRs=nothing
end function

function GetSeatPriceFromSeatNumber(SeatNumber,PerformanceID,PriceCategoryID)
	strSQL="Select TicketPrice"
	'strSQL=strSQL & " from THEATER_SEATING,THEATER_PERFORMANCE_SEAT_CATEGORY,PERFORMANCE_TICKET_PRICE"
	strSQL=strSQL & " from THEATER_SEATING,THEATER__SEAT_CATEGORY,PERFORMANCE_TICKET_PRICE"
	'strSQL=strSQL & " where THEATER_SEATING.Area=THEATER_PERFORMANCE_SEAT_CATEGORY.Area"
	strSQL=strSQL & " where THEATER_SEATING.Area=THEATER_SEAT_CATEGORY.Area"
	'strSQL=strSQL & " and THEATER_SEATING.TSection=THEATER_PERFORMANCE_SEAT_CATEGORY.TSection"
	strSQL=strSQL & " and THEATER_SEATING.TSection=THEATER_SEAT_CATEGORY.TSection"
	'strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=PERFORMANCE_TICKET_PRICE.SeatCategoryID"
	strSQL=strSQL & " and THEATER_SEAT_CATEGORY.SeatCategoryID=PERFORMANCE_TICKET_PRICE.SeatCategoryID"
	strSQL=strSQL & " and THEATER_SEATING.SeatNumber = '" & SeatNumber & "'" 
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID = " & PriceCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		GetSeatPriceFromSeat=oRs("TicketPrice")	
	else
		GetSeatPriceFromSeat=-1
	end if
    set oRS=nothing
end function

function GetSeatPriceFromSeatCategoryIDPriceCategory(PerformanceID,SeatCategoryID,PriceCategoryID)
	strSQL="Select TicketPrice"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatCategoryID = " & SeatCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID = " & PriceCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		GetSeatPriceFromSeatCategoryID=oRs("TicketPrice")	
	else
		GetSeatPriceFromSeatCategoryID=-1
	end if
	set oRs=nothing
end function

function GetSeatPriceFromSeatCategoryID(PerformanceID,SeatingCategoryID,SeatCategoryID)
	strSQL="Select PRICE_CATEGORY.PriceCategoryID,PriceCategory,TicketPrice"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE,PRICE_CATEGORY"
	strSQL=strSQL & " where PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatCategoryID = " & SeatCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatingCategoryID = " & SeatingCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID
	set oRs=getrecordset(strSQL)
	set GetSeatPriceFromSeatCategoryID=oRs	
	set oRs=nothing
end function

function GetSeatPriceFromSeatingCategoryID(PerformanceID,SeatingCategoryID)
	strSQL="Select PRICE_CATEGORY.PriceCategoryID,PriceCategory,TicketPrice"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE,PRICE_CATEGORY"
	strSQL=strSQL & " where PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatingCategoryID = " & SeatingCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID
	set oRs=getrecordset(strSQL)
	set GetSeatPriceFromSeatingCategoryID=oRs	
	set oRs=nothing
end function

function GetSeatPricesFromPriceCategoryID(PerformanceID,PriceCategoryID)
	strSQL="Select TicketPrice"
	'strSQL=strSQL & " from THEATER_SEATING,THEATER_PERFORMANCE_SEAT_CATEGORY,PERFORMANCE_TICKET_PRICE"
	strSQL=strSQL & " from THEATER_SEATING,THEATER_SEAT_CATEGORY,PERFORMANCE_TICKET_PRICE"
	'strSQL=strSQL & " where THEATER_SEATING.Area=THEATER_PERFORMANCE_SEAT_CATEGORY.Area"
	strSQL=strSQL & " where THEATER_SEATING.Area=THEATER_SEAT_CATEGORY.Area"
	'strSQL=strSQL & " and THEATER_SEATING.TSection=THEATER_PERFORMANCE_SEAT_CATEGORY.TSection"
	strSQL=strSQL & " and THEATER_SEATING.TSection=THEATER_SEAT_CATEGORY.TSection"
	'strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=PERFORMANCE_TICKET_PRICE.SeatCategoryID"
	strSQL=strSQL & " and THEATER_SEAT_CATEGORY.SeatCategoryID=PERFORMANCE_TICKET_PRICE.SeatCategoryID"
	strSQL=strSQL & " and THEATER_SEATING.SeatNumber = '" & SeatNumber & "'" 
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID = " & PriceCategoryID
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID

	set oRs=getrecordset(strSQL)
	if oRrs.eof then
		GetSeatPriceFromSeatCategoryID=oRs("TicketPrice")	
	else
		GetSeatPriceFromSeatCategoryID=-1
	end if
	set oRs=nothing
end function

function GetSeatPricesForAPerformance(PerformanceID)
	strSQL="Select TicketPrice, PERFORMANCE_TICKET_PRICE.PriceCategoryID, PriceCategory"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE, PRICE_CATEGORY"
	strSQL=strSQL & " where PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID
	set oRs=getrecordset(strSQL)
	set GetSeatPricesForAPerformance= oRs
	set oRs=nothing
end function

function GetMinMaxPriceForShow(ShowID)
	strSQL="Select Min(TicketPrice) as MinCost, Max(TicketPrice) as MaxCost"
	strSQL=strSQL & " from SHOWS,PERFORMANCES,PERFORMANCE_TICKET_PRICE"
	strSQL=strSQL & " where SHOWS.ShowID=PERFORMANCES.ShowID"
	strSQL=strSQL & " and PERFORMANCES.PerformanceID=PERFORMANCE_TICKET_PRICE.PerformanceID"
	strSQL=strSQL & " and SHOWS.ShowID=" & ShowID

	set oRs=getrecordset(strSQL)
	'if not oRs.eof then
	if not isnull(oRs("MaxCost")) then
		maxPrice=oRs("MaxCost")
		if isnull(oRs("MinCost")) then
			minPrice=maxPrice
		else
			minPrice=oRs("MinCost")		
		end if
	else
		maxPrice=0.0
		minPrice=0.0
	end if	
	set oRs=nothing
end function

function getPricesForAPerformance(PerformanceID)
	set oRs=getrecordset("Select SeatCategory,TicketPrice from PERFORMANCE_TICKET_PRICE,PRICE_CATEGORY where PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID and PerformanceID=" & PerformanceID)
	set getPricesForAPerformance=oRs
	set oRs=nothing
end function

''''''''''''''''''''''''''''

''''SEATING INFORMATION''''''''''''''
sub GetTicketSummaryForPerformance(PerformanceID)
	dim oRsData
	GetShowInformationFromPerformance(PerformanceID)
	strSQL = "SELECT Count(SHOW_SEATING.SeatNumber) AS TicketCount, Sum(PERFORMANCE_TICKET_PRICE.TicketPrice) AS Revenue,SHOW_SEATING.PaymentID"
	strSQL =strSQL & " FROM PERFORMANCE_TICKET_PRICE,SHOW_SEATING"
	strSQL =strSQL & " WHERE PERFORMANCE_TICKET_PRICE.PerformanceID = SHOW_SEATING.PerformanceID and SHOW_SEATING.CostBasis = PERFORMANCE_TICKET_PRICE.PriceCategoryID AND SHOW_SEATING.PaymentID > 0 and SHOW_SEATING.PerformanceID=" & PerformanceID
	strSQL =strSQL & " Group By SHOW_SEATING.PaymentID"
	set oRsData=getrecordset(strSQL)
	TicketRevenue=0.00
	
	do until oRsData.eof
		SeatsTaken=SeatsTaken + oRsData("TicketCount")
		select case oRsData("PaymentID")
		case 1 'Credit Card
			'TicketRevenue=oRs("Revenue")
			GetServiceCharge  ShowID
			if ServiceChargeType=1 then
				TicketRevenue=TicketRevenue + oRsData("Revenue")+ oRsData("TicketCount")*ServiceCharge
			else
				TicketRevenue=TicketRevenue + oRsData("Revenue")*(1+ServiceCharge)
			end if
		case 2 'Cash/Check
			TicketRevenue=TicketRevenue + oRsData("Revenue")
		
		end select
		oRsData.movenext
	loop
	strSQL="Select count(SeatNumber) as TotalTickets from THEATER_SEATING,PERFORMANCES,SHOWS where PERFORMANCES.ShowID=SHOWS.ShowID and SHOWS.TheaterID=THEATER_SEATING.TheaterID and PERFORMANCES.PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	GetInventoryForPerformance PerformanceID 
	TotalSeatsAvailable=TicketInventory
	'strSQL="Select TicketInventory from PERFORMANCE_TICKETS_AVAILABLE where PerformanceID=" & PerformanceID
	'set oRs(strSQL)
	'TicketInventory=oRs("TicketInventory")
	set oRs=nothing
end sub

sub GetTicketSummaryForEvent(ShowID)
	dim oRsData
	dim TotalServiceCharge
	strSQL = "SELECT Count(SHOW_SEATING.SeatNumber) AS TicketCount, Sum(PERFORMANCE_TICKET_PRICE.TicketPrice) AS Revenue,SHOW_SEATING.PaymentID"
	strSQL =strSQL & " FROM PERFORMANCE_TICKET_PRICE,SHOW_SEATING"
	strSQL =strSQL & " WHERE PERFORMANCE_TICKET_PRICE.PerformanceID = SHOW_SEATING.PerformanceID and SHOW_SEATING.CostBasis = PERFORMANCE_TICKET_PRICE.PriceCategoryID AND SHOW_SEATING.PaymentID > 0 and SHOW_SEATING.ShowID=" & ShowID
	strSQL =strSQL & " Group By SHOW_SEATING.PaymentID"
	set oRsData=getrecordset(strSQL)
	TicketRevenue=0.00
	TotalServiceCharge=0.00
	do until oRsData.eof
		SeatsTaken=SeatsTaken + oRsData("TicketCount")
		select case oRsData("PaymentID")
		case 1 'Credit Card
			'TicketRevenue=oRs("Revenue")
			GetServiceCharge  ShowID
			if ServiceChargeType=1 then
				TotalServiceCharge=TotalServiceCharge + oRsData("TicketCount")*ServiceCharge
			else
				TotalServiceCharge=TotalServiceCharge + oRsData("Revenue")*ServiceCharge
			end if
			GetSpecialServiceCharge  ShowID
			if SpecialServiceChargeType=1 then
				TotalServiceCharge=TotalServiceCharge + oRsData("Revenue")+ oRsData("TicketCount")*SpecialServiceCharge
			else
				TotalServiceCharge=TotalServiceCharge + oRsData("Revenue")*SpecialServiceCharge
			end if
			TicketRevenue=TicketRevenue + oRsData("Revenue") + TotalServiceCharge
		case 2 'Cash/Check
			TicketRevenue=TicketRevenue + oRsData("Revenue")
		
		end select
		oRsData.movenext
	loop
	'strSQL="Select count(SeatNumber) as TotalTickets from THEATER_SEATING,SHOWS where SHOWS.TheaterID=THEATER_SEATING.TheaterID and SHOWS.ShowID=" & ShowID
	'set oRs=getrecordset(strSQL)
	'GetInventoryForPerformance PerformanceID 
	'TotalSeatsAvailable=TicketInventory
	'strSQL="Select TicketInventory from PERFORMANCE_TICKETS_AVAILABLE where PerformanceID=" & PerformanceID
	'set oRs(strSQL)
	'TicketInventory=oRs("TicketInventory")
	set oRs=nothing
end sub

sub GetTicketSummaryForEventDuringTimePeriod(ShowID,StartDate,EndDate)
	dim oRsData
	dim TotalServiceCharge
	strSQL = "SELECT Count(SHOW_SEATING.SeatNumber) AS TicketCount, Sum(PERFORMANCE_TICKET_PRICE.TicketPrice) AS Revenue,SHOW_SEATING.PaymentID"
	strSQL =strSQL & " FROM PERFORMANCE_TICKET_PRICE,SHOW_SEATING"
	strSQL =strSQL & " WHERE PERFORMANCE_TICKET_PRICE.PerformanceID = SHOW_SEATING.PerformanceID and SHOW_SEATING.CostBasis = PERFORMANCE_TICKET_PRICE.PriceCategoryID AND SHOW_SEATING.PaymentID > 0 and SHOW_SEATING.ShowID=" & ShowID
	strSQL =strSQL & " and ResearveTime BETWEEN '" & StartDate & "' and '" & dateadd("d",1,endDate) & "'"
	strSQL =strSQL & " Group By SHOW_SEATING.PaymentID"
	set oRsData=getrecordset(strSQL)
	TicketRevenue=0.00
	TotalServiceCharge=0.00
	do until oRsData.eof
		SeatsTaken=SeatsTaken + oRsData("TicketCount")
		select case oRsData("PaymentID")
		case 1 'Credit Card
			'TicketRevenue=oRs("Revenue")
			GetServiceCharge  ShowID
			if ServiceChargeType=1 then
				TotalServiceCharge=TotalServiceCharge + oRsData("TicketCount")*ServiceCharge
			else
				TotalServiceCharge=TotalServiceCharge + oRsData("Revenue")*ServiceCharge
			end if
			GetSpecialServiceCharge  ShowID
			if SpecialServiceChargeType=1 then
				TotalServiceCharge=TotalServiceCharge + oRsData("Revenue")+ oRsData("TicketCount")*SpecialServiceCharge
			else
				TotalServiceCharge=TotalServiceCharge + oRsData("Revenue")*SpecialServiceCharge
			end if
			TicketRevenue=TicketRevenue + oRsData("Revenue") + TotalServiceCharge
		case 2 'Cash/Check
			TicketRevenue=TicketRevenue + oRsData("Revenue")
		
		end select
		oRsData.movenext
	loop
	'strSQL="Select count(SeatNumber) as TotalTickets from THEATER_SEATING,SHOWS where SHOWS.TheaterID=THEATER_SEATING.TheaterID and SHOWS.ShowID=" & ShowID
	'set oRs=getrecordset(strSQL)
	'GetInventoryForPerformance PerformanceID 
	'TotalSeatsAvailable=TicketInventory
	'strSQL="Select TicketInventory from PERFORMANCE_TICKETS_AVAILABLE where PerformanceID=" & PerformanceID
	'set oRs(strSQL)
	'TicketInventory=oRs("TicketInventory")
	set oRs=nothing
end sub

function GetTicketInventoryForPerformanceAndCategory(PerformanceID,SeatCategory)
	strSQL="Select TicketInventory from PERFORMANCE_TICKETS_AVAILABLE where PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	TicketInventory=oRs("TicketInventory")
	GetTicketInventoryForPerformanceAndCategory=TicketInventory
	set oRs=nothing
end function
	
function GetSeatCategoriesForATheater(TheaterID)
	strSQL="Select distinct THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID, SeatCategory from THEATER_PERFORMANCE_SEAT_CATEGORY,SEAT_CATEGORY where THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID and TheaterID=" & TheaterID
	set oRs=getrecordset(strSQL)
	set GetSeatCategoriesForATheater=oRs
	set oRs=nothing
end function

function GetSeatingCategories()
	strSQL="Select SeatingCategoryID, SeatingCategory from SEATING_CATEGORY"
	set oRs=getrecordset(strSQL)
	set GetSeatingCategories=oRs
	set oRs=nothing
end function

function GetPricingCategories()
	'strSQL="Select PriceCategoryID, PriceCategory from PRICE_CATEGORY"
	strSQL="Select PRICE_CATEGORY.PriceCategoryID, PriceCategory from PRICE_CATEGORY,ACCOUNT_PRICE_CATEGORY where PRICE_CATEGORY.PriceCategoryID=ACCOUNT_PRICE_CATEGORY.PriceCategoryID and ACCOUNT_PRICE_CATEGORY.AccountID=" & AccountID
	set oRs=getrecordset(strSQL)
	set GetPricingCategories=oRs
	set oRs=nothing
end function

function GetSeatCategoriesForAPerformance(PerformanceID)
	'strSQL="Select THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID, SeatCategory from THEATER_PERFORMANCE_SEAT_CATEGORY,SEAT_CATEGORY where THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID and PerformanceID=" & PerformanceID
	strSQL="Select THEATER_SEAT_CATEGORY.SeatCategoryID, SeatCategory from THEATER_SEAT_CATEGORY,SEAT_CATEGORY where THEATER_SEAT_CATEGORY.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID and PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	set GetSeatCategoriesForAPerformance=oRs
	set oRs=nothing
end function

function GetAllSeatInformationForAShow(ShowID)
	'strSQL="Select distinct THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID, SeatCategory, THEATER_PERFORMANCE_SEAT_CATEGORY.SeatingCategoryID, SeatingCategory,THEATER_PERFORMANCE_SEAT_CATEGORY.PriceCategoryID, PriceCategory, TicketPrice"
	strSQL="Select distinct PERFORMANCE_TICKET_PRICE.SeatCategoryID,PERFORMANCE_TICKET_PRICE.SeatingCategoryID,PERFORMANCE_TICKET_PRICE.PriceCategoryID,SeatCategory, SeatingCategory, PriceCategory, TicketPrice"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE,SEAT_CATEGORY,SEATING_CATEGORY,PRICE_CATEGORY,PERFORMANCES"
	strSQL=strSQL & " where PERFORMANCE_TICKET_PRICE.PerformanceID=PERFORMANCES.PerformanceID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatingCategoryID=SEATING_CATEGORY.SeatingCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID"
	strSQL=strSQL & " and ShowID=" & ShowID
	set oRs=getrecordset(strSQL)
	set GetAllSeatInformationForAShow=oRs
	set oRs=nothing
end function
function GetAllSeatInformationForAPerformance(PerformanceID)
	'strSQL="Select distinct THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID, SeatCategory, THEATER_PERFORMANCE_SEAT_CATEGORY.SeatingCategoryID, SeatingCategory,THEATER_PERFORMANCE_SEAT_CATEGORY.PriceCategoryID, PriceCategory, TicketPrice"
	strSQL="Select distinct PERFORMANCE_TICKET_PRICE.SeatCategoryID,PERFORMANCE_TICKET_PRICE.SeatingCategoryID,PERFORMANCE_TICKET_PRICE.PriceCategoryID,SeatCategory, SeatingCategory, PriceCategory, TicketPrice"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE,SEAT_CATEGORY,SEATING_CATEGORY,PRICE_CATEGORY"
	strSQL=strSQL & " where PERFORMANCE_TICKET_PRICE.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.SeatingCategoryID=SEATING_CATEGORY.SeatingCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	set GetAllSeatInformationForAPerformance=oRs
	set oRs=nothing
end function

function GetAllSeatInformationIDsForAPerformance(PerformanceID)
	strSQL="Select distinct SeatCategoryID, SeatingCategoryID, PriceCategoryID"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE"
	strSQL=strSQL & " where PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	set GetAllSeatInformationIDsForAPerformance=oRs
	set oRs=nothing
end function

function getNumberOfPurchasedSeatsForAPerformance(PerformanceID)
	strSQL="Select count(SeatNumber) as TicketsSold from SHOW_SEATING where PaymentID>0 and PerformanceID=" & PerformanceID
		set oRs=getrecordset(strSQL)
	getNumberOfPurchasedSeatsForAPerformance=oRs("TicketsSold")
	set oRs=nothing
end function

function getSeatingTypeForPerformance(PerformanceID)	
	set oRs=getrecordset("Select SeatingCategoryID from PERFORMANCE_TICKET_PRICE where PerformanceID=" & PerformanceID)
	SeatingType=0
	do until oRs.eof
		if oRs("SeatingCategoryID")=1 and SeatingType=0 then
			SeatingType=1  'Reserved
		elseif oRs("SeatingCategoryID")=2 and SeatingType=0 then
			SeatingType=2	'Unreserved
		elseif oRs("SeatingCategoryID")=2 and (SeatingType=1 or SeatingType=3) then
			SeatingType=3	'Reserved AND Unreserved
		elseif oRs("SeatingCategoryID")=1 and (SeatingType=2 or SeatingType=3) then
			SeatingType=3	'Reserved AND Unreserved
		end if
	   oRs.movenext
	loop	
	getSeatingTypeForPerformance=SeatingType
	set oRs=nothing
end function

function getSeatCategoryForPerformanceAndSeat(PerformanceID,SeatNumber)	
	strSQL="Select THEATER_SEAT_CATEGORY.SeatCategoryID,SEAT_CATEGORY.SeatCategory"
	strSQL=strSQL & " from THEATER_SEAT_CATEGORY,THEATER_SEATING,SEAT_CATEGORY"
	strSQL=strSQL & " where THEATER_SEATING.Area=THEATER_PERFORMANCE_SEAT_CATEGORY.Area"
	strSQL=strSQL & " and THEATER_SEATING.TSection=THEATER_PERFORMANCE_SEAT_CATEGORY.TSection"
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID"
	strSQL=strSQL & " and THEATER_SEATING.SeatNumber = '" & SeatNumber & "'" 
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.PerformanceID = " & PerformanceID 
	set oRs=getrecordset(strSQL)
	set getSeatingTypeForPerformanceAndSeat=oRs
	set oRs=nothing
end function

function getSeatingCategoryForPerformanceAndLocation(PerformanceID,Area,Section)	
	strSQL="Select SEATING_CATEGORY.*"
	strSQL=strSQL & " from THEATER_PERFORMANCE_SEAT_CATEGORY,PERFORMANCE_TICKET_PRICE,SEATING_CATEGORY"
	strSQL=strSQL & " where THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=PERFORMANCE_TICKET_PRICE.SeatCategoryID"
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.PerformanceID=PERFORMANCE_TICKET_PRICE.PerformanceID"
	strSQL=strSQL & " and SEATING_CATEGORY.SeatingCategoryID=PERFORMANCE_TICKET_PRICE.SeatingCategoryID"
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.Area=" & Area
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.TSection=" & Section
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.PerformanceID = " & PerformanceID 
	set oRs=getrecordset(strSQL)
	set getSeatingCategoryForPerformanceAndLocation=oRs
	set oRs=nothing
end function

function getSeatingCategoryForPerformanceAndSeat(PerformanceID,TheaterID,Seat)	
	strSQL="Select PERFORMANCE_TICKET_PRICE.SeatCategoryID,PERFORMANCE_TICKET_PRICE.SeatingCategoryID"
	strSQL=strSQL & " from THEATER_PERFORMANCE_SEAT_CATEGORY,PERFORMANCE_TICKET_PRICE,THEATER_SEATING"
	strSQL=strSQL & " where THEATER_PERFORMANCE_SEAT_CATEGORY.SeatCategoryID=PERFORMANCE_TICKET_PRICE.SeatCategoryID"
	strSQL=strSQL & " and THEATER_PERFORMANCE_SEAT_CATEGORY.PerformanceID=PERFORMANCE_TICKET_PRICE.PerformanceID"
	strSQL=strSQL & " and THEATER_SEATING.Area=THEATER_PERFORMANCE_SEAT_CATEGORY.Area"
	strSQL=strSQL & " and THEATER_SEATING.TSection=THEATER_PERFORMANCE_SEAT_CATEGORY.Tsection"
	strSQL=strSQL & " and THEATER_SEATING.TheaterID=THEATER_PERFORMANCE_SEAT_CATEGORY.TheaterID"
	strSQL=strSQL & " and THEATER_SEATING.TheaterID=" & TheaterID
	strSQL=strSQL & " and THEATER_SEATING.SeatNumber='" & Seat & "'"
	strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PerformanceID = " & PerformanceID 
	set oRs=getrecordset(strSQL)
	set getSeatingCategoryForPerformanceAndSeat=oRs
	set oRs=nothing
end function

function getAllSeatingCategoriesForPerformance(PerformanceID)
	strSQL="Select distinct PERFORMANCE_TICKET_PRICE.SeatCategoryID,SEATING_CATEGORY.SeatingCategoryID,SeatingCategory,SeatingCategoryColor"
	strSQL=strSQL & " from PERFORMANCE_TICKET_PRICE,SEATING_CATEGORY"
	strSQL=strSQL & " where PERFORMANCE_TICKET_PRICE.SeatingCategoryID=SEATING_CATEGORY.SeatingCategoryID"
	strSQL=strSQL & " and PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	set getAllSeatingCategoriesForPerformance=oRs
	set oRs=nothing
end function

function getAllSeatCategoriesForPerformance(PerformanceID)	
	set oRs=getrecordset("Select SEAT_CATEGORY.SeatCategoryID,SeatCategory from PERFORMANCE_TICKET_PRICE,SEAT_CATEGORY where PERFORMANCE_TICKET_PRICE.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID and PerformanceID=" & PerformanceID)
	set getAllSeatCategoriesForPerformance=oRs
	set oRs=nothing
end function

function getPriceForASeatAndPerformance(PerformanceID,SeatNumber)
	strSQL="Select TicketPrice"
	strSQL=strSQL & " from SHOW_SEATING,PERFORMANCE_TICKET_PRICE"
	strSQL=strSQL & " where SHOW_SEATING.PerformanceID=PERFORMANCE_TICKET_PRICE.PerformanceID"
	strSQL=strSQL & " and SHOW_SEATING.CostBasis=PERFORMANCE_TICKET_PRICE.PriceCategoryID"
	strSQL=strSQL & " and SHOW_SEATING.PerformanceID=" & PerformanceID
	strSQL=strSQL & " and SHOW_SEATING.SeatNumber='" & SeatNumber & "'"
	set oRs=getrecordset(strSQL)
	getPriceForASeatAndPerformance=oRs("TicketPrice")
	set oRs=nothing
end function

function isSeasonTickets(PerformanceID)
	strSQL="Select distinct CostBasis"
	strSQL=strSQL & " from SHOW_SEATING"
	strSQL=strSQL & " where CostBasis=120 and PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		isSeasonTickets=false
	else
		isSeasonTickets=true
	end if
	set oRs=nothing


end function

function isHCTickets(PerformanceID)
	strSQL="Select distinct CostBasis"
	strSQL=strSQL & " from SHOW_SEATING"
	strSQL=strSQL & " where CostBasis=130 and PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		isHCTickets=false
	else
		isHCTickets=true
	end if
	set oRs=nothing


end function

''''''''''''''''''''''''

'''''SHOW/PERFORMANCE INFO
sub GetShowInformation(ShowID)
	set oRs=getrecordset("Select * from SHOWS where ShowID=" & showID)
	strShowLogo=oRs("ShowLogo")
	strShowName=oRs("Show")
	strShowSummary=oRs("ShowSummary") & oRs("ShowSummary2") & oRs("ShowSummary3")
	strShowStartDate=oRs("StartDate")
	strShowEndDate=oRs("EndDate")
	ShowOnLine=oRs("ShowOpen")
	ShowHoldHours=oRs("HoldHours")
	TheaterID=oRs("TheaterID")
	set oRs=nothing
end sub

sub GetShowInformationFromPerformance(PerformanceID)
	set oRs=getrecordset("Select SHOWS.* from PERFORMANCES,SHOWS where PERFORMANCES.ShowID=SHOWS.ShowID and PerformanceID=" & PerformanceID)
	strShowLogo=oRs("ShowLogo")
	strShowName=oRs("Show")
	strShowSummary=oRs("ShowSummary")
	strShowNote=oRs("ShowNote")
	strShowStartDate=oRs("StartDate")
	strShowEndDate=oRs("EndDate")
	ShowOnLine=oRs("ShowOpen")
	ShowHoldHours=oRs("HoldHours")
	TheaterID=oRs("TheaterID")
	ShowID=oRs("ShowID")
	set oRs=nothing
end sub

function GetAllPerformanceForShow(ShowID)
	set oRS=getrecordset("Select count(PerformanceID) as NoPerf from PERFORMANCES where ShowID = " & ShowID)
	if oRS("NoPerf") = 1 then
		set oRS=getrecordset("Select * from PERFORMANCES where ShowID = " & ShowID)
	else
		set oRS=getrecordset("Select * from PERFORMANCES where ShowID = " & ShowID & " order by CONVERT(smalldatetime,PERFORMANCES.ShowDate + PERFORMANCES.Showtime)")
	end if
	set GetAllPerformanceForShow=oRs
	set oRs=nothing
end function

sub GetPerformanceInformation(PerformanceID)
	set oRs=getrecordset("Select * from PERFORMANCES where PerformanceID=" & PerformanceID)
	strPerformanceDate=oRs("ShowDate")
	strPerformanceTime=oRs("ShowTime")
	PerformanceStatus=oRs("PerformanceOpen")
	ShowID=oRs("ShowID")
	set oRs=nothing
end sub

function GetAllEventsForAnAccount(AccountID)
	strSQL = "Select ShowID,Show,AccountName,StartDate,EndDate,TheaterName,TheaterCity,TheaterState,TheaterMapQuest"
	strSQL=strSQL & " from SHOWS,THEATERS,ACCOUNTS"
	strSQL=strSQL & " where SHOWS.AccountID=ACCOUNTS.AccountID" 
	strSQL=strSQL & " and SHOWS.TheaterID=THEATERS.TheaterID"
	strSQL=strSQL & " and ACCOUNTS.AccountID=" & AccountID
	strSQL=strSQL & " and EndDate >= '" & dateadd("d",-5,now()) & "'"
	'strSQL=strSQL & " and EndDate >= '" & dateadd("m",-5,now()) & "'"
	strSQL=strSQL & " order by StartDate"
	set oRs=getrecordset(strSQL)
	set GetAllEventsForAnAccount=oRs
	set oRs=nothing
end function

function GetEveryEventForAnAccount(AccountID)
	strSQL = "Select ShowID,Show,AccountName,StartDate,EndDate,TheaterName,TheaterCity,TheaterState,TheaterMapQuest"
	strSQL=strSQL & " from SHOWS,THEATERS,ACCOUNTS"
	strSQL=strSQL & " where SHOWS.AccountID=ACCOUNTS.AccountID" 
	strSQL=strSQL & " and SHOWS.TheaterID=THEATERS.TheaterID"
	strSQL=strSQL & " and ACCOUNTS.AccountID=" & AccountID
	'strSQL=strSQL & " and EndDate >= '" & now() & "'"
	strSQL=strSQL & " and EndDate >= '" & dateadd("m",-3,now()) & "'"
	strSQL=strSQL & " order by StartDate"
	set oRs=getrecordset(strSQL)
	set GetEveryEventForAnAccount=oRs
	set oRs=nothing
end function

function GetEveryEventForAnAccountForTimePeriod(AccountID,StartDate,EndDate)
	strSQL = "Select ShowID,Show,AccountName,StartDate,EndDate,TheaterName,TheaterCity,TheaterState,TheaterMapQuest"
	strSQL=strSQL & " from SHOWS,THEATERS,ACCOUNTS"
	strSQL=strSQL & " where SHOWS.AccountID=ACCOUNTS.AccountID" 
	strSQL=strSQL & " and SHOWS.TheaterID=THEATERS.TheaterID"
	strSQL=strSQL & " and ACCOUNTS.AccountID=" & AccountID
	strSQL=strSQL & " and EndDate >= '" & StartDate & "'"
	strSQL=strSQL & " and StartDate <= '" & EndDate & "'"
	strSQL=strSQL & " order by StartDate"
	set oRs=getrecordset(strSQL)
	set GetEveryEventForAnAccountForTimePeriod=oRs
	set oRs=nothing
end function

function GetAllCurrentOpenEventsForAllAccounts()
	strSQL = "Select ShowID,Show,AccountName,StartDate,EndDate,TheaterName,TheaterCity,TheaterState,TheaterMapQuest"
	strSQL=strSQL & " from SHOWS,THEATERS,ACCOUNTS"
	strSQL=strSQL & " where SHOWS.AccountID=ACCOUNTS.AccountID" 
	strSQL=strSQL & " and SHOWS.TheaterID=THEATERS.TheaterID"
	strSQL=strSQL & " and ShowOpen=1"
	strSQL=strSQL & " and EndDate >= '" & now() & "' order by StartDate"
	set oRs=getrecordset(strSQL)
	set GetAllCurrentOpenEventsForAllAccounts=oRs
	set oRs=nothing
end function

function GetAllCurrentOpenEventsForAnAccount(AccountID)
	strSQL = "Select ShowID,Show,AccountName,StartDate,EndDate,TheaterName,TheaterCity,TheaterState,TheaterMapQuest"
	strSQL=strSQL & " from SHOWS,THEATERS,ACCOUNTS"
	strSQL=strSQL & " where SHOWS.AccountID=ACCOUNTS.AccountID" 
	strSQL=strSQL & " and SHOWS.TheaterID=THEATERS.TheaterID"
	strSQL=strSQL & " and ACCOUNTS.AccountID=" & AccountID
	strSQL=strSQL & " and ShowOpen=1"
	strSQL=strSQL & " and EndDate >= '" & now() & "' order by StartDate"
	set oRs=getrecordset(strSQL)
	set GetAllCurrentOpenEventsForAnAccount=oRs
	set oRs=nothing
end function

function GetAllCurrentOpenEventsForManagementAccounts(ManagementID)
	strSQL = "Select ShowID,Show,AccountName,StartDate,EndDate,TheaterName,TheaterCity,TheaterState,TheaterMapQuest"
	strSQL=strSQL & " from SHOWS,THEATERS,ACCOUNTS,MANAGEMENT_ACCOUNT_ACCOUNTS"
	strSQL=strSQL & " where SHOWS.AccountID=ACCOUNTS.AccountID" 
	strSQL=strSQL & " and SHOWS.TheaterID=THEATERS.TheaterID"
	strSQL=strSQL & " and ACCOUNTS.AccountID=MANAGEMENT_ACCOUNT_ACCOUNTS.AccountID"
	strSQL=strSQL & " and MANAGEMENT_ACCOUNT_ACCOUNTS.ManagementAccountID=" & ManagementID
	strSQL=strSQL & " and ShowOpen=1"
	strSQL=strSQL & " and EndDate >= '" & now() & "' order by StartDate"
	set oRs=getrecordset(strSQL)
	set GetAllCurrentOpenEventsForManagementAccounts=oRs
	set oRs=nothing
end function
''''''''PROCESS SEATS'''''''''''''''''
sub GetInventoryForPerformance(PerformanceID)
	strSQL="Select count(SeatNumber) as TotalTheater from THEATER_SEATING,PERFORMANCES,SHOWS where seat > 0 and PERFORMANCES.ShowID=SHOWS.ShowID and SHOWS.TheaterID=THEATER_SEATING.TheaterID and PERFORMANCES.PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	TicketInventory=oRs("TotalTheater")
	strSQL="Select count(SeatNumber) as SetAside from SHOW_SEATING where CostBasis > 90 and PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	TicketInventory=TicketInventory - oRs("SetAside")
	set oRs=nothing
end sub

function GetSeatsAtTheater(TheaterID)
	strSQL="Select count(SeatNumber) as TotalTheater from THEATER_SEATING where seat > 0 and TheaterID=" & TheaterID
	set oRs=getrecordset(strSQL)
	GetSeatsAtTheater=oRs("TotalTheater")
	set oRs=nothing
end function

sub ReleaseSeats(ReservedFor)
	if not isempty(ReservedFor) then
		strSQL="Select distinct PerformanceID"
		strSQL=strSQL & " from SHOW_SEATING"
		strSQL=strSQL & " where PaymentID =-1 and ReservationForID=" & ReservedFor
		set oRs=getrecordset(strSQL)
		do until oRs.eof
			deleterecord "Delete from SHOW_SEATING where PaymentID =-1 and PerformanceID=" & oRs("PerformanceID") & " and ReservationForID=" & ReservedFor
			oRs.movenext
		loop
		session("SeatsSaved")=empty
		'updaterecord "Update SHOW_SEATING set PaymentID=-2,ReservationForID=-2 where CostBasis=8 and ReservationForID=" & ReservedFor
		set oRs=nothing
	end if
end sub

sub getSeatsLeftForUnreserved(PerformanceID)
	set oRs=getrecordset("SELECT TicketsAvailable,SeatCategory FROM PERFORMANCE_TICKETS_AVAILABLE,SEAT_CATEGORY where PERFORMANCE_TICKETS_AVAILABLE.SeatCategoryID=SEAT_CATEGORY.SeatCategoryID and PerformanceID=" & PerformanceID)
	if oRs.eof then
		totalSeatsAvailable=100
	else
		totalSeatsAvailable=oRs("SeatsAvailable")
	end if
	set oRs=getrecordset("SELECT count(SeatNumber) as numSeats FROM PERFORMANCE_SEATING where PerformanceID=" & PerformanceID)				
	SeatsTaken =oRs("numSeats")
	SeatsLeft=totalSeatsAvailable-SeatsTaken
end sub 

function GetAvailableSeatsForUnreserved(PerformanceID)
	strSQL="Select TicketsAvailable From PERFORMANCE_TICKETS_AVAILABLE where PerformanceID=" & PerformanceID
	set oRs= getrecordset(strSQL)
	GetAvailableSeatsForUnreserved=oRs(0)
	set oRs = nothing
end function

sub GetAvailableSeatsForPerformance(PerformanceID)
	strSQL="Select count(SeatNumber) as TotalTheater from THEATER_SEATING,PERFORMANCES,SHOWS where PERFORMANCES.ShowID=SHOWS.ShowID and SHOWS.TheaterID=THEATER_SEATING.TheaterID and seat > 0 and PERFORMANCES.PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	totalSeatsAvailable=oRs("TotalTheater")
	strSQL="Select count(SeatNumber) as SeatsNotAvailable from SHOW_SEATING where PerformanceID=" & PerformanceID
	set oRs=getrecordset(strSQL)
	totalSeatsAvailable=totalSeatsAvailable-oRs("SeatsNotAvailable")
	set oRs = nothing
end sub

function GetSeatForPerformanceOtherPending(Performance,PendingID,SeatNumber)
	strSQL="Select SeatNumber"
	strSQL=strSQL & " from SHOW_SEATING"
	strSQL=strSQL & " where PerformanceID=" & PerformanceID
	strSQL=strSQL & " and SeatNumber='" & SeatNumber
	strSQL=strSQL & "' and ReservationForID <>" & PendingID
	set oRs= getrecordset(strSQL)
	set GetSeatForPerformanceOtherPending=oRs
	set oRs = nothing
end function

sub SetPendingSeat(ShowID,PerformanceID,SeatNumber,ReservedFor)
	dim Seat
	strSQL="Insert into SHOW_SEATING (ShowID,PerformanceID,SeatNumber,ReservationForID,PaymentID,ResearveTime,CostBasis) values(" & ShowID & "," & PerformanceID & ",'" & SeatNumber & "'," & ReservedFor & ",-1,'" & now() & "',0)"
	Seat=insertrecord(strSQL,"SHOW_SEATING","ShowID")
end sub

sub SetPendingSeatForPerson(PerformanceID,SeatNumber,ReservedFor,CostBasis)
	dim Seat
	strSQL="Insert into PENDING_SHOW_SEATING (PerformanceID,SeatNumber,ReservationForID,ReserveTime,PriceCategoryID,Status) values(" & PerformanceID & ",'" & SeatNumber & "'," & ReservedFor & ",'" & now() & "'," & CostBasis & ",0)"
	Seat=insertrecord(strSQL,"PENDING_SHOW_SEATING","PerformanceID")
end sub

sub DeletePendingSeatForPerson(PerformanceID,SeatNumber,PersonID)
	strSQL="Delete From PENDING_SHOW_SEATING where Status= 0 and PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "' and ReservationForID=" & PersonID
	deleterecord strSQL
end sub

sub UpdatePendingSeatForPerson(PerformanceID,SeatNumber,PersonID,Status)
	strSQL="Update PENDING_SHOW_SEATING set Status= " & Status & " where Status=0 and PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "' and ReservationForID=" & PersonID
	deleterecord strSQL
end sub

function GetPendingSeatsWithoutCostBasis(PerformanceID,ReservedFor)
	strSQL="Select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & " and ReservationForID=" & ReservedFor & " and PaymentID=-1 and CostBasis=0"
	set oRs= getrecordset(strSQL)
	set GetPendingSeatsWithoutCostBasis=oRs
	set oRs = nothing
end function

function GetPendingSeats(PerformanceID,ReservedFor)
	strSQL="Select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & " and ReservationForID=" & ReservedFor & " and PaymentID=-1"
	set oRs= getrecordset(strSQL)
	set GetPendingSeats=oRs
	set oRs = nothing
end function

sub SetSeatCostBasis(PerformanceID,SeatNumber,CostBasis)
	strSQL="Update SHOW_SEATING set CostBasis=" & CostBasis & " where PerformanceID=" & PerformanceID & " and SeatNumber='" & SeatNumber & "'"
	updateRecord strSQL
end sub

sub setPersonIDAndPaymentForPendingTickets(PersonID,lSessionID,PaymentReceipt)
	strSQL="Update SHOW_SEATING set ReservationForID=" & PersonID & ",PaymentID=1,PaymentReceiptID=" & PaymentReceipt & " where  ReservationForID=" & lSessionID
	updateRecord strSQL
end sub 

sub SetUnreservedSeatCostBasis(ShowID,PerformanceID,TheaterID,numSeats,ReservedForID,CostBasis,StartSeat)
	dim ii
	dim Seat
	strSQL="select SeatNumber from THEATER_SEATING where TheaterID=" & TheaterID & " and SeatNumber NOT IN (Select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & ") order by row,seat"
	set oRs = getrecordset(strSQL)
	for ii = 1 to numSeats
	'do until oRs.eof
		strSQL="Insert into SHOW_SEATING (ShowID,PerformanceID,SeatNumber,ReservationForID,PaymentID,ResearveTime,CostBasis)"
		strSQL=strSql & " values(" & ShowID & "," & PerformanceID & ",'" & oRs("SeatNumber") & "'," & ReservedForID & ",-1,'" & now() & "'," & CostBasis & ")"
		Seat=insertrecord(strSQL,"SHOW_SEATING","ShowID")
		oRs.movenext
	next
	'loop
	'Update seats available
	strSQL="Update PERFORMANCE_TICKETS_AVAILABLE set TicketsAvailable=" & cstr(StartSeat-numSeats) & " where PerformanceID=" & PerformanceID
	updateRecord strSQL
	
end sub
sub SaveUnreservedSeats(ShowID,PerformanceID,TheaterID,numSeats,ReservedForID,CostBasis)
	dim ii
	dim Seat
	'get Unreserved seats
	strSQL="select SeatNumber from THEATER_SEATING where TheaterID=" & TheaterID & " and seat > 0 and SeatNumber NOT IN (Select SeatNumber from SHOW_SEATING where PerformanceID=" & PerformanceID & ") order by row,seat"
	set oRs = getrecordset(strSQL)
	'loop thru number of requested seats
	for ii = 1 to numSeats
		strSQL="Insert into SHOW_SEATING (ShowID,PerformanceID,SeatNumber,ReservationForID,PaymentID,ResearveTime,CostBasis)"
		strSQL=strSql & " values(" & ShowID & "," & PerformanceID & ",'" & oRs("SeatNumber") & "'," & ReservedForID & ",-1,'" & now() & "'," & CostBasis & ")"
		Seat=insertrecord(strSQL,"SHOW_SEATING","ShowID")
		oRs.movenext
	next
	'loop
	'Update seats available
	'strSQL="Update PERFORMANCE_TICKETS_AVAILABLE set TicketsAvailable=" & cstr(StartSeat-numSeats) & " where PerformanceID=" & PerformanceID
	'updateRecord strSQL
	
end sub

function GetAllPendingSeatsForAllPerformancesForPerson(ReservedFor)
	strSQL="SELECT Count(SHOW_SEATING.ShowID) AS NumTickets,PerformanceID,ShowID"
	strSQL=strSQL & " FROM SHOW_SEATING"
	strSQL=strSQL & " Where ReservationForID=" & ReservedFor & " and PaymentID=-1 GROUP BY PerformanceID,ShowID"
	set oRs= getrecordset(strSQL)
	set GetAllPendingSeatsForAllPerformancesForPerson=oRs
	set oRs = nothing
end function

function getAllPendingSeatsForThisPerson(ReservedFor)
	strSQL="SELECT PerformanceID,SeatNumber,CostBasis"
	strSQL=strSQL & " FROM SHOW_SEATING"
	strSQL=strSQL & " Where ReservationForID=" & ReservedFor & " and PaymentID=-1"
	set oRs= getrecordset(strSQL)
	set getAllPendingSeatsForThisPerson=oRs
	set oRs = nothing
end function

sub SetupPendingSeats(PerformanceID,ReservedFor)
		dim rsSeats,rsSeatingCategories,rsSeatInfo
		dim ii
		redim Seats(6,0)
		'Get prices for these seats
		set rsSeats=GetPendingSeats(PerformanceID,ReservedFor)
		set rsSeatingCategories=getAllSeatingCategoriesForPerformance(PerformanceID)
		ii=0
		do until rsSeatingCategories.eof
			ii=ii+1
			redim preserve Seats(6,ii)
			seats(1,ii)=rsSeatingCategories("SeatingCategoryID")
			seats(3,ii)=rsSeatingCategories("SeatingCategory")
			seats(5,ii)=rsSeatingCategories("SeatCategoryID")
			rsSeatingCategories.movenext
		loop
		
		do until rsSeats.eof
			''''''''''''''''''''
			'Seat Information
			'Seats(1,i) Category (reserved, unreserved...)
			'Seats(2,i) number of seats in that category
			'Seats(3,i) Seating Category Name
			'Seats(4,i) Seat Numbers
			'Seats(5,i) Seat Category (All seats, balcony,...)
			''''''''''''''''''''''
			set rsSeatInfo=getSeatingCategoryForPerformanceAndSeat(PerformanceID,TheaterID,rsSeats("SeatNumber"))
			for ii=1 to ubound(Seats,2)
				if Seats(1,ii)=rsSeatInfo("SeatingCategoryID") and Seats(5,ii)=rsSeatInfo("SeatCategoryID") then
					Seats(2,ii)=Seats(2,ii)+1
					totalSeats=totalSeats+1
					Seats(4,ii)=Seats(4,ii) & " " & rsSeats("SeatNumber")
				end if
			next
			rsSeats.movenext
		loop
		set rsSeats=nothing
		set rsSeatingCategories=nothing
		set rsSeatInfo=nothing
end sub


function GetPurchasedSeatsForAPerformancesForPerson(PerformanceID,ReservedFor)
	strSQL="SELECT seatNumber,CostBasis,PaymentID,PaymentReceiptID"
	strSQL=strSQL & " FROM SHOW_SEATING"
	strSQL=strSQL & " Where ReservationForID=" & ReservedFor & " and PaymentID>0 and PerformanceID=" & PerformanceID
	set oRs= getrecordset(strSQL)
	set GetPurchasedSeatsForAPerformancesForPerson=oRs
	set oRs = nothing
end function

sub GetAmountDuePaidForPerformancePerson(PerformanceID,ReservedFor)
	dim oRs1
	dim oRsPrice
	dim oRsPaidFor
	dim oRsSC
	dim oRsTime
	dim TheAmountPaid	
	totalAmountDue=0.00
	totalAmountPaid=0.00
	strSQL="Select distinct PaymentReceiptID,PaymentID,ShowID from SHOW_SEATING where PerformanceID=" & PerformanceID & " and ReservationForID=" & ReservedFor
	set oRs1= getrecordset(strSQL)
	GetServiceCharge  oRs1("ShowID")
	do until oRs1.eof
		strSQL="SELECT PERFORMANCE_TICKET_PRICE.TicketPrice, Count(SHOW_SEATING.SeatNumber) AS Seats"
		strSQL=strSQL & " FROM SHOW_SEATING, PERFORMANCE_TICKET_PRICE"
		strSQL=strSQL & " WHERE SHOW_SEATING.PerformanceID = PERFORMANCE_TICKET_PRICE.PerformanceID AND SHOW_SEATING.CostBasis = PERFORMANCE_TICKET_PRICE.PriceCategoryID AND PaymentID=" & oRs1("PaymentID") & " AND SHOW_SEATING.PerformanceID=" & PerformanceID & "  AND SHOW_SEATING.ReservationForID=" & ReservedFor
		strSQL=strSQL & " and PaymentReceiptID=" & oRs1("PaymentReceiptID")  ' added 8/2/2004
		strSQL=strSQL & " GROUP BY PERFORMANCE_TICKET_PRICE.TicketPrice"
		set oRsPrice=getrecordset(strSQL)
		do until oRsPrice.eof
		'TheAmountPaid=0.00
			select case oRs1("PaymentID")
			case 1
				PaymentType="CreditCard"
				if ServiceChargeType=1 then
					TheAmountPaid=oRsPrice(0) * oRsPrice(1) + oRsPrice(1)*ServiceCharge
				else
					TheAmountPaid=(oRsPrice(0) * oRsPrice(1))*(1+ServiceCharge)
				end if
				totalAmountPaid=totalAmountPaid + TheAmountPaid
			case 2
				PaymentType="Cash/Check"
				TheAmountPaid=oRsPrice(0) * oRsPrice(1)
				totalAmountPaid=totalAmountPaid + TheAmountPaid
			case 3
				PaymentType="DUE"
				TheAmountPaid=oRsPrice(0) * oRsPrice(1)
				totalAmountDue=totalAmountDue + TheAmountPaid
			case 4
				PaymentType="Comp"
				'totalAmountPaid=0.00
			case 5
				PaymentType="SeasonTicket"
				'totalAmountPaid=0.00
			end select
			if not isnull(oRs1("PaymentReceiptID")) then
				set oRsPaidFor=getrecordset("select AmountDue,AmountPaid,ReservedForFN,ReservedForLN from PAYMENT_RECEIPTS where PaymentReceiptID=" & oRs1("PaymentReceiptID"))
				PaymentFor=oRsPaidFor("ReservedForFN") & " " & oRsPaidFor("ReservedForLN")
			end if
			oRsPrice.movenext
		loop
	'	strSQL="SELECT PERFORMANCE_TICKET_PRICE.TicketPrice, Count(SHOW_SEATING.SeatNumber) AS Seats"
	'	strSQL=strSQL & " FROM SHOW_SEATING INNER, PERFORMANCE_TICKET_PRICE"
	'	strSQL=strSQL & " WHERE SHOW_SEATING.PerformanceID = PERFORMANCE_TICKET_PRICE.PerformanceID AND SHOW_SEATING.CostBasis = PERFORMANCE_TICKET_PRICE.PriceCategoryID AND PaymentID=" & oRs1("PaymentID") & " AND SHOW_SEATING.PerformanceID=" & PerformanceID & "  AND SHOW_SEATING.ReservationForID=" & ReservedFor
	'	strSQL=strSQL & " GROUP BY PERFORMANCE_TICKET_PRICE.TicketPrice"
	'	if not isnull(oRs1("PaymentReceiptID")) then
	'		set oRs2=getrecordset("select AmountDue,AmountPaid,ReservedForFN,ReservedForLN from PAYMENT_RECEIPTS where PaymentReceiptID=" & oRs1("PaymentReceiptID"))
	'	set oRs2=getrecordset(strSQL)
	'	totalAmountDue=totalAmountDue + oRs2("AmountDue")
	'	totalAmountPaid=totalAmountPaid + oRs2("AmountPaid")
	'	PaymentFor=oRs2("ReservedForFN") & " " & oRs2("ReservedForLN")
		set oRsTime= getrecordset("Select min(ResearveTime) as RT from SHOW_SEATING where PerformanceID=" & PerformanceID & " and ReservationForID=" & ReservedFor)
		ReserveTime=oRsTime("RT")
		oRs1.movenext
	loop
	set oRs1=nothing
	set oRsPrice=nothing
	set oRsPaidFor=nothing
	set oRsSC=nothing	
end sub

sub UpdateTimeForPendingTickets(lSessionID)
	strSQL="Update SHOW_SEATING set ResearveTime='" & now() & "' where  ReservationForID=" & lSessionID
	updateRecord strSQL
end sub 

sub GetPricesForSelectedSeats(PerformanceID,ReservedFor)
		dim ii
		redim price(4,0)
		ii=0
		'Price(1,i) PriceCategoryID
		'Price(2,i) PriceCategory Name
		'Price(3,i) Number in Price Category
		'Price(4,i) Price
		strSQL="Select 	count(Seatnumber) as NumSeats,PERFORMANCE_TICKET_PRICE.PriceCategoryID,PRICE_CATEGORY.PriceCategory,TicketPrice"
		strSQL=strSQL & " from SHOW_SEATING,PERFORMANCE_TICKET_PRICE,PRICE_CATEGORY"
		strSQL=strSQL & " where SHOW_SEATING.PerformanceID=PERFORMANCE_TICKET_PRICE.PerformanceID"
		strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID=PRICE_CATEGORY.PriceCategoryID"
		strSQL=strSQL & " and PERFORMANCE_TICKET_PRICE.PriceCategoryID=SHOW_SEATING.CostBasis"
		strSQL=strSQL & " and SHOW_SEATING.PerformanceID=" & PerformanceID
		strSQL=strSQL & " and SHOW_SEATING.ReservationForID=" & ReservedFor
		strSQL=strSQL & " GROUP BY PERFORMANCE_TICKET_PRICE.PriceCategoryID,PRICE_CATEGORY.PriceCategory,TicketPrice"
		set oRs= getrecordset(strSQL)
		do until oRS.eof
			ii=ii+1
			redim preserve price(4,ii)
			price(1,ii)=oRs("PriceCategoryID")
			price(2,ii)=oRs("PriceCategory")
			price(3,ii)=oRs("NumSeats")
			price(4,ii)=oRs("TicketPrice")
			oRs.movenext
		loop
		TotalTicketCost=0
		TotalTickets =0		
		for ii=1 to ubound(price,2)
			TotalTicketCost=TotalTicketCost + Price(4,ii)*Price(3,ii)
			TotalTickets =TotalTickets + Price(3,ii)
		next
		set oRs = nothing
end sub

sub GetServiceCharge(ShowID)
	strSQL="Select ServiceCharge,ServiceChargeType from SERVICE_CHARGE where ShowID=" & ShowID
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		ServiceCharge=0.00
		ServiceChargeType=0    
    else
		ServiceCharge=oRs("ServiceCharge")
		ServiceChargeType=oRs("ServiceChargeType")
	end if
	set oRs=nothing

end sub

sub GetSpecialServiceCharge(ShowID)
	strSQL="Select ServiceCharge,ServiceChargeType from SPECIAL_SERVICE_CHARGE where ShowID=" & ShowID
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		SpecialServiceCharge=0.00
		SpecialServiceChargeType=0.00	
	else
		SpecialServiceCharge=oRs("ServiceCharge")
		SpecialServiceChargeType=oRs("ServiceChargeType")
	end if
	set oRs=nothing

end sub
'''''''''''''''''''


''''''ACCOUNT/THEATER INFO
sub GetAccountInformationFromShow(ShowID)
	set oRs=getrecordset("Select ACCOUNTS.*,AccountReturnURL,AccountLogo,AccountReferenceMessage from ACCOUNTS,ACCOUNT_INFO,SHOWS where ACCOUNTS.AccountID=ACCOUNT_INFO.AccountID and ACCOUNTS.AccountID=SHOWS.AccountID and SHOWS.ShowID=" & ShowID)
	AccountID=oRs("AccountID")
	AccountName=oRs("AccountName")
	AccountReturnURL=oRs("AccountReturnURL")
	AccountLogo=oRs("AccountLogo")
	AccountReferenceMessage=oRs("AccountReferenceMessage")
	set oRs=getrecordset("Select AccountID from MANAGEMENT_ACCOUNT_ACCOUNTS where AccountID=" & AccountID)
	if oRs.eof then
		isTTO=false
	else
		isTTO=true
	end if	
	set oRs=nothing
end sub

sub GetAccountInformation(AccountID)
	set oRs=getrecordset("Select ACCOUNTS.*,AccountReturnURL,AccountLogo,AccountReferenceMessage from ACCOUNTS,ACCOUNT_INFO where ACCOUNTS.AccountID=ACCOUNT_INFO.AccountID and ACCOUNTS.AccountID=" & AccountID)
	AccountName=oRs("AccountName")
	AccountReturnURL=oRs("AccountReturnURL")
	AccountLogo=oRs("AccountLogo")
	AccountReferenceMessage=oRs("AccountReferenceMessage")
	set oRs=getrecordset("Select AccountID from MANAGEMENT_ACCOUNT_ACCOUNTS where AccountID=" & AccountID)
	if oRs.eof then
		isTTO=false
	else
		isTTO=true
	end if	
	set oRs=nothing
end sub

function getAccountInfoFromUNandPW(username,password)
	strSQL="Select AccountID,Role from ACCOUNT_REGISTER where UserName= '" & lcase(username) & "' and password='" & lcase(password) & "'"
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		getAccountInfoFromUNandPW=false
	else
		AccountID=oRs("AccountID")
		Role=oRs("Role")
		GetAccountInformation AccountID
		getAccountInfoFromUNandPW=true	
	end if
end function

function VerifyManagementLogin(username,password)
	strSQL="Select ManagementAccountID,ManagementAccountUserID from MANAGEMENT_ACCOUNT_USERS where ManagmentAccountUserName= '" & lcase(username) & "' and ManagementAccountpassword='" & lcase(password) & "'"
	set oRs=getrecordset(strSQL)
	if oRs.eof then
		VerifyManagementLogin=false
	else
		ManagementAccountID=oRs("ManagementAccountID")
		ManagementAccountUserID=oRs("ManagementAccountUserID")
		VerifyManagementLogin=true	
	end if
end function

sub GetManagementInformation(ManagementAccountID)
	strSQL="Select ManagementAccountLogo from MANAGEMENT_ACCOUNT_INFO where ManagementAccountID=" & ManagementAccountID
	set oRs=getrecordset(strSQL)
	AccountLogo=oRs("ManagementAccountLogo")
	set oRs=nothing
end sub

function GetCreditCardsForAccount(AccountID)
	strSQL="Select CreditCardName from CREDIT_CARDS,ACCOUNT_CREDIT_CARD where CREDIT_CARDS.CreditCardID=ACCOUNT_CREDIT_CARD.CreditCardID and ACCOUNT_CREDIT_CARD.AccountID=" & AccountID
	set oRs=getrecordset(strSQL)
	set GetCreditCardsForAccount=oRs
	set oRs=nothing
end function

sub GetTheaterInformation(TheaterID)
	set oRs=getrecordset("Select * from THEATERS where TheaterID=" & TheaterID)
	TheaterName=oRs("TheaterName")
	TheaterAddress=oRs("TheaterAddress")
	TheaterCity=oRs("TheaterCity")
	TheaterState=oRs("TheaterState")
	TheaterZip=oRs("TheaterZip")
	TheaterLabelType=oRs("TheaterLabelType")
	TheaterMapQuest=oRs("TheaterMapQuest")
	TheaterPhone=oRs("TheaterPhone")
	set oRs=nothing
end sub

'''''''''''''''''''''''''

'''''''''PURCHASER INFORMATION
function GetAllPeopleAtAPerformance(PerformanceID)
	strSQL="Select distinct PERSON.PersonID,PersonFirstName,PersonLastName from PERSON,SHOW_SEATING where PERSON.PersonID=SHOW_SEATING.ReservationForID and PerformanceID=" & PerformanceID & " order by PersonLastName ASC"
	set oRs=getrecordset(strSQL)
	set GetAllPeopleAtAPerformance=oRS
	set oRs=nothing
end function

'function GetPurchasedFor(PerformanceID,PersonID)
'	strSQL="Select PaymentFor from PAYMENT_RECEIPTS,SHOW_SEATING where PAYMENT_RECEIPTS.PaymentReceiptID=SHOW_SEATING.PaymentReceiptID and SHOW_SEATING.ReservationsForID=" & PersonID & " and  PerformanceID=" & PerformanceID
'	set oRs=getrecordset(strSQL)
'	GetPurchasedFor=oRS("PaymentFor")
'	set oRs=nothing
'end function

sub GetPerson(PersonID)
	set oRs=getrecordset("Select * from PERSON where PersonID=" & PersonID)
	if not oRs.eof then
		strFname=oRs("PersonFirstName")
		strLName=oRs("PersonLastName")
		strAddress=oRs("PersonAddress1")
		strCity=oRs("PersonCity")
		strState=oRs("PersonState")
		strPhone=oRs("PersonPhone")
		strZip=oRs("PersonZipCode")
		strEMail=oRs("PersonEMail")
	end if
	set oRs=nothing
end sub

'sub InsertPerson(PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail)
'	strSQL="Insert Into PERSON (PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail) values ('" & personData(1) & "','" & personData(2) & "','" & personData(3) & "','" & personData(4) & "','" & personData(5) & "','" & personData(6) & "','" & personData(7) & "','" & personData(8) & "')"
'		PersonID=insertrecord("Insert Into PERSON (PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail) values ('" & PersonLastName & "','" & PersonFirstName & "','" & personData(3) & "','" & personData(4) & "','" & personData(5) & "','" & personData(6) & "','" & personData(7) & "','" & personData(8) & "')","PERSON","PersonID")
'
'end sub
'''' FIND SEATS''''''''

sub getContiguousSeats(TheaterID,PerformanceID,NoSeats)
	dim SeatNum
	dim RowNum
	dim iSeatNo
	strSql="select Row,Seat,SeatNumber from Theater_Seating where TheaterID=" & TheaterID  & " and seat > 0 and area=2 and SeatNumber not in (select SeatNumber from Show_seating where PerformanceID=" & PerformanceID & ") order by row,seat" 
	set oRs=getrecordset(strSQL)
	redim ContiguousSeats(NoSeats)
	ContiguousSeats(0)="X"
	SeatNum=oRs(1)
	RowNum=oRs(0)
	iSeatNo=1
	ContiguousSeats(iSeatNo)=oRs(2)
	oRs.movenext
	do until oRs.eof
		if iSeatNo = NoSeats then
			'Specified Seats found

		else
			'Still looking
			if oRs(0)=Rownum and oRs(1) = SeatNum + 1  then
					'still in same row next seat
					SeatNum=oRs(1)
					iSeatNo=iSeatNo + 1
					ContiguousSeats(iSeatNo)=oRs(2)
			else
				
			end if
		end if
		oRs.movenext
	loop
	set oRs=nothing

end sub

'''''''''''''''''''''''
sub InsertPerson(PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail)
	strSQL="Insert Into PERSON (PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail) values ('" & personData(1) & "','" & personData(2) & "','" & personData(3) & "','" & personData(4) & "','" & personData(5) & "','" & personData(6) & "','" & personData(7) & "','" & personData(8) & "')"
		if testInput(strsql) then
		    Response.Redirect "ErrorPage.asp"
			exit sub
		else
			PersonID=insertrecord("Insert Into PERSON (PersonLastName,PersonFirstName,PersonAddress1,PersonCity,PersonState,PersonZipCode,PersonPhone,PersonEMail) values ('" & PersonLastName & "','" & PersonFirstName & "','" & personData(3) & "','" & personData(4) & "','" & personData(5) & "','" & personData(6) & "','" & personData(7) & "','" & personData(8) & "')","PERSON","PersonID")
		end if
end sub

function TestInput(StringToSearch)
	'stringToSearch = strSQL
	dim RegularExpressionObject
	dim expressionmatch
	Set RegularExpressionObject = New RegExp
	With RegularExpressionObject
	.Pattern = "<|--|drop |xp_|up_|sp_|script|\|;"
	.IgnoreCase = True
	.Global = True
	End With
	expressionmatch = RegularExpressionObject.Test(StringToSearch)
	testInput=expressionmatch
end function

%>