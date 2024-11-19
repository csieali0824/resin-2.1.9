<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit1(xWOTYPE)
{

  if(document.MYFORM.WOTYPE.value==null ||  document.MYFORM.WOTYPE.value=="--")
    {
	 alert("請選擇工令類別!!")
	 document.MYFORM.WOTYPE.focus(); 
	 return(false);
	}
/*	
  if(xDATEBEGIN=="--" || xDATEBEGIN.equals("--") || xDATEBEGIN==null || xDATEEND=="--" || xDATEEND.equals("--") || xDATEEND==null)
    {
	 alert("請選擇工令設立期間!!")
	 return(false);
	}
	*/
  if(document.MYFORM.WOTYPE.value=="1")
   {
      URL="../jsp/TSCMfgWoExceltype1.jsp"; 
    }
  else if (document.MYFORM.WOTYPE.value=="2" || document.MYFORM.WOTYPE.value=="4")
    { 
	  URL="../jsp/TSCMfgWoExceltype2.jsp"; 
	 } 
  else if (document.MYFORM.WOTYPE.value=="3" )
    { 
	  URL="../jsp/TSCMfgWoExceltype3.jsp"; 
	 }  
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}




function setSubmit2(URL)  //清除畫面條件,重新查詢!
{  
 document.MYFORM.MARKETTYPE.value =""; 
 document.MYFORM.WOTYPE.value =""; 
 document.MYFORM.WONO.value ="";
 document.MYFORM.INVITEM.value ="";
 document.MYFORM.ITEMDESC.value ="";
 document.MYFORM.WAFERLOT.value ="";
 document.MYFORM.MONTHFR.value ="";
 document.MYFORM.DAYFR.value ="";
 document.MYFORM.MONTHTO.value ="";
 document.MYFORM.DAYTO.value ="";
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setItemFindCheck(invItem,itemDesc,organizationId)
{
   if (event.keyCode==13)
   { 
    subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&ORGANIZATIONID="+organizationId,"subwin","width=640,height=480,scrollbars=yes"); 
 //  subWin=window.open("../jsp/subwindow/TSMfgItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); 	
   }
}

function subWindowItemFind(invItem,itemDesc,organizationId)
{    
  subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&ORGANIZATIONID="+organizationId,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

function subWinDiscreteJobFind(discreteJob,statusId)
{
  subWin=window.open("../jsp/subwindow/TSMfgWipDiscreteJobFind.jsp?JOBORRUNCARD="+discreteJob+"&STATUSID="+statusId,"subwin","width=640,height=480,status=yes,scrollbars=yes,menubar=yes");
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
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
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
String sWhereSDRQ = "";
String sWhereGP = "";
String havingGrpSDRQ = "";
String sOrder = "";

String havingGrp = "";
String lightStatus ="";

//String fjamDesc = ""; 

//String link2ExcelURL = "";

int counta=0;
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

String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
      if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr+DayFr;

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo+DayTo; 


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String dnDocNoSet=request.getParameter("DNDOCNOSET");
String dnDocNo=request.getParameter("DNDOCNO");
String organizationCode=request.getParameter("ORGANIZATION_CODE");
String custActive=request.getParameter("CUSTACTIVE");
  
  String salesAreaNo=request.getParameter("SALESAREANO");
  String salesOrderNo=request.getParameter("SALESORDERNO");
  String preOrderType=request.getParameter("PREORDERTYPE");
  String custPONo=request.getParameter("CUSTPONO");
  String createdBy=request.getParameter("CREATEDBY");
  String salesPerson=request.getParameter("SALESPERSON");
  String prodManufactory=request.getParameter("PRODMANUFACTORY");
  //String UserPlanCenterNo=request.getParameter("USERPLANCENTERNO");  
  String status=request.getParameter("STATUS");
  String statusCode=request.getParameter("STATUSCODE"); 
  
  String listMode=request.getParameter("LISTMODE");  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  
//liling create
	String woNo=request.getParameter("WONO"); 
    String marketType=request.getParameter("MARKETTYPE");
	String woType=request.getParameter("WOTYPE");
	String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
	String startDate=request.getParameter("STARTDATE");
	String endDate=request.getParameter("ENDDATE");
	String woQty=request.getParameter("WOQTY");
	String invItem=request.getParameter("INVITEM");
	String itemId=request.getParameter("ITEMID");	
	String itemDesc=request.getParameter("ITEMDESC");		
	String woUom=request.getParameter("WOUOM");
	String waferLot=request.getParameter("WAFERLOT");
	String waferQty=request.getParameter("WAFERQTY");          //使用晶片數量
	String waferUom=request.getParameter("WAFERUOM");          //晶片單位
	String waferYld=request.getParameter("WAFERYLD");          //晶片良率
    String waferVendor=request.getParameter("WAFERVENDOR");   //晶片供應商
	String waferKind=request.getParameter("WAFERKIND");       //晶片類別
	String waferElect=request.getParameter("WAFERELECT");     //電阻系數��
	String waferPcs=request.getParameter("WAFERPCS");         //使用晶片片數���
	String waferIqcNo=request.getParameter("WAFERIQCNO");     //檢驗單號	
	String tscPackage=request.getParameter("TSCPACKAGE");     //
	String tscFamily=request.getParameter("TSCFAMILY");     //
	String tscPacking=request.getParameter("TSCPACKING");
	String tscAmp=request.getParameter("TSCAMP");		      //安培數
    String alternateRouting=request.getParameter("ALTERNATEROUTING"); 
    String customerName=request.getParameter("CUSTOMERNAME");	
    String customerNo=request.getParameter("CUSTOMERNO");
	String customerId=request.getParameter("CUSTOMERID");
	String customerPo=request.getParameter("CUSTOMERPO");
	String oeOrderNo=request.getParameter("OEORDERNO");	
	String deptNo=request.getParameter("DEPT_NO");	
    String deptName=request.getParameter("DEPT_NAME");	
    String preFix=request.getParameter("PREFIX");
    String oeHeaderId=request.getParameter("OEHEADERID");	
	String oeLineId=request.getParameter("OELINEID");	
	String organizationId=request.getParameter("ORGANIZATION_ID");
    String singleLotQty=null,createDate=null,userName=null,completeQty="0",scrapQty="0",woStatus="",wipEntityId="",runCardNo="";

  
  
  if (dnDocNo==null || dnDocNo.equals("")) dnDocNo=""; //選擇展開的
  if (dnDocNoSet==null || dnDocNoSet.equals("")) dnDocNoSet=""; // 使用者輸入的
  if (customerId==null || customerId.equals("")) customerId="";
  if (customerNo==null || customerNo.equals("")) customerNo="";
  if (customerName==null || customerName.equals("")) customerName="";
  if (custPONo==null || custPONo.equals("")) custPONo="";
  if (createdBy==null || createdBy.equals("")) createdBy="";

  
  if (statusCode==null || statusCode.equals("")) statusCode="";  

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  if (listMode==null) listMode = "TRUE";
  int iDetailRowCount = 0;
  
  
  if (woType==null || woType.equals("")) woType="--"; 
  if (woNo==null || woNo.equals("")) woNo=""; 
  if (waferIqcNo==null || waferIqcNo.equals("")) waferIqcNo="";   
  
  
  
    // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
  //  


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="../jsp/TSCMfgRsUpdateQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#663333" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#663333" size="+2" face="Times New Roman"> 
<strong><a>工時資料異動</a></strong></font>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = "  ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
try
{
    
     sSql = " SELECT  rc.runcad_id, rc.runcard_no, ywa.wo_no, ywa.market_type, ywa.workorder_type, ywa.inv_item, ywa.item_desc, ywa.wo_qty, "+
            "         ywa.wo_uom, TO_CHAR (TO_DATE (ywa.schedule_strart_date,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') startdate, "+
            "         TO_CHAR (TO_DATE (ywa.schedule_end_date, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD ' ) enddate, user_name, ywa.wip_entity_id, "+
			"         TO_CHAR (TO_DATE (ywa.creation_date, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') AS createdate, ywa.organization_id ,  "+
			"         decode(WDJ.STATUS_TYPE ,'1','Unrelease','3','Release','4','Complete','7','Cancelled','12','Closed') STATUS "+
            "    FROM yew_workorder_all ywa, yew_runcard_all rc , wip_discrete_jobs wdj ";

   sSqlCNT = " select count(WO_NO)  CaseCount from YEW_WORKORDER_ALL  ";
			
   sWhere =  "  where  ywa.wo_no=rc.wo_no(+)  ";
   sWhereSDRQ = "  AND ywa.wip_entity_id=wdj.wip_entity_id  AND wdj.status_type in (3,4)  ";

			 
   sWhereSDRQ = " ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "    order by ywa.creation_date,ywa.wo_no desc ";
   //TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   sSqlCNT = sSqlCNT ;
   //out.println("sSql="+ sSql);   
} //end of try
 catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }

   
   try
        {	
			
         Statement statement1=con.createStatement();
         ResultSet rs1=statement1.executeQuery(sSqlCNT);
		 if (rs1.next())
		 {
		   CaseCount = rs1.getInt("CaseCount");
		   CaseCountORG = rs1.getInt("CaseCountOrg");
		   
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
          out.println("Exception:"+e.getMessage());
        }
}
else
{   
  try
 {
   
     sSql = " SELECT  rc.runcad_id, rc.runcard_no, ywa.wo_no, ywa.market_type, ywa.workorder_type, ywa.inv_item, ywa.item_desc, ywa.wo_qty, "+
            "         ywa.wo_uom, TO_CHAR (TO_DATE (ywa.schedule_strart_date,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') startdate, "+
            "         TO_CHAR (TO_DATE (ywa.schedule_end_date, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD ' ) enddate, user_name, ywa.wip_entity_id, "+
			"         TO_CHAR (TO_DATE (ywa.creation_date, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') AS createdate, ywa.organization_id ,  "+
			"         decode(WDJ.STATUS_TYPE ,'1','Unrelease','3','Release','4','Complete','7','Cancelled','12','Closed') STATUS "+
            "    FROM yew_workorder_all ywa, yew_runcard_all rc , wip_discrete_jobs wdj ";

   sSqlCNT = " select count(WO_NO)  CaseCount from YEW_WORKORDER_ALL  ";
			
   sWhere =  "  where  ywa.wo_no=rc.wo_no(+)  ";
   sWhereSDRQ = "  AND ywa.wip_entity_id=wdj.wip_entity_id  AND wdj.status_type in (3,4)  ";

	//out.print("sSql="+sSql+sWhere); 

			 
			 
   if (marketType==null || marketType.equals("--") || marketType.equals("")) {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and YWA.MARKET_TYPE ='"+marketType+"'"; }
  
   if (woType==null || woType.equals("--"))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and YWA.WORKORDER_TYPE ='"+woType+"'"; }
  
   if (woNo==null || woNo.equals(""))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and ( YWA.WO_NO ='"+woNo+"' or RC.RUNCARD_NO= '"+woNo+"'  or YWA.OE_ORDER_NO= '"+woNo+"' or YWA.WAFER_IQC_NO = '"+woNo+"' ) "  ; }   

   if (invItem==null || invItem.equals(""))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and YWA.INV_ITEM ='"+invItem+"'"; }  

   if (itemDesc==null || itemDesc.equals(""))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and YWA.ITEM_DESC ='"+itemDesc+"'"; } 
   
   if (waferLot==null || waferLot.equals(""))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and YWA.WAFER_LOT_NO ='"+waferLot+"'"; }   
   
   if (waferIqcNo==null || waferIqcNo.equals(""))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and YWA.WAFER_IQC_NO ='"+waferIqcNo+"'"; } 
   
  // if (userMfgDeptNo==null || userMfgDeptNo.equals(""))  {sWhere=sWhere+" ";}
  // else {sWhere=sWhere+" and YWA.DEPT_NO ='"+userMfgDeptNo+"'"; } 
  
  if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0 || UserRoles.indexOf("YEW_WIP_PACKING")>=0) 
      {sWhere=sWhere+" ";}
  else {sWhere=sWhere+" and YWA.DEPT_NO ='"+userMfgDeptNo+"'"; } 
			 
   havingGrp = "  ";      
   havingGrpSDRQ = "  ";  
   sOrder = "  order by ywa.creation_date,ywa.wo_no desc ";
 
   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(YWA.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
   if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(YWA.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(YWA.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
  SWHERECOND = sWhere+ sWhereGP;
//  sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
  sSql = sSql + sWhere +sWhereSDRQ+  sOrder;  
  sSqlCNT = sSqlCNT ;
  //out.println("sSqlTT="+sSql);  
  


   
   String sqlOrgCnt = "select count(*) as CaseCountORG  from YEW_WORKORDER_ALL YWA,YEW_RUNCARD_ALL RC ";
   sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP ;
  // out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
  
   Statement statement2=con.createStatement();
   ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   if (rs2.next())
   {
     CaseCountORG = rs2.getInt("CaseCountORG");     
   }
   rs2.close();
   statement2.close();
   
  } //end of try
 catch (Exception e)
   {
     out.println("Exception 2:"+e.getMessage());
    }
   try
   {       	 	
         Statement statement3=con.createStatement();
		// out.print("sSqlCNT="+sSqlCNT);
		 
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
          out.println("Exception 3:"+e.getMessage());
        }
   
}//end of else 


// 準備予維修方式使用的Statement Con //
//Statement stateAct=con.createStatement();
//out.println(sSql);
sqlGlobal = sSql;
//out.print("sqlGlobal="+sqlGlobal+"<br>");
//PreparedStatement StatementRpRepair = ConnRpRepair.prepareStatement(sSql);
Statement statementTC=con.createStatement(); 
//ResultSet rsTC = StatementRpRepair.executeQuery();
ResultSet rsTC=statementTC.executeQuery(sSql);
   //boolean RpRepair_isEmpty = !RpRepair.next();
   //boolean RpRepair_hasData = !RpRepair_isEmpty;
   //Object RpRepair_data;
boolean rs_isEmptyTC = !rsTC.next();
boolean rs_hasDataTC = !rs_isEmptyTC;
Object rs_dataTC;  
//int RpRepair_numRows = 0;



%> 
<%
  if (listMode==null || listMode.equals("TRUE"))
  {
%> 
  <table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="100%" align="center" bordercolorlight="#FFFFFF" border="1"> 
     <tr>
	    <td width="10%" colspan="1" nowrap  align="center">
		<font color="#663333" size="2"><strong><jsp:getProperty name="rPH" property="pgInSales"/>/<jsp:getProperty name="rPH" property="pgExpSales"/></strong></font>         
        </td> 
		<td width="8%">&nbsp;&nbsp;
		   <%		 
	         try
                 {  
				   //-----取內外銷別
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select CODE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
			       String whereOType = " where DEF_TYPE='MARKETTYPE'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("MARKETTYPE");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();
				//out.print("MARKETTYPE"+marketType);
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }	   
       %>
		</td>
		<td width="8%"  align="center">
		   <font color="#663333" size="2"><strong><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgClass"/></strong></font>
		</td>   
		<td width="10%" colspan="1" nowrap> &nbsp;&nbsp; 
		      <%
     try
                 {  
				   //-----取工單類別  
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select CODE as WOTYPE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
			        String whereOType = " where DEF_TYPE='WO_TYPE'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
				 //  
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(woType);
	               comboBoxBean.setFieldName("WOTYPE");	   
                   out.println(comboBoxBean.getRsString());
				 // 
				  /* 若要使用reflash加上此功能
				   out.println("<select NAME='WOTYPE' onChange='setSubmit("+'"'+"../jsp/TSCMfgWoExpand.jsp"+'"'+")'>");
                   out.println("<OPTION VALUE=-->--");     
                   while (rs.next())
                  {            
                    String s1=(String)rs.getString(1); 
                    String s2=(String)rs.getString(2); 
                        
                     if (s1.equals(woType)) 
                    {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                    }   
			        else 
			        {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                    }        
                   } //end of while
                   out.println("</select>"); 	
				  */   		  
		           rs.close();   
				   statement.close();  
				 //  out.print("whereOType="+woType);   	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
		</td> 
	   <td width="10%" align="center"><font color="#663333" size="2"><strong>工令號/流程卡號</strong></font></td>
	   <td width="20%">&nbsp;&nbsp;<input type="text" name="WONO" value="<%=woNo%>"></td>		   
	 </tr>
	 </table>
<table cellSpacing='0' bordercolordark='#B5B89A'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>	
     <tr>	    
	   <td nowrap colspan="2"><font color="#663333" size="2"><strong><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgCDate"/></strong></font>
        <%
		 // String CurrYear = null;	     		 
	     //try
         //{       
         // String a[]={"2012","2013","2014","2015","2016","2017","2018"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearFr==null)
		 // {
		 //   CurrYear=dateBean.getYearString();
         //
		 //   arrayComboBoxBean.setSelection(CurrYear);
		 // } 
		 // else 
		 // {
		 //   arrayComboBoxBean.setSelection(YearFr);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARFR");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         // out.println("Exception  year:"+e.getMessage());
         //}
		//modify by Peggy 20150105
		try
		{     
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2012+1];
			for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2012 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearFr==null?dateBean.getYearString():YearFr));
			arrayComboBoxBean.setFieldName("YEARFR");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}		 


		  String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  }
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#663333" size="2" face="Arial Black">&nbsp;</font>
        <font color="#663333" size="2" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayFr==null)
		  {
		    CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayFr);
		  }
	      arrayComboBoxBean.setFieldName("DAYFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
       <font color="#663333" size="2"><strong><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgCDate"/></strong></font>
        <%
		 // String CurrYearTo = null;	     		 
	     //try
         //{       
         // String a[]={"2012","2013","2014","2015","2016","2017","2018"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearTo==null)
		 // {
		 //   CurrYearTo=dateBean.getYearString();
		 //   arrayComboBoxBean.setSelection(CurrYearTo);
		 // } 
		 // else 
		 // {
		 //   arrayComboBoxBean.setSelection(YearTo);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARTO");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         // out.println("Exception:"+e.getMessage());
         //}
		//modify by Peggy 20150105
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2012+1];
			for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2012 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearTo==null?dateBean.getYearString():YearTo));
			arrayComboBoxBean.setFieldName("YEARTO");	
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}		 
       %>        
       <%
		  String CurrMonthTo = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthTo==null)
		  {
		    CurrMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonthTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthTo);
		  }
	      arrayComboBoxBean.setFieldName("MONTHTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>        
       <%
		  String CurrDayTo = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayTo==null)
		  {
		    CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayTo);
		  }
	      arrayComboBoxBean.setFieldName("DAYTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
    </td>  
	<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCMfgRsUpdateQuery.jsp")' > 
			<input type="reset" name="RESET" align="middle"  value='<jsp:getProperty name="rPH" property="pgReset"/>' onClick='setSubmit2("../jsp/TSCMfgRsUpdateQuery.jsp")' >
			<!--INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit1(this.form.WOTYPE.value,this.form.DATESETBEGIN.value,this.form.DATESETEND.value)' -->  
			
	</td>
   </tr>
  </table>  
<%  
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
%>



  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark='#FFFFFF'>
    <tr bgcolor="#CCCC99"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#663333" size="2" face="Arial">&nbsp;</font></div></td> 
	  <td width="8%" height="22" nowrap><div align="center"><font color="#663333" size="2" face="Arial">流程卡號</font></div></td> 
	  <td width="8%" height="22" nowrap><div align="center"><font color="#663333" size="2" face="Arial"><jsp:getProperty name="rPH" property="pgWorkOrder"/></font></div></td>               
	  <td width="3%" nowrap><div align="center"><font color="#663333" size="2" face="Arial">Market</font></div></td>
      <td width="3%" nowrap><div align="center"><font color="#663333" size="2" face="Arial"><jsp:getProperty name="rPH" property="pgClass"/></font></div></td>           
      <td width="12%" nowrap><div align="center"><font color="#663333" size="2" face="Arial">&nbsp;<jsp:getProperty name="rPH" property="pgPart"/></font></div></td> 
	  <td width="10%" nowrap><div align="center"><font color="#663333" size="2" face="Arial"><jsp:getProperty name="rPH" property="pgItemDesc"/></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#663333" size="2" face="Arial">工令工時數</font></div></td>
	  <td width="6%" nowrap><div align="center"><font color="#663333" size="2" face="Arial"><jsp:getProperty name="rPH" property="pgSchStartDate"/></font></div></td>
	  <td width="6%" nowrap><div align="center"><font color="#663333" size="2" face="Arial"><jsp:getProperty name="rPH" property="pgSchCompletDate"/></font></div></td>
	  <td width="3%" nowrap><div align="center"><font color="#663333" size="2" face="Arial">設立人員</font></div></td>	
	  <td width="6%" nowrap><div align="center"><font color="#663333" size="2" face="Arial">設立日期</font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#663333" size="2" face="Arial">工令狀態</font></div></td>
	  	    
	  	  	  
    </tr>
	
    <% 
	while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "#E3E4B6";
	     }
	    else{
	       colorStr = "#ECEDCD"; }
//
		marketType=rsTC.getString("MARKET_TYPE");
		woType=rsTC.getString("WORKORDER_TYPE");
		woNo=rsTC.getString("WO_NO"); 
		runCardNo=rsTC.getString("RUNCARD_NO"); 
		organizationId=rsTC.getString("ORGANIZATION_ID");
		invItem=rsTC.getString("INV_ITEM");
		itemDesc=rsTC.getString("ITEM_DESC");
		startDate=rsTC.getString("STARTDATE");
		endDate=rsTC.getString("ENDDATE");
		userName=rsTC.getString("USER_NAME");
		createDate=rsTC.getString("CREATEDATE");
		wipEntityId=rsTC.getString("WIP_ENTITY_ID");
		
 
		   
		   

//  欄位辨識
         String marketCode="",woTypeCode="",rsQty="";

	     String sqlm1 = " select code_desc MARKETCODE from yew_mfg_defdata where def_type='MARKETTYPE' and code='"+marketType+"' ";
		//out.print("sqlm1"+sqlm1);		 
		 Statement statem1=con.createStatement();
	     ResultSet rsm1=statem1.executeQuery(sqlm1);
		 if (rsm1.next())
			 { 	marketCode   = rsm1.getString("MARKETCODE");   }
		 rsm1.close();
	     statem1.close();  	
		 
		String sqlm2 = " select code_desc WOTYPECODE from yew_mfg_defdata where def_type='WO_TYPE' and code='"+woType+"' ";
		//out.print("sqlm2"+sqlm2);
		 Statement statem2=con.createStatement();
	     ResultSet rsm2=statem2.executeQuery(sqlm2);
		 if (rsm2.next())
			 { 	woTypeCode   = rsm2.getString("WOTYPECODE");   }
		 rsm2.close();
	     statem2.close();  	
		String sqlm3 = " SELECT SUM (wt.transaction_quantity) RSQTY , decode(WDJ.STATUS_TYPE ,'1','Unrelease','3','Release','4','Complete','7','Cancelled','12','Closed') STATUS "+
		  			   "   FROM wip_transactions wt,  wip_discrete_jobs wdj "+
 					   "  WHERE wt.transaction_type = 1  AND wt.wip_entity_id = wdj.wip_entity_id  AND wt.organization_id = "+organizationId+" AND wt.wip_entity_id =  "+wipEntityId+"  "+
					   "   GROUP BY  WDJ.STATUS_TYPE ";
		 //out.print("sqlm3"+sqlm3);
		 Statement statem3=con.createStatement();
	     ResultSet rsm3=statem3.executeQuery(sqlm3);
		 if (rsm3.next())
			 { 	rsQty     = rsm3.getString("RSQTY");
			    woStatus  = rsm3.getString("STATUS");
			   }
		 rsm3.close();
	     statem3.close();  		 	   

         if (rsQty==null || rsQty.equals("")) rsQty="0";
		   
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td width="2%"><div align="center"><font size="2" color="#006666" face="Arial"><a name='#<%=rsTC.getString("RUNCAD_ID")%>'><% out.println(rs1__index+1);%></a></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><a href="../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO=<%=runCardNo%>&WO_NO=<%=woNo%>"><%=runCardNo%></a></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=woNo%></a></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=marketCode%></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=woTypeCode%></font></div></td>
	  <td ><div align="left"><font size="2" color="#006666" face="Arial"><%=invItem%></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=itemDesc%></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=rsQty%></font></div></td>
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=startDate%></font></div></td>
      <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=endDate%></font></div></td> 
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=userName%></font></div></td>
      <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=createDate%></font></div></td>  
	  <td ><div align="center"><font size="2" color="#006666" face="Arial"><%=woStatus%></font></div></td> 
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
   counta = rs1__index ;
  }
%>
    <tr bgcolor="#CCCC99"> 
      <td height="23" colspan="15" ><font color="#663333" size="2"><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">	 <font color='#000066' face="Arial"><strong><%=counta%></strong></font>
	 
	 </td>      
    </tr>
  </table>

  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="ORGANIZATIONID" type="HIDDEN" value="<%=organizationId%>">
<input type="hidden" name="ITEMID" value="<%=%>" >
<input type="hidden" name="WOUOM" value="<%=%>" >

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
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>
