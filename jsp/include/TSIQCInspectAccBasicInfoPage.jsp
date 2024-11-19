<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<title></title>
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
<script language="JavaScript" type="text/JavaScript">
function historyByDOCNO(pp)
{   
  subWin=window.open("TSIQCInspectLotHistoryDetail.jsp?INSPLOTNO="+pp,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function historyByCust(pp,qq,rr)
{   
  subWin=window.open("TSSDRQInformationQuery.jsp?CUSTOMERNO="+pp+"&CUSTOMERNAME="+qq+"&DATESETBEGIN=20000101"+"&DATESETEND=20991231"+"&CUSTOMERID="+rr,"subwin");  
}
function resultOfDOAP(repno,svrtypeno)
{   
  subWin=window.open("../jsp/subwindow/DOAPResultQuerySubWindow.jsp?REPNO="+repno+"&SVRTYPENO="+svrtypeno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function IQCInspectDetailHistQuery(inspLotNo,lineNo,interfaceID)
{     
    subWin=window.open("../jsp/TSIQCInspectLotHistory.jsp?INSPLOTNO="+inspLotNo+"&LINE_NO="+lineNo+"&ID="+interfaceID,"subwin","width=800,height=480,scrollbars=yes,menubar=no");    	
}
function ExpandBasicInfoDisplay(expand)
{       
 //alert("URL="+location.href);
 //alert("length="+location.href.indexOf("EXPAND")); 
 var subURL = location.href.substring(0,location.href.indexOf("EXPAND")-1); 
 //alert("subURL="+subURL);
 var URL = location.href;
 if (location.href.indexOf("EXPAND")<0)
 {
          if (expand=="OPEN")
		  { 
		    document.DISPLAYREPAIR.action=URL;  
		  } else { 
                  document.DISPLAYREPAIR.action=URL+"&EXPAND="+expand;
				 }
 } else {
          if (expand=="OPEN")
		  { 
		    document.DISPLAYREPAIR.action=subURL; 
		  }
		  else
		  {
		   document.DISPLAYREPAIR.action=subURL+"&EXPAND="+expand;
		  }
        }
 //alert("LAST URL="+location.href);
 window.document.DISPLAYREPAIR.submit();
}
function popMenuMsg(itemDesc)
{
 alert("台半料號:"+itemDesc);
}
</script>
<%
String expand=request.getParameter("EXPAND");
String lineStatusID=request.getParameter("LSTATUSID"); // ??????? HeadQueryAllStatus????

String supplierID="",supplierNo="",supplierName="",supSiteID="",supSiteNo="",supSiteName="",inspDeptID="",inspector="",inspectDate="",poNumber="",frStatID="",packMethod="",waferAmp="",prodName="",totYield="";
String prodModel="",sampleQty="",wfTypeID="",wfSizeID="",diceSize="",wfThick="",wfResist="",waiveLot="", wfPlatID="", statusid="",status="",creationDate="",creationTime="",createdBy="",createdName="",lastUpdateDate="",lastUpdateTime="",lastUpdateBy="",lastUserName="";
String interfaceTransID=""; // 
String classID="",classCode="",className="",qcDeptName="",qcDeptDesc="",qcUserID="",qcUserName="",qcUserEmpID="";
String organizationID="",preRepMethodName="",actRepMethod="",actRepMethodName="",actRepDesc="",isTransmitted="";
String iMatCode="",iMatName=""; // 間街原物料種類及名稱
String resultName="",resultID="",inspRemark=null;

String isQuoted="N"; //?O§_|33o?u﹐eRA
//String repairingCost="",itemCost="",transCost="",otherCost="";//3o?uAEAU?A
String agentName="",agentNo="",recType="",recTypeName="",qty="";
String Limited=""; //?OcT’A--
String hStatusID ="",hStatus="";

String poUnitPrice = "",currCode="",whsUserChName = "", poUOM="", qcUserChName="",rcvTransDate="", marketType="",poLineId="",taxCode="",termCode="";

if (expand==null) expand = "OPEN";

//String dateCurrent = dateBean.getYearMonthDay();

//out.println("1");

      try
      {      	
	   Statement docstatement=con.createStatement();
	   //out.println("select * from ORADDMAN.TSDELIVERY_NOTICE WHERE DNDOCNO='"+dnDocNo+"'");
       //out.println("UserRoles="+UserRoles);
	   String sqlDocs = "";
	   if (UserRoles.indexOf("admin")>=0) // 管理員,所有單據皆可檢視
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+	
				 " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+	
				 " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+		 
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' ";		 
	   }
	   else if ( UserRoles.indexOf("YEW_AVP")>=0 || UserRoles.indexOf("PUR_ALL_MGR")>=0) // 陽信廠採購不分類或廠主管,所有單據皆可檢視
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+
				 " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' ";		 
	   }
	   else if (UserRoles.equals("PUR_MGR") ) // 陽信廠採購或廠主管,檢視所有非'04'外購類
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+
				 " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' and a.IQC_CLASS_CODE !='04' ";		 
	   }
	   else if (UserRoles.equals("PUR_OUT_MGR")) // 陽信廠外購採購主管,檢視'04'外購類
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+
				 " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' and a.IQC_CLASS_CODE ='04' ";		 
	   }
	   else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0) // 只有自己單位開的單據能看單據內容
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+
				 " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' and ( b.INSPECT_DEPT = '"+userInspDeptID+"' ) "; 
	   }
	   else if (UserRoles.indexOf("YEW_IQC_MC")>=0) //物管 
	   {  
	      sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+
				 " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
			     "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' "; 
	   } else if (UserRoles.indexOf("YEW_STOCKER")>=0)
	          {
			      sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	                      "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				          "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				          "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
						  " b.INTERFACE_TRANSACTION_ID, b.UOM, TO_CHAR(to_date(b.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECTDATE, "+
						  " decode(b.ORGANIZATION_ID,'326','國內採購','327','國外採購',b.ORGANIZATION_ID) as MARKET, b.PO_LINE_ID, b.PO_NO "+
				          "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				          "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' "; 
			  }
       //out.println("2");				  
       if (line_No!=null && !line_No.equals("")) { sqlDocs = sqlDocs+"and to_char(b.LINE_NO) ='"+line_No+"' "; } // ????Line_No???
	   if (lineStatusID!=null && !lineStatusID.equals("")) {  sqlDocs = sqlDocs+"and b.LSTATUSID ='"+lineStatusID+"' "; }
	   //out.println("<BR>"+sqlDocs);
       ResultSet docrs=docstatement.executeQuery(sqlDocs);
       if( docrs.next())
       {
	   inspLotNo=docrs.getString("INSPLOT_NO");
	   supplierID=docrs.getString("SUPPLIER_ID");
	   supplierName=docrs.getString("SUPPLIER_NAME");
	   supSiteID=docrs.getString("SUPPLIER_SITE_ID");
	   supSiteName=docrs.getString("SUPPLIER_SITE_NAME");
	   classID=docrs.getString("IQC_CLASS_CODE");
	   inspDeptID=docrs.getString("INSPECT_DEPT");
	   inspector=docrs.getString("INSPECTOR");
	   //marketType=docrs.getString("ORGAINZATION_ID");
	   poNumber=docrs.getString("PO_NO");
	   packMethod=docrs.getString("PACK_METHOD");
	   waferAmp=docrs.getString("WAFER_AMP");
	   totYield=docrs.getString("TOTAL_YIELD");
	   prodName=docrs.getString("PROD_NAME");          
	   prodModel=docrs.getString("PROD_MODEL");        
	   sampleQty=docrs.getString("SAMPLE_QTY");        
	   wfTypeID=docrs.getString("WAFER_TYPE");         
	   wfSizeID=docrs.getString("WAFER_SIZE");         
	   diceSize=docrs.getString("DICE_SIZE");          
	   wfThick=docrs.getString("WF_THICK");            
	   wfResist=docrs.getString("WF_RESIST");          
	   waiveLot=docrs.getString("WAIVE_LOT");          
	   wfPlatID=docrs.getString("PLAT_LAYER");         
	   inspRemark =docrs.getString("INSPECT_REMARK");	   
	   statusid=docrs.getString("LSTATUSID");
	   status=docrs.getString("LSTATUS");
	   hStatusID=docrs.getString("STATUSID");          
	   hStatus=docrs.getString("STATUS");
	   creationDate=docrs.getString("CREATEDATE");
	   creationTime=docrs.getString("CREATETIME");     
	   createdBy=docrs.getString("CREATED_BY");
	   lastUpdateDate=docrs.getString("LUPDATE");
	   lastUpdateTime=docrs.getString("LUPTIME");	   
	   lastUpdateBy=docrs.getString("LAST_UPDATED_BY");	
	   organizationID=docrs.getString("ORGANIZATION_ID");	   
	   iMatCode=docrs.getString("IMATCODE");	     
	   resultName=docrs.getString("RESULT"); 
	   poUOM=docrs.getString("UOM");  
	   interfaceTransID=docrs.getString("INTERFACE_TRANSACTION_ID"); 
	   inspectDate=docrs.getString("INSPECTDATE");   
	   marketType=docrs.getString("MARKET");  
	   poLineId=docrs.getString("PO_LINE_ID"); 
	   frStatID=statusid; 	   
	   }
	   // 找PO基本付款相關資訊_起
	    if (poNumber!=null)
		{
           Statement statePoInfo=con.createStatement();		    
		   ResultSet poInfoRS=statePoInfo.executeQuery("select b.NAME, c.NAME "+
		                                     "from PO_HEADERS_ALL a, AP_TAX_CODES_ALL b, AP_TERMS_TL c, PO_LINE_LOCATIONS_ALL d, PO_LINES_ALL e "+
		                                     " WHERE a.SEGMENT1="+docrs.getString("PO_NO")+" and e.PO_LINE_ID = "+docrs.getString("PO_LINE_ID")+
											 "   and a.PO_HEADER_ID = e.PO_HEADER_ID and a.PO_HEADER_ID = d.PO_HEADER_ID "+
										     "   and e.PO_LINE_ID = d.PO_LINE_ID and d.TAX_CODE_ID = b.TAX_ID and a.TERMS_ID = c.TERM_ID and c.LANGUAGE='US' ");
		                      //  out.println("select b.NAME, c.NAME "+
		                      //              "from PO_HEADERS_ALL a, AP_TAX_CODES_ALL b, AP_TERMS_TL c, PO_LINE_LOCATIONS_ALL d, PO_LINES_ALL e "+
		                      //              " WHERE a.SEGMENT1="+docrs.getString("PO_NUMBER")+" and e.PO_LINE_ID = '"+docrs.getString("PO_LINE_ID")+"' and a.PO_HEADER_ID = e.PO_HEADER_ID and a.PO_HEADER_ID = d.PO_HEADER_ID "+
							  // 		        "   and e.PO_LINE_ID = d.PO_LINE_ID and d.TAX_CODE_ID = b.TAX_ID and a.TERMS_ID = c.TERM_ID and c.LANGUAGE='US'  ");								   
           if (poInfoRS.next())
		   {             
	        taxCode=poInfoRS.getString(1);
			termCode=poInfoRS.getString(2);
		   }
	       poInfoRS.close();
		   statePoInfo.close();
		 } // 	   
	   // 找PO基本付款相關資訊_迄
	   
       docrs.close();  
	   
//out.println("interfaceTransID="+interfaceTransID);
	  
	   if (classID!=null)
	   {
	     docrs=docstatement.executeQuery("select * from ORADDMAN.TSCIQC_CLASS where CLASS_ID='"+classID+"' ");
         if (docrs.next())      
		 {        
		  classCode=docrs.getString("CLASS_CODE");
		  className=docrs.getString("CLASS_NAME");	      
		 } else { classCode=classID; }
	     docrs.close();
	   }
	  // out.println("classCode="+classCode);
	   if (iMatCode!=null)
	   { 
	     docrs=docstatement.executeQuery("select IMAT_CODE||'('||IMAT_NAME||')' from ORADDMAN.TSCIQC_IMATCODE WHERE IMAT_CODE='"+iMatCode+"' ");
         if (docrs.next())
		 {                
	      iMatName=docrs.getString(1);
		 }
	     docrs.close();
	   } 
	  // out.println("iMatName="+iMatName);
	   if (resultName!=null && !resultName.equals("N/A"))
	   { 
	     docrs=docstatement.executeQuery("select RESULT_ID from ORADDMAN.TSCIQC_RESULT  where RESULT_NAME='"+resultName+"' ");
         if (docrs.next())
		 {                
	      resultID=docrs.getString("RESULT_ID");
		 }
	     docrs.close();
	   }		           
	   
	   if (supplierID!=null)
	   { //out.println("select SEGMENT1 from APPS.PO_VENDORS WHERE VENDOR_ID="+supplierID+" ");
	   	// 20110829 for R12 issue
	    // docrs=docstatement.executeQuery("select SEGMENT1 from PO.PO_VENDORS WHERE VENDOR_ID="+supplierID+" ");
	     docrs=docstatement.executeQuery("select SEGMENT1 from APPS.PO_VENDORS WHERE VENDOR_ID="+supplierID+" ");		 
         if (docrs.next())
		 {             
	      supplierNo=docrs.getString("SEGMENT1");
		 }
	     docrs.close();
	   } 	  
//out.println("4");
 
	  
  // out.println("4");
   
	     if (inspector!=null)
	     {
		  /* docrs=docstatement.executeQuery("select a.QCUSER_ID, a.QCUSER_EMPID, a.EMPLOYEE_ID, b.FULL_NAME "+
		                                   "  from ORADDMAN.TSCIQC_INSPECT_USER a, PER_PEOPLE_F b "+
		                                   " where a.QCUSER_NAME='"+inspector+"' and a.EMPLOYEE_ID = b.PERSON_ID "+
										   "   and to_char(b.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                       "   and to_char(b.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') "); */
           //20070918 liling update由誰驗收,則驗收單顯示正確檢驗人名
           String iqcUser=" SELECT PAP.FULL_NAME  ,fu.user_id QCUSER_ID ,fu.employee_id QCUSER_EMPID "+
		                                   "    FROM PER_ALL_PEOPLE_F PAP, fnd_user fu "+
		                                   " where fu.user_name=upper('"+inspector+"') and PAP.person_id = fu.employee_id "+
										   "   and to_char(PAP.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                       "   and to_char(PAP.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') ";
		   docrs=docstatement.executeQuery(iqcUser);

           if (docrs.next())
		   {
	         qcUserID=docrs.getString("QCUSER_ID");
			 qcUserEmpID=docrs.getString("QCUSER_ID");
			 qcUserChName = docrs.getString("FULL_NAME");
		   }
	       docrs.close();
	     }    
 // out.println("5");
	 
		if (lastUpdateBy!=null)
	    { 		 			 			                         	  

	     docrs=docstatement.executeQuery("select * from ORADDMAN.WSUSER where WEBID='"+lastUpdateBy+"' and LOCKFLAG='N' ");
         if (docrs.next())      
		 {        
		  lastUserName=docrs.getString("USERNAME");	      
		 } else { lastUserName=lastUpdateBy;	 }
	     docrs.close();
	    }
		
		if (createdBy!=null)
	    {
	     docrs=docstatement.executeQuery("select * from ORADDMAN.WSUSER where WEBID='"+createdBy+"' and LOCKFLAG='N' ");
         if (docrs.next())      
		 {        
		  createdName=docrs.getString("USERNAME");	      
		 } else { createdName=createdBy;	 }
	     docrs.close();
	    }
		 
	 
		 docstatement.close();
         docrs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception aa:"+e.getMessage());
       }
%>
<style type="text/css">
<!--
.style1 {
	color: #CC3300;
	font-weight: bold;
	font-family: "Courier New";
}
.style2 {
	color: #CC0033;
	font-size: small;
}
.style3 {font-size: 16px}
.style5 {
	color: #CC3300;
	font-weight: bold;
	font-family: "標楷體";
	font-size: x-large;
}
.style6 {
	color: #993300;
	font-size: large;
}
-->
</style>
<body>
<span class="style1"><font size="5"></font></span> &nbsp;&nbsp;<strong><span class="style2">單據狀態:</span></strong><font color="#CC0033"><strong>&nbsp;<%=status%></strong></font><BR>
  &nbsp;&nbsp;&nbsp;<font color="#8000FF"></font> 
  <%
     Statement seqStat=con.createStatement();
     ResultSet seqRs=seqStat.executeQuery("select COUNT (*) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO ='"+inspLotNo+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
&nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'></font>
 <%  }    

	 seqRs=seqStat.executeQuery("select COUNT (*) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO ='"+inspLotNo+"' and IQC_CLASS_CODE='"+classID+"'");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
&nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'></font>
<%   }	     
	 //} //END OF DAO/DAP§Pcwμ2aGif
	 
	 seqStat.close();
     seqRs.close();
%> 
<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
</div>
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="0">
  <tr><td colspan="3"><div align="center"><span class="style5">陽信長威電子有限公司</span></div></td></tr>
  <tr><td width="23%"><div align="center"><font color="#996633"><%=marketType%></font></div></td><td width="51%">&nbsp;</td>
  <td width="26%"><font color="#996633">接收日期 : <%=rcvTransDate%></font></td></tr>
  <tr><td width="23%"><div align="center"><font color="#996633">廠商 : <%=supplierName%></font></div></td><td><div align="center" class="style6">驗收單</div></td>
  <td width="26%"><font color="#996633">檢驗日期 : <%=inspectDate%></font></td></tr>
  <tr><td width="23%"><div align="center"><font color="#996633">異動原因 : 採購驗收</font></div></td><td><div align="center" class="style1 style3">&nbsp;</div></td><td width="26%"><font color="#996633">檢驗單號 : <%=inspLotNo%></font></td>
  </tr>
</table>

<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr> 
    <td colspan="4"><font color="#990000"> 	
    <%
	  int rowCnt = 0;
	  double lineAmount=0;
	  String lineAmountStr="";
	  double totAmount = 0;
	  String totAmountStr = "";
	  double grantTotal=0;
	  String grantTotalStr = "";
	  try
      {   
	   out.println("<TABLE cellSpacing='0' bordercolordark='#996666'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>");
	   out.println("<tr bgcolor='#BDA279'><td nowrap><font color='WHITE'>&nbsp;</font></td><td nowrap><font color='WHITE'>");	   
	   %>
	   項次
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   料號
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   品 名/規 格
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   採購單號
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   單位
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   接收數量
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   驗收數量
	   <% 
	   //加入採購單幣別欄位BY SHIN20090603
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   幣別
	   <% 
	   //---------------------------------
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   單價
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   小計
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>	 
	   組織倉庫  
	   <% 
       out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>	 
	   狀態  
	   <% 	   
	   out.println("</font></td></TR>");    
	   String jamString="";
	 
       Statement statement=con.createStatement();
       String sqlDTL = "";
	   if (UserRoles.indexOf("admin")>=0) // ???,????????
       { sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID,EMPLOYEE_ID ,LSTATUSID ,LSTATUS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; }
       else if ((statusid.equals("020") || statusid.equals("021")) && UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0) // ????????Assigning?RESPONDING
       {  // out.print("<br>IQC="+UserRoles);
	     sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID,EMPLOYEE_ID ,LSTATUSID ,LSTATUSfrom ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and ( INSPECT_DEPT = '"+userInspDeptID+"' ) order by LINE_NO"; 
	   }
	   else if ( UserRoles.indexOf("YEW_AVP")>=0 || UserRoles.indexOf("PUR_ALL_MGR")>=0) // 陽信廠採購或廠主管,所有單據皆可檢視
	   {   //out.print("<br>YEW_AVP="+UserRoles);
	      sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID,EMPLOYEE_ID ,LSTATUSID ,LSTATUS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO";
	   }
	   else if (UserRoles.indexOf("PUR_OUT_MGR")>=0) // 陽信廠採購看外購類
	   {  //out.print("<br>PUR_OUT_MGR"+UserRoles);
	      sqlDTL ="select b.PO_NO, b.PO_QTY, b.LINE_NO, b.RECEIPT_NO, b.INV_ITEM_ID, b.INV_ITEM, b.INV_ITEM_DESC, b.RECEIPT_QTY, b.UOM, b.AUTHOR_NO, b.SUPPLIER_LOT_NO, b.INSPECT_REQUIRE, to_char(to_date(b.RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, b.WAIVE_ITEM, b.ORGANIZATION_ID, b.INTERFACE_TRANSACTION_ID,b.EMPLOYEE_ID ,LSTATUSID ,LSTATUS from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO=b.INSPLOT_NO and b.INSPLOT_NO='"+inspLotNo+"' and a.IQC_CLASS_CODE ='04' order by b.LINE_NO";
	   }
	   else if (UserRoles.indexOf("PUR_MGR")>=0 ) // 陽信廠採購主管,看非外購類
	   { // out.print("<br>PUR_MGR="+UserRoles);
	      sqlDTL ="select b.PO_NO, b.PO_QTY, b.LINE_NO, b.RECEIPT_NO, b.INV_ITEM_ID, b.INV_ITEM, b.INV_ITEM_DESC, b.RECEIPT_QTY, b.UOM, b.AUTHOR_NO, b.SUPPLIER_LOT_NO, b.INSPECT_REQUIRE, to_char(to_date(b.RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, b.WAIVE_ITEM, b.ORGANIZATION_ID, b.INTERFACE_TRANSACTION_ID,b.EMPLOYEE_ID ,LSTATUSID ,LSTATUS from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO=b.INSPLOT_NO and b.INSPLOT_NO='"+inspLotNo+"' and a.IQC_CLASS_CODE !='04' order by b.LINE_NO";
	   }
	   else if (UserRoles.indexOf("YEW_IQC_MC")>=0)
	        { // out.print("<br>2.UserRoles="+UserRoles);
			    sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID,EMPLOYEE_ID ,LSTATUSID ,LSTATUS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; 
			}
       else if (UserRoles.indexOf("YEW_STOCKER")>=0) { sqlDTL ="select PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID,b.EMPLOYEE_ID ,LSTATUSID ,LSTATUS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; }
       //out.print("<br>sqlDTL="+sqlDTL);
       ResultSet rs=statement.executeQuery(sqlDTL);	   
	   while (rs.next())
	   {	
	    String emplId="";
        emplId=rs.getString("EMPLOYEE_ID");              //2007/07/03  liling add ,fix rcv employee is null
        if (emplId==null || emplId.equals("")) emplId="7435";   //2007/07/03  liling add ,fix rcv employee is null ,default employee value //趙茹7435 update by shin 20100105
          
	   // 找PO基本付款相關資訊_起	
	   interfaceTransID = rs.getString("INTERFACE_TRANSACTION_ID");
	   if (interfaceTransID!=null)
	   { 
	     Statement statePOPrice=con.createStatement();
/*
	     ResultSet rsPOPrice=statePOPrice.executeQuery("select a.PO_UNIT_PRICE, a.CURRENCY_CODE, c.FULL_NAME, to_char(a.TRANSACTION_DATE,'YYYY/MM/DD HH24:MI:SS') as TRANSACTION_DATE "+
		                                               "  from RCV_TRANSACTIONS a, FND_USER b, PER_PEOPLE_F c "+		                                
		                                               " where a.INTERFACE_TRANSACTION_ID ='"+interfaceTransID+"' "+
										               "   and b.EMPLOYEE_ID=c.PERSON_ID AND a.CREATED_BY=b.USER_ID "+
										               "   and to_char(c.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                                   "   and to_char(c.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD')");        									 
*/
	     ResultSet rsPOPrice=statePOPrice.executeQuery("select a.PO_UNIT_PRICE, a.CURRENCY_CODE, c.FULL_NAME, to_char(a.TRANSACTION_DATE,'YYYY/MM/DD HH24:MI:SS') as TRANSACTION_DATE "+
		                                               "  from RCV_TRANSACTIONS a, PER_PEOPLE_F c "+		                                
		                                               " where a.INTERFACE_TRANSACTION_ID ='"+interfaceTransID+"' "+
										               "   and nvl(a.EMPLOYEE_ID,"+emplId+")=c.PERSON_ID  "+
										               "   and to_char(c.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                                   "   and to_char(c.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD')");   

         if (rsPOPrice.next())      
		 {        
		  poUnitPrice=rsPOPrice.getString("PO_UNIT_PRICE");
	      currCode=rsPOPrice.getString("CURRENCY_CODE");
		  whsUserChName=rsPOPrice.getString("FULL_NAME");
		  rcvTransDate=rsPOPrice.getString("TRANSACTION_DATE");	  
		  
		    if (currCode=="CNY" || currCode.equals("CNY"))
		    {   
			   marketType = "國內採購"; 
			}
		    else {
		           marketType = "國外採購";
		         }
		 } 
	     rsPOPrice.close();	 
		 statePOPrice.close();   
	   } 	 // End of if (interfaceTransID!=null)  	   
	  // 找PO基本付款相關資訊_迄	
		
		java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.00"); // 取小數後兩位 
	   			
		lineAmount = rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice);
		lineAmountStr =  nf.format(lineAmount);		// 	
		
		//20120504 liling 增加顯示狀態__起
		String statusDesc="";
		
		if (rs.getString("LSTATUSID").equals("026") )   statusDesc ="待採購授權";
		if (rs.getString("LSTATUSID").equals("027") || rs.getString("LSTATUSID").equals("028"))   statusDesc ="待主管授權";  //028:特採
		if (rs.getString("LSTATUSID").equals("023") || rs.getString("LSTATUSID").equals("022") )   statusDesc ="已核准";  //022特採
		
		//20120504 liling 增加顯示狀態__END
				
		//out.println(assignFactory);
		//out.println("select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO='"+rs.getString("ASSIGN_MANUFACT")+"'");
	    out.print("<TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>");
		out.println("<TD><font color='#990000'>");			
		%>
		  <a href='javaScript:IQCInspectDetailHistQuery("<%=inspLotNo%>","<%=rs.getString("LINE_NO")%>","<%=rs.getString("INTERFACE_TRANSACTION_ID")%>")' onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("查詢項次處理歷程")'><img src='../image/point_arrow.gif' border='0'></a>
		<%
		out.println("</font></TD>");
		out.println("<TD><font color='#990000'>");
		//if (rs.getString("PO_QTY")=="Y" || rs.getString("SDRQ_EXCEED").equals("Y"))
		//{  out.println("<font color='RED'><strong>#</strong></font>"); }
		
		out.println(rs.getString("LINE_NO")+"</font></TD>");
		out.println("<TD><font color='#990000'>"+rs.getString("INV_ITEM")+"</font></TD>");
		out.print("<TD><font color='#990000'>"); // 料號的ToolTip_起
		out.print("<a href=javaScript:popMenuMsg('"+rs.getString("INV_ITEM_DESC")+"') onmouseover='this.T_WIDTH=150;this.T_OPACITY=150;return escape("+"\""+rs.getString("INV_ITEM")+"\""+")'>"); // 寬度,透明度 //
		out.print(rs.getString("INV_ITEM_DESC")); 
		out.println("</a>");	
		out.print("</font></TD>"); // 料號的ToolTip_迄
		out.print("<TD><font color='#990000'>"+rs.getString("PO_NO")+"</font></TD><TD><font color='#990000'>"+rs.getString("UOM")+"</font></TD><TD><font color='#990000'>"+rs.getString("RECEIPT_QTY")+"</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");	
		out.println(rs.getFloat("RECEIPT_QTY"));	// 
		out.println("</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");
		out.println(currCode);	 //加入採購單幣別欄位BY SHIN20090603
		out.println("</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");
		out.println(poUnitPrice);	// ???Line????
		out.println("</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");
		out.println(lineAmountStr);	// 項目小計
		out.println("</font></TD>");
		out.print("<TD><font color='#990000'>"+rs.getString("ORGANIZATION_ID")+"</font></TD>");	
		out.print("<TD><font color='#990000'>"+statusDesc+"</font></TD>");	 //20120504
		out.println("</TR>");	
		
		rowCnt = rs.getInt("LINE_NO"); // 計筆		
		totAmount = totAmount + rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice);
		totAmountStr = nf.format(totAmount);		
		 
		//out.println("Step0");  
		if (currCode.equals("CNY"))
		{
		  if (taxCode.equals("Vat 17%"))
		  {
		       //out.println("Step1");  
		       grantTotal = grantTotal + rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice)*(1.17);			   
			   grantTotalStr = nf.format(grantTotal);//out.println("Step1.2="+grantTotalStr); 		 
		  } else if (taxCode.equals("Vat 4%"))
		         {
				    grantTotal = grantTotal + rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice)*(1.04);			    
			        grantTotalStr = nf.format(grantTotal);//out.println("Step1.2="+grantTotalStr); 
				 } else if (taxCode.equals("Vat 6%"))
				        {
						   grantTotal = grantTotal + rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice)*(1.06);			    
			               grantTotalStr = nf.format(grantTotal);//out.println("Step1.2="+grantTotalStr);  
						} else if (taxCode.equals("Vat 7%"))
						       {
							       grantTotal = grantTotal + rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice)*(1.07);			    
			                       grantTotalStr = nf.format(grantTotal);//out.println("Step1.2="+grantTotalStr);
							   }
		} else {
		              grantTotal = grantTotal + rs.getDouble("RECEIPT_QTY")*Double.parseDouble(poUnitPrice);				  
				      grantTotalStr = nf.format(grantTotal);
				    /* 
			         java.math.BigDecimal bd = new java.math.BigDecimal(grantTotalStr);
		             java.math.BigDecimal grantTotAmt = bd.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
		             grantTotal =grantTotAmt.doubleValue();
				     out.println("Step3");
				    */
		       }
		   	
	   }  // End of While  	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();        
	  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception ab:"+e.getMessage());
       }
       %> 	 
	 </font>
	</td>      
  </tr>
  <tr> 
    <td colspan="3"><font color="#990000">
      計<%=rowCnt%>筆</font>
	</td>	   
	<td width="26%" colspan="1"><font color="#990000">
      小計: <strong><%=totAmountStr%></strong></font>
	</td> 
  </tr>
  <tr> 
    <td colspan="4"><font color="#990000">&nbsp;
      </font>
	</td>	
  </tr>		
  <tr> 
    <td width="29%" colspan="1"><font color="#990000">
      幣別 : <%=currCode%></font></td> 
	<td width="21%" colspan="1"><font color="#990000">
      合計 : <%=totAmountStr%></font></td>   
	<td width="24%" colspan="1"><font color="#990000">
      稅額 : <%=taxCode%></font></td> 
	<td colspan="1"><font color="#990000">
      總計 : <%=grantTotalStr%></font></td> 
  </tr>
  <tr> 
    <td colspan="1"><font color="#990000">
      發票號碼 : <%=%></font></td> 
	<td colspan="2"><font color="#990000">
      發票日期 : <%=%></font></td>   
	<td colspan="1"><font color="#990000">
      付款條件 : <%=termCode%></font></td>  
  </tr>	
</table>
  <table table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">  
  <tr> 
    <td width="5%" bgcolor='#BDA279'><font color="#FFFFFF">
      廠長:</font></td>
    <td width="11%" nowrap><font color="#990000">
	      <%
		     if (UserRoles.indexOf("YEW_AVP")>=0)
			 { // 取廠長登入使用者名
			    Statement stateAVP=con.createStatement();
                ResultSet rsAVP=stateAVP.executeQuery("select b.FULL_NAME "+
		                                            "  from ORADDMAN.WSUSER a, PER_PEOPLE_F b, FND_USER c "+
		                                            " where a.USERNAME='"+UserName+"' and c.EMPLOYEE_ID = b.PERSON_ID "+
													"   and a.USERNAME = c.USER_NAME "+
										            "   and to_char(b.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                                "   and to_char(b.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') ");	   			   
                if (rsAVP.next())
		        {	            
			      out.println(rsAVP.getString("FULL_NAME"));
		        }
	            rsAVP.close();
				stateAVP.close();			     
			 }
			 else { 
			        // 取廠長登入使用者名
			        Statement stateAVP=con.createStatement();
                    ResultSet rsAVP=stateAVP.executeQuery("select b.FULL_NAME "+
		                                            "  from ORADDMAN.WSUSER a, PER_PEOPLE_F b, FND_USER c, ORADDMAN.WSGROUPUSERROLE d "+
		                                            " where a.USERNAME = d.GROUPUSERNAME and d.ROLENAME = 'YEW_AVP' "+
													"   and c.EMPLOYEE_ID = b.PERSON_ID and a.USERNAME = c.USER_NAME "+
										            "   and to_char(b.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                                "   and to_char(b.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') ");	   			   
                    if (rsAVP.next())
		            {	            
			         out.println(rsAVP.getString("FULL_NAME"));
		            } else {
					        out.println("&nbsp;");	
					       }
	                 rsAVP.close();
				     stateAVP.close();	
			        }
		    // =createdBy+"("+createdName+")"
		  %></font>
	</td>
    <td width="7%" bgcolor='#BDA279'><font color="#FFFFFF">
      部門<BR>
    主管</font></td>
    <td width="12%" nowrap><font color="#990000">
	  <%out.println("&nbsp;");  
	  //if (prodFactory.equals("VALID"))
	  //{ 
	 %></font></td>
    <td width="6%" bgcolor='#BDA279'><font color="#FFFFFF">
      倉庫:</font></td>
    <td width="14%" nowrap><font color="#990000"><%=whsUserChName%></font></td>
	<td width="7%" bgcolor='#BDA279'><font color="#FFFFFF">
      驗收:</font></td>
    <td width="15%" nowrap><font color="#990000"><%=qcUserChName%></font></td>
	<td width="7%" bgcolor='#BDA279'><font color="#FFFFFF">
      採購:</font></td>
    <td width="16%" nowrap><font color="#990000">
	      <% 
		     if (UserRoles.indexOf("PUR_MGR")>=0 || UserRoles.indexOf("PUR_OUT_MGR")>=0 || UserRoles.indexOf("PUR_ALL_MGR")>=0)
			 { 
                 // 取採購核准人使用者名(即為登入人員)
			    Statement stateAVP=con.createStatement();
                ResultSet rsAVP=stateAVP.executeQuery("select b.FULL_NAME "+
		                                            "  from PER_PEOPLE_F b, FND_USER c "+
		                                            " where upper(c.USER_NAME)=upper('"+UserName+"') and c.EMPLOYEE_ID = b.PERSON_ID "+
										            "   and to_char(b.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                                "   and to_char(b.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') ");	   			   
                if (rsAVP.next())
		        {	            
			      out.println(rsAVP.getString("FULL_NAME"));
		        }   else {
				           out.println("&nbsp;");	
				         }
	            rsAVP.close();
				stateAVP.close();			     
			 }
			 else 
			    {
			      // 取前一簽核人員
			      Statement stateAVP=con.createStatement();
                  ResultSet rsAVP=stateAVP.executeQuery("select b.FULL_NAME "+
		                                                "  from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY a, PER_PEOPLE_F b, FND_USER c "+
		                                                " where a.ACTIONNAME ='AUTHORIZE' and a.INSPLOT_NO = '"+inspLotNo+"' "+
													    "   and a.UPDATEUSERID=c.USER_NAME and c.EMPLOYEE_ID = b.PERSON_ID "+
										                "   and to_char(b.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	                                                    "   and to_char(b.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') ");	 
				 // out.println("select b.FULL_NAME "+
		         //                                       "  from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY a, PER_PEOPLE_F b, FND_USER c "+
		         //                                       " where a.UPDATEUSERID='"+UserName+"' and a.ACTIONNAME ='AUTHORIZE' and a.INSPLOT_NO = '"+inspLotNo+"' "+
				//									    "   and c.EMPLOYEE_ID = b.PERSON_ID "+
				//						                "   and to_char(b.EFFECTIVE_START_DATE,'YYYY/MM/DD') <= to_char(SYSDATE,'YYYY/MM/DD') "+ 
	             //                                       "   and to_char(b.EFFECTIVE_END_DATE,'YYYY/MM/DD') >= to_char(SYSDATE,'YYYY/MM/DD') ");					  			   
                  if (rsAVP.next())
		          {	            
			        out.println(rsAVP.getString("FULL_NAME"));					
		          } else {
				           out.println("&nbsp;");	
				         }
	              rsAVP.close();
				  stateAVP.close();	
			 }		  
		  %></font></td>
  </tr>
  </table>
  <table table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">     
  <tr>
    <td width="16%"><font color="#0080C0">前次處理人員:</font></td>
    <td width="19%"><font color="#0080C0"><%=lastUpdateBy+"("+lastUserName+")"%></font></td>
    <td width="15%"><font color="#0080C0">前次處理日期:</font></td>
    <td width="17%"><font color="#0080C0"><%=lastUpdateDate%></font></td>
    <td width="13%"><font color="#0080C0">前次處理時間:</font></td>
    <td width="20%"><font color="#0080C0"><%=lastUpdateTime%></font></td>
  </tr>  
</table>   
<% //if (frStatID.equals("009"))  { %>
&nbsp;&nbsp;&nbsp;<font color="RED">標誌圖示<strong><img src="../image/point.gif"></strong>表示必選(填)欄位,請務必輸入</font>
<%      //  } %>
  <!--3o?u?O¥I°I-->
  <!-- ai3a°N?A -->  
    <input name="FORMID" type="HIDDEN" value="QC" > 	
	<input name="FROMSTATUSID" type="hidden" value="<%=frStatID%>" >   
	<input name="INSPLOTNO" type="hidden" value="<%=inspLotNo%>" >
	<input name="PREVIOUSPAGEADDRESS" type="HIDDEN" value=""> 
	<input name="PREORDERTYPE" type="HIDDEN" value="<%=%>"> 
	<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >   
  <!-- add 2006-09-17  -->
    <input name="ORGANIZATIONID" type="HIDDEN" value="<%=organizationID%>" > 
   <input nmae="EXPAND" type="hidden" value="<%=expand%>">
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>


