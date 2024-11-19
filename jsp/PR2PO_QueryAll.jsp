<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsCountBean"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnDominoPage(NOTESAPP).jsp"%>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title>Query All BPCS PO those were ready to receive </title>
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
function prDetail(prURL)
{ 
  subWin=window.open(prURL,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
}
</script>
<body>
<%
String searchString=request.getParameter("SEARCHSTRING"); 
%>
<FORM ACTION="PR2PO_QueryAll.jsp" METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A><BR> 
<strong><font color="#004080" size="4">申購單(PR)轉採購通知單(PO)總表</font></strong>
<%
String sSql="";
int maxrow=0;
Statement bpcsStat=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet rs=null;
try
{     
    Database db=sess_notes.getDatabase(sess_notes.getServerName(),"dbtel_tp/tpepu.nsf"); //取下一層目錄的資料庫其符號為右上左下的斜線"/"
    View v=(View)db.getView("AllDoc_234");  
	Document doc=null; 

   sSql="select unique substr(c.VNDNAM,1,12)||'...('||VENDORCODE||')' as vendorname,VENDORCODE,PO_NO,PR_NO,PR_APPLYTYPENAME,b.TNAME,SHIPTOCODE,PR_APPLICANT,PR_APPLYDATE,RECEIVED_FLAG,PAID_FLAG from PR2PO a,EST b,AVM c"+
        " where SHIPTOCODE=b.TSHIP and VENDORCODE=c.VENDOR ";		
   if (UserRoles.indexOf("admin")<0) //若角色不是admin,則只能看到屬於自己轉換過的PO
   {
      sSql=sSql+" and USER_MAIL='"+userMail+"'";
   }		
   
   if (searchString!=null && !searchString.equals(""))
   {
     sSql=sSql+" and (PR_NO like '"+searchString+"%' or substr(PO_NO,1) like '"+searchString+"%' or VNDNAM like '"+searchString+"%' or substr(VENDORCODE,1) like '"+searchString+"%' or TNAME like '"+searchString+"%' or substr(SHIPTOCODE,1) like '"+searchString+"%')";
   }		
   sSql=sSql+" ORDER BY SHIPTOCODE,PO_NO,PR_NO";
   rs=bpcsStat.executeQuery(sSql); 
   
   rsCountBean.setRs(rs); 
   maxrow=rsCountBean.getRsCount();     
%>
<table width="85%" border="1">
<tr>
<td>PR/PO號碼,廠商名稱/代碼,部門名稱/代碼:
  <INPUT type="text" name="SEARCHSTRING" size=20 <%if (searchString!=null) out.println("value="+searchString);%>>  <INPUT name="button" TYPE="submit"  value="Query" > </td>
</tr>
</table> 
<TABLE width="85%" border="1" cellspacing="0">
  <tr bgcolor="#0099CC">    
	<td width="3%"><font size="2">&nbsp;&nbsp;</font></td>
    <td width="5%"><font color="#FFFFFF" size="2"><strong>驗收</strong></font></td>
    <td width="5%"><font color="#FFFFFF" size="2"><strong>請款</strong></font></td>
    <td width="30%"><strong><font color="#FFFFFF" size="2">廠商</font></strong></td>
    <td width="6%"><strong><font color="#FFFFFF" size="2">PO號碼</font></strong></td>
	<td width="9%"><strong><font color="#FFFFFF" size="2">申購單號碼</font></strong></td>
	<td width="7%"><strong><font color="#FFFFFF" size="2">申購類別</font></strong></td>
	<td width="14%"><strong><font color="#FFFFFF" size="2">申購部門</font></strong></td>
	<td width="9%"><strong><font color="#FFFFFF" size="2">申購人</font></strong></td>
	<td width="12%"><strong><font color="#FFFFFF" size="2">申購日期</font></strong></td>	
  </tr>	
<%   
   if (maxrow>0)
   {
	   while (rs.next())
	   {      
		 String PRNO=rs.getString("PR_NO"); 
		 String PONO=rs.getString("PO_NO");	 
		 
		 doc=v.getDocumentByKey(PRNO);	
		  if (doc!=null) 
		  {
			 String docID=doc.getUniversalID();
			 String docUrl="http://"+dominoConn.getServerName()+"/dbtel_tp/tpepu.nsf/w_viwSample/"+docID+"?OpenDocument";
%>
    <tr >    
    <td ><font size="2"><A href='javaScript:prDetail("<%=docUrl%>")'><img src='../image/docicon.gif'></A></font></td>
    <td >
	  <div align="center">
        <%
	 if (rs.getString("RECEIVED_FLAG").equals("Y"))  out.println("<img src='../image/YES.gif'>"); else  out.println("<img src='../image/NG.gif'>");
	%>
	    </div></td>
    <td >
	  <div align="center">
        <%
	 if (rs.getString("PAID_FLAG").equals("Y"))  out.println("<img src='../image/YES.gif'>"); else  out.println("<img src='../image/NG.gif'>");
	%>	
      </div></td>
    <td ><font size="2"><%=rs.getString("vendorname")%></font></td>
	<td ><font size="2"><%=PONO%></font></td>
	<td ><font size="2"><%=PRNO%></font></td>
	<td ><font size="2"><%=rs.getString("PR_APPLYTYPENAME")%></font></td>
	<td ><font size="2"><%=rs.getString("TNAME")%>(<%=rs.getString("SHIPTOCODE")%>)</font></td>
	<td ><font size="2"><%=rs.getString("PR_APPLICANT")%></font></td>
	<td ><font size="2"><%=rs.getString("PR_APPLYDATE")%></font></td>	
    </tr>	
<%   
		  } //end of if->doc!=null  
	   } //end of while =>rs.next()  
   } //end of if => maxrow>0    
   rs.close();   
   
   if (doc!=null) doc.recycle();
   v.recycle();
   db.recycle(); 
} //end of try
catch (Exception ec)
{
   out.println("Exception:"+ec.getMessage());
   %>
     <%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%> 
   <%
}
bpcsStat.close();
%>	 	
</TABLE>	
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>

