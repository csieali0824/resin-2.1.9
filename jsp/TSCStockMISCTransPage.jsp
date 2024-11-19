<%@ page language="java" import="java.sql.*,java.text.*"%>
<script language="JavaScript" type="text/JavaScript">
function subStockItemFind(vline,itemType)
{
	var orglist=document.getElementById("ORIG_ORG_"+vline);
	var orgid=orglist.options[orglist.selectedIndex].value;
	if (itemType=="OLD")
	{
		subWin=window.open("../jsp/subwindow/TSCStockTransItemInfo.jsp?REQTYPE=MISC&ITEMNAME="+document.MYFORM.elements["ORIG_ITEM_NAME_"+vline].value+"&ITEMDESC="+document.MYFORM.elements["ORIG_ITEM_DESC_"+vline].value+"&LOTNUM="+document.MYFORM.elements["ORIG_LOT_"+vline].value+"&ISEQ="+vline+"&NEWITEM="+document.MYFORM.elements["NEW_ITEM_NAME_"+vline].value+"&NEWITEMDESC="+document.MYFORM.elements["NEW_ITEM_DESC_"+vline].value+"&ITEMTYPE="+itemType+"&ORG="+orgid,"subwin","width=800,height=300,scrollbars=yes,menubar=no");  
	}
	else
	{
		subWin=window.open("../jsp/subwindow/TSCStockTransItemInfo.jsp?REQTYPE=MISC&ITEMNAME="+document.MYFORM.elements["ORIG_ITEM_NAME_"+vline].value+"&ITEMDESC="+document.MYFORM.elements["ORIG_ITEM_DESC_"+vline].value+"&LOTNUM="+document.MYFORM.elements["ORIG_LOT_"+vline].value+"&ISEQ="+vline+"&NEWITEM="+document.MYFORM.elements["NEW_ITEM_NAME_"+vline].value+"&NEWITEMDESC="+document.MYFORM.elements["NEW_ITEM_DESC_"+vline].value+"&ITEMTYPE="+itemType+"&ORG="+orgid,"subwin","width=500,height=200,scrollbars=no,menubar=no");  
	}	
}
</script>
<%
if (!ACTIONCODE.equals("UPLOAD"))
{
	String StockA[][]=StockBean.getArray2DContent();
	String [][] StockB=null;
	if (StockA!=null)
	{
		StockB=new String[StockA.length][16];
	}
	else
	{
		StockB=new String[def_row][20];
	}
	for (int i = 0 ; i < StockB.length ;i ++)
	{
		for (int j=0 ; j < 20 ; j ++)
		{
			StockB[i][j]="";
		}
	}
	StockBean.setArray2DString(StockB);
}
%>
<table width="100%">
	<tr><td width="25%"><img src="images/logo.PNG"></td><td width="50%" align="center" style="font-weight:bold;font-family:'細明體';font-size:28px">台灣半導體股份有限公司</td><td width="25%">&nbsp;</td></tr>
	<tr><td>&nbsp; </td><td align="center" style="font-family:'細明體';font-size:24px">料號移轉(重分轉入)通知單</td><td>&nbsp;</td></tr>
	<tr><td>&nbsp; </td><td>&nbsp;</td>
	<td align="right" style="font-family:'Tahoma,Georgia';font-size:12px">申請日期:民國&nbsp;&nbsp;<%=iYear-1911%>&nbsp;&nbsp;年&nbsp;&nbsp;<%=iMonth%>&nbsp;&nbsp;月&nbsp;&nbsp;<%=iDay%>&nbsp;&nbsp;日</td></tr>
	<tr><td colspan="3">
			<table width="100%" border="1" cellspacing="0" cellpadding="1">
				<tr bgcolor="#E2D9CD" style="font-family:Tahoma,Georgia">
					<td width="4%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">項次</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">產品別</td>
					<td width="14%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉出料號(22D/30D)</td>
					<td width="10%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉出品名規格</td>
					<td width="8%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">Lot Number</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">D/C</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">數量</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">單位</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">Org</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">倉別</td>
					<td width="14%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉入<br>料號(22D/30D)</td>
					<td width="10%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉入<br>品名規格</td>
					<td width="6%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉入<br>Lot Number</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉入<br>D/C</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉入<br>數量</td>
					<td width="3%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">轉入<br>單位</td>
					<td width="7%" align="center" style="font-size:11px;font-family:Tahoma,Georgia">移轉原因</td>
				</tr>
				<%
				String StockA[][]=StockBean.getArray2DContent();
				if (StockA!=null)
				{
					for( int i=0 ; i< StockA.length ; i++ ) 
					{				
						iseq++;
				%>
				<tr>
					<td style="font-size:10px"><%=iseq%><input type="checkbox" name="chk1" value="<%=iseq%>" checked style="visibility:hidden"></td>
					<td><input type="text" name="TSC_PROD_<%=iseq%>" value="<%=StockA[i][0]%>" size="7" style="font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="ORIG_ITEM_NAME_<%=iseq%>" value="<%=StockA[i][1]%>" size="28" style="font-size:10px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn0_<%=iseq%>" VALUE=".."  style="font-size:9px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>,'OLD')"></td>
					<td><input type="text" name="ORIG_ITEM_DESC_<%=iseq%>" value="<%=StockA[i][2]%>" size="17" style="font-size:10px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn1_<%=iseq%>" VALUE=".."  style="font-size:9px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>,'OLD')"></td>
					<td><input type="text" name="ORIG_LOT_<%=iseq%>" value="<%=StockA[i][3]%>" size="12" style="font-size:9px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn2_<%=iseq%>" VALUE=".."  style="font-size:9px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>,'OLD')"></td>
					<td><input type="text" name="ORIG_DC_<%=iseq%>" value="<%=StockA[i][4]%>" size="6" style="font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="QTY_<%=iseq%>" value="<%=StockA[i][11]%>" size="6" style="font-size:10px;font-family:Tahoma,Georgia;" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)"></td>
					<td><input type="text" name="UOM_<%=iseq%>" value="<%=StockA[i][12]%>" size="4" style="text-align:center;font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td>
					<select ID="ORIG_ORG_<%=iseq%>" NAME="ORIG_ORG_<%=iseq%>" style="font-size:10px;font-family:Tahoma,Georgia;">
						<OPTION VALUE="" <%=(request.getParameter("ORIG_ORG_"+iseq)==null?" selected":"")%>>--</OPTION>
					<%
						if (rsOrg.isBeforeFirst() ==false) rsOrg.beforeFirst();
						while (rsOrg.next())
						{	
					%>
							<OPTION VALUE="<%=rsOrg.getString("ORGANIZATION_ID")%>" <%=(rsOrg.getString("ORGANIZATION_CODE").equals(StockA[i][5])?"selected":"")%>><%=rsOrg.getString("ORGANIZATION_CODE")%></OPTION>
					<%
						}	
					%>
					</select>					
					<td><input type="text" name="ORIG_SUBINV_<%=iseq%>" value="<%=StockA[i][6]%>" size="4" style="font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="NEW_ITEM_NAME_<%=iseq%>" value="<%=StockA[i][7]%>" size="28" style="font-size:10px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn3_<%=iseq%>" VALUE=".."  style="font-size:9px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>,'NEW')"></td>
					<td><input type="text" name="NEW_ITEM_DESC_<%=iseq%>" value="<%=StockA[i][8]%>" size="17" style="font-size:10px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn4_<%=iseq%>" VALUE=".."  style="font-size:9px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>,'NEW')"></td>
					<td><input type="text" name="NEW_LOT_<%=iseq%>" value="<%=StockA[i][16]%>" size="11" style="font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="NEW_DC_<%=iseq%>" value="<%=StockA[i][17]%>" size="6" style="font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="NEW_QTY_<%=iseq%>" value="<%=StockA[i][18]%>" size="6" style="font-size:10px;font-family:Tahoma,Georgia;" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)"></td>
					<td><input type="text" name="NEW_UOM_<%=iseq%>" value="<%=StockA[i][19]%>" size="4" style="text-align:center;font-size:10px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="REQ_REASON_<%=iseq%>" value="<%=StockA[i][13]%>" size="12" style="font-size:10px;font-family:Tahoma,Georgia;"></td>
				</tr>
				<%
					}
				}
				%>
			</table>
		</td>
	</tr>
</table>

