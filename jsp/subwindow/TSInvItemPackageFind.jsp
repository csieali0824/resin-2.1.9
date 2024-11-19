<!--20090604 liling 增加TSC_PROD_GROUP的判斷區分各PROD的MOQ數量不同 -->
<!--20140814 by Peggy,TSCE AU客戶且為SMA系列產品只能從山東出貨-->
<!--20141024 by Peggy,use function:tsc_get_item_packing_code get tsc_packing_code-->
<!--20150416 by Peggy,特定客戶指定特定line type-->
<!--20150721 by Peggy,tsc_edi_pkg.get_shipping_method增加order type-->
<!--20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!--20151119 by Peggy,add TSC_PROD_FAMILY column-->
<!--20160114 by Peggy,call function TSC_GET_ITEM_SPQ_MOQ get spq,moq,sample_spq  value-->
<!--20160318 by Peggy,客戶單價有定義時,自動帶入-->
<!--20160513 by Peggy,for TSC_EDI_PKG.GET_SHIPPING_METHOD新增customer_id而修改-->
<!--20161228 by Peggy,ITEM STATUS=NRND FOR SAMPLE ALERT-->
<!--20170425 by Peggy,add YEWFLAG field-->
<!--20180720 Peggy,for TSCA CUSTOMER DIGIKEY ISSUE-->
<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String invItem=request.getParameter("INVITEM");
if (invItem==null) invItem="";
String invItem1=request.getParameter("INVITEM1");
if (invItem1==null) invItem1="";
String itemDesc=request.getParameter("ITEMDESC");
if (itemDesc==null) itemDesc="";
String itemDesc1=request.getParameter("ITEMDESC1");
if (itemDesc1==null) itemDesc1="";
String sampleOrdCh=request.getParameter("SAMPLEORDCH");
String searchString=request.getParameter("SEARCHSTRING");
String plantCode=request.getParameter("PLANTCODE");
if (plantCode == null) plantCode = "";
String salesAreaNo=request.getParameter("SALESAREA");
if (salesAreaNo == null) salesAreaNo = "";
String sType = request.getParameter("sType");
if (sType == null) sType ="0";
String OdrType = request.getParameter("ORDERTYPE");
if (OdrType == null) OdrType = "";
String plantDesc=request.getParameter("PLANTDESC");
String LINENO=request.getParameter("LINENO");  //add by Peggy 20130604
if (LINENO==null) LINENO="";
String CRD = request.getParameter("CRD"); //add by Peggy 20131118
if (CRD==null) CRD="";
String MarketGroup = request.getParameter("MARKETGROUP"); //add by Peggy 20131118
if (MarketGroup==null) MarketGroup="";
String customerID = request.getParameter("CUSTOMERID"); //add by Peggy 20131118
if (customerID ==null) customerID ="";
String FOB = request.getParameter("FOB");
if (FOB==null) FOB="";  //add by Peggy 20140529
String priceList = request.getParameter("PRICELIST");
if (priceList==null || priceList.equals("--")) priceList="";  //add by Peggy 20160318
String shippingMethod="",SSD ="";//add by Peggy 20131118
String deliverid = request.getParameter("deliverid"); //add by Peggy 20210208
if (deliverid==null) deliverid="";
String currency="",sellingprice="",yew_flag="",tsceonhand="",itemID="",coo="";   //add by Peggy 20160318
String tscPacking=null,tscFamily=null,tscProdGroup="",sPQP=null,sMOP=null,SPQRULE="",ORDERTYPE="",UOM="",tscProdFamily="",item_status="",packing_ins="";//add SPQRULE,ORDERTYPE by Peggy 20120516

if (sampleOrdCh != null)
{
	if (sampleOrdCh=="N" || sampleOrdCh.equals("N")) 
	{
		sampleOrdCh="false";
	}
	else if (sampleOrdCh=="Y" || sampleOrdCh.equals("Y")) 
	{
		sampleOrdCh="true";
	}
}
else
{
	sampleOrdCh="false";
}
// 20110407 Marvie Add : FairChild MOQ
String sCustomerId= request.getParameter("CUSTOMERID");
if (sCustomerId == null) sCustomerId = "";
try
{
	if (searchString==null)
   	{
    	if (invItem!=null && !invItem.equals(""))
		{ 
			searchString= invItem.toUpperCase(); 
		}
		else if (itemDesc != null && !itemDesc.equals(""))
		{  
			searchString = itemDesc.toUpperCase(); 
		}
    	else 
		{ 
			searchString="%"; //out.println("NULL input");
%>
	      <script LANGUAGE="JavaScript"> 
            flag=confirm("This query could take a long time. Do you wish to continue?");
            if (flag==false)  { this.window.close(); } //alert("test");}//
          </script> 
<%   
		}
	}
} 
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}  
String lineType = "";
%>
<html>
<head>
<title>Page for choose TSC Item or Item Description to add to Sales DRQ Item List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(invItem,itemDesc,sPQP,MOQP,plantCode,sType,tscPackage,orderType,lineType,SPQRULE,lineNo,UOM,ShippingMethod,SSD,itemID,sellingprice,itemstatus,yewflag,tsceonhand,packing_ins)
{   
	var CRD = "";
	var shippingmethod ="";
	var requestdate ="";
	if (sType == "D9002" || sType == "D11001" )
	{
		window.opener.document.MYFORM.elements["TSC_ITEM_"+lineNo].value=invItem; 
		window.opener.document.MYFORM.elements["MOQ_"+lineNo].value=MOQP; 
		window.opener.document.MYFORM.elements["SPQ_"+lineNo].value=sPQP; 
		window.opener.document.MYFORM.elements["PLANTCODE_"+lineNo].value=plantCode; 
		window.opener.document.MYFORM.elements["UOM_"+lineNo].value=UOM;   //add by Peggy 20130910
		window.opener.document.MYFORM.elements["TSC_ITEM_PACKAGE_"+lineNo].value=tscPackage;
		if (window.opener.document.MYFORM.elements["ORDER_TYPE_"+lineNo].value!="1215")
		{
			window.opener.document.MYFORM.elements["ORDER_TYPE_"+lineNo].value=orderType; //add by Peggy 20131118
			window.opener.document.MYFORM.elements["LINE_TYPE_"+lineNo].value=lineType; //add by Peggy 20131118
		}
		window.opener.document.MYFORM.elements["SHIPPINGMETHOD_"+lineNo].value=ShippingMethod; //add by Peggy 20131118
		window.opener.document.MYFORM.elements["SSD_"+lineNo].value=SSD; //add by Peggy 20131118
		if (sType == "D11001")
		{
			window.opener.document.MYFORM.elements["YEWFLAG_"+lineNo].value=yewflag; //add by Peggy 20170512
		}
		if (window.opener.document.MYFORM.elements["CUST_ITEM_"+lineNo].value=="N/A" || (sType == "D9002" && window.opener.document.MYFORM.ERPCUSTOMERID.value ==7147 && window.opener.document.MYFORM.elements["CUST_ITEM_"+lineNo].value==window.opener.document.MYFORM.elements["TSC_ITEM_DESC_"+lineNo].value))  //add by Peggy 20210825
		{
			window.opener.document.MYFORM.elements["TSC_ITEM_ID_"+lineNo].value=itemID; 
		}
		if (window.opener.document.MYFORM.SALESAREANO.value=="001")
		{
			if (orderType=="1214")
			{
				if (plantCode=="008" || plantCode=="002")
				{
					//window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value="CIF MUNICH";
					window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value="EX WORKS";  //20220105起改為EX WORKS FROM EMILY
				}
				else if (plantCode=="011" || plantCode=="006" || plantCode=="010")
				{
					window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value="C&I MUNICH";
				}
				else if (plantCode=="005") //add by Peggy 20220105
				{
					if (packing_ins=="I")
					{
						window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value="C&I MUNICH";
					}
					else
					{
						window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value="EX WORKS";  
					}
				}							
			}
			else if (orderType=="1141")
			{
				if (window.opener.document.MYFORM.FOB.value.substring(0,3)=="FOB")
				{
					window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value="FOB TAIWAN";
				}
				else
				{
					window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value=window.opener.document.MYFORM.FOB.value;
				}	
			}
		}
	}
	else
	{
		window.opener.document.MYFORM.INVITEM.value=invItem; 
		window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
		window.opener.document.MYFORM.SPQP.value=sPQP;
		if (sType == "D1001" || sType == "D1009")
		{
			window.opener.document.MYFORM.MOQP.value=MOQP; 
			window.opener.document.MYFORM.SPQRULE.value=SPQRULE; 
			window.opener.document.MYFORM.PLANTCODE.value=plantCode; 
			window.opener.document.MYFORM.TSCPACKAGE.value=tscPackage;
			window.opener.document.MYFORM.INVFLAG.value="";      //add by Peggy 20120305
			window.opener.document.MYFORM.ITEMSTATUS.value=itemstatus;      //add by Peggy 20161228
			window.opener.document.MYFORM.YEWFLAG.value=yewflag;      //add by Peggy 20170425
			if (sellingprice!=null && sellingprice !="" && sellingprice !="null")
			{
				window.opener.document.MYFORM.UPRICE.value=sellingprice; //add by Peggy 20160318
			}
			if (window.opener.document.MYFORM.SALESAREANO.value !="020" && window.opener.document.MYFORM.SALESAREANO.value !="021" && window.opener.document.MYFORM.SALESAREANO.value !="022") //add by Peggy 20120423
			{
				if (window.opener.document.MYFORM.CURR.value !="NTD" && window.opener.document.MYFORM.CURR.value !="TWD")  //add by Peggy 20120427		
				{
					if (window.opener.document.MYFORM.PREORDERTYPE.value=="1342")  //add by Peggy 20120523
					{
						//add by Peggy 20131202
						if (sType == "D1001")
						{
							window.opener.document.MYFORM.LINEODRTYPE.value="1214";
							window.opener.document.MYFORM.LINETYPE.value="1113";
							if (window.opener.document.MYFORM.SALESAREANO.value=="001")
							{
								if ((plantCode=="008" || plantCode=="002")  && orderType=="1214")
								{
									//window.opener.document.MYFORM.LINEFOB.value="CIF MUNICH";
									window.opener.document.MYFORM.LINEFOB.value="EX WORKS"; //20220105起改為EX WORKS FROM EMILY
								}
								else if ((plantCode=="011" || plantCode=="006" || plantCode=="010")  && orderType=="1214")
								{
									window.opener.document.MYFORM.LINEFOB.value="C&I MUNICH";
								}
								else if (plantCode=="005") //add by Peggy 20220105
								{
									if (packing_ins=="I")
									{
										window.opener.document.MYFORM.LINEFOB.value="C&I MUNICH";
									}
									else
									{
										window.opener.document.MYFORM.LINEFOB.value="EX WORKS";  
									}
								}								
							}
						}
					}
					else
					{
						window.opener.document.MYFORM.LINEODRTYPE.value = orderType; //add by Peggy 20120423
						if (window.opener.document.MYFORM.CUSTOMERNO.value=="2439"	&& orderType=="1156")
						{
							window.opener.document.MYFORM.LINETYPE.value="1173"; //add by Peggy 20120430
						}
						else
						{
							window.opener.document.MYFORM.LINETYPE.value=lineType;  //add by Peggy 20120423	
						}
						//add by Peggy 20121030
						if (sType == "D1001" && (window.opener.document.MYFORM.SALESAREANO.value=="001" || window.opener.document.MYFORM.SALESAREANO.value=="004")) //add TSCR by Peggy 20131219 
						{
							if (window.opener.document.MYFORM.FOBPOINT.value.substring(0,3)=="FOB" && orderType=="1141")
							{
								window.opener.document.MYFORM.LINEFOB.value="FOB TAIWAN";
							}
							else if (window.opener.document.MYFORM.FOBPOINT.value=="FCA I-LAN" || window.opener.document.MYFORM.FOBPOINT.value=="FCA YANGXIN XIAN" || window.opener.document.MYFORM.FOBPOINT.value=="FCA TIANJIN")
							{
								if (orderType=="1141")
								{
									window.opener.document.MYFORM.LINEFOB.value="FCA I-LAN";
								}
								else if (orderType=="1156")
								{
									window.opener.document.MYFORM.LINEFOB.value="FCA YANGXIN XIAN";
								}
								else if (orderType=="1142")
								{
									window.opener.document.MYFORM.LINEFOB.value="FCA TIANJIN";
								}
								else
								{
									window.opener.document.MYFORM.LINEFOB.value="";
								}								
							}
							else
							{
								window.opener.document.MYFORM.LINEFOB.value=window.opener.document.MYFORM.FOBPOINT.value;
							}
						}
					}
					
					if (window.opener.document.MYFORM.SALESAREANO.value == "008")  //TSCA issue,add by Peggy 20180719
					{
						if (window.opener.document.MYFORM.SHIPTOORG.value=="55839" && window.opener.document.MYFORM.LINEODRTYPE.value=="1141")
						{
							window.opener.document.MYFORM.LINEFOB.value="FCA";	
							window.opener.document.MYFORM.SHIPPINGMETHOD.value="FEDEX ECNOMY";	
						}
					}
					//add by Peggy 20190628
					if (window.opener.document.MYFORM.SALESAREANO.value == "002")
					{
						if (window.opener.document.MYFORM.CUSTOMERNO.value=="25071")
						{
							if (window.opener.document.MYFORM.LINEODRTYPE.value=="1141")					
							{
								window.opener.document.MYFORM.SHIPPINGMETHOD.value="UPS EXPRESS";
							}
							else
							{
								window.opener.document.MYFORM.SHIPPINGMETHOD.value="TRUCK";
							}
						}
					}
				}
				else
				{
					window.opener.document.MYFORM.LINEODRTYPE.value = "1131"; //add by Peggy 20120427
					window.opener.document.MYFORM.LINETYPE.value="1007";  //add by Peggy 20120427	
				}
			}
			if (window.opener.document.MYFORM.SALESAREANO.value == "001")
			{
				CRD = window.opener.document.MYFORM.CRD.value;
				if (window.opener.document.MYFORM.FOBPOINT.value!="FCA I-LAN" && window.opener.document.MYFORM.FOBPOINT.value!="FCA YANGXIN XIAN" && window.opener.document.MYFORM.FOBPOINT.value!="FCA TIANJIN")
				{				
					shippingmethod = window.opener.document.MYFORM.SHIPPINGMETHOD.value;
				}
				if ( sType == "D1001")
				{
					if (window.opener.document.MYFORM.TSCPACKAGE.value=="SMA" && window.opener.document.MYFORM.CUSTMARKETGROUP.value=="AU" && yewflag=="1")
					{
						window.opener.document.MYFORM.btplant.disabled=false;
					}
					else
					{
						window.opener.document.MYFORM.btplant.disabled=true;
					}
				  	window.opener.document.MYFORM.tsceonhand.value="Stock:"+tsceonhand+"K"; //add by Peggy 20190521
				}
			}
			requestdate = window.opener.document.MYFORM.REQUESTDATE.value;
			
			//add by JB 20241021 WAFER料號直接帶LineType 1503
			if (tscPackage == "WAFER" || invItem.charAt(2) == "-")
			{
				window.opener.document.MYFORM.LINETYPE.value="1503";
			}
		}
	
		if ( sType =="D1001" && CRD != null &&  CRD != "" && shippingmethod != null && shippingmethod != "" && (requestdate == null || requestdate == ""))
		{
			window.opener.document.MYFORM.REQUESTDATE.focus(); 
		}
		else if (window.opener.document.MYFORM.ORDERQTY.value==null || window.opener.document.MYFORM.ORDERQTY.value=="")
		{ 
			window.opener.document.MYFORM.ORDERQTY.focus();
		}
		else 
		{
			window.opener.document.MYFORM.REQUESTDATE.focus(); 
		}		
	}
 	this.window.close();
}

</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 10px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 10px } 
  TD        { font-family: Tahoma,Georgia;font-size: 10px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 10px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 10px }
</STYLE>
<body onBlur="this.focus();">  
<FORM METHOD="post" ACTION="TSInvItemPackageFind.jsp" name=ITEMFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%> style="font-family: Tahoma,Georgia">
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>" style="font-family: Tahoma,Georgia"><BR>
  -----<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
<%  
	int queryCount = 0, querySPQCount = 0;
    Statement statement=con.createStatement();
	try
    { 
		if (searchString!="" && searchString!=null) 
	   	{ 
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
		
		 	String sqly = " select  CURRENCY_CODE "+
				          " from qp_list_headers_v "+
					      " where ACTIVE_FLAG = 'Y' "+
						  " and TO_CHAR(LIST_HEADER_ID) > '0'"+
						  " AND NAME NOT LIKE 'TSC_%'"+ //不抓台半TP價
						  " and LIST_HEADER_ID='"+priceList+"'"; 	
			//out.println(sqly);				
 			Statement statementy=con.createStatement();
       		ResultSet rsy=statement.executeQuery(sqly);
			if (rsy.next())
			{
				currency=rsy.getString("CURRENCY_CODE");
			}
			else
			{
				priceList="";
			}
			rsy.close();
			statementy.close();
				
	    	String sqlCNT = "select count(a.SEGMENT1) from APPS.MTL_SYSTEM_ITEMS a  , ORADDMAN.TSPROD_MANUFACTORY B ";
			String sql = "select tsc_get_item_coo(a.inventory_item_id) coo,"+ //add by Peggy 20240708
                     "        SEGMENT1,"+
			         "        DESCRIPTION, "+
				     "        TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,1100000146) as CUSTOMER_CODE, "+ //add by Peggy 20200105
		             "        TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,23) as TSC_PACKAGE, "+          //I1讀不到,再抓IM,modify by Peggy 20130223
		             "        TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,21) as TSC_FAMILY, "+	           //I1讀不到,再抓IM,modify by Peggy 20130223
				     "        CASE WHEN TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,1100000003) IN ('PMD','SSP','SSD') THEN TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,1100000004) ELSE '' END as TSC_PROD_FAMILY, "+ //add by Peggy 20151122
				     "        TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,1100000003) as TSC_PROD_GROUP, "+ //I1讀不到,再抓IM,modify by Peggy 20130223
                     "        b.MANUFACTORY_NO PLANTCODE , B.MANUFACTORY_NAME "+	
					 "       ,a.INVENTORY_ITEM_STATUS_CODE"+ //add by Peggy 20161228
	   			     //"       ,nvl(case when b.MANUFACTORY_NO='005' and ('"+OdrType+"' not in ('1015','1342','1021','1022','1743','1707') or '"+OdrType+"' is null) then tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) "+
					 //"       else (SELECT DISTINCT  x.ORDER_NUM"+
					 //"       FROM ORADDMAN.TSAREA_ORDERCLS  x ,ORADDMAN.TSPROD_ORDERTYPE y "+					 
                     //"       WHERE x.ACTIVE ='Y' "+
					 //"       AND x.ORDER_NUM = y.ORDER_NUM"+
					 //"       AND x.SAREA_NO = '"+salesAreaNo+"' "+
					 //"       AND y.MANUFACTORY_NO = b.MANUFACTORY_NO" +
					 //"       AND x.OTYPE_ID ='"+OdrType+"') end ,nvl(tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id),'')) ORDER_TYPE"+ //modify by Peggy 20191122
			    	 "        ,case when '"+OdrType+"' in ('1015','1342','1021','1022','1743','1707','1763') then (SELECT DISTINCT  x.ORDER_NUM FROM ORADDMAN.TSAREA_ORDERCLS  x ,ORADDMAN.TSPROD_ORDERTYPE y WHERE x.ACTIVE ='Y' "+
				     "           AND x.ORDER_NUM = y.ORDER_NUM"+
				     "           AND x.SAREA_NO = '"+salesAreaNo+"' "+
				     "           AND y.MANUFACTORY_NO = b.MANUFACTORY_NO" +
				     "           AND x.OTYPE_ID ='"+OdrType+"') " +
					 "         else "+
				     "          case when b.MANUFACTORY_NO IN ('005') then tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) "+
					 "          when b.MANUFACTORY_NO IN ('011') and '"+OdrType+"' not in ('1743','1707') then tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) "+ // Add by Mars 20240821
					 "          when b.MANUFACTORY_NO IN ('002') and '" + salesAreaNo +"' in('008') and TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,23) in ('SMA','SMB','SMC','SOD-123W','SOD-128') then '1141' "+ // Add by Mars 20241105
                 	 "		    else tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(b.MANUFACTORY_NO) end end ORDER_TYPE "+ 	 //011 Add by Peggy 20240604
					 "  ,PRIMARY_UOM_CODE"+//add by Peggy 20130910
				  	 "  ,a.inventory_item_id"+//add by Peggy 20140430
   				     "  ,b.TSC_PROD_GROUP PROD_GROUP"+//add by Peggy 20151122
					 "  ,tsc_get_item_packing_code(ORGANIZATION_ID ,INVENTORY_ITEM_ID) tsc_packing_code"+ //add by Peggy 20141024
					 "  ,Tsc_Om_Get_Target_Price_0702(ORGANIZATION_ID ,INVENTORY_ITEM_ID,'PCE','"+priceList+"',trunc(sysdate),'"+currency+"',b.alname) item_price"+  //add by Peggy 20160318
                     ",(SELECT COUNT(1) FROM INV.MTL_SYSTEM_ITEMS_B MSIB WHERE MSIB.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND MSIB.ORGANIZATION_ID=327) YEW_FLAG "+ //ADD BY PEGGY 20170425
					 ",tsc_edi_pkg.GET_ONSEMI_ONHAND(a.inventory_item_id,'KPC')  tsceonhand"+ //add by Peggy 20190521
					 ",TSC_ORDER_WAREHOUSE_VALUE(a.inventory_item_id,tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id),'PACKINGINSTRUCTIONS','"+customerID+"') packing_instructions"+//add by Peggy 20220105
		             "  from APPS.MTL_SYSTEM_ITEMS A, ORADDMAN.TSPROD_MANUFACTORY B ";
			String where="where ORGANIZATION_ID = '49'"+
			         //"  and B.MANUFACTORY_NO = a.attribute3(+) "+		
					 "  and  ','|| a.attribute3||NVL2(trim(ATTRIBUTE17),','||trim(ATTRIBUTE17),'') ||',' LIKE '%,'||b.MANUFACTORY_NO||',%'"+ //modify by Peggy 20200929			 
					 "  and STOCK_ENABLED_FLAG ='Y' and MTL_TRANSACTIONS_ENABLED_FLAG = 'Y' "+ // 2007/03/28 避免更改 Item 屬性為 N 導致的RFQ 無法生成MO問題
					 "  and a.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' "+
					 "  and DESCRIPTION not like '%Disable%' "+ //// 取 TSC_Package 及 TSC_Family 的分類, 且不包含已被設定為 Disable的料項
					 "  and NVL(a.CUSTOMER_ORDER_FLAG,'N')='Y'"+  //add by Peggy 20151008
					 "  and NVL(a.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+  //add by Peggy 20151008
					 "  and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'";  //add by Peggy 20230116
			if (searchString=="%" || searchString.equals("%"))			
			{  
		 		where = where + "and (SEGMENT1 like '%') ";
			}
			else 
			{ 
		 		where = where + "and (upper(SEGMENT1) like '"+searchString.toUpperCase()+"' "+
				" or upper(DESCRIPTION) like '"+searchString.toUpperCase()+"%') ";
			}    
		 	
			Statement stateCNT=con.createStatement();
			sqlCNT=sqlCNT+where;
			ResultSet rsCNT = stateCNT.executeQuery(sqlCNT);
			if (rsCNT.next()) queryCount = rsCNT.getInt(1);
			rsCNT.close();
			stateCNT.close();
			if (queryCount==0) //若取到的查詢數 == 0 ,若找不到半筆,則可能是無設定於包裝Category內(賣零散無包裝產品),那麼,就檢核料件主檔即可
	    	{
		  		sql = "select tsc_get_item_coo(a.inventory_item_id) coo"+ //add by Peggy 20240708
                " ,a.SEGMENT1, a.DESCRIPTION"+
				"  ,'' CUSTOMER_CODE,"+  //add by Peggy 20200105
				" 'NO PACKAGE' as TSC_PACKAGE,"+
				" 'NO FAMILY' as TSC_FAMILY, 'NO PROD_FAMILY' as TSC_PROG_FAMILY , 'NO PROD_GROUP' as TSC_PROG_GROUP ,b.MANUFACTORY_NO as PLANTCODE, b.MANUFACTORY_NO "+
  			    "  ,a.INVENTORY_ITEM_STATUS_CODE"+ //add by Peggy 20161228
	   			//" ,nvl(case when b.MANUFACTORY_NO='005' and ('"+OdrType+"' not in ('1015','1342','1021','1022','1743','1707') or '"+OdrType+"' is null) then tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) "+
				//" else (SELECT DISTINCT  x.ORDER_NUM  FROM ORADDMAN.TSAREA_ORDERCLS  x ,ORADDMAN.TSPROD_ORDERTYPE y "+
				//"       WHERE x.ACTIVE ='Y'  AND x.ORDER_NUM = y.ORDER_NUM  and x.SAREA_NO = '"+salesAreaNo+"'  AND y.MANUFACTORY_NO = b.MANUFACTORY_NO" +
				//"       AND x.OTYPE_ID ='"+OdrType+"') end ,nvl(tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id),'')) ORDER_TYPE"+ //modify by Peggy 20191122
			    "        ,case when '"+OdrType+"' in ('1015','1342','1021','1022','1743','1707') then (SELECT DISTINCT  x.ORDER_NUM FROM ORADDMAN.TSAREA_ORDERCLS  x ,ORADDMAN.TSPROD_ORDERTYPE y WHERE x.ACTIVE ='Y' "+
				"           AND x.ORDER_NUM = y.ORDER_NUM"+
				"           AND x.SAREA_NO = '"+salesAreaNo+"' "+
				"           AND y.MANUFACTORY_NO = b.MANUFACTORY_NO" +
				"           AND x.OTYPE_ID ='"+OdrType+"') " +
						"else "+
				"         case when b.MANUFACTORY_NO in ('005') then tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) " +
				"         when b.MANUFACTORY_NO in ('011') then tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) "+
				"         when b.MANUFACTORY_NO IN ('002') and '" + salesAreaNo +"' in('008') and TSC_INV_CATEGORY(INVENTORY_ITEM_ID,43,23) in ('SMA','SMB','SMC','SOD-123W','SOD-128') then '1141' "+ // Add by Mars 20241105
				"         else tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(b.MANUFACTORY_NO) end end ORDER_TYPE"+   //011 Add by Peggy 20240604
				"  ,PRIMARY_UOM_CODE"+//add by Peggy 20130910
				"  ,a.inventory_item_id"+//add by Peggy 20140430
				"  ,b.TSC_PROD_GROUP PROD_GROUP"+//add by Peggy 20151122
				"  ,Tsc_Om_Get_Target_Price_0702(ORGANIZATION_ID ,INVENTORY_ITEM_ID,'PCE','"+priceList+"',trunc(sysdate),'"+currency+"',b.alname) item_price"+  //add by Peggy 20160318
                "  ,(SELECT COUNT(1) FROM INV.MTL_SYSTEM_ITEMS_B MSIB WHERE MSIB.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND MSIB.ORGANIZATION_ID=327) YEW_FLAG "+ //ADD BY PEGGY 20170425
			    "  ,tsc_edi_pkg.GET_ONSEMI_ONHAND(a.inventory_item_id,'KPC')  tsceonhand"+ //add by Peggy 20190521
 			    "  ,TSC_ORDER_WAREHOUSE_VALUE(a.inventory_item_id,tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id),'PACKINGINSTRUCTIONS','"+customerID+"') packing_instructions"+//add by Peggy 20220105
		        "  from APPS.MTL_SYSTEM_ITEMS a , ORADDMAN.TSPROD_MANUFACTORY b ";
	      		where=" where a.ORGANIZATION_ID = '49' "+
				      " and a.DESCRIPTION not like '%Disable%' "+
					  " and a.DESCRIPTION not like '%disable%'  "+
		              " and a.STOCK_ENABLED_FLAG ='Y'"+
					  " and a.MTL_TRANSACTIONS_ENABLED_FLAG = 'Y'"+
					  " and a.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' "+
					  //" and b.MANUFACTORY_NO = a.attribute3(+) "+
					 "  and  ','|| a.attribute3||NVL2(trim(ATTRIBUTE17),','||trim(ATTRIBUTE17),'') ||',' LIKE '%,'||b.MANUFACTORY_NO||',%'"+ //modify by Peggy 20200929			 
					  " and NVL(a.CUSTOMER_ORDER_FLAG,'N')='Y'"+  //add by Peggy 20151008
					  " and NVL(a.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+  //add by Peggy 20151008
					  " and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'";  //add by Peggy 20230116
				
		  		if (searchString=="%" || searchString.equals("%"))			
		  		{  
		   			where = where + "and (a.SEGMENT1 like '%') ";		   
		  		}
		  		else 
		  		{ 
		   			where = where + "and (upper(a.SEGMENT1) like '"+searchString.toUpperCase()+"'"+
					" or upper(DESCRIPTION) like '"+searchString.toUpperCase()+"%') ";		   
		  		}    
			}  // End of if (queryCount==0)
		
			sql = sql + where+" ORDER BY CASE WHEN SUBSTR(tsc_get_item_packing_code(ORGANIZATION_ID ,INVENTORY_ITEM_ID),1,2)='QQ' THEN 1 ELSE 2 END,DESCRIPTION"; //20201005 packing code=QQ Priority 1
			//out.println(sql);
        	ResultSet rs=statement.executeQuery(sql);
		    
        	out.println("<TABLE>");    
			out.println("<TR BGCOLOR=BLACK style='color:#ffffff'><TD width='3%'>&nbsp;</TD>");  
			out.println("<TD width='3%'>COO</TD>");			
			out.println("<TD width='18%'>SEGMENT1</TD>");
			out.println("<TD width='12%'>DESCRIPTION</TD>");
			out.println("<TD width='7%'>CUSTOMER CODE</TD>");
			out.println("<TD width='7%'>TSC_PACKAGE</TD>");
			out.println("<TD width='7%'>TSC_FAMILY</TD>");
			out.println("<TD width='7%'>TSC_PROD_FAMILY</TD>");
			out.println("<TD width='7%'>TSC_PROD_GROUP</TD>");
			out.println("<TD width='5%'>PLANTCODE</TD>");
			out.println("<TD width='11%'>PLANTDESC</TD>");
			out.println("<TD width='6%'>STATUS</TD>");
		 
			if (sampleOrdCh ==null || sampleOrdCh.equals("false"))
			{ // 未選定為樣品訂單,則以 MOQ 為限定值回傳
		 		out.println("<TD BGCOLOR=BLACK>"+"SPQP (KPC)"+"</TD>"); // 最後一欄帶入訂購最小包裝量
			} 
			else if (sampleOrdCh.equals("true")) 
		    {
			    out.println("<TD BGCOLOR=BLACK>"+"SPQP (KPC)"+"</TD>"); // 最後一欄帶入訂購最小包裝量
		   	}    
			out.println("<TD BGCOLOR=BLACK>"+"MOQP (KPC)"+"</TD>"); // 最小包裝量		
        	out.println("</TR>");
			tscPacking=null;tscFamily=null;tscProdGroup="";sPQP=null;sMOP=null;SPQRULE="";ORDERTYPE="";UOM="";tscProdFamily="";item_status="";//add SPQRULE,ORDERTYPE by Peggy 20120516
        	String buttonContent=null;		
        	while (rs.next())
        	{
		 		invItem1=rs.getString("SEGMENT1");
		 		itemDesc1=rs.getString("DESCRIPTION");
		 		tscPacking=rs.getString("TSC_PACKAGE");
		 		if (tscPacking==null) tscPacking="";
		 		tscFamily=rs.getString("TSC_FAMILY");	
		 		if (tscFamily==null) tscFamily="";
				plantCode=rs.getString("PLANTCODE");
				ORDERTYPE = rs.getString("ORDER_TYPE");
				itemID =rs.getString("INVENTORY_ITEM_ID"); //add by Peggy 20140430
		 		tscProdFamily=rs.getString("TSC_PROD_FAMILY");	
		 		if (tscProdFamily==null) tscProdFamily="";
				sellingprice=rs.getString("item_price");  //add by Peggy 20160318
				item_status=rs.getString("INVENTORY_ITEM_STATUS_CODE");  //add by Peggy 20161228
				yew_flag=rs.getString("YEW_FLAG");  //add by Peggy 20170425
				tsceonhand = rs.getString("tsceonhand"); //add by Peggy 20190521
				packing_ins = rs.getString("packing_instructions"); //add by Peggy 20220105
				coo=rs.getString("coo"); //add by Peggy 20240708
				
				if ((OdrType.equals("1302") || OdrType.equals("1165")) &&  salesAreaNo.equals("012")) //add by Peggy 20140114
				{
					plantCode ="002";
					if (OdrType.equals("1302"))
					{
						ORDERTYPE="4121";
					}
					else if (OdrType.equals("1165"))
					{
						ORDERTYPE="4131";
					}
				}
				UOM =rs.getString("PRIMARY_UOM_CODE");//add by Peggy 20130910
				tscProdGroup=rs.getString("prod_group"); //add by Peggy 20151122
		 		if (tscProdGroup==null) tscProdGroup="";
         		plantDesc=rs.getString("MANUFACTORY_NAME");	
				String packMethodCode=rs.getString("tsc_packing_code"); //modify by Peggy 20141024
				//modify by Peggy 20140814
				if (MarketGroup.equals("AU") && tscPacking.equals("SMA") && salesAreaNo.equals("001") && yew_flag.equals("1"))
				{
					ORDERTYPE="1156";
				}
				if (sType.equals("D11001") && salesAreaNo.equals("001"))
				{
					ORDERTYPE="1214";
				}
				
				//add by Peggy 20140529
				if (salesAreaNo.equals("001"))
				{
					if (FOB.toUpperCase().equals("FOB TAIWAN"))
					{
						if (ORDERTYPE.equals("1156") || ORDERTYPE.equals("1142"))
						{
							ORDERTYPE="1141";
						}
					}
				}
				
				//add by Peggy 20120423
				if (ORDERTYPE != null && !ORDERTYPE.equals(""))
				{
					Statement stateX=con.createStatement();
					//String sqlx = " SELECT DISTINCT  a.DEFAULT_ORDER_LINE_TYPE FROM ORADDMAN.TSAREA_ORDERCLS  A  WHERE A.ACTIVE ='Y'  AND A.ORDER_NUM = '"+ORDERTYPE+"'";
					//add by Peggy 20150416
					String sqlx = " select 1,TO_CHAR(LINE_TYPE_ID) LINE_TYPE_ID from oraddman.tsc_cust_line_type where CUSTOMER_ID='"+sCustomerId+"' and NVL(ACTIVE_FLAG,'N')='A' AND ORDER_TYPE='"+ORDERTYPE+"'"+
								  " UNION ALL"+
								  " SELECT DISTINCT 2, a.DEFAULT_ORDER_LINE_TYPE FROM ORADDMAN.TSAREA_ORDERCLS  A  WHERE A.ACTIVE ='Y'  AND A.ORDER_NUM = '"+ORDERTYPE+"'";
					if (!salesAreaNo.equals("")) sqlx += " and a.SAREA_NO='"+ salesAreaNo+"'";
					sqlx += " order by 1";
					//out.println(sqlx);
		    		ResultSet rsX=stateX.executeQuery(sqlx);
		 			if (rsX.next())
		 			{	
						lineType = rsX.getString(2);			
					}
					rsX.close();
					stateX.close();
				}
				
				//add by Peggy 20131118
				if (sType.equals("D9002") || sType.equals("D11001"))
				{
					//modify by Peggy 20150721
					//CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?)}");
					CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}"); //add by Peggy 20160513
					csf.setString(1,salesAreaNo);
					csf.setString(2,tscPacking);      
					csf.setString(3,tscFamily);                   
					csf.setString(4,itemDesc1);    
					csf.setString(5,CRD);   
					csf.registerOutParameter(6, Types.VARCHAR);  
					csf.setString(7,ORDERTYPE);   
					csf.setString(8,plantCode);   
					csf.setString(9,sCustomerId);   //add by Peggy 20160513 
					csf.setString(10,FOB);   //add by Peggy 20190319
					csf.setString(11,deliverid);    //add by Peggy 20190319 
					csf.execute();					
					shippingMethod = csf.getString(6);

					if (sType.equals("D11001"))  //add by Peggy 20140116
					{
						Statement state3=con.createStatement();     
						ResultSet rs3=state3.executeQuery("SELECT tsce_buffernet_po_pkg.GET_PO_SSD('"+CRD+"','"+shippingMethod+"','"+plantCode+"',sysdate,'"+customerID+"','"+FOB+"','"+deliverid+"') from dual");
						if (rs3.next())	
						{ 
							SSD =rs3.getString(1);	
						}
						else
						{
							SSD ="";
						}
						rs3.close();
						state3.close();					
					}
					else
					{
						CallableStatement cs3 = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");			 
						cs3.setString(1,salesAreaNo); 
						cs3.setString(2,plantCode); 
						cs3.setString(3,CRD); 
						cs3.setString(4,shippingMethod);  
						cs3.setString(5,ORDERTYPE);
						cs3.registerOutParameter(6, Types.VARCHAR);
						cs3.setInt(7,Integer.parseInt(customerID));
						cs3.setString(8,FOB);  //add by Peggy 20210207
						cs3.setString(9,deliverid);  //add by Peggy 20210207
						cs3.execute();
						SSD = cs3.getString(6);
						cs3.close();
					}
				}
				else
				{
					shippingMethod="";
					SSD ="";
				}

		 		out.println("<input type='hidden' name='COO' value='"+coo+"' >");
		 		out.println("<input type='hidden' name='INVITEM' value='"+invItem1+"' >");
		 		out.println("<input type='hidden' name='ITEMDESC1' value='"+itemDesc1+"' >");
         		out.println("<input type='hidden' name='PLANTCODE' value='"+plantCode+"' >");       //20090515 liling 補上,以利1筆資料 windows.closed
         		out.println("<input type='hidden' name='sType' value='"+sType+"' >");
				out.println("<input type='hidden' name='TSCPACKAGE' value='"+tscPacking+"'>");      
				out.println("<input type='hidden' name='ORDERTYPE' value='"+ORDERTYPE+"'>");  //Add by Peggy 20120423    
				out.println("<input type='hidden' name='LINETYPE' value='"+lineType +"'>");  //Add by Peggy 20120423    
				out.println("<input type='hidden' name='LINENO' value='"+LINENO +"'>");  //Add by Peggy 20130604
				out.println("<input type='hidden' name='UOM' value='"+UOM+"'>");  //Add by Peggy 20130910
				out.println("<input type='hidden' name='SHIPPINGMETHOD' value='"+shippingMethod+"'>");  //Add by Peggy 20131118
				out.println("<input type='hidden' name='SSD' value='"+SSD+"'>");  //Add by Peggy 20131118
				out.println("<input type='hidden' name='ITEMID' value='"+itemID+"'>");  //Add by Peggy 20140430
				out.println("<input type='hidden' name='SELLING_PRICE' value='"+sellingprice+"'>");  //Add by Peggy 20160318
				out.println("<input type='hidden' name='ITEM_STATUS' value='"+item_status+"'>");  //Add by Peggy 20161228
				out.println("<input type='hidden' name='YEWFLAG' value='"+yew_flag+"'>");  //Add by Peggy 20170425
				out.println("<input type='hidden' name='TSCEONHAND' value='"+tsceonhand+"'>");  //Add by Peggy 20190521
				out.println("<input type='hidden' name='PACKING_INS' value='"+packing_ins+"'>");  //Add by Peggy 20220105
				
		 		
				String sqlSPQ= "";
		  		if (sCustomerId.equals("1220") && (sampleOrdCh==null || sampleOrdCh.equals("false"))) 
				{
            		//sqlSPQ = "select (MOQ / 1000) SPQ, (MOQ / 1000) MOQ,(SAMPLE_SPQ /1000) SAMPLE_SPQ from ORADDMAN.TSITEM_PACKING_CATE a "+
		    		// " where a.INT_TYPE = 'FSC' "+
					//   " and a.TSC_OUTLINE = '"+tscPacking+"' "+
					//   " and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b "+
					//   							" where b.INT_TYPE = a.INT_TYPE "+
					//							  " and b.TSC_OUTLINE = a.TSC_OUTLINE) ";
					//20160114 by Peggy,call spq moq function
					sqlSPQ = "SELECT  (MOQ / 1000) SPQ, (MOQ / 1000) MOQ,(SAMPLE_SPQ /1000) SAMPLE_SPQ  from table(TSC_GET_ITEM_SPQ_MOQ("+itemID+",'FSC',NULL))";
		  		} 
				else 
				{
					//20160114 by Peggy,call spq moq function
					sqlSPQ = "SELECT  (SPQ / 1000) SPQ, (MOQ / 1000) MOQ,(SAMPLE_SPQ /1000) SAMPLE_SPQ  from table(TSC_GET_ITEM_SPQ_MOQ("+itemID+",'TS','"+plantCode+"'))";
            		//sqlSPQ = "select (SPQ / 1000) SPQ, (MOQ / 1000) MOQ,(SAMPLE_SPQ /1000) SAMPLE_SPQ from ORADDMAN.TSITEM_PACKING_CATE a "+ //add sample spq field by Peggy on 20120516
		            // " where a.INT_TYPE in ('TS','NBU') "+
					//   " and a.TSC_OUTLINE = '"+tscPacking+"' "+
					//   " and a.PACKAGE_CODE = '"+packMethodCode+"' "+
					//   " and a.TSC_FAMILY = '"+tscFamily+"' "+
					//   " and nvl(a.TSC_PROD_FAMILY,'XX') = nvl('"+tscProdFamily+"','XX') "+
					//   " and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b " +
					//                           " where b.INT_TYPE = a.INT_TYPE "+
					//						     " and b.TSC_OUTLINE = a.TSC_OUTLINE "+        
					//						     " and b.PACKAGE_CODE = a.PACKAGE_CODE "+
					//						     " and b.TSC_FAMILY = a.TSC_FAMILY "+
					//						     " and NVL(b.TSC_PROD_FAMILY,'XX') = NVL(a.TSC_PROD_FAMILY,'XX') "+
					//						     " and b.TSC_PROD_GROUP = a.TSC_PROD_GROUP) "+
					//							 " and a.TSC_PROD_GROUP = '"+tscProdGroup+"' ";  //PMD MOQ,SPQ資料已補入,modify by Peggy 20140509
            		//if (tscProdGroup=="Rect-Subcon" || tscProdGroup.equals("Rect-Subcon") ||
		        	//	tscProdGroup=="Rect" || tscProdGroup.equals("Rect") ||
			    	//	tscProdGroup=="SSP" || tscProdGroup.equals("SSP")) 
					//{
              		//	sqlSPQ=sqlSPQ+ " and a.TSC_PROD_GROUP = '"+tscProdGroup+"' ";
					//}
		  		}

				//if (searchString.equals("ES2CA")) out.println(sqlSPQ);
				//out.println(sqlSPQ);
		    	Statement stateSPQP=con.createStatement();
		    	ResultSet rsSPQP=stateSPQP.executeQuery(sqlSPQ); 																									 
		 		if (rsSPQP.next())
		 		{
		   			sMOP = rsSPQP.getString("MOQ");
           			if (sMOP==null || sMOP.equals("null")) sMOP="0";
		   			if (sampleOrdCh==null || sampleOrdCh.equals("false"))
		   			{ 
		   				sPQP = rsSPQP.getString("SPQ");
						SPQRULE = sMOP;
		   			}
		   			else if (sampleOrdCh.equals("true"))
		         	{ 
		   				sPQP = rsSPQP.getString("SAMPLE_SPQ");
						SPQRULE = sPQP;
						ORDERTYPE = "1121";
		         	}
		   			if (sPQP==null || sPQP.equals("null")) sPQP="0";
		   			if (SPQRULE==null || SPQRULE.equals("null")) SPQRULE="0";
				} 
				else 
				{
		         	sPQP = "0"; sMOP = "0"; SPQRULE = "0";
				} // 找不到則設定mOQP = 0
				out.println("<input type=hidden name='SPQP' value='"+sPQP+"'>");
				out.println("<input type=hidden name='MOQ' value='"+sMOP+"'>");   
				out.println("<input type=hidden name='SPQRULE' value='"+SPQRULE+"'>");   
				buttonContent="this.value=sendToMainWindow("+'"'+invItem1+'"'+","+'"'+itemDesc1+'"'+","+'"'+sPQP+'"'+","+'"'+sMOP+'"'+","+'"'+plantCode+'"'+","+'"'+sType+'"'+","+'"'+tscPacking+'"'+","+ORDERTYPE+","+'"'+lineType+'"'+","+'"'+SPQRULE+'"'+","+'"'+LINENO+'"'+","+'"'+UOM+'"'+","+'"'+shippingMethod+'"'+","+'"'+SSD+'"'+","+'"'+itemID+'"'+","+'"'+sellingprice+'"'+","+'"'+item_status+'"'+","+'"'+yew_flag+'"'+","+'"'+tsceonhand+'"'+","+'"'+packing_ins+'"'+")";	
		 		rsSPQP.close();
		 		stateSPQP.close();		 
		 
        		out.print("<TR BGCOLOR=E3E3CF><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 		out.println("' onClick='"+buttonContent+"'></TD>");		
		 		for (int i=1;i<=11;i++) 
				{ //i=要顯示的欄位數 每多select 一欄顯示即要修改
           			String s=(String)rs.getString(i);
		   			if (s==null) s="&nbsp;";
           			out.println("<TD>"+s+"</TD>");		 
         		} //end of for
		 		if (sampleOrdCh==null || sampleOrdCh.equals("false")) 
				{ // 未選定為樣品訂單,則以 MOQ 為限定值回傳
		   			out.println("<TD align='right'>"+sPQP+"</TD>");  // 最後一欄帶入訂購最小包裝量 
		   			out.println("<TD align='right'>"+sMOP+"</TD>");  // 最後一欄帶入訂購最小包裝量     
		 		} 
				else if (sampleOrdCh.equals("true")) 
				{ // 若選定為樣品訂單  
		   			out.println("<TD align='right'>"+sPQP+"</TD>");  // 最後一欄帶入訂購最小包裝量 
		   			out.println("<TD align='right'>"+sMOP+"</TD>");  // 最後一欄帶入訂購最小包裝量     
		 		}
         		out.println("</TR>");	
        	} //end of while
        	out.println("</TABLE>");						
        	rs.close();       
	   	}//end of while
   
	   	if (queryCount==1 && ((itemDesc.equals(itemDesc1) && (!itemDesc.equals("") || !itemDesc1.equals(""))) || (invItem.equals(invItem1) && (!invItem.equals("") || !invItem1.equals(""))))) //若取到的查詢數 == 1
	   	{  
			out.print("<script type=\"text/javascript\">sendToMainWindow("+'"'+invItem1+'"'+","+'"'+itemDesc1+'"'+","+'"'+sPQP+'"'+","+'"'+sMOP+'"'+","+'"'+plantCode+'"'+","+'"'+sType+'"'+","+'"'+tscPacking+'"'+","+ORDERTYPE+","+'"'+lineType+'"'+","+'"'+SPQRULE+'"'+","+'"'+LINENO+'"'+","+'"'+UOM+'"'+","+'"'+shippingMethod+'"'+","+'"'+SSD+'"'+","+'"'+itemID+'"'+","+'"'+sellingprice+'"'+","+'"'+item_status+'"'+","+'"'+yew_flag+'"'+","+'"'+tsceonhand+'"'+","+'"'+packing_ins+'"'+")</script>"); 
		}
	} //end of try
	catch (Exception e)
	{
		out.println("Exception2:"+e.getMessage());
	}
statement.close();
%>
<BR>
<input type="hidden" name="SALESAREA" value="<%=salesAreaNo%>">
<input type="hidden" name="FOB" value="<%=FOB%>">
<input type="hidden" name="sType" value="<%=sType%>">
<input type="hidden" name="ITEMDESC" value="<%=itemDesc%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
