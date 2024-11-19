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
<title>WINS System - Forecast COGS Edit Page</title>
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
<strong> Forecast COGS Edit Page</strong></font>
<% //out.println("step0");    %>
<FORM ACTION="../jsp/WSForecastCogsMaintenance.jsp" METHOD="post" NAME="MYFORM">
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     //String locale=request.getParameter("LOCALE");
     String comp=request.getParameter("FCCOMP");
     String type=request.getParameter("FCTYPE");
     String region=request.getParameter("FCREG");
     String country=request.getParameter("FCCOUN"); 
	 String curr=request.getParameter("FCCURR");
     String model=request.getParameter("FCPRJCD");
     String year=request.getParameter("FCYEAR");
     String month=request.getParameter("FCMONTH"); 
	 String version=request.getParameter("FCMVER"); 
     //out.println("step2");
        
     //out.println("step4");  
    // out.println("step5 : sqlGlobal="+sqlGlobal);    
    
%>
  <table width="100%" border="0">
    <tr bgcolor="#000066"> 
      <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=con.createStatement(); 
      sqlGlobal =  "select FCCOMP,FCREG,FCCOUN,FCCURR,FCPRJCD,FCCOGS,FCYEAR,FCMONTH,FCTYPE,FCLUSER,FCMVER  "+
			       "from psales_fore_cogs ";
      String sWhereTC = "where FCMVER=(select max(FCMVER) from psales_fore_cogs) and FCPRJCD IS NOT NULL ";
       
	         
	  if (comp == null || comp.equals("--")) { sWhereTC = sWhereTC ; }
	  else { sWhereTC = sWhereTC + "and FCCOMP ='"+comp+"'  "; }
      if (type == null || type.equals("")) { sWhereTC = sWhereTC ;}
	  else { sWhereTC = sWhereTC + "and FCTYPE = '"+type+"'  "; } 
      if (region == null || region.equals("--")) { sWhereTC = sWhereTC ; }
	  else { sWhereTC = sWhereTC + "and FCREG ='"+region+"'  "; }                      			             
      if (country == null || country.equals("--")) { sWhereTC = sWhereTC ; }
	  else { sWhereTC = sWhereTC + "and FCCOUN = '"+country+"'  "; }
	  if (curr == null || curr.equals("--")) { sWhereTC = sWhereTC ; }
	  else { sWhereTC = sWhereTC + "and FCCURR = '"+curr+"'  "; }
	  if (model == null || model.equals("--")) { sWhereTC = sWhereTC ; }
	  else { sWhereTC = sWhereTC + "and FCPRJCD = '"+model+"'  "; }
	  if (year == null || year.equals("--")) { sWhereTC = sWhereTC ;}
	  else { sWhereTC = sWhereTC + "and FCYEAR = '"+year+"'  "; }
	  if (month == null || month.equals("--")) { sWhereTC = sWhereTC ;}
	  else { sWhereTC = sWhereTC + "and FCMONTH = '"+month+"'  "; }
	 
     // if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) >="+"'"+dateStringBegin+"' ";
     // if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";

      //sWhereTC = sWhereTC + "and b.TXDATE = '"+txDate+"' and b.TTICKETNO ='"+tTicketNo+"' and b.TOLINE ='"+toLine+"' and b.TXTIME='"+txTime+"' and b.TCOM='"+tCom+"' "; 
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step7 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {
     %>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>Company 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCCOMP")%></strong></font> </td>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>Type 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCTYPE")%></strong></font> </td>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>REGION 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCREG")%></strong></font> </td>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>COUNTRY 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCCOUN")%></strong></font> </td>
    </tr>
    <tr bgcolor="#000066"> 
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>Currency 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCCURR")%></strong></font> </td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>Model 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCPRJCD")%></strong></font> </td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>Year 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCYEAR")%></strong></font> </td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>Month 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCMONTH")%></strong></font> </td>
    </tr>
    <tr bgcolor="#000066"> 
      <td colspan="4" nowrap bordercolor="#FFFFFF" bgcolor="#000099"><font color="#FFFFFF" face="Arial"><strong>Version 
        : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("FCMVER")%></strong></font></td>
    </tr>
  </table>  
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
   <tr>
     <td>&nbsp;</td>    
   </tr>
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr>
      <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>COGS: 
        </strong></font> </td>
    <td> 
      <input name="FCCOGS" type="text" value="<%=rs.getInt("FCCOGS")%>" size="100%" maxlength="10">	
    </td>
  </tr>             
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. USER : </font><font face="Arial"><%=rs.getString("FCLUSER")%></strong></font>    </td>    
  </tr>   
 </table> 
 <input name="FCCOMP" type="hidden" value="<%=comp%>"> 
 <input name="FCTYPE" type="hidden" value="<%=type%>">
 <input name="FCREG" type="hidden" value="<%=region%>">
 <input name="FCCOUN" type="hidden" value="<%=country%>">   
 <input name="FCCURR" type="hidden" value="<%=curr%>">
 <input name="FCPRJCD" type="hidden" value="<%=model%>">  
 <input name="FCYEAR" type="hidden" value="<%=year%>">
  <input name="FCMONTH" type="hidden" value="<%=month%>">
  <input name="FCMVER" type="hidden" value="<%=version%>">
  <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSForecastCogsMaintEditCommit.jsp?&FCCOMP=<%=comp%>&FCTYPE=<%=type%>&FCREG=<%=region%>&FCCOUN=<%=country%>&FCCURR=<%=curr%>&FCPRJCD=<%=model%>&FCYEAR=<%=year%>&FCMONTH=<%=month%>&FCMVER=<%=version%>")'> 
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/WSForecastCogsMaintenance.jsp?&FCCOMP=<%=comp%>&FCTYPE=<%=type%>&FCREG=<%=region%>&FCCOUN=<%=country%>&FCCURR=<%=curr%>&FCPRJCD=<%=model%>&FCYEAR=<%=year%>&FCMONTH=<%=month%>&FCMVER=<%=version%>")'>
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
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>