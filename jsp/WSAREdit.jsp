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
<title>WINS System - AR Edit Page</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
 if ((document.MYFORM.DUNCODE2.value =="5" && document.MYFORM.RECDATE2.value !="") && document.MYFORM.DUNDESP2.value =="") 
	     {
	      alert("請輸入狀態說明!");
		  return (false);
          }
	 else
		  {
		  document.MYFORM.action=URL;		
	      document.MYFORM.submit();
	       }    
 //document.MYFORM.action=URL;
 //document.MYFORM.submit();
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
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> AR Overdue Edit</strong></font> 

<FORM action="WSARMainEditCommit.jsp"  METHOD="post" NAME="MYFORM" >
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     String RCUST=request.getParameter("RCUST");
	 String CNME=request.getParameter("CNME");  
	 String RIDTE=request.getParameter("RIDTE");  
	 String RDDTE=request.getParameter("RDDTE");  
	 String RCURR=request.getParameter("RCURR");  
	 String RAMT=request.getParameter("RAMT");  
	 String RCNVFC=request.getParameter("RCNVFC");  
	 String RCAMT=request.getParameter("RCAMT"); 	
	 String SSAL=request.getParameter("SSAL"); 
	 String SERIAL=request.getParameter("SERIAL"); 	 
	 String DUNCODE2=request.getParameter("DUNCODE2"); 
	 String DUNDESP2=request.getParameter("DUNDESP2");
	 String RECDATE2=request.getParameter("RECDATE2");	 
	 String DUNCODE=request.getParameter("DUNCODE");  
	 String DUNDESP=request.getParameter("DUNDESP");
	 String RECDATE=request.getParameter("RECDATE");
	 
	 
	 
	 
    
%>
  <table width="100%" border="0">
    <tr bgcolor="#000066"> 
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>客戶代碼：</strong></font><font color="#FF3366" face="Arial"><strong><%=RCUST%></strong></font></td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>客戶名稱：</strong></font><font color="#FF3366" face="Arial"><strong><%=CNME%></strong></font></td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>立帳日：</strong></font><font color="#FF3366" face="Arial"><strong><%=RIDTE%></strong></font></td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>發票日：</strong></font><font color="#FF3366" face="Arial"><strong><%=RIDTE%></strong></font></td>
      <td bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>到期日：</strong></font><font color="#FF3366" face="Arial"><strong><%=RDDTE%></strong></font></td>
    </tr>
    <tr bgcolor="#000066"> 
      <td width="17%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>幣別：</strong></font><font color="#FF3366" face="Arial"><strong><%=RCURR%></strong></font></td>
      <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>原幣金額：</strong></font><font color="#FF3366" face="Arial"><strong><%=RAMT%></strong></font></td>
      <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=bpcscon.createStatement(); 
	   	  
	  
      sqlGlobal =  "Select r.RCUST,c.CNME,o.RINVC,o.DUNCODE,o.DUNDESP,o.RECDATE,r.RIDTE,r.RIDTE,r.RDDTE,r.RCURR,r.RAMT,r.RCNVFC,r.RCAMT,m.SSAL,o.SERIAL "+
			                 " FROM overduear o,rar r,rcm c,ssm m";
      String sWhereTC = " WHERE o.SERIAL=r.SERIALCOLUMN and  r.rcust=c.ccust  and  c.csal=m.ssal and r.rrem!=0 and o.PRINT!='N'   ";
      //if (sname == null || sname.equals("--")) { sWhereTC = sWhereTC ; }
			 // else { sWhereTC = sWhereTC + "and SNAME ='"+sname+"'  "; }	
         
			  
			  
      
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step1 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {}
	   rs.close();
       statement.close();
      
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     }  
     %>
      <td width="20%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>匯率：</strong></font><font color="#FF3366" face="Arial"><strong><%=RCNVFC%></strong></font> </td>
      <td width="20%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>台幣金額：</strong></font><font color="#FF3366" face="Arial"><strong><%=RCAMT%></strong></font> </td>
      <td width="20%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>業務員：</strong></font><font color="#FF3366" face="Arial"><strong><%=SSAL%></strong></font></td>
    </tr>
  </table>  
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
   <tr>
      <td><font color="#FF3366"><strong>修改..</strong></font></td>    
   </tr>
 </table>
  <table width="100%" border="1" cellpadding="1" cellspacing="1">
    <tr>
      <td nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font color="#0000FF" size="2"><strong>處理狀態：</strong></font><font color="#0000FF" face="Arial">&nbsp;</font><font color="#FF3366" face="Arial">&nbsp;<strong><%=DUNCODE%></strong></font><font color="#0000FF" face="Arial">&nbsp; 
        </font></td>
      <td width="74%"><font size="2">
        <select name="DUNCODE2" onChange="setSubmit('../jsp/WSAREdit.jsp')">
          <option value="null" <% if (DUNCODE2!=null && (DUNCODE2=="null" || DUNCODE2.equals("unll")) ) { out.println("SELECTED"); } %>></option>
		  <option value="1" <% if (DUNCODE2!=null && (DUNCODE2=="1" || DUNCODE2.equals("1")) ) { out.println("SELECTED"); } %>>1</option>
          <option value="2" <% if (DUNCODE2!=null && (DUNCODE2=="2" || DUNCODE2.equals("2")) ) { out.println("SELECTED"); } %>>2</option>
          <option value="3" <% if (DUNCODE2!=null && (DUNCODE2=="3" || DUNCODE2.equals("3")) ) { out.println("SELECTED"); } %>>3</option>
          <option value="4" <% if (DUNCODE2!=null && (DUNCODE2=="4" || DUNCODE2.equals("4")) ) { out.println("SELECTED"); } %>>4</option>
          <option value="5" <% if (DUNCODE2!=null && (DUNCODE2=="5" || DUNCODE2.equals("5")) ) { out.println("SELECTED"); } %>>5</option>
		  <option value="6" <% if (DUNCODE2!=null && (DUNCODE2=="6" || DUNCODE2.equals("6")) ) { out.println("SELECTED"); } %>>6</option>
        </select>
        </font></td>		
    </tr>
    <tr> 
      <td nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font color="#0000FF" size="2"><strong>狀態說明：</strong></font><font color="#0000FF" face="Arial">&nbsp; 
        </font><font color="#FF3366" face="Arial"><strong><%=DUNDESP%></strong>&nbsp;</font><font color="#0000FF" face="Arial">&nbsp; 
        </font></td>
      <td><input name="DUNDESP2" type="text" <% if (DUNCODE2==null ||DUNCODE2=="" || DUNCODE2.equals("")){ out.println("value="+"''"); }
												else if (DUNCODE2=="1" || DUNCODE2.equals("1")) { out.println("value="+"'預計5-15天內收回'"); }
												else if (DUNCODE2=="2" || DUNCODE2.equals("2")) { out.println("value="+"'預計15-20天內收回'"); }
												else if (DUNCODE2=="3" || DUNCODE2.equals("3")) { out.println("value="+"'預計20-30天內收回'"); }
												else if (DUNCODE2=="4" || DUNCODE2.equals("4")) { out.println("value="+"'可能收不回,將上簽呈處理'"); }
												else if (DUNCODE2=="5" || DUNCODE2.equals("5")) { out.println("value="+"''"); }
												else if (DUNCODE2=="6" || DUNCODE2.equals("6")) { out.println("value="+"'已收款未沖帳'"); }																								
											 %>  size="100%" maxlength="30"> </td>
	      </tr>
    <tr> 
      <td width="26%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font color="#0000FF" size="2"><strong>預計收款日</strong></font><font size="2">：</font><font color="#FF3366" face="Arial"><strong><%=RECDATE%></strong></font><font color="#FF3366" face="Arial">&nbsp;</font> 
      </td>
      <td><font size="2">
        <input name="RECDATE2" type="text" <% if (DUNCODE2==null || DUNCODE2=="" || DUNCODE2.equals("")) { out.println("value="+"''"); }
												else if (DUNCODE2=="1" || DUNCODE2.equals("1")) { dateBean.setAdjDate(15); out.println("value="+dateBean.getYearMonthDay()); }
												else if (DUNCODE2=="2" || DUNCODE2.equals("2")) { dateBean.setAdjDate(20); out.println("value="+dateBean.getYearMonthDay()); }
												else if (DUNCODE2=="3" || DUNCODE2.equals("3")) { dateBean.setAdjDate(30); out.println("value="+dateBean.getYearMonthDay()); }
												else if (DUNCODE2=="4" || DUNCODE2.equals("4")) { out.println("value='' "+"readonly='' " ); }
												else if (DUNCODE2=="5" || DUNCODE2.equals("5")) { out.println("value="+dateBean.getYearMonthDay()); }
												else if (DUNCODE2=="6" || DUNCODE2.equals("6")) { out.println("value='' "+"readonly='' " ); }																											       		
											%>  size="100%" maxlength="10">
        </font></td>
    </tr>
  </table>
 <input name="RCUST" type="hidden" value="<%=RCUST%>">
 <input name="CNME" type="hidden" value="<%=CNME%>">
 <input name="RIDTE" type="hidden" value="<%=RIDTE%>">  
 <input name="RDDTE" type="hidden" value="<%=RDDTE%>">
 <input name="RCURR" type="hidden" value="<%=RCURR%>">
 <input name="RAMT" type="hidden" value="<%=RAMT%>">  
 <input name="RCNVFC" type="hidden" value="<%=RCNVFC%>">
 <input name="RCAMT" type="hidden" value="<%=RCAMT%>"> 
 <input name="SSAL" type="hidden" value="<%=SSAL%>"> 
 <input name="SERIAL" type="hidden" value="<%=SERIAL%>">  
 <input name="DUNCODE" type="hidden" value="<%=DUNCODE%>">
 <input name="DUNDESP" type="hidden" value="<%=DUNDESP%>"> 
 <input name="RECDATE" type="hidden" value="<%=RECDATE%>">   
 <input name="button1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSARMainEditCommit.jsp?RCUST=<%=RCUST%>&CNME=<%=CNME%>&RIDTE=<%=RIDTE%>&RDDTE=<%=RDDTE%>&RCURR=<%=RCURR%>&RAMT=<%=RAMT%>&RCNVFC=<%=RCNVFC%>&RCAMT=<%=RCAMT%>&SSAL=<%=SSAL%>&SERIAL=<%=SERIAL%>")'>
 <input name="button2" type="button" value="ABORT" onClick='return setSubmit("../jsp/WSARMaintenance.jsp?RCUST=<%=RCUST%>&CNME=<%=CNME%>&RIDTE=<%=RIDTE%>&RDDTE=<%=RDDTE%>&RCURR=<%=RCURR%>&RAMT=<%=RAMT%>&RCNVFC=<%=RCNVFC%>&RCAMT=<%=RCAMT%>&SSAL=<%=SSAL%>&SERIAL=<%=SERIAL%>")'> 
  
</FORM>
</body>
<!--=============¢FFFFDH?U¢FFFFXI?q?¢FFFFXAAcn3s¢FFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
 