<!--20160718 Peggy,排除TSCH ORDER-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,jxl.*,jxl.write.*,jxl.format.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%> 
<%@ page import="SalesDRQPageHeaderBean,ComboBoxBean,DateBean,WorkingDateBean" %>
<%@ page import="java.util.Date"%> 	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC訂單已交未交量查詢</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeanF" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeanT" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeanS" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<style type="text/css">
 .style1   {font-family:Arial; font-size:12px; background-color:#D7F4E6; color:#000000; text-align:left;}
 .style2   {font-family:Arial; font-size:12px; background-color:#CCCCCC; color:#000000; text-align:center;}
 .style12   {font-family:Arial; font-size:12px; background-color:#CCFFCC; color:#000000; text-align:left;}
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style7   {font-family: "標楷體";font-weight: bold;}
 .style9   {color: #3366FF}
</style>
<script language="JavaScript" type="text/JavaScript">
function sendSubmit(URL)
{ 
	if (checkData()==true)
	{
		//var salesAreaNo = document.MYFORM.SALESAREANO.value;
		//var CUSTOMERNO = document.MYFORM.CUSTOMERNO.value;
		//var CUSTOMERNAME = document.MYFORM.CUSTOMERNAME.value;
		//var CUSTOMERID = document.MYFORM.CUSTOMERID.value;
		document.MYFORM.submit1.disabled=true;
		document.MYFORM.excel.disabled=true;
		//document.MYFORM.action=URL+"&SALESAREANO="+salesAreaNo+"&CUSTOMERNO="+CUSTOMERNO+"&CUSTOMERNAME="+CUSTOMERNAME+"&partname="+partname+"&YMF="+ymf+"&YMT="+ymt;
		document.MYFORM.action=URL;
		document.MYFORM.submit(); 
	}
}

function sendXLSSubmit(URL)
{  
	if (checkData()==true)
	{
		var salesAreaNo = document.MYFORM.SALESAREANO.value;
		var CUSTOMERNO = document.MYFORM.CUSTOMERNO.value;
		var CUSTOMERNAME = document.MYFORM.CUSTOMERNAME.value;
		var partname = document.MYFORM.partname.value;
		var ymf = document.MYFORM.YMF.value;
		var ymt = document.MYFORM.YMT.value;
		var PRODUCTGROUP = document.MYFORM.PRODUCTGROUP.value;
		var ENDCUST = document.MYFORM.ENDCUST.value;
		document.MYFORM.action=URL+"?salesAreaNo="+salesAreaNo+"&CUSTOMERNO="+CUSTOMERNO+"&CUSTOMERNAME="+CUSTOMERNAME+"&partname="+partname+"&ymf="+ymf+"&ymt="+ymt+"&ENDCUST="+ENDCUST+"&PRODUCTGROUP="+PRODUCTGROUP;
		document.MYFORM.submit(); 
	}
}

function checkData()
{
	var SALESAREANO = document.MYFORM.SALESAREANO.value;
	var sdate = document.MYFORM.YMF.value;
	var edate = document.MYFORM.YMT.value;
	if (document.MYFORM.PC_FLAG.value=="N" && (SALESAREANO == null || SALESAREANO == "--"))
	{
		alert("業務地區別必須選擇!");
		document.MYFORM.SALESAREANO.focus();
		return false;
	}
	if (sdate == null || sdate == "")
	{
		alert("起始年月不可空白!");
		document.MYFORM.YMF.focus();
		return false;
	}
	else
	{
		if (sdate.length!=7)
		{
			alert("起始年月格式必須為YYYY-MM!");
			document.MYFORM.YMF.focus();
			return false;
		}
		var smm = sdate.substring(5,7);
		if(smm<1||smm>12) 
		{ 
        	alert("Month must between 01 and 12 !!"); 
            document.MYFORM.YMF.focus();   
            return(false); 
        } 
	}
	
	if (edate == null || edate == "")
	{
		alert("結束年月不可空白!");
		document.MYFORM.YMT.focus();
		return false;
	}
	else
	{
		if (edate.length!=7)
		{
			alert("結束年月格式必須為YYYY-MM!");
			document.MYFORM.YMT.focus();
			return false;
		}
		var emm = edate.substring(5,7);
		if(emm<1||emm>12) 
		{ 
        	alert("Month must between 01 and 12 !!"); 
            document.MYFORM.YMT.focus();   
            return(false); 
        } 
	}
	return true;
}
function TscSalesOrderDetail(sYM,eYM,ItemNo,CustNo,sKind,endCust)
{            
    subWin=window.open("../jsp/TscSalesOrderDeliveryDetail.jsp?SYM="+sYM+"&EYM="+eYM+"&ITEM="+ItemNo+"&CUST="+CustNo+"&KIND="+sKind+"&ENDCUST="+endCust,"subwin","top=0,left=0,width=650,height=500,scrollbars=yes,menubar=no,status=yes");    	
}
function opencustwindow()
{
	var SALESAREANO = document.MYFORM.SALESAREANO.value;
	if (SALESAREANO == null || SALESAREANO == "--")
	{
		alert("業務地區別必須選擇!");
		document.MYFORM.SALESAREANO.focus();
		return false;
	}
	var CUSTOMERNAME = document.MYFORM.CUSTOMERNAME.value;
	var CUSTOMERNO = document.MYFORM.CUSTOMERNO.value;
   	subWin=window.open("../jsp/subwindow/TscSOCustomerInfo.jsp?CUSTOMERNO="+CUSTOMERNO+"&NAME="+CUSTOMERNAME+"&SAREANO="+SALESAREANO,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
</script>
<%
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String salesAreaNo=request.getParameter("SALESAREANO");
if (salesAreaNo==null) salesAreaNo = userActCenterNo; // 若未選擇其他任何一業務區,則以使用者Login預設
String Action=request.getParameter("Action");
if (Action == null) Action = "";
String CUSTOMERNO=request.getParameter("CUSTOMERNO");
if (CUSTOMERNO==null) CUSTOMERNO = "";
String CUSTOMERID=request.getParameter("CUSTOMERID");
if (CUSTOMERID==null) CUSTOMERID = "";
String CUSTOMERNAME=request.getParameter("CUSTOMERNAME");
if (CUSTOMERNAME==null) CUSTOMERNAME = "";
String PartName=request.getParameter("partname");
if (PartName==null) PartName="";
String YMF = request.getParameter("YMF");
String YMT = request.getParameter("YMT");
String QPage = request.getParameter("QPage");
String ENDCUST = request.getParameter("ENDCUST");
if (ENDCUST ==null) ENDCUST="";
String PRODUCTGROUP = request.getParameter("PRODUCTGROUP"); //add by Peggy 20130318
if (PRODUCTGROUP==null) PRODUCTGROUP=""; 
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int YearF =0,MonthF =0;
int YearT =0,MonthT =0;
int Months = 0;
int PageSize = 100;
String pc_flag = request.getParameter("PC_FLAG"); //add by Peggy 20150729
if (pc_flag==null) pc_flag="N";

try
{
	if (YMF == null || YMF == "")
	{
		dateBeanF.setDate(dateBean.getYear(),dateBean.getMonth(),1); 
		dateBeanF.setAdjMonth(-6);
		YMF = dateBeanF.getYearString() +"-"+dateBeanF.getMonthString(); 
	}
	YearF = Integer.parseInt(YMF.substring(0,4));
	MonthF = Integer.parseInt(YMF.substring(5,7));
	
	if (YMT == null || YMT == "")
	{
		dateBeanT.setDate(dateBean.getYear(),dateBean.getMonth(),1); 
		dateBeanT.setAdjMonth(5);
		YMT = dateBeanT.getYearString() +"-"+dateBeanT.getMonthString(); 
	} 
	YearT = Integer.parseInt(YMT.substring(0,4));
	MonthT = Integer.parseInt(YMT.substring(5,7));

	if (YearT==YearF) 
	{
		Months = MonthT-MonthF;
	}	
	else 
	{
		Months = (YearT-YearF) * 12 - MonthF + MonthT;
	}
}
catch(Exception e)
{
	out.println("error:"+e.getMessage());
}
%>
</head>
<body>
<form name="MYFORM" method="post" >
 <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><span class="style7"><font color="#000000" size="+2">訂單已交未交量查詢</font></span>
<p></p>
	<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#FFFFFF"><font color="black"><STRONG>回首頁</STRONG></font></A>
<table cellspacing="0" bordercolordark="#998811"  cellpadding="1" width="100%" align="center" >
<tr>
<td>
	<table cellspacing="0" bordercolordark="#998811"  cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
		<tr>
    		<td class="style1" colspan="10"><font face="Arial" color="#3366FF">請輸入查詢條件：</font></td>
		</tr>
  		<tr>
    		<td class="style1"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgSalesArea"/></font></td>
			<td width="25%">
			<%		 
			try
			{  
				Statement statement=con.createStatement();
				ResultSet rs=null;	
				String sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA "
						   + "where SALES_AREA_NO > 0 ";

				//if (UserRoles=="admin" || UserRoles.equals("admin") || UserName.toUpperCase().equals("CCYANG"))  //modify by Peggy 20130318,CCYANG可查全部區域
				if (UserRoles=="admin" || UserRoles.equals("admin") || UserName.toUpperCase().equals("CCYANG") || UserName.toUpperCase().equals("RITA_ZHOU") || UserName.startsWith("JUDY_"))  //modify by Peggy 20140513,CELIA,CYTSOU可查全部區域				
				{ 
					pc_flag="Y"; //add by Peggy 20150729
				} 
				else 
				{ 
					if (UserRegionSet==null || UserRegionSet.equals(""))
					{
						sql += "and SALES_AREA_NO='"+userActCenterNo+"' "; // 若是空的地區集,則以主要的業務區
					} 
					else 
					{
						sql += "and SALES_AREA_NO in ("+UserRegionSet+") ";
					}
				}
				sql += " order by SALES_AREA_NO";
				rs=statement.executeQuery(sql);	
				out.println("<select NAME='SALESAREANO' tabindex='1'>");				  			  
				out.println("<OPTION VALUE=-->--");     
				while (rs.next())
				{            
					String s1=(String)rs.getString(1); 
					String s2=(String)rs.getString(2); 
					if (s1.equals(salesAreaNo)) 
					{		   					   
						out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
					} 
					else 
					{
						out.println("<OPTION VALUE='"+s1+"'>"+s2);
					}        
				} 
				out.println("</select>"); 
				rs.close();   
				statement.close(); 
			} 
			catch (Exception e)
			{
				out.println("Exception:"+e.getMessage());
			}		   
			%>
			</td>
			<td class="style1" ><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustomerName"/></font>
			</td>
			<td  width="25%" >
			<input type="text" name="CUSTOMERNO" size="8" value="<%=CUSTOMERNO%>">
			<input name="button3" type="button" tabindex="7" value=".."	 onClick="opencustwindow()" title='Pleaes choose a customer!'>		
			<input type="text" name="CUSTOMERNAME" size="30" value="<%=CUSTOMERNAME%>">
			<input type="hidden" name="CUSTOMERID" value="<%=CUSTOMERID%>">
			<input type="hidden" name="PC_FLAG" value="<%=pc_flag%>">
			</td>
			<td class="style1" ><font face="Arial" color="#3366FF">End Customer</font>
			</td>
			<td  width="25%">
			<input type="text" name="ENDCUST" size="30" value="<%=ENDCUST%>">
			</td>
			</tr>
			<tr>
			<td class="style1"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgPart"/></font></td>
			<td><input type="text" name="partname" size="30" value=<%=PartName%>></td>
			<td class="style1"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgDateFr"/></font></td>
			<td><input type="text" name="YMF" size="8" value=<%=YMF%>><font face="Arial" color="#FF0000" SIZE=1>(YYYY-MM)</font>
			~
			<input type="text" name="YMT" size="8" value=<%=YMT%>><font face="Arial" color="#FF0000" SIZE=1>(YYYY-MM)</font></td>
			<td class="style1"><font face="Arial" color="#3366FF">TSC Prod Group</font></td>
			<td>
			<%	  
				try
				{   
					String sql = " select DISTINCT TSC_PROD_GROUP as x, TSC_PROD_GROUP from ORADDMAN.TSITEM_PACKING_CATE "+		  		  
						  " where TSC_PROD_GROUP is not null AND TSC_PROD_GROUP <>'null' order by TSC_PROD_GROUP ";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					comboBoxBean.setRs(rs);
					comboBoxBean.setSelection(PRODUCTGROUP);
					comboBoxBean.setFieldName("PRODUCTGROUP");	   
					out.println(comboBoxBean.getRsString());
					rs.close();    
					statement.close();  		 
				} //end of try
				catch (Exception e)
				{
					out.println("Exception3:"+e.toString());		  
				} 
			%>
			</td>
		</tr>
		<tr>
			  <td class="style1"  colspan="6">
				<input type="button" name="submit1" id="search" value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick="sendSubmit('../jsp/TscSalesOrderDeliveryOverview.jsp?Action=Q')" title="請按我,謝謝!">
				&nbsp;&nbsp;
				<input type="button" name="excel" id="excel" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick="sendXLSSubmit('../jsp/TscSalesOrderDeliveryExcel.jsp')" title="請按我,謝謝!">
			  </td>
		</tr>
	</table>
</td>
</tr>
</table>
<%
if (Action.equals("Q"))
{
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
	
	int iCnt = 0,pagewidth=0,LastPage =0;
	float unship_qty=0,shipped_qty=0,tt_unship =0,tt_shipped =0;
	String sql = "",sqlt = "",sDate="";
	String customerno ="",customer_name = "",item_name = "",item_desc = "",	item_uom = "",endcustomer="",tsc_package="",tsc_family="",tsc_prod_group="";
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
	try
	{
		sql = " SELECT a.order_number,"+
              " TO_NUMBER (b.line_number || '.' || b.shipment_number) line_number,"+
              " c.segment1 item_name, c.description item_desc,a.sold_to_org_id, d.account_number,e.party_name , b.schedule_ship_date,"+
              " b.actual_shipment_date, case b.order_quantity_uom when 'PCE' then 'KPC' else b.order_quantity_uom end as item_uom ,f.document_description,"+
		      " TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE, "+         
		      " TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY, "+	         
		      " TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP') as TSC_PROD_GROUP ";
		dateBeanS.setDate(YearF,MonthF,1); 
        for (int i =0 ; i <= Months ; i++)
		{	
			sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString(); 
			sql += ",case to_char(nvl( actual_shipment_date,schedule_ship_date),'yyyy-mm') "+
			       " when '"+ sDate + "' then "+
				   " 	to_number((case b.order_quantity_uom "+
				   "     when 'PCE' then "+
				   "        (case when nvl(b.shipped_quantity,0) >0 then 0 else nvl(b.ordered_quantity,0) end) /1000"+
				   "     else"+
				   "        (case when nvl(b.shipped_quantity,0) >0 then 0 else nvl(b.ordered_quantity,0) end)"+
				   "     end))"+
			       " else 0 end as \""+ sDate+"_unship\"";
			sql += ",case to_char(nvl( actual_shipment_date,schedule_ship_date),'yyyy-mm') "+
			       " when '"+ sDate + "' then "+
				   " 	to_number((case b.order_quantity_uom "+
				   "     when 'PCE' then "+
				   "        (case when nvl(b.shipped_quantity,0) >0 then NVL (b.shipped_quantity, 0) else 0 end) /1000"+
				   "     else"+
				   "        (case when nvl(b.shipped_quantity,0) >0 then NVL (b.shipped_quantity, 0) else 0 end)"+
				   "     end))"+
			       " else 0 end as \""+ sDate+"_shipped\"";
			dateBeanS.setAdjMonth(1);
		}
		sql +=" FROM ont.oe_order_headers_all a,"+
              " ont.oe_order_lines_all b,"+
              " inv.mtl_system_items_b c,"+
              " hz_cust_accounts d,"+
              " hz_parties e,"+
			  " (select fadfv.pk1_value,fadfv.document_description from  fnd_attached_docs_form_vl fadfv where fadfv.function_name = 'OEXOEORD'"+
              " AND fadfv.category_description = 'SHIPPING MARKS' AND fadfv.user_entity_name = 'OM Order Header') f"+
              " WHERE a.header_id = b.header_id"+
              " AND b.inventory_item_id = c.inventory_item_id"+
              " AND b.ship_from_org_id = c.organization_id"+
              " AND a.sold_to_org_id = d.cust_account_id"+
              " AND d.party_id = e.party_id"+
			  " AND a.header_id = f.pk1_value(+)"+
              //" AND to_char(nvl(b.actual_shipment_date,b.schedule_ship_date),'yyyy-mm') between '"+ YMF +"' and '"+ YMT +"'"+
			  " AND nvl(b.actual_shipment_date,b.schedule_ship_date) between to_date('"+ YMF +"','yyyy-mm') and add_months(to_date('"+ YMT +"','yyyy-mm'),1)-1+0.99999"+
			  " AND a.org_id in (41,325)"+ //add by Peggy 20160718
              " AND (b.schedule_ship_date IS NOT NULL OR b.actual_shipment_date IS NOT NULL)";
	    if (!CUSTOMERNO.equals("")) sql += " AND d.account_number = '"+ CUSTOMERNO +"' ";
		if (!CUSTOMERNAME.equals("")) sql += " AND e.party_name LIKE '%"+ CUSTOMERNAME +"%' ";
		if (!PartName.equals("")) sql += " AND (c.segment1 like '%"+PartName + "%' or c.description like '%"+PartName + "%')";
		if (!salesAreaNo.equals("") &&!salesAreaNo.equals("--") )
		{
			sql += " AND exists ( SELECT 1  FROM apps.hz_cust_acct_sites_all a,ar.hz_cust_site_uses_all b,oraddman.tssales_area c"+
                   " WHERE a.cust_acct_site_id = b.cust_acct_site_id and c.sales_area_no ='"+salesAreaNo+"'  and ','||c.GROUP_ID||',' LIKE '%,'||b.attribute1||',%'"+
                   " AND a.status = b.status   AND a.org_id = b.org_id AND a.cust_account_id = d.cust_account_id)";
		}
		else if (!UserRoles.equals("admin") && !UserName.equals("CCYANG") && !UserName.equals("RITA_ZHOU") && !UserName.startsWith("JUDY_"))  //add Judy by Peggy 20211007 
		{
			sql += " AND exists ( SELECT 1  FROM apps.hz_cust_acct_sites_all a,ar.hz_cust_site_uses_all b,oraddman.tssales_area c,oraddman.tsrecperson d"+
                   " WHERE a.cust_acct_site_id = b.cust_acct_site_id and c.sales_area_no ='"+salesAreaNo+"'  and ','||c.GROUP_ID||',' LIKE '%,'||b.attribute1||',%'"+
				   " AND c.sales_area_no = d.tssaleareano and d.USERNAME='"+ UserName +"' "+
                   " AND a.status = b.status   AND a.org_id = b.org_id AND a.cust_account_id = d.cust_account_id)";
		}
		if (!ENDCUST.equals("")) sql += " AND f.document_description LIKE '%"+ENDCUST+"%'";
		if (!PRODUCTGROUP.equals("") && !PRODUCTGROUP.equals("--")) sql += " AND TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP') ='"+ PRODUCTGROUP+"'"; //add by Peggy 20130318
		//out.println(sql);
		//sqlt = " SELECT  tt.account_number customerno,'('||tt.account_number ||')'|| tt.party_name customer_name,tt.document_description,tt.item_name,tt.item_desc,tt.item_uom ";
		sqlt = " SELECT  tt.account_number customerno,'('||tt.account_number ||')'|| tt.party_name customer_name,tt.document_description,tt.item_name,tt.item_desc,tt.item_uom,tt.tsc_package,tt.tsc_family,tt.tsc_prod_group ";
		dateBeanS.setDate(YearF,MonthF,1); 
        for (int i =0 ; i <= Months ; i++)
		{	
			sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString();
			sqlt += " ,sum(\""+sDate+"_unship\") as \""+ sDate+"_unship\",sum(\""+sDate+"_shipped\") as \""+ sDate+"_shipped\"";
			dateBeanS.setAdjMonth(1);
		}
		sqlt += " from ("+ sql +") tt"+
			  //" group by  tt.account_number,'('||tt.account_number ||')'|| tt.party_name,tt.document_description,tt.item_name,tt.item_uom,tt.item_desc "+
              " group by  tt.account_number,'('||tt.account_number ||')'|| tt.party_name,tt.document_description,tt.item_name,tt.item_uom,tt.item_desc,tt.tsc_package,tt.tsc_family,tt.tsc_prod_group "+
			  " order by  tt.account_number,tt.item_name";
		//out.println(sqlt); 
		Statement statement=con.createStatement(); 
		ResultSet rs =statement.executeQuery(sqlt);
		while (rs.next()) 
		{ 
			tt_unship =0;tt_shipped =0;
			if (iCnt == 0)
			{	
				sql = " select count(1) rowcnt from ("+sqlt+") ss";
				//out.println(sql);
				Statement statement1=con.createStatement(); 
				ResultSet rs1 =statement1.executeQuery(sql);
				while (rs1.next())
				{
					//總筆數
					dataCnt = Long.parseLong(rs1.getString("rowcnt"));
					//最後頁數
					LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
				}
				rs1.close();
				statement1.close();							
				pagewidth = 800 + ((Months+2) * 80);
				out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>");
				out.println("<tr>");
				out.println("<td>");
				out.println("<font face='標楷體' color='blue'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
				out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
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
				out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TscSalesOrderDeliveryOverview.jsp?Action=Q&QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
				out.println("&nbsp;");
				out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TscSalesOrderDeliveryOverview.jsp?Action=Q&QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
				out.println("&nbsp;&nbsp;"+"<font face='標楷體' color='blue'>第"+NowPage+"頁</font>&nbsp;&nbsp;");
				out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TscSalesOrderDeliveryOverview.jsp?Action=Q&QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
				out.println("&nbsp;");
				out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TscSalesOrderDeliveryOverview.jsp?Action=Q&QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
				out.println("</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td>");
				out.println("<table cellspacing='0' bordercolordark='#118811'  cellpadding='1' width='"+pagewidth+"' align='left' bordercolorlight='#ffffff' border='1'>");
				out.println("<tr>");
				out.println("<td rowspan=2 class='style2' width='20'>SeqNo</td>");
				out.println("<td rowspan=2 class='style2' width='300'>CustomerName</td>");
				out.println("<td rowspan=2 class='style2' width='150'>EndCustomer</td>");
				out.println("<td rowspan=2 class='style2' width='200'>ItemName</td>");
				out.println("<td rowspan=2 class='style2' width='150'>Description</td>");
				out.println("<td rowspan=2 class='style2' width='50'>Uom</td>");
				//out.println("<td rowspan=2 class='style2' width='50'>TSC Package</td>");
				//out.println("<td rowspan=2 class='style2' width='50'>TSC Family</td>");
				out.println("<td rowspan=2 class='style2' width='50'>TSC Prod Group</td>");
				dateBeanS.setDate(YearF,MonthF,1); 
				for (int i =0 ; i <= Months ; i++)
				{	
					sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString(); 
					out.println("<td colspan=2 class='style2' width='80'>"+sDate+"</td>");
					dateBeanS.setAdjMonth(1);
				}					
				out.println("<td colspan=2 class='style2' width='80'>Total</td>");
				out.println("</tr>");
				out.println("<tr>");
				for (int i =0 ; i <= Months ; i++)
				{	
					out.println("<td class='style2' width='40'>未交</td>");
					out.println("<td class='style2' width='40'>已交</td>");
				}
				out.println("<td class='style2' width='40'>未交</td>");
				out.println("<td class='style2' width='40'>已交</td>");
				out.println("</tr>");
			}
			//符合選取頁數範圍內的資料才顯示
			if ((iCnt+1) > sCnt && (iCnt+1) <= eCnt)
			{
				customerno =  rs.getString("customerno");
				customer_name = rs.getString("customer_name");
				endcustomer = rs.getString("document_description");
				item_name = rs.getString("item_name");
				item_desc = rs.getString("item_desc");
				item_uom = rs.getString("item_uom");
				tsc_package = rs.getString("TSC_PACKAGE");
				tsc_family = rs.getString("TSC_FAMILY");
				tsc_prod_group = rs.getString("TSC_PROD_GROUP");
				out.println("<tr>");
				out.println("<td class='style12' width='20'>"+(iCnt +1)+"</td>");
				out.println("<td class='style12' width='300'>"+customer_name+"</td>");
				out.println("<td class='style12' width='150'>"+endcustomer+"</td>");
				out.println("<td class='style12' width='200'>"+item_name+"</td>");
				out.println("<td class='style12' width='150'>"+item_desc+"</td>");
				out.println("<td class='style12' width='50'>"+item_uom+"</td>");
				//out.println("<td class='style12' width='50'>"+tsc_package+"</td>");
				//out.println("<td class='style12' width='50'>"+tsc_family+"</td>");
				out.println("<td class='style12' width='50'>"+tsc_prod_group+"</td>");
				dateBeanS.setDate(YearF,MonthF,1); 
				for (int i =0 ; i <= Months ; i++)
				{	
					sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString();
					unship_qty =  rs.getFloat(sDate+"_unship");
					shipped_qty =  rs.getFloat(sDate+"_shipped");
					if (unship_qty !=0)
					{
						out.println("<td class='style4' width='35'><a href='javaScript:TscSalesOrderDetail("+'"'+sDate+'"'+","+'"'+sDate+'"'+","+'"'+ item_name+'"'+","+'"'+customerno+'"'+","+'"'+"0"+'"'+","+'"'+endcustomer+'"'+")'>"+(new DecimalFormat("#,##0.###")).format(unship_qty)+"</a></td>");
					}
					else
					{
						out.println("<td class='style4' width='35'>"+(new DecimalFormat("#,##0.###")).format(unship_qty)+"</td>");
					}
					if (shipped_qty !=0)
					{
						out.println("<td class='style4' width='35'><a href='javaScript:TscSalesOrderDetail("+'"'+sDate+'"'+","+'"'+sDate+'"'+","+'"'+ item_name+'"'+","+'"'+customerno+'"'+","+'"'+"1"+'"'+","+'"'+endcustomer+'"'+")'>"+(new DecimalFormat("#,##0.###")).format(shipped_qty)+"</a></td>");
					}
					else
					{
						out.println("<td class='style4' width='35'>"+(new DecimalFormat("#,##0.###")).format(shipped_qty)+"</td>");
					}
					dateBeanS.setAdjMonth(1);
					tt_unship += unship_qty;
					tt_shipped += shipped_qty;
				}
				if (tt_unship !=0)
				{
					out.println("<td class='style4' width='35'><a href='javaScript:TscSalesOrderDetail("+'"'+YMF+'"'+","+'"'+YMT+'"'+","+'"'+ item_name+'"'+","+'"'+customerno+'"'+","+'"'+"0"+'"'+","+'"'+endcustomer+'"'+")'>"+(new DecimalFormat("#,##0.###")).format(tt_unship)+"</a></td>");
				}
				else
				{
					out.println("<td class='style4' width='35'>"+(new DecimalFormat("#,##0.###")).format(tt_unship)+"</td>");
				}
				if (tt_shipped !=0)
				{
					out.println("<td class='style4' width='35'><a href='javaScript:TscSalesOrderDetail("+'"'+YMF+'"'+","+'"'+YMT+'"'+","+'"'+ item_name+'"'+","+'"'+customerno+'"'+","+'"'+"1"+'"'+","+'"'+endcustomer+'"'+")'>"+(new DecimalFormat("#,##0.###")).format(tt_shipped)+"</a></td>");
				}
				else
				{
					out.println("<td class='style4' width='35'>"+(new DecimalFormat("#,##0.###")).format(tt_shipped)+"</td>");
				}
				out.println("</tr>");
			}
			iCnt ++;
		}
		if (iCnt >0)
		{
			out.println("</table>");
			out.println("</td>");
			out.println("</tr>");
			out.println("</table>");
		}
		else
		{
		%>
			<script language="JavaScript">
			alert('No Data Found!');
			</script>
		<%
		}
		rs.close();
		statement.close();	
	}
	catch(Exception e)
	{
		out.println("Exception1:"+ e.getMessage());
	}
   sql1="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
   pstmt=con.prepareStatement(sql1);
   pstmt.executeUpdate(); 
   pstmt.close();	
}
%>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
