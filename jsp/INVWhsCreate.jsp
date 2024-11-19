<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<html>
<head>
<title>Whs Create FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function submitCheck()
{  
  if (document.MYFORM.WHS.value==null || document.MYFORM.WHS.value=="")
  { 
   alert("請先輸入您欲新增的倉別後再存檔!!");   
   return(false);
  } 

  if (document.MYFORM.LOC.value==null || document.MYFORM.LOC.value=="")
  { 
   alert("請先輸入您欲新增的架位後再存檔!!");   
   return(false);
  }
  if (document.MYFORM.WHSDESC.value=="" || document.MYFORM.WHSDESC.value==null)
  { 
   alert("請先輸入您欲新增之敘述後再存檔!!");   
   return(false);
  } 
      
   return(true);      
}  
</script>
<body>
<FORM NAME="MYFORM" onsubmit='return submitCheck()' ACTION="INVWhsInsert.jsp" METHOD="post">
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> &nbsp;&nbsp <!--A HREF="file:///O|/webapps/repair/jsp/MRQAll.jsp">查詢所有領料案件</A--> 
  <BR>


<%
  String whs=request.getParameter("WHS");
  String whsDesc=request.getParameter("WHSDESC");
  String loc = request.getParameter("LOC");	
%>
  <font color="#0080FF" size="5"><strong>新增倉別/架位</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td>Whs: 
        <INPUT NAME="WHS" TYPE="text" size="2" maxlength="2"> </td>
    </tr>
    <tr> 
      <td>Loc: 
        <INPUT NAME="LOC" TYPE="text" size="6" maxlength="6"></td>	
    </tr>
    <tr> 
      <td>Whs Desc: 
        <INPUT NAME="WHSDESC" TYPE="text" size="15" maxlength="15"></td>	
    </tr>	
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
</FORM>
  <!--A HREF="INVItemQueryAll.jsp">Query All Item</A--> 
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
