<!--modify by Peggy 20141124,同筆採購單同一項次同次收貨,會有相同LOT但不同Date code,故要改lot+date code不可重複-->
<!--modify by Peggy 20160824,lot第一碼必須為英文字-->
<!--modify by Peggy 20170920,新增remarks欄位-->
<!--modify by Peggy 20171205,檢查供應商來貨D/C是否符FIFO,不符者需填入原因-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TEW Receiving Detail</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<script language="JavaScript" type="text/JavaScript">
function setAddLine(URL)
{
	var TXTLINE = document.MYFORMD.TXTLINE.value;
	if (TXTLINE == "" || TXTLINE == null || TXTLINE == "null")
	{
		alert("請輸入欲新增行數!");
		document.MYFORMD.TXTLINE.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+$/;
		if (TXTLINE.match(regex)==null) 
		{ 
    		alert("數量必須是整數數值型態!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;
		} 
		else if (parseInt(TXTLINE)<1 || parseInt(TXTLINE)>10)
		{
    		alert("行數新增範圍1~10!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;		
		}
	}

	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}
function setDelete(objLine)
{
	if (confirm("您確定要刪除Line No:"+objLine+"所有資料嗎?"))
	{
		for (var i = objLine ; i <= document.MYFORMD.LINECNT.value ; i++)
		{
			if ( i < document.MYFORMD.LINECNT.value)
			{
				document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].value = document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+(i+1)].value;
				document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].value = document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+(i+1)].value;
				document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+i].value = document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+(i+1)].value;
				document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+i].value = document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+(i+1)].value;
				document.MYFORMD.elements["REMARKS_"+document.MYFORMD.ID.value+"_"+i].value = document.MYFORMD.elements["REMARKS_"+document.MYFORMD.ID.value+"_"+(i+1)].value;
				document.MYFORMD.elements["NO_FIFO_REASON_"+document.MYFORMD.ID.value+"_"+i].value = document.MYFORMD.elements["NO_FIFO_REASON_"+document.MYFORMD.ID.value+"_"+(i+1)].value;
			}
			else
			{
				document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].value = "";
				document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].value = "";
				document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+i].value = "";
				document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+i].value = "";
				document.MYFORMD.elements["REMARKS_"+document.MYFORMD.ID.value+"_"+i].value = "";
				document.MYFORMD.elements["NO_FIFO_REASON_"+document.MYFORMD.ID.value+"_"+i].value = "";
			}
		}
		ComputeQty(0);
	}
	else
	{
		return false;
	}
}
function ComputeQty(line)
{
	var LINENUM = document.MYFORMD.LINECNT.value;
	var totQty =0,Qty=0;
	var num1, num2, m, c;
	if (isNaN(document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+line].value))
	{
		document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+line].value="";
		alert("請輸入數字型態!!");
		return false;
	}	
	for (var i = 1 ; i <= LINENUM ; i ++)
	{
		Qty = document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+i].value;
    	try 
		{ 
			num1 = Qty.toString().split(".")[1].length 
		} 
		catch (e) { num1 = 0 }
        try 
		{
			num2 = totQty.toString().split(".")[1].length 
		} catch (e) { num2 = 0 }
        c = Math.abs(num1 - num2);
        m = Math.pow(10, Math.max(num1, num2))
        if (c > 0) 
		{
            var cm = Math.pow(10, c);
            if (num1 > num2) 
			{
                Qty = Number(Qty.toString().replace(".", ""));
                totQty = Number(totQty.toString().replace(".", "")) * cm;
            }
            else 
			{
                Qty = Number(Qty.toString().replace(".", "")) * cm;
                totQty = Number(totQty.toString().replace(".", ""));
            }
        }
        else 
		{
            Qty = Number(Qty.toString().replace(".", ""));
            totQty = Number(totQty.toString().replace(".", ""));
        }
        totQty = (Qty + totQty) / m;
	}
	if (parseFloat(document.MYFORMD.UNRECEIVEQTY.value) < parseFloat(totQty))
	{
		alert("數量不可超收!");
		document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+line].value="";
		document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+line].focus();
	}
	else
	{
		document.MYFORMD.TOTQTY.value = totQty;
	}
}
function setSubmit(URL)
{
	var v_date = "",rec_year="",rec_month="",rec_day="";v_lot="",v_dc="",v_qty="";
	var v_code = "";//add by Peggy 20160824
	for (var i =1 ; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].style.backgroundColor="#FFFFFF";
		document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+i].style.backgroundColor="#FFFFFF";
		v_lot = document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].value;
		v_date =document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].value;
		v_dc =document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+i].value;
		v_qty =document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+i].value;
		
		if (v_lot !="" || v_date !="" || v_dc !="" || v_qty !="")
		{
			if (v_date =="")
			{
				alert("請輸入收料日期!!");
				document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].focus();
				return false;
			}
			else if (v_date.length!=8)
			{
				alert("收料日期格式錯誤(正確格式為YYYYMMDD)!!");
				document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].focus();
				return false;			
			}
			else
			{
				rec_year = v_date.substr(0,4);
				rec_month= v_date.substr(4,2);
				rec_day  = v_date.substr(6,2);
				if (rec_month <1 || rec_month >12)
				{
					alert("收料月份有誤!!");
					document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].focus();
					return false;			
				}	
				else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
				{
					alert("收料日期有誤!!");
					document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].focus();
					return false;			
				} 
				else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
				{
					alert("收料日期有誤!!");
					document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].focus();
					return false;			
				} 
				else if (rec_month == 2)
				{
					if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
					{
						alert("收料日期有誤!!");
						document.MYFORMD.elements["RECEIVE_DATE_"+document.MYFORMD.ID.value+"_"+i].focus();
						return false;	
					}		
				}
			}
			if (v_lot =="")
			{
				alert("請輸入LOT NUMBER!!");
				document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].focus();
				return false;
			}	
			else 
			{
				//檢查第一碼是否為英文字
				v_code = v_lot.substr(0,1).charCodeAt();
				if (v_code < 65 || v_code > 90)
				{
					alert("LOT第一碼必須是大寫英文字!!");
					document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].focus();
					return false;
				}
				
				for (var j =i+1 ; j <= document.MYFORMD.LINECNT.value ; j++)
				{
					document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+j].style.backgroundColor="#FFFFFF";
					//if (v_lot == document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+j].value)
					if (v_lot == document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+j].value && v_dc == document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+j].value)
					{
						document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+i].style.backgroundColor="#FF9999";
						document.MYFORMD.elements["LOT_"+document.MYFORMD.ID.value+"_"+j].style.backgroundColor="#FF9999";
						document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+i].style.backgroundColor="#FF9999";
						document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+j].style.backgroundColor="#FF9999";
						alert("LOT Number + Date Code不可重覆!!")
						return false;
					}
				}
			}
			if (v_dc =="")
			{
				alert("請輸入DATE CODE!!");
				document.MYFORMD.elements["DC_"+document.MYFORMD.ID.value+"_"+i].focus();
				return false;
			}
			else if (document.MYFORMD.LASTDATECODE.value>v_dc) //檢查D/C是否按FIFO,若沒有要填原因,add by Peggy 20171205
			{
				 if (document.MYFORMD.elements["NO_FIFO_REASON_"+document.MYFORMD.ID.value+"_"+i].value=="")
				 {
				 	alert("請填未按FIFO收貨原因");
					return false;
				 }
			}
								
			if (v_qty==null || v_qty=="" || isNaN(v_qty))
			{
				document.MYFORMD.elements["QTY_"+document.MYFORMD.ID.value+"_"+i].focus();
				alert("請輸入數字型態!!");
				return false;
			}	
		}		
	}
	window.opener.document.getElementById("div_"+document.MYFORMD.ID.value).innerHTML  =document.MYFORMD.TOTQTY.value;
	document.MYFORMD.save1.disabled= true;
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
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

function setClose()
{
	window.opener.document.getElementById("div_"+document.MYFORMD.ID.value).innerHTML  =document.MYFORMD.TOTQTY.value;
	this.window.close();
}

function checkDC(dc,obj)
{
	var dclist = document.MYFORMD.DateCodeList.value;
	if (dclist.indexOf("@"+dc+"@") <0)
	{
		alert("Date Code not found!!");
		document.MYFORMD.elements[obj].value="";
		return false;
	}
	if (document.MYFORMD.LASTDATECODE.value>dc)
	{
		document.MYFORMD.elements[obj.replace("DC_","NO_FIFO_REASON_")].style.backgroundColor="#FFCCCC";
	}
	else
	{
		document.MYFORMD.elements[obj.replace("DC_","NO_FIFO_REASON_")].style.backgroundColor="#FFFFFF";
	}
}

function setdate(id,lineno)
{
	if (document.MYFORMD.elements["LOT_"+id+"_"+lineno].value !=null && document.MYFORMD.elements["LOT_"+id+"_"+lineno].value !="")
	{
		if (document.MYFORMD.elements["RECEIVE_DATE_"+id+"_"+lineno].value ==null || document.MYFORMD.elements["RECEIVE_DATE_"+id+"_"+lineno].value=="")
		{
			document.MYFORMD.elements["RECEIVE_DATE_"+id+"_"+lineno].value=document.MYFORMD.SDATE.value;
		}
	}
}
</script>
<%
String sql = "",DateCodeList="",LastReceiveDateCode="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String QTY = request.getParameter("QTY");
if (QTY==null) QTY="0";
String TXTLINE = request.getParameter("TXTLINE");
if (TXTLINE==null) TXTLINE="0";
String LINECNT = request.getParameter("LINECNT");
if (LINECNT==null) LINECNT ="10";
String ORIGCNT=  request.getParameter("ORIGCNT");
if (ORIGCNT ==null) ORIGCNT="";
String TOTQTY = request.getParameter("TOTQTY");
if (TOTQTY ==null) TOTQTY="";
//out.println("ORIGCNT="+ORIGCNT);
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="";
if (ACODE.equals("ADDLINE"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)+Integer.parseInt(TXTLINE));
}
int lineno=0;
%>
<body>  
<FORM ACTION="../jsp/TEWPOReceiveDetail.jsp" METHOD="post" NAME="MYFORMD">
<%
if (!ACODE.equals("SAVE"))
{
	if (!ID.equals(""))
	{
		sql = " SELECT D.vendor_name,A.VENDOR_SITE_ID,A.SEGMENT1 PONO,E.SEGMENT1 ITEM_NAME,E.DESCRIPTION ITEM_DESC,C.QUANTITY,C.UNIT_MEAS_LOOKUP_CODE UOM,C.QUANTITY_RECEIVED,C.QUANTITY_CANCELLED,C.QUANTITY-NVL(C.QUANTITY_RECEIVED,0)-NVL(C.QUANTITY_CANCELLED,0) UNRECEIVE_QTY"+
			  " FROM PO.PO_HEADERS_ALL A,PO.PO_LINES_ALL B,PO.PO_LINE_LOCATIONS_ALL C,AP.AP_SUPPLIERS D ,INV.MTL_SYSTEM_ITEMS_B E"+
			  " WHERE A.ORG_ID =?"+
			  " AND A.ORG_ID=B.ORG_ID"+
			  " AND B.ORG_ID=C.ORG_ID"+
			  " AND A.PO_HEADER_ID = B.PO_HEADER_ID"+
			  " AND B.PO_HEADER_ID = C.PO_HEADER_ID"+
			  " AND B.PO_LINE_ID = C.PO_LINE_ID"+
			  " AND C.LINE_LOCATION_ID =?"+
			  " AND A.vendor_id = D.vendor_id"+
			  " AND B.ITEM_ID = E.INVENTORY_ITEM_ID"+
			  " AND C.SHIP_TO_ORGANIZATION_ID = E.ORGANIZATION_ID";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"41");
		statement.setString(2,ID);
		ResultSet rs=statement.executeQuery();
		int icnt =0;
		int iline =  Integer.parseInt(LINECNT);
		lineno=0;TOTQTY="";
		LastReceiveDateCode="";
		if (rs.next())
		{
			sql = " select date_code "+
			      " from (select a.vendor_site_id,a.item_name,b.date_code,b.creation_date,row_number() over(partition by a.vendor_site_id,a.item_name order by b.creation_date desc) receive_rank"+
			      " from oraddman.tewpo_receive_header a"+
				  " ,oraddman.tewpo_receive_detail b "+
              	  " where a.po_line_location_id=b.po_line_location_id "+
			      " and a.vendor_site_id=?"+
			      " and a.item_name=?"+
			      " and trunc(b.creation_date) <trunc(sysdate)) x where receive_rank=1";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,rs.getString("VENDOR_SITE_ID"));
			statement1.setString(2,rs.getString("ITEM_NAME"));
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{
				LastReceiveDateCode = rs1.getString("date_code");
			}
			rs1.close();	
			statement1.close();			  
	%>
			<TABLE border="0" width="100%">
				<tr>
					<td width="12%" style="font-size:12px" align="right">供應商：</td><TD><%=rs.getString("vendor_name")%></td>
				</tr>
				<tr>
					<td width="12%" style="font-size:12px" align="right">採購單號：</td>
					<td><%=rs.getString("PONO")%></td>
				</tr>
				<tr>
					<td width="12%" style="font-size:12px" align="right">料號 / 型號：</td>
					<td><%=rs.getString("ITEM_NAME")%>&nbsp;/&nbsp;<%=rs.getString("ITEM_DESC")%></td>
				</tr>
				<tr>
					<td width="12%" style="font-size:12px" align="right">未交數量：</td>
					<td style="font-size:13px;font-weight:bold;color:#0000FF"><%=QTY%>&nbsp;&nbsp;&nbsp;<%=rs.getString("UOM")%><input type="hidden" name="UNRECEIVEQTY" value="<%=QTY%>"><input type="hidden" name="LASTDATECODE" value="<%=LastReceiveDateCode%>"></td>
				</tr>
			</TABLE>
			<hr>
			<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
				<tr style="background-color:#006666;color:#FFFFFF;">
					<td width="5%" align="center">&nbsp;</td>
					<td width="8%" align="center">序號</td>
					<td width="12%" align="center">Lot Number</td>
					<td width="10%" align="center">Data Code</td>
					<td width="10%" align="center">收貨數量(K)</td>
					<td width="10%" align="center">收料日期</td>
					<td width="15%" align="center">備註</td>
					<td width="20%" align="center">未按FIFO收貨原因</td>
				</tr>
	<%
				if (ORIGCNT.equals(""))
				{
					String LotArray[][]=POReceivingBean.getArray2DContent();
					if (LotArray!=null)
					{
						for( int i=0 ; i< LotArray.length ; i++ ) 
						{
							//line_location_id
							if (LotArray[i][0] != null && LotArray[i][2] != null && !LotArray[i][2].equals("") && !LotArray[i][0].equals("") && LotArray[i][0].equals(ID))
							{
								lineno++;
							%>
								<tr>
									<td align="center"><input type="button" name="DEL<%=lineno%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=lineno%>)'></td>
									<td align="center"><%=lineno%></td>
									<td align="center"><input type="TEXT" NAME="LOT_<%=ID%>_<%=lineno%>" value="<% if (LotArray[i][2]==null){ out.println("");}else{out.println(LotArray[i][2]);}%>"  style="font-family: Tahoma,Georgia;" size="15" onBlur="setdate(<%=ID%>,<%=lineno%>)"></td>
									<td align="center"><input type="TEXT" NAME="DC_<%=ID%>_<%=lineno%>" value="<% if (LotArray[i][3]==null){ out.println("");}else{out.println(LotArray[i][3]);}%>"   style="font-family: Tahoma,Georgia;" size="10" onChange="checkDC(this.value,'DC_<%=ID%>_<%=lineno%>')"></td>
									<td align="center"><input type="TEXT" NAME="QTY_<%=ID%>_<%=lineno%>" value="<% if (LotArray[i][4]==null){ out.println("");}else{out.println(LotArray[i][4]);}%>"  style="font-family: Tahoma,Georgia;text-align:RIGHT" size="12" onChange="ComputeQty(<%=lineno%>);" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
									<td><input type="TEXT" name="RECEIVE_DATE_<%=ID%>_<%=lineno%>" value="<% if (LotArray[i][1]==null){ out.println("");}else{out.println(LotArray[i][1]);}%>"  style="font-family: Tahoma,Georgia;" size="10" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.RECEIVE_DATE_<%=ID%>_<%=lineno%>);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
									<td align="center"><input type="TEXT" name="REMARKS_<%=ID%>_<%=lineno%>" value="<% if (LotArray[i][5]==null){ out.println("");}else{out.println(LotArray[i][5]);}%>"  style="font-family: Tahoma,Georgia;" size="15"></td>
									<td align="center"><input type="TEXT" name="NO_FIFO_REASON_<%=ID%>_<%=lineno%>" value="<% if (LotArray[i][6]==null){ out.println("");}else{out.println(LotArray[i][6]);}%>"  style="font-family: Tahoma,Georgia;" size="20"></td>
								</tr>							
							<%
								TOTQTY =""+(new DecimalFormat("######.###")).format(Float.parseFloat("0"+TOTQTY)+Float.parseFloat(LotArray[i][4]==null?"0":"0"+LotArray[i][4]));
							}
						}
					}
					ORIGCNT=""+lineno;
					iline = iline-Integer.parseInt(ORIGCNT);
				}
				if (iline>0)
				{
					for (int i =1 ; i <=iline ; i++)
					{
						lineno++;
	%>
						<tr>
							<td align="center"><input type="button" name="DEL<%=lineno%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=lineno%>)'></td>
							<td align="center"><%=lineno%></td>
							<td align="center"><input type="TEXT" NAME="LOT_<%=ID%>_<%=lineno%>" value="<% if (request.getParameter("LOT_"+ID+"_"+lineno)==null){ out.println("");}else{out.println(request.getParameter("LOT_"+ID+"_"+lineno));}%>"  style="font-family: Tahoma,Georgia;" size="15" onBlur="setdate(<%=ID%>,<%=lineno%>)"></td>
							<td align="center"><input type="TEXT" NAME="DC_<%=ID%>_<%=lineno%>" value="<% if (request.getParameter("DC_"+ID+"_"+lineno)==null){ out.println("");}else{out.println(request.getParameter("DC_"+ID+"_"+lineno));}%>"   style="font-family: Tahoma,Georgia;" size="10" onChange="checkDC(this.value,'DC_<%=ID%>_<%=lineno%>')"></td>
							<td align="center"><input type="TEXT" NAME="QTY_<%=ID%>_<%=lineno%>" value="<% if (request.getParameter("QTY_"+ID+"_"+lineno)==null){ out.println("");}else{out.println(request.getParameter("QTY_"+ID+"_"+lineno));}%>"  style="font-family: Tahoma,Georgia;text-align:RIGHT" size="12"  onChange="ComputeQty(<%=lineno%>);"  onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
							<td><input type="TEXT" NAME="RECEIVE_DATE_<%=ID%>_<%=lineno%>" value="<% if (request.getParameter("RECEIVE_DATE_"+ID+"_"+lineno)==null){ out.println("");}else{out.println(request.getParameter("RECEIVE_DATE_"+ID+"_"+lineno));}%>"  style="font-family: Tahoma,Georgia;" size="10" onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.RECEIVE_DATE_<%=ID%>_<%=lineno%>);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
							<td align="center"><input type="TEXT" NAME="REMARKS_<%=ID%>_<%=lineno%>" value="<% if (request.getParameter("REMARKS_"+ID+"_"+lineno)==null){ out.println("");}else{out.println(request.getParameter("REMARKS_"+ID+"_"+lineno));}%>"  style="font-family: Tahoma,Georgia;" size="15"></td>
							<td align="center"><input type="TEXT" NAME="NO_FIFO_REASON_<%=ID%>_<%=lineno%>" value="<% if (request.getParameter("NO_FIFO_REASON_"+ID+"_"+lineno)==null){ out.println("");}else{out.println(request.getParameter("NO_FIFO_REASON_"+ID+"_"+lineno));}%>"  style="font-family: Tahoma,Georgia;" size="20"></td>
						</tr>	
	<%
						TOTQTY =""+(new DecimalFormat("######.###")).format(Float.parseFloat("0"+TOTQTY)+Float.parseFloat(request.getParameter("QTY_"+ID+"_"+lineno)==null?"0":"0"+request.getParameter("QTY_"+ID+"_"+lineno)));
					}
				}
	%>		
				<tr>
					<td  colspan="3" style="border-left-style:none;border-right-style:none;"><input type="button" name="Addline" value="Add Line" style="font-family: Tahoma,Georgia;" onClick='setAddLine("../jsp/TEWPOReceiveDetail.jsp?ACODE=ADDLINE")'><input type="text" NAME="TXTLINE" value="5" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="5"></td>
					<td align="right" style="border-left-style:none;border-right-style:none;">合計：</td>
					<td align="center" style="border-right-style:none"><input type="TEXT" NAME="TOTQTY" value="<% if (TOTQTY==null){ out.println("");}else{out.println(TOTQTY);}%>" style="border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;font-family: Tahoma,Georgia;text-align:RIGHT" size="15" readonly onKeyDown="return (event.keyCode!=8);"></td>
					<td colspan="3" style="border-left-style:none">&nbsp;</td>
				</tr>
			</table>
			<table width="100%">
				<tr>
					<td align="center">
						<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TEWPOReceiveDetail.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">
						&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick='setClose()' style="font-family: Tahoma,Georgia;">
					</td>
				</tr>
			</table>
	<%
			//date code list
			try
			{
				DateCodeList ="";
				sql = " select DISTINCT date_code from tsc.TSC_DATE_CODE where YEAR >= to_char(add_months(sysdate,-36),'yyyy')";
				//out.println(sql);
				Statement statet=con.createStatement();
				ResultSet rst=statet.executeQuery(sql);
				while (rst.next())
				{
					DateCodeList += ("@"+rst.getString("date_code"));
				}
				if (DateCodeList.length() >0)
				{
					DateCodeList +="@";
				}
				rst.close();
				statet.close();	
			}
			catch(Exception e)
			{
				out.println("<font color='red'>Date Code List Exception!!</font>");
			}
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("資料異常,請重新確認,謝謝!");
				this.window.close();
			</script>
	<%
		}
		rs.close();
		statement.close();
	}
}
else
{
	String lot [][] = new String [Integer.parseInt(LINECNT)][7];
	int lot_cnt =0,lot_tot_row=0;
	for (int i =0 ; i < Integer.parseInt(LINECNT) ; i++)
	{
		//out.println(request.getParameter("RECEIVE_DATE_"+ID+"_"+(i+1)));
		//out.println(request.getParameter("LOT_"+ID+"_"+(i+1)));
		if (request.getParameter("RECEIVE_DATE_"+ID+"_"+(i+1))!=null && request.getParameter("LOT_"+ID+"_"+(i+1))!=null)
		{
			lot[i][0] = ID;
			lot[i][1] = request.getParameter("RECEIVE_DATE_"+ID+"_"+(i+1));
			lot[i][2] = request.getParameter("LOT_"+ID+"_"+(i+1));
			lot[i][3] = request.getParameter("DC_"+ID+"_"+(i+1));
			lot[i][4] = request.getParameter("QTY_"+ID+"_"+(i+1));
			lot[i][5] = request.getParameter("REMARKS_"+ID+"_"+(i+1));
			lot[i][6] = request.getParameter("NO_FIFO_REASON_"+ID+"_"+(i+1));
			lot_cnt ++;
		}
	}
	lot_tot_row = lot_cnt;
	String LotArray[][]=POReceivingBean.getArray2DContent();
	if (LotArray!=null)
	{
		if (LotArray.length - Integer.parseInt(ORIGCNT) >0)
		{
			lot_tot_row = lot_tot_row + (LotArray.length - Integer.parseInt(ORIGCNT));	
		}
	}
	String lot_tot [][] = new String [lot_tot_row][7];
	//out.println("lot_tot="+lot_tot.length);
	int iLine=0;
	for (int i = 0 ; i < lot.length ; i++)
	{
		if (lot[i][0]!=null && !lot[i][0].equals("") && lot[i][2] != null && !lot[i][2].equals("") && iLine <=lot_tot.length)
		{
			lot_tot[iLine][0] = lot[i][0];
			lot_tot[iLine][1] = lot[i][1];
			lot_tot[iLine][2] = lot[i][2];
			lot_tot[iLine][3] = lot[i][3];
			lot_tot[iLine][4] = lot[i][4];
			lot_tot[iLine][5] = lot[i][5];
			lot_tot[iLine][6] = lot[i][6];
			iLine ++;
		}
	} 
	if (LotArray!=null)
	{
		for( int i=0 ; i< LotArray.length ; i++ ) 
		{
			if (LotArray[i][0]!=null && !LotArray[i][0].equals("") && LotArray[i][2] != null && !LotArray[i][2].equals("") && !LotArray[i][0].equals(ID) && iLine <= (LotArray.length - Integer.parseInt(ORIGCNT)))
			{
				lot_tot[iLine][0] = LotArray[i][0];
				lot_tot[iLine][1] = LotArray[i][1];
				lot_tot[iLine][2] = LotArray[i][2];
				lot_tot[iLine][3] = LotArray[i][3];
				lot_tot[iLine][4] = LotArray[i][4];
				lot_tot[iLine][5] = LotArray[i][5];
				lot_tot[iLine][6] = LotArray[i][6];
				iLine ++;
			}
		}
	}
	//out.println(lot_tot.length);
	POReceivingBean.setArray2DString(lot_tot);
%>
	<script language="JavaScript" type="text/JavaScript">
		self.close();
	</script>
<%	
}
%>
<input type="hidden" name="ID" value="<%=ID%>">
<input type="hidden" name="QTY" value="<%=QTY%>">
<input type="hidden" name="LINECNT" value="<%=LINECNT%>">
<input type="hidden" name="ORIGCNT" value="<%=ORIGCNT%>">
<input type="hidden" name="DateCodeList" value="<%=DateCodeList%>">
<input type="hidden" name="SDATE" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

