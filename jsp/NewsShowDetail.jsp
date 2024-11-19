<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<STYLE type=text/css>
A:link {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:active {
	TEXT-DECORATION: none
}
A:visited {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:hover {
	COLOR: #3333FF; TEXT-DECORATION: none
}
td {
	font-size: 12px;
}
.tab {
	background-image:   url(../jsp/image/bd-2.jpg);
	background-repeat: no-repeat;
	background-position: right bottom;
	background-color: #FFFFFF;
}
</STYLE>
<html>
<head>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }  
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<title>NewsShowDetail.jsp</title>
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
  location.href="../jsp/NewsShow.jsp?PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value  
}
function submitCheck()
{

}
</script>
<body background="">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
  <%   
  String NewsID=request.getParameter("NEWSID");
  %>
<FORM NAME="MYFORM" ACTION="../jsp/NewShowAttchInsert.jsp" METHOD="post" onSubmit='return submitCheck()' ENCTYPE="multipart/form-data" >  
<% 
  try
  {  
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select NEWSID,ESDATE,NEWSDESC,OWNERNAME,T.NEWSTYPE from ORADDMAN.TSNEWS R,ORADDMAN.TSNEWSTYPE T where R.NEWSTYPE=T.NEWSTYPE AND R.NEWSID like '"+NewsID+"%'  order by R.NEWSID");	   
    while(rs.next())
    {
    String newsid=rs.getString("NEWSID");
	String esdate=rs.getString("ESDATE");
	//String newssubject=rs.getString("NEWSSUBJECT");
	String newsdesc=rs.getString("NEWSDESC");
	String ownername=rs.getString("OWNERNAME");
	String newstype=rs.getString("NEWSTYPE");
	%>
  
<table cellSpacing="0" bordercolordark="#66CC99"  cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr> 
    <td width="24%"><jsp:getProperty name="rPH" property="pgClassOfTopic"/></td>
    <td width="76%"><%=newstype%></td>
  </tr>
    <tr> 
    <td width="24%"><jsp:getProperty name="rPH" property="pgNo"/></td>
    <td width="76%"><%=newsid%></td>
  </tr>
  <tr> 
    <td><jsp:getProperty name="rPH" property="pgPublisher"/></td>
    <td><%=ownername%></td>
  </tr>
  <tr> 
    <td><jsp:getProperty name="rPH" property="pgPublishDate"/></td>
    <td><%=esdate%></td>
  </tr>  
  <tr> 
    <td height="300"><jsp:getProperty name="rPH" property="pgContent"/></td>
    <td valign="top"><br><%=newsdesc%></td>
  </tr>
 </table>
<%}
   statement.close();    
   rs.close();     
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <BR>
<table border="0" width="100%">
  <tr>
    <td>
       <% 
          String fileName = "";
          String imageName = "";      
          Statement stateBlob=con.createStatement();		  
          ResultSet rsBlob=stateBlob.executeQuery("select FILE_NAME from ORADDMAN.TSDNOTICE_DOC where DNDOCNO='"+NewsID+"' and TYPE='NEWS' ");
          if (rsBlob.next()) 
          { 
            //int dotIndex =  rsBlob.getString("SPECFILE_NAME").indexOf(".",0);
            //int specfileLength = rsBlob.getString("SPECFILE_NAME").length(); 
            fileName=rsBlob.getString("FILE_NAME");               
            if (fileName==null || fileName.equals(""))
            {  out.println("!!! 本公告未附說明附件 !!!");  }
            else { 
                  //String fileNameExt = rsBlob.getString("SPECFILE_NAME").substring(dotIndex,specfileLength);
                  
                  out.println("<A HREF='../jsp/NewsShowAttachFile.jsp?DNDOCNO="+NewsID+"'>公告檔附件下載:(檔案名稱="+rsBlob.getString("FILE_NAME")+")</A>");
                 }  
          }
          else {  
		           
		          out.println("!!! 本公告未附說明附件 !!!"); 
			   }   
          rsBlob.close();
          stateBlob.close();       
               
       %>
         <!--%<A HREF="../jsp/ShowMRFile.jsp?APPNO=<!%=appNo%>">產品申請規格檔下載:<!%=appNo%></A>%-->
    </td>
  </tr>
</table>
<BR>
<%
// 管理員才看得到新增附件功能
 if (UserRoles.indexOf("admin")>=0) // ???,???????
 { 

%>
  <font color="#004080"><strong>DOCUMENT FILE Upload</strong></font><BR>
<table cellSpacing="0" bordercolordark="#66CC99"  cellPadding="1" width="80%" align="left" borderColorLight="#ffffff" border="1">
    <tr> 
      <td><div align="right"><font size="2">Specification File </font></div></td>
      <td><font size="2"><INPUT TYPE="FILE" NAME="SPECFILE"></font></td>
    </tr>
    <TR>
	   <td><input type="submit" name="submit" value="存檔"><input type="reset" name="reset" value="取消"></td>
	</TR>
</table>  
<BR>  
<%
  }  // End of if (UserRoles.indexOf("admin")>=0)
%>
<input type="hidden" size="10" name="DNDOCNO" value="<%=NewsID%>">
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
