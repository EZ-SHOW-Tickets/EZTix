<%
function GetRecordSet(strSQL)
Dim m_oConnection
Dim oCommand 
dim oRS
'// Create Recordset
set oRS = Server.CreateObject("ADODB.Recordset")
'// Open recordset
Set m_oConnection = Server.CreateObject("ADODB.Connection")
'm_oConnection.ConnectionString = "DRIVER={SQL Server};SERVER=209.204.62.15;DATABASE=CGCTicketing;UID=sa;PWD=cgcuser"
m_oConnection.ConnectionString = "DRIVER={SQL Server};SERVER=129.47.1.163;DATABASE=CGCTicketing;UID=sa;PWD=cgcuser"
m_oConnection.Open
Set oCommand = Server.CreateObject("ADODB.Command")
oCommand.ActiveConnection = m_oConnection
'// Get RecordSet
oCommand.CommandText = strSQL
Set oRS = oCommand.Execute()
set GetRecordSet=oRS
set m_oConnection=nothing
set oCommand=nothing
set oRS=nothing

end function

function InsertRecord(strSQL,InsertTable,NewID)
Dim m_oConnection
Dim oCommand 
dim oRS
set oRS = Server.CreateObject("ADODB.Recordset")
Set m_oConnection = Server.CreateObject("ADODB.Connection")
'm_oConnection.ConnectionString = "DSN=MSB_SQL;uid=sa;pwd=;"
m_oConnection.ConnectionString = "DRIVER={SQL Server};SERVER=209.204.62.15;DATABASE=CGCTicketing;UID=sa;PWD=cgcuser"
m_oConnection.Open
Set oCommand = Server.CreateObject("ADODB.Command")
oCommand.ActiveConnection = m_oConnection
oCommand.CommandText = strSQL
Set oRS = oCommand.Execute()
oCommand.CommandText = "select max(" & newID & ") as NewID from " & insertTable
Set oRS = oCommand.Execute()	
InsertRecord=oRS("NewID")
set m_oConnection=nothing
set oCommand=nothing
set oRS=nothing
end function

function UpdateRecord(strSQL)
Dim m_oConnection
Dim oCommand 
dim oRS
set oRS = Server.CreateObject("ADODB.Recordset")
Set m_oConnection = Server.CreateObject("ADODB.Connection")
'm_oConnection.ConnectionString = "DSN=MSB_SQL;uid=sa;pwd=;"
m_oConnection.ConnectionString = "DRIVER={SQL Server};SERVER=209.204.62.15;DATABASE=CGCTicketing;UID=sa;PWD=cgcuser"
m_oConnection.Open
Set oCommand = Server.CreateObject("ADODB.Command")
oCommand.ActiveConnection = m_oConnection
oCommand.CommandText = strSQL
Set oRS = oCommand.Execute()
set m_oConnection=nothing
set oCommand=nothing
set oRS=nothing
end function

sub DeleteRecord(strSQL)
Dim m_oConnection
Dim oCommand 
dim oRS
set oRS = Server.CreateObject("ADODB.Recordset")
Set m_oConnection = Server.CreateObject("ADODB.Connection")
'm_oConnection.ConnectionString = "DSN=MSB_SQL;uid=sa;pwd=;"
m_oConnection.ConnectionString ="DRIVER={SQL Server};SERVER=209.204.62.15;DATABASE=CGCTicketing;UID=sa;PWD=cgcuser"
m_oConnection.Open
Set oCommand = Server.CreateObject("ADODB.Command")
oCommand.ActiveConnection = m_oConnection
oCommand.CommandText = strSQL
Set oRS = oCommand.Execute()
set m_oConnection=nothing
set oCommand=nothing
set oRS=nothing
end sub

%>