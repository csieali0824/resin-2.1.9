<%
	String strURL = request.getRequestURL().toString();
	String historyURL = "Tsc1211SourceDataQuery.jsp";
	String style_a ="",style_b ="",style_c ="",style_aa ="",style_bb ="",style_cc ="";
	if (strURL.endsWith(historyURL))
	{ 
		style_a="font-weight:bold;font-size:16px;font-family:arial;background-color:#CCCC99";
		style_aa="color:#FFFFFF";
	}
	else
	{
		style_a="font-size:14px;background-color:#E0E0E0;color:#000099;font-family:arial";
		style_aa="color:#373737";
	}
	String DetailURL = "Tsc1211GenerateXmlAll.jsp";
	if (strURL.endsWith(DetailURL))
	{ 
		style_b="font-weight:bold;font-size:16px;font-family:arial;background-color:#99CCFF";
		style_bb="color:#FFFFFF";
	}
	else
	{
		style_b="font-size:14px;background-color:#E0E0E0;color:#000099;font-family:arial";
		style_bb="color:#373737";
	}
	String CreateURL = "Tsc1211ConfirmList.jsp";
	if (strURL.endsWith(CreateURL))
	{ 
		style_c="font-weight:bold;font-size:16px;font-family:arial;background-color:#669966";
		style_cc="color:#FFFFFF";
	}
	else
	{
		style_c="font-size:14px;background-color:#E0E0E0;color:#000099;font-family:arial";
		style_cc="color:#373737";
	}
	//out.println(strURL);
%>
<table width="100%"border="0" align="center" cellpadding="0" cellspacing="1">
	<TR>
    	<TD width="25%" height="25" style="font-family:arial;font-size:14px;background-color:#E0E0E0"><div align="center"><A HREF="../ORAddsMainMenu.jsp" style="color:#373737">回首頁</A></div></TD>
		<TD width="25%" style="<%=style_a%>"><div align="center"><A HREF="<%=historyURL%>" style="<%=style_aa%>">New BufferNet原始資料查詢</A></div></TD>
  		<TD width="25%" style="<%=style_b%>"><div align="center"><A HREF="<%=DetailURL%>" style="<%=style_bb%>">PackingList待處理資料</A></div></TD>
		<TD width="25%" style="<%=style_c%>"><div align="center"><A HREF="<%=CreateURL%>" style="<%=style_cc%>">PackingListNumber轉1211訂單</A></div></TD>
	</TR>
</TABLE>
