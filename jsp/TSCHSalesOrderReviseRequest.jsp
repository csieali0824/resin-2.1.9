<!-- 20160517 by Peggy,簡稱不使用 Name Pronuncication ,改採用 Account Description-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 10px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 10px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 10px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 10px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Request for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
	}
}

function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
		lineid = document.MYFORM.chk[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		for (var i =0; i <document.getElementsByName("tr_"+lineid).length;i++)
		{	
			document.getElementsByName("tr_"+lineid)[i].style.backgroundColor="#daf1a9";
		}
	}
	else
	{
		for (var i =0; i <document.getElementsByName("tr_"+lineid).length;i++)
		{	
			document.getElementsByName("tr_"+lineid)[i].style.backgroundColor="#FFFFFF";
		}
		document.MYFORM.elements["NEW_CRD_"+lineid].value ="";
		document.MYFORM.elements["NEW_QTY_"+lineid].value ="";
		for ( var j = 1 ; j <= eval(document.MYFORM.elements["TSC_ORDER_CNT_"+lineid].value) ; j++)
		{
			document.MYFORM.elements["TSC_NEW_SSD_"+lineid+"_"+j].value ="";
			document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value ="";
			document.MYFORM.elements["REMARKS_"+lineid+"_"+j].value ="";
		}	
	}
}
function setUpload()
{
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open("../jsp/TSCHSalesOrderReviseUpload.jsp","subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}

function setClose()
{
	if (confirm("Are you sure to exit this function?"))
	{
		location.href="/oradds/ORADDSMainMenu.jsp";
	}
}
function setSubmit(URL)
{   
	if (document.MYFORM.CUSTOMER.value =="" && document.MYFORM.CUSTOMER_PO.value =="" &&  document.MYFORM.TSC_PARTNO.value =="" &&	document.MYFORM.CUST_PARTNO.value =="" && document.MYFORM.TSCH_MO.value =="")
	{
		//alert("Please enter query condition!");
		//return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0,tsc_change_cnt=0;	
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue==true)
		{
			//if ((document.MYFORM.elements["NEW_CRD_"+lineid].value ==null || document.MYFORM.elements["NEW_CRD_"+lineid].value  =="") 
			//	&& (document.MYFORM.elements["NEW_QTY_"+lineid].value ==null || document.MYFORM.elements["NEW_QTY_"+lineid].value  ==""))
			//{
			//	alert("Seq No:"+i+"=>Please enter a New CRD or New Qty!");
			//	document.MYFORM.elements["NEW_CRD_"+lineid].focus();
			//	return false;
			//}
			//if (document.MYFORM.elements["NEW_CRD_"+lineid].value !="" && document.MYFORM.elements["NEW_CRD_"+lineid].value==document.MYFORM.elements["CRD_"+lineid].value)
			//{
			//	alert("Seq No:"+i+"=>New crd must be different with original crd!");
			//	document.MYFORM.elements["NEW_CRD_"+lineid].focus();
			//	return false;			
			//}			
			if (document.MYFORM.elements["NEW_QTY_"+lineid].value != "")
			{
				if (document.MYFORM.elements["NEW_QTY_"+lineid].value==document.MYFORM.elements["QTY_"+lineid].value)
				{
					alert("Seq No:"+i+"=>New qty must be different with original qty!");
					document.MYFORM.elements["NEW_QTY_"+lineid].focus();
					return false;		
				}
				else if (eval(document.MYFORM.elements["NEW_QTY_"+lineid].value) <0)
				{
					alert("Seq No:"+i+"=>New qty error!");
					document.MYFORM.elements["NEW_QTY_"+lineid].focus();
					return false;				
				}	
			}
			if (document.MYFORM.elements["NEW_CRD_"+lineid].value !=null && document.MYFORM.elements["NEW_CRD_"+lineid].value !="")	
			{	
				if (checkDate("CRD","NEW_CRD_"+lineid,lineid)==false)
				{
					return false;
				}
			}
			tsc_change_cnt =0;
			for ( var j = 1 ; j <= eval(document.MYFORM.elements["TSC_ORDER_CNT_"+lineid].value) ; j++)
			{
				if ((document.MYFORM.elements["TSC_NEW_SSD_"+lineid+"_"+j].value!="" && (document.MYFORM.elements["TSC_ORIG_SSD_"+lineid+"_"+j].value != document.MYFORM.elements["TSC_NEW_SSD_"+lineid+"_"+j].value)) 
				    || (document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value!="" && (document.MYFORM.elements["TSC_ORIG_QTY_"+lineid+"_"+j].value != document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value)))
				{
					tsc_change_cnt++;
					
				}
				if (document.MYFORM.elements["TSC_NEW_SSD_"+lineid+"_"+j].value !=null && document.MYFORM.elements["TSC_NEW_SSD_"+lineid+"_"+j].value !="")	
				{	
					if (checkDate("SSD","TSC_NEW_SSD_"+lineid+"_"+j,lineid)==false)
					{
						return false;
					}
				}
				if (document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value !=null && document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value !="")	
				{	
					if (eval(document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value)<0)
					{
						alert("Seq No:"+i+"=>New tsc order qty error!");
						document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].focus();
						return false;							
					}
				}
			}
			//alert(eval(document.MYFORM.elements["TSC_ORDER_CNT_"+lineid].value));
			//alert(eval(document.MYFORM.elements["TSC_ORDER_CLOSE_CNT_"+lineid].value));
			if (eval(document.MYFORM.elements["TSC_ORDER_CNT_"+lineid].value) != eval(document.MYFORM.elements["TSC_ORDER_CLOSE_CNT_"+lineid].value) && tsc_change_cnt ==0)
			{
				alert("Seq No:"+i+"=>TSC Order no change!!");
				return false;	
			}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	document.MYFORM.save1.disabled=true;
	document.MYFORM.exit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function checkDate(objName,objCode,objline)
{
	var rec_year="",rec_month="",rec_day=""
	if (document.MYFORM.elements[objCode].value.length!=8)
	{
		alert("Seq No:"+objline+"=>New "+objName+" format error(vaild format=YYYYMMDD)!!");
		document.MYFORM.elements[objCode].focus();
		return false;			
	}
	else if (eval(document.MYFORM.elements[objCode].value) <= eval(document.MYFORM.sys_date.value))
	{
		alert("Seq No:"+objline+"=>New "+objName+" must be greater than today!!");
		document.MYFORM.elements[objCode].focus();
		return false;		
	}
	else 
	{
		rec_year = document.MYFORM.elements[objCode].value.substr(0,4);
		rec_month= document.MYFORM.elements[objCode].value.substr(4,2);
		rec_day  = document.MYFORM.elements[objCode].value.substr(6,2);
		if (rec_month <1 || rec_month >12)
		{
			alert("Seq No:"+i+"=>New "+objName+" month error!!");
			document.MYFORM.elements[objCode].focus();
			return false;			
		}	
		else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
		{
			alert("Seq No:"+i+"=>New "+objName+" error!!");
			document.MYFORM.elements[objCode].focus();
			return false;			
		} 
		else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
		{
			alert("Seq No:"+i+"=>New "+objName+" error!!");
			document.MYFORM.elements[objCode].focus();
			return false;			
		} 
		else if (rec_month == 2)
		{
			if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
			{
				alert("Seq No:"+i+"=>New "+objName+" error!!");
				document.MYFORM.elements[objCode].focus();
				return false;	
			}		
		}
	}
	return true;
}

// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
} 

function setLineCheck(irow,stype)
{
	var chkvalue = "";
	var v_change = "";
	var lineid = "";
	var change_qty =0;
	if ((document.MYFORM.elements["NEW_CRD_"+irow].value ==null || document.MYFORM.elements["NEW_CRD_"+irow].value  =="") 
			&& (document.MYFORM.elements["NEW_QTY_"+irow].value ==null || document.MYFORM.elements["NEW_QTY_"+irow].value  ==""))
	{
		v_change ="N";
	}
	else
	{
		v_change ="Y";
	}
	if (document.MYFORM.chk.length != undefined)
	{
		chkvalue = document.MYFORM.chk[irow-1].checked;
		lineid = document.MYFORM.chk[irow-1].value;
		//if ((chkvalue==true && v_change =="N") || (chkvalue==false && v_change =="Y"))
		//{
			if (v_change =="N")
			{
				document.MYFORM.chk[irow-1].checked =false;
			}
			else
			{
				document.MYFORM.chk[irow-1].checked =true;
				if (stype=="DATE" && checkDate("CRD","NEW_CRD_"+irow,irow)==false)
				{
					return false;
				}				
			}
			setCheck((irow-1));
		//}
	}
	else
	{
		chkvalue =document.MYFORM.chk.checked;
		lineid = document.MYFORM.chk.value;
		//if ((chkvalue==true && v_change =="N") || (chkvalue==false && v_change =="Y"))
		//{
			if (v_change =="N")
			{
				document.MYFORM.chk.checked =false;
			}
			else
			{
				document.MYFORM.chk.checked =true;
				if (stype=="DATE" && checkDate("CRD","NEW_CRD_"+irow,irow)==false)
				{
					return false;
				}	
			}
			setCheck((irow-1));
		//}
	}
	if (v_change=="Y")
	{
		if (stype=="DATE" && document.MYFORM.elements["NEW_CRD_"+lineid].value!=null && document.MYFORM.elements["NEW_CRD_"+lineid].value !="")
		{
			for ( var j = 1 ; j <= eval(document.MYFORM.elements["TSC_ORDER_CNT_"+lineid].value) ; j++)
			{
				if (document.MYFORM.elements["TSC_NEW_SSD_"+lineid+"_"+j].disabled==false)
				{
					subWin=window.open("../jsp/subwindow/TSCHSalesOrderSSDFind.jsp?objid=TSC_NEW_SSD_"+lineid+"_"+j+"&lineid="+document.MYFORM.elements["TSC_MO_LINE_ID_"+lineid+"_"+j].value+"&CRD="+document.MYFORM.elements["NEW_CRD_"+lineid].value,"subwin","width=10,height=10,scrollbars=yes,menubar=no");  
				}
			}
		}
		else if (stype=="QTY" && document.MYFORM.elements["NEW_QTY_"+lineid].value!=null && document.MYFORM.elements["NEW_QTY_"+lineid].value !="")
		{
			change_qty = eval(document.MYFORM.elements["NEW_QTY_"+lineid].value)- eval(document.MYFORM.elements["QTY_"+lineid].value);
			for ( var j = 1 ; j <= eval(document.MYFORM.elements["TSC_ORDER_CNT_"+lineid].value) ; j++)
			{
				if (document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].disabled==false)
				{
					document.MYFORM.elements["TSC_NEW_QTY_"+lineid+"_"+j].value = eval(document.MYFORM.elements["TSC_ORIG_QTY_"+lineid+"_"+j].value)+(change_qty);
				}
			}
		}
		
	}
}
function subOrderDetail(URL)
{
	subWin=window.open(URL,"subwin","width=800,height=480,scrollbars=yes,menubar=no");  
}
</script>
<%
String sql = "";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String TEMP_ID =request.getParameter("TEMP_ID");
if (TEMP_ID==null) TEMP_ID="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String CUSTOMER_PO = request.getParameter("CUSTOMER_PO");
if (CUSTOMER_PO==null) CUSTOMER_PO="";
String CUST_PARTNO = request.getParameter("CUST_PARTNO");
if (CUST_PARTNO==null) CUST_PARTNO="";
String TSC_PARTNO = request.getParameter("TSC_PARTNO");
if (TSC_PARTNO==null) TSC_PARTNO="";
String TSCH_MO = request.getParameter("TSCH_MO");
if (TSCH_MO==null) TSCH_MO="";
String TSC_MO = request.getParameter("TSC_MO");
if (TSC_MO==null) TSC_MO="";
String SCRD=request.getParameter("SCRD");
if (SCRD==null) SCRD="";
String ECRD=request.getParameter("ECRD");
if (ECRD==null) ECRD="";
String SSSD=request.getParameter("SSSD");
if (SSSD==null) SSSD="";
String ESSD=request.getParameter("ESSD");
if (ESSD==null) ESSD="";
String screenWidth=request.getParameter("SWIDTH");
if (screenWidth==null) screenWidth="0";
String screenHeight=request.getParameter("SHEIGHT");
if (screenHeight==null) screenHeight="0";
String strBackGround="color:#ff0000;";
int i=0,icnt=0,tsch_line_id=0,merge_line=0,tsc_order_cnt=0;
long change_qty=0;
String v_edit_flag = "",v_font_color="";
String v_disabled = "",new_qty="";
			////sql="SELECT   TSC_GET_OQC_RPT(2258496,NULL,NULL) FROM DUAL";
			////out.println(sql);
			//PreparedStatement statement1 = con.prepareStatement(sql);								  
			//ResultSet rs1=statement1.executeQuery();		
			//if (rs1.next())		
		//	{
			//	out.println("xx"+rs1.getString(1)+"xx");
			//}
			//statement1.close();
			//rs1.close();


%>
<body>
<FORM ACTION="../jsp/TSCHSalesOrderReviseRequest.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">TSCH Order Request for Revise</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:<%=screenWidth%>;height:<%=screenHeight%>;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE border="1" width="100%" bgcolor="#CEEAD7" cellpadding="0" cellspacing="1"  bordercolorlight="#CFDAD8" bordercolordark="#5C7671">
	<tr>
		<td width="6%" style="font-size:11px" align="right">Customer：</td>
		<td width="10%"><INPUT TYPE="TEXT" NAME="CUSTOMER" VALUE="<%=CUSTOMER%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="6%" style="font-size:11px" align="right">Customer PO：</td>
		<td width="10%"><INPUT TYPE="TEXT" NAME="CUSTOMER_PO" VALUE="<%=CUSTOMER_PO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="6%" style="font-size:11px" align="right">Cust Part No：</td>
		<td width="10%"><INPUT TYPE="TEXT" NAME="CUST_PARTNO" VALUE="<%=CUST_PARTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="6%" style="font-size:11px" align="right">TSC Part No：</td>
		<td width="10%"><INPUT TYPE="TEXT" NAME="TSC_PARTNO" VALUE="<%=TSC_PARTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="6%" style="font-size:11px" align="right">TSCH MO#：</td>
		<td width="10%"><INPUT TYPE="TEXT" NAME="TSCH_MO" VALUE="<%=TSCH_MO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="6%" style="font-size:11px" align="right">TSC MO#：</td>
		<td width="10%"><INPUT TYPE="TEXT" NAME="TSC_MO" VALUE="<%=TSC_MO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
	</tr>
	<tr>
		<td align="right">TSCH CRD：</td>
		<td colspan="3"><input type="TEXT" NAME="SCRD" value="<%=SCRD%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SCRD);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="ECRD" value="<%=ECRD%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.ECRD);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right">TSC SSD：</td>
		<td colspan="7"><input type="TEXT" NAME="SSSD" value="<%=SSSD%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SSSD);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="ESSD" value="<%=ESSD%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.ESSD);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
	</tr>
	<tr>
		<td style="font-size:11px" colspan="12" align="center">
			<INPUT TYPE="button" value="Query"  style="font-family: Tahoma,Georgia;font-size:11px" onClick='setSubmit("../jsp/TSCHSalesOrderReviseRequest.jsp?ACODE=Q")' >
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" name="btnUpload" value="Excel Upload"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setUpload()">
		</td>
	</tr>
	
</TABLE>
<hr>
<%
try
{
	if (ACODE.equals("Q") || ACODE.equals("UPLOAD"))
	{
		sql = " SELECT C.CUSTOMER_NUMBER"+
              ",C.CUSTOMER_ID"+
              ",NVL(HCA.ACCOUNT_NAME, C.CUSTOMER_NAME) CUSTOMER_NAME"+
              ",A.ORDER_NUMBER"+
              ",B.LINE_NUMBER||'.'||B.SHIPMENT_NUMBER LINE_NO"+
              ",A.HEADER_ID"+
              ",B.LINE_ID"+
              ",D.DESCRIPTION TSC_PARTNO"+
              ",D.INVENTORY_ITEM_ID TSC_ITEMID"+
              ",DECODE(B.ITEM_IDENTIFIER_TYPE,'CUST',B.ORDERED_ITEM,'') CUST_PARTNO"+
              ",B.ORDERED_ITEM_ID CUST_ITEMID"+
              ",B.CUSTOMER_LINE_NUMBER CUST_PO"+
              ",B.CUSTOMER_SHIPMENT_NUMBER CUST_PO_LINE"+
              ",TO_CHAR(B.REQUEST_DATE,'YYYYMMDD') CRD"+
              ",B.ORDERED_QUANTITY QTY"+
              ",B.FLOW_STATUS_CODE STATUS"+
              ",TSC.ORDER_NUMBER TSC_ORDER_NUMBER"+
              ",TSC.LINE_NUMBER||CASE WHEN TSC.LINE_NUMBER IS NOT NULL THEN '.' ELSE '' END||TSC.SHIPMENT_NUMBER TSC_LINE_NUMBER"+
              ",TSC.HEADER_ID TSC_HEADER_ID"+
              ",TSC.LINE_ID TSC_LINE_ID"+
              ",TO_CHAR(TSC.SCHEDULE_SHIP_DATE,'YYYYMMDD') SCHEDULE_SHIP_DATE"+
              ",TSC.ORDERED_QUANTITY"+
              ",TSC.FLOW_STATUS_CODE TSC_FLOW_STATUS_CODE"+
			  ",CASE WHEN TSC.FLOW_STATUS_CODE IN ('CANCELLED','SHIPPED','PICKED','CLOSED','PRE-BILLING_ACCEPTANCE') THEN 'N' ELSE 'Y' END AS TSC_EDIT_FLAG"+
			  ",COUNT(B.LINE_ID) OVER (PARTITION BY B.HEADER_ID,B.LINE_ID) TSCH_TO_TSC_ORDER_CNT"+
			  ",SUM(CASE WHEN TSC.FLOW_STATUS_CODE IN ('CANCELLED','SHIPPED','PICKED','CLOSED','PRE-BILLING_ACCEPTANCE') THEN 1 ELSE 0 END) OVER (PARTITION BY B.HEADER_ID,B.LINE_ID)  AS TSC_ORDER_CLOSE_CNT";
		if ( ACODE.equals("UPLOAD"))
		{
			sql += ",tos.SO_QTY NEW_QTY,to_char(tos.REQUEST_DATE,'yyyymmdd') NEW_CRD,tos.REMARKS"+
			       ",tsch_get_tsc_order_ssd( tsc.LINE_ID,tos.REQUEST_DATE,'TSCH') NEW_TSC_SSD";
		}
		else
		{	
			sql += ",'' NEW_QTY,'' NEW_CRD,'' REMARKS,'' NEW_TSC_SSD";
		}
        sql +=" FROM ONT.OE_ORDER_HEADERS_ALL A "+
              ",ONT.OE_ORDER_LINES_ALL B"+
              ",AR_CUSTOMERS C"+
			  ",HZ_CUST_ACCOUNTS HCA"+
              ",MTL_SYSTEM_ITEMS_B D"+
              ",(SELECT E.ORDER_NUMBER,F.LINE_NUMBER,F.SHIPMENT_NUMBER,E.HEADER_ID,F.LINE_ID,"+
			  " F.SCHEDULE_SHIP_DATE,F.ORDERED_QUANTITY,F.SOURCE_DOCUMENT_ID TSCH_HEADER_ID,"+
			  " F.SOURCE_DOCUMENT_LINE_ID TSCH_LINE_ID,F.ORIG_SYS_DOCUMENT_REF TSCH_ORDER_NUMBER,"+
			  //" G.LINE_NUMBER  TSCH_LINE_NUMBER "+
			  " (select g.line_number from ont.oe_order_lines_all g where g.org_id=? and  f.source_document_id = g.header_id"+
              " AND f.source_document_line_id = g.line_id)  TSCH_LINE_NUMBER"+
			  " ,F.FLOW_STATUS_CODE "+
			  " FROM ONT.OE_ORDER_HEADERS_ALL E"+
              "  ,ONT.OE_ORDER_LINES_ALL F"+
              //"  ,ONT.OE_ORDER_LINES_ALL G"+
              "  WHERE E.ORG_ID=?"+
              "  AND E.HEADER_ID=F.HEADER_ID"+
              //"  AND F.SOURCE_DOCUMENT_ID=G.HEADER_ID"+
              //"  AND F.SOURCE_DOCUMENT_LINE_ID=G.LINE_ID"+
              "  AND F.ORIG_SYS_DOCUMENT_REF IS NOT NULL"+
			  "  AND F.ORDERED_QUANTITY>0"+
              "  AND F.FLOW_STATUS_CODE NOT IN ('CANCELLED')"+
              //"  AND G.ORG_ID=?"+
			  ") TSC";
		if ( ACODE.equals("UPLOAD"))
		{
			sql += ",oraddman.tsc_om_salesorderrevise_temp tos";
		}
        sql +=" WHERE A.ORG_ID=?"+
              " AND A.HEADER_ID=B.HEADER_ID"+
              " AND A.SOLD_TO_ORG_ID=C.CUSTOMER_ID "+
			  " AND c.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID"+ //add by Peggy 20160517
              " AND B.SHIP_FROM_ORG_ID=D.ORGANIZATION_ID "+
              " AND B.INVENTORY_ITEM_ID=D.INVENTORY_ITEM_ID"+
              " AND B.HEADER_ID=TSC.TSCH_HEADER_ID"+
              " AND B.LINE_NUMBER=TSC.TSCH_LINE_NUMBER"+
			  " AND B.ORDERED_QUANTITY>0"+
              " AND B.FLOW_STATUS_CODE NOT IN ('CANCELLED','SHIPPED','PICKED','CLOSED','PRE-BILLING_ACCEPTANCE')";			  
		//if (!UserRoles.equals("admin") && !UserName.toUpperCase().equals("COCO"))
		if (UserRoles.toLowerCase().indexOf("admin")<0 && !UserName.toUpperCase().equals("COCO"))
		{
			sql += " AND EXISTS (SELECT 1 FROM TSC_OM_ORDER_PRIVILEGE X WHERE X.RFQ_USERNAME='"+UserName+"' AND X.CUSTOMER_ID=A.SOLD_TO_ORG_ID AND X.ORG_ID=A.ORG_ID)";
		}	
		if ( ACODE.equals("UPLOAD"))
		{
			sql += " and tos.temp_id="+ TEMP_ID+" and b.Line_id=tos.SO_LINE_ID";
		}	
		else
		{				
			if (!CUSTOMER.equals(""))
			{
				sql += " AND ( TO_CHAR(C.CUSTOMER_NUMBER)='"+ CUSTOMER.toUpperCase()+"' OR UPPER(NVL(HCA.ACCOUNT_NAME, C.CUSTOMER_NAME)) LIKE '%"+CUSTOMER.toUpperCase()+"%') ";
			}
			if (!CUSTOMER_PO.equals(""))
			{
				sql += " AND UPPER(B.CUSTOMER_LINE_NUMBER) LIKE '"+CUSTOMER_PO.toUpperCase()+"%' ";
			}
			if (!CUST_PARTNO.equals(""))
			{
				sql += " AND UPPER(B.ORDERED_ITEM) LIKE '"+CUST_PARTNO.toUpperCase()+"%' ";
			}	
			if (!TSC_PARTNO.equals(""))
			{
				sql += " AND UPPER(D.DESCRIPTION) LIKE '"+TSC_PARTNO.toUpperCase()+"%' ";
			}	
			if (!TSCH_MO.equals(""))
			{
				sql += " AND A.ORDER_NUMBER = '"+TSCH_MO.trim()+"' ";
			}	
			if (!TSC_MO.equals(""))
			{
				sql += " AND tsc.order_number  = '"+TSC_MO.trim()+"' ";
			}
			if (!SCRD.equals("") || !ECRD.equals(""))
			{
				if (!SCRD.equals(""))
				{
					sql += " and B.REQUEST_DATE  >= TO_DATE('"+(SCRD.equals("")?"20160101":SCRD)+"','yyyymmdd')";
				}
				if (!ECRD.equals(""))
				{
				  	sql += " and b.REQUEST_DATE <= TO_DATE('"+ (ECRD.equals("")?dateBean.getYearMonthDay():ECRD)+"','yyyymmdd')+0.99999";
				}
			}	
			if (!SSSD.equals("") || !ESSD.equals(""))
			{
				if (!SSSD.equals(""))
				{
					sql += " and TSC.SCHEDULE_SHIP_DATE >= TO_DATE('"+(SSSD.equals("")?"20160101":SSSD)+"','yyyymmdd')";
				}
				if (!ESSD.equals(""))				
				{
					sql += " and TSC.SCHEDULE_SHIP_DATE <= TO_DATE('"+ (ESSD.equals("")?dateBean.getYearMonthDay():ESSD)+"','yyyymmdd')+0.99999";
				}
			}				
		}
		sql += " ORDER BY NVL(HCA.ACCOUNT_NAME, C.CUSTOMER_NAME),B.CUSTOMER_LINE_NUMBER ,B.CUSTOMER_SHIPMENT_NUMBER, A.ORDER_NUMBER,TO_NUMBER(B.LINE_NUMBER||'.'||B.SHIPMENT_NUMBER),TSC.ORDER_NUMBER,TSC.LINE_ID";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);								  
		statement.setInt(1,806);
		statement.setInt(2,41);
		statement.setInt(3,806);
		ResultSet rs=statement.executeQuery();		
		while (rs.next())
		{
			if (icnt ==0)
			{
			%>
	<table width="100%">
		<tr>
			<td style="font-size:10px;color:#000000;font-family:Tahoma,Georgia">Notice:No change field please keep blank.</td>
			<td style="font-size:10px;color:#000000;font-family:Tahoma,Georgia" align="right">Qty Uom：PCE</td>
		</tr>
	</table>
	<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
		<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:10px" align="center">
			<td width="3%" rowspan="2">Seq No</td>
			<td width="8%" rowspan="2">Customer</td>
			<td width="6%" rowspan="2">TSCH MO#</td>
			<td width="3%" rowspan="2">MO Line#</td>
			<td width="8%" rowspan="2">TSC Part No</td>
			<td width="8%" rowspan="2">Cust Part No</td>
			<td width="8%" rowspan="2">Cust PO</td>
			<td width="4%" rowspan="2">PO Line#</td>
			<td width="5%" rowspan="2">CRD</td>
			<td width="4%" rowspan="2">Qty</td>
			<td width="2%" rowspan="2"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
			<td width="5%" rowspan="2">New CRD</td>
			<td width="5%" rowspan="2">New Qty</td>
			<td width="31%" colspan="7">TSC Order Info</td>
		</tr>
		<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:10px" align="center">
			<td>MO#</td>
			<td>Line#</td>
			<td>Orig Qty</td>
			<td>Orig SSD</td>
			<td>New SSD</td>
			<td>New Qty</td>
			<td>Remarks</td>
		</tr>
	
	<%		
			}
			new_qty="";
			v_edit_flag = rs.getString("TSC_EDIT_FLAG");
			if (v_edit_flag.equals("Y"))
			{
				v_font_color ="#000000";
			}
			else
			{
				v_font_color ="#0000FF";
			}
			if (rs.getString("TSC_ORDER_NUMBER")==null)
			{
				v_disabled = "disabled";
			}
			else
			{
				v_disabled = "";
			}
			if (tsch_line_id != rs.getInt("LINE_ID"))
			{
				tsch_line_id= rs.getInt("LINE_ID");
				merge_line= rs.getInt("TSCH_TO_TSC_ORDER_CNT");
				tsc_order_cnt =1;
				if (rs.getString("NEW_QTY")==null)
				{
					change_qty = 0;
				}
				else
				{
					change_qty = Long.parseLong(rs.getString("NEW_QTY"))-Long.parseLong(rs.getString("QTY"));
				}
				if (change_qty !=0 && v_edit_flag.equals("Y"))
				{
					new_qty = ""+(Long.parseLong(rs.getString("ORDERED_QUANTITY"))+(change_qty));
					change_qty=0;
				}
		%>
				<tr id="tr_<%=(icnt+1)%>" <%=(ACODE.equals("UPLOAD")?"style='background-color:#daf1a9'":"")%>>
					<td align="left" rowspan="<%=merge_line%>"><%=(icnt+1)%><input type="hidden" name="TSC_ORDER_CNT_<%=(icnt+1)%>" value="<%=merge_line%>"></td>
					<td align="left" rowspan="<%=merge_line%>"><%=rs.getString("CUSTOMER_NAME")%></td>
					<td align="center" rowspan="<%=merge_line%>"><%=rs.getString("ORDER_NUMBER")%><input type="hidden" name="ORDER_NUMBER_<%=(icnt+1)%>" value="<%=rs.getString("ORDER_NUMBER")%>"></td>
					<td align="center" rowspan="<%=merge_line%>" title="<%=rs.getString("STATUS")%>"><%=rs.getString("line_no")%></td>
					<td align="left" rowspan="<%=merge_line%>"><%=(rs.getString("TSC_PARTNO")==null?"&nbsp;":rs.getString("TSC_PARTNO"))%><input type="hidden" name="TSCITEMID_<%=(icnt+1)%>" value="<%=rs.getString("TSC_ITEMID")%>"></td>
					<td align="left" rowspan="<%=merge_line%>"><%=(rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))%><input type="hidden" name="CUSTITEMID_<%=(icnt+1)%>" value="<%=rs.getString("CUST_ITEMID")%>"></td>
					<td align="left" rowspan="<%=merge_line%>"><%=(rs.getString("CUST_PO")==null?"&nbsp;":rs.getString("CUST_PO"))%></td>
					<td align="left" rowspan="<%=merge_line%>"><%=(rs.getString("CUST_PO_LINE")==null?"&nbsp;":rs.getString("CUST_PO_LINE"))%></td>
					<td align="center" rowspan="<%=merge_line%>"><%=rs.getString("CRD")%><input type="hidden" name="CRD_<%=(icnt+1)%>" value="<%=rs.getString("CRD")%>"></td>
					<td align="right" rowspan="<%=merge_line%>"><%=rs.getString("QTY")%><input type="hidden" name="QTY_<%=(icnt+1)%>" value="<%=rs.getString("QTY")%>"></td>
					<td align="center" rowspan="<%=merge_line%>"><input type="checkbox" name="chk" value="<%=(icnt+1)%>" onClick="setCheck(<%=icnt%>)" <%=(ACODE.equals("UPLOAD")?"checked":"")%> <%=v_disabled%>><input type="hidden" name="LINE_<%=(icnt+1)%>" value="<%=rs.getString("line_id")%>"><input type="hidden" name="TSC_ORDER_CLOSE_CNT_<%=(icnt+1)%>" value="<%=rs.getInt("TSC_ORDER_CLOSE_CNT")%>"></td>
					<td align="center" rowspan="<%=merge_line%>"><input type="text" name="NEW_CRD_<%=(icnt+1)%>" value="<%=(rs.getString("NEW_CRD")==null?"":rs.getString("NEW_CRD"))%>" size="6" style="font-size:10px;font-family:arial" onBlur="setLineCheck(<%=(icnt+1)%>,'DATE')"  <%=v_disabled%>></td>
					<td align="center" rowspan="<%=merge_line%>"><input type="text" name="NEW_QTY_<%=(icnt+1)%>" value="<%=(rs.getString("NEW_QTY")==null?"":rs.getString("NEW_QTY"))%>" size="6" style="font-size:10px;font-family:arial" onBlur="setLineCheck(<%=(icnt+1)%>,'QTY')"  <%=v_disabled%>></td>
					<td align="center" style="color:<%=v_font_color%>"><%=(rs.getString("TSC_ORDER_NUMBER")==null?"&nbsp;":rs.getString("TSC_ORDER_NUMBER"))%><input type="hidden" name="TSC_MO_HEADER_ID_<%=(icnt+1)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("TSC_HEADER_ID")==null?"":rs.getString("TSC_HEADER_ID"))%>"></td>
					<td align="center" style="color:<%=v_font_color%>" title="<%=rs.getString("TSC_FLOW_STATUS_CODE")%>"><%=(rs.getString("TSC_LINE_NUMBER")==null?"&nbsp;":rs.getString("TSC_LINE_NUMBER"))%><input type="hidden" name="TSC_MO_LINE_ID_<%=(icnt+1)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("TSC_LINE_ID")==null?"":rs.getString("TSC_LINE_ID"))%>"></td>
					<td align="right" style="color:<%=v_font_color%>"><%=(rs.getString("ORDERED_QUANTITY")==null?"&nbsp;":rs.getString("ORDERED_QUANTITY"))%><input type="hidden" name="TSC_ORIG_QTY_<%=(icnt+1)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("ORDERED_QUANTITY")==null?"":rs.getString("ORDERED_QUANTITY"))%>"></td>
					<td align="center" style="color:<%=v_font_color%>"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%><input type="hidden" name="TSC_ORIG_SSD_<%=(icnt+1)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"":rs.getString("SCHEDULE_SHIP_DATE"))%>"></td>
					<td align="center"><input type="text" name="TSC_NEW_SSD_<%=(icnt+1)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("NEW_TSC_SSD")==null || !v_edit_flag.equals("Y")?"":rs.getString("NEW_TSC_SSD"))%>" SIZE="6"  style="text-align:center;font-size:10px;font-family:arial;color:<%=v_font_color%>" <%=v_edit_flag.equals("N")?" readonly ":""%> <%=v_disabled%> <%=(v_edit_flag.equals("Y")?"":"disabled")%>></td>
					<td align="center"><input type="text" name="TSC_NEW_QTY_<%=(icnt+1)%>_<%=tsc_order_cnt%>" value="<%=new_qty%>" SIZE="5" style="text-align:right;font-size:10px;font-family:arial;color:<%=v_font_color%>" <%=v_edit_flag.equals("N")?" readonly ":""%> <%=v_disabled%> <%=(v_edit_flag.equals("Y")?"":"disabled")%>></td>
					<td align="center"><input type="text" name="REMARKS_<%=(icnt+1)%>_<%=tsc_order_cnt%>"  value="<%=(rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))%>" SIZE="6" style="font-size:10px;font-family:arial;color:<%=v_font_color%>" <%=v_edit_flag.equals("N")?" readonly ":""%> <%=v_disabled%> <%=(v_edit_flag.equals("Y")?"":"disabled")%>></td>
				</tr>
	<%
				icnt++;
			}
			else
			{
				if (change_qty !=0 && v_edit_flag.equals("Y"))
				{
					new_qty = ""+(Long.parseLong(rs.getString("ORDERED_QUANTITY"))+(change_qty));
					change_qty=0;
				}
	%>
				<tr id="tr_<%=(icnt)%>" <%=(ACODE.equals("UPLOAD")?"style='background-color:#daf1a9'":"")%>>
					<td align="center" style="color:<%=v_font_color%>"><%=(rs.getString("TSC_ORDER_NUMBER")==null?"&nbsp;":rs.getString("TSC_ORDER_NUMBER"))%><input type="hidden" name="TSC_MO_HEADER_ID_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("TSC_HEADER_ID")==null?"":rs.getString("TSC_HEADER_ID"))%>"></td>
					<td align="center" style="color:<%=v_font_color%>" title="<%=rs.getString("TSC_FLOW_STATUS_CODE")%>"><%=(rs.getString("TSC_LINE_NUMBER")==null?"&nbsp;":rs.getString("TSC_LINE_NUMBER"))%><input type="hidden" name="TSC_MO_LINE_ID_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("TSC_LINE_ID")==null?"":rs.getString("TSC_LINE_ID"))%>"></td>
					<td align="right" style="color:<%=v_font_color%>"><%=(rs.getString("ORDERED_QUANTITY")==null?"&nbsp;":rs.getString("ORDERED_QUANTITY"))%><input type="hidden" name="TSC_ORIG_QTY_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("ORDERED_QUANTITY")==null?"":rs.getString("ORDERED_QUANTITY"))%>"></td>
					<td align="center" style="color:<%=v_font_color%>"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%><input type="hidden" name="TSC_ORIG_SSD_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"":rs.getString("SCHEDULE_SHIP_DATE"))%>"></td>
					<td align="center"><input type="text" name="TSC_NEW_SSD_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("NEW_TSC_SSD")==null || !v_edit_flag.equals("Y") ?"":rs.getString("NEW_TSC_SSD"))%>" SIZE="6" style="text-align:center;font-size:10px;font-family:arial;color:<%=v_font_color%>" <%=v_edit_flag.equals("N")?" readonly ":""%> <%=v_disabled%> <%=(v_edit_flag.equals("Y")?"":"disabled")%>></td>
					<td align="center"><input type="text" name="TSC_NEW_QTY_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=new_qty%>" SIZE="5" style="text-align:right;font-size:10px;font-family:arial;color:<%=v_font_color%>" <%=v_edit_flag.equals("N")?" readonly ":""%> <%=v_disabled%> <%=(v_edit_flag.equals("Y")?"":"disabled")%>></td>
					<td align="center"><input type="text" name="REMARKS_<%=(icnt)%>_<%=tsc_order_cnt%>" value="<%=(rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))%>" SIZE="6" style="font-size:10px;font-family:arial;color:<%=v_font_color%>" <%=v_edit_flag.equals("N")?" readonly ":""%> <%=v_disabled%> <%=(v_edit_flag.equals("Y")?"":"disabled")%>></td>
				</tr>
	<%
			}
			tsc_order_cnt++;
		}
		if (icnt >0)
		{
		%>
	</table>
	<hr>
	<table border="0" width="100%" bgcolor="#CEEAD7">
		<tr>
			<td align="center">
				<input type="button" name="save1" value="Submit" onClick='setSubmit1("../jsp/TSCHSalesOrderReviseProcess.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">
				&nbsp;&nbsp;&nbsp;<input type="button" name="exit1" value="Exit" onClick='setClose()' style="font-family: Tahoma,Georgia;">
			</td>
		</tr>
	</table>
		<%
		}
		else
		{
			out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
		}
		rs.close();
		statement.close();
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font style='font-size:11px;color:#ff0000'>Exception1:"+e.getMessage()+"</font></div>");
}
%>
<input type="hidden" name="sys_date" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

