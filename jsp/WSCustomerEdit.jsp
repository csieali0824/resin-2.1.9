<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>WINS System - Sales Edit Page</title>
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
<strong> Change Salesperson Edit Page</strong></font> 
<% //out.println("step0");    %>
<FORM ACTION="WSCustomerMaintenance.jsp" METHOD="post" NAME="MYFORM">
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     String ssal=request.getParameter("SSAL");  
	 String ssal2=request.getParameter("SSAL2");   
     String sname=request.getParameter("SNAME");
     String ccust=request.getParameter("CCUST");
     String cnme=request.getParameter("CNME"); 
	 String clusr=request.getParameter("CLUSR"); 
	 
     
    
%>
  <table width="100%" border="0">
    <tr bgcolor="#000066">
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>Salesperson's 
        ID </strong></font><font color="#FFFFFF" face="Arial"><strong> : </strong></font><font color="#FF3366" face="Arial"><strong><%=ssal%></strong></font></td>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>Salesperson's 
        Name </strong></font><font color="#FFFFFF" face="Arial"><strong> : </strong></font><font color="#FF3366" face="Arial"><strong><%=sname%></strong></font></td>
      <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=bpcscon.createStatement(); 
	  
      sqlGlobal =  "select ssal,sname,ccust,cnme,clusr "+
			                  " from rcm,ssm";
      String sWhereTC = " where ssal=csal  ";
      if (sname == null || sname.equals("--")) { sWhereTC = sWhereTC ; }
			  else { sWhereTC = sWhereTC + "and SNAME ='"+sname+"'  "; }	
         
			  
			  
      
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step7 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {
     %>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>Customer's 
        ID</strong></font><font color="#FFFFFF" face="Arial"><strong>: </strong></font><font color="#FF3366" face="Arial"><strong><%=ccust%></strong></font> </td>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>Customer's 
        Name </strong></font><font color="#FFFFFF" face="Arial"><strong> : </strong></font><font color="#FF3366" face="Arial"><strong><%=cnme%></strong></font> </td>
    </tr>
  </table>  
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
   <tr>
     <td>&nbsp;</td>    
   </tr>
 </table>
  <table width="100%" border="1" cellpadding="1" cellspacing="1">
    <tr> 
      <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>Change 
        Salesperson's ID: </strong></font> </td>
      <td> <font size="2">
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		 	             		 
		  sSqlC = "select Unique ssal as x ,ssal||'('||sname||')' from ssm";		  
		  sWhereC= " order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=bpcscon.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (ssal2!=null && !ssal2.equals("--")) comboBoxBean.setSelection(ssal2);		  		  		  
	      comboBoxBean.setFieldName("SSAL2");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
    </tr>
  </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. USER : </font><font face="Arial"><%=clusr%></strong></font>    </td>    
  </tr>   
 </table> 
 
 <input name="SNAME" type="hidden" value="<%=sname%>">
 <input name="CCUST" type="hidden" value="<%=ccust%>">
 <input name="CNME" type="hidden" value="<%=cnme%>">  
 <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSCustomerMaintEditCommit.jsp?&SNAME=<%=sname%>&CCUST=<%=ccust%>&CNME=<%=cnme%>")'>
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/WSCustomerMaintenance.jsp?&SNAME=<%=sname%>&CCUST=<%=ccust%>&CNME=<%=cnme%>")'>
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
<!--=============¢FFFFDH?U¢FFFFXI?q?¢FFFFXAAcn3s¢FFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>