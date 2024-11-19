<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>RunCard Delete Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRCDeleteBean" scope="session" class="Array2DimensionInputBean"/>
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
function setSubmit1(URL,xdELCOMMENT)
{ //alert(); 
   if(xdELCOMMENT==null || xdELCOMMENT=="")
    {
	  alert("請輸入刪除原因!");
	  document.DISPLAYREPAIR.DELCOMMENT.focus();
	  document.DISPLAYREPAIR.ACTIONID.value="--";
	  return false;
	}
   
  document.DISPLAYREPAIR.action=URL;
  document.DISPLAYREPAIR.submit();
}
function setSubmit2(URL)
{ 
  var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit(URL,xWoQty,xWoRemark)
{ 
  alert(xWoQty+"   "+xWoRemark);  
  document.DISPLAYREPAIR.WOQTY.value=xWoQty;
  //document.DISPLAYREPAIR.WOREMARK.value=xWoRemark;
  document.DISPLAYREPAIR.UPDATEFLAG.value="Y";
  alert(document.DISPLAYREPAIR.WOREMARK.value+"  "+document.DISPLAYREPAIR.WOREMARK.value);
  document.DISPLAYREPAIR.action=URL+"&WO_QTY="+xWoQty+"&WO_REMARK="+xWoRemark;
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



</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
        String actionID = request.getParameter("ACTIONID"); 
	String statusID = request.getParameter("STATUSID");
        String woNo=request.getParameter("WO_NO"); 
	String runCardNo=request.getParameter("RUNCARD_NO"); 
        String marketType=request.getParameter("MARKETTYPE");
	String woType=request.getParameter("WOTYPE");
	String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
	String startDate=request.getParameter("STARTDATE");
	String endDate=request.getParameter("ENDDATE");
	String woQty=request.getParameter("WO_QTY");
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
    String updateFlag=request.getParameter("UPDATEFLAG");
    String runCardID=request.getParameter("RUNCARDID");
    double woQtyD=0; 
    String s1="",s2="",disableReason="";
	String delComment=request.getParameter("DELCOMMENT");
	 if (delComment==null || delComment.equals("")) delComment="";
	//String aMFGRCDeleteCode[][]=arrMFGRCDeleteBean.getArray2DContent();  	// FOR 流程卡已展開-> 流程卡刪除
        
     if (updateFlag==null || updateFlag.equals("")) updateFlag="N"; 
     int lineIndex = 1;	
       //if (runCardID!=null) lineIndex = Integer.parseInt(runCardID);
	 if (runCardID==null) runCardID = "0";
          else lineIndex = Integer.parseInt(runCardID);
	String queueQty=request.getParameter("QUEUEQTY"+Integer.toString(lineIndex));
	
        String [] check=request.getParameterValues("CHKFLAG");

%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgWoMProcess.jsp?WO_NO=<%=woNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
 <table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      流程卡明細 : <BR>
	  <%
	  try
        {   

            String oneDArray[]= {"工令號","流程卡號","料號","品名","流程卡數量","單位","展開日","展開人員"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	    arrMFGRCDeleteBean.setArrayString(oneDArray);
		// 先取 未投產流程卡筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(runcard_no) from apps.yew_runcard_all where statusid='042' and WO_NO='"+woNo+"'  ");
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
		 //out.println("rowLength="+rowLength);
	     rsCNT.close();
	     stateCNT.close();
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][8]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Item Desc";b[0][3]="QTY";b[0][4]="UOM";b[0][5]="WO_Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#B1A289' cellPadding='0' width='100%' align='center' bordercolorlight='#CCCC99'  border='1'>");
	   out.println("<tr bgcolor='#CCCC99'>");
	   out.println("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
         %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'> 
	   </td>
	   <td width="5%" align="center">Runcard ID</td>
	   <td width="10%" align="center">工令號</td>
	   <td width="12%" align="center">流程卡號</td>
	   <td width="16%" align="center">&nbsp;&nbsp;料號</td>
	   <td width="15%" align="center">&nbsp;&nbsp;品名</td>
	   <td width="8%" align="center">&nbsp;&nbsp;流程卡數量</td>
       <td nowrap width="10%" align="center">&nbsp;展開日</td>
       <td nowrap width="8%" align="center">&nbsp;展開人員</td>
	   <td nowrap width="5%" align="center">&nbsp;狀態</td>
         <%
	   int k=0;
	   //out.println("entityId="+entityId);
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) // 若是管理員,可設定任一項目為特採
	   { 
	      //sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";
		  sqlEst = " select YRA.RUNCAD_ID,YRA.WO_NO,YRA.RUNCARD_NO,YRA.LINE_NUM,YRA.INV_ITEM,YRA.ITEM_DESC,YRA.QTY_IN_QUEUE,YRA.WIP_ENTITY_ID,YRA.ORGANIZATION_ID,YRA.PRIMARY_ITEM_ID, "+
		  		   "        to_date(substr(YRA.CREATION_DATE,1,8),'YYYY/MM/DD') as CREATION_DATE,FU.USER_NAME ,YRA.STATUS  "+
				   "   from YEW_RUNCARD_ALL YRA , FND_USER FU where YRA.CREATE_BY=FU.USER_ID and YRA.STATUSID='042' and YRA.WO_NO='"+woNo+"' order by YRA.RUNCAD_ID desc  ";
	   }
	   else {   
	          //sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; 
		  sqlEst = " select YRA.RUNCAD_ID,YRA.WO_NO,YRA.RUNCARD_NO,YRA.LINE_NUM,YRA.INV_ITEM,YRA.ITEM_DESC,YRA.QTY_IN_QUEUE,YRA.WIP_ENTITY_ID,YRA.ORGANIZATION_ID,YRA.PRIMARY_ITEM_ID, "+
		  		   "        to_date(substr(YRA.CREATION_DATE,1,8),'YYYY/MM/DD') as CREATION_DATE,FU.USER_NAME ,YRA.STATUS  "+
				   "   from YEW_RUNCARD_ALL YRA , FND_USER FU where YRA.CREATE_BY=FU.USER_ID and YRA.STATUSID='042' and YRA.WO_NO='"+woNo+"' order by YRA.RUNCAD_ID desc  ";
			}
	   //out.println("sqlEst"+sqlEst); 
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);
     //out.println("updateFlag 1="+updateFlag+"<br>"); 	   
	   while (rs.next())
	   { 

	    out.print("<TR bgcolor='#CCCC99'>");		
		out.println("<TD width='1%'><div align='center'>");
		out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("RUNCAD_ID")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{  
		  for (int j=0;j<check.length;j++)
		   { if (check[j]==rs.getString("RUNCAD_ID") || check[j].equals(rs.getString("RUNCAD_ID"))) 
		      out.println("checked");  }
		  if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); // 給定生產日期即設定欲結轉
		} 
		else if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
		
		if (rowLength==1) out.println("checked >"); 	
		  else out.println(" >");	     	
		out.println("</div></TD>"); 
            %>
		<TD nowrap align="center"><%=rs.getString("RUNCAD_ID")%></TD>	
		<TD nowrap align="center"><%=rs.getString("WO_NO")%></TD>
		<TD nowrap align="center"><%=rs.getString("RUNCARD_NO")%></TD>
		<TD nowrap align="center"><%=rs.getString("INV_ITEM")%></TD>
		<TD nowrap align="center"><%=rs.getString("ITEM_DESC")%></TD>
		<TD nowrap align="center"><%=rs.getString("QTY_IN_QUEUE")%></TD>
		<TD nowrap align="center"><%=rs.getString("CREATION_DATE").substring(0,10)%></TD>
		<TD nowrap align="center"><%=rs.getString("USER_NAME")%></TD>
		<TD nowrap align="center"><%=rs.getString("STATUS")%></TD></tr>

        <%
		 b[k][0]=rs.getString("RUNCAD_ID");
		 b[k][1]=rs.getString("WO_NO");
		 b[k][2]=rs.getString("RUNCARD_NO");
		 b[k][3]=rs.getString("WIP_ENTITY_ID");
		 b[k][4]=rs.getString("ORGANIZATION_ID");
		 b[k][5]=rs.getString("PRIMARY_ITEM_ID");
		 b[k][6]=rs.getString("QTY_IN_QUEUE");
		 b[k][7]=rs.getString("LINE_NUM");
	/*	 b[k][8]=rs.getString("ORGANIZATION_ID");
        */
		 arrMFGRCDeleteBean.setArray2DString(b);
		 k++;
	   }    //end of while	   	   	 
	%>
	    <tr>
		  <td  nowrap align="right">刪除原因</td>
		  <td colspan="3"><INPUT TYPE='text' NAME='DELCOMMENT' size=40 value="<%=delComment%>"></td>
		  <td colspan="6">&nbsp;</td>
		</tr>
	</TABLE>	
	<%
	   statement.close();
           rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	 /*  
	    if (woNo!=null && woQty!=null && !woQty.equals(""))
	    { //out.println("COMMENT UPDATE="+comment);
		  
	      String sql = "update APPS.YEW_WORKORDER_ALL set WO_QTY=?,WO_REMARK=? where WO_NO='"+woNo+"' ";
	      //out.println("sql="+sql);
	      PreparedStatement pstmt=con.prepareStatement(sql);  
              pstmt.setString(1,woQty);  //  
              pstmt.setString(2,woRemark);  // 
	      pstmt.executeUpdate(); 
              pstmt.close();
             }
        */
  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception 3:"+e.getMessage());
       }
	   
	     String b[][]=arrMFGRCDeleteBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
		
    %> 
   
  </tr>       
</table>
<!--%

<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->

<BR>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {    //out.println("frStatID="+frStatID);
	   //out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
       Statement statement=con.createStatement();
 //此功能為改單,不允許"Generate runcard ,故把action id '020'排除"
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID ='021' and  x1.LOCALE='"+locale+"'");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());	   
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgRCDelete.jsp?WO_NO="+woNo+'"'+",this.form.DELCOMMENT.value)'>");			  				  
	   out.println("<OPTION VALUE=-->--");     
	   while (rs.next())
	   {            
		 s1=(String)rs.getString(1); 
		 s2=(String)rs.getString(2); 
              if (s1.equals(actionID)) 
  	           {
                   out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
                } else {
                   out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  } 
	   } //end of while
	   out.println("</select>"); 
          if(actionID=="021" || actionID.equals("021"))
           {
          %>
	    <script LANGUAGE="JavaScript">
	      alert("此動作會一併刪除工令數量");
	    </script>
          <%
           }
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
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
        out.println("Exception 4:"+e.getMessage());
       }
       %></a></td></tr></table> 


<!-- 表單參數 --> 
<INPUT type="hidden" SIZE=5 name="RUNCARD_NO" value="<%=runCardNo%>" readonly>
<INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
<INPUT type="hidden" SIZE=5 name="ALTERNATEROUTING" value="<%=alternateRouting%>" readonly>
<input name="UPDATEFLAG" type="HIDDEN" value="<%=updateFlag%>">


</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
