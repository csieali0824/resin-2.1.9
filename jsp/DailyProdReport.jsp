<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat"%>
<!--=============To get the Authentication==========-->
<%@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBean2" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DailyProdReport</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
</head>
<body>
<FORM ACTION="QcprodReport.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> <font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
    </font> 
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center"><strong><font color="#003333" size="5">每日生產良率</font> </strong> 
            <%
   int rs1__numRows = 2000;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
          </div></td>
      </tr>
    </table>
	<A HREF="../WinsMainMenu.jsp">HOME</A> 
    <% 
     
 
      String TYPE=request.getParameter("TYPE"); 
	  String DATE=request.getParameter("DATE");
	  String DATE2=request.getParameter("DATE2");
	  String sDateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  int nYear=dateBean.getYear()-1911;	  
	  String sYear=String.valueOf(nYear);	  
	   String sDate=sYear+dateBean.getMonthString()+dateBean.getDayString() ; 
	   //out.println(sDate); 
	  String WSUserID=(String)session.getAttribute("USERNAME");  
	  String sqlGlobal = "";
	  float  inqty=0; 
	  float  outqty=0; 
	  int  ngqty=0; 
	  float yieldrate=0; 
	  DecimalFormat df=new DecimalFormat("%00.00"); 
	 
	   if (DATE==null || DATE== "" || DATE.equals("")) 
	        {DATE=dateBean.getYearMonthDay(); }
			
		   
	    
	   
     //if (TYPE==null || TYPE.equals("")) {  TYPE= "未兌現";}
    
	 
  %>
    <table width="100%" border="1">
      <tr bgcolor="#0F87FF"> 
        <td width="78%" height="26"><font color="#FFFF00"><strong>Date： </strong></font> 
          <font color="#FF0066" face="Arial Black"> 
          <input name="DATE" type="text" size="10" 
		<% if (DATE==null || DATE== "" || DATE.equals("")) 
		    { out.println("value="+dateBean.getYearMonthDay()); }
		   else  
		   { out.println("value="+DATE); }																																							       		
		%>			
		>
          </font><font size="2" color="#000099"> 
          <input name="button2" type="button" onClick='setSubmit("../jsp/DailyProdReport.jsp")'  value="Query" >
          </font><font color="#FF0066" face="Arial Black">&nbsp; </font></td>
      </tr>
    </table>
    <table width="100%" border="1">
      <tr> 
        <td bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>Date</strong><br>
            </font><font size="2"><strong></strong></font></div></td>
        <td bgcolor="#3300FF"><div align="center"><font size="2"><strong><font color="#FFFFFF">MODEL</font></strong></font><br>
          </div></td>
        <td width="10%" bgcolor="#3300FF"> <div align="center"><font size="2"><strong><font color="#FFFFFF">LINE<br>
            </font></strong></font></div></td>
        <td width="8%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>STATION</strong></font></div></td>
        <td width="7%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>QTY_IN 
            </strong><br>
            </font></div></td>
        <td width="7%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>QTY_OUT</strong></font></div></td>
        <td width="7%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>N/G<br>
            </strong></font></div></td>
        <td width="8%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>Yield<br>
            </strong></font></div></td>
      </tr>
      <%      
	     try
            {  
             
              Statement statementTC=dmcon.createStatement();    
               String sqlTC =  "SELECT GENDATE,MODELNO,LINENUM,STANUM,INQTY,OUTQTY"+" "+
			                           "FROM dailyprod"+" ";
			    String sWhereTC = "WHERE  ";
				 if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + " GENDATE <=" +dateBean.getYearMonthDay()+" " ; }
			     else 
				  { sWhereTC = sWhereTC +  " GENDATE <=" +DATE+" "     ; }
			   String sOrderTC="order by GENDATE"; 
			    sqlTC = sqlTC + sWhereTC+sOrderTC ;
			  
			    sqlGlobal = sqlTC;              
			  // out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);	          
		  		  
			  while (rsTC.next()) 
		     {		    
			    
        %>
      <tr bordercolor="#0000FF" bgcolor="#FFFFFF"> 
        <td width="4%"> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("GENDATE")!=null ) { out.println(rsTC.getString("GENDATE")); } 
                      else { out.println("&nbsp;"); }
            %>
            </font></div></td>
        <td width="9%"><font size="2" color="#000099">
          <% 
                      if (rsTC.getString("MODELNO")!=null ) { out.println(rsTC.getString("MODELNO")); } 
                      else { out.println("&nbsp;"); }
            %>
          </font> 
          <div align="center"><font size="2" color="#000099"> </font></div></td>
        <td> <div align="center"><font size="2" color="#000099">
            <% 
                      if (rsTC.getString("LINENUM")!=null ) { out.println(rsTC.getString("LINENUM")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("STANUM")!=null ) { out.println(rsTC.getString("STANUM")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <%     inqty=rsTC.getFloat("INQTY"); 
                      if (rsTC.getInt("INQTY")!=0 ) { out.println(rsTC.getInt("INQTY")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <%     
                      if (rsTC.getInt("OUTQTY")!=0) { out.println(rsTC.getInt("OUTQTY")); } 
                      else { out.println("&nbsp;"); }
					  outqty=rsTC.getFloat("OUTQTY"); 
			          ngqty=rsTC.getInt("INQTY")-rsTC.getInt("OUTQTY"); 
					  yieldrate=(outqty / inqty); 
					  //out.println(outqty); 
					  //out.println(yieldrate); 
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <%    out.println(ngqty);                      
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <%    out.println(df.format(yieldrate));                      
          %>
            </font></div></td>
      </tr>
      <%     }//end of while	     
	 
	          rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
    </table>
    
	
    <p>
<input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
    </p>
  </div>
  <p>
 
  </p>  
</FORM>   
    
<p><font size="2" color="#000099"> </font> </p>
  </body>
  <!--=============以下區段為處理完成==========-->
  <%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
