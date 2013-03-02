<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
    <title>Maximum Time</title>
</head>


<style>
    body    { background : white; color : black; margin: 0 }
    body    { font-family: Verdana, Arial, sans-serif; font-size: 8pt; line-height: 12pt }
    table   { font-family: Verdana, Arial, sans-serif; font-size: 8pt; line-height: 12pt }
    
    div.Offscreen     { display:none }
    span.Offscreen    { display:none }
    span.BulletNumber { font-size: x-large; font-weight: bold; color: #66ccff }
    span.BulletText   { font-size: x-small; font-weight: bold; letter-spacing: -1pt; text-align:center}

    </style>

<body>


<div style="position:relative; left:10px; top:10px; width:90%; height=+30px;" id=DivRule>
	<font style="font-size: 14pt; font-family: Verdana, Arial, sans-serif; color: #4E4E4E;  line-height: 14pt" >
	Sorry... your purchase exceeded the alloted time to complete!
	</font>
</div>

<div id=Out0 style="position:relative; left:20px; top:+15px; width:90%;" >
<BR>
To resubmit your information please  <b><a href="http://www.ez-show-tickets.com/v5/events.asp?AID="<%=session("AccountID")%>">PRESS HERE</a></b> .
</div>
<BR><BR><BR>
</body>
</HTML>