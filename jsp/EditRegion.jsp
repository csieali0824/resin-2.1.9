<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean,CheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditRegion.jsp</title>
</head>

<body background="../image/b01.jpg"> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<%
  
  try
    {
	Statement statement=con.createStatement();
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
      <form action="EditRegionDb.jsp" method="post" name="signform" onsubmit="return getNum()">
      
   REGION:<%
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select distinct REGION, REGION from WsREGION ");
			  comboBoxBean.setRs(rs);
			  comboBoxBean.setSelection("AFRICA");
	          comboBoxBean.setFieldName("REGION");
              out.println(comboBoxBean.getRsString());
			  rs.close();
	          %><br>
	
     <input type="submit" name="submit" value="EDIT" >
        <a href="../jsp/System.jsp">回上一頁</a>
</form>
    
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
