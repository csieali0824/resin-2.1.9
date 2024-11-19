<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,java.util.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>                                              
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateREGIONDb.jsp</title>
</head>

<body  background="../image/b01.jpg" > 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<%
  String REGION=request.getParameter("REGION");
  //String LOCALE_ENG_NAME1=request.getParameter("LOCALE_ENG_NAME1");
  String CONTINENTID=request.getParameter("CONTINENT");

  out.println("REGION:"+REGION+"<br>");
  //out.println(CONTINENTID+"<br>");
%>
 
<%
  
  try
    {
	Statement statement=con.createStatement();
	 statement.close();
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
      <form action="CreateRegionAdd.jsp" method="post" name="signform1">
	  <input type="hidden" name="REGION" value="<%= REGION %>" >
    COUNTRY:<%
             Statement statement1=con.createStatement();
	         ResultSet rs1=statement1.executeQuery("select LOCALE , LOCALE_ENG_NAME from Wslocale where CONTINENTID= '"+CONTINENTID+"' ");
             checkBoxBean.setRs(rs1);
             checkBoxBean.setFieldName("LOCALE");
        	 checkBoxBean.setColumn(7); //傳參數給bean以回傳checkBox的列數
             out.println(checkBoxBean.getRsString()); 
			 rs1.close();
			 statement1.close();
	          %><hr>
     <input type="submit" name="submit" value="ADD" >
     <input name="reset" type="reset" value="REST"><br>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

