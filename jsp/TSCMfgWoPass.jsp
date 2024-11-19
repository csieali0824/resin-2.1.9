<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat"%>
<html>
<head>
<title>MFG System Work Order Expand Process Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFG2DWOExpandBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function submitCheck(ms1,ms2,ms3)
{ //alert("AAA");  
	if (document.DISPLAYREPAIR.ACTIONID.value=="020")  //GENERTED表示為確認工令生成並展開流程卡動作
	{
		flag=confirm(ms2);      
		if (flag==false) return(false);
		else {
			return(true);
		}
	}     
}

function setSubmit(URL,ms1)
{ //alert(); 
	if (document.DISPLAYREPAIR.ACTIONID.value=="020")  //GENERTED表示為確認工令生成並展開流程卡動作
	{
		flag=confirm(ms1);      
		if (flag==false) return(false);
		else {  //alert("BBB");				       		          
		//return(true);
		}
	}  
	//alert("BBB");
	document.DISPLAYREPAIR.submit2.disabled = true;   
	document.DISPLAYREPAIR.action=URL;
	document.DISPLAYREPAIR.submit();
}

function setSubmit1(URL)
{ //alert(); 
	document.DISPLAYREPAIR.action=URL;
	document.DISPLAYREPAIR.submit();
}

function setSubmit2(URL)
{ 
	var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
	document.DISPLAYREPAIR.action=URL+pcAcceptDate;
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

function setDateCode(URL,xDateCodeQty)
{ //alert(); 
	document.DISPLAYREPAIR.DATECODEFLAG.value="Y";
	document.DISPLAYREPAIR.DATECODE.value=xDateCodeQty;
	//alert(xSingleLotQty+"  "+document.DISPLAYREPAIR.SINGLELOTQTY.value);
	document.DISPLAYREPAIR.action=URL;
	document.DISPLAYREPAIR.submit();
}

function subWindowRoutingRefFind(organizationID,itemId,routingRefID,altRoutingDest)
{    
	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
	subWin=window.open("../jsp/subwindow/TSMfgBomRoutingFind.jsp?ORGANIZATIONID="+organizationID+"&PRIMARYITEMID="+itemId+"&ROUTINGREFID="+routingRefID+"&ALTROUTINGDEST="+altRoutingDest,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");  
} 

function setActionChk()
{ //alert(); 
	if (document.DISPLAYREPAIR.ACTIONID.value=="") 
	{
		document.DISPLAYREPAIR.submit2.disabled = true;
	}
	else
	{
		document.DISPLAYREPAIR.submit2.disabled = false;
	}  
}

</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
String actionID = request.getParameter("ACTIONID"); 
String woNo=request.getParameter("WO_NO"); 
String marketType=request.getParameter("MARKETTYPE");
String woType=request.getParameter("WOTYPE");
String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
String startDate=request.getParameter("STARTDATE");
String endDate=request.getParameter("ENDDATE");
String woQty=request.getParameter("WOQTY");
String invItem=request.getParameter("INVITEM");

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

String waferLineNo=request.getParameter("LINE_NO");

String totalYield=request.getParameter("TOTALYIELD");
//String prodModel=request.getParameter("PRODMODEL");
String prodYield=request.getParameter("PRODYIELD");
String result=request.getParameter("RESULT");
String singleLotQty=request.getParameter("SINGLELOTQTY");
String singleControl=request.getParameter("SINGLECONTROL");
//String runCardCount=request.getParameter("RUNCARDCOUNT");
int runCardCount=0;
double runCardCountI=0;
int lastRunCardQty=0;
double runCardCountD=0;
double singleLotQtyD=0;

double runCardQty=0;
// String runCardQty=request.getParameter("RUNCARDQTY");
String reCountFlag=request.getParameter("RECOUNTFLAG");
String  dividedFlag=request.getParameter("DIVIDEDFLAG");
String runCardNo=request.getParameter("RUNCARD_NO");
String runCardPrefix=request.getParameter("RUNCARD_PREFIX");
//String custLot=request.getParameter("CUSTLOT"); // 客戶特殊批號 0: 無設定客戶特殊批號, 1: 需產生客戶特殊批號
String custLotPrefix=request.getParameter("CUSTLOT_PREFIX");  // 客戶批號前置碼

String packageCode="";
String dateCode=request.getParameter("DATECODE");
String dateCodeFlag=request.getParameter("DATECODEFLAG");

//reCountFlag="N";
if (reCountFlag==null || reCountFlag.equals("")) reCountFlag="N";
if (dateCodeFlag==null || dateCodeFlag.equals("")) dateCodeFlag="N";   
//out.print("reCountFlag="+reCountFlag);

String itemId="0", routingId="", alterRoutingDesignator ="", routingRefID="", altRoutingDest=""; 
//organizationId="";
//alternateRoutingDesignator="";   //   

String organizationID=request.getParameter("ORGANIZATIONID");




%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgWoPassMProcess.jsp?WO_NO=<%=woNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->


<BR>
<table align="left"><tr><td colspan="3">

<strong><font color="#FF0000">執行動作-&gt;</font></strong> 
<a name='#ACTION'>
<%	
try
{  
	//out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID not in ('020','021','022') and  x1.LOCALE='"+locale+"'");
	//comboBoxBean.setRs(rs);
	//comboBoxBean.setFieldName("ACTIONID");	   
	//out.println(comboBoxBean.getRsString());
	out.println("<select NAME='ACTIONID' onChange='setActionChk();'>");				  				  
	out.println("<OPTION VALUE=''>--");     
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

%>				  
<INPUT TYPE='button' NAME='submit2' value='Submit' disabled = 'true' onClick='setSubmit("../jsp/TSCMfgWoPassMProcess.jsp?WO_NO=<%=woNo%>","是否執行工令確認?")'>
<%
out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%

	rs.close();       
	statement.close();
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}

%></a></td></tr></table>
<!-- 表單參數 --> 
<INPUT type="hidden" name="RUNCARDCOUNTD" value="<%=runCardCountD%>" > 
<INPUT type="hidden" NAME="RUNCARDQTY" value="<%=runCardQty%>">
<INPUT type="hidden" NAME="DIVIDEDFLAG" value="<%=dividedFlag%>"> 
<INPUT type="hidden" NAME="RUNCARDPREFIX" value="<%=runCardPrefix%>"> 
<INPUT type="hidden" NAME="RUNCARD_NO" value="<%=runCardNo%>"> 
<INPUT type="hidden" NAME="SINGLECONTROL" value="<%=singleControl%>"> 
<INPUT type="hidden" NAME="RECOUNTFLAG" value="<%=reCountFlag%>"> 
<INPUT type="hidden" NAME="DATECODEFLAG" value="<%=dateCodeFlag%>">  
<INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
<INPUT type="hidden" SIZE=5 name="ALTERNATEROUTING" value="<%=alternateRouting%>" readonly>
<INPUT type="hidden" SIZE=5 name="ORGANIZATIONID" value="<%=organizationID%>" readonly>
<INPUT type="hidden" SIZE=1 name="CUSTLOT" value="<%=custLot%>" readonly>
<INPUT type="hidden" SIZE=1 name="CUSTLOT_PREFIX" value="<%=custLotNoPrefix%>" readonly>
</FORM>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
