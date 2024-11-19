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
<strong> Price Segment Edit Page</strong></font>
<% //out.println("step0");    %>
<FORM ACTION="../jsp/WSPriceSegmentMaintenance.jsp" METHOD="post" NAME="MYFORM">
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     //String locale=request.getParameter("LOCALE");
     String region=request.getParameter("REGION");
     String country=request.getParameter("COUNTRY");   
     String brand=request.getParameter("BRAND");          
     String segment=request.getParameter("SEGMENT");
     //out.println("step2");
     String sgmntFr=request.getParameter("SGMNTFR"); 
     String sgmntTo=request.getParameter("SGMNTTO");   
     //out.println("step4");  
    // out.println("step5 : sqlGlobal="+sqlGlobal);    
    
%>
 <table width="100%" border="0">
    <tr bgcolor="#000066">
     <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=con.createStatement(); 
      sqlGlobal =  "select SREGION,SCOUNTRY,SG_BRAND,SEGMENT,SGMNT_FR,SGMNT_TO,GDATE,GUSER "+
			       "from PSALES_PRICE_SGMNT ";
      String sWhereTC = "where SREGION IS NOT NULL ";

      if (region == null || region.equals("--")) { sWhereTC = sWhereTC + "and SREGION != '0'  "; }
	  else { sWhereTC = sWhereTC + "and SREGION ='"+region+"'  "; }                      			             
      if (country == null || country.equals("--")) { sWhereTC = sWhereTC + "and SCOUNTRY != '0'  "; }
	  else { sWhereTC = sWhereTC + "and SCOUNTRY = '"+country+"'  "; }
	  if (brand == null || brand.equals("--")) { sWhereTC = sWhereTC + "and SG_BRAND != '0'  "; }
	  else { sWhereTC = sWhereTC + "and SG_BRAND ='"+brand+"'  "; }			
      if (segment == null || segment.equals("--")) { sWhereTC = sWhereTC + "and SEGMENT != '0'  "; }
	  else { sWhereTC = sWhereTC + "and trim(SEGMENT) = '"+segment+"'  "; }
     // if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) >="+"'"+dateStringBegin+"' ";
     // if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";

      //sWhereTC = sWhereTC + "and b.TXDATE = '"+txDate+"' and b.TTICKETNO ='"+tTicketNo+"' and b.TOLINE ='"+toLine+"' and b.TXTIME='"+txTime+"' and b.TCOM='"+tCom+"' "; 
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step7 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {
     %>
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>REGION : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("SREGION")%></strong></font> </td>  
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>COUNTRY : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("SCOUNTRY")%></strong></font> </td> 
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>BRAND : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("SG_BRAND")%></strong></font> </td>   
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
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>SEGMENT : </strong></font> </td>
    <td> 
      <%
         try
         {       
          String b[]={"1","2","3","4","5","6","7","8","9","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  /* 
          if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  } 
          */
          arrayComboBoxBean.setSelection(segment);     
	      arrayComboBoxBean.setFieldName("SEGMENT");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }    
      %>
    </td>
  </tr>  
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>SEGMENT
          FROM  :</strong></font> </td>
    <td> <input name="SGMNTFR" type="text" value="<%=rs.getString("SGMNT_FR")%>" size="100%" maxlength="11">	</td>
  </tr> 
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>SEGMENT TO  :  </strong></font> </td>
    <td> <input name="SGMNTTO" type="text" value="<%=rs.getString("SGMNT_TO")%>" size="100%" maxlength="11">    </td>
  </tr>           
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. USER : </font><font face="Arial"><%=rs.getString("GUSER")%></strong></font>    </td>
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. DATE : </font><font face="Arial"><%=rs.getString("GDATE").substring(0,8)%></strong></font>    </td> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. TIME : </font><font face="Arial"><%=rs.getString("GDATE").substring(8,14)%></strong></font>    </td> 
  </tr>   
 </table> 
 <input name="REGION" type="hidden" value="<%=region%>">
 <input name="COUNTRY" type="hidden" value="<%=country%>">  
 <input name="BRAND" type="hidden" value="<%=brand%>"> 
 <input name="SEGMENTUP" type="hidden" value="<%=segment%>">
 <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSPriceSegmentMaintEditCommit.jsp?REGION=<%=region%>&COUNTRY=<%=country%>&BRAND=<%=brand%>")'> 
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/WSPriceSegmentMaintenance.jsp?REGION=<%=region%>&COUNTRY=<%=country%>&BRAND=<%=brand%>")'>
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