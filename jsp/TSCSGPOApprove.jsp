<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Confirm for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<%@ page import="Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="FactoryCFMBean" scope="session" class="Array2DimensionInputBean"/>
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
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
		document.getElementById("REMARKS_"+lineid).style.backgroundColor ="#daf1a9";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.getElementById("REMARKS_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	var id="";
	if (document.MYFORM.chk.length != undefined)
	{
		chk_len = document.MYFORM.chk.length;
	}
	else
	{
		chk_len = 1;
	}

	for (var i =0 ; i < chk_len ;i++)
	{
		if (chk_len==1)
		{
			chkflag = document.MYFORM.chk.checked; 
			id = document.MYFORM.chk.value;		
		}
		else
		{
			chkflag = document.MYFORM.chk[i].checked; 
			id = document.MYFORM.chk[i].value;		
		}
		if (chkflag==true) chkcnt ++;
	}
	if (chkcnt ==0)
	{
		alert("Please select process data!");
		return false;
	}
	if (document.MYFORM.ACTIONTYPE.value==""||document.MYFORM.ACTIONTYPE.value=="--")
	{
		alert("Please choose action type!");
		document.MYFORM.ACTIONTYPE.focus();
		return false;	
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;	
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
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

</script>
<%
String sql = "";
String REQTYPE=request.getParameter("REQTYPE");
if (REQTYPE==null) REQTYPE="";
String RECEIVE_DATE=request.getParameter("RECEIVE_DATE");
if (RECEIVE_DATE==null) RECEIVE_DATE="";
String RECEIPT_NUM=request.getParameter("RECEIPT_NUM");
if (RECEIPT_NUM==null) RECEIPT_NUM="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String VENDOR_NAME = request.getParameter("VENDOR_NAME");
if (VENDOR_NAME==null) VENDOR_NAME="";
String ACTIONTYPE=request.getParameter("ACTIONTYPE");
if (ACTIONTYPE==null) ACTIONTYPE="";
String STATUS="CHECKED",STATUS1="RETURN",id="";
String remarks="";
int rowcnt=0;
%>
<body> 
<FORM ACTION="../jsp/TSCSGPOApprove.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">SG PO Deliver/Return Confirm </div>
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
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bgcolor="#DAF0FC">
	<tr>
		<td width="4%">Type：</td>
		<td width="6%">
		<%
		try
    	{   
			out.println("<select NAME='REQTYPE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (REQTYPE.equals("") ||REQTYPE.equals("--") ?" selected ":"")+">--");     
           	out.println("<OPTION VALUE='CHECKED'"+ (REQTYPE.equals("CHECKED")?" selected ":"") +">收貨");
           	out.println("<OPTION VALUE='RETURN'"+ (REQTYPE.equals("RETURN")?" selected ":"") +">退貨");
			out.println("</select>"); 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		}		
		%>
		</td>
		<td width="4%">內外銷:</td>   
		<td width="6%">
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
		<!--<select NAME="ORGCODE" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("887")) out.println("selected");%>>SG1</OPTION>
		<OPTION VALUE="906" <%if (ORGCODE.equals("906")) out.println("selected");%>>SG2</OPTION>
		</select>-->
		</td>
		<td width="8%">Receipt Num ：</td>
		<td width="12%">
		<%
		try
		{   
			sql = "select distinct receipt_num,receipt_num receipt_num1 from oraddman.tssg_po_receive_detail where status ='"+STATUS+"' order by receipt_num";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(RECEIPT_NUM);
			comboBoxBean.setFieldName("RECEIPT_NUM");	
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}		
		%>
		</td>
		<td width="8%">Vendor Name：</td>
		<td width="12%">
		<%
		try
		{   
			sql = " select distinct vendor_name,vendor_name vendor_name1 from oraddman.tssg_po_receive_detail where status ='"+STATUS+"' order by vendor_name";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(VENDOR_NAME);
			comboBoxBean.setFieldName("VENDOR_NAME");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>			
		</td>
		<td width="8%">Item Desc：</td> 
		<td width="12%">
		<%
		try
		{   
			sql = " select distinct item_desc,item_desc item_desc1 from oraddman.tssg_po_receive_detail where status ='"+STATUS+"' order by item_desc";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(ITEMDESC);
			comboBoxBean.setFieldName("ITEMDESC");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>		
		</td>
		<td width="8%">Receive  Date：</td>
		<td width="12%">
		<%
		try
		{   
		
			sql = " select distinct to_char(receive_date,'yyyymmdd') receive_date,to_char(receive_date,'yyyymmdd') receive_date1 from oraddman.tssg_po_receive_detail where status ='"+STATUS+"' order by receive_date";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(12);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(RECEIVE_DATE);
			comboBoxBean.setFieldName("RECEIVE_DATE");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();   	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>	
	</tr>
</TABLE>
  <DIV align="CENTER"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setQuery('../jsp/TSCSGPOApprove.jsp')">&nbsp;&nbsp;
		</DIV>
        <HR>
<%
try
{
	sql = " SELECT * FROM (SELECT a.rcv_group_id"+
	      ",a.po_header_id"+
		  ",a.po_line_id"+
		  ",a.po_line_location_id"+
		  ",a.lot_number"+
		  ",a.date_code"+
		  ",case a.status when '"+STATUS+"' then a.rcv_qty else a.return_qty end /1000 rcv_qty"+
		  ",a.po_no"+
		  ",nvl(d.vendor_site_code,a.vendor_name) vendor_name"+
		  ",a.inventory_item_id"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",to_char(a.receive_date,'yyyy/mm/dd') receive_date"+
		  ",a.inspect_result"+
		  ",a.inspect_reason"+
		  ",a.inspect_remark"+
		  ",a.receipt_num"+
		  ",a.organization_id"+
		  ",a.vendor_site_id"+
		  ",a.status"+
		  ",b.organization_code"+
		  ",a.receive_trx_id"+
          ",case  b.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else b.organization_code end as organization_name"+
		  ",tsc_inv_category(a.inventory_item_id,43,1100000003) tsc_prod_group"+
		  ",case a.status when '"+STATUS+"' then '收貨' else '退貨' end req_type"+
		  ",a.return_reason"+
		  ",a.rcv_inspect_trx_id"+
		  ",a.created_by"+
		  ",nvl(a.delivery_type,'') delivery_type"+ //add by Peggy 20200424
          ",a.RETURNED_DATE"+ //add by Peggy 20210902
          ",a.buyer_date"+ //add by Peggy 20210902
          ",count(1) over (partition by a.receipt_num) receipt_cnt"+ //add by Peggy 20211129
          ",a.tot_cnt"+   //add by Peggy 20211129
          //" FROM oraddman.tssg_po_receive_detail a"+
		  " FROM (select x.*,(select count(1) from oraddman.tssg_po_receive_detail y where y.receipt_num=x.receipt_num) tot_cnt from oraddman.tssg_po_receive_detail x) a"+
		  ",mtl_parameters b"+
		  ",ap.ap_supplier_sites_all d"+
          " where a.status IN ('"+STATUS+"','"+STATUS1+"')"+
		  " and a.organization_id=b.organization_id"+
		  " and a.vendor_site_id=d.vendor_site_id"+
		  " and round((sysdate-case a.status when '"+STATUS1+"' then a.RETURNED_DATE else a.buyer_date end )*24*60,2)>=2";  //add by Peggy 20210902
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " and a.organization_id='"+ORGCODE+"'";
	}
	if (!ITEMDESC.equals("") && !ITEMDESC.equals("--"))
	{
		sql += " and a.description ='"+ITEMDESC+"'";
	}
	if (!RECEIVE_DATE.equals("") && !RECEIVE_DATE.equals("--"))
	{
		sql += " and a.receive_date =to_date('"+RECEIVE_DATE+"','yyyymmdd')";
	}	
	if (!VENDOR_NAME.equals("") && !VENDOR_NAME.equals("--"))
	{
		sql += " and a.vendor_name ='"+VENDOR_NAME+"'";
	}	
	if (!RECEIPT_NUM.equals("") && !RECEIPT_NUM.equals("--"))
	{
		sql += " and a.receipt_num ='"+RECEIPT_NUM+"'";
	}		
	//sql += ") a where CASE a.status WHEN 'RETURN' then a.tot_cnt else a.receipt_cnt end=a.tot_cnt "+
	sql += ") a where CASE a.status WHEN 'RETURN' then a.tot_cnt else a.tot_cnt end=a.tot_cnt "+
         " order by a.vendor_name,a.receipt_num,a.item_desc,a.receive_date,a.po_line_location_id,a.lot_number";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rowcnt==0)
		{
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#D1E0D3;color:#000000">
		<td width="3%" align="center" style="background-color:#66CCCC;color:#000000">&nbsp;</td>
		<td width="3%" align="center" style="background-color:#66CCCC;color:#000000"><input type="checkbox" name="chkall"  onClick="checkall()" <%=(rs.getString("rcv_inspect_trx_id")==null && rs.getString("status").equals("CHECKED")?"disabled":"")%>></td>
		<td width="6%" align="center" style="background-color:#66CCCC;color:#000000">Remarks</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">Type</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Reason</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">廠商直出</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">內外銷</td>
		<td width="9%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receipt Num</td>
		<td width="9%" style="background-color:#51874E;color:#FFFFFF;" align="center">PO NO</td>
		<td width="11%" style="background-color:#51874E;color:#FFFFFF;" align="center">Vendor Name</td>
		<td width="7%" style="background-color:#51874E;color:#FFFFFF;" align="center">TSC Prod Group</td>
		<td width="10%" style="background-color:#51874E;color:#FFFFFF;" align="center">Item Desc</td>
		<td width="8%" style="background-color:#51874E;color:#FFFFFF;" align="center">Lot Number</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">Date Code</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">Qty(K)</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receive Date</td>
	</tr>
		<%
		}
		id = rs.getString("receive_trx_id");
		rowcnt++;
		%>
	<tr id="tr_<%=id%>">
		<td><%=rowcnt%></td>
		<td id="tda_<%=id%>" align="center">
			<input type="checkbox" name="chk" value="<%=id%>" onClick="setCheck(<%=(rowcnt-1)%>)"></td>
		<td align="center"><input type="text" id="REMARKS_<%=id%>" name="REMARKS_<%=id%>" value="<%=remarks%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;" size="8"></td>
		<td align="center" <%=(rs.getString("status").equals(STATUS)?"style="+'"'+"color:#000000;"+'"':"style="+'"'+"color:#FF0000;"+'"')%>><%=rs.getString("req_type")%><input type="hidden" name="status_<%=id%>" value="<%=rs.getString("status")%>"><input type="hidden" name="createdby_<%=id%>" value="<%=rs.getString("CREATED_BY")%>"></td>
		<td align="center"><%=(rs.getString("return_reason")==null?"&nbsp;":rs.getString("return_reason"))%></td>
		<td align="center" <%=(rs.getString("delivery_type")==null?"":"style='background-color:#FFCCCC'")%>><%=(rs.getString("delivery_type")==null?"&nbsp;":rs.getString("delivery_type"))%></td>
		<td align="center"><%=rs.getString("organization_name")%></td>
		<td align="center"><%=rs.getString("receipt_num")%></td>
		<td align="center"><%=rs.getString("po_no")%></td>
		<td><%=rs.getString("vendor_name")%></td>
		<td><%=rs.getString("tsc_prod_group")%></td>
		<td><%=rs.getString("item_desc")%></td>
		<td><%=rs.getString("lot_number")%></td>
		<td align="center"><%=rs.getString("date_code")%></td>
		<td align="right"><%=(rs.getString("rcv_qty")==null?"&nbsp;":rs.getString("rcv_qty"))%></td>
		<td align="center"><%=(rs.getString("receive_date")==null?"&nbsp;":rs.getString("receive_date"))%></td>
	</tr>	
	<%
	}
	rs.close();
	statement.close();
	
	if (rowcnt >0) 
	{
%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#DAF0FC">
	<tr>
		<td>
		<font style="font-family:Tahoma,Georgia;">Action：</font><select NAME="ACTIONTYPE" style="font-family:Tahoma,Georgia;" onChange="changobj()">
				<OPTION VALUE=-- <%if (ACTIONTYPE.equals("")) out.println("selected");%>>--</OPTION>
		        <OPTION VALUE="AGREE" <%if (ACTIONTYPE.equals("AGREE")) out.println("selected");%>>Agree</OPTION>
		        <OPTION VALUE="REJECT" <%if (ACTIONTYPE.equals("REJECT")) out.println("selected");%>>Reject</OPTION>
				</select>
		<input type="button" name="submit1" value="Submit" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCSGPOReceiveProcess.jsp?TRANSTYPE=APPROVE")'></td>
	</tr>
</table>
<hr>
	<%
	}
	else
	{
		out.println("<div style='color:#0000ff;font-size:16px' align='center'>No Data Found!!</div>");
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='font-size:11px;color:#ff0000'>Exception:"+e.getMessage()+"</div>");
}
%>
<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

