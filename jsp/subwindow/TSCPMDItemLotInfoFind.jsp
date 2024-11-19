<!-- 20161107 Peggy,新增prd 外包-->
<!-- 20171012 Peggy,新增RD3工程入庫交易-->
<!-- 20171027 Peggy,新增RD5工程入庫交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="java.text.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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
  text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<%
String GOODSITEM=request.getParameter("GOODS");
if (GOODSITEM==null) GOODSITEM= "";
String ITEMID=request.getParameter("ITEMID");
if (ITEMID == null) ITEMID = "";
String LINENO=request.getParameter("LINENO");
if (LINENO == null) LINENO = "";
String REQUESETNO =request.getParameter("REQUESETNO");
if (REQUESETNO == null) REQUESETNO="";
String VERSIONID= request.getParameter("VERSIONID");
if (VERSIONID == null) VERSIONID="";
String ONHAND_TYPE = request.getParameter("ONHAND_TYPE");
if (ONHAND_TYPE == null) ONHAND_TYPE="";
String WAFERLOT = request.getParameter("WAFERLOT");
if (WAFERLOT == null) WAFERLOT="";
String WAFERQTY = request.getParameter("WAFERQTY");
if (WAFERQTY == null) WAFERQTY="";
String TSC_PROD_GROUP = request.getParameter("TSC_PROD_GROUP");
if (TSC_PROD_GROUP == null) TSC_PROD_GROUP="";

%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(LineNo,Stock,WaferLot,LotOnhand,InvItemID,InvItemName,UseDateCode)
{ 
	window.opener.document.MYFORM.elements["Stock"+LineNo].value=Stock;
	if (WaferLot==null || WaferLot=="null")
	{
		window.opener.document.MYFORM.elements["WaferLot"+LineNo].value="";
	}
	else
	{
		window.opener.document.MYFORM.elements["WaferLot"+LineNo].value=WaferLot;
	}
	window.opener.document.MYFORM.elements["LotOnhand"+LineNo].value=LotOnhand;
	window.opener.document.MYFORM.elements["INVITEM"+LineNo].value=InvItemName;
	window.opener.document.MYFORM.elements["INVITEMID"+LineNo].value=InvItemID;
	window.opener.document.MYFORM.elements["UseDateCode"+LineNo].value=UseDateCode;
	window.opener.document.MYFORM.elements["trans_source_id_"+LineNo].value=document.SITEFORM.ONHAND_TYPE.value;
	var totqty =window.opener.document.MYFORM.elements["totChipQty"].value;
	if (totqty ==null || isNaN(totqty) || totqty=="") totqty=0;
	var chipQty =window.opener.document.MYFORM.elements["ChipQty"+LineNo].value;
	if (chipQty ==null || isNaN(chipQty) || chipQty=="") chipQty=0;
	totqty =parseFloat(totqty)-parseFloat(chipQty);
	var qty = window.opener.document.MYFORM.QTY.value;
	if ((parseFloat(qty)*1000) >0 && ((parseFloat(LotOnhand)*1000) >= ((parseFloat(qty)*1000)-(parseFloat(totqty)*1000))))
	{
		chipQty =((parseFloat(qty)*1000)-(parseFloat(totqty)*1000))/1000;
		if (parseFloat(chipQty)<0) chipQty=0;
	}
	else
	{
		chipQty = LotOnhand;
	}
	window.opener.document.MYFORM.elements["ChipQty"+LineNo].value=chipQty;
	computeTotal("ChipQty");
	window.opener.document.MYFORM.elements["ChipQty"+LineNo].focus();
  	this.window.close();
}

function computeTotal(objName)
{
	var LINENUM = window.opener.document.MYFORM.LINENUM.value;
	var totQty =0,Qty=0;
	var num1, num2, m, c;
	for (var i = 1 ; i <= LINENUM ; i ++)
	{
		Qty = window.opener.document.MYFORM.elements[objName+i].value;
		try 
		{ 
			num1 = Qty.toString().split(".")[1].length 
		} 
		catch (e) { num1 = 0 }
		try 
		{
			num2 = totQty.toString().split(".")[1].length 
		} catch (e) { num2 = 0 }
		c = Math.abs(num1 - num2);
		m = Math.pow(10, Math.max(num1, num2))
		if (c > 0) 
		{
			var cm = Math.pow(10, c);
			if (num1 > num2) 
			{
				Qty = Number(Qty.toString().replace(".", ""));
				totQty = Number(totQty.toString().replace(".", "")) * cm;
			}
			else 
			{
				Qty = Number(Qty.toString().replace(".", "")) * cm;
				totQty = Number(totQty.toString().replace(".", ""));
			}
		}
		else 
		{
			Qty = Number(Qty.toString().replace(".", ""));
			totQty = Number(totQty.toString().replace(".", ""));
		}
		totQty = (Qty + totQty) / m;
	}
	window.opener.document.MYFORM.elements["tot"+objName].value = totQty;
	if (window.opener.document.MYFORM.PRICE_UOM.value != "片" && objName=="ChipQty")
	{
		//add by Peggy 20121009
		var DIEQTY = window.opener.document.MYFORM.DIEQTY.value;
		if (DIEQTY ==null) DIEQTY ="1";
		totQty = Math.round(parseFloat( totQty)/parseFloat(DIEQTY)*10000)/10000;
		window.opener.document.MYFORM.QTY.value = totQty;
	}
}
function setSource(svalue)
{
	document.SITEFORM.submit();
}
function setItem(sitem)
{
	document.SITEFORM.INVID.value=sitem.substr(0,sitem.indexOf(",")-1);
	document.SITEFORM.INVITEMNAME.value=sitem.substr(sitem.indexOf(",")+1);
}
function setSubmit1(LineNo,Stock,UseDateCode)
{
	if (document.SITEFORM.WAFERLOT.value=="")
	{
		alert("Please input the lot value");
		document.SITEFORM.WAFERLOT.focus();
		return false;
	}
	if (document.SITEFORM.WAFERQTY.value=="")
	{
		alert("Please input the qty value");
		document.SITEFORM.WAFERQTY.focus();
		return false;
	}
	sendToMainWindow(LineNo,Stock,document.SITEFORM.WAFERLOT.value,document.SITEFORM.WAFERQTY.value,document.SITEFORM.INVID.value,document.SITEFORM.INVITEMNAME.value,UseDateCode);	
}
</script>
<title>Page for choose Item Lot List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCPMDItemLotInfoFind.jsp" NAME="SITEFORM">
<table width="100%">
	<tr><td>
<%
String UseDateCode="";
Statement statement=con.createStatement();
ResultSet rs=null;
try
{   
	String sql = " SELECT a.type_no, a.type_name"+
                 " FROM oraddman.tspmd_data_type_tbl a"+
                 " WHERE DATA_TYPE ='SOURCE_ID' "+
                 " AND STATUS_FLAG='A'"+
                 " ORDER BY TO_NUMBER(TYPE_NO)";
	//out.println(sql);
	rs=statement.executeQuery(sql);
	out.println("庫存來源：<select NAME='ONHAND_TYPE' onChange='setSource(this.value)'>");
	while (rs.next())
	{  
		if (ONHAND_TYPE.equals("")) ONHAND_TYPE=rs.getString(1);        
		out.println("<OPTION VALUE='"+rs.getString(1)+"' "+(ONHAND_TYPE.equals(rs.getString(1))?" selected":"")+">"+rs.getString(2));
	} 
	out.println("</select>"); 
	rs.close();        	 
} 
catch (Exception e) 
{ 
	out.println("Exception2:"+e.getMessage()); 
}
%> 
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
<%  
try
{
	UseDateCode="";
	if (!GOODSITEM.equals(""))
	{
		String sql = " select distinct b.date_code from oraddman.tspmd_oem_headers_all a,oraddman.tspmd_oem_lines_all b"+
			  " where a.request_no=b.request_no and a.version_id=b.version_id and a.inventory_item_id='"+GOODSITEM+"'"+
			  " and b.date_code is not null"+ //modify by Peggy 20140825,相同成品料號不可使用相同DATECODE
			  " and a.STATUS <>'Inactive'"+
			  " and trunc(a.completion_date) between ADD_MONTHS(TRUNC(sysdate),-108) and trunc(sysdate)"; //add by Peggy 20221124
		if (!REQUESETNO.equals("") && !VERSIONID.equals("")) sql += " AND a.request_no||'-'||a.version_id  <>'"+REQUESETNO+"-"+VERSIONID+"'";
		//out.print(sql);
		Statement statementx=con.createStatement();
		ResultSet rsx=statementx.executeQuery(sql);
		while (rsx.next())
		{
			UseDateCode += (rsx.getString("date_code")+";");
		}	
		rsx.close();
		statementx.close();	
		//out.println(UseDateCode);			  
	}
}
catch (Exception e) 
{
	out.println("Exception5:"+e.getMessage()); 
}

if (ONHAND_TYPE.equals("") || ONHAND_TYPE.equals("0"))
{
	try
    { 
		String sql = " select c.segment1 Item_Name"+
		             ",c.description Item_Desc"+ //add by Peggy 20160721
		             ",a.LOT_NUMBER WAFER_LOT"+
					 ",a.subinventory_code||'-'||b.description subinventory_name"+
					 ",sum(a.PRIMARY_TRANSACTION_QUANTITY) ONHAND_QTY"+
					 ",a.subinventory_code"+
					 ",c.segment1"+
					 ",c.description"+
					 ",a.INVENTORY_ITEM_ID"+
					 ",c.organization_id"+
					 ",tsc_om_category(a.inventory_item_id,c.organization_id,'TSC_PRDO_GROUP') tsc_prod_group"+ //add by Peggy 20161110
                     " from MTL_ONHAND_QUANTITIES_DETAIL a,MTL_SECONDARY_INVENTORIES b,inv.mtl_system_items_b c"+
					 " where A.ORGANIZATION_ID = 49"+
                     " and a.INVENTORY_ITEM_ID IN ("+ITEMID+")"+  //modify by Peggy 20121009
                     " and a.ORGANIZATION_ID = b.ORGANIZATION_ID"+
                     " and a.subinventory_code = b.secondary_inventory_name"+
					 " and a.ORGANIZATION_ID = c.ORGANIZATION_ID"+
					 " and a.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID"+
                     " and a.PRIMARY_TRANSACTION_QUANTITY>0";
		//if (SearchStr != null && !SearchStr.equals(""))
		//{
		//	sql += " AND (a.LOT_NUMBER like '"+SearchStr+"%')"; 
		//}
		sql += " group by a.LOT_NUMBER ,a.subinventory_code||'-'||b.description,a.subinventory_code,c.segment1,c.description,a.INVENTORY_ITEM_ID,c.organization_id ORDER BY a.lot_number";
		//out.println(sql);
		rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		//String WaferLot="";
		//String WaferQty="";
		String StockName="";
		String ITEMNAME="";
		String INVID = "";//add by Peggy 20121009
		int queryCount=0;
		String buttonContent=null;		
		while (rs.next())
		{
			if (queryCount==0)
			{
				//out.println("<font face='標楷體'>台半料號：</fon><font face='Arial' size='2px'>"+rs.getString("segment1")+"</font><BR>");
				//out.println("<font face='標楷體'>品名：</fon><font face='Arial' size='2px''>"+rs.getString("description")+"</font><br>");
				//out.println("<font face='Arial'>");
				out.println("<TABLE width='100%'>");      
				out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
				for (int i=1;i<=colCount-6;i++) 
				{
					colLabel[i]=md.getColumnLabel(i);
					out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
				} //end of for 
				out.println("</TR>");
			}
			INVID=rs.getString("INVENTORY_ITEM_ID"); //add by Peggy 20121009
			WAFERLOT=rs.getString("WAFER_LOT");
			WAFERQTY=(new DecimalFormat("####0.0##")).format(Float.parseFloat(rs.getString("ONHAND_QTY"))); //modify by Peggy 20120705
			StockName=rs.getString("subinventory_code");
			ITEMNAME=rs.getString("segment1");

			buttonContent="this.value=sendToMainWindow("+'"'+LINENO+'"'+','+'"'+StockName+'"'+","+'"'+WAFERLOT+'"'+","+'"'+WAFERQTY+'"'+","+'"'+INVID+'"'+","+'"'+ITEMNAME+'"'+","+'"'+UseDateCode+'"'+")";		
			//out.println(buttonContent);
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount-6;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				out.println("<TD "+( (i==colCount-6)?" align='right'":" align='left'")+"><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT></TD>");
			} //end of for
			out.println("</TR>");
			//out.println("<input type='hidden' name='STOCKNAME' value='"+StockName+"' >");
			//out.println("<input type='hidden' name='WAFERLOT' value='"+WAFERLOT+"' >");
			//out.println("<input type='hidden' name='WAFERQTY' value='"+WAFERQTY+"' >");
			//out.println("<input type='hidden' name='INVID' value='"+INVID+"' >"); //add by Peggy 20121009
			//out.println("<input type='hidden' name='INVITEMNAME' value='"+ITEMNAME+"' >");
			//out.println("<input type='hidden' name='USEDATECODE' value='"+UseDateCode+"' >");
			queryCount++;	
		} //end of while
		rs.close();       
		if (queryCount>0)
		{		
			out.println("</TABLE>");						
		}
		else
		{
			out.println("<font color='red'>查無庫存資料!!!</font>");
		}
	    if (queryCount==1) //若取到的查詢數 == 1
	    {
	     %>
		    <script LANGUAGE="JavaScript">	
				//sendToMainWindow('<%=LINENO%>','<%=StockName%>','<%=WAFERLOT%>','<%=WAFERQTY%>','<%=INVID%>','<%=ITEMNAME%>','<%=UseDateCode%>');
				/*
				var LineNo	=document.SITEFORM.LINENO.value;
				window.opener.document.MYFORM.elements["Stock"+LineNo].value=document.SITEFORM.STOCKNAME.value;
				if (document.SITEFORM.WAFERLOT.value==null || document.SITEFORM.WAFERLOT.value =="null")
				{
					window.opener.document.MYFORM.elements["WaferLot"+LineNo].value="";
				}
				else
				{
					window.opener.document.MYFORM.elements["WaferLot"+LineNo].value=document.SITEFORM.WAFERLOT.value;
				}
				window.opener.document.MYFORM.elements["INVITEMID"+LineNo].value=document.SITEFORM.INVID.value;
				window.opener.document.MYFORM.elements["INVITEM"+LineNo].value=document.SITEFORM.INVITEMNAME.value;
				window.opener.document.MYFORM.elements["UseDateCode"+LineNo].value=document.SITEFORM.USEDATECODE.value;
				window.opener.document.MYFORM.elements["LotOnhand"+LineNo].value=document.SITEFORM.WAFERQTY.value;
				var totqty =window.opener.document.MYFORM.elements["totChipQty"].value;
				if (totqty ==null || isNaN(totqty) || totqty=="") totqty=0;
				var chipQty =window.opener.document.MYFORM.elements["ChipQty"+LineNo].value;
				if (chipQty ==null || isNaN(chipQty) || chipQty=="") chipQty=0;
				totqty =parseFloat(totqty)-parseFloat(chipQty);
				var qty = window.opener.document.MYFORM.QTY.value;
				if ((parseFloat(qty)*1000) > 0 && ((parseFloat(LotOnhand)*1000) >= ((parseFloat(qty)*1000)-(parseFloat(totqty)*1000))))
				{
					chipQty =((parseFloat(qty)*1000)-(parseFloat(totqty)*1000))/1000;
					if (parseFloat(chipQty)<0) chipQty=0;
				}
				else
				{
					chipQty = LotOnhand;
				}
				window.opener.document.MYFORM.elements["ChipQty"+LineNo].value=chipQty;
				computeTotal("ChipQty");
				window.opener.document.MYFORM.elements["ChipQty"+LineNo].focus();
				this.window.close(); 
				*/
            </script>
		 <%
	    }
		
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	finally
	{
		rs.close();
	}
}
else
{
	try
	{
		String sql = " SELECT A.INVENTORY_ITEM_ID"+
					 " ,A.SEGMENT1 ITEM_NAME"+
					 " ,A.DESCRIPTION ITEM_DESC"+
					 " ,B.TYPE_NAME SUBINVENTORY_CODE"+
					 " ,TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
					 " ,COUNT(1) OVER (PARTITION BY A.ORGANIZATION_ID) TOT_CNT"+
					 " ,ROW_NUMBER() OVER (PARTITION BY A.ORGANIZATION_ID ORDER BY A.INVENTORY_ITEM_ID) ROW_CNT"+
					 "  FROM INV.MTL_SYSTEM_ITEMS_B A"+
					 " ,(SELECT * FROM ORADDMAN.TSPMD_DATA_TYPE_TBL WHERE DATA_TYPE='SUBINVENTORY') B "+
					 " WHERE A.INVENTORY_ITEM_ID IN ("+ITEMID+")"+
					 " AND A.ORGANIZATION_ID=49"+
					 //" AND INSTR(TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_GROUP'),B.TYPE_NO)>0";
					 " AND INSTR('"+TSC_PROD_GROUP+"',B.TYPE_NO)>0"+
					 " ORDER BY A.INVENTORY_ITEM_ID";
		//out.println(sql);
		rs=statement.executeQuery(sql);
		while (rs.next())
		{
			if (rs.getInt("ROW_CNT")==1)
			{
				out.println("<table width='100%' border='1' cellpadding='1' cellspacing='0'>");      
				out.println("<tr style='background-color:#AFD8BF'><td width='25%' align='center'>Item Name</td><td width='25%' align='center'>倉別</td><td width='25%' align='center'>LOT</td><td width='25%' align='center'>Qty(KPC)</td></tr>");        
				out.println("<tr>");
				if (rs.getInt("tot_cnt")==1)
				{
					out.println("<td align='center'><input type='text' name='INVITEMNAME' value='"+rs.getString("ITEM_NAME")+"' style='font-family: Tahoma,Georgia;' readonly><input type='hidden' name='INVID' value='"+rs.getString("INVENTORY_ITEM_ID")+"' ></td>");
				}
				else
				{
					out.println("<td><input type='hidden' name='INVITEMNAME' value='"+rs.getString("ITEM_NAME")+"'><input type='hidden' name='INVID' value='"+rs.getString("INVENTORY_ITEM_ID")+"'>");
					out.println("<select NAME='ITEM_LIST' onChange='setItem(this.value)' >");
					out.println("<OPTION VALUE='"+rs.getString("INVENTORY_ITEM_ID")+","+rs.getString("ITEM_NAME")+"'>"+rs.getString("ITEM_NAME"));
				}
			}
			if (rs.getInt("ROW_CNT")!=1 && rs.getInt("ROW_CNT")!=rs.getInt("TOT_CNT"))
			{
				out.println("<OPTION VALUE='"+rs.getString("INVENTORY_ITEM_ID")+","+rs.getString("ITEM_NAME")+"'>"+rs.getString("ITEM_NAME"));
			}
			if (rs.getInt("ROW_CNT")==rs.getInt("TOT_CNT"))
			{
				if (rs.getInt("tot_cnt")>1)
				{
					out.println("<OPTION VALUE='"+rs.getString("INVENTORY_ITEM_ID")+","+rs.getString("ITEM_NAME")+"'>"+rs.getString("ITEM_NAME"));
					out.println("</select></td>"); 
				}
				out.println("<td align='center'><input type='text' name='STOCKNAME' value='"+rs.getString("SUBINVENTORY_CODE")+"' style='font-family: Tahoma,Georgia;' readonly></td>");
				out.println("<td align='center'><input type='text' name='WAFERLOT' value='"+WAFERLOT+"' style='font-family: Tahoma,Georgia;'></td>");
				out.println("<td align='center'><input type='text' name='WAFERQTY' value='"+WAFERQTY+"' style='font-family: Tahoma,Georgia;'></td>");
				out.println("</tr></table>");
				out.println("<hr>");
				out.println("<div align='center'><input type='button' name='Submit1' value='Submit' style='font-family: Tahoma,Georgia;' onclick='setSubmit1("+'"'+LINENO+'"'+","+'"'+rs.getString("SUBINVENTORY_CODE")+'"'+","+'"'+UseDateCode+'"'+")'></div>");
			}
		}
	}
	catch(Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}
	finally
	{
		rs.close();
	}
}
statement.close();		  		  
%>
		</td>
	</tr>
</table>
<!--%表單參數%-->
<input type="hidden" name="ITEMID" value="<%=ITEMID%>">
<input type="hidden" name="REQUESETNO" value="<%=REQUESETNO%>">
<input type="hidden" name="VERSIONID" value="<%=VERSIONID%>">
<input type="hidden" name="GOODS" value="<%=GOODSITEM%>">
<input type="hidden" name="LINENO" value="<%=LINENO%>">
<input type="hidden" name="TSC_PROD_GROUP" value="<%=TSC_PROD_GROUP%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
