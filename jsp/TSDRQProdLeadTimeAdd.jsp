<!-- 20151119 Peggy,add TSC_PROD_FAMILY column-->
<!-- 20160130 Peggy,add No Wafer Lead Time column-->
<!-- 20180802 Peggy,新增"停用/啟用"欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
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
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		if (document.MYFORMD.STATUS.value=="NEW")
		{
			window.opener.MYFORM.submit();
		}
		else
		{	
			window.opener.document.getElementById("alpha").style.width="0";
			window.opener.document.getElementById("alpha").style.height="0";
		}
		window.close();				
    }  
} 
function setCancel()
{
	if (document.MYFORMD.STATUS.value=="NEW")
	{
		window.opener.MYFORM.submit();
	}
	else
	{
		window.opener.document.getElementById("alpha").style.width="0";
		window.opener.document.getElementById("alpha").style.height="0";
	}
	self.close();
}
function setSubmit(URL)
{ 
	if (document.MYFORMD.PLANT_CODE.value=="" || document.MYFORMD.PLANT_CODE.value=="--")
	{
		alert("請選擇生產廠區!!");
		document.MYFORMD.PLANT_CODE.focus();
		return false;
	}
	if (document.MYFORMD.TSC_PROD_GROUP.value=="" || document.MYFORMD.TSC_PROD_GROUP.value=="--")
	{
		alert("請選擇TSC Prod Group!!");
		document.MYFORMD.TSC_PROD_GROUP.focus();
		return false;
	}	
	if (document.MYFORMD.TSC_FAMILY.value=="" || document.MYFORMD.TSC_FAMILY.value=="--")
	{
		alert("請選擇TSC Family!!");
		document.MYFORMD.TSC_FAMILY.focus();
		return false;
	}	
	if (document.MYFORMD.TSC_PROD_GROUP.value=="PMD" || document.MYFORMD.TSC_PROD_GROUP.value=="SSP" || document.MYFORMD.TSC_PROD_GROUP.valu=="SSD")
	{
		if (document.MYFORMD.TSC_PROD_FAMILY.value=="" || document.MYFORMD.TSC_PROD_FAMILY.value=="--")
		{
			alert("請選擇TSC Prod Family!!");
			document.MYFORMD.TSC_PROD_FAMILY.focus();
			return false;
		}	
	}	
	if (document.MYFORMD.TSC_PACKAGE.value=="" || document.MYFORMD.TSC_PACKAGE.value=="--")
	{
		alert("請選擇TSC Package!!");
		document.MYFORMD.TSC_PACKAGE.focus();
		return false;
	}
	if (document.MYFORMD.LEAD_TIME.value=="" || document.MYFORMD.LEAD_TIME.value==null || eval(document.MYFORMD.LEAD_TIME.value) <=0)
	{
		alert("請輸入Lead Time!!");
		document.MYFORMD.LEAD_TIME.focus();
		return false;
	}
	//if (document.MYFORMD.LEAD_TIME_NOWAFER.value=="" || document.MYFORMD.LEAD_TIME_NOWAFER.value==null || eval(document.MYFORMD.LEAD_TIME_NOWAFER.value) <=0)
	//{
	//	alert("請輸入Lead Time(No Wafer)!!");
	//	document.MYFORMD.LEAD_TIME_NOWAFER.focus();
	//	return false;
	//}	
	if (document.MYFORMD.LEAD_TIME_UOM.value=="" || document.MYFORMD.LEAD_TIME_UOM.value=="--")
	{
		alert("請選擇Lead Time Uom!!");
		document.MYFORMD.LEAD_TIME_UOM.focus();
		return false;
	}			
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
}
function setClear()
{
	document.MYFORMD.TSC_FAMILY.value="";
	document.MYFORMD.TSC_PROD_FAMILY.value="";
	document.MYFORMD.TSC_PACKAGE.value="";
	document.MYFORMD.ITEM_DESC.value="";
	document.MYFORMD.LEAD_TIME.value="";
	//document.MYFORMD.LEAD_TIME_NOWAFER.value=""; //add by Peggy 20160130
}
function setCategory(URL,PARTS)
{
	if (event.keyCode==13) 
	{
		if (document.MYFORMD.PLANT_CODE.value=="" || document.MYFORMD.PLANT_CODE.value=="--")
		{
			alert("請選擇生產廠區!!");
			document.MYFORMD.PLANT_CODE.focus();
			return false;
		}
		document.MYFORMD.action=URL;
		document.MYFORMD.submit();	
	}
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>Lead Time Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSDRQProdLeadTimeAdd.jsp" METHOD="POST"> 
<%
String ID = request.getParameter("ID");
if (ID == null) ID="";
String STATUS = request.getParameter("STATUS");
if (STATUS == null) STATUS = "";
String PLANT_CODE = request.getParameter("PLANT_CODE");
if (PLANT_CODE==null) PLANT_CODE="";
String TSC_PROD_GROUP = request.getParameter("TSC_PROD_GROUP");
if (TSC_PROD_GROUP==null) TSC_PROD_GROUP="";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null) TSC_FAMILY="";
String TSC_PROD_FAMILY = request.getParameter("TSC_PROD_FAMILY");
if (TSC_PROD_FAMILY==null) TSC_PROD_FAMILY="";
if (!TSC_PROD_GROUP.equals("PMD") && !TSC_PROD_GROUP.equals("SSP") && !TSC_PROD_GROUP.equals("SSD"))
{
	TSC_PROD_FAMILY="";	
}
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String LEAD_TIME = request.getParameter("LEAD_TIME");
if (LEAD_TIME == null) LEAD_TIME = "";
String LEAD_TIME_UOM = request.getParameter("LEAD_TIME_UOM");
if (LEAD_TIME_UOM==null) LEAD_TIME_UOM="WEEK";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String ORIG_PLANT_CODE = request.getParameter("ORIG_PLANT_CODE");
if (ORIG_PLANT_CODE==null) ORIG_PLANT_CODE="";
String ORIG_TSC_PROD_GROUP = request.getParameter("ORIG_TSC_PROD_GROUP");
if (ORIG_TSC_PROD_GROUP==null) ORIG_TSC_PROD_GROUP="";
String ORIG_TSC_FAMILY = request.getParameter("ORIG_TSC_FAMILY");
if (ORIG_TSC_FAMILY==null) ORIG_TSC_FAMILY="";
String ORIG_TSC_PROD_FAMILY = request.getParameter("ORIG_TSC_PROD_FAMILY");
if (ORIG_TSC_PROD_FAMILY==null) ORIG_TSC_PROD_FAMILY="";
if (!TSC_PROD_GROUP.equals("PMD") && !TSC_PROD_GROUP.equals("SSP") && !TSC_PROD_GROUP.equals("SSD"))
{
	ORIG_TSC_PROD_FAMILY="";	
}
String ORIG_TSC_PACKAGE = request.getParameter("ORIG_TSC_PACKAGE");
if (ORIG_TSC_PACKAGE==null) ORIG_TSC_PACKAGE="";
String ORIG_ITEM_DESC = request.getParameter("ORIG_ITEM_DESC");
if (ORIG_ITEM_DESC==null) ORIG_ITEM_DESC="";
String LEAD_TIME_NOWAFER = request.getParameter("LEAD_TIME_NOWAFER"); //add by Peggy 20160130
if (LEAD_TIME_NOWAFER == null) LEAD_TIME_NOWAFER = "";
String sql ="",strExist="",strNoFound="";
String ACTIVE_FLAG= request.getParameter("ACTIVE_FLAG");
if (ACTIVE_FLAG==null) ACTIVE_FLAG="A";
String S_VOLTAGE= request.getParameter("S_VOLTAGE");
if (S_VOLTAGE==null) S_VOLTAGE="";
String E_VOLTAGE = request.getParameter("E_VOLTAGE");
if (E_VOLTAGE==null) E_VOLTAGE="";
String V_BATCH_ID="";
String REMARKS=request.getParameter("REMARKS");
if (REMARKS==null) REMARKS="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{  
	if (STATUS.equals("UPD"))
	{
		if (ACODE.equals(""))
		{
			sql = " SELECT a.seq_id,a.manufactory_no,a.MANUFACTORY_NO ||' '|| b.MANUFACTORY_NAME MANUFACTORY_NAME, a.tsc_prod_group, a.tsc_family, a.tsc_prod_family,a.tsc_package,a.tsc_desc, a.lead_time, a.lead_time_uom, a.created_by, a.creation_date, a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date"+
	              ",a.NO_WAFER_LEAD_TIME,S_VOLTAGE,E_VOLTAGE"+//add by Peggy 20160130
				  ",nvl(a.ACTIVE_FLAG,'I') ACTIVE_FLAG,REMARKS"+ //add by Peggy 20180802
				  " FROM oraddman.tsprod_manufactory_leadtime a,oraddman.tsprod_manufactory b where a.manufactory_no=b.manufactory_no(+)"+
				  " AND a.seq_id=?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ID);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				PLANT_CODE=rs.getString("manufactory_no");
				ORIG_PLANT_CODE=PLANT_CODE;
				TSC_PROD_GROUP=rs.getString("tsc_prod_group");
				ORIG_TSC_PROD_GROUP=TSC_PROD_GROUP;
				TSC_FAMILY=rs.getString("TSC_FAMILY");
				ORIG_TSC_FAMILY=TSC_FAMILY;
				TSC_PROD_FAMILY=rs.getString("TSC_PROD_FAMILY");
				ORIG_TSC_PROD_FAMILY=TSC_PROD_FAMILY;
				TSC_PACKAGE=rs.getString("TSC_PACKAGE");
				ORIG_TSC_PACKAGE=TSC_PACKAGE;
				ITEM_DESC=rs.getString("TSC_DESC");
				if (ITEM_DESC==null) ITEM_DESC="";
				ORIG_ITEM_DESC=ITEM_DESC;
				LEAD_TIME=rs.getString("lead_time");
				LEAD_TIME_UOM=rs.getString("lead_time_uom");
				LEAD_TIME_NOWAFER=rs.getString("NO_WAFER_LEAD_TIME"); //add by Peggy 20160130
				ACTIVE_FLAG=rs.getString("ACTIVE_FLAG");
				S_VOLTAGE=rs.getString("S_VOLTAGE");
				if (S_VOLTAGE==null) S_VOLTAGE="";
				E_VOLTAGE=rs.getString("E_VOLTAGE");
				if (E_VOLTAGE==null) E_VOLTAGE="";
				REMARKS=rs.getString("REMARKS");
				if (REMARKS==null) REMARKS="";//add by Peggy 20200310
				
			}
			else
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("查無資料,請重新確認,謝謝!");
					setCancel();
				</script>
			<%				
			}
			rs.close();
			statement.close();
		}
		else if (ACODE.equals("SAVE"))
		{
			strExist="";
			if (!ORIG_PLANT_CODE.equals(PLANT_CODE) || !ORIG_TSC_PROD_GROUP.equals(TSC_PROD_GROUP) || !ORIG_TSC_FAMILY.equals(TSC_FAMILY) || !ORIG_TSC_PROD_FAMILY.equals(TSC_PROD_FAMILY) || !ORIG_TSC_PACKAGE.equals(TSC_PACKAGE) || !ORIG_ITEM_DESC.equals(ITEM_DESC))
			{
				sql = " SELECT 1 FROM oraddman.tsprod_manufactory_leadtime a "+
					  " where MANUFACTORY_NO=? and TSC_PROD_GROUP =? and TSC_FAMILY=? and TSC_PROD_FAMILY=? and TSC_PACKAGE=? and nvl(TSC_DESC,'xxx') =nvl(?,'xxx')";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,PLANT_CODE);
				statement.setString(2,TSC_PROD_GROUP);
				statement.setString(3,TSC_FAMILY);
				statement.setString(4,TSC_PROD_FAMILY);
				statement.setString(5,TSC_PACKAGE);
				statement.setString(6,ITEM_DESC);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{	
					strExist="Y";
				}	
				rs.close();
				statement.close();
			}
		}
	}
	
		
	if (ACODE.equals("PART") && !ITEM_DESC.equals(""))
	{
		sql = " select tsc_inv_category(a.inventory_item_id,a.organization_id,21) tsc_family "+
		      " ,tsc_inv_category(a.inventory_item_id,a.organization_id,23) tsc_package "+
			  " ,tsc_inv_category(a.inventory_item_id,a.organization_id,1100000003) tsc_prod_group "+
			  " ,tsc_inv_category(a.inventory_item_id,a.organization_id,1100000004) tsc_prod_family "+
		      " from inv.mtl_system_items_b a"+
			  " where description =? "+
			  " and organization_id=? "+
			  " and attribute3=?"+
			  " order by length(a.segment1) desc,decode(a.CUSTOMER_ORDER_FLAG,'Y',1,0)";
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ITEM_DESC);
		statement.setInt(2,49);		
		statement.setString(3,PLANT_CODE);			
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{	
			TSC_FAMILY = rs.getString(1);
			TSC_PACKAGE = rs.getString(2);
			TSC_PROD_GROUP = rs.getString(3);
			TSC_PROD_FAMILY = rs.getString(4);
		}	
		rs.close();
		statement.close();
	}	
	
	if (ACODE.equals("SAVE") && !ITEM_DESC.equals("") && !ORIG_ITEM_DESC.equals(ITEM_DESC))
	{
		sql = " select distinct 1 "+
		      " from inv.mtl_system_items_b a"+
			  " where description =? "+
			  " and organization_id=? "+
			  " and attribute3=?";
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ITEM_DESC);
		statement.setInt(2,49);		
		statement.setString(3,PLANT_CODE);			
		ResultSet rs=statement.executeQuery();
		if (!rs.next())
		{	
			strNoFound="Y";
		}
		rs.close();
		statement.close();
	}

%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<input type="hidden" name="ID" value="<%=ID%>">
<input type="hidden" name="ORIG_PLANT_CODE" value="<%=ORIG_PLANT_CODE%>">
<input type="hidden" name="ORIG_TSC_PROD_GROUP" value="<%=ORIG_TSC_PROD_GROUP%>">
<input type="hidden" name="ORIG_TSC_PACKAGE" value="<%=ORIG_TSC_PACKAGE%>">
<input type="hidden" name="ORIG_TSC_FAMILY" value="<%=ORIG_TSC_FAMILY%>">
<input type="hidden" name="ORIG_TSC_PROD_FAMILY" value="<%=ORIG_TSC_PROD_FAMILY%>">
<input type="hidden" name="ORIG_ITEM_DESC" value="<%=ORIG_ITEM_DESC%>">
<table align="center" width="80%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">生產廠區Lead Time資料維護</font></strong>
		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#99CC99" bordercolor="#CCCCCC">
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>生產廠區：</td>
					<td nowrap>
					<%
					try
					{
						sql = " select a.manufactory_no,a.manufactory_no || ' '||a.manufactory_name manufactory_name from oraddman.tsprod_manufactory a where MANUFACTORY_NO in ('002','005','006','008','010','011')";
						if (STATUS.equals("UPD"))
						{
							sql += " and MANUFACTORY_NO='"+PLANT_CODE+"'";
						}
						else if (UserRoles.indexOf("admin")<0)
						{
							sql += " and MANUFACTORY_NO='"+userProdCenterNo+"'";
							PLANT_CODE = userProdCenterNo;
						}
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(PLANT_CODE);
						comboBoxBean.setFieldName("PLANT_CODE");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Prod Group：</td>
					<td nowrap>
					<%
					try
					{
						//add by Peggy 20170503
						if (TSC_PROD_GROUP.equals(""))
						{
							sql = "select tsc_prod_group from oraddman.tsprod_manufactory a where MANUFACTORY_NO=?"; 
							PreparedStatement statementx = con.prepareStatement(sql);
							statementx.setString(1,PLANT_CODE);
							ResultSet rsx=statementx.executeQuery();
							if (rsx.next())
							{
								TSC_PROD_GROUP = rsx.getString(1);
							}
							rsx.close();
							statementx.close();
						}
					
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_GROUP' AND DISABLE_DATE IS NULL order by SEGMENT1 ";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSC_PROD_GROUP);
						comboBoxBean.setFieldName("TSC_PROD_GROUP");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>					
					</td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Family：</td>
					<td nowrap>
					<%
					try
					{
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Family' AND DISABLE_DATE IS NULL  order by SEGMENT1";
						//if (STATUS.equals("UPD")) sql += " and SEGMENT1='"+TSC_FAMILY+"'";
						//sql +=" order by SEGMENT1";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSC_FAMILY);
						comboBoxBean.setFieldName("TSC_FAMILY");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td>
				</tr>
				<%
				if (TSC_PROD_GROUP.equals("PMD") || TSC_PROD_GROUP.equals("SSP")|| TSC_PROD_GROUP.equals("SSD") || PLANT_CODE.equals("010"))
				{	
				%>							
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Prod Family：</td>
					<td nowrap>
					<%
					try
					{
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_FAMILY' AND DISABLE_DATE IS NULL  order by SEGMENT1";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSC_PROD_FAMILY);
						comboBoxBean.setFieldName("TSC_PROD_FAMILY");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td>
				</tr>
				<%
				}
				else
				{
					out.println("<input type='hidden' name='TSC_PROD_FAMILY' value=''>");
				}
				%>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Package：</td>
					<td nowrap>
					<%
					try
					{
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Package' AND DISABLE_DATE IS NULL order by SEGMENT1";
						//if (STATUS.equals("UPD")) sql += " and SEGMENT1='"+TSC_PACKAGE+"'";
						//sql +=" order by SEGMENT1";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSC_PACKAGE);
						comboBoxBean.setFieldName("TSC_PACKAGE");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>					
					</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>型號：</td>
					<td nowrap><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia; font-size:12px" size="20" onKeyPress='setCategory("../jsp/TSDRQProdLeadTimeAdd.jsp?ACODE=PART&ID=<%=ID%>&STATUS=<%=STATUS%>",this.form.ITEM_DESC.value)'><br>輸入型號按下Enter鍵自動顯示上面Category</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Voltage(V)：</td>
					<td nowrap><input type="text" name="S_VOLTAGE" value="<%=S_VOLTAGE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10">~<input type="text" name="E_VOLTAGE" value="<%=E_VOLTAGE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Lead Time：</td>
					<td nowrap><input type="text" name="LEAD_TIME" value="<%=LEAD_TIME%>" style="font-family: Tahoma,Georgia; font-size:12px" size="20" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">
					<%
					try
					{
						sql = " select a.DATE_VALUE,a.DATE_VALUE from oraddman.tsprod_manufactory_setup a where DATA_TYPE='LEAD_TIME_UOM'";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(LEAD_TIME_UOM);
						comboBoxBean.setFieldName("LEAD_TIME_UOM");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td>
				</tr>	
				<!--<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Lead Time(No Wafer)：</td>
					<td nowrap><input type="text" name="LEAD_TIME_NOWAFER" value="<%=LEAD_TIME_NOWAFER%>" style="font-family: Tahoma,Georgia; font-size:12px" size="20" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">
					<%
					/*try
					{
						sql = " select a.DATE_VALUE,a.DATE_VALUE from oraddman.tsprod_manufactory_setup a where DATA_TYPE='LEAD_TIME_UOM'";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(LEAD_TIME_UOM);
						comboBoxBean.setFieldName("LEAD_TIME_UOM");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}*/
					%>						
					</td>
				</tr>-->
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Remarks：</td>
					<td nowrap><input type="text" name="REMARKS" value="<%=REMARKS%>" style="font-family: Tahoma,Georgia; font-size:12px" size="40">
				</tr>
				<tr>
					<td width="35%" height="25"  bgcolor="#C9E2D0" nowrap>狀態：</td>
					<td nowrap><input type="radio" name="ACTIVE_FLAG" value="A" style="font-family: Tahoma,Georgia; font-size:12px" <%if (ACTIVE_FLAG.equals("A")){out.println("checked");}%>><font style="font-size:12px">啟用</font>
						       <input type="radio" name="ACTIVE_FLAG" value="I" style="font-family: Tahoma,Georgia; font-size:12px" <%if (ACTIVE_FLAG.equals("I")){out.println("checked");}%>><font style="font-size:12px">停用</font>
					</td>
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
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSDRQProdLeadTimeAdd.jsp?ACODE=SAVE&ID=<%=ID%>&STATUS=<%=STATUS%>")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick='setCancel()' value="關閉視窗" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (ACODE.equals("SAVE"))
	{
		
		try
		{
			if (strExist.equals("Y"))
			{
				throw new Exception("資料已存在,請重新確認,謝謝!");	
			}
			if (strNoFound.equals("Y"))
			{
				throw new Exception("查無型號:"+ITEM_DESC+",請重新確認,謝謝!");	
			}
			
			if (STATUS.equals("UPD"))
			{
				sql= " update oraddman.tsprod_manufactory_leadtime "+
				     " set LEAD_TIME=?"+
					 ",LEAD_TIME_UOM=?"+
					 ",LAST_UPDATED_BY=?"+
					 ",LAST_UPDATE_DATE=sysdate"+
					 ",tsc_prod_group=?"+
					 ",tsc_family=?"+
					 ",tsc_prod_family=?"+
					 ",tsc_package=?"+
					 ",tsc_desc=?"+
					 ",NO_WAFER_LEAD_TIME=?"+
					 ",ACTIVE_FLAG=?"+ //add by Peggy 20180802
					 ",S_VOLTAGE=?"+ //add by Peggy 20200305
					 ",E_VOLTAGE=?"+ //add by Peggy 20200305
					 ",REMARKS=?"+   //add by Peggy 20200310
					 " where seq_id = ?";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,LEAD_TIME);
				st1.setString(2,LEAD_TIME_UOM); 
				st1.setString(3,UserName);
				st1.setString(4,TSC_PROD_GROUP);
				st1.setString(5,TSC_FAMILY);
				st1.setString(6,TSC_PROD_FAMILY);
				st1.setString(7,TSC_PACKAGE);
				st1.setString(8,ITEM_DESC);
				st1.setString(9,LEAD_TIME_NOWAFER);	
				st1.setString(10,ACTIVE_FLAG);	
				st1.setString(11,S_VOLTAGE);	
				st1.setString(12,E_VOLTAGE);	
				st1.setString(13,REMARKS);	
				st1.setString(14,ID);	
				st1.executeUpdate();
				st1.close();
			%>
				<script language = "JavaScript">
					alert('修改成功!');
					window.opener.MYFORM.submit();
					setCancel();
				</script>
			<%				
			}
			else
			{
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(" SELECT TS_LEADTIME_BATCH_ID_S.nextval from dual");
				if (rs1.next())
				{
					V_BATCH_ID = rs1.getString(1);
				}
				else
				{
					throw new Exception("BATCH_ID取得失敗!!");
				}
				rs1.close();
				statement1.close();
								
				sql = " insert into oraddman.tsprod_manufactory_leadtime "+
					  " (manufactory_no"+
					  ",tsc_prod_group"+
					  ",tsc_family"+
					  ",tsc_prod_family"+
					  ",tsc_package"+
					  ",tsc_desc"+
					  ",lead_time"+
					  ",lead_time_uom"+
					  ",created_by"+
					  ",creation_date"+
					  ",last_updated_by"+
					  ",last_update_date"+
					  ",seq_id"+
					  ",NO_WAFER_LEAD_TIME"+
					  ",ACTIVE_FLAG"+
					  ",S_VOLTAGE"+ //add by Peggy 20200305
					  ",E_VOLTAGE"+ //add by Peggy 20200305
					  ",BATCH_ID"+  //add by Peggy 20200306
					  ",REMARKS"+   //add by Peggy 20200310
					  ")"+
					  " select "+
					  " ?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",sysdate"+
					  ",NVL(max(seq_id),0)+1"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  " from oraddman.tsprod_manufactory_leadtime ";
				//out.println(sql);
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,PLANT_CODE);	
				st1.setString(2,TSC_PROD_GROUP);
				st1.setString(3,TSC_FAMILY); 
				st1.setString(4,TSC_PROD_FAMILY); 
				st1.setString(5,TSC_PACKAGE);
				st1.setString(6,ITEM_DESC);  
				st1.setString(7,LEAD_TIME);  
				st1.setString(8,LEAD_TIME_UOM);  
				st1.setString(9,UserName); 
				st1.setString(10,UserName); 
				st1.setString(11,LEAD_TIME_NOWAFER); 
				st1.setString(12,ACTIVE_FLAG); 
				st1.setString(13,S_VOLTAGE);	
				st1.setString(14,E_VOLTAGE);	
				st1.setString(15,V_BATCH_ID);	
				st1.setString(16,REMARKS);	
				st1.executeUpdate();
				st1.close();
				
				out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
		%>
				<script language="javascript">
					setClear();
				</script>
		<%
			}
		}
		catch(Exception e)
		{
			out.println("<div align='center' style='color:#ff0000'>交易異常:"+e.getMessage()+"</div>");
		}
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>Exception1:"+e.getMessage()+"</DIV>");
}
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
