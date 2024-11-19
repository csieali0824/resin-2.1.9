<%@ page language="java" import="java.sql.*,java.text.*"%>
<script language="JavaScript" type="text/JavaScript">
function optChange(optValue,objName)
{
	var subList=document.getElementById("SUBINV_LIST");
	for (m=document.MYFORM.elements[objName.replace("ORG","SUBINV")].options.length-1;m>0;m--) document.MYFORM.elements[objName.replace("ORG","SUBINV")].options[m]=null;
	document.MYFORM.elements[objName.replace("ORG","SUBINV")].options[0]=new Option("--","");
	for (var i=0; i<subList.options.length; i++)
	{
		if (subList.options[i].value == optValue)
		{
			var subcode = (subList.options[i].text).split(",");
			for (var j=0 ; j <subcode.length ; j++)
			{
				document.MYFORM.elements[objName.replace("ORG","SUBINV")].options[j+1]=new Option(subcode[j],subcode[j]);
				if (subcode.length==1)
				{
					document.MYFORM.elements[objName.replace("ORG","SUBINV")].options[j+1].selected=true;
				}
			}
			break;
	 	}	
	}
}
function subStockItemFind(vline)
{
	subWin=window.open("../jsp/subwindow/TSCStockTransItemInfo.jsp?REQTYPE=SUBTRANS&ITEMNAME="+document.MYFORM.elements["ORIG_ITEM_NAME_"+vline].value+"&ITEMDESC="+document.MYFORM.elements["ORIG_ITEM_DESC_"+vline].value+"&LOTNUM="+document.MYFORM.elements["ORIG_LOT_"+vline].value+"&ISEQ="+vline,"subwin","width=800,height=300,scrollbars=yes,menubar=no");  
}
function setAmt(vline)
{
	var iqty=0,iprice=0,iamt=0;
	document.MYFORM.elements["AMT_"+vline].value="";
	if (document.MYFORM.elements["QTY_"+vline].value!="")
	{
		//if (document.MYFORM.elements["UOM_"+vline].value=="KPC" || document.MYFORM.elements["UOM_"+vline].value=="K")
		//{
		//	iqty = eval(document.MYFORM.elements["QTY_"+vline].value)*1000;
		//}
		//else
		//{
			iqty = eval(document.MYFORM.elements["QTY_"+vline].value);
		//}
		if (document.MYFORM.elements["UNITPRICE_"+vline].value!="")
		{
			iprice=eval(document.MYFORM.elements["UNITPRICE_"+vline].value)*100;
			iprice=Math.round(iprice)/100;
			document.MYFORM.elements["UNITPRICE_"+vline].value=iprice;
			//iprice=eval(document.MYFORM.elements["UNITPRICE_"+vline].value)/1000;
			iprice=eval(document.MYFORM.elements["UNITPRICE_"+vline].value); //MODIFY BY PEGGY 20201211
			iamt=eval(iqty)*eval(iprice);
			document.MYFORM.elements["AMT_"+vline].value= Math.round(iamt);
		}
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
		StockB=new String[def_row][16];
	}
	for (int i = 0 ; i < StockB.length ;i ++)
	{
		if (ACTIONCODE.equals("NEW"))
		{	
			for (int j=0 ; j < 16 ; j ++)
			{
				StockB[i][j]="";
			}
		}
		else
		{
			StockB[i][0]=(request.getParameter("TSC_PROD_"+(i+1))==null?"":request.getParameter("TSC_PROD_"+(i+1)));		
			StockB[i][1]=(request.getParameter("ORIG_ITEM_NAME_"+(i+1))==null?"":request.getParameter("ORIG_ITEM_NAME_"+(i+1)));		
			StockB[i][2]=(request.getParameter("ORIG_ITEM_DESC_"+(i+1))==null?"":request.getParameter("ORIG_ITEM_DESC_"+(i+1)));		
			StockB[i][3]=(request.getParameter("ORIG_LOT_"+(i+1))==null?"":request.getParameter("ORIG_LOT_"+(i+1)));		
			StockB[i][4]=(request.getParameter("ORIG_DC_"+(i+1))==null?"":request.getParameter("ORIG_DC_"+(i+1)));		
			StockB[i][5]=(request.getParameter("ORIG_ORG_"+(i+1))==null?"":request.getParameter("ORIG_ORG_"+(i+1)));		
			StockB[i][6]=(request.getParameter("ORIG_SUBINV_"+(i+1))==null?"":request.getParameter("ORIG_SUBINV_"+(i+1)));		
			StockB[i][7]="";		
			StockB[i][8]="";
			StockB[i][9]=(request.getParameter("NEW_ORG_"+(i+1))==null?"":request.getParameter("NEW_ORG_"+(i+1)));		
			StockB[i][10]=(request.getParameter("NEW_SUBINV_"+(i+1))==null?"":request.getParameter("NEW_SUBINV_"+(i+1)));		
			StockB[i][11]=(request.getParameter("QTY_"+(i+1))==null?"":request.getParameter("QTY_"+(i+1)));		
			StockB[i][12]=(request.getParameter("UOM_"+(i+1))==null?"":request.getParameter("UOM_"+(i+1)));		
			StockB[i][13]=(request.getParameter("REQ_REASON_"+(i+1))==null?"":request.getParameter("REQ_REASON_"+(i+1)));		
			StockB[i][14]=(request.getParameter("UNITPRICE_"+(i+1))==null?"":request.getParameter("UNITPRICE_"+(i+1)));		
			StockB[i][15]=(request.getParameter("AMT_"+(i+1))==null?"":request.getParameter("AMT_"+(i+1)));	
		}	
	}
	StockBean.setArray2DString(StockB);
}

%>
<table width="100%">
	<tr><td width="25%"><img src="images/logo.PNG"></td><td width="50%" align="center" style="font-weight:bold;font-family:'細明體';font-size:28px">台灣半導體股份有限公司</td><td width="25%">&nbsp;</td></tr>
	<tr><td>&nbsp; </td>
	<td align="center" style="font-family:'細明體';font-size:24px">轉倉通知單</td>
	<td>&nbsp;</td></tr>
	<tr><td>&nbsp; </td><td>&nbsp;</td>
	<td align="right" style="font-family:'Tahoma,Georgia';font-size:12px">申請日期:民國&nbsp;&nbsp;<%=iYear-1911%>&nbsp;&nbsp;年&nbsp;&nbsp;<%=iMonth%>&nbsp;&nbsp;月&nbsp;&nbsp;<%=iDay%>&nbsp;&nbsp;日</td></tr>
	<tr><td colspan="3">
			<table width="100%" border="1" cellspacing="0" cellpadding="1">
				<tr bgcolor="#D5ECB0" style="font-family:Tahoma,Georgia">
					<td width="4%" align="center">項次</td>
					<td width="4%" align="center">產品別</td>
					<td width="16%" align="center">料號(22D/30D)</td>
					<td width="13%" align="center">品名規格</td>
					<td width="10%" align="center">Lot Number</td>
					<td width="5%" align="center">Date Code</td>
					<td width="5%" align="center">移出Org</td>
					<td width="4%" align="center">移出倉別</td>
					<td width="5%" align="center">移入Org</td>
					<td width="4%" align="center">移入倉別</td>
					<td width="6%" align="center">數量</td>
					<td width="3%" align="center">單位</td>
					<td width="12%" align="center">移轉原因</td>
					<td width="4%" align="center">單價</td>
					<td width="5%" align="center">Amt(NTD)</td>
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
					<td><%=iseq%><input type="checkbox" name="chk1" value="<%=iseq%>" checked style="visibility:hidden"></td>
					<td><input type="text" name="TSC_PROD_<%=iseq%>" value="<%=StockA[i][0]%>" size="8" style="font-size:11px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="ORIG_ITEM_NAME_<%=iseq%>" value="<%=StockA[i][1]%>" size="32" style="font-size:11px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn0_<%=iseq%>" VALUE=".."  style="font-size:11px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>)"></td>
					<td><input type="text" name="ORIG_ITEM_DESC_<%=iseq%>" value="<%=StockA[i][2]%>" size="23" style="font-size:11px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn1_<%=iseq%>" VALUE=".."  style="font-size:11px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>)"></td>
					<td><input type="text" name="ORIG_LOT_<%=iseq%>" value="<%=StockA[i][3]%>" size="16" style="font-size:11px;font-family:Tahoma,Georgia;">
					<INPUT TYPE="button"  NAME="btn2_<%=iseq%>" VALUE=".."  style="font-size:11px;font-family:Tahoma,Georgia;" onClick="subStockItemFind(<%=iseq%>)"></td>
					<td><input type="text" name="ORIG_DC_<%=iseq%>" value="<%=StockA[i][4]%>" size="7" style="font-size:11px;font-family:Tahoma,Georgia;"></td>
					<td>
					<select NAME="ORIG_ORG_<%=iseq%>" style="font-size:11px;font-family:Tahoma,Georgia;">
						<OPTION VALUE="" <%=(request.getParameter("ORIG_ORG_"+iseq)==null?" selected":"")%>>--</OPTION>
					<%
						if (rsOrg.isBeforeFirst() ==false) rsOrg.beforeFirst();
						while (rsOrg.next())
						{	
					%>
							<OPTION VALUE="<%=rsOrg.getString("ORGANIZATION_ID")%>"  <%=(rsOrg.getString("ORGANIZATION_CODE").equals(StockA[i][5])||rsOrg.getString("ORGANIZATION_ID").equals(StockA[i][5])?"selected":"")%>><%=rsOrg.getString("ORGANIZATION_CODE")%></OPTION>
					<%
						}	
					%>
					</select>					
					</td>
					<td><input type="text" name="ORIG_SUBINV_<%=iseq%>" value="<%=StockA[i][6]%>" size="5" style="font-size:11px;font-family:Tahoma,Georgia;"></td>
					<td>
					<select NAME="NEW_ORG_<%=iseq%>" style="font-size:11px;font-family:Tahoma,Georgia;" onChange="optChange(this.value,'NEW_ORG_<%=iseq%>');">
						<OPTION VALUE="" <%=(request.getParameter("NEW_ORG_"+iseq)==null?" selected":"")%>>--</OPTION>
					<%
						if (rsOrg.isBeforeFirst() ==false) rsOrg.beforeFirst();
						while (rsOrg.next())
						{	
					%>
							<OPTION VALUE="<%=rsOrg.getString("ORGANIZATION_ID")%>" <%=(rsOrg.getString("ORGANIZATION_CODE").equals(StockA[i][9])||rsOrg.getString("ORGANIZATION_ID").equals(StockA[i][9])?"selected":"")%>><%=rsOrg.getString("ORGANIZATION_CODE")%></OPTION>
					<%
						}	
					%>
					</select>
					</td>
					<td><input type="text" name="NEW_SUBINV_<%=iseq%>" value="<%=StockA[i][10]%>" size="5" style="font-size:11px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="QTY_<%=iseq%>" value="<%=StockA[i][11]%>" size="8" style="text-align:right;font-size:11px;font-family:Tahoma,Georgia;" onBlur="setAmt(<%=iseq%>)" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)"></td>
					<td><input type="text" name="UOM_<%=iseq%>" value="<%=StockA[i][12]%>" size="6" style="text-align:center;font-size:11px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="REQ_REASON_<%=iseq%>" value="<%=StockA[i][13]%>" size="24" style="font-size:11px;font-family:Tahoma,Georgia;"></td>
					<td><input type="text" name="UNITPRICE_<%=iseq%>" value="<%=(StockA[i][14]==null?"":StockA[i][14])%>" size="6" style="font-size:11px;font-family:Tahoma,Georgia;" onBlur="setAmt(<%=iseq%>)" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)"></td>
					<td><input type="text" name="AMT_<%=iseq%>" value="<%=(StockA[i][15]==null?"":StockA[i][15])%>" size="8" style="font-size:11px;font-family:Tahoma,Georgia;" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)"></td>
				</tr>
				<%
					}
				}
				%>
			</table>
		</td>
	</tr>
</table>


