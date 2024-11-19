<!-- 20161108 Peggy,新增prd 外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/> 
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function subItemFind()
{
	var INVITEM = document.MYFORM.INVITEM.value;
	var ITEMDESC = document.MYFORM.ITEMDESC.value;
	//var PROD_GROUP = document.MYFORM.PROD_GROUP.value;
	subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+INVITEM+"&ITEMDESC="+ITEMDESC+"&ORGANIZATIONID=49","subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}
function subVendorFind()
{
	var supplierName= document.MYFORM.SUPPLIERNAME.value;
	subWin=window.open("../jsp/subwindow/TSCPMDSupplierInfoFind.jsp?SUPPLIERNAME="+supplierName+"&FUNCNAME=F1-006","subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}
function setLink(URL)
{  
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function setSubmit(URL)
{ 
	if (document.MYFORM.ITEMID.value == null || document.MYFORM.ITEMID.value == "")
	{
    	alert("請輸入台半料號!!");
     	document.MYFORM.ITEMNAME.focus();
   		return false;
	}
	if (document.MYFORM.ITEMDESC.value == null || document.MYFORM.ITEMDESC.value == "")
	{
    	alert("請輸入台半品名!!");
     	document.MYFORM.ITEMDESC.focus();
   		return false;
	}
	if (document.MYFORM.SUPPLIERNO.value == null || document.MYFORM.SUPPLIERNO.value == "")
	{
    	alert("請選擇供應商!");
     	document.MYFORM.SUPPLIERNO.focus();
   		return false;
	}
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnCancel.disabled=true;
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.clientHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

</script>
<title>PMD Item AVL creation and modify</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSCPMDOEMItemAVLUpdate.jsp" METHOD="POST"> 
<%
String btnName = "Save";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID == null) ITEMID="";
String ITEMNAME = request.getParameter("INVITEM");
if (ITEMNAME == null) ITEMNAME = "";
String ITEMDESC = request.getParameter("ITEMDESC");
if (ITEMDESC == null) ITEMDESC = "";
String PACKAGESPEC = request.getParameter("PACKAGESPEC");
if (PACKAGESPEC == null) PACKAGESPEC= "";
String TESTSPEC = request.getParameter("TESTSPEC");
if (TESTSPEC == null) TESTSPEC= "";
String ActionMode = request.getParameter("ACTIONMODE");
if (ActionMode == null) ActionMode = "NEW";
String strActionCode = request.getParameter("ACTIONCODE");
if (strActionCode == null) strActionCode ="";
String SUPPLIERNAME = request.getParameter("SUPPLIERNAME");
if (SUPPLIERNAME == null) SUPPLIERNAME = "";
String SUPPLIERNO = request.getParameter("SUPPLIERNO");
if (SUPPLIERNO == null) SUPPLIERNO = "";
String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
if (VENDOR_SITE_ID == null) VENDOR_SITE_ID = "";
String STATUS= request.getParameter("STATUS");
if (STATUS==null) STATUS="Y";
String WOUOM = request.getParameter("WOUOM");
if (WOUOM==null) WOUOM="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP=""; //add by Peggy 20170602
//String PROD_GROUP=request.getParameter("PROD_GROUP");
//if (PROD_GROUP==null) PROD_GROUP=""; //add by Peggy 20161108
//String ORGANIZATION_ID= request.getParameter("ORGANIZATION_ID");
//if (ORGANIZATION_ID==null) ORGANIZATION_ID=""; //add by Peggy 20161108
String bordercolor = "";

if (strActionCode.equals("Save"))
{
	try
	{  
		String sql = " SELECT 1 FROM oraddman.tspmd_item_avl a"+
				 " WHERE INVENTORY_ITEM_ID ='"+ITEMID+"'"+
				 " AND VENDOR_CODE='"+SUPPLIERNO+"'";
		ResultSet rs=con.createStatement().executeQuery(sql);
		if ( rs.next())
		{	
			if (ActionMode.equals("NEW"))
			{	
				out.println("<script language = 'JavaScript'>");
				out.println("alert('新增失敗!!此筆資料已存在,請使用修改功能進行調整,謝謝!')");
				out.println("</script>");
			}
			else
			{
				sql = " update oraddman.tspmd_item_avl "+
					  " set PACKAGE_SPEC =?"+
					  ",TEST_SPEC=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",ACTIVE_FLAG=?"+
					  " where INVENTORY_ITEM_ID ='"+ITEMID+"'"+
	 				  " AND VENDOR_CODE='"+SUPPLIERNO+"'";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,PACKAGESPEC);
				st1.setString(2,TESTSPEC);  
				st1.setString(3,UserName); 
				st1.setString(4,STATUS); 
				st1.executeUpdate();
				st1.close();
				out.print("<script type=\"text/javascript\">setLink("+'"'+"../jsp/TSCPMDOEMItemAVLQuery.jsp"+'"'+")</script>"); 			
			}
		}
		else
		{
			if (ActionMode.equals("NEW"))
			{	
				sql = " insert into oraddman.tspmd_item_avl "+
					  " (inventory_item_id, item_name, item_description,vendor_code, vendor_name, package_spec, test_spec,creation_date, created_by, last_update_date,last_updated_by, active_flag,ORGANIZATION_ID,TSC_PROD_GROUP)"+
					  " values"+
					  " (?,?,?,?,?,?,?,sysdate,?,sysdate,?,?,?,(select tsc_om_category(?,49,'TSC_PROD_GROUP') from dual))";
				//out.println(sql);
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,ITEMID);	
				st1.setString(2,ITEMNAME);
				st1.setString(3,ITEMDESC); 
				st1.setString(4,SUPPLIERNO);
				st1.setString(5,SUPPLIERNAME);  
				st1.setString(6,PACKAGESPEC);  
				st1.setString(7,TESTSPEC);  
				st1.setString(8,UserName); 
				st1.setString(9,UserName); 
				st1.setString(10,STATUS); 
				st1.setString(11,"49"); 
				st1.setString(12,ITEMID); 
				st1.executeUpdate();
				st1.close();
				out.println("<script language = 'JavaScript'>");
				out.println("alert('資料新增成功!')");
				out.println("</script>");
				//清空變數值
				ITEMID ="";ITEMNAME="";ITEMDESC="";SUPPLIERNO="";SUPPLIERNAME="";PACKAGESPEC="";TESTSPEC="";STATUS="";TSCPRODGROUP="";
			}
			else
			{
				out.println("<script language = 'JavaScript'>");
				out.println("alert('修改失敗!!查無此筆資料,請重新確認,謝謝!')");
				out.println("</script>");
			}
		}
		rs.close();
	}
	catch (Exception e)
	{
		//out.println(e.getMessage());
		out.println("<script language = 'JavaScript'>");
		out.println("alert('動作失敗,請洽系統管理人員,謝謝!')");
		out.println("</script>");		
	} 
}
else
{
	if (ActionMode.equals("MODIFY"))
	{
		bordercolor = "border:#FFFFFF;";
		String sql = " SELECT a.* FROM  oraddman.tspmd_item_avl a"+
				     " WHERE a.INVENTORY_ITEM_ID ='"+ITEMID+"'"+
 				     " AND VENDOR_CODE='"+SUPPLIERNO+"'";
		ResultSet rs=con.createStatement().executeQuery(sql);
		if ( rs.next())
		{	
			ITEMID = rs.getString("inventory_item_id");
			ITEMNAME = rs.getString("item_name");
			ITEMDESC = rs.getString("item_description");
			SUPPLIERNAME = rs.getString("vendor_name");
			SUPPLIERNO = rs.getString("VENDOR_CODE");
			PACKAGESPEC= rs.getString("PACKAGE_SPEC");
			TESTSPEC= rs.getString("TEST_SPEC");
			STATUS = rs.getString("ACTIVE_FLAG");
			TSCPRODGROUP =rs.getString("TSC_PROD_GROUP");
		}
		rs.close();
	}
}
%>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 500px; width: 370px; height: 50px;"> 
  <br>
<table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
	<tr>
    	<td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料儲存中,請稍候.....</font> <BR>
      		<DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 100px;"></div>
		</td>
  	</tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table align="center" width="50%">
	<tr>
		<td align="center">
			<font color="#003366" size="+3" face="Arial Black"><em> AVL</em></font>
			<font style="font-size:28px;color:#000000;font-family:'標楷體'"><strong>資料<%=ActionMode.equals("NEW")?"<font style='color:#1212A3'>新增</font>":"<font style='color:#1E7D25'>修改</font>"%></strong></font>
			<br>
		</td>
	</tr>
	<tr>
		<td align="right">
			<A HREF="TSCPMDOEMItemAVLQuery.jsp"><font size="2">回上頁</font></A>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>品名：</td>
					<td nowrap><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" size="50" style="font-family:'Times New Roman';font-size:14px;<%=bordercolor%>" <%if (ActionMode.equals("MODIFY")) out.println(" onKeyDown='return (event.keyCode!=8);' readonly");%>><input type="hidden" name="WOUOM" value="<%=WOUOM%>">
					<%if (ActionMode.equals("NEW")) out.println("<INPUT TYPE='button' name='btniname' value='..' style='font-family:ARIAL' onClick='subItemFind()'>");%>
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>料號：</td>
					<td nowrap><input type="text" name="INVITEM" value="<%=ITEMNAME%>"  size="50" style="font-family:'Times New Roman';font-size:14px;<%=bordercolor%>" <%if (ActionMode.equals("MODIFY")) out.println(" onKeyDown='return (event.keyCode!=8);' readonly");%>>
					<%if (ActionMode.equals("NEW")) out.println("<INPUT TYPE='button' name='btniname' value='..' style='font-family:ARIAL' onClick='subItemFind()'>");%>
					<input type="hidden" name="ITEMID" value="<%=ITEMID%>"><input type="hidden" name="TSCPRODGROUP" value="<%=TSCPRODGROUP%>"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>供應商：</td>
					<td nowrap><input type="text"  name="SUPPLIERNAME" value="<%=SUPPLIERNAME%>" size="50" style="font-family:'Times New Roman';font-size:14px;<%=bordercolor%>" <%if (ActionMode.equals("MODIFY")) out.println(" onKeyDown='return (event.keyCode!=8);' readonly");%>><input type="hidden" name="SUPPLIERNO" value="<%=SUPPLIERNO%>"><input type="hidden" name="VENDOR_SITE_ID" value="<%=VENDOR_SITE_ID%>">
					<%if (ActionMode.equals("NEW")) out.println("<INPUT TYPE='button' name='btnvendor' value='..' style='font-family:ARIAL' onClick='subVendorFind()'>");%>
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>封裝規格：</td>
					<td nowrap><input type="text" name="PACKAGESPEC" value="<%=(PACKAGESPEC==null?"":PACKAGESPEC)%>" size="50" style="font-family:'Times New Roman';font-size:14px"></td>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>測試規格：</td>
					<td nowrap><input type="text" name="TESTSPEC" value="<%=(TESTSPEC==null?"":TESTSPEC)%>"  size="50" style="font-family:'Times New Roman';font-size:14px"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>狀態：</td>
					<td nowrap><input type="radio" name="STATUS" value="Y" style="font-family:'Times New Roman';font-size:14px" <%if (ActionMode.equals("NEW") || STATUS.equals("Y")){out.println("checked");}%>><font style="font-family:'標楷體';font-size:14px">啟用</font>
						       <input type="radio" name="STATUS" value="N" style="font-family:'Times New Roman';font-size:14px" <%if (STATUS.equals("N")){out.println("checked");}%>><font style="font-family:'標楷體';font-size:14px">停用</font>
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>建立日期：</td>
					<td nowrap><font style="font-family:'Times New Roman';font-size:14px"><%=dateBean.getYearMonthDay()%></font></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>建立人員：</td>
					<td nowrap><font style="font-family:'Times New Roman';font-size:14px"><%=UserName%></font></td>
				 </tr>    
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input name="btnSubmit" type=button onClick='setSubmit("../jsp/TSCPMDOEMItemAVLUpdate.jsp?ACTIONMODE=<%=ActionMode%>&ACTIONCODE=Save")' value="儲存" style="font-family:'標楷體';font-size:14px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type=button onClick='setLink("../jsp/TSCPMDOEMItemAVLQuery.jsp")' value="Cancel" style="font-family:'Times New Roman';font-size:14px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
</FORM>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
