<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,java.util.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>                                               
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditREGIONDb2.jsp</title>
</head>

<body  background="../image/b01.jpg" > 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<%
  String[] LOCALE=request.getParameterValues("LOCALE");
  String REGION=request.getParameter("REGION");
  //String LOCALE_ENG_NAME1=request.getParameter("LOCALE_ENG_NAME1");
  String CONTINENTID=request.getParameter("CONTINENT");
  String LOCALE_NAMEA[] = new String[150]; 
    int i=0;

  out.println("REGION:"+REGION+"<br>");
  //out.println(CONTINENTID+"<br>");
%>
 
<%
  
  try
    {
	 Statement statement=con.createStatement();
	 String sql2="select LOCALE from WsREGION WHERE REGION='"+REGION+"'";	
	  ResultSet rs2=statement.executeQuery(sql2);
	  while (rs2.next())
	  {
	   i=i+1;
	    LOCALE_NAMEA[i] = rs2.getString("LOCALE");
	    //out.print("地區:"+rs2.getString("LOCALE")+"<br>");
	  }//查詢修改地區
	
	  out.print("<hr>");
	  rs2.close();
	 statement.close();
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
      <form action="UpdateRegion.jsp" method="post" name="signform1">
	  <input type="hidden" name="REGION" value="<%= REGION %>" >
	  COUNTRY:<%
	          Statement statement=con.createStatement();
	          ResultSet rs2=statement.executeQuery("select X.LOCALE,Y.LOCALE_ENG_NAME from WsREGION X , WsLOCALE Y Where X.REGION='"+REGION+"' and X.LOCALE=Y.LOCALE ");
			  checkBoxBeanNew.setChecked(LOCALE_NAMEA);
              checkBoxBeanNew.setRs(rs2);
	          checkBoxBeanNew.setFieldName("LOCALE2");
	          checkBoxBeanNew.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBeanNew.getRsString());
			  statement.close();
			  rs2.close();
	          %><br> 
	  
	  
	  
	  

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

