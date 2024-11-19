<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NewContinent.jsp</title>
</head>

<body>
<table width="82%" height="25" border="0" cellpadding="0" cellspacing="8">
  <font color="#e8eef7"></font> 
</table>
<table width="397" height="163" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>新建記錄</H4>
          
    <td width="383" height="159" bgcolor=#CCFFFF> <div align="left"> 
      <form action="NewContinentDb.jsp" method="post" name="signform">
新增:<br>
編號:<input type="text" name="CONTINENT" size="2" maxlength="2"><br>
名稱:<input type="text" name="CONTINENT_NAME" size="15" maxlength="15"><br><p>
        <input type="submit" name="submit" value="加入" >
        <input name="reset" type="reset" value="清除"><br>
		<a href="../jsp/WSForecastMenu.jsp">回上一頁</a>
		</form>
        </p></table>

</body>
</html>