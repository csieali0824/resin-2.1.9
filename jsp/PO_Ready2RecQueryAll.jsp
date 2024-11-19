<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnDominoPage(NOTESAPP).jsp"%>
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
function setSubmit(URL)
{     
  flag=confirm("確定要驗收所選取的PO?"); 
  if (flag==0)
  {
    return(false);
  } else {
    rstart();
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }  
}
function prDetail(prURL)
{ 
  subWin=window.open(prURL,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
}
function rstart2(){
	showimage.style.visibility = '';
	blockDiv.style.display = '';
	init();
	slide();
	location.href='PO_RecConverter.jsp';
}
</script>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String searchString=request.getParameter("SEARCHSTRING"); 
%>
<FORM ACTION="PO_Ready2RecQueryAll.jsp" METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A><BR> 
<strong><font color="#004080" size="4">待驗收採購通知單(PO)</font></strong>
<%
String sSql="";
Statement bpcsStat=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet rs=null;
try
{     
    Database db=sess_notes.getDatabase(sess_notes.getServerName(),"dbtel_tp/tpepu.nsf"); //取下一層目錄的資料庫其符號為右上左下的斜線"/"
    View v=(View)db.getView("AllDoc_234");  
	Document doc=null; 

   sSql="select unique c.VNDNAM||'('||VENDORCODE||')' as vendorname,VENDORCODE,PO_NO,PR_NO,PR_APPLYTYPENAME,b.TNAME,PR_APPLICANT,PR_APPLYDATE from PR2PO a,EST b,AVM c"+
        " where SHIPTOCODE=b.TSHIP and VENDORCODE=c.VENDOR and TRANS_FLAG='Y' and RECEIVED_FLAG!='Y'";		
   if (UserRoles.indexOf("admin")<0) //若角色不是admin,則只能看到屬於自己轉換過的PO
   {
      sSql=sSql+" and USER_MAIL='"+userMail+"'";
   }		
   
   if (searchString!=null && !searchString.equals(""))
   {
     sSql=sSql+" and (PR_NO like '"+searchString+"%' or substr(PO_NO,1) like '"+searchString+"%')";
   }		
   sSql=sSql+" ORDER BY VENDORCODE,PO_NO,PR_NO";
   rs=bpcsStat.executeQuery(sSql);   
%>
<table width="80%" border="1">
<tr>
<td width="36%">PR或PO號碼:
  <INPUT type="text" name="SEARCHSTRING" size=10 <%if (searchString!=null) out.println("value="+searchString);%>></td>
<td width="20%"><INPUT name="button" TYPE="submit"  value="Query" ></td>
<td width="44%"><INPUT name="button2" TYPE="button"  onClick='setSubmit("PO_RecConverter.jsp")' value="驗收"> </td>
</tr>
</table> 
<TABLE width="80%" border="1" cellspacing="0">
  <tr bgcolor="#66CCCC">
    <td width="4%"><font size="2"><input name="checkselect" type=checkbox onClick="this.value=check(this.form.CH)" title="選取或取消選取"></font></td>
	<td width="3%"><font size="2">&nbsp;&nbsp;</font></td>
    <td width="29%"><strong><font size="2">廠商</font></strong></td>
    <td width="8%"><strong><font size="2">PO號碼</font></strong></td>
	<td width="12%"><strong><font size="2">申購單號碼</font></strong></td>
	<td width="9%"><strong><font size="2">申購類別</font></strong></td>
	<td width="17%"><strong><font size="2">申購部門</font></strong></td>
	<td width="8%"><strong><font size="2">申購人</font></strong></td>
	<td width="10%"><strong><font size="2">申購日期</font></strong></td>	
  </tr>	
<%   
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
    <td ><font size="2"><INPUT TYPE=checkbox NAME='CH' value='<%=PONO%>'></font></td>
    <td ><font size="2"><A href='javaScript:prDetail("<%=docUrl%>")'><img src='../image/docicon.gif'></A></font></td>
    <td ><font size="2"><%=rs.getString("vendorname")%></font></td>
	<td ><font size="2"><%=PONO%></font></td>
	<td ><font size="2"><%=PRNO%></font></td>
	<td ><font size="2"><%=rs.getString("PR_APPLYTYPENAME")%></font></td>
	<td ><font size="2"><%=rs.getString("TNAME")%></font></td>
	<td ><font size="2"><%=rs.getString("PR_APPLICANT")%></font></td>
	<td ><font size="2"><%=rs.getString("PR_APPLYDATE")%></font></td>	
    </tr>	
<%   
      } //end of if->doc!=null  
   } //end of while =>rs.next()   
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--=================================-->
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>