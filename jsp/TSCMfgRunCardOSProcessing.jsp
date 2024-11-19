<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>MFG System Work Order Process Page</title>
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
function setSubmitQtyToMove(URL,xINDEX)
{    
  var linkURL = "#ACTION";  
  formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()";
  formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數
  
  //document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.action=URL+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&RUNCARDID="+xINDEX+linkURL;
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
function setOSPSubmit(URL,ms1)
{
  if (document.DISPLAYREPAIR.ACTIONID.value=="006")  //TRANSFER表示為確認移站轉至OSP動作
  {
              flag=confirm(ms1);      
              if (flag==false) return(false);
			  else {
			             // 若未選擇任一Line 作動作,則警告
                        var chkFlag="FALSE";
                        if (document.DISPLAYREPAIR.CHKFLAG.length!=null)
                        {
                          for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
                          {
                             if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
	                         {
	                           chkFlag="TURE";
	                         } 
                           }  // End of for	 
                           if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                           {
                             alert(ms11);   
                             return(false);
                           }
	                     } // End of if 	
			       }
  }
  document.DISPLAYREPAIR.action=URL;
  document.DISPLAYREPAIR.submit();
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
    String actionID = request.getParameter("ACTIONID"); 
    String woNo=request.getParameter("WO_NO"); 
	String runCardNo=request.getParameter("RUNCARD_NO"); 
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
    //String alternateRouting=request.getParameter("ALTERNATEROUTING"); 
    String customerName=request.getParameter("CUSTOMERNAME");	
    String customerNo=request.getParameter("CUSTOMERNO");
	String customerPo=request.getParameter("CUSTOMERPO");
	String oeOrderNo=request.getParameter("OEORDERNO");	
	String deptNo=request.getParameter("DEPT_NO");	
    String deptName=request.getParameter("DEPT_NAME");	
    String preFix=request.getParameter("PREFIX");
    String oeHeaderId=request.getParameter("OEHEADERID");	
	String oeLineId=request.getParameter("OELINEID");	
	//String organizationId=request.getParameter("ORGANIZATION_ID");	
	String waferLineNo=request.getParameter("LINE_NO");
	String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
	String prevOpSeqID = "0",nextOpSeqID = "0"; // 基本頁面將上下一站的OperationSequenceID都取出,作為更新移站時判斷依據

    String runCardID=request.getParameter("RUNCARDID");
    int lineIndex = 1;	
    //if (runCardID!=null) lineIndex = Integer.parseInt(runCardID);
	if (runCardID==null) runCardID = "0";
    else lineIndex = Integer.parseInt(runCardID);
	String queueQty=request.getParameter("QUEUEQTY"+Integer.toString(lineIndex));
	
    String [] check=request.getParameterValues("CHKFLAG");
	
	//out.println("000="+nextOpSeqID);

%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgWoMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<% out.println("001="+nextOpSeqID);
   // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新_起
    int currOperSeqID = 0;
   
     String sqlRC = " select max(a.OPERATION_SEQUENCE_ID) from WIP_OPERATIONS a, WIP.WIP_ENTITIES b "+
	                " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and  b.WIP_ENTITY_NAME='"+woNo+"' and a.REQUEST_ID is null ";
	 //out.print("sqlRC 補不足資料欄位="+sqlRC);
	 Statement stateRC=con.createStatement();
     ResultSet rsRC=stateRC.executeQuery(sqlRC);
	 if (rsRC.next())
	 {
		currOperSeqID = rsRC.getInt(1); // 取目前真正的WIP 目前站別(預防使用者自行由Oracle執行移站,WIP系統之移站資訊與Oracle工單不一致
	 }
	 rsRC.close();
     stateRC.close(); 	 
 // 直接至Oracle作移站_上線後不允許(因會導致工令對應不到流程卡移站)_起
 /*
 try
 {
     int  wipCurrOpSeqID = 0; 
     String sqlOp = " select a.WIP_ENTITY_ID, b.OPERATION_SEQ_ID from WIP.WIP_ENTITIES a, APPS.YEW_RUNCARD_ALL b "+
	                " where a.WIP_ENTITY_NAME = b.WO_NO and a.WIP_ENTITY_NAME='"+woNo+"' " ;
	 //out.print("sqlOp 補不足資料欄位="+sqlOp);
	 Statement stateOp=con.createStatement();
     ResultSet rsOp=stateOp.executeQuery(sqlOp);
	 if (rsOp.next())
	 {
		  	entityId   = rsOp.getString(1);  
			wipCurrOpSeqID = rsOp.getInt(2);			
	 }
	 rsOp.close();
     stateOp.close(); 
	 
  if (currOperSeqID != wipCurrOpSeqID && currOperSeqID>0) // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新
  {  //out.println("111="+nextOpSeqID);
	 String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
        			"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
					"  from WIP_OPERATIONS where OPERATION_SEQUENCE_ID = "+currOperSeqID+" and WIP_ENTITY_ID ="+entityId+" ";	 
	 Statement statep=con.createStatement();
     ResultSet rsp=statep.executeQuery(sqlp);
	 if (rsp.next())
	 {
		  	operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");  
			operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
			standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
			standardOpDesc 	  = rsp.getString("DESCRIPTION");
			previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
			nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
			if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
			if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";
			if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";			
			if (nextOpSeqNum==null || nextOpSeqNum.equals("")) nextOpSeqNum = "0";		
			
	 } else {
	             operationSeqNum   = "0";
				 operationSeqId    = "0";
				 standardOpId  	  = "0";
				 standardOpDesc   = "0"; 
	             previousOpSeqNum  = "0"; 
				 nextOpSeqNum	  = "0"; 
	        }
	 rsp.close();
     statep.close(); 
	 
    String woSql=" update APPS.YEW_RUNCARD_ALL set OPERATION_SEQ_NUM=?, OPERATION_SEQ_ID=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, "+
	             "  NEXT_OP_SEQ_NUM=?, PREVIOUS_OP_SEQ_NUM=? "+
	             " where WO_NO= '"+woNo+"' and RUNCARD_NO = '"+runCardNo+"' "; 	
    PreparedStatement wostmt=con.prepareStatement(woSql);    
	wostmt.setInt(1,Integer.parseInt(operationSeqNum));
	wostmt.setInt(2,Integer.parseInt(operationSeqId)); 
	wostmt.setInt(3,Integer.parseInt(standardOpId)); 
	wostmt.setString(4,standardOpDesc); 
	wostmt.setInt(5,Integer.parseInt(nextOpSeqNum));
	wostmt.setInt(6,Integer.parseInt(previousOpSeqNum));
    wostmt.executeUpdate();   
    wostmt.close(); 
	
   }  // End of if (currOperSeqID != wipCurrOpSeqID) // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新	
//out.println("222="+nextOpSeqID);	
  }// end of try
  catch (Exception e)
  {
     out.println("Exception Oracle之站別資訊與MFG WIP不一致:"+e.getMessage());
  }		   
  // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新_迄
*/  // 直接至Oracle作移站_上線後不允許(因會導致工令對應不到流程卡移站)_迄

     boolean singLastOp = false;
     String sqlNextOp = " select NEXT_OP_SEQ_NUM from APPS.YEW_RUNCARD_ALL where WO_NO='"+woNo+"' and RUNCARD_NO ='"+runCardNo+"' " ;	 
	 //out.print("sqlRC 補不足資料欄位="+sqlRC);
	 Statement stateNextOp=con.createStatement();
     ResultSet rsNextOp=stateNextOp.executeQuery(sqlNextOp);
	 if (rsNextOp.next() && rsNextOp.getString("NEXT_OP_SEQ_NUM").equals("0")) // 若下一站未找到,表示本站為最後一站
	 {
		singLastOp = true; // 表示singLastOp
	 }
	 rsNextOp.close();
     stateNextOp.close(); 
	 
   String sqlPrevOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.RUNCARD_NO ='"+runCardNo+"' and c.ORGANIZATION_ID = '"+organizationId+"' "+
					    "    and a.OPERATION_SEQ_NUM  = c.PREVIOUS_OP_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;
   Statement statePrevOpID=con.createStatement();
   ResultSet rsPrevOpID=statePrevOpID.executeQuery(sqlPrevOpID);
   if (rsPrevOpID.next())
   {
      prevOpSeqID = rsPrevOpID.getString("OPERATION_SEQUENCE_ID");	
   }
   rsPrevOpID.close();
   statePrevOpID.close();	 

   String sqlNextOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.RUNCARD_NO ='"+runCardNo+"' and c.ORGANIZATION_ID = '"+organizationId+"' "+					    
					    "    and a.OPERATION_SEQ_NUM  = c.NEXT_OP_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;
   Statement stateNextOpID=con.createStatement();
   out.println("sqlNextOpID="+sqlNextOpID);	
   ResultSet rsNextOpID=stateNextOpID.executeQuery(sqlNextOpID);
   if (rsNextOpID.next())
   {
      nextOpSeqID = rsNextOpID.getString("OPERATION_SEQUENCE_ID");	
   }
   rsNextOpID.close();
   stateNextOpID.close();				 
	 
//out.println("333="+sqlNextOpID);	 
 // 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_起
 String resourceDesc = "";
 boolean ospCheckFlag = false;
 try
 {

   String sqlJudgeOSP = " select b.DESCRIPTION, b.COST_CODE_TYPE "+
                       " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                       " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					   "   and b.ORGANIZATION_ID = '"+organizationId+"' and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					   "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					   "   and to_char(d.OPERATION_SEQUENCE_ID) = '"+nextOpSeqID+"' and b.COST_CODE_TYPE = 4 ";
  //out.println(sqlJudgeOSP);					   
   Statement stateJudgeOSP=con.createStatement();
   ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
   if (rsJudgeOSP.next())
   { 			
      resourceDesc = rsJudgeOSP.getString("DESCRIPTION");   // 外包站說明顯示於下一站的右方
	  ospCheckFlag = true;
	  %>
	    <script language="javascript">
		    alert("          下一站為委外加工站\n 此工作站完工後將產生委外請、採購單!!!");
		</script>	  
	  <%
   }
   rsJudgeOSP.close();
   stateJudgeOSP.close();	   
 } //end of try
 catch (Exception e)
 {
  out.println("Exception runcard:"+e.getMessage());
 }	   
 
 // 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_迄 	 
	 
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      流程卡明細 : <BR>
	  <%
	  try
      {   
	    String oneDArray[]= {"流程卡識別碼","流程卡號","前一站","目前站別","移站數量","下一站","流程卡狀態","展開日期"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	arrMFGRCMovingBean.setArrayString(oneDArray);		
		// 先取 該詢問單筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(RUNCAD_ID) from YEW_RUNCARD_ALL where WO_NO='"+woNo+"' and STATUSID = '"+frStatID+"' ");	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	     //out.println("rowLength="+rowLength);
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][9]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#B1A289' cellPadding='0' width='100%' align='center' bordercolorlight='#CCCC99'  border='1'>");
	   out.println("<tr bgcolor='#CCCC99'>");
	   out.println("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>
	   <%
	   out.println("</td>");
	   out.println("<td>流程卡識別碼</td>");
	   out.println("<td>");	  
	   out.println("流程卡號</td><td>流程卡數量</td><td>移站數量</td><td>前一站</td><td nowrap>目前站別</td>");
	   if (ospCheckFlag) out.println("<td><font color='#990000'><em>下一站(委外加工站)</em></font></td>");
	   else out.println("<td>下一站</td>");
	   out.print("<td>流程卡狀態</td><td>展開日期</td>");    
	   int k=0;
	   out.println("entityId="+entityId);
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   { 
	      //sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";
		  sqlEst = " select YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,WIPO.STANDARD_OPERATION_ID,WIPO.DESCRIPTION,  "+
        			"       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM,YRA.RUNCARD_NO , "+
					"       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					"       BOS.OPERATION_DESCRIPTION, YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID "+
					"  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA,BOM_OPERATION_SEQUENCES BOS  "+
					"  where YRA.PREVIOUS_OP_SEQ_NUM > 0  "+  // 第 n-1站
					"    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID  "+
					"    and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.WIP_ENTITY_ID= "+entityId+" and STATUSID = '"+frStatID+"' ";
	   }
	   else {   
	          //sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; 
			  sqlEst = " select YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM, WIPO.OPERATION_SEQUENCE_ID, WIPO.STANDARD_OPERATION_ID, WIPO.DESCRIPTION,  "+
        			"       WIPO.PREVIOUS_OPERATION_SEQ_NUM, WIPO.NEXT_OPERATION_SEQ_NUM, YRA.RUNCARD_NO , "+
					"       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					"       BOS.OPERATION_DESCRIPTION,YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID  "+
					"  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA,BOM_OPERATION_SEQUENCES BOS  "+
					"  where YRA.PREVIOUS_OP_SEQ_NUM > 0 "+   // 第 n-1站
					"    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID  "+
					"    and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.WIP_ENTITY_ID= "+entityId+" and YRA.DEPT_NO = '"+userMfgDeptNo+"' and STATUSID = '"+frStatID+"' ";
			}
	   //out.println("0=="+sqlEst); 
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   {//out.println("0"); 
	    out.print("<TR bgcolor='#CCCC99'>");		
		out.println("<TD width='1%'><div align='center'>");
		
		out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("RUNCAD_ID")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{  //out.println("111"); 
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("RUNCAD_ID") || check[j].equals(rs.getString("RUNCAD_ID"))) out.println("checked");  }
		  if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); // 給定生產日期即設定欲結轉
		} else if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
		if (rowLength==1) out.println("checked >"); 	else out.println(" >");		
		out.println("</div></TD>");
		out.println("<TD nowrap>");
		out.print(rs.getString("RUNCAD_ID")+"</TD>");		
		out.println("<TD nowrap>");
		out.print(rs.getString("RUNCARD_NO")+"</TD>");
		out.println("<TD nowrap>");
		out.print(rs.getString("RUNCARD_QTY")+"</TD>");
		out.print("<TD nowrap><INPUT TYPE='button' value='Set' onClick='setSubmitQtyToMove("+'"'+"../jsp/TSCMfgRunCardOSProcessing.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+")'>");
		
		//out.println(comment);
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		{ out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+queueQty+"' size=5>"); }
		else { 
		      if (rs.getString("QTY_IN_TOMOVE")==null)
			    out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5>");  
			  else out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_TOMOVE")+"' size=5>"); 
			 }				  
		out.println("</TD>");
		out.println("<TD nowrap>"+rs.getString("PREVIOUS_OPERATION_SEQ_NUM")+"</TD><TD nowrap>"+rs.getString("OPERATION_SEQ_NUM")+"</TD>");
		if (ospCheckFlag) out.print("<TD nowrap><font color='#990000'><em>"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"("+resourceDesc+")"+"</em></font></TD>");
		else out.print("<TD nowrap>"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"</TD>");
		out.print("<TD nowrap>"+rs.getString("STATUS")+"</TD><TD nowrap>"+rs.getString("CREATION_DATE")+"</TD></TR>");
		 
		 b[k][0]=rs.getString("RUNCAD_ID");b[k][1]=rs.getString("RUNCARD_NO");b[k][2]=rs.getString("QTY_IN_TOMOVE");b[k][3]=rs.getString("PREVIOUS_OPERATION_SEQ_NUM");b[k][4]=rs.getString("OPERATION_SEQ_NUM");b[k][5]=rs.getString("NEXT_OPERATION_SEQ_NUM");b[k][6]=rs.getString("STATUS");		 
		 b[k][7]=rs.getString("CREATION_DATE");b[k][8]=rs.getString("ORGANIZATION_ID");
		 arrMFGRCMovingBean.setArray2DString(b);		 
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (runCardID !=null && queueQty!=null && !queueQty.equals(""))
	    { //out.println("COMMENT UPDATE="+comment);
		  
	      String sql = "update APPS.YEW_RUNCARD_ALL set QTY_IN_TOMOVE=?, PREVIOUS_OP_SEQ_ID=?, NEXT_OP_SEQ_ID=?"+
		               " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
		  //out.println("sql="+sql);
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,queueQty);     // 本次移站數量更新
		  pstmt.setInt(2,Integer.parseInt(prevOpSeqID));  // 本次前一站ID更新
		  pstmt.setInt(3,Integer.parseInt(nextOpSeqID));  // 本次下一站ID更新
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=arrMFGRCMovingBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		      //out.println(a[0][0]+""+a[0][1]+""+a[0][2]+""+a[0][3]+""+a[0][4]+"<BR>"); 
		 }	//enf of a!=null if		
		
    %> 
 </font>      
  </tr>       
</table>
<!--%
try
{ 
 //String  entityId="81064";
 //out.print("runcardno="+runCardNo);
      String sqlp = " select WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,WIPO.STANDARD_OPERATION_ID,WIPO.DESCRIPTION,  "+
        			"       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM,YRA.RUNCARD_NO , "+
					"       YRA.QTY_IN_QUEUE,to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					"       BOS.OPERATION_DESCRIPTION "+
					"  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA,BOM_OPERATION_SEQUENCES BOS  "+
					"  where YRA.PREVIOUS_OP_SEQ_NUM in (0,null)  "+
					"    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID  "+
					"    and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.WIP_ENTITY_ID= "+entityId+" ";
	 //out.print("sqli="+sqlp);
	 Statement statep=con.createStatement();
     ResultSet rsp=statep.executeQuery(sqlp);
	 if (rsp.next())
		 { 
		  	operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");  
			operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
			standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
			previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
			nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
			runCardNo         = rsp.getString("RUNCARD_NO");
			qtyInQueue        = rsp.getString("QTY_IN_QUEUE");
			creationDate      = rsp.getString("CREATION_DATE");
			standardOpDesc    = rsp.getString("DESCRIPTION");
		  }
	 rsp.close();
     statep.close(); 
%-->
<!--%
 <TABLE cellSpacing='0' bordercolordark='#B5B89A' cellPadding='0' width='97%' align='center' bordercolorlight='#FFFFFF'  border='1'>
  <tr bgcolor='#CCCC99'>
    <td nowrap><font color='#FFFFFF'>&nbsp;流程卡號</font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;目前站別</font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;接收時間</font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;接收數量</font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;下一站別</font></td>
  </tr>	
  <tr bgcolor='#CCCC99'>
    <td nowrap><font color='#FFFFFF'>&nbsp;<%//=runCardNo%></font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;<%//=operationSeqNum%></font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;<%//=creationDate%></font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;<%//=qtyInQueue%></font></td>
	<td nowrap><font color='#FFFFFF'>&nbsp;<%//=previousOpSeqNum%></font></td>  
  </tr>
</TABLE> 
 %-->
 
 
<% 
 
 
 
%>


<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->

<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">           
  <tr bgcolor="#CCCC99"> 
      <td width="30%">單批作業量: 
        <INPUT TYPE="TEXT" NAME="SINGLELOTQTY" SIZE=5 maxlength="5" value="<%=%>">&nbsp;&nbsp;<%=%>
		<INPUT TYPE="button" NAME="SINGLELOTSET"  value="Update" onClick="setQty('../jsp/TSCMfgWoExpand.jsp?WO_NO=<%=%>',this.form.SINGLELOTQTY.value)">  
     </td>
	 <td >&nbsp;&nbsp;預計展開流程卡張數:
	    <INPUT type="text" SIZE=5 name="RUNCARDCOUNTI" value="<%=%>" readonly></td>
  </tr>         
</table>

<BR>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {  //out.println("frStatID="+frStatID);
	   //out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
	   String sqlAction = null;
	   if (!singLastOp) //  不為最後一站,則可執行Transfer
	   { 
	     if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		 {
		     sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('018') "; 	
		 }
		 else { //不為最後一站,則可執行Transfer
	           sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('018', '006') "; 	   
		      }
	   }
	   else {  //  本站為最後一站,則可執行Complete
	           if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		       {
		         sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('018') "; 	
		       }
		       else { //不為最後一站,則可執行Transfer
	                 sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('018','012') "; 	   
		            }	           
	        }
		//out.println(sqlAction);	
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlAction);
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());	   
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgRunCardOSProcessing.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+")'>");				  				  
	   out.println("<OPTION VALUE=-->--");     
	   while (rs.next())
	   {            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(actionID)) 
  		{
          out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
               }        
	   } //end of while
	   out.println("</select>"); 
	   
	   
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   rs.next();
	   if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   {
	     if (!ospCheckFlag) // 若下一站不為委外加工站,則呼叫正常移站處理頁面_起
		 {
            out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 } else {
		          out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行移至委外加工站?"+'"'+")'>"); 
		        } // 若下一站不為委外加工站,則呼叫正常移站處理頁面_迄
		 out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
	   } 
       rs.close();       
	   statement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></a></td></tr></table>
 <!-- 表單參數 --> 
 <INPUT type="hidden" SIZE=5 name="RUNCARD_NO" value="<%=runCardNo%>" readonly>
 <INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
 <INPUT type="hidden" SIZE=5 name="ALTERNATEROUTING" value="<%=alternateRouting%>" readonly>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>


