<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="java.io.*,DateBean" %>
<html>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<style type="text/css">
<!--
.style5 {
	font-size: 24px;
	font-family: Arial, Helvetica, sans-serif;	
}
.style1 {
	font-size: 18px;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
}
.style2 {
	font-size: 18px;
	font-family: Arial, Helvetica, sans-serif;	
}
-->
</style>
</head>
<%
 //thisDateBean.setDate(2004,9,1);
 dateBean.setDate(thisDateBean.getYear(),thisDateBean.getMonth(),1);
 int dateValue=0;
 
 String dateArray[]={"100","","","","","","60","","","","","","","","","300","","","","","","","80","","","","","","","","159"};
%>
<body>
<TABLE width="570" border=1>
        <TBODY>
        <TR>
          <TD bgColor=#000080 colSpan=7><FONT color=#ffffff><span class="style5"><%out.println(thisDateBean.getYearString());%>年<%out.println(thisDateBean.getMonthString());%>月</span></FONT>		  </TD></TR>
        <TR align=middle bgColor=#e0e0e0>
          <TD width=54>日</TD>
          <TD width=54>一</TD>
          <TD width=54>二</TD>
          <TD width=54>三</TD>
          <TD width=54>四</TD>
          <TD width=54>五</TD>
          <TD width=54>六</TD></TR>
		  <%		 
		   for (int i=1;i<7;i++)
		   {
			 if (dateBean.getMonth()==thisDateBean.getMonth()) //如果是仍在月內則可新增一週
			 {	
			   out.println("<TR align=middle bgColor=white>");		  
		         for (int k=1;k<8;k++)
				 {				    
					if (dateBean.getDayOfWeek()==k && dateBean.getMonth()==thisDateBean.getMonth()) //填入相對應日期
					{	
					  if (dateBean.getYearMonthDay().equals(thisDateBean.getYearMonthDay())) //若為今天日期,則格子背景顏色變掉
					  {
					    out.println("<TD bgcolor='#00ffff'>");
					  } else {
					    out.println("<TD>");
					  }	
					  if (k==1 || k==7) //若為星期日或六則為紅字
					  {
						 out.println("<span class='style1'><FONT color=RED>"+dateBean.getDay()+"</FONT></span>"); 
					  } else {				   					 
					     out.println("<span class='style1'>"+dateBean.getDay()+"</span>");
					  }
					  if (!dateArray[dateValue].equals(""))	//當天若有內容時
					  {
					    out.println("<BR><div align='right' style='background-color:LIGHTBLUE'><FONT color=BLUE><span class='style2'>"+dateArray[dateValue]+"</span></font></div>");	
					  }	else {
					    out.println("<BR>&nbsp;");
					  }
					  dateBean.setAdjDate(1);
					  dateValue++;		
					  out.println("</TD>");			  				  
					} else {
					  out.println("<TD>&nbsp;</TD>");
					}									     					 				 
				 }	                
		       out.println("</TR>");			   
			 } //END OF dateBean.getMonth()==thisDateBean.getMonth() 如果是仍在月內則可新增一週 IF 
		   } //enf of i for loop
		  %>      
</TBODY>
</TABLE>
<BR>
</body>
</html>
