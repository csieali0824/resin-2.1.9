<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean,SalesDRQPageHeaderBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="StockBean" scope="session" class="Array2DimensionInputBean"/>
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
<title>轉倉及料號移轉申請</title>
<script language="JavaScript" type="text/JavaScript">
function rdochk(URL,objValue)
{
	document.MYFORM.action=URL+"&?ACTIONCODE=NEW";
	document.MYFORM.submit();
}
function setSubmit(URL)
{   
	var chvalue="",rdovalue="";
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0,insert_cnt=0;	
	var lineid="";	
	if (document.MYFORM.rdoitem.length== undefined)
	{
		rdovalue = document.MYFORM.rdoitem.value;
	}
	else
	{	
		for (var i =0 ; i <document.MYFORM.rdoitem.length ;i++)
		{
			if (document.MYFORM.rdoitem[i].checked)
			{
				 rdovalue = document.MYFORM.rdoitem[i].value;
				 break;
			}
		}
	}
	if (rdovalue == "")
	{
		alert("請選擇申請項目!");
		return false;
	}
	if (document.MYFORM.chk1.length != undefined)
	{
		iLen = document.MYFORM.chk1.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk1.checked;
			lineid = document.MYFORM.chk1.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk1[i-1].checked;
			lineid = document.MYFORM.chk1[i-1].value;
		}
		if (chkvalue==true)
		{
			if (rdovalue=="SUBTRANS")
			{
				if (document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value !=""
				    || document.MYFORM.elements["ORIG_ITEM_DESC_"+lineid].value !=""
					|| document.MYFORM.elements["ORIG_LOT_"+lineid].value !=""
					|| document.MYFORM.elements["ORIG_DC_"+lineid].value !=""
					|| document.MYFORM.elements["ORIG_ORG_"+lineid].value !="" 
					|| document.MYFORM.elements["ORIG_SUBINV_"+lineid].value !=""
					|| document.MYFORM.elements["NEW_ORG_"+lineid].value !="" 
					|| document.MYFORM.elements["NEW_SUBINV_"+lineid].value !="" 
					|| document.MYFORM.elements["QTY_"+lineid].value !=""
					|| document.MYFORM.elements["UOM_"+lineid].value !="" 
					|| document.MYFORM.elements["REQ_REASON_"+lineid].value !=""
					|| document.MYFORM.elements["AMT_"+lineid].value !=""
					|| document.MYFORM.elements["UNITPRICE_"+lineid].value !=""
					)
				{
					if (document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value=="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_ITEM_DESC_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_ITEM_DESC_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_LOT_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_LOT_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value.length>=22 && document.MYFORM.elements["ORIG_DC_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_DC_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_ORG_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_ORG_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_SUBINV_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_SUBINV_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["NEW_ORG_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_ORG_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["NEW_SUBINV_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_SUBINV_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["QTY_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["QTY_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["UOM_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["UOM_"+lineid].focus();
						return false;						
					}																																								
					else if (document.MYFORM.elements["REQ_REASON_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["REQ_REASON_"+lineid].focus();
						return false;						
					}	
					else if (chkSubinv(document.MYFORM.elements["ORIG_ORG_"+lineid].value,document.MYFORM.elements["ORIG_SUBINV_"+lineid].value)==false)
					{
						alert("項次"+lineid+":移出倉別不在允許名單中!");
						document.MYFORM.elements["ORIG_SUBINV_"+lineid].focus();
						return false;							
					}		
					else if (chkSubinv(document.MYFORM.elements["NEW_ORG_"+lineid].value,document.MYFORM.elements["NEW_SUBINV_"+lineid].value)==false)
					{
						alert("項次"+lineid+":移入倉別不在允許名單中!");
						document.MYFORM.elements["NEW_SUBINV_"+lineid].focus();
						return false;							
					}																																															
					//else if (document.MYFORM.elements["UNITPRICE_"+lineid].value =="")
					//{
					//	alert("項次"+lineid+":請輸入值!");
					//	document.MYFORM.elements["UNITPRICE_"+lineid].focus();
					//	return false;						
					//}																																								
					//else if (document.MYFORM.elements["AMT_"+lineid].value =="")
					//{
					//	alert("項次"+lineid+":請輸入值!");
					//	document.MYFORM.elements["AMT_"+lineid].focus();
					//	return false;						
					//}
					else
					{
						insert_cnt++;
					}																																								
				}
			}
			else if (rdovalue=="MISC" )
			{
				if (document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value !=""
				    || document.MYFORM.elements["ORIG_ITEM_DESC_"+lineid].value !=""
					|| document.MYFORM.elements["ORIG_LOT_"+lineid].value !=""
					|| document.MYFORM.elements["ORIG_DC_"+lineid].value !=""
					|| document.MYFORM.elements["ORIG_ORG_"+lineid].value !="" 
					|| document.MYFORM.elements["ORIG_SUBINV_"+lineid].value !=""
					|| document.MYFORM.elements["NEW_ITEM_NAME_"+lineid].value !="" 
					|| document.MYFORM.elements["NEW_ITEM_DESC_"+lineid].value !="" 
					|| document.MYFORM.elements["QTY_"+lineid].value !=""
					|| document.MYFORM.elements["UOM_"+lineid].value !=""
					|| document.MYFORM.elements["REQ_REASON_"+lineid].value !=""
					)
				{
					if (document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value=="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_ITEM_DESC_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_ITEM_DESC_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_LOT_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_LOT_"+lineid].focus();
						return false;						
					}
					else if ( document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value.length >=22 && document.MYFORM.elements["ORIG_DC_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_DC_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["QTY_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["QTY_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["UOM_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["UOM_"+lineid].focus();
						return false;						
					}					
					else if (document.MYFORM.elements["ORIG_ORG_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_ORG_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_SUBINV_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["ORIG_SUBINV_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["NEW_ITEM_NAME_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_ITEM_NAME_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["NEW_ITEM_DESC_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_ITEM_DESC_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["NEW_LOT_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_LOT_"+lineid].focus();
						return false;						
					}
					else if ( document.MYFORM.elements["NEW_ITEM_NAME_"+lineid].value.length >=22 && document.MYFORM.elements["NEW_DC_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_DC_"+lineid].focus();
						return false;						
					}
					
					else if (document.MYFORM.elements["NEW_QTY_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_QTY_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["NEW_UOM_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["NEW_UOM_"+lineid].focus();
						return false;						
					}					
					else if (document.MYFORM.elements["REQ_REASON_"+lineid].value =="")
					{
						alert("項次"+lineid+":請輸入值!");
						document.MYFORM.elements["REQ_REASON_"+lineid].focus();
						return false;						
					}																																								
					else if (chkSubinv(document.MYFORM.elements["ORIG_ORG_"+lineid].value,document.MYFORM.elements["ORIG_SUBINV_"+lineid].value)==false)
					{
						alert("項次"+lineid+":倉別不在允許名單中!");
						document.MYFORM.elements["ORIG_SUBINV_"+lineid].focus();
						return false;							
					}
					else if (document.MYFORM.elements["UOM_"+lineid].value==document.MYFORM.elements["NEW_UOM_"+lineid].value && document.MYFORM.elements["NEW_QTY_"+lineid].value !=document.MYFORM.elements["QTY_"+lineid].value)
					{
						alert("項次"+lineid+":轉出入單位相同時,數量必須一致!");
						document.MYFORM.elements["NEW_QTY_"+lineid].focus();
						return false;						
					}
					else if (document.MYFORM.elements["ORIG_ITEM_NAME_"+lineid].value==document.MYFORM.elements["NEW_ITEM_NAME_"+lineid].value 
					         && document.MYFORM.elements["ORIG_LOT_"+lineid].value==document.MYFORM.elements["NEW_LOT_"+lineid].value 
							 && document.MYFORM.elements["QTY_"+lineid].value==document.MYFORM.elements["NEW_QTY_"+lineid].value
							 && document.MYFORM.elements["UOM_"+lineid].value==document.MYFORM.elements["NEW_UOM_"+lineid].value)
					{
						alert("項次"+lineid+":轉出入資料一致,請重新確認!");
						document.MYFORM.elements["NEW_ITEM_NAME_"+lineid].focus();
						return false;						
					}
					else
					{
						insert_cnt++;
					}				
				}
							
			}
			else
			{
				insert_cnt=0;
			}
		}
	}
	if (insert_cnt==0)
	{
		alert("請先輸入資料!");
		return false;	
	}
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnClear.disabled=true;
	document.MYFORM.btnExit.disabled=true;
	document.MYFORM.btnUpload.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit1()
{   
	if (confirm("您確定清除畫面嗎?")==true) 
	{
		document.MYFORM.submit();
	}
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到首頁嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit3(URL)
{   
	var chvalue="";
	if (document.MYFORM.rdoitem.length== undefined)
	{
		chvalue = document.MYFORM.rdoitem.value;
	}
	else
	{
		for (var i =0 ; i <document.MYFORM.rdoitem.length ;i++)
		{
			if (document.MYFORM.rdoitem[i].checked)
			{
				 chvalue = document.MYFORM.rdoitem[i].value;
				 break;
			}
		}
	}
	if (chvalue == "")
	{
		alert("請選擇申請項目!");
		return false;
	}
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL+"?rdoitem="+chvalue,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
	
}
function chkSubinv(org,subinv)
{
	var SUBINV_LIST=document.getElementById("SUBINV_LIST");
	var i_exist = false;
	for (var i=0; i<SUBINV_LIST.options.length; i++)
	{
		if (SUBINV_LIST.options[i].value == org)
		{
			if (SUBINV_LIST.options[i].text.indexOf(","+subinv+",")>=0)
			{ 
				i_exist = true;
				break;
			}
	 	}	
	}
	return i_exist;
}
function setAttache(URL)
{
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL,"subwin","width=740,height=250,scrollbars=yes,menubar=no,location=no");
}
function delAttache(URL)
{
	if (confirm("您確定要刪除檔案嗎?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	return false;
}
</script>
</head>
<body>
<%
String rdoitem=request.getParameter("rdoitem");
if (rdoitem==null) rdoitem="";
String HID=request.getParameter("HID");
if (HID==null)
{
	Statement statement1=con.createStatement();
	ResultSet rs1=statement1.executeQuery(" SELECT APPS.TSC_STOCK_TRANS_REQ_ID_S.nextval from dual");
	if (rs1.next())
	{
		HID = rs1.getString(1);
	}
	else
	{
		rs1.close();
		statement1.close();		
		out.println("HEADER ID取得失敗!!");
	}
	rs1.close();
	statement1.close();	
}
//String [] strUom ={"--","KPC","PCE"};
int iYear = dateBean.getYear();
int iMonth = dateBean.getMonth();
int iDay = dateBean.getDay();
int iseq=0,def_row=12,icnt=0;
String strWorkflowCode=request.getParameter("WORKFLOWCODE");
if (strWorkflowCode==null) strWorkflowCode="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";
String ACTIONCODE=request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String SCODE="NEWREQ";
String FILENAME = request.getParameter("FILENAME");
if (FILENAME==null) FILENAME ="";
String sql="";

String opt_subinv="SUBTRANS",opt_misc="MISC";

try
{

%>
<form name="MYFORM"  METHOD="post" ACTION="TSCStockTransRequest.jsp?WKCODE=<%=WKCODE%>">
	<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td bgcolor="#E9E8E7">申請項目:
			<%
				icnt=0;
				strWorkflowCode="";
				sql = " select a.trans_type, a.trans_name, a.trans_desc ,b.wkflow_level,b.wkflow_next_level,count(1) over (partition by c.user_name) item_cnt"+
                      " from oraddman.tsc_stock_trans_type a"+
					  ",oraddman.tsc_stock_trans_wkflow b"+
					  ",oraddman.tsc_stock_trans_member c"+
                      " where a.active_flag=?"+
                      " and a.trans_type=b.trans_type"+
                      " and b.wkflow_level_rank=?"+
                      " and c.user_name=?"+
                      " and a.trans_type=c.trans_type"+
                      " and c.WKFLOW_LEVEL=b.WKFLOW_LEVEL"+
                      " and c.trans_type=b.trans_type"+
                      " and c.ACTIVE_FLAG=?"+
                      " and b.ACTIVE_FLAG=?"+
					  " and substr(c.WKFLOW_LEVEL,1,length(?))=?"+
                      " order by a.trans_type";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,"A");
				statement.setString(2,"0");
				statement.setString(3,UserName);
				statement.setString(4,"A");
				statement.setString(5,"A");
				if (UserRoles.indexOf("admin")>=0)
				{
					statement.setString(6,"M");
					statement.setString(7,"M");
				}
				else
				{
					statement.setString(6,WKCODE);
					statement.setString(7,WKCODE);
				}
				ResultSet rs=statement.executeQuery();	
				while (rs.next())
				{
					icnt++;	
					if (icnt==1) strWorkflowCode = rs.getString("WKFLOW_LEVEL");		
					if (rs.getInt("item_cnt")==1) rdoitem=rs.getString("trans_name");			
			%>
				<input type="radio" name="rdoitem" value="<%=rs.getString("trans_name")%>" onClick="rdochk('../jsp/TSCStockTransRequest.jsp?WKCODE=<%=WKCODE%>',this.value)" <%=(rdoitem.equals(rs.getString("trans_name"))?"checked":"")%>><font  style="font-family: Tahoma,Georgia"><%=rs.getString("trans_desc")%></font>&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				}
				rs.close();
				statement.close();
				
				sql = " SELECT A.ORGANIZATION_ID,A.ORGANIZATION_CODE,LISTAGG(B.SECONDARY_INVENTORY_NAME,',') WITHIN GROUP (ORDER BY B.SECONDARY_INVENTORY_NAME) SUBINV_CODE_LIST"+
							 " FROM INV.MTL_PARAMETERS A,INV.MTL_SECONDARY_INVENTORIES B"+
							 " WHERE A.ORGANIZATION_ID=B.ORGANIZATION_ID"+
							 " AND (B.DISABLE_DATE IS NULL OR trunc(B.DISABLE_DATE)>TRUNC(SYSDATE))"+
							 " AND EXISTS (SELECT 1 FROM ORADDMAN.TSC_STOCK_TRANS_SUBINV C,ORADDMAN.TSC_STOCK_TRANS_TYPE D "+
							 "             WHERE A.ORGANIZATION_CODE=C.ORGANIZATION_CODE"+
							 "             AND B.SECONDARY_INVENTORY_NAME=C.SUBINVENTORY_CODE"+
							 "             AND C.TRANS_TYPE=D.TRANS_TYPE"+
							 "             AND D.TRANS_NAME='"+rdoitem+"'"+
							 "             AND NVL(C.ACTIVE_FLAG,'N')='A')"+
							 " GROUP BY A.ORGANIZATION_ID,A.ORGANIZATION_CODE ORDER BY A.ORGANIZATION_CODE ";				 
				//if (rdoitem.equals(opt_subinv))
				//{			 
				//	sql += " AND ((A.ORGANIZATION_ID IN (49) AND B.SECONDARY_INVENTORY_NAME IN ('63','68','40','73'))"+
				//			 " OR (A.ORGANIZATION_ID IN (566) AND B.SECONDARY_INVENTORY_NAME IN ('40'))"+
				//			 " OR (A.ORGANIZATION_ID IN (746) AND B.SECONDARY_INVENTORY_NAME IN ('67')))";
				//}
				//else if (rdoitem.equals(opt_misc))
				//{
				//	sql += " AND A.ORGANIZATION_ID IN (49,606)";
				//}
				//sql +=" GROUP BY A.ORGANIZATION_ID,A.ORGANIZATION_CODE ORDER BY A.ORGANIZATION_CODE ";
				Statement statementOrg=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				//out.println(sql);
				ResultSet rsOrg = statementOrg.executeQuery(sql);				
			%>
			<select id="SUBINV_LIST" style="visibility:hidden;font-size:7px;font-family:Tahoma,Georgia;">
			<%
				if (rsOrg.isBeforeFirst() ==false) rsOrg.beforeFirst();
				while (rsOrg.next())
				{						
			%>
					<OPTION VALUE="<%=rsOrg.getString("ORGANIZATION_ID")%>"><%=","+rsOrg.getString("SUBINV_CODE_LIST")+","%></OPTION>
			<%
				}	
			%>
			</select>				
			</td>
			<td width="30%" align="right" bgcolor="#E9E8E7">
				<A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
			</td>
		</tr>
		<%
		if (icnt==0)
		{
		%>
			<tr><td colspan="2" style="color:#FF0000"> 您尚未設定申請權限,請向資訊單位提出申請後再作業,謝謝!!</td></tr>
		<%
		}
		else
		{
			if (rdoitem.equals(opt_subinv))
			{
			%>
			<tr><td colspan="2"><%@ include file="/jsp/TSCStockSubinvTransPage.jsp"%></td></tr>
			<%
			}
			else if (rdoitem.equals(opt_misc))
			{
			%>
			<tr><td colspan="2"><%@ include file="/jsp/TSCStockMISCTransPage.jsp"%></td></tr>
			<%
			}
			if (!rdoitem.equals(""))
			{
			%>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
			<td valign="middle" width="30%"><input type="button" name="upload"  size="20" value="上傳附件" onClick='setAttache("../jsp/subwindow/TSCStockTransAttachments.jsp?HID=<%=HID%>")'></td>
			<td align="LEFT">
			<%
			//取得附件
			if (!HID.equals(""))
			{
				String rootName = "/jsp/ILAN_Attache/"+HID;
				if (ACTIONCODE.equals("DELATTACHE") && !FILENAME.equals(""))
				{
					String delPath = application.getRealPath(rootName+"/"+FILENAME);
					File file = new File(delPath);   
					if (file.exists()) 
					{  
						boolean deleted = file.delete();  
					}
				}
				
				String rootPath = application.getRealPath(rootName);
				File fp = new File(rootPath);
				if (fp.exists()) 
				{
					String[] list = fp.list();
					if (list.length > 0)
					{
						for(int i=0; i<list.length;i++)
						{
							File inFp = new File(rootPath + File.separator + list[i]);
							out.println("&nbsp;<img src='images/pdf.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+list[i]+"' target='_blank'>"+list[i]+"</a> ("+new Long(inFp.length()) +" bytes) "+new Timestamp(new Long(inFp.lastModified()).longValue())+"</font>&nbsp;&nbsp;&nbsp;<img style='vertical-align:text-bottom' src='images/deleteicon_disabled.gif' border='0' onClick='delAttache("+'"'+"../jsp/TSCStockTransRequest.jsp?ACTIONCODE=DELATTACHE&FILENAME="+ list[i]+'"'+")'><br>");
						}
					}
					else
					{
						out.println("&nbsp;<br>&nbsp;");
					}
				}
			}
			else
			{
				out.println("&nbsp;<br>&nbsp;");
			}
			%>
			</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td align="center" colspan="2"><input type="button" name="btnSubmit" value="Submit" style="font-family:Tahoma,Georgia" onClick="setSubmit('../jsp/TSCStockTransProcess.jsp')">
				&nbsp;&nbsp;
				<input type="button" name="btnClear" value="Clear" style="font-family:Tahoma,Georgia" onClick="setSubmit1()">
				&nbsp;&nbsp;
				<input type="button" name="btnExit" value="Exit" style="font-family:Tahoma,Georgia"  onClick="setSubmit2('../ORADDSMainMenu.jsp')">
				&nbsp;&nbsp;
				<input type="button" name="btnUpload" value="Upload" style="font-family:Tahoma,Georgia"  onClick="setSubmit3('../jsp/TSCStockTransRequestUpload.jsp')">
				</td>
			</tr>
			<%
			}
			else
			{
			%>
			<tr><td style="color:#0000CC" colspan="2">請選擇申請項目!!</td></tr>
			<%
			}
		}
		%>	
	</table>
<input type="hidden" name="WORKFLOWCODE" value="<%=strWorkflowCode%>">
<input type="hidden" name="STATUS_CODE" value="<%=SCODE%>">
<input type="hidden" name="WKCODE" value="<%=WKCODE%>">
<input type="hidden" name="HID" value="<%=HID%>">
</form>
<%
	rsOrg.close();
	statementOrg.close();
}
catch(Exception e)
{
	out.println(e.getMessage());
}
%>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
