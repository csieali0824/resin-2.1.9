<!-- 20151229 by Peggy,增加標籤檔名查詢條件及刪除資料功能-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
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
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}

function setDelete()
{  //alert(tscFamily);
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	if (document.MYFORM.CH.length != undefined)
	{
		iLen = document.MYFORM.CH.length;
	}
	else
	{
		iLen = 1;
	}		
	
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.CHK.checked;
		}
		else
		{
			chkvalue = document.MYFORM.CH[i-1].checked;
		}
		if (chkvalue==true)
		{	
			chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	else if (confirm("是否確定刪除?"))
	{
		document.MYFORM.action="../jsp/TSCustLabelSpecFileQuery.jsp?ACT_TYPE=DELETE";
		document.MYFORM.submit(); 
	}
}

function setQuery()
{
	document.MYFORM.submit();
}
</script>
<title>Customer Spec Label Query</title>
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
.style18 {
	color: #000066;
	font-size: 24px;
	font-weight: bold;
	font-family: Georgia;
}
.style19 {
	color: #990000;
	font-size: 24px;
}
</STYLE>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
  
	String searchString=request.getParameter("SEARCHSTRING");
  	if (searchString==null) searchString="";
  	String statusDesc="",statusName="";
  	String pageURL="TSCustLabelSpecUpdate.jsp";
  	String svrTypeNo=request.getParameter("SVRTYPENO");    
  	String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  	String queryDateFrom="",queryDateTo=""; 
  	String fromYear=request.getParameter("FROMYEAR");  
  	if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
  	String fromMonth=request.getParameter("FROMMONTH"); 
  	if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
  	String fromDay=request.getParameter("FROMDAY");
  	if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString="01"; else fromDayString=fromDay;
  	queryDateFrom=fromYearString+fromMonthString+fromDayString;//設為搜尋收件起始日期的條件
  	String toYear=request.getParameter("TOYEAR");
  	if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
  	String toMonth=request.getParameter("TOMONTH");
  	if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
  	String toDay=request.getParameter("TODAY");
  	if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
  	queryDateTo=toYearString+toMonthString+toDayString;//設為搜尋收件截止日期的條件
  	int maxrow=0;//查詢資料總筆數 
  	String marketType=request.getParameter("MARKETTYPE");
  	if (marketType==null || marketType.equals("--")) marketType="";
  
  	String stationNo=request.getParameter("STATNO");
  	if (stationNo==null || stationNo.equals("--")) stationNo="--";
  
  	String woType=request.getParameter("WOTYPE");  
  	if (woType==null || woType.equals("--")) woType="%"; 
  
  	String label_code = request.getParameter("LABEL_CODE"); //add by Peggy 20151229
  	if (label_code==null) label_code="";
  	String act_type = request.getParameter("ACT_TYPE");     //add by Peggy 20151229
  	if (act_type==null) act_type="";
  
    // 依選定內外銷別決定 Set Client Infor 於那個Parent Org ID (305) YEW 
  
   	String orgOU = "";
   	Statement stateOU=con.createStatement();   
   	ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
   	if (rsOU.next())
   	{
    	orgOU = rsOU.getString(1);
   	}
   	rsOU.close();
   	stateOU.close();
  	
	CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	//cs1.setString(1,"305"); 
	cs1.setString(1,orgOU);  /*  41 --> 為台半半導體  42 --> 為事務機   325 --> YEW SEMI  */ 
	cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
    cs1.close(); 

  	String supplyVndID = request.getParameter("SUPPLYVNDID");
  	String supplyVndNo = request.getParameter("SUPPLYVNDNO");
  	String supplyVnd = request.getParameter("SUPPLYVND");
  	String supplierName ="";
  	String receptDateStr=request.getParameter("RECEPTDATESTR");
  	String receptDateEnd=request.getParameter("RECEPTDATEEND");
  	String poNo = request.getParameter("PONO");
  	String receiptNo = request.getParameter("RECEIPTNO");
  
  	if (receptDateStr==null) receptDateStr = dateBean.getYearMonthDay();
  	if (receptDateEnd==null) receptDateEnd = dateBean.getYearMonthDay();
  	if (supplyVndID==null) supplyVndID = "";
  	if (supplyVndNo==null) supplyVndNo = "";
  	if (poNo==null) poNo = "";
  	if (receiptNo==null) receiptNo = "";
  
  	if (supplyVnd==null || supplyVnd.equals("")) supplyVnd = ""; 
	
 	//add by Peggy 20151229
	if (act_type.equals("DELETE"))
  	{
		try
		{
			String chk[]= request.getParameterValues("CH");	
			if (chk.length <=0)
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Please choose delete record!!");
				</script>	
			<%		
			}  
			else
			{
				String sql="";
				for(int i=0; i< chk.length ;i++)
				{  
					sql ="delete from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO||'|'|| STATNO||'|'|| TYPE_ID||'|'|| ORGANIZATION_ID||'|'|| TSC_PACKAGE = '"+chk[i]+"' ";		              
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.executeQuery(); 
			 
					sql="delete from ORADDMAN.TSCUST_LABEL_SPECS where CUST_NUMBER||'|'|| STATNO||'|'||TYPE_ID||'|'||ORGANIZATION_ID||'|'||TSC_PACKAGE = '"+chk[i]+"' ";		              
					pstmt=con.prepareStatement(sql);
					pstmt.executeQuery(); 
				}
				con.commit();
			}
		}
		catch(Exception e)
		{	
			con.rollback();
			out.println("<div style='color:#ff0000'>Delete fail,Please contact MIS!!<br>"+e.getMessage()+"</div>");
		}		
  	}
  
  	try
  	{   
  		Statement statement=con.createStatement();
		String sqlRCV = " select count(1)"+
	         " from ORADDMAN.TSCUST_LABEL_SPECS A, APPS.YEW_MFG_DEFDATA B "+						
		     " where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.DEF_TYPE = 'MARKETTYPE' ";							 
		if (supplyVndID!=null && !supplyVndID.equals("")) sqlRCV += " and a.CUST_NUMBER ='"+supplyVndID+"' ";			
		if (stationNo!=null && !stationNo.equals("--")) sqlRCV += " and a.STATNO = '"+stationNo+"' ";
		if (marketType!=null && !marketType.equals("") && !marketType.equals("--")) 
		{
			sqlRCV += " and a.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
		}
		if (!label_code.equals(""))
		{
			sqlRCV += " and LABEL_TEMPFILE like '%"+label_code+"%'";
		}
		//out.println(sqlRCV);
		ResultSet rs=statement.executeQuery(sqlRCV);	
   		rs.next();   
   		maxrow=rs.getInt(1);
    
   		rs.close();   
   		statement.close();
  	} //end of try
  	catch (SQLException e)
  	{
   		out.println("ExceptionCOUNT:"+e.getMessage());
  	} 
  
  String scrollRow=request.getParameter("SCROLLROW");    
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-300;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/300+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/301+1;  
  } else {
    currentPageNumber=rowNumber/300+1; 
  }	
  
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  


%>
<FORM NAME="MYFORM" METHOD="POST" ACTION="../jsp/TSCustLabelSpecFileQuery.jsp" > 
<span class="style18">TSC</span><span class="style19">客戶特殊規格標籤查詢</span>
<img src="../image/search.gif"><font color="#003399">為查詢必選(填)欄位,需擇一輸入</font>
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#FFFFFF">
 <tr bgcolor="#D8DEA9"><td width="6%" nowrap>內外銷型別</td>
   <td width="29%" nowrap>
     <%
	             try
                 {   
				   //-----取內外銷別
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select ORGANIZATION_ID, CODE_DESC from apps.YEW_MFG_DEFDATA ";
			       String whereOType = " where DEF_TYPE='MARKETTYPE'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("MARKETTYPE");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();
				 } //end of try		 
                 catch (Exception e)
				 { out.println("Exception:"+e.getMessage()); }  
	 %>
   </td>
   <td width="12%" nowrap>標籤列印站</td>
   <td nowrap>
     <%
	             try
                 {   
				   //-----取暫收區來源
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select STATNO, STATNAME from ORADDMAN.TSCUST_LABEL_STATION ";
			       String whereOType = " where STATNO >= '00'  ";								  
				   String orderType = " order by STATNO ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(stationNo);
	               comboBoxBean.setFieldName("STATNO");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();
				 } //end of try		 
                 catch (Exception e)
				 { out.println("Exception:"+e.getMessage()); }  
	 %>
   </td>
   <td width="12%" nowrap>標籤檔名</td>
   <td><input type="text" name="LABEL_CODE" size="15" value="<%=label_code%>">
   </td>
 </tr>
 <tr bgcolor="#D8DEA9"><td width="6%" nowrap>客戶資訊<img src="../image/search.gif"></td>
     <td width="29%" nowrap>
	 <input type="hidden" size="5" name="SUPPLYVNDID" maxlength="10" value="<%=supplyVndID%>">
	 <input type="text" size="5" name="SUPPLYVNDNO" maxlength="10" value="<%=supplyVndNo%>" onKeyDown="setWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)">
	 <INPUT TYPE="button" value="..." onClick='subWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)'>
	 <input type="text" size="25" name="SUPPLYVND" maxlength="50" value="<%=supplyVnd%>" onKeyDown="setWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)">	  
    </td>
     <td width="12%" nowrap>設定日起</td>
     <td width="20%"><input name="RECEPTDATESTR" tabindex="2" type="text" size="8" value="<%=receptDateStr%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATESTR);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
     <td width="11%" nowrap>設定日迄</td>
	 <td width="22%"><input name="RECEPTDATEEND" tabindex="3" type="text" size="8" value="<%=receptDateEnd%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATEEND);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
  </tr>
	 <tr bgcolor="#D8DEA9">	   	   
	   <td colspan="6" align="center" >
	       <!--%<INPUT name="button3" tabindex='20' TYPE="button" onClick='setSubmitQuery("../jsp/TSIQCInspectLotInput.jsp?QUERY=Y",this.form.SUPPLYVND.value,this.form.VENDOR.value,this.form.SUPPLYVNDNO.value,this.form.RECEPTDATEBEG.value,this.form.RECEPTDATEEND.value,this.form.PONO.value,this.form.RECEIPTNO.value)'  value='查詢' >%-->
		   <INPUT name="button3" tabindex='20' TYPE="button" onClick="setQuery()" value='查詢' >
		   &nbsp;&nbsp;
		   <INPUT name="button5"  TYPE="button" onClick="setDelete()" value='刪除' >
	   </td>
	 </tr>    
</table>
<input name="VENDOR" type="hidden" size="25" value="<%=supplierName%>" readonly>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</FONT><FONT COLOR=BLACK SIZE=2></FONT>
<table width="100%" border="0">
  <tr>
    <td width="16%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='選擇全部'><strong><FONT COLOR=RED SIZE=2 face="Georgia">總共<%=maxrow%>&nbsp;筆記錄</FONT> </strong> 
	</td>  
	<td>  
<A HREF="../jsp/TSCustLabelSpecFileQuery.jsp?SCROLLROW=FIRST&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&MARKETTYPE=<%=marketType%>&LABEL_CODE=<%=label_code%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCustLabelSpecFileQuery.jsp?SCROLLROW=LAST&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&MARKETTYPE=<%=marketType%>&LABEL_CODE=<%=label_code%>"><font size="2"><strong><font color="#FF0080">最終頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCustLabelSpecFileQuery.jsp?SCROLLROW=300&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&MARKETTYPE=<%=marketType%>&LABEL_CODE=<%=label_code%>">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/../jsp/TSCustLabelSpecFileQuery.jsp?SCROLLROW=-300&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&MARKETTYPE=<%=marketType%>&LABEL_CODE=<%=label_code%>">前一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
	</td>
  </tr>
</table>
<%   
 try
  {   
   //out.println("Step1"); 
   //out.println("UserRoles="+UserRoles);
    
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
   String sqlRCV ="";
   String whereRCV ="";
   String orderRCV = "";
   
   //管理員與一般USER看的資料都一樣,不懂為何分開寫,將管理員CODE MARK掉,只留一般USER,add by Peggy 20151229
   //if (UserRoles.indexOf("admin")>=0) //若角色為admin則可看到全部收料單
   //{  	//out.println("UserRoles="+UserRoles);  
   //	sqlRCV = " select CUST_NUMBER as CUST_NO, STATNO, TYPE_ID, a.ORGANIZATION_ID as MARKETTYPE, TSC_PACKAGE, CUSTOMER_NAME as 客戶名稱, TSC_FAMILY as 產品族群, STAT_NAME as 標簽站別, TYPE_DESCRIPTION as 標簽規格, LABEL_TEMPFILE as 樣本檔名, ICON_NAME as 特殊圖樣, decode(a.ORGANIZATION_ID,'326','內銷','327','外銷',a.ORGANIZATION_ID) as 內外銷別, LABEL_REMARK as 備註說明 "+
   //			     " from ORADDMAN.TSCUST_LABEL_SPECS A, APPS.YEW_MFG_DEFDATA B ";							
   //		whereRCV = " where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.DEF_TYPE = 'MARKETTYPE' ";							 
   //		orderRCV = " order by 6, MARKETTYPE, TSC_PACKAGE, STATNO, TYPE_ID ";
   //				 
   //		if (supplyVndID!=null && !supplyVndID.equals("")) sqlRCV = sqlRCV + " and a.CUST_NUMBER ='"+supplyVndID+"' ";			
   //		if (stationNo!=null && !stationNo.equals("--")) sqlRCV = sqlRCV + " and a.STATNO = '"+stationNo+"' ";
   //		if (marketType!=null && !marketType.equals("") && !marketType.equals("--")) 
   //		{ 
   //			sqlRCV = sqlRCV + " and a.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
   //		}
   //		sqlRCV = sqlRCV + whereRCV + orderRCV;
   //		//out.println(sqlRCV);
   //		rs=statement.executeQuery(sqlRCV); 		  		
   //} 
   //else 
   //{
	sqlRCV = " select CUST_NUMBER as CUST_NO, STATNO, TYPE_ID, a.ORGANIZATION_ID as MARKETTYPE, TSC_PACKAGE, CUSTOMER_NAME as 客戶名稱, TSC_FAMILY as 產品族群, STAT_NAME as 標簽站別, TYPE_DESCRIPTION as 標簽規格, LABEL_TEMPFILE as 樣本檔名, ICON_NAME as 特殊圖樣, decode(a.ORGANIZATION_ID,'326','內銷','327','外銷',a.ORGANIZATION_ID) as 內外銷別, LABEL_REMARK as 備註說明 "+
	         " from ORADDMAN.TSCUST_LABEL_SPECS A, APPS.YEW_MFG_DEFDATA B "+						
		     " where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.DEF_TYPE = 'MARKETTYPE' ";						 
	if (supplyVndID!=null && !supplyVndID.equals("")) sqlRCV += " and a.CUST_NUMBER ='"+supplyVndID+"' ";			
	if (stationNo!=null && !stationNo.equals("--")) sqlRCV += " and a.STATNO = '"+stationNo+"' ";
	if (marketType!=null && !marketType.equals("") && !marketType.equals("--")) 
	{
		sqlRCV += " and a.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
	}
	if (!label_code.equals(""))
	{
		sqlRCV += " and LABEL_TEMPFILE like '%"+label_code+"%'";
	}
	sqlRCV += " order by 6, MARKETTYPE, TSC_PACKAGE, STATNO, TYPE_ID ";
	//out.println(sqlRCV);
	rs=statement.executeQuery(sqlRCV); 		   	 
	//}   // 非管理員權限 out.println("UserRoles="+UserRoles); 
	
	if (rowNumber==1 || rowNumber<0)
   	{ 
    	rs.beforeFirst(); //移至第一筆資料列  
   	} 
	else 
	{ 
    	if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  	{
        	rs.absolute(rowNumber); //移至指定資料列	 
	  	}	
   	}
   
  
   //out.println("UUU<BR>");
   
   String sKeyArray[]=new String[5];   
   sKeyArray[0]="CUST_NO";
   sKeyArray[1]="STATNO";
   sKeyArray[2]="TYPE_ID";
   sKeyArray[3]="MARKETTYPE";
   sKeyArray[4]="TSC_PACKAGE"; 
   //sKeyArray[2]="ASSIGN_MANUFACT";
   //sKeyArray[3]="ORDER_TYPE_ID";
   //sKeyArray[4]="LINE_TYPE";   
   
   	
   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(null);   
   //qryAllChkBoxEditBean.setSearchKey("INTERFACE_TRANSACTION_ID");
   qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
   qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
   qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
   qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
   //qryAllChkBoxEditBean.setRowColor1("B0E0E6"); 
   qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(300);      
   out.println(qryAllChkBoxEditBean.getRsString());
 //  out.print("woNo="+WO_NO);
   statement.close();
   rs.close();   
  //out.println("VVV<BR>");
   //取得維修處理狀態      
  } //end of try  
  catch (Exception e)
  {
   e.printStackTrace();
   out.println("Exception queryAllChkBoxEditBean:"+e.getMessage());   
  }
 
%>
</FORM>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

