
<%
dim connection_string
connection_string="DRIVER={SQL Server};SERVER=207.171.1.66;DATABASE=REHEARSE;UID=sa;PWD=cgc0023"
''''''''DATA BASE '''''''''''''''''
function GetRecordSet(strSQL)
	on error resume next
	Dim m_oConnection
	Dim oCommand 
	dim oRS
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
end function

function GetDBItem(strSQL)
	on error resume next
	Dim m_oConnection
	Dim oCommand 
	dim oRS
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
end function

function InsertRecord(strSQL,InsertTable,NewID)
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

function UpdateRecord(strSQL)
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
		exit function
	end if
	set m_oConnection=nothing
	set oCommand=nothing
	set oRS=nothing
end function
%>
