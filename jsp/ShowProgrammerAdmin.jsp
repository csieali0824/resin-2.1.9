<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,QueryAllCheckBoxBean"  %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllRepairBean2" %>
<%@ page import="QryAllChkBoxEditBean" %>
<html>
<head>
<title>ShowProgrammer.jsp</title>
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
  location.href="../jsp/ShowProgrammerAdmin.jsp?PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value  
}
</script>
<body>
<jsp:useBean id="queryAllRepairBean" scope="session" class="QueryAllRepairBean2"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="queryAllCheckBoxBean" scope="session" class="QueryAllCheckBoxBean"/>

<FORM ACTION="../jsp/ProgrammerDelAdmin.jsp" METHOD="POST" NAME="MYFORM" onSubmit="return NeedConfirm()">
  <font color="#0080C0" size="3"> <strong>
  <%
  if(UserRoles.indexOf("Admin")>=0) 
 {out.println("查詢程式檔案資訊"); }
 else
 {out.println("查詢所有角色記錄"); }
  %>
  </strong></font> 
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
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {
     rowNumber=-1;	 
   } else {
     rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }     
  
  int currentPageNumber=0,totalPageNumber=0;  
 
  try
  {   
   Statement statement=con.createStatement(); 
   ResultSet rs=null;
   if (searchString!=null) //如果有搜尋特定單號則另下SQL
   {  
     rs=statement.executeQuery("select count(*) from WSPROGRAMMER where ROLENAME='admin'  and ( ADDRESS LIKE '%"+searchString+"%' or ADDRESSDESC LIKE '%"+searchString+"%' or MODEL LIKE '%"+searchString+"%' or LINENO LIKE '%"+searchString+"%')");
   }
    else    
   {
     if(UserRoles.indexOf("Admin")>=0)
	 {rs=statement.executeQuery("select count(*) from WSPROGRAMMER where ROLENAME='admin'");}
	 else
	 {rs=statement.executeQuery("select count(*) from WSPROGRAMMER where ROLENAME=!'admin'");}
   }	 
	
   rs.next();   
   maxrow=rs.getInt(1);
   out.println("<FONT COLOR=BLACK SIZE=2>(總共"+maxrow+"筆記錄)</FONT>"); 
   statement.close();
   rs.close();
   
  
       totalPageNumber=maxrow/30;
	   if(maxrow/30<=0)
	   {totalPageNumber=1; }
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
    <td><A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;
		<%
		if(UserRoles.indexOf("Admin")>=0) 
		{out.println("<A HREF='../jsp/CreateProgrammer.jsp'>新增檔案資訊"+"</A>"); }
		%>
  </td>
      <td><strong><font color="#400040" size="2">網址、Key No、模組、序號:</font></strong> 
        <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null ) out.println("value="+searchString);%>> 
      <input name="search" type=button onClick="searchRepNo('<%=pageURL%>')" value="<-搜尋"></td>
  </tr>
</table>
<input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取">
<INPUT TYPE="submit" value="刪除">
  &nbsp;&nbsp; <A HREF="../jsp/ShowProgrammerAdmin.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST"><font size="2"><strong><font color="#FF0080">最後一頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=30">下一頁</A>&nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp?PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-30">上一頁</A>(第頁<%=currentPageNumber%>/共</font><font color="#FF0080"><strong><font size="2"><%=totalPageNumber%></font></strong></font><font size="2">頁)&nbsp;&nbsp;</font></strong></font> 
  <% 
  try
  {  
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
    ResultSet rs=null;
     if (searchString!=null) //如果有搜尋特定單號則另下SQL
     { 
	  rs=statement.executeQuery("select ROLENAME,ADDRESS,ADDRESSDESC,MODEL,PROGRAMMERNAME,LINENO from WSPROGRAMMER where ROLENAME='admin'  and ( ADDRESS LIKE '%"+searchString+"%' or ADDRESSDESC LIKE '%"+searchString+"%' or MODEL LIKE '%"+searchString+"%' or LINENO LIKE '%"+searchString+"%') Order By ROLENAME,LINENO");	   
     } 
	 else
	  {
		  if(UserRoles.indexOf("Admin")>=0)
		  { rs=statement.executeQuery("select ROLENAME,ADDRESS,ADDRESSDESC,MODEL,PROGRAMMERNAME,LINENO from WSPROGRAMMER where ROLENAME='admin' order by ROLENAME,LINENO");}
		  else
		  {rs=statement.executeQuery("select ROLENAME,ADDRESS,ADDRESSDESC,MODEL,PROGRAMMERNAME,LINENO from WSPROGRAMMER where ROLENAME!='admin'  order by ROLENAME,LINENO");}
	 
	 }	   



   if (rowNumber==1)
   {
     rs.beforeFirst(); 
   } else {
     if (rowNumber==-1)
	 {
	   rs.absolute(-30);
	 } else {
      rs.absolute(rowNumber); //2?|U?ucw﹐eRA|C
	 }
   }
      
  /* queryAllRepairBean.setPageURL("../jsp/BBB.jsp");//小圖示連結到修改的網頁  
   queryAllRepairBean.setSearchKey("USERID");//傳到下一個網頁以那一個變數為主
   queryAllRepairBean.setRs(rs);
   queryAllRepairBean.setScrollRowNumber(30);
   out.println(queryAllRepairBean.getRsString());
   //另外一種呈現方式 ,沒有checkbox的*/
   
   qryAllChkBoxEditBean.setPageURL("../jsp/ProgrammerEditAdmin.jsp");//小圖示連結到修改的網頁
   //String at[]={"ADDRESSDESC","ROLENAME"};//下一頁直接以String ADDRESS=request.getParameter("ADDRESS");接及可
   //qryAllChkBoxEditBean.setSearchKeyArray(at);//以陣列傳到下一個網頁以那一個變數為主
if(UserRoles.indexOf("Admin")>=0)
{   qryAllChkBoxEditBean.setSearchKey("ADDRESS");}
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);  
   qryAllChkBoxEditBean.setScrollRowNumber(30);
   out.println(qryAllChkBoxEditBean.getRsString());
   
   /*queryAllCheckBoxBean.setRs(rs);
   //queryAllCheckBoxBean.setSearchKey("ADDRESS");
   queryAllCheckBoxBean.setFieldName("CH");
   queryAllCheckBoxBean.setRowColor1("B0E0E6");
   queryAllCheckBoxBean.setRowColor2("ADD8E6");
   out.println(queryAllCheckBoxBean.getRsString());*/
   
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
