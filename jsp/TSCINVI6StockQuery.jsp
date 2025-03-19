<!-- 20160613 by Peggy,TSCC USER只能查I6-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.Base64" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
 
 if(document.MYFORM.SHIPFROMORG.value==null ||  document.MYFORM.SHIPFROMORG.value=="--")
    {
	 alert("Choose one of Organization!!")
	 document.MYFORM.SHIPFROMORG.focus(); 
	 return(false);
	} 

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit1(xItem,xOrgId)
//function setSubmit1(URL)
{

 if(document.MYFORM.SHIPFROMORG.value==null ||  document.MYFORM.SHIPFROMORG.value=="--")
    {
	 alert("Choose one of Organization!!")
	 document.MYFORM.SHIPFROMORG.focus(); 
	 return(false);
	} 

 // if(document.MYFORM.SHIPFROMORG.value=="49")
  //   {
//	  alert("Will be take a long time!!");
	//  URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=4&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
	//} 

  if(document.MYFORM.SHIPFROMORG.value=="163")
     {
	  alert("Will take a long time!!")
	  var xconZero="N";
	  var xStock=document.MYFORM.SHIPSTOCK.value;
	  if (document.MYFORM.chk1.checked==true)
	  {
	  	xconZero="Y";
	  }
	  URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=5&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId+"&CONTZERO="+xconZero+"&Stock="+xStock;
	} else
        {
	       alert("Will take a long time!!");
	       URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=4&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
          }
  // URL="../jsp/TSCMfgWoExceltype1.jsp?WOTYPE=1&MARKETTYPE="+xMARKETTYPE+"&DATESETBEGIN="+document.MYFORM.YEARFR.value+document.MYFORM.MONTHFR.value+document.MYFORM.DAYFR.value+"&DATESETEND="+document.MYFORM.YEARTO.value+document.MYFORM.MONTHTO.value+document.MYFORM.DAYTO.value+"&WONO="+document.MYFORM.WONO.value+"&MFGDEPTNO="+document.MYFORM.MFGDEPTNO.value+"&INVITEM="+document.MYFORM.INVITEM.value+"&WAFERLOT="+document.MYFORM.WAFERLOT.value; 
  document.MYFORM.action=URL;
  document.MYFORM.submit();
}


function setSubmit2(URL)  //清除畫面條件,重新查詢!
{  
 document.MYFORM.SHIPFROMORG.value =""; 
 document.MYFORM.ITEM.value ="";
 //document.MYFORM.MONTHFR.value ="";
 //document.MYFORM.DAYFR.value ="";
 //document.MYFORM.MONTHTO.value ="";
 //document.MYFORM.DAYTO.value ="";
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function subWinMoFindCheck(invItemNo,invItemDesc,oeOrderNo)
{
  //  subWin=window.open("../jsp/subwindow/TSMfgMoFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&OEORDERNO="+oeOrderNo,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes"); 
}

function TSCINVI6StockDetail(itemid,typeId,subInv,orgId)
{            
    subWin=window.open("../jsp/TSCINVI6StockDetail.jsp?ITEM_ID="+itemid+"&TYPEID="+typeId+"&SUBINV="+subInv+"&ORGANIZATION_ID="+orgId,"subwin","top=0,left=0,width=1000,height=650,scrollbars=yes,menubar=no,status=yes");    	
}

function popMenuMsg(xclkDesc)
{
 alert(xclkDesc);
}

function setSubmit3()
{
	var itemv = document.MYFORM.ITEM.value;
	var orgv = document.MYFORM.SHIPFROMORG.value;
	if (orgv==163 && itemv.length >=4)
	{
		//document.MYFORM.chk1.style.visibility = "visible";
		document.MYFORM.chk1.disabled = false;

	}
	else
	{
		//document.MYFORM.chk1.style.visibility = "hidden";
		document.MYFORM.chk1.checked = false;
		document.MYFORM.chk1.disabled = true;
		
	}
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

<%
int rs1__numRows = 200;
int rs1__index = 0;
int rs_numRows = 0;
rs_numRows += rs1__numRows;
String sSql = "";
String sFrom = "";
String sSqlCNT = "";
String sWhere = "";
String sWhereSDRQ = "";
String sWhereGP = "";
String havingGrpSDRQ = "";
String sOrder = "";
String havingGrp = "";
String lightStatus ="";
String sOrgList = ""; //20110303 add by Peggychen
int counta=0;
int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;
float CASECOUNTORG=0;
String SWHERECOND = "";
int CaseCount = 0;
int CaseCountORG =0;
float CaseCountPCT = 0;
String colorStr = "",fontcolor = "";
String listMode=request.getParameter("LISTMODE"); 
String mfgDeptNo=request.getParameter("MFGDEPTNO"); 
String sqlGlobal = "";
String sWhereGlobal = "";
String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");
String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");
String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr+DayFr;
String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo+DayTo; 
String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String dnDocNoSet=request.getParameter("DNDOCNOSET");
String dnDocNo=request.getParameter("DNDOCNO");
String organizationCode=request.getParameter("ORGANIZATION_CODE");
String custActive=request.getParameter("CUSTACTIVE");
String shipFromOrg =request.getParameter("SHIPFROMORG");	
String organizationId=request.getParameter("ORGANIZATION_ID"); 
String item=request.getParameter("ITEM"); 
String woType=request.getParameter("WOTYPE"); 
String marketType=request.getParameter("MARKETTYPE");
String woQty=request.getParameter("WOQTY");
String invItem=request.getParameter("INVITEM");
String itemId=request.getParameter("ITEMID");	
String itemDesc=request.getParameter("ITEMDESC");		
String woUom=request.getParameter("WOUOM");
String oeOrderNo=request.getParameter("ORDER_NUMBER");	
String shipStock=request.getParameter("SHIPSTOCK");
if (shipStock==null) shipStock="";
String ActionCode=request.getParameter("actionno");
if (ActionCode==null) ActionCode="";
String orgCode="",fgItemId="",fgOhQty="",unShipQty ="",subItemId="",subItemNo="",subItemDesc="",subInv="",locator="";
String onWayInv="",onWayQty="",avaiQty="";
String Qty1213f="0",Qty1211f="0",fgOhQtyf="0";

if (spanning==null || spanning.equals("")) spanning = "TRUE";
if (listMode==null) listMode = "TRUE";
int iDetailRowCount = 0;
if (item==null || item.equals("")) item=""; 
String chkvalue=request.getParameter("chk1");
if (chkvalue==null) chkvalue="N";
%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM ACTION="../jsp/TSCINVI6StockQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>Stock Query</a></strong></font><BR>
<A href="/oradds/ORADDSMainMenu.jsp">Home</A>
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
sWhereGP = "  ";
workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
String currentWeek = workingDateBean.getWeekString();
%>
<table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">
	<TR>
		<TD WIDTH="15%" nowrap><font color="#006666"><strong> &nbsp; &nbsp;Organization</strong></font>
		<%
		try
        { 
        	//依角色判斷可查詢的org
            String sqlGetP="";
	        if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("MPC_003")>=0 ) // 管理員及PC,所有單據皆可檢視  
	        { 
				sOrgList = "49,163,505,48,425,50,326,327";
			}
			// YEW USER
	        else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0 || UserRoles.indexOf("YEW_MFG_PC")>=0 || UserRoles.indexOf("WAFER_STOCK_QUERY")>=0 )
	        { 
				if (UserRoles.indexOf("YEW_WIP_QUERY")>=0 || UserRoles.indexOf("YEW_MFG_PC")>=0)
				{
			    	if  (sOrgList != "") sOrgList +=",";
					sOrgList += "326,327";
				}
				if (UserRoles.indexOf("WAFER_STOCK_QUERY")>=0) //WAFER_STOCK_QUERY
				{
					if  (sOrgList != "") sOrgList +=",";
					sOrgList += "48,425";
				}					
			}
			else if (UserRoles.indexOf("TSCC_USER")>=0)
			{
				sOrgList = "163"; //add by Peggy 20160613
			}
	        else //其它只能看I1/I6
	        { 
				//sOrgList = "163";
				sOrgList = "49,163"; //add by Peggy 20130918
			}
			sqlGetP = " SELECT ORGANIZATION_ID, ORGANIZATION_CODE FROM MTL_PARAMETERS WHERE ORGANIZATION_ID in ("+sOrgList+") order by 2 ";
	        Statement stateGetP=con.createStatement();
            ResultSet rsGetP=stateGetP.executeQuery(sqlGetP);	      									  	  
			//comboBoxBean.setRs(rsGetP);
		    //comboBoxBean.setSelection(shipFromOrg);
	        //comboBoxBean.setFieldName("SHIPFROMORG");					     
            //out.println(comboBoxBean.getRsString());	
			out.println("<select NAME='SHIPFROMORG' onChange='setSubmit("+'"'+"../jsp/TSCINVI6StockQuery.jsp"+'"'+")'>");				  
			out.println("<OPTION VALUE=-->--");     
			while (rsGetP.next())
			{   
				String s1=(String)rsGetP.getString(1); 
				String s2=(String)rsGetP.getString(2); 
				if (s1.equals(shipFromOrg)) 
				{
					out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
				} 
				else 
				{
					out.println("<OPTION VALUE='"+s1+"'>"+s2);
				}        
			} //end of while
			out.println("</select>"); 	   
			stateGetP.close();		  		  
		    rsGetP.close();
	    } //end of try		 
        catch (Exception e) 
		{ 
			out.println("Exception Ship from:"+e.getMessage()); 
		}
		%>
		</TD>
		<%
		if (shipFromOrg != null && shipFromOrg.equals("163"))
		{		
			out.println("<td width='15%' nowrap><font color='#006666'><strong>InventoryNo</strong></font>");
			try
			{
				String sqlGetP= " SELECT SECONDARY_INVENTORY_NAME, SECONDARY_INVENTORY_NAME FROM mtl_secondary_inventories inv"+
								"  WHERE ORGANIZATION_ID in ("+shipFromOrg+")";
				if (shipFromOrg!=null && shipFromOrg.equals("163"))
				{ 
					//sqlGetP +=" AND inv.attribute2 = 'S'";
					sqlGetP +=" AND (inv.attribute2 = 'S' or SECONDARY_INVENTORY_NAME='14' or SECONDARY_INVENTORY_NAME='15')";  //ADD TSCE 14,15 倉 BY Mars 20250319
				}
				sqlGetP +=" order by 1 ";
				Statement stateGetP=con.createStatement();
				ResultSet rsGetP=stateGetP.executeQuery(sqlGetP);	      									  	  
				out.println("<select NAME='SHIPSTOCK'>");				  				  
				out.println("<OPTION VALUE=-->--");     
				while (rsGetP.next())
				{   
					String s1=(String)rsGetP.getString(1); 
					String s2=(String)rsGetP.getString(2); 
					if (s1.equals(shipStock)) 
					{
						out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
					} 
					else 
					{
						out.println("<OPTION VALUE='"+s1+"'>"+s2);
					}        
				} //end of while
				out.println("</select>"); 	   
				stateGetP.close();		  		  
				rsGetP.close();
			}
			catch (Exception e) 
			{ 
				out.println("Exception subinventory:"+e.getMessage()); 
			} 
		}
		out.println("</td>");
		%>		
	   	<td width="15%" nowrap><font color="#006666"><strong> &nbsp; &nbsp;Item_No or Item_Description</strong></font></td>
	   	<td width="15%"><input type="text" name="ITEM" value="<%=item%>" onKeyUp='setSubmit3()'></td>
		<% 
		if (shipFromOrg != null && shipFromOrg.equals("163"))
		{
			out.println("<td width='20%'>");
			if (item.length() < 4 )
			{
				out.println("<input type='checkbox' name='chk1' value='Y' disabled='disabled'>");
			}
			else if (chkvalue.equals("Y")) 
			{
				out.println("<input type='checkbox' name='chk1' value='Y' checked >");
			}
			else
			{
				out.println("<input type='checkbox' name='chk1' value='Y'>");
			}
			out.println("<strong>Stock = 0 included (4 letters at least)</strong></td>");
		}
		%>
		<td width="20%">
		    <INPUT TYPE="button" align="middle"  value='Query' onClick='setSubmit("../jsp/TSCINVI6StockQuery.jsp?actionno=Q")' > 
			<INPUT TYPE="reset" name="RESET" align="middle"  value='Reset' onClick='setSubmit2("../jsp/TSCINVI6StockQuery.jsp")' >
			<INPUT TYPE='button' name='IMPORT' value='EXCEL' onClick='setSubmit1(this.form.ITEM.value,this.form.SHIPFROMORG.value)'>
		</td>
	</tr>
</table>
<table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">
</table>
<%
if (shipFromOrg==null || shipFromOrg.equals("")) shipFromOrg="--";

// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
String clientID = "";
if (shipFromOrg=="--" || shipFromOrg.equals("--") ||shipFromOrg==null || shipFromOrg.equals(""))  clientID="41";
if (shipFromOrg=="326" || shipFromOrg.equals("326"))
{  
	clientID = "325"; 
}
else 
{ 
	clientID = "41"; 
}
//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
//cs1.setString(1,clientID);  //  41 --> 為半導體  325 --> 為YEW
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
cs1.setString(1,clientID);  //  41 --> 為半導體  325 --> 為YEW
cs1.execute();
cs1.close();
// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
if (ActionCode.equals("Q") && (shipFromOrg=="163" || shipFromOrg.equals("163")))
{
	sSql = " SELECT   stk.organization_id, stk.inventory_item_id,"+
           " stk.secondary_inventory_name, stk.item_name,stk.item_desc,stk.description, stk.intransit_stock,"+
           " NVL (onh.onhand_qty, 0) onhand_qty, NVL (ins.onway_qty, 0) onway_qty,"+
           " NVL (qty_1211, 0) qty_1211,nvl(qty_1213,0) qty_1213,"+
           " NVL (onh.onhand_qty, 0) + NVL (ins.onway_qty, 0) - NVL (qty_1211, 0)+ nvl(qty_1213,0) available_qty"+
           " FROM (SELECT msi.organization_id, msi.inventory_item_id,msi.segment1 item_name,msi.description item_desc,"+
           " inv.secondary_inventory_name, inv.description,"+
           " CASE inv.secondary_inventory_name"+
           " WHEN '10' THEN '12' WHEN '20' THEN '22' WHEN '30' THEN '32' WHEN '40' THEN '42' WHEN '50' THEN '52' ELSE inv.secondary_inventory_name"+
           " END AS intransit_stock"+
           " FROM mtl_secondary_inventories inv,"+
           " mtl_system_items msi,"+
           " inv.mtl_parameters mps"+
           //" WHERE inv.attribute2 = 'S'"+
		   " WHERE (inv.attribute2 = 'S' or SECONDARY_INVENTORY_NAME='14' or SECONDARY_INVENTORY_NAME='15')"+  //ADD TSCE 14,15 倉 BY Mars 20250319
           " AND inv.organization_id = msi.organization_id"+
           " AND msi.organization_id = mps.organization_id"+
		   //" AND msi.inventory_item_status_code <> 'Inactive'"+
           //" AND msi.description not like '%Disable%'"+
		   " $$$ "+
		   " ??? "+
           " AND mps.organization_id = "+shipFromOrg+") stk,"+
           " (SELECT   moq.organization_id, moq.subinventory_code, moq.inventory_item_id,SUM (moq.primary_transaction_quantity) onhand_qty"+
           " FROM mtl_onhand_quantities_detail moq GROUP BY moq.organization_id,moq.subinventory_code, moq.inventory_item_id) onh,"+
           " (SELECT   moq.organization_id, moq.subinventory_code,moq.inventory_item_id,SUM (moq.primary_transaction_quantity) onway_qty"+
           " FROM mtl_onhand_quantities_detail moq,mtl_secondary_inventories msi "+
		   //" WHERE moq.subinventory_code IN ('12', '22', '32', '42','52') "+  //用倉庫名判別,add by Peggy 20210413
		   " WHERE moq.organization_id=msi.organization_id"+
		   " and moq.subinventory_code=msi.secondary_inventory_name"+
		   " and msi.description LIKE '%In Transit%'"+
           " GROUP BY moq.organization_id,moq.subinventory_code, moq.inventory_item_id) ins,"+
           " (SELECT   hub subinventory_code, item_id inventory_item_id,(SUM (order_qty) / 1000) qty_1211 FROM tsc_om_1211"+
           " WHERE l_status IN ('AWAITING_SHIPPING', 'ENTERED', 'BOOKED')  AND item_id != 29570 GROUP BY hub, item_id) om1211,"+
           " (SELECT   hub subinventory_code, item_id inventory_item_id,(SUM (order_qty) / 1000) qty_1213 FROM tsc_om_1213"+
           " WHERE l_status IN ('AWAITING_SHIPPING', 'ENTERED', 'BOOKED') GROUP BY hub, item_id) om1213 "+
   		   " WHERE stk.organization_id = onh.organization_id(+)"+
     	   " AND stk.inventory_item_id = onh.inventory_item_id(+)"+
     	   " AND stk.secondary_inventory_name = onh.subinventory_code(+)"+
     	   " AND stk.organization_id = ins.organization_id(+)"+
     	   " AND stk.inventory_item_id = ins.inventory_item_id(+)"+
           " AND stk.intransit_stock = ins.subinventory_code(+)"+
           " AND stk.inventory_item_id = om1211.inventory_item_id(+)"+
     	   " AND stk.secondary_inventory_name= om1211.subinventory_code(+)"+
           " AND stk.inventory_item_id = om1213.inventory_item_id(+)"+
           " AND stk.secondary_inventory_name = om1213.subinventory_code(+)"+
           " ***"+
           " ORDER BY 1, 2, 3";
	if (!item.equals("") && item != null)
	{
		sSql = sSql.replace("???","AND (msi.SEGMENT1 like upper('"+item+"%') or upper(msi.DESCRIPTION) like upper('"+item+"%'))");
	}
	else
	{
		sSql = sSql.replace("???","");
	}
	if (chkvalue.equals("Y"))
	{
		sSql = sSql.replace("***","");
	}
	else
	{
		sSql = sSql.replace("***","AND (NVL (onh.onhand_qty, 0)>0  OR NVL (ins.onway_qty, 0) >0  OR   NVL (qty_1211, 0) >0 OR Nvl(qty_1213,0) >0)");
	}
	if (! shipStock.equals("") &&  shipStock != null && !shipStock.equals("--"))
	{
		sSql = sSql.replace("$$$","AND inv.secondary_inventory_name = '" +shipStock+"'");
	}
	else
	{
		sSql = sSql.replace("$$$","");
	}
	//out.println("sSql:"+sSql);
	//if (item==null || item.equals(""))
   	//{
    //	try
    //	{
    //  		sSql = " SELECT A.*  ";
    //  		sSqlCNT = " select count(A.*) as CaseCount ";
    //   		sFrom = " FROM ( SELECT DISTINCT MOQ.SUBINVENTORY_CODE,MOQ.INVENTORY_ITEM_ID,MSI.SEGMENT1,MSI.DESCRIPTION "+
 	//			    "          FROM MTL_ONHAND_QUANTITIES_DETAIL MOQ,MTL_SECONDARY_INVENTORIES INV,MTL_SYSTEM_ITEMS MSI "+
	//		  	    "		 WHERE MOQ.ORGANIZATION_ID=163 "+
 	//		   		"		   AND MOQ.ORGANIZATION_ID = INV.ORGANIZATION_ID "+
  	//		   		"		   AND MOQ.SUBINVENTORY_CODE=INV.SECONDARY_INVENTORY_NAME  "+
  	//		   		" 		   AND INV.ATTRIBUTE2 = 'S'  "+
  	//		   		"		   AND MOQ.ORGANIZATION_ID = MSI.ORGANIZATION_ID    "+
  	//		   		"           AND MOQ.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID "+
	//		   		"		 UNION "+
	//		   		"        SELECT DISTINCT HUB,ITEM_ID,ITEM,ITEM_DESC FROM TSC_OM_1211 "+
	//		   		"	     WHERE L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND item_id != 29570 "+
	//		   		"         UNION  "+
	//		   		"        SELECT DISTINCT HUB,ITEM_ID,ITEM,ITEM_DESC FROM TSC_OM_1213  "+
	//		   		"         WHERE  L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED') ) A ";
   	//		sWhere = "   ";
   	//		sWhereGP =  "";	
   	//		sWhereSDRQ = " ";
   	//		havingGrp = " ";               
   	//		havingGrpSDRQ = "  ";
   	//		sOrder = "  order by 3,1  ";
   	//		SWHERECOND = sWhere + sWhereGP + havingGrp;
   	//		sSql = sSql +sFrom+ sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   	//		sSqlCNT = sSqlCNT + sFrom+ sWhere + sWhereSDRQ  ;
  	//	} //end of try
  	//	catch (Exception e)
  	//	{
   	//		out.println("Exception a:"+e.getMessage());
  	//	}
	//}
	//else if (item=="0" || item.equals("0")) 
  	//{
    //	sSql=" select '' SUBINVENTORY_CODE,'' INVENTORY_ITEM_ID,'' ITEM_NO,'' DESCRIPTION from dual ";
  	//}
	//else
	//{   
  	//	try
 	//	{
    //  		sSql = " SELECT A.*  ";
   	//		sSqlCNT = " select count(*) as CaseCount ";
    //		sFrom = " FROM ( SELECT DISTINCT MOQ.SUBINVENTORY_CODE,MOQ.INVENTORY_ITEM_ID,MSI.SEGMENT1,MSI.DESCRIPTION "+
 	//		   		"          FROM MTL_ONHAND_QUANTITIES_DETAIL MOQ,MTL_SECONDARY_INVENTORIES INV,MTL_SYSTEM_ITEMS MSI "+
	//		   		"		 WHERE MOQ.ORGANIZATION_ID=163 "+
 	//		   		"		   AND MOQ.ORGANIZATION_ID = INV.ORGANIZATION_ID "+
  	//		   		"		   AND MOQ.SUBINVENTORY_CODE=INV.SECONDARY_INVENTORY_NAME  "+
  	//		   		" 		   AND INV.ATTRIBUTE2 = 'S'  "+
  	//		   		"		   AND MOQ.ORGANIZATION_ID = MSI.ORGANIZATION_ID    "+
  	//		   		"           AND MOQ.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID "+
	//		   		"		 UNION "+
	//		   		"        SELECT DISTINCT HUB,ITEM_ID,ITEM,ITEM_DESC FROM TSC_OM_1211 "+
	//		   		"	     WHERE L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND item_id != 29570 "+
	//		   		"         UNION  "+
	//		   		"        SELECT DISTINCT HUB,ITEM_ID,ITEM,ITEM_DESC FROM TSC_OM_1213  "+
	//		   		"         WHERE  L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  ) A ";
   	//		sWhere = "   ";
   	//		sWhereSDRQ = "  ";
   	//		sWhereGP = "    ";
   	//		if (item==null || item.equals(""))  
	//		{
	//			sWhere=sWhere+" ";
	//		}
  	// 		else 
	//		{
	//			sFrom=sFrom+" WHERE ( a.SEGMENT1 like upper('"+item+"%') or upper(a.DESCRIPTION) like upper('"+item+"%'))  "; 
	//		}
   	//		havingGrp = "  ";      
   	//		havingGrpSDRQ = "  ";  
   	//		sOrder = "   ";
  	//		SWHERECOND = sWhere+ sWhereGP;
  	//		sSql = sSql +sFrom+sWhere +  sWhereGP;   
  	//		sSqlCNT = sSqlCNT+sFrom + sWhere ;
   	//		String sqlOrgCnt = " select count(*) as CaseCountORG ";
   	//		sqlOrgCnt = sqlOrgCnt+ sFrom+ sWhere ;
   	//		Statement statement2=con.createStatement();
   	//		ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   	//		if (rs2.next())
   	//		{
    // 			CaseCountORG = rs2.getInt("CaseCountORG");
   	//		}
   	//		rs2.close();
   	//		statement2.close();
	//		
  	//	} //end of try
 	//	catch (Exception e)
   	//	{
    // 		out.println("Exception 2:"+e.getMessage());
    //	}
   	//try
   	//{ 
    //  	Statement statement3=con.createStatement();
    //   	ResultSet rs3=statement3.executeQuery(sSqlCNT);
	// 	if (rs3.next())
	// 	{	
	//  		CaseCount = rs3.getInt("CaseCount");
	//   		if (CaseCountORG!=0)
	//  		{
	//     		CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
	//	 		// 取小數1位
	//			sCSCountPCT = Float.toString(CaseCountPCT);
	//			idxCSCount = sCSCountPCT.indexOf('.');
	//			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
	//   		}
	//   		else
	//   		{
	//     		CaseCountPCT = 0;
	//   		}
	//   		rs3.close();
	//   		statement3.close();
	// 	}
	//} //end of try
    //catch (Exception e)
    //{
    // 	out.println("Exception 3:"+e.getMessage());
    //}
//}//end of else 


	// 準備予維修方式使用的Statement Con //
	sqlGlobal = sSql; 
	Statement statementTC=con.createStatement(); 
	ResultSet rsTC=statementTC.executeQuery(sSql);
	//boolean rs_isEmptyTC = !rsTC.next();
	//boolean rs_hasDataTC = !rs_isEmptyTC;
	//Object rs_dataTC;  
	
	if (listMode==null || listMode.equals("TRUE"))
  	{
%> 
<table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">	
	<tr>	    
<%
		String CurrYear = null;	
        String CurrMonth = null;
        String CurrDay = null;   
        String CurrYearTo = null,CurrMonthTo=null,CurrDayTo = null;	 
%>
	</tr>
</table>  
<HR>
<%  
	}  // End of if (listMode==null || listMode,equals("TRUE")) 
%>
<table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#BBD3E1">
	<tr bgcolor="#BBD3E1"> 
		<td width="5%" height="22" nowrap><div align="center"><font color="#000000" face="Arial">&nbsp;</font></div></td> 
	  	<td width="18%" nowrap><div align="center"><font color="#006666" face="Arial">Item No</font></div></td>
      	<td width="15%" nowrap><div align="center"><font color="#006666" face="Arial">Description</font></div></td>           
      	<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">UOM</font></div></td> 
	  	<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">InventoryNo</font></div></td>
	  	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">On Hand Qty</font></div></td>
	  	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">On The Way</font></div></td>
      	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">1213/1214 Unship Qty</font></div></td>
	  	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">1211/1215 Unship Qty</font></div></td>	 
	  	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">Available Qty</font></div></td>  	   
    </tr>
<% 
	while (rsTC.next()) 
	{ 
		if ((rs1__index % 2) == 0)
		{
	    	colorStr = "#D8E6E7";
	    }
	    else
		{
	    	colorStr = "#BBD3E1"; 
		}
		organizationId=rsTC.getString("ORGANIZATION_ID");
		itemId=rsTC.getString("INVENTORY_ITEM_ID");
		invItem=rsTC.getString("ITEM_NAME");
		itemDesc=rsTC.getString("ITEM_DESC");
		subInv=rsTC.getString("secondary_inventory_name"); 
		String clkDesc = rsTC.getString("DESCRIPTION"); 
		woUom="KPC";
		onWayInv=rsTC.getString("INTRANSIT_STOCK");
		fgOhQtyf=new java.text.DecimalFormat("0.###").format(rsTC.getFloat("ONHAND_QTY")); 
		onWayQty=new java.text.DecimalFormat("0.###").format(rsTC.getFloat("ONWAY_QTY"));
		Qty1211f=new java.text.DecimalFormat("0.###").format(rsTC.getFloat("QTY_1211"));
	    Qty1213f=new java.text.DecimalFormat("0.###").format(rsTC.getFloat("QTY_1213"));
		avaiQty =new java.text.DecimalFormat("#.###").format(rsTC.getFloat("available_qty"));
			
		//顯示on_hand
      	//String sqlOh = "   SELECT SUM(MOQ.PRIMARY_TRANSACTION_QUANTITY) ONHAND_QTY "+
 		//			   "     FROM MTL_ONHAND_QUANTITIES_DETAIL MOQ "+
		//		       "    WHERE MOQ.ORGANIZATION_ID=163   "+
  		//			   "      AND MOQ.SUBINVENTORY_CODE='"+subInv+"'  AND MOQ.INVENTORY_ITEM_ID='"+itemId+"'  ";
	  	//Statement stateOh=con.createStatement();
      	//ResultSet rsOh=stateOh.executeQuery(sqlOh);
	  	//if (rsOh.next())
		//{
	 	//	fgOhQtyf = rsOh.getFloat("ONHAND_QTY"); 
		//}
	  	//rsOh.close();
	  	//stateOh.close();
		//if (subInv=="10" || subInv.equals("10")) onWayInv="12";
        //if (subInv=="20" || subInv.equals("20")) onWayInv="22";
        //if (subInv=="30" || subInv.equals("30")) onWayInv="32";
        //if (subInv=="40" || subInv.equals("40")) onWayInv="42";
		
		//顯示在途倉數量
      	//String sqlway = "   SELECT SUM (moq.primary_transaction_quantity) ONWAY_QTY   FROM mtl_onhand_quantities_detail moq"+  
  		//  			  "    WHERE moq.organization_id = 163  AND moq.inventory_item_id = '"+itemId+"' "+
        //                "      AND moq.subinventory_code = '"+onWayInv+"'  ";
	  	//Statement stateWay=con.createStatement();
      	//ResultSet rsWay=stateWay.executeQuery(sqlway);
	  	//if (rsWay.next())
		//{
	 	//	onWayQty = rsWay.getString("ONWAY_QTY"); 
	 	// 	onWayQtyf = rsWay.getFloat("ONWAY_QTY"); 
		//}
	  	//rsWay.close();
	  	//stateWay.close();

		//顯示1211/1213未交數量
      	//String sqlUnShip = " SELECT A.QTY_1211,B.QTY_1213 FROM  "+
        //                  "    (SELECT (SUM(ORDER_QTY)/1000) QTY_1211 FROM TSC_OM_1211 "+
		//		          "      WHERE L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND HUB='"+subInv+"' AND ITEM_ID='"+itemId+"' ) A, "+
		//			      "    (SELECT DISTINCT (SUM(ORDER_QTY)/1000) QTY_1213 FROM TSC_OM_1213 "+
		//		          "      WHERE  L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND HUB='"+subInv+"' AND ITEM_ID='"+itemId+"' ) B  ";
	  	//Statement stateUnShip=con.createStatement();
      	//ResultSet rsUnShip=stateUnShip.executeQuery(sqlUnShip);
	  	//if (rsUnShip.next())
		//{
		//	Qty1211f=rsUnShip.getFloat("QTY_1211");
	    //	Qty1213f=rsUnShip.getFloat("QTY_1213");
		//}
	  	//rsUnShip.close();
	  	//stateUnShip.close();
		// avaiQtyf 庫存計算
        //avaiQtyf =  fgOhQtyf + onWayQtyf + Qty1213f - Qty1211f;

		// avaiQtyf 庫存計算
		//小數3位顯示
    	//java.text.DecimalFormat nf = new java.text.DecimalFormat("#.###"); // 取小數後三位
		//avaiQty = nf.format(avaiQtyf);

  		if (invItem==null || invItem.equals("")) invItem="&nbsp"; 
  		if (itemDesc==null || itemDesc.equals("")) itemDesc="&nbsp"; 
  		if (woUom==null || woUom.equals("")) woUom="&nbsp"; 
  		if (subInv==null || subInv.equals("")) subInv="&nbsp"; 
  		if (locator==null || locator.equals("")) locator="&nbsp"; 
  		if (onWayQty==null || onWayQty.equals("")) onWayQty="&nbsp"; 

	 	//顯示倉別代碼的名稱			 
      	//
      	//String sqlInv = " SELECT DESCRIPTION FROM MTL_SECONDARY_INVENTORIES WHERE ORGANIZATION_ID=163 AND SECONDARY_INVENTORY_NAME='"+subInv+ "'";
	 	//Statement stateInv=con.createStatement();
      	//ResultSet rsInv=stateInv.executeQuery(sqlInv);
	  	//if (rsInv.next())
		//{
	 	//	clkDesc = rsInv.getString("DESCRIPTION"); 
		//}
	  	//rsInv.close();
	  	//stateInv.close();
%>
	<tr bgcolor="<%=colorStr%>"> 
    	<td ><div align="center"><font color="#006666" face="Arial"><% out.println(rs1__index+1);%></font></div></td>
	  	<td ><div align="left"><font color="#006666" face="Arial">&nbsp;<%=invItem%></font></div></td>
	  	<td ><div align="left"><font color="#006666" face="Arial">&nbsp;<%=itemDesc%></font></div></td>
	  	<td ><div align="center"><font color="#006666" face="Arial"><%=woUom%></font></div></td>
	  	<td ><div align="center"><font color="#006666" face="Arial"><a href="javaScript:popMenuMsg("<%=clkDesc%>") onMouseOver='this.T_ABOVE=false;this.T_WIDTH=180;this.T_OPACITY=80;return escape("<%=clkDesc%>")'"><%=subInv%></a></font></div></td>
	  	<td ><div align="right"><font color="#006666" face="Arial"><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=0%>','<%=subInv%>','<%=organizationId%>')"><%=fgOhQtyf%></a></font></div></td>
<%
		if(subInv=="13" || subInv.equals("13"))   //13倉是帳差倉,不可SHOW 在途數量
   		{
%> 
		<td> &nbsp </td> 
<% 
		}
      	else 
		{   
%>
	  	<td ><div align="right"><font color="#006666" face="Arial"><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=0%>','<%=onWayInv%>','<%=organizationId%>')"><%=onWayQty%></a></font></div></td>
<%            
		} 
%>
	  	<td ><div align="right"><font color="#006666" face="Arial"><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=1%>','<%=subInv%>')"><%=Qty1213f%></a></font></div></td>	
	  	<td ><div align="right"><font color="#006666" face="Arial"><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=2%>','<%=subInv%>')"><%=Qty1211f%></a></font></div></td>	  
	  	<td ><div align="right"><font color="#006666" face="Arial"><%=avaiQty%></font></div></td>
    </tr>
<%
  		rs1__index++;
  		//rs_hasDataTC = rsTC.next();
   		//counta = rs1__index ;
  	}// endof while substate
%>
	<tr bgcolor="#BBD3E1"> 
    	<td height="23" colspan="15" ><font color="#006666">ToTal Count:</font> 
<% 
	if (rs1__index !=0) 
	{ 
		out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); 
	}
	workingDateBean.setAdjWeek(1);  // 把週別調整回來
%>
<input type="hidden" name="CASECOUNT" value=<%=rs1__index%> size="5" readonly=""><font color='#000066' face="Arial"><strong><%=rs1__index%></strong></font>
		</td>      
	</tr>
</table>
<!--%每頁筆●顯示筆到筆總共有資料%-->
<div align="center"> <font color="#993366" size="2">
<% 
	if (rs1__index ==0) 
	{  
%>
<strong>No Record Found</strong> 
<% 
	} /* end RpRepair_isEmpty */ 
%>
</font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
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
<%
	rsTC.close();
	statementTC.close();
}  //end if shipfromorg=163 I6

//************START SELECT I1 49
if (ActionCode.equals("Q") && (shipFromOrg=="49" || shipFromOrg.equals("49") || shipFromOrg=="505" || shipFromOrg.equals("505")  
     || shipFromOrg=="48" || shipFromOrg.equals("48") 
     || shipFromOrg=="425" || shipFromOrg.equals("425")  || shipFromOrg=="50" || shipFromOrg.equals("50") 
     || shipFromOrg=="326" || shipFromOrg.equals("326") || shipFromOrg=="327" || shipFromOrg.equals("327")) )
{
	try
 	{
    	sSql = " SELECT ROWNUM,A.INVENTORY_ITEM_ID,MSI.SEGMENT1 ITEM_NO,MSI.DESCRIPTION,MSI.PRIMARY_UNIT_OF_MEASURE UOM  ";
	  	sSql += ",a.onhand_qty,a.unship_qty,a.onhand_qty-a.unship_qty as approve_qty"; //20110303 add by Peggychen
   		sSqlCNT = " select count(*) as CaseCount ";
    	String sqlOrgCnt = " select count(*) as CaseCountORG ";
    	sFrom = " FROM ( "+
   				"          SELECT moq.inventory_item_id,SUM (transaction_quantity) onhand_qty, 0 AS unship_qty "+
     			"		   FROM mtl_onhand_quantities_detail moq "+
				"          WHERE moq.organization_id = "+shipFromOrg+"  "+
				"                AND moq.SUBINVENTORY_CODE NOT IN ('00','01','02','05','06') "+
				"                GROUP BY moq.inventory_item_id"+
  				"          UNION  "+
   				"          SELECT ool.inventory_item_id , 0 AS onhand_qty"+
				"          , SUM (DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000,ordered_quantity)) unship_qty"+
    			"          FROM oe_order_lines_all ool "+
    			"          WHERE ool.ship_from_org_id = "+shipFromOrg+" "+
				"          AND ool.line_category_code = 'ORDER'  "+
     			"          AND ool.cancelled_flag = 'N'"+
				"          AND ool.flow_status_code IN ('ENTERED', 'BOOKED', 'AWAITING_SHIPPING')  "+
     			"          AND ool.inventory_item_id NOT IN (29570, 29560, 29562, 66996) "+
				"          GROUP BY ool.inventory_item_id) a ,mtl_system_items msi ";
   		sWhere = " WHERE msi.organization_id ="+shipFromOrg+" AND a.inventory_item_id   = msi.inventory_item_id 	 ";
   		sWhereSDRQ = "  ";
   		sWhereGP = "   ";
   		if (item==null || item.equals(""))  
		{
			sWhere=sWhere+" ";
		}
   		else 
		{ 
			sWhere = sWhere + " AND ( MSI.SEGMENT1 LIKE upper('"+item+"%') or upper(MSI.DESCRIPTION) like upper('"+item+"%'))   "; 
		}
   		havingGrp = "  ";      
   		havingGrpSDRQ = "  ";  
   		sOrder = "   order by ROWNUM ";
  		SWHERECOND = sWhere+ sWhereGP;
  		sSql = sSql +sFrom+sWhere +  sWhereGP;   
  		sSqlCNT = sSqlCNT+sFrom + sWhere +  sWhereGP;
  		sqlOrgCnt = sqlOrgCnt+ sFrom+ sWhere+  sWhereGP; 
   		Statement statement2=con.createStatement();
   		ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   		if (rs2.next())
   		{
     		CaseCountORG = rs2.getInt("CaseCountORG");
   		}
   		rs2.close();
   		statement2.close();
  	} //end of try
 	catch (Exception e)
   	{
    	out.println("Exception CaseCountORG:"+e.getMessage());
    }
   	
	try
   	{   
    	Statement statement3=con.createStatement();
        ResultSet rs3=statement3.executeQuery(sSqlCNT);
		if (rs3.next())
		{
			CaseCount = rs3.getInt("CaseCount");
		   	if (CaseCountORG!=0)
		   	{
		    	CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
			 	// 取小數1位
				sCSCountPCT = Float.toString(CaseCountPCT);
				idxCSCount = sCSCountPCT.indexOf('.');
				sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   	}
		   	else
		   	{
		    	CaseCountPCT = 0;
			}
		   	rs3.close();
		   	statement3.close();
		}
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception 3b:"+e.getMessage());
    }

	// 準備予維修方式使用的Statement Con //
	sqlGlobal = sSql; 
	Statement statementTC=con.createStatement(); 
	ResultSet rsTC=statementTC.executeQuery(sSql);
	boolean rs_isEmptyTC = !rsTC.next();
	boolean rs_hasDataTC = !rs_isEmptyTC;
	Object rs_dataTC;  

	// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables
	int rs_first = 1;
	int rs_last  = 1;
	int rs_total = -1;
	if (rs_isEmptyTC) 
	{
  		rs_total = rs_first = rs_last = 0;
	}

	//set the number of rows displayed on this page
	if (rs_numRows == 0) 
	{
  		rs_numRows = 1;
	}

	// *** Move To Record and Go To Record: declare variables
	ResultSet MM_rs = rsTC;
	int       MM_rsCount = rs_total;
	int       MM_size = rs_numRows;
	String    MM_uniqueCol = "";
    String    MM_paramName = "";
	int       MM_offset = 0;
	boolean   MM_atTotal = false;
	boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);

	// *** Move To Record: handle 'index' or 'offset' parameter
	if (!MM_paramIsDefined && MM_rsCount != 0) 
	{
  		//use index parameter if defined, otherwise use offset parameter
  		String r = request.getParameter("index");
  		if (r==null) r = request.getParameter("offset");
  		if (r!=null) MM_offset = Integer.parseInt(r);

  		// if we have a record count, check if we are past the end of the recordset
  		if (MM_rsCount != -1) 
		{
    		if (MM_offset >= MM_rsCount || MM_offset == -1) 
			{  // past end or move last
      			if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        			MM_offset = MM_rsCount - MM_rsCount % MM_size;
      			else
        			MM_offset = MM_rsCount - MM_size;
    		}
  		}

  		//move the cursor to the selected record
  		int i;
  		for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) 
		{
    		rs_hasDataTC = MM_rs.next();
  		}
  		if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
	}

	// *** Move To Record: if we dont know the record count, check the display range
	if (MM_rsCount == -1) 
	{
  		// walk to the end of the display range for this page
  		int i;
  		for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) 
		{
    		rs_hasDataTC = MM_rs.next();
  		}

  		// if we walked off the end of the recordset, set MM_rsCount and MM_size
  		if (!rs_hasDataTC) 
		{
    		MM_rsCount = i;
    		if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  		}

  		// if we walked off the end, set the offset based on page size
  		if (!rs_hasDataTC && !MM_paramIsDefined) 
		{
    		if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) 
			{ //check if past end or last
      			if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        			MM_offset = MM_rsCount - MM_rsCount % MM_size;
      			else
        			MM_offset = MM_rsCount - MM_size;
    		}
  		}

  		// reset the cursor to the beginning
  		rsTC.close();
  		rsTC = statementTC.executeQuery(sSql);
  		rs_hasDataTC = rsTC.next();
  		MM_rs = rsTC;

  		// move the cursor to the selected record
  		for (i=0; rs_hasDataTC && i < MM_offset; i++) 
		{
    		rs_hasDataTC = MM_rs.next();
  		}
	}
	// *** Move To Record: update recordset stats

	// set the first and last displayed record
	rs_first = MM_offset + 1;
	rs_last  = MM_offset + MM_size;
	if (MM_rsCount != -1) 
	{
  		rs_first = Math.min(rs_first, MM_rsCount);
  		rs_last  = Math.min(rs_last, MM_rsCount);
	}

	// set the boolean used by hide region to check if we are on the last record
	MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
	
	// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters
	String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
	String[] MM_removeList = { "index", MM_paramName };

	// create the MM_keepURL string
	if (request.getQueryString() != null) 
	{
  		MM_keepURL = '&' + request.getQueryString();
  		for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) 
		{
  			int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    		if (start >= 0 && MM_keepURL.charAt(start) == '&' && MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') 
			{
      			int stop = MM_keepURL.indexOf('&', start + 1);
      			if (stop == -1) stop = MM_keepURL.length();
      			MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    		}
  		}
	}

	// add the Form variables to the MM_keepForm string
	if (request.getParameterNames().hasMoreElements()) 
	{
  		java.util.Enumeration items = request.getParameterNames();
  		while (items.hasMoreElements()) 
		{
    		String nextItem = (String)items.nextElement();
    		boolean found = false;
    		for (int i=0; !found && i < MM_removeList.length; i++) 
			{
      			if (MM_removeList[i].equals(nextItem)) found = true;
    		}
    		if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) 
			{
      			MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    		}
  		}
	}

	// create the Form + URL string and remove the intial '&' from each of the strings
	MM_keepBoth = MM_keepURL + MM_keepForm;
	if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
	if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
	if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);


	// *** Move To Record: set the strings for the first, last, next, and previous links
	String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
	{
  		String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  		String MM_moveParam = "index=";

	 	// if the page has a repeated region, remove 'offset' from the maintained parameters
  		if (MM_size > 1) 
		{
    		MM_moveParam = "offset=";
    		int start = MM_keepMove.indexOf(MM_moveParam);
    		if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) 
			{
      			int stop = MM_keepMove.indexOf('&', start);
      			if (start == 0 && stop != -1) stop++;
      			if (stop == -1) stop = MM_keepMove.length();
      			if (start > 0) start--;
      			MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    		}
  		}

  		// set the strings for the move to links
  		StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  		if (MM_keepMove.length() > 0) urlStr.append('&');
  		urlStr.append(MM_moveParam);
  		MM_moveFirst = urlStr + "0";
  		MM_moveLast  = urlStr + "-1";
  		MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  		MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
	}
	// move end
%> 
<%
  	if (listMode==null || listMode.equals("TRUE"))
  	{
%> 
<table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#CCCCCC">	
	<tr>	    
        <%

		  String CurrYear = null;	
          String CurrMonth = null;
          String CurrDay = null;   
          String  CurrYearTo = null,CurrMonthTo=null,CurrDayTo = null;	 
       %>
	</tr>
</table>  
<HR>
<%  
	}  // End of if (listMode==null || listMode,equals("TRUE")) 
%>
<table cellspacing="1" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#BBD3E1">
	<tr bgcolor="#BBD3E1"> 
		<td width="5%" height="22" nowrap><div align="center"><font color="#000000" face="Arial">&nbsp;</font></div></td> 
	  	<td width="18%" nowrap><div align="center"><font color="#006666" face="Arial">Item No</font></div></td>
      	<td width="15%" nowrap><div align="center"><font color="#006666" face="Arial">Description</font></div></td>           
      	<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">UOM</font></div></td> 
	  	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">On Hand Qty</font></div></td>
      	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">Unship Qty</font></div></td>	 
	  	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">Available Qty</font></div></td>  	   
    </tr>
<% 
	while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
	{ 
%>
<%
	    if ((rs1__index % 2) == 0)
		{
	    	colorStr = "#D8E6E7";
	    }
	    else
		{
	    	colorStr = "#BBD3E1"; 
		}
        String rowNo =" ";
		rowNo=rsTC.getString("ROWNUM");
		itemId=rsTC.getString("INVENTORY_ITEM_ID");
		invItem=rsTC.getString("ITEM_NO");
		itemDesc=rsTC.getString("DESCRIPTION");
		woUom=rsTC.getString("UOM");
		fgOhQty=rsTC.getString("ONHAND_QTY");
		unShipQty=rsTC.getString("UNSHIP_QTY");
		avaiQty=rsTC.getString("APPROVE_QTY");
  		if (invItem==null || invItem.equals("")) invItem="&nbsp"; 
  		if (itemDesc==null || itemDesc.equals("")) itemDesc="&nbsp"; 
  		if (woUom==null || woUom.equals("")) woUom="&nbsp"; 
  		if (subInv==null || subInv.equals("")) subInv="&nbsp"; 
  		if (fgOhQty==null || fgOhQty.equals("")) fgOhQty="&nbsp";
  		if (unShipQty==null || unShipQty.equals("")) unShipQty="&nbsp";
%>
	<tr bgcolor="<%=colorStr%>"> 
    	<td ><div align="center"><font color="#006666" face="Arial"><%=rowNo%></font></div></td>
	  	<td ><div align="left"><font color="#006666" face="Arial">&nbsp;<%=invItem%></font></div></td>
	  	<td ><div align="left"><font color="#006666" face="Arial">&nbsp;<%=itemDesc%></font></div></td>
	  	<td ><div align="center"><font color="#006666" face="Arial"><%=woUom%></font></div></td>
	  	<td ><div align="right"><font color="#006666" face="Arial"><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=4%>','<%=subInv%>','<%=shipFromOrg%>')"><%=fgOhQty%></a></font></div></td>
	  	<td ><div align="right"><font color="#006666" face="Arial"><a href="javaScript:TSCINVI6StockDetail('<%=itemId%>','<%=3%>','<%=subInv%>','<%=shipFromOrg%>')"><%=unShipQty%></a></font></div></td>	  
	  	<td ><div align="right"><font color="#006666" face="Arial"><%=avaiQty%></font></div></td>
    </tr>
<%
  		rs1__index++;
  		rs_hasDataTC = rsTC.next();
   		counta = rs1__index ;
  	}// endof while substate
%>
	<tr bgcolor="#BBD3E1"> 
    	<td height="23" colspan="15" ><font color="#006666">ToTal Count:</font> 
<% 
    if (CaseCount==0) 
	{
	} 
	else 
	{ 
		out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); 
	}
	workingDateBean.setAdjWeek(1);  // 把週別調整回來
%>
<input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>
		</td>      
    </tr>
</table>

<!--%每頁筆●顯示筆到筆總共有資料%-->
<div align="center"> <font color="#993366" size="2">
<% 
	if (rs_isEmptyTC ) 
	{  
%>
		<strong>No Record Found</strong> 
<% 
	} /* end RpRepair_isEmpty */ 
	
Base64.Encoder encoder = Base64.getEncoder();
byte[] textByte = sqlGlobal.getBytes("UTF-8");
sqlGlobal = encoder.encodeToString(textByte);
textByte = SWHERECOND.getBytes("UTF-8");
SWHERECOND = encoder.encodeToString(textByte);	
%>
</font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="ORGANIZATIONID" type="HIDDEN" value="<%=organizationId%>">
<input type="hidden" name="ITEMID" value="<%=%>" >
<input type="hidden" name="WOUOM" value="<%=%>" >
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveFirst%>">第一頁</A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_movePrev%>">前一頁</A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveNext%>">下一頁</A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveLast%>">最後頁</A>]</strong></font></pre>
      </div></td>
  </tr>
</table>  

<BR>
<%
	rsTC.close();
	statementTC.close();
}  //end if shipfromorg=49 I1

%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

