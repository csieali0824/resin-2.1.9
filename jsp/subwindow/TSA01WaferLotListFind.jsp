<!--20170316 Peggy,(R)工程退料(327)=>(R)研發退料(130) for mohow-->
<!--20170814 Peggy,新增21 : 原物料-重驗合格倉 22 : 半成品-重驗合格倉-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="WaferBean" scope="session" class="Array2DimensionInputBean"/>
<!--<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<%
String sql = "";
String ITEMID  =request.getParameter("ITEMID");
if (ITEMID==null) ITEMID="";
String UOM  =request.getParameter("UOM");
if (UOM==null) UOM="";
String ITEM_NAME = request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String ORGANIZATION_ID= request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="";
String LINENO = request.getParameter("LINENO");
if (LINENO==null ) LINENO="";
String REQQTY = request.getParameter("REQQTY");
if (REQQTY==null) REQQTY="";
String PTYPE = request.getParameter("PTYPE");
if (PTYPE ==null) PTYPE="";
String DEF_LINE = request.getParameter("DEF_LINE");
if (DEF_LINE==null) DEF_LINE="10";
String CHK_CNT = request.getParameter("CHK_CNT");
if (CHK_CNT==null) CHK_CNT="0";
String WIPNO = request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String CTYPENO = request.getParameter("CTYPENO");  //add by Peggy 20161207
if (CTYPENO==null) CTYPENO=""; 
String TRANS_TYPE = request.getParameter("TRANS_TYPE");    //add by Peggy 20170630
if (TRANS_TYPE==null) TRANS_TYPE="";
String TRANS_SOURCE_ID = request.getParameter("TRANS_SOURCE_ID");   //add by Peggy 20170630
if (TRANS_SOURCE_ID==null) TRANS_SOURCE_ID="";
String SUBINVENTORY_CODE=request.getParameter("SUBINVENTORY_CODE");  //add by Peggy 20170630
if (SUBINVENTORY_CODE==null) SUBINVENTORY_CODE="";
%>
<html>
<head>
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
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSA01 Wafer Lot List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1()
{
	var lot_list="";
	var chk_cnt =0;
	var tot_allot_qty=0;
	var list_name="";
	for (var i=1; i<= eval(document.SUBFORM.DEF_LINE.value) ; i++)
	{
		if (document.SUBFORM.elements["LOT_"+i].value!=null && document.SUBFORM.elements["LOT_"+i].value!="")
		{
			if (document.SUBFORM.elements["LOT_QTY_"+i].value ==null || document.SUBFORM.elements["LOT_QTY_"+i].value =="" || isNaN(document.SUBFORM.elements["LOT_QTY_"+i].value))
			{
				alert("請輸入數字型態!!");
				document.SUBFORM.elements["LOT_QTY_"+i].focus();
				return false;
			}
			tot_allot_qty = parseFloat(tot_allot_qty) + parseFloat(document.SUBFORM.elements["LOT_QTY_"+i].value);
			if (lot_list.length>0) lot_list +="\n";
			lot_list += document.SUBFORM.elements["LOT_"+i].value + "   "+document.SUBFORM.elements["LOT_QTY_"+i].value+document.SUBFORM.UOM.value;
			chk_cnt++;
		}
	}
	if (document.SUBFORM.CTYPENO.value!="C008")
	{
		list_name="LOT_LIST_";
		if (tot_allot_qty < parseFloat(document.SUBFORM.REQQTY.value))
		{
			alert("分配量必須大於等於工單用量!!");
			return false;
		}
	}
	else
	{
		list_name="EE_LOT_LIST_";
	}
	document.SUBFORM.submit1.disabled= true;
	document.SUBFORM.cancel1.disabled= true;
	window.opener.document.MYFORM.elements[list_name+document.SUBFORM.LINENO.value].value = lot_list;
	document.SUBFORM.action="TSA01WaferLotListFind.jsp?PTYPE=SAVE&CHK_CNT="+chk_cnt;
	document.SUBFORM.submit();	
}
function setClose()
{
	//window.opener.document.getElementById("alpha").style.width="0%";
	//window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
function toUpper(objname)
{
	var i_exist=0;
	if (objname!=null)
	{
		document.SUBFORM.elements[objname].value = document.SUBFORM.elements[objname].value.toUpperCase();
	}
	//add by Peggy 20161202
	for (var i =0 ; i < document.getElementById("LOT_LIST").options.length; i ++)
	{
		if (document.getElementById("LOT_LIST").options[i].value==document.SUBFORM.elements[objname].value )
		{
			document.SUBFORM.elements[objname.replace("LOT","ONHAND")].value=document.getElementById("LOT_LIST").options[i].text;
			document.SUBFORM.elements[objname.replace("LOT","ONHAND")].style.color="#0000ff";
			i_exist =1;
		}
	}
	if (i_exist==0)
	{
		document.SUBFORM.elements[objname.replace("LOT","ONHAND")].value="0";
		document.SUBFORM.elements[objname.replace("LOT","ONHAND")].style.color="#ff0000";
	}
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSA01WaferLotListFind.jsp" NAME="SUBFORM">
<%
if (!PTYPE.equals("SAVE"))
{
	sql= " SELECT a.lot_number,"+
         //" SUM(a.transaction_quantity)||' '||a.transaction_uom_code onhand"+
		 " SUM(a.transaction_quantity) onhand"+
         " FROM inv.mtl_onhand_quantities_detail a"+
         " WHERE INVENTORY_ITEM_ID=? "+
		 " AND ORGANIZATION_ID=? "+
		 " AND SUBINVENTORY_CODE IN (?,?,?,?)"+
         " GROUP BY a.inventory_item_id, a.organization_id, a.lot_number,a.transaction_uom_code";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,ITEMID);
	statement.setString(2,ORGANIZATION_ID);
	statement.setString(3,"01");
	statement.setString(4,"02");
	statement.setString(5,"21");
	statement.setString(6,"22");
	ResultSet rs=statement.executeQuery();
	int icnt=0;
	while (rs.next())
	{
		if (icnt ==0)
		{		
			out.println("<select NAME='LOT_LIST' style='visibility:hidden'>");				  				  
		}
        out.println("<OPTION VALUE='"+rs.getString(1)+"'>"+rs.getString(2));
		icnt++;
	} 
	if (icnt>0)
	{
		out.println("</select>");  
	}
	rs.close();
	statement.close();
	
	//add by Peggy 20170630
	sql = " SELECT Y.TYPE_NAME,Y.TYPE_VALUE,X.TYPE_ATTRIBUTE1 "+
	      " FROM (SELECT  type_name, type_value, type_group,TYPE_ATTRIBUTE1"+
          "        FROM oraddman.tsa01_base_setup a"+
          "        WHERE  type_name LIKE 'T%' AND TYPE_CODE IN ('TRANS_TYPE')) x"+
          "        ,(SELECT type_name, type_value, type_group,"+
          "         type_desc  FROM oraddman.tsa01_base_setup a  "+
          "        WHERE TYPE_CODE IN  ('TRANS_SOURCE_ID')) Y"+
          " WHERE X.TYPE_VALUE=Y.TYPE_NAME(+)"+
          "  AND X.TYPE_GROUP=Y.TYPE_GROUP(+)"+
          "  AND X.TYPE_GROUP=?"+
          "  AND ? LIKE X.TYPE_NAME||'%'";
	statement = con.prepareStatement(sql);
	statement.setString(1,CTYPENO);
	statement.setString(2,WIPNO);
	rs=statement.executeQuery();
	if (rs.next())
	{	
		TRANS_TYPE = rs.getString(1);
		TRANS_SOURCE_ID = rs.getString(2);	
		SUBINVENTORY_CODE= rs.getString(3);
	}
	else
	{
		TRANS_TYPE ="";TRANS_SOURCE_ID="";SUBINVENTORY_CODE="";
	}
	rs.close();	  
	statement.close();
%>
<table width="100%">
	<tr>
		<td>
			<div id="div1" style="font-size:12px">料號：<%=ITEM_NAME%></div>
			<font style='color:#000000;font-family:Tahoma,Georgia; font-size: 12px'>需求量：<%=REQQTY%><%=UOM%></font><input type="hidden" name="REQQTY" value="<%=REQQTY%>"><INPUT TYPE="hidden" name="ITEMID" value="<%=ITEMID%>">
			<TABLE border='1' width='100%' cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#ffffff'>
			<TR bgcolor='#cccccc' align='center'>
			<Td width='3%'>&nbsp;</Td>
			<Td width='10%'>LOT號</Td>
			<Td width='9%'>數量</Td>
			<Td width='10%'>備註</Td>
			<Td width='5%'>ERP庫存(K)</Td>
			</TR>
			<%
			String strarr[][] = new String[Integer.parseInt(DEF_LINE)][3];
			String ShipArray [][]=WaferBean.getArray2DContent();
			int rows=0;
			if (ShipArray!=null)
			{
				for( int i=0 ; i< ShipArray.length ; i++ ) 
				{
					if (ShipArray[i][0].equals(WIPNO) && ShipArray[i][1].equals(LINENO))
					{
						strarr[rows][0]=ShipArray[i][3];
						strarr[rows][1]=ShipArray[i][4];
						strarr[rows][2]=ShipArray[i][5];
						rows++;
					}
				}
			}
			for (int i =rows ; i <Integer.parseInt(DEF_LINE) ; i++ )
			{
				strarr[i][0]="";
				strarr[i][1]="";
				strarr[i][2]="";
			}
			for (int iline=0 ; iline <Integer.parseInt(DEF_LINE) ; iline++ )
			{
			%>
			<TR>
			<TD align='center'><%=(iline+1)%></TD>
			<TD align='center'><input type="text" name="LOT_<%=(iline+1)%>" value="<%=strarr[iline][0]%>" style="font-family: Tahoma,Georgia; color: #000000; font-size: 12px" onBlur="toUpper('LOT_<%=(iline+1)%>')"></TD>
			<TD align='center'><input type="text" name="LOT_QTY_<%=(iline+1)%>" value="<%=strarr[iline][1]%>" style="font-family: Tahoma,Georgia; color: #000000; font-size: 12px"></TD>
			<TD align='center'><input type="text" name="LOT_REMARKS_<%=(iline+1)%>" value="<%=strarr[iline][2]%>" style="font-family: Tahoma,Georgia; color: #000000; font-size: 12px"></TD>
			<TD align='center'><input type="text" name="ONHAND_<%=(iline+1)%>" value="" style="font-weight:bold;text-align:right;font-family: Tahoma,Georgia; color: #000000; font-size: 12px" size="5" readonly></TD>
			</TR>
			<%
			}
			%>
			</TABLE>
			<table border="0" width="100%">
			<tr><td align="center"><input type="button" name="submit1" value="確定" onClick="setSubmit1();">&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="取消" onClick="setClose()"></td></tr>
			</table>
		</td>
	</tr>
</table>
<%
}
else
{
	try
	{
		int tot_row  =0, del_cnt=0;
		String ShipArray [][]=WaferBean.getArray2DContent();
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				if (ShipArray[i][0].equals(WIPNO) && ShipArray[i][1].equals(LINENO)) del_cnt++;
			}
			tot_row = ShipArray.length + Integer.parseInt(CHK_CNT) - del_cnt;	
		}
		else
		{
			tot_row =Integer.parseInt(CHK_CNT);
		}
		String ship_tot [][] = new String [tot_row][10];
		int iLine=0;
		for (int i = 1 ; i <= Integer.parseInt(CHK_CNT) ; i++)
		{
			ship_tot[iLine][0] = WIPNO;
			ship_tot[iLine][1] = LINENO;
			ship_tot[iLine][2] = ITEMID;
			ship_tot[iLine][3] = request.getParameter("LOT_"+i);
			ship_tot[iLine][4] = request.getParameter("LOT_QTY_"+i);
			ship_tot[iLine][5] = request.getParameter("LOT_REMARKS_"+i);
			//ship_tot[iLine][6] = (CTYPENO.equals("C008")?"Y":"N");
			//ship_tot[iLine][7] = (CTYPENO.equals("C008")?"130":null);
			ship_tot[iLine][6] = (!TRANS_TYPE.equals("")?"Y":"N");
			ship_tot[iLine][7] = (!TRANS_TYPE.equals("")?TRANS_TYPE:null);
			ship_tot[iLine][8] = (!TRANS_SOURCE_ID.equals("")?TRANS_SOURCE_ID:null);
			ship_tot[iLine][9] = (!SUBINVENTORY_CODE.equals("")?SUBINVENTORY_CODE:null);
			iLine ++;
		} 
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				//out.println(ShipArray[i][0]);
				if (ShipArray[i][0].equals(WIPNO) && ShipArray[i][1].equals(LINENO)) continue;
				//out.println(ShipArray[i][0]);
				ship_tot[iLine][0] = ShipArray[i][0];
				ship_tot[iLine][1] = ShipArray[i][1];
				ship_tot[iLine][2] = ShipArray[i][2];
				ship_tot[iLine][3] = ShipArray[i][3];
				ship_tot[iLine][4] = ShipArray[i][4];
				ship_tot[iLine][5] = ShipArray[i][5];
				ship_tot[iLine][6] = ShipArray[i][6];
				ship_tot[iLine][7] = ShipArray[i][7];
				ship_tot[iLine][8] = ShipArray[i][8];
				ship_tot[iLine][9] = ShipArray[i][9];
				iLine ++;
			}
		}
		WaferBean.setArray2DString(ship_tot);
%>
		<script language="JavaScript" type="text/JavaScript">
			setClose();
		</script>
<%			
	}
	catch(Exception e)
	{
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}
}
%>
<INPUT TYPE="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
<INPUT TYPE="hidden" name="LINENO" value="<%=LINENO%>">
<INPUT TYPE="hidden" name="PTYPE" value="<%=PTYPE%>">
<INPUT TYPE="hidden" name="DEF_LINE" value="<%=DEF_LINE%>">
<INPUT TYPE="hidden" name="CHK_CNT" value="<%=CHK_CNT%>">
<INPUT TYPE="hidden" name="UOM" value="<%=UOM%>">
<INPUT TYPE="hidden" name="ITEM_NAME" value="<%=ITEM_NAME%>">
<INPUT TYPE="hidden" name="WIPNO" value="<%=WIPNO%>">
<INPUT TYPE="hidden" name="CTYPENO" value="<%=CTYPENO%>">
<INPUT TYPE="hidden" name="TRANS_TYPE" value="<%=TRANS_TYPE%>">
<INPUT TYPE="hidden" name="TRANS_SOURCE_ID" value="<%=TRANS_SOURCE_ID%>">
<INPUT TYPE="hidden" name="SUBINVENTORY_CODE" value="<%=SUBINVENTORY_CODE%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
