<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllRepairBean2" %>
<%@ page import="QryAllChkBoxEditBean" %>
<html>
<head>
<title>GroupShow.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
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
 checkflag = "false";
 return "全部選取"; }
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}

function searchRepNo(pageURL) 
{   
  location.href="../jsp/GroupShow.jsp?PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value  
}
</script>
<body>
<jsp:useBean id="queryAllRepairBean" scope="session" class="QueryAllRepairBean2"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<FORM ACTION="../jsp/GroupDelS.jsp" METHOD="POST" NAME="MYFORM" onSubmit="return NeedConfirm()">
  &nbsp;<strong><font color="#0080C0" size="5">查詢所有群組記錄</font></strong> 
  <%   
  int maxrow=0;//查詢資料總筆數 
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null)
  {searchString=""; }
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");
  
  String scrollRow=request.getParameter("SCROLLROW");  
  int rowNumber=queryAllRepairBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   queryAllRepairBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {
     rowNumber=-1;	 
   } else {
     rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     queryAllRepairBean.setRowNumber(rowNumber);
   }	 
  }     
  
  int currentPageNumber=0,totalPageNumber=0;
  
  try
  {   
   Statement statement=con.createStatement(); 
   ResultSet rs=null;
   if (searchString!=null) //如果有搜尋特定單號則另下SQL
   {  
     rs=statement.executeQuery("select count(*) from WsGroup where GROUPNAME like '"+searchString+"%'");
   } else {
     rs=statement.executeQuery("select count(*) from WsGroup order by GROUPNAME");
   }	 
	
   rs.next();   
   maxrow=rs.getInt(1);
   out.println("<FONT COLOR=BLACK SIZE=2>(總共"+maxrow+"筆記錄)</FONT>"); 
   statement.close();
   rs.close();
   
    
    totalPageNumber=maxrow/30+1;
    if (rowNumber==0 || rowNumber<0)
    {
      currentPageNumber=rowNumber/31+1;  
    } else {
      currentPageNumber=rowNumber/30+1; 
    }	
    if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
<BR>
<table width="75%" border="0">
  <tr>
      <td><A HREF="/wins/WinsMainMenu.jsp">回首頁</A>  &nbsp;&nbsp;<A HREF="../jsp/CreateGroup.jsp">新增群組</A></td>
    <td><strong><font color="#400040" size="2">人員名稱:</font></strong> <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>> 
      <input name="search" type=button onClick="searchRepNo('<%=pageURL%>')" value="<-搜尋"></td>
  </tr>
</table>
<input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取">
<INPUT TYPE="submit" value="刪除">
<A HREF="../jsp/GroupShow.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;<A HREF="../jsp/GroupShow.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST"><font size="2"><strong><font color="#FF0080">最後一頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;<A HREF="../jsp/GroupShow.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=30">下一頁</A>&nbsp;&nbsp;<A HREF="../jsp/GroupShow.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-30">上一頁</A>(第頁<%=currentPageNumber%>/共<%=totalPageNumber%>頁)</font></strong></font> 
<% 
  try
  {  
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   //Statement statement=con.createStatement();
   //ResultSet rs=statement.executeQuery("select * from RPREPAIR where REPCENTERNO='"+userRepCenterNo+"'");
    ResultSet rs=null;
    if (UserRoles.indexOf("admin")>=0)
   {   
     if (searchString!=null) //如果有搜尋特定單號則另下SQL
     { 
       rs=statement.executeQuery("select GROUPNAME,GROUPDESC,GROUPPROFILE from WSGROUP where GROUPNAME like '"+searchString+"%'");	   
     } else {
       rs=statement.executeQuery("select GROUPNAME,GROUPDESC,GROUPPROFILE from WSGROUP order by GROUPNAME");
	 }	   
   } else {
    if (searchString!=null) //如果有搜尋特定單號則另下SQL
     { 	   
	   rs=statement.executeQuery("select GROUPNAME,GROUPDESC,GROUPPROFILE from WSGROUP where GROUPNAME like '"+searchString+"%'");
     } else {
	   rs=statement.executeQuery("select GROUPNAME,GROUPDESC,GROUPPROFILE from WSGROUP order by GROUPNAME");
	 }	   
   }	

   if (rowNumber==1)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else {
     if (rowNumber==-1)
	 {
	   rs.absolute(-30);
	 } else {
      rs.absolute(rowNumber); //移至指定資料列
	 }
   }
      
  /* queryAllRepairBean.setPageURL("../jsp/BBB.jsp");//小圖示連結到修改的網頁  
   queryAllRepairBean.setSearchKey("USERID");//傳到下一個網頁以那一個變數為主
   queryAllRepairBean.setRs(rs);
   queryAllRepairBean.setScrollRowNumber(30);
   out.println(queryAllRepairBean.getRsString());*/
   //另外一種呈現方式 ,沒有checkbox的
   
   qryAllChkBoxEditBean.setPageURL("../jsp/EditGroupDb.jsp");//小圖示連結到修改的網頁
   qryAllChkBoxEditBean.setSearchKey("GROUPNAME");//傳到下一個網頁以那一個變數為主
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();    
   rs.close();     
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</FORM>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
