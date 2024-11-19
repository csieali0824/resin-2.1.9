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
function setUpdate(URL)
{
	var w_width=800;
	var w_height=500;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x+',scrollbars=yes';
	subWin=window.open(URL,"subwin",ww);
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
<title>SG Distribution Lot Detail</title>
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
String DISTRIBUTION_ID = request.getParameter("DISTRIBUTION_ID");
if (DISTRIBUTION_ID==null) DISTRIBUTION_ID="";
String ADVISE_LINE_ID ="",CARTON_NUM="",LOT_NUMBER="",DATE_CODE="",DATE_CODE1="",PO_HEADER_ID="",SEQ_ID="",LOT_QTY="",strColor="",CARTON_NO="",PO_CUST_PARTNO="",DC_YYWW="",DC_YYWW1="";
int rowcnt=0,cartoncnt=0,icnt=0,errcnt=0,tr_flag=0,advise_line_flag=0;
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGLotDistributionDetail.jsp" METHOD="post" NAME="MYFORM">
<BR>
<%
try
{	
	if (!ADVISENO.equals(""))
	{
		//Statement statements=con.createStatement();
		//ResultSet rss=statements.executeQuery("select max(SG_DISTRIBUTION_ID) from oraddman.TSSG_LOT_DISTRIBUTION_TEMP where advise_no='"+ADVISENO+"'");
		//if (rss.next())
		//{
		//	DISTRIBUTION_ID = rss.getString(1);
		//}
		//rss.close();
		//statements.close();		
		//if (ADVISENO.equals("20200423023"))
		//{
		//	DISTRIBUTION_ID="2471";
		//}
		
		
		if (DISTRIBUTION_ID.equals(""))
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select SG_LOT_DISTRIBUTION_ID_S.nextval from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				DISTRIBUTION_ID = rs.getString(1);
			}
			rs.close();
			statement.close();		
			
			sql= " insert into oraddman.TSSG_LOT_DISTRIBUTION_TEMP"+
			     " (sg_distribution_id, advise_no, vendor_site_code,"+
                 " vendor_site_id, advise_header_id, advise_line_id,"+
                 " pc_advise_id, so_no, so_line_no, item_id, item_name,"+
                 " item_desc, ship_qty, cust_po, cust_partno,"+
                 " shipping_remark, shipping_method, schedule_ship_date,"+
                 " carton_num, post_fix_code, lot_number, date_code, qty,"+
                 " po_cust_partno,vendor_carton_no,sg_stock_id,subinventory_code,po_header_id,dc_yyww,created_by, creation_date)"+
			     //" select ?,a.*,?,sysdate FROM TABLE(TSSG_SHIP_PKG.LOT_DISTRIBUTION_VIEW(?)) a";
				 " select ?,a.*,?,sysdate FROM TABLE(TSSG_SHIP_PKG.LOT_DISTRIBUTION_VIEW_NEW(?)) a";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  	
			pstmtDt.setString(1,DISTRIBUTION_ID); 
			pstmtDt.setString(2,UserName);						 
			pstmtDt.setString(3,ADVISENO);						 
			pstmtDt.executeUpdate();
			pstmtDt.close();			
		}	
		sql = " select b.* "+
		      " from (SELECT  count(1) over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_cnt,"+
              "               count(1) over(partition by ADVISE_LINE_ID,carton_num) carton_cnt,"+
			  "               sum(case when LOT_NUMBER='庫存不足' THEN 0 ELSE QTY END) over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_sum,"+
              "               sum(case when LOT_NUMBER='庫存不足' THEN 0 ELSE QTY END) over(partition by ADVISE_LINE_ID,carton_num order by lot_number) carton_sum,"+
              "               count(distinct LOT_NUMBER) over(partition by ADVISE_LINE_ID,CUST_PARTNO,carton_num,DATE_CODE,DC_YYWW) carton_lot_cnt,"+ 
			  "       a.* FROM oraddman.TSSG_LOT_DISTRIBUTION_TEMP a"+
			  "       where SG_DISTRIBUTION_ID=?"+
			  "      ) b "+
			  "  order by CARTON_NUM,ADVISE_LINE_ID,ADVISE_LINE_CNT ,CARTON_CNT,lot_number";
		//out.println(sql);
		//out.println(DISTRIBUTION_ID);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,DISTRIBUTION_ID);
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
					<td width="4%" align="center">訂單量(K)</td>            
					<td width="9%">客戶品號</td>            
					<td width="10%">客戶PO</td>            
					<td width="12%">嘜頭</td>
					<td width="7%">出貨方式</td>            
					<td width="5%">C/NO</td>            
					<td width="9%">LOT</td>            
					<td width="4%">Date Code</td>            
					<td width="4%">DC YYWW</td>            
					<td width="4%" align="center">撿貨量(K)</td>            
					<td width="5%" align="center">小計(K)</td>            
				</tr>
	<%		
			}
			LOT_NUMBER=rs.getString("LOT_NUMBER");
			DATE_CODE=rs.getString("DATE_CODE");
			DC_YYWW=rs.getString("DC_YYWW"); //add by Peggy 20220722
			PO_CUST_PARTNO=rs.getString("PO_CUST_PARTNO");
			if (DATE_CODE==null) DATE_CODE="";
			if (DC_YYWW==null) DC_YYWW="";
			if (LOT_NUMBER.equals("庫存不足"))
			{
				LOT_QTY="0";
			}
			else
			{
				LOT_QTY=rs.getString("QTY");
			}
			tr_flag=1;advise_line_flag=1;

			if (!ADVISE_LINE_ID.equals(rs.getString("ADVISE_LINE_ID")))
			{
				rowcnt = rs.getInt("ADVISE_LINE_CNT");
				ADVISE_LINE_ID =rs.getString("ADVISE_LINE_ID");
				cartoncnt = rs.getInt("CARTON_CNT");
				CARTON_NUM = rs.getString("CARTON_NUM");
				DATE_CODE1=DATE_CODE;
				DC_YYWW1=DC_YYWW;
				tr_flag=0;advise_line_flag=0;
			%>
				<tr>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("VENDOR_SITE_CODE")%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("so_no")%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("item_desc")%></td>
					<td style="vertical-align:top;color:#0000FF;font-weight:bold;font-size:12px;text-align:right;" rowspan="<%=rowcnt%>"><%=(new DecimalFormat("######.###")).format(rs.getFloat("SHIP_QTY")/1000)+"&nbsp;&nbsp;&nbsp;"%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=(rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("CUST_PO")%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=(rs.getString("SHIPPING_REMARK")==null || rs.getString("SHIPPING_REMARK").equals(" ")?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
					<td style="vertical-align:top" rowspan="<%=rowcnt%>"><%=rs.getString("shipping_method")%></td>
			<%
				if (rs.getString("SHIPPING_REMARK") != null && ((rs.getString("SHIPPING_REMARK").length()>=12 && rs.getString("SHIPPING_REMARK").substring(0,12).equals("CHANNEL WELL")) || (rs.getString("SHIPPING_REMARK").indexOf("駱騰")>=0)))
				{
					CARTON_NO=rs.getString("POST_FIX_CODE")+CARTON_NUM;
				}
				else
				{
					CARTON_NO=CARTON_NUM+rs.getString("POST_FIX_CODE");
				}
			%>
				<td rowspan="<%=cartoncnt%>" valign="top">
					<%=CARTON_NO%><input type="hidden" name="CARTON_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM%>" value="<%=CARTON_NO%>" style="font-size:11px;font-family:Tahoma,Georgia" size="4" readonly>
					<%
					//if (!LOT_NUMBER.equals("庫存不足"))
					//{
					%>					
					<img border="0" src="images/updateicon_enabled.gif" height="16" title="modify" onClick="setUpdate('../jsp/subwindow/TSCSGLotDistributionFind.jsp?SG_DIST_ID=<%=DISTRIBUTION_ID%>&ADVISE_LINE_ID=<%=rs.getString("ADVISE_LINE_ID")%>&CARTON_NO=<%=rs.getString("CARTON_NUM")%>')">
					<%
					//}
					%>
				</td>
			<%
			}				
			
			if (!CARTON_NUM.equals(rs.getString("CARTON_NUM")))
			{
				cartoncnt = rs.getInt("CARTON_CNT");
				CARTON_NUM = rs.getString("CARTON_NUM");
				DATE_CODE1=DATE_CODE;
				DC_YYWW1=DC_YYWW;
				if (tr_flag==1)
				{
					out.println("<tr style='font-size:11px'>");
					tr_flag=0;
				}
				//add by Peggy 20140902,channel well客戶箱碼在前面
				if (rs.getString("SHIPPING_REMARK") != null && ((rs.getString("SHIPPING_REMARK").length()>=12 && rs.getString("SHIPPING_REMARK").substring(0,12).equals("CHANNEL WELL")) || (rs.getString("SHIPPING_REMARK").indexOf("駱騰")>=0)))
				{
					CARTON_NO=rs.getString("POST_FIX_CODE")+CARTON_NUM;
				}
				else
				{
					CARTON_NO=CARTON_NUM+rs.getString("POST_FIX_CODE");
				}
			%>
				<td rowspan="<%=cartoncnt%>" valign="top">
					<%=CARTON_NO%><input type="hidden" name="CARTON_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM%>" value="<%=CARTON_NO%>" style="font-size:11px;font-family:Tahoma,Georgia" size="4" readonly>
					<%
					//if (!LOT_NUMBER.equals("庫存不足"))
					//{
					%>
					<img border="0" src="images/updateicon_enabled.gif" height="16" title="modify" onClick="setUpdate('../jsp/subwindow/TSCSGLotDistributionFind.jsp?SG_DIST_ID=<%=DISTRIBUTION_ID%>&ADVISE_LINE_ID=<%=rs.getString("ADVISE_LINE_ID")%>&CARTON_NO=<%=rs.getString("CARTON_NUM")%>')">
					<%
					//}
					%>
				</td>
			<%	
			}
			if (tr_flag==1)
			{
				out.println("<tr style='font-size:11px'>");
				tr_flag=0;
			}	
			//if ((!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")) || (rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2)) errcnt ++;  
			
			%>
					<td>
					<%
					//if (((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || (!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA"))))
					//{
					%>
					<input type="text" name="LOT_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=LOT_NUMBER%>" style="color:<%=(LOT_NUMBER.equals("庫存不足")?"#ff0000":"#000000")%>;font-size:11px;font-family:Tahoma,Georgia;border-bottom:#FFFFFF;border-top:#FFFFFF;border-left:#FFFFFF;border-right:#FFFFFF;" size="24" readonly>
					<input type="checkbox" name="chk" value="<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" style="width:0;visibility:hidden" checked>
					<input type="hidden" name="ADVISE_HEADER_ID_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=rs.getString("advise_header_id")%>">
					<input type="hidden" name="ADVISE_LINE_ID_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=rs.getString("advise_line_id")%>">
					<input type="hidden" name="CARTON_NUM_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=CARTON_NUM%>">
					<input type="hidden" name="DATECODE_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=DATE_CODE%>">
					<input type="hidden" name="DC_YYWW_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=DC_YYWW%>">
					<input type="hidden" name="LOT_QTY_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=LOT_QTY%>">
					<input type="hidden" name="PO_CUST_PARTNO_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=PO_CUST_PARTNO%>">	
					<%
						if (!LOT_NUMBER.equals("庫存不足") && ((rs.getString("CUST_PARTNO")!=null && !rs.getString("CUST_PARTNO").equals("N/A") && rs.getString("PO_CUST_PARTNO")==null) || ((rs.getString("CUST_PARTNO")==null || rs.getString("CUST_PARTNO").equals("N/A")) && rs.getString("PO_CUST_PARTNO")!=null && !rs.getString("PO_CUST_PARTNO").equals("N/A")) || (rs.getString("CUST_PARTNO")!=null && !rs.getString("CUST_PARTNO").equals("N/A") && !rs.getString("CUST_PARTNO").equals(rs.getString("PO_CUST_PARTNO")))))
						{
							out.println("<br><font color='red'>("+(rs.getString("PO_CUST_PARTNO")==null?"N/A":rs.getString("PO_CUST_PARTNO"))+")</font>");
						}
					%>
					</td>
					<td style="vertical-align:top"><%=(((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || (!DATE_CODE.equals(DATE_CODE1) && !DC_YYWW.equals(DC_YYWW) &&rs.getString("shipping_method").startsWith("SEA")))?"<font style='color:#ff0000;font-weight:bold'>":"<font color='black'>")%><%=(DATE_CODE.equals("")?"&nbsp;":DATE_CODE)%></font></td>
					<td style="vertical-align:top"><%=(((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || (!DATE_CODE.equals(DATE_CODE1) && !DC_YYWW.equals(DC_YYWW) &&rs.getString("shipping_method").startsWith("SEA")))?"<font style='color:#ff0000;font-weight:bold'>":"<font color='black'>")%><%=(DC_YYWW.equals("")?"&nbsp;":DC_YYWW)%></font></td>
					<td style="text-align:right;vertical-align:top">
					<%
					//if (((rs.getInt("CARTON_CNT")==1 && rs.getInt("CARTON_LOT_CNT")>2) || (!DATE_CODE.equals(DATE_CODE1) && rs.getString("shipping_method").startsWith("SEA")))
					%>
					<input type="text" name="QTY_<%=rs.getString("advise_line_id")+"|"+CARTON_NUM+"]"+(icnt+1)%>" value="<%=(new DecimalFormat("######.###")).format(Float.parseFloat(LOT_QTY)/1000)%>" style="text-align:right;font-size:11px;font-family:Tahoma,Georgia;border-bottom:#FFFFFF;border-top:#FFFFFF;border-left:#FFFFFF;border-right:#FFFFFF;" size="10" readonly>
					</td>
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
				<tr><td align="center"><input type="button" name="save1" value="配貨確認" style="font-family:'細明體'" onClick="setSubmit1('../jsp/TSCSGLotDistributionProcess.jsp')"><%=(errcnt>0?"&nbsp;<input type='button' name='preview1' value='預覽批號分配表' style='font-family:細明體' onClick='setSubmit2("+'"'+"../jsp/TSCSGLotDistributionExcel.jsp?SG_DIST_ID="+DISTRIBUTION_ID+"&ADVISENO="+ADVISENO+"&ATYPE=PREVIEW"+'"'+")'>":"")%>
				<input type="button" name="exit1" value="取消，回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TSCSGLotDistribution.jsp')">
				</td></tr>
			</table>
	<%
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("查無資料,請重新確認,謝謝!");
				location.href="/oradds/jsp/TSCSGLotDistribution.jsp";
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
<input type="hidden" name="DISTRIBUTION_ID" value="<%=DISTRIBUTION_ID%>">
<input type="hidden" name="TRANSTYPE" value="ALLOT">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

