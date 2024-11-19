<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="MOShipBean" scope="session" class="Array2DimensionInputBean"/>
<!--<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<%
String sql = "",ITEMNAME="",ITEMDESC="",v_trans_flag="";
int icnt=0;
String WIP_TYPE = request.getParameter("WIP_TYPE");
if (WIP_TYPE==null) WIP_TYPE="";
String DIEID = request.getParameter("DIEID");
if (DIEID==null) DIEID="";
String ITEMN = request.getParameter("ITEMN");
if (ITEMN==null) ITEMN="";
String RDOTYPE = request.getParameter("RDOTYPE");
if (RDOTYPE == null) RDOTYPE="";
String WIPNO = request.getParameter("WIPNO");
if (WIPNO == null) WIPNO="";
if (RDOTYPE.equals("")) RDOTYPE="1";
String IROW=request.getParameter("IROW");
if (IROW==null) IROW="";
String CLICK_CNT=request.getParameter("CLICK_CNT");
if (CLICK_CNT==null) CLICK_CNT="0";
%>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>A01 OEM Item List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setAdd(sitemid,sitemname,sitemdesc,ssubinv,slot,sdc,sqty,iseq,icnt,swaferno)
{
	var irow= eval(iseq)+ eval("0"+document.SUBFORM.CLICK_CNT.value);
	var chvalue="";
	document.SUBFORM.CLICK_CNT.value = irow;
	window.opener.document.MYFORM.elements["ITEMID_D_"+irow].value=sitemid;
	window.opener.document.MYFORM.elements["ITEMNAME_D_"+irow].value=sitemname;
	window.opener.document.MYFORM.elements["ITEMDESC_D_"+irow].value=sitemdesc;
	window.opener.document.MYFORM.elements["SUBINV_D_"+irow].value=ssubinv;
	window.opener.document.MYFORM.elements["LOT_D_"+irow].value=slot;
	window.opener.document.MYFORM.elements["WAFERNO_D_"+irow].value=swaferno;
	window.opener.document.MYFORM.elements["WAFERQTY_D_"+irow].value=sqty;
	window.opener.document.MYFORM.elements["DATECODE_D_"+irow].value=sdc;
	if (window.opener.document.MYFORM.chk.length != undefined)
	{
		window.opener.document.MYFORM.chk[irow-1].checked=true;
	}
	else
	{
		window.opener.document.MYFORM.chk.checked=true;;
	}
	if (window.opener.document.MYFORM.QTY.value=="")
	{
		window.opener.document.MYFORM.QTY.value=0;
	}
	window.opener.document.MYFORM.QTY.value	= eval(window.opener.document.MYFORM.QTY.value)+eval(sqty);
	for (var i =0 ; i <document.SUBFORM.RDOTYPE.length ;i++)
	{
		if (document.SUBFORM.RDOTYPE[i].checked)
		{
			 chvalue = document.SUBFORM.RDOTYPE[i].value;
			 break;
		}
	}
	if (chvalue =="2")
	{
		window.opener.document.MYFORM.HOLD_FLAG.checked=true;
	}
	document.getElementById("tr_"+icnt).style.backgroundColor="#FFFF66";
}
function setClose()
{
	window.close();				
}
function setRaoObj()
{
	var chvalue="";
	for (var i =0 ; i <document.SUBFORM.RDOTYPE.length ;i++)
	{
		if (document.SUBFORM.RDOTYPE[i].checked)
		{
			 chvalue = document.SUBFORM.RDOTYPE[i].value;
			 break;
		}
	}
	if (chvalue =="1")
	{
		document.SUBFORM.WIPNO.disabled =true;
		document.SUBFORM.WIPNO.value="--";
	}
	else if (chvalue =="2")
	{
		document.SUBFORM.WIPNO.disabled =false;
		document.SUBFORM.WIPNO.value="--";
	}

}
function setWIPNO(wipno)
{
	
	document.SUBFORM.action="../subwindow/TSA01OEMMISCItemInfo.jsp?WIPNO="+wipno;
	document.SUBFORM.submit();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSA01OEMMISCItemInfo.jsp" NAME="SUBFORM">
<%
try
{
	sql = " select segment1 ,description,(select ? from oraddman.tsa01_oem_data_type b where b.data_type=? and b.data_code=? and b.data_name=? and b.status_flag=?) TRANS_FLAG "+
		  " from inv.mtl_system_items_b a"+
		  " where a.organization_id=?"+
		  " and a.inventory_item_id=?";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"Y");
	statement.setString(2,"PCETOKPCS");
	statement.setString(3,WIP_TYPE);
	statement.setString(4,ITEMN);
	statement.setString(5,"A");	
	statement.setInt(6,606);
	statement.setInt(7,Integer.parseInt(DIEID));
	ResultSet rs=statement.executeQuery();
	if (rs.next())
	{
		ITEMNAME=rs.getString(1);
		ITEMDESC=rs.getString(2);
		v_trans_flag=rs.getString(3);
		if (v_trans_flag==null) v_trans_flag="N";
	}
	rs.close();	  
	statement.close();
	
%>
<table width="100%">
	<tr><td>料號:<%=ITEMNAME%></td></tr>
	<tr><td>品名:<%=ITEMDESC%></td></tr>
	<tr><td><input type="radio" name="RDOTYPE" value="1" <%=(RDOTYPE.equals("1")?"checked":"")%> onClick="setRaoObj()">庫存明細
		<%
		//if (WIP_TYPE.equals("CP"))
		if (v_trans_flag.equals("Y"))
		{
		%>
	        &nbsp;&nbsp;<input type="radio" name="RDOTYPE" value="2"  <%=(RDOTYPE.equals("2")?"checked":"")%> onClick="setRaoObj()">工單明細
			<%
			try
			{   
				sql = " SELECT DISTINCT WIP_NO,WIP_NO WIP_NO1 "+
				      " FROM ORADDMAN.TSA01_OEM_HEADERS_ALL A ,ORADDMAN.TSA01_OEM_LINES_ALL B "+
					  " WHERE A.WIP_TYPE_NO<>? "+
					  " AND A.WIP_NO is not null"+
                      " AND A.REQUEST_NO=B.REQUEST_NO"+
                      " AND A.VERSION_ID=B.VERSION_ID "+
					  " AND A.INVENTORY_ITEM_ID =?"+
					  " AND NOT EXISTS (SELECT 1 FROM ORADDMAN.TSA01_OEM_HEADERS_ALL X,ORADDMAN.TSA01_OEM_LINES_ALL Y"+
					  "                 WHERE X.WIP_TYPE_NO=? AND X.REQUEST_NO=Y.REQUEST_NO AND X.VERSION_ID=Y.VERSION_ID"+
					  "                 AND Y.LOT_NUMBER=B.LOT_NUMBER)"+					  					  
					  " ORDER BY A.WIP_NO DESC"; 
				PreparedStatement statement1 = con.prepareStatement(sql);							 
				statement1.setString(1,WIP_TYPE);
				statement1.setInt(2,Integer.parseInt(DIEID));
				statement1.setString(3,WIP_TYPE);				
				ResultSet rs1=statement1.executeQuery();
				out.println("<select NAME='WIPNO' style='font-size:11px;font-family:Tahoma,Georgia' onChange='setWIPNO(this.form.WIPNO.value)' "+(RDOTYPE.equals("2")?" ":" disabled")+">");
				out.println("<OPTION VALUE=-->--");     
				while (rs1.next())
				{            
					out.println("<OPTION VALUE='"+rs1.getString(1)+"' "+(WIPNO.equals(rs1.getString(1))?" SELECTED":"")+">"+rs1.getString(2));					   
				} 
				out.println("</select>"); 
				rs1.close();        	 	
				statement1.close();		  		  
			} 
			catch (Exception e) 
			{ 
				out.println("Exception1:"+e.getMessage()); 
			}
		} 		
		%>				
	   </td>
	</tr>
		<%
			if (RDOTYPE.equals("1"))
			{
				//sql = " SELECT MSI.INVENTORY_ITEM_ID,MSI.SEGMENT1,MSI.DESCRIPTION,MQOD.SUBINVENTORY_CODE,MQOD.LOT_NUMBER,MQOD.TRANSACTION_QUANTITY ONHAND_QTY,MQOD.TRANSACTION_UOM_CODE UOM,NVL(MLN.DATE_CODE,'N/A') DATE_CODE,'#01-'||MQOD.TRANSACTION_QUANTITY WAFER_NUMBER"+
				sql = " SELECT MSI.INVENTORY_ITEM_ID,MSI.SEGMENT1,MSI.DESCRIPTION,MQOD.SUBINVENTORY_CODE,MQOD.LOT_NUMBER,MQOD.TRANSACTION_QUANTITY ONHAND_QTY,MQOD.TRANSACTION_UOM_CODE UOM,NVL(MLN.DATE_CODE,'N/A') DATE_CODE,'' WAFER_NUMBER"+  //不用自動編片號,add by Peggy 20220915
                      " FROM INV.MTL_ONHAND_QUANTITIES_DETAIL MQOD"+
					  ",INV.MTL_LOT_NUMBERS MLN"+
					  ",INV.MTL_SYSTEM_ITEMS_B MSI"+
                      " WHERE MQOD.INVENTORY_ITEM_ID=MLN.INVENTORY_ITEM_ID "+
                      " AND MQOD.ORGANIZATION_ID=MLN.ORGANIZATION_ID "+
                      " AND MQOD.LOT_NUMBER=MLN.LOT_NUMBER"+
                      " AND MQOD.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID "+
                      " AND MQOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID "+
                      " AND MSI.ORGANIZATION_ID=?"+
                      " AND MSI.INVENTORY_ITEM_ID=?"+
                      " AND MQOD.SUBINVENTORY_CODE=?";
			}
			else
			{
				sql = " SELECT A.INVENTORY_ITEM_ID,A.INVENTORY_ITEM_NAME SEGMENT1,A.ITEM_DESCRIPTION DESCRIPTION,B.SUBINVENTORY_CODE,B.LOT_NUMBER,B.WAFER_QTY ONHAND_QTY,'PCE' UOM,B.DATE_CODE,B.WAFER_NUMBER"+
                      " FROM ORADDMAN.TSA01_OEM_HEADERS_ALL A"+
					  ",ORADDMAN.TSA01_OEM_LINES_ALL B "+
                      " WHERE A.WIP_NO=?"+
					  " AND A.INVENTORY_ITEM_ID=?"+
                      " AND A.REQUEST_NO=B.REQUEST_NO"+
                      " AND A.VERSION_ID=B.VERSION_ID "+
					  " AND A.WIP_NO NOT IN (?)"+ //晶片已轉PMD,ADD BY PEGGY 20220826
					  " AND NOT EXISTS (SELECT 1 FROM ORADDMAN.TSA01_OEM_HEADERS_ALL X,ORADDMAN.TSA01_OEM_LINES_ALL Y"+
					  "                 WHERE X.WIP_TYPE_NO=? AND X.REQUEST_NO=Y.REQUEST_NO AND X.VERSION_ID=Y.VERSION_ID"+
					  "                 AND Y.LOT_NUMBER=B.LOT_NUMBER)"+
                      " AND A.STATUS IN (?)";
			}
			statement = con.prepareStatement(sql);
			if (RDOTYPE.equals("1"))
			{			
				statement.setInt(1,606);
				statement.setInt(2,Integer.parseInt(DIEID));
				statement.setString(3,"01");
			}
			else
			{
				statement.setString(1,WIPNO);
				statement.setInt(2,Integer.parseInt(DIEID));
				statement.setString(3,"SA-220225-001"); //晶片已轉PMD,ADD BY PEGGY 20220826
				statement.setString(4,"CP");
				statement.setString(5,"Approved");
			}
			rs=statement.executeQuery();	
			while(rs.next())
			{
				icnt++;
				if (icnt==1)
				{
		%>	
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0"  bordercolor="#CCCCCC">
				<tr bgcolor="#CCCCCC">
					<td width="15%">Subinv Code</td>
					<td width="20%">Lot Number</td>
					<td width="15%">Wafer#</td>
					<td width="15%">Onhand(PCE)</td>
					<td width="10%">Date Code</td>
					<td width="10%">&nbsp;</td>
				</tr>
				<%
				}
				%>
				<tr id="tr_<%=icnt%>">
				<td><%=rs.getString("SUBINVENTORY_CODE")%></td>
				<td><%=rs.getString("LOT_NUMBER")%></td>
				<td><%=(rs.getString("WAFER_NUMBER")==null?"&nbsp;":rs.getString("WAFER_NUMBER"))%></td>
				<td><%=rs.getString("ONHAND_QTY")%></td>
				<td><%=rs.getString("DATE_CODE")%></td>
				<td align="center"><input type="button" name="btn_<%=icnt%>" value="Add" style="font-size:11px;font-family:Tahoma,Georgia" onClick="setAdd('<%=rs.getString("INVENTORY_ITEM_ID")%>','<%=rs.getString("SEGMENT1")%>','<%=rs.getString("DESCRIPTION")%>','<%=rs.getString("SUBINVENTORY_CODE")%>','<%=rs.getString("LOT_NUMBER")%>','<%=rs.getString("DATE_CODE")%>','<%=rs.getString("ONHAND_QTY")%>','<%=Integer.parseInt(IROW)%>','<%=icnt%>','<%=(rs.getString("WAFER_NUMBER")==null?"":rs.getString("WAFER_NUMBER"))%>')"></td>
				</tr>
			<%
			}
			rs.close();	  
			statement.close();			
			
			%>
			<%
			if (icnt>0)
			{
			%>
		</table>		</td>
	</tr>
			<%
			}
			else
			{
			%>
	<tr>
		<td>
			<%
			if (RDOTYPE.equals("1"))
			{			
				out.println("<font color='red'>查無庫存資料,請重新確認,謝謝!</font>");
			}
			else
			{
				out.println("<font color='red'>查無資料,請確認料號是否有下工單,謝謝!</font>");
			}
			
			%>		
		</td>
	</tr>
			<%
			}	
			%>
	<tr>
		<td align="center"><INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'></td>
	</tr>
</table>
<%
}
catch(Exception e)
{
	out.println("<font color='red'>"+e.getMessage()+"</font>");
}
%>
<INPUT TYPE="hidden" name="DIEID" value="<%=DIEID%>">
<INPUT TYPE="hidden" name="WIP_TYPE" value="<%=WIP_TYPE%>">
<INPUT TYPE="hidden" name="IROW" value="<%=IROW%>">
<INPUT TYPE="hidden" name="CLICK_CNT" vlaue="<%=CLICK_CNT%>">
<INPUT TYPE="hidden" name="ITEMN" value="<%=ITEMN%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
