<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditGroup.jsp</title>
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
<table width="322" height="106" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>修改群組記錄</H4>
          
    <td width="340" height="102" bgcolor=#CCFFFF> <div align="left"> 
      <form action="EditGroupDb.jsp" method="post" name="signform" onsubmit="return getNum()">
 
   群組名稱:<%
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select GROUPNAME,GROUPNAME from Wsgroup ");
			  comboBoxBean.setRs(rs);
			  comboBoxBean.setSelection("jsp");
	          comboBoxBean.setFieldName("GROUPNAME");
              out.println(comboBoxBean.getRsString());
			  statement.close();
			  rs.close();
	          %><br>
     <input type="submit" name="submit" value="修改" >
     <input name="reset" type="reset" value="清除"><br>
        <a href="../jsp/GroupClass.jsp">回上一頁</a>
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
     sel = document.signform.GROUPNAME.selectedIndex;
	 if (sel==0){
	  alert("請選擇群組名稱!!");
	    return (false);
	 }
	 else{
	   document.signform.submit();
	 }
   }
    </script>
