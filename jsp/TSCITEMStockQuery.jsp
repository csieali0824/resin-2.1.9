<%@ page contentType="text/html;charset=utf-8"  language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean,ComboBoxBean,"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>TSC Stock Query</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
	if ((document.MYFORM.ITEM.value==null ||  document.MYFORM.ITEM.value=="") && (document.MYFORM.TSCPRODGROUP.value==null ||document.MYFORM.TSCPRODGROUP.value=="" ||document.MYFORM.TSCPRODGROUP.value=="--"))
    {
		alert("Please input a value of the Item_No or Item_Description !!")
	 	document.MYFORM.ITEM.focus(); 
	 	return(false);
	} 
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(xItem,xOrgId)
{
	if(document.MYFORM.ORGANIZATIONID.value==null ||  document.MYFORM.ORGANIZATIONID.value=="--")
    {
		alert("Choose one of Organization!!")
	 	document.MYFORM.SHIPFROMORG.focus(); 
	 	return(false);
	} 

  	if(document.MYFORM.SHIPFROMORG.value=="163")
    {
		alert("Will take a long time!!")
	  	URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=5&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
	} 
	else
    {
		alert("Will take a long time!!");
	    URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=4&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
    }
  	document.MYFORM.action=URL;
  	document.MYFORM.submit();
}

function setSubmit2(URL)  //清除畫面條件,重新查詢!
{  
 	document.MYFORM.ITEM.value ="";
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit3(URL)  
{  
	if ((document.MYFORM.ITEM.value==null ||  document.MYFORM.ITEM.value=="") && (document.MYFORM.TSCPRODGROUP.value==null ||document.MYFORM.TSCPRODGROUP.value==""||document.MYFORM.TSCPRODGROUP.value=="--"))
    {
		alert("Please input a value of the Item_No or Item_Description !!")
	 	document.MYFORM.ITEM.focus(); 
	 	return(false);
	} 

 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function TSCINVI6StockDetail(itemid,typeId,subInv,orgId)
{            
    subWin=window.open("../jsp/TSCINVI6StockDetail.jsp?ITEM_ID="+itemid+"&TYPEID="+typeId+"&SUBINV="+subInv+"&ORGANIZATION_ID="+orgId,"subwin","top=0,left=0,width=1000,height=650,scrollbars=yes,menubar=no,status=yes");    	
}

function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
</script>
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
<%
String item = request.getParameter("ITEM");
if (item==null) item="";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
String TSCPRODGROUP = request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="--";  //add by Peggy 20131031
String OFILTER = request.getParameter("OFILTER");
if (OFILTER==null) OFILTER="--"; //add by Peggy 20131031
String ACODE = request.getParameter("ACODE");  //add by Peggy 20160518
if (ACODE==null) ACODE="";
String sSql = "";
String colorStr = "",fontcolor = "";
int icnt=0,pagewidth=0,LastPage =0,showCnt=0,btnCnt =0;
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String organizationId="",itemId="",invItem="",itemDesc="",woUom="",organizationCode="",fgOhQty="",unShipQty="",subInv="";
int NowPage = Integer.parseInt(QPage);
int PageSize = 50;
long dataCnt =0;
long sCnt = (NowPage-1) * PageSize;
long eCnt = NowPage * PageSize;
int rowcnt =0;
%>
</head>
<body>
<form name="MYFORM"  METHOD="post" ACTION="../jsp/TSCITEMStockQuery.jsp">
<table width="100%">
	<tr>
		<td>&nbsp;</td>
		<td align="center"><font color="#003366" size="+2" face="Tahoma,Georgia"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>Stock Query by Item</a></strong></font><br>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A href="/oradds/ORADDSMainMenu.jsp">Home</A>
</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">	
			<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
				<tr>
					<td width="20%" nowrap bgcolor="#BBD3E1" style="font-weight:bold;font-family:Tahoma,Georgia;color:#006666;">Input Item_No or Item_Description</td>
					<td width="20%"><input type="text" name="ITEM" style="font-family:Tahoma,Georgia" value="<%=item%>" size="20"></td>
					<td width="20%" nowrap bgcolor="#BBD3E1" style="font-weight:bold;font-family:Tahoma,Georgia;color:#006666;">TSC Prod Group</td>
					<td width="10%">
					<%
						//add by Peggy 20131031
						String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
						PreparedStatement pstmt=con.prepareStatement(sql1);
						pstmt.executeUpdate(); 
						pstmt.close();	
											
						try
						{   
							String sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1"+
										 " FROM MTL_CATEGORIES_V "+
										 " WHERE STRUCTURE_NAME='TSC_PROD_GROUP'"+
										 " AND DISABLE_DATE IS NULL order by SEGMENT1";
							Statement statement=con.createStatement();
							ResultSet rs=statement.executeQuery(sql);
							comboBoxBean.setRs(rs);
							comboBoxBean.setSelection(TSCPRODGROUP);
							comboBoxBean.setFieldName("TSCPRODGROUP");	 
							out.println(comboBoxBean.getRsString());
							rs.close();   
							statement.close();
						 } //end of try		 
						 catch (Exception e)
						 { 
							out.println("Exception:"+e.getMessage()); 
						 }  
						 String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
						 PreparedStatement pstmt2=con.prepareStatement(sql2);
						 pstmt2.executeUpdate(); 
						 pstmt2.close();			 
					%>		
					</td>
					<td width="20%" nowrap bgcolor="#BBD3E1" style="font-weight:bold;font-family:Tahoma,Georgia;color:#006666;">Other Filter</td>
					<td width="10%">
						<select NAME="OFILTER" style="font-family:Tahoma,Georgia;">				  
						<OPTION VALUE=--<%=(OFILTER.equals("--")?"selected":"")%> >--   
						<OPTION VALUE="1"<%=(OFILTER.equals("1")?"selected":"")%> >On hand Qty > Unship Qty				                                
						</select>	   
					</td>
				</tr>
				<tr>
					<td colspan="6" align="center">
						<INPUT TYPE="button" align="middle"  value='Query' style="font-family:Tahoma,Georgia" onClick='setSubmit("../jsp/TSCITEMStockQuery.jsp?ACODE=Q")' > 
						&nbsp;&nbsp;
						<INPUT TYPE="reset" name="RESET" align="middle"  value='Reset' style="font-family:Tahoma,Georgia" onClick='setSubmit2("../jsp/TSCITEMStockQuery.jsp")' >
						&nbsp;&nbsp;
						<INPUT TYPE="button" name="EXCEL" align="middle"  value='Export To Excel' style="font-family:Tahoma,Georgia" onClick='setSubmit3("../jsp/TSCITEMStockExcel.jsp")' >
					</td>
				</tr>
			</table>
		</td>
		<td width="50%">&nbsp;</td>
	</tr>
<%
		if (ACODE.equals("Q"))	
		{
			try
			{
				sSql = "select * from (SELECT 'ERP' source_stock,mp.organization_code,"+
                       "         msi.organization_id,"+
                       "         msi.inventory_item_id,"+
                       "         msi.segment1 item_no,"+
                       "         msi.description,"+
                       "         TSC_INV_Category(msi.inventory_item_id,43,'1100000003') TSC_Prod_Group,"+
                       //"         TSC_INV_Category(msi.inventory_item_id,msi.organization_id,'21') TSC_Family,"+
                       //"         TSC_INV_Category(msi.inventory_item_id,msi.organization_id,'1100000004') TSC_Prod_Family,"+
                       "         TSC_INV_Category(msi.inventory_item_id,43,'23') TSC_Package,"+
                       "         case when msi.primary_unit_of_measure='PCE' THEN 'KPC' ELSE msi.primary_unit_of_measure END AS uom,"+
                       "         NVL ((SELECT SUM (moq.TRANSACTION_QUANTITY/case when TRANSACTION_UOM_CODE='PCE' THEN 1000 ELSE 1 END) FROM mtl_onhand_quantities_detail moq WHERE  moq.organization_id = msi.organization_id  AND moq.inventory_item_id = msi.inventory_item_id),0) onhand_qty,"+
                       "         NVL ((SELECT SUM (DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000, ordered_quantity)) FROM oe_order_lines_all ool WHERE ool.line_category_code = 'ORDER' AND ool.cancelled_flag = 'N' AND ool.flow_status_code IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE') AND ool.ship_from_org_id = msi.organization_id  AND ool.inventory_item_id = msi.inventory_item_id),0)  unship_qty"+
					   "         ,'' customer,'' item_info"+
                       "         FROM mtl_system_items msi,"+
					   "         mtl_parameters mp"+
                       "         WHERE msi.organization_id = mp.organization_id"+
					   //"         and msi.organization_id NOT IN (46, 386,807)";
					   "         and msi.organization_id NOT IN (46, 386)";
				if (item !=null && !item.equals(""))
				{
					sSql += " and ( MSI.SEGMENT1 LIKE upper('%"+item.trim()+"%') or MSI.DESCRIPTION like upper('%"+item.trim()+"%')) ";
				}		
				sSql += " union all"+
				        " select 'Out Side' source_stock ,a.AREA organization_code,"+
						" 0 organization_id,"+
						" a.inventory_item_id,"+
                        " a.item_name item_no,"+
                        " a.item_desc description,"+
                        " TSC_INV_Category(a.inventory_item_id,43,'1100000003') TSC_Prod_Group,"+
                        //" TSC_INV_Category(a.inventory_item_id,49,'21') TSC_Family,"+
                        //" TSC_INV_Category(a.inventory_item_id,49,'1100000004') TSC_Prod_Family,"+
                        " TSC_INV_Category(a.inventory_item_id,43,'23') TSC_Package,"+
                        " 'KPC' uom,"+
						" A.QTY/1000 onhand_qty,"+
						" 0 unship_qty"+
					    " ,a.customer,a.DATE_CODE||case when a.DATE_CODE is null then '' else '/' end ||a.LOT_NUMBER item_info"+
						" from oraddman.tsc_wws_stock_detail a,oraddman.tsc_wws_stock_header  b"+
						" where a.VERSION_ID=b.VERSION_ID"+
						" and VERSION_FLAG='A'";
				if (item !=null && !item.equals(""))
				{
					sSql += " and ( a.item_name LIKE upper('%"+item.trim()+"%') or a.item_desc like upper('%"+item.trim()+"%')) ";
				}								   
				sSql +="         ) x "+
                       " where ONHAND_QTY+UNSHIP_QTY >0";
				if (!TSCPRODGROUP.equals("") && !TSCPRODGROUP.equals("--"))
				{					   
					sSql+=" and  TSC_Prod_Group='"+TSCPRODGROUP+"'";
				}
				if (OFILTER.equals("1"))
				{				
                	sSql+=" and ONHAND_QTY-UNSHIP_QTY >0";
				}
				sSql+=" order by 1,5,4,6,2";
				//out.println(sSql);
				String sqlt = " select count(1) rowcnt from ("+sSql+") ss";
				Statement statement1=con.createStatement(); 
				ResultSet rs1 =statement1.executeQuery(sqlt);
				//out.println(sqlt);
				while (rs1.next())
				{
					//總筆數
					dataCnt = Long.parseLong(rs1.getString("rowcnt"));
					//最後頁數
					LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
				}
				rs1.close();
				statement1.close();
				
				//out.println(sSql);
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sSql);
				while(rs.next())
				{
					rowcnt ++;
					if (rowcnt >= (sCnt+1) && rowcnt <= eCnt)
					{
						if (icnt ==0)
						{
							out.println("<tr>");
							out.println("<td>&nbsp;</td><td><table width='100%'><tr><td width='30%'><font face='細明體' color='#CC0066' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font></td><td width='40%' align='center'>");
							if (LastPage==1)
							{
								FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
							}
							else if (NowPage == 1)
							{
								FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
							}
							else if (NowPage == LastPage)
							{
								FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
							}				
							else
							{
								FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
							}
							out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?ACODE=Q&QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
							out.println("&nbsp;");
							out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?ACODE=Q&QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
							out.println("&nbsp;&nbsp;<font face='細明體' color='#CC0066' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
							out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?ACODE=Q&QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
							out.println("&nbsp;");
							out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?ACODE=Q&QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
							out.println("</td><td width='30%'>&nbsp;</td>");		
							out.println("</tr></table></td><td>&nbsp;</td></tr>");
	%>
		<tr>
			<td width="5%">&nbsp;</td>
			<td width="90%">	
				<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
					<tr bgcolor="#BBD3E1"> 
						<td width="3%" height="22" nowrap><div align="center"><font color="#000000" face="Tahoma,Georgia">&nbsp;</font></div></td> 
						<td width="5%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Stock Source</div></td>
						<td width="14%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Item No</div></td>
						<td width="12%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Description</div></td>           
						<td width="8%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">TSC Prod Group</div></td>           
						<td width="10%" nowrap style="font-family:Tahoma,Georgial;color:#006666;"><div align="center">TSC Package</div></td>           
						<td width="10%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Organizaton</div></td>
						<td width="5%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">UOM</div></td> 
						<td width="6%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">On Hand Qty</div></td>
						<td width="6%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Unship Qty</div></td>
						<td width="10%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Customer</div></td>           
						<td width="15%" nowrap style="font-family:Tahoma,Georgia;color:#006666;"><div align="center">Date Code/Lot</div></td>           
					</tr>
	<%
						}
						itemId=rs.getString("INVENTORY_ITEM_ID");
						invItem=rs.getString("ITEM_NO");
						itemDesc=rs.getString("DESCRIPTION");
						woUom=rs.getString("UOM");
						organizationId=rs.getString("ORGANIZATION_ID");
						organizationCode=rs.getString("ORGANIZATION_CODE");
						fgOhQty=rs.getString("ONHAND_QTY");
						unShipQty=rs.getString("UNSHIP_QTY");
						if (invItem==null || invItem.equals("")) invItem="&nbsp"; 
						if (itemDesc==null || itemDesc.equals("")) itemDesc="&nbsp"; 
						if (woUom==null || woUom.equals("")) woUom="&nbsp"; 
						if (fgOhQty==null || fgOhQty.equals("")) fgOhQty="&nbsp";
						if (unShipQty==null || unShipQty.equals("")) unShipQty="&nbsp";
						icnt ++;
						if ((icnt % 2) == 0)
						{
							colorStr = "#E0F0FE"; 
						}
						else
						{
							colorStr = "#D8E6E7";
						}
	%>
					<tr bgcolor="<%=colorStr%>"> 
						<td ><div align="center" style="font-family:Tahoma,Georgia;color:#006666"><%=(NowPage-1)*PageSize+icnt%></div></td>
						<td <%=(!rs.getString("source_stock").equals("ERP")?"style='background-color:#EEF565'":"")%>><%=rs.getString("source_stock")%></td>
						<td ><div align="left" style="font-family:Tahoma,Georgia;color:#006666">&nbsp;<%=invItem%></div></td>
						<td ><div align="left" style="font-family:Tahoma,Georgia;color:#006666">&nbsp;<%=itemDesc%></div></td>
						<td ><div align="left" style="font-family:Tahoma,Georgia;color:#006666">&nbsp;<%=(rs.getString("tsc_prod_group")==null?"&nbsp;":rs.getString("tsc_prod_group"))%></div></td>
						<td ><div align="left" style="font-family:Tahoma,Georgia;color:#006666">&nbsp;<%=(rs.getString("tsc_package")==null?"&nbsp;":rs.getString("tsc_package"))%></div></td>
						<td ><div align="center" style="font-family:Tahoma,Georgia;color:#006666">&nbsp;<%=organizationCode%></font></div></td>
						<td ><div align="center" style="font-family:Tahoma,Georgia;color:#006666"><%=woUom%></div></td>
						<td ><div align="right" style="font-family:Tahoma,Georgia;color:#006666">
						<%
						if (rs.getString("source_stock").equals("ERP"))
						{
						%>
						<a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=4%>','<%=subInv%>','<%=organizationId%>')">
						<%
						}
						%>
						<%=fgOhQty%>
						<%
						if (rs.getString("source_stock").equals("ERP"))
						{
						%>						
						</a>
						<%
						}
						%>
						</div></td>
						<td ><div align="right" style="font-family:Tahoma,Georgia;color:#006666">
						<%
						if (rs.getString("source_stock").equals("ERP"))
						{
						%>						
						<a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=3%>','<%=subInv%>','<%=organizationId%>')">
						<%
						}
						%>
						<%=unShipQty%>
						<%
						if (rs.getString("source_stock").equals("ERP"))
						{
						%>						
						</a>
						<%
						}
						%>
						</div></td>	
						<td ><div align="left" style="font-family:Tahoma,Georgia;color:#006666"><%=(rs.getString("customer")==null?"&nbsp;":rs.getString("customer"))%></div></td>
						<td ><div align="left" style="font-family:Tahoma,Georgia;color:#006666"><%=(rs.getString("item_info")==null?"&nbsp;":rs.getString("item_info"))%></div></td>
						  
					</tr>
	<%
					}
				}
				statement.close();
				rs.close();
			
				if (icnt>0)
				{
		%>
					</table>
				</td>
				<td width="5%">&nbsp;</td>
			</tr>
		<%
					if (icnt >15)
					{
						out.println("<tr>");
						out.println("<td>&nbsp;</td><td><table width='100%'><tr><td width='30%'>&nbsp;</td><td width='40%' align='center'>");
						if (LastPage==1)
						{
							FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
						}
						else if (NowPage == 1)
						{
							FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
						}
						else if (NowPage == LastPage)
						{
							FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
						}				
						else
						{
							FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
						}
						out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
						out.println("&nbsp;");
						out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
						out.println("&nbsp;&nbsp;<font face='細明體' color='#CC0066' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
						out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
						out.println("&nbsp;");
						out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCITEMStockQuery.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
						out.println("</td><td width='30%'>&nbsp;</td>");		
						out.println("</tr></table></td><td>&nbsp;</td></tr>");
					}
				}
				else
				{
					out.println("<tr><td colspan='3' align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></TD></TR>");
				}
			}
			catch(Exception e)
			{
				out.println("<tr><td align='center'>資料查詢發生錯誤,請洽系統管理人員!!("+e.getMessage()+")</td></tr>");
			}
		}
%>
</table>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
