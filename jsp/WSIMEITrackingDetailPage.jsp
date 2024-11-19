<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<!--=============¥H?U°I?q?°|w¥t?{AO?÷‥i==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============¥H?U°I?q?°‥u±o3sμ2|A==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<title>IMEI TRACKING DETAIL PAGE</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<body>
<%
   String agentName =request.getParameter("AGENTNAME"); 
   String imei =request.getParameter("IMEI"); 
%>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;<A HREF="/wins/jsp/WSIMEITrackingInquiry.jsp?IMEI=<%=imei%>&AGENTNAME=<%=agentName%>">Previous Page</A>
<BR>
<BR>
 <%
	     //out.println("agentName="+agentName);
		 if ( imei!=null && !imei.equals("--")  )
	     //if ( agentName!=null || !agentName.equals("") )
		 {
		    try
            {               
              Statement statementH=con.createStatement();  
  
              String sqlH =  "select  to_number(substr(a.AGENTNO,5,3)) as IN_QTY, a.AGENTNAME, a.AGENTTEL, a.AGENTFAX, a.AGENTADDR, "+
			                                     "a.AGENT_UNITNO, a.CONTACTMAN, c.IMEI, c.MODEL_NAME, c.IN_STATION_TIME, c.MCARTON_NO, "+
												 "b.IN_USER, to_date(b.IN_DATETIME,'YYYY/MM/DD hh24miss') as IN_DATETIME "+
			                          "from WSCUST_AGENT a, IMEI_TRACKING b, MES_WIP_TRACKING c ";
			  String sWhereH = "where a.AGENTNAME=b.CUST_NAME and b.IMEI = c.IMEI and a.AGENTNAME !='0'  ";				                    
			   if (agentName == null || agentName.equals("--")) { sWhereH = sWhereH + "and a.AGENTNAME != '0'  "; }
			   else { sWhereH = sWhereH + "and a.AGENTNAME ='"+agentName+"'  "; }
			   if (imei == null || imei.equals("")) { sWhereH = sWhereH + "and b.IMEI > '0'  "; }
			   else { sWhereH = sWhereH + "and b.IMEI = '"+imei+"' "; }
			   sqlH = sqlH + sWhereH ;
			  		             
              ResultSet rsH=statementH.executeQuery(sqlH);
			  if (rsH.next())
			  {
	           
	/*	      }
			  rsH.close();
			  statementH.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   				
	    } // end of if
	*/
   %>	
   <table width="100%" border="1" cellpadding="1" cellspacing="1">
     <tr>
       <td bgcolor='#FFFFCC'  colspan="1" ><font color='#000000' face='Arial Black'>IMEI</font></td>
       <td bgcolor='#FFFFCC'  colspan="3" >      
            <%out.println(rsH.getString("IMEI"));%>
       </td>
    </tr>
   
	   <tr>
       <td bgcolor='#FFFFCC'  nowrap colspan="1"><font color='#000000' face='Arial Black'>IN USER</font></td>
       <td bgcolor='#FFFFCC'  nowrap colspan="3">
             <%out.println(rsH.getString("IN_USER"));%>
       </td>
      </tr>
     <tr>
       <td bgcolor='#FFFFCC'  nowrap colspan="1"><font color='#000000' face='Arial Black'>IN DATETIME</font></td>
       <td bgcolor='#FFFFCC'  nowrap colspan="3"><%out.println(rsH.getString("IN_DATETIME"));%></td>      
     </tr>
     <tr>
       <td bgcolor='#FFFFCC'  nowrap><font color='#000000' face='Arial Black'>ITEM NO.</font>
             <%out.println("<font color='#000066' face='Arial'>"+rsH.getString("MODEL_NAME")+"</font>");%>
       </td>
       <td bgcolor='#FFFFCC'  nowrap><font color='#000000' face='Arial Black'>PACKING TIME</font>
             <%out.println("<font color='#000066' face='Arial'>"+rsH.getString("IN_STATION_TIME")+"</font>");%>
       </td>
       <td bgcolor='#FFFFCC' colspan="2"  nowrap><font color='#000000' face='Arial Black'>CARTON NO.</font>
            <%out.println("<font color='#000066' face='Arial'>"+rsH.getString("MCARTON_NO")+"</font>");%>
       </td>
     </tr>
   </table>
   <%     // 列印代理商/客戶資訊//
                out.println("<table width='100%'><tr><td width='30%' bgcolor='#CC3333' ><font color='#FFFFFF' face='Arial Black'>AGENT<input name='AGENTNAME' type='text' value="+rsH.getString("AGENTNAME")+" size='30' maxlength='20'></font></td>");
		        out.println(" <td width='20%' bgcolor='#CC3333'  ><font color='#FFFFFF' face='Arial Black'>TEL<input name='TEL' type='text' value="+rsH.getString("AGENTTEL")+" size='15' maxlength='20'></font></td>");
		        out.println(" <td width='20%' bgcolor='#CC3333'  ><font color='#FFFFFF' face='Arial Black'>FAX<input name='FAX' type='text' value="+rsH.getString("AGENTFAX")+" size='15' maxlength='20'></font></td>");
		        out.println("<td width='15%' bgcolor='#CC3333' nowrap><font color='#FFFFFF' face='Arial Black'>UNIT NO.<input name='UNITNO' type='text' value="+rsH.getString("AGENT_UNITNO")+" size='10' maxlength='10'></font></td>");
		        out.println("<td width='5%' bgcolor='#CC3333' ><font color='#FFFFFF' face='Arial Black'>CONTACT<input name='CONTACT' type='text' value="+rsH.getString("CONTACTMAN")+" size='15' maxlength='20'></td></font></tr>");
		        out.println("<tr><td colspan='4' bgcolor='#CC3333'  ><font color='#FFFFFF' face='Arial Black'>AGENT ADDRESS<input name='AGADDRESS' type='text' value="+rsH.getString("AGENTADDR")+" size='70' maxlength='80'></font></td>");
		        out.println("<td width='5%' bgcolor='#CC3333' ><font color='#FFFFFF' face='Arial Black'>INPUT QTY.<input name='INPUTQTY' type='text' value="+rsH.getString("IN_QTY")+" size='10' maxlength='10'></font></td> </tr></table> ");
          }
			  rsH.close();
			  statementH.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   				
	    } // end of if
   %>
 <%// 表單參數 //%>
 <input name="IMEI" type="hidden" value="<%=imei%>"> 
 <input name="AGENTNAME" type="hidden" value="<%=agentName%>">
 <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSIMEITrackingEditCommit.jsp?IMEI=<%=imei%>&AGENTNAME=<%=agentName%>")'> 
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/WSIMEITrackingInquiry.jsp")'>
</body>
</html>
