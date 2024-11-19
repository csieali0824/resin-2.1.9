<!-- 20150205 Peggy,晶片種類,晶片尺吋,鍍層加入inactive_date is null or inactive_date > trunc(sysdate)條件-->
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
 
String expand         = request.getParameter("EXPAND");
String lineStatusID   = request.getParameter("LSTATUSID"); // ??????? HeadQueryAllStatus????
String supplierID     = "",supplierNo="",supplierName="",supSiteID="",supSiteNo="",supSiteName="",inspDeptID="",inspector="",inspectDate="",poNumber="",frStatID="",packMethod="",waferAmp="",prodName="",totYield="";
String prodModel      = "",sampleQty="",wfTypeID="",wfSizeID="",diceSize="",wfThick="",wfResist="",waiveLot="", wfPlatID="", statusid="",status="",creationDate="",creationTime="",createdBy="",createdName="",lastUpdateDate="",lastUpdateTime="",lastUpdateBy="",lastUserName="";
String classID        = "",classCode="",className="",qcDeptName="",qcDeptDesc="",qcUserID="",qcUserName="",qcUserEmpID="";
String organizationID = "",preRepMethodName="",actRepMethod="",actRepMethodName="",actRepDesc="",isTransmitted="";
String iMatCode       = "",iMatName=""; // 間街原物料種類及名稱
String resultName     = "",resultID="",inspRemark=null;
String isQuoted       = "N"; //?O§_|33o?u﹐eRA
String agentName      = "",agentNo="",recType="",recTypeName="",qty="";
String Limited        = ""; //?OcT’A--
String hStatusID      = "",hStatus="";
String poLineLocationID = "";

if (expand==null) expand = "OPEN";

String poCURR = "";

//String dateCurrent = dateBean.getYearMonthDay();

//out.println("1");

      try
      {      	
	  
	   Statement docstatement=con.createStatement();
	   //out.println("select * from ORADDMAN.TSDELIVERY_NOTICE WHERE DNDOCNO='"+dnDocNo+"'");
	   String sqlDocs = "";
	   if (UserRoles.indexOf("admin")>=0) // 管理員,所有單據皆可檢視
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.PO_LINE_LOCATION_ID "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' ";		 
	   }
	   else if (UserRoles.indexOf("PUR_MGR")>=0 || UserRoles.indexOf("YEW_AVP")>=0) // 陽信廠採購或廠主管,所有單據皆可檢視
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.PO_LINE_LOCATION_ID "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' ";		 
	   }
	   else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0) // 只有自己單位開的單據能看單據內容
	   { 
	     sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.PO_LINE_LOCATION_ID "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				 "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' and  b.INSPECT_DEPT = '"+userInspDeptID+"' "; 
	   }
	   else if (UserRoles.indexOf("YEW_IQC_MC")>=0) //物管 
	   {  
	      sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
				 " b.PO_LINE_LOCATION_ID "+
				 "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
			     "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' "; 
	   } else if (UserRoles.indexOf("YEW_STOCKER")>=0)
	          {
			      sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	                      "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				          "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				          "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
						  " b.PO_LINE_LOCATION_ID "+
				          "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				          "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' "; 
			  }
			  else // 其它查詢一率可以看到單據內容
	          {
			      sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	                      "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				          "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				          "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME, "+
						  " b.PO_LINE_LOCATION_ID "+
				          "from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b "+
				          "WHERE a.INSPLOT_NO=b.INSPLOT_NO and a.INSPLOT_NO='"+inspLotNo+"' "; 
			  }
				  
       if (line_No!=null && !line_No.equals("")) { sqlDocs = sqlDocs+"and to_char(b.LINE_NO) ='"+line_No+"' "; } // ????Line_No???
	   if (lineStatusID!=null && !lineStatusID.equals("")) {  sqlDocs = sqlDocs+"and b.LSTATUSID ='"+lineStatusID+"' "; }
	   //out.println(sqlDocs);
       ResultSet docrs=docstatement.executeQuery(sqlDocs);
       docrs.next();
	   inspLotNo        = docrs.getString("INSPLOT_NO");
	   supplierID       = docrs.getString("SUPPLIER_ID");
	   supplierName     = docrs.getString("SUPPLIER_NAME");
	   supSiteID        = docrs.getString("SUPPLIER_SITE_ID");
	   supSiteName      = docrs.getString("SUPPLIER_SITE_NAME");
	   classID          = docrs.getString("IQC_CLASS_CODE");
	   inspDeptID       = docrs.getString("INSPECT_DEPT");
	   inspector        = docrs.getString("INSPECTOR");
	   inspectDate      = docrs.getString("INSPECT_DATE");
	   poNumber         = docrs.getString("PO_NUMBER");
	   packMethod       = docrs.getString("PACK_METHOD");
	   waferAmp         = docrs.getString("WAFER_AMP");
	   totYield         = docrs.getString("TOTAL_YIELD");
	   prodName         = docrs.getString("PROD_NAME");          
	   prodModel        = docrs.getString("PROD_MODEL");        
	   sampleQty        = docrs.getString("SAMPLE_QTY");        
	   wfTypeID         = docrs.getString("WAFER_TYPE");         
	   wfSizeID         = docrs.getString("WAFER_SIZE");         
	   diceSize         = docrs.getString("DICE_SIZE");          
	   wfThick          = docrs.getString("WF_THICK");            
	   wfResist         = docrs.getString("WF_RESIST");          
	   waiveLot         = docrs.getString("WAIVE_LOT");          
	   wfPlatID         = docrs.getString("PLAT_LAYER");         
	   inspRemark       = docrs.getString("INSPECT_REMARK");	   
	   statusid         = docrs.getString("LSTATUSID");
	   status           = docrs.getString("LSTATUS");
	   hStatusID        = docrs.getString("STATUSID");          
	   hStatus          = docrs.getString("STATUS");
	   creationDate     = docrs.getString("CREATEDATE");
	   creationTime     = docrs.getString("CREATETIME");     
	   createdBy        = docrs.getString("CREATED_BY");
	   lastUpdateDate   = docrs.getString("LUPDATE");
	   lastUpdateTime   = docrs.getString("LUPTIME");	   
	   lastUpdateBy     = docrs.getString("LAST_UPDATED_BY");	
	   organizationID   = docrs.getString("ORGANIZATION_ID");	   
	   iMatCode         = docrs.getString("IMATCODE");	     
	   resultName       = docrs.getString("RESULT");   
	   poLineLocationID = docrs.getString("PO_LINE_LOCATION_ID");  // Kerwin 2008/02/01
	   frStatID=statusid; 
       docrs.close();  

	         String sqlTxnId = " SELECT poh.currency_code FROM po_headers_all poh, po_line_locations_all poll "+
 							   "  WHERE poh.po_header_id = poll.po_header_id AND poll.line_location_id = "+poLineLocationID+" ";
			 Statement stateTxnId=con.createStatement();
    	     ResultSet rsTxnId=stateTxnId.executeQuery(sqlTxnId);
			 if (rsTxnId.next())
			 { poCURR = rsTxnId.getString(1);   } //幣別 			
			 rsTxnId.close();
			 stateTxnId.close();

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

	   if (iMatCode!=null)
	   { 
	     docrs=docstatement.executeQuery("select IMAT_CODE||'('||IMAT_NAME||')' from ORADDMAN.TSCIQC_IMATCODE WHERE IMAT_CODE='"+iMatCode+"' ");
         if (docrs.next())
		 {                
	      iMatName=docrs.getString(1);
		 }
	     docrs.close();
	   } 

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
	   
	   if (inspDeptID!=null)
	   { 		 			 			                         	  

	     docrs=docstatement.executeQuery("select * from ORADDMAN.TSCIQC_INSPECT_DEPT WHERE QCDEPT_ID='"+inspDeptID+"' ");
         if (docrs.next())      
		 {        
		  qcDeptName=docrs.getString("QCDEPT_NAME");
	      qcDeptDesc=docrs.getString("QCDEPT_DESC");
		 } 
	     docrs.close();
	    
	   } 	  	 
  
	     if (inspector!=null)
	     {
		   docrs=docstatement.executeQuery("select QCUSER_ID, QCUSER_EMPID from ORADDMAN.TSCIQC_INSPECT_USER "+
		                                   "where QCUSER_NAME='"+inspector+"' ");
           if (docrs.next())
		   {
	         qcUserID=docrs.getString("QCUSER_ID");
			 qcUserEmpID=docrs.getString("QCUSER_ID");
		   }
	       docrs.close();
	     }    
	 
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
        out.println("Exception:"+e.getMessage());
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
-->
</style>
<body>
<span class="style1"><font size="5">品管IQC檢驗批單據</font></span> 
&nbsp;&nbsp;<strong><span class="style2">單據狀態:</span></strong><font color="#CC0033"><strong>&nbsp;<%=status%></strong></font><BR>
  <strong><font size="2">檢驗批單號:<font color="#000066"><%=inspLotNo%></font></font></strong>&nbsp;&nbsp;&nbsp;<font color="#8000FF"></font> 
<%
     Statement seqStat=con.createStatement();
     ResultSet seqRs=seqStat.executeQuery("select COUNT (*) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO ='"+inspLotNo+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
      &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'><A HREF='javaScript:historyByDOCNO("<%=inspLotNo%>")'>檢驗批單據歷程查詢(依批單據號)</A></font>
 <%  }     
	 seqRs=seqStat.executeQuery("select COUNT (*) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO ='"+inspLotNo+"' and IQC_CLASS_CODE='"+classID+"'");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
       &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'><A HREF='javaScript:historyByCust("<%=userInspDeptID%>","<%=userInspDeptID%>","<%=classID%>")'>檢驗批單據歷程查詢(依檢驗類型)</A></font>
<%   }	     
 
	 seqStat.close();
     seqRs.close();
%> 
<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr> 
    <td>
      <font color="#990000">檢驗類別:</font>
	</td>
	<td width="26%">
	  <font color="#990000"><%=classCode%>(<%=className%>)</font>
	</td>
	<td><font color="#990000">供應商資訊: <BR>	
	<%
	   if (supplierID==null || supplierID.equals("")) out.println("N/A"); else out.println(supplierNo); 			  
	%>(<%=supplierID+"-"+supplierName%>)<BR>
	供應商出貨地資訊:<%=supSiteID%>(<%=supSiteName%>)</font></td>
    <td><font color="#990000">檢驗單位:<%=inspDeptID%>(<%=qcDeptName+"-"+qcDeptDesc%>)</font><BR>
	    <font color="#990000">檢驗人員:<%=qcUserID%>(<%=inspector%>)</font>
	<BR><font color="#990000">檢驗日期:<%=inspectDate.substring(0,4) %>/<%=inspectDate.substring(4,6)%>/<%=inspectDate.substring(6,8)%></font>
	</td>
  </tr>
  <tr> 
    <td width="9%"><font color="#990000">市場類型:</font></td>
    <td><font color="#990000">
	<%
	    Statement stateMarkType=con.createStatement();
        ResultSet rsMarkType=stateMarkType.executeQuery("select CODE_DESC from YEW_MFG_DEFDATA where ORGANIZATION_ID='"+organizationID+"' ");
	    if (rsMarkType.next())
	    {
	      out.println(rsMarkType.getString(1));  // 內銷/外銷
	    } else {
		        out.println("&nbsp;");
		       } 
	    rsMarkType.close();
	    stateMarkType.close();
	%>
	</font></td>
    <td width="39%"><font color="#990000">採購單號:</font><font color="#990000"><%=poNumber%></font></td>
    <td width="26%"><font color="#990000">包裝方式:<%=packMethod%></font></td>    
  </tr>
  <tr> 
    <td colspan="1"><font color="#990000">物料名稱:</font></td>
	<td><font color="#990000"><%=prodName%></font></td>
	<td width="39%"><font color="#990000">適用型號:<%=prodModel%></font></td>
    <td><font color="#990000">抽樣數:<%=sampleQty%></font></td>
  </tr>  
  <%
     if (classID=="01" || classID.equals("01"))
	 { // 晶片晶粒類才顯示資訊
  %>
  <tr>
    <td><font color="#990000">晶片種類</font></td>
	<td colspan="2"><font color="#990000">
	  <%
		     try
             {       
               Statement statement=con.createStatement();
               //ResultSet rs=statement.executeQuery("select WF_TYPE_ID as WFTYPEID,WF_TYPE_NAME from ORADDMAN.TSCIQC_WAFER_TYPE order by WF_TYPE_ID");
			   ResultSet rs=statement.executeQuery("select WF_TYPE_ID as WFTYPEID,WF_TYPE_NAME from ORADDMAN.TSCIQC_WAFER_TYPE  where (INACTIVE_DATE is null or INACTIVE_DATE > trunc(sysdate))  order by WF_TYPE_ID"); //modify by Peggy 20150205
               checkBoxBean.setRs(rs);
               if (wfTypeID != null)
   	           checkBoxBean.setChecked(wfTypeID);
	           checkBoxBean.setFieldName("WFTYPEID");	   
	           checkBoxBean.setColumn(10); //傳參數給bean以回傳checkBox的列數
               out.println(checkBoxBean.getRsString());
	           statement.close();
               rs.close();       
             } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());
             }
	  %></font>
	  <!--%
	     if (wfTypeID.equals("")) out.println("<font color='#FF0000' face='Arial' size='2'>"+"NO"+"</font>");
		 else out.println("<font color='#FF0000' face='Arial' size='2'>"+"YES"+"</font>");
	  %-->
	</td>
	<td colspan="1"><font color="#990000">晶粒尺寸:<%=diceSize%>mil</font></td>
  </tr>  
  <tr>
    <td nowrap="nowrap"><font color="#990000">晶片尺寸:</font></td>
	<td nowrap><font color="#990000">
	  <%
	         try
             {       
               Statement statement=con.createStatement();
               //ResultSet rs=statement.executeQuery("select WF_SIZE_ID as WFSIZEID,WFSIZE_REMARK from ORADDMAN.TSCIQC_WAFER_SIZE order by WF_SIZE_ID");
			   ResultSet rs=statement.executeQuery("select WF_SIZE_ID as WFSIZEID,WFSIZE_REMARK from ORADDMAN.TSCIQC_WAFER_SIZE where (INACTIVE_DATE is null or INACTIVE_DATE > trunc(sysdate)) order by WF_SIZE_ID"); //mofify by Peggy 20150205
               checkBoxBean.setRs(rs);
               if (wfSizeID != null)
   	           checkBoxBean.setChecked(wfSizeID);
	           checkBoxBean.setFieldName("WFSIZEID");	   
	           checkBoxBean.setColumn(4); //傳參數給bean以回傳checkBox的列數
               out.println(checkBoxBean.getRsString());
	           statement.close();
               rs.close();       
             } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());
             }
	   %></font>
	</td>
	<td colspan="1"><font color="#990000">晶片厚度:<%=wfThick%>μm</font></td>
	<td colspan="1"><font color="#990000">電阻系數:<%=wfResist%>Ω-cm</font></td>
  </tr> 
  <tr> 
    <td colspan="1"><font color="#990000">鍍層:</font></td>
	<td colspan="1"><font color="#990000">	   
	   <%
	         try
             {       
               Statement statement=con.createStatement();
               //ResultSet rs=statement.executeQuery("select WF_PLAT_ID as WFPLATID,WF_PLAT_CODE from ORADDMAN.TSCIQC_WAFER_PLAT order by WF_PLAT_ID");
				ResultSet rs=statement.executeQuery("select WF_PLAT_ID as WFPLATID,WF_PLAT_CODE from ORADDMAN.TSCIQC_WAFER_PLAT  where (INACTIVE_DATE is null or INACTIVE_DATE > trunc(sysdate)) order by WF_PLAT_ID"); //modify by Peggy 20150205
               checkBoxBean.setRs(rs);
               if (wfPlatID != null)
   	           checkBoxBean.setChecked(wfPlatID);
	           checkBoxBean.setFieldName("WFPLATID");	   
	           checkBoxBean.setColumn(3); //傳參數給bean以回傳checkBox的列數
               out.println(checkBoxBean.getRsString());
	           statement.close();
               rs.close();       
             } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());
             }
	   
	   %>
	   </font>
	</td> 
    <td><font color="#990000">型號良率:</font><font color="#990000"><%=totYield%> </font></td> 
	<td><font color="#990000">安培數:</font><font color="#990000"><%=waferAmp%> </font></td>  
  </tr>
 <%
    } // End of if (classID=="" || classID.equals("01"))
 %>
  <tr>
     <td><font color="#990000">原料種類:</font></td> 
	 <td><font color="#990000"></font><font color="#990000"><%=waiveLot%> </font></td> 
	 <td><font color="#990000">特採檢驗批:</font><font color="#990000"><%=waiveLot%> </font></td> 
	 <td><font color="#990000">&nbsp;</font></td> 
  </tr>
  <tr> 
    <td colspan="4"><font color="#990000">檢驗批明細: 
	  <%  
	   if (expand==null || expand.equals("OPEN") || expand.equals("null"))
	   {
	  %>
	    <a href='javaScript:ExpandBasicInfoDisplay("CLOSE")' onmouseover='this.T_WIDTH=150;this.T_OPACITY=80;return escape("點擊圖示收合項目明細")'><img src='../image/folder_lock.gif' style="vertical-align:middle " align="middle" border='0'></a>
	  <%
	   } else {	   
	  %>	
	    <a href='javaScript:ExpandBasicInfoDisplay("OPEN")' onmouseover='this.T_WIDTH=150;this.T_OPACITY=80;return escape("點擊圖示展開項目明細")'><img src='../image/folder_open.gif' style="vertical-align:middle " align="middle" border='0'></a>
	  <%
	          }
	 if (expand==null || expand.equals("OPEN") || expand.equals("null"))
	 {

	  try
      {   
	   out.println("<TABLE cellSpacing='0' bordercolordark='#996666'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>");
	   out.println("<tr bgcolor='#BDA279'><td nowrap><font color='WHITE'>&nbsp;</font></td><td nowrap><font color='WHITE'>");	   
	   %>
	   項次
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   採購單號
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   幣別
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   料號說明
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   收料數量
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   單位
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   零件承認編號
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   供應商(晶片)批號
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   檢驗要求
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   收料日期
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>	 
	   組織倉庫  
	   <% 
	   out.println("</font></td></TR>");    
	   String jamString="";
       Statement statement=con.createStatement();
       String sqlDTL = "";
	   if (UserRoles.indexOf("admin")>=0) // ???,????????
       {      sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID, (SELECT DISTINCT currency_code FROM po_headers_all WHERE PO_HEADER_ID = TLD.PO_HEADER_ID) currency  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; }  //加入採購單幣別欄位BY SHIN20090603
       else if ((statusid.equals("020") || statusid.equals("021")) && UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0) // ????????Assigning?RESPONDING
       { 
	          sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID, (SELECT DISTINCT currency_code FROM po_headers_all WHERE PO_HEADER_ID = TLD.PO_HEADER_ID) currency  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where INSPLOT_NO='"+inspLotNo+"' and ( INSPECT_DEPT = '"+userInspDeptID+"' ) order by LINE_NO";   //加入採購單幣別欄位BY SHIN20090603
	   }
	   else if (UserRoles.indexOf("PUR_MGR")>=0 || UserRoles.indexOf("YEW_AVP")>=0) // 陽信廠採購或廠主管,所有單據皆可檢視
	   {
	          sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID, (SELECT DISTINCT currency_code FROM po_headers_all WHERE PO_HEADER_ID = TLD.PO_HEADER_ID) currency  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO";  //加入採購單幣別欄位BY SHIN20090603
	   }
	   else if (UserRoles.indexOf("YEW_IQC_MC")>=0)
	        {
			  sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID, (SELECT DISTINCT currency_code FROM po_headers_all WHERE PO_HEADER_ID = TLD.PO_HEADER_ID) currency  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO";   //加入採購單幣別欄位BY SHIN20090603
			}
            else if (UserRoles.indexOf("YEW_STOCKER")>=0)
		    { 
			  sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID, (SELECT DISTINCT currency_code FROM po_headers_all WHERE PO_HEADER_ID = TLD.PO_HEADER_ID) currency  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO";  //加入採購單幣別欄位BY SHIN20090603
		    }
			else  { sqlDTL ="select PO_NO, PO_QTY, LINE_NO, RECEIPT_NO, INV_ITEM_ID, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, AUTHOR_NO, SUPPLIER_LOT_NO, INSPECT_REQUIRE, to_char(to_date(RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, WAIVE_ITEM, ORGANIZATION_ID, INTERFACE_TRANSACTION_ID, (SELECT DISTINCT currency_code FROM po_headers_all WHERE PO_HEADER_ID = TLD.PO_HEADER_ID) currency  from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; }  //加入採購單幣別欄位BY SHIN20090603
       ResultSet rs=statement.executeQuery(sqlDTL);	   
	   while (rs.next())
	   {
	    out.print("<TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>");
		out.println("<TD><font color='#990000'>");			
		%>
		  <a href='javaScript:IQCInspectDetailHistQuery("<%=inspLotNo%>","<%=rs.getString("LINE_NO")%>","<%=rs.getString("INTERFACE_TRANSACTION_ID")%>")' onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("查詢項次處理歷程")'><img src='../image/point_arrow.gif' border='0'></a>
		<%
		out.println("</font></TD>");
		out.println("<TD><font color='#990000'>");
		out.println(rs.getString("LINE_NO")+"</font></TD>");
		out.println("<TD><font color='#990000'>"+rs.getString("PO_NO")+"</font></TD>");
		//out.println("<TD><font color='#990000'>"+poCURR+"</font></TD>"); //
		out.println("<TD><font color='#990000'>"+rs.getString("currency")+"</font></TD>"); //加入採購單幣別欄位BY SHIN20090603
		out.print("<TD><font color='#990000'>"); // 料號的ToolTip_起
		out.print("<a href=javaScript:popMenuMsg('"+rs.getString("INV_ITEM")+"') onmouseover='this.T_WIDTH=150;this.T_OPACITY=150;return escape("+"\""+rs.getString("INV_ITEM")+"\""+")'>"); // 寬度,透明度 //
		out.print(rs.getString("INV_ITEM_DESC")); 
		out.println("</a>");	
		out.print("</font></TD>"); // 料號的ToolTip_迄
		out.print("<TD><font color='#990000'>"+rs.getString("RECEIPT_QTY")+"</font></TD><TD><font color='#990000'>"+rs.getString("UOM")+"</font></TD><TD><font color='#990000'>"+rs.getString("AUTHOR_NO")+"</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");
		out.println(rs.getString("SUPPLIER_LOT_NO"));	
		out.println("</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");
		out.println(rs.getString("INSPECT_REQUIRE"));	// ???Line????
		out.println("</font></TD>");
		out.println("<TD NOWRAP><font color='#990000'>");
		out.println(rs.getString("RECEIPT_DATE"));	// ???收料日期
		out.println("</font></TD>");
		out.print("<TD><font color='#990000'>"+rs.getString("ORGANIZATION_ID")+"</font></TD>");
		out.println("</TR>");		
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();        
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	  }
	 %> 
	 </font>
	</td>      
  </tr>
  <tr> 
    <td colspan="4"><font color="#990000">備註:: <%=inspRemark%></font></td>   
  </tr>	
  </table>
  <table table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">  
  <tr> 
    <td width="10%" nowrap><font color="#990000">開單人員:</font></td>
    <td width="21%" nowrap><font color="#990000"><%=createdBy+"("+createdName+")"%></font></td>
    <td width="11%"><font color="#990000">開單日期:</font></td>
    <td width="27%" nowrap><font color="#990000"><%=creationDate%></font></td>
    <td width="10%"><font color="#990000">開單時間:</font></td><td width="21%"><font color="#990000"><%=creationTime%></font></td>
  </tr>
  <tr>
    <td nowrap><font color="#0080C0">前次處理人員:</font></td><td nowrap><font color="#0080C0"><%=lastUpdateBy+"("+lastUserName+")"%></font></td>
    <td nowrap><font color="#0080C0">前次處理日期:</font></td><td><font color="#0080C0"><%=lastUpdateDate%></font></td>
    <td nowrap><font color="#0080C0">前次處理時間:</font></td><td><font color="#0080C0"><%=lastUpdateTime%></font></td>
  </tr>  
</table>   
<% //if (frStatID.equals("009"))  { %>
&nbsp;&nbsp;&nbsp;<font color="RED">標誌圖示<strong><img src="../image/point.gif"></strong>表示必選(填)欄位,請務必輸入</font>
<%      //  } %>
  <!--3o?u?O¥I°I-->
  <!-- ai3a°N?A -->  
    <input name="FORMID"              type="HIDDEN" value="QC" > 	
	<input name="FROMSTATUSID"        type="hidden" value="<%=frStatID%>" >   
	<input name="INSPLOTNO"           type="hidden" value="<%=inspLotNo%>" >
	<input name="PREVIOUSPAGEADDRESS" type="HIDDEN" value=""> 
	<input name="PREORDERTYPE"        type="HIDDEN" value="<%=%>"> 
	<input name="LSTATUSID"           type="HIDDEN" value="<%=frStatID%>" >   
    <input name="ORGANIZATIONID"      type="HIDDEN" value="<%=organizationID%>" > 
    <input nmae="EXPAND"              type="hidden" value="<%=expand%>">
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

