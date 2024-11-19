<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*"%>
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
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}
function submitCheck(ms1,ms2,ms3)
{  
       
  return(true);  
}
function setSubmit1(URL)
{ //alert(); 
  document.MYFORM.action=URL;
  document.MYFORM.submit();
}
function setSubmit2(URL)
{ 
  var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  document.MYFORM.action=URL+pcAcceptDate;
  document.MYFORM.submit();    
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
   	String createDate=request.getParameter("CREATEDATE");
   	String rsPph=request.getParameter("RSPPH");
   	String colorStr="#FFFFFF";
   	String rsQty ="", workEmployee ="", workMachine = "",rsUom="",wkClass="",qtyInInput="",moveQty="";	
   	String rsMachineQty = "",rsMachineUom = "" ,rsMachinePph=""; //add by Peggy 20120605 		
   	String runCardID=request.getParameter("RUNCARDID");
    int lineIndex = 1;
	int k=1;	
	String [] check=request.getParameterValues("CHKFLAG");

%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<BR>
<FORM ACTION="../jsp/TSCMfgWoResourceDetail.jsp" METHOD="post" NAME="MYFORM">
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
		<td nowrap align="center" width="3%"><font color="#FFFFFF">站別</font></td>
		<td nowrap align="center" width="10%"><font color="#FFFFFF">站別名稱</font></td>
        <td nowrap align="center" width="5%"><font color="#FFFFFF">投入數</font></td>
		<td nowrap align="center" width="5%"><font color="#FFFFFF">產出數</font></td>		
		<td nowrap align="center" width="6%"><font color="#FFFFFF">機器工時</font></td> <!--add by Peggy 20120605-->
		<td nowrap align="center" width="6%"><font color="#FFFFFF">人工工時</font></td>
		<td nowrap align="center" width="4%"><font color="#FFFFFF">單位</font></td>		
		<td nowrap align="center" width="7%"><font color="#FFFFFF">班別</font></td>
		<!--<td nowrap align="center" width="5%"><font color="#FFFFFF">機台號</font></td>-->
		<!--<td nowrap align="center" width="8%"><font color="#FFFFFF">操作人員</font></td>-->
		<td nowrap align="center" width="5%"><font color="#FFFFFF">機器PPH</font></td><!--add by Peggy 20120605-->
		<td nowrap align="center" width="5%"><font color="#FFFFFF">人工PPH</font></td>
		<td nowrap align="center" width="8%"><font color="#FFFFFF">回報日期</font></td>
		<td nowrap align="center" width="10%"><font color="#FFFFFF">異動人員</font></td>		
		<td nowrap align="center" width="12%"><font color="#FFFFFF">狀態</font></td>
    </tr>
     

<%    
	String sqlOp =  "  select YRA.RUNCARD_NO,YRA.WIP_ENTITY_ID,YRR.QTY_IN_INPUT,YRA.QTY_IN_TOMOVE,YRR.OPERATION_SEQ_NUM,WIPO.DESCRIPTION,YRA.QTY_IN_TOMOVE, "+
         			 "		   TO_CHAR(TO_DATE(YRR.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE,YRR.TRANSACTION_QUANTITY, YRR.TRANSACTION_UOM,"+
					 "		   YRR.WORK_EMPLOYEE,YRR.WORK_MACHINE,decode(YRR.WKCLASS_CODE,'1','1st','2','2nd','3','3rd') WKCLASS ,FU.USER_NAME,YRA.STATUS "+
					 "         ,YRR.MACHINE_TRANSACTION_QUANTITY,YRR.MACHINE_TRANSACTION_UOM,YRR.resource_seq_num,YRR.machine_resource_seq_num,NVL(YRR.QTY_IN_INPUT,0)-NVL(YRR.qty_ac_scrap,0) MOVEQTY"+//add by Peggy 20120605
					 "         ,round(YRR.QTY_IN_INPUT/decode(YRR.TRANSACTION_QUANTITY,0,1,YRR.TRANSACTION_QUANTITY),2) RSPPH"+//add by Peggy 20120605
					 "         ,round(YRR.QTY_IN_INPUT/decode(YRR.MACHINE_TRANSACTION_QUANTITY,0,1,YRR.MACHINE_TRANSACTION_QUANTITY),2) MACHINERSPPH"+//add by Peggy 20120605
 					 "    from YEW_RUNCARD_ALL YRA, FND_USER FU ,YEW_RUNCARD_RESTXNS YRR ,WIP_OPERATIONS WIPO "+
					 "	  where YRA.CREATE_BY=FU.USER_ID and YRA.RUNCARD_NO=YRR.RUNCARD_NO(+)  "+
					 "		and  WIPO.WIP_ENTITY_ID=YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQ_NUM=YRR.OPERATION_SEQ_NUM  and YRA.WO_NO ='"+woNo+"'  "+
					 "	order by YRA.RUNCARD_NO,YRR.OPERATION_SEQ_NUM  "; 
	//out.print("sqlOp ="+sqlOp);
	Statement stateOp=con.createStatement();
    ResultSet rsOp=stateOp.executeQuery(sqlOp);
	while (rsOp.next())
	{ 	
		runCardNo    = rsOp.getString("RUNCARD_NO"); 
	    opDesc       = rsOp.getString("DESCRIPTION");
		opSeqNum     = rsOp.getString("OPERATION_SEQ_NUM");
		qtyInInput   = rsOp.getString("QTY_IN_INPUT");
		qtyInToMove  = rsOp.getString("QTY_IN_TOMOVE");
		rsQty   	 = rsOp.getString("TRANSACTION_QUANTITY");		
		rsUom   	 = rsOp.getString("TRANSACTION_UOM");		
		wkClass		 = rsOp.getString("WKCLASS");		
		workEmployee   = rsOp.getString("WORK_EMPLOYEE");
		workMachine    = rsOp.getString("WORK_MACHINE");
		userName       = rsOp.getString("USER_NAME");
		rcStatus       = rsOp.getString("STATUS"); 
		createDate     = rsOp.getString("CREATEDATE");
		rsMachineQty   = rsOp.getString("MACHINE_TRANSACTION_QUANTITY"); //add by Peggy 20120605 
		rsMachineUom   = rsOp.getString("MACHINE_TRANSACTION_UOM");      //add by Peggy 20120605 
		moveQty        = rsOp.getString("MOVEQTY");                      //add by Peggy 20120605  		 
		rsPph          = rsOp.getString("RSPPH");	                     //add by Peggy 20120605  		 
		rsMachinePph   = rsOp.getString("MACHINERSPPH");	             //add by Peggy 20120605  		 
        if (opDesc==null) opDesc="&nbsp"; 
		if (opSeqNum==null) opSeqNum="&nbsp";
		if (rsQty==null) rsQty="&nbsp";
		if (workEmployee==null) workEmployee="&nbsp";
		if (workMachine==null) workMachine="&nbsp";
		if (createDate==null) createDate="&nbsp";
	 
	 	//機器與人工PPH,與User確認後,公式為投入數/機器工時(or人工工時),故下面sql不適用,改寫在上面的sql,modify by Peggy 20120605
	 	//String sqlPph="  select yrr.operation_seq_num,sum(yrt.transaction_quantity) MOVEQTY,"+
		//              "  sum(yrr.transaction_quantity) RSQTY , "+
		//		   	  "  round( sum(yrt.transaction_quantity) / sum(DECODE(yrr.transaction_quantity,0,1,yrr.transaction_quantity)),2) RSPPH ,"+
		//		      "	 from  YEW_RUNCARD_TRANSACTIONS YRT ,YEW_RUNCARD_RESTXNS YRR "+
		//		      "	where YRT.RUNCARD_NO=YRR.RUNCARD_NO and YRT.FM_OPERATION_SEQ_NUM = YRR.OPERATION_SEQ_NUM and YRT.STEP_TYPE='1' "+
		//		      "       and YRR.RUNCARD_NO= '"+runCardNo+"' and yrr.operation_seq_num="+opSeqNum+" group by yrr.operation_seq_num ";
	 	//out.print("<br>sqlPph="+sqlPph);
	 	//Statement stateph=con.createStatement();
     	//ResultSet rsph=stateph.executeQuery(sqlPph);
	 	//while (rsph.next())
	 	//{
	 	//	moveQty = rsph.getString("MOVEQTY");
		//  	rsPph   = rsph.getString("RSPPH");	
		//   	rsMachinePph   = rsph.getString("MACHINERSPPH");	
       	//} //end if
	 	//rsph.close();
     	//stateph.close(); 
   		colorStr="#FFFFFF";
			
%>			
	   <TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='<%=colorStr%>'>
	    <TD align="center"><font color='#990000'><%=k%></TD>
		<TD align="center"><font color='#990000'>
		  <a href='javaScript:IQCInspectDetailHistQuery("<%=woNo%>","<%=runCardNo%>")' onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("查詢項次處理歷程")'><img src='../image/point_arrow.gif' border='0'>
         </a></font></TD>
	    <TD align="center"><font color='#990000'><%=runCardNo%></font></TD>
		<TD align="center"><font color='#990000'><%=opSeqNum%></font></TD>
		<TD align="left"><font color='#990000'>&nbsp;<%=opDesc%></font></TD>
        <TD align="center"><font color='#990000'><%=qtyInInput%></font></TD>
		<TD align="center"><font color='#990000'><%=moveQty%></font></TD>		
		<TD align="center"><font color='#990000'><%if (rsMachineQty==null) out.println("&nbsp;"); else out.println((new DecimalFormat("##,##0.###")).format(Float.parseFloat(rsMachineQty)));%></font></TD> <!--add by Peggy 20120605-->
		<TD align="center"><font color='#990000'><%if (rsQty==null) out.println("&nbsp;"); else out.println((new DecimalFormat("##,##0.###")).format(Float.parseFloat(rsQty)));%></font></TD>
		<TD align="center"><font color='#990000'><%=rsUom%></font></TD>		
		<TD align="center"><font color='#990000'><%if (wkClass==null) out.println("&nbsp;"); else out.println(wkClass);%></font></TD>	
		<!--<TD align="center"><font color='#990000'><%=workMachine%></font></TD>-->
		<!--<TD align="center"><font color='#990000'><%=workEmployee%></font></TD>-->
		<TD align="center"><font color='#990000'><%if (rsMachinePph==null) out.println("&nbsp;"); else out.println(rsMachinePph);%></font></TD>
		<TD align="center"><font color='#990000'><%=rsPph%></font></TD>
		<TD align="center"><font color='#990000'><%=createDate%></font></TD>
		<TD align="center"><font color='#990000'><%=userName%></font></TD>			
		<TD align="center"><font color='#990000'><%=rcStatus%></font></TD>		
	  </TR>	

<%	
		k=k+1; 
	} //end of while
	rsOp.close();
    stateOp.close(); 
%>    
</table>	 
<%
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
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
