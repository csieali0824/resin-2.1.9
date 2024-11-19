<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--20100927 Marvie Update : Add INV return STATUSID="029" -->
<html>
<head>
<title>IQC Inspect Lot Data Insert</title>
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
.style17 {
	color: #000099;
	font-family: Georgia;
	font-weight: bold;
	font-size: large;
}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function alertRFQNotSuccess(msRFQCreateMsg)
{
   alert(msRFQCreateMsg);
}
</script>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<!--20100307 Marvie Add : Add MC agree-->
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/>
<!--20100927 Marvie Add : Add INV return-->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); 
String organizationID=request.getParameter("ORGANIZATIONID");
String inspLotNo=request.getParameter("INSPLOTNO"); 
String classID=request.getParameter("CLASSID");
String wfTypeID=request.getParameter("WFTYPEID");   
String wfSizeID=request.getParameter("WFSIZEID");
String diceSize=request.getParameter("DICESIZE");
String wfThick=request.getParameter("WFTHICK");
String wfResist=request.getParameter("WFRESIST");  
String poNumber=request.getParameter("PONUMBER");
String packMethod=request.getParameter("PACKMETHOD");
String waferAmp=request.getParameter("WAFERAMP");
String prodName=request.getParameter("PRODNAME");
String prodModel=request.getParameter("PRODMODEL");
String sampleQty=request.getParameter("SAMPLEQTY");
String supplierID=request.getParameter("SUPPLIERID"); 
String supplierName=request.getParameter("SUPPLIERNAME"); 
String supSiteID=request.getParameter("SUPSITEID");
String supSiteName=request.getParameter("SUPSITENAME"); 
String receiptNo=request.getParameter("RECEIPTNO"); 
String inspectDate=request.getParameter("INSPECTDATE"); 
String wfPlatID=request.getParameter("WFPLATID");
String waiveLot=request.getParameter("WAIVELOT"); 
String grainQty=request.getParameter("GRAINQTY"); //2007/04/06 liling  
String prodYield=request.getParameter("PRODYIELD");
String totalYield=request.getParameter("TOTALYIELD");
String iMatCode=request.getParameter("IMATCODE");
String remark=request.getParameter("REMARK");
String requireReason=request.getParameter("REQUIREREASON"); 
String preOrderType=request.getParameter("PREORDERTYPE"); 
String a[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容
String seqno=null;
String seqkey=null;
String dateString=null;
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String fromStatusID=request.getParameter("FROMSTATUSID");
if (fromStatusID==null) fromStatusID=""; //add by Peggy 20130129
String actionID=request.getParameter("ACTIONID");
String inspectID=userID;
String receiptSource=request.getParameter("RECEIPTSOURCE");
String expDateFlag="N"; //20110117 預設N不需檢查expirationDate,有帶lot者,則需改為'Y'
String returnFlag="N"; //20110127  預設N ,lot 沒有退貨紀錄
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
if (remark==null || remark.equals("")) remark="";
if (typeNo==null || typeNo.equals("")) typeNo="001"; // 暫時未分QC種類, 預設 "001"->IQC ,  "002"->OQC  
if (sampleQty==null || sampleQty.equals("")) sampleQty="0";
if (formID==null) formID = "QC";       // 此為預設為取 IQC 的 FLOW 狀態表,用 TYPE = 001區分 IQC;  TYPE =002 OQC
if (receiptSource==null || receiptSource.equals("--")) 
{  
	if (classID!=null && !classID.equals("06")) // 不為RMA類型
    {  
    	receiptSource="1";
	} 
	else 
	{  // RMA 類型的檢驗
		classID="06";
	    receiptSource="2";
	}
}
String result=request.getParameter("RESULT"); //add by Peggy 20121219
if (result==null) result="N/A";
String resultname="N/A";
if (actionID.equals("016"))  // 選擇ACCEPT , 則為 檢驗合格
{ 
	result = "01";	
	resultname = "ACCEPT";
}  
else if (actionID.equals("005"))  // 選擇REJECT , 則為 檢驗判退
{ 
    result = "02"; 
	resultname = "REJECT";
} 

String NGREASON = request.getParameter("NGREASON");     //add by Peggy 20121219
if (NGREASON == null) NGREASON ="";
String headerProdYield=request.getParameter("HEADERPRODYIELD");  //add by Peggy 20121220
if (headerProdYield==null) headerProdYield="";
String headerTotalYield=request.getParameter("HEADERTOTALYIELD"); //add by Peggy 20121220
if (headerTotalYield==null) headerTotalYield="";

String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();

if (userInspDeptID==null || userInspDeptID.equals("")) 
{  
	// 2007/01/05_避免檢驗部門別未於登錄時沒有取出_起      
    Statement stateDeptID=con.createStatement();   
    ResultSet rsDeptID=stateDeptID.executeQuery("select QCDEPT_ID from ORADDMAN.TSCIQC_INSPECT_USER where QCUSER_NAME = '"+UserName+"' ");
    if (rsDeptID.next())
    {
    	userInspDeptID=rsDeptID.getString(1);
    } 
	else 
	{
		userInspDeptID="01";
	}
    rsDeptID.close();
    stateDeptID.close();   
}
  
String q[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容		
if (q!=null) 
{			   
	out.println(arrayIQCDocumentInputBean.getArray2DIQCString());
}
String customer="";
String defaultLineType="";
int RepTimes=0;
String agentNo=request.getParameter("AGENTNO"); //經銷/代理商編號
String recType=request.getParameter("RECTYPE"); //收件來源型態
String qty=request.getParameter("QTY"); //收件數量
String fromPage=request.getParameter("FROMPAGE");
String repeatInput=request.getParameter("REPEATINPUT");
String orgOU = "";
Statement stateOU=con.createStatement();   
ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
if (rsOU.next())
{
	orgOU = rsOU.getString(1);
}
rsOU.close();
stateOU.close();

CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
cs1.setString(1,orgOU);  // 取品管人員隸屬OrgID
cs1.execute();
cs1.close();  
  
//if (actionID.equals("002"))    // E1-001 INSPECTOR insert
if (fromStatusID.equals("020") && (actionID.equals("002") || actionID.equals("016") || actionID.equals("005")))    //action=027,add by Peggy 20121219
{
	try
	{  
  		if (inspLotNo==null || inspLotNo.equals(""))
  		{  
   			dateString=dateBean.getYearMonthDay();   
   			if (classID==null || classID.equals("--")) seqkey="IQC"+classID+dateString; //但仍以預設為使用者地區
   			else seqkey="IQC"+classID+dateString;         // 2006/09/10 改以選擇的檢驗類型號產生單號   
   			Statement statement=con.createStatement();
   			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSQCDOCSEQ where header='"+seqkey+"' and TYPE_CODE ='IQC' ");
  
   			if (rs.next()==false)
   			{   
    			String seqSql="insert into ORADDMAN.TSQCDOCSEQ values(?,?,?)";   
    			PreparedStatement seqstmt=con.prepareStatement(seqSql);     
    			seqstmt.setString(1,seqkey);
    			seqstmt.setInt(2,1);   
				seqstmt.setString(3,"IQC");   
	
    			seqstmt.executeUpdate();
    			seqno=seqkey+"-001";
    			seqstmt.close();   
   			} 
   			else 
   			{
    			int lastno=rs.getInt("LASTNO");
    			String sql = "select * from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO = '"+seqno+"' ";
    			ResultSet rs2=statement.executeQuery(sql); 
    			if (rs2.next())
    			{         
      				lastno++;
      				String numberString = Integer.toString(lastno);
      				String lastSeqNumber="000"+numberString;
      				lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
      				seqno=seqkey+"-"+lastSeqNumber;     
   
      				String seqSql="update ORADDMAN.TSQCDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE_CODE ='IQC' ";   
      				PreparedStatement seqstmt=con.prepareStatement(seqSql);        
      				seqstmt.setInt(1,lastno);   
      				seqstmt.executeUpdate();   
      				seqstmt.close(); 
    			} 
    			else
    			{
      				//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依檢驗類型別)
      				String sSqlSeq = "select to_number(substr(max(INSPLOT_NO),15,3)) as LASTNO from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where substr(INSPLOT_NO,1,13)='"+seqkey+"' ";
      				ResultSet rs3=statement.executeQuery(sSqlSeq);
	  				if (rs3.next()==true)
	  				{
       					int lastno_r=rs3.getInt("LASTNO");
	   					lastno_r++;
	   					String numberString_r = Integer.toString(lastno_r);
       					String lastSeqNumber_r="000"+numberString_r;
       					lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
       					seqno=seqkey+"-"+lastSeqNumber_r;  
	 
	   					String seqSql="update ORADDMAN.TSQCDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE_CODE ='IQC' ";   
       					PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       					seqstmt.setInt(1,lastno_r);   
       					seqstmt.executeUpdate();   
       					seqstmt.close();  
	  				} 
     			} 
    		}
			inspLotNo = seqno;
  		} 
  		else 
		{
        	String inspLotNoSub = inspLotNo.substring(5,inspLotNo.length());
          	inspLotNo = "IQC"+classID+inspLotNoSub;
		  	seqno = inspLotNo;
       	}
		
  		Statement getStatusStat=con.createStatement();  
  		ResultSet getStatusRs=getStatusStat.executeQuery("select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND TYPENO='"+typeNo+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'");  
  		getStatusRs.next();  
		//out.println("select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND TYPENO='"+typeNo+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'");
  		String sql= " insert into ORADDMAN.TSCIQC_LOTINSPECT_HEADER(INSPLOT_NO, SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_SITE_ID, SUPPLIER_SITE_NAME, PO_NUMBER, RECEIPT_NO, IQC_CLASS_CODE,"+ // 8
                    " LOT_QTY, SUPPLY_LOT_NO, PACK_METHOD, WAFER_AMP, MECH_EXAM, DIMEN_EXAM , ELEC_EXAM, PULL_EXAM, PEELING_EXAM, QUANTITY_EXAM, TOTAL_YIELD, "+ //11
					" PROD_MODEL, PROD_NAME , PROD_YIELD, SAMPLE_QTY, INSPECT_QTY, UOM, VERSION, UNITS, RESULT, STATUSID, STATUS, WAFER_TYPE, WAFER_SIZE, DICE_SIZE, WF_THICK, WF_RESIST, "+ //16
					" PLAT_LAYER, WAIVE_LOT, INSPECT_REMARK, INSPECTOR, INSPECT_DEPT, INSPECT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,ORG_ID, ORGANIZATION_ID,IMATCODE)"+ 
                    " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
  		PreparedStatement pstmt=con.prepareStatement(sql);  
  		pstmt.setString(1,seqno);  // 檢驗批單號
  		pstmt.setString(2,supplierID); // SUPPLIER_ID 供應商識別碼
  		pstmt.setString(3,supplierName);  // SUPPLIER_NAME 供應商名稱
  		pstmt.setString(4,supSiteID);  // SUPPLIER_SITE_ID 供應出貨地識別碼
  		pstmt.setString(5,supSiteName); // SUPPLIER_SITE_NAME 供應出貨地名  
  		pstmt.setString(6,poNumber); // PO_NUMBER 採購單號 (Header 參考)
		pstmt.setString(7,receiptNo); //RECEIPT_NO 收料單號(暫收) (Header 參考)
		pstmt.setString(8,classID);  // IQC_CLASS_CODE 檢驗類別代碼 (01晶片晶粒,02主要原物料,03間接原物料,04...)
		pstmt.setInt(9,0);  // LOT_QTY 檢驗總批量 加總
		pstmt.setString(10,"N/A");  // SUPPLY_LOT_NO 供應商批號
		pstmt.setString(11,packMethod);  // PACK_METHOD 包裝方式
		pstmt.setString(12,waferAmp); // WAFERAMP 晶片安培數
		pstmt.setString(13,"N"); // MECH_EXAM 外觀檢驗 "Y/N Default N ...到檢驗時決定
		pstmt.setString(14,"N"); // DIMEN_EXAM  尺寸檢驗"Y/N Default N ...到檢驗時決定
		pstmt.setString(15,"N"); // ELEC_EXAM  電性檢驗"Y/N Default N ...到檢驗時決定
		pstmt.setString(16,"N"); // PULL_EXAM  焊接測試"Y/N Default N ...到檢驗時決定
		pstmt.setString(17,"N"); // PEELING_EXAM  剝裂測試"Y/N Default N ...到檢驗時決定
		pstmt.setString(18,"N"); // QUANTITY_EXAM 數量檢查"Y/N Default N ...到檢驗時決定
		//pstmt.setString(19,totalYield); // TOTAL_YIELD 電性良品率
		pstmt.setString(19,headerProdYield); //modify by peggy 20121220
		pstmt.setString(20,prodModel); // PROD_MODEL 適用產品(型號)
		pstmt.setString(21,prodName); // PROD_NAME 物料名稱
		//pstmt.setString(22,prodYield); // PROD_YIELD 型號良品率
		pstmt.setString(22,headerProdYield); //modify by Peggy 20121220
		pstmt.setInt(23,Integer.parseInt(sampleQty)); // SAMPLE_QTY 抽樣數
		pstmt.setInt(24,0); // INSPECT_QTY 檢驗數 = Total receipt Qty
		pstmt.setString(25,"N/A"); // UOM 收料單位
		pstmt.setString(26,"N/A"); // VERSION 品檢版本
		pstmt.setString(27,"N/A"); // UNITS 檢驗單位
		pstmt.setString(28,resultname ); // RESULT 檢驗結果  
		pstmt.setString(29,getStatusRs.getString("TOSTATUSID"));//寫入STATUSID
		pstmt.setString(30,getStatusRs.getString("STATUSNAME"));//寫入狀態名稱  
		pstmt.setString(31,wfTypeID); // WAFER_TYPE 晶片類型 (01,02,03,04,05) 同一檢驗批可否檢多種晶片類型
		pstmt.setString(32,wfSizeID); // WAFER_SIZE 晶片尺寸 (01,02,03) 同一檢驗批可否檢多種晶片尺寸
		pstmt.setString(33,diceSize);// DICE_SIZE 晶粒尺寸
		pstmt.setString(34,wfThick);// WAFER 晶片厚度
		pstmt.setString(35,wfResist);// WAFER 電阻係數
		pstmt.setString(36,wfPlatID);// PLAT_LAYER 鍍層種類  
		pstmt.setString(37,waiveLot);// WAIVE LOT 特採批waiveLot
		pstmt.setString(38,NGREASON); // INSPECT_REMARK 備註說明
		pstmt.setString(39,UserName); // INSPECTOR 檢驗人員名
		pstmt.setString(40,userInspDeptID); // INSPECTOR 檢驗單位  
		pstmt.setString(41,inspectDate+dateBean.getHourMinuteSecond()); //寫入檢驗日期 + 時間
		pstmt.setString(42,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //CREATION_DATE日期  
		pstmt.setString(43,userID); //寫入User ID
		pstmt.setString(44,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //CREATION_DATE日期 
		pstmt.setString(45,userID); //最後更新User 
		pstmt.setString(46,userQCOrgID); //ORG_ID  
		pstmt.setString(47,organizationID); //ORGANIZATION_ID 
		if (iMatCode==null || iMatCode.equals("--")) iMatCode = "N/A";  // 若未選定物料種類,則表示未分類
		pstmt.setString(48,iMatCode); //間接原物料種類  
		pstmt.executeQuery();
		//pstmt.executeUpdate(); 
		//pstmt.close();
  		float sumInspectQty = 0; // 累計檢驗數量,作為更新頭檔LOTQTY及SAMPLEQTY依據

  		if (a!=null) // 判斷入若session Array 內值不為null
  		{  
        	String sqlDtl=" insert into ORADDMAN.TSCIQC_LOTINSPECT_DETAIL(INSPLOT_NO,LINE_NO,INTERFACE_TRANSACTION_ID,PO_NO,PO_QTY,RECEIPT_NO,INV_ITEM_ID,INV_ITEM,INV_ITEM_DESC,"+
                          " AUTHOR_NO, INSPECT_REQUIRE, WAFER_AMP, RECEIPT_QTY, SUPPLIER_LOT_NO, SUPPLIER_SITE_ID ,TOTAL_YIELD, PRODUCTS, PROD_YIELD, SAMPLE_QTY, INSPECT_QTY, UOM, VERSION, "+
					      " UNITS, RESULT, LSTATUSID, LSTATUS, WAFER_TYPE, WAFER_SIZE, MECH_NG_QTY, INTACT_NG_QTY, SHORTAGE_QTY, PULL_JUDGE, PEELING_QTY, VOID_QTY, OXGN_QTY ,ELEC_EXTYPE , DICE_SIZE,"+
					      " CPK, UCL, LCL, WAIVE_ITEM, INSPECT_REMARK, INSPECTOR, INSPECT_DEPT, INSPECT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, "+
					      " PO_HEADER_ID, PO_LINE_ID, PO_LINE_LOCATION_ID, SHIP_TO_LOCATION_ID, SUPPLIER_ID, TO_ORGANIZATION_ID, UNIT_MEAS_LOOKUP_CODE, CURRENCY_CONVERSION_TYPE,"+
					      " ROUTING, EMPLOYEE_ID, ORGANIZATION_ID, RECEIPT_DATE, ORG_ID, IMATCODE, SHIPMENT_LINE_ID, SHIPMENT_HEADER_ID, PO_DISTRIBUTION_ID, NOTE_TO_RECEIVER,GRAINQTY,EXPDATE_FLAG,RTN_FLAG,COMMENTS)"+  //add COMMENTS field  by Peggy 20121219
                          " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
   			for (int ac=0;ac<a.length;ac++)
   			{ 	 
      			String invItemID = "";
      			String invItemDesc = "";
      			String transactUOM = "";
      			String supplier = "";
      			supplierID = "";
      			String supplierSiteID = "";
      			String receiptDate = "";
      			poNumber = "";
	  			String poQty = "";	  
	  			String poHeaderID="",poLineID ="",poLineLocID ="",shipToLocID ="",toOrganID = "";
      			String unitMCode = "",currConvType = "",routing = "",empID = "";
	  			int shipmentLineID = 0, shipmentHdrID=0, poDistributionID=0;
	  			String noteToReceiver = ""; // For 檢驗外購的MO單號
	  			String sqlBasic = "";
      			Statement stateBasic=con.createStatement();
	  			if (receiptSource==null || receiptSource.equals("1"))
	  			{
            		sqlBasic = " select /*+ ORDERED index(b RCV_TRANSACTIONS_N11)  */ "+
	                           " ITEM_ID, ITEM_DESC, TRANSACT_UOM, SUPPLIER, SUPPLIER_ID, SUPPLIER_SITE, SUPPLIER_SITE_ID, "+
							   " RECEIPT_DATE, PO_NUM, SOURCE_DOC_QTY, to_char(RECEIPT_DATE,'YYYYMMDDHH24MISS') as REC_DATE, "+
						       " PO_HEADER_ID, PO_LINE_ID, PO_LINE_LOCATION_ID, SHIP_TO_LOCATION_ID, TO_ORGANIZATION_ID, "+
						       " UNIT_MEAS_LOOKUP_CODE, CURRENCY_CONVERSION_TYPE, ROUTING, EMPLOYEE_ID, ORGANIZATION_ID, SHIPMENT_LINE_ID, SHIPMENT_HEADER_ID, PO_DISTRIBUTION_ID, "+
							   " NOTE_TO_RECEIVER "+
                               " from APPS.RCV_VRC_TXS_V where TRANSACTION_TYPE='RECEIVE' and DESTINATION_TYPE_CODE = 'RECEIVING' "+
				               " and INTERFACE_TRANSACTION_ID = "+a[ac][1]+" and to_char(RECEIPT_NUM) = '"+a[ac][2]+"' ";
	  			} 
				else if (receiptSource.equals("2"))
	         	{
			    	sqlBasic = " SELECT RSL.ITEM_ID, MSI.DESCRIPTION as ITEM_DESC, RT.UNIT_OF_MEASURE as TRANSACT_UOM, RC.CUSTOMER_NAME as SUPPLIER, RC.CUSTOMER_NUMBER as SUPPLIER_ID, RT.CUSTOMER_SITE_ID as SUPPLIER_SITE_ID,  "+
				               " to_char(RT.TRANSACTION_DATE,'YYYYMMDDHH24MISS') as RECEIPT_DATE,  OOHA.ORDER_NUMBER as PO_NUM, RT.SOURCE_DOC_QUANTITY as SOURCE_DOC_QTY,  to_char(RT.TRANSACTION_DATE,'YYYYMMDDHH24MISS') as REC_DATE, "+
							   " RT.OE_ORDER_HEADER_ID as PO_HEADER_ID, RT.OE_ORDER_LINE_ID as PO_LINE_ID, RT.PO_LINE_LOCATION_ID, RSL.SHIP_TO_LOCATION_ID, RSL.TO_ORGANIZATION_ID, "+
							   " RT.UNIT_OF_MEASURE as UNIT_MEAS_LOOKUP_CODE, RT.CURRENCY_CONVERSION_TYPE, RT.ROUTING_STEP_ID as ROUTING, RT.EMPLOYEE_ID, RT.ORGANIZATION_ID, RSL.SHIPMENT_LINE_ID, RSH.RECEIPT_NUM, RSH.SHIPMENT_HEADER_ID, RSL.PO_DISTRIBUTION_ID, "+	
							   " '' as NOTE_TO_RECEIVER "+			          
							   " FROM RCV_TRANSACTIONS RT , RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES RSL, "+
							   " OE_ORDER_HEADERS_ALL OOHA, RA_CUSTOMERS RC , MTL_SYSTEM_ITEMS MSI "+
                               " where RT.TRANSACTION_TYPE='RECEIVE' and RT.DESTINATION_TYPE_CODE = 'RECEIVING' "+
						  	   " and RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID and RT.SOURCE_DOCUMENT_CODE='RMA' "+
							   " AND RT.SHIPMENT_LINE_ID=RSL.SHIPMENT_LINE_ID "+
							   " AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID  "+
							   " AND RSH.RECEIPT_SOURCE_CODE='CUSTOMER' AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID "+
						 	   " AND MSI.ORGANIZATION_ID=RSH.ORGANIZATION_ID AND MSI.ORGANIZATION_ID=RT.ORGANIZATION_ID "+
							   " AND RT.TRANSACTION_TYPE='RECEIVE' AND OOHA.HEADER_ID=RT.OE_ORDER_HEADER_ID AND RC.CUSTOMER_ID=RT.CUSTOMER_ID  "+
				               " and RT.INTERFACE_TRANSACTION_ID = "+a[ac][1]+" and to_char(RSH.RECEIPT_NUM) = '"+a[ac][2]+"' "; 
			 	}            
      			
				ResultSet rsBasic=stateBasic.executeQuery(sqlBasic);
      			if (rsBasic.next())
      			{ 
        			invItemID = rsBasic.getString("ITEM_ID");		
	    			invItemDesc = rsBasic.getString("ITEM_DESC");		
	    			transactUOM = rsBasic.getString("TRANSACT_UOM");		
	    			supplier = rsBasic.getString("SUPPLIER");		
	    			supplierID = rsBasic.getString("SUPPLIER_ID"); 		
	    			supplierSiteID = rsBasic.getString("SUPPLIER_SITE_ID");		
	    			receiptDate = rsBasic.getString("RECEIPT_DATE");		
	    			poNumber = rsBasic.getString("PO_NUM");  		
					poQty = rsBasic.getString("SOURCE_DOC_QTY");
					receiptDate = rsBasic.getString("REC_DATE"); 		
					poHeaderID = rsBasic.getString("PO_HEADER_ID"); 
					poLineID = rsBasic.getString("PO_LINE_ID"); 
					poLineLocID = rsBasic.getString("PO_LINE_LOCATION_ID");
					shipToLocID = rsBasic.getString("SHIP_TO_LOCATION_ID");
					toOrganID = rsBasic.getString("TO_ORGANIZATION_ID");
					unitMCode = rsBasic.getString("UNIT_MEAS_LOOKUP_CODE");
					currConvType = rsBasic.getString("CURRENCY_CONVERSION_TYPE");
					routing = rsBasic.getString("ROUTING");
					empID = rsBasic.getString("EMPLOYEE_ID");
					organizationID = rsBasic.getString("ORGANIZATION_ID");	
					shipmentLineID = rsBasic.getInt("SHIPMENT_LINE_ID");
					shipmentHdrID =	rsBasic.getInt("SHIPMENT_HEADER_ID");
					poDistributionID = rsBasic.getInt("PO_DISTRIBUTION_ID");
					noteToReceiver = rsBasic.getString("NOTE_TO_RECEIVER"); // For 檢驗外購的MO單號
					
					//檢查shipment_line_id是否存在,add by Peggy 20121220
					Statement statek=con.createStatement();
       			    ResultSet rsk=statek.executeQuery("select 1 from oraddman.tsciqc_lotinspect_detail a where shipment_line_id='"+shipmentLineID+"'");
	   			    if (rsk.next())
	   				{
						throw new Exception("shipment line id is duplicate!!");
					}
					statek.close();
					rsk.close();
      			}    
      			rsBasic.close();
      			stateBasic.close();   

	   			String sqlfnd = " SELECT COUNT(MMT.TRANSACTION_ID)  FROM MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTN "+
  	  			                " WHERE MMT.TRANSACTION_TYPE_ID=36  AND MMT.ORGANIZATION_ID=MTN.ORGANIZATION_ID  "+
                                " AND MMT.TRANSACTION_ID = MTN.TRANSACTION_ID AND MMT.INVENTORY_ITEM_ID = MTN.INVENTORY_ITEM_ID "+
     				            " AND MMT.ORGANIZATION_ID='"+organizationID+"' AND MMT.INVENTORY_ITEM_ID='"+invItemID+"' "+
	 				            " AND MTN.LOT_NUMBER = '"+a[ac][11]+"'  ";
	   			Statement stateFndId=con.createStatement();
       			ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
	   			if (rsFndId.next())
	   			{
	    			if (rsFndId.getInt(1) > 1) 
           			{ 
						returnFlag="Y";
					} 
         			else  
           			{ 
						returnFlag="N";
					} 
	   			}
	   			rsFndId.close();
   	   			stateFndId.close();
	  			PreparedStatement pstmtDtl=con.prepareStatement(sqlDtl);  
      			pstmtDtl.setString(1,seqno);  // 檢驗批號	   
	  			pstmtDtl.setInt(2,ac+1);         // Line_No // 給料項序號	  
      			pstmtDtl.setString(3,a[ac][1]); // INTERFACE_TRANSACTION_ID  
	  			pstmtDtl.setString(4,poNumber); // PO NUMBER
	  			pstmtDtl.setFloat(5,Float.parseFloat(poQty)); // PO Qty
	  			pstmtDtl.setString(6,a[ac][2]); // Receipt Number
	  			pstmtDtl.setString(7,invItemID); // Inventory Item ID
	  			pstmtDtl.setString(8,a[ac][3]); // Inventory Item
	  			pstmtDtl.setString(9,invItemDesc); // Inventory Item Desc
	  			pstmtDtl.setString(10,a[ac][10]); // Authorize No.. 零件承認編號
	  			pstmtDtl.setString(11,a[ac][12]); // Inspect Require 檢驗要求(預設找供應商免檢清單)
	  			pstmtDtl.setString(12,waferAmp); // waferAmp 晶片安培數
	  			pstmtDtl.setFloat(13,Float.parseFloat(a[ac][5])); // RECEIPT_QTY 收料數量
	  			pstmtDtl.setString(14,a[ac][11]); // SUPPLIER_LOT_NO 供應商進料批號
	  			pstmtDtl.setString(15,supplierSiteID); // 供應商出貨地識別碼
	  			pstmtDtl.setString(16,a[ac][9]); // TOTAL_YIELD 電性良品率
	  			//pstmtDtl.setString(17,"N/A"); // PRODUCTS 適用產品
				pstmtDtl.setString(17,invItemDesc); //PRODUCTS 適用產品,modify by Peggy 20121219
	  			pstmtDtl.setString(18,a[ac][8]); // PROD_YIELD 型號良品率  //20091118 liling update
	  			pstmtDtl.setFloat(19,Float.parseFloat(a[ac][5])); //SAMPLE_QTY 抽樣數
	  			pstmtDtl.setFloat(20,Float.parseFloat(a[ac][5])); //INSPECT_QTY 檢驗數 =  收料數量
	  			pstmtDtl.setString(21,transactUOM);  // UOM 收料單位
	 	 		pstmtDtl.setString(22,"0");    //VERSION 檢驗版本
	  			pstmtDtl.setString(23,transactUOM);    // UNITS 檢驗單位 = 收料單位
	  			//pstmtDtl.setString(24,"N/A");    // RESULT 檢驗結果
				pstmtDtl.setString(24,result);     //RESULT,modify by Peggy 20121219
	  			pstmtDtl.setString(25,getStatusRs.getString("TOSTATUSID"));    // LSTATUSID 工作流程狀態識別碼
	  			pstmtDtl.setString(26,getStatusRs.getString("STATUSNAME")); // LSTATUSID 工作流程狀態 Name
	  			pstmtDtl.setString(27,wfTypeID); // WAFER_TYPE 晶片類型 (01,02,03,04,05) 同一檢驗批可否檢多種晶片類型
	  			pstmtDtl.setString(28,wfSizeID); // WAFER_SIZE 晶片尺寸 (01,02,03) 同一檢驗批可否檢多種晶片尺寸
	  			pstmtDtl.setInt(29,0); // MECH_NG_QTY  外觀不良數
	  			pstmtDtl.setInt(30,0); // INTACT_NG_QTY 破片數 
	  			pstmtDtl.setInt(31,0); // SHORTAGE_QTY 短缺數 
	  			pstmtDtl.setString(32,"N/A"); // PULL_JUDGE 拉力總評 
	  			pstmtDtl.setInt(33,0); // PEELING_QTY  剝裂數
	  			pstmtDtl.setInt(34,0); // VOID_QTY  氣泡數
	  			pstmtDtl.setInt(35,0); // OXGN_QTY  氧化數
	  			pstmtDtl.setString(36,"N/A"); // ELEC_EXTYPE  電性測試類型
	  			pstmtDtl.setString(37,diceSize); // DICE_SIZE  晶粒尺寸(01,02,03) 同一檢驗批可否檢多種晶粒尺寸?
	  			pstmtDtl.setInt(38,0); // CPK  製程能力值
	  			pstmtDtl.setInt(39,0); // UCL 原物料檢測上限
	  			pstmtDtl.setInt(40,0); // LCL 原物料檢測下限
	  			pstmtDtl.setString(41,waiveLot); // WAIVE_ITEM 特採項目 
	  			//pstmtDtl.setString(42,"N/A"); // 備註說明
				pstmtDtl.setString(42,NGREASON); //備註說明,modify by Peggy 20121225
	  			pstmtDtl.setString(43,UserName); // INSPECTOR 檢驗人員名
	  			pstmtDtl.setString(44,userInspDeptID); // INSPECTOR 檢驗單位
	  			pstmtDtl.setString(45,inspectDate+dateBean.getHourMinuteSecond()); // INSPECT_DATE 檢驗日期
	  			pstmtDtl.setString(46,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 開單日期
	 	 		pstmtDtl.setString(47,userID); // 開單人員
	  			pstmtDtl.setString(48,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  // LAST_UPDATED_DATE 維護日期
	  			pstmtDtl.setString(49,userID); // LAST_UPDATED_BY 維護人員
	  			pstmtDtl.setString(50,poHeaderID); // PO_HEADER_ID 	
	  			pstmtDtl.setString(51,poLineID); // PO_LINE_ID  
	  			pstmtDtl.setString(52,poLineLocID); // PO_LINE_LOC_ID 
	  			pstmtDtl.setString(53,shipToLocID); 
	  			pstmtDtl.setString(54,supplierID); // SupplierID
	  			pstmtDtl.setString(55,toOrganID); 
	  			pstmtDtl.setString(56,unitMCode);
	  			pstmtDtl.setString(57,currConvType);
	  			pstmtDtl.setString(58,routing);  
	  			pstmtDtl.setString(59,empID);  
	  			pstmtDtl.setString(60,organizationID);
	  			pstmtDtl.setString(61,receiptDate);  // RECEIPT_DATE
	  			pstmtDtl.setString(62,userQCOrgID);  // OEG_ID
	  			pstmtDtl.setString(63,iMatCode);     //間接原物料種類 
	  			pstmtDtl.setInt(64,shipmentLineID);     //原ShipmentLineID
	  			pstmtDtl.setInt(65,shipmentHdrID);      //原ShipmentHaderID 
	  			pstmtDtl.setInt(66,poDistributionID);   //原poDistributionID 
	  			pstmtDtl.setString(67,noteToReceiver);  // For 檢驗外購的MO單號
	  			pstmtDtl.setFloat(68,Float.parseFloat(a[ac][7])); // 晶粒數量
				String sqlefnd = " SELECT SHELF_LIFE_CODE FROM mtl_system_items WHERE organization_id='"+invItemID+"'   AND inventory_item_id='"+organizationID+"'  ";
	     		Statement stateFndeId=con.createStatement();
         		ResultSet rsFndeId=stateFndeId.executeQuery(sqlefnd);
	     		if (rsFndeId.next())
	     		{
	       			if (rsFndeId.getString(1)=="4" || rsFndeId.getString(1).equals("4"))  // SHELF_LIFE_CODE=4 則要有到期日
             		{ 
						expDateFlag="Y";
					}  
          			else  
             		{ 
						expDateFlag="N";
					} 
	     		}
	     		rsFndeId.close();
   	     		stateFndeId.close();

	  			pstmtDtl.setString(69,expDateFlag); // 20110117
	  			pstmtDtl.setString(70,returnFlag); // 20110127
				pstmtDtl.setString(71,(a[ac][13]==null?"":a[ac][13]));  //COMMENTS,add by Peggy 20121219
				pstmtDtl.executeQuery();
	  			//pstmtDtl.executeUpdate(); 
     	 		//pstmtDtl.close();  	  
	  			sumInspectQty= sumInspectQty + Float.parseFloat(a[ac][5]); // 累加檢驗數量

				//add by Peggy 20121219
 				if (actionID.equals("016") || actionID.equals("005"))
				{
          			// 處理歷程檔寫入_起	
					Statement statementx=con.createStatement();
					ResultSet rsx =statementx.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
					rsx.next();
					String actionName=rsx.getString("ACTIONNAME");

					rsx=statementx.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
					rsx.next();
					String oriStatus=rsx.getString("STATUSNAME");   
					statementx.close();
					rsx.close();	
										
					int deliveryCount = 0;
					Statement stateDeliveryCNT=con.createStatement(); 
					ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+seqno+"' and LINE_NO='"+(ac+1)+"' ");
					if (rsDeliveryCNT.next())
					{
						deliveryCount = rsDeliveryCNT.getInt(1);
					}
					rsDeliveryCNT.close();
					stateDeliveryCNT.close();
				
					String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
									" ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
									 "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
					PreparedStatement historystmt=con.prepareStatement(historySql);   
					historystmt.setString(1,seqno); 
					historystmt.setString(2,""+(ac+1));  
					historystmt.setString(3,fromStatusID); 
					historystmt.setString(4,oriStatus);
					historystmt.setString(5,actionID); 
					historystmt.setString(6,actionName);
					historystmt.setString(7,UserName);
					historystmt.setString(8,dateBean.getYearMonthDay()); 
					historystmt.setString(9,dateBean.getHourMinuteSecond()); 
					historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					historystmt.setString(11,(a[ac][13]==null?"":a[ac][13]));
					historystmt.setInt(12,deliveryCount);		      
					historystmt.executeQuery();
					//historystmt.executeUpdate(); 
					//historystmt.close(); 
					
					if (actionID.equals("005") && sendMailOption!=null && sendMailOption.equals("YES"))
					{ 
						Statement stateList=con.createStatement();
						String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSC_MC_USER b where a.USERNAME = b.MC_USERID and b.TSC_DEPT_ID = 'YEW_MC' ";
						ResultSet rsList=stateList.executeQuery(sqlList);
						while (rsList.next())
						{         
							sendMailBean.setMailHost(mailHost);
							sendMailBean.setReception(rsList.getString("USERMAIL"));		        
							sendMailBean.setFrom(UserName);   	 	 
							sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統品管檢驗不合格通知"));                  
							sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:品管檢驗批檢驗不合格-檢驗批單號("+seqno+")"));   	 
							sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotWaivingPage.jsp?INSPLOTNO="+seqno+"&LSTATUSID=022");//				   
							sendMailBean.sendMail();
						} 
						rsList.close();
						stateList.close();	   
					} 
					  
				}				
   			}
  		}
		else
		{
			throw new Exception("No Detail Data!!");
		}
  		
		if (sumInspectQty>0)
  		{
        	String sqlUpdate= "update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set SAMPLE_QTY=?, INSPECT_QTY=?, LOT_QTY=? where INSPLOT_NO = '"+inspLotNo+"' ";
			PreparedStatement pstmtUpd=con.prepareStatement(sqlUpdate);
			pstmtUpd.setFloat(1,sumInspectQty); 
			pstmtUpd.setFloat(2,sumInspectQty);
			pstmtUpd.setFloat(3,sumInspectQty);
			pstmtUpd.executeQuery();
			//pstmtUpd.executeUpdate(); 
            //pstmtUpd.close();   
  		}
  
  		con.commit();
		
  		out.println("insert into IQC Inspection Lot Information value(");%>品管IQC檢驗批單號<%out.println(":<font color=#FF0000>"+seqno+"</font>- (");%><%out.println(":<font color=#660000>"+RepTimes+"</font>) OK!<BR>"); 
  		out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSIQCInspectLotHistoryQueryAll.jsp?INSPLOTNO="+seqno+"'>");%>檢驗批單據歷程查詢<%out.println("(by Inspect Lot Doc No.)</A>");
  		out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSIQCInspectLotInput.jsp'>");%>品管IQC檢驗批輸入頁面<%out.println("</A>");
  		getStatusRs.close();
  		pstmt.close();  
 	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font color='red'>Exception1:"+e.getMessage()+"</font>");
	}
}

if (!fromStatusID.equals("020") && (actionID.equals("004") || actionID.equals("005")))    // D1-012 004:Receipt MC agree    005:Receipt MC reject
{
	try
	{
    	String arrIQCSearch[][]=arrayIQCSearchBean.getArray2DContent();
    	String [] choice=request.getParameterValues("CH");
		String sMCAgreeflag="N";
		if (actionID.equals("004")) sMCAgreeflag="Y";
    	String sMailFlag = "";      // 20100927 Marvie Add : Add INV return
    	
		for (int k=0;k<choice.length;k++)
    	{
	  		for (int m=0;m<arrIQCSearch.length-1;m++)
	  		{
	    		if (choice[k].equals(arrIQCSearch[m][1]))
				{
          			out.println("<BR>Processing MC agree/reject value(ID:"+arrIQCSearch[m][1]+") ");
		  
		 	 		String sql=" UPDATE rcv_transactions"+
		                       " SET attribute12='"+sMCAgreeflag+"|'||TO_CHAR(sysdate,'DD-MON-YYYY HH24:MI:SS')||'|'||UPPER('"+UserName+"')"+
	                           " WHERE interface_transaction_id="+arrIQCSearch[m][1]+" AND transaction_type='RECEIVE'";
          			PreparedStatement pstmt=con.prepareStatement(sql);
          			pstmt.executeUpdate();
          			pstmt.close();
          			
					if (actionID.equals("005") && (sMailFlag==null || sMailFlag.equals(""))) sMailFlag="Y";    
		  			out.println(" OK!");
				}
	  		}
		}
	
		if (sMailFlag!=null && sMailFlag.equals("Y"))
    	{ 
      		Statement stateList=con.createStatement();
	  		String sqlList = " select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a "+
		                     " where upper(a.USERNAME) in (select upper(USER_NAME) from ORADDMAN.TSC_WAREHOUSE_USER "+
					         " where TSC_DEPT_ID = 'YEW' and STOCK_CODE in ('00','01') and RECEPT_EMAIL = 'Y' ) ";
      		ResultSet rsList=stateList.executeQuery(sqlList);
      		while (rsList.next())
      		{         
        		sendMailBean.setMailHost(mailHost);
        		sendMailBean.setReception(rsList.getString("USERMAIL"));		        
        		sendMailBean.setFrom(UserName);   	 	 
        		sendMailBean.setSubject(CodeUtil.unicodeToBig5("收料檢驗物控不同意通知"));                  
				sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:收料檢驗物控不同意"));   	 
        		sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotEntry.jsp?STATUSID=029");
        		sendMailBean.sendMail();
	  		}
	  		rsList.close();
	  		stateList.close();	   
		}
		if (arrIQCSearch!=null)
		{
	  		arrayIQCSearchBean.setArray2DString(null);
		}
 	}
	catch(Exception e)
	{
		out.println("<font color='red'>Exception2:"+e.getMessage()+"</font>");
	}
}

if (actionID.equals("019"))    // D1-013 019:INV return
{
	try
	{
    	String arrIQCSearch[][]=arrayIQCSearchBean.getArray2DContent();
    	String [] choice=request.getParameterValues("CH");
    	String fndUserID = "";
    	String fndEmpID = "";
		String sqlfnd = " select USER_ID, EMPLOYEE_ID from APPS.FND_USER "+
 			            " where USER_NAME = UPPER('"+UserName+"')";
		Statement stateFndId=con.createStatement();
    	ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
		if (rsFndId.next())
		{
	  		fndUserID = rsFndId.getString("USER_ID"); 
	  		fndEmpID = rsFndId.getString("EMPLOYEE_ID");
    	}
		rsFndId.close();
		stateFndId.close();

		String sGroupId = "";
    	for (int k=0;k<choice.length;k++)
    	{
	  		for (int m=0;m<arrIQCSearch.length-1;m++)
	  		{	
	    		if (choice[k].equals(arrIQCSearch[m][1]))
				{
          			out.println("<BR>Processing INV return value(ID:"+arrIQCSearch[m][1]+") ");
	        		if (sGroupId==null || sGroupId.equals(""))
					{
			  			Statement state=con.createStatement();
              			ResultSet rs=state.executeQuery("SELECT rcv_interface_groups_s.nextval group_id FROM dual");
	          			if (rs.next())  sGroupId = rs.getString("GROUP_ID");
	          			rs.close();
	          			state.close();
					}
            		String sqlRTI=" INSERT INTO RCV_TRANSACTIONS_INTERFACE(INTERFACE_TRANSACTION_ID, GROUP_ID, LAST_UPDATE_DATE, LAST_UPDATED_BY,"+
                                  " CREATION_DATE, CREATED_BY, LAST_UPDATE_LOGIN, TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE,"+
                                  " PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE, QUANTITY, UNIT_OF_MEASURE, ITEM_ID, EMPLOYEE_ID,"+
				                  " SHIPMENT_HEADER_ID, SHIPMENT_LINE_ID, RECEIPT_SOURCE_CODE, VENDOR_ID, FROM_ORGANIZATION_ID,"+
				                  " FROM_SUBINVENTORY, FROM_LOCATOR_ID, SOURCE_DOCUMENT_CODE, PARENT_TRANSACTION_ID, PO_HEADER_ID, PO_LINE_ID,"+
                                  " PO_LINE_LOCATION_ID, PO_DISTRIBUTION_ID, DESTINATION_TYPE_CODE, DELIVER_TO_PERSON_ID, LOCATION_ID,"+
				                  " DELIVER_TO_LOCATION_ID, VALIDATION_FLAG)"+
                                  " VALUES(rcv_transactions_interface_s.nextval, "+sGroupId+", SYSDATE, "+fndUserID+","+
                                  " SYSDATE, "+fndUserID+", 0, 'RETURN TO VENDOR', SYSDATE, 'PENDING',"+
                                  " 'BATCH', 'PENDING', "+arrIQCSearch[m][12]+", '"+arrIQCSearch[m][13]+"', "+arrIQCSearch[m][14]+", "+fndEmpID+","+
                                  " null, null, 'VENDOR', "+arrIQCSearch[m][2]+", "+arrIQCSearch[m][19]+","+
                                  " null, null, 'PO', "+arrIQCSearch[m][20]+", "+arrIQCSearch[m][21]+", "+arrIQCSearch[m][22]+","+ arrIQCSearch[m][23]+", null, 'RECEIVING', null, null,"+
                                  " null, 'Y')";
            		PreparedStatement pstmtRTI=con.prepareStatement(sqlRTI);
            		pstmtRTI.executeUpdate(); 
            		pstmtRTI.close(); 
		  			out.println(" OK!");
				}
	  		}
		}
	
		if (sGroupId != "" && !sGroupId.equals(""))
		{
	  		CallableStatement cs4 = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
	  		cs4.setString(1,sGroupId);			                // RCV Processor Group ID
	  		cs4.setInt(2,Integer.parseInt(fndUserID));            // USER REQUEST
	  		cs4.setInt(3,50804);                                  // RESPONSIBILITY ID : YEW_PO_SEMI_REQ 50804
	  		cs4.registerOutParameter(4, Types.INTEGER);           // REQUEST_ID
	  		cs4.registerOutParameter(5, Types.VARCHAR);           // DEV_STATUS
	  		cs4.registerOutParameter(6, Types.VARCHAR);           // DEV_MASSAGE
	  		cs4.execute();
      		int requestID = cs4.getInt(4);                        // REQUEST_ID
	  		String devStatus = cs4.getString(5);                  // DEV_STATUS
	  		String devMessage = cs4.getString(6);                 // DEV_MASSAGE
	  		cs4.close();
	  		out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
	  		out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
	  		out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");			
    	}
		if (arrIQCSearch!=null)
		{
	  		arrayIQCSearchBean.setArray2DString(null);
		}
	}
	catch (Exception e)
	{
		out.println("<font color='red'>Exception3:"+e.getMessage()+"</font>");
	}
}
%>
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="60%" align="LEFT" borderColorLight="#ffffff" border="1">
  <tr>
    <td width="278">IQC品管檢驗批單據處理</td>
    <td width="297">IQC品管檢驗批單查詢及報表</td>    
  </tr>
  <tr>
    <td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E1";    
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    while(rs.next())
    {
    	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
    rs.close(); 
	statement.close();
	out.println("</table>"); 
}
catch (Exception e)
{
	e.printStackTrace();
    out.println(e.getMessage());
}
%>   </td>
     <td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E2";    
	Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    while(rs.next())
    {
    	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td><td>");
	}
    rs.close(); 
	statement.close();
    out.println("</table>");  
} 
catch (Exception e)
{
	e.printStackTrace();
    out.println(e.getMessage());
}
%>
	</td>    
  </tr>
</table>
<%  // 判斷是否成功產生單據
try  
{    
	if (actionID.equals("002"))   
   	{
		Statement statement=con.createStatement(); 
    	ResultSet rs=statement.executeQuery("SELECT INSPLOT_NO FROM ORADDMAN.TSCIQC_LOTINSPECT_HEADER WHERE INSPLOT_NO='"+seqno+"' ");    
    	if (!rs.next())
    	{
%>
			<script language="javascript">
		    	alert("系統異常,未成功新增檢驗批,請洽系統管理員 !!!");		    
		   	</script>
<%
		} 
		else 
		{
	    	Statement stateDtl=con.createStatement(); 
            ResultSet rsDtl=stateDtl.executeQuery("select INSPLOT_NO from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+seqno+"' ");
			if (!rsDtl.next())   
			{
%>
				<script language="javascript">
					alert("系統異常,未成功新增檢驗批明細,請洽系統管理員 !!! !!!");		              
		        </script>
<%
				String sql="delete from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO='"+seqno+"' ";
                PreparedStatement pstmt=con.prepareStatement(sql);               
	            pstmt.executeUpdate(); 
				pstmt.close();
			}			  
			rsDtl.close();
			stateDtl.close();	   	         
	    }
    	rs.close();
		statement.close();
   	}
} 
catch (Exception e)
{
	e.printStackTrace();
    out.println(e.getMessage());
}
%>
<input name="PRESEQNO" type="HIDDEN" value="<%=seqno%>">	   
<input name="REPTIMES" type="HIDDEN" value="<%=RepTimes%>">  
<%
arrayCheckBoxBean.setArray2DString(null); //將此bean值清空以為不同case可以重新運作
arrayIQCDocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
if (repeatInput==null || repeatInput.equals(""))
{	  
} 
else
{
	response.sendRedirect("TSIQCInspectLotInput.jsp?PREDNDOCNO="+seqno);
}
%>
</body>
</html>

