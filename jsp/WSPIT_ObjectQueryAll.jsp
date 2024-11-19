<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean" %>

<html>
<head>
<title>Query All PIT Object</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";w
 return "全部選取"; }
}
function NeedConfirm(field)
{
  var pass = "NO"; 
  if (field.length==null)
  {
     if (field.checked==true) pass="YES";
  } else {
	  for (i = 0; i < field.length; i++) 
	  {    
		if (field[i].checked == true)
		{
		  pass="YES";
		  break;
		}
	  }
  }
  
  if (pass == "NO")
  {
    alert("您沒有選取任何資料!!");
    return false;
  }       
 
  flag=confirm("確定刪除?"); 
  if (flag==false)
  {
    return false;
  } else {     
    document.MYFORM.action="WSPIT_ObjectDel.jsp";
    document.MYFORM.submit(); 
  }  
}

function searchResult() 
{   
  location.href="WSPIT_ObjectQueryAll.jsp?SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value;
}
</script>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<body>
<%  
String searchString=request.getParameter("SEARCHSTRING");
if (searchString==null) searchString=""; 
%><FORM METHOD="POST" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font></font></font><font color="#000000" size="+1" face="Times New Roman"> 
<strong>物件定義</strong></font> <BR>
<INPUT TYPE="Button"  name="Button" value="刪除" onClick="NeedConfirm(this.form.CH)">
&nbsp;&nbsp; <A HREF="../jsp/WSPIT_ObjectInput.jsp">新增物件定義</A>&nbsp;&nbsp;<A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
&nbsp;&nbsp;&nbsp;&nbsp;NAME/DESCRIPTION:
<INPUT type="text" name="SEARCHSTRING" size=20 <%if (searchString!=null) out.println("value="+searchString);%>>
<input name="search" type=button onClick="searchResult()" value='<-搜尋'>
<BR>
<%  
Statement statement=con.createStatement();
ResultSet rs=null; 
String sql="";

try
{      
	   String a[]={"<input name='checkselect' type=checkbox onClick='this.value=check(this.form.CH)' title='選取全部或取消選取'>","","OBJECTID","NAME","DESCRIPTION","MDATE","MTIME","MUSER"};
   qryAllChkBoxEditBean.setHeaderArray(a); //先設置表頭
   
   if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
   {	
	 sql="select objectid,name,description,mdate,mtime,muser from pit_object where description like '"+searchString+"%' or name like '"+searchString+"%' order by objectid";	
   } else {    
	 sql="select objectid,name,description,mdate,mtime,muser from pit_object order by objectid";	
   }        

   rs=statement.executeQuery(sql);   
   qryAllChkBoxEditBean.setPageURL("../jsp/WSPIT_ObjectEdit.jsp");
   qryAllChkBoxEditBean.setSearchKey("objectid");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setScrollRowNumber(0);
   qryAllChkBoxEditBean.setRs(rs);   
   out.println(qryAllChkBoxEditBean.getRsString());   
  
   rs.close();   
} //end of try
catch (Exception e)
{
   out.println("Exception:"+e.getMessage());
}
statement.close(); 
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
