<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String sql = "";
String REQTYPE= request.getParameter("REQTYPE");
if (REQTYPE==null) REQTYPE="";
String ITEMNAME = request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String ITEMDESC = request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String LOTNUM = request.getParameter("LOTNUM");
if (LOTNUM==null) LOTNUM="";
String ISEQ = request.getParameter("ISEQ");
if (ISEQ==null) ISEQ="";
String NEWITEM = request.getParameter("NEWITEM");
if (NEWITEM==null) NEWITEM="";
String NEWITEMDESC = request.getParameter("NEWITEMDESC");
if (NEWITEMDESC==null) NEWITEMDESC="";
String ITEMTYPE = request.getParameter("ITEMTYPE");
if (ITEMTYPE ==null) ITEMTYPE ="";
String ORG = request.getParameter("ORG");
if (ORG ==null) ORG ="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SG Advise No List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(lineno,iseq)
{
	if (document.SUBFORM.REQTYPE.value=="SUBTRANS")
	{
		window.opener.document.MYFORM.elements["TSC_PROD_"+iseq].value = document.getElementById("prod_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["ORIG_ITEM_NAME_"+iseq].value = document.getElementById("item_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["ORIG_ITEM_DESC_"+iseq].value = document.getElementById("desc_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["ORIG_LOT_"+iseq].value = document.getElementById("lot_"+lineno).innerHTML;
		if (document.getElementById("dc_"+lineno).innerHTML!=null)
		{
			window.opener.document.MYFORM.elements["ORIG_DC_"+iseq].value = document.getElementById("dc_"+lineno).innerHTML;
		}
		else
		{
			window.opener.document.MYFORM.elements["ORIG_DC_"+iseq].value = "";
		}
		//window.opener.document.MYFORM.elements["ORIG_ORG_"+iseq].value = document.getElementById("orgid_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["ORIG_ORG_"+iseq].value = document.SUBFORM.elements["orgid_"+lineno].value;
		window.opener.document.MYFORM.elements["ORIG_SUBINV_"+iseq].value = document.getElementById("subinv_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["QTY_"+iseq].value = document.getElementById("qty_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["UOM_"+iseq].value = document.getElementById("uom_"+lineno).innerHTML;
		window.opener.document.MYFORM.elements["NEW_ORG_"+iseq].value ="";
		window.opener.document.MYFORM.elements["NEW_SUBINV_"+iseq].value ="";
		window.opener.document.MYFORM.elements["REQ_REASON_"+iseq].value = ""
		window.opener.document.MYFORM.elements["UNITPRICE_"+iseq].value = "";
		window.opener.document.MYFORM.elements["AMT_"+iseq].value = "";
	}
	else if (document.SUBFORM.REQTYPE.value=="MISC")
	{
		if (document.SUBFORM.ITEMTYPE.value=="OLD")
		{
			window.opener.document.MYFORM.elements["TSC_PROD_"+iseq].value = document.getElementById("prod_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["ORIG_ITEM_NAME_"+iseq].value = document.getElementById("item_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["ORIG_ITEM_DESC_"+iseq].value = document.getElementById("desc_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["ORIG_LOT_"+iseq].value = document.getElementById("lot_"+lineno).innerHTML;
			if (document.getElementById("dc_"+lineno).innerHTML!=null)
			{
				window.opener.document.MYFORM.elements["ORIG_DC_"+iseq].value = document.getElementById("dc_"+lineno).innerHTML;
			}
			else
			{
				window.opener.document.MYFORM.elements["ORIG_DC_"+iseq].value = "";
			}
			//window.opener.document.MYFORM.elements["ORIG_ORG_"+iseq].value = document.getElementById("orgid_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["ORIG_ORG_"+iseq].value = document.SUBFORM.elements["orgid_"+lineno].value;
			window.opener.document.MYFORM.elements["ORIG_SUBINV_"+iseq].value = document.getElementById("subinv_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["QTY_"+iseq].value = document.getElementById("qty_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["UOM_"+iseq].value = document.getElementById("uom_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["NEW_ITEM_NAME_"+iseq].value ="";
			window.opener.document.MYFORM.elements["NEW_ITEM_DESC_"+iseq].value ="";
			window.opener.document.MYFORM.elements["REQ_REASON_"+iseq].value = "";
		}
		else
		{
			window.opener.document.MYFORM.elements["NEW_ITEM_NAME_"+iseq].value = document.getElementById("item_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["NEW_ITEM_DESC_"+iseq].value = document.getElementById("desc_"+lineno).innerHTML;
			window.opener.document.MYFORM.elements["NEW_UOM_"+iseq].value = document.getElementById("uom_"+lineno).innerHTML;
			if (window.opener.document.MYFORM.elements["NEW_ITEM_NAME_"+iseq].value!=window.opener.document.MYFORM.elements["ORIG_ITEM_NAME_"+iseq].value)
			{
				window.opener.document.MYFORM.elements["NEW_LOT_"+iseq].value = window.opener.document.MYFORM.elements["ORIG_LOT_"+iseq].value;
				window.opener.document.MYFORM.elements["NEW_DC_"+iseq].value = window.opener.document.MYFORM.elements["ORIG_DC_"+iseq].value;
			}
			if (window.opener.document.MYFORM.elements["NEW_UOM_"+iseq].value = window.opener.document.MYFORM.elements["UOM_"+iseq].value)
			{
				window.opener.document.MYFORM.elements["NEW_QTY_"+iseq].value = window.opener.document.MYFORM.elements["QTY_"+iseq].value;
			}
		}
	}
	this.window.close();
}
</script>
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
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<body >  
<FORM METHOD="post" ACTION="TSCStockTransItemInfo.jsp" NAME="SUBFORM">
<input type="hidden" name="REQTYPE" value="<%=REQTYPE%>">
<input type="hidden" name="ITEMTYPE" value="<%=ITEMTYPE%>">
<%	
try
{	
	if (REQTYPE.equals("SUBTRANS"))
	{			
		sql = " SELECT TSC_INV_CATEGORY(MOQD.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
			  ",MSI.SEGMENT1 ITEM_NO"+
			  ",MSI.DESCRIPTION ITEM_DESC"+
			  ",MOQD.SUBINVENTORY_CODE"+
			  ",MOQD.LOT_NUMBER"+
			  ",MLN.DATE_CODE"+
			  //",MOQD.TRANSACTION_QUANTITY"+
			  ",SUM(CASE WHEN MSI.ITEM_TYPE='FG' THEN CASE WHEN MSI.PRIMARY_UNIT_OF_MEASURE='KPC' AND MOQD.TRANSACTION_UOM_CODE='PCE' THEN MOQD.TRANSACTION_QUANTITY/1000 "+
              "     WHEN MSI.PRIMARY_UNIT_OF_MEASURE='PCE' AND MOQD.TRANSACTION_UOM_CODE='KPC' THEN MOQD.TRANSACTION_QUANTITY*1000 ELSE MOQD.TRANSACTION_QUANTITY END"+
              "    ELSE MOQD.TRANSACTION_QUANTITY END) TRANSACTION_QUANTITY"+
			  //",MOQD.TRANSACTION_UOM_CODE"+
			  ",MSI.PRIMARY_UNIT_OF_MEASURE UOM"+
			  ",MP.ORGANIZATION_ID"+
			  ",MP.ORGANIZATION_CODE"+
			  ",MSI.ITEM_TYPE"+
			  " FROM INV.MTL_ONHAND_QUANTITIES_DETAIL MOQD,INV.MTL_SYSTEM_ITEMS_B MSI,INV.MTL_LOT_NUMBERS MLN,INV.MTL_PARAMETERS MP"+
			  //" WHERE ((MOQD.ORGANIZATION_ID IN (49) AND MOQD.SUBINVENTORY_CODE IN ('63','68','40','73'))"+
			  //" OR (MOQD.ORGANIZATION_ID IN (566) AND MOQD.SUBINVENTORY_CODE IN ('40'))"+
			  //" OR (MOQD.ORGANIZATION_ID IN (746) AND MOQD.SUBINVENTORY_CODE IN ('67')))"+
			  " WHERE MOQD.ORGANIZATION_ID=MSI.ORGANIZATION_ID"+
			  " AND MOQD.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
			  " AND MOQD.ORGANIZATION_ID=MLN.ORGANIZATION_ID"+
			  " AND MOQD.INVENTORY_ITEM_ID=MLN.INVENTORY_ITEM_ID"+
			  " AND MOQD.ORGANIZATION_ID=MP.ORGANIZATION_ID"+
			  " AND MSI.SEGMENT1 LIKE NVL(?,MSI.SEGMENT1)||'%'"+
			  " AND MSI.DESCRIPTION LIKE NVL(?,MSI.DESCRIPTION)||'%'"+
			  " AND MOQD.LOT_NUMBER LIKE NVL(?,MOQD.LOT_NUMBER)||'%'"+
			  " AND MOQD.LOT_NUMBER=MLN.LOT_NUMBER"+
		      " AND EXISTS (SELECT 1 FROM ORADDMAN.TSC_STOCK_TRANS_SUBINV X WHERE X.TRANS_TYPE=? AND X.ORGANIZATION_CODE=MP.ORGANIZATION_CODE AND X.SUBINVENTORY_CODE=MOQD.SUBINVENTORY_CODE"+
			  "             AND NVL(X.ACTIVE_FLAG,'N')=?)"+
			  " GROUP BY MOQD.INVENTORY_ITEM_ID"+
			  " ,MSI.SEGMENT1"+
              " ,MSI.DESCRIPTION"+
              " ,MOQD.SUBINVENTORY_CODE"+
              " ,MOQD.LOT_NUMBER"+
              " ,MLN.DATE_CODE"+
              " ,MSI.PRIMARY_UNIT_OF_MEASURE"+
              " ,MP.ORGANIZATION_ID"+
              " ,MP.ORGANIZATION_CODE"+
			  " ,MSI.ITEM_TYPE"+
			  " ORDER BY MSI.DESCRIPTION,MOQD.SUBINVENTORY_CODE,MOQD.LOT_NUMBER";
	}
	else if (REQTYPE.equals("MISC"))
	{
		if (ITEMTYPE.equals("OLD"))
		{
			sql = " SELECT TSC_INV_CATEGORY(MOQD.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
				  ",MSI.SEGMENT1 ITEM_NO"+
				  ",MSI.DESCRIPTION ITEM_DESC"+
				  ",MOQD.SUBINVENTORY_CODE"+
				  ",MOQD.LOT_NUMBER"+
				  ",MLN.DATE_CODE"+
				  //",MOQD.TRANSACTION_QUANTITY"+
				  //",MOQD.TRANSACTION_UOM_CODE"+
			      ",SUM(CASE WHEN MSI.ITEM_TYPE='FG' THEN CASE WHEN MSI.PRIMARY_UNIT_OF_MEASURE='KPC' AND MOQD.TRANSACTION_UOM_CODE='PCE' THEN MOQD.TRANSACTION_QUANTITY/1000 "+
                  "     WHEN MSI.PRIMARY_UNIT_OF_MEASURE='PCE' AND MOQD.TRANSACTION_UOM_CODE='KPC' THEN MOQD.TRANSACTION_QUANTITY*1000 ELSE MOQD.TRANSACTION_QUANTITY END"+
                  "    ELSE MOQD.TRANSACTION_QUANTITY END) TRANSACTION_QUANTITY"+
			      ",MSI.PRIMARY_UNIT_OF_MEASURE UOM"+
				  ",MP.ORGANIZATION_ID"+
				  ",MP.ORGANIZATION_CODE"+
				  ",MSI.ITEM_TYPE"+
				  " FROM INV.MTL_ONHAND_QUANTITIES_DETAIL MOQD,INV.MTL_SYSTEM_ITEMS_B MSI,INV.MTL_LOT_NUMBERS MLN,INV.MTL_PARAMETERS MP"+
				  " WHERE MOQD.ORGANIZATION_ID=MSI.ORGANIZATION_ID"+
				  " AND MOQD.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
				  " AND MOQD.ORGANIZATION_ID=MLN.ORGANIZATION_ID"+
				  " AND MOQD.INVENTORY_ITEM_ID=MLN.INVENTORY_ITEM_ID"+
				  " AND MOQD.ORGANIZATION_ID=MP.ORGANIZATION_ID"+
				  " AND MSI.SEGMENT1 = NVL(?,MSI.SEGMENT1)"+
				  " AND MSI.DESCRIPTION = NVL(?,MSI.DESCRIPTION)"+
				  " AND MOQD.LOT_NUMBER = NVL(?,MOQD.LOT_NUMBER)"+
				  " AND MOQD.LOT_NUMBER=MLN.LOT_NUMBER"+
				  " AND EXISTS (SELECT 1 FROM ORADDMAN.TSC_STOCK_TRANS_SUBINV X WHERE X.TRANS_TYPE=? AND X.ORGANIZATION_CODE=MP.ORGANIZATION_CODE AND X.SUBINVENTORY_CODE=MOQD.SUBINVENTORY_CODE"+
				  "             AND NVL(X.ACTIVE_FLAG,'N')=?)"+
    			  " GROUP BY MOQD.INVENTORY_ITEM_ID"+
		    	  " ,MSI.SEGMENT1"+
                  " ,MSI.DESCRIPTION"+
                  " ,MOQD.SUBINVENTORY_CODE"+
                  " ,MOQD.LOT_NUMBER"+
                  " ,MLN.DATE_CODE"+
                  " ,MSI.PRIMARY_UNIT_OF_MEASURE"+
                  " ,MP.ORGANIZATION_ID"+
                  " ,MP.ORGANIZATION_CODE"+				  
				  " ,MSI.ITEM_TYPE"+
		    	  " ORDER BY MSI.DESCRIPTION,MOQD.SUBINVENTORY_CODE,MOQD.LOT_NUMBER";
		}
		else
		{
			sql = "SELECT TSC_INV_CATEGORY(MSI.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
                  ",MSI.SEGMENT1 ITEM_NO"+
                  ",MSI.DESCRIPTION ITEM_DESC"+
                  ",MSI.ITEM_TYPE"+
                  ",MP.ORGANIZATION_ID"+
                  ",MP.ORGANIZATION_CODE"+
   		          ",MSI.PRIMARY_UNIT_OF_MEASURE UOM"+				  
                  " FROM INV.MTL_SYSTEM_ITEMS_B MSI,INV.MTL_PARAMETERS MP"+
                  " WHERE MSI.ORGANIZATION_ID=MP.ORGANIZATION_ID"+
				  " AND MSI.ORGANIZATION_ID=?"+
                  //" AND MSI.DESCRIPTION LIKE (SELECT CASE WHEN A.ITEM_TYPE ='FG' THEN TSC_GET_ITEM_DESC_NOPACKING(A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID) ELSE NVL(?,MSI.DESCRIPTION) END FROM INV.MTL_SYSTEM_ITEMS_B A WHERE A.SEGMENT1 =? AND A.ORGANIZATION_ID=?)||'%'"+
                  " AND MSI.SEGMENT1 =NVL(?,MSI.SEGMENT1)"+
                  //" AND MSI.SEGMENT1 <> ? "+
				  //" AND MSI.ITEM_TYPE=(SELECT ITEM_TYPE FROM INV.MTL_SYSTEM_ITEMS_B A WHERE A.SEGMENT1 =? AND A.ORGANIZATION_ID=?)"+
				  " ORDER BY MSI.DESCRIPTION";
                  //" AND MSI.DESCRIPTION = NVL(?,MSI.DESCRIPTION)"+
                  //" AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSX"+
                  //"             WHERE MSX.SEGMENT1 = NVL(?,MSX.SEGMENT1)"+
                  //"             AND MSX.DESCRIPTION = NVL(?,MSX.DESCRIPTION)"+
                  //"             AND MSX.ORGANIZATION_ID=NVL(?,MSX.ORGANIZATION_ID)"+
                  //"             AND TSC_INV_CATEGORY(MSX.INVENTORY_ITEM_ID,43,1100000003)=TSC_INV_CATEGORY(MSI.INVENTORY_ITEM_ID,43,1100000003)"+
                  //"             AND MSX.ORGANIZATION_ID=MSI.ORGANIZATION_ID"+
                  //"             AND MSX.ITEM_TYPE=MSI.ITEM_TYPE"+
                  //"             AND CASE WHEN MSX.ITEM_TYPE='FG' THEN TSC_GET_ITEM_DESC_NOPACKING(MSX.ORGANIZATION_ID,MSX.INVENTORY_ITEM_ID) ELSE 'XX' END =CASE WHEN MSX.ITEM_TYPE='FG' THEN TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID,MSI.INVENTORY_ITEM_ID) ELSE 'XX' END)";
		}
	}
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	if (!ITEMTYPE.equals("NEW"))
	{
		statement.setString(1,ITEMNAME);
		statement.setString(2,ITEMDESC);
		statement.setString(3,LOTNUM);
		if (REQTYPE.equals("SUBTRANS"))
		{		
			statement.setString(4,"01");
		}
		else if (REQTYPE.equals("MISC"))
		{
			statement.setString(4,"02");
		}
		else
		{
			statement.setString(4,"");
		}
		statement.setString(5,"A");
	}
	else
	{
		statement.setInt(1,Integer.parseInt(ORG));
		//statement.setString(2,NEWITEMDESC);
		//statement.setString(3,ITEMNAME);
		//statement.setInt(4,Integer.parseInt(ORG));
		statement.setString(2,NEWITEM);
		//statement.setString(3,ITEMNAME);
		//statement.setString(4,ITEMNAME);
		//statement.setInt(5,Integer.parseInt(ORG));
		if (REQTYPE.equals("SUBTRANS"))
		{		
			statement.setString(4,"A");
		}
	}
	ResultSet rs=statement.executeQuery();
	int vline=0;
	while (rs.next())
	{
		if (!ITEMTYPE.equals("NEW"))
		{	
			if (vline==0)
			{
				out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
				out.println("<TR bgcolor='#cccccc'>");
				out.println("<TH width='5%' style='font-size:11px;font-family:Tahoma,Georgia'>&nbsp;</TH>");        
				out.println("<TH width='7%' style='font-size:11px;font-family:Tahoma,Georgia'>TSC Prod Group</TH>");
				out.println("<TH width='25%' style='font-size:11px;font-family:Tahoma,Georgia'>Item Name</TH>");
				out.println("<TH width='16%' style='font-size:11px;font-family:Tahoma,Georgia'>Item Desc</TH>");
				out.println("<TH width='16%' style='font-size:11px;font-family:Tahoma,Georgia'>Lot Number</TH>");
				out.println("<TH width='7%' style='font-size:11px;font-family:Tahoma,Georgia'>Date Code</TH>");
				out.println("<TH width='5%' style='font-size:11px;font-family:Tahoma,Georgia'>ORG</TH>");
				out.println("<TH width='6%' style='font-size:11px;font-family:Tahoma,Georgia'>Subinv Code</TH>");
				out.println("<TH width='8%' style='font-size:11px;font-family:Tahoma,Georgia'>Qty</TH>");
				out.println("<TH width='5%' style='font-size:11px;font-family:Tahoma,Georgia'>UOM</TH>");
				out.println("</TR>");
			}
			out.println("<TR id='tr_"+vline+"'>");
			out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:11px;font-family:Tahoma,Georgia' onclick="+'"'+"setSubmit('"+vline+"','"+ISEQ+"')"+'"'+"><input type='hidden' name='orgid_"+vline+"' value='"+rs.getString("organization_id")+"'></TD>");
			out.println("<TD id='prod_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ (rs.getString("ITEM_TYPE").equals("FG")?rs.getString("TSC_PROD_GROUP"):(rs.getString("ITEM_TYPE").equals("SA")?"半成品":"原物料"))+"</TD>");
			out.println("<TD id='item_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("ITEM_NO")+"</TD>");
			out.println("<TD id='desc_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("ITEM_DESC")+"</TD>");
			out.println("<TD id='lot_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("LOT_NUMBER")+"</TD>");
			out.println("<TD id='dc_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ (rs.getString("DATE_CODE")==null?"":rs.getString("DATE_CODE"))+"</TD>");
			out.println("<TD id='org_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("organization_code")+"</TD>");
			out.println("<TD id='subinv_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("SUBINVENTORY_CODE")+"</TD>");
			out.println("<TD id='qty_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("TRANSACTION_QUANTITY")+"</TD>");
			out.println("<TD id='uom_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("UOM")+"</TD>");
			out.println("</TR>");
		}
		else
		{
			if (vline==0)
			{
				out.println("<TABLE width='100%' border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
				out.println("<TR bgcolor='#cccccc'>");
				out.println("<TH width='5%' style='font-size:11px;font-family:Tahoma,Georgia'>&nbsp;</TH>");        
				out.println("<TH width='10%' style='font-size:11px;font-family:Tahoma,Georgia'>TSC Prod Group</TH>");
				out.println("<TH width='25%' style='font-size:11px;font-family:Tahoma,Georgia'>Item Name</TH>");
				out.println("<TH width='20%' style='font-size:11px;font-family:Tahoma,Georgia'>Item Desc</TH>");
				out.println("<TH width='5%' style='font-size:11px;font-family:Tahoma,Georgia'>UOM</TH>");
				out.println("</TR>");
			}
			out.println("<TR id='tr_"+vline+"'>");
			out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:11px;font-family:Tahoma,Georgia' onclick="+'"'+"setSubmit('"+vline+"','"+ISEQ+"')"+'"'+"><input type='hidden' name='orgid_"+vline+"' value='"+rs.getString("organization_id")+"'></TD>");
			out.println("<TD id='prod_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("TSC_PROD_GROUP")+"</TD>");
			out.println("<TD id='item_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("ITEM_NO")+"</TD>");
			out.println("<TD id='desc_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("ITEM_DESC")+"</TD>");
			out.println("<TD id='uom_"+vline+"' style='font-size:11px;font-family:Tahoma,Georgia'>"+ rs.getString("UOM")+"</TD>");
			out.println("</TR>");				
		}
		vline++;	
	}
	if (vline>0)
	{
		out.println("</TABLE>");	
	}
	else
	{
		out.println("<div><font color='red'>No data found!</font></div>");
	}
	rs.close();  
	statement.close();  
	if (vline==1)
	{
	%>
	 <script LANGUAGE="JavaScript">	
		setSubmit("<%=(vline-1)%>","<%=ISEQ%>");
	 </script>
	<%	
	}  
}
catch (Exception e)
{
	out.println("Exception3:"+e.getMessage());
}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
