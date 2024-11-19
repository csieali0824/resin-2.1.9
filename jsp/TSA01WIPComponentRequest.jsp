<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean,SalesDRQPageHeaderBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="FrontWIPBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="WaferBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="WIPMISCBean" scope="session" class="Array2DimensionInputBean"/>
<title>A01封裝-領退料申請</title>
<script language="JavaScript" type="text/JavaScript">
function setQuery()
{ 
	if (event.keyCode==13)
	{
		if (document.MYFORM.TRANS_TYPE.value==null || document.MYFORM.TRANS_TYPE.value =="" || document.MYFORM.TRANS_TYPE.value =="--")
		{
			alert("請選擇交易類型!");
			document.MYFORM.TRANS_TYPE.focus();
			return false;
		}
		if (document.MYFORM.WIP_NO.value==null || document.MYFORM.WIP_NO.value =="")
		{
			alert("請輸入工單號碼!");
			document.MYFORM.WIP_NO.focus();
			return false;
		}
		//if (document.MYFORM.WIP_NO.value != document.MYFORM.WIP_NO_TEMP.value || document.MYFORM.WIP_NO_TEMP.value ==null ||  document.MYFORM.WIP_NO_TEMP.value =="")
		//{
			document.MYFORM.submit();
		//}
	}
}
function setChange(v_trans_type)
{
	if (document.MYFORM.ACODE.value!="VIEW" && document.MYFORM.WIP_NO.value!=null && document.MYFORM.WIP_NO.value !="")
	{
		document.MYFORM.submit();
	}
	else 
	{
		if (v_trans_type=="MISC" || v_trans_type=="RDMISC" || v_trans_type=="QCMISC") 
		{
			document.getElementById("wip1").style.visibility="hidden";
			document.getElementById("send1").style.visibility="hidden";
			document.getElementById("upload1").style.visibility="visible";
		}
		else
		{
			document.getElementById("wip1").style.visibility="visible";
			document.getElementById("send1").style.visibility="visible";
			document.getElementById("upload1").style.visibility="hidden";
		}
	}
}
function setUpload()
{
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open("../jsp/TSA01WIPComponentInventory.jsp","subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
function setSubmit(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	if (document.MYFORM.TRANS_TYPE.value ==null || document.MYFORM.TRANS_TYPE.value =="--" || document.MYFORM.TRANS_TYPE.value =="")
	{
		alert("請選擇交易類型!");
		document.MYFORM.TRANS_TYPE.focus();
		return false;
	}
	if (document.MYFORM.TRANS_TYPE.value!="MISC" && document.MYFORM.TRANS_TYPE.value!="RDMISC" && document.MYFORM.TRANS_TYPE.value!="QCMISC")
	{
		if (document.MYFORM.WIP_NO_TEMP.value != document.MYFORM.WIP_NO.value)
		{
			alert("工單與申請原物料內容不符,請重新確認!");
			document.MYFORM.WIP_NO.focus();
			return false;
		}
		if (document.MYFORM.chk.length != undefined)
		{
			iLen = document.MYFORM.chk.length;
		}
		else
		{
			iLen = 1;
		}
		for (var i=1; i<= iLen ; i++)
		{
			if (iLen==1)
			{
				chkvalue =document.MYFORM.chk.checked;
				lineid = document.MYFORM.chk.value;
			}
			else
			{
				chkvalue = document.MYFORM.chk[i-1].checked;
				lineid = document.MYFORM.chk[i-1].value;
			}
			if (chkvalue==true)
			{
				if (document.MYFORM.elements["SPQ_"+lineid].value ==null || document.MYFORM.elements["SPQ_"+lineid].value =="" || eval(document.MYFORM.elements["SPQ_"+lineid].value)<=0)
				{
					alert("項次"+i+":最小包裝量必須大於0!");
					return false;		
				}
				if (document.MYFORM.elements["REQUEST_QTY_"+lineid].value ==null || document.MYFORM.elements["REQUEST_QTY_"+lineid].value =="")
				{
					alert("項次"+i+":請輸入領用數量!");
					return false;		
				}
				if (document.MYFORM.TRANS_TYPE.value=="ISSUE")
				{
					//if (document.MYFORM.elements["COMP_TYPE_"+lineid].value!="C002"  && document.MYFORM.elements["COMP_TYPE_"+lineid].value!="C004" && document.MYFORM.elements["COMP_TYPE_"+lineid].value!="C006" && document.MYFORM.elements["COMP_TYPE_"+lineid].value!="C008"  && document.MYFORM.elements["COMP_TYPE_"+lineid].value!="C009"  && document.MYFORM.elements["COMP_TYPE_"+lineid].value!="C010")
					//{
					//	if (eval(document.MYFORM.elements["REQUEST_QTY_"+lineid].value)<=0)
					//	{
					//		alert("項次"+i+":領用數量必須大於0!");
					//		return false;	
					//	}	
					//}
					if (eval(document.MYFORM.elements["REQUEST_QTY_"+lineid].value)>0 && (document.MYFORM.elements["COMP_TYPE_"+lineid].value=="C001" || document.MYFORM.elements["COMP_TYPE_"+lineid].value=="C008"))
					{
						if ((document.MYFORM.elements["LOT_LIST_"+lineid].value==null || document.MYFORM.elements["LOT_LIST_"+lineid].value=="") && (document.MYFORM.elements["EE_LOT_LIST_"+lineid].value==null || document.MYFORM.elements["EE_LOT_LIST_"+lineid].value==""))
						{
							alert("項次"+i+":請輸入批號!");
							return false;	
						} 
					}
				}			
				else if (document.MYFORM.TRANS_TYPE.value=="RETURN")
				{
					if (eval(document.MYFORM.elements["REQUEST_QTY_"+lineid].value)<0 || eval(document.MYFORM.elements["REQUEST_QTY_"+lineid].value)>eval(document.MYFORM.elements["ORIG_REQ_QTY_"+lineid].value))
					{
						alert("項次"+i+":領退數量必須介於0~"+document.MYFORM.elements["ORIG_REQ_QTY_"+lineid].value+"之間!");
						return false;	
					}
				}			
				chkcnt++;
			}
		}
		if (chkcnt <=0)
		{
			alert("請先勾選資料!");
			return false;
		}	
	}
	document.MYFORM.save1.disabled= true;
	document.MYFORM.cancel1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit1(URL)
{   
	if (confirm("您確定要離開回到首頁嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit2(URL)
{   
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function showFrontWIPList(itemid,itemname,uom,lineno,orgid,reqQty,comptypeno)
{
	subWin=window.open("../jsp/subwindow/TSA01FrontWIPListFind.jsp?ITEMID="+itemid+"&ITEM_NAME="+itemname+"&UOM="+uom+"&ORGANIZATION_ID="+orgid+"&LINENO="+lineno+"&REQQTY="+reqQty+"&PTYPE="+document.MYFORM.ACODE.value+"&WIPNO="+document.MYFORM.WIP_NO.value+"&CTYPENO="+comptypeno,"subwin","width=800,height=500,scrollbars=yes,menubar=no");  
}	
function showWaferLotList(itemid,itemname,uom,lineno,orgid,comptypeno)
{
	subWin=window.open("../jsp/subwindow/TSA01WaferLotListFind.jsp?ITEMID="+itemid+"&ITEM_NAME="+itemname+"&UOM="+uom+"&ORGANIZATION_ID="+orgid+"&LINENO="+lineno+"&REQQTY="+document.MYFORM.elements["REQUEST_QTY_"+lineno].value+"&PTYPE="+document.MYFORM.ACODE.value+"&WIPNO="+document.MYFORM.WIP_NO.value+"&CTYPENO="+comptypeno,"subwin","width=600,height=500,scrollbars=yes,menubar=no");  
}	

</script>
</head>
<body>
<%
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String TRANS_TYPE = request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null) TRANS_TYPE="";
String REQUEST_NO = request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String WIP_ID = request.getParameter("WIP_ID");
if (WIP_ID==null) WIP_ID="";
String WIP_NO_TEMP = request.getParameter("WIP_NO_TEMP");
if (WIP_NO_TEMP==null) WIP_NO_TEMP="";
String ITEM_DESC=request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String ITEM_ID=request.getParameter("ITEM_ID");
if (ITEM_ID==null) ITEM_ID="";
String ITEM_NAME=request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String TSC_PACKAGE=request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="606";
String REQUEST_DATE=request.getParameter("REQUEST_DATE");
if (REQUEST_DATE==null) REQUEST_DATE=dateBean.getYearMonthDay();
String CREATED_BY = request.getParameter("CREATED_BY");
if (CREATED_BY==null) CREATED_BY="";
String screenWidth=request.getParameter("SWIDTH");
if (screenWidth==null) screenWidth="0";
String screenHeight=request.getParameter("SHEIGHT");
if (screenHeight==null) screenHeight="0";
String sql="",err_msg="",objEvent="",objeeEvent="";
int icnt=0;
FrontWIPBean.setArray2DString(null);
WaferBean.setArray2DString(null);
if (!ACODE.equals("UPLOAD"))
{
	WIPMISCBean.setArray2DString(null);
}

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{
	if (ACODE.equals("VIEW"))
	{
		sql = " SELECT a.REQUEST_NO,a.REQUEST_TYPE,a.ORGANIZATION_ID,a.WIP_ENTITY_NAME,a.WIP_ENTITY_ID"+
			  ",a.INVENTORY_ITEM_ID,a.ITEM_NAME,a.TSC_PACKAGE,a.CREATED_BY,TO_CHAR(a.CREATION_DATE,'YYYYMMDD') CREATION_DATE "+
			  ",b.description"+
			  " FROM ORADDMAN.TSA01_REQUEST_HEADERS_ALL a,INV.MTL_SYSTEM_ITEMS_B b"+
			  " WHERE a.ORGANIZATION_ID=b.ORGANIZATION_ID"+
			  " AND a.INVENTORY_ITEM_ID=b.INVENTORY_ITEM_ID"+
			  " AND a.REQUEST_NO=?";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,REQUEST_NO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{	
			REQUEST_NO = rs.getString("REQUEST_NO");
			TRANS_TYPE = rs.getString("REQUEST_TYPE");
			WIP_NO = rs.getString("WIP_ENTITY_NAME");
			WIP_ID = rs.getString("WIP_ENTITY_ID");
			WIP_NO_TEMP = rs.getString("WIP_ENTITY_NAME");
			ITEM_DESC=rs.getString("description");
			ITEM_ID=rs.getString("INVENTORY_ITEM_ID");
			ITEM_NAME=rs.getString("ITEM_NAME");
			TSC_PACKAGE=rs.getString("TSC_PACKAGE");
			if (TSC_PACKAGE==null)  TSC_PACKAGE="";
			ORGANIZATION_ID = rs.getString("ORGANIZATION_ID");
			REQUEST_DATE=rs.getString("CREATION_DATE");
			CREATED_BY=rs.getString("CREATED_BY");
		}		 
		else
		{
			out.println("<div style='color:#ff0000'>查無工單申請資料,請重新確認!!</div>");
		}
		rs.close();
		statement.close();
	}
	else 
	{	
		CREATED_BY=UserName;
		if (REQUEST_NO.equals(""))
		{
			CallableStatement cs1 = con.prepareCall("{call TSA01_WIP_PKG.GET_PROCESS_NO(?,?,?,?)}");
			cs1.setString(1,"REQUEST_NO");    
			cs1.setString(2, REQUEST_DATE.substring(2,6));    
			cs1.setInt(3, 4);    
			cs1.registerOutParameter(4, Types.VARCHAR);   
			cs1.execute();
			REQUEST_NO = cs1.getString(4);                    
			cs1.close();
		}
		if (!WIP_NO.equals(""))
		{
			sql = " SELECT COUNT(1) FROM oraddman.tsa01_request_headers_all B "+
				  " WHERE WIP_ENTITY_NAME=?"+
				  " AND B.REQUEST_TYPE=?"+
				  " and exists (select 1 from oraddman.tsa01_request_lines_all A"+
				  "             where upper(a.STATUS) NOT IN (?,?,?) and a.request_no=b.request_no)";
			//out.println(sql);
			PreparedStatement statement2 = con.prepareStatement(sql);
			statement2.setString(1,WIP_NO);
			statement2.setString(2,TRANS_TYPE);
			statement2.setString(3,"CLOSED");
			statement2.setString(4,"REJECT");
			statement2.setString(5,"DISAGREE");
			ResultSet rs2=statement2.executeQuery();
			if (rs2.next())
			{
				if (rs2.getInt(1)==0)
				{
					sql =" SELECT A.WIP_ENTITY_ID,C.INVENTORY_ITEM_ID WIP_ITEM_ID,C.SEGMENT1 WIP_ITEM_NAME,C.DESCRIPTION WIP_ITEM_DESC "+
						 " ,TSC_OM_CATEGORY(C.INVENTORY_ITEM_ID,C.ORGANIZATION_ID,'TSC_Package') TSC_PACKAGE"+
						 " FROM WIP_DISCRETE_JOBS_V A,INV.MTL_SYSTEM_ITEMS_B C"+
						 " WHERE A.ORGANIZATION_ID=C.ORGANIZATION_ID"+
						 " AND A.PRIMARY_ITEM_ID=C.INVENTORY_ITEM_ID"+
						 " AND A.wip_entity_name=?"+
						 " AND A.ORGANIZATION_ID=?"+
						 " AND A.STATUS_TYPE_DISP in ('Complete','Released')"; //add Complete status,by Peggy 20170505 
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,WIP_NO);
					statement.setString(2,ORGANIZATION_ID);
					//statement.setString(3,"Released");
					ResultSet rs=statement.executeQuery();
					if (rs.next())
					{	
						WIP_ID = rs.getString(1);
						ITEM_ID = rs.getString(2);
						ITEM_NAME = rs.getString(3);
						ITEM_DESC = rs.getString(4);
						TSC_PACKAGE = rs.getString(5);
						if (TSC_PACKAGE==null) TSC_PACKAGE="";
						WIP_NO_TEMP = WIP_NO;
					}
					else
					{
						err_msg="查無工單:"+WIP_NO+" 資訊!!";
						WIP_ID = ""; ITEM_ID = "";ITEM_NAME = "";ITEM_DESC = ""; WIP_NO_TEMP="";
					}
					rs.close();
					statement.close();
				}
				else
				{
					err_msg="工單:"+WIP_NO+" 正在申請中,請勿重複申請!!";
					WIP_ID = ""; ITEM_ID = "";ITEM_NAME = "";ITEM_DESC = ""; WIP_NO_TEMP="";
				}
			}
			rs2.close();
			statement2.close();
			
		}
	}
}
catch(Exception e)
{
	out.println("<font color='#ff0000'>系統發生錯誤:"+e.getMessage()+",請洽系統管理人員!!</font>");
}
%>
<form name="MYFORM"  METHOD="post" ACTION="TSA01WIPComponentRequest.jsp">
<input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
<input type="hidden" name="ACODE" value="<%=ACODE%>">
<div align="center" style="font-size:18px;font-family: Tahoma,Georgia">A01封裝領(退)料申請</div>
<div align="right">
<%
if (ACODE.equals("VIEW"))
{
%>
<A href="TSA01WIPRequestHistory.jsp"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a>
&nbsp;&nbsp;
<%
}
%>
<A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
<hr>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:<%=screenWidth%>;height:<%=screenHeight%>;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td width="6%">交易類型:</td>
		<td width="19%">		
		<%
		try
		{   
			sql = "select a.type_value,a.type_name from oraddman.tsa01_base_setup a where a.type_code='REQ_TYPE'";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TRANS_TYPE);
			comboBoxBean.setFieldName("TRANS_TYPE");	
			comboBoxBean.setOnChangeJS("setChange(this.value)");
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();      	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		<input type="button" id="upload1" name="upload1" value="Upload" onClick='setUpload()' style="font-family: Tahoma,Georgia;visibility:<%=!TRANS_TYPE.equals("MISC")&& !TRANS_TYPE.equals("RDMISC") && !TRANS_TYPE.equals("QCMISC")?"hidden":"visibility"%>">
		</td>
		<td width="6%">領料單號:</td>
		<td width="19%"><input type="text" name="REQUEST_NO" value="<%=REQUEST_NO%>" style="font-family: Tahoma,Georgia;" readonly></td>
		<td width="6%">申請日期:</td>
		<td width="19%"><input type="text" name="REQUEST_DATE" value="<%=REQUEST_DATE%>" style="font-family: Tahoma,Georgia;" size="10" readonly></td>
		<td width="6%">申請人:</td>
		<td width="19%"><input type="text" name="CREATED_BY" value="<%=CREATED_BY%>" style="font-family: Tahoma,Georgia;"  size="15" readonly></td>
		
	</tr>
</table>
<%
try
{
	if (ACODE.equals("UPLOAD"))
	{
	%>
<p>
<table width="100%" id="wip2" border="1" cellPadding="1" cellspacing="0">
	<tr style="color:#ffffff" bgcolor="#99CC99">
		<td>工單號</td>
		<td>原物料/半成品/成品料號</td>
		<td>批號</td>
		<td>MES餘量(K)</td>
		<td>盤點餘料(K)</td>	
		<td>差異數(K)</td>	
	</tr>
	<%
		String LotArray[][]=WIPMISCBean.getArray2DContent();
		if (LotArray!=null)
		{
			for( int j=0 ; j< LotArray.length ; j++ ) 
			{
			%>
				<tr>
				<td><%=LotArray[j][0]%></td>
				<td><%=LotArray[j][1]%></td>
				<td><%=LotArray[j][2]%></td>
				<td align="right"><%=LotArray[j][3]%></td>
				<td align="right"><%=LotArray[j][4]%></td>
				<td align="right" style="color:<%=Double.parseDouble(LotArray[j][5])<0?"FF0000":"0000FFF"%>"><%=LotArray[j][5]%></td>
				<tr>
			<%				
			}
		}
	%>
	</table>
<p>
	<%
	}
	else
	{
%>
<table width="100%" id="wip1">
	<tr>
		<td>	
			<table width="100%">
				<tr>
					<td>工單號碼:</td>
					<td><input type="text" name="WIP_NO" value="<%=WIP_NO%>" style="font-family: Tahoma,Georgia;" <%=(ACODE.equals("VIEW")?" readonly ":" onKeyPress='setQuery()'")%>><input type="hidden" name="WIP_ID" value="<%=WIP_ID%>"><input type="hidden" name="WIP_NO_TEMP" value="<%=WIP_NO_TEMP%>">
					  <br><font color='#0000ff'><%=(ACODE.equals("VIEW")?"":"(輸入完畢後,請按Enter鍵)")%></font></td>
					<td>品名:</td>
					<td colspan="3"><input type="text" name="ITEM_NAME" value="<%=ITEM_NAME%>" style="font-family: Tahoma,Georgia;" size="25" readonly><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia;" size="50" readonly><input type="hidden" name="ITEM_ID" value="<%=ITEM_ID%>"></td>
					<td>Package:</td>
					<td><input type="text" name="TSC_PACKAGE" value="<%=TSC_PACKAGE%>" style="font-family: Tahoma,Georgia;" size="20" readonly></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<%

		if (!WIP_NO.equals(""))
		{
			if (!WIP_ID.equals(""))
			{
				if (ACODE.equals("VIEW"))
				{
					 sql = " SELECT a.request_no, a.line_no, a.comp_type_no,b.comp_type_name, a.organization_id,a.OP_SEQ_NUM OPERATION_SEQ_NUM,"+
						   " a.component_item_id INVENTORY_ITEM_ID, a.component_name CONCATENATED_SEGMENTS, a.uom ITEM_PRIMARY_UOM_CODE, a.required_qty REQUIRED_QUANTITY,"+
						   " a.request_qty,  a.spq, a.moq, a.change_rate,"+
						   " a.remarks,d.description ITEM_DESCRIPTION"+
						   ",(select listagg(e.LOT ||CASE WHEN E.REMARKS IS NULL THEN '' ELSE '('||E.REMARKS||')' END ,'\n') within group (order by e.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL e where  a.request_no=e.request_no"+
						   " and a.line_no=e.line_no and nvl(e.MISCELLANEOUS_FLAG,'N')='N') lot_list"+
						   ",(select listagg(e.LOT ||CASE WHEN E.REMARKS IS NULL THEN '' ELSE '('||E.REMARKS||')' END ,'\n') within group (order by e.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL e where  a.request_no=e.request_no"+
						   " and a.line_no=e.line_no and nvl(e.MISCELLANEOUS_FLAG,'N')='Y') ee_lot_list"+
						   " FROM oraddman.tsa01_request_lines_all a,oraddman.tsa01_component_type b,oraddman.tsa01_request_headers_all c,inv.mtl_system_items_b d "+
						   " where a.COMP_TYPE_NO=b.COMP_TYPE_NO "+
						   " and a.request_no=c.request_no"+
						   " and a.organization_id=d.organization_id"+
						   " and a.component_item_id=d.inventory_item_id"+
						   " and c.request_type=?"+
						   " and c.WIP_ENTITY_ID=?"+
						   //" and 1=?"+
						   " and a.request_no='"+REQUEST_NO+"'"+
						   " and c.organization_id=?"+
						   " order by a.line_no";
				}
				else
				{
					sql =" SELECT B.CONCATENATED_SEGMENTS,B.INVENTORY_ITEM_ID,B.ITEM_DESCRIPTION,B.ITEM_PRIMARY_UOM_CODE"+
						 " ,B.REQUIRED_QUANTITY,C.COMP_TYPE_NO,D.COMP_TYPE_NAME,C.SPQ,C.MOQ,C.CHANGE_RATE,B.OPERATION_SEQ_NUM"+
						 //" ,CASE WHEN ?='RETURN' THEN TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)) ELSE round((B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0))) /NVL(C.SPQ,1))*C.SPQ  END REQUEST_QTY "+
						 //" ,CASE WHEN ?='RETURN' THEN TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)) ELSE CASE WHEN C.COMP_TYPE_NO=? THEN CEIL((B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0))) /NVL(C.SPQ,1))*C.SPQ ELSE round((B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0))) /NVL(C.SPQ,1))*C.SPQ END END REQUEST_QTY "+
						 //" ,CASE WHEN ?='RETURN' THEN TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)) ELSE  CASE WHEN C.COMP_TYPE_NO='C004' THEN CEIL(ROUND(B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)),6)/NVL(C.SPQ,1))*C.SPQ  ELSE CEIL((B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)))/NVL(C.SPQ,1))*C.SPQ  END END as REQUEST_QTY "+
						 " ,CASE WHEN ?='RETURN' THEN  CASE WHEN B.WIP_SUPPLY_MEANING='Operation Pull' THEN NVL((SELECT case when x.REQUEST_TYPE='ISSUE' then 1 else -1 end*ISSUE_QTY ISSUE_QTY from oraddman.tsa01_request_headers_all x,oraddman.tsa01_request_lines_all y"+
                         " WHERE x.request_no=y.request_no  and x.STATUS<>'REJECT' and x.WIP_ENTITY_ID=B.WIP_ENTITY_ID and y.COMPONENT_ITEM_ID=B.INVENTORY_ITEM_ID),0) ELSE  TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)) END ELSE  CASE WHEN C.COMP_TYPE_NO='C004' THEN CEIL(ROUND(B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)),6)/NVL(C.SPQ,1))*C.SPQ  ELSE CEIL((B.REQUIRED_QUANTITY-TO_NUMBER(NVL(B.QUANTITY_ISSUED,0)))/NVL(C.SPQ,1))*C.SPQ  END END as REQUEST_QTY "+
						 " ,'' REMARKS"+
						 " ,'' lot_list"+
						 " ,'' ee_lot_list"+ //add by Peggy 20161207
						 " FROM WIP_REQUIREMENT_OPERATIONS_V B,ORADDMAN.TSA01_COMPONENT_DETAIL C,ORADDMAN.TSA01_COMPONENT_TYPE D,INV.MTL_SYSTEM_ITEMS_B MSI"+
						 " WHERE B.ORGANIZATION_ID=C.ORGANIZATION_ID(+)"+
						 " AND B.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID(+)"+
						 " AND C.COMP_TYPE_NO=D.COMP_TYPE_NO(+)"+
						 " AND B.WIP_ENTITY_ID=?"+
						 //" AND B.WIP_SUPPLY_TYPE=?"+
						 " AND B.ORGANIZATION_ID=?"+
						 " AND B.inventory_item_id=MSI.inventory_item_id"+
                         " AND B.organization_id=MSI.organization_id"+
						 " AND MSI.item_type<>'SA'"+  //LINDA 要求移除半成品,ADD BY Peggy 20210902
						 " AND B.REQUIRED_QUANTITY>0"+
						 " ORDER BY C.COMP_TYPE_NO,B.CONCATENATED_SEGMENTS,B.REQUIRED_QUANTITY DESC";
				}
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,TRANS_TYPE);
				statement.setString(2,WIP_ID);
				//statement.setString(3,"1");
				statement.setString(3,ORGANIZATION_ID);
				ResultSet rs=statement.executeQuery();
				while (rs.next())
				{	
					//if (TRANS_TYPE.equals("RETURN") && rs.getFloat("REQUEST_QTY")<=0)
					//if (rs.getString("REQUEST_QTY")!=null && rs.getFloat("REQUEST_QTY")<=0 && (!rs.getString("COMP_TYPE_NO").equals("C001") && !rs.getString("COMP_TYPE_NO").equals("C008")))
					//{	
					//	continue;
					//}
					//不檢查,可能會多領,modify by Peggy 20190116
				
					if (icnt==0)
					{			 
	%>
	<tr>
		<td>
			<table width="100%" border="1" cellPadding="1" cellspacing="0">
				<tr style='color:#ffffff' bgcolor='#B4AB72'>
					<td width="8%" align="center">類別</td>
					<td width="10%" align="center">料號</td>
					<td width="30%" align="center">品名</td>
					<td width="6%" align="center">單位</td>
					<td width="6%" align="center">工單用量</td>
					<td width="6%" align="center">最小包裝量</td>
					<td width="6%" align="center"><%=(TRANS_TYPE.equals("ISSUE")?"領用":(TRANS_TYPE.equals("RETURN")?"領退":""))%>數量</td>
					<td width="10%" align="center">指定批號</td>
					<td width="10%" align="center">工程批號</td>
					<td align="center">備註</td>
				</tr>
	<%
					}

					icnt++;
					out.println("<tr>");
					out.println("<td align='center'><input type='checkbox' name='chk' value='"+icnt+"' style='visibility:hidden' checked><input type='hidden' name='COMP_TYPE_"+icnt+"' value='"+rs.getString("COMP_TYPE_NO")+"'>"+rs.getString("COMP_TYPE_NAME")+"</td>");
					out.println("<td><input type='hidden' name='COM_ITEM_"+icnt+"' value='"+rs.getString("CONCATENATED_SEGMENTS")+"'>"+rs.getString("CONCATENATED_SEGMENTS")+"</td>");
					out.println("<td><input type='hidden' name='COM_ITEM_ID_"+icnt+"' value='"+rs.getString("INVENTORY_ITEM_ID")+"'>"+rs.getString("ITEM_DESCRIPTION")+"</td>");
					out.println("<td align='center'><input type='hidden' name='UOM_"+icnt+"' value='"+rs.getString("ITEM_PRIMARY_UOM_CODE")+"'>"+rs.getString("ITEM_PRIMARY_UOM_CODE")+"</td>");
					out.println("<td align='right'><input type='hidden' name='OPERATION_SEQ_NUM_"+icnt+"' value='"+rs.getString("OPERATION_SEQ_NUM")+"'><input type='hidden' name='REQUIRED_QTY_"+icnt+"' value='"+rs.getString("REQUIRED_QUANTITY")+"'>"+Double.valueOf(rs.getString("REQUIRED_QUANTITY")).doubleValue()+"</td>");
					out.println("<td align='right'><input type='hidden' name='SPQ_"+icnt+"' value='"+rs.getString("SPQ")+"'><input type='hidden' name='MOQ_"+icnt+"' value='"+rs.getString("MOQ")+"'><input type='hidden' name='CHANGE_RATE_"+icnt+"' value='"+rs.getString("CHANGE_RATE")+"'>"+Double.valueOf(rs.getString("SPQ")).doubleValue()+"</td>");
					out.println("<td align='center'><input type='text' name='REQUEST_QTY_"+icnt+"' value='"+Double.valueOf((rs.getFloat("REQUEST_QTY")<0?"0":rs.getString("REQUEST_QTY"))).doubleValue()+"' size='6' style='text-align:right;font-family: Tahoma,Georgia;' "+ (TRANS_TYPE.equals("RETURN")||rs.getString("COMP_TYPE_NO").equals("C001")||rs.getString("COMP_TYPE_NO").equals("C002")||rs.getString("COMP_TYPE_NO").equals("C003")||rs.getString("COMP_TYPE_NO").equals("C004")||rs.getString("COMP_TYPE_NO").equals("C006")||rs.getString("COMP_TYPE_NO").equals("C008")||rs.getString("COMP_TYPE_NO").equals("C009")||rs.getString("COMP_TYPE_NO").equals("C010")||rs.getString("COMP_TYPE_NO").equals("C011")||rs.getString("CONCATENATED_SEGMENTS").equals("15-2A22000")?"":" readonly")+"><input type='hidden' name='ORIG_REQ_QTY_"+icnt+"' value='"+Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue()+"'></td>");
					if (rs.getString("COMP_TYPE_NO").equals("C008") && TRANS_TYPE.equals("ISSUE") && !ACODE.equals("VIEW"))
					{
						objEvent="onMouseDown='showFrontWIPList("+'"'+rs.getString("INVENTORY_ITEM_ID")+'"'+","+'"'+rs.getString("CONCATENATED_SEGMENTS")+'"'+","+'"'+rs.getString("ITEM_PRIMARY_UOM_CODE")+'"'+","+'"'+icnt+'"'+","+'"'+ORGANIZATION_ID+'"'+","+'"'+Double.valueOf(rs.getString("REQUIRED_QUANTITY")).doubleValue()+'"'+","+'"'+rs.getString("COMP_TYPE_NO")+'"'+")'";
						objeeEvent="onMouseDown='showWaferLotList("+'"'+rs.getString("INVENTORY_ITEM_ID")+'"'+","+'"'+rs.getString("CONCATENATED_SEGMENTS")+'"'+","+'"'+rs.getString("ITEM_PRIMARY_UOM_CODE")+'"'+","+'"'+icnt+'"'+","+'"'+ORGANIZATION_ID+'"'+","+'"'+rs.getString("COMP_TYPE_NO")+'"'+")'";
					}
					else if ((rs.getString("COMP_TYPE_NO").equals("C001") || rs.getString("COMP_TYPE_NO").equals("C002")) && TRANS_TYPE.equals("ISSUE") && !ACODE.equals("VIEW"))
					{
						objEvent="onMouseDown='showWaferLotList("+'"'+rs.getString("INVENTORY_ITEM_ID")+'"'+","+'"'+rs.getString("CONCATENATED_SEGMENTS")+'"'+","+'"'+rs.getString("ITEM_PRIMARY_UOM_CODE")+'"'+","+'"'+icnt+'"'+","+'"'+ORGANIZATION_ID+'"'+","+'"'+rs.getString("COMP_TYPE_NO")+'"'+")'";
						objeeEvent = " disabled";
					}
					else if (!ACODE.equals("VIEW"))
					{
						objEvent = " disabled";
						objeeEvent = " disabled";
					}
					else
					{
						objEvent = "";
						objeeEvent = "";
					}
					out.println("<td align='center'><textarea cols='30' rows='3' name='LOT_LIST_"+icnt+"' title='請按下滑鼠右鍵指定批號!'  onKeyDown='return (event.keyCode!=8);'" + objEvent+" readonly>"+(rs.getString("lot_list")==null?"":rs.getString("lot_list"))+"</textarea></td>");
					out.println("<td align='center'><textarea cols='30' rows='3' name='EE_LOT_LIST_"+icnt+"' title='請按下滑鼠右鍵指定工程批號!'  onKeyDown='return (event.keyCode!=8);'" + objeeEvent+" readonly>"+(rs.getString("ee_lot_list")==null?"":rs.getString("ee_lot_list"))+"</textarea></td>");
					out.println("<td align='center'><input type='text' name='REMARKS_"+icnt+"' value='"+(rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))+"' SIZE='10' style='font-family: Tahoma,Georgia;'></td>");
					out.println("</tr>");
				
				}
				rs.close();
				statement.close();
	
				if (icnt>0)
				{
	%>
				<tr  style='color:#ffffff' bgcolor='#B4AB72'><td colspan="10">&nbsp;</td></tr>
			</table>
		</td>
	</tr>
	<%
				}
				else
				{
					out.println("<tr><td>&nbsp;</td></tr><tr><td style='color:#ff0000;font-size:16px;' align='center'>查無工單資料,請重新確認!!</td></tr>");
				}
			}
			else
			{
				out.println("<tr><td>&nbsp;</td></tr><tr><td style='color:#ff0000;font-size:16px;' align='center'>"+err_msg+"</td></tr>");
			}
		}
	}
	%>
</table>
<%
	if (!ACODE.equals("VIEW"))			
	{
%>
<table width="100%" id="send1">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="Submit" onClick='setSubmit("../jsp/TSA01WIPComponentProcess.jsp?PROGRAM=K2-001")' style="font-family: Tahoma,Georgia;">
			&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="Cancel" onClick="setSubmit1('/oradds/ORADDSMainMenu.jsp')" style="font-family: Tahoma,Georgia;">
		</td>
	</tr>
</table>
<%
	}
	else
	{
%>
<table width="70%" align="center">
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td><font style="color:#8F996C">申請歷程:</font></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
				<tr bgcolor="#C1DBCF">
					<td align="center" width="5%">版次</td>
					<td align="center" width="5%">序號</td>
					<td align="center" width="20%">交易說明</td>
					<td align="center" width="16%">異動者</td>
					<td align="center" width="16%">異動日期</td>
					<td align="center" width="30%">備註</td>
				</tr>
			<%
				sql = " select a.REQUEST_NO"+
				      ",a.VERSION_ID"+
					  ",a.seq SEQ_NO"+
					  ",a.TRANS_NAME"+
					  ",a.CREATED_BY"+
					  ",to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE"+
					  ",a.REMARKS"+
					  ",b.type_desc"+
                      " from oraddman.tsa01_request_history a"+
					  ",(select type_name, type_value,type_desc  FROM oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') b"+
                      " where a.TRANS_NAME=b.type_name"+
					  " and a.REQUEST_NO=?"+
                      " order by a.REQUEST_NO,a.VERSION_ID desc,seq desc";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,REQUEST_NO);
				ResultSet rs=statement.executeQuery();
				int i =1;
				while (rs.next())
				{
					out.println("<tr>");
					out.println("<td align='center'>"+rs.getString("VERSION_ID")+"</td>");
					out.println("<td align='center'>"+rs.getString("SEQ_NO")+"</td>");
					out.println("<td>"+rs.getString("type_desc")+"</td>");
					out.println("<td align='center'>"+rs.getString("CREATED_BY")+"</td>");
					out.println("<td align='center'>"+rs.getString("CREATION_DATE")+"</td>");
					out.println("<td>"+(rs.getString("REMARKS")==null?"&nbsp;":rs.getString("REMARKS").replace("\n","<br>"))+"</td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();	  
			%>
			</table>
		</td>
	</tr>
</table>
<%
	}
}
catch(Exception e)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		document.MYFORM.WIP_NO_TEMP.value="";
	</script>
<%
	out.println("<div align='center'><font color='#ff0000'>系統發生錯誤(Error:"+e.getMessage()+"),請通知系統管理人員!!</font></div>");
}
%>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
