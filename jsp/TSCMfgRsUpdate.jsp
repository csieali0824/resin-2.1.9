<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*"%>
<html>
<head>
<title>Runcard Resource Update Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRsUpdateBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<script language="JavaScript" type="text/JavaScript">

var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	  gfPop.fHideCal();
}

function check(field) 
{
	if (checkflag == "false") 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = true;
		}
 		checkflag = "true";
 		return "取消選取"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
 		return "全部選取"; 
	}
}

function submitCheck(xchkMoveQtyFlag)
{  
	if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
    {
    	alert("請選擇執行動作!!!");
	 	document.DISPLAYREPAIR.ACTIONID.focus(); 
	 	return(false);
    }      

   	flag=confirm("是否確認?");
   	{
    	if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
     	{
       		alert("請選擇執行動作!!!");
	   		document.DISPLAYREPAIR.ACTIONID.focus(); 
	   		return(false);
      	}      
	    //document.DISPLAYREPAIR.ACTIONID.focus();
		document.DISPLAYREPAIR.ACTIONID.value="--";
	    return(false);
   	}  
}

function setSubmit(URL,xchkMoveQtyFlag)
{ 
	if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
   	{
    	alert("請選擇執行動作!!!");
	 	document.DISPLAYREPAIR.ACTIONID.focus(); 
	 	return(false);
   	}      
   	if (xchkMoveQtyFlag=="N")
   	{   
		alert("請輸入工時!!!");
	    //document.DISPLAYREPAIR.ACTIONID.focus();
		document.DISPLAYREPAIR.ACTIONID.value="--";
	    return(false);
   	}  
    document.DISPLAYREPAIR.action=URL;
    document.DISPLAYREPAIR.submit();
}

function setSubmit1(URL)
{ 
	var linkURL = "#ACTION";  
  	document.DISPLAYREPAIR.action=URL+linkURL;
  	document.DISPLAYREPAIR.submit();
}

function setSubmit2(URL)
{ 
  	var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  	document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  	document.DISPLAYREPAIR.submit();    
}

function setSubmitComment(URL, xINDEX, xWKClass, xWKHour, xWKMachine, xWKEmployee,xOPSEQ, xMACHINEWKHour)
{    
	var linkURL = "#ACTION"; 
  	//alert(xINDEX); 
  	formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  	formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  	xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  	formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
  	formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
  	xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數
  
	formRESOURCEMACHINEQTY = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".focus()";
	formRESOURCEMACHINEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".value";
	xRESOURCEMACHINEQTY = eval(formRESOURCEMACHINEQTY_Write);  //add by Peggy 20120313,把值取得給java script 變數(機器工時)
  
  	formRESMACHINE = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".focus()";
  	formRESMACHINE_Write = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".value";
  	xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數
  
  	//formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  	//formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  	//xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數
  
  	formTXNDATE = "document.DISPLAYREPAIR.TXNDATE"+xINDEX+".focus()";
  	formTXNDATE_Write = "document.DISPLAYREPAIR.TXNDATE"+xINDEX+".value";
  	xTXNDATE = eval(formTXNDATE_Write);  // 把值取得給java script 變數
  	document.DISPLAYREPAIR.SETFLAG.value="Y";
  	//alert("xWKClass="+eval(formWKCLASS_Write)+"   xWKHour="+eval(formRESOURCEQTY_Write)+"  index="+xINDEX+"   "+xOPSEQ);
   
   	txt3=xRESOURCEQTY;	 //檢查人工工時回報數量是否為數字
    for (j=0;j<txt3.length;j++)      
    { 
    	e=txt3.charAt(j);
	    if ("0123456789.".indexOf(e,0)<0) 
	    {
			alert("人工工時回報數量必需為數值型態!!");
		  	eval(formRESOURCEQTY); // 取得焦點		     
		  	return(false);
	    }
   	}  
  
  	if (xRESOURCEQTY==null || xRESOURCEQTY=="" || xRESOURCEQTY==null || xRESOURCEQTY=="")
  	{
   		alert("請至少輸入人工工時回報資訊 !!!");
   		eval(formRESOURCEQTY);
   		return false;
  	} 
	
	//add by Peggy 20120604
   	txt31=xRESOURCEMACHINEQTY;	 //檢查機器工時回報數量是否為數字
    for (j=0;j<txt31.length;j++)      
    { 
    	e=txt31.charAt(j);
	    if ("0123456789.".indexOf(e,0)<0) 
	    {
			alert("機器工時回報數量必需為數值型態!!");
		  	eval(formRESOURCEMACHINEQTY); // 取得焦點		     
		  	return(false);
	    }
   	}  
  
  	if (xRESOURCEMACHINEQTY==null || xRESOURCEMACHINEQTY=="" || xRESOURCEMACHINEQTY==null || xRESOURCEMACHINEQTY=="")
  	{
   		alert("請至少輸入工時回報資訊 !!!");
   		eval(formRESOURCEMACHINEQTY);
   		return false;
  	} 
	
  	//document.DISPLAYREPAIR.action=URL+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&RUNCARDID="+xINDEX+linkURL;
  	//document.DISPLAYREPAIR.action=URL+"&WKCLASS"+xINDEX+"="+xWKCLASS+"&RESOURCEQTY"+xINDEX+"="+xRESOURCEQTY+"&RESMACHINE"+xINDEX+"="+xRESMACHINE+"&RESEMPLOYEE"+xINDEX+"="+xRESEMPLOYEE+"&TXNDATE"+xINDEX+"="+xTXNDATE+"&RUNCARDID="+xINDEX+"&OPSEQ="+xOPSEQ+"&RESOURCEQTY_MACHINE"+xINDEX+"="+xRESOURCEMACHINEQTY+linkURL;  
	document.DISPLAYREPAIR.action=URL+"&WKCLASS"+xINDEX+"="+xWKCLASS+"&RESOURCEQTY"+xINDEX+"="+xRESOURCEQTY+"&RESMACHINE"+xINDEX+"="+xRESMACHINE+"&TXNDATE"+xINDEX+"="+xTXNDATE+"&RUNCARDID="+xINDEX+"&OPSEQ="+xOPSEQ+"&RESOURCEQTY_MACHINE"+xINDEX+"="+xRESOURCEMACHINEQTY+linkURL;  
  	document.DISPLAYREPAIR.submit();    
}

function setTabNext(tabNextIndex, URL, xINDEX, xWKClass, xWKHour, xWKMachine, xWKEmployee,xOPSEQ, xMACHINEWKHour)
{ 
	//alert(xINDEX);  
  	formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  	formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  	xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  	formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
  	formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
  	xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數
  
  	//add by Peggy 20120604
	formRESOURCEMACHINEQTY = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".focus()";
	formRESOURCEMACHINEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".value";
	xRESOURCEMACHINEQTY = eval(formRESOURCEMACHINEQTY_Write);  // add by Peggy 20120313,把值取得給java script 變數(機器工時)
  
  	formRESMACHINE = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".focus()";
  	formRESMACHINE_Write = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".value";
  	xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數
  
  	//formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  	//formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  	//xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數

   	if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
   	{ 
    	if (tabNextIndex=="1")
	  	{
	    	eval(formWKCLASS);  // setFocus 到班別 
	  	} 
		else if (tabNextIndex=="2")
	    {
			eval(formRESOURCEMACHINEQTY); // setFocus 到工時
		} 
		else if (tabNextIndex=="3")
	    {
			eval(formRESOURCEQTY); // setFocus 到工時
		} 
		//else if (tabNextIndex=="4")
		//{
		//	eval(formRESEMPLOYEE); // setFocus 到製程處理人員
		//} 
		else if (tabNextIndex=="4")
		{
			eval(formRESMACHINE);  // setFocus 到製程機台號 
	    } 
		else if (tabNextIndex=="5")
		{
			setSubmitComment(URL, xINDEX, xWKClass, xWKHour, xWKMachine, xWKEmployee ,xOPSEQ, xMACHINEWKHour);
		}
   	}
}

</script>
<%
	String actionID = request.getParameter("ACTIONID"); 
	String statusID = request.getParameter("STATUSID");
    String woNo=request.getParameter("WO_NO"); 
	String runCardNo=request.getParameter("RUNCARD_NO"); 
    String marketType=request.getParameter("MARKETTYPE");
	String woType=request.getParameter("WOTYPE");
	String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
	//String startDate=request.getParameter("STARTDATE");
	//String endDate=request.getParameter("ENDDATE");
	String woQty="",startDate="",endDate="";
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
    double woQtyD=0; 
    String s1="",s2="";
	String setFlag=request.getParameter("SETFLAG");
	if (setFlag==null || setFlag.equals("")) setFlag="N";
	
    String [] check=request.getParameterValues("CHKFLAG");
	
	String woQtySet=request.getParameter("WOQTY");
	String startDateSet=request.getParameter("STARTDATE");
	String endDateSet=request.getParameter("ENDDATE");
	String woRemarkSet=request.getParameter("WOREMARK");
    String opSeq=request.getParameter("OPSEQ");
    String runCardID=request.getParameter("RUNCARDID");
    int lineIndex = 1;	
    //if (runCardID!=null) lineIndex = Integer.parseInt(runCardID);
	if (runCardID==null) runCardID = "0";
    else lineIndex = Integer.parseInt(runCardID);

	String opDesc=request.getParameter("DESCRIPTION");
	String wkClass=request.getParameter("WKCLASS"+Integer.toString(lineIndex));
	String resourceQty=request.getParameter("RESOURCEQTY"+Integer.toString(lineIndex));	
	String resMachine=request.getParameter("RESMACHINE"+Integer.toString(lineIndex));
	//String resEmployee=request.getParameter("RESEMPLOYEE"+Integer.toString(lineIndex));
	String txnDateSet=request.getParameter("TXNDATE"+Integer.toString(lineIndex));
    String chkMoveQtyFlag = "N",newQty="";
    String updateQty=request.getParameter("UPDATEQTY"+Integer.toString(lineIndex));	
	String resourceQty_machine=request.getParameter("RESOURCEQTY_MACHINE"+Integer.toString(lineIndex));	 //機器工時,add by Peggy 20120604
	if (resourceQty_machine==null) resourceQty_machine="0";
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgRsMProcess.jsp?RUNCARD_NO=<%=runCardNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<%
if (txnDateSet==null || txnDateSet.equals("")) txnDateSet=""; //dateBean.getYearMonthDay();
if (wkClass==null || wkClass.equals("")) wkClass="";
if (resourceQty==null || resourceQty.equals("")) resourceQty="";
if (resMachine==null || resMachine.equals("")) resMachine="";
//if (resEmployee==null || resEmployee.equals("")) resEmployee="";
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
	<tr bgcolor="#CCCC99"> 
    	<td colspan="3">
     	<font color="#000066">流程卡明細:</font> <BR>
	  	<%
	try
	{  
		//機器工時,add by Peggy 20120604
       	String oneDArray[]= {"ID","RUNCAD_ID","OPSEQNUM","流程卡號","班別","機器工時","人工工時","操作人員","機台號","異動日期","WIP_ENTITY_ID","OPSEQID","ORG_ID"};  // 先將內容明細的標頭,給一維陣列		 	     			  
   	    arrMFGRsUpdateBean.setArrayString(oneDArray);
		// 先取 該工令流程卡筆數
     	int rowLength = 0;
     	Statement stateCNT=con.createStatement();
       	ResultSet rsCNT=stateCNT.executeQuery("select count(RUNCARD_NO) from YEW_RUNCARD_RESTXNS where WO_NO='"+woNo+"'  ");
		 
		if (rsCNT.next()) rowLength = rsCNT.getInt(1);
		rsCNT.close();
		stateCNT.close();
		//out.print("rowLength="+rowLength);
		String b[][]=new String[rowLength+1][18]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)	   
  
		//array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
		//b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Item Desc";b[0][3]="QTY";b[0][4]="UOM";b[0][5]="WO_Remark";b[0][6]="Product Manufactory";
		out.println("<TABLE cellSpacing='0' bordercolordark='#B1A289' cellPadding='0' width='100%' align='center' bordercolorlight='#CCCC99'  border='1'>");
		out.println("<tr bgcolor='#CCCC99'>");
		out.println("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
       %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'> 
	   <%
	   	out.println("</td>");
	   	out.println("<td><div align='center'>流程卡號</div></td>");
		out.println("<td><div align='center'>站別碼</div></td>");
		out.println("<td><div align='center'>站別名稱</div></td>");
	   	out.println("<td><div align='center'>已報工時</div></td>");
		out.println("<td><div align='center'>班別</div></td>");
		out.println("<td><div align='center'>機器工時</div></td>");
		out.println("<td><div align='center'>人工工時</div></td>");
	   	//out.println("<td><div align='center'>操作人員</div></td>"); //不顯示,modify by Peggy 20120605
		out.println("<td><div align='center'>機台號</div></td>");
		out.println("<td><div align='center'>回報日期</div></td>");
	   	out.print("<td><div align='center'>Set</div></td>");    
	   	int k=0;
	   
	   	String sqlEst = "",wipRsQty="";
	   	if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) // 若是管理員,可設定任一項目為特採
	   	{ 
	   		//sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";
			sqlEst =   "  select YRA.RUNCAD_ID,YRA.RUNCARD_NO,YRA.WIP_ENTITY_ID,WIPO.OPERATION_SEQ_NUM,WIPO.DESCRIPTION, WIPO.OPERATION_SEQUENCE_ID, YRA.PRIMARY_ITEM_ID,"+
         			 "		   TO_CHAR(TO_DATE(YRR.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, YRR.TRANSACTION_QUANTITY, YRR.TRANSACTION_UOM, YRR.TRANSACTION_DATE, "+
					 "		   YRR.WORK_EMPLOYEE, YRR.WORK_MACHINE, decode(YRR.WKCLASS_CODE,'1','1st','2','2nd','3','3rd') WKCLASS ,FU.USER_NAME,YRA.STATUS, "+
					 "         YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, WIPO.ORGANIZATION_ID ,YRR.UPDATE_QTY "+
					 "         ,YRR.MACHINE_TRANSACTION_QUANTITY,YRA.RES_MACHINE_WKHOUR_OP,YRR.MACHINE_UPDATE_QTY"+ //機器工時,add by Peggy 20120604
 					 "    from YEW_RUNCARD_ALL YRA, FND_USER FU ,YEW_RUNCARD_RESTXNS YRR ,WIP_OPERATIONS WIPO "+
					 "	  where YRA.CREATE_BY=FU.USER_ID and YRA.RUNCARD_NO=YRR.RUNCARD_NO  "+
					 "		and  WIPO.WIP_ENTITY_ID=YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQ_NUM=YRR.OPERATION_SEQ_NUM(+)  and YRA.RUNCARD_NO ='"+runCardNo+"'  order by YRA.RUNCARD_NO,YRR.OPERATION_SEQ_NUM ";
	   	}
	   	else 
	   	{   
	          //sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; 
		  	sqlEst ="  select YRA.RUNCARD_NO,YRA.WIP_ENTITY_ID,YRA.QTY_IN_TOMOVE,WIPO.OPERATION_SEQ_NUM,WIPO.DESCRIPTION,WIPO.OPERATION_SEQUENCE_ID,  YRA.PRIMARY_ITEM_ID, "+
         			 "		   TO_CHAR(TO_DATE(YRR.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE,YRR.TRANSACTION_QUANTITY, YRR.TRANSACTION_UOM, YRR.TRANSACTION_DATE, "+
					 "		   YRR.WORK_EMPLOYEE,YRR.WORK_MACHINE, decode(YRR.WKCLASS_CODE,'1','1st','2','2nd','3','3rd') WKCLASS ,FU.USER_NAME,YRA.STATUS, "+
					 "         YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP , WIPO.ORGANIZATION_ID,YRR.UPDATE_QTY "+					 
					 "         ,YRR.MACHINE_TRANSACTION_QUANTITY,YRA.RES_MACHINE_WKHOUR_OP,YRR.MACHINE_UPDATE_QTY"+//機器工時,add by Peggy 20120604
 					 "    from YEW_RUNCARD_ALL YRA, FND_USER FU ,YEW_RUNCARD_RESTXNS YRR ,WIP_OPERATIONS WIPO "+
					 "	  where YRA.CREATE_BY=FU.USER_ID and YRA.RUNCARD_NO=YRR.RUNCARD_NO  "+
					 "		and  WIPO.WIP_ENTITY_ID=YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQ_NUM=YRR.OPERATION_SEQ_NUM(+)  and YRA.RUNCARD_NO ='"+runCardNo+"' order by YRA.RUNCARD_NO,YRR.OPERATION_SEQ_NUM  ";
		}
	   	//out.println("sqlEst="+sqlEst); 
       	Statement statement=con.createStatement();
       	ResultSet rs=statement.executeQuery(sqlEst);
	   	while (rs.next())
	   	{ 
        	// 取Oracle已回報工時累計  
            String wipRs = " select nvl(sum(nvl(TRANSACTION_QUANTITY,0)),0) from wip_transactions "+
							"  where TRANSACTION_TYPE =1  and wip_entity_id = "+rs.getString("WIP_ENTITY_ID")+" "+
 							"    and ATTRIBUTE2 = '"+rs.getString("RUNCARD_NO")+"'   and OPERATION_SEQ_NUM = "+rs.getString("OPERATION_SEQ_NUM")+" ";
            //out.print("wiprs="+wipRs);
            Statement stateWipRs=con.createStatement();
			ResultSet rsWipRs=stateWipRs.executeQuery(wipRs);
			if (rsWipRs.next())
			{
				wipRsQty  = rsWipRs.getString(1); 
	   	  		out.print("<TR bgcolor='#CCCC99'>");		
		  		out.println("<TD width='1%'><div align='center'>");		 
		  
		  		out.print("<input type='checkbox' name='CHKFLAG' value='"+(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))+"' ");
		  		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		   		{
		      		for (int j=0;j<check.length;j++) 
			  		{ 
			    		if ((check[j])==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || check[j].equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) out.print("checked"); 
			  		}
			 		if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) out.print("checked"); // 給定生產日期即設定欲結轉
		   		} 
				else if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) out.print("checked"); //第一筆給定生產日期即設定欲結轉  
		 		if (rowLength==1) out.print("checked>"); 	
		 		else out.println(">");	     	
	   	 		out.println("</div></TD>"); 
		 		out.println("<TD nowrap><div align='center'>"+rs.getString("RUNCARD_NO")+"</div></TD>");
				out.println("<TD nowrap><div align='center'>"+rs.getString("OPERATION_SEQ_NUM")+"</div></TD>");
         		out.println("<TD nowrap><div align='left'>&nbsp;&nbsp;"+rs.getString("DESCRIPTION")+"</div></TD>");
				out.println("<TD nowrap><div align='center'>"+wipRsQty+"</div></TD>");
  
				//班別,是否?自動依處理時間判段所屬班別_起
				out.println("<TD nowrap><div align='center'>");
		        try
                {   
					//-----取班別資訊
		           	Statement stateWClass=con.createStatement();
                   	ResultSet rsWClass=null;	
			       	String sqlWClass = " select WKCLASS_CODE, WKCLASS_NAME||'('||WKCLASS_DESC||')' from APPS.YEW_MFG_WORKCLASS ";
			       	String whereWClass = " where WORKCLASS_TYPE='1'  ";								  
				   	String orderWClass = "  ";  				   
				   	sqlWClass = sqlWClass + whereWClass;
				   	//out.println(sqlOrgInf);
                   	rsWClass=stateWClass.executeQuery(sqlWClass);
		           	comboBoxBean.setRs(rsWClass);
		           	comboBoxBean.setSelection(wkClass);
	               	comboBoxBean.setFieldName("WKCLASS"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"));	
				   	//comboBoxBean.setTabIndex(rs.getString("RUNCAD_ID"));   
                   	out.println(comboBoxBean.getRsString());
		           	rsWClass.close();   
				   	stateWClass.close();			
                } //end of try		 
                catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				}
				out.println("</div></TD>");
				//班別,自動依處理時間判段所屬班別_迄
		
				//機器工時,add by Peggy 20120604
				out.println("<TD nowrap>");			
				if (resourceQty_machine==null || resourceQty_machine.equals(""))
				{ 
					out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(rs.getString("MACHINE_TRANSACTION_QUANTITY")==null?"":(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("MACHINE_TRANSACTION_QUANTITY"))))+"' size=5 onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
				}
		 		else 
				{
		        	if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) 
					{
    			    	out.print("<input name='RESOURCEQTY_MAHCINE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(resourceQty_machine==null?"":(new DecimalFormat("##,##0.###")).format(Float.parseFloat(resourceQty_machine)))+"' size=5 onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
					}
					else  
					{
						out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(rs.getString("MACHINE_TRANSACTION_QUANTITY")==null?"":(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("MACHINE_TRANSACTION_QUANTITY"))))+"' size=5 onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>");  
					}
 		 		}
				out.println("</TD>");
		
				//人工工時
				out.println("<TD nowrap>");			
				if (resourceQty==null || resourceQty.equals(""))
				{ 
					out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(rs.getString("TRANSACTION_QUANTITY")==null?"":(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("TRANSACTION_QUANTITY"))))+"' size=5 onKeyDown=setTabNext('3',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
				}
		 		else 
				{
		        	if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) 
					{
    			    	out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(resourceQty==null?"":(new DecimalFormat("##,##0.###")).format(Float.parseFloat(resourceQty)))+"' size=5 onKeyDown=setTabNext('3',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
					}
					else  
					{
						out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(rs.getString("TRANSACTION_QUANTITY")==null?"":(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("TRANSACTION_QUANTITY"))))+"' size=5 onKeyDown=setTabNext('3',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>");  
					}
 		 		}
				out.println("</TD>");
  
				//線上處理人員_ 
				/*
				out.println("<TD align='center' nowrap>");		
				if (resEmployee==null || resEmployee.equals("")) // 若是處理項次,則予此次給定comments
				{ 
					out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+rs.getString("WORK_EMPLOYEE")+"' size=10 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
				}
		 		else 
				{ 
		        	if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) 
					{
    			    	out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+resEmployee+"' size=10 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
					}
					else  
					{
						out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+rs.getString("WORK_EMPLOYEE")+"' size=10 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>");  
					}
			  	} 
				out.println("</TD>");	
				*/
				  
				// 機台編號_ 
				out.println("<TD align='center' nowrap>");		
				if (resMachine==null || resMachine.equals("")) // 若是處理項次,則予此次給定comments
				{ 
					out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(rs.getString("WORK_MACHINE")==null?"":rs.getString("WORK_MACHINE"))+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
				}
		 		else 
				{ 
		        	if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) 
					{
    			    	out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(resMachine==null?"":resMachine)+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>"); 
					}
					else  
					{
						out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+(rs.getString("WORK_MACHINE")==null?"":rs.getString("WORK_MACHINE"))+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")>");  
					}
			  	} 
				out.println("</TD>");
		
				out.println("<TD align='center' nowrap>");		
				if (runCardID==null || runCardID.equals("")) // 若是處理項次,則予此次給定comments
				{ 
					out.print("<input name='TXNDATE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+rs.getString("TRANSACTION_DATE")+"' size=15 readonly>");  
		  			out.println("<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.DISPLAYREPAIR.TXNDATE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+");return false;'>");
		  			out.println("<img name='popcal' border='0' src='../image/calbtn.gif'></a>");
		 		}
		 		else 
				{ 
		        	if (runCardID==rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM") || runCardID.equals(rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM"))) 
    				{  
						out.print("<input name='TXNDATE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+txnDateSet+"' size=15 readonly>"); 
			       		out.println("<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.DISPLAYREPAIR.TXNDATE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+");return false;'>");
				   		out.println("<img name='popcal' border='0' src='../image/calbtn.gif'></a>");
                 	}
					else
					{   
						out.print("<input name='TXNDATE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+"' type='text' value='"+rs.getString("TRANSACTION_DATE")+"' size=15 readonly>");  
						out.println("<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.DISPLAYREPAIR.TXNDATE"+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+");return false;'>");
						out.println("<img name='popcal' border='0' src='../image/calbtn.gif'></a>");
                 	}
			  	} 
				out.println("</TD>");
    			out.print("<TD nowrap><div align='center'><INPUT TYPE='button' value='Set' onClick='setSubmitComment("+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&WO_NO="+woNo+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+rs.getString("OPERATION_SEQ_NUM")+'"'+")'>");
				out.print("</div></TD></TR>");
            } 
			else wipRsQty ="0";
   
	        rsWipRs.close();
            stateWipRs.close();
		
			b[k][0]=rs.getString("RUNCAD_ID")+rs.getString("OPERATION_SEQ_NUM");
			b[k][1]=rs.getString("RUNCAD_ID");
			b[k][2]=rs.getString("OPERATION_SEQ_NUM");
			b[k][3]=rs.getString("RUNCARD_NO");	
					    
			b[k][4]=rs.getString("WKCLASS");//wkClass; resourceQty
			b[k][5]=rs.getString("TRANSACTION_QUANTITY");//;
			b[k][6]=rs.getString("WORK_EMPLOYEE");//resEmployee;
			b[k][7]=rs.getString("WORK_MACHINE");//resMachine;
			b[k][8]=rs.getString("TRANSACTION_DATE");//txnDateSet; 	
						   
			b[k][9]=rs.getString("WIP_ENTITY_ID");
			b[k][10]=rs.getString("OPERATION_SEQUENCE_ID");
			b[k][11]=rs.getString("ORGANIZATION_ID");
			b[k][12]=rs.getString("PRIMARY_ITEM_ID");
			b[k][13]=resourceQty;       //人工工時
            b[k][14]=rs.getString("UPDATE_QTY");
			b[k][15]=rs.getString("MACHINE_TRANSACTION_QUANTITY");//機器工時,add by Peggy 20120604
			b[k][16]=resourceQty_machine; //機器工時,add by Peggy 20120604
            b[k][17]=rs.getString("MACHINE_UPDATE_QTY"); //機器工時,add by Peggy 20120604
			arrMFGRsUpdateBean.setArray2DString(b);
			k++;
	    }    //end of while	   
	   	out.println("</TABLE>");
	   	statement.close();
       	rs.close();  
	   
	   	//modify by Peggy 20120604
		if (runCardID!=null && (resourceQty!=null ||resourceQty_machine!=null) )
	    { 		   
   	    	//String sql = "update APPS.YEW_RUNCARD_RESTXNS set WKCLASS_CODE=?,TRANSACTION_QUANTITY=? ,WORK_EMPLOYEE=?,WORK_MACHINE=?, TRANSACTION_DATE=?, UPDATE_QTY=? ,MACHINE_TRANSACTION_QUANTITY=?,MACHINE_UPDATE_QTY=? where RUNCARD_NO='"+runCardNo+"' and OPERATION_SEQ_NUM = '"+opSeq+"'  ";
			String sql = "update APPS.YEW_RUNCARD_RESTXNS set WKCLASS_CODE=?,TRANSACTION_QUANTITY=? ,WORK_MACHINE=?, TRANSACTION_DATE=?, UPDATE_QTY=? ,MACHINE_TRANSACTION_QUANTITY=?,MACHINE_UPDATE_QTY=? where RUNCARD_NO='"+runCardNo+"' and OPERATION_SEQ_NUM = '"+opSeq+"'  ";
	        PreparedStatement pstmt=con.prepareStatement(sql);  
            pstmt.setString(1,wkClass);       //  
            pstmt.setString(2,resourceQty);   // 
			//pstmt.setString(3,resEmployee);   // 
			pstmt.setString(3,resMachine);    // 
			pstmt.setString(4,txnDateSet);    //
			pstmt.setString(5,resourceQty);   //人工工時
			pstmt.setString(6,resourceQty_machine);   //機器工時
			pstmt.setString(7,resourceQty_machine);   //機器工時
	      	pstmt.executeUpdate(); 
            pstmt.close();
       	}
		
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception 4:"+e.getMessage());
    }
	   
	String a[][]=arrMFGRsUpdateBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
    if (a!=null) 
	{	
		for (int i=0;i<a.length-1;i++)
		{
        } 
		chkMoveQtyFlag="Y"; 
	}	//enf of a!=null if	
	else 
	{
		chkMoveQtyFlag="N"; //未給定任何數值*/
	}			
%> 
	</tr>       
</table>
<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->

<BR>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
<%
	try
    {   
    	Statement statement=con.createStatement();
 		//此功能為改單,只允許update ,故限定action為update 022
     	frStatID="042";
     	ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID ='022' and  x1.LOCALE='"+locale+"'");
	   	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgRsUpdate.jsp?RUNCARD_NO="+runCardNo+"&WO_NO="+woNo+'"'+")'>");				  				  
	   	out.println("<OPTION VALUE=-->--");     
	   	while (rs.next())
	   	{ 
			s1=(String)rs.getString(1); 
		 	s2=(String)rs.getString(2); 
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
	   	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   	rs.next();
	   	if (rs.getInt(1)>0 ) //判斷若沒有動作可選擇就不出現submit按鈕
	   	{ 
%>
        	<INPUT TYPE='submit' NAME='submit2' value='Submit' onClick='setSubmit("../jsp/TSCMfgRsMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>&FROMSTATUSID=042","<%=setFlag%>")'><%
            out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
	   	} 
       	rs.close();       
	   	statement.close();
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>
</a></td></tr></table> 
<!-- 表單參數 --> 
<INPUT type="hidden" SIZE=5 name="SETFLAG" value="<%=setFlag%>" readonly>
<INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
<INPUT type="hidden" SIZE=5 name="FROMSTATUSID" value="<%=frStatID%>" readonly>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
