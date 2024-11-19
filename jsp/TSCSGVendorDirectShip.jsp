<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
			setCheck(i);
		}
	}
	else
	{
		document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
		setCheck(1);
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
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
		document.getElementById("div_"+lineid).innerHTML ="&nbsp;";
		document.MYFORM.elements["btn_"+lineid].disabled=false;
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.getElementById("div_"+lineid).innerHTML ="&nbsp;";
		document.MYFORM.elements["btn_"+lineid].disabled=true;	
	}
}
function setSubmit(URL)
{    
	if ((document.MYFORM.SUPPLIERSITEID.value =="" || document.MYFORM.SUPPLIERSITEID.value ==null)  && (document.MYFORM.PONO.value =="" || document.MYFORM.PONO.value ==null) && (document.MYFORM.ITEM.value =="" || document.MYFORM.ITEM.value ==null))
	{
		alert("採購單號或供應商或品名必須擇一輸入,不可同時空白!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
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
			if (document.getElementById("div_"+lineid).innerHTML  =="" || document.getElementById("div_"+lineid).innerHTML  =="&nbsp;" || document.getElementById("div_"+lineid).innerHTML ==null)
			{
				alert("項次"+i+":本次收貨數量必須輸入!");
				return false;
			}
			else
			{
				var receive_qty = document.getElementById("div_"+lineid).innerHTML;
				var unreceive_qty = document.MYFORM.elements["UNRECEIVE_"+lineid].value;
				if (parseFloat(receive_qty) > parseFloat(unreceive_qty))
				{
					alert("本次收貨數量("+receive_qty+")不可大於未收數量("+unreceive_qty+")!");
					return false;
				}
			}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	document.MYFORM.save.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{
	if (document.MYFORM.SUPPLIERSITEID.value =="" || document.MYFORM.SUPPLIERSITEID.value ==null )
	{
		alert("請先指定供應商!");
		return false;
	}
	document.getElementById("alpha").style.width="100%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL+"?ORGCODE="+document.MYFORM.ORGCODE.value+"&VENDORID="+document.MYFORM.SUPPLIERSITEID.value,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
function subWindowSupplierFind(Supplier)
{
	subWin=window.open("../jsp/subwindow/TSCSGPOSupplierFind.jsp?SEARCHSTR="+Supplier+"&ORGCODE="+document.MYFORM.ORGCODE.value,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
function showActionType()
{
	var chvalue="";
	for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
	{
		if (document.MYFORM.rdo1[i].checked)
		{
			 chvalue = document.MYFORM.rdo1[i].value;
			 break;
		}
	}

}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>SG PO Receiving</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String sql = "";
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String SUPPLIERSITEID = request.getParameter("SUPPLIERSITEID");
if (SUPPLIERSITEID==null) SUPPLIERSITEID="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String CUST_ITEM = request.getParameter("CUST_ITEM");
if (CUST_ITEM==null) CUST_ITEM="";
String PO_LINE_LIST="";
float TOTQTY=0;
Hashtable hashtb = (Hashtable)session.getAttribute("H12001");
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE ==null) ACTIONCODE="";
if (ACTIONCODE.equals("UPLOAD"))
{
	if (hashtb!=null)
	{
		Enumeration enkey  = hashtb.keys(); 
		while (enkey.hasMoreElements())   
		{
			PO_LINE_LIST += enkey.nextElement()+","; 
		} 
		if (!PO_LINE_LIST.equals("")) PO_LINE_LIST = PO_LINE_LIST.substring(0,PO_LINE_LIST.length()-1);
		//out.println(PO_LINE_LIST);
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGPOReceive.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;font-family:Tahoma,Georgia;">SG Vendor Direct to Ship</font></strong><BR>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 400px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#BBEAC1">
	<tr>
		<td width="8%">內外銷:</td>   
		<td width="7%">
		<%		
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG1','SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (ORGCODE.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>	
		<!--<select NAME="ORGCODE" style="font-family:ARIAL;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		<OPTION VALUE="906" <%if (ORGCODE.equals("908")) out.println("selected");%>>SG2</OPTION>
		</select>-->
		</td>    
		<td width="8%">供應商:</td>
		<td width="12%"><input type="text" name="SUPPLIER" value="<%=SUPPLIER%>" style="font-family:Arial;font-size:12px" size="15"><input type="hidden" name="SUPPLIERSITEID" value="<%=SUPPLIERSITEID%>"><input type="button"  height="8" name="btnSupplier" value=".." onClick="subWindowSupplierFind(this.form.SUPPLIER.value)"></td>
		<td width="65%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="10" align="center">&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" align="middle"  value='上傳匯入' onClick='setSubmit2("../jsp/TSCSGVendorDirectShipUpload.jsp")' > 
	  </td>
	</tr>
</table> 
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

