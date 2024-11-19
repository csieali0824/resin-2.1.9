<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ComboBoxAllBean" %>

<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ACPageByModel.jsp</title>
</head>

<body background="../image/b01.jpg" topmargin="0">
  <FORM METHOD=post ACTION="ACPageByModelDb.jsp">
  <%
    String YearFr=request.getParameter("YEARFR");
    String MonthFr=request.getParameter("MONTHFR");
  %>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
  <strong><font size="+2">AC生產日報彙總表</font></strong><BR>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
<table width="39%" border="2" align="center" cellpadding="0" cellspacing="0">

    <tr bgcolor="#FFFFFF"> 
      <td valign="middle" nowrap bgcolor="#6AE1FF"> 
	  <font face="標楷體">MODEL:</font>
	  <%
		      Statement statement=con.createStatement();
			  ResultSet rs=statement.executeQuery("select distinct MPROJ a,MPROJ b from PRODMODEL order by a");
			  comboBoxAllBean.setRs(rs);
			  comboBoxAllBean.setSelection("MPROJ");
			  comboBoxAllBean.setFieldName("MPROJ");
              out.println(comboBoxAllBean.getRsString());
			  statement.close();
			  rs.close();
	   %>
	   
	   
	    <font face="標楷體">日期:</font>
        <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2000","2001","2002","2003","2004","2005","2006","2007","2008","2009"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearFr==null)
		  {
		    CurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearFr);
		  }
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font face="標楷體">年</font> 
        <%
		  String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  }
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font face="標楷體">月</font>  
		<input type="submit" name="submit" value="查詢" >  

	  </td>
	  </tr>
  </FORM>
</table>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
