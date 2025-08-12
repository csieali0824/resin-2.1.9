<!--20151122 Peggy,add TSC_PROD_FAMILY column-->
<!--20150508 by Peggy,PACKING CLASS=TAPE & REEL PACK傳值到其他網頁會變成TAPE-->
<!--20151122 Peggy,add TSC_PROD_FAMILY column-->
<!--20160113 Peggy,新增"整批匯入"功能&ITEM DESC欄位-->
<!--20160727 Peggy,add catalog_cust_moq欄位-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script language="JavaScript" type="text/JavaScript">
	var checkflag = "false";
	function check(field)
	{
		if (checkflag == "false") {
			for (i = 0; i < field.length; i++) {
				field[i].checked = true;}
			checkflag = "true";
			return "Cancel Selected"; }
		else {
			for (i = 0; i < field.length; i++) {
				field[i].checked = false; }
			checkflag = "false";
			return "Select All"; }
	}
	function setSubmit(URL)
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function setSubmit2(URL)
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function setDelete(URL)
	{
		if (confirm("您確定要刪除此筆資料?"))
		{
			document.MYFORM.action=URL;
			document.MYFORM.submit();
		}
	}
	function setUpload(URL)
	{
		var w_width=600;
		var w_height=500;
		var x=(screen.width-w_width)/2;
		var y=(screen.height-w_height-100)/2;
		var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
		document.getElementById("alpha").style.width=document.body.clientWidth;
		document.getElementById("alpha").style.height=document.body.clientHeight;
		subWin=window.open(URL,"subwin",ww);
	}
</script>
<html>
<head>

	<title>Oracle Add On System Information Query</title>
	<!--=============以下區段為安全認證機制==========-->
	<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
	<!--=================================-->
	<!--=============以下區段為取得連結池==========-->
	<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
	<!--=================================-->
	<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
	<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
	<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
	<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
	<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
	<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
	<%
		int rs1__numRows = 200;
		int rs1__index = 0;
		int rs_numRows = 0;

		rs_numRows += rs1__numRows;

		String sSql = "";
		String sSqlCNT = "";
		String sWhere = "";
		String sWhereGP = "";
		String sOrder = "";
		String subSql = "";

		int CASECOUNT=0;
		float CASECOUNTPCT=0;
		String sCSCountPCT="";
		int idxCSCount=0;

		float CASECOUNTORG=0;

//String RepLocale=(String)session.getAttribute("LOCALE"); 		
		String SWHERECOND = "";
		int CaseCount = 0;
		int CaseCountORG =0;
		float CaseCountPCT = 0;

		String colorStr = "";

		String dateStringBegin=request.getParameter("DATEBEGIN");
		String dateStringEnd=request.getParameter("DATEEND");

		String YearFr=request.getParameter("YEARFR");
		String MonthFr=request.getParameter("MONTHFR");
		String DayFr=request.getParameter("DAYFR");
		String dateSetBegin=YearFr+MonthFr+DayFr;

		String YearTo=request.getParameter("YEARTO");
		String MonthTo=request.getParameter("MONTHTO");
		String DayTo=request.getParameter("DAYTO");
		String dateSetEnd=YearTo+MonthTo+DayTo;

		String intType=request.getParameter("INTTYPE");
		if (intType==null || intType.equals("--")) intType="";
		String packClass=request.getParameter("PACKCLASS");
		String TSCFAMILY = request.getParameter("TSCFAMILY");
		if (TSCFAMILY == null) TSCFAMILY = "";
		String TSCPRODFAMILY = request.getParameter("TSCPRODFAMILY");
		if (TSCPRODFAMILY == null) TSCPRODFAMILY = "";
		String PACKAGECODE = request.getParameter("PACKAGECODE");
		if (PACKAGECODE == null) PACKAGECODE = "";
		String TSCOUTLINE = request.getParameter("TSCOUTLINE");
		if (TSCOUTLINE == null) TSCOUTLINE = "";
		String PRODUCTGROUP = request.getParameter("PRODUCTGROUP");
		if (PRODUCTGROUP == null) PRODUCTGROUP = "";
		String ITEM_DESC = request.getParameter("ITEM_DESC"); //add by Peggy 20160113
		if (ITEM_DESC == null) ITEM_DESC = "";
		String sqlGlobal = "";
		String ID = request.getParameter("ID"); //add by Peggy 20150508
		if (ID == null) ID = "";
		String ACTYPE = request.getParameter("ACTYPE");
		if (ACTYPE==null) ACTYPE="";
		if (ACTYPE.equals("DELETE"))
		{
			try
			{
				String sql = " delete  ORADDMAN.TSITEM_PACKING_CATE where ROWID=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);
				pstmtDt.setString(1,ID);
				pstmtDt.executeQuery();
				pstmtDt.close();

				con.commit();
			}
			catch(Exception e)
			{
				con.rollback();
				out.println("刪除動作失敗!!(錯誤原因:"+e.getMessage()+")");
			}
		}
		if (!ID.equals(""))
		{
			String sql = " SELECT * FROM ORADDMAN.TSITEM_PACKING_CATE WHERE ROWID='"+ID+"'";
			ResultSet rs=con.createStatement().executeQuery(sql);
			if (rs.next())
			{
				intType = rs.getString("INT_TYPE");
				packClass = rs.getString("PACKING_CLASS");
				TSCOUTLINE = rs.getString("TSC_OUTLINE");
				PACKAGECODE = rs.getString("PACKAGE_CODE");
				PRODUCTGROUP = rs.getString("TSC_PROD_GROUP");
				TSCFAMILY = rs.getString("TSC_FAMILY");
				TSCPRODFAMILY = rs.getString("TSC_PROD_FAMILY");
				ITEM_DESC=rs.getString("ITEM_DESCRIPTION"); //add by Peggy 20160113
				if (ITEM_DESC==null) ITEM_DESC="";
				if (TSCPRODFAMILY==null) TSCPRODFAMILY="";
			}
			rs.close();
		}

		if (dateStringBegin==null || dateStringBegin.equals(""))
		{ dateStringBegin = dateBean.getYearMonthDay(); }


	%>
	<% /* 建立本頁面資料庫連線  */ %>
	<style type="text/css">
		BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
		P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
		TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}
		TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
		A         { text-decoration: underline }
		A:link    { color: #003399; text-decoration: underline }
		A:visited { color: #990066; text-decoration: underline }
		A:active  { color: #FF0000; text-decoration: underline }
		.board    { background-color: #D6DBE7}
		.text     { font-family: Tahoma,Georgia;  font-size: 11px }
		select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
	</style>
	<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>
<FORM ACTION="../jsp/TSDRQItemPackageCategorySetting.jsp" METHOD="post" NAME="MYFORM">
	<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
	<!--%/20040109/將Excel Veiw 夾在檔頭%-->
	<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#003366"  size="+2" face="Times New Roman">
	<strong>Item Package Category and Packing Mapping Setting </strong></font>
	<!--<A HREF="DocDownload.jsp?file=D3-002_User_Guide.doc"><font size="2">Download User Guide</font></A>-->
	<A HREF="../jsp/samplefiles/D3-002_User_Guide.doc"><font size="2">Download User Guide</font></A>
	<!--%/20040109/將Excel Veiw 夾在檔頭%-->
	<%
		try
		{
			//sWhereGP = " and a.INT_TYPE > '0' ";
			sWhereGP = " and 1=1";
			subSql = "SELECT rowid, int_type,"+
					"    int_type || '_' || packing_class || '_' || tsc_outline || '_'"+
					"    || package_code || '_' || TSC_PROD_GROUP || '_'|| tsc_family || '_'|| tsc_prod_family AS okey,"+
					"    packing_class, tsc_family, tsc_prod_family,tsc_outline, spq, moq,SAMPLE_SPQ, package_code,"+  //add sample_spq field by Peggy on 20120516
					"    CATALOG_CUST_MOQ,"+ //add by Peggy 20160727
					"    VENDOR_MOQ,"+ //add by Peggy 20211206
					"    to_char(TO_date(CASE WHEN LAST_UPDATE_DATE IS NULL OR LAST_UPDATE_DATE='N/A' THEN creation_date ELSE LAST_UPDATE_DATE END, 'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') creation_date"+
					"    ,CASE WHEN LAST_UPDATE_DATE IS NULL OR LAST_UPDATE_DATE='N/A' THEN created_by ELSE LAST_UPDATED_BY END created_by,TSC_PROD_GROUP,"+
					"    ITEM_DESCRIPTION,"+ //add by Peggy 20160113
					"     CASE WHEN NVL(item_description,'XX')='XX' THEN ROW_NUMBER () OVER (PARTITION BY  int_type"+
					"                                    || '_'"+
					"                                     || packing_class"+
					"                                     || '_'"+
					"                                     || tsc_outline"+
					"                                     || '_'"+
					"                                     || package_code"+
					"                                     || '_'"+
					"                                     || TSC_PROD_GROUP"+
					"                                     || '_'"+
					//"                                     || CASE WHEN tsc_prod_group not IN ('PMD') THEN tsc_family ELSE '' END "+ //add by Peggy 20200716
					//"                                     || CASE WHEN tsc_prod_group not IN ('PMD') THEN tsc_family ELSE NVL (item_description, 'XX') END "+ //add by Peggy 20210802
					"                                     || NVL(tsc_family,'XX')"+ //add by Peggy 20240329
					//"                                     || tsc_family"+
					//"                                     || '_'|| tsc_prod_family"+
					//"                                     || '-'|| nvl(INVENTORY_ITEM_ID,0)"+
					//"                                     || CASE WHEN '-' ||tsc_prod_group IN ('SSP', 'SSD') THEN tsc_prod_family ELSE '' END "+ //add by Peggy 20200716
					"                                     || '_'"+
					"                                     || CASE WHEN tsc_prod_group IN ('SSP','SSD','PMD') THEN tsc_prod_family ELSE '' END "+ //add by Peggy 20240329
					"                                      ORDER BY  NVL (last_update_date, creation_date) DESC) ELSE ROW_NUMBER () OVER (PARTITION BY int_type,item_description order by NVL (last_update_date, creation_date) DESC) end"+
					"                                                           row_num"+
					" FROM oraddman.tsitem_packing_cate"+
					" WHERE upper(int_type) not in ('YEW','YE')"+
					//" AND ((TSC_PROD_GROUP IN ('PMD','SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
					//" or (TSC_PROD_GROUP not in ('PMD','SSP','SSD') AND tsc_prod_family IS NULL))";
					" AND ((TSC_PROD_GROUP IN ('SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
					//" or (TSC_PROD_GROUP not in ('SSP','SSD') AND tsc_prod_family IS NULL))";
					" or TSC_PROD_GROUP not in ('SSP','SSD'))"; //modify by Peggy 20200716
			workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
			workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日

			String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
			String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天


			/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

/*if (intType==null || intType.equals("") || intType.equals("--"))
{
   //sSql = "select INT_TYPE, PACKING_CLASS||'_'||TSC_OUTLINE||'_'||PACKAGE_CODE as OKEY, PACKING_CLASS, TSC_FAMILY,TSC_OUTLINE, SPQ, MOQ ,PACKAGE_CODE "+          
	//	  "from ORADDMAN.TSITEM_PACKING_CATE a ";
   sSql = " SELECT rowid,int_type, okey, packing_class, tsc_family,tsc_prod_family, tsc_outline, spq, moq,SAMPLE_SPQ,package_code,TSC_PROD_GROUP,creation_date,created_by"+ //add sample_spq field by Peggy on 20120516
		  ",ITEM_DESCRIPTION "+ //add by Peggy 20160113
		  ",CATALOG_CUST_MOQ"+ //add by Peggy 20160727
          " from ("+ subSql + ") a  WHERE row_num = 1 ";
   //sSqlCNT = "SELECT count(*) as CaseCount FROM ORADDMAN.TSITEM_PACKING_CATE a ";
   sSqlCNT = " SELECT COUNT(1) as CaseCount FROM ("+ subSql + ") a where row_num = 1 ";
   sWhere =  " and a.INT_TYPE IS NOT NULL ";     // 預設進入頁面即將小於今日            
   sOrder = " order by decode(INT_TYPE,'TS',1,2),INT_TYPE ,TSC_PROD_GROUP,TSC_FAMILY,TSC_PROD_FAMILY,TSC_OUTLINE,PACKAGE_CODE ";

   SWHERECOND = sWhere + sWhereGP;
   sSql = sSql + sWhere + sWhereGP + sOrder;
   sSqlCNT = sSqlCNT + sWhere + sWhereGP;   
   //out.println("sSql="+ sSql);   
   
   	try
	{	
         Statement statement1=con.createStatement();
         ResultSet rs1=statement1.executeQuery(sSqlCNT);
		 if (rs1.next())
		 {
		   CaseCount = rs1.getInt("CaseCount");
		   CaseCountORG = rs1.getInt("CaseCount");
			   
		   if (CaseCountORG!=0)
		   {
		     CaseCountPCT = Math.round((float)(CaseCount/CaseCountORG)*100);
			 //out.println("CaseCount="+CaseCount);
			 //out.println("CaseCountPCT="+CaseCountPCT);
			 // 取小數1位
			sCSCountPCT = Float.toString(CaseCountPCT);
			idxCSCount = sCSCountPCT.indexOf('.');
			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   }
		   else
		   {
		     CaseCountPCT = 0;
			 //out.println(CaseCountPCT);
		   }
		   		   
		   rs1.close();
		   statement1.close();
		 }
		 
		} //end of try
        catch (Exception e)
        {
          out.println("Exception1:"+e.getMessage()+"<br>"+sSqlCNT);
        }
}
else
{ 
*/
			// sSql = "select INT_TYPE, PACKING_CLASS||'_'||TSC_OUTLINE||'_'||PACKAGE_CODE as OKEY, PACKING_CLASS, TSC_FAMILY,TSC_OUTLINE, SPQ, MOQ ,PACKAGE_CODE "+
			//	  "from ORADDMAN.TSITEM_PACKING_CATE a ";
			sSql = " SELECT ROWID,int_type, okey, packing_class, tsc_family,tsc_prod_family, tsc_outline, spq, moq,SAMPLE_SPQ,package_code,TSC_PROD_GROUP,creation_date,created_by"+ //add sample_spq field by Peggy on 20120516
					",ITEM_DESCRIPTION "+ //add by Peggy 20160113
					",CATALOG_CUST_MOQ"+ //add by Peggy 20160727
					",VENDOR_MOQ"+ //add by Peggy 20211206
					" from ("+ subSql + ") a  WHERE 1=1  ";// row_num = 1
			//sSqlCNT = "SELECT count(*) as CaseCount FROM ORADDMAN.TSITEM_PACKING_CATE a ";
			sSqlCNT = " SELECT COUNT(1) as CaseCount FROM ("+ subSql + ") a where row_num = 1 ";
			sWhere =  " and a.INT_TYPE IS NOT NULL ";     // 預設進入頁面即將小於今日
			if (intType!=null && !intType.equals("")) sWhere += " and a.INT_TYPE ='"+intType+"' ";
			if (packClass!=null && !packClass.equals("") && !packClass.equals("--")) sWhere += " and a.PACKING_CLASS='"+packClass+"' ";
			if (TSCFAMILY !=null && !TSCFAMILY.equals("") && !TSCFAMILY.equals("--"))  sWhere += " and a.TSC_FAMILY='"+TSCFAMILY+"' ";
			if (TSCPRODFAMILY !=null && !TSCPRODFAMILY.equals("") && !TSCPRODFAMILY.equals("--"))  sWhere += " and a.TSC_PROD_FAMILY='"+TSCPRODFAMILY+"' ";
			if (TSCOUTLINE !=null && !TSCOUTLINE.equals("") && !TSCOUTLINE.equals("--"))  sWhere += " and a.TSC_OUTLINE='"+TSCOUTLINE+"' ";
			if (PACKAGECODE !=null && !PACKAGECODE.equals("") && !PACKAGECODE.equals("--"))  sWhere += " and a.PACKAGE_CODE='"+PACKAGECODE+"' ";
			if (PRODUCTGROUP !=null && !PRODUCTGROUP.equals("") && !PRODUCTGROUP.equals("--"))  sWhere += " and a.TSC_PROD_GROUP='"+PRODUCTGROUP+"' ";
			if (ITEM_DESC !=null && !ITEM_DESC.equals("") && !ITEM_DESC.equals("--"))  sWhere += " and a.ITEM_DESCRIPTION='"+ITEM_DESC+"' ";
			sOrder = " order by decode(INT_TYPE,'TS',1,2), INT_TYPE,TSC_PROD_GROUP,TSC_FAMILY,TSC_PROD_FAMILY,TSC_OUTLINE,PACKAGE_CODE ";


			SWHERECOND = sWhere+ sWhereGP;
			sSql = sSql + sWhere + sWhereGP + sOrder;
			sSqlCNT = sSqlCNT + sWhere + sWhereGP;
			//out.println(sSql);

			//String sqlOrgCnt = "select count(*) as CaseCountORG from ORADDMAN.TSITEM_PACKING_CATE a ";
			String sqlOrgCnt = " SELECT COUNT(1) as CaseCountORG FROM ("+ subSql + ") a where row_num = 1 ";
			sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP;
			try
			{
				Statement statement2=con.createStatement();
				ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
				if (rs2.next())
				{
					CaseCountORG = rs2.getInt("CaseCountORG");
				}
				rs2.close();
				statement2.close();

				Statement statement3=con.createStatement();
				ResultSet rs3=statement3.executeQuery(sSqlCNT);
				if (rs3.next())
				{
					//CaseCountORG = CaseCount;
					CaseCount = rs3.getInt("CaseCount");
					if (CaseCountORG!=0)
					{
						CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
						//out.println("CaseCount="+CaseCount);
						//out.println("CaseCountPCT="+CaseCountPCT);
						// 取小數1位
						sCSCountPCT = Float.toString(CaseCountPCT);
						idxCSCount = sCSCountPCT.indexOf('.');
						sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
					}
					else
					{
						CaseCountPCT = 0;
						//out.println(CaseCountPCT);
					}
					rs3.close();
					statement3.close();
				}
			} //end of try
			catch (Exception e)
			{
				out.println("Exception3:"+e.getMessage()+"<br>"+sqlOrgCnt);
			}
//}
// 準備予維修方式使用的Statement Con //
//Statement stateAct=con.createStatement();
//out.println(sSql);
			sqlGlobal = sSql;
//PreparedStatement StatementRpRepair = ConnRpRepair.prepareStatement(sSql);
			Statement statementTC=con.createStatement();
//ResultSet rsTC = StatementRpRepair.executeQuery();
			System.out.println(sSql);
			ResultSet rsTC= null;
			try
			{
				rsTC = statementTC.executeQuery(sSql);
			}
			catch(Exception e)
			{
				out.println("資料發生錯誤:"+e.toString());
			}

			//boolean RpRepair_isEmpty = !RpRepair.next();
			//boolean RpRepair_hasData = !RpRepair_isEmpty;
			//Object RpRepair_data;
			boolean rs_isEmptyTC = !rsTC.next();
			boolean rs_hasDataTC = !rs_isEmptyTC;
			Object rs_dataTC;
//int RpRepair_numRows = 0;

// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

			int rs_first = 1;
			int rs_last  = 1;
			int rs_total = -1;


			if (rs_isEmptyTC) {
				rs_total = rs_first = rs_last = 0;
			}

//set the number of rows displayed on this page
			if (rs_numRows == 0) {
				rs_numRows = 1;
			}

			String MM_paramName = "";

// *** Move To Record and Go To Record: declare variables

			ResultSet MM_rs = rsTC;
			int       MM_rsCount = rs_total;
			int       MM_size = rs_numRows;
			String    MM_uniqueCol = "";
			MM_paramName = "";
			int       MM_offset = 0;
			boolean   MM_atTotal = false;
			boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);

// *** Move To Record: handle 'index' or 'offset' parameter

			if (!MM_paramIsDefined && MM_rsCount != 0) {

				//use index parameter if defined, otherwise use offset parameter
				String r = request.getParameter("index");
				if (r==null) r = request.getParameter("offset");
				if (r!=null) MM_offset = Integer.parseInt(r);

				// if we have a record count, check if we are past the end of the recordset
				if (MM_rsCount != -1) {
					if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
						if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
							MM_offset = MM_rsCount - MM_rsCount % MM_size;
						else
							MM_offset = MM_rsCount - MM_size;
					}
				}

				//move the cursor to the selected record
				int i;
				for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) {
					rs_hasDataTC = MM_rs.next();
				}
				if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
			}

// *** Move To Record: if we dont know the record count, check the display range

			if (MM_rsCount == -1) {

				// walk to the end of the display range for this page
				int i;
				for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) {
					rs_hasDataTC = MM_rs.next();
				}

				// if we walked off the end of the recordset, set MM_rsCount and MM_size
				if (!rs_hasDataTC) {
					MM_rsCount = i;
					if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
				}

				// if we walked off the end, set the offset based on page size
				if (!rs_hasDataTC && !MM_paramIsDefined) {
					if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
						if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
							MM_offset = MM_rsCount - MM_rsCount % MM_size;
						else
							MM_offset = MM_rsCount - MM_size;
					}
				}

				// reset the cursor to the beginning
				rsTC.close();
				rsTC = statementTC.executeQuery(sSql);
				rs_hasDataTC = rsTC.next();

				MM_rs = rsTC;

				// move the cursor to the selected record
				for (i=0; rs_hasDataTC && i < MM_offset; i++) {
					rs_hasDataTC = MM_rs.next();
				}
			}

// *** Move To Record: update recordset stats

// set the first and last displayed record
			rs_first = MM_offset + 1;
			rs_last  = MM_offset + MM_size;
			if (MM_rsCount != -1) {
				rs_first = Math.min(rs_first, MM_rsCount);
				rs_last  = Math.min(rs_last, MM_rsCount);
			}

// set the boolean used by hide region to check if we are on the last record
			MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
	%>
	<%
		// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

		String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
		String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
		if (request.getQueryString() != null) {
			MM_keepURL = '&' + request.getQueryString();
			for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
				int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
				if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
						MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
					int stop = MM_keepURL.indexOf('&', start + 1);
					if (stop == -1) stop = MM_keepURL.length();
					MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
				}
			}
		}

// add the Form variables to the MM_keepForm string
		if (request.getParameterNames().hasMoreElements()) {
			java.util.Enumeration items = request.getParameterNames();
			while (items.hasMoreElements()) {
				String nextItem = (String)items.nextElement();
				boolean found = false;
				for (int i=0; !found && i < MM_removeList.length; i++) {
					if (MM_removeList[i].equals(nextItem)) found = true;
				}
				if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
					MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
				}
			}
		}

// create the Form + URL string and remove the intial '&' from each of the strings
		MM_keepBoth = MM_keepURL + MM_keepForm;
		if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
		if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
		if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);


// *** Move To Record: set the strings for the first, last, next, and previous links

		String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
		{
			String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
			String MM_moveParam = "index=";

			// if the page has a repeated region, remove 'offset' from the maintained parameters
			if (MM_size > 1) {
				MM_moveParam = "offset=";
				int start = MM_keepMove.indexOf(MM_moveParam);
				if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
					int stop = MM_keepMove.indexOf('&', start);
					if (start == 0 && stop != -1) stop++;
					if (stop == -1) stop = MM_keepMove.length();
					if (start > 0) start--;
					MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
				}
			}

			// set the strings for the move to links
			StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
			if (MM_keepMove.length() > 0) urlStr.append('&');
			urlStr.append(MM_moveParam);
			MM_moveFirst = urlStr + "0";
			MM_moveLast  = urlStr + "-1";
			MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
			MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
		}

	%>
	<table cellSpacing="0" bordercolordark="#99CC99" cellPadding="1" width="100%" align="left" bordercolorlight="#FFFFCC"  border="0">
		<tr>
			<td>
				<table cellSpacing="1" bordercolordark="#99CC99" cellPadding="1" width="100%" align="left" bordercolorlight="#FFFFCC"  border="1" bordercolor="#cccccc">
					<tr>
						<td bgcolor="#eeeeee"> Internal/External:</td>
						<td>
							<%
								String INTTYPE="";
								try
								{
									String sql = "";
									String sWherePerson  = "";

									sql = "select DISTINCT INT_TYPE as x, INT_TYPE from ORADDMAN.TSITEM_PACKING_CATE ";
									sWherePerson  = " where INT_TYPE > '0' and upper(INT_TYPE) not in ('YEW','YE')";
									String sOrderPerson = "order by x DESC ";

									sql = sql+sWherePerson+sOrderPerson;

									//out.println(sSql);
									Statement statement=con.createStatement();
									ResultSet rs=statement.executeQuery(sql);
									out.println("<select NAME='INTTYPE' class='style1' onChange='setSubmit("+'"'+"../jsp/TSDRQItemPackageCategorySetting.jsp"+'"'+")'>");
									out.println("<OPTION VALUE=-->--");
									while (rs.next())
									{
										String s1=(String)rs.getString(1);
										String s2=(String)rs.getString(2);

										if (s1.equals(intType))
										{
											out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
										}
										else
										{
											out.println("<OPTION VALUE='"+s1+"'>"+s2);
										}
									} //end of while
									out.println("</select>");
									rs.close();
									statement.close();
								} //end of try
								catch (Exception e)
								{
									out.println("Exception3:"+e.getMessage());
								}

							%>
						</td>
						<td bgcolor="#eeeeee">Packing Class:</td>
						<td>
							<%
								String PACKCLASS="";
								try
								{
									String sql = "";
									String sWherePerson  = "";

									sql = "select DISTINCT PACKING_CLASS as x, PACKING_CLASS, INT_TYPE from ORADDMAN.TSITEM_PACKING_CATE ";
									sWherePerson  = " where INT_TYPE ='"+intType+"' ";
									String sOrderPerson = "order by INT_TYPE DESC ";

									sql = sql+sWherePerson+sOrderPerson;

									//out.println(sSql);
									Statement statement=con.createStatement();
									ResultSet rs=statement.executeQuery(sql);
									comboBoxBean.setRs(rs);
									comboBoxBean.setSelection(packClass);
									comboBoxBean.setFieldName("PACKCLASS");
									out.println(comboBoxBean.getRsString());
									rs.close();
									statement.close();
								} //end of try
								catch (Exception e)
								{
									out.println("Exception4:"+e.getMessage());
								}
							%>
						</td>
						<td bgcolor="#eeeeee">TSC Family:</td>
						<td>
							<%
								try
								{
									String sql = " select DISTINCT TSC_FAMILY as x, TSC_FAMILY  from ORADDMAN.TSITEM_PACKING_CATE "+
											" where TSC_FAMILY  is not null "+
											//" AND ((TSC_PROD_GROUP IN ('PMD','SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
											//" or (TSC_PROD_GROUP not in ('PMD','SSP','SSD') AND tsc_prod_family IS NULL))"+
											" order by TSC_FAMILY ";

									Statement statement=con.createStatement();
									ResultSet rs=statement.executeQuery(sql);
									comboBoxBean.setRs(rs);
									comboBoxBean.setSelection(TSCFAMILY);
									comboBoxBean.setFieldName("TSCFAMILY");
									out.println(comboBoxBean.getRsString());
									rs.close();
									statement.close();
								} //end of try
								catch (Exception e)
								{
									out.println("Exception5:"+e.getMessage());
								}
							%>
						</td>
						<td bgcolor="#eeeeee">TSC Prod Family:</td>
						<td>
							<%
								try
								{
									String sql = " select DISTINCT TSC_PROD_FAMILY as x, TSC_PROD_FAMILY  from ORADDMAN.TSITEM_PACKING_CATE "+
											" where TSC_PROD_FAMILY  is not null"+
											" AND ((TSC_PROD_GROUP IN ('PMD','SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
											" or (TSC_PROD_GROUP not in ('PMD','SSP','SSD') AND tsc_prod_family IS NULL))"+
											" order by TSC_PROD_FAMILY ";

									Statement statement=con.createStatement();
									ResultSet rs=statement.executeQuery(sql);
									comboBoxBean.setRs(rs);
									comboBoxBean.setSelection(TSCPRODFAMILY);
									comboBoxBean.setFieldName("TSCPRODFAMILY");
									out.println(comboBoxBean.getRsString());
									rs.close();
									statement.close();
								} //end of try
								catch (Exception e)
								{
									out.println("Exception5:"+e.getMessage());
								}
							%>
						</td>
					</tr>
					<tr>
						<td bgcolor="#eeeeee">TSC Package:</td>
						<td>
							<%
								try
								{
									String sql = " select DISTINCT TSC_OUTLINE as x, TSC_OUTLINE from ORADDMAN.TSITEM_PACKING_CATE "+
											" where TSC_OUTLINE is not null "+
											//" AND ((TSC_PROD_GROUP IN ('PMD','SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
											//" or (TSC_PROD_GROUP not in ('PMD','SSP','SSD') AND tsc_prod_family IS NULL))"+
											" order by TSC_OUTLINE ";

									Statement statement=con.createStatement();
									ResultSet rs=statement.executeQuery(sql);
									comboBoxBean.setRs(rs);
									comboBoxBean.setSelection(TSCOUTLINE);
									comboBoxBean.setFieldName("TSCOUTLINE");
									out.println(comboBoxBean.getRsString());
									rs.close();
									statement.close();
								} //end of try
								catch (Exception e)
								{
									out.println("Exception6:"+e.getMessage());
								}
							%>
						</td>
						<td bgcolor="#eeeeee" >Packing Code:</td>
						<td >
							<%
								try
								{
									String sql = " select DISTINCT PACKAGE_CODE as x, PACKAGE_CODE from ORADDMAN.TSITEM_PACKING_CATE "+
											" where PACKAGE_CODE is not null order by PACKAGE_CODE ";

									Statement statement=con.createStatement();
									ResultSet rs=statement.executeQuery(sql);
									comboBoxBean.setRs(rs);
									comboBoxBean.setSelection(PACKAGECODE);
									comboBoxBean.setFieldName("PACKAGECODE");
									out.println(comboBoxBean.getRsString());
									rs.close();
									statement.close();
								} //end of try
								catch (Exception e)
								{
									out.println("Exception7:"+e.getMessage());
								}
							%>
						</td>
						<td bgcolor="#eeeeee" >TSC Prod Group:</td>
						<td >
							<%
								try
								{
									String sql = " select DISTINCT TSC_PROD_GROUP as x, TSC_PROD_GROUP from ORADDMAN.TSITEM_PACKING_CATE "+
											" where TSC_PROD_GROUP is not null order by TSC_PROD_GROUP ";

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
									out.println("Exception8:"+e.toString());
								}
							%>
						</td>
						<td bgcolor="#eeeeee" >Item Desc:</td>
						<td><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia;  font-size: 11px "></td>
					</tr>
					<tr bgcolor="#eeeeee">
						<td  colspan="8" align="center">
							<font color="#CC0000" face="Arial Black"><strong>
								<input name="submit1" type="button" value='<jsp:getProperty name="rPH" property="pgQuery"/>' style="font-family:Tahoma;" onClick='return setSubmit("../jsp/TSDRQItemPackageCategorySetting.jsp")'>&nbsp;&nbsp;&nbsp;&nbsp;
								<INPUT name="submit3" TYPE="button" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' style="font-family:Tahoma;" onClick='setSubmit("../jsp/TSDRQItemPackageCategoryExcel.jsp")' >&nbsp;&nbsp;&nbsp;&nbsp;
								<input name="submit2" type="button" value='<jsp:getProperty name="rPH" property="pgAdd"/>' style="font-family:Tahoma;" onClick='return setSubmit("../jsp/TSDRQItemPackageCategoryAdd.jsp?ActionName=A")'>&nbsp;&nbsp;&nbsp;&nbsp;
								<input name="submit4" type="button" value='Batch Upload' style="font-family:Tahoma;"  onClick='setUpload("../jsp/TSDRQItemPackageCategoryUpload.jsp")'>
							</strong></font>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table cellSpacing="1" bordercolordark="#99CC99" cellPadding="1" width="100%" align="left" bordercolorlight="#FFFFCC"  border="1" bordercolor="#CCFFCC">
					<tbody>
					<tr bgcolor="#CCFFCC">
						<td width="3%" height="22" nowrap>&nbsp;&nbsp;&nbsp;</td>
						<td width="5%"  height="19" nowrap align="center"><jsp:getProperty name="rPH" property="pgEdit"/></td>
						<td width="4%" height="22" nowrap align="center">Internal/External</td>
						<td width="9%" nowrap align="center">Packing Class</td>
						<td width="5%" nowrap align="center">TSC Prod Group</td>
						<td width="10%" nowrap align="center">TSC Family</td>
						<td width="10%" nowrap align="center">TSC Prod Family</td>
						<td width="8%" nowrap align="center">TSC Package</td>
						<td width="4%" nowrap align="center">Packing Code</td>
						<td width="10%" nowrap align="center">Item Desc</td>
						<td width="4%" nowrap align="center">SPQ</td>
						<td width="4%" nowrap align="center">Sample SPQ</td>
						<td width="4%" nowrap align="center">MOQ</td>
						<td width="4%" nowrap align="center">Catalog Cust MOQ</td>
						<td width="4%" nowrap align="center">Vendor MOQ</td>
						<td width="6%" nowrap align="center">Last Update Date</td>
						<td width="6%" nowrapa align="center">Last Updated By</td>
					</tr>
					<% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
					<%
						//Repeat1__index++;
						if ((rs1__index % 2) == 0){
							colorStr = "FFFFDD";
						}
						else{
							colorStr = "FFFFCC"; }
					%>
					<tr bgcolor="<%=colorStr%>">
						<td bgcolor="#CCFFCC"><div align="center"><font size="-1" color="#006699"><%out.println(rs1__index+1);%></font></div></td>
						<td height="20" align="center"><a href="../jsp/TSDRQItemPackageCategoryEdit.jsp?ID=<%=java.net.URLEncoder.encode(rsTC.getString("ROWID"))%>&ActionName=Edit">
							<img src="../image/docicon.gif" width="14" height="15" border="0"></a>
							&nbsp;&nbsp;<img border="0" src="images/deletion.gif" height="14" title="刪除資料" onClick="setDelete('../jsp/TSDRQItemPackageCategorySetting.jsp?ID=<%=java.net.URLEncoder.encode(rsTC.getString("ROWID"))%>&ACTYPE=DELETE')">
						</td>
						<td nowrap><%=rsTC.getString("INT_TYPE") %></font></td>
						<td nowrap><%=rsTC.getString("PACKING_CLASS")%></font></td>
						<td nowrap><%=(rsTC.getString("TSC_PROD_GROUP")==null?"&nbsp;":rsTC.getString("TSC_PROD_GROUP"))%></td>
						<td nowrap><%=(rsTC.getString("TSC_FAMILY")==null?"&nbsp;":rsTC.getString("TSC_FAMILY"))%></td>
						<td nowrap><%=(rsTC.getString("TSC_PROD_FAMILY")==null?"&nbsp;":rsTC.getString("TSC_PROD_FAMILY"))%></td>
						<td nowrap><%=(rsTC.getString("TSC_OUTLINE")==null?"&nbsp;":rsTC.getString("TSC_OUTLINE"))%></td>
						<td nowrap><%=(rsTC.getString("PACKAGE_CODE")==null?"&nbsp;":rsTC.getString("PACKAGE_CODE"))%></td>
						<td nowrap><%=(rsTC.getString("ITEM_DESCRIPTION")==null?"&nbsp;":rsTC.getString("ITEM_DESCRIPTION"))%></td>
						<td align=right nowrap><%=(rsTC.getString("SPQ")==null?"&nbsp;":rsTC.getString("SPQ"))%></td>
						<td align=right nowrap><%=(rsTC.getString("SAMPLE_SPQ")==null?"&nbsp;":rsTC.getString("SAMPLE_SPQ"))%></td>
						<td align=right nowrap><%=(rsTC.getString("MOQ")==null?"&nbsp;":rsTC.getString("MOQ"))%></td>
						<td align=right nowrap><%=(rsTC.getString("CATALOG_CUST_MOQ")==null?"&nbsp;":rsTC.getString("CATALOG_CUST_MOQ"))%></td>
						<td align=right nowrap><%=(rsTC.getString("VENDOR_MOQ")==null?"&nbsp;":rsTC.getString("VENDOR_MOQ"))%></td>
						<td align=center nowrap><%=(rsTC.getString("CREATION_DATE")==null?"&nbsp;":rsTC.getString("CREATION_DATE"))%></td>
						<td align=left nowrap><%=(rsTC.getString("CREATED_BY")==null?"&nbsp;":rsTC.getString("CREATED_BY"))%></td>
					</tr>
					<%
							rs1__index++;
							rs_hasDataTC = rsTC.next();
							qryAllChkBoxEditBean.setPageURL("../jsp/TSSalesAreaMapOrderTypeSetActive.jsp");
							qryAllChkBoxEditBean.setSearchKey("OKEY");
							qryAllChkBoxEditBean.setFieldName("CHKFLAG");
							qryAllChkBoxEditBean.setRowColor1("B0E0E6");
							qryAllChkBoxEditBean.setRowColor2("ADD8E6");
							qryAllChkBoxEditBean.setRs(rsTC);
						}
					%>
					<tr bgcolor="#CCFFCC">
						<td height="24" colspan="17" ><font color="#006699" size="-1">總資料筆數</font>
							<%
								if (CaseCount==0)
								{ //若
								}
								else {
									out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>");
									// 若 有資料則顯示可全選的按鈕

								}

								workingDateBean.setAdjWeek(1);  // 把週別調整回來

							%><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5"  readonly=""><%out.println("<font color='#000099' face='Arial'><strong>"+CaseCount+"</strong></font>");%>
						</td>
					</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<!--%每頁筆●顯示筆到筆總共有資料%-->
				<% if (rs_isEmptyTC ) {  %>
				<div align="center"><font color="#993366" size="2"><strong>No Record Found</strong></font></div>
				<% } else {
				%>
				<div align="left"></div>
				<%
					}
					/*若有資料則顯示可全選擇的按鈕 */ %>
				<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
				<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
			</td>
		</tr>
		<tr>
			<td>
				<div align="left"></div>
				<table width="100%" border="0">
					<tr align="center" bordercolor="#000000" >
						<td width="24%">
							<div align="center">
								<pre><font color="#000066"><strong>[<A HREF="<%=MM_moveFirst%>"><jsp:getProperty name="rPH" property="pgFirst"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
							</div></td>
						<td width="24%">
							<div align="center">
								<pre><font color="#000066"><strong>[<A HREF="<%=MM_movePrev%>"><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
							</div></td>
						<td width="24%">
							<div align="center">
								<pre><font color="#000066"><strong>[<A HREF="<%=MM_moveNext%>"><jsp:getProperty name="rPH" property="pgNext"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
							</div></td>
						<td width="28%">
							<div align="center">
								<pre><font color="#000066"><strong>[<A HREF="<%=MM_moveLast%>"><jsp:getProperty name="rPH" property="pgLast"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
							</div></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%
		rsTC.close();
		statementTC.close();
	}
	catch(Exception e)
	{
		out.println("Exception:"+e.getMessage());
	}
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>
