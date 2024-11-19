/////////// Agenda file for CalendarXP 5.0 ////////////
// This file is totally configurable. You may remove all the comments in this file to shrink the download size.
////////////////////////////////////////////////////////
var gsAction=" ";	// Default action to be performed on everyday, except agenda days.

////////////// Add Agendas //////////////////////////////////////////
// Usage -- addEvent(date, message, color, action, imgsrc);
// Notice:
// 1. The format of event date is defined in fHoliday() plug-in. Current format is Y-M-D.
// 2. In the action part you can use any javascript statement.
// 3. Assign <null> to action will result in a line-through effect of that day, while <" "> not.
// 4. imgsrc is the tag string to be shown inside the agenda cell, should usually be an image tag.
/////////////////////////////////////////////////////////////////////
addEvent("2001-12-8", " Dec 8, 2001 \n PopCalendarXP 5.0 Unleashed! ", "gold", "alert('Hello World!');");
addEvent("2001-5-13", "Disabled Date!", gcBG, null);


////////////////////////////////////////////////////////////////////////////////
// Holiday PLUG-IN Function -- will return [message,color,action,imgsrc] like agenda!
////////////////////////////////////////////////////////////////////////////////
function fHoliday(y,m,d) {
  var r=agenda[y+"-"+m+"-"+d]; // check agenda table with designated date format
  if (r) return r;	// if there is a defined agenda, then skip the holiday highlights.

  if (m==12&&d==25)
	r=["Merry Xmas!", "seagreen"];
  else if (m==12&&d==26)
	r=[" Boxing Day! \n Let's go shopping ... ", "skyblue", "popup('http://www.yahoo.com','main');"];
  else if (m==10&&d==1)
	r=[" China National Day! \n Let's enjoy a long vacation ... ", "skyblue", " "];
 
  return r;
}

//////// Put all your self-defined functions to the following /////////
function popup(url, framename) {
  var w=parent.open(url,framename,"top=200,left=200,width=400,height=200,scrollbars=1,resizable=1");
  if (w&&!framename) w.focus();
}



