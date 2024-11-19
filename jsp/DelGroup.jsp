<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DelGroup.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<%
  
  try
    {
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
<table width="82%" height="25" border="0" cellpadding="0" cellspacing="8">
  <font color="#e8eef7"></font> 
</table>
<table width="397" height="136" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>刪除群組記錄</H4>
          
    <td width="383" height="132" bgcolor=#CCFFFF> <div align="left"> 
      <form action="DelGroupDb.jsp" method="post" name="signform" onsubmit="return change_acton()">
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

     <input type="submit" name="submit" value="刪除" >
     <input name="reset" type="reset" value="清除"><br>
	 <a href="../jsp/GroupClass.jsp">回上一頁</a>
	 </form>
        </p></table>
		

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

  
  <script language="JavaScript"> 

   function change_acton(){
	var chks = signform.GROUPNAME;
        var checkItems = 0;
	 for (var len = 0; len <chks.length;len++){
		if (chks[len].checked){
			checkItems++;
		}
	 }

     if ( checkItems == 0 ) {
		alert("請選擇群組名稱!!");
	    return (false);
	 }else {
	      document.signform.submit();
     }
   }

    </script>