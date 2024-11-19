<!--20170110 Peggy,Performance issue-->
<!--20170915 Peggy,YEW 拿掉"需求原因"欄位,新增"RFQ類型"欄位-->
<!--20171225 Peggy,新增L/T & 交期L/T for YEW issue-->
<!--20180614 Peggy,新增終端客戶-->
<!--20180625 Peggy,"工廠排定執行日"更名為"HQ排定執行日" for YEW issue-->
<!--20180731 Peggy,特規& H Code for YEW issue-->
<!--20181005 Peggy,新增ERP訂單狀態-->
<!--20181213 Peggy,消庫存RFQ其工廠別欄位顯示"消庫存"-->
<!--20200112 Peggy,增加"是否回T"欄位 from Zhangdi-->
<!--20200113 Peggy,增加"Over Lead Time Reason"欄位 from Amanda-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,java.util.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSRFQFactResponseMO2Excel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String sqlGlobal = request.getParameter("SQLGLOBAL");
String sqlDtl = request.getParameter("SQLDETAIL");
String RepCenterNo=request.getParameter("REPCENTERNO");   // 改抓Session內的登入資料
String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");
String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");  
String CdateSetBegin=request.getParameter("CDATESETBEGIN");   //add by Peggy 20120222
String CdateSetEnd=request.getParameter("CDATESETEND");       //add by Peggy 20120222
String dnDocNo=request.getParameter("DNDOCNO");
String SWHERE=request.getParameter("SWHERECOND");
String prodManufactory=request.getParameter("PRODMANUFACTORY");
String status=request.getParameter("STATUS");
String salesAreaNo=request.getParameter("SALESAREANO");
if (dnDocNo==null) dnDocNo = "";
if (dateStringBegin==null){dateStringBegin=dateBean.getYearMonthDay();}
if (dateStringEnd==null){dateStringEnd=dateBean.getYearMonthDay();}
String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
String hmsCurr = dateBean.getHourMinuteSecond();
String ShipType=request.getParameter("SHIPTYPE");
String ShipName=request.getParameter("SHIPNAME");
String strHMSec = request.getParameter("HOURTIME");
String NYearFr=request.getParameter("NYEARFR");
if (NYearFr==null) NYearFr="--";
String NMonthFr=request.getParameter("NMONTHFR");
if (NMonthFr==null) NMonthFr="--";
String NDayFr=request.getParameter("NDAYFR");
if (NDayFr==null) NDayFr="--";
String NYearTo=request.getParameter("NYEARTO");
if (NYearTo==null) NYearTo="--";
String NMonthTo=request.getParameter("NMONTHTO");
if (NMonthTo==null) NMonthTo="--";
String NDayTo=request.getParameter("NDAYTO");
if (NDayTo==null) NDayTo="--";
String debugstr = "0";  //20110929 add by Peggy 
int colNo = 0,rowNo = 0;

try 
{ 	
	String sql = "";
	String sWhere = "";
    String sFrom = "";
	String orderBy = "";
	String customer="";
	String tscItemDesc = "";
	String salesPerson = "";
    String creationDate = "";   //20090518 liling for YEW issue
	String requestDate = "";
	String pcDeliverDate = "";
	String factArrangeDate = "";
	String pcConfirmDate = ""	,ftConDT="";
	String moCreateDate = "";
	String prodFactoryName="";
    String assignUserName="";
	String prodUserName="";
	String uom = "";	 
	String qty="";
	String schShipDate="";
	String remark="";
	String salesOrderNo = "";
	String processStatus = "";
	String reqReason = "";
    String tscPackage = "",tscFamily = "";
    String reasonDesc="";
    String plantCode="",deptCode="";
    String ftConfDate="",pcRemark="",lstatusId="";
	String sSqlCnt = "";
	String sInqDocCount = "0";
	String marketGroup  ="";
	String wafer_item ="",wafer_use_qty="",wafer_vendor="",v_str="";
	Hashtable hashtb = new Hashtable();

    /*if (sqlGlobal==null || sqlGlobal=="")
	{ 		
		sql = "select c.*,d.* ,e.attribute2,case when d.assign_manufact='002' then g.DEPT else '' end yew_department"+
			  ",h.pc_confirm_date,round(to_date(h.pc_confirm_time,'YYYYMMDDHH24MISS')- to_date(d.CREATION_DATE,'YYYYMMDDHH24MISS'),0) pc_reply_time,g.pc_ft_confirm_date,g.pc_ft_apply_date,h.PC_REMARK"+
              ",lt.*,case when d.ftacpdate='N/A' then null else ceil((TO_DATE (SUBSTR (d.ftacpdate, 1, 8), 'yyyymmdd') -TO_DATE (g.PC_FT_CONFIRM_DATE, 'yyyy/mm/dd')) /7) end as ssd_leadtime"+
			  ",nvl(nvl(end_cust.CUSTOMER_NAME_PHONETIC,end_cust.customer_name),d.end_customer) end_customer1"+ //add by Peggy 20180614
			  ",case when instr(ITEM_DESCRIPTION,'D2SB60-19')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'GBU805-03')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'GBU806-13')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'ES1J-15')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1J-15')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1J-03')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S3J-02')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S3JB-02')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1GL-01')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'1T7G-A')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1G-23')>0 then 'Y'"+        //add by Peggy 20181126
			  "      when instr(ITEM_DESCRIPTION,'BZD27C22P-01')>0 then 'Y'"+  //add by Peggy 20181126
			  "      when instr(ITEM_DESCRIPTION,'BZD27C27P-02')>0 then 'Y'"+  //add by Peggy 20181126
			  "      when SUBSTR(ITEM_SEGMENT1,11,1) IN ('H','2') then 'H'"+
			  "      else '' end as h_item_flag"+  //add by Peggy 20180731
			  ",nvl(oha.flow_status_code,'CANCELLED') flow_status_code"+  //add by Peggy 20181005
			  ",'' ALNAME2"+
			  ",nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID) line_ORDER_TYPE_ID"+ //add by Peggy 20200204
			  ",tsc_get_china_to_tw_days(null,NVL(decode(d.orderno,'N/A',null,d.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=c.tsareano and oto.otype_id=nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID))),d.inventory_item_id,d.assign_manufact,c.tscustomerid,case when d.SASCODATE<>'N/A' then substr(d.SASCODATE,1,8) else to_char(sysdate,'yyyymmdd') end) * CASE WHEN d.direct_ship_to_cust =1  and d.assign_manufact='002' THEN 0 ELSE 1 END as totw_days"+ //add by Peggy 20200916		  
			  ",tsc_get_rfq_lead_time( TO_DATE (DECODE (d.creation_date, 'N/A', NULL, substr(d.creation_date,1,8)),'YYYYMMDD'),to_date(d.pc_leadtime,'yyyymmdd')) rfq_leadtime"+ //add by Peggy 20201028
			  ",rea.reasondesc reasondescname "+//add by Peggy 20201126
			  ",(SELECT meaning  FROM fnd_lookup_values x WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD' and x.lookup_code=nvl(d.shipping_method,c.SHIPMETHOD)) shipping_method_name"+
			  ",to_char(to_date(substr(d.request_date,1,8),'yyyymmdd')-tsc_get_china_to_tw_days(null,NVL(decode(d.orderno,'N/A',null,d.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=c.tsareano and oto.otype_id=nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID))),d.inventory_item_id,d.assign_manufact,c.tscustomerid,case when d.SASCODATE<>'N/A' then substr(d.SASCODATE,1,8) else to_char(sysdate,'yyyymmdd') end) * CASE WHEN d.direct_ship_to_cust =1  and d.assign_manufact='002' THEN 0 ELSE 1 END,'yyyy/mm/dd') as factory_ssd";//add by Peggy 20210628
	   	sFrom = " from ORADDMAN.TSDELIVERY_NOTICE c"+
		        ",ORADDMAN.TSDELIVERY_NOTICE_DETAIL d"+
				",apps.hz_cust_accounts e"+
				",APPS.YEW_MFG_DEPT f"+
				",ar_customers end_cust "+	
				",(select h.dndocno,h.line_no, TO_CHAR(TO_DATE(h.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') pc_confirm_date,h.CDATETIME pc_confirm_time,h.PC_REMARK from (select a.* ,row_number() over (partition by a.dndocno,a.line_no,a.ORISTATUSID order by CDATETIME desc) row_seq"+
                " from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a where a.ORISTATUSID = '004' ) h where row_seq=1) h"+
				",(select h.dndocno,h.line_no, TO_CHAR(TO_DATE(h.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') pc_ft_confirm_date,TO_CHAR(TO_DATE(decode(h.ARRANGED_DATE,'N/A',null,h.ARRANGED_DATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD') pc_ft_apply_date from (select a.* ,row_number() over (partition by a.dndocno,a.line_no,a.ORISTATUSID order by CDATETIME desc) row_seq"+
                " from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a where a.ORISTATUSID = '003' ) h where row_seq=1) g "+
				",table(TSC_GET_ITEM_LEADTIME(d.INVENTORY_ITEM_ID,d.ASSIGN_MANUFACT,null)) lt "+ //add by Peggy 20171225
                ",(select to_char(x.order_number) order_number,case when sum(y.ordered_quantity) >0 then x.flow_status_code else 'CANCELLED' END flow_status_code from ont.oe_order_headers_all x,ont.oe_order_lines_all y  where x.org_id=y.org_id and x.header_id=y.header_id and substr(x.order_number,1,1) =1 and x.org_id=41 group by x.order_number,x.org_id,x.flow_status_code"+
                " union all"+
                " select to_char(x.order_number) order_number,case when sum(y.ordered_quantity) >0 then x.flow_status_code else 'CANCELLED' END flow_status_code from ont.oe_order_headers_all x,ont.oe_order_lines_all y  where x.org_id=y.org_id and x.header_id=y.header_id and substr(x.order_number,1,1) in (4,8) and x.org_id in (325,906) group by x.order_number,x.org_id,x.flow_status_code) oha "+
				" ,(SELECT tsreasonno, reasondesc FROM oraddman.tsreason WHERE TSREASONNO NOT IN ('07','08') and LOCALE='886') rea "; //add by Peggy 20201126
	   	sWhere = " where c.DNDOCNO = d.DNDOCNO "+
		         " and c.tscustomerid=e.CUST_ACCOUNT_ID "+
				 " and tsc_om_category (d.inventory_item_id, 49, 'TSC_Package')=f.TSC_PACKAGE(+) "+
				 " and d.dndocno=h.dndocno(+) "+
				 " and d.line_no=h.line_no(+) "+
				 " and d.dndocno=g.dndocno(+) "+
				 " and d.line_no=g.line_no(+)"+
		         " and d.end_customer_id=end_cust.customer_id(+)"+
			  	 " and d.orderno=oha.order_number(+)"+ //add by Peggy 20181005
				 " and d.REASON_CODE=rea.TSREASONNO(+)"; //add by Peggy 20201126
	   	orderBy =  " ";	  
		if (status.equals("005"))  //add by Peggy 20130610
		{
			sWhere+= " and NVL(d.EDIT_CODE,'') ='R'"; 
		}	
		if ((dateSetBegin!=null &&  !dateSetBegin.equals("") && !dateSetBegin.equals("------")) || (dateSetEnd !=null && !dateSetEnd.equals("") && !dateSetEnd.equals("------")))
		{
			sWhere+= " and exists (select 1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=d.dndocno and x.line_no=d.line_no and x.ORISTATUSID = '004' and substr(x.CDATETIME,1,8) between nvl(decode('"+dateSetBegin+"','------',null,'"+dateSetBegin+"'),'20010101')"+" AND nvl(decode('"+dateSetEnd+"','------',null,'"+dateSetEnd+"'),'20991231'))";	
		}	
		if (!NYearFr.equals("--") || !NMonthFr.equals("--") || !NDayFr.equals("--"))
		{
			sWhere+= " and substr(d.REQUEST_DATE,1,8) >= '"+ (NYearFr.equals("--")?""+(dateBean.getYear()-2):NYearFr)+(NMonthFr.equals("--")?"01":NMonthFr)+(NDayFr.equals("--")?"01":NDayFr)+"' ";
		}
		if (!NYearTo.equals("--") || !NMonthTo.equals("--") || !NDayTo.equals("--"))
		{
			//sWhere+= " and substr(d.REQUEST_DATE,1,8) <='"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):NDayTo)+"' ";
			sWhere+= " and substr(d.REQUEST_DATE,1,8) <= to_char(to_date('"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):""+NDayTo)+"','yyyymmdd')-"+(!NMonthTo.equals("--")&&NDayTo.equals("--")?1:0)+",'yyyymmdd')";
		}		
		if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("PRD_PM")>=0)  //add by Peggy 20210609
		{
			sWhere+=" and d.TSC_PROD_GROUP in ('PRD','PRD-Subcon')";  	
		}			
	}
	else
   	{
	*/
 		sql = "select "+
        	  "  TO_CHAR(TO_DATE(decode(d.PCCFMDATE,'N/A',null,d.PCCFMDATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD') PCCFMDATE, "+   //20081125 liling update for YEW date format issue
              " TO_CHAR(TO_DATE(decode(d.FTACPDATE,'N/A',null,d.FTACPDATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD') FTACPDATE,  "+   //20081125 liling update for YEW date format issue
		      " TO_CHAR(TO_DATE(decode(d.PCACPDATE,'N/A',null,d.PCACPDATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD') PCACPDATE,  "+   //20081125 liling update for YEW date format issue
		      " TO_CHAR(TO_DATE(decode(d.SASCODATE,'N/A',null,d.SASCODATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD') SASCODATE,  "+   //20081125 liling update for YEW date format issue
		      " TO_CHAR(TO_DATE(SUBSTR(d.REQUEST_DATE,1,8),'YYYYMMDD'),'YYYY/MM/DD') REQUEST_DATE ,  "+   //20091125 liling ADD for YEW issue
		      " TO_CHAR(TO_DATE(SUBSTR(d.REQUEST_DATE,1,6),'YYYYMM'),'YYYY/MM') CRD_YM ,  "+   //20091125 liling ADD for YEW issue
              " TO_CHAR(TO_DATE(decode(d.CREATION_DATE,'N/A',null,d.CREATION_DATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') CREATION_DATE,  "+   //20090518 liling update for YEW date format issue
              " TO_CHAR(TO_DATE(decode(d.CREATION_DATE,'N/A',null,d.CREATION_DATE),'YYYYMMDDHH24MISS'),'DAY') CREATION_DAY, d.REMARK REASONDESC ,  "+   //20090518 liling update for YEW date format issue
		      //" b.*,c.*,d.*,e.*, "+
			  " c.customer,c.REQREASON,c.RFQ_TYPE,b.ALCHNAME,c.DNDOCNO,c.SALESPERSON,d.REASON_CODE,e.MANUFACTORY_NAME,d.ASSIGN_MANUFACT,d.PC_OVER_LEADTIME_REASON,"+
              " d.LINE_NO,d.ITEM_SEGMENT1,d.ITEM_DESCRIPTION,d.PRIMARY_UOM,d.QUANTITY,d.ORDERNO,d.EDIT_CODE,d.LSTATUSID,d.LSTATUS,"+
              " d.ORDERED_ITEM,c.TSCUSTOMERID,d.CUST_REQUEST_DATE,d.PC_COMMENT,d.inventory_item_id"+
			  //",TSC_OM_CATEGORY(d.INVENTORY_ITEM_ID, 49,'TSC_Family') TSC_FAMILY"+
			  //",TSC_OM_CATEGORY(d.INVENTORY_ITEM_ID, 49,'TSC_Package') TSC_PACKAGE "+
			  ",TSC_INV_CATEGORY(d.INVENTORY_ITEM_ID, 49,21) TSC_FAMILY"+
			  ",TSC_INV_CATEGORY(d.INVENTORY_ITEM_ID, 49,23) TSC_PACKAGE "+
			  ",count(distinct c.dndocno) over (partition by 1) rfq_cnt,count(c.dndocno) over (partition by 1) rfq_tot_cnt,f.attribute2,case when d.assign_manufact='002' then g1.DEPT else '' end yew_department"+ //add by Peggy 20170110
			  ",h.pc_confirm_date ,round(to_date(h.pc_confirm_time,'YYYYMMDDHH24MISS')- to_date(d.CREATION_DATE,'YYYYMMDDHH24MISS'),0) pc_reply_time,g.pc_ft_confirm_date,g.pc_ft_apply_date,h.PC_REMARK"+
              //",lt.*"+
			  ",case when d.ftacpdate='N/A' then null else ceil((TO_DATE (SUBSTR (d.ftacpdate, 1, 8), 'yyyymmdd') -TO_DATE (g.PC_FT_CONFIRM_DATE, 'yyyy/mm/dd')) /7) end as ssd_leadtime"+
			  ",nvl(nvl(end_cust.CUSTOMER_NAME_PHONETIC,end_cust.customer_name),d.end_customer) end_customer1"+ //add by Peggy 20180614
			  ",case when instr(ITEM_DESCRIPTION,'D2SB60-19')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'GBU805-03')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'GBU806-13')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'ES1J-15')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1J-15')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1J-03')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S3J-02')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S3JB-02')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1GL-01')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'1T7G-A')>0 then 'Y'"+
			  "      when instr(ITEM_DESCRIPTION,'S1G-23')>0 then 'Y'"+        //add by Peggy 20181126
			  "      when instr(ITEM_DESCRIPTION,'BZD27C22P-01')>0 then 'Y'"+  //add by Peggy 20181126
			  "      when instr(ITEM_DESCRIPTION,'BZD27C27P-02')>0 then 'Y'"+  //add by Peggy 20181126
			  "      when SUBSTR(ITEM_SEGMENT1,11,1) IN ('H','2') then 'H'"+
			  "      else '' end as h_item_flag"+ //add by Peggy 20180731	
			  ",nvl(oha.flow_status_code,'CANCELLED') flow_status_code"+ //add by Peggy 20181005
			  ",e.ALNAME ALNAME2"+
			  ",nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID) line_ORDER_TYPE_ID"+ //add by Peggy 20200204
              //",tsc_get_china_to_tw_days(null,NVL(decode(d.orderno,'N/A',null,d.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=c.tsareano and oto.otype_id=nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID))),d.inventory_item_id,d.assign_manufact,c.tscustomerid,null) * CASE WHEN d.direct_ship_to_cust =1  and d.assign_manufact='002' THEN 0 ELSE 1 END as totw_days"; //add by Peggy 20200325			  
			  ",tsc_get_china_to_tw_days(null,NVL(decode(d.orderno,'N/A',null,d.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=c.tsareano and oto.otype_id=nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID))),d.inventory_item_id,d.assign_manufact,c.tscustomerid,case when d.SASCODATE<>'N/A' then substr(d.SASCODATE,1,8) else to_char(sysdate,'yyyymmdd') end,nvl(d.CUST_PO_NUMBER,c.CUST_PO)) * CASE WHEN d.direct_ship_to_cust =1  and d.assign_manufact='002' THEN 0 ELSE 1 END as totw_days"+ //add by Peggy 20200916		  
			  ",tsc_get_rfq_lead_time( TO_DATE (DECODE (d.creation_date, 'N/A', NULL, substr(d.creation_date,1,8)),'YYYYMMDD'),to_date(d.pc_leadtime,'yyyymmdd')) rfq_leadtime"+ //add by Peggy 20201028
			  ",rea.reasondesc reasondescname"+//add by Peggy 20201126
			  ",(SELECT meaning  FROM fnd_lookup_values x WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD' and x.lookup_code=nvl(d.shipping_method,c.SHIPMETHOD)) shipping_method_name"+
			  //",to_char(to_date(substr(d.request_date,1,8),'yyyymmdd')-tsc_get_china_to_tw_days(null,NVL(decode(d.orderno,'N/A',null,d.orderno),(SELECT order_num from oraddman.tsarea_ordercls oto where oto.sarea_no=c.tsareano and oto.otype_id=nvl(d.ORDER_TYPE_ID,c.ORDER_TYPE_ID))),d.inventory_item_id,d.assign_manufact,c.tscustomerid,case when d.SASCODATE<>'N/A' then substr(d.SASCODATE,1,8) else to_char(sysdate,'yyyymmdd') end,nvl(d.CUST_PO_NUMBER,c.CUST_PO)) * CASE WHEN d.direct_ship_to_cust =1  and d.assign_manufact='002' THEN 0 ELSE 1 END,'yyyy/mm/dd') as factory_ssd"+//add by Peggy 20210628
			  ",to_char(to_date(substr(d.request_date,1,8),'yyyymmdd'),'yyyy/mm/dd') as factory_ssd"+//不應扣回T天數 BY PEGGY 20221209
			  ",nvl(ped.pc1_pending_hours,0)+nvl(ped.pc2_pending_hours,0) tot_pc_pending_hours ";  //add by Peggy 20211202
		sFrom = " from ORADDMAN.TSSALES_AREA b"+
		        ",ORADDMAN.TSDELIVERY_NOTICE c"+
				",ORADDMAN.TSDELIVERY_NOTICE_DETAIL d"+
				",ORADDMAN.TSPROD_MANUFACTORY e"+
				",apps.hz_cust_accounts f"+
				",APPS.YEW_MFG_DEPT g1"+
				",ar_customers end_cust "+
				",tsc_customer_all_v ar"+
				",(select h.dndocno,h.line_no, TO_CHAR(TO_DATE(h.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') pc_confirm_date,h.CDATETIME pc_confirm_time,h.PC_REMARK from (select a.* ,row_number() over (partition by a.dndocno,a.line_no,a.ORISTATUSID order by CDATETIME desc) row_seq"+
                " from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a where a.ORISTATUSID = '004' ) h where row_seq=1) h"+
				",(select h.dndocno,h.line_no, TO_CHAR(TO_DATE(h.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') pc_ft_confirm_date,TO_CHAR(TO_DATE(decode(h.ARRANGED_DATE,'N/A',null,h.ARRANGED_DATE),'YYYYMMDDHH24MISS'),'YYYY/MM/DD') pc_ft_apply_date from (select a.* ,row_number() over (partition by a.dndocno,a.line_no,a.ORISTATUSID order by CDATETIME desc) row_seq"+
                " from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a where a.ORISTATUSID = '003' ) h where row_seq=1) g "+
				//",table(TSC_GET_ITEM_LEADTIME(d.INVENTORY_ITEM_ID,d.ASSIGN_MANUFACT,null)) lt "+//add by Peggy 20171225
				//", (select to_char(order_number) order_number,flow_status_code from ont.oe_order_headers_all where org_id=41) oha ";
                ",(select to_char(x.order_number) order_number,case when sum(y.ordered_quantity) >0 then x.flow_status_code else 'CANCELLED' END flow_status_code from ont.oe_order_headers_all x,ont.oe_order_lines_all y  where x.org_id=y.org_id and x.header_id=y.header_id and substr(x.order_number,1,1) =1 and x.org_id=41 group by x.order_number,x.org_id,x.flow_status_code"+
                " union all"+
                " select to_char(x.order_number) order_number,case when sum(y.ordered_quantity) >0 then x.flow_status_code else 'CANCELLED' END flow_status_code from ont.oe_order_headers_all x,ont.oe_order_lines_all y  where x.org_id=y.org_id and x.header_id=y.header_id and substr(x.order_number,1,1) =4 and x.org_id=325 group by x.order_number,x.org_id,x.flow_status_code) oha "+
				" ,(SELECT tsreasonno, reasondesc FROM oraddman.tsreason WHERE TSREASONNO NOT IN ('07','08') and LOCALE='886') rea "+ //add by Peggy 20201126
				" ,table(tsc_rfq_create_erp_odr_pkg.rfq_pending_info(d.dndocno,d.line_no)) ped "; //add by Peggy 20211202
		sWhere = SWHERE+ " and c.tscustomerid=f.CUST_ACCOUNT_ID "+
		        //" and tsc_om_category (d.inventory_item_id, 49, 'TSC_Package')=g1.TSC_PACKAGE(+) "+
				" and tsc_inv_category (d.inventory_item_id, 49, 23)=g1.TSC_PACKAGE(+) "+
				" and d.dndocno=h.dndocno(+) "+
				" and d.line_no=h.line_no(+) "+
				" and d.dndocno=g.dndocno(+) "+
				" and d.line_no=g.line_no(+) "+
				" and c.tscustomerid=ar.customer_id"+ 
				" and d.end_customer_id=end_cust.customer_id(+)"+
				" and d.orderno=oha.order_number(+)"+ //add by Peggy 20181005
				" and d.REASON_CODE=rea.TSREASONNO(+)"; //add by Peggy 20201126
		if (UserRoles=="admin" || UserRoles.equals("admin")) 
		{ 
		}  // 若為管理員,可看任一產地詢問單
	    else 
		{
			if (!prodManufactory.equals("--") && !prodManufactory.equals(""))
	    	{
        		//SWHERE+=" and d.ASSIGN_MANUFACT = '"+prodManufactory+"' "; 
				sWhere+=" and case when nvl(d.REASON_CODE,'XX')='08' AND d.ASSIGN_MANUFACT not in ('005','008') then '00' else d.ASSIGN_MANUFACT end = '"+prodManufactory+"' ";  //消庫存的rfq不要顯示在工廠裡for -ON消庫存ISSUE,add by Peggy 20181213
	    	}    
			//add by Peggy 20120413
			if (salesAreaNo != null && !salesAreaNo.equals("--") && !salesAreaNo.equals(""))
			{
				sWhere+=" and c.TSAREANO ='" +salesAreaNo+"'";  
			}		   
		}
		if (status.equals("005"))  //add by Peggy 20130610
		{
			sWhere+= " and NVL(d.EDIT_CODE,'') ='R'"; 
		}		
		if ((dateSetBegin!=null &&  !dateSetBegin.equals("") && !dateSetBegin.equals("------")) || (dateSetEnd !=null && !dateSetEnd.equals("") && !dateSetEnd.equals("------")))
		{
			sWhere+= " and exists (select 1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=d.dndocno and x.line_no=d.line_no and x.ORISTATUSID = '004' and substr(x.CDATETIME,1,8) between nvl(decode('"+dateSetBegin+"','------',null,'"+dateSetBegin+"'),'20010101')"+" AND nvl(decode('"+dateSetEnd+"','------',null,'"+dateSetEnd+"'),'20991231'))";	
		}	
		if (!NYearFr.equals("--") || !NMonthFr.equals("--") || !NDayFr.equals("--"))
		{
			sWhere += " and substr(d.REQUEST_DATE,1,8) >= '"+ (NYearFr.equals("--")?""+(dateBean.getYear()-2):NYearFr)+(NMonthFr.equals("--")?"01":NMonthFr)+(NDayFr.equals("--")?"01":NDayFr)+"' ";
		}
		if (!NYearTo.equals("--") || !NMonthTo.equals("--") || !NDayTo.equals("--"))
		{
			//sWhere+= " and substr(d.REQUEST_DATE,1,8) <='"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):NDayTo)+"' ";
			sWhere+= " and substr(d.REQUEST_DATE,1,8) <= to_char(to_date('"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):""+NDayTo)+"','yyyymmdd')-"+(!NMonthTo.equals("--")&&NDayTo.equals("--")?1:0)+",'yyyymmdd')";
			//out.println(SWHERE);
		}	
		if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("PRD_PM")>=0)  //add by Peggy 20210609
		{
			sWhere+=" and d.TSC_PROD_GROUP in ('PRD','PRD-Subcon')";  	
		}						
	//}
  	// 取生產地抬頭_起
    Statement stateProd=con.createStatement();
    String sqlProd = "select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO= '"+prodManufactory+"' ";
    ResultSet rsProd=stateProd.executeQuery(sqlProd);
	if (rsProd.next())
	{
		prodFactoryName = rsProd.getString(1);
	} 
	else 
	{ 
		prodFactoryName = "ALL"; 
	}
	rsProd.close();
	stateProd.close();

	//用不到不知當時抓這句sql做什麼,mark by Peggy 20170109
    //Statement stateAssign=con.createStatement();
    //String sqlAssign = "select b.USERID from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a,ORADDMAN.TSSPLANER_PERSON b where a.UPDATEUSERID = b.USERNAME and DNDOCNO= '"+dnDocNo+"' and ORISTATUSID='002' ";
    //ResultSet rsAssign=stateAssign.executeQuery(sqlAssign);
	//if (rsAssign.next())
	//{
	//	assignUserName = rsAssign.getString(1);
	//}
	//rsAssign.close();
	//stateAssign.close();

    //if (SWHERE==null || SWHERE=="" || SWHERE.equals("")) // 若為傳入條件式,則為單據
    if (sqlGlobal==null || sqlGlobal=="")
	{     
		if (orderBy==null) orderBy = " order by d.DNDOCNO,d.line_no ";
	    sql = sql + sFrom + sWhere + orderBy;		  
		//out.println("sWhere="+sql);
		sSqlCnt = "select count(d.DNDOCNO) "+ sFrom + sWhere;
    }
    else // 否則則是查詢頁
    {  
		if (orderBy==null) orderBy = " order by d.DNDOCNO,d.line_no ";    
        sql = sql + sFrom + sWhere + orderBy;  // 測試傳表單參數 // 
		//out.println("SWHERE="+sql);   
		//out.println(sql);
		sSqlCnt = "select count(d.DNDOCNO) " + sFrom + sWhere + orderBy;  // 測試傳表單參數 //             
    }
	//out.println(sql);
	
	// 產生報表
	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{
    	os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/FRMO_"+userID+"_"+ymdCurr+hmsCurr+".xls");
	}  
	else 
	{ 
	    // 20210414 Marvie Update : for test
		//os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\FRMO_"+userID+"_"+ymdCurr+hmsCurr+".xls");
	    os = new FileOutputStream("/resin-2.1.9/webapps/oradds/report/FRMO_"+userID+"_"+ymdCurr+hmsCurr+".xls");
	}
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os);
    jxl.write.WritableSheet ws = wwb.createSheet("Sales Delivery Request", 0); //-- TEST
	jxl.SheetSettings sst = ws.getSettings(); 

    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 12, WritableFont.BOLD, false, UnderlineStyle.SINGLE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
    wcfT.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色  20101110
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);

	sst.setSelected();
	sst.setVerticalFreeze(7);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
			
	//file://抬頭:(第0列第1行)
    jxl.write.WritableFont wf1 = new jxl.write.WritableFont(WritableFont.TIMES, 16,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF1 = new jxl.write.WritableCellFormat(wf1); 
	wcfF1.setAlignment(jxl.format.Alignment.CENTRE);
    jxl.write.Label labelCF1 = new jxl.write.Label(0, 0, "工廠回覆與訂單生成狀態表", wcfF1);  // (行,列)
    ws.addCell(labelCF1);
	ws.mergeCells(0, 0, 14, 0);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 6);

                                     
    //抬頭:(第0列第2行)
    jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,12,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.RED); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
   
	jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 11,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
	wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
	
	jxl.write.WritableFont wfR = new jxl.write.WritableFont(WritableFont.TIMES, 11,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFR = new jxl.write.WritableCellFormat(wfR);
	wcfFR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 	
	wcfFR.setAlignment(jxl.format.Alignment.RIGHT);   
	
	jxl.write.Label labelCFC2 = new jxl.write.Label(0, 4, "生產廠區", wcfFC); // 生產廠區(行,列)
    ws.addCell(labelCFC2);
	ws.setColumnView(1, 10);
	
	jxl.write.Label labelCFCProd = new jxl.write.Label(1, 4, prodFactoryName, wcfFC); // 指派人員(行,列)
    ws.addCell(labelCFCProd);
	ws.setColumnView(1, 10);
	
	jxl.write.Label labelCFC30 = new jxl.write.Label(0, 5, "交期回覆日:", wcfFC); // 交期回覆日(行,列)
    ws.addCell(labelCFC30);
	ws.setColumnView(0, 10);
	
	//抬頭:(第0列第3行) 
    jxl.write.Label labelCF3 = new jxl.write.Label(1, 5, dateSetBegin, wcfFC); // 日期起(行,列)
    ws.addCell(labelCF3);
	ws.setColumnView(0, 10);	
	
	//抬頭:(第5行第4行)
	jxl.write.Label labelCF4 = new jxl.write.Label(2, 5, "~"+dateSetEnd, wcfFC); // 日期迄(行,列)
    ws.addCell(labelCF4);
	ws.setColumnView(4, 10);
	
	//抬頭:(第6列第0行)		// 明細抬頭說明
	colNo=0;rowNo=6;
	jxl.write.Label labelCF5 = new jxl.write.Label(colNo, rowNo, "業務地區別", wcfT); // (行,列)
    ws.addCell(labelCF5);
	ws.setColumnView(colNo, 15);
	colNo++;
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(colNo, rowNo, "詢問單號", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(colNo, 20);
	colNo++;
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCFC7 = new jxl.write.Label(colNo, rowNo, "業務人員", wcfT); // (行,列)
    ws.addCell(labelCFC7);
	ws.setColumnView(colNo, 10);
	colNo++;
	
	//抬頭:(第6列第2行)
	jxl.write.Label labelCFC8 = new jxl.write.Label(colNo, rowNo, "生產廠區", wcfT); // (行,列)
    ws.addCell(labelCFC8);
	ws.setColumnView(colNo, 15);
	colNo++;
	
	//抬頭:(第6列第2行)
	jxl.write.Label labelReqDate = new jxl.write.Label(colNo, rowNo, "交期需求日", wcfT); // (行,列)
    ws.addCell(labelReqDate);
	ws.setColumnView(colNo, 12);
	colNo++;

	//抬頭:(第6列第2行)
	jxl.write.Label labelReqMy = new jxl.write.Label(colNo, rowNo, "交期需求年月", wcfT); // (行,列)
    ws.addCell(labelReqMy);
	ws.setColumnView(colNo, 12);
	colNo++;
	
	//抬頭:(第6列第3行)
	jxl.write.Label labelCDate = new jxl.write.Label(colNo, rowNo, "業務開單日", wcfT); // (行,列)
    ws.addCell(labelCDate);
	ws.setColumnView(colNo, 12);
	colNo++;
	
	//抬頭:(第6列第3行)
	jxl.write.Label labelfDate = new jxl.write.Label(colNo, rowNo, "工廠排定執行日", wcfT); // (行,列)
    ws.addCell(labelfDate);
	ws.setColumnView(colNo, 12);	
	colNo++;
	
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(colNo, rowNo, "工廠回覆日", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(colNo, 12);
	colNo++;
	
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9A = new jxl.write.Label(colNo, rowNo, "回覆累計天數", wcfT); // (行,列)
    ws.addCell(labelCF9A);
	ws.setColumnView(colNo, 12);
	colNo++;
	
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(colNo, rowNo, "項次", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(colNo, 5);
	colNo++;

	jxl.write.Label labelCFC111 = new jxl.write.Label(colNo, rowNo, "台半料號", wcfT); // (行,列)
    ws.addCell(labelCFC111);
	ws.setColumnView(colNo, 15);
	colNo++;
	
	jxl.write.Label labelCFC11 = new jxl.write.Label(colNo, rowNo, "台半品號說明", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(colNo, 15);
	colNo++;
	
	jxl.write.Label labelCFC12 = new jxl.write.Label(colNo, rowNo, "單位", wcfT); // (行,列)
    ws.addCell(labelCFC12);
	ws.setColumnView(colNo, 5);
	colNo++;
	
	jxl.write.Label labelCFC13 = new jxl.write.Label(colNo, rowNo, "數量", wcfT); // (行,列)
    ws.addCell(labelCFC13);
	ws.setColumnView(colNo, 5);
	colNo++;
	
	jxl.write.Label labelCFC15 = new jxl.write.Label(colNo, rowNo, (prodManufactory.equals("002")?"HQ排定交貨日":"工廠排定交貨日"), wcfT); // (行,列)
    ws.addCell(labelCFC15);
	ws.setColumnView(colNo, 12);
	colNo++;
 
	jxl.write.Label labelCFC16 = new jxl.write.Label(colNo, rowNo, "工廠確認交貨日", wcfT); // (行,列)
    ws.addCell(labelCFC16);
	ws.setColumnView(colNo, 12);
	colNo++;
 
	//抬頭:(第6列第11行)
	jxl.write.Label labelCFC17 = new jxl.write.Label(colNo, rowNo, "訂單生成日期", wcfT); // (行,列)
    ws.addCell(labelCFC17);
	ws.setColumnView(colNo, 12);
	colNo++;
	
	//抬頭:(第6列第12行)
	jxl.write.Label labelCFC18 = new jxl.write.Label(colNo, rowNo, "銷售訂單號", wcfT); // (行,列)
    ws.addCell(labelCFC18);
	ws.setColumnView(colNo, 18);
	colNo++;

	//抬頭:(第6列第12行)
	jxl.write.Label labelCFC181 = new jxl.write.Label(colNo, rowNo, "ERP訂單狀態", wcfT); // (行,列)
    ws.addCell(labelCFC181);
	ws.setColumnView(colNo, 12);
	colNo++;
	
	//抬頭:(第6列第12行)
	jxl.write.Label labelCFC19 = new jxl.write.Label(colNo, rowNo, "RFQ狀態", wcfT); // (行,列)
    ws.addCell(labelCFC19);
	ws.setColumnView(colNo, 15);
	colNo++;
	
	//抬頭:(第6列第17行)
	if (prodManufactory.equals("002")) //add by Peggy 20170915
	{
		jxl.write.Label labelCFC20 = new jxl.write.Label(colNo, rowNo, "RFQ類型", wcfT); // (行,列)
	    ws.addCell(labelCFC20);
		ws.setColumnView(colNo, 15);
		colNo++;
	}
	else
	{
		jxl.write.Label labelCFC20 = new jxl.write.Label(colNo, rowNo, "需求原因", wcfT); // (行,列)
	    ws.addCell(labelCFC20);
		ws.setColumnView(colNo, 30);
		colNo++;
	}
	
	//抬頭:(第6列第17行)
	jxl.write.Label labelCFC21 = new jxl.write.Label(colNo, rowNo, "客戶品號", wcfT); // (行,列)
    ws.addCell(labelCFC21);
	ws.setColumnView(colNo, 15);
	colNo++;
	
	//抬頭:(第6列第17行)
	jxl.write.Label labelCFC22 = new jxl.write.Label(colNo, rowNo, "Package", wcfT); // (行,列)
    ws.addCell(labelCFC22);
	ws.setColumnView(colNo, 15);
	colNo++;

	//抬頭:(第6列第17行)
	jxl.write.Label labelCFC23 = new jxl.write.Label(colNo, rowNo, "Family", wcfT); // (行,列)
    ws.addCell(labelCFC23);
	ws.setColumnView(colNo, 15);
	colNo++;

	jxl.write.Label labelCFC24 = new jxl.write.Label(colNo, rowNo, "備註", wcfT); // (行,列)
    ws.addCell(labelCFC24);
	ws.setColumnView(colNo, 30);
	colNo++;

	jxl.write.Label labelCFC25 = new jxl.write.Label(colNo, rowNo, "DEPT", wcfT); // (行,列)
    ws.addCell(labelCFC25);
	ws.setColumnView(colNo, 5);
	colNo++;
 
	jxl.write.Label labelCFC26 = new jxl.write.Label(colNo, rowNo, "工廠確認回覆備註", wcfT); // (行,列)
    ws.addCell(labelCFC26);
	ws.setColumnView(colNo, 10);
	colNo++;
 
 	jxl.write.Label labelCFC27 = new jxl.write.Label(colNo, rowNo, "客戶分類", wcfT); // (行,列)
    ws.addCell(labelCFC27);
	ws.setColumnView(colNo, 10);
	colNo++;
	
    jxl.write.Label labelCFC28 = new jxl.write.Label(colNo, rowNo, "客戶名稱", wcfT); // (行,列)
    ws.addCell(labelCFC28);
	ws.setColumnView(colNo, 30); 
	colNo++;

	//Lead Time
	if (prodManufactory.equals("002")) //add by Peggy 20171225
	{
		//add by Peggy 20180614
		jxl.write.Label labelCFC281 = new jxl.write.Label(colNo, rowNo, "終端客戶", wcfT); // (行,列)
		ws.addCell(labelCFC281);
		ws.setColumnView(colNo, 20); 
		colNo++;
		
		jxl.write.Label labelCFC29 = new jxl.write.Label(colNo, rowNo, "CRD", wcfT); // (行,列)  //add by Peggy 20140306
		ws.addCell(labelCFC29);
		ws.setColumnView(colNo, 10); 
		colNo++;	
	
		jxl.write.Label labelCFC32 = new jxl.write.Label(colNo, rowNo, "L/T", wcfT); // (行,列)
	    ws.addCell(labelCFC32);
		ws.setColumnView(colNo, 10);
		colNo++;
		
		jxl.write.Label labelCFC31 = new jxl.write.Label(colNo, rowNo, "交期L/T", wcfT); // (行,列)
	    ws.addCell(labelCFC31);
		ws.setColumnView(colNo, 10);
		colNo++;
		
		jxl.write.Label labelCFC33 = new jxl.write.Label(colNo, rowNo, "特規/H Code", wcfT); // (行,列) add by Peggy 20180731
	    ws.addCell(labelCFC33);
		ws.setColumnView(colNo, 10);		
		colNo++;

		jxl.write.Label labelCFC301 = new jxl.write.Label(colNo, rowNo, "回T", wcfT); // (行,列)
		ws.addCell(labelCFC301);
		ws.setColumnView(colNo, 10); 
		colNo++;	

		jxl.write.Label labelCFC302 = new jxl.write.Label(colNo, rowNo, "Over Lead Time Reason", wcfT); // (行,列)
		ws.addCell(labelCFC302);
		ws.setColumnView(colNo, 15); 	
		colNo++;
		
		jxl.write.Label labelCFC100 = new jxl.write.Label(colNo, rowNo, "PC Remarks", wcfT); // (行,列)
		ws.addCell(labelCFC100);
		ws.setColumnView(colNo, 30); 
		colNo++;
		
		labelCFC100 = new jxl.write.Label(colNo, rowNo, "運輸方式", wcfT); // (行,列)
		ws.addCell(labelCFC100);
		ws.setColumnView(colNo, 12); 
		colNo++;
		
		labelCFC100 = new jxl.write.Label(colNo, rowNo, "Wafer料號", wcfT); // (行,列)
		ws.addCell(labelCFC100);
		ws.setColumnView(colNo, 20);	
		colNo++;

		labelCFC100 = new jxl.write.Label(colNo, rowNo, "Wafer使用量", wcfT); // (行,列)
		ws.addCell(labelCFC100);
		ws.setColumnView(colNo,8);
		colNo++;		
		
		labelCFC100 = new jxl.write.Label(colNo, rowNo, "Wafer廠商", wcfT); // (行,列)
		ws.addCell(labelCFC100);
		ws.setColumnView(colNo, 12);		
		colNo++;				
	}
	else
	{
		jxl.write.Label labelCFC29 = new jxl.write.Label(colNo, rowNo, "CRD", wcfT); // (行,列)  //add by Peggy 20140306
		ws.addCell(labelCFC29);
		ws.setColumnView(colNo, 10); 	
		colNo++;
		
		jxl.write.Label labelCFC301= new jxl.write.Label(colNo, rowNo, "回T", wcfT); // (行,列)
		ws.addCell(labelCFC301);
		ws.setColumnView(colNo, 10); 
		colNo++;	

		jxl.write.Label labelCFC302 = new jxl.write.Label(colNo, rowNo, "Over Lead Time Reason", wcfT); // (行,列)
		ws.addCell(labelCFC302);
		ws.setColumnView(colNo, 15); 
		colNo++;	
		
		jxl.write.Label labelCFC100 = new jxl.write.Label(colNo, rowNo, "PC Remarks", wcfT); // (行,列)
		ws.addCell(labelCFC100);
		ws.setColumnView(colNo, 30); 
		colNo++;
		
		jxl.write.Label labelCFC32 = new jxl.write.Label(colNo, rowNo, "L/T", wcfT); // (行,列)
	    ws.addCell(labelCFC32);
		ws.setColumnView(colNo, 10);
		colNo++;
	}
	ws.addCell(new jxl.write.Label(colNo, rowNo, "PC Pending Hours", wcfT));  //add by Peggy 20211202
	ws.setColumnView(colNo, 10);
	colNo++;
			
	rowNo++;

	int noSeq = 0;
	String noSeqStr = "";
	int rep0DayAcc = 0;
	int rep1DayAcc = 0;
	int rep2DayAcc = 0;
	int rep3DayAcc = 0;
	int iNO = 0;
	String oriDNDocNo = null;
	String manufactName=null;
	String factRespDTime=null;
	String factRespDays=null;
	String v_totw="";
    //out.println(sql+"<BR>"); 
	//out.println(sql);
	
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sql); 
	//out.println(sql);		
	while (rs.next())
	{	

		colNo=0;
		iNO = rs.getInt("RFQ_CNT");              //add by Peggy 20170110
		sInqDocCount = rs.getString("RFQ_TOT_CNT");  //add by Peggy 20170110
		
		debugstr ="1";
        creationDate=rs.getString("CREATION_DATE");
		debugstr ="1-7";
		jxl.write.Label lable10 = new jxl.write.Label(colNo, rowNo, rs.getString("ALCHNAME") , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(lable10);
		colNo++;
		  
		debugstr ="1-1";
		dnDocNo = rs.getString("DNDOCNO");
	    jxl.write.Label lable11 = new jxl.write.Label(colNo, rowNo, dnDocNo , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(lable11);
		colNo++;
		  
		debugstr ="1-2";
		salesPerson=rs.getString("SALESPERSON");
		if (salesPerson==null) salesPerson="";		  			  
		jxl.write.Label lableSalesPerson = new jxl.write.Label(colNo, rowNo,  salesPerson , wcfFL); 
        ws.addCell(lableSalesPerson);
		colNo++;

		debugstr ="1-3";
		//add by Peggy 20181213
		if (rs.getString("REASON_CODE") !=null && rs.getString("REASON_CODE").equals("08"))
		{
			manufactName="消庫存";
		}
		else
		{
			manufactName=rs.getString("MANUFACTORY_NAME");	//20091125 改抓LINE 的CRD,以免HISTORY裡未有造成空白		  			  
		}
		jxl.write.Label lableManufactName = new jxl.write.Label(colNo, rowNo, manufactName , wcfFL); 
        ws.addCell(lableManufactName);
		colNo++;
			
		debugstr ="2";
		requestDate=rs.getString("REQUEST_DATE");		
		if (rs.getString("ASSIGN_MANUFACT").equals("005") || rs.getString("ASSIGN_MANUFACT").equals("008") || rs.getString("ASSIGN_MANUFACT").equals("002")) //ADD 0002-YEW 20210709 BY PEGGY 
		{	  
			jxl.write.Label lableReqDate = new jxl.write.Label(colNo, rowNo, rs.getString("factory_ssd") , wcfFL);   //add by Peggy 20210628
	        ws.addCell(lableReqDate);
			colNo++;	
		}
		else
		{
			jxl.write.Label lableReqDate = new jxl.write.Label(colNo, rowNo, requestDate , wcfFL); 
	        ws.addCell(lableReqDate);	
			colNo++;
		}
					  
		jxl.write.Label lableReqMy = new jxl.write.Label(colNo, rowNo,rs.getString("CRD_YM") , wcfFL);   //20091125
        ws.addCell(lableReqMy);	
		colNo++;

		pcRemark=rs.getString("PC_REMARK");
		factRespDTime= rs.getString("pc_confirm_date");	
		factRespDays = rs.getString("pc_reply_time");
		if (factRespDTime!=null && !factRespDTime.equals(""))
		{
			if (Integer.parseInt(factRespDays)==0)
			{  
				rep0DayAcc += 1; 
			}
			else if (Integer.parseInt(factRespDays)==1)
			{ 
				rep1DayAcc += 1; 
			}
			else if (Integer.parseInt(factRespDays)==2)
			{ 
				rep2DayAcc += 1;
			}
			else if (Integer.parseInt(factRespDays)>=3)
			{ 
				rep3DayAcc += 1; 		
			}
		}
		else
		{
			factRespDTime="N/A";
			factRespDays="N/A";
		}
		ftConfDate=rs.getString("pc_ft_apply_date");
		ftConDT=rs.getString("pc_ft_confirm_date"); 

	
		debugstr ="6";
		jxl.write.Label lableCreationDTime = new jxl.write.Label(colNo, rowNo, creationDate, wcfFL); //20090518 liling add
		ws.addCell(lableCreationDTime);
		colNo++;
		
		jxl.write.Label lableFactDTime = new jxl.write.Label(colNo, rowNo, ftConDT , wcfFL);   //d1-003 操作時間
		ws.addCell(lableFactDTime);		
		colNo++;
				  			  
		jxl.write.Label lableFactRespDTime = new jxl.write.Label(colNo, rowNo, factRespDTime , wcfFL); 
		ws.addCell(lableFactRespDTime);
		colNo++;
			
		jxl.write.Label lableFactRespDays = new jxl.write.Label(colNo, rowNo, ""+factRespDays , wcfFL); 
		ws.addCell(lableFactRespDays);
		colNo++;
			
		jxl.write.Label lableINO = new jxl.write.Label(colNo, rowNo, rs.getString("LINE_NO") , wcfFL); 
		ws.addCell(lableINO);	
		colNo++;
		  
	  	jxl.write.Label lable211 = new jxl.write.Label(colNo, rowNo, rs.getString("ITEM_SEGMENT1"), wcfFL); // (行,列); 台半料號
	  	ws.addCell(lable211);
		colNo++;
				  
		debugstr ="7";
	  	tscItemDesc=rs.getString("ITEM_DESCRIPTION");
	  	if ((tscItemDesc == null ||  tscItemDesc.equals(""))) {tscItemDesc ="";}		 		       
	  	jxl.write.Label lable21 = new jxl.write.Label(colNo, rowNo, tscItemDesc , wcfFL); // (行,列); 台半料號
	  	ws.addCell(lable21);
		colNo++;
		  
		debugstr ="7-1";
	  	uom=rs.getString("PRIMARY_UOM");
	  	if ((uom == null ||  uom.equals("")))  {uom ="";}
	  	jxl.write.Label lable31 = new jxl.write.Label(colNo, rowNo, uom , wcfFL); // (行,列); 單位
	  	ws.addCell(lable31);
		colNo++;
		  
		debugstr ="7-2";
		qty=rs.getString("QUANTITY");					  
		if (qty==null) qty="0";
		//jxl.write.Label lable41 = new jxl.write.Label(14, rowNo, qty , wcfFL); 
		jxl.write.Number lable41 = new jxl.write.Number(colNo, rowNo, Double.valueOf(qty).doubleValue() , wcfFR);   //modify by Peggy 20180326,改為數字型態
        ws.addCell(lable41);	
		colNo++;		  

	
		debugstr ="7-3";
	  	if ((ftConfDate == null ||  ftConfDate.equals("N/A")))  {ftConfDate ="";}  //第一關(D1-003)工廠回覆日期
	  	jxl.write.Label lablePcCfmDate = new jxl.write.Label(colNo, rowNo, ftConfDate , wcfFL); 
        ws.addCell(lablePcCfmDate);
		colNo++;

		debugstr ="8";
		factArrangeDate=rs.getString("FTACPDATE");  //最終工廠PC確認的日期,但要在confirm後再show出,否則空白
		lstatusId=rs.getString("LSTATUSID");
		if (lstatusId =="003" || lstatusId.equals("003") || lstatusId =="004" || lstatusId.equals("004")) {factArrangeDate ="";}
		jxl.write.Label lableFADate = new jxl.write.Label(colNo, rowNo, factArrangeDate , wcfFL); 
        ws.addCell(lableFADate);	
		colNo++;
		  
		moCreateDate=rs.getString("SASCODATE");
		if ((moCreateDate == null || moCreateDate.equals("N/A"))) {moCreateDate ="N/A";}
		jxl.write.Label lableMoCreateDate = new jxl.write.Label(colNo, rowNo, moCreateDate , wcfFL); 
        ws.addCell(lableMoCreateDate);	
		colNo++;
		  
		salesOrderNo=rs.getString("ORDERNO");
		if ((salesOrderNo == null || salesOrderNo.equals(""))) {salesOrderNo ="N/A";}
		jxl.write.Label lableSOrderNo = new jxl.write.Label(colNo, rowNo, salesOrderNo , wcfFL); 
        ws.addCell(lableSOrderNo);
		colNo++;
		  
		jxl.write.Label lableSOrderNoStatus = new jxl.write.Label(colNo, rowNo, (salesOrderNo == null || salesOrderNo.equals("") || salesOrderNo.equals("N/A")?"N/A":rs.getString("flow_status_code")) , wcfFL); 
        ws.addCell(lableSOrderNoStatus);
		colNo++;
				  
		debugstr ="9";
		//processStatus=rs.getString("LSTATUS");			  	  	
		processStatus=((rs.getString("EDIT_CODE")!=null && rs.getString("EDIT_CODE").equals("R"))?"REJECTED":rs.getString("LSTATUS"));	//modify by Peggy 20130610	  			  
	  	jxl.write.Label lable71 = new jxl.write.Label(colNo, rowNo, processStatus , wcfFL); 
	  	ws.addCell(lable71);
		colNo++;	
		  
		debugstr ="9-1";
		if (prodManufactory.equals("002")) //add by Peggy 20170915
		{
			jxl.write.Label lableReqReason = new jxl.write.Label(colNo, rowNo, (rs.getString("rfq_type").equals("2")?"Forecast":"Normal") , wcfFL); 
	        ws.addCell(lableReqReason);	
			colNo++;
		}
		else
		{
			reqReason=rs.getString("REQREASON");		
			if (reqReason==null || reqReason.equals("")) { reqReason = "";}
			jxl.write.Label lableReqReason = new jxl.write.Label(colNo, rowNo, reqReason , wcfFL); 
	        ws.addCell(lableReqReason);	
			colNo++;
		}
		
		debugstr ="9-2";  
		//2007/03/30 加入客戶品號
		//jxl.write.Label custItemLabel = new jxl.write.Label(21, rowNo, custItem , wcfFL); 
		jxl.write.Label custItemLabel = new jxl.write.Label(colNo, rowNo, rs.getString("ORDERED_ITEM") , wcfFL);
        ws.addCell(custItemLabel);	
		colNo++;	

		//2008/05/20 加入TSC_PACKAGE
		tscPackage=rs.getString("TSC_PACKAGE");
		if ((tscPackage == null ||  tscPackage.equals(""))) tscPackage ="";
		jxl.write.Label tscPackageLabel = new jxl.write.Label(colNo, rowNo, tscPackage , wcfFL); 
        ws.addCell(tscPackageLabel);	 
		colNo++; 

		//2009/07/14 加入TSC_FAMILY
		debugstr ="10";
		tscFamily=rs.getString("TSC_FAMILY");
		if ((tscFamily == null ||  tscFamily.equals(""))) tscFamily ="";
		jxl.write.Label tscFamilyLabel = new jxl.write.Label(colNo, rowNo, tscFamily , wcfFL); 
        ws.addCell(tscFamilyLabel);	
		colNo++;

		reasonDesc=rs.getString("REASONDESC");
		jxl.write.Label reasonDescLabel = new jxl.write.Label(colNo, rowNo, reasonDesc , wcfFL); 
        ws.addCell(reasonDescLabel);
		colNo++;	

	  	plantCode=rs.getString("ASSIGN_MANUFACT");
		deptCode=rs.getString("yew_department");

		jxl.write.Label deptLabel = new jxl.write.Label(colNo, rowNo, (deptCode==null?"":deptCode) , wcfFL); 
        ws.addCell(deptLabel);
		colNo++;	
 
 		debugstr ="11-1";
		jxl.write.Label ftmarkLabel = new jxl.write.Label(colNo, rowNo, pcRemark , wcfFL);   
		ws.addCell(ftmarkLabel);
		colNo++;	
			
		debugstr ="11-2";
		marketGroup=rs.getString("attribute2"); //add by Peggy 20170110
		if (marketGroup==null) marketGroup="";
		
		debugstr ="11-3"+rs.getString("TSCUSTOMERID");
		if ( marketGroup =="AU" || marketGroup.equals("AU")) marketGroup="汽車";
		jxl.write.Label marketLabel = new jxl.write.Label(colNo, rowNo, marketGroup , wcfFL);   //20110729 liling
        ws.addCell(marketLabel);
		colNo++;
		debugstr ="12";
		
		customer=rs.getString("CUSTOMER");
		jxl.write.Label reasonCustLabel = new jxl.write.Label(colNo, rowNo, customer , wcfFL); 
        ws.addCell(reasonCustLabel);	
		colNo++;	

		v_totw =(rs.getInt("totw_days")>0?"Y":"");
		//if (rs.getString("ALNAME2").equals("T") || rs.getString("ALNAME2").equals("E") || rs.getString("ALNAME2").equals("Y"))
		//{
		//	if (!salesOrderNo.equals("N/A") && (salesOrderNo.substring(0,4).equals("1121") || salesOrderNo.substring(0,4).equals("1131") || salesOrderNo.substring(0,4).equals("1141")))
		//	{
		//		v_totw="Y";
		//	}
		//	else if (rs.getString("LINE_ORDER_TYPE_ID").equals("1015") || rs.getString("LINE_ORDER_TYPE_ID").equals("1021") || rs.getString("LINE_ORDER_TYPE_ID").equals("1022"))
		//	{
		//		v_totw="Y";
		//	}
		//}

		debugstr ="12-1";
		//Lead Time
		if (prodManufactory.equals("002")) //add by Peggy 20171225
		{
			//add by Peggy 20180614	
			jxl.write.Label endCustLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("end_customer1")==null?"":rs.getString("end_customer1")) , wcfFL); 
			ws.addCell(endCustLabel);
			colNo++;
		
			//add by Peggy 20140306		
			jxl.write.Label CRDLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("CUST_REQUEST_DATE")==null?"":rs.getString("CUST_REQUEST_DATE")) , wcfFL); 
			ws.addCell(CRDLabel);
			colNo++;

			//jxl.write.Label LTLabel = new jxl.write.Label(32, rowNo, (rs.getString("LEAD_TIME")==null?"":rs.getString("LEAD_TIME")) , wcfFL); 
			//ws.addCell(LTLabel);
			//add by Peggy 20201028
			if (rs.getString("RFQ_LEADTIME")==null)
			{
				ws.addCell(new jxl.write.Label(colNo, rowNo, "" , wcfFL));
				colNo++;
			}
			else
			{
				ws.addCell(new jxl.write.Number(colNo, rowNo, Double.valueOf(rs.getString("RFQ_LEADTIME")).doubleValue(),wcfFR));
				colNo++;
			}			

			jxl.write.Label SSDLTLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("SSD_LEADTIME")==null?"":rs.getString("SSD_LEADTIME")) , wcfFL); 
			ws.addCell(SSDLTLabel);
			colNo++;

			jxl.write.Label	FLAGLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("h_item_flag")==null?"":rs.getString("h_item_flag")) , wcfFL); 
			ws.addCell(FLAGLabel);
			colNo++;

			jxl.write.Label	TOTWLabel = new jxl.write.Label(colNo, rowNo, v_totw, wcfFL); 
			ws.addCell(TOTWLabel);
			colNo++;

			jxl.write.Label	OVERLTLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("PC_OVER_LEADTIME_REASON")==null?"":rs.getString("PC_OVER_LEADTIME_REASON")) , wcfFL); 
			ws.addCell(OVERLTLabel);
			colNo++;

			jxl.write.Label	PCRemarksLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("reasondescname")==null?"":rs.getString("reasondescname"))+(rs.getString("PC_COMMENT")==null?"":rs.getString("PC_COMMENT")) , wcfFL); 
			ws.addCell(PCRemarksLabel);
			colNo++;

			jxl.write.Label Labelx = new jxl.write.Label(colNo, rowNo, rs.getString("shipping_method_name") , wcfFL); 
			ws.addCell(Labelx);		
			colNo++;
			
			wafer_item ="";wafer_use_qty="";wafer_vendor="";v_str="";
			
			if ((String)hashtb.get(rs.getString("inventory_item_id"))==null)
			{
				PreparedStatement statement1 = con.prepareStatement("select * from TABLE(tsc_get_bom_component_info(case when ? in (1302,1165) then 326 else 327 end,?,?)) bom");
				statement1.setString(1,rs.getString("line_ORDER_TYPE_ID"));
				statement1.setString(2,rs.getString("inventory_item_id"));
				statement1.setString(3,"2");
				ResultSet rs1=statement1.executeQuery();
				if (rs1.next())					 
				{
					wafer_item=rs1.getString("ITEM_NAME");
					wafer_use_qty=rs1.getString("COMPONENT_QTY");
					wafer_vendor=rs1.getString("VENDOR_NAME");
					if (wafer_vendor==null) wafer_vendor="";
					hashtb.put(rs.getString("inventory_item_id"),wafer_item+"|"+wafer_use_qty+";"+wafer_vendor);
				}
				rs1.close();
				statement1.close();
			}
			else
			{
				v_str= (String)hashtb.get(rs.getString("inventory_item_id"));
				wafer_item = v_str.substring(0,v_str.indexOf("|"));
				wafer_use_qty = v_str.substring(v_str.indexOf("|")+1,v_str.indexOf(";"));
				wafer_vendor = v_str.substring(v_str.indexOf(";")+1);
				if (wafer_vendor==null) wafer_vendor="";
			}
			
			Labelx = new jxl.write.Label(colNo, rowNo, wafer_item , wcfFL); 
			ws.addCell(Labelx);		
			colNo++;				

			Labelx = new jxl.write.Label(colNo, rowNo, wafer_use_qty, wcfFL); 
			ws.addCell(Labelx);	
			colNo++;					

			Labelx = new jxl.write.Label(colNo, rowNo, wafer_vendor, wcfFL); 
			ws.addCell(Labelx);		
			colNo++;				
		}
		else
		{
			debugstr ="12-11";
			//add by Peggy 20140306		
			jxl.write.Label CRDLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("CUST_REQUEST_DATE")==null?"":rs.getString("CUST_REQUEST_DATE")) , wcfFL); 
			ws.addCell(CRDLabel);
			colNo++;
			
			debugstr ="12-12";
			jxl.write.Label	TOTWLabel = new jxl.write.Label(colNo, rowNo, v_totw , wcfFL); 
			ws.addCell(TOTWLabel);
			colNo++;

			debugstr ="12-13";
			jxl.write.Label	OVERLTLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("PC_OVER_LEADTIME_REASON")==null?"":rs.getString("PC_OVER_LEADTIME_REASON")) , wcfFL); 
			ws.addCell(OVERLTLabel);
			colNo++;

			debugstr ="12-14";
			jxl.write.Label	PCRemarksLabel = new jxl.write.Label(colNo, rowNo, (rs.getString("reasondescname")==null?"":rs.getString("reasondescname"))+(rs.getString("PC_COMMENT")==null?"":rs.getString("PC_COMMENT")) , wcfFL); 
			ws.addCell(PCRemarksLabel);
			colNo++;
			
			//add by Peggy 20201028
			if (rs.getString("RFQ_LEADTIME")==null)
			{
				ws.addCell(new jxl.write.Label(colNo, rowNo, "" , wcfFL));
				colNo++;
			}
			else
			{
				ws.addCell(new jxl.write.Number(colNo, rowNo, Double.valueOf(rs.getString("RFQ_LEADTIME")).doubleValue(),wcfFR));
				colNo++;
			}			
		}
		debugstr ="12-15";
		ws.addCell(new jxl.write.Number(colNo, rowNo, Double.valueOf(rs.getString("tot_pc_pending_hours")).doubleValue(),wcfFR)); //add by Peggy 20211202
		colNo++;

		rowNo++;
		oriDNDocNo = rs.getString("DNDOCNO");
	}  
		
	rs.close();
	statement.close();
	 
	jxl.write.Label accumDNCntTitle = new jxl.write.Label(0, rowNo+3, "本次查詢詢問單數" , wcfFL); //行, 列+3 顯示詢問單筆數標題 
    ws.addCell(accumDNCntTitle);	
	  
	debugstr ="13";
	jxl.write.Label accumDNCount = new jxl.write.Label(1, rowNo+3, sInqDocCount+ "筆" , wcfFC); //行+1, 列+3 顯示詢問單筆數 
    ws.addCell(accumDNCount);	
	  
	jxl.write.Label fctRPImmTitle = new jxl.write.Label(5, rowNo+4, "工廠當天回覆共" , wcfFL); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRPImmTitle);	
	 
	jxl.write.Label fctRPImmed = new jxl.write.Label(6, rowNo+4, rep0DayAcc + "筆" , wcfFC); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRPImmed);
	  
	jxl.write.Label fctRP1Title = new jxl.write.Label(5, rowNo+5, "工廠1天回覆共" , wcfFL); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRP1Title);	
	  
	debugstr ="14";
	jxl.write.Label fctRP1Day = new jxl.write.Label(6, rowNo+5, rep1DayAcc + "筆" , wcfFC); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRP1Day);	 
	 
	jxl.write.Label fctRP2Title = new jxl.write.Label(5, rowNo+6, "工廠2天回覆共" , wcfFL); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRP2Title);	
	  
	jxl.write.Label fctRP2Day = new jxl.write.Label(6, rowNo+6, rep2DayAcc + "筆" , wcfFC); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRP2Day);
	  
	jxl.write.Label fctRP3Title = new jxl.write.Label(5, rowNo+7, "工廠3天(含)以上回覆共" , wcfFL); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRP3Title);	
	  
	jxl.write.Label fctRP3Day = new jxl.write.Label(6, rowNo+7, rep3DayAcc + "筆" , wcfFC); //行+4, 列+3 顯示詢問單筆數標題 
    ws.addCell(fctRP3Day);
	debugstr ="15";
	wwb.write(); 
    wwb.close();
    os.close();  
    out.close(); 
}   
catch (Exception e) 
{ 
	out.println("Exception"+debugstr+":"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
  response.reset();
  response.setContentType("application/vnd.ms-excel");					
  response.sendRedirect("/oradds/report/FRMO_"+userID+"_"+ymdCurr+hmsCurr+".xls");  

%>

</html>
