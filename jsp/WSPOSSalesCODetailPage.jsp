<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean,RsBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============??????????==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp/"%>
<!--%@ include file="/jsp/include/ConnectionPOSPoolPage.jsp/"%-->
<!--=================================-->
<jsp:useBean id="rsBean" scope="session" class="RsBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>POS System Sales Daily BPCS CO Maintenance History</title>
</head>
<body>
<FORM ACTION="../jsp/WSPOSSalesCODetailPage.jsp" METHOD="post" NAME="MYFORM">
  <div align="center">
    <%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;   
  %>
    <%
    String bpcsItemNo =request.getParameter("BPCSITEMNO");
    //String bpcsLine =request.getParameter("BPCSLINE");  
    String salQty =request.getParameter("SALQTY"); 
    String salDate =request.getParameter("SALDATE"); 
  %>
    <font color="#000099" size="+2" face="Times New Roman, Times, serif"><strong>BPCS CUSTOMER ORDER HISTORY</strong></font> </div>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr bgcolor="#FFFFCC">          		  
          <td width="8%"  height="19" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>LORD</strong></font></td>
          <td width="6%" bgcolor="#FF0000"  nowrap><font color="#FFFFFF" size="2"><strong>LLINE</strong></font></td>
		  <td width="10%" bgcolor="#FF0000"  nowrap><font color="#FFFFFF" size="2"><strong>LNET</strong></font></td>		  
		  <td width="5%" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>LQORD</strong></font></td>
          <td width="8%" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>TTYPE</strong></font></td>
		  <td width="10%" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>LWHS</strong></font></td>
		  <td width="8%" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>TLOCT</strong></font></td>
          <td width="8%" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>CLENUS</strong></font></td>
          <td width="9%" bgcolor="#FF0000" nowrap><font color="#FFFFFF" size="2"><strong>ENTRY DATE TIME</strong></font></td>          
        </tr>
          <%  
             try
            {               
               
              Statement stateBPCS=ifxdistcon.createStatement();  // ??BPCS??? //          
			 
              String sqlBPCSCO =   "select DISTINCT LORD, LLINE, LNET, LQORD, TTYPE, LWHS, TLOCT, CLENUS, HEDTE||CHENTM  as ENTRDT "+			                       
			                       "from ECL, ECH, ITH ";
			  String sWhereBPCS = "where HID='CZ' and LID='ZL' and HORD=LORD and LORD=TREF and LWHS=TWHS and TTYPE in('B','RM') and LWHS='90' and TLOCT='N001' "+
                                  "and LPROD='"+bpcsItemNo+"' and  abs(LQORD)='"+salQty+"' "+
                                  "and ( LRDTE='"+salDate+"' ) and TTDTE= '"+salDate+"' ";
				
			   
			  String sOrderBPCSCO = "order by ENTRDT desc ";
 
              sqlBPCSCO = sqlBPCSCO + sWhereBPCS + sOrderBPCSCO;
              //out.println(sqlBPCSCO);  
              ResultSet rsTC=stateBPCS.executeQuery(sqlBPCSCO);              
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;   
              while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		        
         
        %>  
       <tr bgcolor="#FFFFCC">	    
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("LORD") %></font></td>	
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("LLINE") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("LNET") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("LQORD") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("TTYPE") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("LWHS") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("TLOCT") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("CLENUS") %></font></td>
        <td height="20"><font size="2" color="#000099"><%=rsTC.getString("ENTRDT") %></font></td>     
       </tr>
        <%
               rs1__index++;	   
               rs_hasDataTC = rsTC.next();	   
             }	        
	          rsTC.close();
	          stateBPCS.close();
          } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
        %>       
  </table>
</FORM>
</body>
<!--=============??????????==========-->
<!--%@ include file="/jsp/include/ReleaseConnPOSPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<!--=================================-->
</html>
