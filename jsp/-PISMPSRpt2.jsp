<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="java.io.*,DateBean" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<style type="text/css">
<!--
.style5 {
	font-size: 18px;
	font-family: Arial, Helvetica, sans-serif;	
}
.style15 {font-size: 12px; font-weight: bold;}
.style16 {	font-size: 16px;
	font-weight: bold;
}
.style17 {font-size: 24px}
.style21 {
	font-size: 12px;
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
}
.style22 {color: #FFFF00}
.style24 {
	font-size: 14px;
	font-family: Arial, Helvetica, sans-serif;
}
.style27 {
	font-family: "Courier New", Courier, mono;
	font-weight: bold;
	color: #FF0000;
	font-size: 12px;
}
.style28 {color: #0000FF}
.style29 {color: #333333}
-->
</style>
</head>
<%
	 String MONTH=request.getParameter("MONTH");     	 
	 String YEAR=request.getParameter("YEAR");      	 
     String Model=request.getParameter("MODELNO"); 
	 String Date=""; 
	 String Day=""; 
     String sQty=""; 
	 int Qty=0; 
	 //DecimalFormat df=new DecimalFormat(",000"); 
     String sqlGlobal = "";

 //thisDateBean.setDate(2004,9,1);
 dateBean.setDate(thisDateBean.getYear(),thisDateBean.getMonth(),1);
  int dateValue=0; 				
 //String dateArray[]=new String [31];			  
String dateArray[]={"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""};
String t_qty="";
 
%>
  <body>
  <%      
	     try
            { 
                Statement statementTC=dmcon.createStatement();     

              String sqlTC =  "Select  MODEL,SUM(QTY) AS sqty "+" "+   
			                          "FROM  mps " +" ";
			  //String sWhereTC = "where substr(LAUNCH_DATE,1,6) <= '"+ymCurr+"'  ";
			  String sWhereTC = " WHERE MODEL= '"+Model+"' GROUP BY MODEL ";

			
			 /* if (YEAR== null || YEAR.equals("")) { sWhereTC = sWhereTC + " substr(M_DATE,1,4)= '"+dateBean.getYearString()+"'  "; }
			  else { sWhereTC = sWhereTC + " substr(M_DATE,1,4)= '"+YEAR+"'  "; }  
			  if (MONTH== null || MONTH.equals("")) { sWhereTC = sWhereTC + "AND substr(M_DATE,6,2)= '"+dateBean.getMonthString()+"'  "; }
			  else { sWhereTC = sWhereTC + "AND  substr(M_DATE,6,2)= '"+MONTH+"'  "; }            */         			             
            
			  String sOrderTC = " ";
             
			  sqlTC = sqlTC + sWhereTC + sOrderTC;			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);		
			 
			               if (rsTC.next()) 
		                     {		 	        		     		  
           
					     
                 %>
            <span class="style15"><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>  
			<span class="style14"><font color="#000000" size="+2"><strong>
			<% 
                     
					     out.println(rsTC.getString("MODEL")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
            </span>            <span class="style15"><font color="#FF3300"><span class="style16"><font color="#000000" face="Times New Roman">生產計劃報表</font></span></font></span>
			<%                  				 				 				 				 
                    try
                   { 
					 String  sSqlL = "Select m_date,m_day,qty,substr(M_DATE,9,2) as dayofmonth  from mps ";		  
		             String sWhereL = "WHERE MODEL= '"+rsTC.getString("MODEL")+"' AND  substr(M_DATE,1,4)= '"+thisDateBean.getYearString()+"' AND  substr(M_DATE,6,2)= '"+thisDateBean.getMonthString()+"' order by M_DATE"  ;    		              
		             sSqlL = sSqlL+sWhereL;
					// out.println(sSqlL);
                     Statement docstatement=dmcon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     while (docrs.next()) 
					 { 					    
					     if ( docrs.getString ("qty")!=null)
						 {
					        t_qty= docrs.getString ("qty");
						 } else {
						   t_qty="";
						 }
					       dateArray[Integer.parseInt( docrs.getString ("dayofmonth"))-1] = t_qty; 													   
					  } //end of docrs while
					 		 	   
	                 docstatement.close();
                     docrs.close(); 	   
                     } //end of try
                     catch (Exception e)
                  {
                   out.println("Exception:"+e.getMessage());
                  }	   	
				  %>	     
				
					      
			<TABLE  border=1>
        <TBODY>
        <TR>
          <TD bgColor=#000080 colSpan=7><FONT color=#ffffff><span class="style5"><%out.println(thisDateBean.getYearString());%>
                <strong>年</strong>
          <%out.println(thisDateBean.getMonthString());%>
          <strong>月</strong></span></FONT>		  <FONT color=#ffffff><span class="style21"> &nbsp; &nbsp;   計劃生產量總計：</span></FONT><span class="style21"><span class="style22">
          <% 
                     
					     out.println(rsTC.getString("sqty")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
</span></span>                    </TD>
          </TR>
        <TR align=middle bgColor=#e0e0e0>
          <TD width=50><div align="center"><strong>日</strong></div></TD>
          <TD width=50><div align="center"><strong>一</strong></div></TD>
          <TD width=50><div align="center"><strong>二</strong></div></TD>
          <TD width=50><div align="center"><strong>三</strong></div></TD>
          <TD width=50 bgcolor="#e0e0e0"><div align="center"><strong>四</strong></div></TD>
          <TD width=50><div align="center"><strong>五</strong></div></TD>
          <TD width=50><div align="center"><strong>六</strong></div></TD></TR>
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
					    if (k==1 || k==7) //若為星期日或六則為紅字
					    {
						  out.println("<TD> <span class='style1'><FONT color=RED><strong>"+dateBean.getDay()+"</strong></FONT></span>"); 
					    } else {				   					 
					      out.println("<TD> <span class='style1'><strong>"+dateBean.getDay()+"</strong></span>");
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
               }//end if
               rsTC.close();
	          statementTC.close();
             } //end of try
             catch (Exception e)
           {
            out.println("Exception:"+e.getMessage());
          }   
      %>     
				
</TABLE>
            
  <span class="style24"><span class="style27"><span class="style29">*</span>日期下方<span class="style28">藍色數字</span>表示當日計劃生產量</span><BR>
  </span>  
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
