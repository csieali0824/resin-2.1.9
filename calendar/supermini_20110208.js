/////////// JS theme file for CalendarXP 5.0 ////////////
// This file is totally configurable. You may remove all the comments in this file to shrink the download size.
////////////////////////////////////////////////////////

// ---- PopCalendar Specific Options ----
//var gsSplit="/";	        // separator of date string, AT LEAST one char.
var gsSplit=null;	        // separator of date string, 
var giDatePos=2;	// date format  0: D-M-Y ; 1: M-D-Y; 2: Y-M-D
var gbDigital=true;	// month format   true: 01-05-2001 ; false: 1-May-2001
var gbShortYear=false;   // year format   true: 2-digits; false: 4-digits
var gbAutoPos=true;	// enable auto-adpative positioning or not
var gbPopDown=true;	// true: pop the calendar below the dateCtrl; false: pop above if gbAutoPos is false.

// ---- Common Options ----
var gMonths=["JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"];
var gWeekDay=["Su","Mo","Tu","We","Th","Fr","Sa"];	// weekday caption from Sunday to Saturday

var gBegin=[1990,1,1];	// static Range begin from [Year,Month,Date]
var gEnd=[2050,12,31];	// static Range end at [Year,Month,Date]
var gsOutOfRange="Sorry, you may not go beyond the designated range!";	// out-of-date-range error message

var gbEuroCal=false;	// show european calendar layout - Sunday goes after Saturday

var giDCStyle=1;	// the style of Date Controls.	0: 3D; 1: flat; 2: text-only;
var gsCalTitle="gMonths[gCurMonth[1]-1]+' '+gCurMonth[0]";	// dynamic statement to be eval-ed as the title when giDCStyle>0.
var gbDCSeq=true;	// (effective only when giDCStyle is 0) true: show month box before year box; false: vice-versa;
var gsYearInBox="i";	// dynamic statement to be eval-ed as the text shown in the year box. e.g. "'A.D.'+i" will show "A.D.2001"
var gsNavPrev="&lt;";	// the caption of the left month navigator
var gsNavNext="&gt;";	// the caption of the right month navigator

var gbHideBottom=true;	// true: hide the bottom portion; false: show it with gsBottom.
var gsBottom="<A class='Today' href='javascript:void(0)' onclick='if(!NN4)this.blur();fHideCal();return false;' onmouseover='return true;' title='close it'>close</A>";	// the expression of Today-portion at the bottom

//var giCellWidth=OP6?14:12;	// calendar cell width;
var giCellWidth=OP6?14:12;	// calendar cell width;
var giCellHeight=12;	// calendar cell height;
var gpicBG=null;	// url of background image
var gsBGRepeat="repeat";// repeat mode of background image [no-repeat,repeat,repeat-x,repeat-y]
var gsCalTable="border=0 cellpadding=2 cellspacing=1";	// properties of the calendar inside <table> tag
var gsPopTable="border=1 cellpadding=1 cellspacing=1";	// properties of the outmost container <table> tag

//var gcBG="#f1f1f1";	// default background color of the cells. Use "" for transparent!!!
var gcBG="#e1e1e1";	// default background color of the cells. Use "" for transparent!!!
var gcCalBG="#6699cc";	// background color of the calendar
//var gcFrame="#f5f5f5";	// frame color
var gcFrame="WHITE";	// frame color
var gcSat="darkcyan";	// Saturday color
var gcSun="red";	// Sunday color
var gcWorkday="black";	// Workday color
var gcOtherDay="silver";	// the day color of other months
var gcToggle="yellow";	// highlight color of the focused cell

var gsCopyright="TSC (c) 2005-2010";
var giHighlightAgenda=2;	// 0: no highlight; 1: highlight with bold-font only (font-size>=8pt); 2: highlight with agenda color only; 3: highlight with both effects.
var giHighlightToday=1; // 0: no highlight; 1: highlight the cell background-color with gsTodayHS (supported in all browsers) ; 2: highlight the cell border with gsTodayHS (not supported in NN4);
var gsTodayHS="#FF9900";	// the highlight style of the cell with today's date, it is a string of color or border-style depending on giHighlightToday

var giWeekCell=-1;	// -1: don't show up week counters;  0~7: show week counters at the designated column.
var gsWeekHead="&sect;";	// the text shown in the table head of week column.
var gsWeeks="w";	// the dynamic statement to be eval-ed into the week counters cell. e.g. "'week '+w" will show "week 1" for the first week of a year.

var gsImg=null;		// default tag string to be used for every non-agenda day, usually an image tag.
var gbHidePadding=false;	// hide the days of non-current months
var gbCrossPast=false;	// line-through all the past dates
var gbMarkSelected=true;	// mark the selected date or not.


if (NN4) with (document.classes) {	// disable those unsupported CSS for NN4 so that it won't get misbehaved
	CalTop.all.paddings=function(){};
}
