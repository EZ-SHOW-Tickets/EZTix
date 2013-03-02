<% 
dim i,j
dim x
for i= 1 to 10000
	for j= 1 to 1000
	x= i + j
	next
next
%>
<html>
#loading-image {
background-color: #333;
width: 55px;
height: 55px;
position: fixed;
top: 20px;
right: 20px;
z-index: 1;
-moz-border-radius: 10px;
-webkit-border-radius: 10px;
border-radius: 10px; /* future proofing */
-khtml-border-radius: 10px;
}
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Test Loading</title>
<script language="JavaScript">
<!--
jQuery(window).load(function() {
jQuery('#loading-image').hide();
});
//-->
</script>

</head>

<body onLoad="MM_preloadImages('images/loginON.gif')">


<div id="loading-image">
<img src="%3c?php bloginfo('template_url'); ?&gt;images/ajax-loader.gif" alt="Loading..." / WIDTH="0" HEIGHT="0">
</div>

</body>

</html>