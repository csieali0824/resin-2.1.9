<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="java.io.*,DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/>

<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>MPS</title>
</head>
<body>

<%
try { 
	String Model=request.getParameter("MODELNO"); 
	String sMONTH="";     	 
	String sYEAR="";      	 
	//String sDate=""; 
	int dateValue=0; 				
	String dateArray[]={"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""};
	String t_qty="";
	dateBean.setDate(thisDateBean.getYear(),thisDateBean.getMonth(),1);
	//dateBean.setDate(2004,12,1);
	//thisDateBean.setDate(2004,12,1);
 
%>
<%      

	String sqlTC = "Select MODEL,SUM(QTY) AS sqty "+ 
		" FROM  mps " +
		" WHERE MODEL= '"+Model+"' " + 
		" AND  substr(M_DATE,1,4)= '"+thisDateBean.getYearString()+"' "+
		" AND  substr(M_DATE,6,2)= '"+thisDateBean.getMonthString()+"' "+
		" GROUP BY MODEL ";  
	//out.println(sqlTC);

	Statement statementTC=dmcon.createStatement();     
	ResultSet rsTC=statementTC.executeQuery(sqlTC);		
		 
	if (rsTC.next()) { 	        		     		  
           
					     
%>
<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font><font color="#000000" size="+2" face="Times New Roman"><%out.println(rsTC.getString("MODEL")); %></font>
<font color="#000000" size="+2" face="Times New Roman">生產計劃</font>
<%                  				 				 				 				 
                    
		String sSqlL = "Select m_date,m_day,qty,substr(M_DATE,9,2) as dayofmonth  from mps " +
		" WHERE MODEL= '"+rsTC.getString("MODEL")+"' "+
		" AND  substr(M_DATE,1,4)= '"+thisDateBean.getYearString()+"' "+
		" AND  substr(M_DATE,6,2)= '"+thisDateBean.getMonthString()+"' "+
		" order by M_DATE"; 
		//out.println(sSqlL);
		Statement docstatement=dmcon.createStatement();
		ResultSet docrs=docstatement.executeQuery(sSqlL);
		while (docrs.next()) { 					    
			if ( docrs.getString ("qty")!=null) {t_qty= docrs.getString ("qty");} 
			else {t_qty="";}
			dateArray[Integer.parseInt( docrs.getString ("dayofmonth"))-1] = t_qty; 													   
		} //end of docrs while
	
		docstatement.close();
		docrs.close(); 	   
		
%>	     
				
					      
<TABLE  border=1>
	<tr>
		<td bgColor="#0072A8" colspan="2"><FONT color="#ffffff">資料更新日期時間</font></td>
		<td bgColor="#0072A8" colspan="5"><FONT color="#ffffff">
<%
	Statement stDt = dmcon.createStatement();
	ResultSet rsDt = stDt.executeQuery("SELECT MAX(LMDATE) AS MDATE FROM MPS WHERE MODEL= '"+Model+"' "+
		" AND  substr(M_DATE,1,4)= '"+thisDateBean.getYearString()+"' "+
		" AND  substr(M_DATE,6,2)= '"+thisDateBean.getMonthString()+"' ");
	if (rsDt.next()) { 
		String sDateTime = rsDt.getString("MDATE");
		String sDate = sDateTime.substring(0,4)+"/"+sDateTime.substring(4,6)+"/"+sDateTime.substring(6,8);
		String sTime = sDateTime.substring(8,10)+":"+sDateTime.substring(10,12);
		out.println(sDate+" "+sTime); 
	}
	rsDt.close();
	stDt.close();
	
%>	
			</font>
		</td>
	</TR>
<TBODY>
	<TR>
		<TD bgColor="#0072A8" colSpan=7>
			<FONT color="#ffffff">
			<span class="style5">
			<%out.println(thisDateBean.getYearString());%><strong>年</strong>
			<%out.println(thisDateBean.getMonthString());%><strong>月</strong>
			</span>
			</FONT>
			<FONT color="#ffffff"><span class="style21"> &nbsp; &nbsp; 計劃生產量總計：</span></FONT>
			<font color="#ffffff">
<% 
		if(rsTC.getString("sqty") ==null) {out.println(0); }
		else {  out.println(rsTC.getString("sqty")); }  
%>
			</font>
		</TD>
	</tr>
	<TR align="center" bgColor="#e0e0e0">
		<TD width=50><div align="center"><strong>日</strong></div></TD>
		<TD width=50><div align="center"><strong>一</strong></div></TD>
		<TD width=50><div align="center"><strong>二</strong></div></TD>
		<TD width=50><div align="center"><strong>三</strong></div></TD>
		<TD width=50 bgcolor="#e0e0e0"><div align="center"><strong>四</strong></div></TD>
		<TD width=50><div align="center"><strong>五</strong></div></TD>
		<TD width=50><div align="center"><strong>六</strong></div></TD></TR>
<%
		 
		     for (int i=1;i<7;i++) {
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
						  out.println("<span class='style1'><FONT color=RED><strong>"+dateBean.getDay()+"</strong></FONT></span>"); 
					    } else {				   					 
					      out.println("<span class='style1'><strong>"+dateBean.getDay()+"</strong></span>");
						}
					  if (!dateArray[dateValue].equals(""))	//當天若有內容時
					  {
					    out.println("<BR><div align='right' style='background-color:LIGHTBLUE'><FONT color=blue><span class='style1'><strong>"+dateArray[dateValue]+"</strong></span></font></div>");	
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
 	    
<%
		
			out.println("<tr><td colspan='7'><font face='Arial' size='-1'>*日期下方藍色數字表示當日計劃生產量</font></td></tr>");
		}//end if rsTC
		else { out.println("<font face='Arial' size='+2'>本月沒有生產排程紀錄</font>");
		}

		rsTC.close();
		statementTC.close();
		

} //end of try
catch (Exception e) {out.println("Exception:"+e.getMessage());}   
%>     
</TABLE>
<br>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
