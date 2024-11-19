<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnRFQDBPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="QryAllChkBoxEditBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function setSubmit(URL)
{ //alert();  
  document.REASONFORM.action=URL;
  document.REASONFORM.submit();    
}
</script>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<title>Estimating Reason Code Input Page</title>
</head>
<body>
<FORM NAME="REASONFORM" action="../jsp/TSRFQEstimateReasonInsert.jsp"  METHOD="post">
<table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr bgcolor="#CCFFCC">      
      <td width="27%"><div align="center"><font face="Arial" size="2" color="#3366FF">No</font></div></td>
	  <td width="22%"><div align="center"><font face="Arial" size="2" color="#3366FF">Code</font></div></td>
	  <td width="17%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF">Code Desc:</font><font color="#FF0000" size="2"></font></div></td> 
      <td width="13%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF">Locale</font></div></td>
	  <td width="17%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgRemark"/></font></div></td> 	 	  	        
	  <td width="4%" rowspan="2"><div align="center"><INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/TSRFQEstimateReasonInsert.jsp")'></div></td>
    </tr>
  <tr>
    <td>    
    <input type="text" name="NO"  size="20" maxlength="30" >
    </td>
	<td>    
    <input type="text" name="CODE" size="20" maxlength="60" >	
    </td>
    <td><div align="center"><input type="text" name="DESC"  size="10" maxlength="15"></div>
    </td>
	<td width="13%" bgColor="#ffffff">	   
	   <input name="LOCALE" type="text" size="8" >   	   
    </td>
	<td><div align="center">
	     <input type="text" name="LNREMARK"  size="10" maxlength="60">		 
		 </div>
    </td>    
    </tr>
</table> 
<%
   String pageURL=request.getParameter("PAGEURL");
      
   Statement statement=conRFQ.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql ="select TSREASONNO,REASONCODE,REASONDESC,LOCALE from ORADDMAN.TSREASON where TSREASONNO > '0' order by TSREASONNO ASC";
	               
   //out.println("sql="+sql);  
   rs=statement.executeQuery(sql);

   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(null);
   qryAllChkBoxEditBean.setSearchKey("TSREASONNO");
   //qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(10);
       
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();
   rs.close();
%>   

<!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnRFQDBPage.jsp"%>
<!--=================================-->
</FORM>
</body>
</html>
