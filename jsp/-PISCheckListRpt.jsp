<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %>
<%//@ page import="ComboBoxAllBean,DateBean"%>
<%//@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,javax.naming.*,java.util.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*,org.jCharts.*,org.jCharts.chartData.*,org.jCharts.properties.*,org.jCharts.types.ChartType.*,org.jCharts.axisChart.*,org.jCharts.test.TestDataGenerator.*,org.jCharts.encoders.JPEGEncoder13.*,org.jCharts.properties.util.ChartFont.*,org.jCharts.encoders.ServletEncoderHelper.*" %>
<%@ page import="DateBean,WorkingDateBean,ArrayComboBoxBean"%>

<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<!--%@ include file="/jsp/include/ConnMESPoolPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>PIS MPS REPORT</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<style type="text/css">
<!--
.style13 {font-size: 12px}
.style14 {
	color: #FFFF00;
	font-weight: bold;
}
.style15 {font-size: 12px; font-weight: bold;}
.style16 {
	font-size: 16px;
	font-weight: bold;
}
.style23 {color: #FFFFFF}
.style24 {color: #FFFFFF; font-weight: bold; }
.style28 {
	font-size: 16;
	color: #333333;
}
.style29 {font-size: 12px; font-weight: bold; color: #FFFFFF; }
.style31 {font-size: 12px; font-weight: bold; color: #FFFF00; }
.style36 {color: #993300}
.style39 {color: #333333}
.style40 {font-size: 12}
.style41 {font-size: 12; font-weight: bold; }
-->
</style>
</head>
<body>
<FORM ACTION="PISMPSRpt.jsp" METHOD="post" NAME="MYFORM">
  <div align="left">
    <table width="100%" border="0">
      <tr>
        <td>            <div align="left"><span class="style16"></span> 
            <%
   int rs1__numRows = 20000;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
            <% 
     
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
        
	   
	   
	 String MONTH=request.getParameter("MONTH");     	 
	 String YEAR=request.getParameter("YEAR");      	 
     String Model=request.getParameter("MODELNO"); 
	 String Name2=""; 
	 String Name3=""; 
	 String Status=""; 
	 String Desc=""; 
	 String Remark=""; 

	 //int Qty=0; 
	 //DecimalFormat df=new DecimalFormat(",000"); 
     String sqlGlobal = "";
	
  %>
  <%      
	     try
            { 
                Statement statementTC2=dmcon.createStatement();     

              String sqlTC2 =  "Select Distinct  MODELNO,PHASE,GDATE,QTY,CKHW,CKSW,CKRF,AUDIO,BATTERY,HOUSING"+" "+   
			                            "from mdcklist" +" ";
			  //String sWhereTC = "where substr(LAUNCH_DATE,1,6) <= '"+ymCurr+"'  ";
			  String sWhereTC2 = " WHERE MODELNO= '"+Model+"'  ";

			
			 /* if (YEAR== null || YEAR.equals("")) { sWhereTC = sWhereTC + " substr(M_DATE,1,4)= '"+dateBean.getYearString()+"'  "; }
			  else { sWhereTC = sWhereTC + " substr(M_DATE,1,4)= '"+YEAR+"'  "; }  
			  if (MONTH== null || MONTH.equals("")) { sWhereTC = sWhereTC + "AND substr(M_DATE,6,2)= '"+dateBean.getMonthString()+"'  "; }
			  else { sWhereTC = sWhereTC + "AND  substr(M_DATE,6,2)= '"+MONTH+"'  "; }            */         			             
            
			  String sOrderTC2 = " ";
             
			  sqlTC2 = sqlTC2 + sWhereTC2 + sOrderTC2;			  
			  //sqlGlobal = sqlTC2;
              //out.println(sqlTC);
              ResultSet rsTC2=statementTC2.executeQuery(sqlTC2);		
			 
			               if (rsTC2.next()) 
		                     {		 	        		     		  
           
					     
                 %>
            <span class="style15"><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
            <span class="style28">
            <% 
                     
					     out.println(rsTC2.getString("MODELNO")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
            </span>                        </span><strong>CHECK
            LIST</strong></div></td>
      </tr>
    </table>
  </div>
  <table width="100%" border="0" >
    <tr bgcolor="#CCFFFF" >
      <td  colspan="9"><span class="style15">階段:<span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("PHASE")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
    </tr>
    <tr bgcolor="#CCFFFF" >
      <td colspan="2"><span class="style15">產出日期</span></td>
      <td ><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("GDATE")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
      <td ><span class="style15">數量</span></td>
      <td ><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("QTY")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
      <td ><span class="style15">H/W Ver</span></td>
      <td ><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("CKHW")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
      <td ><span class="style15">S/W Ver</span></td>
      <td ><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("CKSW")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
    </tr>
    <tr bgcolor="#CCFFFF" >
      <td colspan="2"><span class="style15">RF Table</span></td>
      <td><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("CKRF")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
      <td><span class="style15">Audio Table</span></td>
      <td><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("AUDIO")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
      <td><span class="style15">Battery Table</span></td>
      <td><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("BATTERY")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></span></td>
      <td><span class="style15">Housing Ver</span></td>
      <td><span class="style15"><span class="style36">
        <% 
                     
					     out.println(rsTC2.getString("HOUSING")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
		 
      </span></span></td>
    </tr>
	 <%      
	     try
            { 
                Statement statementTC=dmcon.createStatement();     

              String sqlTC =  "Select  distinct ITEM,CKNAME1"+" "+   
			                          "from mdcklist" +" ";
			  //String sWhereTC = "where substr(LAUNCH_DATE,1,6) <= '"+ymCurr+"'  ";
			  String sWhereTC = " WHERE MODELNO= '"+rsTC2.getString("MODELNO")+"'  ";
			
			    			             
            
			  String sOrderTC = " ";
             
			  sqlTC = sqlTC + sWhereTC + sOrderTC;			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);		
			 
			               while (rsTC.next()) 
		                     {		 	        		     		  
           
					     
                 %>
    <tr >
	  <td  bgcolor="#99CCFF"><div align="center" class="style16 style40"><span class="style39">
	      <% 
                     
					     out.println(rsTC.getString("ITEM")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></div></td>
      <td width="10%" bgcolor="#99CCFF"><div align="center" class="style41"><span class="style39">
          <% 
                     
					     out.println(rsTC.getString("CKNAME1")); 
					     //Bamt=rsTC.getInt("beginamt");                       
          %>
      </span></div></td>
      <td  colspan="8">
        <div align="center">
          <table width="100%"  height="34" border="1" cellpadding="0" cellspacing="0">
            <tr bgcolor="#006699" >
              <td height="16" colspan="2"   nowrap class="style13"><div align="center"><span class="style14 style23"><span class="style15">名稱</span></span></div></td>
              <td   nowrap class="style29"><div align="center">PASS/FAIL</div></td>
              <td  class="style13"><div align="center" class="style24"><span class="style15">Description</span></div></td>
              <td  class="style13"><div align="center" class="style24"><span class="style15">Remark</span></div></td>
            </tr>
            <%
                    			     
				    try
		            { 
					   String  sSqlL = "Select CKNAME2,CKNAME3,STATUS,CKDESC,CKREMARK from mdcklist ";		  
		              String sWhereL = "WHERE MODELNO= '"+rsTC2.getString("MODELNO")+"' AND ITEM= '"+rsTC.getString("ITEM")+"' AND  CKNAME1= '"+rsTC.getString("CKNAME1")+"' "  ;    		              
		             sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=dmcon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     while (docrs.next()) 
					 { 					   
					   Name2=docrs.getString("CKNAME2"); 					
					   Name3=docrs.getString("CKNAME3"); 					
					   Status = docrs.getString("STATUS"); 					
					   Desc = docrs.getString("CKDESC"); 					
					   Remark = docrs.getString("CKREMARK");            
                 %>
            <tr bgcolor="#FFFFFF" >
              <td width="20%"  height="16" nowrap class="style13"><font color="#0000FF" face="Arial, Helvetica, sans-serif">
			  <%
			    if (Name2!=null ) { out.println(Name2); } 
                else { out.println("&nbsp;"); }
			 
			  %>
			  </font></td>
              <td width="15%"  nowrap class="style13"><font color="#0000FF" face="Arial, Helvetica, sans-serif">
			  <% if (Name3!=null ) { out.println(Name3); } 
                else { out.println("&nbsp;"); }
			 %></font></td>
              <td width="5%"   height="16" nowrap class="style13"><div align="center"><font color="#0000FF" face="Arial, Helvetica, sans-serif">
			  <%
			       if (Status!=null ) { out.println(Status); } 
                   else { out.println("&nbsp;"); }
			 %></font></div></td>
              <td width="30%"  class="style13"><div align="left"><font color="#0000FF" face="Arial, Helvetica, sans-serif">
			  <%  if (Desc!=null ) { out.println(Desc); } 
                   else { out.println("&nbsp;"); }%>
			  </font></div></td>
              <td width="30%"  class="style13"><div align="left"><font color="#0000FF" face="Arial, Helvetica, sans-serif">
			  <% if (Remark!=null ) { out.println(Remark); } 
                   else { out.println("&nbsp;"); }%>
				   </font></div></td>
            </tr>
            <%                       
                      }  // End of subWhile
                     
                      docrs.close();
                      docstatement.close();       
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }   
                %>
          </table>
      </div></td>
    </tr>
    <tr >
      <td  colspan="9" bgcolor="#006699"><div align="right"><span class="style31">      </span></div></td>
    </tr>
    <%
              rs1__index++;		 
			
	     }//endwhile
               rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
	   <%
		     } // end if 
				
			} // end of try
			catch (Exception e)
			{
				 out.println("Exception:"+e.getMessage());		  
			} 
			 %>
  </table>
  <p>
      <input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
  </p>
</FORM>
    
    <p>&nbsp; </p>
</body>
<!--=============以下區段為處理完成==========-->

<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

<!--=================================-->
</html>
