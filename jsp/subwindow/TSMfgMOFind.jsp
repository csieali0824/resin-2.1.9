<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<%
String runCardNo=request.getParameter("RUNCARDNO");
String invItem=request.getParameter("INVITEM"); 
String itemDesc=request.getParameter("ITEMDESC");
String itemId=request.getParameter("ITEMID"); 
String semiItemID=request.getParameter("SEMIITEMID");

String oeOrderNo=request.getParameter("OEORDERNO"); 
String oeLineQtyCh=request.getParameter("OELINEQTY"); 
String woType=request.getParameter("WOTYPE"); //20090120
String searchString=request.getParameter("SEARCHSTRING");
String marketType=request.getParameter("MARKETTYPE");
String alternateRouting=request.getParameter("ALTERNATEROUTING");
String organizationId=request.getParameter("ORGANIZATIONID");

 
//String custLotAlert=request.getParameter("CUSTLOTALERT");  // 2007/08/02 定義客戶流程卡編碼的警告(使用者未選擇特殊客戶編號,當選定的銷售訂單對應客戶被定義於特殊批號)

String customerName=null,customerPo=null,woQty=null,woUom=null,endDate=null;
String oeHeaderId=null,oeLineId=null,customerId=null;
String defaultWoQty=null,frontRunCard=null,oeLineQty=null,moUom=null;
String tscAmp=null,tscFamily=null,tscPackage=null,tscPacking=null;
String dateCode=null;
String orderPartnoQty="",wipPartnoQty="";//add by Peggy 20191007
String v_show="",wip_msg="";          //add by Peggy 20201208
 
String dateShipSugDate=null; // 出貨日前5天的日期 

String q[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容	


float leftAddQty = 0;

if (oeLineQtyCh==null || oeLineQtyCh.equals("")) oeLineQtyCh = "0";

//if (custLotAlert==null || custLotAlert.equals("")) custLotAlert = "N"; // 預設值是 N , 當出現選定後段工令對應銷售訂單客戶是需要特定批號卻選擇一般客戶,則系統警告訊息

String runCardDesc = null; // ItemDesc
String runCardGet = "";  // itemCodeGet
int runCardGetLength = 0;   // itemCodeGetLength
//By Choose MarketType Pick Organization_id--Kerwin
String parOrgID = "";

try
{
	Statement stateORG=con.createStatement();	 
    ResultSet rsORG=stateORG.executeQuery("select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
	//out.println("select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
    if (rsORG.next()) 
	{
		parOrgID = rsORG.getString(1);
	   	organizationId = rsORG.getString(2); 
	} 
	else 
	{
	%>			 
		<script language="javascript">
			alert("No Org found , Please Choose Market Type !!!");					   
			window.opener.document.MYFORM.MARKETTYPE.focus();
			// this.window.close(); 
		</script>
	<%
	}
	rsORG.close();
	stateORG.close();
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
} 
//By Choose MarketType Pick Organization_id--Kerwin
 
float moQty=0;
String exceedFlag = "N";

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
		else if (oeOrderNo != null && !oeOrderNo.equals(""))
		{  
			searchString = oeOrderNo.toUpperCase(); 
		}	
	    else 
		{ 
			searchString="%"; //out.println("NULL input");
	%>
	 	     <script LANGUAGE="JavaScript"> 
        	  <!-- 
		    	//alert("test");
           
            	flag=confirm("This query could take a long time. Do you wish to continue?");
            	if (flag==false)  { this.window.close(); } //alert("test");}//
            	//else  return(false);
           
          		// --> 
          	</script> 
	<% 
		}
   	} //end if
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}   
%>
<html>
<head>
<title>Page for choose Item List</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
</head>
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
//function sendToMainWindow(jNo,oeOrderNo,invItem,itemDesc,woQty,woUom,endDate,customerName,customerPo,oeHeaderId,oeLineId,itemId,customerId,defaultWoQty,frontRunCard,oeLineQty,moUom,exceedFlag,tscAmp,tscFamily,tscPackage,tscPacking,dateCode,unShipMoQty)
function sendToMainWindow(jNo,oeOrderNo,invItem,itemDesc,woQty,woUom,endDate,customerName,customerPo,oeHeaderId,oeLineId,itemId,customerId,defaultWoQty,frontRunCard,oeLineQty,moUom,exceedFlag,tscAmp,tscFamily,tscPackage,tscPacking,dateCode,unShipMoQty,odrPartQty,wipPartQty)
{
	if (exceedFlag=="Y")
	{
		alert("加入此項次後,累計選定數量已大於MO單需求數!!!\n           此張流程卡剩餘數將為下次所使用");
	}
		  
	if (eval(odrPartQty)<=eval(wipPartQty))
	{
		if (!confirm("訂單:"+oeOrderNo+" 型號:"+itemDesc+" 工單量已滿足訂單量,確定要再下工單?")) return false;
	}
	//add by Peggy 20221128
	if (document.getElementById(oeLineId).value!="PASS")
	{
		if (!confirm("訂單:"+oeOrderNo+" 型號:"+itemDesc+" "+document.getElementById(oeLineId).value)) return false;
	}
	
	if (customerPo==null || customerPo=="null") customerPo="";
    window.opener.document.MYFORM.OEORDERNO.value=oeOrderNo; 
	window.opener.document.MYFORM.OELINEQTY.value=oeLineQty; 
	window.opener.document.MYFORM.OEQTYUOM.value=moUom;
    window.opener.document.MYFORM.INVITEM.value=invItem; 
    window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
    window.opener.document.MYFORM.WOQTY.value=woQty;
    window.opener.document.MYFORM.WOUOM.value=woUom; 
    window.opener.document.MYFORM.ENDDATE.value=endDate; 
    window.opener.document.MYFORM.CUSTOMERNAME.value=customerName; 
    window.opener.document.MYFORM.CUSTOMERPO.value=customerPo;   
    window.opener.document.MYFORM.OEHEADERID.value=oeHeaderId;   
    window.opener.document.MYFORM.OELINEID.value=oeLineId;  
    window.opener.document.MYFORM.ITEMID.value=itemId;   
    window.opener.document.MYFORM.CUSTOMERID.value=customerId;  
    window.opener.document.MYFORM.FRONTRUNCARD.value=frontRunCard;
	window.opener.document.MYFORM.TSCPACKAGE.value=tscPackage;
	window.opener.document.MYFORM.TSCFAMILY.value=tscFamily;
	window.opener.document.MYFORM.TSCPACKING.value=tscPacking;
	window.opener.document.MYFORM.DATECODE.value=dateCode;
	window.opener.document.MYFORM.ORDERQTY.value=unShipMoQty;
	this.window.close();
}

function setFindMO()
{
	if (document.SUBMOFORM.OEORDERNO.value==null || document.SUBMOFORM.OEORDERNO.value=="")
   	{
    	alert("請輸入特定MO單狀態作MO單內容查詢!!!");
       	return false;	   
   	} 
   	subWin=window.open("../subwindow/TSMfgMOAdmFind.jsp?OEORDERNO="+document.SUBMOFORM.OEORDERNO.value+"&MARKETTYPE="+document.SUBMOFORM.ORGANIZATIONID.value,"subwin","width=640,height=480,scrollbars=yes,menubar=yes");    
}
</script>
<body >  
<FORM name="SUBMOFORM" METHOD="post" ACTION="TSMfgMoFind.jsp">
  <font color="#000099">請輸入MO單開立之成品料號: <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  <font color="#000099">-----依MO單開立後段工令資訊-------------------------------------------- </font>     
  <BR>
  查詢訂單詳細內容<input type="text" name='OEORDERNO' value="" size="15"><input type="button" name="FINDMO" value="訂單內容" onClick='setFindMO()'>  
  <BR>
  <%  
   
			   
Statement statement=con.createStatement();
String strtable="";
try
{ 
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	cs1.setString(1,parOrgID); // By Choose market Set Client info
	cs1.execute();	 			  
		 
	 // 組合MO單下的成品料號對應出半成品料號,作為找前段流程卡依據_起(若使用者輸入ORDER NO作查詢依據)
	String semiItemDesc = null;
    String semiItemCodeGet = "";
    int semiItemCodeGetLength = 0;   
	String hold_flag=""; //add by Peggy 20220221
	if (oeOrderNo!=null && !oeOrderNo.equals(""))
	{
		String ItemDesc = null;
		String itemCodeGet = "";
		int itemCodeGetLength = 0;     
		Statement stateItemDesc=con.createStatement(); 
		//20100820 liling update  修正原有客品料號會撈錯
		// ResultSet rsItemDesc=stateItemDesc.executeQuery("select ORDERED_ITEM_ID from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER ='"+oeOrderNo+"' ");
		ResultSet rsItemDesc=stateItemDesc.executeQuery("select INVENTORY_ITEM_ID from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER ='"+oeOrderNo+"' ");
		while (rsItemDesc.next()) 
        { 
        	ItemDesc = rsItemDesc.getString(1);
	        itemCodeGet = itemCodeGet+"'"+ItemDesc+"'"+","; 
        }
        rsItemDesc.close();
        stateItemDesc.close(); 
			 
		// out.println("select ORDERED_ITEM_ID from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER ='"+oeOrderNo+"' ");
        // 取當月條件內的機種成品料號 //
        if (itemCodeGet.length()>0)
        {   //out.println(itemCodeGet);     
        	itemCodeGetLength = itemCodeGet.length()-1;
            itemCodeGet = itemCodeGet.substring(0,itemCodeGetLength);
        } 
			
		// 取BOM_COMPONENT 內動應的半成品料號_起			 
		if (itemCodeGet!=null && !itemCodeGet.equals(""))			 
		{
			Statement stateBC=con.createStatement(); 
            ResultSet rsBC=stateBC.executeQuery(" select  /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */  COMPONENT_ITEM_ID "+
			                                     " from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b "+
												// " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and to_char(b.ASSEMBLY_ITEM_ID) in ("+itemCodeGet+")  and a.DISABLE_DATE is null "); //20130925 liling add   a.DISABLE_DATE is null
												" where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and to_char(b.ASSEMBLY_ITEM_ID) in ("+itemCodeGet+")  "+
												"   and b.organization_Id ="+organizationId+
												"   and sysdate between EFFECTIVITY_DATE  and nvl(DISABLE_DATE,sysdate+360) ");  //20150803 liling update  YEW有使用DISABLE 在控制BOM
			while (rsBC.next()) 
            { 
            	semiItemDesc = rsBC.getString(1);
	          	semiItemCodeGet = semiItemCodeGet+"'"+semiItemDesc+"'"+","; 
            }
            rsBC.close();
            stateBC.close(); 

			if (semiItemCodeGet.length()>0)
            {        
            	semiItemCodeGetLength = semiItemCodeGet.length()-1;            
              	semiItemCodeGet = semiItemCodeGet.substring(0,semiItemCodeGetLength); // 取到對應半成品料號ID
            } 
		} // End of if (itemCodeGet!=null)
		// 取BOM_COMPONENT 內動應的半成品料號_迄
	}
	// 組合MO單下的成品料號對應出半成品料號,作為找前段流程卡依據_迄 	 
 		
	String sql = " select DISTINCT "+
				 " TSC_OM_Hold_status(ooh.org_id,ool.attribute20) \"Hold Flag\""+ //add by Peggy 20220221
	             ", 'KPC' as \"單位\""+
		         ", OOH.ORDER_NUMBER MO單號"+
				 ", OOL.LINE_NUMBER||'.'||OOL.SHIPMENT_NUMBER \"MO項次\""+
				 ", MSI.SEGMENT1 as \"製成品品號\""+
				 ", REPLACE(MSI.DESCRIPTION,'\''',' ') as \"品號規格說明\""+
				 ", OOL.ORDERED_QUANTITY \"未開工令數\""+					
			     ", OOL.ORDER_QUANTITY_UOM as \"MO單位\""+
			     ", to_char(OOL.SCHEDULE_SHIP_DATE,'YYYYMMDD') as \"預計出貨日\""+					
			     ", REPLACE(OOL.CUSTOMER_LINE_NUMBER,'''','\\''' ) as \"客戶訂單號\" "+ //將 ' 變更為 \' , 才能進行網頁間的傳值	by shin 20090825
				 " ,(SELECT SUM(x.ORDERED_QUANTITY) FROM APPS.OE_ORDER_LINES_ALL x WHERE x.HEADER_ID=OOL.HEADER_ID AND x.INVENTORY_ITEM_ID=OOL.INVENTORY_ITEM_ID) \"同型號訂單量\""+
				 " ,NVL((SELECT SUM(WO_QTY*case when WO_UOM='KPC' then 1000 else 1 end) FROM YEW_WORKORDER_ALL X WHERE  X.ORDER_HEADER_ID=OOL.HEADER_ID AND X.INVENTORY_ITEM_ID=OOL.INVENTORY_ITEM_ID and X.WORKORDER_TYPE in ('3','5')  and X.STATUSID != '050'),0) \"同型號已開工單量\""+
			     ", OOH.HEADER_ID as \"MO單識別碼\""+
				 ", OOL.LINE_ID as \"MO單項次識別碼\""+
			     ", MSI.INVENTORY_ITEM_ID \"製成品品號識別碼\" "+
				 ", OOH.SOLD_TO_ORG_ID "+	
                 ", SML.INVENTORY_ITEM_ID as \"半成品料號識別碼\""+
  			     " from APPS.OE_ORDER_HEADERS_ALL OOH, APPS.OE_ORDER_LINES_ALL OOL, APPS.MTL_SYSTEM_ITEMS MSI, "+
				 " ( select b.INVENTORY_ITEM_ID, a.LOT_NUMBER, b.SEGMENT1 "+
				 "     from MTL_LOT_NUMBERS a, MTL_SYSTEM_ITEMS b   "+
				 "    where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
				 "      and b.ITEM_TYPE ='SA' and substr(b.SEGMENT1,5,1) = '-' and length(b.SEGMENT1) != 22 "+
				 "      and b.ORGANIZATION_ID in (326,327)  "+						  
				 "  UNION "+ // 或者已經開了前段工令
				 "   select YRA.PRIMARY_ITEM_ID , YRA.RUNCARD_NO, YRA.INV_ITEM "+
				 "     from YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA "+
				 "    where YWA.WO_NO=YRA.WO_NO and YWA.WORKORDER_TYPE in (2,7) "+ // 2007/01/29_工程實驗前段工令
				 "      and YWA.ORGANIZATION_ID in (326,327)   "+						  
				 " ) SML "+
				 "      ";			
	String where = " where OOH.HEADER_ID=OOL.HEADER_ID "+
	               " and OOL.CANCELLED_FLAG !='Y' "+
				   " and OOL.FLOW_STATUS_CODE !='SHIPPED' "+
		           " and OOH.FLOW_STATUS_CODE = 'BOOKED' "+
		           " and OOL.FLOW_STATUS_CODE != 'CLOSED' and OOL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID  "+
				   " and OOL.LINE_CATEGORY_CODE = 'ORDER' "+
				   " and OOL.SHIP_FROM_ORG_ID="+organizationId+" "+  // 訂單從各自ORG
				   " and OOL.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID  ";		//20150513 liling for 1214			   
	if (runCardGet!=null && !runCardGet.equals(""))	 where = where + " and YRA.RUNCARD_NO not in ("+runCardGet+") "; // 先前已在清單內的RunCard不得出現   
					   
	if (semiItemID!=null && !semiItemID.equals(""))	 // 如果先選半成品再找訂單資訊		   
	{	
		where +=" and SML.INVENTORY_ITEM_ID = '"+semiItemID+"' "+			                 
		                  " and  MSI.INVENTORY_ITEM_ID in ( select  /* + ORDERED index(a BOM_COMPONENTS_B_N2) */   b.ASSEMBLY_ITEM_ID "+
				                                                     " from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b "+
					                                                 " where ( a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID "+
																	 "        or a.BILL_SEQUENCE_ID = b.COMMON_BILL_SEQUENCE_ID ) "+ // 2006/11/11 因為BOM表設定使用COMMON BOM
																	 " and b.ASSEMBLY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+
															         " and COMPONENT_ITEM_ID = '"+semiItemID+"' "+
																	 " and sysdate between EFFECTIVITY_DATE  and nvl(DISABLE_DATE,sysdate+360) "+   //20150803 liling update  YEW有使用DISABLE 在控制BOM
					 						                         " and b.ORGANIZATION_ID = "+organizationId+" ) ";
	} 
		
	if ( (invItem==null || invItem.equals("")) && (semiItemID==null || semiItemID.equals("")) )
	{  
		// 一個成品料號可能對應多筆半成品料號
		where += " and SML.INVENTORY_ITEM_ID in (  select /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */ COMPONENT_ITEM_ID "+
				                                               "  from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b "+
				                                               " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and b.ASSEMBLY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+
				                                               "   and b.ASSEMBLY_ITEM_ID  = OOL.ORDERED_ITEM_ID "+
															//   "    and a.DISABLE_DATE is null "+  //20130925 liling add
															   " and sysdate between EFFECTIVITY_DATE  and nvl(DISABLE_DATE,sysdate+360) "+   //20150803 liling update  YEW有使用DISABLE 在控制BOM
														       "   and b.ORGANIZATION_ID = "+organizationId+"  ) ";
	}
		
	if (semiItemCodeGet!=null && !semiItemCodeGet.equals(""))
	{
		where +=" and to_char(SML.INVENTORY_ITEM_ID) in ("+semiItemCodeGet+") ";  // 以MO成品料號的ID對應的半成品料號ID作為找流程卡的條件
	}
		
	if (oeOrderNo!=null && !oeOrderNo.equals("")) where += "and ( to_char(OOH.ORDER_NUMBER) = '"+oeOrderNo+"' or to_char(OOH.ORDER_NUMBER) like '"+oeOrderNo+"%' ) "; 
	if (invItem!=null && !invItem.equals(""))			   
	{	
		where +=" and ( MSI.SEGMENT1 = '"+invItem+"' or MSI.SEGMENT1 like '"+invItem+"%' ) ";	// 如果已先找出特定成品料號,則以該成為料號作為找尋條件
	}	

	if (woType=="5" || woType.equals("5"))			   
	{	
		where +=" and substr(OOH.ORDER_NUMBER,1,4) in ('1121' ,'4121')";	// 若為樣品工令,只出現1121及4121的單 ,20120606		   
	} 
	else 
	{ 
		where +=" and substr(OOH.ORDER_NUMBER,1,4) not in ('1121','4121') "; 
	}
								   
	String orderby= "	order by to_char(OOL.SCHEDULE_SHIP_DATE,'YYYYMMDD'), OOH.ORDER_NUMBER,to_number(OOL.LINE_NUMBER||'.'||OOL.SHIPMENT_NUMBER) ";//" OOH.ORDER_NUMBER, OOL.SCHEDULE_SHIP_DATE ";
		
	// 需要改為取特定索引 SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)   /			 
	if (searchString =="%" || searchString.equals("%"))			
	{  
		where += " and (MSI.SEGMENT1 like '%') "; //		  
	}
	else 
	{ 
		where += "  and ( upper(MSI.SEGMENT1) = '"+searchString.toUpperCase()+"%' or upper(MSI.SEGMENT1) like '"+searchString.toUpperCase()+"%'  "+
		        "   OR upper(OOH.ORDER_NUMBER) = '"+searchString+"' or upper(OOH.ORDER_NUMBER) like '"+searchString+"%' ) ";	     
	}  
 
	sql = sql + where + orderby;	
	//out.println(sql);
	ResultSet rs=statement.executeQuery(sql);
	ResultSetMetaData md=rs.getMetaData();
    int colCount=md.getColumnCount();
	//colCount = colCount-1; //CUSTOMER ID不顯示,ADD BY PEGGY 20201208
    String colLabel[]=new String[colCount+1];           
	//out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='left' borderColorLight='#ffffff' border='0'>");          
	strtable ="<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='left' borderColorLight='#ffffff' border='0'>";
	//out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT COLOR=BROWN>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>項次</TD>"); 
	strtable += "<TR BGCOLOR='#CCCC99'><TD nowrap><FONT COLOR=BROWN>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>項次</TD>";
    //out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
    for (int i=1;i<=colCount-7;i++) // 不顯示第一,二欄資料ITEMID, 故 for 由 2開始
    {
		colLabel[i]=md.getColumnLabel(i);         
		if (i==3)
		{
			//out.println("<TD nowrap><FONT COLOR=BLUE><strong>"+colLabel[i]+"</strong></TD>");
			strtable += "<TD nowrap><FONT COLOR=BLUE><strong>"+colLabel[i]+"</strong></TD>";
		} 
		else 
		{
			//out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");
			strtable += "<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>";
		}
	} //end of for 
    //out.println("</TR>");
	strtable +="</TR>";
		
	String moNoTmp = null; // 每次取到的MO號給暫存MoNoTmp
	String buttonContent=null;
	String trBgColor = "";
	int j = 0,icnt=0,iline=0; //項次數
	while (rs.next())
    { 
		if (icnt==0)
		{
			sql = "SELECT X.ORGANIZATION_ID,X.INVENTORY_ITEM_ID,X.SUBINVENTORY_CODE,SUM(X.TRANSACTION_QUANTITY/CASE WHEN X.TRANSACTION_UOM_CODE='PCE' THEN 1000 ELSE 1 END) ONHAND,X.TRANSACTION_UOM_CODE"+
				   ",SUM(CASE WHEN X.SUBINVENTORY_CODE<>? AND X.HOLD_FLAG=? THEN X.TRANSACTION_QUANTITY/CASE WHEN X.TRANSACTION_UOM_CODE='PCE' THEN 1000 ELSE 1 END ELSE 0 END) HOLD_QTY"+
				   ",SUM(CASE WHEN X.SUBINVENTORY_CODE<>? AND X.FLOW_STATUS_CODE=? THEN X.TRANSACTION_QUANTITY/CASE WHEN X.TRANSACTION_UOM_CODE='PCE' THEN 1000 ELSE 1 END ELSE 0 END) CLOSED_QTY"+
				   ",SUM(CASE WHEN X.SUBINVENTORY_CODE<>? AND X.FLOW_STATUS_CODE=? THEN X.TRANSACTION_QUANTITY/CASE WHEN X.TRANSACTION_UOM_CODE='PCE' THEN 1000 ELSE 1 END ELSE 0 END) CANCELLED_QTY"+
				   " FROM (SELECT A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.SUBINVENTORY_CODE,A.LOT_NUMBER,A.TRANSACTION_QUANTITY,A.TRANSACTION_UOM_CODE,YWA.WO_NO,YWA.OE_ORDER_NO,YWA.ORDER_HEADER_ID,YWA.ORDER_LINE_ID,OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER LINE_NO,OLA.FLOW_STATUS_CODE,OLA.ATTRIBUTE20"+
				   " ,TSC_OM_Hold_status(OLA.ORG_ID,OLA.ATTRIBUTE20,?) HOLD_FLAG"+
				   " FROM INV.MTL_ONHAND_QUANTITIES_DETAIL A,INV.MTL_SYSTEM_ITEMS_B MSI,YEW_RUNCARD_ALL YRA,YEW_WORKORDER_ALL YWA,ONT.OE_ORDER_LINES_ALL OLA"+
				   " WHERE A.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
				   " AND A.ORGANIZATION_ID=MSI.ORGANIZATION_ID"+
				   " AND MSI.SEGMENT1=?"+
				   " AND A.ORGANIZATION_ID =?"+
				   " AND A.SUBINVENTORY_CODE IN (?,?)"+
				   " AND A.LOT_NUMBER=YRA.RUNCARD_NO(+)"+
				   " AND A.ORGANIZATION_ID=YRA.ORGANIZATION_ID(+)"+
				   " AND YRA.WO_NO=YWA.WO_NO(+)"+
				   " AND YWA.ORDER_LINE_ID=OLA.LINE_ID(+)) X"+
				   " GROUP BY X.ORGANIZATION_ID,X.INVENTORY_ITEM_ID,X.SUBINVENTORY_CODE,X.TRANSACTION_UOM_CODE";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,"08");
			statement1.setString(2,"Y");
			statement1.setString(3,"08");
			statement1.setString(4,"CLOSED");
			statement1.setString(5,"08");
			statement1.setString(6,"CANCELLED");
			statement1.setString(7,"WNS");
			statement1.setString(8,rs.getString(5));
			statement1.setString(9,organizationId);
			statement1.setString(10,"03");
			statement1.setString(11,"08");
			ResultSet rs1=statement1.executeQuery();
			while (rs1.next())
			{	
				iline++;
				out.println("<table width=0>");
				if (!rs1.getString("SUBINVENTORY_CODE").equals("08"))
				{
					out.println("<tr><td style='color:#0000FF'>"+(rs1.getString("ORGANIZATION_ID").equals("326")?"內銷":"外銷")+rs1.getString("SUBINVENTORY_CODE")+"倉庫存:"+rs1.getString("ONHAND")+"K(CLOSE數:"+rs1.getString("CLOSED_QTY")+"K / CANCEL數:"+rs1.getString("CANCELLED_QTY")+"K / HOLD數:"+rs1.getString("HOLD_QTY")+"K)</td></tr>");
				}
				else
				{
					out.println("<tr><td style='color:#FF0000'>"+(rs1.getString("ORGANIZATION_ID").equals("326")?"內銷":"外銷")+rs1.getString("SUBINVENTORY_CODE")+"倉庫存:"+rs1.getString("ONHAND")+"K</td></tr>");
				}
			}
			if (iline>0) out.println("</table>");
			rs1.close();	
			statement1.close();			
			out.println(strtable);
		}
		icnt++;
		float accWoQty = 0;
		
		frontRunCard = "N/A";        // 前段流程卡號(後段開工令時不給定,待投產時方決定批號)
		semiItemID = rs.getString(17);	 // 取得前段半成品料號ID作為查MO單依據
		woQty = rs.getString(7);  //把未出貨數量給此次新增數量
		woUom = rs.getString(2); // 完工單位
		String backEndWoList = "已開後段工令<BR>";
		String orgOeLineQty = "原MO單項次訂單數量=";
		 
		if (woQty==null || woQty.equals("")) woQty = "0";
		oeOrderNo=rs.getString(3); //rs.getString("ORDER_NUMBER");
		invItem=rs.getString(5); //rs.getString("INV_ITEM");
		itemDesc=rs.getString(6);//rs.getString("DESCRIPTION");			 
		moUom=rs.getString(8); //rs.getString("UOM");		     	 
		endDate=rs.getString(9); //rs.getString("SCH_SHIP_DATE");			     
		customerPo=rs.getString(10);//rs.getString("CUSTOMER_LINE_NUMBER");
		oeHeaderId=rs.getString(13); //rs.getString("HEADER_ID");
		oeLineId=rs.getString(14); //rs.getString("LINE_ID");				     
		itemId=rs.getString(15); //rs.getString("INVENTORY_ITEM_ID");
		customerId=rs.getString(16); //rs.getString("SOLD_TO_ORG_ID");	
		orderPartnoQty=rs.getString(11); //add by Peggy 20191007
		wipPartnoQty=rs.getString(12); //add by Peggy 20191007
		hold_flag=rs.getString(1); //add by Peggy 20220221
			 
		if (endDate==null || endDate.equals(""))
		{
			endDate = dateBean.getYearMonthDay(); // 如MO未給預計出貨日,則預設以開單日為工單結案日
		}

			 
		// 列表依MO單找出先前已開後段工令_起			   
		Statement stateWOLst=con.createStatement();
		String sqlWoLst = " select DISTINCT b.EXTEND_NO||'(數量='||b.EXTENDED_QTY||',單位='||WO_UOM||',單耗量='||a.WO_UNIT_QTY||')', (b.EXTENDED_QTY*a.WO_UNIT_QTY) as ACCWO_QTY "+
			              " from YEW_WORKORDER_ALL a, YEW_MFG_TRAVELS_ALL b "+
		                  " where a.WO_NO = b.EXTEND_NO and a.INV_ITEM= '"+invItem+"' "+  // 此檢驗批列表已開切割工令號
						  " and a.OE_ORDER_NO = b.ORDER_NO and b.EXTEND_TYPE= a.WORKORDER_TYPE "+
						  " and a.ORDER_LINE_ID = b.ORDER_LINE_ID  "+
						  " and a.STATUSID != '050' "+ // 不累加已經取消的工令數
						  " and a.ORDER_HEADER_ID = "+rs.getString(13)+" "+
						  " and a.ORDER_LINE_ID= '"+rs.getString(14)+"' "+
		                  " and a.WORKORDER_TYPE in ('3','5') "; // 依後段工令找出累計已開數量
		//out.println(sqlWoLst);	 
		ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		while (rsWOLst.next()) 
		{
			backEndWoList = backEndWoList + rsWOLst.getString(1)+"<BR>";
			accWoQty = accWoQty + rsWOLst.getFloat(2);  // 累加已開後段工令數量;
		}
		rsWOLst.close();
		stateWOLst.close();
			   
		if (backEndWoList.equals("已開後段工令<BR>")) backEndWoList = "已開後段工令<BR>無";
			 
		oeLineQty=rs.getString(7); //rs.getString("UNSHIP_QTY");
		orgOeLineQty = orgOeLineQty + oeLineQty+",單位="+moUom; // 把原訂單數量給予
			   
		if (moUom=="PCE" || moUom.equals("PCE"))
		{
			oeLineQty = Float.toString(Float.parseFloat(oeLineQty)/1000-accWoQty);  // 計算扣除已開工令數的最後訂單數
			woQty=oeLineQty;	
			oeLineQty = Float.toString(Float.parseFloat(oeLineQty) *1000); // 再換算回來
		} 
		else if (moUom=="KPC" || moUom.equals("KPC")) 
		{
			oeLineQty = Float.toString(Float.parseFloat(oeLineQty)-accWoQty);  // 計算扣除已開工令數的最後訂單數
			woQty=oeLineQty;
		}
		moQty = Float.parseFloat(oeLineQty);
			  
		// 抓客戶名稱
		String sqlCust = " SELECT replace(CUSTOMER_NAME,'''','’') CUSTOMER_NAME FROM APPS.AR_CUSTOMERS where CUSTOMER_ID = " +customerId;
		Statement stateCust=con.createStatement();
  		ResultSet rsCust=stateCust.executeQuery(sqlCust);
		if (rsCust.next())
		{  
			customerName  = rsCust.getString("CUSTOMER_NAME");  
		}
  		rsCust.close();
        stateCust.close();		   
			
		if (moUom=="PCE" || moUom.equals("PCE"))
		{
	    	oeLineQty=String.valueOf(moQty);// 訂單數量		  
		    moUom="KPC"; 
		}	

		String sqltsc = " SELECT TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Family') TSC_FAMILY, "+
                        "    TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Package') TSC_PACKAGE, "+
                        "    TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Amp') TSC_AMP from dual  "; 				  
		Statement statetsc=con.createStatement();
        ResultSet rstsc=statetsc.executeQuery(sqltsc);
	    if (rstsc.next())
	    { 	
			tscAmp       = rstsc.getString("TSC_AMP"); 
		    tscFamily    = rstsc.getString("TSC_FAMILY"); 
		    tscPackage   = rstsc.getString("TSC_PACKAGE");
		    tscPacking	= itemDesc.substring(itemDesc.length()-2,itemDesc.length());	 
	    }
	    rstsc.close();
        statetsc.close(); 
			  
	    out.print("<TR BGCOLOR='"+(hold_flag.equals("Y")?"#FFFF99":"#D2D0AA")+"'><TD>");	
		
		if (Float.parseFloat(woQty)<0) 
		{ 
			woQty = "0"; 
		  	oeLineQty = "0";
		}
		
		if (Float.parseFloat(woQty)>0)  // if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示此列(資料顯示,但無法點擊帶入鈕)
	    { 
		
			//add by Peggy 20221129
			sql =" select tsc_check_yew_wip(?) wip_msg from dual";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,oeLineId);
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{
				wip_msg=rs1.getString(1); //add by Peggy 20221129
			}
			rs1.close();		
			statement1.close();	
		
			out.println("<input type='hidden' id='"+oeLineId+"' value='"+wip_msg+"'>");	
							
			if (oeOrderNo!=moNoTmp && !oeOrderNo.equals(moNoTmp)) // 每次取到的製成品給暫存)// 可能BOM 對到一個以上的製成品號,若是,則序號不累加
		  	{
		    	j++; // 項次數
		  	}
			
			v_show = ""; //add by Peggy 20201208
			if (customerId.equals("601290"))  //On Semiconductor
			{
				if (customerPo.length()>8 && customerPo.startsWith("20")) //forecast po用年月日流水碼編列,add by Peggy 20210303
				//if (!customerPo.equals("14089675") && !customerPo.equals("14099423"))  //po<>14089675表示是forecast訂單,Amanda要求不要開後段工單,2021 cust po:14099423 add by Peggy 20210125
				{
					v_show="disabled";
				}
			}
			else if (customerId.equals("4777"))  //TSCJ,add by Peggy 20211007
			{
				if (customerPo.toUpperCase().startsWith("FORECAST"))  //forecast po不允許開工單
				{
					v_show="disabled";
				}
			}
			else if (hold_flag.equals("Y"))  //HOLD, add by Peggy 20221128
			{
				v_show="disabled";//只卡YC
			}
       %>
	  		 <INPUT TYPE="button" NAME="button" VALUE="帶入" onClick="sendToMainWindow('<%=j%>','<%=oeOrderNo%>','<%=invItem%>','<%=itemDesc%>','<%=woQty%>','<%=woUom%>','<%=endDate%>','<%=customerName%>','<%=customerPo%>','<%=oeHeaderId%>','<%=oeLineId%>','<%=itemId%>','<%=customerId%>','<%=defaultWoQty%>','<%=frontRunCard%>','<%=oeLineQty%>','<%=moUom%>','<%=exceedFlag%>','<%=tscAmp%>','<%=tscFamily%>','<%=tscPackage%>','<%=tscPacking%>','<%=dateCode%>','<%=oeLineQty%>','<%=orderPartnoQty%>','<%=wipPartnoQty%>')" <%=v_show%>>
       <%
	   	}  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料顯示,但無法點擊帶入鈕)
		else 
		{ 
			// j--; //不計入
		    out.println("<em><font color='#FF0000'>無餘額</font></em>");
		}
		
		out.print("</TD>");		
		out.print("<TD nowrap>"+j+"</TD>");		
        for (int i=1;i<=colCount-7;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
        {		  
        	String s=(String)rs.getString(i);
			if (i==1 && s.equals("N")) s=""; // HOLD BY PEGGY 20220221
		   	if (i==3)
		   	{ 
		    	s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+backEndWoList+'"'+")'>"+s+"</a></strong></font>";
		   	}
		   	
			if (i==7)
		   	{
		    	oeLineQty="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+orgOeLineQty+'"'+")'>"+oeLineQty+"</a></strong></font>";
		     	out.println("<TD nowrap><FONT COLOR=BROWN>"+oeLineQty+"</TD>");
		   	}
			else 
			{
            	out.println("<TD nowrap><FONT COLOR=BROWN>"+s+"</TD>");	
			}
        } //end of for
        out.println("</TR>");
		moNoTmp = oeOrderNo; // 晶片批號給暫存
	} //end of while
    out.println("</TABLE>");						
		
    rs.close();    
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
statement.close();
  %>
  <BR>
<!--%表單參數%-->
<input type="hidden" name="ORGANIZATIONID" value="<%=organizationId%>">
<input type="hidden" name="MARKETTYPE" value="<%=marketType%>">
<input type="hidden" name="SEMIITEMID" value="<%=semiItemID%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
</body>
</html>
