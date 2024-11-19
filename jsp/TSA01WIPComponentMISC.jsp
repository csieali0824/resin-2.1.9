<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,Array2DimensionInputBean"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>A01 MISC Detail</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setChangeObj(trans_value,obj_id)
{
	if (trans_value=="130")
	{
		document.MYFORMD.elements["TRANS_TYPE_SOURCE_ID_"+obj_id].value=document.MYFORMD.elements["trans_source_id_"+trans_value].value;
		document.MYFORMD.elements["EXPIRES_"+obj_id].disabled = false;
		document.MYFORMD.elements["EXPIRES_"+obj_id].value =document.MYFORMD.SYSDATE.value ;
		document.MYFORMD.elements["SUBINVEN_"+obj_id].disabled = false;
		document.MYFORMD.elements["SUBINVEN_"+obj_id].value = document.MYFORMD.elements["trans_subinventory_"+trans_value].value;
		document.MYFORMD.elements["WIP_"+obj_id].value = "--";
		document.MYFORMD.elements["WIP_"+obj_id].disabled = true;
		document.MYFORMD.elements["TXT_WIP_"+obj_id].value = "";
		document.MYFORMD.elements["TXT_WIP_"+obj_id].disabled = true;
		document.MYFORMD.elements["popcal_"+obj_id].style.width="20px";
		
	}
	else if (trans_value=="44")
	{
		document.MYFORMD.elements["TRANS_TYPE_SOURCE_ID_"+obj_id].value=document.MYFORMD.elements["trans_source_id_"+trans_value].value;
		document.MYFORMD.elements["SUBINVEN_"+obj_id].disabled = false;
		document.MYFORMD.elements["SUBINVEN_"+obj_id].value = document.MYFORMD.elements["trans_subinventory_"+trans_value].value;
		document.MYFORMD.elements["WIP_"+obj_id].disabled = false;
		document.MYFORMD.elements["WIP_"+obj_id].value = "--";
		document.MYFORMD.elements["TXT_WIP_"+obj_id].disabled = false;
		document.MYFORMD.elements["TXT_WIP_"+obj_id].value = "";
		document.MYFORMD.elements["EXPIRES_"+obj_id].disabled = false;
		document.MYFORMD.elements["EXPIRES_"+obj_id].value =document.MYFORMD.SYSDATE.value ;
		document.MYFORMD.elements["popcal_"+obj_id].style.width="20px";
	}
	else if (trans_value=="--")
	{
		document.MYFORMD.elements["TRANS_TYPE_SOURCE_ID_"+obj_id].value="";
		document.MYFORMD.elements["SUBINVEN_"+obj_id].value = "";
		document.MYFORMD.elements["SUBINVEN_"+obj_id].disabled = true;
		document.MYFORMD.elements["WIP_"+obj_id].value = "--";
		document.MYFORMD.elements["WIP_"+obj_id].disabled = true;
		document.MYFORMD.elements["TXT_WIP_"+obj_id].value = "";
		document.MYFORMD.elements["TXT_WIP_"+obj_id].disabled = true;
		document.MYFORMD.elements["EXPIRES_"+obj_id].value = "";
		document.MYFORMD.elements["EXPIRES_"+obj_id].disabled = true;
		document.MYFORMD.elements["popcal_"+obj_id].style.width="0px";
	}
}

function setWIPChange(trans_value,obj_id)
{
	var i_exist=false;
	document.MYFORMD.elements["WIP_"+obj_id].value="";
	document.MYFORMD.elements["TRANS_TYPE_SOURCE_ID_"+obj_id].value="";
	var wipselect=document.getElementById("WIP_"+obj_id);
	for (var i=0; i<wipselect.options.length; i++)
	{
		if (wipselect.options[i].text == trans_value)
		{
			document.MYFORMD.elements["WIP_"+obj_id].value=	wipselect.options[i].value;
			document.MYFORMD.elements["TRANS_TYPE_SOURCE_ID_"+obj_id].value=document.MYFORMD.elements["WIP_"+obj_id].value;
	  		i_exist = true;
	  		break
	 	}	
	}
	if (!i_exist)
	{
		alert("查無工單號,請重新確認!");
		document.MYFORMD.elements["TXT_WIP_"+obj_id].value="";
		return false;	
	}
}

function setSubmit(URL)
{
	var v_date = "",rec_year="",rec_month="",rec_day="";v_qty=0;
	var obj_id= "";
	for (var i =1 ; i <= document.MYFORMD.LINE_CNT.value ; i++)
	{
		obj_id=document.MYFORMD.elements["WID_"+i].value;
		trans_value=document.MYFORMD.elements["TRANS_TYPE_"+obj_id].value;
		v_qty = eval(v_qty)+eval(document.MYFORMD.elements["QTY_"+obj_id].value);
		if (document.MYFORMD.elements["TRANS_TYPE_"+obj_id].value!="--")
		{
			if (document.MYFORMD.elements["SUBINVEN_"+obj_id].value =="" || document.MYFORMD.elements["SUBINVEN_"+obj_id].value == null)
			{
				document.MYFORMD.elements["SUBINVEN_"+obj_id].focus();
				alert("請指定入庫倉!");
				return false;
			}
			
			if (document.MYFORMD.elements["WIP_"+obj_id].disabled==false)
			{
				if (document.MYFORMD.elements["WIP_"+obj_id].value=="--")
				{
					document.MYFORMD.elements["WIP_"+obj_id].focus();
					alert("請指定工單!");
					return false;
				}
			}
			if (document.MYFORMD.elements["EXPIRES_"+obj_id].disabled==false)
			{
				v_date =document.MYFORMD.elements["EXPIRES_"+obj_id].value;
				if (v_date=="" || v_date==null)
				{
					document.MYFORMD.elements["EXPIRES_"+obj_id].focus();
					alert("請指定有效期!");
					return false;
				}
				else if (v_date.length!=8)
				{
					alert("有效期格式錯誤(正確格式為YYYYMMDD)!!");
					document.MYFORMD.elements["EXPIRES_"+obj_id].focus();
					return false;			
				}
				else
				{
					rec_year = v_date.substr(0,4);
					rec_month= v_date.substr(4,2);
					rec_day  = v_date.substr(6,2);
					if (rec_month <1 || rec_month >12)
					{
						alert("有效月份有誤!!");
						document.MYFORMD.elements["EXPIRES_"+obj_id].focus();
						return false;			
					}	
					else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
					{
						alert("有效期有誤!!");
						document.MYFORMD.elements["EXPIRES_"+obj_id].focus();
						return false;			
					} 
					else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
					{
						alert("有效期有誤!!");
						document.MYFORMD.elements["EXPIRES_"+obj_id].focus();
						return false;			
					} 
					else if (rec_month == 2)
					{
						if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
						{
							alert("有效期有誤!!");
							document.MYFORMD.elements["EXPIRES_"+obj_id].focus();
							return false;	
						}		
					}
				}				
			}
		}
	}
	if (eval(v_qty) > eval(document.MYFORMD.NUMQ.value)) 
	{
		alert("總入庫量不可超過庫存不足量!!");
		return false;				
	}
	document.MYFORMD.save1.disabled= true;
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}

// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
} 

function setClose()
{
	this.window.close();
}

</script>
<%
String sql = "";
String REQUEST_NO = request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String LINE_NO = request.getParameter("LINE_NO");
if (LINE_NO==null) LINE_NO="";
String TOT_QTY = request.getParameter("TOT_QTY");
if (TOT_QTY==null) TOT_QTY="0";
String NUMQ = request.getParameter("NUMQ");
if (NUMQ==null) NUMQ="";
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="";
int LINE_CNT=Integer.parseInt((request.getParameter("LINE_CNT")==null?"0":request.getParameter("LINE_CNT")));

%>
<body>  
<FORM ACTION="../jsp/TSA01WIPComponentMISC.jsp" METHOD="post" NAME="MYFORMD">
<%
try
{
	if (ACODE.equals("SAVE"))
	{
		String wid="";
		try
		{
			for (int i=1 ; i <= LINE_CNT ; i++)
			{
				wid=request.getParameter("WID_"+i);
				if (request.getParameter("TRANS_TYPE_"+wid) != null && !request.getParameter("TRANS_TYPE_"+wid).equals("--"))
				{
					sql = " update oraddman.tsa01_request_wafer_lot_all a "+
						  " set TRANSACTIONS_TYPE_ID=?"+
						  ",TRANSACTION_SOURCE_ID=?"+
						  ",TRANS_WIP_NO=(select wip_entity_name from WIP_ENTITIES x where x.organization_id=a.organization_id and x.wip_entity_id=?)"+
						  ",EXPIRES_ON=to_date(?,'yyyymmdd')"+
						  ",TRANS_WIP_ID=?"+
						  ",SUBINVENTORY_CODE=?"+
						  ",MISCELLANEOUS_FLAG=?"+
						  ",TRANS_WIP_OP_SEQ_NUM=(select  wo.operation_seq_num FROM wip_entities we, wip_operations wo WHERE  we.wip_entity_id=? AND we.wip_entity_id = wo.wip_entity_id)"+
						  " where WAFER_LINE_ID=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,request.getParameter("TRANS_TYPE_"+wid));
					pstmtDt.setString(2,request.getParameter("TRANS_TYPE_SOURCE_ID_"+wid));
					pstmtDt.setString(3,request.getParameter("WIP_"+wid));
					pstmtDt.setString(4,request.getParameter("EXPIRES_"+wid));
					pstmtDt.setString(5,request.getParameter("WIP_"+wid));
					pstmtDt.setString(6,request.getParameter("SUBINVEN_"+wid));
					pstmtDt.setString(7,"Y");
					pstmtDt.setString(8,request.getParameter("WIP_"+wid));
					pstmtDt.setString(9,wid);
					pstmtDt.executeQuery();
					pstmtDt.close();					  
				}
				else
				{
					sql = " update oraddman.tsa01_request_wafer_lot_all a "+
						  " set TRANSACTIONS_TYPE_ID=null"+
						  ",TRANSACTION_SOURCE_ID=null"+
						  ",TRANS_WIP_NO=null"+
						  ",EXPIRES_ON=null"+
						  ",TRANS_WIP_ID=null"+
						  ",SUBINVENTORY_CODE=null"+
						  ",TRANS_WIP_OP_SEQ_NUM=null"+
						  ",MISCELLANEOUS_FLAG=?"+
						  " where WAFER_LINE_ID=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,"N");
					pstmtDt.setString(2,wid);
					pstmtDt.executeQuery();
					pstmtDt.close();				
				}
			}
			con.commit();
			%>
			<script language="JavaScript" type="text/JavaScript">
				alert("更新成功!");
			</script>			
			<%
		}
		catch(Exception e)
		{
			out.println(e.getMessage());
			con.rollback();
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("交易失敗,請洽系統管理人員!");
			</script>			
		<%
		}	
		finally
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				this.window.close();
			</script>	
		<%
		}
	}
	else
	{
		sql = " SELECT TT.TRANSACTION_TYPE_ID,TT.TYPE_DESC"+
			  ",TT.TRANSACTION_SOURCE_ID, TT.SUBINVENTORY_CODE"+
			  " FROM (SELECT X.TYPE_NAME,X.TYPE_GROUP,X.TYPE_DESC,X.TYPE_VALUE TRANSACTION_TYPE_ID,Y.TYPE_VALUE TRANSACTION_SOURCE_ID,X.TYPE_ATTRIBUTE1 SUBINVENTORY_CODE"+
			  " FROM (SELECT  type_name, type_value, type_group,"+
			  "       type_desc,TYPE_ATTRIBUTE1"+
			  "       FROM oraddman.tsa01_base_setup a"+
			  "       WHERE TYPE_CODE IN ('TRANS_TYPE')) x"+
			  "      ,(SELECT type_name, type_value, type_group,"+
			  "      type_desc  FROM oraddman.tsa01_base_setup a  "+
			  "      WHERE TYPE_CODE IN  ('TRANS_SOURCE_ID')) Y"+
			  " WHERE X.TYPE_VALUE=Y.TYPE_NAME(+)"+
			  " AND X.TYPE_GROUP=Y.TYPE_GROUP(+)) TT"+
			  " WHERE EXISTS (SELECT 1 FROM oraddman.tsa01_request_headers_all A,oraddman.tsa01_request_lines_all B"+
			  " WHERE A.REQUEST_NO=B.REQUEST_NO"+
			  " AND SUBSTR(A.WIP_ENTITY_NAME,1,1)=TT.TYPE_NAME"+
			  " AND B.COMP_TYPE_NO=TYPE_GROUP"+
			  " AND B.REQUEST_NO='"+REQUEST_NO+"' AND B.LINE_NO='"+LINE_NO+"')";
		Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rsh = statementh.executeQuery(sql);
		if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
		while (rsh.next())
		{	
			%><input type="hidden" name="trans_source_id_<%=rsh.getString("TRANSACTION_TYPE_ID")%>" value="<%=rsh.getString("TRANSACTION_SOURCE_ID")%>"><%	
			%><input type="hidden" name="trans_subinventory_<%=rsh.getString("TRANSACTION_TYPE_ID")%>" value="<%=rsh.getString("SUBINVENTORY_CODE")%>"><%	
		}
		
		sql = " SELECT DISTINCT B.WIP_ENTITY_ID,B.WIP_ENTITY_NAME"+
			  " FROM WIP_DISCRETE_JOBS A,WIP_ENTITIES B,ORADDMAN.TSA01_REQUEST_LINES_ALL C"+
			  " WHERE A.WIP_ENTITY_ID=B.WIP_ENTITY_ID"+
			  " AND A.ORGANIZATION_ID=B.ORGANIZATION_ID"+
			  " AND B.ORGANIZATION_ID=C.ORGANIZATION_ID"+
			  " AND B.PRIMARY_ITEM_ID=C.COMPONENT_ITEM_ID"+
			  " AND A.STATUS_TYPE=3"+
			  " AND C.REQUEST_NO='"+REQUEST_NO+"'"+
			  " AND C.LINE_NO='"+LINE_NO+"'"+
			  " ORDER BY B.WIP_ENTITY_NAME";
		Statement statementwip=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rswip = statementwip.executeQuery(sql);
				  
		sql = " select a.request_no, a.line_no, a.organization_id, a.inventory_item_id,"+
			  " a.item_name, a.wip_no, a.lot, a.lot_qty, a.uom, a.remarks,a.miscellaneous_flag, nvl(a.transactions_type_id,0) transactions_type_id,"+
			  " a.transaction_source_id, a.trans_wip_no, a.wafer_line_id,a.subinventory_code,nvl(a.trans_wip_id,0) trans_wip_id, "+
              " c.comp_type_no,CASE WHEN c.COMP_TYPE_NO='C008' AND length(a.lot)=14 AND  a.expires_on IS NULL THEN TO_CHAR(ADD_MONTHS(to_date(substr(a.lot,5,6),'YYMMDD'),12)-CASE WHEN  substr(a.lot,7,4)='0229' THEN 0 ELSE 1 END,'YYYYMMDD') ELSE TO_CHAR(a.expires_on,'YYYYMMDD')  END AS expires_on"+
			  " from oraddman.tsa01_request_wafer_lot_all a,oraddman.tsa01_request_headers_all b,oraddman.tsa01_request_lines_all c"+
			  " where a.request_no=b.request_no"+
			  " and a.request_no=c.request_no"+
              " and a.line_no=c.line_no"+
			  " and a.request_no=?"+
			  " and a.line_no=?";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,REQUEST_NO);
		statement.setString(2,LINE_NO);
		ResultSet rs=statement.executeQuery();
		LINE_CNT =0;
		while (rs.next())
		{
			LINE_CNT ++;
			if (LINE_CNT==1)
			{
		%>
				<TABLE border="0" width="100%">
					<tr>
						<td width="12%" style="font-size:12px" align="right">料號：</td>
						<td><%=rs.getString("ITEM_NAME")%></td>
					</tr>
				</TABLE>
				<hr>
				<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
					<tr style="background-color:#006666;color:#FFFFFF;">
						<td width="20%" align="center">Lot Number</td>
						<td width="15%" align="center">數量(<%=rs.getString("UOM")%>)</td>
						<td width="15%" align="center">交易類型</td>
						<td width="15%" align="center">入庫倉</td>
						<td width="15%" align="center">工單號碼</td>
						<td width="15%" align="center">有效日期</td>
					</tr>
		<%
		
			}
		%>
			<tr>
				<td align="center"><input type="TEXT" NAME="LOT_<%=rs.getString("wafer_line_id")%>" value="<%=rs.getString("lot")%>" size="15"  style="font-family: Tahoma,Georgia;" readonly><input type="hidden" name="WID_<%=LINE_CNT%>" value="<%=rs.getString("wafer_line_id")%>"></td>
				<td align="center"><input type="TEXT" NAME="QTY_<%=rs.getString("wafer_line_id")%>" value="<%=rs.getString("LOT_QTY")%>" size="10"  style="text-align:right;font-family: Tahoma,Georgia;"></td>
				<td align="center">
					<select name="TRANS_TYPE_<%=rs.getString("wafer_line_id")%>" style="font-size:12px;font-family:Tahoma,Georgia" onChange="setChangeObj(this.value,<%=rs.getString("wafer_line_id")%>)">
					<option value="--">--
				<%
					if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
					while (rsh.next())
					{				
				%>
					<option value="<%=rsh.getString("TRANSACTION_TYPE_ID")%>" <%if (rs.getString("transactions_type_id").equals(rsh.getString("TRANSACTION_TYPE_ID"))) out.println("selected");%>><%=rsh.getString("TYPE_DESC")%>
				<%
					}
				%>
					</select>	
					<input type="hidden" name="TRANS_TYPE_SOURCE_ID_<%=rs.getString("wafer_line_id")%>" value="<%=(rs.getString("transaction_source_id")==null?"":rs.getString("transaction_source_id"))%>">
				</td>
				<td align="center"><input type="TEXT" name="SUBINVEN_<%=rs.getString("wafer_line_id")%>" VALUE="<%=(rs.getString("subinventory_code")==null?"":rs.getString("subinventory_code"))%>" size="10" style="font-family: Tahoma,Georgia;" <%=(rs.getString("transactions_type_id").equals("0")?"disabled":"")%>></td>
				<td align="center">
					<input type="TEXT" name="TXT_WIP_<%=rs.getString("wafer_line_id")%>" VALUE="<%=(rs.getString("TRANS_WIP_NO")==null?"":rs.getString("TRANS_WIP_NO"))%>" size="14" style="font-family: Tahoma,Georgia;" <%=(rs.getString("transactions_type_id").equals("0")?"disabled":"")%>  onChange="setWIPChange(this.value,<%=rs.getString("wafer_line_id")%>)" >
					<select name="WIP_<%=rs.getString("wafer_line_id")%>" style="width:0;font-size:12px;font-family:Tahoma,Georgia;visibility:hidden"  onChange="setWIPChange(this.value,<%=rs.getString("wafer_line_id")%>)" <%=(rs.getString("transactions_type_id").equals("0")||rs.getString("TRANS_WIP_ID").equals("0")?"disabled":"")%>>
					<option value="--">--
				<%
					if (rswip.isBeforeFirst() ==false) rswip.beforeFirst();
					while (rswip.next())
					{				
				%>
					<option value="<%=rswip.getString("WIP_ENTITY_ID")%>" <%if (rs.getString("TRANS_WIP_ID").equals(rswip.getString("WIP_ENTITY_ID"))) out.println("selected");%>><%=rswip.getString("WIP_ENTITY_NAME")%>
				<%
					}
				%>
					</select>			
				</td>
				<td align="center"><input type="TEXT" NAME="EXPIRES_<%=rs.getString("wafer_line_id")%>" VALUE="<%=(rs.getString("expires_on")==null?"":rs.getString("expires_on"))%>" size="10" style="font-family: Tahoma,Georgia;" <%=(rs.getString("transactions_type_id").equals("0")||rs.getString("expires_on")==null?"disabled":"")%>><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.EXPIRES_<%=rs.getString("wafer_line_id")%>);return false;'><img name="popcal_<%=rs.getString("wafer_line_id")%>" border="0" src="../image/calbtn.gif" <%=(rs.getString("transactions_type_id").equals("0")||rs.getString("expires_on")==null?" width='0'":" width='20'")%>></A></td>
			</tr>
		<%
		}
		rs.close();
		rsh.close();
		rswip.close();
		statement.close();
		statementh.close();
		statementwip.close();
		if (LINE_CNT>0)
		{
		%>
			</table>
			<hr>
			<table width="100%">
				<tr>
					<td align="center">
						<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TSA01WIPComponentMISC.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">
						&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick='setClose()' style="font-family: Tahoma,Georgia;">
					</td>
				</tr>
			</table>
		<%
		}
		else
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("查無資料,請重新確認,謝謝!");
				this.window.close();
			</script>
		<%
		}
	}
}
catch(Exception e)
{
	out.println("系統功能異常,請洽系統管理人員,謝謝!"+e.getMessage());
}
%>
<input type="hidden" name="REQUEST_NO" value="<%=REQUEST_NO%>">
<input type="hidden" name="TOT_QTY" value="<%=TOT_QTY%>">
<input type="hidden" name="LINE_NO" value="<%=LINE_NO%>">
<input type="hidden" name="SYSDATE" value="<%=dateBean.getYearMonthDay()%>">
<input type="hidden" name="LINE_CNT" value="<%=LINE_CNT%>">
<input type="hidden" name="NUMQ" value="<%=NUMQ%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

