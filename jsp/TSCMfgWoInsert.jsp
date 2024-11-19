<!--  取 alternaateRouting及Routing Id	還有error ,先disable   2006/9/29-->
<!--20071108 liling 增加判斷重工及其他類 woType=="4","7"  可展單批數量  -->
<!--20100702 liling  手動及YEW分批出貨無ORIG_SYS_LINE_RE LINE ID,則回台北訂單判斷orgMOLineID -->
<!--20120306 liling  修改FSC單批數量 -->
<!--20120515 liling  修改wo_type 5/6 加入單批控管 -->
<!--20121107 liling  修正CUSTOMER_NAME_PHONETIC為空值時,抓CUSTOMER_NAME -->
<!--20130208 liling  修正packing code 的抓取方式 -->
<!--20130328 liling  修正customerPO改抓order line.CUSTOMER_LINE_NUMBER -->
<!--20150817 Peggy,修正packing code抓法->
<!--20151026 liling 修改custtype rule -->
<!--20151028 liling 修正DICESIZE寫入 -->
<!--20151229 liling 修正1121 台北訂單headerid lineid 及料號是FSC者END CUST強製寫FSC-->
<!--20160919 liling 修正1156 headerid lineid 客戶品號的判斷錯誤-->
<!--20171102 liling 增加ON SEMI單批及1121訂單 料號是ON SEMI者END CUST強製寫ON SEMI--->
<!--20180416 liling YEW ADD ON SEMI MBS -->
<!--20190722 liling YEW update ON SEMI lotqty -->
<!--20200413 liling 前段單批數量DO-15 再判斷前七碼抓數量 >
<!--20231102 liling 增加寫入last update by 的user id -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<html>
<head>
<title>MFG System Work Order Data Save</title>
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
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
String woNo=request.getParameter("WONO"); 
String marketType=request.getParameter("MARKETTYPE");
String woType=request.getParameter("WOTYPE");
String woKind=request.getParameter("WOKIND");
String prodSource=request.getParameter("PRODSOURCE"); // 製二前段工令開兩張,重分轉入轉出
String startDate=request.getParameter("STARTDATE");
String endDate=request.getParameter("ENDDATE");
String woQty=request.getParameter("WOQTY");
String woUnitQty=request.getParameter("WOUNITQTY"); // 工令製成品的單位用量,必填
String invItem=request.getParameter("INVITEM");
String itemId=request.getParameter("ITEMID");	
String itemDesc=request.getParameter("ITEMDESC");		
String woUom=request.getParameter("WOUOM");
String waferLot=request.getParameter("WAFERLOT");
String waferQty=request.getParameter("WAFERQTY");          //使用晶片數量
String waferUom=request.getParameter("WAFERUOM");          //晶片單位
String waferYld=request.getParameter("WAFERYLD");          //晶片良率
String waferAmp = "N/A";   // 安培數
String waferVendor=request.getParameter("WAFERVENDOR");   //晶片供應商
String supplyVnd=request.getParameter("SUPPLYVND");       //工程實驗工令晶片供應商
String waferKind=request.getParameter("WAFERKIND");       //晶片類別
String diceSize=request.getParameter("DICESIZECH");       //晶粒尺寸
String waferElect=request.getParameter("WAFERELECT");     //電阻系數��
String waferIqcNo=request.getParameter("WAFERIQCNO");     //晶片種類	
String tscPackage=request.getParameter("TSCPACKAGE");     //
String tscFamily=request.getParameter("TSCFAMILY");     //
String tscPacking=request.getParameter("TSCPACKING");
String opSupplierLot=request.getParameter("OPSUPPLIERLOT");
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
String organizationId=request.getParameter("ORGANIZATION_ID");	
String singleControl="";   //單批作業管制否
//String defInv="";    //預設倉別  
String subInv=request.getParameter("SUBINVENTORY");  //預設倉別  2007/03/12 liling修改由工令開立畫面選擇
String STATUSID="";
String STATUS=""; 

String errorMessageHeader ="";
String processStatus="";

String iNo=request.getParameter("INO");
String isModelSelected=request.getParameter("ISMODELSELECTED"); 
String woRemark=request.getParameter("WOREMARK");
String [] addItems=request.getParameterValues("ADDITEMS");
//   String [] allMonth={iNo,woNo,invItem,itemDesc,woQty,woUom,startDate,endDate};
String processArea=request.getParameter("PROCESSAREA");
String salesPerson=request.getParameter("SALESPERSON"); 
String toPersonID=request.getParameter("TOPERSONID"); 
String customerIdTmp=request.getParameter("CUSTOMERIDTMP");
String insertPage=request.getParameter("INSERT"); 
String preSeqNo=request.getParameter("PREDNDOCNO");
String repeatInput=request.getParameter("REPEATINPUT");
String custAROverdue=request.getParameter("CUSTOMERAROVERDUE");
String sampleOrder=request.getParameter("SAMPLEORDER");
String sOrderCheck=request.getParameter("SORDERCHECK");
String sampleCharge=request.getParameter("SAMPLECHARGE");
String classID=request.getParameter("CLASSID"); 
String oeHeaderId=request.getParameter("OEHEADERID");
String oeLineId=request.getParameter("OELINEID");
String orderQty=request.getParameter("ORDERQTY");
String waferLineNo=request.getParameter("WAFERLINENO");
String frontRunCardNo=null;
String seqno=null;
String seqkey=null;
String dateString=null; 
String singleLotQty=request.getParameter("AFTER_QTY");;
String workOrderId=null;  
String routingId=request.getParameter("ROUTINGID");
String alternateRoutingDesignator="";   //

String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");
String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");
String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
if (dateSetBegin==null) dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
if (dateSetEnd==null) dateSetEnd=YearTo+MonthTo+DayTo; 
 
String [] selectFlag=request.getParameterValues("SELECTFLAG"); 
String waferUsedPce=request.getParameter("WAFERUSEDPCE");
String altBomSeqID=request.getParameter("ALTBOMSEQID");  
String altBomDest=request.getParameter("ALTBOMDEST");
String routingRefID=request.getParameter("ROUTINGREFID");
String altRoutingDest=request.getParameter("ALTROUTINGDEST");
String custPartItem = ""; // 2007/01/05 後段工令客戶品號及End-Customer Name資訊
String endCustName = "";

String custType=request.getParameter("CUSTTYPE");  // 2007/08/02 定義不同的客戶流程卡編碼
String q[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容		
//印出陣列內容
if (q!=null) 
{			   
} 
else 
{
	out.println("No get!");
}

//out.println("userParOrgID="+userParOrgID);
if (orderQty==null || orderQty.equals("") || orderQty.equals("null")) orderQty = "0";

if (woUnitQty==null || woUnitQty.equals("")) woUnitQty = "1"; // 預設單位用量是1

String defaultLineType="";
String otherJamDesc=request.getParameter("OTHERJAMDESC");
int RepTimes=0;
String fromPage=request.getParameter("FROMPAGE");

CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
cs1.execute();
cs1.close();

// 2007/01/29_取原始Copy訂單ID資訊
String orgMOHeaderID = "0";
String orgMOLineID = "0";
String shipToOrgID = "0";
		
int idxHeader = 0;
int idxLine = 0;	 		  
//out.println("oeOrderNo="+oeOrderNo+"<BR>"); 					                
String orderExImJdge = "";	
if (oeOrderNo==null || oeOrderNo.equals("")) 
{  
}	
else 
{  
	//out.println(oeOrderNo.length());
	if (oeOrderNo.length()>4)
	{
		orderExImJdge = oeOrderNo.substring(0,4);   // 判斷訂單號前四碼 
	}
}
// 2007/01/29_取原始Copy訂單ID資訊

//========將陣列內容取出=========
try
{  // EXCEPTION 3: 
	int k=0;

 	String r[][]=new String[q.length][29];
 	float accWoQty = 0;
 
  	for (int i=0;i<q.length;i++) // 將陣列內容取出
  	{
    	iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
	  	r[k][0]=iNo;
		//  r[k][1]=q[i][1];  //wo_no
  	  	r[k][1]=q[i][1];  //invItem
	  	r[k][2]=q[i][2];  //itemDesc
	  	r[k][3]=q[i][3];  //woQty
	  	r[k][4]=q[i][4];  //WO_UOM
	  	r[k][5]=q[i][5];  //START_DATE		  
	  	r[k][6]=q[i][6];	//END_DATE
	  	r[k][7]=q[i][7];	 //marketType
	  	r[k][8]=q[i][8];	 //workType
	  	r[k][9]=q[i][9];    //alternateRouting
	  	r[k][10]=q[i][10];  //waferIqcNo	
 	  	r[k][11]=q[i][11];  //waferQty	
	 	r[k][12]=q[i][12];  //woRemark
	  	r[k][13]=q[i][13];  //itemId
	  	r[k][14]=q[i][14];  //oeLineId
	  	r[k][15]=q[i][15];  //customerId	
	  	r[k][16]=q[i][16];  //preFix  
	  	r[k][17]=q[i][17];  //waferLineNo
	  	r[k][18]=q[i][18];  //frontRunCardNo
	  	r[k][19]=q[i][19];  //woUnitQty
	  	r[k][20]=q[i][20];  //waferUsedPce
	  	r[k][21]=q[i][21];  //altBomSeqID
	  	r[k][22]=q[i][22];  //routingRefID
	  	r[k][23]=q[i][23];  //altBomDest
	  	r[k][24]=q[i][24];  //altroutingDest
	  	r[k][25]=q[i][25];  //oeorderno
	  	r[k][26]=q[i][26];  //oeHeaderId
	  	r[k][27]=q[i][27];  //oeLineId	
      	r[k][28]=q[i][28];  //subInv  

		//woNo=r[k][1];
		invItem=r[k][1];
		itemDesc=r[k][2];
		woQty=r[k][3];
		woUom=r[k][4];
		startDate=r[k][5];
		endDate=r[k][6];
		marketType=r[k][7];
		woType=r[k][8];
		alternateRouting=r[k][9];   //alternateRouting
		waferIqcNo=r[k][10];
		waferQty=r[k][11];
		woRemark=r[k][12];
		itemId=r[k][13];
		oeLineId=r[k][14];
		customerId=r[k][15];
		preFix=r[k][16];
		waferLineNo=r[k][17];
		frontRunCardNo=r[k][18];
		woUnitQty=r[k][19];
		if (woUnitQty==null || woUnitQty.equals("")) woUnitQty="1";
		if (waferUsedPce==null || waferUsedPce.equals("") || waferUsedPce.equals("null") )
		{
			waferUsedPce=r[k][20]; // 若是Manual未給下線片數,則以計算重分後的下線片數
		}
		altBomSeqID=r[k][21];
		routingRefID=r[k][22];
		altBomDest=r[k][23];
		altRoutingDest=r[k][24];
        oeOrderNo=r[k][25];
		oeHeaderId=r[k][26];
        oeLineId=r[k][27];
        subInv=r[k][28];
        if (oeOrderNo==null || oeOrderNo.equals("")) oeOrderNo="0"; // 表示不為後段生產
		// 更新後段工令連結前段使用量_起
		if (woType=="3" || woType.equals("3")) //後段工令
		{
			String seqSqlUF="update YEW_RUNCARD_ALL SET WIP_USED_QTY=? WHERE RUNCARD_NO='"+frontRunCardNo+"' ";   
          	PreparedStatement seqstmtUF=con.prepareStatement(seqSqlUF);        
          	seqstmtUF.setFloat(1,Float.parseFloat(woQty));   	
          	seqstmtUF.executeUpdate();   
          	seqstmtUF.close();   
		}  
		// 更新後段工令連結前段使用量_迄
		accWoQty = accWoQty + Float.parseFloat(woQty);
		
		//--- organization_id
     	String sqli = " select ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE='MARKETTYPE' and CODE= '"+marketType+"' " ;
	 	//out.print("sqli="+sqli);
	 	Statement statei=con.createStatement();
     	ResultSet rsi=statei.executeQuery(sqli);
	 	if (rsi.next())
	 	{ 	
			organizationId   = rsi.getString("ORGANIZATION_ID");   
		}
	 	rsi.close();
     	statei.close(); 	
	 
	 	// 確認工令Inventory_Item_ID 為正確的ID
	 	//20130208 liling
		// String sqlInvItem = " select INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS where SEGMENT1='"+invItem+"' and ORGANIZATION_ID= "+organizationId+" " ;
     	String sqlInvItem = " select INVENTORY_ITEM_ID "+
		                    //",substr(SEGMENT1,9,2)||decode(substr(SEGMENT1,11,1),'1','G',0,null,null) PACKING"+
							",tsc_get_item_packing_code(ORGANIZATION_ID,INVENTORY_ITEM_ID)  PACKING"+  //modify by Peggy 20150817
	                        "  from MTL_SYSTEM_ITEMS where SEGMENT1='"+invItem+"' and ORGANIZATION_ID= "+organizationId+" " ;	 
	 	//out.print("sqlInvItem="+sqlInvItem);
	 	Statement stateInvItem=con.createStatement();
     	ResultSet rsInvItem=stateInvItem.executeQuery(sqlInvItem);
	 	if (rsInvItem.next())
	 	{ 	
			itemId = rsInvItem.getString("INVENTORY_ITEM_ID");  
	    	tscPacking = rsInvItem.getString("PACKING");  //20130208 liling 
	  	}
	 	rsInvItem.close();
     	stateInvItem.close(); 	
			
   		if (woType=="4" || woType.equals("4")) { woKind="2"; } else { woKind="1";}  //woKind=2 重工屬於非標準型工單
   
   		if (alternateRouting=="2" || alternateRouting.equals("2")) 
   		{   
			alternateRoutingDesignator = "PUR";  
		}
   		else if  (alternateRouting=="3" || alternateRouting.equals("3")) 
   		{   
			alternateRoutingDesignator = "OSP";  
		}
   		else 
		{  
			alternateRoutingDesignator ="";   
		}
   		if (routingId==null || routingId.equals("") ) routingId="";
		 /*============取wo_no 工單號,起====================*/
  
  		if (preFix!=null && !preFix.equals(""))
  		{  
   			dateString=dateBean.getYearMonthDay();   
   			seqkey=preFix+userMfgDeptNo+"-"+dateString.substring(2,8);  //內外銷別+部門+年月日
   			if (classID==null || classID.equals("--")) seqkey=preFix+userMfgDeptNo+"-"+dateString.substring(2,8); // 抓年月日8碼
			else seqkey=preFix+userMfgDeptNo+"-"+dateString.substring(2,8);     // 抓年月日8碼單號   
   			//====先取得流水號=====  
   			Statement statement=con.createStatement();
  			ResultSet rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+seqkey+"' and TYPE='WO' "); // WO for WorkoOrder
   
   			if (rs.next()==false)
   			{   
    			String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
    			PreparedStatement seqstmt=con.prepareStatement(seqSql);     
    			seqstmt.setString(1,seqkey);
    			seqstmt.setInt(2,1);   
				seqstmt.setString(3,"WO");
    			seqstmt.executeUpdate();
    			seqno=seqkey+"001";
    			seqstmt.close();   
   			} 
   			else 
   			{
    			int lastno=rs.getInt("LASTNO");
    			String sql = "select * from APPS.YEW_WORKORDER_ALL where substr(WO_NO,1,9)='"+seqkey+"' and to_number(substr(WO_NO,10,3))= '"+lastno+"' ";
    			ResultSet rs2=statement.executeQuery(sql); 
	
    			//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
    			if (rs2.next())
    			{         
      				lastno++;
      				String numberString = Integer.toString(lastno);
      				String lastSeqNumber="000"+numberString;
      				lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
     				seqno=seqkey+lastSeqNumber;     
   
      				String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE='WO' ";   
      				PreparedStatement seqstmt=con.prepareStatement(seqSql);        
      				seqstmt.setInt(1,lastno);   	
     				seqstmt.executeUpdate();   
      				seqstmt.close(); 
    			} 
				else
    			{
      				//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
      				String sSqlSeq = "select to_number(substr(max(WO_NO),10,3)) as LASTNO from APPS.YEW_WORKORDER_ALL where substr(WO_NO,1,9)='"+seqkey+"' ";
      				ResultSet rs3=statement.executeQuery(sSqlSeq);
	  				if (rs3.next()==true)
	  				{
       					int lastno_r=rs3.getInt("LASTNO");
	   					lastno_r++;
	  
	   					String numberString_r = Integer.toString(lastno_r);
      	 				String lastSeqNumber_r="000"+numberString_r;
       					lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
       					seqno=seqkey+lastSeqNumber_r;  
	 
	   					String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE ='WO' ";   
       					PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       					seqstmt.setInt(1,lastno_r);   	
       					seqstmt.executeUpdate();   
       					seqstmt.close();  
	  				}  // End of if (rs3.next()==true)
   
     			} // End of Else  //===========(處理跳號問題)
    		} // End of Else    
			//docNo = seqno; // 把取到的號碼給本次輸入
			woNo = seqno; // 把取到的號碼給本次輸入
  		} // End of if (docNo==null || docNo.equals(""))	

   //out.print("woNo"+woNo);
 		//=========取 wo_no 單號,迄==========================================    
 		try   // Exception 98
 		{ 
    		//抓取資料不足欄位
			//--- WO_ID
     		String sqla = " select APPS.YEW_WORKORDER_ALL_S.nextval as WO_ID from dual ";
	 		//out.print("sqla="+sqla);
	 		Statement statea=con.createStatement();
     		ResultSet rsa=statea.executeQuery(sqla);
	 		if (rsa.next())
	 		{ 	
				workOrderId = rsa.getString("WO_ID");   
			}
	 		rsa.close();
     		statea.close(); 	 
  	 
	 		//--- tsc_package,tsc_family,tsc_amp
 
			//  2006/11/05 fix to retrive from Oracle Package				
			String sqltsc = " SELECT TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Family') TSC_FAMILY, "+
                  	        "    TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Package') TSC_PACKAGE, "+
                            "    TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Amp') TSC_AMP from dual  "; 				
			// out.print("<BR>sqltsc="+sqltsc+"<br>");
	 		Statement statetsc=con.createStatement();
     		ResultSet rstsc=statetsc.executeQuery(sqltsc);
	 		if (rstsc.next())
	 		{ 	
		   		tscAmp       = rstsc.getString("TSC_AMP"); 
		   		tscFamily    = rstsc.getString("TSC_FAMILY"); 
		   		tscPackage   = rstsc.getString("TSC_PACKAGE");
	 		}
	 		rstsc.close();
     		statetsc.close(); 	 
	
 
			//--- 取該料號的單批作業量

			if (woType=="2" || woType.equals("2" ))   //前段工令單批作業量
			{
	  			if (alternateRouting=="1" || alternateRouting.equals("1"))
	  			{
  	   				String sqlsltf = " select FONT_LOT_QTY from YEW_SINGLE_LOT_QTY where TSC_PACKAGE = upper('"+tscPackage+"')";
	   				Statement statesltf=con.createStatement();
 	   				ResultSet rssltf=statesltf.executeQuery(sqlsltf);
					if (rssltf.next())
					{ 	    
		        		singleLotQty   = rssltf.getString("FONT_LOT_QTY");   
			 			singleControl  ="Y";
	    			}
					else 
					{ 
		      			singleLotQty=woQty; 
		       			singleControl  ="Y";
		     		}  			 
	   				rssltf.close();
       				statesltf.close(); 
					
					 //20200413 DO-15 再判斷前七碼抓單批 
					if(tscPackage =="DO-15" || tscPackage.equals("DO-15"))
					{
                         String sqlsltfd = " select FONT_LOT_QTY from YEW_SINGLE_LOT_QTY where TSC_PACKAGE = '"+invItem.substring(0,7)+"' ";
	   			         Statement statesltfd=con.createStatement();
 	   				     ResultSet rssltfd=statesltfd.executeQuery(sqlsltfd);
					     if (rssltfd.next())
					     { 	    
		        		    singleLotQty   = rssltfd.getString("FONT_LOT_QTY");   
			 			    singleControl  ="Y";
	    			      }
					     else 
					     { 
		      			   singleLotQty=singleLotQty;  //沒設定者用上方抓到的為數量
		       			   singleControl  ="Y";
		     		     }  			 
	   				     rssltfd.close();
       				     statesltfd.close(); 										
					} //20200413 DO-15
										
	   			}
	   			else   //不是自製則不受單批控管
	   			{ 
	    			singleLotQty=woQty;
	     			singleControl  ="N"; 	   
	   			}	 
	 		}
	 		else if (woType=="3" || woType.equals("3" ))   //後段工令單批作業量
	 		{
	  			if (alternateRouting=="1" || alternateRouting.equals("1"))
	  			{   	
   					String sqlslt =" select AFTER_QTY from YEW_SINGLE_LOT_QTY where TSC_PACKAGE = upper('"+tscPackage+"')  "+
						           " and AFTER_UOM = upper('"+tscPacking+"') " ;	 	
	 				Statement stateslt=con.createStatement();
					//out.print("sqlsltf ="+sqlslt+"3.woType="+woType + "   singleLotQty="+singleLotQty);
     				ResultSet rsslt=stateslt.executeQuery(sqlslt);
	 	 			if (rsslt.next())
			 		{ 	
						singleLotQty   = rsslt.getString("AFTER_QTY");  
			    		singleControl  ="Y";
			  		}
		 			else
					{   //找不到對應的單批數
		       			singleLotQty=woQty; 
				   		singleControl  ="Y";
		      		}  
	 				rsslt.close();
     				stateslt.close(); 
	   			}
	   			else   //不是自制品不受單批控管
	   			{
	    			singleLotQty=woQty; 
	    			singleControl  ="N";
	   			}		 
	 		}
	 		else if   (woType=="1" || woType.equals("1" ))   //切割工令單批作業量  //20061115因切割需分批入庫故修改為單批控制  liling
	 		{
	  			singleLotQty=woQty;
	  			singleControl  ="Y";
	 		} 
	 		else if   ( woType=="4" || woType.equals("4") || woType=="5" || woType.equals("5") || woType=="6" || woType.equals("6") || woType=="7" || woType.equals("7"))   //重工及工程其他單批作業量  //20071108因其他類需單批控制  liling //20120515
	 		{
	  			singleLotQty=woQty;
	  			singleControl  ="Y";
	 		} 
	 		else   //其餘不受單批作業量控制
			{
	  			singleLotQty=woQty;
	  			singleControl  ="N";
	 		} 
 	 
			if (woType=="1" || woType.equals("1") || woType=="2" || woType.equals("2"))  //切割,前段工令 補不足欄位
	 		{
	   			//======== wafer
 	    		String sqlw = "  select IQCD.SUPPLIER_LOT_NO as WAFERLOT,IQCH.SUPPLIER_SITE_NAME, IQCH.PROD_YIELD, "+
		  		  	  		  "  IQCH.WAFER_AMP, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST ,IQCD.UOM , IQCD.DICE_SIZE		"+  //20151028 LILING DICE_SIZE
	       			          " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, "+
					          " ORADDMAN.TSCIQC_WAFER_TYPE IQCWT  "+
          			          " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE  and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO  "+
					          "  and IQCH.INSPLOT_NO = '"+waferIqcNo+"' and to_char(IQCD.LINE_NO) = '"+waferLineNo+"' ";
		 		Statement statew=con.createStatement();
	     		ResultSet rsw=statew.executeQuery(sqlw);
		 		if (rsw.next())
		 		{ 	
		        	waferLot   = rsw.getString("WAFERLOT");  
			 		waferVendor  = rsw.getString("SUPPLIER_SITE_NAME");  
					waferYld     = rsw.getString("PROD_YIELD"); // 試作良率 = 晶片良率
					waferKind    = rsw.getString("WF_TYPE_NAME"); 
					waferElect   = rsw.getString("WF_RESIST"); 
					waferUom     = rsw.getString("UOM"); 
					waferAmp     = rsw.getString("WAFER_AMP");
					diceSize     = rsw.getString("DICE_SIZE");		 //20151028 LILING DICE_SIZE			
					tscPacking   = "N/A";
		 		}
				rsw.close();
		 		statew.close();  	 
	 		}	 //end if 切割,前段工令 補不足欄位
	 		else if (woType=="7" || woType.equals("7")) // 工程實驗工令,晶片批號由Manual輸入
	 		{
	    		// 直接由前一頁手動輸入的晶片批號
		 		waferVendor  = supplyVnd;		 
		 		waferLineNo  = "N/A";
		 		waferAmp     =  "N/A";
	 		}
	 		else 
	 		{
		 		waferLot="N/A";
		 		waferIqcNo   = "N/A";
		 		waferVendor  = "N/A";
		 		waferKind    = "N/A";
		 		waferElect   = "N/A";
		 		waferUom     = "KPC";
				waferQty	  = "0";
		 		waferLineNo  = "N/A";
		 		waferAmp     =  "N/A";
	 		}	 

     		String splitLineNum = "";
     		String oeItemId="";  //20100702 Liling
 	 		if ( oeLineId!=null && !oeLineId.equals("null")) //後段工令 補不足欄位
     		{
	    
	  			//======== order_Number, order_header_id
 	    		String sqla1 = " select OOH.ORDER_NUMBER,OOL.HEADER_ID,OOL.LINE_ID,OOH.SOLD_TO_ORG_ID, OOL.LINE_NUMBER ||'.'|| OOL.SHIPMENT_NUMBER as LINE_NUM ,OOL.CUSTOMER_LINE_NUMBER,OOL.INVENTORY_ITEM_ID "+  //20130328 liling update ,OOL.CUSTOMER_LINE_NUMBER
		               "   from OE_ORDER_HEADERS_ALL OOH,OE_ORDER_LINES_ALL OOL "+
					   "  where OOH.HEADER_ID=OOL.HEADER_ID and OOL.LINE_ID= "+oeLineId; // 2007/01/03 Update By Kerwin
			    
		 		Statement statea1=con.createStatement();
	     		ResultSet rsa1=statea1.executeQuery(sqla1);
		 		if (rsa1.next())
		 		{ 	
			    	oeOrderNo   = rsa1.getString("ORDER_NUMBER");  
			 		oeHeaderId  = rsa1.getString("HEADER_ID");
					oeLineId = rsa1.getString("LINE_ID");
					splitLineNum = rsa1.getString("LINE_NUM"); // 取開單時Line_Num
					//customerPo= rsa1.getString("CUST_PO_NUMBER");
					customerPo= rsa1.getString("CUSTOMER_LINE_NUMBER"); //20130328 liling update
					oeItemId= rsa1.getString("INVENTORY_ITEM_ID");  //20100702 liling
					if (customerId==null || customerId.equals(""))  customerId = rsa1.getString("SOLD_TO_ORG_ID");	
                	if (customerPo==null || customerPo.equals(""))  customerPo = "";			
		 		}
		 		rsa1.close();
		 		statea1.close();   
	 
				//======== customerName
	     		String sqla2 = " select CUSTOMER_NAME from AR_customers where CUSTOMER_ID= "+customerId;	 
		 		Statement statea2=con.createStatement();
	     		ResultSet rsa2=statea2.executeQuery(sqla2);
		 		if (rsa2.next())
		 		{ 	
		    		customerName   = rsa2.getString("CUSTOMER_NAME");   
				}
		    	rsa2.close();
	        	statea2.close();  	 
		 	} //end if woType=3  後段
		 	else 
		 	{ 
		      	oeHeaderId="0";
		      	oeLineId="0";
		      	customerName="N/A";
			  	customerPo="N/A";
		 	} // End of else 
		 
			// 2007/01/05 加入客戶品號及End-Customer資訊供標籤使用_起	
		 	try
		 	{ // Exception for 客戶品號及End-Customer 資訊
				//if (orderExImJdge.equals("1213") || orderExImJdge.equals("1131") || orderExImJdge.equals("1141"))
				if (orderExImJdge.equals("1213") || orderExImJdge.equals("1131") || orderExImJdge.equals("1141") || orderExImJdge.equals("1121"))  //20151229 liling add 1121
			   	{  // 此三種類型找台北訂單				
					Statement stateOrgHdr=con.createStatement();
		            ResultSet rsOrgHdr=stateOrgHdr.executeQuery("select HEADER_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = "+oeOrderNo+" and ORG_ID = 41 ");
					if (rsOrgHdr.next()) orgMOHeaderID = rsOrgHdr.getString("HEADER_ID");
					rsOrgHdr.close();
					stateOrgHdr.close();				 
						 
					Statement stateOrgLine=con.createStatement();
		            ResultSet rsOrgLine=stateOrgLine.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID = "+orgMOHeaderID+" and LINE_NUMBER ||'.'|| SHIPMENT_NUMBER = '"+splitLineNum+"' and ORG_ID = 41 ");
					if (rsOrgLine.next()) orgMOLineID = rsOrgLine.getString("LINE_ID");
					rsOrgLine.close();
					stateOrgLine.close();				 
		             
			   	} 
				else if (orderExImJdge.equals("1156"))
				{  
					// Intercompany 只有一張MO單..故為原來資訊,  
					orgMOHeaderID = oeHeaderId;
					orgMOLineID = oeLineId;
					
					//20160919 liling add
					String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
			                              "  from OE_ORDER_LINES_ALL "+
								          "  where HEADER_ID = "+oeHeaderId+" and LINE_ID = "+oeLineId+"  "; // 取台北那一筆MO的客戶品號
			        Statement stateOrgCSItem=con.createStatement();
		            ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		            if (rsOrgCSItem.next())
				    { 	
						custPartItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					} 
					else 
					{ 
						custPartItem = "";  
					} // 表示原MO單未輸入客戶品號
			        rsOrgCSItem.close();
		            stateOrgCSItem.close();  	
					//20160919				
					
				}
				else if (orderExImJdge.equals("4131") || orderExImJdge.equals("4141"))
				{ // 4131為山東內銷, 故亦為原本地資訊
					orgMOHeaderID = "0";
					orgMOLineID = "0";
				}
				else 
				{ // 其他類型,一率取原開單資訊
					String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
			                              "  from OE_ORDER_LINES_ALL "+
								          "  where HEADER_ID = "+oeHeaderId+" and LINE_ID = "+oeLineId+"  "; // 取台北那一筆MO的客戶品號
			        Statement stateOrgCSItem=con.createStatement();
		            ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		            if (rsOrgCSItem.next())
				    { 	
						custPartItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					} 
					else 
					{ 
						custPartItem = "";  
					} // 表示原MO單未輸入客戶品號
			        rsOrgCSItem.close();
		            stateOrgCSItem.close();  
					         
					Statement stateOrgEndCS=con.createStatement();
		            //    ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME_PHONETIC from RA_CUSTOMERS "+
		            ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select nvl(CUSTOMER_NAME_PHONETIC,CUSTOMER_NAME) CUSTOMER_NAME_PHONETIC from AR_CUSTOMERS "+	//20111226 liling update	 ,20121107				 
					                                                "  where CUSTOMER_ID = ( select SOLD_TO_ORG_ID from OE_ORDER_HEADERS_ALL where HEADER_ID = "+oeHeaderId+" ) ");
		            if (rsOrgEndCS.next())
				    { 	
						endCustName = rsOrgEndCS.getString("CUSTOMER_NAME_PHONETIC");   
					}
			        rsOrgEndCS.close();
		            stateOrgEndCS.close(); 
			  	} // End of else 
		 	} //end of try
         	catch (SQLException e)
         	{
           		out.println("EXCEPTION 客戶品號及End-Customer資訊:"+e.getMessage());
         	}
		
    		/* ========取 alternaateRouting及Routing Id	 ==============*/ 
	 		try  
	 		{	 		   	  
			    if ( orderExImJdge.equals("1131") || orderExImJdge.equals("1141") || orderExImJdge.equals("1156") || orderExImJdge.equals("1121"))  		
			   	{    // 此四種類型找台北訂單之原ID資訊
	            	//out.print("select ORIG_SYS_DOCUMENT_REF, ORIG_SYS_LINE_REF from OE_ORDER_LINES_ALL where LINE_ID = "+oeLineId+" "+"<BR>");
			        Statement stateOrgMO=con.createStatement();
		            ResultSet rsOrgMO=stateOrgMO.executeQuery("select ORIG_SYS_DOCUMENT_REF, ORIG_SYS_LINE_REF from OE_ORDER_LINES_ALL where LINE_ID = "+oeLineId+" ");
		            if (rsOrgMO.next()) 
					{						     						 
						if (rsOrgMO.getString("ORIG_SYS_LINE_REF").indexOf("-",12)>1)
						{
					    	idxLine = rsOrgMO.getString("ORIG_SYS_LINE_REF").indexOf("-",12); // 從第13個位置之後找原訂單 Line ID "-"
						  	orgMOLineID = rsOrgMO.getString("ORIG_SYS_LINE_REF").substring( idxLine+1,rsOrgMO.getString("ORIG_SYS_LINE_REF").length() );
						}	
						else if  (orderExImJdge.equals("1156"))  //20160919 liling add 1156 ,1156的格式是由第19碼開始id,故取原先id即可 
						{
						  orgMOHeaderID = oeHeaderId;
					      orgMOLineID = oeLineId;	
						}					 
                        else   //20100702 liling  手動及YEW分批出貨無ORIG_SYS_LINE_RE LINE ID,則回台北訂單判斷
                        {
				 	    	String sqlLineid = " SELECT oola.line_id FROM oe_order_lines_all oola, oe_order_headers_all ooha "+
 											   "  WHERE oola.header_id = ooha.header_id  AND oola.org_id = 41 "+
 											   "    AND ooha.order_number = '"+oeOrderNo+"' AND oola.inventory_item_id = '"+oeItemId+"' "+
				  							   "    AND oola.ORDERED_QUANTITY >0 AND oola.CANCELLED_FLAG ='N'  "+
				 							   "    AND oola.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING') ";
			        
			         		Statement stateLineid=con.createStatement();
		             		ResultSet rsLineid=stateLineid.executeQuery(sqlLineid);
		             		if (rsLineid.next())
				     		{ 	
					 		  orgMOLineID = rsLineid.getString("LINE_ID");  
					 		} 
			        		rsLineid.close();
		            		stateLineid.close();  
                        } //end else 20100702 liling
					}	 
					rsOrgMO.close();
					stateOrgMO.close(); 					   
					   
					String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
			                              "  from OE_ORDER_LINES_ALL "+
								          " where LINE_ID = "+orgMOLineID+" and ORG_ID = 41 "; // 取台北那一筆MO的客戶品號
			        //out.print("sqlm3"+sqlm3);
			        Statement stateOrgCSItem=con.createStatement();
		            ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		            if (rsOrgCSItem.next())
				    { 	
						custPartItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					} 
					else 
					{ 
						custPartItem = "";  
					} // 表示原MO單未輸入客戶品號
			        rsOrgCSItem.close();
		            stateOrgCSItem.close();  
					 
					Statement stateOrgEndCS=con.createStatement();
		         //    ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME_PHONETIC from RA_CUSTOMERS "+
		            ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select nvl(CUSTOMER_NAME_PHONETIC,CUSTOMER_NAME) CUSTOMER_NAME_PHONETIC from AR_CUSTOMERS "+					 
					                                                  "  where CUSTOMER_ID = ( select SOLD_TO_ORG_ID from OE_ORDER_HEADERS_ALL where HEADER_ID = "+orgMOHeaderID+" ) ");
		            if (rsOrgEndCS.next())
				    { 	
						endCustName = rsOrgEndCS.getString("CUSTOMER_NAME_PHONETIC");   
					}
			        rsOrgEndCS.close();
		            stateOrgEndCS.close(); 
					   
               	}
				else if (orderExImJdge.equals("1213"))   
			   	{    
					// 此四種類型找台北訂單之原ID資訊
	                //out.print("select ORIG_SYS_DOCUMENT_REF, ORIG_SYS_LINE_REF from OE_ORDER_LINES_ALL where LINE_ID = "+oeLineId+" "+"<BR>");
			        Statement stateOrgMO=con.createStatement();
		            ResultSet rsOrgMO=stateOrgMO.executeQuery("select ORIG_SYS_DOCUMENT_REF, ORIG_SYS_LINE_REF from OE_ORDER_LINES_ALL where LINE_ID = "+oeLineId+" ");
		            if (rsOrgMO.next()) 
					{						     						 
						if (rsOrgMO.getString("ORIG_SYS_LINE_REF").indexOf("-",12)>1)
						{
					    	idxLine = rsOrgMO.getString("ORIG_SYS_LINE_REF").indexOf("-",12); // 從第13個位置之後找原訂單 Line ID "-"
						  	orgMOLineID = rsOrgMO.getString("ORIG_SYS_LINE_REF").substring( idxLine+1,rsOrgMO.getString("ORIG_SYS_LINE_REF").length() );
						}						 
						//out.println("ORIG_SYS_LINE_REF="+rsOrgMO.getString("ORIG_SYS_LINE_REF")+"<BR>");
                        else   //20100702 liling  手動及YEW分批出貨無ORIG_SYS_LINE_RE LINE ID,則回台北訂單判斷
                        {
				 	    	String sqlLineid = " SELECT oola.line_id FROM oe_order_lines_all oola, oe_order_headers_all ooha "+
 												  "  WHERE oola.header_id = ooha.header_id  AND oola.org_id = 41 "+
 												  "    AND ooha.order_number = '"+oeOrderNo+"' AND oola.inventory_item_id = '"+oeItemId+"' "+
				  								  "    AND oola.ORDERED_QUANTITY >0 AND oola.CANCELLED_FLAG ='N'  "+
				 								  "    AND oola.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING') ";
			        
			         		Statement stateLineid=con.createStatement();
		             		ResultSet rsLineid=stateLineid.executeQuery(sqlLineid);
		             		if (rsLineid.next())
				     		{ 	
					 			orgMOLineID = rsLineid.getString("LINE_ID");  
					 		} 
			        		rsLineid.close();
		            		stateLineid.close();  
                        } //end else 20100702 liling
					}	 
					rsOrgMO.close();
					stateOrgMO.close(); 					   
					   
					String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
			                               "  from OE_ORDER_LINES_ALL "+
								           " where LINE_ID = "+orgMOLineID+" and ORG_ID = 41 "; // 取台北那一筆MO的客戶品號
			        //out.print("sqlm3"+sqlm3);
			        Statement stateOrgCSItem=con.createStatement();
		            ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		            if (rsOrgCSItem.next())
				    { 	
						custPartItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					} 
					else 
					{ 
						custPartItem = "";  
					} // 表示原MO單未輸入客戶品號
			        rsOrgCSItem.close();
		            stateOrgCSItem.close();  
					 
					Statement stateOrgEndCS=con.createStatement();
		            ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select FADFV.DOCUMENT_DESCRIPTION as CUSTOMER_NAME_PHONETIC  from FND_ATTACHED_DOCS_FORM_VL FADFV "+
					                                                   "  where FADFV.FUNCTION_NAME = 'OEXOEORD'  and UPPER(FADFV.CATEGORY_DESCRIPTION) = 'SHIPPING MARKS' and FADFV.PK1_VALUE = "+orgMOHeaderID+" ");
		            
                    if (rsOrgEndCS.next())
				    { 	
						endCustName = rsOrgEndCS.getString("CUSTOMER_NAME_PHONETIC");   
					}
			        rsOrgEndCS.close();
		            stateOrgEndCS.close(); 
			 	}
				else if (orderExImJdge.equals("1214") )   //modify by Peggy 20131211
			   	{  
					orgMOHeaderID = oeHeaderId; //add by Peggy 20190225
					orgMOLineID = oeLineId;
					String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
			                               "  from OE_ORDER_LINES_ALL "+
								           " where LINE_ID = "+orgMOLineID+" and ORG_ID = 41 "; // 取台北那一筆MO的客戶品號
			        Statement stateOrgCSItem=con.createStatement();
		            ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		            if (rsOrgCSItem.next())
				    { 	
						custPartItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					} 
					else 
					{ 
						custPartItem = "";  
					} // 表示原MO單未輸入客戶品號
			        rsOrgCSItem.close();
		            stateOrgCSItem.close();  
					 
					Statement stateOrgEndCS=con.createStatement();
		            ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select FADFV.DOCUMENT_DESCRIPTION as CUSTOMER_NAME_PHONETIC  from FND_ATTACHED_DOCS_FORM_VL FADFV "+
					                                                   "  where FADFV.FUNCTION_NAME = 'OEXOEORD'  and UPPER(FADFV.CATEGORY_DESCRIPTION) = 'SHIPPING MARKS' and FADFV.PK1_VALUE = "+orgMOHeaderID+" ");
		            
                    if (rsOrgEndCS.next())
				    { 	
						endCustName = rsOrgEndCS.getString("CUSTOMER_NAME_PHONETIC");   
					}
			        rsOrgEndCS.close();
		            stateOrgEndCS.close(); 
			 	} 				 
				else if (orderExImJdge.equals("4131") || orderExImJdge.equals("4141"))
			    {  // 原訂單ID即為MO ID
					orgMOHeaderID = oeHeaderId;
					orgMOLineID = oeLineId;	
						   
					Statement stateOrgHdr=con.createStatement();
		            ResultSet rsOrgHdr=stateOrgHdr.executeQuery("select HEADER_ID, SHIP_TO_ORG_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = "+oeOrderNo+" and ORG_ID = 325 ");
					if (rsOrgHdr.next()) 
					{ 						    
						shipToOrgID = rsOrgHdr.getString("SHIP_TO_ORG_ID"); // 取內銷出貨地
					}
					rsOrgHdr.close();
					stateOrgHdr.close();							 
											 
					// Intercompany 只有一張MO單..故為原來資訊,   4131為山東內銷, 故亦為原本地資訊
					String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
			                               "  from OE_ORDER_LINES_ALL "+
								           "  where HEADER_ID = "+orgMOHeaderID+" and LINE_ID = "+orgMOLineID+"  "; // 取台北那一筆MO的客戶品號
			        //out.print("sqlOrgCSItem="+sqlOrgCSItem);
			        Statement stateOrgCSItem=con.createStatement();
		            ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		            if (rsOrgCSItem.next())
				    { 	
						custPartItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					} 
					else 
					{ 
						custPartItem = "";  
					} // 表示原MO單未輸入客戶品號
			        rsOrgCSItem.close();
		            stateOrgCSItem.close();  
					 
					Statement stateOrgEndCS=con.createStatement();
		            //  ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME from RA_CUSTOMERS "+
		            ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME from AR_CUSTOMERS "+						 
					                                                "  where PARTY_ID in ( select b.PARTY_ID from RA_SITE_USES_ALL a, RA_ADDRESSES_ALL b where a.ADDRESS_ID = b.ADDRESS_ID and a.SITE_USE_ID = "+shipToOrgID+" ) ");
					//customerName =shipFromOrgID;												 
		            if (rsOrgEndCS.next())
				    { 	
						endCustName = rsOrgEndCS.getString("CUSTOMER_NAME");						    
					}
			        rsOrgEndCS.close();
		            stateOrgEndCS.close(); 					   
				} // End of if 
				else 
				{
					orgMOHeaderID = oeHeaderId;
					orgMOLineID = oeLineId;						 
				}	 

				//20151229 判斷FSC的料號,若是則塞endCustName=FSC
				if (orderExImJdge.equals("1121") )
				{
					Statement stateFSCitem=con.createStatement();
		            ResultSet rsFSCitem=stateFSCitem.executeQuery("  select 'FSC' FSC_ITEM   from mtl_system_items  "+						 
					                                                "    where organization_id=43  and upper(description) like  '%FAIRCHILD%'  and segment1='"+invItem+"' "); 
					//customerName =shipFromOrgID;												 
		            if (rsFSCitem.next())
				    { 	
						endCustName = rsFSCitem.getString("FSC_ITEM");	
										    
					}
			        rsFSCitem.close();
		            stateFSCitem.close(); 	
			     }				
				//20151229
				
				//20171102 判斷ON SEMI的料號,若是則塞endCustName=ON SEMI
				if (orderExImJdge.equals("1121") )
				{
					Statement stateFSCitem=con.createStatement();
		            ResultSet rsFSCitem=stateFSCitem.executeQuery("  select 'ON SEMI' ONSEMI_ITEM   from mtl_system_items  "+						 
					                                                "    where organization_id=43  and upper(description) like  '%ON SEMI%'  and segment1='"+invItem+"' "); 
					//customerName =shipFromOrgID;												 
		            if (rsFSCitem.next())
				    { 	
						endCustName = rsFSCitem.getString("ONSEMI_ITEM");	
										    
					}
			        rsFSCitem.close();
		            stateFSCitem.close(); 	
			     }				
				//20171102				
						  
	 		} //end of try
     		catch (Exception e)
     		{
	   			//e.printStackTrace();
        		out.println("EXCEPTION Original Order Info:"+e.getMessage());
     		}//end of catch   	
  		} //end of try
  		catch (Exception e)
  		{
	    	e.printStackTrace();
        	out.println("EXCEPTION 98:"+e.getMessage());
  		}//end of catch   
	 	 
		//  欄位辨識
		String marketCode=null;
		String woTypeCode=null;	 
	 
	 	PreparedStatement pstmt=null;
 		if (k==q.length-1)   //若為後段工令,則可能為多筆前段工令完工數累加,僅加總完工數量作一筆後段工令新增
 		{  
  			/*====== 寫入YEW_WORKORDER_ALL table ======================================*/	 
  
    		// 若是後段工令,則預計完工日需比MO單上之Schedule Ship Date提早兩天_起
	   		if (woType.equals("3"))
	   		{  // Step0. 先把今日日期記下來
	      		int currYear = dateBean.getYear();
		  		int currMonth = dateBean.getMonth();
		  		int currDay = dateBean.getDay();
	      		// Step1. 將dateBean日期設為原預計完工日
	      		dateBean.setVarDate(Integer.parseInt(endDate.substring(0,4)),Integer.parseInt(endDate.substring(4,6)),Integer.parseInt(endDate.substring(6,8)));
		  		// Step2. 把預計完工日設為原給定提早兩日
	      		//dateBean.setAdjDate(-2);  //modify by Peggy 20181119,李永勤說不要提早兩天
	      		endDate = dateBean.getYearMonthDay(); // 新的預計完工日
		  		//dateBean.setAdjDate(2); // 日期還原 //modify by Peggy 20181119,李永勤說不要提早兩天
		  		dateBean.setVarDate(currYear,currMonth,currDay);
		  		//out.println(dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
		  		out.println("<BR><font color='#FF0000'>後段工令!為出貨前置作業考量,工令預計完工日為(</font>"+"<font color='#000099'>"+endDate+"</font>"+"<font color='#FF0000'>)</font><BR>");
	   		}
	
			// 若是後段工令,則預計完工日需比MO單上之Schedule Ship Date提早兩天_迄

    		String sql= " insert into YEW_WORKORDER_ALL( WORKORDER_ID, WO_NO ,DEPT_NO , MARKET_TYPE, WORKORDER_TYPE ,   "+           
						"	JOB_TYPE , ALTERNATE_ROUTING_DESIGNATOR , INVENTORY_ITEM_ID, INV_ITEM, ITEM_DESC,         "+
  						"	WO_QTY , WO_UOM, WO_STATUS , SCHEDULE_STRART_DATE, SCHEDULE_END_DATE ,ROUTING_REFERENCE_ID ,   "+  
						"   COMPLETION_SUBINVENTORY ,TSC_PACKAGE , TSC_AMP , TSC_FAMILY ,TSC_PACKING, SINGLE_CONTROL, SINGLE_LOT_QTY  ,"+ 
  						"	WAFER_LOT_NO ,WAFER_QTY  , WAFER_LINE_NO , WAFER_IQC_NO ,WAFER_KIND  , WAFER_VENDOR ,OE_ORDER_NO ,CUSTOMER_NAME, "+ 
  						"	ORDER_HEADER_ID, ORDER_LINE_ID ,WO_REMARK ,CREATION_DATE , CREATE_BY ,USER_NAME, ORGANIZATION_ID ,STATUSID, STATUS, ALTERNATE_ROUTING, PROD_SOURCE, WO_UNIT_QTY, "+
						"   WAFER_YIELD, WAFER_AMP, ORDER_QTY_CR, WAFER_USED_PCE, ALT_BILL_SEQUENCE_ID, ALT_BILL_DEST, CUST_PART_NO, END_CUST_ALNAME, SUPPLIER_LOT_NO, DICE_SIZE, WFRESIST,CUSTOMER_PO,ORG_OEHEADER_ID,ORG_OELINE_ID,WAFER_UOM, CUST_LOT, LAST_UPDATED_BY) "+
               			 " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
    		//out.println("sql="+sql);
    		pstmt=con.prepareStatement(sql);  
    		pstmt.setInt(1,Integer.parseInt(workOrderId));  // workorder_id
    		pstmt.setString(2,woNo); // 工單號
    		pstmt.setString(3,userMfgDeptNo);  // 部門代碼
    		pstmt.setString(4,marketType);  //    --內外銷別 
    		pstmt.setString(5,woType); // 工單類別(前後段...) 
    		pstmt.setString(6,woKind); // 標準,非標準工單
    		pstmt.setString(7,altRoutingDest);   //ALTERNATE_ROUTING_DESIGNATO   20061127 liling update
    		pstmt.setInt(8,Integer.parseInt(itemId));  //inventory_item_id
    		pstmt.setString(9,invItem);  // INV_ITEM 
    		pstmt.setString(10,itemDesc);  // ITEM_DESC
    		pstmt.setFloat(11,accWoQty);  // WO_QTY
    		pstmt.setString(12,woUom); // WO_UOM
    		pstmt.setString(13,"O"); // wo status O=open
    		pstmt.setString(14,startDate+dateBean.getHourMinuteSecond()); 
    		pstmt.setString(15,endDate+dateBean.getHourMinuteSecond());
			if(woType=="4" || woType.equals("4")) routingRefID="0";
    		pstmt.setInt(16,Integer.parseInt(routingRefID));    //還抓不到id以1先暫代,供測試用  //20061127 liling update altnate routing id
    		pstmt.setString(17,subInv); //default subinventory
    		pstmt.setString(18,tscPackage); // 
    		pstmt.setString(19,tscAmp); //
    		pstmt.setString(20,tscFamily); // 
    		pstmt.setString(21,tscPacking); //
    		pstmt.setString(22,singleControl); // 單批作業管制
    		pstmt.setFloat(23,Float.parseFloat(singleLotQty)); // 單批作業量
    		pstmt.setString(24,waferLot); // 晶片批號
    		pstmt.setFloat(25,Float.parseFloat(waferQty)); //waferQty
    		pstmt.setString(26,waferLineNo); //檢驗批號項次  
    		pstmt.setString(27,waferIqcNo); // 
    		pstmt.setString(28,waferKind); // 
    		pstmt.setString(29,waferVendor); //
    		pstmt.setString(30,oeOrderNo);// 
    		pstmt.setString(31,customerName);//
    		pstmt.setInt(32,Integer.parseInt(oeHeaderId)); //  
    		pstmt.setInt(33,Integer.parseInt(oeLineId)); //  
    		pstmt.setString(34,woRemark);//  
    		pstmt.setString(35,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());// CREATION_DATE日期  
    		pstmt.setString(36,userMfgUserID);  // 寫入
    		pstmt.setString(37,userMfgUserName);// 寫入User name 
    		pstmt.setString(38,organizationId); // 寫入organizationId 
    		pstmt.setString(39,"040"); // 寫入STATUD_ID  '040'
    		pstmt.setString(40,"CREATING"); // 寫入STATUD_ID  '040'
    		pstmt.setString(41,alternateRouting); // 寫入(新增工令的CombBox自制=1,外購=2,委外加工=3)
			pstmt.setString(42,prodSource); // 區分製二前段工令開立來源(1 : 表正常, 2 : 表來至前段工令)
			pstmt.setFloat(43,Float.parseFloat(woUnitQty)); //工令單位用量(可能是1,2,4),作為計算可用餘量之用
			pstmt.setString(44,waferYld); // 試作良率 = 晶片良率 = ProdYield
			pstmt.setString(45,waferAmp);   // 安培數
			pstmt.setFloat(46,Float.parseFloat(orderQty));    // 後段工令開立時依Line之待開立MO數量
	 		if (waferUsedPce==null || waferUsedPce.equals("")) waferUsedPce="0";
			pstmt.setFloat(47,Float.parseFloat(waferUsedPce));   // 下線片數
    		if(woType=="4" || woType.equals("4")) altBomSeqID="0";	
			pstmt.setInt(48,Integer.parseInt(altBomSeqID));    // altnate bom seq id
			if(woType=="4" || woType.equals("4")) altBomDest="";
			pstmt.setString(49,altBomDest); // alternate bom Dest	
			pstmt.setString(50,custPartItem); // Customer Part No.
			pstmt.setString(51,endCustName);  // End-Customer Name
			pstmt.setString(52,opSupplierLot); // 外購品廠商批號(後段工令)
			pstmt.setString(53,diceSize);   // 晶粒尺寸
	 		if (waferElect==null || waferElect.equals("")) waferElect="0";
			pstmt.setString(54,waferElect); // 阻值(伏數)
    		pstmt.setString(55,customerPo); // customerPo
			pstmt.setInt(56,Integer.parseInt(orgMOHeaderID)); //  原台北訂單ID
		    pstmt.setInt(57,Integer.parseInt(orgMOLineID));   // 原台北訂單ID
			pstmt.setString(58,waferUom); // 晶片單位
		//	if(woType!="3" && !woType.equals("3")) custType="0"; //  若不為後段工令,則客戶批號一律為一般客戶  //20151026 liling disable
		    if (woType=="1" || woType=="2" ||woType=="4" ||woType=="6"||woType=="7") custType="0";
			pstmt.setString(59,custType); // 2007/08/12 客戶特殊批號
			pstmt.setString(60,userMfgUserID);  // LAST_UPDATED_BY  20231102 LILING add
    		pstmt.executeUpdate();   
    		pstmt.close();
 		} // end if (k==q.length-1)

	    String sqlm1 = " select code_desc MARKETCODE from yew_mfg_defdata where def_type='MARKETTYPE' and code='"+marketType+"' ";
		//out.print("sqlm1"+sqlm1);		 
		Statement statem1=con.createStatement();
	    ResultSet rsm1=statem1.executeQuery(sqlm1);
		if (rsm1.next())
		{ 	
			marketCode   = rsm1.getString("MARKETCODE");   
		}
		rsm1.close();
	    statem1.close();  	
		 
		String sqlm2 = " select code_desc WOTYPECODE from yew_mfg_defdata where def_type='WO_TYPE' and code='"+woType+"' ";
		//out.print("sqlm2"+sqlm2);
		Statement statem2=con.createStatement();
	    ResultSet rsm2=statem2.executeQuery(sqlm2);
		if (rsm2.next())
		{ 
			woTypeCode   = rsm2.getString("WOTYPECODE");  
		}
		rsm2.close();
	    statem2.close();  
		//*******************  20120306 修改FSC單批數量 起 ******************
		//out.print("<br>endCustName="+endCustName+"    tscPackage="+tscPackage);
		if (endCustName=="FSC" || endCustName.equals("FSC") || endCustName=="FAIRCHILD" || endCustName.equals("FAIRCHILD"))
   		{ 
   
    		if(tscPackage=="DO-41" || tscPackage.equals("DO-41"))  singleLotQty="50";
			if(tscPackage=="DO-15" || tscPackage.equals("DO-15"))  singleLotQty="20";
			if(tscPackage=="DO-201" || tscPackage.equals("DO-201"))  singleLotQty="12.5";
			if(tscPackage=="DO-201AD" || tscPackage.equals("DO-201AD"))  singleLotQty="12.5";
			if(tscPackage=="DBL" || tscPackage.equals("DBL"))  singleLotQty="5";
			if(tscPackage=="GBU" || tscPackage.equals("GBU"))  singleLotQty="3.2";
			if(tscPackage=="KBP" || tscPackage.equals("KBP"))  singleLotQty="4.8";	
			if(tscPackage=="KBL" || tscPackage.equals("KBL"))  singleLotQty="1.8";	
			if(tscPackage=="KBU" || tscPackage.equals("KBU"))  singleLotQty="1.8";	
			if(tscPackage=="GBJ" || tscPackage.equals("GBJ"))  singleLotQty="2";						
   
			String woUpSql=" update APPS.YEW_WORKORDER_ALL set SINGLE_LOT_QTY=? "+ 	             
	                       " where WO_NO = '"+woNo+"' "; 	
			//out.println("<br>woupsql="+woUpSql);			
    		PreparedStatement woUpstmt=con.prepareStatement(woUpSql);	        
    		woUpstmt.setFloat(1,Float.parseFloat(singleLotQty)); 	
    		woUpstmt.executeUpdate();   
    		woUpstmt.close();    
   		}
		//*******************  20120306 修改FSC單批數量 迄 ******************	 
		
		//*******************  20171102 修改ON SEMI單批數量 起 ******************
		//out.print("<br>endCustName="+endCustName+"    tscPackage="+tscPackage);
		if (endCustName=="ON SEMI" || endCustName.equals("ON SEMI") || endCustName.equals("On Semiconductor") || endCustName.equals("ON SEMICONDUCTOR"))
   		{ 
   
    		if(tscPackage=="DO-41" || tscPackage.equals("DO-41"))  singleLotQty="50";
			if(tscPackage=="DO-15" || tscPackage.equals("DO-15"))  singleLotQty="40";  //20190722 20->40
			if(tscPackage=="DO-201" || tscPackage.equals("DO-201"))  singleLotQty="12.5";
			if(tscPackage=="DO-201AD" || tscPackage.equals("DO-201AD"))  singleLotQty="12.5";
			if(tscPackage=="DBL" || tscPackage.equals("DBL"))  singleLotQty="5";
			if(tscPackage=="GBU" || tscPackage.equals("GBU"))  singleLotQty="3.2";
			if(tscPackage=="KBP" || tscPackage.equals("KBP"))  singleLotQty="4.8";	
			if(tscPackage=="KBL" || tscPackage.equals("KBL"))  singleLotQty="1.8";	
			if(tscPackage=="KBU" || tscPackage.equals("KBU"))  singleLotQty="1.8";	
			if(tscPackage=="GBJ" || tscPackage.equals("GBJ"))  singleLotQty="2";	
			if(tscPackage=="MBS" || tscPackage.equals("MBS"))  singleLotQty="30";  //20180416 YEW ADD	
			if(tscPackage=="SOD-123HE" || tscPackage.equals("SOD-123HE"))  singleLotQty="107.52";  //20181218 YEW ADD 100 ,20210129 update to 107.52
			if(tscPackage=="SUB SMA" || tscPackage.equals("SUB SMA"))  singleLotQty="64";       //20181218 YEW ADD
			if(tscPackage=="SOD-123W" || tscPackage.equals("SOD-123W"))  singleLotQty="107.52";       //20210127 YEW ADD
							
   
			String woUpSql=" update APPS.YEW_WORKORDER_ALL set SINGLE_LOT_QTY=? "+ 	             
	                       " where WO_NO = '"+woNo+"' "; 	
			//out.println("<br>woupsql="+woUpSql);			
    		PreparedStatement woUpstmt=con.prepareStatement(woUpSql);	        
    		woUpstmt.setFloat(1,Float.parseFloat(singleLotQty)); 	
    		woUpstmt.executeUpdate();   
    		woUpstmt.close();    
   		}
		//*******************  20171102 修改ON SEMI單批數量 迄 ******************	 		
		 
		 
 		// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& 寫入流程卡關聯關係表 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&_起
 		if (woType=="1" || woType.equals("1"))  // 切割工令_起
 		{
     		// 並寫入一筆連結表資料_起
		   	String seqSqlIns="insert into YEW_MFG_TRAVELS_ALL(PRIMARY_NO, PRIMARY_TYPE, EXTEND_NO, EXTEND_TYPE, EXTENDED_QTY, ORDER_NO, CREATED_BY, LAST_UPDATED_BY, PRIMARY_PARENT_NO) "+
		                     "values(?,?,?,?,?,?,?,?,?) ";   
           	PreparedStatement seqstmtIns=con.prepareStatement(seqSqlIns);        
           	seqstmtIns.setString(1,frontRunCardNo); 
		   	seqstmtIns.setString(2,"0");  
		   	seqstmtIns.setString(3,woNo); 
		   	seqstmtIns.setString(4,woType);
		   	seqstmtIns.setFloat(5,Float.parseFloat(woQty));      	
		   	seqstmtIns.setString(6,waferIqcNo);
		   	seqstmtIns.setString(7,userMfgUserID);
		   	seqstmtIns.setString(8,userMfgUserID);
		   	seqstmtIns.setString(9,frontRunCardNo); // 主要父序號(對切割而言是廠商晶片批號)
           	seqstmtIns.executeUpdate();   
           	seqstmtIns.close(); 
     		// 並寫入一筆連結表資料_迄	 
 		}   // 切割工令_迄
 
 		if (woType=="2" || woType.equals("2")) // 前段工令_起
 		{       
			// Step1: 找切割流程卡號對應的工令號
         	String sqlfrWoNo = " select WO_NO from YEW_RUNCARD_ALL where RUNCARD_NO='"+frontRunCardNo+"' ";
		 	String frontWoNo = "";
		 	Statement statefrWoNo=con.createStatement();
	     	ResultSet rsfrWoNo=statefrWoNo.executeQuery(sqlfrWoNo);
		 	if (rsfrWoNo.next())
		 	{ 
				frontWoNo = rsfrWoNo.getString("WO_NO");  
		 	} 
			else 
			{
		    	frontWoNo = frontRunCardNo; // 對前段工令而言可能是廠商晶片批號或切割工令號 
		    }
		 	rsfrWoNo.close();
	     	statefrWoNo.close(); 

     		// 並寫入一筆連結表資料_起
		   	String seqSqlIns="insert into YEW_MFG_TRAVELS_ALL(PRIMARY_NO, PRIMARY_TYPE, EXTEND_NO, EXTEND_TYPE, EXTENDED_QTY, ORDER_NO, CREATED_BY, LAST_UPDATED_BY, PRIMARY_PARENT_NO) "+
		                    "values(?,?,?,?,?,?,?,?,?) ";   
           	PreparedStatement seqstmtIns=con.prepareStatement(seqSqlIns);        
           	seqstmtIns.setString(1,frontRunCardNo); // 原IQC檢驗批號或切割流程卡號 
		   	seqstmtIns.setString(2,prodSource);  //  由切割工令開前段工令 = 1; 由製二的前段工令再開一次前段工令 = 2 
		   	seqstmtIns.setString(3,woNo); 
		   	seqstmtIns.setString(4,woType);
		   	seqstmtIns.setFloat(5,Float.parseFloat(woQty));      	
		   	seqstmtIns.setString(6,waferIqcNo);
		   	seqstmtIns.setString(7,userMfgUserID);
		   	seqstmtIns.setString(8,userMfgUserID);
		   	seqstmtIns.setString(9,frontWoNo); // 主要父序號(對前段而言是廠商晶片批號或切割工令號)
           	seqstmtIns.executeUpdate();   
           	seqstmtIns.close(); 		  
 		} // 前段工令_迄
 
 		if (woType=="3" || woType.equals("3") || woType.equals("5") || woType.equals("5"))  //後段及樣品工令串前段工令及訂單號
 		{		 
      		// Step1: 找切割流程卡號對應的工令號
         	String sqlfrWoNo = " select WO_NO from YEW_RUNCARD_ALL where RUNCARD_NO='"+frontRunCardNo+"' ";
		 	String frontWoNo = "";
		 	Statement statefrWoNo=con.createStatement();
	     	ResultSet rsfrWoNo=statefrWoNo.executeQuery(sqlfrWoNo);
		 	if (rsfrWoNo.next())
		 	{ 
				frontWoNo = rsfrWoNo.getString("WO_NO");  
		 	}
		 	rsfrWoNo.close();
	     	statefrWoNo.close(); 
 
   			// 並寫入一筆連結表資料_起
		   	String seqSqlIns="insert into YEW_MFG_TRAVELS_ALL(PRIMARY_NO, PRIMARY_TYPE, EXTEND_NO, EXTEND_TYPE, EXTENDED_QTY, ORDER_NO, CREATED_BY, LAST_UPDATED_BY, PRIMARY_PARENT_NO, ORDER_LINE_ID ) "+
		                    "values(?,?,?,?,?,?,?,?,?,?) ";   
           	PreparedStatement seqstmtIns=con.prepareStatement(seqSqlIns);        
           	seqstmtIns.setString(1,frontRunCardNo); 
		   	seqstmtIns.setString(2,"2");  // 一律由前段工令產生後段工令
		   	seqstmtIns.setString(3,woNo); 
		   	seqstmtIns.setString(4,woType);
		   	seqstmtIns.setFloat(5,Float.parseFloat(woQty));      	
		   	seqstmtIns.setString(6,oeOrderNo);
		   	seqstmtIns.setString(7,userMfgUserID);
		   	seqstmtIns.setString(8,userMfgUserID);
		   	seqstmtIns.setString(9,frontWoNo); // 主要父序號
		   	seqstmtIns.setString(10,oeLineId); // 原訂單項次號
           	seqstmtIns.executeUpdate();   
           	seqstmtIns.close(); 
 		} // end of if (woType=="3" || woType.equals("3"))	
 
 		if (woType=="4" || woType.equals("4"))  //重工工令串原後段工令及訂單號
 		{		 
      		// Step1: 找切割流程卡號對應的工令號
         	String sqlfrWoNo = " select WO_NO from YEW_WORKORDER_ALL where OE_ORDER_NO='"+oeOrderNo+"' and ORDER_HEADER_ID='"+oeHeaderId+"' and ORDER_LINE_ID='"+oeLineId+"'  ";
		 	String preWoNo = "";
		 	Statement statefrWoNo=con.createStatement();
	     	ResultSet rsfrWoNo=statefrWoNo.executeQuery(sqlfrWoNo);
		 	if (rsfrWoNo.next())
		 	{ 
				preWoNo = rsfrWoNo.getString("WO_NO");  
		 	}
		 	rsfrWoNo.close();
	     	statefrWoNo.close(); 
		   
		   	String seqSqlIns="insert into YEW_MFG_TRAVELS_ALL(PRIMARY_NO, PRIMARY_TYPE, EXTEND_NO, EXTEND_TYPE, EXTENDED_QTY, ORDER_NO, CREATED_BY, LAST_UPDATED_BY, PRIMARY_PARENT_NO, ORDER_LINE_ID ) "+
		                    "values(?,?,?,?,?,?,?,?,?,?) ";   
           	PreparedStatement seqstmtIns=con.prepareStatement(seqSqlIns);        
           	seqstmtIns.setString(1,frontRunCardNo); 
		   	seqstmtIns.setString(2,"3");  // 一律由後段工令產生重工工令
		   	seqstmtIns.setString(3,woNo); 
		   	seqstmtIns.setString(4,woType);
		   	seqstmtIns.setFloat(5,Float.parseFloat(woQty));      	
		   	seqstmtIns.setString(6,oeOrderNo);
		   	seqstmtIns.setString(7,userMfgUserID);
		   	seqstmtIns.setString(8,userMfgUserID);
		   	seqstmtIns.setString(9,preWoNo); // 主要父序號
		   	seqstmtIns.setString(10,oeLineId); // 原訂單項次號
           	seqstmtIns.executeUpdate();   
           	seqstmtIns.close(); 
 		}
 	 
 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& 寫入流程卡關聯關係表 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&_迄
%>
<table width="90%" border="1" cellpadding="0" cellspacing="0" borderColorLight="#000099"> 
   <tr bgcolor="#0000CC">
       <td width="15%" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgWorkOrder"/></font></td>
	   <td width="7%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgInSales"/>/<jsp:getProperty name="rPH" property="pgExpSales"/></font></td>
	   <td width="6%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgClass"/></font></td>
	   <td width="20%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgPart"/></font></td>
	   <td width="20%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgItemDesc"/></font></td>
	   <td width="8%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgQty"/></font></td>
	   <td width="5%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgUOM"/></font></td>
	   <td width="8%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgSchStartDate"/></font></td>
	   <td width="8%" align="center" nowrap><font color="#FFFFFF"><jsp:getProperty name="rPH" property="pgSchCompletDate"/></font></td>
   </tr> 
<% //  } // end if k=0  %>
   <tr>
       <td width="15%" nowrap><%=woNo%></td><td align="center" width="6%"><%=marketCode%></td>
	   <td align="center" width="6%" nowrap><%=woTypeCode%></td><td width="20%"><%=invItem%></td>
	   <td width="20%" nowrap><%=itemDesc%></td><td align="center" width="8%"><%=woQty%></td>
	   <td align="center" width="5%" nowrap><%=woUom%></td>
	   <td align="center" width="8%" nowrap><%=startDate%></td><td align="center" width="8%"><%=endDate%></td>
   </tr></table>
<%   

    //檢查是否存檔成功
    try  
    {    
	  Statement statement=con.createStatement(); 
      ResultSet rs=statement.executeQuery("SELECT WO_NO FROM APPS.YEW_WORKORDER_ALL WHERE WO_NO='"+woNo+"' ");    
      if (!rs.next())
      {
        %>
		   <script language="javascript">
		     alert("WORK ORDER="+document.MYFORM.WONO.value+"SAVE Faile!!!");		    
		   </script>
		<%
	  } 
      rs.close(); 
	  statement.close();
     } //end of try
     catch (Exception e)
     {
	    e.printStackTrace();
        out.println("EXCEPTION 99:"+e.getMessage());
     }//end of catch   
	 
   k++;   //累加陣列內容  
   
 }  //end  for (int i=0;i<q.length;i++)  


 
} //end of try
catch (Exception e)
{
  e.printStackTrace();
  out.println("EXCEPTION 3:"+e.getMessage());
}//end of catch
%>

<table width="60%" border="1" cellpadding="0" cellspacing="0" >
  <tr>
    <td width="278"><font size="2">WIP單據處理</font></td>
    <td width="297"><font size="2">WIP查詢及報表</font></td>    
  </tr>
  <tr>   
    <td>
<%
  

  try  
  { out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E5"; 	
	String sqlE3 = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ";
	//out.println("sqlE3="+sqlE3);
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlE3);    	
    while(rs.next())
    {
	    //out.println("FSEQ="+rs.getString("FSEQ"));
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
    rs.close(); 
	statement.close();
	out.println("</table>");  
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch  
   
%>   
 </td> 
 <td>
 <%
  try  
  { out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E6";    
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
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch   
   
%></td>    
  </tr>
</table>


<!-- 表單參數 -->  
    <input name="PRESEQNO" type="HIDDEN" value="<%=seqno%>">	   
	<input name="REPTIMES" type="HIDDEN" value="<%=RepTimes%>">  <!--做為判斷是否已選取故障描述-->
<%
    arrayCheckBoxBean.setArray2DString(null); //將此bean值清空以為不同case可以重新運作
	arrayWODocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<%
    //response.sendRedirect("TSSalesDRQ_Create.jsp");
    // Modify by Jingker for Order Import Redirect 2006/03/07
	if (repeatInput==null || repeatInput.equals(""))
	{	  
	} else
	    { 
		  //response.reset();
		  response.sendRedirect("../jsp/TSCMfgWoCreate.jsp?PREDNDOCNO="+seqno);
        }
   /*
    if (repeatInput ==null || repeatInput.equals(""))
	{ }
	else
	{
	   if (fromPage =="RepairInputPage.jsp" || fromPage.equals("RepairInputPage.jsp"))
       {    response.sendRedirect("RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
	    else if (fromPage =="(3)RepairInputPage.jsp" || fromPage.equals("(3)RepairInputPage.jsp"))
	          {    response.sendRedirect("(3)RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
	           else if (fromPage =="(X)RepairInputPage.jsp" || fromPage.equals("(X)RepairInputPage.jsp"))
	                 {    response.sendRedirect("(X)RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
  	                else if (fromPage =="(0)RepairInputPage.jsp" || fromPage.equals("(0)RepairInputPage.jsp"))
	                     {    response.sendRedirect("(0)RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
	}
	*/
%>
</html>

