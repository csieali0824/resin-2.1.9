<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit1(xWOTYPE,xMARKETTYPE)
{

  if(document.MYFORM.WOTYPE.value==null ||  document.MYFORM.WOTYPE.value=="--")
    {
	 alert("請選擇工令類別!!")
	 document.MYFORM.WOTYPE.focus(); 
	 return(false);
	}
/*	
  if(xDATEBEGIN=="--" || xDATEBEGIN.equals("--") || xDATEBEGIN==null || xDATEEND=="--" || xDATEEND.equals("--") || xDATEEND==null)
    {
	 alert("請選擇工令設立期間!!")
	 return(false);
	}
	*/
  if(document.MYFORM.WOTYPE.value=="1")
  {
      URL="../jsp/TSCMfgWoExceltype1.jsp?WOTYPE=1&MARKETTYPE="+xMARKETTYPE+"&DATESETBEGIN="+document.MYFORM.YEARFR.value+document.MYFORM.MONTHFR.value+document.MYFORM.DAYFR.value+"&DATESETEND="+document.MYFORM.YEARTO.value+document.MYFORM.MONTHTO.value+document.MYFORM.DAYTO.value+"&WONO="+document.MYFORM.WONO.value+"&MFGDEPTNO="+document.MYFORM.MFGDEPTNO.value+"&INVITEM="+document.MYFORM.INVITEM.value+"&WAFERLOT="+document.MYFORM.WAFERLOT.value; 
  }
  else if (document.MYFORM.WOTYPE.value=="2" || document.MYFORM.WOTYPE.value=="4"  || document.MYFORM.WOTYPE.value=="7")
       { 
	     URL="../jsp/TSCMfgWoExceltype2.jsp?WOTYPE="+xWOTYPE+"&MARKETTYPE="+xMARKETTYPE+"&DATESETBEGIN="+document.MYFORM.YEARFR.value+document.MYFORM.MONTHFR.value+document.MYFORM.DAYFR.value+"&DATESETEND="+document.MYFORM.YEARTO.value+document.MYFORM.MONTHTO.value+document.MYFORM.DAYTO.value+"&WONO="+document.MYFORM.WONO.value+"&MFGDEPTNO="+document.MYFORM.MFGDEPTNO.value+"&INVITEM="+document.MYFORM.INVITEM.value+"&WAFERLOT="+document.MYFORM.WAFERLOT.value; 
	   } 
  else if (document.MYFORM.WOTYPE.value=="3" )
  { 
	  URL="../jsp/TSCMfgWoExceltype3.jsp?WOTYPE=3&MARKETTYPE="+xMARKETTYPE+"&DATESETBEGIN="+document.MYFORM.YEARFR.value+document.MYFORM.MONTHFR.value+document.MYFORM.DAYFR.value+"&DATESETEND="+document.MYFORM.YEARTO.value+document.MYFORM.MONTHTO.value+document.MYFORM.DAYTO.value+"&WONO="+document.MYFORM.WONO.value+"&MFGDEPTNO="+document.MYFORM.MFGDEPTNO.value+"&INVITEM="+document.MYFORM.INVITEM.value+"&WAFERLOT="+document.MYFORM.WAFERLOT.value; 
  }  
  document.MYFORM.action=URL;
  document.MYFORM.submit();
}

</script>
<html>
<head>
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
.style1 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
}
</STYLE>
<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
int rs1__numRows = 200;
int rs1__index = 0;
int rs_numRows = 0;

rs_numRows += rs1__numRows;

String sSql = "",sql="";
//String sSqlCNT = "";
//String sWhere = "";
//String sWhereSDRQ = "";
//String sWhereGP = "";
//String havingGrpSDRQ = "";
//String sOrder = "";

//String havingGrp = "";
String lightStatus ="";

//String fjamDesc = ""; 

//String link2ExcelURL = "";

int counta=0;
int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;

float CASECOUNTORG=0;

//String RepLocale=(String)session.getAttribute("LOCALE"); 		
String SWHERECOND = "";
int CaseCount = 0;
int CaseCountORG =0;
float CaseCountPCT = 0;

String colorStr = "";
String sqlGlobal = "";
String sWhereGlobal = "";
  
String woNo=request.getParameter("WONO"); 
String marketType=request.getParameter("MARKETTYPE");
String singleLotQty=null,createDate=null,userName=null,completeQty="0",scrapQty="0",woStatus="",olStatus="";
if (woNo==null || woNo.equals("")) woNo=""; 
if (marketType==null || marketType.equals(""))marketType="";   
String QPage = request.getParameter("QPage");
if (QPage ==null) QPage="1";
float LastPage=0;
float dataCnt=0;
float NowPage = Float.parseFloat(QPage);
String invItem="",itemDesc="",invLot="",woQty="",woUom="",wipOrderno="",wipLot="",resOrderLine="",resOrderstatus="";
String resOrderno="",resQty="",orderStage="",spanning="",customerId="",custActive="",organizationCode="",organizationId="";
  
%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM ACTION="../jsp/TSCMfgINVQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>庫存使用狀況查詢</a></strong></font><BR>
  <A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
     <tr>
	    <td width="18%" colspan="1" nowrap>
		<font color="#006666"><strong>
		內銷/外銷</strong></font>  </td> 
	   <td width="13%"><%		
		try
        {  
			//-----取內外銷別
		   	Statement statement=con.createStatement();
		   	ResultSet rs=null;	
		   	String sqlOrgInf = " select ORGANIZATION_ID as CODE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
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
				//out.print("MARKETTYPE"+marketType);
		} //end of try		 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}	   
       %></td>
   
	   <td width="32%" nowrap><font color="#006666"><strong> &nbsp; &nbsp;品名/規格、工令號、流程卡號、出貨MO單號</strong></font></td>
	   <td width="37%"> &nbsp;
       <input type="text" name="WONO" value="<%=woNo%>"></td>
	 </tr>
	<tr>
		<td colspan="4" align="center"><input name="button" type="button" onClick='setSubmit("../jsp/TSCMfgINVQuery.jsp")'  value='<jsp:getProperty name="rPH" property="pgQuery"/>' align="middle" >
	  <!--<input type="reset" name="RESET" align="middle"  value='<jsp:getProperty name="rPH" property="pgReset"/>' onClick='setSubmit2("../jsp/TSCMfgINVQuery.jsp")' >-->
			<!--INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit1(this.form.WOTYPE.value,this.form.DATESETBEGIN.value,this.form.DATESETEND.value)' -->  
			<INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit1(this.form.WOTYPE.value,this.form.MARKETTYPE.value)' >	</td>
   </tr>	 
  </table>
<%
try
{
	sSql = " select ROW_NUMBER() OVER (ORDER BY  mp.organization_code, msi.segment1,moqd.LOT_NUMBER) ROWNO,count(1) over (partition by 1) tot_cnt"+
	       " ,moqd.INVENTORY_ITEM_ID"+
	       " ,msi.segment1 as ITEM_NO"+
		   " ,msi.description as ITEM_DESCRIPTION"+
		   //" ,decode(moqd.organization_id, 326, 'Y1', 327, 'Y2') as ORG_CODE"+
		   " ,mp.organization_code as ORG_CODE"+ 
		   " ,moqd.SUBINVENTORY_CODE"+
           " ,moqd.LOT_NUMBER"+
           " ,sum(moqd.transaction_quantity) as ON_HAND_QTY"+
		   " ,moqd.TRANSACTION_UOM_CODE"+
		   " ,res_order.WO_NO"+
		   " ,mln.attribute1 as WIP_ORDER_NUMBER"+
		   " ,mln.attribute2 as WIP_LOT_NUMBER"+
		   " ,res_order.order_number as RES_ORDER_NUMBER"+
		   " ,res_order.line_number as RES_LINE_NUMBER"+
		   " ,res_order.flow_status_code as RES_LINE_STATUS"+
           " from mtl_onhand_quantities_detail moqd "+
		   " ,mtl_lot_numbers mln"+
		   " ,mtl_system_items msi"+
		   " ,mtl_parameters mp"+
		   " ,(select ywa.wo_no,oola.inventory_item_id,yra.runcard_no lot_number,ooha.order_number, oola.line_number||'.'||oola.shipment_number as LINE_NUMBER,oola.flow_status_code"+ 
           " from yew_workorder_all ywa"+
		   " , oe_order_headers_all ooha"+
		   " , oe_order_lines_all oola"+
		   " , yew_runcard_all yra"+
           " where ywa.order_header_id=oola.header_id "+
		   " and ywa.order_line_id=oola.line_id "+
		   " and ooha.header_id = oola.header_id "+
		   " and ywa.STATUSID not in (?)"+
           " and ywa.wo_no=yra.wo_no) res_order"+
           " where moqd.organization_id  in (?,?)"+
           " and moqd.inventory_item_id = mln.inventory_item_id"+
           " and moqd.organization_id = mln.organization_id "+
		   " and moqd.organization_id = mp.organization_id"+
           " and moqd.lot_number = mln.lot_number "+
           " and moqd.inventory_item_id = msi.inventory_item_id "+
           " and moqd.organization_id = msi.organization_id "+
           " and moqd.inventory_item_id = res_order.inventory_item_id(+)  "+
           " and moqd.lot_number = res_order.lot_number(+) "+
           " and moqd.subinventory_code = ?";
	if (marketType!=null &&  !marketType.equals("--") &&  !marketType.equals(""))
   	{
		sSql +=" and moqd.organization_id ='"+marketType+"'"; 
	}
  
	if (woNo!=null && !woNo.equals(""))
	{
  		sSql += " and ( msi.description like '"+woNo+"%' or to_char(res_order.order_number) like '"+woNo+"%' or moqd.lot_number like '"+woNo+"%' or res_order.wo_no like '"+woNo+"%' )"; 
	}   
   	sSql += " group by moqd.organization_id"+
			",moqd.inventory_item_id"+
		    ",msi.segment1 "+
            ",msi.description"+
		    ",moqd.subinventory_code"+
		    ",moqd.lot_number"+
		    ",moqd.transaction_uom_code"+
		    ",mln.attribute1"+
		    ",mln.attribute2"+
		    ",res_order.order_number"+
		    ",res_order.line_number"+
		    ",res_order.flow_status_code"+
		    ",res_order.lot_number"+
		    ",res_order.wo_no"+
			",mp.organization_code "+
			" ORDER BY mp.organization_code, msi.segment1,moqd.LOT_NUMBER";
	//out.println(sSql);
	PreparedStatement statement = con.prepareStatement(sSql);
	statement.setString(1,"050");
	statement.setInt(2,326);
	statement.setInt(3,327);
	statement.setString(4,"03");
	int icnt=0;
	ResultSet rsTC=statement.executeQuery();
	if (rsTC.next())	
	{
		//總筆數
		dataCnt = Float.parseFloat(rsTC.getString("tot_cnt"));
		//最後頁數
		LastPage = (int)(Math.ceil(dataCnt / rs1__numRows));		
	}
	rsTC.close();
	statement.close();
	
	sql ="select * from ("+sSql+") a where ROWNO between "+(int)((NowPage-1)*rs1__numRows+1) +" and "+ (int)(NowPage*rs1__numRows)+"";
	//out.println(sql);
	statement = con.prepareStatement(sql);
	statement.setString(1,"050");
	statement.setInt(2,326);
	statement.setInt(3,327);
	statement.setString(4,"03");
	rsTC=statement.executeQuery();
	while (rsTC.next())	
	{
		if (icnt ==0)
		{
		%>
		<table width="100%" border="0">
			<tr>
				<td><font face="細明體" color="#006666">查詢結果共<%=(int)dataCnt%>筆資料，每頁顯示<%=(int)rs1__numRows%>筆/共<%=(int)LastPage%>頁</font>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type=button name="FPage" id="FPage" value="<<" onClick="setSubmit('../jsp/TSCMfgINVQuery.jsp?ACTIONCODE=QRY&QPage=1')" <%if(NowPage==1){ out.println("disabled");}%> title="First Page">
					&nbsp;
					<input type=button name="PPage" id="PPage" value="<" onClick="setSubmit('../jsp/TSCMfgINVQuery.jsp?ACTIONCODE=QRY&QPage=<%=(NowPage-1)%>')"  <%if(NowPage==1){ out.println("disabled");}%> title="Previous Page">
					&nbsp;&nbsp;<font face='細明體' color='#006666'>第<%=(int)NowPage%>頁</font>&nbsp;&nbsp;
					<input type=button name="NPage" id="NPage" value=">" onClick="setSubmit('../jsp/TSCMfgINVQuery.jsp?ACTIONCODE=QRY&QPage=<%=(NowPage+1)%>')"  <%if(NowPage==LastPage){ out.println("disabled");}%> title="Next Page">
					&nbsp;
					<input type=button name="LPage" id="LPage" value=">>" onClick="setSubmit('../jsp/TSCMfgINVQuery.jsp?ACTIONCODE=QRY&QPage=<%=LastPage%>')" <%if(NowPage==LastPage){ out.println("disabled");}%> title="Last Page">
				</td>
			</tr>
		</table>
		  <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
			<tr bgcolor="#BBD3E1"> 
			  <td width="3%" height="22" nowrap><div align="center"><font color="#000000" face="Arial">&nbsp;</font></div></td> 
			  <td width="5%" height="22" nowrap><div align="center"><font color="#006666" face="Arial">內/外銷</font></div></td>
			  <td width="15%" nowrap><div align="center"><font color="#006666" face="Arial">料號</font></div></td>
			  <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">品名</font></div></td>           
			  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">INV Lot</font></div></td> 
			  <td width="6%" nowrap><div align="center"><font color="#006666" face="Arial">庫存數量</font></div></td>
			  <td width="4%" nowrap><div align="center"><font color="#006666" face="Arial">單位</font></div></td>
			  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">工令</font></div></td>
			  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">生產訂單</font></div></td>	 
			  <!--td width="8%" nowrap><div align="center"><font color="#006666" face="Arial">生產 Lot</font></div></td-->  	   
			  <!--<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">保留訂單</font></div></td>-->
			  <td width="4%" nowrap><div align="center"><font color="#006666" face="Arial">訂單項次</font></div></td>
			  <!--<td width="4%" nowrap><div align="center"><font color="#006666" face="Arial">數量</font></div></td>-->
			  <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">訂單狀態</font></div></td>
			  <!--<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">撿貨確認</font></div></td>-->
			</tr>  		
		<%	
		}
		if ((icnt % 2) == 0)
		{
	       colorStr = "#D8E6E7";
	    }
	    else
		{
	    	colorStr = "#BBD3E1"; 
		}
//
		marketType=rsTC.getString("ORG_CODE");
		invItem=rsTC.getString("ITEM_NO");
		itemDesc=rsTC.getString("ITEM_DESCRIPTION");
		invLot=rsTC.getString("LOT_NUMBER");
		woQty=rsTC.getString("ON_HAND_QTY");
		woUom=rsTC.getString("TRANSACTION_UOM_CODE");
		woNo=rsTC.getString("WO_NO"); 
	    //wipOrderno=rsTC.getString("WIP_ORDER_NUMBER"); 
		wipOrderno=rsTC.getString("RES_ORDER_NUMBER"); 
	    wipLot=rsTC.getString("WIP_LOT_NUMBER"); 
	    //resOrderno=rsTC.getString("RES_ORDER_NUMBER");
        resOrderLine=rsTC.getString("RES_LINE_NUMBER");
	    //resQty=rsTC.getString("RESERVATION_QUANTITY");
        resOrderstatus=rsTC.getString("RES_LINE_STATUS"); 
	    //orderStage=rsTC.getString("RES_STAGED_FLAGE"); 

	  	if (woNo==null || woNo.equals("")) woNo="--"; 
	  	if (wipOrderno==null || wipOrderno.equals("")) wipOrderno="--"; 
	  	if (wipLot==null || wipLot.equals("")) wipLot="--"; 
	  	//if (resOrderno==null || resOrderno.equals("")) resOrderno="--"; 
	  	if (resOrderLine==null || resOrderLine.equals("")) resOrderLine="--"; 
	  	//if (resQty==null || resQty.equals("")) resQty="--"; 
	  	if (resOrderstatus==null || resOrderstatus.equals("")) resOrderstatus="--"; 
	  	//if (orderStage==null || orderStage.equals("")) orderStage="--";
		
    %>
		<tr bgcolor="<%=colorStr%>"> 
		  <td bgcolor="#BBD3E1" width="3%"><div align="center"><font color="#006666" face="Arial"><a name='#<%=rsTC.getString("inventory_item_id")%>'><%=rsTC.getString("ROWNO")%></a></font></div></td>
		  <td ><div align="center"><font color="#006666" face="Arial"><%=marketType%></font></div></td>
		  <td ><div align="left"><font color="#006666" face="Arial">&nbsp;<%=invItem%></font></div></td>
		  <td ><div align="left"><font color="#006666" face="Arial">&nbsp;<%=itemDesc%></font></div></td>
		  <td ><div align="center"><font color="#006666" face="Arial"><%=invLot%></font></div></td>
		  <td ><div align="center"><font color="#006666" face="Arial"><%=woQty%></font></div></td>
		  <td ><div align="center"><font color="#006666" face="Arial"><%=woUom%></font></div></td>	  
		  <td ><div align="center"><font color="#006666" face="Arial"><%=woNo%></font></div></td>
		  <td ><div align="center"><font color="#006666" face="Arial"><%=wipOrderno%></font></div></td>	  
		  <!--td ><div align="center"><font color="#006666" face="Arial"><%=wipLot%></font></div></td-->
		  <!--<td ><div align="center"><font color="#006666" face="Arial"><%=resOrderno%></font></div></td>-->
		  <td ><div align="center"><font color="#006666" face="Arial"><%=resOrderLine%></font></div></td> 
		  <!--<td ><div align="center"><font color="#006666" face="Arial"><%=resQty%></font></div></td>-->
		  <td ><div align="center"><font color="#006666" face="Arial"><%=resOrderstatus%></font></div></td>  
		  <!--<td ><div align="center"><font color="#006666" face="Arial"><%=orderStage%></font></div></td>-->
		</tr>
    <%
		icnt ++;
	}
	rsTC.close();
	statement.close();
%>

<%
	if (icnt ==0)
	{
	%>
		<div style="color:#ff0000" align="center">No Data Found!!</div>
	<%
	}
	else
	{
	%>
	</table>
	<%
	}
}
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
}	   
%>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="ORGANIZATIONID" type="HIDDEN" value="<%=organizationId%>">
<input type="hidden" name="ITEMID" value="<%=%>" >
<input type="hidden" name="WOUOM" value="<%=%>" >

</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

