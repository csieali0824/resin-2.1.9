<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditLocale.jsp</title>
</head>

<body> 
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
<table width="82%" height="25" border="0" cellpadding="0" cellspacing="8">
  <font color="#e8eef7"></font> 
</table>
<table width="433" height="128" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>修改記錄</H4>
          
    <td width="340" height="124" bgcolor=#CCFFFF> <div align="left"> 
      <form action="LocaleDb.jsp" method="post" name="signform" onsubmit="return getNum()">
      <input type=hidden name=CONTINENT_NAME value="">
   陸地名稱:<%
              String CONTINENT_CONTINENT_NAME="";
			  boolean haveflag=false;
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select CONTINENT,CONTINENT_NAME from WsCONTINENT ");
			  rsBean.setRs(rs);
	          while(rs.next())
              {
			   String CONTINENT = rs.getString("CONTINENT");
			   String CONTINENT_NAME = rs.getString("CONTINENT_NAME");

			   CONTINENT_CONTINENT_NAME=CONTINENT_CONTINENT_NAME+"<option "+"value=\""+ CONTINENT +"\">"+CONTINENT_NAME+"</option>\n";
               haveflag=true;
			  }
			  if(haveflag)
              out.println("<select name=CONTINENT onchange=\"document.signform.CONTINENT_NAME.value = document.signform.CONTINENT[document.signform.CONTINENT.selectedIndex].text\">"+CONTINENT_CONTINENT_NAME+"</select>\n");
			  //out.println("<input type=hidden name=CONTINENT_NAME value="+CONTINENT_NAME+"> ");
			  
			  
			  
			  //以下為comboBoxBean
			 /* comboBoxBean.setRs(rs);
			  comboBoxBean.setSelection("jsp");
	          comboBoxBean.setFieldName("CONTINENT");
              out.println(comboBoxBean.getRsString());*/
			  rs.close();
	          %><br>
     <input type="submit" name="submit" value="修改" >
     <input name="reset" type="reset" value="清除"><br>
        <a href="../jsp/System.jsp">回上一頁</a>
</form>
     </p></table>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>