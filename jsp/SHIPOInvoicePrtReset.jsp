<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>WINS System - Distributor Gorss Margin Edit Page</title>
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
<strong>Shipping IPO Invoice System - Invoice Print Flag Reset</strong></font>
<% //out.println("step0");    %>
<FORM ACTION="../jsp/SHIPOInvoiceInquiry.jsp" METHOD="post" NAME="MYFORM">
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     //String locale=request.getParameter("LOCALE");
     String vndInvNo=request.getParameter("VNDINVNO");
     String invoiceNo=request.getParameter("INVOICENO");
     String vendor=request.getParameter("VENDOR");
     String shipWay=request.getParameter("SHIPWAY");
     String poNo=request.getParameter("PONO");
     String paymentTerm=request.getParameter("PAYMENTTERM");
     //out.println("step2");
        
     //out.println("step4");  
    // out.println("step5 : sqlGlobal="+sqlGlobal);    
    
%>
 <table width="100%" border="0">
    <tr bgcolor="#000066">
     <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=ifxdbexpcon.createStatement(); 
      sqlGlobal =  "select b.INVD, b.ILINE, b.VENDOR, b.VNDINV_NO, b.PORD, b.PLINE, b.PO_ECST, b.QTY, b.IPRODNO, a.INVDATE, a.SHIPPED_PER, a.INVH_PRT, a.VNALPH, a.HM_USER, a.HM_DATE, a.HM_TIME  "+
			       "from IPOINV_H a, IPOINV_D b ";
      String sWhereTC = "where a.HID= 'HO' and b.DID='DO' and a.INVH=b.INVD and a.VNDINV_NO=b.VNDINV_NO and a.VENDOR = b.VENDOR ";

      if (vendor == null || vendor.equals("--")) { sWhereTC = sWhereTC + "and b.VENDOR != 0  "; }
	  else { sWhereTC = sWhereTC + "and b.VENDOR ="+vendor+"  "; }
      if (shipWay == null || shipWay.equals("--")) { sWhereTC = sWhereTC + "and a.SHIPPED_PER != '0'  "; }
	  else { sWhereTC = sWhereTC + "and a.SHIPPED_PER ='"+shipWay+"'  "; }
      if (paymentTerm == null || paymentTerm.equals("--")) { sWhereTC = sWhereTC + "and a.PAYMENT_TERM != '0'  "; }
	  else { sWhereTC = sWhereTC + "and a.PAYMENT_TERM ='"+paymentTerm+"'  "; }             			             
      if (vndInvNo == null || vndInvNo.equals("")) { sWhereTC = sWhereTC + "and b.VNDINV_NO != '0'  "; }
	  else { sWhereTC = sWhereTC + "and b.VNDINV_NO = '"+vndInvNo+"'  "; }
      if (invoiceNo == null || invoiceNo.equals("")) { sWhereTC = sWhereTC + "and b.INVD != '0'  "; }
	  else { sWhereTC = sWhereTC + "and b.INVD = '"+invoiceNo+"'  "; }
      if (poNo == null || poNo.equals("")) { sWhereTC = sWhereTC + "and b.PORD != 0  "; }
	  else { sWhereTC = sWhereTC + "and b.PORD ="+poNo+"  "; }
     // if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) >="+"'"+dateStringBegin+"' ";
     // if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";

      //sWhereTC = sWhereTC + "and b.TXDATE = '"+txDate+"' and b.TTICKETNO ='"+tTicketNo+"' and b.TOLINE ='"+toLine+"' and b.TXTIME='"+txTime+"' and b.TCOM='"+tCom+"' "; 
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step7 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {
     %>
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>INVOICE NO. : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("INVD")%></strong></font> </td>  
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>VND. INVNO : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("VNDINV_NO")%></strong></font> </td> 
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>VENDOR NO : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("VENDOR")%></strong></font> </td> 
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>VENDOR NAME : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("VNALPH")%></strong></font> </td>    
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
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>INVOICE PRINT TIMES: </strong></font> </td>
    <td> 
      <input name="INVHPRT" type="text" value="<%=rs.getString("INVH_PRT")%>" size="100%" maxlength="3">	
    </td>
  </tr>             
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. USER : </font><font face="Arial"><%=rs.getString("HM_USER")%></strong></font>    </td>
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. DATE : </font><font face="Arial"><%=rs.getString("HM_DATE")%></strong></font>    </td> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. TIME : </font><font face="Arial"><%=rs.getString("HM_TIME")%></strong></font>    </td> 
  </tr>   
 </table> 
 <input name="INVOICENO" type="hidden" value="<%=invoiceNo%>"> 
 <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/SHIPOInvoicePrtResetCommit.jsp?INVOICENO=<%=invoiceNo%>")'> 
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/SHIPOInvoiceInquiry.jsp")'>
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
<!--=============¢FFFFFDH?U¢FFFFFXI?q?¢FFFFFXAAcn3s¢FFFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<!--=================================-->
</html>
