<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="RsCountBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean"%>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Query All Material Request Confirmation for PIS</title>
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">

</script>
<body>
<%
String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");   
String v_modelNo=request.getParameter("MODELNO");   
 
if (YearFr==null || YearFr.equals(""))
{YearFr=dateBean.getYearString();}
if (MonthFr==null || MonthFr.equals(""))
{MonthFr=dateBean.getMonthString();}  

String dateYearCurr = dateBean.getYearString();
String dateMonCurr = dateBean.getMonthString();   

Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
Statement subStat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet  rs=null,subRs=null;   
String sql="",sub_Sql="";  
int subRow=1; 	
%>

<FORM NAME="MYFORM" ACTION="PIS_MRC_QueryAll.jsp" METHOD="POST"> 
 <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font></font></font><font color="#000000" size="+1" face="Times New Roman"> 
    <strong>物料需求狀況追蹤表</strong></font>
    <BR>
      <A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
  <table width="100%" border="0">
    <tr bgcolor="#99CCCC">
      <td width="47%" bgcolor="#99CCCC"><font color="#333399" face="Arial Black"><strong>TARGET DATE:Year</strong></font>
          <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
		  arrayComboBoxBean.setNoNull("Y");
          arrayComboBoxBean.setArrayString(a);		  
   	      arrayComboBoxBean.setSelection(YearFr);		  
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
      %>
&nbsp;&nbsp;<font color="#330099" face="Arial Black"><strong>Month</strong></font>
      <%
		 String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
		  arrayComboBoxBean.setNoNull("Y");
          arrayComboBoxBean.setArrayString(b);		
  	      arrayComboBoxBean.setSelection(MonthFr);		 
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %></td>
      <td width="36%"><font color="#333399" face="Arial Black"><strong>Model</strong></font>
          <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";		  
		  
		  sSql = "select trim(PROJECTCODE) as MODEL,trim(PROJECTCODE)||'('||trim(SALESCODE)||')' from PIMASTER ";		  
		  sWhere= " order by MODEL";			                 		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		               
          rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(v_modelNo);
	      comboBoxAllBean.setFieldName("MODELNO");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
          v_modelNo= rs.getString("MODEL");
		  }
          rs.close();     		  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
      <td width="17%"><font color="#333399" face="Arial Black">&nbsp; </font>         
      <input name="search" type="submit" value='Inquiry'>	  
	  </td>
    </tr>
  </table>
  
<table width="100%" height="105" border="1" cellpadding="0" cellspacing="0">
<tr bgcolor="#77CCCC">
  <td width="7%" rowspan="2"><font size=2>MODEL</font></td>
  <td width="6%" rowspan="2"><font size=2>COLOR</font></td>
  <td width="8%" rowspan="2"><font size=2>需求單號</font></td>
  <td colspan="4"><div align="center"><font size=2>數量(Unit /K pcs)</font></div></td>
  <td colspan="4"><div align="center"><font size=2>日期</font></div></td>
  <td width="6%" rowspan="2"><font size=2>備註1</font></td>
  <td width="12%" rowspan="2"><font size=2>備註2</font></td>
</tr>
<tr>
  <td width="8%" bgcolor="#77CCCC"><font size=2>預測數量</font></td>
  <td width="8%" bgcolor="#77CCCC"><font size=2>需求數量</font></td>
  <td width="8%" bgcolor="#77CCCC"><font size=2>承諾數量</font></td>
  <td width="8%" bgcolor="#77CCCC"><font size=2>實收數量</font></td>
  <td width="7%" bgcolor="#77CCCC"><font size=2>發單日期</font></td>
  <td width="8%" bgcolor="#77CCCC"><font size=2>需求日期</font></td>
  <td width="7%" bgcolor="#77CCCC"><font size=2>承諾交期</font></td>
  <td width="7%" bgcolor="#77CCCC"><font size=2>實際交期</font></td>
  </tr>
<%
String cm_qty="&nbsp;",cm_date="&nbsp;",act_qty="&nbsp;",act_date="&nbsp;";
String fc_qty="",pr_date="",mr_qty="",mr_date="";
String fc_qtyTotal="0",mr_qtyTotal="0",cm_qtyTotal="0",act_qtyTotal="0";
String remark1="",remark2="";
try
{    
   sql = "select a.PRJCD,a.COLOR,a.DOCNO,b.FCQTY,b.RQYEAR,b.RQMONTH,a.EP_QTY,a.EP_DATE,c.CREATEDDATE as PRDATE from PSALES_FORE_MRC_LN a,PSALES_FORE_APP_LN b,PSALES_FORE_APP_HD c "+
         " where a.DOCNO=b.DOCNO and a.PRJCD=b.PRJCD and a.COLOR=b.COLOR and a.DOCNO=c.DOCNO"+
		 " and a.R_TYPE='I' and b.RQYEAR='"+YearFr+"' and b.RQMONTH='"+MonthFr+"'";
   if (v_modelNo!=null && !v_modelNo.equals("--"))  sql=sql+" and a.PRJCD='"+v_modelNo+"'";   
   sql=sql+" order by PRJCD,COLOR,DOCNO";      	
   rs=statement.executeQuery(sql);
   
   while (rs.next())   
   {      
      fc_qty=rs.getString("FCQTY");
      if (fc_qty==null) 
	  {
	     fc_qty="&nbsp;";
	  } else {
	     fc_qtyTotal=String.valueOf(Float.parseFloat(fc_qtyTotal)+Float.parseFloat(fc_qty)); 
	  }	 
      pr_date=rs.getString("PRDATE");
      if (pr_date==null) 
	  {
	      pr_date="&nbsp;";
	  } else {
	     if (pr_date.length()==8) pr_date=pr_date.substring(0,4)+"/"+pr_date.substring(4,6)+"/"+pr_date.substring(6,8);
	  }  
	  mr_qty=rs.getString("EP_QTY");
      if (mr_qty==null) 
	  {
	     mr_qty="&nbsp;";
	  } else {
	     mr_qtyTotal=String.valueOf(Float.parseFloat(mr_qtyTotal)+Float.parseFloat(mr_qty)); 
	  }	
	  mr_date=rs.getString("EP_DATE");
      if (mr_date==null) 
	  {
	      mr_date="&nbsp;";
	  } else {
	     if (mr_date.length()==8) mr_date=mr_date.substring(0,4)+"/"+mr_date.substring(4,6)+"/"+mr_date.substring(6,8);
	  }
	  	  
      subRow=1;
      sub_Sql="select PRJCD,COLOR,DOCNO,CM_QTY,CM_DATE,ACT_QTY,ACT_DATE,LINENO,REMARK,COMMENTS from PSALES_FORE_MRC_LN"+
	          " where R_TYPE='R' and DOCNO='"+rs.getString("DOCNO")+"' and PRJCD='"+rs.getString("PRJCD")+"' and COLOR='"+rs.getString("COLOR")+"'"+
			  " order by DOCNO,PRJCD,COLOR,LINENO";  
	  subRs=subStat.executeQuery(sub_Sql);			 
	  rsCountBean.setRs(subRs); //取得其總筆數
	  subRow=rsCountBean.getRsCount();	 
	  if (subRow<1) subRow=1;	
	  if (subRs.next())
	  { 	  
		  cm_qty=subRs.getString("CM_QTY");
		  if (cm_qty==null)
		  {
			cm_qty="&nbsp;";
		  } else {
			cm_qtyTotal=String.valueOf(Float.parseFloat(cm_qtyTotal)+Float.parseFloat(cm_qty)); 
		  }			  
		  cm_date=subRs.getString("CM_DATE");	  
		  if (cm_date==null) 
		  {
			   cm_date="&nbsp;";
		  } else {
			 if (cm_date.length()==8) cm_date=cm_date.substring(0,4)+"/"+cm_date.substring(4,6)+"/"+cm_date.substring(6,8);
		  }  
		  act_qty=subRs.getString("ACT_QTY");
		  if (act_qty==null) 
		  {
			act_qty="&nbsp;";
		  } else {
			act_qtyTotal=String.valueOf(Float.parseFloat(act_qtyTotal)+Float.parseFloat(act_qty)); 
		  }	
		  act_date=subRs.getString("ACT_DATE");	  
		  if (act_date==null) 
		  {
			   act_date="&nbsp;";
		  } else {
			 if (act_date.length()==8) act_date=act_date.substring(0,4)+"/"+act_date.substring(4,6)+"/"+act_date.substring(6,8);
		  } 		  
		  
		  remark1=subRs.getString("REMARK"); //取得上海物管回覆的備註
		  if (remark1==null) remark1="";
		  remark2=subRs.getString("COMMENTS"); //取得台北物管收料的備註
		  if (remark2==null) remark2="";	
	  } //end of if=> (subRs.next())	   	    
%> 
<tr>
  <td rowspan=<%=subRow%> width="7%"><font size=2><%=rs.getString("PRJCD")%></font></td>
  <td rowspan=<%=subRow%> width="6%"><font size=2><%=rs.getString("COLOR")%></font></td>
  <td rowspan=<%=subRow%> width="8%"><font size=1><%=rs.getString("DOCNO")%></font></td>
  <td width="8%"><div align="right"><font size=2><%=fc_qty%></font></div></td>
  <td width="8%"><div align="right"><font size=2><%=mr_qty%></font></div></td>    
  <td width="8%"><div align="right"><font size=2><%=cm_qty%></font></div></td>
  <td width="8%"><div align="right"><font size=2><%=act_qty%></font></div></td>
  <td width="7%"><div align="center"><font size=2><%=pr_date%></font></div></td>
  <td width="8%"><div align="center"><font size=2><%=mr_date%></font></div></td>
  <td width="7%"><div align="center"><font size=2><%=cm_date%></font></div></td>
  <td width="7%"><div align="center"><font size=2><%=act_date%></font></div></td>
  <td width="6%">
  <%   
    if (!remark1.equals("")) //若有備註說明才秀出
	{
	   out.println("<img title='"+remark1+"' src='../image/docicon.gif'>");
	} 
  %>		
  &nbsp;</td>
  <td width="12%">
  <%
    if (!remark2.equals("")) //若有備註說明才秀出
	{
	   out.println("<img title='"+remark2+"' src='../image/docicon.gif'>");
	} 
  %>
  &nbsp;</td>
  </tr>   
  <%
      if (subRow>1)
	  {	    
        while (subRs.next())
	    {
		   cm_qty=subRs.getString("CM_QTY");
	       if (cm_qty==null)
	       {
	         cm_qty="&nbsp;";
	       } else {
	         cm_qtyTotal=String.valueOf(Float.parseFloat(cm_qtyTotal)+Float.parseFloat(cm_qty)); 
	       }	
	       cm_date=subRs.getString("CM_DATE");
	       if (cm_date==null) 
	       {
	          cm_date="&nbsp;";
	       } else {
	          if (cm_date.length()==8) cm_date=cm_date.substring(0,4)+"/"+cm_date.substring(4,6)+"/"+cm_date.substring(6,8);
	       }  
	       act_qty=subRs.getString("ACT_QTY");
	       if (act_qty==null) 
	       { 
	          act_qty="&nbsp;";
	       } else {
	          act_qtyTotal=String.valueOf(Float.parseFloat(act_qtyTotal)+Float.parseFloat(act_qty)); 
	       }
	       act_date=subRs.getString("ACT_DATE");
	       if (act_date==null) 
	       {
	          act_date="&nbsp;";
	       } else {
	          if (act_date.length()==8) act_date=act_date.substring(0,4)+"/"+act_date.substring(4,6)+"/"+act_date.substring(6,8);
	       } 
  %>
    <tr>
    <td width="7%"><div align="right"><font size=2><img border='0' src='../image/arrowup.gif'></font></div></td>
    <td width="6%"><div align="right"><font size=2><img border='0' src='../image/arrowup.gif'></font></div></td>    
     <td width="8%"><div align="right"><font size=2><%=cm_qty%></font></div></td>
     <td width="8%"><div align="right"><font size=2><%=act_qty%></font></div></td>
     <td width="8%"><div align="center"><font size=2><%=pr_date%></font></div></td>
     <td width="8%"><div align="center"><font size=2><%=mr_date%></font></div></td>
     <td width="8%"><div align="center"><font size=2><%=cm_date%></font></div></td>
     <td width="7%"><div align="center"><font size=2><%=act_date%></font></div></td>
     <td width="8%">
	 <%
       if (!remark1.equals("")) //若有備註說明才秀出
	   {
	      out.println("<img title='"+remark1+"' src='../image/docicon.gif'>");
	   } 
     %>
	 &nbsp;</td>
     <td width="7%">
	 <%
       if (!remark2.equals("")) //若有備註說明才秀出
	   {
	      out.println("<img title='"+remark2+"' src='../image/docicon.gif'>");
	   } 
     %>
	 &nbsp;</td>
    </tr>
  <%          
        } 	
	  }	        
      if (subRs!=null) subRs.close();
   } //end of main while loop=>rs.next()
   rs.close();  
} //end of try
catch (Exception e1)
{
 %>
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
 <%
  out.println("Exception:"+e1.getMessage());		  
}
%>
 <tr bgcolor="#FFFFCC">
  <td height="21" colspan="3"><div align="right"><strong><font size=1>TOTAL</font></strong></div></td>
  <td width="8%"><div align="right"><strong><font size=2><%=fc_qtyTotal%></font></strong></div></td>
  <td width="8%"><div align="right"><strong><font size=2><%=mr_qtyTotal%></font></strong></div></td>    
  <td width="8%"><div align="right"><strong><font size=2><%=cm_qtyTotal%></font></strong></div></td>
  <td width="8%"><div align="right"><strong><font size=2><%=act_qtyTotal%></font></strong></div></td>
  <td colspan="6"><div align="center"><strong><font size=2>&nbsp;</font></strong></div></td>
  </tr>      
</table>
</FORM>
</body>
<%
 subStat.close();
 statement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
