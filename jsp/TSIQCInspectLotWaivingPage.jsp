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
<jsp:useBean id="arrIQC2DWaivingBean" scope="session" class="Array2DimensionInputBean"/>
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
      else if (document.DISPLAYREPAIR.ACTIONID.value =="017" && document.DISPLAYREPAIR.WAIVENO.value=="")    // 如為特採,卻未給定特採核可編號,警告訊息
      {
        alert("選擇特採需輸入特採編號!");
	    document.DISPLAYREPAIR.WAIVENO.focus();		
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
	  
  } // End of flag = true 確認要送出
 return(true);
}
function setSubmit1(URL)
{ //alert();
  var linkURL = "#ACTION";
  formWAIVELOT = "document.DISPLAYREPAIR.WAIVELOT.focus()";
  formWAIVELOT_Write = "document.DISPLAYREPAIR.WAIVELOT.value";
  xWAIVELOT = eval(formWAIVELOT_Write);  // 把值取得給java script 變數 
 // alert("xWAIVELOT ="+xWAIVELOT);
  
  document.DISPLAYREPAIR.WAIVELOT.value = xWAIVELOT;
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit2(URL)
{ 
  var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  document.DISPLAYREPAIR.submit();    
}
function setSubmitWaiveNo(URL,xINDEX)
{
  var linkURL = "#ACTION";  
  formWAIVENO = "document.DISPLAYREPAIR.WAIVENO"+xINDEX+".focus()";
  formWAIVENO_Write = "document.DISPLAYREPAIR.WAIVENO"+xINDEX+".value";
  xWAIVENO = eval(formWAIVENO_Write);  // 把值取得給java script 變數
  
  //document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.action=URL+"&WAIVENO"+xINDEX+"="+xWAIVENO+"&LINENO="+xINDEX+linkURL;
  document.DISPLAYREPAIR.submit();    

}

</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
   String inspLotNo=request.getParameter("INSPLOTNO");
   //String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   String lineNo=request.getParameter("LINENO");
   String waiveItem=request.getParameter("WAIVEITEM");
   String waiveLotAll=request.getParameter("WAIVELOT"); 
   String actionID = request.getParameter("ACTIONID");   
   String remark = request.getParameter("REMARK");   
   String line_No=request.getParameter("LINE_NO");
   String recUserID=request.getParameter("RECUSERID");
   String statusID=request.getParameter("STATUSID");
   
   int lineIndex = 1;
   if (line_No!=null) lineIndex = Integer.parseInt(line_No);   
   String waiveNo=request.getParameter("WAIVENO"+Integer.toString(lineIndex));
   
   String waiveNoH=request.getParameter("WAIVENO");
   
   
   String [] check=request.getParameterValues("CHKFLAG");
   
   if (lineNo==null) { lineNo="";}
   //if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   
   if (waiveItem==null) waiveItem="N";  // 若未指定,預設為 N 非特採項目
   if (waiveNoH==null) waiveNoH="";  // 若未指定,預設為 N 非特採項目
   if (waiveNo==null) waiveNo="";
   
   
   //out.println("waiveNo="+waiveNo);
%>
<body>
<%@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<BR>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否確認送出","請選擇執行動作","選擇特採需輸入特採編號!")' ACTION="../jsp/TSIQCInspectLotMProcess.jsp?INSPLOT_NO=<%=inspLotNo%>" METHOD="post">
<!--=============以下區段為取得IQC檢驗批基本資料==========-->
<%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%>
<!--=================================-->
<table cellSpacing="0" bordercolordark="#B5B89A" cellPadding="0" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      處理內容明細 
      : <font color="#FF0000">如下為批退內容</font><BR>
    <%
	  try
      {   
	    String oneDArray[]= {"項次","特採核准編號","台半料號","收料數量","單位","收料日期","供應商進料批號","備註"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	arrIQC2DWaivingBean.setArrayString(oneDArray);
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
	   out.print("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>
	   <%
	   out.println("</td>");
	   out.println("<td>項次</td>");
	   out.println("<td>");	  
	   out.println("特採核准編號</td><td>供應商進料批號</td><td>台半料號</td><td>收料單號</td><td>收料數量</td><td>單位</td><td>收料日期</td><td>備註</td>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   { sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, LWAIVE_NO, SHIPMENT_LINE_ID, RECEIPT_NO from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   else {   
	          sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, LWAIVE_NO, SHIPMENT_LINE_ID, RECEIPT_NO from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
			}
	   //out.print("<br>sqlEst="+sqlEst);
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
		
		out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{  out.println("111"); 
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  }
		  if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定生產日期即設定欲結轉
		} else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
		if (rowLength==1) out.println("checked >"); else out.println(" >");		
		out.println("</div></TD>");      
		
		out.println("<TD>");
		out.println(rs.getString("LINE_NO")+"</TD>");
		
		out.print("<TD><INPUT TYPE='button' value='Set' onClick='setSubmitWaiveNo("+'"'+"../jsp/TSIQCInspectLotWaivingPage.jsp?INSPLOTNO="+inspLotNo+"&LINE_NO="+rs.getString("LINE_NO")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");		
		//out.println(comment);
		if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) // 若是處理項次,則予此次給定comments
		{ out.print("<input name='WAIVENO"+rs.getString("LINE_NO")+"' type='text' value='"+waiveNo+"' size=10>"); }
		else { 
		      if (rs.getString("LWAIVE_NO")==null)
			    out.print("<input name='WAIVENO"+rs.getString("LINE_NO")+"' type='text' value='' size=10>");  
			  else out.print("<input name='WAIVENO"+rs.getString("LINE_NO")+"' type='text' value='"+rs.getString("LWAIVE_NO")+"' size=10>"); 
			 }				  
		out.println("</TD>");
		
		//out.print("<TD><input name='WAIVEITEM' type='text' value='A001'>");
		//out.println("</TD>");
		out.println("<TD nowrap>");
		%><a onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=recList%>")'>
		<% out.print(rs.getString("SUPPLIER_LOT_NO")+"</a></TD>");
		//out.println("<TD>"+rs.getString("SUPPLIER_LOT_NO")+"</TD>");
		
		out.println("<TD>"+rs.getString("INV_ITEM_DESC")+"</TD><TD>"+rs.getString("RECEIPT_NO")+"</TD><TD>"+rs.getString("RECEIPT_QTY")+"</TD><TD><font size='2'>"+rs.getString("UOM")+"</TD><TD>"+rs.getString("RECEIPT_DATE")+"</TD><TD>"+rs.getString("INSPECT_REMARK")+"</TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("INV_ITEM");b[k][2]=rs.getString("RECEIPT_QTY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("RECEIPT_DATE");b[k][5]=rs.getString("SUPPLIER_LOT_NO");b[k][6]=rs.getString("INSPECT_REMARK");	
		 b[k][7]=rs.getString("LWAIVE_NO");	 
		 arrIQC2DWaivingBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && waiveNo!=null && !waiveNo.equals(""))
	    {
	      String sql = "update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LWAIVE_NO=? where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+lineNo+"' ";
		  //out.println("sql="+sql);
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,waiveNo);  // 設定其為特採項目
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception 1:"+e.getMessage());
       }
	   
	     String a[][]=arrIQC2DWaivingBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		       
		 }	//enf of a!=null if		
		
    %>      
  </tr>       
</table>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="1">       
  <tr bgcolor="#CCCC99">
	   <td nowrap="nowrap" width="10%">本批皆為特採項目</td>
	   <td colspan="4">
	     <select name="WAIVELOT">
	       <option value="<%if (waiveLotAll==null || waiveLotAll.equals("")) out.print(""); else  out.print("Y"); %>">Y(是)</option>
	       <option value="<%if (waiveLotAll==null || waiveLotAll.equals("")) out.print("N");else  out.print(waiveLotAll); %>" selected>N(否)</option>
	     </select>
	   </td>
	   <td>特採編號</td>
	   <td><INPUT TYPE="TEXT" NAME="WAIVENO" SIZE=20 maxlength="30" value="<%=waiveNoH%>"></td>
	</tr>
    <tr bgcolor="#CCCC99"> 
      <td colspan="7">本次處理備註: 
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
       ResultSet rs=statement.executeQuery("select x1.ACTIONID, decode(x2.ACTIONNAME,'AGREE','REJECT','APPLY','WAIVE',x2.ACTIONNAME) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' order by x2.ACTIONNAME DESC");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSIQCInspectLotWaivingPage.jsp?INSPLOTNO="+inspLotNo+'"'+")'>");  			  				  
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
        out.println("Exception 2:"+e.getMessage());
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
