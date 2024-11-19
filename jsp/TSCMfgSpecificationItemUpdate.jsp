<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
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
	
	subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+INVITEM+"&ITEMDESC="+ITEMDESC+"&ORGANIZATIONID=49","subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
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
	if (document.MYFORM.CARTONITEM.value == null || document.MYFORM.CARTONITEM.value == "" || document.MYFORM.BOXITEM.value == null || document.MYFORM.BOXITEM.value == "")
	{
    	alert("外箱料號及內盒料號請擇一輸入，不可同時空白!!");
     	document.MYFORM.CARTONITEM.focus();
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
<title>TSC Special Item Add and modify</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSDRQItemPackageCategoryAdd.jsp?ActionName=A" METHOD="POST"> 
<%
String btnName = "Save";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID == null) ITEMID="";
String ITEMNAME = request.getParameter("INVITEM");
if (ITEMNAME == null) ITEMNAME = "";
String ITEMDESC = request.getParameter("ITEMDESC");
if (ITEMDESC == null) ITEMDESC = "";
String CARTONITEM = request.getParameter("CARTONITEM");
if (CARTONITEM == null) CARTONITEM = "";
String BOXITEM = request.getParameter("BOXITEM");
if (BOXITEM == null) BOXITEM = "";
String ActionMode = request.getParameter("ACTIONMODE");
if (ActionMode == null) ActionMode = "NEW";
String strActionCode = request.getParameter("ACTIONCODE");
if (strActionCode == null) strActionCode ="";
String WOUOM = request.getParameter("WOUOM");
if (WOUOM == null) WOUOM = "&nbsp;";
String bordercolor = "";

if (strActionCode.equals("Save"))
{
	try
	{  
		String sql = " SELECT 1 FROM oraddman.tsc_special_item_data a"+
				 " WHERE INVENTORY_ITEM_ID ='"+ITEMID+"'";
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
				sql = " update oraddman.tsc_special_item_data"+
					  " set carton_item_desc =?"+
					  ",box_item_desc=?"+
					  ",previous_update_date =last_update_date"+
					  ",previous_updated_by =  last_updated_by"+
					  ",last_update_date=sysdate"+
					  ",last_updated_by =?"+
					  " where INVENTORY_ITEM_ID ='"+ITEMID+"'";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,CARTONITEM);
				st1.setString(2,BOXITEM);  
				st1.setString(3,UserName); 
				st1.executeUpdate();
				st1.close();
				out.print("<script type=\"text/javascript\">setLink("+'"'+"../jsp/TSCMfgSpecificationItemQuery.jsp"+'"'+")</script>"); 			
			}
		}
		else
		{
			if (ActionMode.equals("NEW"))
			{	
				sql = " insert into oraddman.tsc_special_item_data"+
					  " (inventory_item_id, inventory_item_name, item_description,carton_item_desc, box_item_desc, last_update_date,last_updated_by)"+
					  " values"+
					  " (?,?,?,?,?,sysdate,?)";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,ITEMID);	
				st1.setString(2,ITEMNAME);
				st1.setString(3,ITEMDESC); 
				st1.setString(4,CARTONITEM);
				st1.setString(5,BOXITEM);  
				st1.setString(6,UserName); 
				st1.executeUpdate();
				st1.close();
				out.println("<script language = 'JavaScript'>");
				out.println("alert('資料新增成功!')");
				out.println("</script>");
				//清空變數值
				ITEMID ="";ITEMNAME="";ITEMDESC="";CARTONITEM="";BOXITEM="";WOUOM="";
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
		String sql = " SELECT a.*, b.PRIMARY_UNIT_OF_MEASURE as WOUOM FROM oraddman.tsc_special_item_data a,MTL_SYSTEM_ITEMS_B  b"+
				 " WHERE a.INVENTORY_ITEM_ID ='"+ITEMID+"'"+
				 " and a.inventory_item_id = b.inventory_item_id"+
				 " and b.organization_id =49";
		ResultSet rs=con.createStatement().executeQuery(sql);
		if ( rs.next())
		{	
			ITEMID = rs.getString("inventory_item_id");
			ITEMNAME = rs.getString("inventory_item_name");
			ITEMDESC = rs.getString("item_description");
			CARTONITEM = rs.getString("carton_item_desc");
			WOUOM = rs.getString("WOUOM");
			BOXITEM = rs.getString("box_item_desc");
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
			<font color="#003366" size="+3" face="Arial Black"><em>TSC</em></font>
			<font style="font-size:28px;color:#000000;font-family:'標楷體'"><strong>特規料號資料<%=ActionMode.equals("NEW")?"<font style='color:#1212A3'>新增</font>":"<font style='color:#1E7D25'>修改</font>"%></strong></font>
			<br>
		</td>
	</tr>
	<tr>
		<td align="right">
			<A HREF="TSCMfgSpecificationItemQuery.jsp"><font size="2">回上頁</font></A>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>料號：</td>
					<td nowrap><input type="text" name="INVITEM" value="<%=ITEMNAME%>"  size="50" style="font-family:'Times New Roman';font-size:14px;<%=bordercolor%>" <%if (ActionMode.equals("MODIFY")) out.println(" onKeyDown='return (event.keyCode!=8);' readonly");%>>
					<%if (ActionMode.equals("NEW")) out.println("<INPUT TYPE='button' name='btniname' value='..' style='font-family:ARIAL' onClick='subItemFind()'>");%>
					<input type="hidden" name="ITEMID" value="<%=ITEMID%>"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>品名：</td>
					<td nowrap><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" size="50" style="font-family:'Times New Roman';font-size:14px;<%=bordercolor%>" <%if (ActionMode.equals("MODIFY")) out.println(" onKeyDown='return (event.keyCode!=8);' readonly");%>>
					<%if (ActionMode.equals("NEW")) out.println("<INPUT TYPE='button' name='btniname' value='..' style='font-family:ARIAL' onClick='subItemFind()'>");%>
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>單位：</td>
					<td nowrap><input type="text"  name="WOUOM" value="<%=WOUOM%>" size="50" style="border:#FFFFFF;font-family:'Times New Roman';font-size:14px;" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>外箱料號：</td>
					<td nowrap><input type="text" name="CARTONITEM" value="<%=CARTONITEM%>" size="50" style="font-family:'Times New Roman';font-size:14px"></td>
				<tr>
					<td width="35%" height="25" bgcolor="#D8DEA9" style="font-family:'標楷體';font-size:16px" nowrap>內盒料號：</td>
					<td nowrap><input type="text" name="BOXITEM" value="<%=BOXITEM%>"  size="50" style="font-family:'Times New Roman';font-size:14px"></td>
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
    				<td width="16%"> <input name="btnSubmit" type=button onClick='setSubmit("../jsp/TSCMfgSpecificationItemUpdate.jsp?ACTIONMODE=<%=ActionMode%>&ACTIONCODE=Save")' value="儲存" style="font-family:'標楷體';font-size:14px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type=button onClick='setLink("../jsp/TSCMfgSpecificationItemQuery.jsp")' value="Cancel" style="font-family:'Times New Roman';font-size:14px">
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
