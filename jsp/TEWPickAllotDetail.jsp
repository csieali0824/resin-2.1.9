<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- 20181211 by Peggy,客戶=駱騰, 箱碼固定為I,且放置在箱數前面,例I1,I2-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ page import="java.util.*"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1(URL)
{
	document.MYFORM.save1.disabled=true;
	document.MYFORM.exit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到上頁功能嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit2(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TEW 出貨通知確認</title>
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
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String ADVISE_LINE_ID ="",CARTON_NUM="",PO_LINE_LOCATION_ID="",LOT_NUMBER="",DATE_CODE="",DATE_CODE1="",PO_HEADER_ID="",SEQ_ID="",LOT_QTY="",strColor="";
int rowcnt=0,cartoncnt=0,icnt=0,errcnt=0,tr_flag=0,advise_line_flag=0;
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWPickAllotDetail.jsp" METHOD="post" NAME="MYFORM">
<BR>
<%
try
{	
	if (!ADVISENO.equals(""))
	{
		sql = " select b.* "+
		      " from (SELECT  row_number() over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_cnt,"+
              "               row_number() over(partition by ADVISE_LINE_ID,carton_num order by lot_number) carton_cnt,"+
			  "               sum(LOT_ALLOT_QTY) over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_sum,"+
              "               sum(LOT_ALLOT_QTY) over(partition by ADVISE_LINE_ID,carton_num order by lot_number) carton_sum,"+
              "               count(distinct LOT_NUMBER) over(partition by ADVISE_LINE_ID,CUST_PARTNO,carton_num,DATE_CODE) carton_lot_cnt,"+ //add by Peggy 20150203
			  "       a.* FROM TABLE(TEW_RCV_PKG.GET_LOT_ALLOT_VIEW(?)) a"+
			  "      ) b "+
			  "  order by CARTON_NUM,ADVISE_LINE_ID,ADVISE_LINE_CNT desc,CARTON_CNT desc";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISENO);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{
			if (icnt ==0)
			{
		%>
			<table cellSpacing="0" bordercolordark="#CCCCCC"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" >
				<tr><td><div id="div1" style="font-weight:bold;font-size:13px">Advise No：<font color="#0000CC"><%=ADVISENO%></font>&nbsp;&nbsp;&nbsp;&nbsp;出貨日期：<font color="#0000CC"><%=rs.getString("SCHEDULE_SHIP_DATE")%></font></div></td>
					<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>	
				</tr>		
			</table>	
			<table cellSpacing="0" bordercolordark="#CCCCCC"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1" >
				<tr bgcolor="#538079" style="text-shadow:#FFFFFF;color:#FFFFFF;font-family:'細明體';font-size:11px">
					<td width="6%">供應商</td>
					<td width="7%">MO#</td>
					<td width="13%">型號</td>            
					<td width="5%" align="center">訂單量(K)</td>            
					<td width="9%">客戶品號</td>            
					<td width="11%">客戶PO</td>            
					<td width="12%">嘜頭</td>
					<td width="6%">出貨方式</td>            
					<td width="5%">C/NO</td>            
					<td width="8%">LOT</td>            
					<td width="5%">Date Code</td>            
					<td width="6%" align="center">撿貨量(K)</td>            
					<td width="7%" align="center">小計(K)</td>            
				</tr>
	<%		
			}
			PO_LINE_LOCATION_ID = rs.getString("PO_LINE_LOCATION_ID");
			LOT_NUMBER=rs.getString("LOT_NUMBER");
			DATE_CODE=rs.getString("DATE_CODE");
			PO_HEADER_ID=rs.getString("PO_HEADER_ID");
			SEQ_ID=rs.getString("SEQ_ID");
			LOT_QTY=rs.getString("LOT_ALLOT_QTY");
			tr_flag=1;advise_line_flag=1;

			if (!ADVISE_LINE_ID.equals(rs.getString("ADVISE_LINE_ID")))
			{
				rowcnt = rs.getInt("ADVISE_LINE_CNT");
				ADVISE_LINE_ID =rs.getString("ADVISE_LINE_ID");
				cartoncnt = rs.getInt("CARTON_CNT");
				CARTON_NUM = rs.getString("CARTON_NUM");
				DATE_CODE1=DATE_CODE;
				tr_flag=0;advise_line_flag=0;
			%>
				<tr>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("VENDOR_SITE_CODE")%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("so_no")%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("item_desc")%></td>
					<td style="vertical-align:top;color:#0000FF;font-weight:bold;font-size:12px;text-align:right;" rowspan="<%=rowcnt%>"><%=(new DecimalFormat("######.###")).format(rs.getFloat("SHIP_QTY")/1000)+"&nbsp;&nbsp;&nbsp;"%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=(rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("CUST_PO")%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("shipping_method")%></td>
			<%
				//add by Peggy 20140902,channel well客戶箱碼在前面
				if (rs.getString("SHIPPING_REMARK") != null && ((rs.getString("SHIPPING_REMARK").length()>=12 && rs.getString("SHIPPING_REMARK").substring(0,12).equals("CHANNEL WELL")) || (rs.getString("SHIPPING_REMARK").indexOf("駱騰")>=0)))
				{
			%>
					<td rowspan="<%=cartoncnt%>"><%=rs.getString("POST_FIX_CODE")+CARTON_NUM%></td>
			<%
				}
				else
				{
			%>
					<td rowspan="<%=cartoncnt%>"><%=CARTON_NUM+rs.getString("POST_FIX_CODE")%></td>
			<%
				}	
			}				
			
			if (!CARTON_NUM.equals(rs.getString("CARTON_NUM")))
			{
				cartoncnt = rs.getInt("CARTON_CNT");
				CARTON_NUM = rs.getString("CARTON_NUM");
				DATE_CODE1=DATE_CODE;
				if (tr_flag==1)
				{
					out.println("<tr style='font-size:11px'>");
					tr_flag=0;
				}
				//add by Peggy 20140902,channel well客戶箱碼在前面
				if (rs.getString("SHIPPING_REMARK") != null && ((rs.getString("SHIPPING_REMARK").length()>=12 && rs.getString("SHIPPING_REMARK").substring(0,12).equals("CHANNEL WELL")) || (rs.getString("SHIPPING_REMARK").indexOf("駱騰")>=0)))
				{
			%>
					<td rowspan="<%=cartoncnt%>"><%=rs.getString("POST_FIX_CODE")+CARTON_NUM%></td>
			<%
				}
				else
				{
			%>
					<td rowspan="<%=cartoncnt%>"><%=CARTON_NUM+rs.getString("POST_FIX_CODE")%></td>
			<%
				}
			}
			if (tr_flag==1)
			{
				out.println("<tr style='font-size:11px'>");
				tr_flag=0;
			}	
			//if ((!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")) || PO_LINE_LOCATION_ID.equals("0")) errcnt ++;
			if ((!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")) || PO_LINE_LOCATION_ID.equals("0") || (rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2)) errcnt ++;  //add by Peggy 20150203
			
			%>
					<td><%=(((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || PO_LINE_LOCATION_ID.equals("0") || (!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")))?"<font style='color:#ff0000;font-weight:bold'>":"<font color='black'>")%><%=LOT_NUMBER%></font><input type="checkbox" name="chk" value="<%=(icnt+1)%>" style="width:0;visibility:hidden" checked>
					<input type="hidden" name="ADVISE_HEADER_ID_<%=(icnt+1)%>" value="<%=rs.getString("advise_header_id")%>">
					<input type="hidden" name="ADVISE_LINE_ID_<%=(icnt+1)%>" value="<%=rs.getString("advise_line_id")%>">
					<input type="hidden" name="CARTON_NUM_<%=(icnt+1)%>" value="<%=CARTON_NUM%>">
					<input type="hidden" name="PO_LINE_LOCATION_ID_<%=(icnt+1)%>" value="<%=PO_LINE_LOCATION_ID%>">
					<input type="hidden" name="PO_HEADER_ID_<%=(icnt+1)%>" value="<%=PO_HEADER_ID%>">
					<input type="hidden" name="LOT_<%=(icnt+1)%>" value="<%=LOT_NUMBER%>">
					<input type="hidden" name="DATECODE_<%=(icnt+1)%>" value="<%=DATE_CODE%>">
					<input type="hidden" name="LOT_QTY_<%=(icnt+1)%>" value="<%=LOT_QTY%>">
					<input type="hidden" name="SEQ_ID_<%=(icnt+1)%>" value="<%=SEQ_ID%>">
					</td>
					<td><%=(((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || PO_LINE_LOCATION_ID.equals("0") || (!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")))?"<font style='color:#ff0000;font-weight:bold'>":"<font color='black'>")%><%=DATE_CODE%></font></td>
					<td align="right"><%=(((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || PO_LINE_LOCATION_ID.equals("0") ||  (!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")))?"<font style='color:#ff0000;font-weight:bold'>":"<font color='black'>")%><%=(new DecimalFormat("######.###")).format(Float.parseFloat(LOT_QTY)/1000)%></font></td>
			<%
					icnt++;			
					if (advise_line_flag==0)
					{
						if (rs.getFloat("SHIP_QTY")!=rs.getFloat("advise_line_sum"))
						{
							strColor ="#FF0000";
							errcnt ++;
						}
						else
						{	
							strColor ="#0000FF";
						}
			%>
						<td style="color:<%=strColor%>;font-weight:bold;font-size:12px;text-align:right;vertical-align:bottom" rowspan="<%=rowcnt%>"><%=(new DecimalFormat("######.###")).format(rs.getFloat("advise_line_sum")/1000)%></td>					
			<%			
					}
			%>
				</tr>
	<%
		}
		rs.close();
		statement.close();
		if (icnt >0)
		{
	%>
			</table>
			<HR>	
			<table width="100%">
				<tr><td align="center"><%=(errcnt==0?"<input type='button' name='save1' value='配貨確認' style='font-family:細明體' onClick='setSubmit1("+'"'+"../jsp/TEWPickProcess.jsp"+'"'+")'>&nbsp;&nbsp;&nbsp;":"<input type='button' name='preview1' value='預覽批號分配表' style='font-family:細明體' onClick='setSubmit2("+'"'+"../jsp/TEWPickConfirmExcel.jsp?ADVISENO="+ADVISENO+"&ATYPE=PREVIEW"+'"'+")'>")%>
				<input type="button" name="exit1" value="取消，回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TEWPickAllot.jsp')">
				</td></tr>
			</table>
	<%
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("查無資料,請重新確認,謝謝!");
				location.href="/oradds/jsp/TEWPickAllot.jsp";
			</script>
	<%
		}
	}
}
catch(Exception e)
{
	out.println("<font style='color:#ff0000;font-size:12px'>搜尋資料發生異常!!請洽系統管理人員,謝謝!"+e.getMessage()+"</font>");
}
%>
<input type="hidden" name="ADVISENO" value="<%=ADVISENO%>">
<input type="hidden" name="TRANSTYPE" value="ALLOT">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

