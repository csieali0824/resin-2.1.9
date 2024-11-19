<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,java.util.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>LocaleDb.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<%

  String CONTINENT=request.getParameter("CONTINENT");
  String CONTINENT_NAME=request.getParameter("CONTINENT_NAME");
  out.print(CONTINENT_NAME+"<br>");

  try
    {
	Statement statement=con.createStatement();
	  String sql2="select LOCALE,LOCALE_NAME from WsLOCALE where CONTINENTID='"+CONTINENT+"'";	
	  ResultSet rs2=statement.executeQuery(sql2);
	  while (rs2.next())
	  {
	    out.print("地區:"+rs2.getString("LOCALE_NAME")+"<br>");
	  }//查詢修改地區
	  out.print("<hr>");
	  rs2.close();
    }//end of try
	
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
<table width="82%" height="25" border="0" cellpadding="0" cellspacing="8">
  <font color="#e8eef7"></font> 
</table>
<table width="562" height="128" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>修改記錄</H4>
          
    <td width="340" height="124" bgcolor=#CCFFFF> <div align="left"> 
      <form action="UpdateLocale.jsp" method="post" name="signform" onsubmit="return getNum()">
      	<input type="hidden" name="CONTINENT" value="<%= CONTINENT %>" >
		<input type="hidden" name="CONTINENT_NAME" value="<%= CONTINENT_NAME %>" >
	  
	   	   地區:<%
	          Statement statement=con.createStatement();
	          ResultSet rs1=statement.executeQuery("select * from WsLOCALE where RESGIN='"+1+"'");
			  while(rs1.next())
              {
             	String LOCALE = rs1.getString("LOCALE");
		        String LOCALE_NAME = rs1.getString("LOCALE_NAME");
				String LOCALE_ENG_NAME = rs1.getString("LOCALE_ENG_NAME");
				String LOCALE_SHT_NAME = rs1.getString("LOCALE_SHT_NAME");
		        out.println("<input type=checkbox name=LOCALE value="+LOCALE+"> "+LOCALE_NAME+"");
			    out.println("<input type=hidden name=LOCALE_NAME value="+LOCALE_NAME+"> ");
				out.println("<input type=hidden name=LOCALE_ENG_NAME value="+LOCALE_ENG_NAME+"> ");
				out.println("<input type=hidden name=LOCALE_SHT_NAME value="+LOCALE_SHT_NAME+"> ");
	          }
			  statement.close();
			  rs1.close();
	          %><br> 
	
     <input type="submit" name="submit" value="修改" >
     <input name="reset" type="reset" value="清除"><br>
        <a href="../jsp/EditLocale.jsp">回上一頁</a>
</form>
     </p></table>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

  <script language="JavaScript"> 

   function getNum(){
     var sel="";
     sel = document.signform.LOCALE.selectedIndex;
	 if (sel==0){
	  alert("請選擇陸地名稱!!");
	    return (false);
	 }
	 else{
	   document.signform.submit();
	 }
   }
    </script>
