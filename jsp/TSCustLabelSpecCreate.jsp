<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<!--=================================-->
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
.style1 {color: #990033}
.style3 {
	color: #000099;
	font-weight: bold;
}
</STYLE>
<html>
<head>
<STYLE TYPE='text/css'>  
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
             
.style2 {
	font-size: 24px;
	font-family: Tahoma, Georgia;
	font-style: italic;
	font-weight: bold;
}
</STYLE>
<title>CSL System Specification File Upload</title>
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
function subWindowCustInfoFind(custNo,custName,ouORGID)
{ 
   if (event.keyCode==13)
   {    
    subWin=window.open("../jsp/subwindow/TSCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName+"&OUORGID="+ouORGID,"subwin","width=640,height=480,scrollbars=yes,status=yes,menubar=yes");  
   }	
}
function setCustInfoFind(custID,custName,ouORGID)
{   //alert(ouORGID);
    subWin=window.open("../jsp/subwindow/TSCustomerInfoFind.jsp?CUSTOMERNO="+custID+"&NAME="+custName+"&OUORGID="+ouORGID,"subwin","width=640,height=480,scrollbars=yes,status=yes,menubar=yes");  
}

function submitCheck()
{
   // 確認存檔檢查
   if (document.MYFORM.MARKETTYPE.value==null || document.MYFORM.MARKETTYPE.value=="" || document.MYFORM.MARKETTYPE.value=="--")
   {
      alert("請選擇內外銷型別!!!"); 
	  document.MYFORM.MARKETTYPE.focus();
	  return false;
   }
   
   if (document.MYFORM.STATNO.value==null || document.MYFORM.STATNO.value=="" || document.MYFORM.STATNO.value=="--")
   {
      alert("請選擇標籤站別!!!"); 
	  document.MYFORM.STATNO.focus();
	  return false;
   }
   
   if (document.MYFORM.TYPE_ID.value==null || document.MYFORM.TYPE_ID.value=="" || document.MYFORM.TYPE_ID.value=="--")
   {
      alert("請選擇標籤類型!!!"); 
	  document.MYFORM.TYPE_ID.focus();
	  return false;
   }
   
   if (document.MYFORM.CUSTOMERNO.value==null || document.MYFORM.CUSTOMERNO.value=="" || document.MYFORM.CUSTOMERNO.value=="--")
   {
      alert("請選擇客戶資料!!!"); 
	  document.MYFORM.CUSTOMERNO.focus();
	  return false;
   }
   
   if (document.MYFORM.ITEMCATE.value==null || document.MYFORM.ITEMCATE.value=="")
   {
      alert("請選擇產品族群資料!!!"); 
	  document.MYFORM.ITEMCATE.focus();
	  return false;
   }
   /*
           flag=confirm("是否確認儲存工令?");      
           if (flag==false) return(false);
           else {
                  document.MYFORM.action=URL;
                  document.MYFORM.submit(); 
		        }
   */
}
</script>
<body background="">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%    

  
     String customerId=request.getParameter("CUSTOMERID"); 
     String customerNo=request.getParameter("CUSTOMERNO");
     String customerName=request.getParameter("CUSTOMERNAME");
	 String stationNo=request.getParameter("STATNO");
     String typeID=request.getParameter("TYPE_ID");
	 String itemCate=request.getParameter("ITEMCATE");
	 String organizationID=request.getParameter("MARKETTYPE");
	 
	 if (customerId==null || customerId.equals("")) customerId="";
     if (customerNo==null || customerNo.equals("")) customerNo="";
     if (customerName==null || customerName.equals("")) customerName="";
  
%>
<FORM NAME="MYFORM" ACTION="TSCustLabelSpecInsert.jsp" METHOD="post" onSubmit='return submitCheck()' ENCTYPE="multipart/form-data" >   
 <font size="+3" face="Arial Black" color="#000099"><em>TSC</em></font><span class="style1 style2">客戶特殊規格標籤新增</span><BR>
<img src="../image/point.gif"><font color="#FF6600">為必填欄位,請務必輸入</font>
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
   <tr bgcolor="#D1E2FE">
    <td width="25%"><font color="#330099"><span class="style1">&nbsp;</span>內銷/外銷<img src="../image/point.gif"></font>
    <%
		         try
                 {   
				   //-----取內外銷別
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select ORGANIZATION_ID,CODE_DESC from APPS.YEW_MFG_DEFDATA ";
			       String whereOType = " where DEF_TYPE='MARKETTYPE'  ";								  
				   String orderType = "  ";  				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(organizationID);
	               comboBoxBean.setFieldName("MARKETTYPE");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();			
					 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
			
		%>
     </td>	 
     <td width="31%"><font color="#330099"><span class="style1">&nbsp;</span>標籤站別<img src="../image/point.gif"></font>
         <%
		         try
                 {  
				   //-----取標籤站別  
		           Statement stateStatNo=con.createStatement();
                   ResultSet rsStatNo=null;	
			       String sqlStatNo = " select STATNO, STATNO||'('||STATNAME||')' from ORADDMAN.TSCUST_LABEL_STATION ";
			       String whereStatNo = "   ";								  
				   String orderStatNo = "  ";  				   
				   sqlStatNo = sqlStatNo + whereStatNo;
				   //out.println(sqlOrgInf);
                   rsStatNo=stateStatNo.executeQuery(sqlStatNo);				  
		           comboBoxBean.setRs(rsStatNo);
		           comboBoxBean.setSelection(stationNo);
	               comboBoxBean.setFieldName("STATNO");	   
                   out.println(comboBoxBean.getRsString());		    		  
		           rsStatNo.close();   
				   stateStatNo.close(); 					 
					 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
		%>
     </td> 
	 <td width="44%"><font color="#330099"><span class="style1">&nbsp;</span>標籤類型<img src="../image/point.gif"></font>
         <%
		      try
              { 
				   //-----取標籤類型 
		           Statement stateType=con.createStatement();
                   ResultSet rsType=null;	
			       String sqlType = " select TYPE_ID, TYPE_ID || '(' ||TYPE_NAME || ')' from ORADDMAN.TSCUST_LABEL_TYPE ";
			        String whereType = "   ";								  
				   String orderType = "order by TYPE_ID ";  				   
				   sqlType = sqlType + whereType + orderType;
				   //out.println(sqlOrgInf);
                   rsType=stateType.executeQuery(sqlType);				  
		           comboBoxBean.setRs(rsType);
		           comboBoxBean.setSelection(typeID);
	               comboBoxBean.setFieldName("TYPE_ID");	   
                   out.println(comboBoxBean.getRsString());		    		  
		           rsType.close();   
				   stateType.close(); 	 		  
  
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
		%>
     </td>	   
  </tr>
  <tr bgcolor="#D1E2FE">	
     <td colspan="2"><font color="#330099"><span class="style1">&nbsp;</span>客戶資訊<img src="../image/point.gif"></font>
	    <input type="text" size="10" name="CUSTOMERNO" tabindex='6' onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,<%="325"%>)' value="<%=customerNo%>">	        
              <input name="button3" type="button" tabindex='7' onClick='setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.MARKETTYPE.value)' value="...">		
        <input type="text" size="50" name="CUSTOMERNAME" tabindex='8' onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.MARKETTYPE.value)' value="<%=customerName%>"> </font>  
	</td>
	<td><font color="#330099"><span class="style1">&nbsp;</span>產品族群</font><img src="../image/point.gif">
	  <%
	             try
                 {  
				   //-----取產品族群  
		           Statement stateCate=con.createStatement();
                   ResultSet rsCate=null;	
			       String sqlCate = " select DISTINCT SEGMENT1,SEGMENT1 from MTL_ITEM_CATEGORIES_V ";
			        String whereCate = "where CATEGORY_SET_NAME='TSC_Package' ";								  
				   String orderCate = "  ";  				   
				   sqlCate = sqlCate + whereCate;
				   //out.println(sqlOrgInf);
                   rsCate=stateCate.executeQuery(sqlCate);				  
		           comboBoxAllBean.setRs(rsCate);
		           comboBoxAllBean.setSelection(itemCate);
	               comboBoxAllBean.setFieldName("ITEMCATE");	   
                   out.println(comboBoxAllBean.getRsString());		    		  
		           rsCate.close();   
				   stateCate.close(); 	  
					 
					 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
	  
	  
	  %> 
	 </td>
	  
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤樣本檔<img src="../image/point.gif"></font>
	  <INPUT TYPE="FILE" NAME="SPECFILE" width="10">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>特殊圖樣檔</font>
	  <INPUT TYPE="FILE" NAME="ICONFILE" width="20">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤預覽圖檔</font>
	  <INPUT TYPE="FILE" NAME="PREVFILE" width="20">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">
     <td colspan="3"><span class="style3">標籤變數(屬性)說明 ： 以下針對不同客戶於各製程作業階段列印標籤,請給定其標籤變數</span><br>
	                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 <span class="style3"> 例•客戶於包裝站需額外加上客戶品號,則給定變數名為 CUSTITEM<br>
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 系統於該製程站標籤列印時,即依變數名至ERP擷取客戶品號資訊並列印標籤。
					 </span>
	 </td>
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;1&nbsp;</font>
	  <input name="ATTRIBUTE1" tabindex='10' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;2&nbsp;</font>
	  <input name="ATTRIBUTE2" tabindex='11' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;3&nbsp;</font>
	  <input name="ATTRIBUTE3" tabindex='12' type="text" size="15" value="<%=%>">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;4&nbsp;</font>
	  <input name="ATTRIBUTE4" tabindex='13' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;5&nbsp;</font>
	  <input name="ATTRIBUTE5" tabindex='14' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;6&nbsp;</font>
	  <input name="ATTRIBUTE6" tabindex='15' type="text" size="15" value="<%=%>">
	</td>
   </tr>
    <tr bgcolor="#D1E2FE">	
    <td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;7&nbsp;</font>
	  <input name="ATTRIBUTE7" tabindex='16' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;8&nbsp;</font>
	  <input name="ATTRIBUTE8" tabindex='17' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名&nbsp;9&nbsp;</font>
	  <input name="ATTRIBUTE9" tabindex='18' type="text" size="15" value="<%=%>">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名10</font>
	  <input name="ATTRIBUTE10" tabindex='19' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名11</font>
	  <input name="ATTRIBUTE11" tabindex='20' type="text" size="15" value="<%=%>">
	</td>
	<td width="25%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>標籤屬性名12</font>
	  <input name="ATTRIBUTE12" tabindex='21' type="text" size="15" value="<%=%>">
	</td>
   </tr>
 </table>  
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
   <tr bgcolor="#D1E2FE">
    <td width="10%"><font color="#330099"><span class="style1">&nbsp;</span>附註</font></td>
	<td width="90%" colspan="2" bgcolor="#FFFFFF"><input name="REMARK" tabindex='49' type="text" size="80" value="<%=%>"></td>
   </tr>
 </table>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
 <tr bgcolor="#D1E2FE">   
 <td width="12%" align="center">
  <strong><font color="#330099" face="Arial">處理人員</font></strong> 
 </td>
 <td width="15%" bgcolor="#FFFFFF" align="center"> 
    <font color='#000099' face="Arial" ><strong><%=userID+"("+UserName+")"%></strong></font>	 
 </td>
 <td width="10%" bgcolor="#D1E2FE" align="center">
  <strong><font color="#330099" face="Arial">處理日期</font></strong> 
 </td>
 <td width="10%" bgcolor="#FFFFFF" align="center"> 
   <font color="#000099" face="Arial"><strong><% out.println(dateBean.getYearMonthDay());%></strong></font>	 
 </td> 
 <td width="10%" bgcolor="#D1E2FE" align="center">
  <strong><font color="#330099" face="Arial" >處理時間</font></strong> 
 </td>
 <td width="10%" bgcolor="#FFFFFF" align="center"> 
    <font color='#000099' face="Arial" ><strong><%out.println(dateBean.getHourMinuteSecond());%></strong></font>	 
 </td>  
 </tr>
</table>
<br>
<input type="submit" name="submit" value="儲存並上載樣本檔"> 
<BR>
<input type="hidden" size="10" name="CUSTOMERID" value="<%=customerId%>">
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

