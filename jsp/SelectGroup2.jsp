<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SelectGroup2.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
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
<table width="82%" height="25" border="0" cellpadding="0" cellspacing="8">
  <font color="#e8eef7"></font> 
</table>			 
<table width="322" height="148" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>查詢群組記錄</H4>
          
    <td width="340" height="144" bgcolor=#CCFFFF> <div align="left"> 
      <form action="SelectGroupDb.jsp" method="post" name="" id="">
       <font color="#FF0000"><strong>錯誤!請從新輸入</strong></font><br>
      	群組名稱:<%
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select GROUPNAME,GROUPNAME from Wsgroup ");
              checkBoxBean.setRs(rs);
	          checkBoxBean.setFieldName("GROUPNAME");
	          checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
              statement.close();
			  rs.close();
	          %><br>
     <input type="submit" name="submit" value="查詢" >
     <input name="reset" type="reset" value="清除"><br>
	 <a href="/wins/WinsMainMenu.jsp">回手頁</a></form>
     </p></table>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

  
