<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.io.*,java.sql.*"  %>
<%@ page import="oracle.sql.*,oracle.jdbc.driver.*" %>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
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
<title>CSL System Specification File Update</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "�������"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "�������"; }
}
function NeedConfirm(custNo,organizationID,stationNo,typeID,tscFamily)
{  //alert(tscFamily);
   var URL = "TSCustLabelSpecFileDelete.jsp?CUST_NO="+custNo+"&MARKETTYPE="+organizationID+"&STATNO="+stationNo+"&TYPE_ID="+typeID+"&ITEMCATE="+tscFamily;
   flag=confirm("�O�_�T�w�R��?");      
   if (flag==false) return(false);
   else {
          document.MYFORM.action=URL;
          document.MYFORM.submit(); 
		}
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
{      
    subWin=window.open("../jsp/subwindow/TSCustomerInfoFind.jsp?CUSTOMERID="+custID+"&NAME="+custName+"&OUORGID="+ouORGID,"subwin","width=640,height=480,scrollbars=yes,status=yes,menubar=yes");  
}
function NiceLabelOpener(custNo,stationNo,typeID,organizationID)
{
  subWin=window.open("../jsp/TSCustLabelSpecNiceLabelOpen.jsp?CUST_NO="+custNo+"&STATNO="+stationNo+"&TYPE_ID="+typeID+"&MARKETTYPE="+organizationID,"subwin","width=640,height=480,scrollbars=yes,status=yes,menubar=yes");
}
function callNiceLabelOpener(svrLocJobName)
{
   alert(svrLocJobName);
   //window.location.href="file://C:\Program Files\EuroPlus\NiceLabel\Bin\nice3.exe "+svrLocJobName+" /s";  //�AJavaScript �L�k�ǻ��\��
   window.location.href="file://C:\Program Files\EuroPlus\NiceLabel\Bin\nice3.exe /s";
}
function submitCheck()
{
   // �T�{�s���ˬd,�O�_�w�W�����Ҽ˥��W����
   if (document.MYFORM.SPECFILE.value==null || document.MYFORM.SPECFILE.value=="")
   {
      alert("�z���W�����Ȥ���ҳW��˥���,�ЦA�T�{!!!");
	  document.MYFORM.SPECFILE.focus();
	  return false;
   }
}
</script>
<body background="">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%   //out.println("1");

     String serverHostName=request.getServerName();

     String custNo=request.getParameter("CUST_NO"); 
     String customerId=request.getParameter("CUSTOMERID"); 
     String customerNo=request.getParameter("CUSTOMERNO");
    
	 String stationNo=request.getParameter("STATNO");
     String typeID=request.getParameter("TYPE_ID");
	 String itemCate=request.getParameter("TSC_PACKAGE");
	 String organizationID=request.getParameter("MARKETTYPE");
	
	 
	 if (customerId==null || customerId.equals("")) customerId="";
     if (customerNo==null || customerNo.equals("")) customerNo="";
	 
	 String customerName="";
	 String stationInfo = "";
	 String typeInfo = "";
	 String tscFamily = "";
	 String labelRemark = "";
	 String attVar1 = "",attVar2 = "",attVar3 = "";
	 String attVar4 = "",attVar5 = "",attVar6 = "";
	 String attVar7 = "",attVar8 = "",attVar9 = "";
	 String attVar10 ="",attVar11 = "",attVar12 = "";
	 
	 if (labelRemark==null || labelRemark.equals("")) labelRemark = "";
	 if (attVar1==null || attVar1.equals("")) attVar1="";
	 if (attVar2==null || attVar2.equals("")) attVar2="";
	 if (attVar3==null || attVar3.equals("")) attVar3="";
	 if (attVar4==null || attVar4.equals("")) attVar4="";
	 if (attVar5==null || attVar5.equals("")) attVar5="";
	 if (attVar6==null || attVar6.equals("")) attVar6="";
	 if (attVar7==null || attVar7.equals("")) attVar7="";
	 if (attVar8==null || attVar8.equals("")) attVar8="";
	 if (attVar9==null || attVar9.equals("")) attVar9="";
	 if (attVar10==null || attVar10.equals("")) attVar10="";
	 if (attVar11==null || attVar11.equals("")) attVar11="";
	 if (attVar12==null || attVar12.equals("")) attVar12="";
	 
//out.println("2");	 
	    try
        {   
				   //-----�����~�P�O
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sql = " select CUSTOMER_ID, CUST_NUMBER, CUSTOMER_NAME, CUST_DESCRIPTION, STATNO, STAT_NAME, "+
				                " TYPE_ID, TYPE_DESCRIPTION, LABEL_TEMPFILE, ICON_NAME, ORGANIZATION_ID, TSC_FAMILY, TSC_PACKAGE, "+
								" LABEL_REMARK, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, "+
								" ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12 "+
				                " from ORADDMAN.TSCUST_LABEL_SPECS ";
			       String where = " where CUST_NUMBER = '"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+itemCate+"' ";								  
				   String order = "   ";  				   
				   sql = sql + where;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sql);
		           if (rs.next())
				   {
				     customerId = rs.getString("CUSTOMER_ID"); 
				     customerNo = rs.getString("CUST_NUMBER");
					 customerName = rs.getString("CUSTOMER_NAME");
					 stationInfo = rs.getString("STATNO") + "("+rs.getString("STAT_NAME")+")";
					 typeInfo = rs.getString("TYPE_ID") + "("+rs.getString("TYPE_DESCRIPTION")+")";
					 tscFamily = rs.getString("TSC_PACKAGE");
					 
					 labelRemark = rs.getString("LABEL_REMARK");
					 attVar1 = rs.getString("ATTRIBUTE1");attVar2 = rs.getString("ATTRIBUTE2");attVar3 = rs.getString("ATTRIBUTE3");
					 attVar4 = rs.getString("ATTRIBUTE4");attVar5 = rs.getString("ATTRIBUTE5");attVar6 = rs.getString("ATTRIBUTE6");
					 attVar7 = rs.getString("ATTRIBUTE7");attVar8 = rs.getString("ATTRIBUTE8");attVar9 = rs.getString("ATTRIBUTE9");
					 attVar10 = rs.getString("ATTRIBUTE10");attVar11 = rs.getString("ATTRIBUTE11");attVar12 = rs.getString("ATTRIBUTE12");
				   }
		           rs.close();   
				   statement.close();			
					 
         } //end of try		 
         catch (Exception e) { out.println("Exception:"+e.getMessage()); }
 //out.println("3"); 
%>
<FORM NAME="MYFORM" ACTION="TSCustLabelSpecInsert.jsp" METHOD="post" onSubmit='return submitCheck()' ENCTYPE="multipart/form-data" >   
 <font size="+3" face="Arial Black" color="#000099"><em>TSC</em></font><span class="style1 style2">�Ȥ�S��W����Һ��@</span><BR>
<img src="../image/circle.gif"><font color="#009966">���t�ί��ޭ�,�����\�ܧ�</font>
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
   <tr bgcolor="#D1E2FE">
    <td width="35%"><font color="#330099"><span class="style1">&nbsp;</span>���P/�~�P<img src="../image/circle.gif"></font>
    <% 	         try
                 {   
				   //-----�����~�P�O
		           Statement stateOrgInf=con.createStatement();
                   ResultSet rsOrgInf=null;	
			       String sqlOrgInf = " select ORGANIZATION_ID, CODE_DESC from APPS.YEW_MFG_DEFDATA ";
			       String whereOrgInf = " where DEF_TYPE='MARKETTYPE' and ORGANIZATION_ID= "+organizationID+"  ";								  
				   String orderOrgInf = "  ";  				   
				   sqlOrgInf = sqlOrgInf + whereOrgInf;
				   //out.println(sqlOrgInf);
                   rsOrgInf=stateOrgInf.executeQuery(sqlOrgInf);
				   if (rsOrgInf.next())
		           {
				     out.println("<span class='style3'>"+rsOrgInf.getString(1)+"("+rsOrgInf.getString(2)+")"+"</span>");
				   }
		           rsOrgInf.close();   
				   stateOrgInf.close();			
					 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
			
		%>
     </td>	 
     <td width="31%"><font color="#330099"><span class="style1">&nbsp;</span>���ү��O<img src="../image/circle.gif"></font>
         <%out.println("<span class='style3'>"+stationInfo+"</span>");%>
     </td>
	 <td width="34%"><font color="#330099"><span class="style1">&nbsp;</span>��������<img src="../image/circle.gif"></font>
         <%out.println("<span class='style3'>"+typeInfo+"</span>");%>
     </td>    
  </tr>
  <tr bgcolor="#D1E2FE">	
    <td colspan="2"><font color="#330099"><span class="style1">&nbsp;</span>�Ȥ��T<img src="../image/circle.gif"></font>
	   <%out.println("<span class='style3'>("+customerNo+")</span>");%>	        
       <%out.println("<span class='style3'>"+customerName+"</span>");%> </font>  
	</td>
	<td><font color="#330099"><span class="style1">&nbsp;</span>���~�ڸs</font>
	  <%out.println("<span class='style3'>"+tscFamily+"</span>");%>
	  <!--% 
	             try
                 {  
				   //-----�����~�ڸs  
		           Statement stateCate=con.createStatement();
                   ResultSet rsCate=null;	
			       String sqlCate = " select DISTINCT SEGMENT1,SEGMENT1 from MTL_ITEM_CATEGORIES_V ";
			       String whereCate = "where CATEGORY_SET_NAME='TSC_Package' ";				   					  
				   String orderCate = "  ";  				   
				   sqlCate = sqlCate + whereCate;
				   //out.println(sqlOrgInf);
                   rsCate=stateCate.executeQuery(sqlCate);				  
		           comboBoxAllBean.setRs(rsCate);
		           comboBoxAllBean.setSelection(tscFamily);
	               comboBoxAllBean.setFieldName("ITEMCATE");	   
                   out.println(comboBoxAllBean.getRsString());	    		  
		           rsCate.close();   
				   stateCate.close(); 	  
					 
					 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
	  
	  
	  %-->
	</td>	 
  </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="35%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>���Ҽ˥���</font>
	  <INPUT TYPE="FILE" NAME="SPECFILE" width="10">
	</td>
	<td width="31%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�S��ϼ���</font>
	  <INPUT TYPE="FILE" NAME="ICONFILE" width="20">
	</td>
	<td width="34%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>���ҹw������</font>
	  <INPUT TYPE="FILE" NAME="PREVFILE" width="20">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">
     <td colspan="3"><span class="style3">�����ܼ�(�ݩ�)���� �G �H�U�w�藍�P�Ȥ��U�s�{�@�~���q�C�L����,�е��w������ܼ�</span><br>
	                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 <span class="style3"> �ҡE�Ȥ��]�˯����B�~�[�W�Ȥ�~��,�h���w�ܼƦW�� CUSTITEM<br>
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 �t�Ω�ӻs�{�����ҦC�L��,�Y���ܼƦW��ERP�^���Ȥ�~����T�æC�L���ҡC
					 </span>
	 </td>
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="35%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;1&nbsp;</font>
	  <input name="ATTRIBUTE1" tabindex='10' type="text" size="15" value="<%if (attVar1==null || attVar1.equals("")) out.print(""); else out.print(attVar1);%>">
	</td>
	<td width="31%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;2&nbsp;</font>
	  <input name="ATTRIBUTE2" tabindex='11' type="text" size="15" value="<%if (attVar2==null || attVar2.equals("")) out.print(""); else out.print(attVar2);%>">
	</td>
	<td width="34%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;3&nbsp;</font>
	  <input name="ATTRIBUTE3" tabindex='12' type="text" size="15" value="<%if (attVar3==null || attVar3.equals("")) out.print(""); else out.print(attVar3);%>">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="35%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;4&nbsp;</font>
	  <input name="ATTRIBUTE4" tabindex='13' type="text" size="15" value="<%if (attVar4==null || attVar4.equals("")) out.print(""); else out.print(attVar4);%>">
	</td>
	<td width="31%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;5&nbsp;</font>
	  <input name="ATTRIBUTE5" tabindex='14' type="text" size="15" value="<%if (attVar5==null || attVar5.equals("")) out.print(""); else out.print(attVar5);%>">
	</td>
	<td width="34%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;6&nbsp;</font>
	  <input name="ATTRIBUTE6" tabindex='15' type="text" size="15" value="<%if (attVar6==null || attVar6.equals("")) out.print(""); else out.print(attVar6);%>">
	</td>
   </tr>
    <tr bgcolor="#D1E2FE">	
    <td width="35%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;7&nbsp;</font>
	  <input name="ATTRIBUTE7" tabindex='16' type="text" size="15" value="<%if (attVar7==null || attVar7.equals("")) out.print(""); else out.print(attVar7);%>">
	</td>
	<td width="31%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;8&nbsp;</font>
	  <input name="ATTRIBUTE8" tabindex='17' type="text" size="15" value="<%if (attVar8==null || attVar8.equals("")) out.print(""); else out.print(attVar8);%>">
	</td>
	<td width="34%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW&nbsp;9&nbsp;</font>
	  <input name="ATTRIBUTE9" tabindex='18' type="text" size="15" value="<%if (attVar9==null || attVar9.equals("")) out.print(""); else out.print(attVar9);%>">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">	
    <td width="35%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW10</font>
	  <input name="ATTRIBUTE10" tabindex='19' type="text" size="15" value="<%if (attVar10==null || attVar10.equals("")) out.print(""); else out.print(attVar10);%>">
	</td>
	<td width="31%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW11</font>
	  <input name="ATTRIBUTE11" tabindex='20' type="text" size="15" value="<%if (attVar11==null || attVar11.equals("")) out.print(""); else out.print(attVar11);%>">
	</td>
	<td width="34%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>�����ݩʦW12</font>
	  <input name="ATTRIBUTE12" tabindex='21' type="text" size="15" value="<%if (attVar12==null || attVar12.equals("")) out.print(""); else out.print(attVar12);%>">
	</td>
   </tr>
   <tr bgcolor="#D1E2FE">
     <td><span class="style1"><strong>�}�ҫȤ�����ɹw��</strong></span></td>
     <td><span class="style1"><strong>�Ȥ���ҹ��ɹw��</strong></span></td> 
	 <td><span class="style1"><strong>�Ȥ�S��ϼ˹w��</strong></span></td>     
   </tr>
   <tr bgcolor="#D1E2FE">
     <td>	 
	 <%
	    int    bbuffSize = 64 ;  //bbuffSize = 64 ;
        byte[]  bbuff = new byte[bbuffSize] ;  
        String svrJobLocName="";
		String svrLabelName = "";
   
        Blob blob;  
  
        try
        {  
           Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
           ResultSet rs=stmt.executeQuery("select * from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID="+typeID+" and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE='"+itemCate+"' ");
           if (rs.next())
           {
              blob = (Blob)rs.getObject("LABEL_BLOBFILE") ;  
              bbuff = blob.getBytes(1, (int)blob.length());
		
	          //String frontFilePath="d://clientupload/"+request.getRemoteAddr()+"-"+rs.getString("LABEL_TEMPFILE"); 
	          String blobFileName = rs.getString("LABEL_TEMPFILE");
	          String frontFilePath="d:/resin-2.1.9/webapps/oradds/LabPrintJob/"+rs.getString("LABEL_TEMPFILE");   
	          svrLabelName = "http://"+serverHostName+":8080/webapps/oradds/LabPrintJob/"+rs.getString("LABEL_TEMPFILE"); 
	          String front_file=frontFilePath; 
			  
	
	           // �N��Ʈw���X��Blob�ɥt�sO.S �ɮש󵹩w��m_By Kerwin
	
	           BLOB myblob=null;
               InputStream instream=null;
               FileOutputStream outstream=null;
               int bufsize=0;
               byte[] buffer =null;
               int fileLength=0;   
	           String s = "";
	      	         
	           myblob=((OracleResultSet)rs).getBLOB("LABEL_BLOBFILE");
               //instream=myblob.getBinaryOutputStream();
	           instream=myblob.getBinaryStream(0);
               outstream=new FileOutputStream(frontFilePath);
               bufsize=myblob.getBufferSize();
               buffer = new byte[bufsize];   
               while ((fileLength=instream.read(buffer))!=-1)   
               {        
	             outstream.write(buffer,0,fileLength);
		         outstream.flush(); 
	           }
               instream.close();	 
               outstream.close();		   
	            // �N��Ʈw���X��Blob�ɥt�sO.S �ɮש󵹩w��m_By Kerwin   
      
               int specFileNameLngth = rs.getString("LABEL_TEMPFILE").length();
               String specFileExtName = rs.getString("LABEL_TEMPFILE").substring(specFileNameLngth-3,specFileNameLngth);
	           String jobFileName = rs.getString("LABEL_TEMPFILE").substring(0,specFileNameLngth-4);
	           //out.println("LBL File Open="+specFileExtName); 
	           if (specFileExtName=="LBL" || specFileExtName.equals("LBL") || specFileExtName=="lbl" || specFileExtName.equals("lbl"))
               { // �Y�榡�O���X��,�h�HJava�I�s�~���{���I�s Nice Label	
	
	              // ����NiceLabel�����XJob��_�_
	              String jobFileNPath = "d:/resin-2.1.9/webapps/oradds/LabPrintJob/"+jobFileName+".JOB";
	              FileWriter fw = new FileWriter(jobFileNPath);
                  PrintWriter pw = new PrintWriter(fw);
                  pw.write("LABEL "+"\""+"d:\\resin-2.1.9\\webapps\\oradds\\LabPrintJob\\"+blobFileName+"\""+" ");
	              //pw.write("SET V1="+"\""+"987654321"+"\""+" "); 
	              //pw.write("SET "+"\""+"Bar Code"+"\""+"=123456789012 ");	     
                  pw.close();
                  fw.close();	
				  
				  svrJobLocName="http://"+serverHostName+":8080/oradds/LabPrintJob/"+blobFileName; 	
	              
               }  // End of if (specFileExtName=="LBL" || specFileExtName.equals("LBL") || specFileExtName=="lbl")
               stmt.close();
			   rs.close(); 
   
            } // End of if (rs.next())
  
         } //end of try
         catch (Exception e)
         {
           out.println(e.getMessage());
         }//end of catch 	   
	     
	   %>    	   
       <a href="/oradds/LabPrintJob/ts_nolog_out.lbl" onmouseover='this.T_WIDTH=200;this.T_OPACITY=80;return escape("�нT�{�z���w��Nice Label���X�n��<br>�������Ϲ��i�˵��w����ñ���e")'><img src="images/NiceLabelLogo.gif" align="top" border="0" onDblClick='callNiceLabelOpener("<%=svrJobLocName%>")' width="150"/></a>
	 </td>
     <td>
       <img src="/oradds/jsp/TSCustLabelPreviewBlobsContent.jsp?CUST_NO=<%=custNo%>&STATNO=<%=stationNo%>&TYPE_ID=<%=typeID%>&MARKETTYPE=<%=organizationID%>" align="middle" border="1"/>
	 </td> 
	 <td >      
	   <img src="/oradds/jsp/TSCustLabelIconBlobsContent.jsp?CUST_NO=<%=custNo%>&STATNO=<%=stationNo%>&TYPE_ID=<%=typeID%>&MARKETTYPE=<%=organizationID%>" align="middle" border="1"/>
	 </td>   
   </tr>
 </table>  
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
   <tr bgcolor="#D1E2FE">
    <td width="10%"><font color="#330099"><span class="style1">&nbsp;</span>����</font></td>
	<td width="90%" colspan="2" bgcolor="#FFFFFF"><input name="REMARK" tabindex='49' type="text" size="80" value="<%if (labelRemark==null || labelRemark.equals("")) out.print(""); else out.print(labelRemark); %>"></td>
   </tr>
 </table>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
 <tr bgcolor="#D1E2FE">   
 <td width="12%" align="center">
  <strong><font color="#330099" face="Arial">�B�z�H��</font></strong> 
 </td>
 <td width="15%" bgcolor="#FFFFFF" align="center"> 
    <font color='#000099' face="Arial" ><strong><%=userID+"("+UserName+")"%></strong></font>	 
 </td>
 <td width="10%" bgcolor="#D1E2FE" align="center">
  <strong><font color="#330099" face="Arial">�B�z���</font></strong> 
 </td>
 <td width="10%" bgcolor="#FFFFFF" align="center"> 
   <font color="#000099" face="Arial"><strong><% out.println(dateBean.getYearMonthDay());%></strong></font>	 
 </td> 
 <td width="10%" bgcolor="#D1E2FE" align="center">
  <strong><font color="#330099" face="Arial" >�B�z�ɶ�</font></strong> 
 </td>
 <td width="10%" bgcolor="#FFFFFF" align="center"> 
    <font color='#000099' face="Arial" ><strong><%out.println(dateBean.getHourMinuteSecond());%></strong></font>	 
 </td>  
 </tr>
</table>
<BR>
<input type="submit" name="UPDATE" value="�ק�äW���˥���">
<input type="button" name="DELETE" value="�R�������W����" onClick='NeedConfirm("<%=custNo%>","<%=organizationID%>","<%=stationNo%>","<%=typeID%>","<%=tscFamily%>")'> 
<BR>
<input type="hidden" size="10" name="CUSTOMERID" value="<%=customerId%>">
<input type="hidden" size="10" name="CUSTOMERNAME" value="<%=customerName%>">
<input type="hidden" size="10" name="CUST_NO" value="<%=custNo%>">
<input type="hidden" size="10" name="CUSTOMERNO" value="<%=custNo%>">
<input type="hidden" size="10" name="STATNO" value="<%=stationNo%>">
<input type="hidden" size="10" name="TYPE_ID" value="<%=typeID%>">
<input type="hidden" size="10" name="MARKETTYPE" value="<%=organizationID%>">
<input type="hidden" size="10" name="ITEMCATE" value="<%=tscFamily%>">
</form>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>


