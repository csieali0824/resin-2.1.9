
// get user agent
var agent = navigator.userAgent.toLowerCase();

// check browser type
var isSafari = (agent.indexOf('safari')!=-1);

// check operating system type
var isWindows = ((agent.indexOf("win")!=-1) || (agent.indexOf("16bit")!=-1));
var isMac = (agent.indexOf("mac")!=-1);
var isMacClassic = (isMac && !hasJavaPlugin());
var isMacOSX = (isMac && !isMacClassic);

// set applet width and height
var appletWidth = 600;
var appletHeight = 600;
var appletMacOSXWidth = 900;

if(isMacOSX) {
	appletWidth = appletMacOSXWidth;
}

// dynamically determine jar file to use
if(isMacClassic) {
	var jarFile = "ftpapplet-mac.jar";
} else {
	var jarFile = "ftpapplet.jar";
}

// check if Java plug-in is installed
function hasJavaPlugin() {
		if (isSafari) {
		  return true;
		}		
 		for (var i = 0; i < navigator.plugins.length; i++) {
  			if (navigator.plugins[i].name.indexOf("Java Plug-in") > -1) {
  			  return true;
  			}
 		} 
		return false;		
}  

// write out beginning applet tag
document.write("<applet name=\"ftpapplet\" code=\"com.jscape.ftpapplet.FtpApplet.class\" width=\""+appletWidth+"\" height=\""+appletHeight+"\" archive=\""+jarFile+"\">");    

// if Mac OS 9 or earlier is used omit cabbase tag
if(!isMacClassic) {
  document.write("<param name=\"cabbase\" value=\"ftpapplet.cab\">");
}  
