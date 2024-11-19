<!--20071108 liling 增加判斷重工及其他類 woType=="4","7"  可展單批數量-->
<!--20110111 liling FOR SAMSUNG datecode ISSUE -->
<!--20111108 liling FOR FAGOR datecode ISSUE and FSC/SAMSUNG modify -->
<!--20120109 liling FOR SAMSUNG datecode dept ISSUE modify -->
<!--20130102 liling FOR datecode 改週次計算  -->
<!--20130208 liling FOR M1 GreenCompont datecode Issue  -->
<!--20130325 liling FOR dc rule for wotype=3  -->
<!--20130704 Peggy,SAMSUNG DateCode取消前置0規則,Green Compound不分部門,一律在DateCode第一碼加G-->
<!--20130709 Peggy,ABS/MBS 系列產品，2013年起工廠均用環保樹脂生產，D/C不須區分帶G或不帶G-->
<!--20130905 liling FOR yew 要求加入樣品工單 datecode資訊  -->
<!--20140814 liling 正確顯示未設卡號前置碼訊息  -->
<!--20140827 liling FOR yew 要求加入實驗工單 datecode資訊  -->
<!--20150422 Peggy,SOD123HE系列產品，2013年起工廠均用環保樹脂生產，D/C不須區分帶G或不帶G-->
<!--20150817 Peggy,Fairchild & FAGOR DATA CODE不帶G-->
<!--20150914 Peggy,SOD-123HE系列產品，2013年起工廠均用環保樹脂生產，D/C不須區分帶G或不帶G-->
<!--20151026 liling 增加樣品加入custlotno-->
<!--20151111 Peggy,特規型號TS15P05G-14 & TS15P05G-16 datacdoe+S-->
<!--20151225 Peggy,周次超過52以52為主-->
<!--20151229 liling 修正物件CUSTLOT_PREFIX 存custLotPrefix-->
<!--20160104 Peggy,1/1為每年第一周,每周第一天為星期一-->
<!--20160226 Peggy,依http://www.calendar-365.com/2016-calendar.html網站定義周次-->
<!--20160704 liling  GBU805-03 D2 /GBU805-03 C2 /GBU806-13 D2 特規單批數量為1K -->
<!--20161220 Peggy,package:SOD-128 D/C不帶G-->
<!--20170326 Peggy,上海禾馥(視源) D/C增加星期幾-->
<!--20170822 liling TS10B06G-07 c_mon-->
<!--20170901 liling MBS10-02 Fairchild RCG 特規30k->
<!--20171018 Peggy,on semi date code rule=yyww-->
<!--20171020 liling ,c_eng_mon & MBS10-08 ON Semi RCG-->
<!--20171114 Peggy,標準品走台半D/C rule,特規型號follow FAGOR D/C rule-->
<!--20171207 liling add UG2D-05 SHS d/c rule -->
<!--20171219 Peggy,增加以品名判斷是否為on semi訂單(4121)-->
<!--20180706 Peggy,on semi house no為-ON -->
<!--20190306 Peggy,package:Thin SMA D/C不帶G-->
<!--20220430 liling,流程卡前置碼山東需求由package 改由料號前4碼抓取-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat"%>
<html>
<head>
<title>MFG System Work Order Expand Process Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFG2DWOExpandBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function submitCheck(ms1,ms2,ms3)
{ //alert("AAA");  
	if (document.DISPLAYREPAIR.ACTIONID.value=="020")  //GENERTED表示為確認工令生成並展開流程卡動作
  	{
    	flag=confirm(ms2);      
        if (flag==false) return(false);
		else 
		{
			return(true);
		}
  	}     
}

function setSubmit(URL,ms1)
{ //alert(); 
	if (document.DISPLAYREPAIR.WOTYPE.value ==3 || document.DISPLAYREPAIR.WOTYPE.value==5 || document.DISPLAYREPAIR.WOTYPE.value==7)
	{
		//檢查DC_YYWW
		if (document.DISPLAYREPAIR.DC_YYWW.value.length!=4)
		{
			alert("DC_YYWW長度固定四碼!");
			return false;
		}
		else
		{
			var i_yy=document.DISPLAYREPAIR.DC_YYWW.value.substr(0,2);
			var i_ww=eval(document.DISPLAYREPAIR.DC_YYWW.value.substr(2,2));
			var i_year=eval(document.DISPLAYREPAIR.CREATEDATE.value.substr(2,2));
			var i_mon=eval(document.DISPLAYREPAIR.CREATEDATE.value.substr(4,2));
			if (i_ww>52)
			{
				alert("DC_YYWW周別最大為52!");
				return false;
			}
			//if (i_yy!=i_year &&  ((eval(i_year)-eval(i_yy))!=1 || i_mon!=1))
			//{
			//	alert("DC_YYWW年度有誤,請重新確認!");
			//	return false;
			//}
		}
	}
	if (document.DISPLAYREPAIR.ACTIONID.value=="020")  //GENERTED表示為確認工令生成並展開流程卡動作
  	{
    	flag=confirm(ms1);      
        if (flag==false) return(false);
		else 
		{  //alert("BBB");				       		          
						//return(true);
		}
  	}  
  	//alert("BBB");
  	document.DISPLAYREPAIR.submit2.disabled = true;   
  	document.DISPLAYREPAIR.action=URL;
  	document.DISPLAYREPAIR.submit();
}

function setSubmit1(URL)
{ //alert(); 
	document.DISPLAYREPAIR.action=URL;
  	document.DISPLAYREPAIR.submit();
}

function setSubmit2(URL)
{ 
	var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  	document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  	document.DISPLAYREPAIR.submit();    
}

function setQty(URL,xSingleLotQty)
{ //alert(); 
	document.DISPLAYREPAIR.RECOUNTFLAG.value="Y";
  	document.DISPLAYREPAIR.SINGLELOTQTY.value=xSingleLotQty;
  	//alert(xSingleLotQty+"  "+document.DISPLAYREPAIR.SINGLELOTQTY.value);
  	document.DISPLAYREPAIR.action=URL;
  	document.DISPLAYREPAIR.submit();
}

function setDateCode(URL,xDateCodeQty)
{ //alert(); 
	document.DISPLAYREPAIR.DATECODEFLAG.value="Y";
  	document.DISPLAYREPAIR.DATECODE.value=xDateCodeQty;
  	//alert(xSingleLotQty+"  "+document.DISPLAYREPAIR.SINGLELOTQTY.value);
  	document.DISPLAYREPAIR.action=URL;
  	document.DISPLAYREPAIR.submit();
}

function subWindowRoutingRefFind(organizationID,itemId,routingRefID,altRoutingDest)
{    
	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  	subWin=window.open("../jsp/subwindow/TSMfgBomRoutingFind.jsp?ORGANIZATIONID="+organizationID+"&PRIMARYITEMID="+itemId+"&ROUTINGREFID="+routingRefID+"&ALTROUTINGDEST="+altRoutingDest,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");  
} 

function setDCYYWW()
{
	if (document.DISPLAYREPAIR.DATECODE.value.substr(0,document.DISPLAYREPAIR.ORIG_DC.value.length)!=document.DISPLAYREPAIR.ORIG_DC.value)
	{
		document.DISPLAYREPAIR.DC_YYWW.value="";
	}
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
String actionID = request.getParameter("ACTIONID"); 
String woNo=request.getParameter("WO_NO"); 
String marketType=request.getParameter("MARKETTYPE");
String woType=request.getParameter("WOTYPE");
String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
String startDate=request.getParameter("STARTDATE");
String endDate=request.getParameter("ENDDATE");
String woQty=request.getParameter("WOQTY");
String invItem=request.getParameter("INVITEM");

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
//String alternateRouting=request.getParameter("ALTERNATEROUTING"); 
String customerName=request.getParameter("CUSTOMERNAME");	
String endCustomerName=request.getParameter("ENDCUSTOMERNAME");	
String customerNo=request.getParameter("CUSTOMERNO");
String customerPo=request.getParameter("CUSTOMERPO");
String oeOrderNo=request.getParameter("OEORDERNO");	
String deptNo=request.getParameter("DEPT_NO");	
String deptName=request.getParameter("DEPT_NAME");	
String preFix=request.getParameter("PREFIX");
String oeHeaderId=request.getParameter("OEHEADERID");	
String oeLineId=request.getParameter("OELINEID");	
	
String waferLineNo=request.getParameter("LINE_NO");

String totalYield=request.getParameter("TOTALYIELD");
//String prodModel=request.getParameter("PRODMODEL");
String prodYield=request.getParameter("PRODYIELD");
String result=request.getParameter("RESULT");
String singleLotQty=request.getParameter("SINGLELOTQTY");
String singleControl=request.getParameter("SINGLECONTROL");
//String runCardCount=request.getParameter("RUNCARDCOUNT");
int runCardCount=0;
double runCardCountI=0;
int lastRunCardQty=0;
double runCardCountD=0;
double singleLotQtyD=0;

double runCardQty=0;
// String runCardQty=request.getParameter("RUNCARDQTY");
String reCountFlag=request.getParameter("RECOUNTFLAG");
String  dividedFlag=request.getParameter("DIVIDEDFLAG");
String runCardNo=request.getParameter("RUNCARD_NO");
String runCardPrefix=request.getParameter("RUNCARD_PREFIX");
//String custLot=request.getParameter("CUSTLOT"); // 客戶特殊批號 0: 無設定客戶特殊批號, 1: 需產生客戶特殊批號
String custLotPrefix=request.getParameter("CUSTLOT_PREFIX");  // 客戶批號前置碼
String custLotType=request.getParameter("CUST_LOT");  // 一般0 OR 客戶批號1

String packageCode="";
String dateCode=request.getParameter("DATECODE");
String dateCodeFlag=request.getParameter("DATECODEFLAG");
String order_line_id=""; //add by Peggy 20170326
String dc_yyww=request.getParameter("DC_YYWW");  //add by Peggy 20220704

//reCountFlag="N";
if (reCountFlag==null || reCountFlag.equals("")) reCountFlag="N";
if (dateCodeFlag==null || dateCodeFlag.equals("")) dateCodeFlag="N";   
//out.print("reCountFlag="+reCountFlag);

String itemId="0", routingId="", alterRoutingDesignator ="", routingRefID="", altRoutingDest="",onsemi_flag=""; 
//organizationId="";
//alternateRoutingDesignator="";   //   

String organizationID=request.getParameter("ORGANIZATIONID");
   
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否執行工令生成並展開流程卡???","請選擇執行動作")' ACTION="../jsp/TSCMfgWoExpandMProcess.jsp?WO_NO=<%=woNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      內容明細 : <BR>
 </font>      
  </tr>       
</table>
<%    	
try
{
	//--- 取得Routing ID
    String sqlR = " select  JOB_TYPE, ORGANIZATION_ID, ALTERNATE_ROUTING, ALTERNATE_ROUTING_DESIGNATOR, INVENTORY_ITEM_ID, ROUTING_REFERENCE_ID, ALTERNATE_ROUTING_DESIGNATOR as ALT_ROUTING_DEST,CUSTOMER_NAME,upper(END_CUST_ALNAME) END_CUST_ALNAME ,DEPT_NO ,CUST_LOT,ORDER_LINE_ID "+ //ORDER_LINE_ID,add by Peggy 20170326
	              ",tsc_label_pkg.TSC_GET_ONSEMI_PARTNO ('"+itemDesc+"') onsemi_partno_flag"+  //add by Peggy 20220824
	              "  from APPS.YEW_WORKORDER_ALL where WO_NO= '"+woNo+"' " ;
	// out.print("sqlR="+sqlR);
	Statement stateR=con.createStatement();
    ResultSet rsR=stateR.executeQuery(sqlR);
	if (rsR.next())
	{ 			   
		alternateRoutingDesignator = rsR.getString("ALTERNATE_ROUTING_DESIGNATOR");
        itemId= rsR.getString("INVENTORY_ITEM_ID");
		routingId = rsR.getString("ROUTING_REFERENCE_ID");
		jobType = rsR.getString("JOB_TYPE");
		alternateRouting =  rsR.getString("ALTERNATE_ROUTING");
		organizationID = rsR.getString("ORGANIZATION_ID");
		altRoutingDest  = rsR.getString("ALT_ROUTING_DEST");
		customerName = rsR.getString("CUSTOMER_NAME");  //20100325 liling for FSC datecode issue			
		endCustomerName = rsR.getString("END_CUST_ALNAME");  //20100325 liling for FSC datecode issue
		deptNo = rsR.getString("DEPT_NO");  //20100325 liling for FSC datecode issue
		custLotType = rsR.getString("CUST_LOT");  //20151026 liling for FSC cust lot issue	
		order_line_id = rsR.getString("ORDER_LINE_ID"); //20170326 by Peggy	
		onsemi_flag=rsR.getString("onsemi_partno_flag");  //add by Peggy 20220824
	}
	rsR.close();
    stateR.close();  
    //out.print("********");
} //end of try
catch (Exception e)
{
	out.println("Exception 0:"+e.getMessage());
}	

try
{// out.print("reCountFlag="+reCountFlag);
	if (reCountFlag=="N" || reCountFlag.equals("N"))    //沒有按下重算單批數量才抓單批數量
   	{
		//--- 取得單批作業量
     	String sqli = " select  DEPT_NO,MARKET_TYPE,WORKORDER_TYPE,TSC_PACKAGE,SINGLE_LOT_QTY,SINGLE_CONTROL "+	 	    
	                  "  from APPS.YEW_WORKORDER_ALL where WO_NO= '"+woNo+"' " ;
	    //out.print("sqli="+sqli);
	    Statement statei=con.createStatement();
     	ResultSet rsi=statei.executeQuery(sqli);
	 	if (rsi.next())
		{ 	
			deptNo      = rsi.getString("DEPT_NO");
			marketType  = rsi.getString("MARKET_TYPE");
			woType      = rsi.getString("WORKORDER_TYPE");
			tscPackage  = rsi.getString("TSC_PACKAGE");
		    singleLotQty   = rsi.getString("SINGLE_LOT_QTY");   
    		singleControl  = rsi.getString("SINGLE_CONTROL");
						
		}
	 	rsi.close();
     	statei.close();  
	}//end if 
	
	//out.print("<br>id:"+organizationID+"<br>itemDesc="+itemDesc+"<br>singleLotQty="+singleLotQty);
	// 20160704 liling add  特規單批數量為1k

		if (itemDesc.equals("GBU806-13 D2")) 
		    { singleLotQty = "1"; }	
			
		if ( organizationID.equals("326") && itemDesc.equals("GBU805-03 C2") )
		    { singleLotQty = "1";  }	
			
	//	if ( organizationID.equals("327") && itemDesc.equals("GBU805-03 D2") )  
		if ( itemDesc.equals("GBU805-03 D2") )   //20170313 liling YEW 改D2不分內外銷都1K
		    { singleLotQty = "1";  }					
				
	//
		if ( itemDesc.equals("MBS10-02 Fairchild RCG") )   //20170901 liling add 
		    { singleLotQty = "30";  }	
				
		if ( itemDesc.equals("TS6K80-02 X0") )   //20180831 liling add 
		    { singleLotQty = "1.6";  }		
		if ( itemDesc.equals("TS6K80-01 X0") )   //20180831 liling add 
		    { singleLotQty = "1.6";  }								
		if ( itemDesc.equals("TS6K80-02 X0G") || itemDesc.equals("TS10K80-01 X0") )   //20180913 liling add 
		    { singleLotQty = "1.6";  }	
		if ( itemDesc.equals("TS6P05G-07 X0") || itemDesc.equals("TS6P05G-07 X0G"))   //20181218 liling add 
		    { singleLotQty = "1.2";  }					
		if ( itemDesc.equals("TS10K80-02 X0") || itemDesc.equals("TS10K80-02 X0"))   //20210129 liling add 
		    { singleLotQty = "1.6";  }		
		if ( itemDesc.equals("TS4K60-05 X0") || itemDesc.equals("TS4K60-05 X0"))   //20210129 liling add 
		    { singleLotQty = "1.6";  }				
	
	
	
} //end of try
catch (Exception e)
{
	e.printStackTrace();
    out.println("EXCEPTION 沒有按下重算單批數量才抓單批數量:"+e.getMessage());
}//end of catch   	
 
 
// 判斷是否展開有取得BOM ROUTING SEQUENCE ID_起  
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
 
try
{ 
	//抓取流程卡前置碼作業
	if( woType=="2" || woType.equals("2") || woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5") )   //只有前後段需要前置(會有一工令,對應多張流程卡)
	{ 
	 /*
    	String sqli = " select  RUNCARD_PREFIX, CUSTLOT_PREFIX from YEW_RUNCARD_PREFIX "+
					  " where DEPT_NO= '"+deptNo+"'  and MARKET_TYPE = '"+marketType+"' "+
					//  "   and WO_TYPE = '"+woType+"' and TSC_PACKAGE like '"+tscPackage+"' ";
                      "   and WO_TYPE = replace("+woType+",'5','3')  "+  //20151027 liling update sample 比照後段
                      "   and TSC_PACKAGE = '"+tscPackage+"' ";		 
	 */
    	String sqli = " select distinct RUNCARD_PREFIX, CUSTLOT_PREFIX from YEW_RUNCARD_PREFIX "+
					  " where DEPT_NO= '"+deptNo+"'  and MARKET_TYPE = '"+marketType+"' "+
                      "   and WO_TYPE = replace("+woType+",'5','3')  "+  //20151027 liling update sample 比照後段
                      "   and PACKAGE_NO =  substr('"+invItem+"',1,4) ";	//20220430
					  				
		//out.print("sqli="+sqli);
		Statement statei=con.createStatement();
		ResultSet rsi=statei.executeQuery(sqli);
		if (rsi.next())
		{ 	
			runCardPrefix  = rsi.getString("RUNCARD_PREFIX");
			custLotPrefix = rsi.getString("CUSTLOT_PREFIX"); // 20070812 針對後段客戶批號取出前置序號	
			
		    //out.print("runCardPrefix:"+runCardPrefix);		
		}
		else  //沒有找到相對應的值時,統一前置碼為
		{  
			//out.print("step2");
			%>
			  <script language="javascript">
			//	alert("找不到此package '<%=tscPackage%>',請確認補足資料庫後再展卡!!!");  //20140814 liling
				alert("找不到此package no'<%=invItem%>'卡號前置碼,請通知MIS補足資料庫YEW_RUNCARD_PREFIX後再展卡!!!");				
				<%locale="00";%>
			  </script>
			<%
			// 針對後段工令,特別取客戶特殊批號做寫入_起
		//	if (woType.equals("3"))
			if (woType.equals("3") || woType.equals("5") )	 //20151026 liling yew issue 
			{
			  if (custLotType=="1" || custLotType.equals("1"))
			   {
			    /*
				  String sqlCLot = "select distinct CUSTLOT_PREFIX from YEW_RUNCARD_PREFIX "+
				  				   " where DEPT_NO= '"+deptNo+"'  and WO_TYPE = replace("+woType+",'5','3')  "+   //20151026
								   " and MARKET_TYPE = '"+marketType+"' and TSC_PACKAGE like '"+tscPackage+"'"; 
		         */
				  String sqlCLot = "select CUSTLOT_PREFIX from YEW_RUNCARD_PREFIX "+
				  				   " where DEPT_NO= '"+deptNo+"'  and WO_TYPE = replace("+woType+",'5','3')  "+   
								   " and MARKET_TYPE = '"+marketType+"'  and PACKAGE_NO = substr('"+invItem+"',1,4) ";    						   
					  
				  Statement stateCLot=con.createStatement();
				  ResultSet rsCLot=stateCLot.executeQuery(sqlCLot);	
				  if (rsCLot.next())
				  {
					custLotPrefix = rsCLot.getString("CUSTLOT_PREFIX"); // 20070812 針對後段客戶批號取出前置序號					
				  }
				 //20151026 liling add else
				  else
				 {
		     	   %>
			        <script language="javascript">
			    	alert("找不到此部門package no '<%=invItem%>'卡號客戶前置碼,請通知MIS補足資料庫YEW_RUNCARD_PREFIX後再展卡!!!");				
				    <%locale="00";%>
			       </script>
			      <%				
				 }  //20151026 liling add else
				rsCLot.close();
				stateCLot.close();	
		       }	   
			}				   
		}	
		rsi.close();
		statei.close();  
	} //end 前後段
	else
	{ 
		runCardNo=woNo; 
	} //Update by Kerwin
//  }//制一部  20120510 M1~M3 皆需要判斷 PACKAGE

	if  ( woType=="1" || woType.equals("1") || woType=="4" || woType.equals("4") || woType=="7" || woType.equals("7") || woType=="5" || woType.equals("5") || woType=="6" || woType.equals("6"))   //20071108 增加判斷其他類 woType=="7"  ,20090114 liling add wotype=5
	{
	   out.print("step3");
		String sqlia = " select  distinct RUNCARD_PREFIX, CUSTLOT_PREFIX from YEW_RUNCARD_PREFIX "+
					   " where DEPT_NO= '"+deptNo+"'  and MARKET_TYPE = '"+marketType+"' and WO_TYPE = '"+woType+"'";
	
		//out.print("sqlia="+sqlia);
		Statement stateia=con.createStatement();
		ResultSet rsia=stateia.executeQuery(sqlia);
		if (rsia.next())
		{ 	
			runCardPrefix   = rsia.getString("RUNCARD_PREFIX");
			//custLotPrefix = rsia.getString("CUSTLOT_PREFIX"); // 20070812 針對後段客戶批號取出前置序號
		}
		rsia.close();
		stateia.close(); 
	}
}//end of try
catch (Exception e)
{
	out.println("Exception 只有前後段需要前置(一工令,對應多張流程卡):"+e.getMessage());
}	

try
{
	//抓取DATE CODE 
 //	if( woType=="3" || woType.equals("3")  || woType=="5" || woType.equals("5") )   //20130325 只有後段需要dc  //20130905 加入樣品工單入dc
 	if( woType=="3" || woType.equals("3")  || woType=="5" || woType.equals("5") || woType=="7" || woType.equals("7") )   //20130325 只有後段需要dc  //20130905 加入樣品工單入dc	 //20140827 加入實驗工單入dc
  	{  
   		if (endCustomerName==null || dateCodeFlag.equals("null")) endCustomerName = "na";
   		if (dateCodeFlag=="N" || dateCodeFlag.equals("N"))    //沒有按下重算單批數量才抓單批數量
    	{
     		if (altRoutingDest==null || altRoutingDest.equals("")) altRoutingDest="TSC" ;
	
		  	//20100429 liling add creation_date 避免重覆上傳,及package 大小寫問題
		  	//   String sqlda = " select TSC_PACKAGE from yew_date_code where TSC_MAKEBUY='"+altRoutingDest+"' and TSC_PACKAGE='"+tscPackage+"' ";
			String sqlda = " select TSC_PACKAGE from yew_date_code A where TSC_MAKEBUY='"+altRoutingDest+"' and upper(TSC_PACKAGE)=UPPER('"+tscPackage+"') "+
							"   and a.CREATION_DATE =(SELECT MAX(CREATION_DATE) FROM  yew_date_code b WHERE a.tsc_package=b.tsc_package   "+
							"                      	     AND a.tsc_makebuy = b.tsc_makebuy  AND a.period=b.period  and a.week=b.week) ";


	 		//out.print("sqlda="+sqlda);
	 		Statement stateda=con.createStatement();
     		ResultSet rsda=stateda.executeQuery(sqlda);
	 		if (rsda.next())
		 	{ 	
		    	packageCode   = rsda.getString("TSC_PACKAGE");
		 	}
	 		else packageCode="YEW" ;   //若在DATE CODE TABLE無抓到特定的PACKAGE則,屬於一般的DATE,故使用YEW去抓PERIOD值
		 
	 		rsda.close();
     		stateda.close(); 
			
			//取年度,周別 by Peggy 20160104
			String c_year="",c_week="",c_eng_year="",c_mon="",c_eng_mon="",a_eng_mon="";  
			//String sql = "SELECT to_char(sysdate,'yyyy') c_year,CASE WHEN TO_NUMBER(WEEK)>52 THEN '52' ELSE WEEK END c_week,CHR(TO_CHAR(SYSDATE,'YYYY')-2010+65) c_eng_year "+
			//             //" FROM (select (to_char(TRUNC(sysdate)+CASE WHEN TO_CHAR(TRUNC(sysdate,'YYYY'),'IW')<>1 THEN 7 ELSE 0 END,'IW')) AS WEEK from dual)";
			//			 " from (SELECT  TO_CHAR(CASE WHEN TO_CHAR(SYSDATE,'D')=1 THEN SYSDATE+1 ELSE SYSDATE END,'IW') AS week FROM dual)"; //modify by Peggy 20160226,依http://www.calendar-365.com/2016-calendar.html網站定義周次
			//String sql = "select tsc_get_calendar_week(sysdate,'YEAR') AS C_YEAR,tsc_get_calendar_week(sysdate,'WEEK') AS C_WEEK,CHR(tsc_get_calendar_week(sysdate,'YEAR')-2010+65) C_ENG_YEAR , LTRIM(TO_CHAR(SYSDATE,'MM'),'0') AS C_MON FROM DUAL"; //modify by Peggy 20160302
           String sql = "select tsc_get_calendar_week(sysdate,'YEAR') AS C_YEAR,tsc_get_calendar_week(sysdate,'WEEK') AS C_WEEK,CHR(tsc_get_calendar_week(sysdate,'YEAR')-2010+65) C_ENG_YEAR , "+
			              "       LTRIM(TO_CHAR(SYSDATE,'MM'),'0') AS C_MON, SUBSTR(TO_CHAR(SYSDATE,'MON'),1,1) AS C_ENG_MON ,CHR(TO_CHAR(SYSDATE,'MM')+64) A_ENG_MON  FROM DUAL"; //modify by Peggy 20160302	,20171020 liling add c_eng_mon		
	 		Statement state=con.createStatement();
     		ResultSet rs=state.executeQuery(sql);
	 		if (rs.next())
		 	{ 	
		    	c_year = rs.getString("c_year");
		    	c_week = rs.getString("c_week");
		    	c_eng_year = rs.getString("c_eng_year");
				c_mon = rs.getString("c_mon");
				c_eng_mon = rs.getString("c_eng_mon");  //20171020 liling add	
				a_eng_mon = rs.getString("A_ENG_MON");  //20171207 liling add				
		 	}
	 		rs.close();
     		state.close();
			
  			//20100429 liling add creation_date 避免重覆上傳,及package 大小寫問題 
   			//  String sqldc = " select DATE_CODE from yew_date_code   "+
   			//	 				"  where PERIOD=SUBSTR(TO_CHAR(TRUNC(SYSDATE),'YYYY/MM/DD'),1,7) and TSC_MAKEBUY='"+altRoutingDest+"' and TSC_PACKAGE='"+packageCode+"' ";
     		//String sqldc = " select A.DATE_CODE from yew_date_code A  "+
	 		//	//	"  where A.PERIOD=SUBSTR(TO_CHAR(TRUNC(SYSDATE),'YYYY/MM/DD'),1,7) and A.TSC_MAKEBUY='"+altRoutingDest+"' and upper(A.TSC_PACKAGE)=UPPER('"+packageCode+"') "+
	 		//		"  where A.TSC_MAKEBUY='"+altRoutingDest+"' and upper(A.TSC_PACKAGE)=UPPER('"+packageCode+"') "+	//20130102 抓年份				
	 		//		"   and  SUBSTR(A.PERIOD,1,4)=TO_CHAR(TRUNC(SYSDATE),'YYYY')"+
			//		//"   and A.WEEK=to_number(to_char(TRUNC(SYSDATE),'FMIW')) "+		//20130102 liling update by DC ISSUE BY WEEK			
			//		"   and A.WEEK=case when to_number(to_char(TRUNC(SYSDATE),'FMIW')) > 52 then 52 else to_number(to_char(TRUNC(SYSDATE),'FMIW')) end "+		//20151225 by Peggy,超過52周以52為主
            //       "   and a.CREATION_DATE =(SELECT MAX(CREATION_DATE) FROM  yew_date_code b WHERE a.tsc_package=b.tsc_package   "+
 			//		"                      	     AND a.tsc_makebuy = b.tsc_makebuy  AND a.period=b.period and a.week=b.week) ";
			//20160104 by Peggy,1/1為第一周
			//String sqldc = " select A.DATE_CODE from yew_date_code A  "+
			String sqldc = " select yew_dc_special_spec("+order_line_id+",A.DATE_CODE,sysdate,'01') as DATE_CODE from yew_date_code A  "+	//modify by Peggy 20170326		
			               " where A.TSC_MAKEBUY='"+altRoutingDest+"'"+
						   " and upper(A.TSC_PACKAGE)=UPPER('"+packageCode+"') "+	
						   " and SUBSTR(A.PERIOD,1,4)='"+c_year+"'"+
						   " and A.WEEK=to_number('"+ c_week+"')"+
						   " order by a.CREATION_DATE desc"; 
	 		//out.print("<br>sqlc="+sqldc);
	 		Statement statedc=con.createStatement();
     		ResultSet rsdc=statedc.executeQuery(sqldc);
	 		if (rsdc.next())
		 	{ 	
		    	dateCode   = rsdc.getString("DATE_CODE");
				dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
		 	}
	 		rsdc.close();
     		statedc.close(); 
			//20100325 liling FOR FSC datecode ISSUE___start
			//out.print("<br>customerName="+customerName);
   			if (endCustomerName=="FSC" || endCustomerName.equals("FSC") || endCustomerName=="FAIRCHILD" || endCustomerName.equals("FAIRCHILD"))
   			{ 
				/*
				//SYSDATE+7 是因為IW 年初1/1那週會被試為是上年度的最後一週,所以週期都會少算一週故再加7天  //2010/05/12 liling
   				//  String sqlFdc = " SELECT 'A'||TO_CHAR(SYSDATE,'YY')||TO_CHAR(SYSDATE,'IW') FC_DATE_CODE FROM dual  ";  
  				//   String sqlFdc = " SELECT 'A'||TO_CHAR(SYSDATE,'YY')||TO_CHAR(SYSDATE+7,'IW') FC_DATE_CODE FROM dual  ";  
    		 	//String sqlFdc = " SELECT 'A'||TO_CHAR(SYSDATE,'YY')||TO_CHAR(SYSDATE,'IW') FC_DATE_CODE FROM dual  ";  	//20111108 liling 修正for yew issue 
				String sqlFdc = " SELECT 'A'||TO_CHAR(SYSDATE,'YY')|| case when TO_CHAR(SYSDATE,'IW') > '52' then '52' else TO_CHAR(SYSDATE,'IW') end  FC_DATE_CODE FROM dual  ";  //20151225 by Peggy,超過52周以52為主
    		 	//String sqlFdc = " SELECT 'A'||TO_CHAR(SYSDATE,'YY')||TO_CHAR(SYSDATE,'WW') FC_DATE_CODE FROM dual  ";  	//20151026 liling 修正for yew FSC DC issue 				
	 			//out.print("sqlia="+sqlFdc);
	 			Statement stateFdc=con.createStatement();
     			ResultSet rsFdc=stateFdc.executeQuery(sqlFdc);
	 			if (rsFdc.next())
		 		{ 	
		    		dateCode   = rsFdc.getString(1);
		 		}
		 
	 			rsFdc.close();
     			stateFdc.close();
				*/
				dateCode = "A"+c_year.substring(2,4)+c_week; //add by Peggy 20160104
				dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
   	 		}
			//20111108 liling FOR FAGOR datecode ISSUE___start
   			//else if (endCustomerName=="FAGOR" || endCustomerName.equals("FAGOR"))
			else if ((customerName.toUpperCase().startsWith("FAGOR") || endCustomerName.toUpperCase().startsWith("FAGOR")) && itemDesc.indexOf("-")>=0)
   			{ 
				/*
    			//2011-->B ,2012-->C....
 				//    String sqlfadc = " SELECT TO_CHAR(SYSDATE,'FMWW')||CHR(TO_CHAR(SYSDATE,'YYYY')-2010+65) FROM dual ";  
     			//String sqlfadc = " SELECT TO_CHAR(SYSDATE,'WW')||CHR(TO_CHAR(SYSDATE,'YYYY')-2010+65) FROM dual ";  	//20130102 YEW DC ISSUE 
				String sqlfadc = " SELECT case when TO_CHAR(SYSDATE,'WW')>'52' then '52' else TO_CHAR(SYSDATE,'WW') end ||CHR(TO_CHAR(SYSDATE,'YYYY')-2010+65) FROM dual ";  	//20151225 by Peggy,超過52周以52為主
	 			//out.print("sqlia="+sqlFdc);
	 			Statement stateFadc=con.createStatement();
     			ResultSet rsFadc=stateFadc.executeQuery(sqlfadc);
	 			if (rsFadc.next())
				{ 	
					dateCode   = rsFadc.getString(1);
				}
		 
	 			rsFadc.close();
     			stateFadc.close();
				*/
				////特規格才按客戶d/c,否則,依台半d/c rule,add by Peggy 20171115
				//if (itemDesc.indexOf("-")>=0)
				///{
					String s_code =itemDesc.substring(itemDesc.lastIndexOf("-")+1,itemDesc.lastIndexOf("-")+2);
					//代表特規料號
					if (s_code.equals("0") || s_code.equals("1") || s_code.equals("2") || s_code.equals("3") || s_code.equals("4") || s_code.equals("5") || s_code.equals("6") || s_code.equals("7") || s_code.equals("8") || s_code.equals("9"))
					{
						dateCode = c_week + c_eng_year; //add by Peggy 20160104
						dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
						
					}
				//}
    		}
			//on semi datecode rule=yyymm,add by Peggy 20171018
			else if (customerName.toUpperCase().startsWith("ON SEMI") || endCustomerName.toUpperCase().startsWith("ON SEMI") ||  itemDesc.toUpperCase().indexOf("ON SEMI")>=0 ||  itemDesc.toUpperCase().indexOf("-ON ")>=0 || onsemi_flag.equals("Y"))  //add -ON by Peggy 20180706
			{
				dateCode =c_year.substring(2,4)+c_week;
				dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
			}
			//modify by Peggy add tsc_package=SOD123HE 
			//add package:SOD-123W & SOD123W by Peggy 20160419
			//add package=DO-218AB by Peggy 20181017  
			//else if (!packageCode.startsWith("ABS") && !packageCode.equals("MBS")  && !packageCode.equals("SOD123HE")  && !packageCode.equals("SOD-123HE") && !packageCode.equals("SOD-123W") && !packageCode.equals("SOD123W")  && tscPacking.length() ==3 && tscPacking.substring(2,3).equals("G")) 
			else if (!packageCode.startsWith("ABS") && !packageCode.equals("MBS")  && !packageCode.startsWith("SOD123")  && !packageCode.startsWith("SOD-123") && !packageCode.startsWith("SOD-128")  && !packageCode.startsWith("DO-218AB") && !packageCode.startsWith("Thin SMA") && tscPacking.length() ==3 && tscPacking.substring(2,3).equals("G")) 
			{
				dateCode  ="G"+dateCode;
				dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
			}
			
			//add by Peggy 20151111
			if (itemDesc.startsWith("TS15P05G-14") || itemDesc.startsWith("TS15P05G-16") || itemDesc.startsWith("TS15P06G-06"))  //20160628 liling add TS15P06G-06
			{
				dateCode += "S";
				dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
			}
			
			if (itemDesc.startsWith("TS10B06G-07"))  // 20170822 add by liling
			{
			    if (  Integer.parseInt(c_mon) > 9)  //10月起要用簡碼 O,N ,D
				{  
					dateCode =  c_eng_year+c_eng_mon; 
					dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
				} //20171020 add by liling
				else
				{  
					dateCode =  c_eng_year+c_mon; 
					dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
				}   //20170822 add by liling
			}			


			if (itemDesc.startsWith("UG2D-05 SHS"))  // 20171207 add by liling
			{
                dateCode = c_year.substring(4,4)+a_eng_mon+'1'; 
				dc_yyww = c_year.substring(2,4)+("0"+c_week).substring(("0"+c_week).length()-2);  //add by Peggy 20220704
			}						
					
 		} 
  	}//end if wotype=3
}//end of try
catch (Exception e)
{
	out.println("Exception DATE CODE:"+e.getMessage());
}	
 
java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.0000"); // 取小數後四位, 作為計算餘數的基準
java.math.BigDecimal bd = null;  
java.math.BigDecimal strRunCardRQty = null;
java.math.BigDecimal strRemainderQty = null;
try
{
	//計算流程卡張數及單張數量
    singleLotQtyD=Double.parseDouble(singleLotQty);
	runCardCountD=Math.IEEEremainder(Double.parseDouble(woQty),singleLotQtyD); //計算單批計算後餘數
	
	try
	{			         
		bd = new java.math.BigDecimal(runCardCountD);
		strRunCardRQty = bd.setScale(4, java.math.BigDecimal.ROUND_HALF_UP);
		runCardCountD = Math.abs(strRunCardRQty.doubleValue());				    
	} //end of try
    catch (NumberFormatException e)
    {
    	System.out.println("Exception: Remainder Round to 4 digit "+e.getMessage());
    }

    if (runCardCountD==0)  //整除
	{ 
		//runCardCountI=Double.parseDouble(woQty)/Double.parseDouble(singleLotQty);    //流程卡張數
		//modify by Peggy 20130916
		runCardCountI=(Double.parseDouble(woQty)*1000)/(Double.parseDouble(singleLotQty)*1000);    //流程卡張數
	   
	   	runCardQty=singleLotQtyD; 
	   	dividedFlag="Y";                                                //單張流程卡數量
	   	runCardCount=(int)runCardCountI; // 若整除,則轉型給開立流程卡張數
	}
	else    //無法整除有餘數
	{  //out.print("runcardcout <> 0");        
		//runCardCount=(int)(Double.parseDouble(woQty)/Double.parseDouble(singleLotQty));
		//modify by Peggy 20130916
		runCardCount=(int)((Double.parseDouble(woQty)*1000)/(Double.parseDouble(singleLotQty)*1000));
	   
	   	double compRoundCardQty = runCardCount * singleLotQtyD;                      // 整除的全部數量
	   	double remainderQty =  Double.parseDouble(woQty) - compRoundCardQty; 
	   	runCardQty=singleLotQtyD;                                                    //單張流程卡數量
		
		try
		{	// 再取四捨五入至4位		         
			bd = new java.math.BigDecimal(remainderQty);
			strRemainderQty = bd.setScale(4, java.math.BigDecimal.ROUND_HALF_UP);
			remainderQty = Math.abs(strRemainderQty.doubleValue());				    
		} //end of try
        catch (NumberFormatException e)
        {
       		System.out.println("Exception: Remainder Round to 4 digit "+e.getMessage());
        }
		runCardCountD=remainderQty;  // 剩餘的流程卡數量
	   	//out.println(" remainderQty="+remainderQty);                                                  
	   	dividedFlag="N";
	}	  
} //end of try
catch (Exception e)
{
	out.println("Exception 計算流程卡張數及單張數量:"+e.getMessage());
}	  

if (jobType==null || jobType.equals("1"))
{
	try
	{    
    	if (routingId !=null && !routingId.equals("0"))
	    { //out.println("routingId UPDATE="+routingId);
		  
	    	String sql = "update APPS.YEW_WORKORDER_ALL set ROUTING_REFERENCE_ID=? "+
		               " where WO_NO='"+woNo+"' ";
		  	//out.println("sql="+sql);
	      	PreparedStatement pstmt=con.prepareStatement(sql);  
          	pstmt.setString(1,routingId);     // 本次Routing更新	 
		  	pstmt.executeUpdate(); 
          	pstmt.close();
        } 
		else if (routingRefID !=null && !routingRefID.equals("0"))
		{
			String sql = "update APPS.YEW_WORKORDER_ALL set ROUTING_REFERENCE_ID=? "+
		               " where WO_NO='"+woNo+"' ";
		           out.println("sql="+sql);
	        PreparedStatement pstmt=con.prepareStatement(sql);  
            pstmt.setString(1,routingRefID);     // 後來選擇的Routing更新	 
		    pstmt.executeUpdate(); 
            pstmt.close();
		}
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception 00:"+e.getMessage());
	}
} 
else if (jobType.equals("2"))
{
		     // 重工工令
}

if (singleControl=="Y" || singleControl.equals("Y")) 
{
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">             
  <tr bgcolor="#CCCC99"> 
      <td width="15%" nowrap>單批作業量: 
        <INPUT TYPE="TEXT" NAME="SINGLELOTQTY" SIZE=5 maxlength="5" value="<%=singleLotQtyD%>">&nbsp;&nbsp;<%=woUom%>
		<INPUT TYPE="button" NAME="SINGLELOTSET"  value="Update" onClick="setQty('../jsp/TSCMfgWoExpand.jsp?WO_NO=<%=woNo%>',this.form.SINGLELOTQTY.value)">     </td>
<%  
	//if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5"))  //20130905 ADD TYPE=5 for sampletype dc
	if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5") || woType=="7" || woType.equals("7") )  //20140827 ADD TYPE=7 for ENG type dc	
    {
%>	 
      <td width="5%" nowrap>DateCode: 
        <INPUT TYPE="TEXT" NAME="DATECODE" SIZE="6" maxlength="6" value="<%=dateCode%>" onChange="setDCYYWW()"><input type="hidden" name="ORIG_DC" value="<%=dateCode%>">&nbsp;
        DC YYWW:
        <input type="TEXT" name="DC_YYWW" size="4" maxlength="4" value="<%=dc_yyww%>" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">
        &nbsp;
        <input type="button" name="DATECODESET2"  value="Update" onClick="setDateCode('../jsp/TSCMfgWoExpand.jsp?WO_NO=<%=woNo%>',this.form.DATECODE.value)"></td>
<%   
	} 
%>	 
	 <td nowrap>&nbsp;&nbsp;<font color="#000099">預計展開流程卡張數:</font>
<% 
	if (runCardCountD==0)
	{
		out.println("<font color='#FF0000'><strong>"+runCardCount+"&nbsp;</strong></font><font color=#000099>張</font>(整除每張數量:<font color='FF9900'><strong>"+runCardQty+"</strong></font>)"); 
	} 
	else 
	{	
		if (singleLotQtyD<Double.parseDouble(woQty))
		{	   
			out.println("<font color='#FF0000'><strong>"+Integer.toString(runCardCount+1)+"&nbsp;</strong></font><font color=#000099>張</font></font>(整除每批數量:<font color='FF9900'><strong>"+runCardQty+"</strong></font>&nbsp;尾批餘數:<font color='FF9900'><strong>"+runCardCountD+"</strong></font>)"); 
		} 
		else 
		{ // else if (Double.parseDouble(woQty)<singleLotQtyD)
			out.println("<font color='#FF0000'><strong>"+Integer.toString(runCardCount+1)+"&nbsp;</strong></font><font color=#000099>張</font></font>(流程卡數量:<font color='FF9900'><strong>"+woQty+"</strong></font>)"); 
		}
	}
%>
	    <INPUT type="hidden" SIZE=5 name="RUNCARDCOUNTI" value="<%=runCardCount%>" readonly></td>
  </tr>         
</table>
<%  
} 
else
{ 
	if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5"))	  
    {
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">             
  <tr bgcolor="#CCCC99"> 
      <td width="5%" nowrap>DateCode: 
        <INPUT TYPE="TEXT" NAME="DATECODE" SIZE=5 maxlength="5" value="<%=dateCode%>" onChange="setDCYYWW()"><input type="hidden" name="ORIG_DC" value="<%=dateCode%>">&nbsp;
        DC YYWW:<INPUT TYPE="TEXT" NAME="DC_YYWW" SIZE="4" maxlength="4" value="<%=dc_yyww%>" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">&nbsp;
		<INPUT TYPE="button" NAME="DATECODESET"  value="Update" onClick="setDateCode('../jsp/TSCMfgWoExpand.jsp?WO_NO=<%=woNo%>',this.form.DATECODE.value)">  
     </td>
  </tr>         
</table>
<%	
	}//end if wotype=3
}  // end if singleControl %>
<BR>
<table align="left"><tr><td colspan="3">
<%
if (routingId!=null && !routingId.equals("0") && jobType.equals("1"))
{ // 若無 Routing 設定予此工令,則無法顯示動作
 %>
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
 <%	
	try
    {  
		//out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
       	Statement statement=con.createStatement();
       	ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID not in ('005','029') and  x1.LOCALE='"+locale+"'"); //排除REJECT, PASS. update by SHIN 20090722
       	//comboBoxBean.setRs(rs);
	   	//comboBoxBean.setFieldName("ACTIONID");	   
       	//out.println(comboBoxBean.getRsString());
	   	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgWoExpand.jsp?WO_NO="+woNo+'"'+")'>");				  				  
	   	out.println("<OPTION VALUE=-->--");     
	   	while (rs.next())
	   	{            
			String s1=(String)rs.getString(1); 
			String s2=(String)rs.getString(2); 
        	if (s1.equals(actionID)) 
  			{
          		out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        	} 
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
	   	} //end of while
	   	out.println("</select>"); 
	   
	   
	   	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID not in ('005','029') and  x1.LOCALE='"+locale+"'"); //排除REJECT, PASS. update by SHIN 20090722
	   	rs.next();
	   	if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   	{
          //out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>"); // 2007/01/22 限制使用者不得 Submit 兩次展開流程卡
		  %>				  
                  <INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setSubmit("../jsp/TSCMfgWoExpandMProcess.jsp?WO_NO=<%=woNo%>","是否執行工令生成並展開流程卡?")'>
		  <%
			out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
	   	} 
       	rs.close();       
	   	statement.close();
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception 000:"+e.getMessage());
    }
} // End of if ((routingId!=null && routingId.equals("0")))
else if (jobType.equals("2")) // 若為重工工令
{
	%>
	<strong><font color="#FF0000">執行動作-&gt;</font></strong> 
    <a name='#ACTION'>
<%	
    try
    {  
		//out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
        Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID not in ('005','029') and  x1.LOCALE='"+locale+"'"); //排除REJECT, PASS. update by SHIN 20090807
        //comboBoxBean.setRs(rs);
	    //comboBoxBean.setFieldName("ACTIONID");	   
        //out.println(comboBoxBean.getRsString());
	    out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgWoExpand.jsp?WO_NO="+woNo+'"'+")'>");				  				  
	    out.println("<OPTION VALUE=-->--");     
	    while (rs.next())
	    {            
			String s1=(String)rs.getString(1); 
		    String s2=(String)rs.getString(2); 
            if (s1.equals(actionID)) 
  		    {
            	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
            }
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
	    } //end of while
	    out.println("</select>"); 
	   
	    rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID not in ('005','029') and  x1.LOCALE='"+locale+"'"); //排除REJECT, PASS. update by SHIN 20090722
	    rs.next();
	    if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	    {
		   // out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>"); // 2007/01/22 限制使用者不得 Submit 兩次展開流程卡
		  %>				  
		  <INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setSubmit("../jsp/TSCMfgWoExpandMProcess.jsp?WO_NO=<%=woNo%>","是否執行工令生成並展開流程卡?")'>
		  <%
		  out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
	   	} 
        rs.close();       
	    statement.close();
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception 9:"+e.getMessage());
	}   
}  // Endo of else if ()
// 若為管理員,可設定此項目作為僅生成Oracle工令,不展流程卡(因應MassLoad Fail 但已展流成卡並生產)_20070127_起	
if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) // 若是管理員模式或WIP管理員,可設定手動給定報廢數量
{ 
	out.println("<INPUT TYPE='checkBox' NAME='ADMINMODEOPTION' VALUE='YES'>");%>管理員模式1(僅生成工令不再展卡)<%
}
// 若為管理員,可設定此項目作為僅生成Oracle工令,不展流程卡(因應MassLoad Fail 但已展流成卡並生產)_20070127_起

// 若為管理員,可設定此項目作為僅展開流程卡,不生成Oracle工令(因應已生成Oracle工令,但流程卡展開異常)_20070326_起	
if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) // 若是管理員模式,可設定手動給定報廢數量
{ 
	out.println("<INPUT TYPE='checkBox' NAME='ADMINMODEOPTION2' VALUE='YES'>");%>管理員模式2(僅展流程卡不生成工令)<%
}
    // 若為管理員,可設定此項目作為僅展開流程卡,不生成Oracle工令(因應已生成Oracle工令,但流程卡展開異常)_20070326_起	

		
  %></a></td></tr></table>
<!-- 表單參數 --> 
 <INPUT type="hidden" name="RUNCARDCOUNTD" value="<%=runCardCountD%>" > 
 <INPUT type="hidden" NAME="RUNCARDQTY" value="<%=runCardQty%>">
 <INPUT type="hidden" NAME="DIVIDEDFLAG" value="<%=dividedFlag%>"> 
 <INPUT type="hidden" NAME="RUNCARDPREFIX" value="<%=runCardPrefix%>"> 
 <INPUT type="hidden" NAME="RUNCARD_NO" value="<%=runCardNo%>"> 
 <INPUT type="hidden" NAME="SINGLECONTROL" value="<%=singleControl%>"> 
 <INPUT type="hidden" NAME="RECOUNTFLAG" value="<%=reCountFlag%>"> 
 <INPUT type="hidden" NAME="DATECODEFLAG" value="<%=dateCodeFlag%>">  
 <INPUT type="hidden" SIZE="5" name="WOTYPE" value="<%=woType%>">
 <INPUT type="hidden" SIZE="5" name="ALTERNATEROUTING" value="<%=alternateRouting%>">
 <INPUT type="hidden" SIZE="5" name="ORGANIZATIONID" value="<%=organizationID%>">
 <INPUT type="hidden" SIZE="1" name="CUSTLOT" value="<%=custLot%>">
 <INPUT type="hidden" SIZE="1" name="CUSTLOT_PREFIX" value="<%=custLotPrefix%>">
 <input type="hidden" SIZE="8" name="CREATEDATE" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
<!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
