<%@ Language=VBScript %>
<%
Response.Buffer = true
'/////////////////////////////////////////////////////////rac
'//
'// WebStatProcessor Page
'//
'////////////////////////////////////////////////////////////
'// Change History
'////////////////////////////////////////////////////////////
'// By	Date		Description
'////////////////////////////////////////////////////////////
'// rac	20021203	Initial construction
'////////////////////////////////////////////////////////////

dim b
dim strSQL
'// add a server name and contentgroup constant, can be replaced
'// with querystrings
const cSERVERNAME = "CGCINTL2"
const cCONTENTGROUP = "ez-show-tickets"

'// build SQL string with querystring values that are passed
strSQL = "INSERT INTO webstatlog "
strSQL = strSQL & "(userid, " & _
				  "userip, " & _
				  "server, " & _
				  "contentgroup, " & _
				  "tz_offset, " & _
				  "hours, " & _
				  "longdate, " & _
				  "doc_title, " & _
				  "doc_url, " & _
				  "doc_referrer, " & _
				  "proc_java, " & _
				  "language, " & _
				  "screen_res, " & _
				  "color_depth, " & _
				  "java_enabled, " & _
				  "SessionID, " & _
				  "ServerDate) "
strSQL = strSQL & "VALUES (" & _
				  "'" & session("AccountID") & "', " & _
				  "'" & Request.ServerVariables("REMOTE_ADDR") & "', " & _
				  "'" & cSERVERNAME & "', " & _
				  "'" & cCONTENTGROUP & "', " & _
				  Request.QueryString.Item(4) & ", " & _
				  Request.QueryString.Item(5) & ", " & _
				  "'" & Request.QueryString.Item(6) & "', " & _
				  "'" & Request.QueryString.Item(7) & "', " & _
				  "'" & Request.QueryString.Item(8) & "', " & _
				  "'" & Request.QueryString.Item(9) & "', " & _
				  Request.QueryString.Item(10) & ", " & _
				  "'" & Request.QueryString.Item(11) & "', " & _
				  "'" & Request.QueryString.Item(12) & "', " & _
				  Request.QueryString.Item(13) & ", " & _
				  Request.QueryString.Item(14) & ", " & _
				  cstr(session.SessionID) & ", " & _
				  "'" & formatdatetime(now(),vbgeneralDate) & "')"

'// if uncommented, you can view the values that are being passed
'for b = 1 to Request.QueryString.Count
'	Response.Write(Request.QueryString.Item(b) & "<br>")
'next

dim m_strDB_Connection

''m_strDB_Connection = "DRIVER={SQL Server};SERVER=129.47.1.162;DATABASE=EZT;UID=EZTicketing;PWD=ezt0023"
m_strDB_Connection = "DRIVER={SQL Server};SERVER=207.171.1.162;DATABASE=EZT;UID=EZTicketing;PWD=ezt0023"

'// call insert
InsertRecord(strSQL)

function InsertRecord(strSQL)

	dim m_oConnection
	dim oCommand 
	dim oRS

	set oRS = Server.CreateObject("ADODB.Recordset")
	Set m_oConnection = Server.CreateObject("ADODB.Connection")
		m_oConnection.ConnectionString = m_strDB_Connection
		m_oConnection.Open
	Set oCommand = Server.CreateObject("ADODB.Command")
		oCommand.ActiveConnection = m_oConnection
		oCommand.CommandText = strSQL
	Set oRS = oCommand.Execute()

	'// clean up objects
	set oRS = nothing
	set oCommand = nothing
	set m_oConnection = nothing

end function

'Response.Clear

%>
<html>
<head>
<meta name="generator" content="microsoft visual studio 6.0">
</head>
<body>

<p>xxxx</p>

</body>
</html>
