<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!-- 20140421 liling 增加type=5 DC顯示-->
<!-- 20151026 liling 增加type=5 custlot顯示-->
<html>
<head>
<title>Work Order Information List</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function submitCheck(ms1,ms2,ms3)
{         
  return(true);  
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
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
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
	String customerPo=request.getParameter("CUSTOMERPO");
	String oeOrderNo=request.getParameter("OEORDERNO");	
	String deptNo=request.getParameter("DEPT_NO");	
    String deptName=request.getParameter("DEPT_NAME");	
    String preFix=request.getParameter("PREFIX");
    String oeHeaderId=request.getParameter("OEHEADERID");	
	String oeLineId=request.getParameter("OELINEID");	
	String organizationId=request.getParameter("ORGANIZATION_ID");	
	String waferLineNo=request.getParameter("LINE_NO");
   String runCardNo=request.getParameter("RUNCARD_NO");
   String opSeqNum=request.getParameter("OPERATION_SEQ_NUM");
   String opDesc=request.getParameter("STANDARD_OP_DESC");
   String runCardQty=request.getParameter("RUNCARD_QTY");
   String qtyInQueue=request.getParameter("QTY_IN_QUEUE");
   String qtyInScrap=request.getParameter("QTY_IN_SCRAP");
   String qtyInToMove=request.getParameter("QTY_IN_TOMOVE");
   String userName=request.getParameter("USER_NAME");
   String rcStatus=request.getParameter("STATUS");
   String rcDateCode=request.getParameter("RC_DATE_CODE");
   String createDate=request.getParameter("CREATEDATE");
   String custLotNo=request.getParameter("CUSTLOTNO");
   String colorStr="#FFFFFF";
   
   
   String runCardID=request.getParameter("RUNCARDID");
    int lineIndex = 1;
	int k=1;	
	
   String [] check=request.getParameterValues("CHKFLAG");

%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="../jsp/TSCMfgWoDetail.jsp" METHOD="post" NAME="DISPLAYREPAIR">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPageV2.jsp"%>
<!--=================================-->
<%
   try
   {
%>   
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
    <tr> &nbsp;</tr>
	<tr bgcolor='#BDA279'>
	    <td nowrap align="center" width="2%"><font color="#FFFFFF"> NO </a></font></td>
    	<td nowrap align="center" width="2%"><font color="#FFFFFF">&nbsp;</a></font></td>
	 	<td nowrap align="center" width="10%"><font color="#FFFFFF">流程卡號</font></td>
		<td nowrap align="center" width="7%"><font color="#FFFFFF">流程卡數量</font></td>
<!--% if(woType=="3" || woType.equals("3")) { % -->
<% if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5")) { %>
        <td nowrap align="center" width="3%"><font color="#FFFFFF">DateCode</font></td>
<% }  %>
		<td nowrap align="center" width="3%"><font color="#FFFFFF">站別代碼</font></td>
		<td nowrap align="center" width="7%"><font color="#FFFFFF">站別名稱</font></td>
		<td nowrap align="center" width="7%"><font color="#FFFFFF">接收數量</font></td>
		<td nowrap align="center" width="7%"><font color="#FFFFFF">處理數量</font></td>
		<td nowrap align="center" width="7%"><font color="#FFFFFF">耗損</font></td>
		<td nowrap align="center" width="9%"><font color="#FFFFFF">展開人員</font></td>
		<td nowrap align="center" width="8%"><font color="#FFFFFF">展開日期</font></td>
		<td nowrap align="center" width="10%"><font color="#FFFFFF">狀態</font></td>
<% if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5")) { %>
	 	<td nowrap align="center" width="9%"><font color="#FFFFFF">客戶卡號</font></td>
<% }  %>
    </tr>
     

<%    


   
     String sqlOp = " select YRA.RUNCARD_NO,YRA.WIP_ENTITY_ID,YRA.OPERATION_SEQ_NUM,YRA.STANDARD_OP_DESC,YRA.RUNCARD_QTY,YRA.RC_DATE_CODE,  "+
       				"        YRA.QTY_IN_QUEUE,YRA.QTY_AC_SCRAP,YRA.QTY_IN_TOMOVE,FU.USER_NAME,YRA.STATUS,YRA.CUST_LOT_NO, "+
       				"        TO_CHAR(TO_DATE(YRA.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE "+
 					"   from YEW_RUNCARD_ALL YRA, FND_USER FU "+
					"  where YRA.WO_NO ='"+woNo+"' " ;
	 String orderOp = " order by YRA.RUNCARD_NO,YRA.OPERATION_SEQ_NUM ";

	 if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0 || UserRoles.indexOf("YEW_WIP_PACKING")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) 
	 {  sqlOp=sqlOp+" and YRA.CREATE_BY=FU.USER_ID "+orderOp; }
	 else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0) 
     {
         sqlOp=sqlOp+" and YRA.CREATE_BY=FU.USER_ID "+orderOp; 	 	    
     } else {
	           sqlOp=sqlOp+" and YRA.CREATE_BY=FU.USER_ID "+orderOp;
	        }
	 //out.print("sqlOp ="+sqlOp);
	 Statement stateOp=con.createStatement();
     ResultSet rsOp=stateOp.executeQuery(sqlOp);
	 while (rsOp.next())
	 { 	
       String revRcQty="";
       String sqlRc = " select YRT.TRANSACTION_QUANTITY from YEW_RUNCARD_TRANSACTIONS YRT , YEW_RUNCARD_ALL YRA  "+
					  "  where YRT.FM_OPERATION_SEQ_NUM = YRA.PREVIOUS_OP_SEQ_NUM "+
  					  "    and YRT.RUNCARD_NO = YRA.RUNCARD_NO   AND YRT.STEP_TYPE = 1 "+
                      "    and YRA.RUNCARD_NO = '"+rsOp.getString("RUNCARD_NO")+"'";

       	 Statement stateRc=con.createStatement();
         ResultSet rsRc=stateRc.executeQuery(sqlRc);
		 if (rsRc.next())
          { revRcQty  = rsRc.getString("TRANSACTION_QUANTITY");  }
         rsRc.close();
         stateRc.close();

         if (revRcQty=="0" || revRcQty.equals(""))
          {qtyInQueue   = rsOp.getString("QTY_IN_QUEUE");}
         else
          {qtyInQueue   = revRcQty;} 




		    runCardNo    = rsOp.getString("RUNCARD_NO"); 
	        opDesc       = rsOp.getString("STANDARD_OP_DESC");
			opSeqNum     = rsOp.getString("OPERATION_SEQ_NUM");
			runCardQty   = rsOp.getString("RUNCARD_QTY");
            rcDateCode   = rsOp.getString("RC_DATE_CODE");
			qtyInToMove  = rsOp.getString("QTY_IN_TOMOVE");
			//qtyInQueue   = rsOp.getString("QTY_IN_QUEUE");
			qtyInScrap   = rsOp.getString("QTY_AC_SCRAP");	 //qtyInScrap   = rsOp.getString("QTY_IN_SCRAP");			
			userName       = rsOp.getString("USER_NAME");
			rcStatus       = rsOp.getString("STATUS"); 
			createDate     = rsOp.getString("CREATEDATE");
            custLotNo    = rsOp.getString("CUST_LOT_NO"); 

            if (opDesc==null) opDesc="&nbsp"; 
			if (opSeqNum==null) opSeqNum="&nbsp";
			if (runCardQty==null) runCardQty="&nbsp";
            if (rcDateCode==null) rcDateCode="&nbsp";
			if (qtyInQueue==null) qtyInQueue="&nbsp";
			if (qtyInScrap==null) qtyInScrap="&nbsp";
			if (qtyInToMove==null) qtyInToMove="&nbsp";
            if (custLotNo==null) custLotNo="&nbsp";

	        /*       if ((k % 2) == 0)   //控制每列顏色
	                 { colorStr = "#FFCCCC"; }
	               else
	                 { colorStr = "#FFFFCC"; }
*/
      		colorStr="#FFFFFF";
			
%>			
	   <TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='<%=colorStr%>'>
	    <TD align="center"><font color='#990000'><%=k%></TD>
		<TD align="center"><font color='#990000'>
		  <a href='javaScript:WorkOrderDetailHistQuery("<%=woNo%>","<%=runCardNo%>")' onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("查詢流程卡處理歷程")'><img src='../image/point_arrow.gif' border='0'>
         </a></font></TD>
	    <TD align="center"><font color='#990000'><%=runCardNo%></font></TD>
		<TD align="center"><font color='#990000'><%=runCardQty%></font></TD>
<%-- if(woType=="3" || woType.equals("3")) { --%> 
<% if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5")) { %>
        <TD align="center"><font color='#990000'><%=rcDateCode%></font></TD>
<% }  %>
		<TD align="center"><font color='#990000'><%=opSeqNum%></font></TD>
		<TD align="center"><font color='#990000'><%=opDesc%></font></TD>
		<TD align="center"><font color='#990000'><%=qtyInQueue%></font></TD>
		<TD align="center"><font color='#990000'><%=qtyInToMove%></font></TD>
		<TD align="center"><font color='#990000'><%=qtyInScrap%></font></TD>
		<TD align="center"><font color='#990000'><%=userName%></font></TD>	
		<TD align="center"><font color='#990000'><%=createDate%></font></TD>
		<TD align="center"><font color='#990000'><%=rcStatus%></font></TD>	
<% if(woType=="3" || woType.equals("3") || woType=="5" || woType.equals("5") ) { %>
	 	<TD align="center"><font color='#990000'><%=custLotNo%></font></TD>
<% }  %>	
	  </TR>	

<%	 
	   k=k+1;
	 } //end of while
	 rsOp.close();
     stateOp.close(); 
	  
%>    </table>	 <%
   }// end of try
   catch (Exception e)
   {
     out.println("Exception 3:"+e.getMessage());
   }		
%>
<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->
<BR>
<!-- 表單參數 --> 
 <INPUT type="hidden" NAME="runCardNo" value="<%=runCardNo%>"> 
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
