<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>WINS System - Sales Forecast Product Data Edit Page</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<style type="text/css">
<!--
.style2 {color: #000099}
-->
</style>
<head>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>WINS System Sales Forecast Labor Load(Rate VAT)Edit Page</strong></font>
<% //out.println("step0");    %>
<FORM ACTION="../jsp/WSProductCenterMaintenance.jsp" METHOD="post" NAME="MYFORM">
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     //String locale=request.getParameter("LOCALE");
     String region=request.getParameter("REGION");
     String country=request.getParameter("COUNTRY");        
     String interModel=request.getParameter("INTERMODEL");
     
     //out.println("step2");
    // String YearFr=request.getParameter("YEARFR");
    // String MonthFr=request.getParameter("MONTHFR");
	// String dateStringBegin=YearFr+MonthFr;
     //out.println("step3");
     String YearTo=request.getParameter("YEARTO");
     String MonthTo=request.getParameter("MONTHTO");
	// String dateStringEnd=YearTo+MonthTo;   
     //out.println("step4");  
    // out.println("step5 : sqlGlobal="+sqlGlobal);    
    
%>
 <table width="100%" border="0">
    <tr bgcolor="#000066">
     <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=con.createStatement(); 
      sqlGlobal =  "select DISTINCT REGION,COUNTRY,INT_MODEL,SYEAR,SMONTH,LBL_LOAD,EXRATE,VAT,MTDATE,MTUSER "+
			        "from PSALES_LBLRATE_VAT ";
      String sWhereTC = "where REGION IS NOT NULL ";

      if (region == null || region.equals("--")) { sWhereTC = sWhereTC + "and REGION != '0'  "; }
	  else { sWhereTC = sWhereTC + "and REGION ='"+region+"'  "; }                      			             
      if (country == null || country.equals("--")) { sWhereTC = sWhereTC + "and COUNTRY != '0'  "; }
	  else { sWhereTC = sWhereTC + "and COUNTRY = '"+country+"'  "; }
	  if (interModel == null || interModel.equals("--")) { sWhereTC = sWhereTC + "and INT_MODEL != '0'  "; }
	  else { sWhereTC = sWhereTC + "and INT_MODEL ='"+interModel+"'  "; }	
      if (YearTo == null || YearTo.equals("")) { sWhereTC = sWhereTC + "and SYEAR != '0'  "; }
	  else { sWhereTC = sWhereTC + "and SYEAR ='"+YearTo+"'  "; }	
      if (MonthTo == null || MonthTo.equals("")) { sWhereTC = sWhereTC + "and SMONTH != '0'  "; }
	  else { sWhereTC = sWhereTC + "and SMONTH ='"+MonthTo+"'  "; } 
          		
     // if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) >="+"'"+dateStringBegin+"' ";
     // if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";

      //sWhereTC = sWhereTC + "and b.TXDATE = '"+txDate+"' and b.TTICKETNO ='"+tTicketNo+"' and b.TOLINE ='"+toLine+"' and b.TXTIME='"+txTime+"' and b.TCOM='"+tCom+"' "; 
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step7 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {
     %>
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>REGION : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("REGION")%></strong></font> </td>  
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>COUNTRY : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("COUNTRY")%></strong></font> </td>      
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>INTERNAL MODEL : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("INT_MODEL")%></strong></font> </td>    
    </tr>    
    <tr bgcolor="#6699FF"> 
 </table>  
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
   <tr>
     <td>&nbsp;</td>    
   </tr>
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>YEAR /DATE : </strong></font> </td>
    <td> <%out.println(rs.getString("SYEAR")+"/"+rs.getString("SMONTH"));%> </td>
  </tr> 
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>LABOR
          LOAD  : </strong></font> </td>
    <td> <input name="LABORLOAD" type="text" value="<%=rs.getString("LBL_LOAD")%>" size="100%" maxlength="15"> </td>
  </tr>    
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>EXTRA
          RATE  : </strong></font> </td>
    <td> <input name="EXRATE" type="text" value="<%=rs.getString("EXRATE")%>" size="100%" maxlength="50"> </td>
  </tr>
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>VAT : </strong></font> </td>
    <td> <input name="VAT" type="text" value="<%=rs.getString("VAT")%>" size="100%" maxlength="50"> </td>
  </tr>    
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. USER : </font><font face="Arial"><%=rs.getString("MTUSER")%></strong></font>    </td>
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. DATE : </font><font face="Arial"><%=rs.getString("MTDATE").substring(0,8)%></strong></font>    </td> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. TIME : </font><font face="Arial"><%=rs.getString("MTDATE").substring(8,14)%></strong></font>    </td> 
  </tr>   
 </table> 
 <input name="INTERMODEL" type="hidden" value="<%=interModel%>"> 
 <input name="YEARTO" type="hidden" value="<%=YearTo%>">
 <input name="MONTHTO" type="hidden" value="<%=MonthTo%>">   
 
 <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSLaborRateVATMaintEditCommit.jsp?REGION=<%=region%>&COUNTRY=<%=country%>&INTERMODEL=<%=interModel%>&YEARTO=<%=YearTo%>&MONTHTO=<%=MonthTo%>")'> 
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/WSLaborRateVATMaintenance.jsp?REGION=<%=region%>&COUNTRY=<%=country%>&INTERMODEL=<%=interModel%>&YEARTO=<%=YearTo%>&MONTHTO=<%=MonthTo%>")'>
 <%
       rs.close();
       statement.close();
      }
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     }
  %>
</FORM>
</body>
<!--=============¢FFFDH?U¢FFFXI?q?¢FFFXAAcn3s¢FFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
