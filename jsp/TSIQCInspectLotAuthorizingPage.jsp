<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>IQC Inspection Lot Process Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/IQCInclude/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrIQC2DAuthorizingBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
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
function submitCheck(ms1,ms2,ms3,ms4)
{         
  flag=confirm("是否確認送出?");
  if (flag==false) return(false);
  else
  {   
      if (document.DISPLAYREPAIR.ACTIONID.value =="--")    // 如未選擇動作送出,則顯示警告訊息
      {
        alert("請選擇執行動作");
	    return(false);
      }
	    
	   
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
               alert("請選擇清單內項目執行送出確認!!");   
               return(false);
            }
	  } // End of if 
						 
	  if (document.DISPLAYREPAIR.ACTIONID.value=="021")
	  {	      
		  flagCancel=confirm("是否確認取消此比檢驗批?");
          if (flagCancel==false) return(false);
		  else {
		          if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                  {
                    alert("請選擇清單內項目執行送出確認!!");   
                    return(false);
                  } else {
		                  // return true;
						  }
		       }
	  }
	  
	  if (document.DISPLAYREPAIR.ACTIONID.value=="005")
	  {	      
		  flagReject=confirm("是否確認批退此檢驗批?");
          if (flagReject==false) return(false);
		  else {
		          if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                  {
                    alert("請選擇清單內項目執行送出確認!!");   
                    return(false);
                  } else {
		                   //return true;
						  }
		       }
	  }
	  
	  if (document.DISPLAYREPAIR.ACTIONID.value=="026")
	  {	      
		  flagAccept=confirm("是否同意檢驗批合格?");
          if (flagAccept==false) return(false);
		  else {
		          if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                  {
                    alert("請選擇清單內項目執行送出確認!!");   
                    return(false);
                  } else {
		                   //return true;
						  }
		       }
	  }								 
	  
  } // End of flag = true 確認要送出
  //return(true);  
}
function setSubmitResult(URL,xINDEX,setResult)
{    
  var linkURL = "#ACTION";   
  
    var resultID="N/A";
    for (i=0;i<document.DISPLAYREPAIR.RESULT.length;i++)
    {//alert(document.MYFORM.WFTYPEID[i].checked);
	  if (document.DISPLAYREPAIR.RESULT[i].checked==true)
	  { 
	    resultID = document.DISPLAYREPAIR.RESULT[i].value;
		//alert(document.DISPLAYREPAIR.RESULT[i].value);
	  } 
    }   // end of for  
 
  document.DISPLAYREPAIR.action=URL+"&LINE_NO="+xINDEX+"&SETRESULT="+setResult+"&RESULT="+resultID+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmitComment(URL,xINDEX)
{    
  var linkURL = "#ACTION";  
  formCOMMENT = "document.DISPLAYREPAIR.COMMENT"+xINDEX+".focus()";
  formCOMMENT_Write = "document.DISPLAYREPAIR.COMMENT"+xINDEX+".value";
  xCOMMENT = eval(formCOMMENT_Write);  // 把值取得給java script 變數
  
  //document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.action=URL+"&COMMENT"+xINDEX+"="+xCOMMENT+"&LINENO="+xINDEX+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit1(URL)
{ //alert(); 
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

  // 20100923 Marvie Add : check frStatID = '026'
  function ProcessFormQuery(URL,statusId,pageURL)
  {
    alert("Stauts of this IQC document is not AUTHORIZING, return to previous page.");
	document.DISPLAYREPAIR.action=URL+"?STATUSID="+statusId+"&PAGEURL="+pageURL;
    document.DISPLAYREPAIR.submit();
  }

</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
   String inspLotNo=request.getParameter("INSPLOTNO");
   //String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   String lineNo=request.getParameter("LINENO");
   //String pcAcceptDate=request.getParameter("PCACPDATE"); 
   String actionID = request.getParameter("ACTIONID");   
   String remark = request.getParameter("REMARK");   
   String line_No=request.getParameter("LINE_NO");
   String recUserID=request.getParameter("RECUSERID");
   String statusID=request.getParameter("STATUSID");
   // 晶片晶粒檢測內容_參數起   
   String exWfSizeID=request.getParameter("EXWFSIZEID"); 
   String exDiceSize=request.getParameter("EXDICESIZE"); 
   String exWfThick=request.getParameter("EXWFTHICK"); 
   String exWfResist=request.getParameter("EXWFRESIST"); 
   String exWfPlatID=request.getParameter("EXWFPLATID"); 
   String surDefect=request.getParameter("SURDEFECT");
   String shortage=request.getParameter("SHORTAGE");
   String pullDMIN=request.getParameter("PULLDMIN");
   String peeling=request.getParameter("MATPEEL");
   String voidBub=request.getParameter("VOIDBUB");
   String oxid=request.getParameter("OXID");
   String diceShtRate=request.getParameter("DICESHTRAT");
   String wfShtQty=request.getParameter("WFSHTQTY");      
   
   String totalYield=request.getParameter("TOTALYIELD");
   String product=request.getParameter("PRODUCT");
   String prodYield=request.getParameter("PRODYIELD");
   // 晶片晶粒檢測內容_參數迄
   // 主要原物料檢測內容_參數起
   String specFile=request.getParameter("SPECFILE");
   String mtSizeCPK=request.getParameter("MTSIZECPK"); // 尺寸檢測CPK
   String qtyShtRate=request.getParameter("QTYSHTRATE"); // 包裝數短少率
   String mtSurface=request.getParameter("MTSURFACE"); // 外觀0收1退
   String mtPlatDeg=request.getParameter("MTPLATDEG"); // 鋅底平面度0收1退
   String mtPackBox=request.getParameter("MTPACKBOX"); // 外包裝箱0收1退
   // 主要原物料檢測內容_參數迄
   // 間接原物料檢測內容_參數起
   String imSurface=request.getParameter("IMSURFACE"); // 間接外觀0收1退 
   String chSurDsc=request.getParameter("CHSURDSC");  // 間接外觀說明
   String chLiqDsc=request.getParameter("CHLIQDSC");  // 間接液重說明
   String chIPADsc=request.getParameter("CHIPADSC");  // 間接IPA說明
   String imWeight=request.getParameter("IMWEIGHT");  // 間接重量0收1退    
   String imSizeDim=request.getParameter("IMSIZEDIM");  // 間接尺寸0收1退
   String imInked=request.getParameter("IMINKED");  // 間接印字附著性0收1退   
  
   if (chSurDsc==null) chSurDsc = "";
   if (chLiqDsc==null) chLiqDsc= "";
   if (chIPADsc==null) chIPADsc= "";
   
   // 間接原物料檢測內容_參數迄
   
   String result=request.getParameter("RESULT");
   String setResult=request.getParameter("SETRESULT");
   
   String exSampleQty=request.getParameter("EXSAMPLEQTY");
   String exInspectQty=request.getParameter("EXINSPECTQTY");
   String exProdName=request.getParameter("EXPRODNAME");   
   
   
   //out.println("result="+result);
  // if (result == null || result.equals("")) result = "01";
   
   if (lineNo==null) { lineNo="";}
   //if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   
   if (surDefect==null) surDefect = "";
   if (shortage==null) shortage = "0";
   if (pullDMIN==null) pullDMIN = "";
   if (peeling==null) peeling = "";
   if (voidBub==null) voidBub = "";
   if (oxid==null) oxid = "";
   if (diceShtRate==null) diceShtRate = "";
   if (wfShtQty==null) wfShtQty = "";
   
    
   if (totalYield==null) totalYield = "";
   if (product==null || product.equals("") ||product.equals("null")) product = "";
   if (prodYield==null) prodYield = "";
   if (setResult==null) setResult = "N";
   
   //out.println("setResult="+setResult);
   
   String subInventory=request.getParameter("SUBINVENTORY");
   String subInvDesc=request.getParameter("SUBINVDESC");
   
    //String comment=request.getParameter("COMMENT");
   int lineIndex = 1;
   if (line_No!=null) lineIndex = Integer.parseInt(line_No);
   String comment=request.getParameter("COMMENT"+Integer.toString(lineIndex));
   
   String [] check=request.getParameterValues("CHKFLAG");
   
   if (lineNo==null) { lineNo="";}
   if (subInventory==null) { subInventory="";}
   if (subInvDesc==null) { subInvDesc="";}
   
   //if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   
   if (comment==null) comment="";  // 若未指定,預設為 ""
   
    CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
    cs1.setString(1,userQCOrgID);  // 取品管人員隸屬OrgID
    cs1.execute();
    //out.println("Procedure : Execute Success !!! ");
    cs1.close();
   
%>
<body>
<%@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<BR>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作","")' ACTION="../jsp/TSIQCInspectLotMProcess.jsp?INSPLOT_NO=<%=inspLotNo%>" METHOD="post">
<!--=============以下區段為取得IQC檢驗批基本資料==========-->
<%@ include file="/jsp/include/TSIQCInspectAccBasicInfoPage.jsp"%>

<%
  // 20100923 Marvie Add : check frStatID = '026'
  if (!frStatID.equals("026"))
  {       
	%>
	  <script LANGUAGE="JavaScript">
	    ProcessFormQuery("../jsp/TSIQCInspectLotQueryAllStatus.jsp","026","TSIQCInspectLotAuthorizingPage.jsp");
	  </script>
	<%
  }
%>

<!--=================================-->
<INPUT TYPE="hidden" NAME="SUBINVENTORY" SIZE=5 value="<%=subInventory%>">
<INPUT TYPE="hidden" NAME="SUBINVDESC" SIZE=40 value="<%=subInvDesc%>">  
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      處理內容明細
      : <BR>
    <%
	  try
      {   
	    String oneDArray[]= {"項次","說明","台半料號","收料數量","單位","收料日期","供應商進料批號","備註"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	arrIQC2DAuthorizingBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' ");	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][8]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#B5B89A' cellPadding='0' width='100%' align='center' bordercolorlight='#FFFFFF'  border='1'>");
	   out.println("<tr bgcolor='#CCCC99'>");
	   out.println("<td nowrap>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>
	   <%
	   out.println("</td>");
	   out.println("<td>項次</td>");
	   out.println("<td>");	  
	   out.println("說明(Comment)</td><td>收料單(異動明細)</td><td nowrap>供應商進料批號</td><td>台半料號</td><td>收料數量</td><td>單位</td><td>收料日期</td><td>備註</td>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   { sqlEst =  "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";  }
       else if  (UserRoles.indexOf("PUR_ALL_MGR")>=0 ) 
             {  
	           sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";  }
	   else if  (UserRoles.indexOf("PUR_MGR")>=0 ) 
             {  
	          sqlEst = "select b.LINE_NO, b.SUPPLIER_LOT_NO, b.RECEIPT_NO, b.INV_ITEM, b.INV_ITEM_DESC, b.RECEIPT_QTY, b.UOM, b.RECEIPT_DATE, b.INSPECT_REMARK, b.SAMPLE_QTY, b.INSPECT_QTY, b.INSPECT_DATE, b.COMMENTS, b.SHIPMENT_LINE_ID  "+
			           "  from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b  "+
				       " where a.INSPLOT_NO = b.INSPLOT_NO and b.INSPLOT_NO='"+inspLotNo+"'  and b.LSTATUSID = '"+frStatID+"' and a.IQC_CLASS_CODE !='04' order by b.LINE_NO "; }
       else if  (UserRoles.indexOf("PUR_OUT_MGR")>=0 ) 
             {  
	          sqlEst = "select b.LINE_NO, b.SUPPLIER_LOT_NO, b.RECEIPT_NO, b.INV_ITEM, b.INV_ITEM_DESC, b.RECEIPT_QTY, b.UOM, b.RECEIPT_DATE, b.INSPECT_REMARK, b.SAMPLE_QTY, b.INSPECT_QTY, b.INSPECT_DATE, b.COMMENTS, b.SHIPMENT_LINE_ID  "+
			           "  from  ORADDMAN.TSCIQC_LOTINSPECT_HEADER a, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b  "+
				       " where a.INSPLOT_NO = b.INSPLOT_NO and b.INSPLOT_NO='"+inspLotNo+"'  and b.LSTATUSID = '"+frStatID+"' and a.IQC_CLASS_CODE = '04' order by b.LINE_NO "; }
       else { 
	           sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
			}
	   //out.print("<BR>sqlEst="+sqlEst);
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   {//out.println("0"); 
	      // 找Oracle Deliver 的Transaction Type_起
		      String recList = "";
			  int listCNT = 1;
		      Statement stateDlvr=con.createStatement();
			  //out.println("select TRANSACTION_TYPE from RCV_TRANSACTIONS where ATTRIBUTE6 = '"+inspLotNo+"' and VENDOR_LOT_NUM = '"+rs.getString("SUPPLIER_LOT_NO")+"' and SHIPMENT_LINE_ID = '"+rs.getString("SHIPMENT_LINE_ID")+"' ");
              ResultSet rsDlvr=stateDlvr.executeQuery("select TRANSACTION_TYPE, TRANSACTION_DATE from RCV_TRANSACTIONS where VENDOR_LOT_NUM = '"+rs.getString("SUPPLIER_LOT_NO")+"' and SHIPMENT_LINE_ID = '"+rs.getString("SHIPMENT_LINE_ID")+"' order by TRANSACTION_DATE ");	
		      while (rsDlvr.next())
			  {
			    listCNT++;
				if (listCNT==1)
				{
			      recList = recList+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
				} else if (listCNT==2)
				       {
					     recList = recList+"&nbsp;&nbsp;"+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					   } else {
					            recList = recList+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					          }
			  }
			  rsDlvr.close();
			  stateDlvr.close();
		  // 找Oracle Deliver 的Transaction Type_迄  
	   
	   
	    out.print("<TR bgcolor='#CCCC99'>");		
		out.println("<TD width='1%'><div align='center'>");
		
		out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{  //out.println("111"); 
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  }
		  if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定生產日期即設定欲結轉
		} else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
		if (rowLength==1) out.println("checked >"); 	else out.println(" >");		
		out.println("</div></TD>");
		out.println("<TD nowrap>");
		out.print(rs.getString("LINE_NO")+"</TD>");
		out.print("<TD nowrap><INPUT TYPE='button' value='Set' onClick='setSubmitComment("+'"'+"../jsp/TSIQCInspectLotAuthorizingPage.jsp?INSPLOTNO="+inspLotNo+"&LINE_NO="+rs.getString("LINE_NO")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");
		
		//out.println(comment);
		if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) // 若是處理項次,則予此次給定comments
		{ out.print("<input name='COMMENT"+rs.getString("LINE_NO")+"' type='text' value='"+comment+"' size=30>"); }
		else { 
		      if (rs.getString("COMMENTS")==null)
			    out.print("<input name='COMMENT"+rs.getString("LINE_NO")+"' type='text' value='' size=30>");  
			  else out.print("<input name='COMMENT"+rs.getString("LINE_NO")+"' type='text' value='"+rs.getString("COMMENTS")+"' size=30>"); 
			 }		
		  
		out.println("</TD>");
		
		out.println("<TD nowrap>");
		%><a onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=recList%>")'>
		<% out.print(rs.getString("RECEIPT_NO")+"</a></TD>");
		
		out.println("<TD nowrap>"+rs.getString("SUPPLIER_LOT_NO")+"</TD><TD nowrap>"+rs.getString("INV_ITEM_DESC")+"</TD><TD nowrap>"+rs.getString("RECEIPT_QTY")+"</TD><TD nowrap>"+rs.getString("UOM")+"</TD><TD nowrap>"+rs.getString("RECEIPT_DATE")+"</TD><TD nowrap>"+rs.getString("INSPECT_REMARK")+"</TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("INV_ITEM");b[k][2]=rs.getString("RECEIPT_QTY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("RECEIPT_DATE");b[k][5]=rs.getString("SUPPLIER_LOT_NO");b[k][6]=rs.getString("INSPECT_REMARK");		 
		 b[k][7]=rs.getString("COMMENTS");
		 arrIQC2DAuthorizingBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && comment!=null && !comment.equals(""))
	    { //out.println("COMMENT UPDATE="+comment);
		  
	      String sql = "update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set COMMENTS=? where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+lineNo+"' ";
		  //out.println("sql="+sql);
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,comment);  // 設定其為備註更新
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=arrIQC2DAuthorizingBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		      //out.println(a[0][0]+""+a[0][1]+""+a[0][2]+""+a[0][3]+""+a[0][4]+"<BR>"); 
		 }	//enf of a!=null if		
		
    %>      
  </tr>       
</table>
<%
    try
	{
	    Statement stateResult=con.createStatement();
        ResultSet rsResult=stateResult.executeQuery("select DISTINCT LOT_RESULTS from ORADDMAN.TSCIQC_LOTEXAMINE_DETAIL where INSPLOT_NO='"+inspLotNo+"' ");
		if (rsResult.next())
		{
		    result = rsResult.getString("LOT_RESULTS");
		}
		rsResult.close();
		stateResult.close();
	
	}//end of try	
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }	
	 
%>
<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->         
		<!--%
		           try
                   {       
                     Statement statement=con.createStatement();
                     ResultSet rs=statement.executeQuery("select RESULT_ID,RESULT_DESC from ORADDMAN.TSCIQC_RESULT order by RESULT_ID");
                     checkBoxBean.setRs(rs);
                     if (result != null) {}
					 else result = resultID;
   	                 checkBoxBean.setChecked(result);
	                 checkBoxBean.setFieldName("RESULT");	   
	                 checkBoxBean.setColumn(1); //傳參數給bean以回傳checkBox的列數
                     out.println(checkBoxBean.getRsString());
	                 statement.close();
                     rs.close();       
                   } //end of try
                   catch (Exception e)
                   {
                    out.println("Exception:"+e.getMessage());
                   }	
		%-->	   
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">             
  <tr bgcolor="#CCCC99"> 
      <td colspan="5">不良原因說明: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="LINE_NO" SIZE=60 value="<%=line_No%>" >           
     </td>
    </tr>          
</table>
<BR>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {  
	   //out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select x1.ACTIONID, decode(x2.ACTIONNAME,'021','REMOVE',x2.ACTIONNAME)from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' order by 2");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSIQCInspectLotAuthorizingPage.jsp?INSPLOTNO="+inspLotNo+'"'+")'>");				  				  
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
	   
	   
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   rs.next();
	   if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   {
         out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
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
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<%@ include file="/jsp/IQCInclude/MProcessStatusBarStop.jsp"%>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
