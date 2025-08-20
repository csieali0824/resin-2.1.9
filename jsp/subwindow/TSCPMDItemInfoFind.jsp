<!-- 20150317 Peggy,北新科3867只做測試-->
<!-- 20150814 Peggy,MOSFET系列產品,Testing Yield=95%-->
<!-- 20160914 Peggy,新增bill_sequence_id-->
<!-- 20161104 Peggy,新增prd 外包-->
<%@ page language="java" import="java.sql.*"%>
<%@ page import="java.text.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME == null) ITEMNAME = "";
String ITEMDESC=request.getParameter("ITEMDESC");
if (ITEMDESC == null) ITEMDESC = "";
String SearchStr=request.getParameter("SEARCHSTRING");
if (SearchStr == null) SearchStr = "";
String LINENO=request.getParameter("LINENO");
if (LINENO == null) LINENO ="";
String FUNCNAME = request.getParameter("FUNCNAME");
if (FUNCNAME == null) FUNCNAME="F1";
String VENDOR = request.getParameter("VENDOR");
if (VENDOR == null) VENDOR="";
String QTY = request.getParameter("QTY");
if (QTY==null || QTY.equals("")) QTY="0";
String VENDOR_SITE_ID = request.getParameter("SUPPLIERSITE");
if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  
String WIPTYPE = request.getParameter("WIPTYPE");
if (WIPTYPE == null) WIPTYPE = ""; //add by Peggy 20120831
String REQUESTNO=request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";  //add by Peggy 20191021
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(ItemID,ItemName,ItemDesc,ItemPackage,DieName,DieID,LineNo,PackingType,FuncName,Price,PriceUom,PriceList,DieQty,QtyUnit,PackageSpec,TestSpec,AVL,lineno,DIEITEM,tsc_family,BillSeqID,organizationid,prod_group,item_type)
{ 
	if (LineNo=="")
	{
		window.opener.document.MYFORM.ITEMID.value=ItemID;
		window.opener.document.MYFORM.ITEMNAME.value=ItemName;
		window.opener.document.MYFORM.ITEMDESC.value=ItemDesc;
		window.opener.document.MYFORM.PACKAGE.value=ItemPackage;
		window.opener.document.MYFORM.DIENAME.value=DieName;
		window.opener.document.MYFORM.DIEID.value=DieID;
		window.opener.document.MYFORM.DIEITEM.value=DIEITEM;
		window.opener.document.MYFORM.PACKING.value=PackingType;
		window.opener.document.MYFORM.BILLSEQID.value=BillSeqID;  //add by Peggy 20160914
		window.opener.document.MYFORM.PROD_GROUP.value=prod_group;  //add by Peggy 20161109
		window.opener.document.MYFORM.ORGANIZATION_ID.value=organizationid;  //add by Peggy 20161106
		window.opener.document.MYFORM.ITEM_TYPE.value=item_type;  //add by Peggy 20220817
		if (window.opener.document.MYFORM.WIPTYPE.value =="01")
		{
			if (window.opener.document.MYFORM.SUPPLIERNO.value =="3867")  //北新科只有測試,add by Peggy 20150317
			{
				window.opener.document.MYFORM.CHKASSEMBLY.checked=false;
				window.opener.document.MYFORM.CHKTESTING.checked=true;
				window.opener.document.MYFORM.CHKTAPING.checked=false;
				window.opener.document.MYFORM.CHKLAPPING.checked=false;
				window.opener.document.MYFORM.CHKOTHERS.checked=false;
				window.opener.document.MYFORM.OTHERS.value="";
			}
			else
			{			
				if (window.opener.document.MYFORM.SUPPLIERNO.value !="2012" && window.opener.document.MYFORM.PACKAGE.value.toUpperCase() !="WAFER")  //封裝形式=WAFER不勾封裝 For Nono issue,add by Peggy 20180126
				{
					window.opener.document.MYFORM.CHKASSEMBLY.checked =true; 
				}
				else
				{
					window.opener.document.MYFORM.CHKASSEMBLY.checked =false;
				}
				//if (PackingType=="AMMO" || PackingType=="TAPE & REEL")
				if ((PackingType=="AMMO" || PackingType=="TAPE & REEL") && window.opener.document.MYFORM.PACKAGE.value.toUpperCase() !="WAFER") //封裝形式=WAFER不勾編帶 For Nono issue,add by Peggy 20180126 
				{
					window.opener.document.MYFORM.CHKTAPING.checked=true;
				}
				else
				{
					window.opener.document.MYFORM.CHKTAPING.checked=false;
				}
				//add by Peggy 20130726
				var lapping_flag = DIEITEM.substr(DIEITEM.length-3,1);
				if (lapping_flag=="A" || lapping_flag=="B")
				{
					window.opener.document.MYFORM.CHKLAPPING.checked=true;
				}
				else
				{
					window.opener.document.MYFORM.CHKLAPPING.checked=false;
				}
			}
			
			if (ItemPackage=="WAFER")
			{
				if (prod_group=="PRD")
				{
					window.opener.document.MYFORM.SUBINVENTORY.value="71";
				}
				else if (prod_group=="PMD")
				{
					window.opener.document.MYFORM.SUBINVENTORY.value="61";
				}
				else if (prod_group=="SSD")
				{
					window.opener.document.MYFORM.SUBINVENTORY.value="81";
				}				
			}
			else
			{
				if (prod_group=="PRD")
				{
					window.opener.document.MYFORM.SUBINVENTORY.value="73";
				}
				else if (prod_group=="PMD")
				{
					window.opener.document.MYFORM.SUBINVENTORY.value="63";
				}
				else if (prod_group=="SSD")
				{
					window.opener.document.MYFORM.SUBINVENTORY.value="83";
				}				
			}
			
			window.opener.document.MYFORM.AVL.value=AVL;                 //add by Peggy 20130719
			if (window.opener.document.MYFORM.ACTIONTYPE.value!="MODIFY" && window.opener.document.MYFORM.ACTIONTYPE.value!="CHANGE" )
			{
				window.opener.document.MYFORM.MARKING.value=document.SITEFORM.elements["MARKING_1"].value;     //add by Peggy 20130719
				window.opener.document.MYFORM.PACKAGESPEC.value=PackageSpec; //add by Peggy 20130719
				window.opener.document.MYFORM.TESTSPEC.value=TestSpec;       //add by Peggy 20130719
			}
			if (tsc_family=="MOSFET")
			{
				window.opener.document.MYFORM.REMARKS.value=window.opener.document.MYFORM.REMARKS.value.replace("97%","95%");  //add by Peggy 20150814
			}
		}
		if (window.opener.document.MYFORM.WIPTYPE.value =="04")  //WAFER工單自動寫入封裝規格及測試規格 add by Peggy 20240418
		{
			window.opener.document.MYFORM.PACKAGESPEC.value=PackageSpec;
			window.opener.document.MYFORM.TESTSPEC.value=TestSpec;   			
		}	
		
		if (window.opener.document.MYFORM.WIPTYPE.value =="03" || window.opener.document.MYFORM.WIPTYPE.value =="05")  //CP follow重工 by Peggy 20220126
		{
			window.opener.document.MYFORM.DIEQTY.value="1"; //add by Peggy 20170602
			if (window.opener.document.MYFORM.ACTIONTYPE.value!="MODIFY" && window.opener.document.MYFORM.ACTIONTYPE.value!="CHANGE" )
			{
				window.opener.document.MYFORM.PACKAGESPEC.value=PackageSpec;
				window.opener.document.MYFORM.TESTSPEC.value=TestSpec;      
			}
		}
		else
		{
			window.opener.document.MYFORM.DIEQTY.value=DieQty;           //add by Peggy 20121009
			window.opener.document.MYFORM.MARKING.value=document.SITEFORM.elements["MARKING_1"].value;     //add by Peggy 20130719
		}
		if (Price ==null || Price == "" || Price =="null" || (window.opener.document.MYFORM.WIPTYPE.value !="01" && window.opener.document.MYFORM.WIPTYPE.value !="04" && window.opener.document.MYFORM.WIPTYPE.value !="05")) //add 05-CP by Peggy 20220316
		{
			window.opener.document.MYFORM.UNITPRICE.value="";
			window.opener.document.MYFORM.ST_UNITPRICE.value=""; //add by Peggy 20210608
			//window.opener.document.MYFORM.UNITPRICE.readOnly = true;
		}
		else
		{
			window.opener.document.MYFORM.UNITPRICE.value=Price;
			window.opener.document.MYFORM.ST_UNITPRICE.value=Price; //add by Peggy 20210608
			//window.opener.document.MYFORM.UNITPRICE.readOnly = false;
			window.opener.document.MYFORM.UNITPRICELIST.options.length = 0;
		}
		if (window.opener.document.getElementById("td1")!=undefined)
		{
			if (window.opener.document.MYFORM.WIPTYPE.value =="01" || window.opener.document.MYFORM.WIPTYPE.value =="04" || window.opener.document.MYFORM.WIPTYPE.value =="05")  //add 05-CP by Peggy 20220316
			{
				window.opener.document.MYFORM.PRICE_UOM.value = PriceUom;
				window.opener.document.MYFORM.PRICE_SOURCE_UOM.value = PriceUom;
			}
			else
			{
				if (window.opener.document.MYFORM.CURRENCYCODE.value =="USD" || window.opener.document.MYFORM.WIPTYPE.value=="03" || window.opener.document.MYFORM.WIPTYPE.value==="02")  //modify by Peggy 20120705,重工的單價單位為K
				{
					window.opener.document.MYFORM.PRICE_UOM.value = "k";
				}
				else
				{
					window.opener.document.MYFORM.PRICE_UOM.value = "ea";
				}
			}
			window.opener.document.getElementById("td1").innerHTML = window.opener.document.MYFORM.CURRENCYCODE.value+"/"+PriceUom;
			if (PriceUom =="片")
			{
				window.opener.document.getElementById("td2").innerHTML = "Q'ty("+PriceUom+")";
			}
			else
			{
				window.opener.document.getElementById("td2").innerHTML = "Q'ty(KPC)";
			}
		}
		window.opener.document.MYFORM.submit();
	}
	else
	{
		if (FuncName=="F1")
		{	
			window.opener.document.MYFORM.elements["INVITEM"+LineNo].value=ItemName;
			window.opener.document.MYFORM.elements["INVITEMID"+LineNo].value=ItemID;
			window.opener.document.MYFORM.elements["WaferLot"+LineNo].focus();
		}
		//add by Peggy 20120622
		else if (FuncName=="F2-001")
		{
			window.opener.document.MYFORM.ORGANIZATION_ID.value=organizationid;  //add by Peggy 20161106
			window.opener.document.MYFORM.elements["ITEMID"+LineNo].value=ItemID;
			window.opener.document.MYFORM.elements["ITEMNAME"+LineNo].value=ItemName;
			window.opener.document.MYFORM.elements["ITEMDESC"+LineNo].value=ItemDesc;
			//window.opener.document.MYFORM.elements["PREPRICE"+LineNo].value=Price;
			window.opener.document.MYFORM.elements["PRICELIST"+LineNo].value=PriceList;
			window.opener.document.MYFORM.elements["QTY_UNIT"+LineNo].value=QtyUnit;
			window.opener.document.MYFORM.elements["PROD_GROUP"+LineNo].value=prod_group;  //add by Peggy 20161109
			window.opener.document.MYFORM.elements["ORGANIZATION_ID"+LineNo].value=organizationid;  //add by Peggy 20161106
			window.opener.document.MYFORM.elements["STARTQTY"+LineNo].focus();
		}
	}
  	this.window.close();
}
</script>
<title>Page for choose Item List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCPMDItemInfoFind.jsp" NAME="SITEFORM">
<font size="-1"><jsp:getProperty name="rPH" property="pgPart"/><jsp:getProperty name="rPH" property="pgName"/>: 
	<input type="text" name="SEARCHSTRING" size=30 value="<%=SearchStr%>" STYLE="font-family:ARIAL">
  	</font> 
  	<INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
<BR>
<%  
	Statement statement=con.createStatement();
	try
    { 
		String sql = "";
		if (FUNCNAME.startsWith("F2"))
		{
			sql = " select distinct A.SEGMENT1 ITEM_NAME, A.DESCRIPTION,"+
                     " TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE,"+ 
                     " TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_FAMILY') as TSC_FAMILY,"+ //MOSFET記錄在TSC_PROD_FAMILY
                     " TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_GROUP') as PROD_GROUP,"+
					 " '' DIE_NAME,'' packing_type,'' PACKAGE_SPEC ,'' TEST_SPEC,'' DIE_ID,a.inventory_item_id ITEM_ID,0 BILL_SEQUENCE_ID"+
					 " ,a.ORGANIZATION_ID"+
					 " ,a.item_type"+ //add by Peggy 20190213
					 " ,'' marking_code"+ //add by Peggy 20190329
					 " from APPS.MTL_SYSTEM_ITEMS A"+
					 " where A.ORGANIZATION_ID = 49"+
					 //" AND a.attribute3='006'"+ //add by Peggy 20240304
					 " AND tsc_om_category (a.inventory_item_id, a.organization_id,'TSC_PROD_GROUP') in ('PMD','PRD-Subcon','PRD','SSD')"+
		             " and A.STOCK_ENABLED_FLAG ='Y' "+
			         " and A.MTL_TRANSACTIONS_ENABLED_FLAG = 'Y'"+
                     " and A.INVENTORY_ITEM_STATUS_CODE <> 'Inactive'"+
                     " and upper(A.DESCRIPTION) not like '%DISABLE%'"+ 
			         " AND not exists (select 1 from  oraddman.tspmd_quotation_headers_all x,oraddman.tspmd_quotation_lines_all y"+
			         " where x.request_no = y.request_no and x.status in ('Submit','Draft') and y.inventory_item_id = a.INVENTORY_ITEM_ID"+
				     " and x.VENDOR_CODE = '"+ VENDOR+"' and x.vendor_site_id = '" + VENDOR_SITE_ID+"')";
		}
		else
		{
			sql = " select distinct A.SEGMENT1 ITEM_NAME, A.DESCRIPTION,"+
                     " TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE,"+ 
                     " TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_FAMILY') as TSC_FAMILY,"+ //MOSFET記錄在TSC_PROD_FAMILY
                     " TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_GROUP') as PROD_GROUP,"+
					 " '' DIE_NAME"+
					 //",tpn.packing_type,"+
					 ",CASE WHEN INSTR(nvl(tpn.D_ATTRIBUTE1,tpn1.D_ATTRIBUTE1),'AMMO')>0 THEN 'AMMO' WHEN INSTR(nvl(tpn.D_ATTRIBUTE1,tpn1.D_ATTRIBUTE1),'REEL')>0 THEN 'TAPE & REEL' ELSE nvl(tpn.D_ATTRIBUTE1,tpn1.D_ATTRIBUTE1) END AS packing_type"+
					 " ,avl.package_spec,avl.test_spec,"+ //add by Peggy 20130719
					 " '' DIE_ID,a.inventory_item_id ITEM_ID,"+
					 " bom.BILL_SEQUENCE_ID"+
					 " ,a.ORGANIZATION_ID"+
					 " ,a.marking_code"+  //add by Peggy 20190322
					 ",tsc_om_category (a.inventory_item_id, a.organization_id,'TSC_PROD_GROUP') tsc_prod_group"+ 
                     //" from APPS.MTL_SYSTEM_ITEMS A"+
					 " ,a.item_type"+ //add by Peggy 20190213
					 " from (select tsc_get_item_packing_code (x.organization_id,x.inventory_item_id) packing_code"+
					 " ,y.marking_code"+  //add by Peggy 20190322
					 " ,x.* from apps.mtl_system_items x,oraddman.TSPMD_ITEM_MARKING_CODE y where  TSC_GET_ITEM_DESC_NOPACKING(x.organization_id,x.inventory_item_id)=y.product_name(+)) a"+
					 ",(select * from (SELECT d_attribute2,d_attribute1,d_value,row_number() over (partition by d_attribute2,d_value order by d_attribute1) row_seq FROM oraddman.tsqra_product_setup  where D_TYPE='PACKING_CODE') where row_seq=1) tpn"+
					 ",(select * from (SELECT d_attribute1,d_value,row_number() over (partition by d_value order by d_attribute1) row_seq FROM oraddman.tsqra_product_setup  where D_TYPE='PACKING_CODE') where row_seq=1) tpn1"+
					 //",(select * from  bom_bill_of_materials bom where exists (select 1 from bom_inventory_components bic where (DISABLE_DATE is null or trunc(DISABLE_DATE)>trunc(sysdate)) AND  bic.BILL_SEQUENCE_ID=bom.BILL_SEQUENCE_ID)) bom"+ //停用不顯示 ,add by Peggy 20140414
					 //若有alternate bom,以IS_PREFERRED=Y為優先.modif by Peggy 20140428
					 ",(select bom.* from (select bom.*,row_number() over (partition by ORGANIZATION_ID,ASSEMBLY_ITEM_ID order by nvl(IS_PREFERRED,'Z')) seqno from  bom_bill_of_materials bom where exists (select 1 from bom_inventory_components bic,inv.mtl_system_items_b msi where bic.component_item_id=msi.inventory_item_id and (bic.DISABLE_DATE is null or trunc(bic.DISABLE_DATE)>trunc(sysdate)) AND  bic.BILL_SEQUENCE_ID=bom.BILL_SEQUENCE_ID and msi.organization_id=bom.organization_id and msi.inventory_item_status_code<>'Inactive')) bom where 1=1";
			//if (WIPTYPE.equals("03")) sql += " and bom.seqno=1";
			if ((WIPTYPE.equals("03") || WIPTYPE.equals("05"))) sql += " and bom.seqno=1";  //CP follow重工 by Peggy 20220126
			sql +=   ") bom"+
			         ",(select INVENTORY_ITEM_ID,PACKAGE_SPEC,TEST_SPEC from oraddman.tspmd_item_avl x where x.VENDOR_CODE ='"+VENDOR+"' and nvl(x.ACTIVE_FLAG,'') ='Y') avl"+  //add by Peggy 20130719
					 " WHERE A.ORGANIZATION_ID = 49"+
					 //" AND a.attribute3='006'"+ //add by Peggy 20240304
					 " AND tsc_om_category (a.inventory_item_id, a.organization_id,'TSC_PROD_GROUP') in ('PMD','PRD-Subcon','PRD','SSD')"+
                     " and A.STOCK_ENABLED_FLAG ='Y' "+
					 " and A.MTL_TRANSACTIONS_ENABLED_FLAG = 'Y'"+
                     " and A.INVENTORY_ITEM_STATUS_CODE <> 'Inactive'"+
                     " and upper(A.DESCRIPTION) not like '%DISABLE%'"+ 
                     //" AND substr(A.SEGMENT1,9,2)=tpn.packing_code(+)"+
                     " AND TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_Package')=tpn.d_attribute2(+)"+
					 " AND case when length(NVL (a.packing_code, '-1'))>2 then substr(a.packing_code,1,2) else a.packing_code end = tpn.d_value(+)"+
					 //" AND TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_Package')=tpn.D_ATTRIBUTE2(+)"+
					 " AND case when length(NVL (a.packing_code, '-1'))>2 then substr(a.packing_code,1,2) else a.packing_code end = tpn1.d_value(+)"+
					 " AND a.inventory_item_id = avl.inventory_item_id(+)"; //add by Peggy 20130719
			if (WIPTYPE.equals("03") || WIPTYPE.equals("05") || !LINENO.equals(""))  //CP follow重工 by Peggy 20220126
			{
				sql +=" AND A.ORGANIZATION_ID=bom.ORGANIZATION_ID(+)"+
                   	 " AND A.INVENTORY_ITEM_ID=bom.assembly_item_id(+)";
			}
			else
			{
				sql +=" AND A.ORGANIZATION_ID=bom.ORGANIZATION_ID"+
                     " AND A.INVENTORY_ITEM_ID=bom.assembly_item_id";
			}
			//add by Peeggy 20131120
			//if (WIPTYPE.equals("03"))
			//{
			//	sql += " and bom.IS_PREFERRED='Y'";
			//}
		}
		if (SearchStr != null && !SearchStr.equals(""))
		{
			sql += " AND (a.SEGMENT1 like '"+SearchStr+"%' or a.DESCRIPTION like '"+SearchStr+"%')"; 
		}
		else if (ITEMNAME != null && !ITEMNAME.equals(""))
		{
			//if (WIPTYPE.equals("03") &&  !LINENO.equals(""))
			if ((WIPTYPE.equals("03") ||WIPTYPE.equals("05")) &&  !LINENO.equals(""))  //CP follow重工 by Peggy 20220126
			{
				sql += " AND ( a.SEGMENT1 like '"+ITEMNAME+"%' or a.DESCRIPTION like '"+ITEMNAME+"%')"; 
			}
			else
			{
				sql += " AND a.SEGMENT1 like '"+ITEMNAME+"%'"; 
			}
		}
		else if (ITEMDESC != null && !ITEMDESC.equals(""))
		{
			sql += " AND a.DESCRIPTION like '"+ITEMDESC+"'"; 		
		}
		//out.println(sql);
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
		for (int i=1;i<=colCount-3;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
		} //end of for 
		out.println("</TR>");
		String ItemID="";
		String ItemName="";
		String ItemDesc="";
		String ItemPackage="";
		String DieID="";
		String DieName="";
		String PackingType="";
		String Price="0";
		String PriceUom="";       //add by Peggy 20120726
		String PriceList="";      //add by Peggy 20120803
		String DieQty="0";        //add by Peggy 20121009
		String BillSeqID="";      //add by Peggy 20121012
		String QTY_UNIT="";       //add by Peggy 20121105
		String PACKAGE_SPEC="";   //add by Peggy 20130719
		String TEST_SPEC="";      //add by Peggy 20130719
		String AVL="";            //add by Peggy 20130719
		String MARKING="";        //add by Peggy 20130722
		String DIEITEM="";        //add by Peggy 20130726
		String TSC_Family="";     //add by Peggy 20150814
		String ORGANIZATION_ID="";//add by Peggy 20161106
		String PROD_GROUP="";     //add by Peggy 20161109
		String ITEM_TYPE="";      //add by Peggy 20220817
		int queryCount=0;
		String buttonContent=null;
		while (rs.next())
		{
			ItemID=rs.getString("ITEM_ID");
			ItemName=rs.getString("ITEM_NAME");
			ItemDesc=rs.getString("DESCRIPTION");
			ItemPackage=rs.getString("TSC_PACKAGE");
			if (ItemPackage ==null) ItemPackage="";
			PackingType=rs.getString("packing_type");
			BillSeqID=rs.getString("BILL_SEQUENCE_ID"); //add by Peggy 20121012
			PACKAGE_SPEC=rs.getString("PACKAGE_SPEC");  //add by Peggy 20130719
			if (PACKAGE_SPEC==null) PACKAGE_SPEC="";
			TEST_SPEC=rs.getString("TEST_SPEC");        //add by Peggy 20130719
			if (TEST_SPEC==null) TEST_SPEC="";
			TSC_Family = rs.getString("TSC_FAMILY");    //add by Peggy 20150814
			ORGANIZATION_ID=rs.getString("ORGANIZATION_ID"); //add by Peggy 20161106
			PROD_GROUP=rs.getString("PROD_GROUP");   //add by Peggy 20161109
			ITEM_TYPE=rs.getString("ITEM_TYPE");     //add by Peggy 20220817
			DieID="";
			DieName="";
			DieQty="0";
			AVL="";
			MARKING=rs.getString("marking_code");  //add by Peggy 20190322
			DIEITEM=""; //add by Peggy 20130726
			
			//if ((WIPTYPE.equals("03") && BillSeqID != null) || (!WIPTYPE.equals("03") && LINENO.equals("")))
			//if (((WIPTYPE.equals("03") || WIPTYPE.equals("05")) && BillSeqID != null && !rs.getString("item_type").toUpperCase().equals("WAFER")) || (!WIPTYPE.equals("03") && !WIPTYPE.equals("05") && LINENO.equals(""))) //CP follow重工 by Peggy 20220126
			if (((WIPTYPE.equals("03") || WIPTYPE.equals("05")) && BillSeqID != null && !rs.getString("item_type").toUpperCase().equals("WAFER") && !rs.getString("TSC_PACKAGE").toUpperCase().equals("WAFER")) || (!WIPTYPE.equals("03") && !WIPTYPE.equals("05") && LINENO.equals(""))) //CP follow重工 by Peggy 20220126
			{
				sql = " select distinct replace(msi.description,'\"','&quot;') DIE_NAME, msi.inventory_item_id DIE_ID,bic.COMPONENT_QUANTITY ,msi.segment1 DIEITEM"+
					 ",substr(msi.segment1,length(msi.segment1)-2,1) lcode"+
					 " from bom_inventory_components bic,APPS.MTL_SYSTEM_ITEMS msi"+
					 " where bic.bill_sequence_id ='"+BillSeqID+"'"+
					 " AND (bic.DISABLE_DATE is null or trunc(bic.DISABLE_DATE) > trunc(sysdate))"+					 
					 " AND bic.component_item_id=msi.INVENTORY_ITEM_ID"+
					 " AND msi.ORGANIZATION_ID="+ORGANIZATION_ID+"";
				//out.println(sql);
				Statement statement8=con.createStatement();
				ResultSet rs8=statement8.executeQuery(sql);
				while (rs8.next())
				{
					DieID += ((!DieID.equals(""))?","+rs8.getString("DIE_ID"):rs8.getString("DIE_ID"));
					DieName+=((!DieName.equals(""))?","+rs8.getString("DIE_NAME"):rs8.getString("DIE_NAME"));
					DIEITEM += ((!DIEITEM.equals(""))?","+rs8.getString("DIEITEM"):rs8.getString("DIEITEM"));
					DieQty = ""+(Float.parseFloat(DieQty)+Float.parseFloat(rs8.getString("COMPONENT_QUANTITY")));
				}
				rs8.close();
				statement8.close();
			}
			//else if (WIPTYPE.equals("03") && BillSeqID ==null)
			//else if (WIPTYPE.equals("03") && (BillSeqID ==null || rs.getString("item_type").toUpperCase().equals("WAFER")))
			//else if ((WIPTYPE.equals("03") || WIPTYPE.equals("05")) && (BillSeqID ==null || rs.getString("item_type").toUpperCase().equals("WAFER"))) //CP follow重工 by Peggy 20220126
			else if ((WIPTYPE.equals("03") || WIPTYPE.equals("05")) && (BillSeqID ==null || rs.getString("item_type").toUpperCase().equals("WAFER") || rs.getString("TSC_PACKAGE").toUpperCase().equals("WAFER"))) //加package判斷 by Peggy 20220208
			{
				DieID = ItemID;
				DieName ="N/A";
				DIEITEM ="N/A";
				DieQty = "";
			}
			
			//add by Peggy 20130722
			if (WIPTYPE.equals("01"))
			{
				//add by Peggy 20130719
				sql = " select distinct VENDOR_CODE from oraddman.tspmd_item_avl x where INVENTORY_ITEM_ID ='"+ItemID+"' and nvl(x.ACTIVE_FLAG,'') ='Y'";
				//out.println(sql);
				Statement statement3=con.createStatement();
				ResultSet rs3=statement3.executeQuery(sql);
				while (rs3.next())
				{
					if (AVL.length() >0) AVL+=",";
					AVL += rs3.getString("VENDOR_CODE");
				}
				rs3.close();
				statement3.close();

				sql = " select MARKING from (SELECT a.INVENTORY_ITEM_NAME,a.VENDOR_CODE, a.MARKING,row_number() over (partition by a.VENDOR_CODE,a.INVENTORY_ITEM_NAME order by a.CREATION_DATE desc) ROW_CNT"+
					  //" FROM oraddman.tspmd_oem_headers_all a  where STATUS='Approved' AND a.VENDOR_CODE='"+VENDOR+"' AND a.WIP_TYPE_NO='"+WIPTYPE+"' AND a.INVENTORY_ITEM_ID='"+ItemID+"' AND a.MARKING <>'N/A') a where row_cnt =1";
					  " FROM oraddman.tspmd_oem_headers_all a  where STATUS='Approved' AND a.WIP_TYPE_NO='"+WIPTYPE+"' AND a.INVENTORY_ITEM_ID='"+ItemID+"' AND a.MARKING <>'N/A') a where row_cnt =1";  //依型號判別marking for nono,modify by Peggy 20191217
				//out.println(sql);	  
				Statement statement5=con.createStatement();
				ResultSet rs5=statement5.executeQuery(sql);
				while (rs5.next())
				{
					MARKING = rs5.getString("MARKING");
				}
				rs5.close();
				statement5.close();
			}
			else if (WIPTYPE.equals("02"))  //add by Peggy 20191021
			{
				sql = " select MARKING FROM oraddman.tspmd_oem_headers_all a  where STATUS='Approved' AND a.REQUEST_NO='"+REQUESTNO+"' ORDER BY a.VERSION_ID desc";
				//out.println(sql);	  
				Statement statement5=con.createStatement();
				ResultSet rs5=statement5.executeQuery(sql);
				while (rs5.next())
				{
					MARKING = rs5.getString("MARKING");
				}
				rs5.close();
				statement5.close();
			} 

			if (FUNCNAME.equals("F2-001") || FUNCNAME.startsWith("F1"))
			{
				//sql = " SELECT  a.unit_price  FROM oraddman.tspmd_item_quotation a  "+
				//      " where vendor_code ='"+VENDOR+"'  and inventory_item_id='"+ItemID+"' and VENDOR_SITE_ID='"+ VENDOR_SITE_ID+"'"+
			    //		" and "+ QTY + " between a.start_qty and a.end_qty";
				sql = " SELECT distinct decode( LOWER(a.uom),'kpcs','k',LOWER(a.uom)) UOM,(select b.unit_price  from  oraddman.tspmd_item_quotation b"+
                      " where b.vendor_code =a.vendor_code  and b.inventory_item_id=a.inventory_item_id and b.VENDOR_SITE_ID=a.VENDOR_SITE_ID"+
                      " and decode(LOWER(b.uom),'ea',b.start_qty/1000,b.start_qty) <= "+ QTY +" and decode(LOWER(b.uom),'ea',b.end_qty/1000,b.end_qty) >="+ QTY +") unit_price"+
                      " FROM oraddman.tspmd_item_quotation a  ";
				if (FUNCNAME.startsWith("F2-001"))
				{
                	sql += " where a.inventory_item_id='"+ItemID+"' and exists (select 1 from ( select x.vendor_code,x.vendor_site_id,x.inventory_item_id,row_number() over (PARTITION by x.vendor_code,x.vendor_site_id, x.inventory_item_id order by x.creation_date desc) as rowcnt"+
                           " from oraddman.tspmd_item_quotation x where x.inventory_item_id='"+ItemID+"') y where rowcnt =1 and y.VENDOR_SITE_ID=a.VENDOR_SITE_ID and y.vendor_code=a.vendor_code)";
				}
				else
				{
					sql += " where a.vendor_code ='"+VENDOR+"' and a.inventory_item_id='"+ItemID+"' and a.VENDOR_SITE_ID='"+ VENDOR_SITE_ID+"'";
				}
				//out.println(sql);
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(sql);
				if (rs1.next())
				{
					PriceUom = rs1.getString("uom");
					Price = (new DecimalFormat("####0.###")).format(Float.parseFloat((rs1.getString("unit_price")==null?"0":rs1.getString("unit_price"))));
				}
				rs1.close();
				statement1.close();
				
				if (FUNCNAME.equals("F2-001"))
				{
					sql = " SELECT a.end_qty, a.unit_price"+
                          " FROM oraddman.tspmd_item_quotation a  "+
						  " where a.inventory_item_id='"+ItemID+"' and exists (select 1 from ( select x.vendor_code,x.vendor_site_id,x.inventory_item_id,row_number() over (PARTITION by x.vendor_code,x.vendor_site_id,x.inventory_item_id order by x.creation_date desc) as rowcnt"+
                          " from oraddman.tspmd_item_quotation x where x.inventory_item_id='"+ItemID+"') y where rowcnt =1 and y.VENDOR_SITE_ID=a.VENDOR_SITE_ID and y.vendor_code=a.vendor_code)";
                          //" where a.vendor_code ='"+VENDOR+"' and a.inventory_item_id='"+ItemID+"' and a.VENDOR_SITE_ID='"+ VENDOR_SITE_ID+"'";
					//out.println(sql);
					Statement statement2=con.createStatement();
					ResultSet rs2=statement2.executeQuery(sql);
					while (rs2.next())
					{
						PriceList += (rs2.getString("end_qty")+"="+ (new DecimalFormat("####0.###")).format(Float.parseFloat(rs2.getString("unit_price")))+",");
					}
					//out.println(PriceList);
					rs2.close();
					statement2.close();

					//modify by Peggy on 20131212
					/*
					sql = " select DECODE(x.DATA_TYPE,'ITEM',1,DECODE(x.DATA_NAME,'OTHER',3,2)) SEQNO, QTY_UNIT from oraddman.TSPMD_QUOTATION_UNIT_SETUP x where (x.DATA_TYPE='ITEM' AND x.DATA_NAME='"+ItemName+"') or (x.DATA_TYPE='PACKAGE' AND x.DATA_NAME IN ('"+ItemPackage+"','OTHER')) order by 1";
					Statement statement3=con.createStatement();
					ResultSet rs3=statement3.executeQuery(sql);
					while (rs3.next())
					{
						QTY_UNIT = rs3.getString("QTY_UNIT");
					}
					//out.println(PriceList);
					rs3.close();
					statement3.close();
					*/
					QTY_UNIT ="0";
				}
			}
			//buttonContent="this.value=sendToMainWindow("+'"'+ItemID+'"'+','+'"'+ItemName+'"'+','+'"'+ItemDesc+'"'+","+'"'+ItemPackage+'"'+","+'"'+DieName+'"'+","+'"'+DieID+'"'+","+'"'+LINENO+'"'+","+'"'+PackingType+'"'+","+'"'+FUNCNAME+'"'+","+'"'+Price+'"'+")";		
			buttonContent="this.value=sendToMainWindow('"+ItemID+"','"+ItemName+"','"+ItemDesc+"','"+ItemPackage+"','"+DieName+"','"+DieID+"','"+LINENO+"','"+PackingType+"','"+FUNCNAME+"','"+Price+"','"+PriceUom +"','"+PriceList+"','"+DieQty+"','"+QTY_UNIT+"','"+PACKAGE_SPEC+"','"+TEST_SPEC+"','"+AVL+"','"+(queryCount+1)+"','"+DIEITEM+"','"+TSC_Family+"','"+BillSeqID+"','"+ORGANIZATION_ID+"','"+PROD_GROUP+"','"+ITEM_TYPE+"')";	 //add BillSeqID by Peggy 20160914				
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE='button' NAME='button1' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			//out.println("' onClick='"+buttonContent+"'></TD>");		
			out.println("' onClick="+'"'+buttonContent+'"'+"></TD>");		
			for (int i=1;i<=colCount-3;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				if (md.getColumnLabel(i).equals("DIE_NAME"))
				{
					s=DieName;
				}
				if (md.getColumnLabel(i).equals("DIE_ID"))
				{
					s=DieID; 
				}
				out.println("<TD align='left'><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT></TD>");
			} //end of for
			out.println("</TR>");
			out.println("<input type='hidden' name='ITEM_ID' value='"+ItemID+"'>");
			out.println("<input type='hidden' name='ITEM_NAME' value='"+ItemName+"'>");
			out.println("<input type='hidden' name='DESCRIPTION' value='"+ItemDesc+"'>");
			out.println("<input type='hidden' name='TSC_PACKAGE' value='"+ItemPackage+"'>");
			out.println("<input type='hidden' name='DIENAME' value='"+DieName+"'>");
			out.println("<input type='hidden' name='DIEID' value='"+DieID+"'>");
			out.println("<input type='hidden' name='PACKINGTYPE' value='"+PackingType+"'>");
			out.println("<input type='hidden' name='PRICE' value='"+Price+"'>");
			out.println("<input type='hidden' name='PRICEUOM' value='"+PriceUom+"'>");
			out.println("<input type='hidden' name='PRICELIST' value='"+PriceList+"'>");
			out.println("<input type='hidden' name='WIPTYPE' value='"+WIPTYPE+"'>");
			out.println("<input type='hidden' name='DIEQTY' value='"+DieQty+"'>");
			out.println("<input type='hidden' name='QTY_UNIT' value='"+QTY_UNIT+"'>");
			out.println("<input type='hidden' name='PACKAGESPEC' value='"+PACKAGE_SPEC+"'>");
			out.println("<input type='hidden' name='TESTSPEC' value='"+TEST_SPEC+"'>");
			out.println("<input type='hidden' name='AVL' value='"+AVL+"'>");
			out.println("<input type='hidden' name='MARKING_"+(queryCount+1)+"' value='"+(MARKING==null?"":MARKING)+"'>");
			out.println("<input type='hidden' name='DIEITEM' value='"+DIEITEM+"'>");
			out.println("<input type='hidden' name='TSC_FAMILY' value='"+TSC_Family+"'>");
			out.println("<input type='hidden' name='BILLSEQID' value='"+BillSeqID+"'>");  //add by Peggy 20160914
			out.println("<input type='hidden' name='ORGANIZATION_ID' value='"+ORGANIZATION_ID+"'>");  //add by Peggy 20161106
			out.println("<input type='hidden' name='PROD_GROUP' value='"+PROD_GROUP+"'>");  //add by Peggy 20161109
			out.println("<input type='hidden' name='ITEM_TYPE' value='"+ITEM_TYPE+"'>");  //add by Peggy 20220817
			
			queryCount++;	
		} //end of while
		out.println("</TABLE>");						
		rs.close();    
		%>
		<input type="hidden" name="VENDOR" value="<%=VENDOR%>">
		<input type="hidden" name="FUNCNAME" value="<%=FUNCNAME%>">		
		<input type='hidden' name='LINENO' value="<%=LINENO%>">
		<%   
		//out.println("queryCount="+queryCount);
	    if (queryCount ==1) //若取到的查詢數 == 1
	    {		
			out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+ItemID+'"'+","+'"'+ItemName+'"'+","+'"'+ItemDesc+'"'+","+'"'+ItemPackage+'"'+","+'"'+DieName+'"'+","+'"'+DieID+'"'+","+'"'+LINENO+'"'+","+'"'+PackingType+'"'+","+'"'+FUNCNAME+'"'+","+'"'+Price+'"'+","+'"'+PriceUom +'"'+","+'"'+PriceList+'"'+","+'"'+DieQty+'"'+","+'"'+QTY_UNIT+'"'+","+'"'+PACKAGE_SPEC+'"'+","+'"'+TEST_SPEC+'"'+","+'"'+AVL+'"'+","+'"'+(queryCount+1)+'"'+","+'"'+DIEITEM+'"'+","+'"'+TSC_Family+'"'+","+'"'+BillSeqID+'"'+","+'"'+ORGANIZATION_ID+'"'+","+'"'+PROD_GROUP+'"'+","+'"'+ITEM_TYPE+'"'+")</script>"); 
		}
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
%>
 <BR>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
