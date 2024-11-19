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
<jsp:useBean id="arrIQC2DReturningBean" scope="session" class="Array2DimensionInputBean"/>
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
      else if (document.DISPLAYREPAIR.ACTIONID.value =="019" && document.DISPLAYREPAIR.SUBINVENTORY.value=="")    // 如為入庫倉別,警告訊息
      {
        alert("             未選擇退庫倉別資訊!!!\n如請購單已選擇預設入庫倉別需選擇退庫倉別");
	    //document.DISPLAYREPAIR.SUBINVCH.focus();		
	    //return(false);
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
	  
  } // End of flag = true 確認要送出
  return(true);  
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
function subWindowSubInventoryFind(organizationID,subInv,subInvDesc)
{    
  //subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,scrollbars=yes");  
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
   String subInventory=request.getParameter("SUBINVENTORY");
   String subInvDesc=request.getParameter("SUBINVDESC");
   
    //String comment=request.getParameter("COMMENT");
   int lineIndex = 1;
   if (line_No!=null) lineIndex = Integer.parseInt(line_No);
   String comment=request.getParameter("COMMENT"+Integer.toString(lineIndex));
   
   String [] check=request.getParameterValues("CHKFLAG");
   
   if (lineNo==null) { lineNo="";}
   //if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   
   if (comment==null) comment="";  // 若未指定,預設為 ""
   
   if (subInventory==null) { subInventory="";}
   if (subInvDesc==null) { subInvDesc="";}
   
   
   
%>
<body>
<%@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<BR>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSIQCInspectLotMProcess.jsp?INSPLOT_NO=<%=inspLotNo%>" METHOD="post">
<!--=============以下區段為取得IQC檢驗批基本資料==========-->
<%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%>
<!--=================================-->
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      內容明細
      : <BR>
    <!--%
	  try
      {   
	    String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	array2DArrangedFactoryBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' ");	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][7]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#99CCFF'  cellPadding='1' width='100%' align='center' borderColorLight='#ffEEff' border='1'>");
	   out.println("<tr>");
	   out.println("<td>");	  
	   out.println("<font size='2'>Line</font></td><td><font size='2'>Ordered Item</font></td><td><font size='2'>Item Description</font></td><td><font size='2'>Qty</font></td><td><font size='2'>UOM</font></td><td><font size='2'>Request Date</font></td><td><font size='2'>Remark</font></td>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可指派任一廠區交期
	   { sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   else {   
	          sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' order by LINE_NO"; 
			}
	   
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   {//out.println("0"); 
	    out.print("<TR>");		
		out.println("<TD><font size='2'>");
		out.println(rs.getString("LINE_NO")+"</font></TD><TD><font size='2'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font size='2'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font size='2'>"+rs.getString("QUANTITY")+"</font></TD><TD><font size='2'>"+rs.getString("UOM")+"</font></TD><TD><font size='2'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD><TD><font size='2'>"+rs.getString("REMARK")+"</font></TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("ITEM_SEGMENT1");b[k][2]=rs.getString("QUANTITY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("REQUEST_DATE");b[k][5]=rs.getString("REMARK");b[k][6]=rs.getString("PCACPDATE");		 
		 array2DArrangedFactoryBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && pcAcceptDate!=null)
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set PCACPDATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,pcAcceptDate+dateBean.getHourMinuteSecond());  // 工廠交期安排
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=array2DArrangedFactoryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		       
		 }	//enf of a!=null if		
		
    %--> </font>      
  </tr>       
</table>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">       
   <tr bgcolor="#CCCC99"> 
     <td width="10%" nowrap>由Sub-Inventory退料:</td>
	 <td>
        <INPUT TYPE="TEXT" NAME="SUBINVENTORY" SIZE=5 value="<%=subInventory%>">
		<input type='button' name='SUBINVCH' value='...' onClick='subWindowSubInventoryFind(<%=organizationID%>,this.form.SUBINVENTORY.value,this.form.SUBINVDESC.value)'>
		<INPUT TYPE="TEXT" NAME="SUBINVDESC" SIZE=40 value="<%=subInvDesc%>">               
     </td>
   </tr>
</table>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      處理內容明細
      : <BR>
    <%
	  try
      {   
	    String oneDArray[]= {"項次","說明","台半料號","收料數量","單位","收料日期","供應商進料批號","備註"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	arrIQC2DReturningBean.setArrayString(oneDArray);
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
	   out.println("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>
	   <%
	   out.println("</td>");
	   out.println("<td nowrap>項次</td>");
	   out.println("<td width='10%' nowrap>");	  
	   out.println("說明(Comment)</td><td nowrap>收料單(異動明細)</td><td nowrap>供應商進料批號</td><td nowrap>台半料號</td><td nowrap>收料數量</td><td nowrap>單位</td><td nowrap>收料日期</td><td nowrap>備註</td>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   { sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   else {   
	          sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
			}
	   //out.print("<br>sqlEst"+sqlEst);
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
		out.print("<TD width='10%' nowrap><INPUT TYPE='button' value='Set' onClick='setSubmitComment("+'"'+"../jsp/TSIQCInspectLotReturningPage.jsp?INSPLOTNO="+inspLotNo+"&LINE_NO="+rs.getString("LINE_NO")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");
		
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
		 arrIQC2DReturningBean.setArray2DString(b);
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
	   
	     String a[][]=arrIQC2DReturningBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		       
		 }	//enf of a!=null if		
		
    %> </font>      
  </tr>       
</table>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">       
  <tr bgcolor="#CCCC99"> 
      <td colspan="3">處理備註: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 >           
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
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSIQCInspectLotReturningPage.jsp?INSPLOTNO="+inspLotNo+'"'+")'>");				  				  
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
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
 <%@ include file="/jsp/IQCInclude/MProcessStatusBarStop.jsp"%>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
