<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
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
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<title>Oracle Workflow Re-Start MO、PO API</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<body>
<FORM METHOD="POST"  NAME="MYFORM" action="../jsp/WFAPIStartProcess.jsp"> 
<%
   String itemTYPE=request.getParameter("ITEMTYPE"); // 傳入要處理的ITEM TYPE (OEOH , POAPPRV, REQAPPRV )
   if (itemTYPE==null) itemTYPE = "OEOH"; // 如果未給ITEM TYPE (OEOH , POAPPRV, REQAPPRV )
   
%>
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial"></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>Oracle Workflow MO、PO、PR Process restart API</strong></font>
<BR>
<A href="/oradds/ORAddsMainMenu.jsp">回首頁</A>
<table cellSpacing='0' bordercolordark='#D8DEA9'  cellPadding='1' width='50%' borderColorLight='#ffffff' border='1'>     	 	 
	 <tr>	    
		<td width="26%" colspan="1" nowrap><font color="#006666"><strong>項目類型</strong></font></td> 
		<td width="74%" colspan="1">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
		   
		   <%
		   // REQAPPRV, OEOH , POAPPRV
		   
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select DISTINCT a.MESSAGE_TYPE, a.MESSAGE_TYPE||'('||b.DISPLAY_NAME||')' "+
			                          "from APPLSYS.WF_NOTIFICATIONS a, APPLSYS.WF_ITEM_TYPES_TL b ";
			       String whereOType = "where a.MESSAGE_TYPE = b.NAME and b.LANGUAGE ='ZHT' and a.MESSAGE_TYPE in ('OEOH','OEOL','POAPPRV','REQAPPRV') ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(itemTYPE);
	               comboBoxBean.setFieldName("ITEMTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		      
		   %>   
		   </div>
		</td> 
   </tr>	
   <tr>
     <td><font color="#006666"><strong>MO單號、MO LINE ID、PO或PR單號</strong></font></td><td><font color="#006666"><strong><input name="DOCNO" tabindex='9' type="text" size="20" maxlength="60"></strong></font></td>     
   </tr>
   <tr>
     <td colspan="2"><INPUT TYPE="button" align="middle"  value='Submit' onClick='setSubmit("../jsp/WFAPIStartProcess.jsp")' > </td>
   </tr>
  </table> 
  <INPUT TYPE="hidden" NAME="NOTIFYTYPE" VALUE="startProcess">  
  </FORM>
</body>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
