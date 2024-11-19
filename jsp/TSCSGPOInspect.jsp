<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
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
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	var id="",radflag="",i_res="",rcv_trx_id="";
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
		if (chkflag==true)
		{
			radflag="N";
			for(var j = 0; j < document.MYFORM.elements["rdo_"+id].length; j++) 
			{
				if (document.MYFORM.elements["rdo_"+id][j].checked)
				{
					if (j==0 || j==1)
					{ 
						i_res="A";
					}
					else 
					{
						i_res="R"
					}
					if (j>1 && (document.MYFORM.elements["qcrej_"+id].value==null || document.MYFORM.elements["qcrej_"+id].value=="")) 
					{
						alert("Line"+(i+1)+": Please enter a reject reason!!");
						return false;
					}
					radflag="Y";
				}
			}
			if (radflag=="N")
			{
				alert("Line"+(i+1)+": Please choose a result!!");
				return false;
			}
			chkcnt ++;
		}
	}
	if (chkcnt ==0)
	{
		alert("Please select process data!");
		return false;
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;	
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
}

function setRadioPress(Lineno,objValue,id)
{
	if (objValue=="A")
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#C4F8A5";
		document.getElementById("tdb_"+id).style.backgroundColor ="#C4F8A5";
		document.MYFORM.elements["chkno_"+id].style.backgroundColor ="#C4F8A5";
		document.MYFORM.elements["qcrej_"+id].style.backgroundColor ="#C4F8A5";
	}
	else if (objValue=="W")
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#FBF539";
		document.getElementById("tdb_"+id).style.backgroundColor ="#FBF539";
		document.MYFORM.elements["chkno_"+id].style.backgroundColor ="#FBF539";
		document.MYFORM.elements["qcrej_"+id].style.backgroundColor ="#FBF539";
	}
	else
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#FEA398";
		document.getElementById("tdb_"+id).style.backgroundColor ="#FEA398";
		document.MYFORM.elements["chkno_"+id].style.backgroundColor ="#FEA398";
		document.MYFORM.elements["qcrej_"+id].style.backgroundColor ="#FEA398";
	}
	if (document.MYFORM.chk.length != undefined)
	{
		if (document.MYFORM.chk[Lineno-1].disabled==false)
		{
			if (document.MYFORM.chk[Lineno-1].checked==false)
			{
				document.MYFORM.chk[Lineno-1].checked=true;
				setChkboxPress(Lineno,id);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			if (document.MYFORM.chk.checked==false)
			{
				document.MYFORM.chk.checked=true;
				setChkboxPress(Lineno,id);
			}
		}
	}	
}
function checkall()
{
	var id ="";
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{		
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				id =document.MYFORM.chk[i].value;
				if (document.MYFORM.chkall.checked==false)
				{
					setChkboxPress(i+1,id);
				}
				else
				{
					document.MYFORM.elements["rdo_"+id][0].checked=document.MYFORM.chkall.checked;
					document.MYFORM.elements["rdo_"+id][1].checked=false;
					document.MYFORM.elements["rdo_"+id][2].checked=false;
					setRadioPress(i+1,"A",id);
				}
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setRadioPress(1,"A",document.MYFORM.chk[i].value);
		}
	}
}
function setChkboxPress(Lineno,id)
{
	var checkvalue=false;
	if (document.MYFORM.chk.length != undefined)
	{
		checkvalue =document.MYFORM.chk[Lineno-1].checked;
	}
	else
	{
		checkvalue =document.MYFORM.chk.checked;
	}
	if (checkvalue==false)
	{
		for(var i = 0; i < document.MYFORM.elements["rdo_"+id].length; i++) 
		{
			document.MYFORM.elements["rdo_"+id][i].checked=false;
		}
		document.MYFORM.elements["qcrej_"+id].value="";
		document.getElementById("tda_"+id).style.backgroundColor ="#FFFFFF";
		document.getElementById("tdb_"+id).style.backgroundColor ="#FFFFFF";	
		document.MYFORM.elements["chkno_"+id].style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["qcrej_"+id].style.backgroundColor ="#FFFFFF";
	}
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
String STATUS="RECEIVE";
String qc_result="",id="",qc_rej="",qc_remarks="",chkno="";
int rowcnt=0;
%>
<body> 
<FORM ACTION="../jsp/TSCSGPOInspect.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">SG PO Inspect</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
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
		<td width="8%">Receipt Num ：</td>
		<td width="12%">
		<%
		try
		{   
			sql = "select distinct receipt_num,receipt_num receipt_num1 from oraddman.tssg_po_receive_detail where status ='"+STATUS+"' order by receipt_num";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(12);
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
		<td width="8%">內外銷:</td>   
		<td width="12%">
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
		<!--<select NAME="ORGCODE" style="font-size:12px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		<OPTION VALUE="906" <%if (ORGCODE.equals("908")) out.println("selected");%>>SG2</OPTION>
		</select>-->
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
			comboBoxBean.setFontSize(12);
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
			comboBoxBean.setFontSize(12);
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
<br>
  <DIV align="CENTER"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSCSGPOInspect.jsp')">&nbsp;&nbsp;
  </DIV>
        <HR>
<%
try
{
	sql = " SELECT a.rcv_group_id"+
	      ",a.po_header_id"+
		  ",a.po_line_id"+
		  ",a.po_line_location_id"+
		  ",a.lot_number"+
		  ",a.date_code"+
		  ",a.rcv_qty/1000 rcv_qty"+
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
		  ",a.rcv_receive_trx_id"+
		  ",tsc_inv_category(a.inventory_item_id,43,1100000003) tsc_prod_group"+
          ",case  b.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else b.organization_code end as organization_name"+
		  ",nvl(a.delivery_type,'') delivery_type"+ //add by Peggy 20200424
          " FROM oraddman.tssg_po_receive_detail a"+
		  ",mtl_parameters b"+
		  ",ap.ap_supplier_sites_all d"+
          " where a.status='"+STATUS+"'"+
		  " and a.organization_id=b.organization_id"+
		  " and a.vendor_site_id=d.vendor_site_id";
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " and a.organization_id='"+ORGCODE+"'";
	}
	if (!ITEMDESC.equals("") && !ITEMDESC.equals("--"))
	{
		sql += " and a.item_desc ='"+ITEMDESC+"'";
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
	sql += " order by a.vendor_name,a.receipt_num,a.item_desc,a.receive_date,a.po_line_location_id,a.lot_number";
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
		<td width="2%" align="center" style="background-color:#ffffff;color:#000000">&nbsp;</td>
		<td width="2%" align="center" style="background-color:#66CCCC;color:#000000"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
		<td width="23%" align="center" style="background-color:#66CCCC;color:#000000">QC CFM Result</td>
		<td width="6%" align="center" style="background-color:#66CCCC;color:#000000">QC Remark</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">廠商直出</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">內外銷</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receipt Num</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">PO NO</td>
		<td width="11%" style="background-color:#51874E;color:#FFFFFF;" align="center">Vendor Name</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">TSC Prod Group</td>
		<td width="9%" style="background-color:#51874E;color:#FFFFFF;" align="center">Item Desc</td>
		<td width="7%" style="background-color:#51874E;color:#FFFFFF;" align="center">Lot Number</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">Date Code</td>
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">Qty(K)</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receive Date</td>
	</tr>
		<%
		}
		id = rs.getString("receive_trx_id");
		rowcnt++;
		%>
	<tr style="font-size:11px">
		<td align="center"><%=rowcnt%></td>
		<td id="tda_<%=id%>" align="center" <%=(qc_result.equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(qc_result.equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>>
			<input type="checkbox" name="chk" value="<%=id%>" onClick="setChkboxPress('<%=rowcnt%>','<%=id%>')" <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>></td>
		<td id="tdb_<%=id%>" <%=(qc_result.equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(qc_result.equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':(qc_result.equals("W")?"style="+'"'+"background-color:#FBF539;"+'"':"")))%>>
			<input type="radio" name="rdo_<%=id%>" value="A" onClick="setRadioPress('<%=rowcnt%>','A','<%=id%>')" <%=(qc_result.equals("A")?" checked":"")%> <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>>
			Accept
		    <input type="radio" name="rdo_<%=id%>" value="W" onClick="setRadioPress('<%=rowcnt%>','W','<%=id%>')" <%=(qc_result.equals("W")?" checked":"")%> <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>>
		    Wave
		    <input type="text" name="chkno_<%=id%>" value="<%=chkno%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;<%=(qc_result.equals("A")?"background-color:#C4F8A5;":(qc_result.equals("R")?"background-color:#FEA398;":(qc_result.equals("W")?"background-color:#FBF539;":"")))%>" size="8" <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>>
		    <input type="radio" name="rdo_<%=id%>" value="R" onClick="setRadioPress('<%=rowcnt%>','R','<%=id%>')" <%=(qc_result.equals("R")?" checked":"")%> <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>>
		    Reject
		    <input type="text" name="qcrej_<%=id%>" value="<%=qc_rej%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;<%=(qc_result.equals("A")?"background-color:#C4F8A5;":(qc_result.equals("R")?"background-color:#FEA398;":(qc_result.equals("W")?"background-color:#FBF539;":"")))%>" size="8" <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>>
		</td>
		<td align="center"><input type="text" name="qcremark_<%=id%>" value="<%=qc_remarks%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;" size="8" <%=(rs.getString("rcv_receive_trx_id")==null?"disabled":"")%>></td>
		<td align="center" <%=(rs.getString("delivery_type")==null?"":"style='background-color:#FFCCCC'")%>><%=(rs.getString("delivery_type")==null?"&nbsp;":rs.getString("delivery_type"))%></td>
		<td align="center"><%=rs.getString("organization_name")%></td>
		<td align="center"><%=(rs.getString("receipt_num")==null?"&nbsp;":rs.getString("receipt_num"))%></td>
		<td align="center"><%=rs.getString("po_no")%></td>
		<td><%=rs.getString("vendor_name")%></td>
		<td><%=rs.getString("tsc_prod_group")%></td>
		<td><%=rs.getString("item_desc")%></td>
		<td><%=rs.getString("lot_number")%></td>
		<td align="center"><%=rs.getString("date_code")%></td>
		<td align="right"><%=(rs.getString("rcv_qty")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("rcv_qty"))))%></td>
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
		<td align="center"><input type="button" name="submit1" value="Submit" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCSGPOReceiveProcess.jsp?TRANSTYPE=INSPECT")'></td>
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

