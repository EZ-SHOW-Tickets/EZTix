/////////////////////////////////////////////////////////rac
//
//	Site Statistics Accumulator
//
////////////////////////////////////////////////////////////
// Adapted from WebTrends script(s) - this is an include
// file that needs to be added to the end of each page for
// which statistics are desired, i.e.
// after the </html> tag, insert
// <script src="../pathname/thisfilename.js"> add end tag ..
// Length of command line parameters is limited to 2K ...,
// therefore, date is parsed into 8 characters
////////////////////////////////////////////////////////////
// Change history
////////////////////////////////////////////////////////////
// By		Date		Description
// rac	20021201	Initial version
////////////////////////////////////////////////////////////
function _siteStatAccumulator()
{
	//alert("XX");
	// add servername if required for tracking (manual)
	var SERVER= "";
	// add content group name if required for tracking (manual)
	var CONTENTGROUP= "";
	
	// this document's URL (in browser mode)
	var wtl_URL= document.URL;
	// this document's title
	var wtl_Title= document.title;

	////////////////////////////////////////////////////////
	// date formatter (valid for next 62 years)
	//		expressed in character string
	//		year		y		2	=	2002
	//		month		m		C	=	December
	//		day			d		2	=	4
	//		hours		h		A	=	10:
	//		minutes		m		V	=	31:
	//		seconds		s		K	=	21
	//		weekday maj d*16	9	=	}
	//		weekday min d		8	=	} a Wednesday (day 3 of the week)
	function D8(d)
	{
		var fwd=0, seed= new Date('01/01/2000'), key= "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		var s= key.charAt( d.getFullYear()-2000)+key.charAt( d.getMonth()+1)+key.charAt( d.getDate());
		s+= key.charAt( d.getHours())+key.charAt( d.getMinutes())+key.charAt( d.getSeconds());
		while( seed.getDay()!=fwd) seed= new Date(seed.getTime() + 86400000);
		var w= Math.floor( (d.getTime()-(seed.getTime()+86400000)) / 604800000 );
		s+= key.charAt( (w-(w%16))/16 );
		s+= key.charAt( w%16);
		return s;
	}
	
	////////////////////////////////////////////////////////
	// reverse day of the week calculation based on the
	// last (2) digits in the stored converted date
	//
	function _rDay(seed,w)
	{
		var nseed = new Date(seed.getTime() + 86400000);
		var r = ((w * 604800000) + 86400000) + (nseed.getTime() + 86400000)
		return new Date(r)
	}
	
	///////////////////////////////////////////////////////
	// concatenate parameters
	//
	function A(B,C)
	{
		W+="&"+B+"="+escape(C);
	}

	var t = new Date();
	var W = "";
	// address of processor page on server
	//var W="http"+(document.URL.indexOf('https:')==0?'s':'')+"://localhost/mystudentbody_Local/MSBReporting/WebStatProcessor.asp?version=1.0";
	//var W="http"+(document.URL.indexOf('https:')==0?'s':'')+"://209.204.50.84/MSBReporting/WebStatProcessor.asp?version=1.0";
	var W="WebStatProcessor.asp?version=1.0";
	A( "server", typeof(SERVER)== "string" ? SERVER : "");
	A( "Group", typeof(CONTENTGROUP)== "string" ? CONTENTGROUP : "");
	// timezone offset in minutes
	A( "tz", t.getTimezoneOffset());
	// rounded hours (24hr based)
	A( "ch", t.getHours());
	// long date
	A( "cl", D8(t));
	// this document's title
	A( "ti", typeof(wtl_Title)== "string" ? wtl_Title : document.title);
	// this document's full address string
	A( "url", typeof(wtl_URL)== "string" ? wtl_URL : document.URL);
	A( "rf", window.document.referrer);
	// processes JavaScript (default = yes)
	A( "js", 1);
	// user language (indexOf(navigator.language) = 'en' = English, 
	//												'nl' = Dutch,
	//												'fr' = French,
	//												'de' = German,
	//												'ja' = Japanese,
	//												'it' = Italian,
	//												'pt' = Portugese,
	//												'es' = Spanish,
	//												'sv' = Swedish,
	//												'zh' = Chinese ...
	A( "ul", navigator.appName=="Netscape" ? navigator.language : navigator.userLanguage);
	if(typeof(screen)=="object")
	{
		A( "sr", screen.width+"x"+screen.height);
		A( "cd", screen.colorDepth);
		A( "jo", navigator.javaEnabled()?1:0);
	}
	if( W.length>2048 && navigator.userAgent.indexOf('MSIE')>=0)
		W= W.substring( 0, 2043)+"&tu=1";

	//////////////////////////////////////////////////////////////////////////////////////
	// id = can be used as account #, for tracking purposes
	// the document.write method below is the way to redirect capturing the web statistics
	// the other 2 methods are for debug purposes only ...
	//alert(W);
	document.write('<IMG ID="CGC_01" BORDER="0" WIDTH="1" HEIGHT="1" SRC="'+W+'">');
	//txaDebug.innerHTML = W;
	//window.navigate(W)
}
_siteStatAccumulator();
