<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DelProgrammer.jsp</title>
</head>

<body background="../image/b01.jpg">
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
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
      <form action="DelProgrammerDb.jsp" method="post" name="signform">
刪除授權角色/程式對應檔:<br>
角色名稱:<%
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select ROLENAME,ROLENAME from WsROLE ");
			  comboBoxBean.setRs(rs);
			  comboBoxBean.setSelection("jsp");
	          comboBoxBean.setFieldName("ROLENAME");
              out.println(comboBoxBean.getRsString());
			  statement.close();
			  rs.close();
	          %><br>
模組:<select name="MODEL" size="1">
     <option value="A1">A1 人員群組管理 </option>
	 <option value="B1">B1 報表查詢 </option>
	 <option value="C1">C1 資料維護與管理 </option>
	 <option value="D1">D1 SALES FORECAST </option>
</select><br>
程式檔名:<input type="text" name="PROGRAMMERNAME" size="30" maxlength="30"><br>
        <input type="submit" name="submit" value="刪除" >
        <input name="reset" type="reset" value="清除"><br>
		<a href="../jsp/WinsMainMenu.jsp">回上一頁</a>
		</form>
        </p>

</body>
</html>