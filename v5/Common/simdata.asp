<%
Dim loginid
Dim txnkey
dim rsAccount
set rsAccount=getrecordset("Select AccountANUN,AccountANtxnkey from ACCOUNT_INFO where AccountID=" & session("AccountID"))
loginid=rsAccount("AccountANUN")
txnkey=rsAccount("AccountANtxnkey")
' You may want to store this in a more secure location like a DB or Registry
'loginid = "ib0000776"
'txnkey = "0yJWfhZ3amILg488"
%>
