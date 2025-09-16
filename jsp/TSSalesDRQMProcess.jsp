<!--20101220 lilin update 抓各生產廠別id  -->
<!--20110620 lilin update 草稿Templator 及 create 的tsc_prod_group 寫入  -->
<!--20140811 Peggy ,INSERT TSDELIVERY_NOTICE_DETAIL.END_CUSTOMER_ID-->
<!--20150114 Peggy,Lead Time reason insert-->
<!--20150318 Peggy,山東船期改18天-->
<!--20150409 Peggy,check Arrow End customer item-->
<!--20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!--20160309 by Peggy,for sample order add direct_ship_to_cust column-->
<!--20160706 by Peggy,PMD TIN SLOW MOVING交期以業務交期回覆-->
<!--20161021 by Peggy,工廠PC confirm前再檢查一次rfq狀態是否合法,避免系統異常,造成重複confirm,重複轉單-->
<!--20170216 by Peggy,add sales region for bi-->
<!--20170511 by Peggy,add end cust ship to id-->
<!--20170714 Peggy,元利,茂荃,MUSTARD於備註欄標示產品有效須為一年以上-->
<!--20190225 Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<%@ page import="java.sql.Date" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<script language="JavaScript" type="text/JavaScript">
function reProcessFormConfirm(ms1,URL,dnDOCNo,lineNo,assignFact,ordtypeid,linetypeid)
{
	var orginalPage="?DNDOCNO="+dnDOCNo+"&LINE_NO="+lineNo+"&ASSIGN_MANUFACT="+assignFact+"&ORDER_TYPE_ID="+ordtypeid+"&LINE_TYPE="+linetypeid;
    flag=confirm(ms1);
	if (flag==false) return(false);
	else
    {
	  document.MPROCESSFORM.action=URL+orginalPage;
      document.MPROCESSFORM.submit();
	}
}

function alertItemExistsMsg(msItemExists)
{
	alert(msItemExists);
}
</script>
<html>
<head>
<title>Sales Delivery Request M Data Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--FOR MATERIAL USAGE-->
<jsp:useBean id="rfqArray2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 業務交期詢問單草稿文件_2-->
<jsp:useBean id="array2DAssignFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 企劃分派產地-->
<jsp:useBean id="array2DEstimateFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工廠安排交期確認中-->
<jsp:useBean id="array2DArrangedFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工廠回覆交期確認-->
<jsp:useBean id="array2DGenerateSOrderBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 業務生成銷售訂單確認-->
<jsp:useBean id="array2DPromiseFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 客戶取消交期給定新交期需求日-->
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="Array2DimensionInputBean"/> <!-- FOR 業務生成銷售訂單確認(其他資訊Notify to Contact) -->
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="Array2DimensionInputBean"/> <!-- FOR 業務生成銷售訂單確認(其他資訊Deliver to Contact) -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="StockInfoBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSSalesDRQMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String dnDocNo=request.getParameter("DNDOCNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");
// 20110310 Marvie Add : Add field  PROGRAM_NAME
String sProgramName=request.getParameter("PROGRAMNAME");
if (sProgramName==null || sProgramName.equals("")) sProgramName="";
String aRfqTemporaryCode[][]=rfqArray2DTemporaryBean.getArray2DContent();//取得rfqArray2DTemporaryBean目前陣列內容(業務草稿文件陣列內容_2)
String aFactoryCode[][]=array2DAssignFactoryBean.getArray2DContent();//取得assignFactoryCode目前陣列內容
String aFactoryEstimatingCode[][]=array2DEstimateFactoryBean.getArray2DContent();//取得工廠交期安排中確認目前陣列內容
String aFactoryArrangedCode[][]=array2DArrangedFactoryBean.getArray2DContent();//取得工廠回覆交期確認目前陣列內容
String aSalesOrderGenerateCode[][]=array2DGenerateSOrderBean.getArray2DContent();//取得業務訂單生成陣列內容
String aCustCancelPromiseCode[][]=array2DPromiseFactoryBean.getArray2DContent();//取得客戶取消交期並給定新的交期需求日陣列內容
String aSalesOrderNotifyInfo[]=array2DMOContactInfoBean.getArrayContent(); // 取MO單生成User設定的NotifyTOContact資訊 陣列內容
String aSalesOrderDeliverInfo[]=array2DMODeliverInfoBean.getArrayContent(); // 取MO單生成User設定的DeliverTOContact資訊 陣列內容

String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String newDRQOption=request.getParameter("NEWDRQOPTION");//是否要以原單據內容產生新的交期詢問單
String oriStatus=null;
String actionName=null;
String dateString="";
String seqkey="";
String seqno="";
String firmOrderType=request.getParameter("FIRMORDERTYPE");
String firmSoldToOrg=request.getParameter("FIRMSOLDTOORG");
String firmPriceList=request.getParameter("FIRMPRICELIST");
String ShipToOrg=request.getParameter("SHIPTOORG");
String billTo = request.getParameter("BILLTO");
String payTermID=request.getParameter("PAYTERMID");
String fobPoint=request.getParameter("FOBPOINT");
String shipMethod=request.getParameter("SHIPMETHOD");
String line_No=request.getParameter("LINE_NO");
String custPO=request.getParameter("CUST_PO");
String curr=request.getParameter("CURR");
String prCurr=request.getParameter("PRCURR");
String [] choice=request.getParameterValues("CHKFLAG");
List lineNoList = new ArrayList();
String sampleOrder=request.getParameter("SAMPLEORDER");
if (custPO==null) { custPO=""; }
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);;
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr)); // 給Promise Date
String sourceTypeCode = "INTERNAL";
int lineType = 0;
String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
String assignLNo = "";
String prodDesc = null;
String prodCodeGet = "";
int prodCodeGetLength = 0;
String dateCurrent = dateBean.getYearMonthDay();
String sToStatusID = "";
String sToStatusName = "";
String strRes = "";      //20110418 add by Peggychen
String choiceLine = "";  //20110418 add by Peggychen
String CancelReason=request.getParameter("CancelReason");
if (CancelReason==null) CancelReason = ""; //add by Peggy 20111103
String salesAreaNo="",customerId="",autoCreate_Flag="",orderTypeId="", orderType="",custItemID="", custItemType = "";   //add by Peggy 20120307
String vendor_site_id="";        //add by Peggy 20140328
String vendor_ssd="";            //add by Peggy 20140423
String over_lead_time_reason="",pc_lead_time=""; //add by Peggy 20150114
String END_CUST_SHORT_NAME="",END_CUST_ID=""; //add by Peggy 20140813
String end_cust_ship_to="";   //add by Peggy 20160219
int errCnt =0;     //add by Peggy 20120307
boolean is_exist = false; //add by Peggy 20161221
String sql_e="",customer="",line_remarks=""; //add by Peggy 20170714
long ship_qty=0,allot_qty=0;
String SUPPLIER_NUMBER=request.getParameter("SUPPLIER_NUMBER"); //add by Peggy 20220428
if (SUPPLIER_NUMBER==null) SUPPLIER_NUMBER="";
// formID = 基本資料頁傳來固定常數='TS'
// fromStatusID = 基本資料頁傳來Hidden 參數
// actionID = 前頁取得動作 ID( Assign = 003 )
try
{
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate();
	pstmt1.close();

 // 先取得下一狀態及狀態描述並作流程狀態更新
	dateString=dateBean.getYearMonthDay();

  	String sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
  	String whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
  	// 2006/04/13加入特殊內銷流程,針對上海內銷_起
  	if (UserRoles.equals("admin"))
	{
		whereStat = whereStat+"and FORMID='TS' "; //預設TS
	}  //若是管理員,則任何動作不受限制
  	else if (userActCenterNo.equals("010") || userActCenterNo.equals("011"))
	{
		whereStat = whereStat+"and FORMID='SH' "; // 若是上海內銷辦事處
	}
  	else
	{
		whereStat = whereStat+"and FORMID='TS' "; // 否則一律皆為外銷流程
	}

  	// 2006/04/13加入特殊內銷流程,針對上海內銷_迄
  	sqlStat = sqlStat+whereStat;
	//out.println("sqlStat="+sqlStat);
  	Statement getStatusStat=con.createStatement();
  	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);
  	//getStatusRs.next();
  	if (getStatusRs.next())
	{
    	sToStatusID = getStatusRs.getString("TOSTATUSID");
		sToStatusName = getStatusRs.getString("STATUSNAME");
  	}
  	getStatusStat.close();
  	getStatusRs.close();

  	String sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=? where DNDOCNO='"+dnDocNo+"'";
  	PreparedStatement pstmt=con.prepareStatement(sql);
  	pstmt.setString(1,sToStatusID);
  	pstmt.setString(2,sToStatusName);
  	pstmt.executeUpdate();
  	pstmt.close();

  	//若有指派人員則找出其e-Mail
  	if (changeProdPersonID!=null)
	{
    	Statement mailStat=con.createStatement();
    	ResultSet mailRs=mailStat.executeQuery("select USERMAIL from ORADDMAN.WSUSER where WEBID='"+changeProdPersonID+"'");
    	if (mailRs.next()) changeProdPersonMail=mailRs.getString("USERMAIL");
		mailRs.close();
		mailStat.close();
  	}

  	//@@@@@@@@@@取得該使用者隸屬之業務中心資料@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  	Statement userSalesStat=con.createStatement();
	ResultSet userSalesRs=userSalesStat.executeQuery("SELECT SALES_AREA_NO,SALES_AREA_NAME,TEL,MOBILE,ZIP,ADDRESS "+
	" FROM ORADDMAN.TSSALES_AREA WHERE trim(SALES_AREA_NO)='"+userActCenterNo+"'");
  	String userSalesAreaName="",userTel="",userCell="",userAddr="",userZIP="";//Zip是電話分機代碼
  	if (userSalesRs.next())
	{
		userSalesAreaName=userSalesRs.getString("SALES_AREA_NAME");
		userTel=userSalesRs.getString("TEL");
		userCell=userSalesRs.getString("MOBILE");
		userAddr=userSalesRs.getString("ADDRESS");
		userZIP=userSalesRs.getString("ZIP");
  	}
  	userSalesRs.close();
  	userSalesStat.close();
  	//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  	// 先設定Client Info_起
  	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
 	cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
  	cs1.execute();
  	cs1.close();
	// 先設定Client Info_迄
  	//業務草稿文件處理(TEMPORARY)_起	(ACTION=001)
  	if (actionID.equals("001") || actionID.equals("002"))
  	{
    	if (aRfqTemporaryCode!=null)
		{
			try
			{
				String defaultLineType = "0";
				String priceList = "0";
				String custMarketGroup="";
				String tscdesc="";  //add by Peggy 20141007
				boolean slowmoving_flag = false; //add by Peggy 20141007

				//add by Peggy 20141007
				String sqlh = " SELECT  a.area"+
							  ",a.inventory_item_id"+
							  ",a.item_name"+
							  ",a.item_desc"+
							  ",a.date_code"+
							  ",(a.idle_qty/1000) idle_qty"+
							  ",a.sales"+
							  ",a.customer"+
							  ",a.remarks"+
							  ",a.item_desc1"+
							  ",a.seq_no"+
							  ",tsc_om_category(a.inventory_item_id,49,'TSC_PROD_GROUP') tsc_prod_group"+
							  " FROM oraddman.tsc_idle_stock_detail a"+
							  " where exists (select 1 from (select VERSION_ID from oraddman.tsc_idle_stock_header  where VERSION_FLAG='A' order by UPDATE_DATE desc) b where rownum=1 and b.version_id=a.version_id)";
				Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rsh = statementh.executeQuery(sqlh);

				Statement stateLT=con.createStatement();
				ResultSet rsLT=stateLT.executeQuery("select a.TSAREANO,a.TSCUSTOMERID,nvl(a.AUTOCREATE_FLAG,'N') AUTOCREATE_FLAG, a.PRICE_LIST, b.LINE_TYPE,a.customer "+
				",c.ATTRIBUTE2 market_group"+
				" from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b,APPS.AR_CUSTOMERS c  "+
				" where a.DNDOCNO = b.DNDOCNO(+) and a.DNDOCNO='"+dnDocNo+"' and a.TSCUSTOMERID=c.CUSTOMER_ID");
				if (rsLT.next())
				{
					salesAreaNo=rsLT.getString("TSAREANO");
					customerId=rsLT.getString("TSCUSTOMERID");
					autoCreate_Flag=rsLT.getString("AUTOCREATE_FLAG");
					defaultLineType=rsLT.getString("LINE_TYPE");
					priceList = rsLT.getString("PRICE_LIST");
					customer=rsLT.getString("customer");   //add by Peggy 20170714
					custMarketGroup =rsLT.getString("market_group");
				}
				rsLT.close();
				stateLT.close();

				// 若清單內容>0,先全刪,再依Array內容清單新增
				pstmt=con.prepareStatement("delete ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' ");
				pstmt.executeQuery();

				//add by Peggy 20130305
				pstmt=con.prepareStatement("delete ORADDMAN.TSDELIVERY_NOTICE_REMARKS where DNDOCNO='"+dnDocNo+"' ");
				pstmt.executeQuery();


				//add by Peggy 20170714
				line_remarks ="";
				if (salesAreaNo.equals("006"))
				{
					sql = " SELECT 'Date Code須'||VALID_MONTHS/12||'年內'"+
						  " FROM tsc.tsc_cust_shipping_dc_check a"+
						  " WHERE ? LIKE CUSTOMER_NAME"+
						  " AND ?=?";
					PreparedStatement statementss = con.prepareStatement(sql);
					statementss.setString(1,customer);
					statementss.setString(2,salesAreaNo);
					statementss.setString(3,"006");
					ResultSet rssx=statementss.executeQuery();
					if (rssx.next())
					{
						line_remarks=rssx.getString(1);
					}
					rssx.close();
					statementss.close();
				}

				String sqlDtl="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,LINE_NO,INVENTORY_ITEM_ID,"+
						"ITEM_SEGMENT1,QUANTITY,UOM,LIST_PRICE,REQUEST_DATE,SHIP_DATE,"+
						"PROMISE_DATE,LINE_TYPE,PRIMARY_UOM,REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LSTATUSID,LSTATUS,"+
						"ITEM_DESCRIPTION,MOQP,ASSIGN_MANUFACT,CUST_PO_NUMBER, SPQ, MOQ, PROGRAM_NAME,TSC_PROD_GROUP"+
						",CUST_REQUEST_DATE,SHIPPING_METHOD,ORDER_TYPE_ID,AUTOCREATE_FLAG,SELLING_PRICE,ORDERED_ITEM,ORDERED_ITEM_ID,ITEM_ID_TYPE,FOB"+  //add by Peggychen 20110621
						",CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER"+ //add by Peggy 20121107
						",END_CUSTOMER_ID"+ //add by Peggy 20140813
						",PC_LEADTIME"+    //add by Peggy 20150114
						",ORIG_SO_LINE_ID"+ //add by Peggy 20150519
						",END_CUSTOMER_SHIP_TO_ORG_ID"+ //add by Peggy 20160219
						",DIRECT_SHIP_TO_CUST"+ //add by Peggy 20160309
						",BI_REGION"+    //Add by Peggy 20170220
						",END_CUSTOMER_PARTNO,SUPPLIER_NUMBER)"+ //add by Peggy 20180225 //add SUPPLIER_NUMBER by Peggy
						" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				for (int r=0;r<aRfqTemporaryCode.length-1;r++)
				{
					String invItemID = "0",uom = "N/A",itemFactory = "N/A",priceCategory = "",tscProdGroup=""; //20110620 liling add tscprodgroup
					tscdesc="";slowmoving_flag=false; //add by Peggy 20141007
					pc_lead_time=""; //add by Peggy 20150114
					double listPrice = 0;
					Statement statement=con.createStatement();
					sql = "select a.INVENTORY_ITEM_ID, a.PRIMARY_UOM_CODE, NVL(a.ATTRIBUTE3,'N/A') ATTRIBUTE3, b.SEGMENT1  "+
						  ",APPS.TSC_OM_CATEGORY(b.INVENTORY_ITEM_ID, 49,'TSC_PROD_GROUP') TSCPRODGROUP "+ //20110620 LILING
						  ",NVL(upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_Package')),'N/A') as TSC_PACKAGE "+ //add by Peggy 20120303
						  //",substr(a.description,0,decode(INSTR(a.description,'-'),0,length(a.description)-length(apps.tsc_get_item_packing_code(a.organization_id,a.inventory_item_id))-1,INSTR(a.description,'-')-1)) tsc_desc"+ //add by Peggy 20141007
						  ",case when apps.tsc_get_item_packing_code (49,a.inventory_item_id) in ('QQ','QQG') THEN a.description ELSE substr(a.description,0,decode(INSTR(a.description,'-'),0,length(a.description)-length(apps.tsc_get_item_packing_code(a.organization_id,a.inventory_item_id))-1,INSTR(a.description,'-')-1)) end tsc_desc"+ //add by Peggy 20220726
						  ",c.OPERAND"+
						  " from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b "+
						  ",(select OPERAND,PRODUCT_ATTR_VAL_DISP from ORADDMAN.TSITEM_LIST_PRICE  where LIST_HEADER_ID =  '"+priceList+"'  AND SYSDATE BETWEEN TO_DATE(SUBSTR(START_DATE_ACTIVE,1,8),'YYYYMMDD') AND TO_DATE(SUBSTR(NVL(END_DATE_ACTIVE,'20990101'),1,8),'YYYYMMDD')) c"+
						  " where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
						  " and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
						  " AND NVL(a.CUSTOMER_ORDER_FLAG,'N')='Y'"+     //add by Peggy 20151008
						  " AND NVL(a.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+//add by Peggy 20151008
						  " and a.ORGANIZATION_ID = '49' "+
						  " and b.CATEGORY_SET_ID = 6 "+
						  " and a.SEGMENT1 = '"+aRfqTemporaryCode[r][1]+"' "+
						  " and b.SEGMENT1=c.PRODUCT_ATTR_VAL_DISP(+)";
					ResultSet rs=statement.executeQuery(sql);
					if (rs.next())
					{
						invItemID = rs.getString("INVENTORY_ITEM_ID");
						itemFactory = rs.getString("ATTRIBUTE3");
						uom =  rs.getString("PRIMARY_UOM_CODE");
						priceCategory = rs.getString("SEGMENT1");
						tscProdGroup = rs.getString("TSCPRODGROUP");
						tscdesc = rs.getString("tsc_desc");  //add by Peggy 20141007
						listPrice = rs.getDouble("OPERAND"); //add by Peggy 20170714
						if (salesAreaNo.equals("001") && rs.getString("TSC_PACKAGE").equals("SMA") && rs.getString("ATTRIBUTE3").equals("008"))
						{
							itemFactory ="002";
						}
						else if  (custMarketGroup.equals("AU") && rs.getString("ATTRIBUTE3").equals("008"))
						{
							itemFactory ="002";
						}
						else
						{
							itemFactory = rs.getString("ATTRIBUTE3");
						}
						//2009/04/02 若沒填就抓料號預設
						if (aRfqTemporaryCode[r][10]==null || aRfqTemporaryCode[r][10].equals("null")) aRfqTemporaryCode[r][10]= itemFactory;

						//add by Peggy 20150114
						sql = "select tsc_get_pc_lead_time('"+itemFactory +"',trunc(sysdate),'"+invItemID +"') from dual";
						Statement statementx=con.createStatement();
						ResultSet rsx=statementx.executeQuery(sql);
						if (rsx.next())
						{
							pc_lead_time = rsx.getString(1);
						}
						rsx.close();
						statementx.close();
					}
					else
					{
						throw new Exception("line:"+(r+1)+" The item is not exist!!");
					}
					rs.close();
					statement.close();

					//add by Peggy 20120307
					if (!aRfqTemporaryCode[r][13].trim().equals("") && !aRfqTemporaryCode[r][13].trim().equals("N/A") && aRfqTemporaryCode[r][13].trim()!= null)
					{
						Statement statecust=con.createStatement();
						String sqlcust = " SELECT item_id, item_identifier_type item_type,item cust_item, inventory_item,sold_to_org_id"+
										 " FROM oe_items_v a"+
										 " where cross_ref_status <>'INACTIVE'"+
										 " and item='"+aRfqTemporaryCode[r][13].trim()+"'"+
										 " and inventory_item='"+aRfqTemporaryCode[r][1].trim()+"'"+
										 " and sold_to_org_id='"+customerId+"'";
						ResultSet rscust=statecust.executeQuery(sqlcust);
						if (rscust.next())
						{
							custItemID = rscust.getString("item_id");
							custItemType = rscust.getString("item_type");
						}
						else
						{
							throw new Exception("line:"+(r+1)+" The customer item is not available!!"+sqlcust);
						}
						rscust.close();
						statecust.close();
					}
					else
					{
						aRfqTemporaryCode[r][13]="N/A";
						custItemID = "0";
						custItemType = "INT";
					}

					//add by Peggychen 20120307
					if (autoCreate_Flag.equals("Y") || (aRfqTemporaryCode[r][15] != null && !aRfqTemporaryCode[r][15].trim().equals("N/A") && !aRfqTemporaryCode[r][15].trim().equals("")))
					{
						if (aRfqTemporaryCode[r][15] ==null || aRfqTemporaryCode[r][15].equals("null"))
						{
							throw new Exception("line:"+(r+1)+" The order type can not empty!!");
						}
						else
						{
							if (!orderType.equals(aRfqTemporaryCode[r][15].trim()))
							{
								Statement stateodrtype=con.createStatement();
								ResultSet rsodrtype=stateodrtype.executeQuery("SELECT  a.otype_id  FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
								" where b.order_num=a.order_num and a.order_num='"+aRfqTemporaryCode[r][15].trim()+"' and a.SAREA_NO ='"+salesAreaNo+"' and a.active='Y'"+
								" and b.MANUFACTORY_NO='"+aRfqTemporaryCode[r][10]+"' and b.ACTIVE='Y'");
								if (rsodrtype.next())
								{
									orderTypeId=rsodrtype.getString("otype_id");
								}
								else
								{
									throw new Exception("line:"+(r+1)+" The order type is not exist!!");
								}
								rsodrtype.close();
								stateodrtype.close();
								orderType= aRfqTemporaryCode[r][15].trim();
							}
						}
						//CHECK LINE TYPE是否正確
						if (aRfqTemporaryCode[r][16] == null || aRfqTemporaryCode[r][16].trim().equals(""))
						{
							throw new Exception("line:"+(r+1)+" The line type can not empty!!");
						}
						else
						{
							Statement stateB=con.createStatement();
							ResultSet rsB=stateB.executeQuery(" select wf.LINE_TYPE_ID, vl.name as LINE_TYPE"+
																   " from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl "+
																   " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID "+
																   " and wf.LINE_TYPE_ID is not null"+
																   " and vl.language = 'US' "+
																   " and END_DATE_ACTIVE is NULL "+
																   " and wf.LINE_TYPE_ID ='"+aRfqTemporaryCode[r][16].trim() +"'"+
																   " and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
																   " and c.SAREA_NO = '"+salesAreaNo+"' and c.ORDER_NUM='"+orderType+"')");
							if (!rsB.next())
							{
								throw new Exception("line:"+(r+1)+" The line type is not exist!!");
							}
							stateB.close();
							rsB.close();
						}
					}

					//check slow moving stock,add by Peggy 20141007
					//if (actionID.equals("002") && !aRfqTemporaryCode[r][15].trim().equals("1121") && !aRfqTemporaryCode[r][15].trim().equals("4121"))
					if (actionID.equals("002") && !aRfqTemporaryCode[r][15].trim().equals("1121") && !aRfqTemporaryCode[r][15].trim().equals("4121") && !salesAreaNo.equals("018") && !customerId.equals("601290")) //TSCH RFQ在7訂單已經檢查過FROM RITA 20221207 //from rita:onsemi的料因都是特殊marking/packing/label,無法與其他客戶互相消化 add by Peggy 20230207
					{
						if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
						while (rsh.next())
						{
							if (rsh.getString("item_desc1")!=null && rsh.getString("item_desc1").equals(tscdesc))  //add rsh.getString("item_desc1") is not null by Peggy 20220118
							{
								slowmoving_flag=true;
								break;
							}
						}
					}

					//check arrow end customer item,add by Peggy 20150409
					if (customerId.equals("7147"))
					{
						sql = " SELECT b.customer_number,nvl(b.customer_name_phonetic, b.customer_name) customer_name"+
							  " FROM oraddman.tsce_arrow_end_customer a,ar_customers b"+
							  "  where NVL(a.ACTIVE_FLAG,'I') =? "+
							  " AND a.end_customer_id=b.customer_id "+
							  " and trim(a.item_desc)=trim(?)";
						PreparedStatement state88 = con.prepareStatement(sql);
						state88.setString(1,"A");
						state88.setString(2,aRfqTemporaryCode[r][2]);
						ResultSet rs88=state88.executeQuery();
						if (rs88.next())
						{
							aRfqTemporaryCode[r][20]=rs88.getString(1);
							aRfqTemporaryCode[r][23]=rs88.getString(2);
						}
						rs88.close();
						state88.close();
					}

					if (salesAreaNo.equals("018"))
					{
						//FABRICATORS D/C一年內,ADD BY PEGGY 20200512
						sql = " SELECT 'Date Code需'||VALID_MONTHS/12||'年內'"+
							  " FROM tsc.tsc_cust_shipping_dc_check a"+
							  " WHERE INSTR(upper(?),CUSTOMER_NAME)>0"+
							  " AND ?=?";
						PreparedStatement statementss = con.prepareStatement(sql);
						statementss.setString(1,aRfqTemporaryCode[r][9]);
						statementss.setString(2,salesAreaNo);
						statementss.setString(3,"018");
						ResultSet rssx=statementss.executeQuery();
						if (rssx.next())
						{
							//line_remarks =new String(rssx.getString(1).getBytes("ISO8859-1"),"utf8");
							line_remarks =rssx.getString(1);
						}
						rssx.close();
						statementss.close();
					}

					pstmt=con.prepareStatement(sqlDtl);
					pstmt.setString(1,dnDocNo); //  詢問單號
					pstmt.setInt(2,r+1); // Line_No // 給料項序號
					pstmt.setString(3,invItemID); // Inventory_Item_ID
					pstmt.setString(4,aRfqTemporaryCode[r][1]); // Inventory_Item_Segment1
					pstmt.setFloat(5,Float.parseFloat(aRfqTemporaryCode[r][3])); // Order Qty
					pstmt.setString(6,uom); // Primary Unit of Measure
					pstmt.setDouble(7,listPrice); // List Price
					pstmt.setString(8,aRfqTemporaryCode[r][7]+dateBean.getHourMinuteSecond()); // Request Date
					pstmt.setString(9,aRfqTemporaryCode[r][7]+dateBean.getHourMinuteSecond());
					// Ship Date( 預設與需求日相同,但可由工廠於安排交期,生管確認交期及業務最後於生成訂單時修改 )
					pstmt.setString(10,aRfqTemporaryCode[r][7]+dateBean.getHourMinuteSecond());
					// Promise Date( 客戶需求日,預設與需求日相同,但可由業務最後於生成訂單時修改 )
					pstmt.setInt(11,Integer.parseInt(aRfqTemporaryCode[r][16].trim())); // Default Order Line Type
					pstmt.setString(12,aRfqTemporaryCode[r][4]); // Primary Unit of Measure
					if (aRfqTemporaryCode[r][8]==null || aRfqTemporaryCode[r][8].indexOf(line_remarks)<0) //add by Peggy 20170714
					{
						aRfqTemporaryCode[r][8] = aRfqTemporaryCode[r][8]+(aRfqTemporaryCode[r][8].length()>0?",":"")+line_remarks;
					}
					pstmt.setString(13,aRfqTemporaryCode[r][8]); // Remark
					pstmt.setString(14,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入日期
					pstmt.setString(15,userID); //寫入User ID
					pstmt.setString(16,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //最後更新日期
					pstmt.setString(17,userID); //最後更新User
					//add by Peggy 20141007
					if (slowmoving_flag)
					{
						pstmt.setString(18,"014");
						pstmt.setString(19,"PENDING");
					}
					else
					{
						pstmt.setString(18,sToStatusID);
						pstmt.setString(19,sToStatusName);
					}
					pstmt.setString(20,aRfqTemporaryCode[r][2]); //台半品號說明
					pstmt.setString(21,"0"); //最小包裝訂購量
					pstmt.setString(22,aRfqTemporaryCode[r][10]); // 生產地 2009/04/02 liling
					aRfqTemporaryCode[r][9] =aRfqTemporaryCode[r][9].replace("（","(").replace("）",")"); //20130304 by Peggy:全形轉半形
					pstmt.setString(23,aRfqTemporaryCode[r][9]); // Cust PO Number 2006/06/06 Add Kerwin
					// 20110310 Marvie Add : Add Field  SPQ MOQ PROGRAM_NAME
					float fSPQ = 0;
					if (aRfqTemporaryCode[r].length > 9)
					{
						if (aRfqTemporaryCode[r][11]==null || aRfqTemporaryCode[r][11].equals("") || aRfqTemporaryCode[r][11].equals("null")) aRfqTemporaryCode[r][11]="0";
						fSPQ = Float.valueOf(aRfqTemporaryCode[r][11]).floatValue();
					}
					pstmt.setFloat(24,fSPQ); // SPQ
					float fMOQ = 0;
					if (aRfqTemporaryCode[r].length > 10)
					{
						if (aRfqTemporaryCode[r][12]==null || aRfqTemporaryCode[r][12].equals("") || aRfqTemporaryCode[r][12].equals("null")) aRfqTemporaryCode[r][12]="0";
						fMOQ = Float.valueOf(aRfqTemporaryCode[r][12]).floatValue();
					}
					pstmt.setFloat(25,fMOQ); // MOQ
					pstmt.setString(26,sProgramName+"P"); // PROGRAM_NAME
					pstmt.setString(27,tscProdGroup); // 20110620 liling add
					pstmt.setString(28,(aRfqTemporaryCode[r][5].equals("&nbsp;"))?null:aRfqTemporaryCode[r][5]);  //add by Peggy 20110622
					pstmt.setString(29,(aRfqTemporaryCode[r][6].equals("&nbsp;"))?null:aRfqTemporaryCode[r][6]);  //add by Peggy 20110622
					pstmt.setString(30,orderTypeId);  //add by Peggy 20120307
					pstmt.setString(31,autoCreate_Flag);  //add by Peggy 20120307
					pstmt.setString(32,(aRfqTemporaryCode[r][14].equals("&nbsp;"))?null:aRfqTemporaryCode[r][14]);  //selling price,add by Peggy 20120307
					pstmt.setString(33,(aRfqTemporaryCode[r][13].equals("&nbsp;"))?"N/A":aRfqTemporaryCode[r][13]);  //cust item name,add by Peggy 20120307
					pstmt.setString(34,custItemID);    //cust item id,add by Peggy 20120307
					pstmt.setString(35,custItemType);  //cust item type,add by Peggy 20120307
					pstmt.setString(36,aRfqTemporaryCode[r][17]);  //FOB,add by Peggy 20120329
					pstmt.setString(37,aRfqTemporaryCode[r][18]);  //CUSTOMER PO LINE NUMBER,add by Peggy 20120531
					pstmt.setString(38,(aRfqTemporaryCode[r][19].equals("&nbsp;"))?null:aRfqTemporaryCode[r][19]);  //QUOTE NUMBER,add by Peggy 20120917
					END_CUST_ID=null;
					if (!aRfqTemporaryCode[r][20].startsWith("&nbsp"))
					{
						Statement state1=con.createStatement();
						ResultSet rs1=state1.executeQuery("SELECT A.CUSTOMER_ID  FROM  AR_CUSTOMERS A WHERE A.CUSTOMER_NUMBER = '"+aRfqTemporaryCode[r][20].trim()+"'");
						if (rs1.next())
						{
							END_CUST_ID =""+rs1.getInt(1);
						}
						rs1.close();
						state1.close();
					}
					//check 業務區012 end customer是否有效,add by Peggy 20160219
					if (salesAreaNo.equals("012"))
					{
						sql_e=" select SITE_USE_ID from  AR.HZ_CUST_SITE_USES_ALL a,APPS.HZ_CUST_ACCT_SITES_ALL b"+
                              " where A.SITE_USE_CODE='SHIP_TO' "+
                              " AND A.STATUS='A' "+
	    				      " AND A.ORG_ID=325"+
                              " AND A.CUST_ACCT_SITE_ID = B.CUST_ACCT_SITE_ID "+
                              " AND TO_CHAR(B.CUST_ACCOUNT_ID) ='"+END_CUST_ID+"'";
						if (!aRfqTemporaryCode[r][27].equals("&nbsp;") && !aRfqTemporaryCode[r][27].equals(""))  //add by Peggy 20170511
						{
							sql_e += " AND a.LOCATION='"+aRfqTemporaryCode[r][27]+"'";
						}
						else
						{
							sql_e += " AND A.PRIMARY_FLAG='Y'";
						}
						Statement state81=con.createStatement();
						ResultSet rs81=state81.executeQuery(sql_e);
						if (!rs81.next())
						{
							throw new Exception("line:"+(r+1)+" end customer ship to not found!!");
						}
						else
						{
							end_cust_ship_to = rs81.getString(1);
						}
						state81.close();
						rs81.close();
					}
					else
					{
						end_cust_ship_to =null;
					}
					pstmt.setString(39,(aRfqTemporaryCode[r][23].equals("&nbsp;"))?null:aRfqTemporaryCode[r][23]);  //END CUSTOMER,modify by Peggy 20140813
					pstmt.setString(40,END_CUST_ID);  //END CUSTOMER ID,add by Peggy 20140813
					pstmt.setString(41,pc_lead_time); //pc lead time,add by Peggy 20150114
					pstmt.setString(42,(aRfqTemporaryCode[r][24].equals("&nbsp;") ||aRfqTemporaryCode[r][24]==null||aRfqTemporaryCode[r][24].equals("null"))?null:aRfqTemporaryCode[r][24]);  //ORIG SO line id,add by Peggy 20150519
					pstmt.setString(43,end_cust_ship_to); //add by Peggy 20160219
					pstmt.setString(44,(aRfqTemporaryCode[r][25].equals("&nbsp;") ||aRfqTemporaryCode[r][25]==null||aRfqTemporaryCode[r][25].equals("null"))?null:aRfqTemporaryCode[r][25]); //add by Peggy 2016309
					pstmt.setString(45,(aRfqTemporaryCode[r][26].equals("&nbsp;") ||aRfqTemporaryCode[r][26]==null||aRfqTemporaryCode[r][26].equals("null"))?null:aRfqTemporaryCode[r][26]); //add by Peggy 20170221
					pstmt.setString(46,(aRfqTemporaryCode[r][28].equals("&nbsp;") ||aRfqTemporaryCode[r][28]==null||aRfqTemporaryCode[r][28].equals("null"))?null:aRfqTemporaryCode[r][28]); //END_CUSTOMER_PARTNO,add by Peggy 20190225
					pstmt.setString(47,SUPPLIER_NUMBER); //SUPPLIER_NUMBER,add by Peggy 20220428
					pstmt.executeQuery();
					out.print("***** sucess *****");

					// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
					float processWorkTime = 0;
					//String preWorkTime = "0";
					//Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
					//ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aRfqTemporaryCode[r][0]+"' and ORISTATUSID ='001' ");
					//if (rsHProcWT.next())
					//{
					//	preWorkTime = rsHProcWT.getString(1);
					//}
					//rsHProcWT.close();
					//stateHProcWT.close();
					////若取到前一個狀態時間,則以目前時間減去前
					//if (preWorkTime!="0")
					//{
					//	String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
					//	Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
					//	ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
					//	if (rsWTime.next())
					//	{
					//		processWorkTime = rsWTime.getFloat(1);
					//	}
					//	rsWTime.close();
					//	stateWTime.close();
					//}
					//// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

					//modify by Peggy 20170512
					String sqlWT = " select ROUND((SYSDATE-to_date(CDATETIME,'yyyymmddhh24miss'))*24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aRfqTemporaryCode[r][0]+"' and ORISTATUSID ='001'";
					Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
					ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
					if (rsWTime.next())
					{
						processWorkTime = rsWTime.getFloat(1);
					}
					rsWTime.close();
					stateWTime.close();


					//Step5. 任一Action,寫入交期詢問明細歷程檔
					int deliveryCount = 0;
					Statement stateDeliveryCNT=con.createStatement();
					ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aRfqTemporaryCode[r][0]+"' ");
					if (rsDeliveryCNT.next())
					{
						deliveryCount = rsDeliveryCNT.getInt(1);
					}
					rsDeliveryCNT.close();
					stateDeliveryCNT.close();

					statement=con.createStatement();
					rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
					rs.next();
					actionName=rs.getString("ACTIONNAME");

					rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
					rs.next();
					oriStatus=rs.getString("STATUSNAME");
					statement.close();
					rs.close();

					String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
					"ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,"+
					"CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
									"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
					PreparedStatement historystmt=con.prepareStatement(historySql);
					historystmt.setString(1,dnDocNo);
					historystmt.setString(2,fromStatusID);
					historystmt.setString(3,oriStatus); //寫入status名稱
					historystmt.setString(4,actionID);
					historystmt.setString(5,actionName);
					historystmt.setString(6,userID);
					historystmt.setString(7,dateBean.getYearMonthDay());
					historystmt.setString(8,dateBean.getHourMinuteSecond());
					historystmt.setString(9,prodCodeGet); //寫入工廠編號
					historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					historystmt.setString(11,remark);
					historystmt.setInt(12,deliveryCount);
					historystmt.setInt(13,Integer.parseInt(aRfqTemporaryCode[r][0])); // 寫入處理Line_No
					historystmt.setFloat(14,processWorkTime);
					historystmt.executeQuery();

					//add by Peggy 20130304,insert data to tsdelivery_notice_remarks table
					if (aRfqTemporaryCode[r][21] != null && !aRfqTemporaryCode[r][21].equals("") && !aRfqTemporaryCode[r][21].equals("&nbsp;") && aRfqTemporaryCode[r][22] != null && !aRfqTemporaryCode[r][22].equals("") && !aRfqTemporaryCode[r][22].equals("&nbsp;"))
					{
						PreparedStatement pstmtDt11=con.prepareStatement("insert into oraddman.tsdelivery_notice_remarks(dndocno, line_no, shipping_marks, remarks,creation_date, created_by, last_update_date,last_updated_by, customer) values(?,?,?,?,sysdate,?,sysdate,?,CASE WHEN ?='ARROW' THEN 'ARROW HONG KONG' ELSE ? END)");
						pstmtDt11.setString(1,dnDocNo);
						pstmtDt11.setInt(2,r+1); // Line_No
						pstmtDt11.setString(3,(aRfqTemporaryCode[r][21].startsWith("&nbsp"))?null:aRfqTemporaryCode[r][21].trim()); //SHIPPING MARKS,Add by Peggy 20130304
						pstmtDt11.setString(4,(aRfqTemporaryCode[r][22].startsWith("&nbsp"))?null:aRfqTemporaryCode[r][22].trim()); //REMARKS,Add by Peggy 20130304
						pstmtDt11.setString(5,UserName); //User
						pstmtDt11.setString(6,UserName);   //User
						pstmtDt11.setString(7,(aRfqTemporaryCode[r][9].indexOf("(")<0?aRfqTemporaryCode[r][9]:aRfqTemporaryCode[r][9].substring(aRfqTemporaryCode[r][9].indexOf("(")+1,aRfqTemporaryCode[r][9].lastIndexOf(")"))));   //customer,modify by Peggy 20130729,抓最右邊的右括號
						pstmtDt11.setString(8,(aRfqTemporaryCode[r][9].indexOf("(")<0?aRfqTemporaryCode[r][9]:aRfqTemporaryCode[r][9].substring(aRfqTemporaryCode[r][9].indexOf("(")+1,aRfqTemporaryCode[r][9].lastIndexOf(")"))));   //customer,modify by Peggy 20130729,抓最右邊的右括號
						pstmtDt11.executeQuery();
					}

				}

				//Step1. 若為業務草稿文件處理(ACTION=CREATE)
				//Step3. 再更新交期詢問主檔資料
				//pstmt=con.prepareStatement("update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? where DNDOCNO='"+dnDocNo+"' ");
				pstmt=con.prepareStatement("update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,CREATED_BY=?,CREATION_DATE=decode(?,'001',CREATION_DATE,TO_CHAR(SYSDATE,'yyyymmddhh24miss')) where DNDOCNO='"+dnDocNo+"' ");
				pstmt.setString(1,userID); // 最後更新人員
				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
				pstmt.setString(3,userID);   // 最後更新人員
				pstmt.setString(4,actionID); //建立時間
				pstmt.executeQuery();

				//write into db
				con.commit();

				//clear array detail
				rfqArray2DTemporaryBean.setArray2DString(null);
			}
			catch (Exception e)
			{
				errCnt++;
 				out.println("<font color='red'>動作失敗!請速洽系統管理員,謝謝!"+e.getMessage().toString()+"</font>");
				con.rollback();
			}//end of catch
		}
  	}


  	//生管分派產地(ASSIGN)_起	(ACTION=003)
  	if (actionID.equals("003"))
  	{
		//Step1. 若為生管指派(ACTION=ASSIGN)生產地,則依判斷生管預先指派的產地給分批給號序號
		if (aFactoryCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aFactoryCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aFactoryCode[i][0] || choice[k].equals(aFactoryCode[i][0]))
	    			{
	     				String assignFactory = aFactoryCode[i][6];  // 取到被生管預先指定的生產地
	     				// 取號 sub-program 起 @@@@@@@@@@@@@@@@@@@@@@@@@@
	     				String lastLNo = "";

       	 				dateString=dateBean.getYearMonthDay();
	    				seqkey=dnDocNo+"-"+assignFactory; // 先把本張詢問單序號給為取號前置碼(共17碼+'-'+3碼=21碼)
        				//====先取得流水號=====
        				Statement statement=con.createStatement();
        				ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
        				if (rs.next()==false)
        				{
          					String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";
          					PreparedStatement seqstmt=con.prepareStatement(seqSql);
          					seqstmt.setString(1,seqkey);
          					seqstmt.setInt(2,1);
          					seqstmt.executeUpdate();
          					seqno=seqkey+"-01"; // 分批給流水號設為兩碼
          					seqstmt.close();
		  					lastLNo = "01"; // 若為本批次第一筆資料
        				}
        				else
        				{
          					int lastno=rs.getInt("LASTNO");
          					sql = "select * from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
							" where substr(DNDOCNO,1,17)||'-'||substr(ASSIGN_LNO,1,3)='"+seqkey+"' "+
							" and to_number(substr(ASSIGN_LNO,5,2))= '"+lastno+"' ";
          					ResultSet rs2=statement.executeQuery(sql);
          					//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
          					if (rs2.next())
          					{
            					lastno++;
            					String numberString = Integer.toString(lastno);
            					String lastSeqNumber="00"+numberString;
            					lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
            					seqno=seqkey+"-"+lastSeqNumber;
            					String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
            					PreparedStatement seqstmt=con.prepareStatement(seqSql);
            					seqstmt.setInt(1,lastno);
								seqstmt.executeUpdate();
            					seqstmt.close();
								lastLNo = lastSeqNumber; // 本次的最大批序號
          					}
          					else
          					{
             					//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
            					String sSql = "select to_number(substr(max(ASSIGN_LNO),5,2)) as LASTNO "+
								" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
								" where substr(DNDOCNO,1,17)||'-'||substr(ASSIGN_LNO,1,3)='"+seqkey+"' ";
            					ResultSet rs3=statement.executeQuery(sSql);
	        					if (rs3.next()==true)
	        					{
               						int lastno_r=rs3.getInt("LASTNO");
	           						lastno_r++;

	           						String numberString_r = Integer.toString(lastno_r);
               						String lastSeqNumber_r="00"+numberString_r;
               						lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-2);
               						seqno=seqkey+"-"+lastSeqNumber_r;
	           						String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
               						PreparedStatement seqstmt=con.prepareStatement(seqSql);
               						seqstmt.setInt(1,lastno_r);
               						seqstmt.executeUpdate();
               						seqstmt.close();
			   						lastLNo = lastSeqNumber_r; // 本次的最大批序號
	         					}  // End of if (rs3.next()==true)
            				} // End of Else  //===========(處理跳號問題)
         				} // End of Else  //int lastno=rs.getInt("LASTNO");
	     				assignLNo = assignFactory +"-"+ lastLNo;   // 把取到的號碼給本次更新的  ASSIGN_LNO 欄位  // ***********************
	  					// 取號 sub-program 迄 @@@@@@@@@@@@@@@@@@@@
	    				//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
						sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						" set ASSIGN_MANUFACT=ASSIGN_MANUFACT,ASSIGN_LNO=?,PCCFMDATE=?"+
						",LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	        			"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryCode[i][0]+"' ";
       	 				pstmt=con.prepareStatement(sql);
        				pstmt.setString(1,assignLNo); // 批次指派產地序號
        				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 生管指派時間
						pstmt.setString(3,userID); // 最後更新人員
						pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
        				pstmt.setString(5,sToStatusID);
        				pstmt.setString(6,sToStatusName);
        				pstmt.executeUpdate();
        				pstmt.close();

	      				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      			float processWorkTime = 0;
		      			String preWorkTime = "0";
		      			Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '001' (企劃判定產地送出前一狀態為ASSIGNING(001))
              			ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryCode[i][0]+"' and ORISTATUSID ='001' ");
	          			if (rsHProcWT.next())
		      			{
			     			preWorkTime = rsHProcWT.getString(1);
			  			}
						else
						{
			            	Statement stateCProcWT=con.createStatement();  // 若不存在草稿文件,則找單據開立日為
                        	ResultSet rsCProcWT=stateCProcWT.executeQuery("select CREATION_DATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
							" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryCode[i][0]+"' ");
							if (rsCProcWT.next())
							{
						  		preWorkTime = rsCProcWT.getString(1);
							}
							rsCProcWT.close();
							stateCProcWT.close();
			         	}
			  			rsHProcWT.close();
			  			stateHProcWT.close();
           				//若取到前一個狀態時間,則以目前時間減去前
		    			if (preWorkTime!="0")
		    			{
			    			String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
		        			Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                			ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            			if (rsWTime.next())
		        			{
			     				processWorkTime = rsWTime.getFloat(1);
			    			}
			    			rsWTime.close();
			    			stateWTime.close();
						}
						// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

	          			//Step5. 任一Action,寫入交期詢問明細歷程檔
	          			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement();
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();

              			Statement stateACT=con.createStatement();
              			ResultSet rsACT=stateACT.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rsACT.next();
              			actionName=rsACT.getString("ACTIONNAME");

              			rsACT=stateACT.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rsACT.next();
              			oriStatus=rsACT.getString("STATUSNAME");
              			stateACT.close();
              			rsACT.close();

	          			String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
					                      "ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,"+
						                  "CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                                  "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          			PreparedStatement historystmt=con.prepareStatement(historySql);
              			historystmt.setString(1,dnDocNo);
              			historystmt.setString(2,fromStatusID);
              			historystmt.setString(3,oriStatus); //寫入status名稱
              			historystmt.setString(4,actionID);
              			historystmt.setString(5,actionName);
              			historystmt.setString(6,userID);
              			historystmt.setString(7,dateBean.getYearMonthDay());
              			historystmt.setString(8,dateBean.getHourMinuteSecond());
              			historystmt.setString(9,prodCodeGet); //寫入維修點編號
              			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,remark);
              			historystmt.setInt(12,deliveryCount);
		      			historystmt.setInt(13,Integer.parseInt(aFactoryCode[i][0])); // 寫入處理Line_No
		      			historystmt.setFloat(14,processWorkTime);
		      			historystmt.executeUpdate();
              			historystmt.close();
	         			//Step5. 寫入交期詢問明細歷程檔
             			//===ENF OF 寫入action history

		   				// 寄送 E-Mail_起
			 			if (sendMailOption!=null && sendMailOption.equals("YES"))
             			{
	          				String sqlAddList = "select DISTINCT ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
							" where DNDOCNO='"+dnDocNo+"' and ASSIGN_MANUFACT != 'N/A' and TO_CHAR(LINE_NO) = '"+aFactoryCode[i][0]+"' ";
	          				Statement stateAddList=con.createStatement();
              				ResultSet rsAddList=stateAddList.executeQuery(sqlAddList);
              				while (rsAddList.next())
	          				{
	            				Statement stateList=con.createStatement();
	            				String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSPROD_PERSON b "+
								" where a.USERNAME = b.USERNAME and b.PROD_FACNO = '"+rsAddList.getString(1)+"' and b.PACTIVE = 'Y' ";
                				ResultSet rsList=stateList.executeQuery(sqlList);
	            				if (rsList.next())
	            				{
                   					sendMailBean.setMailHost(mailHost);
                   					sendMailBean.setReception(rsList.getString("USERMAIL"));
                   					sendMailBean.setFrom(UserName);
                   					sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System Document Approvement Notification"));
				   		           	sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+
									CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:總公司企劃分派交期生產地-("+dnDocNo+")"));
                   					sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQEstimatingPage.jsp?DNDOCNO="+dnDocNo+"&LSTATUSID=003");
				   					sendMailBean.setUrlName1(CodeUtil.unicodeToBig5("   交期詢問單Excel表動態生成請點擊如下連結:\n"));
                   					sendMailBean.setUrlAddr1(serverHostName+":8080/oradds/jsp/TSSalesDRQAssignInf2Excel.jsp?DNDOCNO="+dnDocNo);
                   					sendMailBean.sendMail();
	            				} //While (rsList.next())
	            				rsList.close();
	            				stateList.close();
	         				} //While (rsAddList.next())
	         				rsAddList.close();
	         				stateAddList.close();
	       				} // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	   				} // End of if (choice[k]==aFactoryCode[i][0] || choice[k].equals(aFactoryCode[i][0]))
	  			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才指派生產地
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aFactoryCode!=null)

	  	//Step4. 取得本張單據分配的工廠組合字串_起
        Statement stateProdDesc=con.createStatement();
        ResultSet rsProdDesc=stateProdDesc.executeQuery("select DISTINCT ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
		" where DNDOCNO='"+dnDocNo+"' ");
        while (rsProdDesc.next())
        {
        	prodDesc = rsProdDesc.getString(1);
	        prodCodeGet = prodCodeGet + prodDesc+",";
        }
        rsProdDesc.close();
        stateProdDesc.close();

		if (prodCodeGet.length()>0)
        {
        	prodCodeGetLength = prodCodeGet.length()-1;  // 把最後的','去掉
            prodCodeGet = prodCodeGet.substring(0,prodCodeGetLength);
        }
	 	//取得本張單據分配的工廠組合字串_迄

	 	//Step4. 再更新交期詢問主檔資料
    	sql="update ORADDMAN.TSDELIVERY_NOTICE set PROD_FACTORY=?,PCCFIRM_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	    "where DNDOCNO='"+dnDocNo+"' ";
     	pstmt=con.prepareStatement(sql);
     	pstmt.setString(1,prodCodeGet);
     	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 生管指派時間
     	pstmt.setString(3,userID); // 最後更新人員
	 	pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
     	pstmt.executeUpdate();
     	pstmt.close();
	 	// 再更新交期詢問主檔資料

		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aFactoryCode!=null)
		{
			array2DAssignFactoryBean.setArray2DString(null);
		}
  	}  //END OF 003 ACTION IF
  	//生管分派產地(ASSIGN)_迄	(ACTION=003)

  	//  (ACTION=005)工廠批退交期詢問單(REJECT)_起 (ACTION=005) 即正常流至企劃(RESPONDING),且Show出批退訊息
  	if (actionID.equals("005"))
  	{
		String choose_line = ""; //add by Peggy 20120321
		if (aFactoryEstimatingCode!=null) // 判斷該次處理細項才更新明細檔
		{
	 		for (int i=0;i<aFactoryEstimatingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)
       			{
		 			// 判斷被Check 的Line 才執行工廠安排交期作業
	    			if (choice[k]==aFactoryEstimatingCode[i][0] || choice[k].equals(aFactoryEstimatingCode[i][0]))
	    			{
						//add by Peggy  20161021,update前檢查rfq狀態是否合法
						Statement stater=con.createStatement();
						sql = " select 1 from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
						      " where DNDOCNO='"+dnDocNo+"' "+
							  " and TO_CHAR(LINE_NO) = '"+aFactoryEstimatingCode[i][0]+"'"+
							  " and a.LSTATUSID='"+fromStatusID+"'";
						ResultSet rsr=stater.executeQuery(sql);
						if (rsr.next())
						{
							is_exist=true;
						}
						else
						{
							is_exist=false;
						}
						rsr.close();
						stater.close();
						if (!is_exist)
						{
							throw new Exception("查無RFQ資料!");
						}

						choose_line += (","+aFactoryEstimatingCode[i][0]); //add by Peggy 20120321
	     				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						"set ASSIGN_MANUFACT=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?"+
						",SHIP_DATE=?,REMARK=? , EDIT_CODE=? ,AUTOCREATE_FLAG = ?"+
	         			"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryEstimatingCode[i][0]+"' ";
         				pstmt=con.prepareStatement(sql);
         				pstmt.setString(1,aFactoryEstimatingCode[i][7]); // 轉移的產地代碼
		 				pstmt.setString(2,userID); // 最後更新人員
		 				pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
         				pstmt.setString(4,sToStatusID);
         				pstmt.setString(5,sToStatusName);
		 				pstmt.setString(6,"N/A"); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間(因為工廠批退,故不給SHIP_DATE時間)
		 				pstmt.setString(7,aFactoryEstimatingCode[i][5]); // 記住各項次批退的原因
		 				pstmt.setString(8,"R"); // 記住批退代碼"R"  //2009/03/03 LILING add
		 				pstmt.setString(9,"R"); // AUTOCREATE_FLAG, ADD BY Peggy 20120322
         				pstmt.executeUpdate();
         				pstmt.close();

		  				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      			float processWorkTime = 0;
		      			String preWorkTime = "0";
		     			Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '003' (工廠批退交期安排中送出前一狀態為ESTIMATING(003))
              			ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryEstimatingCode[i][0]+"' and ORISTATUSID ='003' ");
	          			if (rsHProcWT.next())
		      			{
			     			preWorkTime = rsHProcWT.getString(1);
			  			}
			  			rsHProcWT.close();
			  			stateHProcWT.close();
           				//若取到前一個狀態時間,則以目前時間減去前
		    			if (preWorkTime!="0")
		    			{
			    			String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+
							dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) "+
							"from DUAL ";
		        			Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                			ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            			if (rsWTime.next())
		        			{
			     				processWorkTime = rsWTime.getFloat(1);
			    			}
			    			rsWTime.close();
			    			stateWTime.close();
						}
						// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

		      			//Step5. 任一Action,寫入交期詢問明細歷程檔
	          			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement();
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryEstimatingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
              			Statement statement=con.createStatement();
              			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");
              			statement.close();
              			rs.close();
	          			String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,"+
						"ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,"+
						"SERIALROW,LINE_NO,PROCESS_WORKTIME,PC_REMARK) "+
		                "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          			PreparedStatement historystmt=con.prepareStatement(historySql);
              			historystmt.setString(1,dnDocNo);
              			historystmt.setString(2,fromStatusID);
              			historystmt.setString(3,oriStatus); //寫入status名稱
              			historystmt.setString(4,actionID);
              			historystmt.setString(5,actionName);
             		 	historystmt.setString(6,userID);
              			historystmt.setString(7,dateBean.getYearMonthDay());
              			historystmt.setString(8,dateBean.getHourMinuteSecond());
              			historystmt.setString(9,prodCodeGet); //寫入維修點編號
             	 		historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aFactoryEstimatingCode[i][5]);
              			historystmt.setInt(12,deliveryCount);
		      			historystmt.setInt(13,Integer.parseInt(aFactoryEstimatingCode[i][0])); // 寫入處理Line_No
		      			historystmt.setFloat(14,processWorkTime);
		      			historystmt.setString(15,aFactoryEstimatingCode[i][8]); // 20110111 LILING 寫入處理PC_COMMENT
		      			historystmt.executeUpdate();
              			historystmt.close();
	         			//Step5. 寫入交期詢問明細歷程檔
             			//===ENF OF 寫入action history
					}  // End of if (choice[k]==aFactoryEstimatingCode[i][0] || choice[k].equals("aFactoryEstimatingCode[i][0]"))
	  			}  // End of for (int k=0;k<choice.length;k++))
	 		} // End of for
		} // End of if (aFactoryEstimatingCode!=null)
		if (aFactoryArrangedCode!=null) // 企劃取得工廠無法給予交期,需回覆業務REJECT作業
		{
	 		for (int i=0;i<aFactoryArrangedCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)
       			{
	    			if (choice[k]==aFactoryArrangedCode[i][0] || choice[k].equals(aFactoryArrangedCode[i][0]))
	    			{
						choose_line += (","+aFactoryArrangedCode[i][0]); //add by Peggy 20120321
	     				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						" set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,SHIP_DATE=?,REMARK=?,EDIT_CODE=? ,AUTOCREATE_FLAG = ?"+
	         			"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ";
         				pstmt=con.prepareStatement(sql);
		 				pstmt.setString(1,userID); // 最後更新人員
		 				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
         				pstmt.setString(3,sToStatusID);
         				pstmt.setString(4,sToStatusName);
		 				pstmt.setString(5,"N/A"); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間(因為工廠批退,故不給SHIP_DATE時間)
		 				pstmt.setString(6,aFactoryArrangedCode[i][5]); // 記住各項次批退的原因
		 				pstmt.setString(7,"R"); // 記住批退代碼"R"
		 				pstmt.setString(8,"R"); // AUTOCREATE_FLAG, ADD BY Peggy 20120322
         				pstmt.executeUpdate();
         				pstmt.close();

		  				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      			float processWorkTime = 0;
		      			String preWorkTime = "0";
		      			Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '004' (工廠批退交期確認送出前一狀態為ARRANGED(004))
              			ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' and ORISTATUSID ='004' ");
	          			if (rsHProcWT.next())
		      			{
			     			preWorkTime = rsHProcWT.getString(1);
			  			}
			  			rsHProcWT.close();
			  			stateHProcWT.close();
           				//若取到前一個狀態時間,則以目前時間減去前
		    			if (preWorkTime!="0")
		    			{
			    			String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+
							dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) "+
							"from DUAL ";
		        			Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                			ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            			if (rsWTime.next())
		        			{
			     				processWorkTime = rsWTime.getFloat(1);
			    			}
			    			rsWTime.close();
			    			stateWTime.close();
						}
						// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

		      			//Step5. 任一Action,寫入交期詢問明細歷程檔
	          			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement();
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
              			Statement statement=con.createStatement();
              			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");

              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");
             		 	statement.close();
              			rs.close();

	          			String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
						"ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,LINE_NO"+
						",PROCESS_WORKTIME,PC_REMARK) "+
		                "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          			PreparedStatement historystmt=con.prepareStatement(historySql);
              			historystmt.setString(1,dnDocNo);
              			historystmt.setString(2,fromStatusID);
              			historystmt.setString(3,oriStatus); //寫入status名稱
              			historystmt.setString(4,actionID);
              			historystmt.setString(5,actionName);
              			historystmt.setString(6,userID);
              			historystmt.setString(7,dateBean.getYearMonthDay());
              			historystmt.setString(8,dateBean.getHourMinuteSecond());
              			historystmt.setString(9,aFactoryArrangedCode[i][7]); // 20110111 update 寫入工廠編號
              			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,remark);  // 給業務批退批次註明
              			historystmt.setInt(12,deliveryCount);
		      			historystmt.setInt(13,Integer.parseInt(aFactoryArrangedCode[i][0])); // 寫入處理Line_No
		      			historystmt.setFloat(14,processWorkTime);
		      			historystmt.setString(15,aFactoryArrangedCode[i][8]); // 20110111 PC_REMARK
		      			historystmt.executeUpdate();
             	 		historystmt.close();
	         			//Step5. 寫入交期詢問明細歷程檔
             			//===ENF OF 寫入action history

			 			//  派送E-Mail_起
			 			if (sendMailOption!=null && sendMailOption.equals("YES"))
             			{
	           				String sqlAddList = "select DISTINCT CREATED_BY from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
							" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ";
	           				Statement stateAddList=con.createStatement();
               				ResultSet rsAddList=stateAddList.executeQuery(sqlAddList);
               				while (rsAddList.next())
	           				{
	             				Statement stateList=con.createStatement();
	             				String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSRECPERSON b "+
								" where a.USERNAME = b.USERNAME and b.USERID = '"+rsAddList.getString(1)+"' ";
                 				ResultSet rsList=stateList.executeQuery(sqlList);
	             				while (rsList.next())
	             				{
                   					sendMailBean.setMailHost(mailHost);
                   					sendMailBean.setReception(rsList.getString("USERMAIL"));
                   					sendMailBean.setFrom(UserName);
                   					sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System Document Approvement Notification"));
		           					sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+
									CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:企劃批退交期詢問單(請檢視備註說明)-("+dnDocNo+")"));
                   					sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQConfirmedPage.jsp?DNDOCNO="+
									dnDocNo+"&LINE_NO="+aFactoryArrangedCode[i][0]);
                   					sendMailBean.sendMail();
	             				}
	             				rsList.close();
	            				stateList.close();
	           				}
	           				rsAddList.close();
	           				stateAddList.close();
	        			}
					}
	  			}
	 		}
		}

		if (!choose_line.equals(""))
		{
			CallableStatement cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.ACTION_REJECT_EMAIL_NOTICE(?,?)}");
			cs3.setString(1,dnDocNo);
			cs3.setString(2,choose_line+",");
			cs3.execute();
			cs3.close();
		}
	    //Step4. 再更新交期詢問主檔資料
       	sql="update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? where DNDOCNO='"+dnDocNo+"' ";
       	pstmt=con.prepareStatement(sql);
      	pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 工廠交期確認時間
       	pstmt.setString(2,userID); // 最後更新人員
	   	pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
       	pstmt.executeUpdate();
       	pstmt.close();
	   	// 再更新交期詢問主檔資料
		//###***  完成各處理後即將session取到的Bean 的內容值清空(避免二次傳送)  *****###
		if (aFactoryEstimatingCode!=null) array2DEstimateFactoryBean.setArray2DString(null);
		if (aFactoryArrangedCode!=null)	array2DArrangedFactoryBean.setArray2DString(null);
  	} //若為工廠批退交期詢問單(REJECT)_或企劃批退業務交期詢問單(REJECT)_迄
  	// 工廠批退交期詢問單(REJECT)_迄 (ACTION=005)

	//  (ACTION=007)工廠請求企劃重新指派產地(REASSIGN)_起 (ACTION=007)
  	if (actionID.equals("007"))
  	{
		if (aFactoryEstimatingCode!=null) // 判斷該次處理細項才更新明細檔
		{
	 		for (int i=0;i<aFactoryEstimatingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)
       			{
		 			// 判斷被Check 的Line 才執行工廠安排交期作業
	    			if (choice[k]==aFactoryEstimatingCode[i][0] || choice[k].equals(aFactoryEstimatingCode[i][0]))
	    			{
	     				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL  set FTACPDATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,SHIP_DATE=?,REMARK=? "+
	         			" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryEstimatingCode[i][0]+"' ";
         				pstmt=con.prepareStatement(sql);
         				pstmt.setString(1,"N/A"); // 設定的工廠確認日期 + 時間
		 				pstmt.setString(2,userID); // 最後更新人員
		 				pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
         				pstmt.setString(4,sToStatusID);
         				pstmt.setString(5,sToStatusName);
		 				pstmt.setString(6,"N/A"); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間
		 				pstmt.setString(7,aFactoryEstimatingCode[i][5]); // 記住各項次批退的原因
         				pstmt.executeUpdate();
         				pstmt.close();

						// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      			float processWorkTime = 0;
		      			String preWorkTime = "0";
		      			Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '002' (工廠批退交期安排中送出前一狀態為ESTIMATING(002))
              			ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryEstimatingCode[i][0]+"' and ORISTATUSID ='002' ");
	          			if (rsHProcWT.next()) preWorkTime = rsHProcWT.getString(1);
			  			rsHProcWT.close();
			  			stateHProcWT.close();
           				//若取到前一個狀態時間,則以目前時間減去前
		    			if (preWorkTime!="0")
		    			{
			    			String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2)  from DUAL ";
		        			Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                			ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            			if (rsWTime.next())
		        			{
			     				processWorkTime = rsWTime.getFloat(1);
			    			}
			    			rsWTime.close();
			    			stateWTime.close();
						}
						// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

		      			//Step5. 任一Action,寫入交期詢問明細歷程檔
	          			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement();
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryEstimatingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
              			Statement statement=con.createStatement();
              			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");
              			statement.close();
              			rs.close();

	          			String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,"+
						" LINE_NO,PROCESS_WORKTIME) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          			PreparedStatement historystmt=con.prepareStatement(historySql);
              			historystmt.setString(1,dnDocNo);
              			historystmt.setString(2,fromStatusID);
              			historystmt.setString(3,oriStatus); //寫入status名稱
              			historystmt.setString(4,actionID);
              			historystmt.setString(5,actionName);
              			historystmt.setString(6,userID);
              			historystmt.setString(7,dateBean.getYearMonthDay());
              			historystmt.setString(8,dateBean.getHourMinuteSecond());
              			historystmt.setString(9,prodCodeGet); //寫入工廠編號
              			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aFactoryEstimatingCode[i][5]); //個別Line的重新指派說明
              			historystmt.setInt(12,deliveryCount);
		      			historystmt.setInt(13,Integer.parseInt(aFactoryEstimatingCode[i][0])); // 寫入處理Line_No
		      			historystmt.setFloat(14,processWorkTime);
		      			historystmt.executeUpdate();
              			historystmt.close();
					}
	  			}
	 		}
		}

	    //Step4. 再更新交期詢問主檔資料
       	sql="update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? where DNDOCNO='"+dnDocNo+"' ";
       	pstmt=con.prepareStatement(sql);
       	pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 工廠交期確認時間
       	pstmt.setString(2,userID); // 最後更新人員
	   	pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
       	pstmt.executeUpdate();
       	pstmt.close();
	   	// 再更新交期詢問主檔資料
		//###***  完成各處理後即將session取到的Bean 的內容值清空(避免二次傳送)  *****###
		if (aFactoryEstimatingCode!=null)  array2DEstimateFactoryBean.setArray2DString(null);
 	} //若為重新指派產地(REASSIGN)_迄
  	// 工廠請求企劃重新指派產地(REASSIGN)_迄 (ACTION=007)


  	//若為企劃交期回覆已確認(ACEPT)_起 (ACTION=010)
  	if (actionID.equals("010"))
  	{
    	//工廠交期已回覆由企劃生管作狀態確認後,更新至交期回應客戶同意中(RESPONDING)
	 	//Step2. 取得本張單據分配的工廠組合字串_起
	 	if (aFactoryArrangedCode!=null)
	 	{
	   		for (int i=0;i<aFactoryArrangedCode.length-1;i++)
	   		{
	    		for (int k=0;k<=choice.length-1;k++)
        		{
		 			// 判斷被Check 的Line 才執行工廠安排交期作業
	     			if (choice[k]==aFactoryArrangedCode[i][0] || choice[k].equals(aFactoryArrangedCode[i][0]))
	     			{
	      				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						" set PCACPDATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,SHIP_DATE=?,PROMISE_DATE=? "+
	          			"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ";
          				pstmt=con.prepareStatement(sql);
						 // 若生管未重新給定交期日,則以工產安排日為其交期日
		  				if (aFactoryArrangedCode[i][6].equals("N/A")) aFactoryArrangedCode[i][6] = aFactoryArrangedCode[i][7];
		  				if (aFactoryArrangedCode[i][7].equals("N/A"))  // 若是工廠與生管都未給定日期,則回覆預設值予原需求日
		  				{
							aFactoryArrangedCode[i][6] = aFactoryArrangedCode[i][4]; aFactoryArrangedCode[i][7] = aFactoryArrangedCode[i][4];
						}
          				pstmt.setString(1,aFactoryArrangedCode[i][6]); // 設定的PC 接收日期 + 時間
		  				pstmt.setString(2,userID); // 最後更新人員
		  				pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
          				pstmt.setString(4,sToStatusID);
          				pstmt.setString(5,sToStatusName);
		  				pstmt.setString(6,aFactoryArrangedCode[i][6]); // 預設將生管的確認日給Schedule Shipment Date日期 + 時間
		  				pstmt.setString(7,aFactoryArrangedCode[i][6]); // 預設將生管的確認日給Customer Request Date日期 + 時間
          				pstmt.executeUpdate();
          				pstmt.close();

		 				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      			float processWorkTime = 0;
		      			String preWorkTime = "0";
		      			Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '003' (工廠批退交期安排中送出前一狀態為ESTIMATING(003))
              			ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' and ORISTATUSID ='004' ");
	          			if (rsHProcWT.next())
		      			{
			     			preWorkTime = rsHProcWT.getString(1);
			  			}
			  			rsHProcWT.close();
			  			stateHProcWT.close();
           				//若取到前一個狀態時間,則以目前時間減去前
		    			if (preWorkTime!="0")
		    			{
			    			String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
							+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
		        			Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                			ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            			if (rsWTime.next())
		        			{
			     				processWorkTime = rsWTime.getFloat(1);
			    			}
			    			rsWTime.close();
			    			stateWTime.close();
						}
          				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

		      			//Step5. 任一Action,寫入交期詢問明細歷程檔
	          			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement();
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();

              			Statement statement=con.createStatement();
              			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");

              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");
              			statement.close();
              			rs.close();

	          			String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
					    "ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,"+
						"REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME,ARRANGED_DATE) "+
		                "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          			PreparedStatement historystmt=con.prepareStatement(historySql);
              			historystmt.setString(1,dnDocNo);
              			historystmt.setString(2,fromStatusID);
             		 	historystmt.setString(3,oriStatus); //寫入status名稱
              			historystmt.setString(4,actionID);
              			historystmt.setString(5,actionName);
              			historystmt.setString(6,userID);
              			historystmt.setString(7,dateBean.getYearMonthDay());
              			historystmt.setString(8,dateBean.getHourMinuteSecond());
              			historystmt.setString(9,prodCodeGet); //寫入工廠編號
              			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,remark);
              			historystmt.setInt(12,deliveryCount);
		      			historystmt.setInt(13,Integer.parseInt(aFactoryArrangedCode[i][0])); // 寫入處理Line_No
		      			historystmt.setFloat(14,processWorkTime);
			  			historystmt.setString(15,aFactoryArrangedCode[i][6]);  //20101105 liling
		      			historystmt.executeUpdate();
              			historystmt.close();
	         			//Step5. 寫入交期詢問明細歷程檔
             			//===ENF OF 寫入action history

						// 企劃回覆交期寄送Mail予開單業務人員_起
			 			/*if (sendMailOption!=null && sendMailOption.equals("YES"))
             			{
	          				String sqlAddList = "select DISTINCT CREATED_BY from ORADDMAN.TSDELIVERY_NOTICE where DNDOCNO='"+dnDocNo+"' ";
	          				Statement stateAddList=con.createStatement();
              				ResultSet rsAddList=stateAddList.executeQuery(sqlAddList);
              				if (rsAddList.next())
	          				{
	             				Statement stateList=con.createStatement();
	             				String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a, ORADDMAN.TSRECPERSON b "+
								" where a.USERNAME = b.USERNAME "+
				                "and b.USERID = '"+rsAddList.getString(1)+"' "; //取單據開立人員Email
                 				ResultSet rsList=stateList.executeQuery(sqlList);
	             				while (rsList.next())
	             				{
                   					sendMailBean.setMailHost(mailHost);
                   					sendMailBean.setReception(rsList.getString("USERMAIL"));
                   					sendMailBean.setFrom(UserName);
                   					sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System Document Approvement Notification"));	                   					sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"
									+CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:客戶交期等待確認-("+dnDocNo+")"));
                   					sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQQueryAllStatus.jsp"+
									"?STATUSID=008&PAGEURL=TSSalesDRQConfirmedPage.jsp&SEARCHSTRING="+dnDocNo);
                   					sendMailBean.sendMail();
	             				} // End of while
                 				rsList.close();
	             				stateList.close();
	           				} // End of if
	           				rsAddList.close();
	           				stateAddList.close();
	       				} // End of if (sendMailOption!=null && sendMailOption.equals("YES"))*/
		 			} // End of if (choice[k]==aFactoryArrangedCode[i][0] || choice[k].equals(aFactoryArrangedCode[i][0]))
				} // End of for (int k=0;k<choice.length;k++)
	   		} // End of for
	 	} // End of If  aFactoryArrangedCode!=null

	    //Step4. 再更新交期詢問主檔資料
       	sql="update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	       "where DNDOCNO='"+dnDocNo+"' ";
       	pstmt=con.prepareStatement(sql);
       	pstmt.setString(1,userID); // 最後更新人員
	   	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
       	pstmt.executeUpdate();
       	pstmt.close();
	   	// 再更新交期詢問主檔資料

		//###***  完成各處理後即將session取到的Bean 的內容值清空(避免二次傳送)  *****###
		if (aFactoryArrangedCode!=null)
    	{
			array2DArrangedFactoryBean.setArray2DString(null);
		}
  	} //若為工廠交期回覆已確認(ACEPT)_迄 (ACTION=010)

  	if (actionID.equals("011") || actionID.equals("015")) ////業務取得客戶確認交期_APPLY_或CLOSE_(內銷結案)_起
  	{
    	if (aCustCancelPromiseCode!=null) // 判斷該次處理細項才更新明細檔
	    {
			for (int i=0;i<aCustCancelPromiseCode.length-1;i++)
	        {
	        	for (int k=0;k<=choice.length-1;k++)
               	{
		        	// 判斷被Check 的Line 才執行客戶確認交期作業
	             	if (choice[k]==aCustCancelPromiseCode[i][0] || choice[k].equals(aCustCancelPromiseCode[i][0]))
	             	{
				    	// 2006/12/27_因應 YEW ERP上線_判斷大陸內銷單(012,013區)如給天津廠生產地(T)的項次,直接結案_起
					  	String statusID=sToStatusID;
					  	String status=sToStatusName;
					  	salesAreaNo = dnDocNo.substring(2,5);
					   	if ( (salesAreaNo.equals("012") || salesAreaNo.equals("013")) && aCustCancelPromiseCode[i][7].equals("T") ) // 天津直接結案
					   	{
					    	statusID = "010"; // 產地是天津RFQ項次直接結案
						 	status = "CLOSED";// 產地是天津RFQ項次直接結案
					   	}
					 	// 2006/12/27_因應 YEW ERP上線_判斷大陸內銷單(012,013區)如給天津廠生產地(T)的項次,直接結案_迄

				     	sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						" set REREQUEST_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	                     "where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ";
                     	pstmt=con.prepareStatement(sql);
						// 若業務未重新給定交期日,則以原需求日為其重新需求日
		             	if (aCustCancelPromiseCode[i][6].equals("N/A")) aCustCancelPromiseCode[i][6] = aCustCancelPromiseCode[i][4];
                     	pstmt.setString(1,aCustCancelPromiseCode[i][6]); // 設定的重新需求日期 + 時間
		             	pstmt.setString(2,userID); // 最後更新人員
		             	pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
		             	pstmt.setString(4,statusID); // Line 的狀態ID
		             	pstmt.setString(5,status); // Line 的狀態
                     	pstmt.executeUpdate();
                     	pstmt.close();

					 	// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		             	float processWorkTime = 0;
		             	String preWorkTime = "0";
					 	// ORISTATUSID = '007' (客戶確認交期送出前一狀態為企劃覆議交期RESPONDING(007))
		             	Statement stateHProcWT=con.createStatement();
                     	ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' and ORISTATUSID ='007' ");
	                 	if (rsHProcWT.next())
		             	{
			          		preWorkTime = rsHProcWT.getString(1);
			         	}
			         	rsHProcWT.close();
			         	stateHProcWT.close();
                     	//若取到前一個狀態時間,則以目前時間減去前
		             	if (preWorkTime!="0")
		             	{
			          		String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
							+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
		              		Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                      		ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	                  		if (rsWTime.next())
		              		{
			            		processWorkTime = rsWTime.getFloat(1);
			          		}
			          		rsWTime.close();
			          		stateWTime.close();
			        	}
                    	// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

					 	//Step5. 任一Action,寫入交期詢問明細歷程檔
	                 	int deliveryCount = 0;
	                 	Statement stateDeliveryCNT=con.createStatement();
                     	ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ");
	                 	if (rsDeliveryCNT.next())
	                 	{
	                  		deliveryCount = rsDeliveryCNT.getInt(1);
	                 	}
	                 	rsDeliveryCNT.close();
	                 	stateDeliveryCNT.close();
                     	Statement statement=con.createStatement();
                     	ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
                     	rs.next();
                     	actionName=rs.getString("ACTIONNAME");

                     	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
                     	rs.next();
                     	oriStatus=rs.getString("STATUSNAME");
                     	statement.close();
                     	rs.close();

	                 	String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,"+
						"ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,"+
						"CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME,ARRANGED_DATE) "+
		                " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	                 	PreparedStatement historystmt=con.prepareStatement(historySql);
                     	historystmt.setString(1,dnDocNo);
                     	historystmt.setString(2,fromStatusID);
                     	historystmt.setString(3,oriStatus); //寫入status名稱
                     	historystmt.setString(4,actionID);
                     	historystmt.setString(5,actionName);
                     	historystmt.setString(6,userID);
                     	historystmt.setString(7,dateBean.getYearMonthDay());
                     	historystmt.setString(8,dateBean.getHourMinuteSecond());
                     	historystmt.setString(9,prodCodeGet); //寫入工廠編號
                     	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
                     	historystmt.setString(11,remark);
                     	historystmt.setInt(12,deliveryCount);
		             	historystmt.setInt(13,Integer.parseInt(aCustCancelPromiseCode[i][0])); // 寫入處理Line_No
		             	historystmt.setFloat(14,processWorkTime);
		             	historystmt.setString(15,aCustCancelPromiseCode[i][6]);
		             	historystmt.executeUpdate();
                     	historystmt.close();
	                 	//Step5. 寫入交期詢問明細歷程檔

					 	// 取企劃回覆交期及業務確認日於明細歷程檔內,判斷此客戶確認是否超過工廠回覆交期4日以上,則更新無效單據FLAG='Y'
		             	String respondingDate= "0";
		             	String salesCinfirmDate = "0";
		             	String limitSalesDate="0";
                     	String respDay="0";   //add by Peggy 20111226
                     	int setDay=3;  //add by Peggy 20111226
		             	Statement stateEstDate=con.createStatement();
						//modify by Peggy 20111226
						ResultSet rsEstDate=stateEstDate.executeQuery("SELECT a.UPDATEDATE,a.ORISTATUSID, a.remark,"+
                                   //" nvl( (SELECT limit_days FROM oraddman.tssales_comfirm_days "+
								   //" WHERE TO_DATE (a.updatedate, 'yyyy-mm-dd') BETWEEN start_date AND end_date) ,'0') resp_day"+
								   " to_char(to_date(a.updatedate,'yyyymmdd')+"+setDay+"+tsc_get_holiday_days( TO_DATE(a.updatedate,'YYYYMMDD'), sysdate,null),'yyyymmdd') limitSalesDate"+ //add by Peggy 20170802
                                   " FROM oraddman.tsdelivery_detail_history a"+
                                   " where a.DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' "+
		                           " and a.ORISTATUSID in ('004','007','008','014') and ORISTATUS in ('ARRANGED','RESPONDING','CONFIRMED','PENDING') order by decode(a.ORISTATUSID,'014',1,0),a.ORISTATUSID ");
		             	while (rsEstDate.next())
		             	{
		               		if (rsEstDate.getString("ORISTATUSID").equals("007"))
							{
								respondingDate=rsEstDate.getString("UPDATEDATE");
								//respDay=rsEstDate.getString("RESP_DAY");  //20111226
								limitSalesDate=rsEstDate.getString("limitSalesDate");  //add by Peggy 20170802
							}
			           		if (rsEstDate.getString("ORISTATUSID").equals("008")) salesCinfirmDate = rsEstDate.getString("UPDATEDATE");
		               		if (rsEstDate.getString("ORISTATUSID").equals("004"))
							{
								respondingDate=rsEstDate.getString("UPDATEDATE");
								//respDay=rsEstDate.getString("RESP_DAY");  //20111226
								limitSalesDate=rsEstDate.getString("limitSalesDate");  //add by Peggy 20170802
							}
		             	}
		             	stateEstDate.close();
		             	rsEstDate.close();
		             	////Step1. 設定企劃判定日為目前日期, 且業務亦確認客戶交期
		             	//if (respondingDate!="0" && !respondingDate.equals("0") && salesCinfirmDate != "0" && !salesCinfirmDate.equals("0"))
		             	//{
						//	setDay += Integer.parseInt(respDay);  //20111226 modify by Peggy 直接加上select sql回傳天數
		                //		dateBean.setVarDate(Integer.parseInt(respondingDate.substring(0,4)),Integer.parseInt(respondingDate.substring(4,6)),Integer.parseInt(respondingDate.substring(6,8)));
			            //		dateBean.setAdjDate(setDay);
			            //		limitSalesDate=dateBean.getYearMonthDay(); // 取回業務限制開單日
			            //		dateBean.setAdjDate(setDay*(-1));//日期調整回來
			            //		dateBean.setVarDate(Integer.parseInt(dateCurrent.substring(0,4)),Integer.parseInt(dateCurrent.substring(4,6)),Integer.parseInt(dateCurrent.substring(6,8))); //日期調整回來
		             	//}
					 	if (Integer.parseInt(salesCinfirmDate)>Integer.parseInt(limitSalesDate)) // 判斷若超過,則更新Exceed_Valid Flag --> Y
					 	{
					    	String sqlExceed="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set SDRQ_EXCEED='Y' "+
							" where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ";
	                    	PreparedStatement stmtExceed=con.prepareStatement(sqlExceed);
							stmtExceed.executeUpdate();
                        	stmtExceed.close();
					 	} // End of if
				 	} // End of if (choice[k]==aCustCancelPromiseCode[i][0] || choice[k].equals(aCustCancelPromiseCode[i][0]))
			   	} // End of for (int k=0;k<=choice.length-1;k++)
			} // End of for (int i=0;i<aCustCancelPromiseCode.length-1;i++)
	    } // End of if (aCustCancelPromiseCode!=null)

	 	// 更新交期詢問主檔
		sql="update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,STATUSID=?,STATUS=? "+
        "where DNDOCNO='"+dnDocNo+"' ";  //原則上已針對各區作查詢限制
        pstmt=con.prepareStatement(sql);
		pstmt.setString(1,userID); // 最後更新人員
		pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
		pstmt.setString(3,sToStatusID);
		pstmt.setString(4,sToStatusName);
        pstmt.executeUpdate();
        pstmt.close();
  	}
   	////業務取得客戶確認交期_APPLY_或CLOSE_(內銷結案)_迄

  	//若為交期詢問銷售訂單生成(COMPLETE)_起 (ACTION=012)
  	if (actionID.equals("012"))
  	{
    	//  取批次訂單生成批號_起( MG00X200XXXXXXXXX-XXX )
        try
        {
        	dateString=dateBean.getYearMonthDay();
            if (dnDocNo==null || dnDocNo.equals("--")) seqkey="MG"+userActCenterNo+dateString; //但仍以預設為使用者地區
            else seqkey="MG"+dnDocNo.substring(2,5)+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號
            //====先取得流水號=====
            Statement statement=con.createStatement();
            ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
            if (rs.next()==false)
            {
            	String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";
                PreparedStatement seqstmt=con.prepareStatement(seqSql);
                seqstmt.setString(1,seqkey);
                seqstmt.setInt(2,1);
                seqstmt.executeUpdate();
                seqno=seqkey+"-001";
                seqstmt.close();
            }
            else
            {
            	int lastno=rs.getInt("LASTNO");
                String sqlLstNo = "select * from ORADDMAN.TSDELIVERY_NOTICE "+
				" where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
                ResultSet rs2=statement.executeQuery(sqlLstNo);
                //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
                if (rs2.next())
                {
                	lastno++;
                    String numberString = Integer.toString(lastno);
                    String lastSeqNumber="000"+numberString;
                    lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
                    seqno=seqkey+"-"+lastSeqNumber;

                    String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
                    PreparedStatement seqstmt=con.prepareStatement(seqSql);
                    seqstmt.setInt(1,lastno);
                    seqstmt.executeUpdate();
                 	seqstmt.close();
                }
                else
                {
                	//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
                    String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO "+
					" from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' ";
                    ResultSet rs3=statement.executeQuery(sSql);
	                if (rs3.next()==true)
	                {
                    	int lastno_r=rs3.getInt("LASTNO");
	                    lastno_r++;
	                    String numberString_r = Integer.toString(lastno_r);
                        String lastSeqNumber_r="000"+numberString_r;
                        lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
                        seqno=seqkey+"-"+lastSeqNumber_r;

	                    String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
                        PreparedStatement seqstmt=con.prepareStatement(seqSql);
                        seqstmt.setInt(1,lastno_r);
                       	seqstmt.executeUpdate();
                        seqstmt.close();
	                }  // End of if (rs3.next()==true)
		        } // End of Else  //===========(處理跳號問題)
            } // End of Else
      	} //end of try
      	catch (Exception e)
      	{
        	out.println("Exception:"+e.getMessage());
      	}

       	String oraUserID = "";
	   	Statement stateUser=con.createStatement();
	   	ResultSet rsUser=stateUser.executeQuery("select DISTINCT ERP_USER_ID from ORADDMAN.WSUSER "+
	   	" where (WEBID = '"+userID+"' or USERNAME = '"+userID+"' ) and ERP_USER_ID is not null ");
       	if (rsUser.next())
       	{
	    	oraUserID = rsUser.getString("ERP_USER_ID");
	   	}
	   	else
	   	{
	    %>
		<script language="javascript">
			alert("No User Authorise in Oracle System");
		</script>
		<%
	   	}
	   	rsUser.close();
	   	stateUser.close();

		int choiceLen = choice.length; // 若有選任一Line作Check才執行下列動作
		if (choiceLen>0)
		{
	   		//業務針對已確認交期詢問單作銷售訂單生成作業,需呼叫產生訂單API
	   		//Step1. 主要步驟(i). 呼叫產生銷售訂單API的 StoreProcedure, 但前提是Array內不是Null
	   		if (aSalesOrderGenerateCode!=null)
	   		{
	     		// 開始針對 Array 內容產生訂單到 Oracle 透過API
	     		String errorMessage = "";
		 		String errorMessageHeader = "";
		 		String noTPriceMsg = "";
		 		String processStatus="";
		 		String processMsg = "";
	     		int headerID = 0;  // 第一次取得的 Header ID
	     		int lineNo = 1;  // 累加的 LineNo
		 		String orderNo = "";
		 		String notifyContact = null;
		 		String notifyLocation = null;
		 		String shipContact = null;
		 		String deliverOrgID = null;
		 		String deliverContactID = null;
		        String orgID = "41";  // 預設的 ORG_ID (2006/12/27)
				String sales_region = "";    //add by Peggy 20211118
				String ship_to_org_id = "";  //add by Peggy 20211118
				String customer_id = "";     //add by Peggy 20211118
				String strSubinv = "N/A";    //add by Peggy 20211118
				// ## 依廠區找此單據開單業務區取得其 OrgID_起
				Statement stateOrg=con.createStatement();
                ResultSet rsOrg=stateOrg.executeQuery("select a.PAR_ORG_ID,a.SALES_AREA_NO,b.SHIP_TO_ORG,b.TSCUSTOMERID from ORADDMAN.TSSALES_AREA a,oraddman.tsdelivery_notice b  "+
				" where a.SALES_AREA_NO=b.TSAREANO and b.DNDOCNO='"+dnDocNo+"'");  //modify by Peggy 20120517
				if (rsOrg.next())
				{
					orgID = rsOrg.getString("PAR_ORG_ID");
					sales_region = rsOrg.getString("SALES_AREA_NO"); //add by Peggy 20211118
					ship_to_org_id = rsOrg.getString("SHIP_TO_ORG"); //add by Peggy 20211118
					customer_id  = rsOrg.getString("TSCUSTOMERID");  //add by Peggy 20211118
				}
				rsOrg.close();
				stateOrg.close();
				// ## 依廠區找此單據開單業務區取得其 OrgID_迄
				//add by Peggy 20120517
				if (orgID.equals("325") && firmOrderType.equals("1302"))
				{
					respID = "50795";
				}
				else if (orgID.equals("906") && firmOrderType.equals("1707")) //8131,add by Peggy 20200509
				{
					respID = "52244";
				}

				// 判斷各訂單類型給定的line Type及 Source Type Code(Oracle Transaction Table -->
		 		if (firmOrderType=="1132" || firmOrderType.equals("1132")) // Drop Ship
		 		{
					sourceTypeCode = "EXTERNAL";
		   			lineType = 1133;
		 		}
				else if (firmOrderType=="1015" || firmOrderType.equals("1015")) // 1121Order
		        {
					lineType = 1013; /* S_R_Ship Only */
				}
				else if (firmOrderType=="1021" || firmOrderType.equals("1021")) // 1131Order
				{
					lineType = 1007; /* S_R_Finished Goods */
				}
				else if (firmOrderType=="1091" || firmOrderType.equals("1091")) // 1211Order
				{
					lineType = 1007; /* S_R_Finished Goods */
				}
				else if (firmOrderType=="1022" || firmOrderType.equals("1022")) // 1141Order
				{
					//lineType = 1007; /* S_R_Finished Goods */
				}
				else if (firmOrderType=="1020" || firmOrderType.equals("1020")) // 1151Order
				{
					lineType = 1007; /* S_R_Finished Goods */
				}
				else if (firmOrderType=="1054" || firmOrderType.equals("1054")) // 1161Order
				{
					lineType = 1051; /* S_R_Internal Deal */ }
				else if (firmOrderType=="1114" || firmOrderType.equals("1114"))  // 1213Order
				{
					lineType = 1113; /* S_R_Forecast_Line */
				}
				else if (firmOrderType=="1056" || firmOrderType.equals("1056"))  // 1112Order (半導體交期詢問單)
				{
					lineType = 1010; /* S_R_Quotation STD */
				}
				else if (firmOrderType=="1161" || firmOrderType.equals("1161"))
				{
					lineType = 1158; /* TSC_S_DropShip Standard Order */
					sourceTypeCode = "EXTERNAL";
				}
				else if (firmOrderType=="1154" || firmOrderType.equals("1154"))
				{
					sourceTypeCode = "EXTERNAL";
				}
				else
				{
					lineType = 1007; /* S_R_Finished Goods */
				}  // 否則預設為

		 		if (aSalesOrderGenerateCode!=null)
		 		{
					out.println("<BR>");
		   		%>
					<jsp:getProperty name="rPH" property="pgSalesOrder"/><jsp:getProperty name="rPH" property="pgGenerateInf"/>
		   		<% out.println("<BR>");
		 		} // end of if

				out.println("<table cellSpacing='0' bordercolordark='#66CC99'  cellPadding='1' width='60%' borderColorLight='#ffffff' border='1'>");
			 	if (shipMethod==null || shipMethod.equals(""))
			 	{
					shipMethod = "N/A";
				}

				//add by Peggy 20211118
				if (sales_region.equals("018"))
				{
					strSubinv="20";
					notifyContact = "4315";
					notifyLocation = "N/A";
					shipContact = "N/A";

					sql = " select a.LOCATION "+
						  " from ar_site_uses_v a"+
						  " ,HZ_CUST_ACCT_SITES b"+
						  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
						  " and a.STATUS=?"+
						  " and a.PRIMARY_FLAG=?"+
						  " and a.SITE_USE_CODE =?"+
						  " and b.CUST_ACCOUNT_ID =?";
					PreparedStatement statement1 = con.prepareStatement(sql);
					statement1.setString(1,"A");
					statement1.setString(2,"Y");
					statement1.setString(3,"DELIVER_TO");
					statement1.setString(4,customer_id);
					ResultSet rs1=statement1.executeQuery();
					if (rs1.next())
					{
						notifyLocation = rs1.getString("LOCATION");
					}
					rs1.close();
					statement1.close();

					sql = " SELECT r.cust_account_role_id"+
						  " FROM hz_cust_site_uses_all s"+
						  ", hz_cust_account_roles r"+
						  " WHERE s.cust_acct_site_id = r.cust_acct_site_id"+
						  " AND r.current_role_state = ?"+
						  " AND s.site_use_id =?"+
						  " AND ROWNUM = ?";
					statement1 = con.prepareStatement(sql);
					statement1.setString(1,"A");
					statement1.setString(2,ship_to_org_id);
					statement1.setInt(3,1);
					rs1=statement1.executeQuery();
					if (rs1.next())
					{
						shipContact = rs1.getString("cust_account_role_id");
					}
					rs1.close();
					statement1.close();
				}
				else
				{
					if (aSalesOrderNotifyInfo!=null)
					{
						if (aSalesOrderNotifyInfo[0]!=null && !aSalesOrderNotifyInfo[0].equals(""))
						{
							notifyContact = aSalesOrderNotifyInfo[0];
						}
						else
						{
							notifyContact = "N/A";
						}
						if (aSalesOrderNotifyInfo[1]!=null && !aSalesOrderNotifyInfo[1].equals(""))
						{
							notifyLocation = aSalesOrderNotifyInfo[1];
						}
						else
						{
							notifyLocation = "N/A";
						}
						if (aSalesOrderNotifyInfo[2]!=null && !aSalesOrderNotifyInfo[2].equals(""))
						{
							shipContact = aSalesOrderNotifyInfo[2];
						}
						else
						{
							shipContact = "N/A";
						}
					}
					else
					{
						notifyContact = "N/A";
						notifyLocation = "N/A";
						shipContact = "N/A";
					}
				}

				if (aSalesOrderDeliverInfo!=null)
			   	{
			    	if (aSalesOrderDeliverInfo[1]!=null && !aSalesOrderDeliverInfo[1].equals(""))
						deliverOrgID = aSalesOrderDeliverInfo[1];
				   	else deliverOrgID = "0";
				   	if (aSalesOrderDeliverInfo[8]!=null && !aSalesOrderDeliverInfo[8].equals(""))
						deliverContactID = aSalesOrderDeliverInfo[8];
				   	else deliverContactID = "0";
			   	}
				else
				{
					deliverOrgID = "0";
					deliverContactID = "0";
				}

				String demonCURR = "CNY";
				Statement statGetItemLP=con.createStatement();
				String sqlGetItemLP = "select b.TO_CURRENCY_CODE from qp_currency_lists_vl a, qp_currency_details b "+
				              " where a.CURRENCY_HEADER_ID = b.CURRENCY_HEADER_ID  and a.BASE_CURRENCY_CODE = 'USD' "+
							  "   and b.TO_CURRENCY_CODE = 'CNY' and b.END_DATE_ACTIVE is null ";						  								 			    //out.println(sqlGetItemLP);
                ResultSet rsGetItemLP=statGetItemLP.executeQuery(sqlGetItemLP);
	            if (rsGetItemLP.next())
				{
					demonCURR = rsGetItemLP.getString("TO_CURRENCY_CODE");
				}
				rsGetItemLP.close();
				statGetItemLP.close();

				if (orgID.equals("325"))
				{
					prCurr = demonCURR; // 內銷需取轉換幣別為CNY
				}

	   			for (int i=0;i<aSalesOrderGenerateCode.length-1;i++)
       			{ 	//out.println(choice[0]); out.println(aSalesOrderGenerateCode[i][0]);
		  			for (int k=0;k<=choice.length-1;k++)
          			{ //out.println("choice[k]="+choice[k]);   out.println("aSalesOrderGenerateCode[i][0]="+aSalesOrderGenerateCode[i][0]);
		    			// 判斷被Check 的Line 才執行產生訂單作業
		    			if (choice[k]==aSalesOrderGenerateCode[i][0] || choice[k].equals(aSalesOrderGenerateCode[i][0]))
						{ //out.println("choice[k]="+choice[k]);   out.println("aSalesOrderGenerateCode[i][0]="+aSalesOrderGenerateCode[i][0]);
			  				// 若當時料號不存在,則產生訂單此時再取料號Inventory_Item_ID,並更新_起
			  				if (aSalesOrderGenerateCode[i][9]=="0" || aSalesOrderGenerateCode[i][9].equals("0"))
			  				{
			       				Statement statGetItemID=con.createStatement();
                   				ResultSet rsGetItemID=null;
	               				String sqlGetItemID = "select INVENTORY_ITEM_ID,PRIMARY_UOM_CODE "+
								" from APPS.MTL_SYSTEM_ITEMS "+
								" where ORGANIZATION_ID = '49' "+
								" and DESCRIPTION = '"+aSalesOrderGenerateCode[i][1]+"' "+
                                " and NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+
								" and NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'";
				   				//out.println(sqlGetItemID);
                   				rsGetItemID=statGetItemID.executeQuery(sqlGetItemID);
	               				if (rsGetItemID.next())
	               				{
					 				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set INVENTORY_ITEM_ID=?,UOM=?"+
	                     			"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ";
                     				pstmt=con.prepareStatement(sql);
                     				pstmt.setInt(1,Integer.parseInt(rsGetItemID.getString("INVENTORY_ITEM_ID"))); // 更新的Inventory_item_id
					 				pstmt.setString(2,rsGetItemID.getString("PRIMARY_UOM_CODE")); // 更新的Primary_UOM
					 				pstmt.executeUpdate();
                     				pstmt.close();

	               				}
								else
								{
				                %>
                                <script language="javascript">
                                //alert("清單內含不存在於Oracle系統的品號 \n    請洽相關人員確認品號已建立!!");
								alertItemExistsMsg("<jsp:getProperty name='rPH' property='pgAlertItemExistsMsg'/>");
                                </script>
                                <%
							 	}
	               				//out.println(sql);
	              				rsGetItemID.close();
	              				statGetItemID.close();
			  				}
							//add by Peggy 20181205
			 				sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set ORDER_TYPE_ID=?"+
	                     		" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+choice[k]+"' "+
								" and  ORDER_TYPE_ID<>'"+choice[k]+"'";
							pstmt=con.prepareStatement(sql);
							pstmt.setString(1,firmOrderType); //order type id
							pstmt.executeUpdate();
							pstmt.close();

							choiceLine += ","+choice[k];
							if (!StringUtils.isNullOrEmpty(aSalesOrderGenerateCode[i][19])) {
								lineNoList.add(aSalesOrderGenerateCode[i][19]);
							}

							if (k==0)
							{
 								strRes += "<table border='1' bordercolordark='#66CC99'><TR bgcolor='#CCFFCC'>"+
										"<TD><font color='#000000'>RFQ No.</FONT></TD>"+
										"<TD><font color='#000000'>Process Status</FONT></TD>"+
										"<TD><font color='#000000'>Header ID</FONT></TD>"+
										"<TD><font color='#000000'>Order No</FONT></TD>"+
										"</TR>"+
					  					"<TR>"+
										"<TD><font color='blue'>"+dnDocNo+"</FONT></TD>"+
										"<TD><font color='?color'>?processStatus(?processMsg)</font></TD>"+
										"<TD><font color='blue'>?headerID</FONT></TD>"+
										"<TD><font color='blue'>?orderNo</FONT></TD>"+
										"</TR>"+
					  					"<TR bgcolor='#CCFFCC'>"+
										"<TD><font color='#000000'>Line No.</FONT></TD>"+
										"<TD><font color='#000000'>Inventory Item ID</FONT></TD>"+
										"<TD><font color='#000000'>Inventory Item</FONT></TD>"+
										"<TD><font color='#000000'>Order Q'ty</FONT></TD>"+
										"</TR>";
							}
					  		strRes += "<TR><TD><font color='#000000'>"+(k+1)+"</FONT></TD>"+
							"<TD><font color='#000000'>"+aSalesOrderGenerateCode[i][9]+"</FONT></TD>"+
							"<TD><font color='#000000'>"+aSalesOrderGenerateCode[i][1]+"</FONT></TD>"+
							"<TD align=right><font color='#000000'>"+aSalesOrderGenerateCode[i][2]+"</FONT></TD>"+
							"</TR>";
		   				}  // End of if (choice[k]==aSalesOrderGenerateCode[i][0])
		  			} // End of for (k=0;k<choice.length)
	    		} //enf of for (int i=0;i<aSalesOrderGenerateCode.length-1;i++)

				try {
					Statement stmt = con.createStatement();
					sql = "select distinct ORDER_NUM from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= '" + firmOrderType + "' \n" +
							" and c.SAREA_NO = '" + sales_region + "'";
					String orderNum = "";
					ResultSet rs = stmt.executeQuery(sql);  // 取任一筆未處理RFQ單據做訂單生成的Line_No及分派產地
					while (rs.next()) {
						orderNum = rs.getString("ORDER_NUM");
					}
					rs.close();
					stmt.close();

					if ("8".equals(orderNum.substring(0, 1))) {
						if (!lineNoList.isEmpty()) {
							// 8訂單，從workflow來的
							String soLineIdResult = "('" + String.join("','", lineNoList) + "')";
							Statement stmtSoLineIdSsd = con.createStatement();
							sql = "select LINE_NO, ORIG_SO_LINE_ID, to_date(SHIP_DATE,'yyyymmdd')SHIP_DATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL \n" +
									" where DNDOCNO='" + dnDocNo + "' and ORIG_SO_LINE_ID in " + soLineIdResult + "";
							ResultSet rsSoLineIdSsd = stmtSoLineIdSsd.executeQuery(sql);
							String detailLineNo = "";
							String origSoLineId = "";
							Date shipDate = null;
							while (rsSoLineIdSsd.next()) {
								detailLineNo = rsSoLineIdSsd.getString("LINE_NO");
								origSoLineId = rsSoLineIdSsd.getString("ORIG_SO_LINE_ID");
								shipDate = rsSoLineIdSsd.getDate("SHIP_DATE");

								CallableStatement callStmt = con.prepareCall("{call APPS.Tscc_Oe_Order_line_Update_ssd(?,?,?,?)}");
								callStmt.setInt(1, Integer.parseInt(origSoLineId));
								callStmt.setDate(2, shipDate);
								callStmt.registerOutParameter(3, Types.VARCHAR);
								callStmt.registerOutParameter(4, Types.VARCHAR);
								callStmt.execute();
								processStatus = callStmt.getString(3);
								errorMessageHeader = callStmt.getString(4);
								callStmt.close();

								Statement stmtOeOrderHeadLine = con.createStatement();
								String oeOrderSql = "select  h.header_id, h.order_number, l.line_number from OE_ORDER_HEADERS_ALL h, OE_ORDER_lines_all l\n" +
										"    where h.header_id= l.header_id\n" +
										"    and l.line_id = '" + origSoLineId + "' ";
								ResultSet rsOeOrderHeadLine = stmtOeOrderHeadLine.executeQuery(oeOrderSql);

								if (rsOeOrderHeadLine.next()) {
									headerID = rsOeOrderHeadLine.getInt("HEADER_ID");
									orderNo = rsOeOrderHeadLine.getString("ORDER_NUMBER");
									String lineNumber = rsOeOrderHeadLine.getString("LINE_NUMBER");

									String upDateDetailSql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL \n" +
											" set SASCODATE=?,ORDERNO=?,OR_LINENO=?,LSTATUSID=?,LSTATUS=? \n" +
											"where DNDOCNO='" + dnDocNo + "' and LINE_NO ='" + detailLineNo + "'";

									PreparedStatement psOeOrderHeadLineStmt = con.prepareStatement(upDateDetailSql);
									psOeOrderHeadLineStmt.setString(1, dateBean.getYearMonthDay() + dateBean.getHourMinuteSecond());
									psOeOrderHeadLineStmt.setString(2, orderNo);
									psOeOrderHeadLineStmt.setString(3, lineNumber);
									psOeOrderHeadLineStmt.setString(4, "010"); // Line 的狀態ID
									psOeOrderHeadLineStmt.setString(5, "CLOSED"); // Line 的狀態
									psOeOrderHeadLineStmt.executeUpdate();
									psOeOrderHeadLineStmt.close();

									String updateTscOmRequisition = "UPDATE TSC_OM_REQUISITION\n" +
											"   SET (SUPPLY_HEADER_ID, SUPPLY_LINE_ID, FLOW_STATUS_CODE, LAST_UPDATE_DATE) =\n" +
											"           (SELECT HEADER_ID, LINE_ID, 'AWAITING_BOOK', LAST_UPDATE_DATE\n" +
											"              FROM OE_ORDER_LINES_ALL L\n" +
											"             WHERE L.LINE_ID = ?\n" +
											"               AND EXISTS\n" +
											"                       (SELECT 1\n" +
											"                          FROM OE_ORDER_HEADERS_ALL H\n" +
											"                         WHERE H.HEADER_ID = L.HEADER_ID\n" +
											"                           AND H.ORDER_NUMBER = ?))\n" +
											"WHERE  HEADER_ID= ? AND LINE_ID = ?";

									PreparedStatement psTscOmRequisitionStmt = con.prepareStatement(updateTscOmRequisition);
									psTscOmRequisitionStmt.setString(1, origSoLineId);
									psTscOmRequisitionStmt.setString(2, orderNo);
									psTscOmRequisitionStmt.setInt(3, headerID);
									psTscOmRequisitionStmt.setString(4, origSoLineId);
									psTscOmRequisitionStmt.executeUpdate();
									psTscOmRequisitionStmt.close();
									rsOeOrderHeadLine.close();
									stmtOeOrderHeadLine.close();
								}
							}
							rsSoLineIdSsd.close();
							stmtSoLineIdSsd.close();
						} else  {
							//8訂單，但不是從workflow來的
							CallableStatement cs3 = con.prepareCall("{call tsc_rfq_odr_to_erp(" +
									"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
							cs3.setString(1, orgID);
							cs3.setInt(2, Integer.parseInt(oraUserID));
							cs3.setInt(3, Integer.parseInt(respID));
							cs3.setInt(4, Integer.parseInt(firmOrderType));
							cs3.setInt(5, Integer.parseInt(firmSoldToOrg));
							cs3.setInt(6, Integer.parseInt(firmPriceList));
							cs3.setInt(7, Integer.parseInt(ShipToOrg));
							cs3.setDate(8, orderedDate);
							cs3.setInt(9, Integer.parseInt(billTo));
							cs3.setInt(10, Integer.parseInt(payTermID));
							cs3.setString(11, shipMethod);
							cs3.setString(12, fobPoint);
							cs3.setString(13, custPO);
							cs3.setString(14, "N/A");
							cs3.setDate(15, pricedate);
							cs3.setDate(16, promisedate);
							cs3.setString(17, sourceTypeCode);
							cs3.setString(18, "");
							cs3.setString(19, "N/A");
							cs3.setString(20, dnDocNo);
							cs3.setString(21, strSubinv);  //add by Peggy 20211118
							cs3.setString(22, "N/A");
							cs3.setString(23, notifyContact);
							cs3.setString(24, notifyLocation);
							cs3.setString(25, shipContact);
							cs3.setInt(26, Integer.parseInt(deliverOrgID));
							cs3.setInt(27, Integer.parseInt(deliverContactID));
							cs3.setString(28, sampleOrder);
							cs3.setString(29, dnDocNo);
							cs3.setString(30, choiceLine + ",");
							cs3.setString(31, prCurr);
							cs3.setString(32, seqno);
							cs3.setString(33, dateBean.getYearMonthDay() + dateBean.getHourMinuteSecond());
							cs3.setString(34, sToStatusID);
							cs3.setString(35, sToStatusName);
							cs3.setString(36, remark);
							cs3.setString(37, fromStatusID);
							cs3.setString(38, actionID);
							cs3.setString(39, prodCodeGet);
							cs3.setString(40, userID);
							cs3.registerOutParameter(41, Types.VARCHAR);
							cs3.registerOutParameter(42, Types.INTEGER);
							cs3.registerOutParameter(43, Types.INTEGER);
							cs3.registerOutParameter(44, Types.VARCHAR);
							cs3.execute();
							processStatus = cs3.getString(41);
							headerID = cs3.getInt(42);   // 把第二次的更新 Header ID 取到
							orderNo = cs3.getString(43);
							errorMessageHeader = cs3.getString(44);
							cs3.close();

						}
					} else {
						// 走原來流程
						CallableStatement cs3 = con.prepareCall("{call tsc_rfq_odr_to_erp(" +
								"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
						cs3.setString(1, orgID);
						cs3.setInt(2, Integer.parseInt(oraUserID));
						cs3.setInt(3, Integer.parseInt(respID));
						cs3.setInt(4, Integer.parseInt(firmOrderType));
						cs3.setInt(5, Integer.parseInt(firmSoldToOrg));
						cs3.setInt(6, Integer.parseInt(firmPriceList));
						cs3.setInt(7, Integer.parseInt(ShipToOrg));
						cs3.setDate(8, orderedDate);
						cs3.setInt(9, Integer.parseInt(billTo));
						cs3.setInt(10, Integer.parseInt(payTermID));
						cs3.setString(11, shipMethod);
						cs3.setString(12, fobPoint);
						cs3.setString(13, custPO);
						cs3.setString(14, "N/A");
						cs3.setDate(15, pricedate);
						cs3.setDate(16, promisedate);
						cs3.setString(17, sourceTypeCode);
						cs3.setString(18, "");
						cs3.setString(19, "N/A");
						cs3.setString(20, dnDocNo);
						cs3.setString(21, strSubinv);  //add by Peggy 20211118
						cs3.setString(22, "N/A");
						cs3.setString(23, notifyContact);
						cs3.setString(24, notifyLocation);
						cs3.setString(25, shipContact);
						cs3.setInt(26, Integer.parseInt(deliverOrgID));
						cs3.setInt(27, Integer.parseInt(deliverContactID));
						cs3.setString(28, sampleOrder);
						cs3.setString(29, dnDocNo);
						cs3.setString(30, choiceLine + ",");
						cs3.setString(31, prCurr);
						cs3.setString(32, seqno);
						cs3.setString(33, dateBean.getYearMonthDay() + dateBean.getHourMinuteSecond());
						cs3.setString(34, sToStatusID);
						cs3.setString(35, sToStatusName);
						cs3.setString(36, remark);
						cs3.setString(37, fromStatusID);
						cs3.setString(38, actionID);
						cs3.setString(39, prodCodeGet);
						cs3.setString(40, userID);
						cs3.registerOutParameter(41, Types.VARCHAR);
						cs3.registerOutParameter(42, Types.INTEGER);
						cs3.registerOutParameter(43, Types.INTEGER);
						cs3.registerOutParameter(44, Types.VARCHAR);
						cs3.execute();
						processStatus = cs3.getString(41);
						headerID = cs3.getInt(42);   // 把第二次的更新 Header ID 取到
						orderNo = cs3.getString(43);
						errorMessageHeader = cs3.getString(44);
						cs3.close();
					}
//					}
//					rsSoLineIdSsd.close();
//					stmtSoLineIdSsd.close();
					// renderStart---------------------------------;
					if (processStatus == null) {
						strRes = strRes.replace("?processStatus", "");
					} else {
						strRes = strRes.replace("?processStatus", processStatus);
					}
					if (errorMessageHeader == null) {
						strRes = strRes.replace("?color", "blue");
						strRes = strRes.replace("?processMsg", "MO Generated Success!!!");
						strRes = strRes.replace("?headerID", "" + headerID);
						strRes = strRes.replace("?orderNo", orderNo);
					} else {
						strRes = strRes.replace("?color", "red");
						strRes = strRes.replace("?processMsg", "MO Generated Fail!!!");
						strRes = strRes.replace("?headerID", "&nbsp;");
						strRes = strRes.replace("?orderNo", "&nbsp;");
						strRes += "<TR bgcolor='#CCFFCC'>" +
								"<TD colspan=4><font color='#000000'>Error Message</FONT></TD>" +
								"</TR>" +
								"<TR>" +
								"<TD colspan=4><font color='RED'>" + errorMessageHeader + "</FONT></TD>" +
								"</TR>";
					}
					strRes += "</table>";
					out.println(strRes);
					out.println("<p><p>");
					if ((errorMessageHeader == null || errorMessageHeader.equals("")
							|| errorMessageHeader.equals("&nbsp;")) && (processStatus == "S"
							|| processStatus.equals("S")))     // 訂單第一筆細項產生沒有ErrorMessage ,才執行
					{

					} else {
						out.println("<BR>");
						out.println("Sales Order create fail , No action happened in this case ! ");
					}
					// renderEnd---------------------------------;
				} catch (Exception e) {
					e.printStackTrace();
					out.println("<font color='red'>更新動作失敗!請速洽系統管理員,謝謝!"+e.getMessage().toString()+"</font>");
					con.rollback();
				}

			}  // End of if (aSalesOrderGenerateCode!=null )
			else
			{
	    		//Step3. 判斷若非所有詢問單拆單項目狀態皆已產生訂單(狀態存在任一個'N/A'),則更新交期詢問主檔狀態為前一狀態_起
	       		Statement statement=con.createStatement();
           		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
           		rs.next();
           		actionName=rs.getString("ACTIONNAME");

           		rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
           		rs.next();
           		oriStatus=rs.getString("STATUSNAME");
           		statement.close();
           		rs.close();

	       		String oldStatusID = "N/A";
	       		String oldStatus = "N/A";
	       		Statement stateLStatus=con.createStatement();
           		ResultSet rsLStatus=stateLStatus.executeQuery("select LSTATUSID from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
				" where DNDOCNO='"+dnDocNo+"' and ORDERNO='N/A' ");
           		if (rsLStatus.next())
	       		{
	        		oldStatusID = fromStatusID; // 如果詢問單明細還存在部份狀態為 "N/A" 的未生成訂單,則詢問單主檔狀態便不更新為 "COMPLETE"
		     		oldStatus = oriStatus;      // 回朔至前一狀態
	       		}
				else
				{
	        		oldStatusID =sToStatusID;
					oldStatus =sToStatusName;
	        	}
		  		// 沒有任何訂單被產生,故詢問單主檔狀態RollBack至前一個狀態
	       		sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	           		"where DNDOCNO='"+dnDocNo+"' ";
           		pstmt=con.prepareStatement(sql);
	       		pstmt.setString(1,oldStatusID);  // 原狀態ID
           		pstmt.setString(2,oldStatus); // 原狀態
	       		pstmt.setString(3,userID); // 最後更新人員
	       		pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
           		pstmt.executeUpdate();
           		pstmt.close();
			} // End of else
	 		out.println("<BR>");
		} // End of if (choiceLen>0) 若使用者有選擇任一Check Choice才執行產生訂單作業
		else
		{
	    	//Step3. 判斷若非所有詢問單拆單項目狀態皆已產生訂單(狀態存在任一個'N/A'),則更新交期詢問主檔狀態為前一狀態_起
	    	Statement statement=con.createStatement();
        	ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
        	rs.next();
        	actionName=rs.getString("ACTIONNAME");

        	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
        	rs.next();
        	oriStatus=rs.getString("STATUSNAME");
        	statement.close();
        	rs.close();

	    	String oldStatusID = "N/A";
	    	String oldStatus = "N/A";
	    	Statement stateLStatus=con.createStatement();
        	ResultSet rsLStatus=stateLStatus.executeQuery("select LSTATUSID from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
				" where DNDOCNO='"+dnDocNo+"' and ORDERNO='N/A' ");
        	if (rsLStatus.next())
	    	{
	    		oldStatusID = fromStatusID; // 如果詢問單明細還存在部份狀態為 "N/A" 的未生成訂單,則詢問單主檔狀態便不更新為 "COMPLETE"
		    	oldStatus = oriStatus;      // 回朔至前一狀態
	    	}
			else
			{
	        	oldStatusID =sToStatusID;
				oldStatus =sToStatusName;
	    	}
			// 沒有任何訂單被產生,故詢問單主檔狀態RollBack至前一個狀態
	    	sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	           "where DNDOCNO='"+dnDocNo+"' ";
        	pstmt=con.prepareStatement(sql);
	    	pstmt.setString(1,oldStatusID);  // 原狀態ID
        	pstmt.setString(2,oldStatus); // 原狀態
	    	pstmt.setString(3,userID); // 最後更新人員
	    	pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
        	pstmt.executeUpdate();
        	pstmt.close();
		}  //End of Else // 未選任何Check line作訂單生成,則主檔狀態回復	 
	 
		//完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) 
		if (aSalesOrderGenerateCode!=null)
		{ 
			array2DGenerateSOrderBean.setArray2DString(null); 
		}	 
	 
		Statement stateReProcess=con.createStatement(); 
    	ResultSet rsReProcess=stateReProcess.executeQuery("select LINE_NO,ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
		" where DNDOCNO='"+dnDocNo+"' and LSTATUSID='009' ");  // 取任一筆未處理RFQ單據做訂單生成的Line_No及分派產地
		if (rsReProcess.next())
		{
			String reLineNo = rsReProcess.getString("LINE_NO");
	  		String reAssignManufact = rsReProcess.getString("ASSIGN_MANUFACT");
	 	%>
	   	<script LANGUAGE="JavaScript">
	    	reProcessFormConfirm("<jsp:getProperty name='rPH' property='pgAlertReProcessMsg'/>","../jsp/TSSalesDRQGeneratingPage.jsp","<%=dnDocNo%>","<%=reLineNo%>","<%=reAssignManufact%>","<%=firmOrderType%>","<%=lineType%>");
	   	</script>
	 	<%
		} // end of if (rsReProcess.next())
		rsReProcess.close();
		stateReProcess.close();	 
	 
	} //若為交期詢問銷售訂單生成(COMPLETE)_迄 (ACTION=012)
  
 	 ////若為企劃覆議交期但要求工廠重新安排交期(REARRANGE)_迄 (ACTION=014)
	if (actionID.equals("014")) 
  	{
    	//工廠交期已回覆由企劃生管作狀態確認後,更新至交期安排中(ESTIMATING)
	 	//Step2. 取得本張單據分配的工廠組合字串_起	    
	 	if (aFactoryArrangedCode!=null)
	 	{	 
	   		for (int i=0;i<aFactoryArrangedCode.length-1;i++)
	   		{
	    		for (int k=0;k<=choice.length-1;k++)    
        		{
		 			// 判斷被Check 的Line 才執行工廠安排交期作業
	     			if (choice[k]==aFactoryArrangedCode[i][0] || choice[k].equals(aFactoryArrangedCode[i][0]))
	     			{ 
	      				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						" set PCACPDATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,SHIP_DATE=?,PROMISE_DATE=? "+
	          			"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ";     
          				pstmt=con.prepareStatement(sql);
						// 若生管未重新給定交期日,則以工產安排日為其交期日
		  				if (aFactoryArrangedCode[i][6].equals("N/A")) aFactoryArrangedCode[i][6] = aFactoryArrangedCode[i][7];
		  				if (aFactoryArrangedCode[i][7].equals("N/A"))  // 若是工廠與生管都未給定日期,則回覆預設值予原需求日
		  				{  
							aFactoryArrangedCode[i][6] = aFactoryArrangedCode[i][4]; aFactoryArrangedCode[i][7] = aFactoryArrangedCode[i][4];  
						}
          				pstmt.setString(1,aFactoryArrangedCode[i][6]); // 設定的PC 接收日期 + 時間     
		  				pstmt.setString(2,userID); // 最後更新人員 
		  				pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		  				pstmt.setString(4,sToStatusID);
		  				pstmt.setString(5,sToStatusName);
		  				pstmt.setString(6,aFactoryArrangedCode[i][6]); // 預設將生管的確認日給Schedule Shipment Date日期 + 時間 
		  				pstmt.setString(7,aFactoryArrangedCode[i][6]); // 預設將生管的確認日給Customer Request Date日期 + 時間  
          				pstmt.executeUpdate(); 
          				pstmt.close(); 
		  
		  				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      			float processWorkTime = 0;
		      			String preWorkTime = "0"; 			 
		      			Statement stateHProcWT=con.createStatement();  
              			ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' and ORISTATUSID in ('004','003') ");
	          			if (rsHProcWT.next())
		      			{
			     			preWorkTime = rsHProcWT.getString(1);
			  			}
			  			rsHProcWT.close();
			  			stateHProcWT.close();
           				//若取到前一個狀態時間,則以目前時間減去前
		    			if (preWorkTime!="0")
		    			{
			    			String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
							+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
		        			Statement stateWTime=con.createStatement();  
                			ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            			if (rsWTime.next())
		        			{
			     				processWorkTime = rsWTime.getFloat(1);
			    			}
			    			rsWTime.close();
			    			stateWTime.close();
						}
            			// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄		  
		  
		      			//Step5. 任一Action,寫入交期詢問明細歷程檔
	          			//STARTUP ====以下為寫入該交期詢問明細之異動記錄 	 
	          			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
						" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aFactoryArrangedCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
              			Statement statement=con.createStatement();
              			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
	
	          			String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,"+
						"ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,"+
						"REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,dnDocNo); 
             	 		historystmt.setString(2,fromStatusID); 
              			historystmt.setString(3,oriStatus); //寫入status名稱
              			historystmt.setString(4,actionID); 
              			historystmt.setString(5,actionName); 
              			historystmt.setString(6,userID); 
              			historystmt.setString(7,dateBean.getYearMonthDay()); 
              			historystmt.setString(8,dateBean.getHourMinuteSecond());
              			historystmt.setString(9,prodCodeGet); //寫入工廠編號
              			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,remark);
              			historystmt.setInt(12,deliveryCount);
		      			historystmt.setInt(13,Integer.parseInt(aFactoryArrangedCode[i][0])); // 寫入處理Line_No
		      			historystmt.setFloat(14,processWorkTime);
		      			historystmt.executeUpdate();   
              			historystmt.close(); 
             			//===ENF OF 寫入action history
			 
						// 企劃回覆交期寄送Mail予開單業務人員_起  
						if (sendMailOption!=null && sendMailOption.equals("YES"))
            			{
			 				if (k==0) // 一個批次處理只送一次Mail
			 				{
	          					String sqlAddList = "select DISTINCT ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
								" where DNDOCNO='"+dnDocNo+"' and ASSIGN_MANUFACT != 'N/A' ";
	          					Statement stateAddList=con.createStatement();
              					ResultSet rsAddList=stateAddList.executeQuery(sqlAddList);
              					while (rsAddList.next())
	          					{		
	            					Statement stateList=con.createStatement();
	            					String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSPROD_PERSON b "+
									" where a.USERNAME = b.USERNAME and b.PROD_FACNO = '"+rsAddList.getString(1)+"' and b.PACTIVE = 'Y' ";
                					ResultSet rsList=stateList.executeQuery(sqlList);
	            					while (rsList.next())
	            					{
                   						sendMailBean.setMailHost(mailHost);
                   						sendMailBean.setReception(rsList.getString("USERMAIL"));		         
                   						sendMailBean.setFrom(UserName);   	 	 
                   						sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System Document Approvement Notification"));
		           						sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")
										+",\n"+CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:企劃要求工廠重新交期安排-("+dnDocNo+")")); 
                   						sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQQueryHeadAllStatus.jsp"
										+"?STATUSID=003&PAGEURL=TSSalesDRQEstimatingPage.jsp&SEARCHSTRING="+dnDocNo);			   
				   						sendMailBean.setUrlName1(CodeUtil.unicodeToBig5("   交期詢問單Excel表動態生成請點擊如下連結:\n"));   	 
                   						sendMailBean.setUrlAddr1(serverHostName+":8080/oradds/jsp/TSSalesDRQAssignInf2Excel.jsp?DNDOCNO="+dnDocNo);
                   						sendMailBean.sendMail();
	            					} //While (rsList.next())
	            					rsList.close();
	            					stateList.close();	   
	         					} //While (rsAddList.next()) 
	         					rsAddList.close();
	         					stateAddList.close();
		   					} // End of if (k==0) // 一個批次處理只送一次Mail
	      				} // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
		 			} // End of if (choice[k]==aFactoryArrangedCode[i][0] || choice[k].equals(aFactoryArrangedCode[i][0]))
				} // End of for (int k=0;k<choice.length;k++)
	   		} // End of for
	 	} // End of If  aFactoryArrangedCode!=null   
	      
	    //Step4. 再更新交期詢問主檔資料
       	sql="update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	       "where DNDOCNO='"+dnDocNo+"' ";     
       	pstmt=con.prepareStatement(sql);              
      	pstmt.setString(1,userID); // 最後更新人員
	  	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
       	pstmt.executeUpdate(); 
      	pstmt.close();      
	   	// 再更新交期詢問主檔資料
	   
		//###***  完成各處理後即將session取到的Bean 的內容值清空(避免二次傳送)  *****###  
		if (aFactoryArrangedCode!=null)  
    	{ 
			array2DArrangedFactoryBean.setArray2DString(null);  
		}
  	} //若為企劃覆議交期但要求工廠重新安排交期(REARRANGE)_迄 (ACTION=014)

  	// 業務詢問客戶取消原交期,並給定新的交期需求(ABORT)_起 (ACTION=013)
  	if (actionID.equals("013")) 
  	{
		try
		{
			//add by Peggy 20111103
			if (fromStatusID.equals("001"))
			{
				sql=" update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,STATUSID=?,STATUS=? where DNDOCNO='"+dnDocNo+"' ";     
				pstmt=con.prepareStatement(sql);      
				pstmt.setString(1,userID); // 最後更新人員
				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
				pstmt.setString(3,sToStatusID);
				pstmt.setString(4,sToStatusName);
				//pstmt.executeUpdate(); 
				//pstmt.close();      
				pstmt.executeQuery(); 
			
				sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? where DNDOCNO='"+dnDocNo+"'";     
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1,userID); 
				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
				pstmt.setString(3,sToStatusID);
				pstmt.setString(4,sToStatusName);
				//pstmt.executeUpdate(); 
				//pstmt.close();  
				pstmt.executeQuery(); 
			}
			else if (aCustCancelPromiseCode!=null) // 判斷該次處理細項才更新明細檔
			{ 
				dateString=dateBean.getYearMonthDay();
				//seqkey="TS"+userActCenterNo+dateString;
				//抓原單據前五碼(因為一個帳號會有一個以上site)modify by Peggy 20120910
				seqkey=dnDocNo.substring(0,5)+dateString;
				//====先取得流水號=====  
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");  
				if (rs.next()==false)
				{   
					String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";   
					PreparedStatement seqstmt=con.prepareStatement(seqSql);     
					seqstmt.setString(1,seqkey);
					seqstmt.setInt(2,1);   
					seqstmt.executeUpdate();
					seqno=seqkey+"-001";
					seqstmt.close();   
				} 
				else 
				{
					int lastno=rs.getInt("LASTNO");
					sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' "+
					" and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
					ResultSet rs2=statement.executeQuery(sql); 
					//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
					if (rs2.next())
					{         
						lastno++;
						String numberString = Integer.toString(lastno);
						String lastSeqNumber="000"+numberString;
						lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
						seqno=seqkey+"-"+lastSeqNumber;     
						String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
						PreparedStatement seqstmt=con.prepareStatement(seqSql);        
						seqstmt.setInt(1,lastno);   
						seqstmt.executeUpdate();   
						seqstmt.close(); 
					} 
					else
					{
						//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
						String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE "+
						" where substr(DNDOCNO,1,13)='"+seqkey+"' ";
						ResultSet rs3=statement.executeQuery(sSql);
						if (rs3.next()==true)
						{
							int lastno_r=rs3.getInt("LASTNO");
							lastno_r++;
							String numberString_r = Integer.toString(lastno_r);
							String lastSeqNumber_r="000"+numberString_r;
							lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
							seqno=seqkey+"-"+lastSeqNumber_r;  
							String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
							PreparedStatement seqstmt=con.prepareStatement(seqSql);        
							seqstmt.setInt(1,lastno_r);   
							seqstmt.executeUpdate();   
							seqstmt.close();  
						}  // End of if (rs3.next()==true)
					} // End of Else  //===========(處理跳號問題)
			 
					int newLine =1; 		
					// Step2. 依Detail 更新原單據狀態,並根據Array新增新交期詢問單細項內容
					for (int i=0;i<aCustCancelPromiseCode.length-1;i++)
					{  
						for (int k=0;k<=choice.length-1;k++)    
						{
							// 判斷被Check 的Line 才執行客戶重新確認產生新訂單交期作業
							if (choice[k]==aCustCancelPromiseCode[i][0] || choice[k].equals(aCustCancelPromiseCode[i][0]))
							{ 
								sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL  set REREQUEST_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,EDIT_CODE=? where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ";     
								pstmt=con.prepareStatement(sql);
								// 若業務未重新給定新的交期需求日,則以原需求日作為新交期需求日
								if (aCustCancelPromiseCode[i][6].equals("N/A")) aCustCancelPromiseCode[i][6] = aCustCancelPromiseCode[i][4];
								pstmt.setString(1,aCustCancelPromiseCode[i][6]); // 設定的客戶新交期需求日期    
								pstmt.setString(2,userID); // 最後更新人員 
								pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
								pstmt.setString(4,sToStatusID);
								pstmt.setString(5,sToStatusName);
								pstmt.setString(6,"N/A"); // 回覆EDIT_CODE的原狀態  
								//pstmt.executeUpdate(); 
								//pstmt.close();    
								pstmt.executeQuery();// 先將原單據狀態更新為(012=ABANDONNING)
									   
			   
								// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
								float processWorkTime = 0;
								String preWorkTime = "0"; 			 
								Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '003' (客戶放棄交期詢單送出前一狀態為RESPONDING(007))
								ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' and ORISTATUSID ='007' ");
								if (rsHProcWT.next())
								{
									preWorkTime = rsHProcWT.getString(1);
								}
								rsHProcWT.close();
								stateHProcWT.close();
								
								//若取到前一個狀態時間,則以目前時間減去前
								if (preWorkTime!="0")
								{
									String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond() +"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
									Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
									ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
									if (rsWTime.next())
									{
										processWorkTime = rsWTime.getFloat(1);
									}	
									rsWTime.close();
									stateWTime.close();
								}
								// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄
			   
								//Step5. 任一Action,寫入交期詢問明細歷程檔
								//STARTUP ====以下為寫入該交期詢問明細之異動記錄 	 
								int deliveryCount = 0;
								Statement stateDeliveryCNT=con.createStatement(); 
								ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY  where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ");
								if (rsDeliveryCNT.next())
								{
									deliveryCount = rsDeliveryCNT.getInt(1);
								}
								rsDeliveryCNT.close();
								stateDeliveryCNT.close();
								Statement state013=con.createStatement();
								ResultSet rs013=state013.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
								rs013.next();
								actionName=rs013.getString("ACTIONNAME");
								rs013=state013.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
								rs013.next();
								oriStatus=rs013.getString("STATUSNAME");
								state013.close();
								rs013.close();	
		
								String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,"+
								"REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
								PreparedStatement historystmt=con.prepareStatement(historySql);   
								historystmt.setString(1,dnDocNo); 
								historystmt.setString(2,fromStatusID); 
								historystmt.setString(3,oriStatus); //寫入status名稱
								historystmt.setString(4,actionID); 
								historystmt.setString(5,actionName); 
								historystmt.setString(6,userID); 
								historystmt.setString(7,dateBean.getYearMonthDay()); 
								historystmt.setString(8,dateBean.getHourMinuteSecond());
								historystmt.setString(9,prodCodeGet); //寫入工廠編號
								historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
								historystmt.setString(11,remark);
								historystmt.setInt(12,deliveryCount);
								historystmt.setInt(13,Integer.parseInt(aCustCancelPromiseCode[i][0])); // 寫入處理Line_No
								historystmt.setFloat(14,processWorkTime);		
								//historystmt.executeUpdate();   
								//historystmt.close(); 
								historystmt.executeQuery();
			
								if (newDRQOption!=null && newDRQOption.equals("YES")) // 若使用者選擇要以原單據內容產生新的交期詢問單
								{ 		   
									if (k==0)
									{
										//Step1 若有給定新的交期,則,依頭檔先產生交期單據
										sql=" insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,"+
										    " TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,REMARK,STATUSID,STATUS,CREATED_BY,"+
										    " TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,SALESPERSON,"+
										    " BILL_TO_ORG,LAST_UPDATE_DATE,LAST_UPDATED_BY,ORIDOCNO,AUTOCREATE_FLAG,PAYTERM_ID,FOB_POINT,RFQ_TYPE,SAMPLE_ORDER,SAMPLE_CHARGE,TAX_CODE,"+ //add TAX_CODE by Peggy 20130411
											" SHIP_TO_CONTACT_ID)"+ //add by Peggy 20190104
										    " select '"+seqno+"',TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,"+
											" (select CUST_PO_NUMBER from ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where b.DNDOCNO=a.DNDOCNO and TO_CHAR(b.LINE_NO)='"+aCustCancelPromiseCode[i][0]+"'),"+
											"CURR,'"+
										    aCustCancelPromiseCode[i][6]+"','"+remark+"','001','CREATING','"+userID+
										    "',TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,SALESPERSON,BILL_TO_ORG,'"+
										    dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+userID+
										    "',DNDOCNO,AUTOCREATE_FLAG,PAYTERM_ID,FOB_POINT,RFQ_TYPE,SAMPLE_ORDER,SAMPLE_CHARGE,TAX_CODE,SHIP_TO_CONTACT_ID from ORADDMAN.TSDELIVERY_NOTICE a where DNDOCNO='"+dnDocNo+"' "; 											
										pstmt=con.prepareStatement(sql);          
										pstmt.executeQuery();
									}
									// 再產生新的單據細項
									sql="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,"+
									"LINE_NO,"+
									"INVENTORY_ITEM_ID,"+
									"ITEM_SEGMENT1,"+
									"QUANTITY,"+
									"UOM,"+
									"LIST_PRICE,"+
									"REQUEST_DATE,"+
									"PRIMARY_UOM,"+
									"REMARK,"+
									"CREATED_BY,"+
									"LSTATUSID,"+
									"LSTATUS,"+
									"ITEM_DESCRIPTION,"+
									"LAST_UPDATE_DATE,"+
									"LAST_UPDATED_BY,"+
									"CUST_REQUEST_DATE,"+//add by Peggy 20120117
									"SHIPPING_METHOD,"+  //add by Peggy 20120117
									"AUTOCREATE_FLAG,"+  //add by Peggy 20120307
									"ORDERED_ITEM,"+     //add by Peggy 20120307
									"ORDERED_ITEM_ID,"+  //add by Peggy 20120307
									"ITEM_ID_TYPE,"+     //add by Peggy 20120307
									"CUST_PO_NUMBER,"+   //add by Peggy 20120307
									"SELLING_PRICE,"+    //add by Peggy 20120307
									"PROGRAM_NAME, "+    //add by Peggy 20120307
									"FOB,"+              //add by Peggy 20120329
									"CUST_PO_LINE_NO,"+  //add by Peggy 20120601
									"QUOTE_NUMBER,"+     //add by Peggy 20120917
									"END_CUSTOMER,"+     //add by Peggy 20121107
									"END_CUSTOMER_ID,"+   //add by Peggy 20140813
									"ORIG_SO_LINE_ID,"+  //add by Peggy 20150519
									"END_CUSTOMER_SHIP_TO_ORG_ID,"+  //add by Peggy 20160219
									"DIRECT_SHIP_TO_CUST,"+          //add by Peggy 20170420
									"BI_REGION,"+   //add by Peggy 20170927
									"END_CUSTOMER_PARTNO,"+ //add by Peggy 20190225
									"SUPPLIER_NUMBER)"+  //add by Peggy 20220503 
									" select '"+seqno+"','"+newLine+"',a.INVENTORY_ITEM_ID,a.ITEM_SEGMENT1,a.QUANTITY,a.UOM,a.LIST_PRICE,'"+
									aCustCancelPromiseCode[i][6]+"',a.PRIMARY_UOM,a.REMARK,'"+userID+"','001','CREATING',a.ITEM_DESCRIPTION,'"+
									dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+userID+"' "+
									",a.CUST_REQUEST_DATE,a.SHIPPING_METHOD"+//add by Peggy 20120117
									",b.AUTOCREATE_FLAG,a.ORDERED_ITEM,a.ORDERED_ITEM_ID, a.ITEM_ID_TYPE,a.CUST_PO_NUMBER,a.SELLING_PRICE,'D1-006I',NVL(a.FOB,b.FOB_POINT),"+ //add by Peggy 20120307
									" a.CUST_PO_LINE_NO,a.QUOTE_NUMBER,a.END_CUSTOMER "+ //add by Peggy 20121107
									",a.END_CUSTOMER_ID"+ //add by Peggy 20140813
									",a.orig_so_line_id"+ //add by Peggy 20150519
									",a.END_CUSTOMER_SHIP_TO_ORG_ID"+ //add by Peggy 20160219
									",a.DIRECT_SHIP_TO_CUST"+         //add by Peggy 20170420
									",a.BI_REGION"+                   //add by Peggy 20170927
									",a.END_CUSTOMER_PARTNO"+         //add by Peggy 20190225
									",a.SUPPLIER_NUMBER"+             //add by Peggy 20220503
									" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,ORADDMAN.TSDELIVERY_NOTICE b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+dnDocNo+"' "+
									" and TO_CHAR(a.LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ";
									pstmt=con.prepareStatement(sql);          
									pstmt.executeQuery();
									
									//add by Peggy 20130815
									sql = " insert into oraddman.tsdelivery_notice_remarks"+
									      "(dndocno,"+
										  " line_no,"+
										  " customer,"+
										  " shipping_marks,"+
										  " remarks,"+
                                          " creation_date,"+
										  " created_by,"+
										  " last_update_date,"+
       									  " last_updated_by)"+
										  " SELECT '"+seqno+"','"+newLine+"', a.customer, a.shipping_marks, a.remarks, sysdate,'"+UserName+"', sysdate,'"+UserName+"' "+
                                          " FROM oraddman.tsdelivery_notice_remarks a where a.DNDOCNO='"+dnDocNo+"' "+
									      " and TO_CHAR(a.LINE_NO)='"+aCustCancelPromiseCode[i][0]+"' ";
									pstmt=con.prepareStatement(sql);          
									pstmt.executeQuery();
								} 
								newLine++; 
							}
						}  
					} 
				}
		
				//write into db
				con.commit();
						
				//###***  完成各處理後即將session取到的Bean 的內容值清空(避免二次傳送)  *****###  
				if (aCustCancelPromiseCode!=null)  
				{ 
					array2DPromiseFactoryBean.setArray2DString(null);  
				}
				//執行sendMail動作
				if (sendMailOption!=null && sendMailOption.equals("YES"))
				{
					sendMailBean.setMailHost(mailHost);
					sendMailBean.setReception(changeProdPersonMail);
					sendMailBean.setFrom(UserName);
					sendMailBean.setSubject(CodeUtil.unicodeToBig5("Assignment from the Sales Delivery Request System"));	 
					sendMailBean.setBody(CodeUtil.unicodeToBig5("Case No.:")+dnDocNo);	
					if (typeNo.equals("001")) //區別一般維修及DOA/DAP件
					{
						sendMailBean.setUrlAddr(serverHostName+"/oradds/jsp/TSSalesEstimatingPage.jsp?DNDOCNO="+dnDocNo);
					}    
					sendMailBean.sendMail();
				} 	
			}			
		}
		catch (Exception e)
		{	
			errCnt++;
			out.println("<font color='red'>動作失敗!請速洽系統管理員,謝謝!"+e.getMessage().toString()+"</font>");
			con.rollback();
		}//end of catch
  	}
  
  	//若為重新指派(REASSIGN)則再執行以下動作
  	if (actionID.equals("006")) 
  	{
   		sql="update ORADDMAN.TSDELIVERY_NOTICE set TSMANUFACTORYNO=? where DNDOCNO='"+dnDocNo+"'";
   		pstmt=con.prepareStatement(sql);  
   		pstmt.setString(1,changeProdPersonID);      
   		pstmt.executeUpdate(); 
   		pstmt.close();  
  	}
 
  	// 業務詢問單取消(ACTION=021)
  	if (actionID.equals("021")) 
  	{
    	if (aRfqTemporaryCode!=null)
		{
	  		String defaultLineType = "0";
	  		String priceList = "0";
	  		if (aRfqTemporaryCode.length>0)
	  		{    
		  		Statement stateLT=con.createStatement();  
          		ResultSet rsLT=stateLT.executeQuery("select a.PRICE_LIST, b.LINE_TYPE,NVL(a.AUTOCREATE_FLAG,'') AUTOCREATE_FLAG "+
				" from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				" where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+dnDocNo+"' ");  
          		if (rsLT.next()) 
		  		{ 
					defaultLineType=rsLT.getString("LINE_TYPE"); 
					priceList = rsLT.getString("PRICE_LIST"); 
					autoCreate_Flag = rsLT.getString("AUTOCREATE_FLAG");
				}
		  		rsLT.close();
		  		stateLT.close();
		  
		  		sql="delete ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
	          	"where DNDOCNO='"+dnDocNo+"' ";    // 若清單內容>0,先全刪,再依Array內容清單新增 
          		pstmt=con.prepareStatement(sql); 
          		pstmt.executeUpdate(); 
          		pstmt.close();
	  		} // End of if (aRfqTemporaryCode.length>0)
	  
	  		String sqlDtl="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,LINE_NO,INVENTORY_ITEM_ID,"+
	  				"ITEM_SEGMENT1,QUANTITY,UOM,LIST_PRICE,REQUEST_DATE,SHIP_DATE,"+
                    "PROMISE_DATE,LINE_TYPE,PRIMARY_UOM,REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LSTATUSID,LSTATUS,"+
					"ITEM_DESCRIPTION,MOQP,ASSIGN_MANUFACT,CUST_PO_NUMBER, SPQ, MOQ, PROGRAM_NAME,TSC_PROD_GROUP"+
					",CUST_REQUEST_DATE,SHIPPING_METHOD,ORDER_TYPE_ID,AUTOCREATE_FLAG,SELLING_PRICE,ORDERED_ITEM,ORDERED_ITEM_ID,ITEM_ID_TYPE,FOB"+  //add by Peggychen 20120329					
					",CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER"+//add by Peggy 20121107				
					",END_CUSTOMER_ID)"+ //add by Peggy 20140813
                    " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	  		for (int r=0;r<aRfqTemporaryCode.length-1;r++)
	  		{	    
        		pstmt=con.prepareStatement(sqlDtl);
				pstmt.setString(1,dnDocNo); //  詢問單號 
				String invItemID = "0";	
	    		String uom = "N/A";
	    		String itemFactory = "N/A";
	    		String priceCategory = "",tscProdGroup=""; //20110620 liling add tscprodgroup
				double listPrice = 0;
	    		Statement statement=con.createStatement();
	    		sql = "select a.INVENTORY_ITEM_ID, a.PRIMARY_UOM_CODE, NVL(a.ATTRIBUTE3,'N/A') ATTRIBUTE3, b.SEGMENT1  "+
               		" ,APPS.TSC_OM_CATEGORY(b.INVENTORY_ITEM_ID, 49,'TSC_PROD_GROUP') TSCPRODGROUP "+ //20110620 LILING
					",c.OPERAND"+
	          		" from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b "+
					" ,(select OPERAND,PRODUCT_ATTR_VAL_DISP from ORADDMAN.TSITEM_LIST_PRICE  where LIST_HEADER_ID = '"+priceList+"' AND SYSDATE BETWEEN TO_DATE(SUBSTR(START_DATE_ACTIVE,1,8),'YYYYMMDD') AND TO_DATE(SUBSTR(NVL(END_DATE_ACTIVE,'20990101'),1,8),'YYYYMMDD')) c"+
		      		" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
		      		" and a.ORGANIZATION_ID = '49' and b.CATEGORY_SET_ID = 6 and a.SEGMENT1 = '"+aRfqTemporaryCode[r][1]+"' "+
					" and b.SEGMENT1=c.PRODUCT_ATTR_VAL_DISP(+)";	
        		ResultSet rs=statement.executeQuery(sql);
	    		if (rs.next())
	    		{
		  			invItemID = rs.getString("INVENTORY_ITEM_ID");
		  			itemFactory = rs.getString("ATTRIBUTE3");
		  			uom =  rs.getString("PRIMARY_UOM_CODE");
		  			priceCategory = rs.getString("SEGMENT1");		
		  			tscProdGroup = rs.getString("TSCPRODGROUP");	
					listPrice = rs.getDouble("OPERAND"); 
	    		}	
	    		rs.close();
	    		statement.close();
	    		/*		
	    		Statement stateListPrice=con.createStatement();
	    		String sqlLPrice = "select OPERAND from ORADDMAN.TSITEM_LIST_PRICE "+
				" where LIST_HEADER_ID =  '"+priceList+"' and PRODUCT_ATTR_VAL_DISP = '"+priceCategory+"' ";
	    		ResultSet rsLPrice=stateListPrice.executeQuery(sqlLPrice); 
	    		if (rsLPrice.next())
	    		{
	     			listPrice = rsLPrice.getDouble("OPERAND");  
	    		}
	    		rsLPrice.close();
	    		stateListPrice.close(); 
				*/

				//add by Peggychen 20120307
				if (autoCreate_Flag.equals("Y") || (!aRfqTemporaryCode[r][15].trim().equals("N/A") && !aRfqTemporaryCode[r][15].trim().equals("") && aRfqTemporaryCode[r][15].trim() != null))
				{
					if (!orderType.equals(aRfqTemporaryCode[r][15].trim()))
					{
						Statement stateodrtype=con.createStatement();
						ResultSet rsodrtype=stateodrtype.executeQuery("SELECT  a.otype_id  FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
						" where b.order_num=a.order_num and a.order_num='"+aRfqTemporaryCode[r][15].trim()+"' and a.SAREA_NO ='"+salesAreaNo+"' and a.active='Y'"+
						" and b.MANUFACTORY_NO='"+aRfqTemporaryCode[r][10]+"' and b.ACTIVE='Y'");  
						if (rsodrtype.next())
						{
							orderTypeId=rsodrtype.getString("otype_id");  
						}
						else
						{
							throw new Exception("line:"+(r+1)+" The order type is not exist!!");
						}
						rsodrtype.close();
						stateodrtype.close();
						orderType= aRfqTemporaryCode[r][15].trim();
					}
				}
				pstmt.setInt(2,r+1); // Line_No // 給料項序號	  
        		pstmt.setString(3,invItemID); // Inventory_Item_ID	  
	    		pstmt.setString(4,aRfqTemporaryCode[r][1]); // Inventory_Item_Segment1
	    		pstmt.setFloat(5,Float.parseFloat(aRfqTemporaryCode[r][3])); // Order Qty
	    		pstmt.setString(6,uom); // Primary Unit of Measure
	    		pstmt.setDouble(7,listPrice); // List Price
	    		pstmt.setString(8,aRfqTemporaryCode[r][7]+dateBean.getHourMinuteSecond()); // Request Date
	    		pstmt.setString(9,aRfqTemporaryCode[r][7]+dateBean.getHourMinuteSecond()); 
	    		pstmt.setString(10,aRfqTemporaryCode[r][7]+dateBean.getHourMinuteSecond()); 
	    		pstmt.setInt(11,Integer.parseInt(defaultLineType)); // Default Order Line Type
	    		pstmt.setString(12,aRfqTemporaryCode[r][4]); // Primary Unit of Measure
	    		pstmt.setString(13,aRfqTemporaryCode[r][8]); // Remark
	    		pstmt.setString(14,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入日期
        		pstmt.setString(15,userID); //寫入User ID
        		pstmt.setString(16,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //最後更新日期
        		pstmt.setString(17,userID); //最後更新User
        		pstmt.setString(18,sToStatusID);
        		pstmt.setString(19,sToStatusName);
	    		pstmt.setString(20,aRfqTemporaryCode[r][2]); //台半品號說明
	    		pstmt.setString(21,"0"); //最小包裝訂購量	  
				if (aRfqTemporaryCode[r][10]==null || aRfqTemporaryCode[r][10].equals("null")) aRfqTemporaryCode[r][10]= itemFactory;	
        		pstmt.setString(22,aRfqTemporaryCode[r][10]); // 生產地 2009/04/02 liling
				pstmt.setString(23,aRfqTemporaryCode[r][9]); // Cust PO Number 2006/06/06 Add Kerwin  
        		float fSPQ = 0;
        		if (aRfqTemporaryCode[r].length > 9) 
				{
          			if (aRfqTemporaryCode[r][11]==null || aRfqTemporaryCode[r][11].equals("") || aRfqTemporaryCode[r][11].equals("null")) aRfqTemporaryCode[r][11]="0";
	      			fSPQ = Float.valueOf(aRfqTemporaryCode[r][11]).floatValue();
	    		}
	    		pstmt.setFloat(24,fSPQ); // SPQ
        		float fMOQ = 0;
        		if (aRfqTemporaryCode[r].length > 10) 
				{
          			if (aRfqTemporaryCode[r][12]==null || aRfqTemporaryCode[r][12].equals("") || aRfqTemporaryCode[r][12].equals("null")) aRfqTemporaryCode[r][12]="0";
	      			fMOQ = Float.valueOf(aRfqTemporaryCode[r][12]).floatValue();
	    		}
	    		pstmt.setFloat(25,fMOQ); // MOQ
        		pstmt.setString(26,sProgramName+"P"); // PROGRAM_NAME
        		pstmt.setString(27,tscProdGroup); // 20110620 liling add
				pstmt.setString(28,(aRfqTemporaryCode[r][5].equals("&nbsp;"))?null:aRfqTemporaryCode[r][5]); //add by Peggy 20110622
				pstmt.setString(29,(aRfqTemporaryCode[r][6].equals("&nbsp;"))?null:aRfqTemporaryCode[r][6]);  //add by Peggy 20110622
				pstmt.setString(30,orderTypeId);  //add by Peggy 20120307
				pstmt.setString(31,autoCreate_Flag);  //add by Peggy 20120307
				pstmt.setString(32,(aRfqTemporaryCode[r][14].equals("&nbsp;"))?null:aRfqTemporaryCode[r][14]);  //selling price,add by Peggy 20120307
				pstmt.setString(33,(aRfqTemporaryCode[r][13].equals("&nbsp;"))?"N/A":aRfqTemporaryCode[r][13]);  //cust item name,add by Peggy 20120307
				pstmt.setString(34,custItemID);    //cust item id,add by Peggy 20120307
				pstmt.setString(35,custItemType);  //cust item type,add by Peggy 20120307
				pstmt.setString(36,aRfqTemporaryCode[r][17]);  //FOB,add by Peggy 20120329
				pstmt.setString(37,aRfqTemporaryCode[r][18]);  //CUST PO LINE NUMBER,add by Peggy 20120917
				pstmt.setString(38,(aRfqTemporaryCode[r][19].equals("&nbsp;"))?null:aRfqTemporaryCode[r][19]);  //QUOTE NUMBER,add by Peggy 20120917
				//add by Peggy 20140811
				if (!aRfqTemporaryCode[r][20].startsWith("&nbsp"))
				{
					Statement state1=con.createStatement();
					ResultSet rs1=state1.executeQuery("SELECT A.CUSTOMER_NAME_PHONETIC,A.CUSTOMER_ID  FROM  AR_CUSTOMERS A WHERE A.CUSTOMER_NUMBER = '"+aRfqTemporaryCode[r][20].trim()+"'");  
					if (rs1.next())
					{
						END_CUST_SHORT_NAME=rs1.getString(1);
						END_CUST_ID =""+rs1.getInt(2);
					}
					else
					{
						END_CUST_SHORT_NAME="";
						END_CUST_ID =null;
					}
					rs1.close();
					state1.close();
				}	
				else
				{
					END_CUST_SHORT_NAME="";
					END_CUST_ID =null;
				}					
				pstmt.setString(39,END_CUST_SHORT_NAME);  //END CUSTOMER,modify by Peggy 20140813
				pstmt.setString(40,END_CUST_ID);          //END CUSTOMER ID,add by Peggy 20140813
	    		pstmt.executeUpdate();
        		pstmt.close(); 	

				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      	float processWorkTime = 0;
		      	String preWorkTime = "0"; 
		      	Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
              	ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
				" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aRfqTemporaryCode[r][0]+"' and ORISTATUSID ='001' ");
	          	if (rsHProcWT.next())
		      	{
			    	preWorkTime = rsHProcWT.getString(1);
			  	}
			  	rsHProcWT.close();
			  	stateHProcWT.close();
           		//若取到前一個狀態時間,則以目前時間減去前
		    	if (preWorkTime!="0")
		    	{
			    	String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
		        	Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                	ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            	if (rsWTime.next())
		        	{
			     		processWorkTime = rsWTime.getFloat(1);
			    	}
			    	rsWTime.close();
			    	stateWTime.close();
				}
				// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄		
		
		      	//Step5. 任一Action,寫入交期詢問明細歷程檔	          	 
	          	int deliveryCount = 0;
	          	Statement stateDeliveryCNT=con.createStatement(); 
              	ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
				" where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aRfqTemporaryCode[r][0]+"' ");
	          	if (rsDeliveryCNT.next())
	          	{
	            	deliveryCount = rsDeliveryCNT.getInt(1);
	          	}

	          	rsDeliveryCNT.close();
	          	stateDeliveryCNT.close();

              	statement=con.createStatement();
              	rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              	rs.next();
              	actionName=rs.getString("ACTIONNAME");
   
              	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              	rs.next();
              	oriStatus=rs.getString("STATUSNAME");   
              	statement.close();
              	rs.close();	
	
	          	String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
		      	"ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,"+
				"CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	          	PreparedStatement historystmt=con.prepareStatement(historySql);   
              	historystmt.setString(1,dnDocNo); 
              	historystmt.setString(2,fromStatusID); 
              	historystmt.setString(3,oriStatus); //寫入status名稱
              	historystmt.setString(4,actionID); 
              	historystmt.setString(5,actionName); 
              	historystmt.setString(6,userID); 
              	historystmt.setString(7,dateBean.getYearMonthDay()); 
              	historystmt.setString(8,dateBean.getHourMinuteSecond());
              	historystmt.setString(9,prodCodeGet); //寫入工廠編號
              	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              	historystmt.setString(11,remark);
              	historystmt.setInt(12,deliveryCount);
		      	historystmt.setInt(13,Integer.parseInt(aRfqTemporaryCode[r][0])); // 寫入處理Line_No
		      	historystmt.setFloat(14,processWorkTime);		
		      	historystmt.executeUpdate();   
              	historystmt.close(); 
	  		} 
  		}
     	sql="update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	     "where DNDOCNO='"+dnDocNo+"' ";     
     	pstmt=con.prepareStatement(sql);      
     	pstmt.setString(1,userID); // 最後更新人員
	 	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
     	pstmt.executeUpdate(); 
     	pstmt.close();      
		if (aRfqTemporaryCode!=null)
		{ 
			rfqArray2DTemporaryBean.setArray2DString(null); 
		}
  	}
 
    //Step5. 任一Action,寫入交期詢問歷程檔
	//STARTUP ====以下為寫入該交期詢問之異動記錄  
	if (errCnt==0) //modify by Peggy 20120307
	{
		int deliveryCount = 0;
		Statement stateDeliveryCNT=con.createStatement(); 
		ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_HISTORY where DNDOCNO='"+dnDocNo+"' ");
		if (rsDeliveryCNT.next())
		{
			deliveryCount = rsDeliveryCNT.getInt(1);
		}
		rsDeliveryCNT.close();
		stateDeliveryCNT.close();
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
		rs.next();
		actionName=rs.getString("ACTIONNAME");
	   
		rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
		rs.next();
		oriStatus=rs.getString("STATUSNAME");
		statement.close();
		rs.close();	
		
		String historySql="insert into ORADDMAN.TSDELIVERY_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,"+
		"ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW) "+
		"values(?,?,?,?,?,?,?,?,?,?,?,?) ";
		PreparedStatement historystmt=con.prepareStatement(historySql);   
		historystmt.setString(1,dnDocNo); 
		historystmt.setString(2,fromStatusID); 
		historystmt.setString(3,oriStatus); //寫入status名稱
		historystmt.setString(4,actionID); 
		historystmt.setString(5,actionName); 
		historystmt.setString(6,userID); 
		historystmt.setString(7,dateBean.getYearMonthDay()); 
		historystmt.setString(8,dateBean.getHourMinuteSecond());
		historystmt.setString(9,prodCodeGet); //寫入工廠編號
		historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
		//add by Peggy 20111103,記錄草稿詢問單取消原因
		if (fromStatusID.equals("001") && actionID.equals("013"))
		{
			historystmt.setString(11,CancelReason); // 取消詢問單原因說明
		}
		else
		{
			historystmt.setString(11,remark); // 本次處理說明欄位
		}
		historystmt.setInt(12,deliveryCount);		
		historystmt.executeUpdate();   
		historystmt.close(); 
	 
		if (actionID.equals("007")) 
		{ 
			if (sendMailOption!=null && sendMailOption.equals("YES"))
			{  
				String sqlAddList = "select DISTINCT UPDATEUSERID from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
				" where DNDOCNO='"+dnDocNo+"' and ORISTATUSID='002' ";
				Statement stateAddList=con.createStatement();
				ResultSet rsAddList=stateAddList.executeQuery(sqlAddList);
				while (rsAddList.next())
				{		  
					Statement stateList=con.createStatement();
					String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSSPLANER_PERSON b "+
					" where a.USERNAME = b.USERID and b.USERNAME = '"+rsAddList.getString(1)+"' ";
					ResultSet rsList=stateList.executeQuery(sqlList);
					while (rsList.next())
					{
						sendMailBean.setMailHost(mailHost);
						sendMailBean.setReception(rsList.getString("USERMAIL"));		  
						sendMailBean.setFrom(UserName);   	 	 
						sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System Document Approvement Notification"));	            
						sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+
						CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:工廠要求重新指派產地-("+dnDocNo+")"));   	 
						sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo);
						sendMailBean.sendMail();
					}
					rsList.close();
					stateList.close();
				}
				rsAddList.close();
				stateAddList.close();
			}
		}

		out.println("<BR>Processing Sales Delivery Request value(RFQ NO.:<A HREF='TSSalesDRQDisplayPage.jsp?DNDOCNO="+dnDocNo+"'><font color=#FF0000>"+dnDocNo+"</font></A>) OK!");
	  
		if (actionID.equals("013")) //若為倉管發料確認(ISSUE)則再執行以下動作
		{
			if (newDRQOption!=null && newDRQOption.equals("YES")) // 若使用者選擇要以原單據內容產生新的交期詢問單
			{ 	
				out.println("<BR>&nbsp;<A HREF='TSSalesDRQTemporaryPage.jsp?DNDOCNO="+seqno+"&LSTATUSID=001'>");%><<jsp:getProperty name="rPH" property="pgRefresh"/>><jsp:getProperty name="rPH" property="pgSalesDRQ"/><%out.println("("+seqno+")</A><BR>"); 
			}
		}
		out.println("<BR>");
		out.println("<A HREF='../OraddsMainMenu.jsp'>");%><font size="2"><jsp:getProperty name="rPH" property="pgHOME"/></font><%out.println("</A>");
	}
		
	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();	

	if (sProgramName.equals("D4-002I") && actionID.equals("002"))  //add by Peggy 20170920
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
		if (confirm("是否要繼續上傳匯入RFQ?"))
		{
			document.location.href="../jsp/TscJapanExlRfqUpload.jsp";
		}
		</script>	
	<%
	}							 
	
} //end of try
catch (Exception e)
{
	e.printStackTrace();
   	out.println("<font color='#ff0000'>Update Fail!!~" + e.getMessage()+"</font>");
}
%>

<table width="60%" border="1" cellpadding="0" cellspacing="0" >
	<tr>
    	<td width="278"><font size="2"><jsp:getProperty name="rPH" property="pgDRQDocProcess"/></font></td>
    	<td width="297"><font size="2"><jsp:getProperty name="rPH" property="pgDRQInquiryReport"/></font></td>    
  	</tr>
		<%
		String MODEL = "'D1','D2'",FMODULE="";   
		int icnt =0; 
  		try  
  		{ 
			Statement statement=con.createStatement();
    		ResultSet rs=statement.executeQuery("SELECT DISTINCT FMODULE,FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER "+
			" WHERE FMODULE IN ("+MODEL+") AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 "+
			" AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"')"+
			" ORDER BY FMODULE,FSEQ ");    	
    		while(rs.next())
    		{
      			String ADDRESS = rs.getString("FADDRESS");
				String PROGRAMMERNAME= rs.getString("FDESC");
				if (!FMODULE.equals(rs.getString("FMODULE")))
				{	
					if (icnt ==0) out.println("<tr>");
					if (icnt !=0) out.println("</table></td>");
					out.println("<td><table width='100%' border='0' cellpadding='0' cellspacing='0'>");
					FMODULE=rs.getString("FMODULE");
				}
				out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
				icnt++;
			}
      		rs.close(); 
	  		statement.close();
  		} //end of try
  		catch (Exception e)
  		{
	  		e.printStackTrace();
      		out.println(e.getMessage());
  		}//end of catch  
  		if (icnt >0) out.println("</table></td></tr>");   
		%>   
</table>
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
