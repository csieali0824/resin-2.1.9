<%
'SQL
Function SqlStr(data)
   SqlStr = Replace ( data, "'", "''" )
   SqlStr = Replace ( SqlStr , "<", "&lt;")
   SqlStr = Replace ( SqlStr , ">", "&gt;")
   SqlStr = Replace ( SqlStr, """","&quot;")
End Function

Function backStr(data)
   backStr = Replace ( data, "''", "'" )
   backStr = Replace ( backStr , "&lt;", "<")
   backStr = Replace ( backStr , "&gt;", ">")
   backStr = Replace ( backStr, "&quot;", """")
End Function

Function ch_vbcrlf_br(data)
	ch_vbcrlf_br = Replace ( data , vbCrLf, "<br>")
End Function 
Function ch_br_vbcrlf(data)
	ch_br_vbcrlf = Replace ( data, "<br>" , vbCrLf)
End Function
Function ch_br_space(data)
	ch_br_space = Replace ( data, vbCrLf , "")
End Function

%>
<% Function js_alert(msg) %>
<Script Language="JavaScript">
<!--
	alert("<% = msg %>");
//-->
</Script>
<% End Function %>
   
<% Function js_back() %>
<Script Language="JavaScript">
<!--
	history.back();
//-->
</Script>
<% End Function %>

<% Function js_location(url) %>
<Script Language="JavaScript">
<!--
	document.location.href="<% = url %>";
//-->
</Script>

<% End Function %>

<Script Language="JavaScript">
<!--
	function trim(data){
		var data;
		for (var begin=0; begin<data.length; begin++)
			if (data.charAt(begin) != " " && data.charAt(begin) != "　") break;
		for (var end=data.length; end>0; end--)
			if (data.charAt(end-1) != " " && data.charAt(end-1) != "　") break;
		return data.slice( begin, end );
	}

	function FileWin(str,stype,svalue,spath,sname,sversion,sponum)
	{
	 if(form1.cust_po_num.value == ""){
      window.alert("It is empty of Po_number field!!");
      //
      document.form1.cust_po_num.focus();
      //
      return;
   }

	  w = 300;
	  h = 230;
	  fileName = "../tsc_euro_po/fileupload/fileupload.asp?f=" + str + "&p=" + spath + "&n=" + sname + "&t="  + stype + "&v=" + svalue + "&c=" + sversion + "&m=" + sponum ;
	
	  window.open(fileName,"FileUpload","width="+w+",height="+h+",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,titlebar=no,left="+(screen.width-w)/2+",top="+(screen.height-h-100)/2);
	}
	
	function FileView(spath,sname)
	{
		w = 270;
	    h = 200;
		FN = spath + "/" + sname;
		if ( sname != "" ) {
			pop=window.open(FN,"FileView","width="+w+",height="+h+",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,titlebar=no,left="+(screen.width-w)/2+",top="+(screen.height-h-100)/2);
			pop.focus();
		}
	}
	function noBorderWin(fileName,n,w,h,s)
	{
	  pop=window.open(fileName,n,"width="+w+",height="+h+",toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+s+",resizable=no,titlebar=no,left="+(screen.width-w)/2+",top="+(screen.height-h)/2);
	  pop.focus();
	}
	
	function returnwindow(filename,data){ //開新視窗傳回子視窗值
		var rn = Math.random()*(99)+1;
		var tmp2 = "ohlila" + Math.round(rn);
		var temp= "toolbar=no,directories=no,location=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=no,"
		temp = temp + data
		window.open(filename,tmp2,temp);	
		return (tmp2);
	}
//-->
</Script>