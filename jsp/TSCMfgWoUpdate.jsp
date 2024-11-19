<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>Work Order Update Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGWoUpdateBean" scope="session" class="Array2DimensionInputBean"/>
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

function setSubmit1(URL,xWOQTY,xSELFLAG)
{ 
	if (xWOQTY<="0")
	{
		alert("工令數量不正確!!");
		document.DISPLAYREPAIR.WOQTY.focus();
		document.DISPLAYREPAIR.ACTIONID.value="--";
		return false;
	}	  

	if (xSELFLAG=="N")
	{
		alert("請按Set更新資料!!");
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

function setSubmitComment(URL,xWOQTY)
{   

	var linkURL = "#ACTION";  
	formWOREMARK = "document.DISPLAYREPAIR.WOREMARK.focus()";
	formWOREMARK_Write = "document.DISPLAYREPAIR.WOREMARK.value";
	xWOREMARK = eval(formWOREMARK_Write);  // 把值取得給java script 變數

	formWOQTY = "document.DISPLAYREPAIR.WOQTY.focus()";
	formWOQTY_Write = "document.DISPLAYREPAIR.WOQTY.value";
	xWOQTY = eval(formWOQTY_Write);  // 把值取得給java script 變數
	//alert(xWOQTY);

	formSTARTDATE = "document.DISPLAYREPAIR.STARTDATE.focus()";
	formSTARTDATE_Write = "document.DISPLAYREPAIR.STARTDATE.value";
	xSTARTDATE = eval(formSTARTDATE_Write);  // 把值取得給java script 變數 

	formENDDATE = "document.DISPLAYREPAIR.ENDDATE.focus()";
	formENDDATE_Write = "document.DISPLAYREPAIR.ENDDATE.value";
	xENDDATE = eval(formENDDATE_Write);  // 把值取得給java script 變數   

	//alert(xWOREMARK+"   "+xWOQTY+"   "+xSTARTDATE+"   "+xENDDATE);
	//document.DISPLAYREPAIR.action=URL+linkURL;
	// document.DISPLAYREPAIR.action=URL+"&COMMENT"+xINDEX+"="+xCOMMENT+"&LINENO="+xINDEX+linkURL;
	document.DISPLAYREPAIR.SETFLAG.value="Y";
	document.DISPLAYREPAIR.action=URL+"&WOQTY="+xWOQTY+"&STARTDATE="+xSTARTDATE+"&ENDDATE="+xENDDATE+"&WOREMARK="+xWOREMARK;   //liling
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
String s1="",s2="",disableReason="";
String setFlag=request.getParameter("SETFLAG");
if (setFlag==null || setFlag.equals("")) setFlag="N";

int lineIndex = 1;	
//if (runCardID!=null) lineIndex = Integer.parseInt(runCardID);
String queueQty=request.getParameter("QUEUEQTY"+Integer.toString(lineIndex));

String [] check=request.getParameterValues("CHKFLAG");

String woQtySet=request.getParameter("WOQTY");
String startDateSet=request.getParameter("STARTDATE");
String endDateSet=request.getParameter("ENDDATE");
String woRemarkSet=request.getParameter("WOREMARK");

String WOStatID = "Fail";


%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%//@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgWoMProcess.jsp?WO_NO=<%=woNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
<tr bgcolor="#CCCC99"> 
<td colspan="3">
<font color="#000066">工令明細 :</font> <BR>
<%
try
{   


	if (woRemarkSet==null || woRemarkSet.equals("null")) woRemarkSet="";
	if (woRemark==null || woRemark.equals("null")) woRemark="";
	String oneDArray[]= {"工令號","生產數量","預計投入日","預計生產日","備註"};  // 先將內容明細的標頭,給一維陣列		 	     			  
	arrMFGWoUpdateBean.setArrayString(oneDArray);

	// 取得目前工令狀態 Add by SHIN 20090721
	Statement stateSQL=con.createStatement();
	ResultSet rsSQL=stateSQL.executeQuery("select statusid from YEW_WORKORDER_ALL where WO_NO='"+woNo+"'  ");	
	if (rsSQL.next()) WOStatID = rsSQL.getString("statusid");
	rsSQL.close();
	rsSQL.close();

	// 先取 該工令筆數
	int rowLength = 0;
	Statement stateCNT=con.createStatement();
	ResultSet rsCNT=stateCNT.executeQuery("select count(WO_NO) from YEW_WORKORDER_ALL where WO_NO='"+woNo+"'  ");	
	if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	rsCNT.close();
	stateCNT.close();

	//choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	String b[][]=new String[rowLength+1][5]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)

	//array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	//b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Item Desc";b[0][3]="QTY";b[0][4]="UOM";b[0][5]="WO_Remark";b[0][6]="Product Manufactory";
	out.println("<TABLE cellSpacing='0' bordercolordark='#B1A289' cellPadding='0' width='100%' align='center' bordercolorlight='#CCCC99'  border='1'>");
	out.println("<tr bgcolor='#CCCC99'>");
	out.println("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
%>
<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'> 
<%
	out.println("</td>");
	out.println("<td>");	  
	out.println("工令編號</td><td>料號</td><td>品名</td><td>生產數量</td><td>單位</td><td>預計生產日</td><td>預計完成日</td><td>備註</td><td>Set</td>");    
	int k=0;

	String sqlEst = "";
	if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	{ 
		//sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";
		sqlEst = " select WORKORDER_ID, WO_NO, INV_ITEM, ITEM_DESC, WO_QTY, WO_UOM, WO_REMARK, OE_ORDER_NO, "+
				"        substr(SCHEDULE_STRART_DATE,1,8) STARTDATE, "+
				"        substr(SCHEDULE_END_DATE,1,8) ENDDATE  "+
				"   from APPS.YEW_WORKORDER_ALL  where WO_NO='"+woNo+"' ";
	}
	else {   
		//sqlEst = "select LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' order by LINE_NO"; 
		sqlEst = " select WORKORDER_ID, WO_NO, INV_ITEM, ITEM_DESC, WO_QTY , WO_UOM, WO_REMARK, OE_ORDER_NO, "+
				"        Substr(Schedule_strart_date,1,8) Startdate, "+
				"        Substr(Schedule_end_date,1,8) Enddate  "+
				"   From Apps.Yew_workorder_all  Where Wo_no='"+woNo+"' ";
	}
// out.println("0=="+sqlEst); 


	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sqlEst);
	while (rs.next())
	{ 
		startDate=rs.getString("STARTDATE");
		endDate=rs.getString("ENDDATE");
		woRemark=rs.getString("WO_REMARK");
		woQty=rs.getString("WO_QTY");
		woRemark=rs.getString("WO_REMARK");
		if (woRemark==null || woRemark.equals("")) woRemark="";

		out.print("<TR bgcolor='#CCCC99'>");		
		out.println("<TD width='1%'><div align='center'>");

		out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("WO_NO")+"' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{  //out.println("111"); 
			for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("WO_NO") || check[j].equals(rs.getString("WO_NO"))) out.println("checked");  }
			if (woNo==rs.getString("WO_NO") || woNo.equals(rs.getString("WO_NO"))) out.println("checked"); // 給定生產日期即設定欲結轉
		} else if (woNo==rs.getString("WO_NO") || woNo.equals(rs.getString("WO_NO"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
		if (rowLength==1) out.println("checked >");
		else out.println(" >");	     	
		out.println("</div></TD>"); 
		out.println("<TD nowrap>"+rs.getString("WO_NO")+"</TD><TD nowrap>"+rs.getString("INV_ITEM")+"</TD><TD nowrap>"+rs.getString("ITEM_DESC")+"</TD>");


%>
<TD nowrap><INPUT TYPE='text' NAME="WOQTY" size=4 value="<% if (woQtySet==null || woQtySet.equals("")) out.print(rs.getString("WO_QTY")); else out.print(woQtySet); %>"></TD>
<TD nowrap><%=rs.getString("WO_UOM")%></TD>
<TD><input name='STARTDATE' type='text' size='8' value="<% if(startDateSet==null || startDateSet.equals("")) out.print(rs.getString("STARTDATE")); else out.print(startDateSet);%>" readonly>
<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.DISPLAYREPAIR.STARTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></a></td>
<TD><input name='ENDDATE' type='text' size='8' value="<% if(endDateSet==null || endDateSet.equals("")) out.print(rs.getString("ENDDATE")); else out.print(endDateSet);%>" readonly>
<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.DISPLAYREPAIR.ENDDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></a></td>							
<TD nowrap>&nbsp;<INPUT TYPE='text' NAME='WOREMARK' size=20 value="<% if (woRemarkSet==null || woRemarkSet.equals("")) out.print(woRemark); else out.print(woRemarkSet); %>"></TD>
<%
		out.print("<TD nowrap><INPUT TYPE='button' value='Set' onClick='setSubmitComment("+'"'+"../jsp/TSCMfgWoUpdate.jsp?WO_NO="+woNo+'"'+")'></TD></TR>");


		b[k][0]=rs.getString("WO_NO");
		if (woQtySet==null || woQtySet.equals("")) b[k][1]= rs.getString("WO_QTY");
		else b[k][1]=woQtySet;
		if (startDateSet==null || startDateSet.equals("")) b[k][2]= rs.getString("STARTDATE");
		else b[k][2]=startDateSet;	
		if (endDateSet==null || endDateSet.equals("")) b[k][3]= rs.getString("ENDDATE");
		else b[k][3]=endDateSet;	
		if (woRemarkSet==null || woRemarkSet.equals("")) b[k][4]= rs.getString("WO_REMARK");
		else b[k][4]=woRemarkSet;

		arrMFGWoUpdateBean.setArray2DString(b);
		k++;

	}    //end of while	   

	out.println("</TABLE>");
	statement.close();
	rs.close();  

	//out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	// if (woQtySet!=null && woRemarkSet!=null && startDateSet!=null && endDateSet!=null)
	if (setFlag=="Y" || setFlag.equals("Y"))
	{ 

		String sql = "update APPS.YEW_WORKORDER_ALL set WO_QTY=?,WO_REMARK=?,SCHEDULE_STRART_DATE=?,SCHEDULE_END_DATE=? where WO_NO='"+woNo+"' ";
		//out.println("<br>sql="+sql);
		PreparedStatement pstmt=con.prepareStatement(sql);  
		pstmt.setString(1,woQtySet);      //  
		pstmt.setString(2,woRemarkSet);   // 
		pstmt.setString(3,startDateSet);  // 
		pstmt.setString(4,endDateSet);    // 
		pstmt.executeUpdate(); 
		pstmt.close();

		String sqla = "update APPS.YEW_MFG_TRAVELS_ALL set EXTENDED_QTY=? ,LAST_UPDATE_DATE=?, LAST_UPDATED_BY=? where EXTEND_NO = '"+woNo+"' ";
		//out.println("<br>sql="+sql);
		PreparedStatement pstmta=con.prepareStatement(sqla);  
		pstmta.setString(1,woQtySet);      //  
		pstmta.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());      //  
		pstmta.setString(3,userMfgUserID);      //  			   
		pstmta.executeUpdate(); 
		pstmta.close();

		//out.println("<br>WOStatID.equals(\"058\")="+WOStatID.equals("058"));
		//========工令確認退回修改...起 add by SHIN20090713
		if (WOStatID.equals("058"))   // 
		{  

			//取得ERP_USER_ID
			String ERPUserID = "";
			Statement getERPID=con.createStatement();  
			ResultSet getERPIDRs=getERPID.executeQuery("SELECT ERP_USER_ID FROM oraddman.wsuser WHERE username = '"+UserName+"' ");  
			if (getERPIDRs.next())
			{
				ERPUserID = getERPIDRs.getString("ERP_USER_ID");
			}
			getERPIDRs.close();
			getERPID.close();

			//修改工令狀態到040, CREATING, by SHIN20090713
			String woSql=" update APPS.YEW_WORKORDER_ALL set STATUSID=?,STATUS=?,LAST_UPDATE_DATE=?,LAST_UPDATED_BY=? "+
						" where WO_NO= '"+woNo+"' "; 	
			PreparedStatement woStmt=con.prepareStatement(woSql);
			woStmt.setString(1,"040"); 
			woStmt.setString(2,"CREATING");
			woStmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
			woStmt.setInt(4,Integer.parseInt(ERPUserID));
			woStmt.executeUpdate();   
			woStmt.close(); 
			//out.println("<BR>Update!!");

		}
		//========工令確認退回修改...迄 add by SHIN20090713
	
	}


} //end of try
catch (Exception e)
{
	out.println("Exception 4:"+e.getMessage());
}

String a[][]=arrMFGWoUpdateBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
if (a!=null) 
{		  
	// out.println(b[0][0]+""+b[0][1]+""+b[0][2]+""+b[0][3]+""+b[0][4]+"<BR>"); 
}	//enf of a!=null if		

%> 

</tr>       
</table>

<!--%
try
{ 

%-->


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
	//排除PASS & REJECT actionid '029''005'
	ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID not in ('020','005','029') and  x1.LOCALE='"+locale+"'");
	//comboBoxBean.setRs(rs);
	//comboBoxBean.setFieldName("ACTIONID");	   
	//out.println(comboBoxBean.getRsString());	   
	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgWoUpdate.jsp?WO_NO="+woNo+'"'+",this.form.WOQTY.value,this.form.SETFLAG.value"+")'>");			  				  
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
alert("此動作會刪除工令");	
</script>	
<%
	}
	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	rs.next();
	if (rs.getInt(1)>0 ) //判斷若沒有動作可選擇就不出現submit按鈕
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
<INPUT type="hidden" SIZE=5 name="SETFLAG" value="<%=setFlag%>" readonly>
<INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
