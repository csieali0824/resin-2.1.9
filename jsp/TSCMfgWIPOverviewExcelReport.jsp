<!--20151021 by Peggy,解決TMT.T_機器工時&TMT.T_人工工時=null-->
<!--20180104 by Liling 修前段料號判斷方式 -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCMfgWIPOverviewExcelReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String RPTTYPE=request.getParameter("RPTTYPE");
if (RPTTYPE==null) RPTTYPE="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String DEPTNO=request.getParameter("DEPTNO");
if (DEPTNO==null) DEPTNO="";
String ITEMNO=request.getParameter("ITEMNO");
if (ITEMNO==null) ITEMNO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String WIPNO=request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="";
int fontsize=9,mergeCol=0,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	if (RPTTYPE.equals("1"))
	{
		sql = " select decode(we.organization_id,'326','Y1','327','Y2')  org"+
                 ",we.wip_entity_name  \"工單號\""+
                 ",TSC_OM_CATEGORY(msi.inventory_item_id, msi.organization_id,'TSC_Package')  as  TSC_Package "+   //20141127 liling add column  
                 ",TSC_OM_CATEGORY(msi.inventory_item_id, 43,'TSC_Family')  as  TSC_Family "+    	 //20141127 liling add column  			 
                 ",msi.segment1  \"料號\""+				 	 
                 ",msi.description \"品名\""+
                 ",wdj.start_quantity \"工單數量\""+
                 ",wro.segment1 \"使用晶片\""+
				 ",apps.tsc_get_wip_item_lot(wro.organization_id,wro.wip_entity_id,wro.inventory_item_id) \"晶片批號\""+
                 ",ml.MEANING \"狀態\""+
                 //",to_char(wdj.scheduled_start_date,'yyyy-mm-dd') \"開工日\""+
                 ",to_char(wdj.due_date,'yyyy-mm-dd') \"預計完工日\""+
			     ",to_char(wdj.date_completed,'yyyy-mm-dd') \"實際完工日\""+
                 ",to_char(wdj.date_closed,'yyyy-mm-dd') \"關帳日\""+
                 ",wro.quantity_issued \"領料\""+
                 ",wp.\"切割_投入數\" as \"切割_投入數\""+
                 ",wp.\"切割_產出數\" as \"切割_產出數\""+
                 ",(round(wp.\"切割_良率\",4)*100)||'%' as \"切割_良率\""+
                 ",wp.\"切割_機器工時\" as \"切割_機器工時\""+
                 ",wp.\"切割_人工工時\" as \"切割_人工工時\""+
                 ",decode( wp.\"切割_投入數\",0,0,round(wp.\"切割_機器工時\" / wp.\"切割_投入數\",3)) as \"切割_機器_UPH\""+
                 ",decode( wp.\"切割_投入數\",0,0,round(wp.\"切割_人工工時\" / wp.\"切割_投入數\",3)) as \"切割_人工_UPH\""+
                 ",wp.\"焊接_投入數\" as \"焊接_投入數\""+
                 ",wp.\"焊接_產出數\" as \"焊接_產出數\""+
                 ",(round(wp.\"焊接_良率\",4)*100)||'%' as \"焊接_良率\""+
                 ",wp.\"焊接_機器工時\" as \"焊接_機器工時\""+
                 ",wp.\"焊接_人工工時\" as \"焊接_人工工時\""+
                 ",decode( wp.\"焊接_投入數\",0,0,round(wp.\"焊接_機器工時\" / wp.\"焊接_投入數\",3)) as \"焊接_機器_UPH\""+
                 ",decode( wp.\"焊接_投入數\",0,0,round(wp.\"焊接_人工工時\" / wp.\"焊接_投入數\",3)) as \"焊接_人工_UPH\"";
		if (!DEPTNO.equals("1"))
		{				 
        	sql +=",wp.\"酸洗_投入數\" as \"酸洗_投入數\""+
                 ",wp.\"酸洗_產出數\" as \"酸洗_產出數\""+
                 ",(round(wp.\"酸洗_良率\",4)*100)||'%' as \"酸洗_良率\""+
                 ",wp.\"酸洗_機器工時\" as \"酸洗_機器工時\""+
                 ",wp.\"酸洗_人工工時\" as \"酸洗_人工工時\""+
                 ",decode( wp.\"酸洗_投入數\",0,0,round(wp.\"酸洗_機器工時\" / wp.\"酸洗_投入數\",3)) as \"酸洗_機器_UPH\""+
                 ",decode( wp.\"酸洗_投入數\",0,0,round(wp.\"酸洗_人工工時\" / wp.\"酸洗_投入數\",3)) as \"酸洗_人工_UPH\""+
                 //",wp.\"清洗_投入數\" as \"清洗_投入數\""+
                 //",wp.\"清洗_產出數\" as \"清洗_產出數\""+
                 //",(round(wp.\"清洗_良率\",4)*100)||'%' as \"清洗_良率\""+
                 //",wp.\"清洗_機器工時\" as \"清洗_機器工時\""+
                 //",wp.\"清洗_人工工時\" as \"清洗_人工工時\""+
                 //",round(wp.\"清洗_機器工時\" / wp.\"清洗_投入數\",3) as \"清洗_機器_UPH\""+
                 //",round(wp.\"清洗_人工工時\" / wp.\"清洗_投入數\",3) as \"清洗_人工_UPH\""+
                 ",wp.\"梳條_投入數\" as \"梳條_投入數\""+
                 ",wp.\"梳條_產出數\" as \"梳條_產出數\""+
                 ",(round(wp.\"梳條_良率\",4)*100)||'%' as \"梳條_良率\""+
                 ",wp.\"梳條_機器工時\" as \"梳條_機器工時\""+
                 ",wp.\"梳條_人工工時\" as \"梳條_人工工時\""+
                 ",decode( wp.\"梳條_投入數\",0,0,round(wp.\"梳條_機器工時\" / wp.\"梳條_投入數\",3)) as \"梳條_機器_UPH\""+
                 ",decode( wp.\"梳條_投入數\",0,0,round(wp.\"梳條_人工工時\" / wp.\"梳條_投入數\",3)) as \"梳條_人工_UPH\""+
                 //",wp.\"上玻粉_投入數\" as \"上玻粉_投入數\""+
                 //",wp.\"上玻粉_產出數\" as \"上玻粉_產出數\""+
                 //",(round(wp.\"上玻粉_良率\",4)*100)||'%' as \"上玻粉_良率\""+
                 //",wp.\"上玻粉_機器工時\" as \"上玻粉_機器工時\""+
                 //",wp.\"上玻粉_人工工時\" as \"上玻粉_人工工時\""+
                 //",round(wp.\"上玻粉_機器工時\" / wp.\"上玻粉_投入數\",3) as \"上玻粉_機器_UPH\""+
                 //",round(wp.\"上玻粉_人工工時\" / wp.\"上玻粉_投入數\",3) as \"上玻粉_人工_UPH\""+
                 ",wp.\"上膠_投入數\" as \"上膠_投入數\""+
                 ",wp.\"上膠_產出數\" as \"上膠_產出數\""+
                 ",(round(wp.\"上膠_良率\",4)*100)||'%' as \"上膠_良率\""+
                 ",wp.\"上膠_機器工時\" as \"上膠_機器工時\""+
                 ",wp.\"上膠_人工工時\" as \"上膠_人工工時\""+
                 ",decode( wp.\"上膠_投入數\",0,0,round(wp.\"上膠_機器工時\" / wp.\"上膠_投入數\",3)) as \"上膠_機器_UPH\""+
                 ",decode( wp.\"上膠_投入數\",0,0,round(wp.\"上膠_人工工時\" / wp.\"上膠_投入數\",3)) as \"上膠_人工_UPH\"";
		}
                 //",wp.\"燒結_投入數\" as \"燒結_投入數\""+
                 //",wp.\"燒結_產出數\" as \"燒結_產出數\""+
                 //",(round(wp.\"燒結_良率\",4)*100)||'%' as \"燒結_良率\""+
                 //",wp.\"燒結_機器工時\" as \"燒結_機器工時\""+
                 //",wp.\"燒結_人工工時\" as \"燒結_人工工時\""+
                 //",decode( wp.\"燒結_投入數\",0,0,round(wp.\"燒結_機器工時\" / wp.\"燒結_投入數\",3)) as \"燒結_機器_UPH\""+
                 //",decode( wp.\"燒結_投入數\",0,0,round(wp.\"燒結_人工工時\" / wp.\"燒結_投入數\",3)) as \"燒結_人工_UPH\""+
                 //",wp.\"拋光_投入數\" as \"拋光_投入數\""+
                 //",wp.\"拋光_產出數\" as \"拋光_產出數\""+
                 //",(round(wp.\"拋光_良率\",4)*100)||'%' as \"拋光_良率\""+
                 //",wp.\"拋光_機器工時\" as \"拋光_機器工時\""+
                 //",wp.\"拋光_人工工時\" as \"拋光_人工工時\""+
                 //",decode( wp.\"拋光_投入數\",0,0,round(wp.\"拋光_機器工時\" / wp.\"拋光_投入數\",3)) as \"拋光_機器_UPH\""+
                 //",decode( wp.\"拋光_投入數\",0,0,round(wp.\"拋光_人工工時\" / wp.\"拋光_投入數\",3)) as \"拋光_人工_UPH\""+
        sql +=   ",wp.\"壓模_投入數\" as \"壓模_投入數\""+
                 ",wp.\"壓模_產出數\" as \"壓模_產出數\""+
                 ",(round(wp.\"壓模_良率\",4)*100)||'%' as \"壓模_良率\""+
                 ",wp.\"壓模_機器工時\" as \"壓模_機器工時\""+
                 ",wp.\"壓模_人工工時\" as \"壓模_人工工時\""+
                 ",decode( wp.\"壓模_投入數\",0,0,round(wp.\"壓模_機器工時\" / wp.\"壓模_投入數\",3)) as \"壓模_機器_UPH\""+
                 ",decode( wp.\"壓模_投入數\",0,0,round(wp.\"壓模_人工工時\" / wp.\"壓模_投入數\",3)) as \"壓模_人工_UPH\"";
		if (!DEPTNO.equals("1"))
		{				 
        	sql +=",wp.\"去膠_投入數\" as \"去膠_投入數\""+
                 ",wp.\"去膠_產出數\" as \"去膠_產出數\""+
                 ",(round(wp.\"去膠_良率\",4)*100)||'%' as \"去膠_良率\""+
                 ",wp.\"去膠_機器工時\" as \"去膠_機器工時\""+
                 ",wp.\"去膠_人工工時\" as \"去膠_人工工時\""+
                 ",decode( wp.\"去膠_投入數\",0,0,round(wp.\"去膠_機器工時\" / wp.\"去膠_投入數\",3)) as \"去膠_機器_UPH\""+
                 ",decode( wp.\"去膠_投入數\",0,0,round(wp.\"去膠_人工工時\" / wp.\"去膠_投入數\",3)) as \"去膠_人工_UPH\""+
                 ",wp.\"自動彎角_投入數\" as \"自動彎角_投入數\""+
                 ",wp.\"自動彎角_產出數\" as \"自動彎角_產出數\""+
                 ",(round(wp.\"自動彎角_良率\",4)*100)||'%' as \"自動彎角_良率\""+
                 ",wp.\"自動彎角_機器工時\" as \"自動彎角_機器工時\""+
                 ",wp.\"自動彎角_人工工時\" as \"自動彎角_人工工時\""+
                 ",decode( wp.\"自動彎角_投入數\",0,0,round(wp.\"自動彎角_機器工時\" / wp.\"自動彎角_投入數\",3)) as \"自動彎角_機器_UPH\""+
                 ",decode( wp.\"自動彎角_投入數\",0,0,round(wp.\"自動彎角_人工工時\" / wp.\"自動彎角_投入數\",3)) as \"自動彎角_人工_UPH\""+
                 ",wp.\"水刀_投入數\" as \"水刀_投入數\""+
                 ",wp.\"水刀_產出數\" as \"水刀_產出數\""+
                 ",(round(wp.\"水刀_良率\",4)*100)||'%' as \"水刀_良率\""+
                 ",wp.\"水刀_機器工時\" as \"水刀_機器工時\""+
                 ",wp.\"水刀_人工工時\" as \"水刀_人工工時\""+
                 ",decode( wp.\"水刀_投入數\",0,0,round(wp.\"水刀_機器工時\" / wp.\"水刀_投入數\",3)) as \"水刀_機器_UPH\""+
                 ",decode( wp.\"水刀_投入數\",0,0,round(wp.\"水刀_人工工時\" / wp.\"水刀_投入數\",3)) as \"水刀_人工_UPH\""+
                 ",wp.\"IR-Reflow_投入數\" as \"IR-Reflow_投入數\""+
                 ",wp.\"IR-Reflow_產出數\" as \"IR-Reflow_產出數\""+
                 ",(round(wp.\"IR-Reflow_良率\",4)*100)||'%' as \"IR-Reflow_良率\""+
                 ",wp.\"IR-Reflow_機器工時\" as \"IR-Reflow_機器工時\""+
                 ",wp.\"IR-Reflow_人工工時\" as \"IR-Reflow_人工工時\""+
                 ",decode( wp.\"IR-Reflow_投入數\",0,0,round(wp.\"IR-Reflow_機器工時\" / wp.\"IR-Reflow_投入數\",3)) as \"IR-Reflow_機器_UPH\""+
                 ",decode( wp.\"IR-Reflow_投入數\",0,0,round(wp.\"IR-Reflow_人工工時\" / wp.\"IR-Reflow_投入數\",3)) as \"IR-Reflow_人工_UPH\""+
                 ",wp.\"切斷_投入數\" as \"切斷_投入數\""+
                 ",wp.\"切斷_產出數\" as \"切斷_產出數\""+
                 ",(round(wp.\"切斷_良率\",4)*100)||'%' as \"切斷_良率\""+
                 ",wp.\"切斷_機器工時\" as \"切斷_機器工時\""+
                 ",wp.\"切斷_人工工時\" as \"切斷_人工工時\""+
                 ",decode( wp.\"切斷_投入數\",0,0,round(wp.\"切斷_機器工時\" / wp.\"切斷_投入數\",3)) as \"切斷_機器_UPH\""+
                 ",decode( wp.\"切斷_投入數\",0,0,round(wp.\"切斷_人工工時\" / wp.\"切斷_投入數\",3)) as \"切斷_人工_UPH\""+
                 ",wp.\"灌膠_投入數\" as \"灌膠_投入數\""+
                 ",wp.\"灌膠_產出數\" as \"灌膠_產出數\""+
                 ",(round(wp.\"灌膠_良率\",4)*100)||'%' as \"灌膠_良率\""+
                 ",wp.\"灌膠_機器工時\" as \"灌膠_機器工時\""+
                 ",wp.\"灌膠_人工工時\" as \"灌膠_人工工時\""+
                 ",decode( wp.\"灌膠_投入數\",0,0,round(wp.\"灌膠_機器工時\" / wp.\"灌膠_投入數\",3)) as \"灌膠_機器_UPH\""+
                 ",decode( wp.\"灌膠_投入數\",0,0,round(wp.\"灌膠_人工工時\" / wp.\"灌膠_投入數\",3)) as \"灌膠_人工_UPH\"";
		}
		sql +=   ",wp.\"德錫外包_投入數\" as \"德錫外包_投入數\""+
                 ",wp.\"德錫外包_產出數\" as \"德錫外包_產出數\""+
                 ",(round(wp.\"德錫外包_良率\",4) *100)||'%' as \"德錫外包_良率\""+
                 ",case when (wp.\"切割_良率\"+wp.\"焊接_良率\"+wp.\"酸洗_良率\"+wp.\"清洗_良率\"+wp.\"梳條_良率\"+wp.\"上玻粉_良率\""+
                 "+wp.\"上膠_良率\"+wp.\"燒結_良率\"+wp.\"拋光_良率\"+wp.\"壓模_良率\"+wp.\"去膠_良率\"+wp.\"自動彎角_良率\""+
                 "+wp.\"水刀_良率\"+wp.\"IR-Reflow_良率\"+wp.\"切斷_良率\"+wp.\"灌膠_良率\"+wp.\"德錫外包_良率\") =0 then '0%'"+
                 " else "+
                 "(round(decode(wp.\"切割_良率\",0,1,wp.\"切割_良率\") * decode(wp.\"焊接_良率\",0,1,wp.\"焊接_良率\")"+
                 " * decode(wp.\"酸洗_良率\",0,1,wp.\"酸洗_良率\") * decode(wp.\"清洗_良率\",0,1,wp.\"清洗_良率\")"+
                 " * decode(wp.\"梳條_良率\",0,1,wp.\"梳條_良率\") * decode(wp.\"上玻粉_良率\",0,1,wp.\"上玻粉_良率\")"+
                 " * decode(wp.\"上膠_良率\",0,1,wp.\"上膠_良率\") * decode(wp.\"燒結_良率\",0,1,wp.\"燒結_良率\")"+
                 " * decode(wp.\"拋光_良率\",0,1,wp.\"拋光_良率\") * decode(wp.\"壓模_良率\",0,1,wp.\"壓模_良率\")"+
                 " * decode(wp.\"去膠_良率\",0,1,wp.\"去膠_良率\") * decode(wp.\"自動彎角_良率\",0,1,wp.\"自動彎角_良率\")"+
                 " * decode(wp.\"水刀_良率\",0,1,wp.\"水刀_良率\") * decode(wp.\"IR-Reflow_良率\",0,1,wp.\"IR-Reflow_良率\")"+
                 " * decode(wp.\"切斷_良率\",0,1,wp.\"切斷_良率\") * decode(wp.\"灌膠_良率\",0,1,wp.\"灌膠_良率\")"+
                 " * decode(wp.\"德錫外包_良率\",0,1,wp.\"德錫外包_良率\"),4)*100)||'%' end as \"TTL\","+
                 " (ROUND(wp.\"切割_投入數\"/decode(wro.quantity_issued,0,1,wro.quantity_issued),4)*100)||'%' AS \"盈虧率\""+
                 ",(decode( wp.\"切割_投入數\",0,0,round(wp.\"切割_機器工時\" / wp.\"切割_投入數\",3)) + "+
                 " decode( wp.\"焊接_投入數\",0,0,round(wp.\"焊接_機器工時\" / wp.\"焊接_投入數\",3)) + "+
                 " decode( wp.\"酸洗_投入數\",0,0,round(wp.\"酸洗_機器工時\" / wp.\"酸洗_投入數\",3)) + "+
                 " decode( wp.\"清洗_投入數\",0,0,round(wp.\"清洗_機器工時\" / wp.\"清洗_投入數\",3)) + "+
                 " decode( wp.\"梳條_投入數\",0,0,round(wp.\"梳條_機器工時\" / wp.\"梳條_投入數\",3)) + "+
                 " decode( wp.\"上玻粉_投入數\",0,0,round(wp.\"上玻粉_機器工時\" / wp.\"上玻粉_投入數\",3)) + "+
                 " decode( wp.\"上膠_投入數\",0,0,round(wp.\"上膠_機器工時\" / wp.\"上膠_投入數\",3)) + "+
                 " decode( wp.\"燒結_投入數\",0,0,round(wp.\"燒結_機器工時\" / wp.\"燒結_投入數\",3)) + "+
                 " decode( wp.\"拋光_投入數\",0,0,round(wp.\"拋光_機器工時\" / wp.\"拋光_投入數\",3)) + "+
                 " decode( wp.\"壓模_投入數\",0,0,round(wp.\"壓模_機器工時\" / wp.\"壓模_投入數\",3)) + "+
                 " decode( wp.\"去膠_投入數\",0,0,round(wp.\"去膠_機器工時\" / wp.\"去膠_投入數\",3)) + "+
                 " decode( wp.\"自動彎角_投入數\",0,0,round(wp.\"自動彎角_機器工時\" / wp.\"自動彎角_投入數\",3)) + "+
                 " decode( wp.\"水刀_投入數\",0,0,round(wp.\"水刀_機器工時\" / wp.\"水刀_投入數\",3)) + "+
                 " decode( wp.\"IR-Reflow_投入數\",0,0,round(wp.\"IR-Reflow_機器工時\" / wp.\"IR-Reflow_投入數\",3)) + "+
                 " decode( wp.\"切斷_投入數\",0,0,round(wp.\"切斷_機器工時\" / wp.\"切斷_投入數\",3)) + "+
                 " decode( wp.\"灌膠_投入數\",0,0,round(wp.\"灌膠_機器工時\" / wp.\"灌膠_投入數\",3)) "+
                 ") as \"機器_TTLUPH\" "+
                 ",(decode( wp.\"切割_投入數\",0,0,round(wp.\"切割_人工工時\" / wp.\"切割_投入數\",3)) + "+
                 " decode( wp.\"焊接_投入數\",0,0,round(wp.\"焊接_人工工時\" / wp.\"焊接_投入數\",3)) + "+
                 " decode( wp.\"酸洗_投入數\",0,0,round(wp.\"酸洗_人工工時\" / wp.\"酸洗_投入數\",3)) + "+
                 " decode( wp.\"清洗_投入數\",0,0,round(wp.\"清洗_人工工時\" / wp.\"清洗_投入數\",3)) + "+
                 " decode( wp.\"梳條_投入數\",0,0,round(wp.\"梳條_人工工時\" / wp.\"梳條_投入數\",3)) + "+
                 " decode( wp.\"上玻粉_投入數\",0,0,round(wp.\"上玻粉_人工工時\" / wp.\"上玻粉_投入數\",3)) + "+
                 " decode( wp.\"上膠_投入數\",0,0,round(wp.\"上膠_人工工時\" / wp.\"上膠_投入數\",3)) + "+
                 " decode( wp.\"燒結_投入數\",0,0,round(wp.\"燒結_人工工時\" / wp.\"燒結_投入數\",3)) + "+
                 " decode( wp.\"拋光_投入數\",0,0,round(wp.\"拋光_人工工時\" / wp.\"拋光_投入數\",3)) + "+
                 " decode( wp.\"壓模_投入數\",0,0,round(wp.\"壓模_人工工時\" / wp.\"壓模_投入數\",3)) + "+
                 " decode( wp.\"去膠_投入數\",0,0,round(wp.\"去膠_人工工時\" / wp.\"去膠_投入數\",3)) + "+
                 " decode( wp.\"自動彎角_投入數\",0,0,round(wp.\"自動彎角_人工工時\" / wp.\"自動彎角_投入數\",3)) + "+
                 " decode( wp.\"水刀_投入數\",0,0,round(wp.\"水刀_人工工時\" / wp.\"水刀_投入數\",3)) + "+
                 " decode( wp.\"IR-Reflow_投入數\",0,0,round(wp.\"IR-Reflow_人工工時\" / wp.\"IR-Reflow_投入數\",3)) + "+
                 " decode( wp.\"切斷_投入數\",0,0,round(wp.\"切斷_人工工時\" / wp.\"切斷_投入數\",3)) + "+
                 " decode( wp.\"灌膠_投入數\",0,0,round(wp.\"灌膠_人工工時\" / wp.\"灌膠_投入數\",3)) "+
                 " ) as \"人工_TTLUPH\" "+				 
		         " from  wip_discrete_jobs wdj "+
                 ",wip_entities we "+
                 ",mtl_system_items msi "+
                 ",mfg_lookups ml "+
                 ",(select wro.organization_id,wro.wip_entity_id,wro.inventory_item_id,msi.segment1,wro.quantity_issued from wip_requirement_operations wro ,mtl_system_items msi "+
                 " where wro.organization_id = msi.organization_id "+
                 " and wro.inventory_item_id = msi.inventory_item_id "+
                 " and msi.item_type in ('WAFER','CHIP','SA','DICE') "+
                 " ) wro "+
                 ",( select a.WIP_ENTITY_ID,a.ORGANIZATION_ID "+
                 ",sum(\"切割_投入數\") as \"切割_投入數\" "+
                 ",sum(\"切割_產出數\") as \"切割_產出數\" "+
                 ",sum(\"切割_良率\") as \"切割_良率\" "+
                 ",sum(\"切割_機器工時\") as \"切割_機器工時\" "+
                 ",sum(\"切割_人工工時\") as \"切割_人工工時\" "+
                 ",sum(\"焊接_投入數\") as \"焊接_投入數\" "+
                 ",sum(\"焊接_產出數\") as \"焊接_產出數\" "+
                 ",sum(\"焊接_良率\") as \"焊接_良率\" "+
                 ",sum(\"焊接_機器工時\") as \"焊接_機器工時\" "+
                 ",sum(\"焊接_人工工時\") as \"焊接_人工工時\" "+
                 ",sum(\"酸洗_投入數\") as \"酸洗_投入數\" "+
                 ",sum(\"酸洗_產出數\") as \"酸洗_產出數\" "+
                 ",sum(\"酸洗_良率\") as \"酸洗_良率\" "+
                 ",sum(\"酸洗_機器工時\") as \"酸洗_機器工時\" "+
                 ",sum(\"酸洗_人工工時\") as \"酸洗_人工工時\" "+
                 ",sum(\"清洗_投入數\") as \"清洗_投入數\" "+
                 ",sum(\"清洗_產出數\") as \"清洗_產出數\" "+
                 ",sum(\"清洗_良率\") as \"清洗_良率\" "+
                 ",sum(\"清洗_機器工時\") as \"清洗_機器工時\" "+
                 ",sum(\"清洗_人工工時\") as \"清洗_人工工時\" "+
                 ",sum(\"梳條_投入數\") as \"梳條_投入數\" "+
                 ",sum(\"梳條_產出數\") as \"梳條_產出數\" "+
                 ",sum(\"梳條_良率\") as \"梳條_良率\" "+
                 ",sum(\"梳條_機器工時\") as \"梳條_機器工時\" "+
                 ",sum(\"梳條_人工工時\") as \"梳條_人工工時\" "+
                 ",sum(\"上玻粉_投入數\") as \"上玻粉_投入數\" "+
                 ",sum(\"上玻粉_產出數\") as \"上玻粉_產出數\" "+
                 ",sum(\"上玻粉_良率\") as \"上玻粉_良率\" "+
                 ",sum(\"上玻粉_機器工時\") as \"上玻粉_機器工時\" "+
                 ",sum(\"上玻粉_人工工時\") as \"上玻粉_人工工時\" "+
                 ",sum(\"上膠_投入數\") as \"上膠_投入數\" "+
                 ",sum(\"上膠_產出數\") as \"上膠_產出數\" "+
                 ",sum(\"上膠_良率\") as \"上膠_良率\" "+
                 ",sum(\"上膠_機器工時\") as \"上膠_機器工時\" "+
                 ",sum(\"上膠_人工工時\") as \"上膠_人工工時\" "+
                 ",sum(\"燒結_投入數\") as \"燒結_投入數\" "+
                 ",sum(\"燒結_產出數\") as \"燒結_產出數\" "+
                 ",sum(\"燒結_良率\") as \"燒結_良率\" "+
                 ",sum(\"燒結_機器工時\") as \"燒結_機器工時\" "+
                 ",sum(\"燒結_人工工時\") as \"燒結_人工工時\" "+
                 ",sum(\"拋光_投入數\") as \"拋光_投入數\" "+
                 ",sum(\"拋光_產出數\") as \"拋光_產出數\" "+
                 ",sum(\"拋光_良率\") as \"拋光_良率\" "+
                 ",sum(\"拋光_機器工時\") as \"拋光_機器工時\" "+
                 ",sum(\"拋光_人工工時\") as \"拋光_人工工時\" "+
                 ",sum(\"壓模_投入數\") as \"壓模_投入數\" "+
                 ",sum(\"壓模_產出數\") as \"壓模_產出數\" "+
                 ",sum(\"壓模_良率\") as \"壓模_良率\" "+
                 ",sum(\"壓模_機器工時\") as \"壓模_機器工時\" "+
                 ",sum(\"壓模_人工工時\") as \"壓模_人工工時\" "+
                 ",sum(\"去膠_投入數\") as \"去膠_投入數\" "+
                 ",sum(\"去膠_產出數\") as \"去膠_產出數\" "+
                 ",sum(\"去膠_良率\") as \"去膠_良率\" "+
                 ",sum(\"去膠_機器工時\") as \"去膠_機器工時\" "+
                 ",sum(\"去膠_人工工時\") as \"去膠_人工工時\" "+
                 ",sum(\"自動彎角_投入數\") as \"自動彎角_投入數\" "+
                 ",sum(\"自動彎角_產出數\") as \"自動彎角_產出數\" "+
                 ",sum(\"自動彎角_良率\") as \"自動彎角_良率\" "+
                 ",sum(\"自動彎角_機器工時\") as \"自動彎角_機器工時\" "+
                 ",sum(\"自動彎角_人工工時\") as \"自動彎角_人工工時\" "+
                 ",sum(\"水刀_投入數\") as \"水刀_投入數\" "+
                 ",sum(\"水刀_產出數\") as \"水刀_產出數\" "+
                 ",sum(\"水刀_良率\") as \"水刀_良率\" "+
                 ",sum(\"水刀_機器工時\") as \"水刀_機器工時\" "+
                 ",sum(\"水刀_人工工時\") as \"水刀_人工工時\" "+
                 ",sum(\"IR-Reflow_投入數\") as \"IR-Reflow_投入數\" "+
                 ",sum(\"IR-Reflow_產出數\") as \"IR-Reflow_產出數\" "+
                 ",sum(\"IR-Reflow_良率\") as \"IR-Reflow_良率\" "+
                 ",sum(\"IR-Reflow_機器工時\") as \"IR-Reflow_機器工時\" "+
                 ",sum(\"IR-Reflow_人工工時\") as \"IR-Reflow_人工工時\" "+
                 ",sum(\"切斷_投入數\") as \"切斷_投入數\" "+
                 ",sum(\"切斷_產出數\") as \"切斷_產出數\" "+
                 ",sum(\"切斷_良率\") as \"切斷_良率\" "+
                 ",sum(\"切斷_機器工時\") as \"切斷_機器工時\" "+
                 ",sum(\"切斷_人工工時\") as \"切斷_人工工時\" "+
                 ",sum(\"灌膠_投入數\") as \"灌膠_投入數\" "+
                 ",sum(\"灌膠_產出數\") as \"灌膠_產出數\" "+
                 ",sum(\"灌膠_良率\") as \"灌膠_良率\" "+
                 ",sum(\"灌膠_機器工時\") as \"灌膠_機器工時\" "+
                 ",sum(\"灌膠_人工工時\") as \"灌膠_人工工時\" "+
                 ",sum(\"德錫外包_投入數\") as \"德錫外包_投入數\" "+
                 ",sum(\"德錫外包_產出數\") as \"德錫外包_產出數\" "+
                 ",sum(\"德錫外包_良率\") as \"德錫外包_良率\" "+
                 ",case when sum(\"切割_投入數\") > 0 then sum(\"切割_投入數\") "+
                 " when sum(\"焊接_投入數\")>0 then sum(\"焊接_投入數\") "+
                 " when sum(\"酸洗_投入數\") >0 then sum(\"酸洗_投入數\") "+
                 " when sum(\"清洗_投入數\") >0 then sum(\"清洗_投入數\") "+
                 " when sum(\"梳條_投入數\") >0 then sum(\"梳條_投入數\") "+
                 " when sum(\"上玻粉_投入數\")>0 then sum(\"上玻粉_投入數\") "+
                 " when sum(\"上膠_投入數\") >0 then sum(\"上膠_投入數\") "+
                 " when sum(\"燒結_投入數\") >0 then sum(\"燒結_投入數\") "+
                 " when sum(\"拋光_投入數\") >0 then sum(\"拋光_投入數\") "+
                 " when sum(\"壓模_投入數\") >0 then sum(\"壓模_投入數\") "+
                 " when sum(\"去膠_投入數\") >0 then sum(\"去膠_投入數\") "+
                 " when sum(\"自動彎角_投入數\") >0 then sum(\"自動彎角_投入數\") "+
                 " when sum(\"水刀_投入數\") >0 then sum(\"水刀_投入數\") "+
                 " when sum(\"IR-Reflow_投入數\") >0 then sum(\"IR-Reflow_投入數\") "+
                 " when sum(\"切斷_投入數\") >0 then sum(\"切斷_投入數\") "+
                 " when sum(\"灌膠_投入數\") >0 then sum(\"灌膠_投入數\") "+
                 " when sum(\"德錫外包_投入數\") >0 then sum(\"德錫外包_投入數\") "+
                 " else 0 end as FIR_INPUT_QTY "+
                 ",case when sum(\"德錫外包_產出數\") >0 then sum(\"德錫外包_產出數\") "+
                 " when sum(\"灌膠_產出數\") >0 then sum(\"灌膠_產出數\") "+
                 " when sum(\"切斷_產出數\") >0 then sum(\"切斷_產出數\") "+
                 " when sum(\"IR-Reflow_產出數\") >0 then sum(\"IR-Reflow_產出數\") "+
                 " when sum(\"水刀_產出數\") >0 then sum(\"水刀_產出數\")  "+
                 " when sum(\"自動彎角_產出數\") >0 then sum(\"自動彎角_產出數\") "+
                 " when sum(\"去膠_產出數\") >0 then sum(\"去膠_產出數\") "+
                 " when sum(\"壓模_產出數\") >0 then sum(\"壓模_產出數\") "+
                 " when sum(\"拋光_產出數\") >0 then sum(\"拋光_產出數\") "+
                 " when sum(\"燒結_產出數\") >0 then sum(\"燒結_產出數\") "+
                 " when sum(\"上膠_產出數\") >0 then sum(\"上膠_產出數\") "+
                 " when sum(\"上玻粉_產出數\")>0 then sum(\"上玻粉_產出數\") "+
                 " when sum(\"梳條_產出數\") >0 then sum(\"梳條_產出數\") "+
                 " when sum(\"清洗_產出數\") >0 then sum(\"清洗_產出數\") "+
                 " when sum(\"酸洗_產出數\") >0 then sum(\"酸洗_產出數\") "+
                 " when sum(\"焊接_產出數\")>0 then sum(\"焊接_產出數\") "+
                 " when sum(\"切割_產出數\") > 0 then sum(\"切割_產出數\") "+
                 " else 0 end as LST_OUTPUT_QTY "+
                 " from ("+
                 "select wp.WIP_ENTITY_ID,"+
                    " wp.ORGANIZATION_ID,"+
                    " case when substr(bso.operation_code,2,3) ='010' then wp.quantity_completed else 0 end as \"切割_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='010' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"切割_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='010' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"切割_良率\","+
                    " case when substr(bso.operation_code,2,3) ='010' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"切割_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='010' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"切割_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='020' then wp.quantity_completed else 0 end as \"焊接_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='020' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"焊接_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='020' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"焊接_良率\","+
                    " case when substr(bso.operation_code,2,3) ='020' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"焊接_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='020' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"焊接_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='030' then wp.quantity_completed else 0 end as \"酸洗_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='030' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"酸洗_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='030' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"酸洗_良率\","+
                    " case when substr(bso.operation_code,2,3) ='030' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"酸洗_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='030' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"酸洗_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='035' then wp.quantity_completed else 0 end as \"清洗_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='035' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"清洗_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='035' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"清洗_良率\","+
                    " case when substr(bso.operation_code,2,3) ='035' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"清洗_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='035' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"清洗_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='040' then wp.quantity_completed else 0 end as \"梳條_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='040' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"梳條_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='040' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"梳條_良率\","+
                    " case when substr(bso.operation_code,2,3) ='040' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"梳條_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='040' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"梳條_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='041' then wp.quantity_completed else 0 end as \"上玻粉_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='041' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"上玻粉_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='041' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"上玻粉_良率\","+
                    " case when substr(bso.operation_code,2,3) ='041' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"上玻粉_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='041' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"上玻粉_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='043' then wp.quantity_completed else 0 end as \"上膠_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='043' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"上膠_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='043' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"上膠_良率\","+
                    " case when substr(bso.operation_code,2,3) ='043' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"上膠_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='043' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"上膠_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='045' then wp.quantity_completed else 0 end as \"燒結_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='045' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"燒結_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='045' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"燒結_良率\","+
                    " case when substr(bso.operation_code,2,3) ='045' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"燒結_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='045' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"燒結_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='047' then wp.quantity_completed else 0 end as \"拋光_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='047' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"拋光_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='047' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"拋光_良率\","+
                    " case when substr(bso.operation_code,2,3) ='047' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"拋光_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='047' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"拋光_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='050' then wp.quantity_completed else 0 end as \"壓模_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='050'then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"壓模_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='050'then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"壓模_良率\","+
                    " case when substr(bso.operation_code,2,3) ='050' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"壓模_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='050' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"壓模_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='051' then wp.quantity_completed else 0 end as \"去膠_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='051' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"去膠_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='051' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"去膠_良率\","+
                    " case when substr(bso.operation_code,2,3) ='051' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"去膠_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='051' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"去膠_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='053' then wp.quantity_completed else 0 end as \"自動彎角_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='053' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"自動彎角_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='053' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"自動彎角_良率\","+
                    " case when substr(bso.operation_code,2,3) ='053' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"自動彎角_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='053' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"自動彎角_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='055' then wp.quantity_completed else 0 end as \"水刀_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='055' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"水刀_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='055' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"水刀_良率\","+
                    " case when substr(bso.operation_code,2,3) ='055' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"水刀_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='055' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"水刀_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='056' then wp.quantity_completed else 0 end as \"IR-Reflow_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='056' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"IR-Reflow_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='056' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"IR-Reflow_良率\","+
                    " case when substr(bso.operation_code,2,3) ='056' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"IR-Reflow_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='056' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"IR-Reflow_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='057' then wp.quantity_completed else 0 end as \"切斷_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='057' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"切斷_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='057' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"切斷_良率\","+
                    " case when substr(bso.operation_code,2,3) ='057' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"切斷_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='057' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"切斷_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='060' then wp.quantity_completed else 0 end as \"灌膠_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='060' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"灌膠_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='060' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"灌膠_良率\","+
                    " case when substr(bso.operation_code,2,3) ='060' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=1 ) else 0 end as \"灌膠_機器工時\","+
                    " case when substr(bso.operation_code,2,3) ='060' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
                    " where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
                    " and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
                    " and y.resource_type=2 ) else 0 end as \"灌膠_人工工時\","+
                    " case when substr(bso.operation_code,2,3) ='999' then wp.quantity_completed else 0 end as \"德錫外包_投入數\","+
                    " case when substr(bso.operation_code,2,3) ='999' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"德錫外包_產出數\","+
                    " case when substr(bso.operation_code,2,3) ='999' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"德錫外包_良率\""+
                    " from wip_operations wp,bom.bom_standard_operations bso"+
                    " where wp.organization_id = bso.organization_id"+
                    " and wp.standard_operation_id=bso.standard_operation_id"+
                    " and exists (select 1 from wip_discrete_jobs z "+
                    " where z.wip_entity_id= wp.wip_entity_id"+
                    " and z.ORGANIZATION_ID=wp.ORGANIZATION_ID";
		if (STATUS.equals("")||STATUS.equals("--"))
		{ 
			sql += " and z.status_type in (3,4,12)";
		}
		else if (STATUS.equals("OPEN"))
		{
			sql += " and z.status_type in (3,4)";
		}
		else if (STATUS.equals("CLOSED"))
		{
			sql += " and z.status_type =12";
		}              
		sql +=" and z.scheduled_start_date between trunc(to_date('"+SDATE+"','yyyy-mm-dd')) and trunc(to_date('"+EDATE+"','yyyy-mm-dd'))+0.99999"+
                    " )   "+             
                    " ) a"+
                    " group by a.WIP_ENTITY_ID,a.ORGANIZATION_ID) wp"+
                    " where we.organization_id = wdj.organization_id"+
                    " and we.organization_id = msi.organization_id"+
                    " and we.primary_item_id = msi.inventory_item_id"+
                    " and we.wip_entity_id = wdj.wip_entity_id  "+
                    " and we.organization_id=wro.organization_id"+
                    " and we.wip_entity_id=wro.wip_entity_id"+
                    " and we.organization_id in (326,327)"+
                    " and ml.lookup_type='WIP_JOB_STATUS'"+
                    " and wdj.status_type = ml.lookup_code"+
                    " and we.wip_entity_id = wp.WIP_ENTITY_ID"+
                    " and we.organization_id = wp.organization_id"+
                   // " and length(msi.segment1)=13"+   //20180104 liling for SA ITEM length > 13
				    " and msi.item_type ='SA' "+         //20180104 liling for SA ITEM length > 13
                    " and wdj.scheduled_start_date between trunc(to_date('"+SDATE+"','yyyy-mm-dd')) and trunc(to_date('"+EDATE+"','yyyy-mm-dd'))+0.99999";
		if (!DEPTNO.equals("") && !DEPTNO.equals("--")) sql += " and substr(we.wip_entity_name,2,1) ='"+ DEPTNO+"'";
		if (!ITEMNO.equals("")) sql += " and msi.segment1 like '%"+ITEMNO+"%'";
		if (!WIPNO.equals("")) sql += " and we.wip_entity_name ='" + WIPNO+"'";
		if (STATUS.equals("")||STATUS.equals("--"))
		{ 
			sql += " and wdj.status_type in (3,4,12)";
		}
		else if (STATUS.equals("OPEN"))
		{
			sql += " and wdj.status_type in (3,4)";
		}
		else if (STATUS.equals("CLOSED"))
		{
			sql += " and wdj.status_type =12";
		}
		sql +=" order by decode(we.organization_id,'326','Y1','327','Y2'),we.wip_entity_name";
	}
	else if (RPTTYPE.equals("2"))
	{
		sql = " select decode(we.organization_id,'326','Y1','327','Y2')  org"+
              ",we.wip_entity_name  \"工單號\""+
			  ",msi.segment1  \"料號\""+
              //",TSC_OM_CATEGORY(msi.inventory_item_id, msi.organization_id,'TSC_Package')  TSC_Package "+	 //20141127 liling add column  		
              //",TSC_OM_CATEGORY(msi.inventory_item_id, msi.organization_id,'TSC_Family')  TSC_Family "+		  //20141127 liling add column  			  
              ",TSC_INV_CATEGORY(msi.inventory_item_id, msi.organization_id,23)  TSC_Package "+	 //performance issue by Peggy 20201027	
              ",TSC_INV_CATEGORY(msi.inventory_item_id, msi.organization_id,21)  TSC_Family "+		 //performance issue by Peggy 20201027		  
              ",msi.description \"品名\""+
              ",wdj.start_quantity \"工單數量\""+
              ",wro.segment1 \"半成品\""+
			  ",apps.tsc_get_wip_item_lot(wro.organization_id,wro.wip_entity_id,wro.inventory_item_id) \"半成品批號\""+
              ",ml.MEANING \"狀態\""+
              //",to_char(wdj.scheduled_start_date,'yyyy-mm-dd') \"開工日\""+
              ",to_char(wdj.due_date,'yyyy-mm-dd') \"預計完工日\""+
			  ",to_char(wdj.date_completed,'yyyy-mm-dd') \"實際完工日\""+
              ",to_char(wdj.date_closed,'yyyy-mm-dd') \"關帳日\""+
              ",wro.quantity_issued \"領料\"";
		if (!DEPTNO.equals("1"))
		{			  
        	sql+=",wp.\"測分_投入數\" as \"測分_投入數\""+
              ",wp.\"測分_產出數\" as \"測分_產出數\""+
              ",(round(wp.\"測分_良率\",4)*100)||'%' as \"測分_良率\""+
              ",wp.\"測分_機器工時\" as \"測分_機器工時\""+
              ",wp.\"測分_人工工時\" as \"測分_人工工時\""+
              ",decode( wp.\"測分_投入數\",0,0,round(wp.\"測分_機器工時\" / wp.\"測分_投入數\",3)) as \"測分_機器_UPH\""+
              ",decode( wp.\"測分_投入數\",0,0,round(wp.\"測分_人工工時\" / wp.\"測分_投入數\",3)) as \"測分_人工_UPH\""+
              ",wp.\"印字_投入數\" as \"印字_投入數\""+
              ",wp.\"印字_產出數\" as \"印字_產出數\""+
              ",(round(wp.\"印字_良率\",4)*100)||'%' as \"印字_良率\""+
              ",wp.\"印字_機器工時\" as \"印字_機器工時\""+
              ",wp.\"印字_人工工時\" as \"印字_人工工時\""+
              ",decode( wp.\"印字_投入數\",0,0,round(wp.\"印字_機器工時\" / wp.\"印字_投入數\",3)) as \"印字_機器_UPH\""+
              ",decode( wp.\"印字_投入數\",0,0,round(wp.\"印字_人工工時\" / wp.\"印字_投入數\",3)) as \"印字_人工_UPH\""+
              ",wp.\"復測_投入數\" as \"復測_投入數\""+
              ",wp.\"復測_產出數\" as \"復測_產出數\""+
              ",(round(wp.\"復測_良率\",4)*100)||'%' as \"復測_良率\""+
              ",wp.\"復測_機器工時\" as \"復測_機器工時\""+
              ",wp.\"復測_人工工時\" as \"復測_人工工時\""+
              ",decode( wp.\"復測_投入數\",0,0,round(wp.\"復測_機器工時\" / wp.\"復測_投入數\",3)) as \"復測_機器_UPH\""+
              ",decode( wp.\"復測_投入數\",0,0,round(wp.\"復測_人工工時\" / wp.\"復測_投入數\",3)) as \"復測_人工_UPH\"";
		}
       	sql +=",wp.\"TMT.T_投入數\" as \"TMT.T_投入數\""+
              ",wp.\"TMT.T_產出數\" as \"TMT.T_產出數\""+
              ",(round(wp.\"TMT.T_良率\",4)*100)||'%' as \"TMT.T_良率\""+
              ",wp.\"TMT.T_機器工時\" as \"TMT.T_機器工時\""+
              ",wp.\"TMT.T_人工工時\" as \"TMT.T_人工工時\""+
              ",decode( wp.\"TMT.T_投入數\",0,0,round(wp.\"TMT.T_機器工時\" / wp.\"TMT.T_投入數\",3)) as \"TMT.T_機器_UPH\""+
              ",decode( wp.\"TMT.T_投入數\",0,0,round(wp.\"TMT.T_人工工時\" / wp.\"TMT.T_投入數\",3)) as \"TMT.T_人工_UPH\""+
              ",wp.\"彎腳_投入數\" as \"彎腳_投入數\""+
              ",wp.\"彎腳_產出數\" as \"彎腳_產出數\""+
              ",(round(wp.\"彎腳_良率\",4)*100)||'%' as \"彎腳_良率\""+
              ",wp.\"彎腳_機器工時\" as \"彎腳_機器工時\""+
              ",wp.\"彎腳_人工工時\" as \"彎腳_人工工時\""+
              ",decode( wp.\"彎腳_投入數\",0,0,round(wp.\"彎腳_機器工時\" / wp.\"彎腳_投入數\",3)) as \"彎腳_機器_UPH\""+
              ",decode( wp.\"彎腳_投入數\",0,0,round(wp.\"彎腳_人工工時\" / wp.\"彎腳_投入數\",3)) as \"彎腳_人工_UPH\""+
              ",wp.\"目檢_投入數\" as \"目檢_投入數\""+
              ",wp.\"目檢_產出數\" as \"目檢_產出數\""+
              ",(round(wp.\"目檢_良率\",4)*100)||'%' as \"目檢_良率\""+
              ",wp.\"目檢_機器工時\" as \"目檢_機器工時\""+
              ",wp.\"目檢_人工工時\" as \"目檢_人工工時\""+
              ",decode( wp.\"目檢_投入數\",0,0,round(wp.\"目檢_機器工時\" / wp.\"目檢_投入數\",3)) as \"目檢_機器_UPH\""+
              ",decode( wp.\"目檢_投入數\",0,0,round(wp.\"目檢_人工工時\" / wp.\"目檢_投入數\",3)) as \"目檢_人工_UPH\""+
              ",wp.\"包裝_投入數\" as \"包裝_投入數\""+
              ",wp.\"包裝_產出數\" as \"包裝_產出數\""+
              ",(round(wp.\"包裝_良率\",4)*100)||'%' as \"包裝_良率\""+
              ",wp.\"包裝_機器工時\" as \"包裝_機器工時\""+
              ",wp.\"包裝_人工工時\" as \"包裝_人工工時\""+
              ",decode( wp.\"包裝_投入數\",0,0,round(wp.\"包裝_機器工時\" / wp.\"包裝_投入數\",3)) as \"包裝_機器_UPH\""+
              ",decode( wp.\"包裝_投入數\",0,0,round(wp.\"包裝_人工工時\" / wp.\"包裝_投入數\",3)) as \"包裝_人工_UPH\""+
              ",case when (wp.\"測分_良率\"+wp.\"印字_良率\"+wp.\"復測_良率\"+wp.\"TMT.T_良率\"+wp.\"彎腳_良率\"+wp.\"目檢_良率\"+wp.\"包裝_良率\") =0 then '0%'"+
              " else "+
              "(round(decode(wp.\"測分_良率\",0,1,wp.\"測分_良率\")*decode(wp.\"印字_良率\",0,1,wp.\"印字_良率\")"+
              " * decode(wp.\"復測_良率\",0,1,wp.\"復測_良率\") * decode(wp.\"TMT.T_良率\",0,1,wp.\"TMT.T_良率\")"+
              " * decode(wp.\"彎腳_良率\",0,1,wp.\"彎腳_良率\") * decode(wp.\"目檢_良率\",0,1,wp.\"目檢_良率\")"+
              " * decode(wp.\"包裝_良率\",0,1,wp.\"包裝_良率\"),4)*100)||'%' end as \"TTL\","+
              " (ROUND(FIR_INPUT_QTY/decode(wro.quantity_issued,0,1,wro.quantity_issued),4)*100)||'%' AS \"盈虧率\""+
              ",(decode( wp.\"測分_投入數\",0,0,round(wp.\"測分_機器工時\" / wp.\"測分_投入數\",3)) +"+
              "decode( wp.\"印字_投入數\",0,0,round(wp.\"印字_機器工時\" / wp.\"印字_投入數\",3)) +"+
              "decode( wp.\"復測_投入數\",0,0,round(wp.\"復測_機器工時\" / wp.\"復測_投入數\",3)) +"+
              "decode( wp.\"TMT.T_投入數\",0,0,round(wp.\"TMT.T_機器工時\" / wp.\"TMT.T_投入數\",3)) +"+
              "decode( wp.\"彎腳_投入數\",0,0,round(wp.\"彎腳_機器工時\" / wp.\"彎腳_投入數\",3)) +"+
              "decode( wp.\"目檢_投入數\",0,0,round(wp.\"目檢_機器工時\" / wp.\"目檢_投入數\",3)) +"+
              "decode( wp.\"包裝_投入數\",0,0,round(wp.\"包裝_機器工時\" / wp.\"包裝_投入數\",3))) as \"機器_TTLUPH\""+
              ",(decode( wp.\"測分_投入數\",0,0,round(wp.\"測分_人工工時\" / wp.\"測分_投入數\",3)) +"+
              "decode( wp.\"印字_投入數\",0,0,round(wp.\"印字_人工工時\" / wp.\"印字_投入數\",3)) +"+
              "decode( wp.\"復測_投入數\",0,0,round(wp.\"復測_人工工時\" / wp.\"復測_投入數\",3)) +"+
              "decode( wp.\"TMT.T_投入數\",0,0,round(wp.\"TMT.T_人工工時\" / wp.\"TMT.T_投入數\",3)) +"+
              "decode( wp.\"彎腳_投入數\",0,0,round(wp.\"彎腳_人工工時\" / wp.\"彎腳_投入數\",3)) +"+
              "decode( wp.\"目檢_投入數\",0,0,round(wp.\"目檢_人工工時\" / wp.\"目檢_投入數\",3)) +"+
              "decode( wp.\"包裝_投入數\",0,0,round(wp.\"包裝_人工工時\" / wp.\"包裝_投入數\",3))) as \"人工_TTLUPH\""+
              " from wip_discrete_jobs wdj "+
              ",wip_entities we"+
              ",mtl_system_items msi"+
              ",mfg_lookups ml"+
              ",(select wro.organization_id,wro.wip_entity_id,wro.inventory_item_id,msi.segment1,wro.quantity_issued"+
              " from wip_requirement_operations wro ,mtl_system_items msi"+
              " where wro.organization_id = msi.organization_id"+
              " and wro.inventory_item_id = msi.inventory_item_id"+
              " and msi.item_type in ('WAFER','CHIP','SA','DICE')"+
              ") wro"+
              ",(select a.WIP_ENTITY_ID,a.ORGANIZATION_ID"+
              ",sum(\"測分_投入數\") as \"測分_投入數\""+
              ",sum(\"測分_產出數\") as \"測分_產出數\""+
              ",sum(\"測分_良率\") as \"測分_良率\""+
              ",sum(\"測分_機器工時\") as \"測分_機器工時\""+
              ",sum(\"測分_人工工時\") as \"測分_人工工時\""+
              ",sum(\"印字_投入數\") as \"印字_投入數\""+
              ",sum(\"印字_產出數\") as \"印字_產出數\""+
              ",sum(\"印字_良率\") as \"印字_良率\""+
              ",sum(\"印字_機器工時\") as \"印字_機器工時\""+
              ",sum(\"印字_人工工時\") as \"印字_人工工時\""+
              ",sum(\"復測_投入數\") as \"復測_投入數\""+
              ",sum(\"復測_產出數\") as \"復測_產出數\""+
              ",sum(\"復測_良率\") as \"復測_良率\""+
              ",sum(\"復測_機器工時\") as \"復測_機器工時\""+
              ",sum(\"復測_人工工時\") as \"復測_人工工時\""+
              ",sum(\"TMT.T_投入數\") as \"TMT.T_投入數\""+
              ",sum(\"TMT.T_產出數\") as \"TMT.T_產出數\""+
              ",sum(\"TMT.T_良率\") as \"TMT.T_良率\""+
              ",sum(\"TMT.T_機器工時\") as \"TMT.T_機器工時\""+
              ",sum(\"TMT.T_人工工時\") as \"TMT.T_人工工時\""+
              ",sum(\"彎腳_投入數\") as \"彎腳_投入數\""+  
              ",sum(\"彎腳_產出數\") as \"彎腳_產出數\""+
              ",sum(\"彎腳_良率\") as \"彎腳_良率\""+
              ",sum(\"彎腳_機器工時\") as \"彎腳_機器工時\""+
              ",sum(\"彎腳_人工工時\") as \"彎腳_人工工時\""+
              ",sum(\"目檢_投入數\") as \"目檢_投入數\""+
              ",sum(\"目檢_產出數\") as \"目檢_產出數\""+
              ",sum(\"目檢_良率\") as \"目檢_良率\""+
              ",sum(\"目檢_機器工時\") as \"目檢_機器工時\""+
              ",sum(\"目檢_人工工時\") as \"目檢_人工工時\""+
              ",sum(\"包裝_投入數\") as \"包裝_投入數\""+
              ",sum(\"包裝_產出數\") as \"包裝_產出數\""+
              ",sum(\"包裝_良率\") as \"包裝_良率\""+
              ",sum(\"包裝_機器工時\") as \"包裝_機器工時\""+
              ",sum(\"包裝_人工工時\") as \"包裝_人工工時\""+
              ",case when sum(\"測分_投入數\") > 0 then sum(\"測分_投入數\")"+
              " when sum(\"印字_投入數\")>0 then sum(\"印字_投入數\")"+
              " when sum(\"復測_投入數\") >0 then sum(\"復測_投入數\")"+
              " when sum(\"TMT.T_投入數\") >0 then  sum(\"TMT.T_投入數\")"+
              " when sum(\"彎腳_投入數\") >0 then sum(\"彎腳_投入數\")"+
              " when sum(\"目檢_投入數\")>0 then sum(\"目檢_投入數\")"+
              " when sum(\"包裝_投入數\") >0 then sum(\"包裝_投入數\")"+
              " else 0 end as FIR_INPUT_QTY"+
              ",case when sum(\"包裝_產出數\") >0 then sum(\"包裝_產出數\")"+
              " when sum(\"目檢_產出數\") >0 then sum(\"目檢_產出數\")"+
              " when sum(\"彎腳_產出數\") >0 then sum(\"彎腳_產出數\")"+
              " when sum(\"TMT.T_產出數\") >0 then sum(\"TMT.T_產出數\")"+
              " when sum(\"復測_產出數\") >0 then sum(\"復測_產出數\")"+
              " when sum(\"印字_產出數\") >0 then sum(\"印字_產出數\")"+
              " when sum(\"測分_產出數\") >0 then sum(\"測分_產出數\")"+
              " else 0 end as LST_OUTPUT_QTY"+
              " from ("+
              "       select wp.WIP_ENTITY_ID,wp.ORGANIZATION_ID,"+
              "       case when substr(bso.operation_code,2,3) ='100' then wp.quantity_completed else 0 end as \"測分_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='100' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"測分_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='100' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"測分_良率\","+
              "       case when substr(bso.operation_code,2,3) ='100' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"測分_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='100' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"測分_人工工時\","+
              "       case when substr(bso.operation_code,2,3) ='101' then wp.quantity_completed else 0 end as \"印字_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='101' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"印字_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='101' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"印字_良率\","+
              "       case when substr(bso.operation_code,2,3) ='101' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"印字_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='101' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"印字_人工工時\","+
              "       case when substr(bso.operation_code,2,3) ='103' then wp.quantity_completed else 0 end as \"復測_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='103' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"復測_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='103' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"復測_良率\","+
              "       case when substr(bso.operation_code,2,3) ='103' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"復測_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='103' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"復測_人工工時\","+
              "       case when substr(bso.operation_code,2,3) ='110' or substr(bso.operation_code,2,3) ='105' then wp.quantity_completed else 0 end as \"TMT.T_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='110' or substr(bso.operation_code,2,3) ='105' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"TMT.T_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='110' or substr(bso.operation_code,2,3) ='105' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"TMT.T_良率\","+
              "       case when substr(bso.operation_code,2,3) ='110' or substr(bso.operation_code,2,3) ='105' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"TMT.T_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='110' or substr(bso.operation_code,2,3) ='105' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"TMT.T_人工工時\","+
              "       case when substr(bso.operation_code,2,3) ='115' or substr(bso.operation_code,2,3) ='107' then wp.quantity_completed else 0 end as \"彎腳_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='115' or substr(bso.operation_code,2,3) ='107' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"彎腳_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='115' or substr(bso.operation_code,2,3) ='107' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"彎腳_良率\","+
              "       case when substr(bso.operation_code,2,3) ='115' or substr(bso.operation_code,2,3) ='107' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"彎腳_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='115' or substr(bso.operation_code,2,3) ='107' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"彎腳_人工工時\","+
              "       case when substr(bso.operation_code,2,3) ='120' then wp.quantity_completed else 0 end as \"目檢_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='120' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"目檢_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='120' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"目檢_良率\","+
              "       case when substr(bso.operation_code,2,3) ='120' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"目檢_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='120' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"目檢_人工工時\","+
              "       case when substr(bso.operation_code,2,3) ='140' then wp.quantity_completed else 0 end as \"包裝_投入數\","+
              "       case when substr(bso.operation_code,2,3) ='140' then wp.quantity_completed-wp.QUANTITY_SCRAPPED else 0 end as \"包裝_產出數\","+
              "       case when substr(bso.operation_code,2,3) ='140' then round(((wp.quantity_completed-wp.QUANTITY_SCRAPPED)/nvl(decode(wp.quantity_completed,0,1,wp.quantity_completed),1)),8) else 0 end as \"包裝_良率\","+
              "       case when substr(bso.operation_code,2,3) ='140' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=1 ) else 0 end as \"包裝_機器工時\","+
              "       case when substr(bso.operation_code,2,3) ='140' then (select sum(x.TRANSACTION_QUANTITY) TRANSACTION_QUANTITY  from wip_transactions x,bom.bom_resources y"+
              "       where wp.WIP_ENTITY_ID=x.WIP_ENTITY_ID and wp.organization_id=x.organization_id"+
              "       and wp.operation_seq_num=x.operation_seq_num and x.resource_id=y.resource_id"+
              "       and y.resource_type=2 ) else 0 end as \"包裝_人工工時\""+
              " from wip_operations wp,bom.bom_standard_operations bso"+
              " where wp.organization_id = bso.organization_id"+
              " and wp.standard_operation_id=bso.standard_operation_id"+
              " and exists (select 1 from wip_discrete_jobs z "+
              "         where z.wip_entity_id= wp.wip_entity_id"+
              "         and z.ORGANIZATION_ID=wp.ORGANIZATION_ID";
		if (STATUS.equals("")||STATUS.equals("--"))
		{ 
			sql += " and z.status_type in (3,4,12)";
		}
		else if (STATUS.equals("OPEN"))
		{
			sql += " and z.status_type in (3,4)";
		}
		else if (STATUS.equals("CLOSED"))
		{
			sql += " and z.status_type =12";
		}              
		sql +=" and z.scheduled_start_date between trunc(to_date('"+SDATE+"','yyyy-mm-dd')) and trunc(to_date('"+EDATE+"','yyyy-mm-dd'))+0.99999"+
              " ) "+           
              " ) a"+
              " group by a.WIP_ENTITY_ID,a.ORGANIZATION_ID) wp"+
              " where we.organization_id = wdj.organization_id"+
              " and we.organization_id = msi.organization_id"+
              " and we.primary_item_id = msi.inventory_item_id"+
              " and we.organization_id=wro.organization_id"+
              " and we.wip_entity_id=wro.wip_entity_id"+
              " and we.wip_entity_id = wdj.wip_entity_id"+  
              " and we.organization_id in (326,327)"+
              " and we.wip_entity_id = wp.WIP_ENTITY_ID"+
              " and we.organization_id = wp.organization_id"+
              //" and length(msi.segment1)=22"+
			  " and msi.item_type ='FG'"+ //modify by Peggy 20201027
              " and ml.lookup_type='WIP_JOB_STATUS'"+
              " and wdj.status_type = ml.lookup_code"+
              " and wdj.scheduled_start_date between trunc(to_date('"+SDATE+"','yyyy-mm-dd')) and trunc(to_date('"+EDATE+"','yyyy-mm-dd'))+0.99999";
		if (!DEPTNO.equals("") && !DEPTNO.equals("--")) sql += " and substr(we.wip_entity_name,2,1) ='"+ DEPTNO+"'";
		if (!ITEMNO.equals("")) sql += " and msi.segment1 like '%"+ITEMNO+"%'";
		if (!WIPNO.equals("")) sql += " and we.wip_entity_name ='" + WIPNO+"'";
		if (STATUS.equals("")||STATUS.equals("--"))
		{ 
			sql += " and wdj.status_type in (3,4,12)";
		}
		else if (STATUS.equals("OPEN"))
		{
			sql += " and wdj.status_type in (3,4)";
		}
		else if (STATUS.equals("CLOSED"))
		{
			sql += " and wdj.status_type =12";
		}
		sql +=" order by decode(we.organization_id,'326','Y1','327','Y2'),we.wip_entity_name";
	}
	//out.println(sql);
	int row =0,col=0,reccnt=0,station_seq=0;
	OutputStream os = null;	
	RPTName = "YEWWIP"+(RPTTYPE.equals("1")?"FE":"BE")+"Report";
	FileName = RPTName+"("+userID+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+")";
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	
	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);

	WritableCellFormat ACenterBL1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL1.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL1.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBL1.setWrap(true);	
	
	WritableCellFormat ACenterBL2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL2.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL2.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL2.setBackground(jxl.write.Colour.TURQUOISE); 
	ACenterBL2.setWrap(true);	

	WritableCellFormat ACenterBL3 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL3.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL3.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL3.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL3.setBackground(jxl.write.Colour.PINK2); 
	ACenterBL3.setWrap(true);	

	WritableCellFormat ACenterBL4 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL4.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL4.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL4.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL4.setBackground(jxl.write.Colour.YELLOW2); 
	ACenterBL4.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	Statement state=con.createStatement();     
    ResultSet rs=state.executeQuery(sql);
	while (rs.next())	
	{ 
		if (reccnt==0)
		{
			ResultSetMetaData md=rs.getMetaData();
			colcnt =md.getColumnCount();

			//報表種類
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row, "報表種類:"+(RPTTYPE.equals("1")?"前段":"後段")+"工令明細報表" , ALeftL));
			ws.setColumnView(col,22);	
			row++;
			
			//開工日
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row, "開工日期:" +SDATE+"~"+EDATE, ALeftL));
			ws.setColumnView(col,22);	
			row++;
			
			//部門別
			if (DEPTNO.equals("--")||DEPTNO.equals(""))
			{
				DEPTNAME="全部";
			}
			else if (DEPTNO.equals("1"))
			{
				DEPTNAME="製造一部";
			}
			else if (DEPTNO.equals("2"))
			{
				DEPTNAME="製造二部";
			}
			else if (DEPTNO.equals("3"))
			{
				DEPTNAME="製造三部";
			}			
			else
			{
				DEPTNAME=DEPTNO;
			}
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row, "部門別:"+DEPTNAME , ALeftL));
			ws.setColumnView(col,20);	
			row++;

			//工令號
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row, "工令號:"+WIPNO , ALeftL));
			ws.setColumnView(col,20);	
			row++;
			
			//料號
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row, "料號:"+ITEMNO , ALeftL));
			ws.setColumnView(col,20);	
			row++;

			//狀態
			ws.mergeCells(col, row, col+1, row);     
			ws.addCell(new jxl.write.Label(col, row, "工單狀態:"+ (STATUS.equals("--")||STATUS.equals("")?"全部":STATUS) , ALeftL));
			ws.setColumnView(col,20);	
			row++;
			
			for (int i=1;i<=colcnt;i++) 
			{
				if (md.getColumnLabel(i).endsWith("_投入數") || md.getColumnLabel(i).endsWith("_產出數") || md.getColumnLabel(i).endsWith("_良率") || md.getColumnLabel(i).endsWith("_機器工時") || md.getColumnLabel(i).endsWith("_人工工時") || md.getColumnLabel(i).endsWith("_機器_UPH") || md.getColumnLabel(i).endsWith("_人工_UPH"))
				{
					if (md.getColumnLabel(i).endsWith("_投入數"))
					{
						station_seq=(i% 4);
						ColumnName = md.getColumnLabel(i).replace("_投入數","");
						if (ColumnName.equals("德錫外包")) mergeCol = 2; else mergeCol = 6;
						ws.mergeCells(col+(i-1), row, col+(i-1)+mergeCol, row);     
						ws.addCell(new jxl.write.Label(col+(i-1), row, ColumnName , (station_seq==0?ACenterBL1:(station_seq==1?ACenterBL2:(station_seq==2?ACenterBL3:ACenterBL4)))));
						ws.setColumnView(col+(i-1),11);	
					}
					ws.addCell(new jxl.write.Label(col+(i-1), row+1, md.getColumnLabel(i).replace(ColumnName+"_","") ,(station_seq==0?ACenterBL1:(station_seq==1?ACenterBL2:(station_seq==2?ACenterBL3:ACenterBL4)))));
					ws.setColumnView(col+(i-1),11);	
					
				}
				else
				{
					ws.mergeCells(col+(i-1), row, col+(i-1), row+1);     
					ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
				//	if (i ==2 || i ==3 || i ==4 || i ==6 || i ==7) --20141127 liling add column  3,4
	                if (i ==2 || i ==3|| i ==4 || i ==5 || i ==6 || i ==8 || i ==9)				
					{
						ws.setColumnView(col+(i-1),25);	
					}
				//	else if (i==1 || i ==8 || i == 9 || i ==10 || i ==11)   --20141127 liling add column  shift
                    else if (i==1 || i ==10 || i == 11 || i ==12 || i ==13)				
					{
						ws.setColumnView(col+(i-1),13);	
					}
					else
					{
						ws.setColumnView(col+(i-1),11);	
					}
				}
			}
			row+=2;
		}
		for (int i =1 ; i <= colcnt ; i++)
		{
		//	if (i ==2 || i ==3 || i ==4 || i ==6 || i==7)  --20141127 liling add column  3,4	
	        if (i ==2 || i ==3 || i ==4 || i ==5 || i ==6 || i ==8 || i ==9)	 
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
				ws.setColumnView(col+(i-1),25);
			}
			//else if (i==1 || i ==8 || i == 9 || i ==10 || i ==11)  --20141127 liling add column  shift
            else if (i==1 || i ==10 || i == 11 || i ==12 || i ==13)			
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ACenterL));
				ws.setColumnView(col+(i-1),13);
			}
			else
			{
				if (rs.getString(i)==null)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row,"0", ARightL));
					ws.setColumnView(col+(i-1),11);
				}
				else if (rs.getString(i).endsWith("%"))
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i), ARightL));
					ws.setColumnView(col+(i-1),11);
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("####0.#####")).format(Double.parseDouble(rs.getString(i))) , ARightL));
					ws.setColumnView(col+(i-1),11);
				}
			}
		}	
		reccnt++;
		row++;
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	state.close();

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
try
{
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName+".xls"; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
