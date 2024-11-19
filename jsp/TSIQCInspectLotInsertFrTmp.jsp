<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
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
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
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
  String actionID=request.getParameter("ACTIONID");
  String inspectID=userID;
  
  String receiptSource=request.getParameter("RECEIPTSOURCE");
  
  //out.println("receiptSource="+receiptSource);
  //if (receptDate==null || receptDate.equals("")) receptDate=dateBean.getYearMonthDay();
  //if (curr==null || curr.equals("")) curr="";
  if (remark==null || remark.equals("")) remark="";
 // if (customerPO==null || customerPO.equals("")) customerPO="";
  if (typeNo==null || typeNo.equals("")) typeNo="001"; // 暫時未分QC種類, 預設 "001"->IQC ,  "002"->OQC  
  if (sampleQty==null || sampleQty.equals("")) sampleQty="0";
  
 // if (sourceInput==null) sourceInput = "01";
  if (formID==null) formID = "QC";       // 此為預設為取 IQC 的 FLOW 狀態表,用 TYPE = 001區分 IQC;  TYPE =002 OQC
  
  if (receiptSource==null || receiptSource.equals("--")) 
  {  
     if (classID!=null && !classID.equals("06")) // 不為RMA類型
     {  
       receiptSource="1";
	 } else {  // RMA 類型的檢驗
	           classID="06";
	           receiptSource="2";
	        }
  }
  
   out.println("receiptSource="+receiptSource);
  //out.println("sampleOrder ="+sampleOrder);
  
  
  //out.println(arrayIQCDocumentInputBean.getArray2DIQCString());  
////
  String customer="";

//String [][] jamDesc=arrayCheckBoxBean.getArray2DContent();//取得session中目前陣列內容;

String defaultLineType="";

//String remark=request.getParameter("REMARK");
//String otherJamDesc=request.getParameter("OTHERJAMDESC");
   int RepTimes=0;

String agentNo=request.getParameter("AGENTNO"); //經銷/代理商編號
String recType=request.getParameter("RECTYPE"); //收件來源型態
String qty=request.getParameter("QTY"); //收件數量

String fromPage=request.getParameter("FROMPAGE");
String repeatInput=request.getParameter("REPEATINPUT");


//out.println("1");
   String orgOU = "";
   Statement stateOU=con.createStatement();   
   ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
   if (rsOU.next())
   {
     orgOU = rsOU.getString(1);
   }
   rsOU.close();
   stateOU.close();


  CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
  cs1.setString(1,orgOU);  // 取品管人員隸屬OrgID
  cs1.execute();
  //out.println("Procedure : Execute Success !!! ");
  cs1.close();  
  
 //out.println("2");
 classID = "01"; // 晶片晶粒類
 String invItemTmp = ""; 
 int ac = 1; 
 Statement stateTmp=con.createStatement();   
 ResultSet rsTmp=stateTmp.executeQuery("select INSPLOT_NO, LINE_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, INSPECT_REQUIRE, "+
                                        "      WAFER_AMP, INSPECT_QTY, UOM, SUPPLIER_LOT_NO, SUPPLIER_SITE_ID, SUPPLIER, "+
										"      decode(RESULT,'','N/A',RESULT) as RESULT, "+
										" decode(WAFER_TYPE,'STD','01','SKY','03','GPP','02','EGP','04','GP','05','RGP','06','FR','07','HER','08','SF','09','STDGPP','10','FRGPP','11','HERGPP','12','SFGPP','13',WAFER_TYPE) as WAFER_TYPE, "+
										" decode(WAFER_SIZE,'3','01','4','02','5','03','','N/A',WAFER_SIZE) as WAFER_SIZE, "+
										" DICE_SIZE, WF_RESIST, "+
										" decode(ORGANIZATION_ID,'Y1','326','Y2','327',ORGANIZATION_ID) as ORGANIZATION_ID, STATUSID, STATUS, INSPECT_REMARK  "+
										" from ORADDMAN.TSCIQC_LOTINSPECT_TMP ");  // 暫存檔內的資料
 while (rsTmp.next())
 {
   

try
{  
  // 判斷若未取到取得單號且料號不同於上一個_起
  if ((rsTmp.getString("INSPLOT_NO")==null || rsTmp.getString("INSPLOT_NO").equals("")) && !invItemTmp.equals(rsTmp.getString("INV_ITEM")) )
  {  
   ac = 1;  // 若新取號,則將Line_no 重智為1
   dateString=dateBean.getYearMonthDay();   
   
   //out.println("1. inspLotNo="+inspLotNo);
   if (classID==null || classID.equals("--")) seqkey="IQC"+classID+dateString; //但仍以預設為使用者地區
   else seqkey="IQC"+classID+dateString;         // 2006/09/10 改以選擇的檢驗類型號產生單號   
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
      
    String sql = "select * from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where substr(INSPLOT_NO,1,13)='"+seqkey+"' and to_number(substr(INSPLOT_NO,15,3))= '"+lastno+"' ";
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
	 
	   String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
       PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       seqstmt.setInt(1,lastno_r);   
	
       seqstmt.executeUpdate();   
       seqstmt.close();  
	  }  // End of if (rs3.next()==true)
   
     } // End of Else  //===========(處理跳號問題)
    } // End of Else    
	//docNo = seqno; // 把取到的號碼給本次輸入
	inspLotNo = seqno; // 把取到的號碼給本次輸入
	//out.println("inspLotNo ="+inspLotNo);
  } // End of if (docNo==null || docNo.equals(""))	
  else {
          String inspLotNoSub = inspLotNo.substring(5,inspLotNo.length());
		  //out.println("inspLotNoSub="+inspLotNoSub);
          inspLotNo = "IQC"+classID+inspLotNoSub;
		  //out.println("inspLotNo ="+inspLotNo);
		  seqno = inspLotNo;
       }	
	   
// 取得單號_迄	  
  
  
  
  //out.println("新增寫入IQC 檢驗批頭檔_起");
 if ((rsTmp.getString("INSPLOT_NO")==null || rsTmp.getString("INSPLOT_NO").equals("")) && !invItemTmp.equals(rsTmp.getString("INV_ITEM")) )
 {    
  String sql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HEADER(INSPLOT_NO, SUPPLIER_ID, SUPPLIER_NAME, SUPPLIER_SITE_ID, SUPPLIER_SITE_NAME, PO_NUMBER, RECEIPT_NO, IQC_CLASS_CODE,"+ // 8
                         "LOT_QTY, SUPPLY_LOT_NO, PACK_METHOD, WAFER_AMP, MECH_EXAM, DIMEN_EXAM , ELEC_EXAM, PULL_EXAM, PEELING_EXAM, QUANTITY_EXAM, TOTAL_YIELD, "+ //11
					     "PROD_MODEL, PROD_NAME , PROD_YIELD, SAMPLE_QTY, INSPECT_QTY, UOM, VERSION, UNITS, RESULT, STATUSID, STATUS, WAFER_TYPE, WAFER_SIZE, DICE_SIZE, "+ //14
					     "WF_THICK, WF_RESIST, PLAT_LAYER, WAIVE_LOT, INSPECT_REMARK, INSPECTOR, INSPECT_DEPT, INSPECT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,ORG_ID, ORGANIZATION_ID,IMATCODE)"+  //9
                   " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
  //out.println("3="+waiveLot);
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,seqno); out.println("seqno="+seqno+"<BR>"); // 檢驗批單號
  pstmt.setString(2,"000"); out.println("SUPPLIER_ID=SUPPLIER_ID"+"<BR>");  // SUPPLIER_ID 供應商識別碼
  pstmt.setString(3,"SUPPLIER");  out.println("SUPPLIER=SUPPLIER"+"<BR>");// SUPPLIER_NAME 供應商名稱
  pstmt.setString(4,"111");  out.println("SUPPLIER_SITE_ID=111"+"<BR>");// SUPPLIER_SITE_ID 供應出貨地識別碼
  pstmt.setString(5,"SUPPLIER_SITE"); out.println("SUPPLIER_SITE=SUPPLIER_SITE"+"<BR>"); // SUPPLIER_SITE_NAME 供應出貨地名  
  pstmt.setString(6,"222"); out.println("PO_NUMBER=PO_NUMBER"+"<BR>");// PO_NUMBER 採購單號 (Header 參考)
  pstmt.setString(7,"333"); out.println("RECEIPT_NO=RECEIPT_NO"+"<BR>"); //RECEIPT_NO 收料單號(暫收) (Header 參考)
  pstmt.setString(8,"01"); out.println("IQC_CLASS_CODE=IQC_CLASS_CODE"+"<BR>"); // IQC_CLASS_CODE 檢驗類別代碼 (01晶片晶粒,02主要原物料,03間接原物料,04...)
  pstmt.setInt(9,0);  // LOT_QTY 檢驗總批量 加總
  pstmt.setString(10,rsTmp.getString("SUPPLIER_LOT_NO"));  // SUPPLY_LOT_NO 供應商批號
  pstmt.setString(11,"PACK_METHOD");  // PACK_METHOD 包裝方式
  pstmt.setString(12,"AMP"); // WAFERAMP 晶片安培數
  pstmt.setString(13,"N"); // MECH_EXAM 外觀檢驗 "Y/N Default N ...到檢驗時決定
  pstmt.setString(14,"N"); // DIMEN_EXAM  尺寸檢驗"Y/N Default N ...到檢驗時決定
  pstmt.setString(15,"N"); // ELEC_EXAM  電性檢驗"Y/N Default N ...到檢驗時決定
  pstmt.setString(16,"N"); // PULL_EXAM  焊接測試"Y/N Default N ...到檢驗時決定
  pstmt.setString(17,"N"); // PEELING_EXAM  剝裂測試"Y/N Default N ...到檢驗時決定
  pstmt.setString(18,"N"); // QUANTITY_EXAM 數量檢查"Y/N Default N ...到檢驗時決定
  pstmt.setString(19,"444"); // TOTAL_YIELD 電性良品率
  pstmt.setString(20,"MODEL"); // PROD_MODEL 適用產品(型號)
  pstmt.setString(21,"NAME"); // PROD_NAME 物料名稱
  pstmt.setString(22,"555"); // PROD_YIELD 型號良品率
  pstmt.setInt(23,0); // SAMPLE_QTY 抽樣數
  pstmt.setInt(24,0); // INSPECT_QTY 檢驗數 = Total receipt Qty
  pstmt.setString(25,rsTmp.getString("UOM"));out.println("UOM"+rsTmp.getString("UOM")+"<BR>"); // UOM 收料單位
  pstmt.setString(26,"N/A"); // VERSION 品檢版本
  pstmt.setString(27,rsTmp.getString("UOM")); // UNITS 檢驗單位
  pstmt.setString(28,rsTmp.getString("RESULT")); // RESULT 檢驗結果  
  pstmt.setString(29,"010");//寫入STATUSID
  pstmt.setString(30,"CLOSED");//寫入狀態名稱  
  pstmt.setString(31,rsTmp.getString("WAFER_TYPE")); // WAFER_TYPE 晶片類型 (01,02,03,04,05) 同一檢驗批可否檢多種晶片類型
  pstmt.setString(32,rsTmp.getString("WAFER_SIZE")); // WAFER_SIZE 晶片尺寸 (01,02,03) 同一檢驗批可否檢多種晶片尺寸
  pstmt.setString(33,rsTmp.getString("DICE_SIZE"));// DICE_SIZE 晶粒尺寸
  pstmt.setString(34,"WF_THICK");// WAFER 晶片厚度
  pstmt.setString(35,rsTmp.getString("WF_RESIST"));// WAFER 電阻係數
  pstmt.setString(36,"LAYER"); out.println("LAYER=LAYER"+"<BR>"); // PLAT_LAYER 鍍層種類  
  pstmt.setString(37,"N");// WAIVE LOT 特採批waiveLot
  pstmt.setString(38,"N/A"); // INSPECT_REMARK 備註說明
  pstmt.setString(39,"kerwin"); // INSPECTOR 檢驗人員名
  pstmt.setString(40,"01"); // INSPECTOR 檢驗單位  
  pstmt.setString(41,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入檢驗日期 + 時間
  pstmt.setString(42,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //CREATION_DATE日期  
  pstmt.setString(43,"OF000886"); //寫入User ID
  pstmt.setString(44,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //CREATION_DATE日期 
  pstmt.setString(45,"OF000886"); //最後更新User 
  pstmt.setString(46,"325"); //ORG_ID  
  pstmt.setString(47,rsTmp.getString("ORGANIZATION_ID")); //ORGANIZATION_ID   
  pstmt.setString(48,"N/A"); //間接原物料種類   
  pstmt.executeUpdate(); 
  pstmt.close();
  
 } // End of if (Header Insert)
  
  float sumInspectQty = 0; // 累計檢驗數量,作為更新頭檔LOTQTY及SAMPLEQTY依據
  
  // Step2. 寫入IQC 檢驗批明細檔
  
   //out.println("5");  
  
        String sqlDtl="insert into ORADDMAN.TSCIQC_LOTINSPECT_DETAIL(INSPLOT_NO,LINE_NO,INTERFACE_TRANSACTION_ID,PO_NO,PO_QTY,RECEIPT_NO,INV_ITEM_ID,INV_ITEM,INV_ITEM_DESC,"+
                      "AUTHOR_NO, INSPECT_REQUIRE, WAFER_AMP, RECEIPT_QTY, SUPPLIER_LOT_NO, SUPPLIER_SITE_ID ,TOTAL_YIELD, PRODUCTS, PROD_YIELD, SAMPLE_QTY, INSPECT_QTY, UOM, VERSION, "+
					  "UNITS, RESULT, LSTATUSID, LSTATUS, WAFER_TYPE, WAFER_SIZE, MECH_NG_QTY, INTACT_NG_QTY, SHORTAGE_QTY, PULL_JUDGE, PEELING_QTY, VOID_QTY, OXGN_QTY ,ELEC_EXTYPE , DICE_SIZE,"+
					  "CPK, UCL, LCL, WAIVE_ITEM, INSPECT_REMARK, INSPECTOR, INSPECT_DEPT, INSPECT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, "+
					  "PO_HEADER_ID, PO_LINE_ID, PO_LINE_LOCATION_ID, SHIP_TO_LOCATION_ID, SUPPLIER_ID, TO_ORGANIZATION_ID, "+
					  "UNIT_MEAS_LOOKUP_CODE, CURRENCY_CONVERSION_TYPE, ROUTING, EMPLOYEE_ID, ORGANIZATION_ID, RECEIPT_DATE, ORG_ID, IMATCODE, SHIPMENT_LINE_ID)"+ 
                      " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  	 
      //Step : 加入預設的收料單相關訊息_起 // 2006/09/12 
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
	  int shipmentLineID = 0;
	  
	  String oraInvItem = "";
	  String oraItemDesc = "";
	  String sqlBasic = "";
      Statement stateBasic=con.createStatement();
	  ResultSet rsBasic = stateBasic.executeQuery("select INVENTORY_ITEM_ID, SEGMENT1, DESCRIPTION from MTL_SYSTEM_ITEMS where SEGMENT1 = '"+rsTmp.getString("INV_ITEM")+"' and ORGANIZATION_ID = "+rsTmp.getString("ORGANIZATION_ID")+" ");
	  if (rsBasic.next())
	  { 
	   invItemID = rsBasic.getString(1);
	   //oraInvItem = ;
	   oraItemDesc = rsBasic.getString(3);;
	  }
	  rsBasic.close();
	  stateBasic.close();
	
	//Step : 加入預設的收料單相關訊息_迄 // 2006/09/12 
   //out.println("6");
      PreparedStatement pstmtDtl=con.prepareStatement(sqlDtl);  
      pstmtDtl.setString(1,seqno);  // 檢驗批號		 
	  pstmtDtl.setInt(2,ac); // Line_No // 給料項序號	  
      pstmtDtl.setString(3,"0");  out.println("INT_ID=INT_ID"+"<BR>"); // INTERFACE_TRANSACTION_ID  
	  pstmtDtl.setString(4,"222"); // PO NUMBER
	  pstmtDtl.setFloat(5,0); // PO Qty
	  pstmtDtl.setString(6,"333"); // Receipt Number
	  pstmtDtl.setString(7,invItemID); out.println("invItemID="+invItemID+"<BR>"); // Inventory Item ID
	  pstmtDtl.setString(8,rsTmp.getString("INV_ITEM")); // Inventory Item
	  pstmtDtl.setString(9,oraItemDesc); // Inventory Item Desc
	  pstmtDtl.setString(10,"N"); // Authorize No.. 零件承認編號
	  pstmtDtl.setString(11,"Y"); // Inspect Require 檢驗要求(預設找供應商免檢清單)
	  pstmtDtl.setString(12,rsTmp.getString("WAFER_AMP")); // waferAmp 晶片安培數
	  pstmtDtl.setFloat(13,Float.parseFloat(rsTmp.getString("INSPECT_QTY"))); // RECEIPT_QTY 收料數量
	  pstmtDtl.setString(14,rsTmp.getString("SUPPLIER_LOT_NO")); // SUPPLIER_LOT_NO 供應商進料批號
	  pstmtDtl.setString(15,"111"); // 供應商出貨地識別碼
	  pstmtDtl.setString(16,"TOTAL"); // TOTAL_YIELD 電性良品率
	  pstmtDtl.setString(17,"PROD_NAME"); // PRODUCTS 適用產品
	  pstmtDtl.setString(18,"PROD_YIELD"); // PROD_YIELD 型號良品率
	  pstmtDtl.setFloat(19,0); //SAMPLE_QTY 抽樣數
	  pstmtDtl.setFloat(20,Float.parseFloat(rsTmp.getString("INSPECT_QTY"))); //INSPECT_QTY 檢驗數 =  收料數量
	  pstmtDtl.setString(21,rsTmp.getString("UOM"));  // UOM 收料單位
	  pstmtDtl.setString(22,"0");    //VERSION 檢驗版本
	  pstmtDtl.setString(23,rsTmp.getString("UOM"));    // UNITS 檢驗單位 = 收料單位
	  pstmtDtl.setString(24,rsTmp.getString("RESULT"));    // RESULT 檢驗結果
	  pstmtDtl.setString(25,"010");    // LSTATUSID 工作流程狀態識別碼
	  pstmtDtl.setString(26,"CLOSED"); // LSTATUSID 工作流程狀態 Name
	  pstmtDtl.setString(27,rsTmp.getString("WAFER_TYPE")); // WAFER_TYPE 晶片類型 (01,02,03,04,05) 同一檢驗批可否檢多種晶片類型
	  pstmtDtl.setString(28,rsTmp.getString("WAFER_SIZE")); // WAFER_SIZE 晶片尺寸 (01,02,03) 同一檢驗批可否檢多種晶片尺寸
	  pstmtDtl.setInt(29,0); // MECH_NG_QTY  外觀不良數
	  pstmtDtl.setInt(30,0); // INTACT_NG_QTY 破片數 
	  pstmtDtl.setInt(31,0); // SHORTAGE_QTY 短缺數 
	  pstmtDtl.setString(32,"N/A"); // PULL_JUDGE 拉力總評 
	  pstmtDtl.setInt(33,0); // PEELING_QTY  剝裂數
	  pstmtDtl.setInt(34,0); // VOID_QTY  氣泡數
	  pstmtDtl.setInt(35,0); // OXGN_QTY  氧化數
	  pstmtDtl.setString(36,"N/A"); // ELEC_EXTYPE  電性測試類型
	  pstmtDtl.setString(37,rsTmp.getString("DICE_SIZE")); // DICE_SIZE  晶粒尺寸(01,02,03) 同一檢驗批可否檢多種晶粒尺寸?
	  pstmtDtl.setInt(38,0); // CPK  製程能力值
	  pstmtDtl.setInt(39,0); // UCL 原物料檢測上限
	  pstmtDtl.setInt(40,0); // LCL 原物料檢測下限
	  pstmtDtl.setString(41,"N"); // WAIVE_ITEM 特採項目 
	  pstmtDtl.setString(42,"N/A"); // 備註說明
	  pstmtDtl.setString(43,"kerwin"); // INSPECTOR 檢驗人員名
	  pstmtDtl.setString(44,"01"); // INSPECTOR 檢驗單位
	  pstmtDtl.setString(45,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // INSPECT_DATE 檢驗日期
	  pstmtDtl.setString(46,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 開單日期
	  pstmtDtl.setString(47,"OF000886"); // 開單人員
	  pstmtDtl.setString(48,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  // LAST_UPDATED_DATE 維護日期
	  pstmtDtl.setString(49,"OF000886"); // LAST_UPDATED_BY 維護人員
	  pstmtDtl.setString(50,"0"); // PO_HEADER_ID 	
	  pstmtDtl.setString(51,"0"); // PO_LINE_ID  
	  pstmtDtl.setString(52,"0"); // PO_LINE_LOC_ID 
	  pstmtDtl.setString(53,"0"); 
	  pstmtDtl.setString(54,"0"); // SupplierID
	  pstmtDtl.setString(55,"0");  // toOrgId
	  pstmtDtl.setString(56,rsTmp.getString("UOM"));
	  pstmtDtl.setString(57,"CU");
	  pstmtDtl.setString(58,"1");  
	  pstmtDtl.setString(59,"2487");  out.println("EmployeeID=2487"+"<BR>");
	  pstmtDtl.setString(60,rsTmp.getString("ORGANIZATION_ID"));
	  pstmtDtl.setString(61,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  // RECEIPT_DATE
	  pstmtDtl.setString(62,"325");  // OEG_ID
	  pstmtDtl.setString(63,"N/A");     //間接原物料種類 
	  pstmtDtl.setInt(64,0);     //原ShipmentLineID
	  pstmtDtl.executeUpdate(); 
      pstmtDtl.close();  	  
	  
	  //sumInspectQty= sumInspectQty + Float.parseFloat(a[ac][5]); // 累加檢驗數量
	  
 
  
   out.println("insert into IQC Inspection Lot Information value(");%>品管IQC檢驗批單號<%out.println(":<font color=#FF0000>"+seqno+"</font>- (");%><%out.println(":<font color=#660000>"+RepTimes+"</font>) OK!<BR>");    
   out.println("<A HREF='/oradds/OraddsMainMenu.jsp'>");%>回首頁<%out.println("</A>&nbsp;&nbsp;");
   out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSIQCInspectLotHistoryQueryAll.jsp?INSPLOTNO="+seqno+"'>");%>檢驗批單據歷程查詢<%out.println("(by Inspect Lot Doc No.)</A>");
   out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSIQCInspectLotInput.jsp'>");%>品管IQC檢驗批輸入頁面<%out.println("</A>");
  
  
   
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
   ac++;  // 累加 Line No
   invItemTmp = rsTmp.getString("INV_ITEM");// 把這次的料號給暫存

} // End of while (rsTmp.next())
rsTmp.close();
stateTmp.close();


%>



<!-- 表單參數 -->  
    <input name="PRESEQNO" type="HIDDEN" value="<%=seqno%>">	   
	<input name="REPTIMES" type="HIDDEN" value="<%=RepTimes%>">  <!--做為判斷是否已選取故障描述-->

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
    //response.sendRedirect("TSSalesDRQ_Create.jsp");
    // Modify by Jingker for Order Import Redirect 2006/03/07

	
%>
</body>
</html>

