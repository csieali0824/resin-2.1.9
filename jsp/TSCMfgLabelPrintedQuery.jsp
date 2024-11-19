<!--20160830 by Peggy,增加日期區間查詢條件,excel匯出功能,解鎖原因輸入-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	if (document.MYFORM.SDATE.value =="" && document.MYFORM.EDATE.value =="" && document.MYFORM.LOTNO.value =="" && document.MYFORM.LABEL_NAME.value =="")
	{
		alert("查詢條件至少要輸入一項!!");
		return false; 
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{   
	if (confirm("您確定要解鎖!!"))
	{
		subWin=window.open(URL,"subwin","width=340,height=480,scrollbars=no,menubar=no");
	}
	
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline; font-size: 12px  }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>生產系統-標籤打印記錄查詢</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<% /* 建立本頁面資料庫連線  */ %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM  METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
	String LOTNO = request.getParameter("LOTNO");
	if (LOTNO==null) LOTNO="";
	String ActionCode = request.getParameter("ActionCode");
	if (ActionCode==null) ActionCode="";
	String LABEL = request.getParameter("LABEL");
	if (LABEL==null) LABEL="";
	String LABEL_NAME = request.getParameter("LABEL_NAME");
	if (LABEL_NAME==null) LABEL_NAME="";
	String SDATE = request.getParameter("SDATE");
	if (SDATE==null) SDATE="";
	String EDATE = request.getParameter("EDATE");
	if (EDATE==null) EDATE="";
	String UNLOCK_REASON = request.getParameter("UNLOCK_REASON");
	if (UNLOCK_REASON==null) UNLOCK_REASON="";
	String UNLOCK_REASON_REMARKS = request.getParameter("UNLOCK_REASON_REMARKS");
	if (UNLOCK_REASON_REMARKS==null) UNLOCK_REASON_REMARKS="";
	String SYS_NAME = request.getParameter("SYS_NAME");
	if (SYS_NAME==null) SYS_NAME="";
	String sql="";
	int seq=0;
	
	
	if (ActionCode.equals("Unlock"))
	{
		if (UserRoles.equals("admin")|| UserRoles.indexOf("UNLOCK_USER")>0 || (SYS_NAME.equals("OLD") || SYS_NAME.equals("NEW")))
		{
			if (SYS_NAME.equals("OLD"))
			{
				sql = "update oraddman.tscust_lblprt_txns set runcard_no=?,LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss'),LAST_UPDATED_BY=?,unlock_reason=?,unlock_reason_remarks=? where runcard_no=? and label_tempfile=? ";
				PreparedStatement pstmt=con.prepareStatement(sql);	
				pstmt.setString(1, LOTNO+"*");  
				pstmt.setString(2, UserName);  
				pstmt.setString(3, UNLOCK_REASON);  
				pstmt.setString(4, UNLOCK_REASON_REMARKS);  
				pstmt.setString(5, LOTNO);  
				pstmt.setString(6, LABEL);  
				pstmt.executeUpdate(); 
				pstmt.close();
				
				sql = " update oraddman.tscust_label_px set PX_LOT_NO=? where PX_LOT_NO='"+LOTNO+"'";
				pstmt=con.prepareStatement(sql);	
				pstmt.setString(1, LOTNO+"*");  
				pstmt.executeUpdate(); 
				pstmt.close();		
			}
			else if (SYS_NAME.equals("NEW"))				
			{
				sql = " update oraddman.tsyew_label_print_log a "+
				      " set a.unlock_reason=?"+
					  ",a.unlock_reason_remarks=?"+
					  ",a.unlocked_by=?"+
                      ",a.unlock_date=sysdate"+
					  " where a.lot_number=? "+
					  " and a.label_code=replace(?,'.lbl','')"+
					  " and a.unlock_date is null";
				PreparedStatement pstmt=con.prepareStatement(sql);	
				pstmt.setString(1, UNLOCK_REASON);  
				pstmt.setString(2, UNLOCK_REASON_REMARKS);  
				pstmt.setString(3, UserName);  
				pstmt.setString(4, LOTNO);  
				pstmt.setString(5, LABEL);  
				pstmt.executeUpdate(); 
				pstmt.close();			
			}
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("解鎖成功!!");
			</script>
		<%
			ActionCode ="Q";
		}
		else
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("解鎖失敗!!您沒有解鎖權限~~");
			</script>
		<%
		}
	}
%>
<table cellspacing="0" cellpadding="1" width="100%" align="center">	
	<tr>
		<td><font color="#003366" size="+3" face="Arial Black"><em>YEW</em></font>
			<font style="font-size:28px;color:#000000;font-family:'標楷體'"><strong>標籤打印記錄查詢</strong></font>
		</td>
	</tr>
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"  style="font-size:16px;font-family:標楷體;text-decoration:none;color:#0000FF">回首頁</A></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#CCCCCC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
				<tr bgcolor="#D3E4DE">
					<td width="10%">Printed Date</td> 
					<td width="20%">
					<input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:12px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
					<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
					<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:12px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
					<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>					
					</td>
					<td width="10%">Lot Number</td> 
					<td width="10%"><INPUT TYPE="textbox" NAME="LOTNO" value="<%=LOTNO%>" style="font-family:Tahoma,Georgia;font-size:12px" ></td>
					<td width="10%">Label Name</td> 
					<td width="10%"><INPUT TYPE="textbox" NAME="LABEL_NAME" value="<%=LABEL_NAME%>" style="font-family:Tahoma,Georgia;font-size:12px" ></td>
				</tr>
				<tr>
					<td  colspan="6" align="center"><INPUT TYPE="button" value='查詢' onClick='setSubmit("../jsp/TSCMfgLabelPrintedQuery.jsp?ActionCode=Q")'>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" value="Excel" style="font-family: Tahoma,Georgia" onClick='setSubmit("../jsp/TSCMfgLabelPrintedExcel.jsp")'></td> 			
				</tr>
			</table>
		</td>
   	</tr>
   	<tr>
   		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>	
			<table cellspacing="0" bordercolordark="#CCCCCC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
				<tr bgcolor="#D3E4DE">
					<td>&nbsp;</td>
					<td>Seq No </td>
					<td>System</td>
					<td>Lot Number</td>
					<td>Label Name</td>
					<td>Station</td>
					<td>Printed Date</td>
					<td>Printed By</td>
					<td>Orig Lot Number</td>
					<td>Unlock Reason</td>
					<td>Unlock Reason Descripton</td>
				</tr>
<%
			try
			{
				if (ActionCode.equals("Q"))
				{
					String sourceLot = "";
					//String sql = " select replace(a.runcard_no,'*','') runcard_no,a.label_tempfile,a.printed_date,b.statname,a.CREATED_BY,a.runcard_no orig_lotno"+
					//            //" FROM oraddman.tscust_lblprt_txns a,oraddman.tscust_label_station b"+
					//			 " from (select * from oraddman.tscust_lblprt_txns x where runcard_no in ('"+LOTNO+"' ,'"+LOTNO+"*') "+
					//            "       union all "+
					//             "      select * from oraddman.tscust_lblprt_txns x where  exists (select 1 from oraddman.tscust_label_px c where  c.PX_LOT_NO=x.RUNCARD_NO and c.LOT_NO='"+ LOTNO+"') "+
					//             "      ) a,oraddman.tscust_label_station b"+
					//             " where a.statno=b.statno"+
					//			 " order by replace(a.runcard_no,'*',''),a.printed_date";
					//String sql = " select z.statname,replace(y.runcard_no,'*','') runcard_no,y.runcard_no orig_lotno,y.*,(SELECT listagg(a.lot_no,'<br>') within group(order by a.lot_no) FROM oraddman.tscust_label_px a  WHERE a.px_lot_no=y.runcard_no) source_lot_list"+
					sql = " select 'OLD' sys_kind, z.statname,replace(y.runcard_no,'*','') runcard_no,y.runcard_no orig_lotno,y.LABEL_TEMPFILE,y.CREATED_BY,y.PRINTED_DATE,(SELECT listagg(a.lot_no,'<br>') within group(order by a.lot_no) FROM oraddman.tscust_label_px a  WHERE a.px_lot_no=y.runcard_no) source_lot_list"+
					      ",y.unlock_reason,y.unlock_reason_remarks,NULL unlocked_by,NULL unlock_date"+
						  " from (select * from oraddman.tscust_lblprt_txns x "+
						  "       where 1=1";
					if (!LOTNO.equals("")) sql += " and runcard_no in ('"+LOTNO+"' ,'"+LOTNO+"*')";						 
						  sql += "       union all"+
								 "       select * from oraddman.tscust_lblprt_txns x "+
								 "       where 1=1 ";
					if (!LOTNO.equals("")) sql += " and exists (select 1 from oraddman.tscust_label_px c where  c.PX_LOT_NO=x.RUNCARD_NO and c.LOT_NO='"+LOTNO+"')";
						  sql += "      ) y,oraddman.tscust_label_station z "+
								 " where  y.statno=z.statno";
					if (!LABEL_NAME.equals("")) sql += " and upper(y.LABEL_TEMPFILE) like '"+LABEL_NAME.toUpperCase()+"%'";
					if (!SDATE.equals("")) sql += " and PRINTED_DATE >= '"+SDATE+"000000'";
					if (!EDATE.equals("")) sql += " and PRINTED_DATE <= '"+EDATE+"235959'";
					sql +=" union all"+
					      " select x.* from (SELECT 'NEW' sys_kind,"+
                          " CASE  c.label_kind WHEN 'TSC' THEN '台半' WHEN 'CUST' THEN '客戶' ELSE '其他' END || d.label_type_name statname,"+
                          " a.lot_number RUNCARD_NO,"+
                          " a.lot_number || case when a.unlock_date is not null then '*' else '' end  orig_lotno,"+
                          " a.label_code || '.lbl' LABEL_TEMPFILE,"+
                          " a.printed_by CREATED_BY,"+
                          " TO_CHAR (MAX (a.print_date), 'YYYYMMDDHH24MISS') print_date,"+
                          " NULL source_lot_list,"+
                          " a.unlock_reason,"+
                          " a.unlock_reason_remarks,"+
                          " a.unlocked_by,"+
                          " TO_CHAR (a.unlock_date, 'YYYYMMDD') unlock_date "+
                          " FROM oraddman.tsyew_label_print_log a,"+
                          " oraddman.tsyew_label_all b,"+
                          " oraddman.tsyew_label_groups c,"+
                          " oraddman.tsyew_label_types d"+
                          " WHERE a.label_code = b.label_code"+
                          " AND b.label_group_code = c.label_group_code"+
                          " AND b.label_type_code=d.label_type_code"+
                          " GROUP BY a.lot_number,a.item_no,a.item_desc, a.label_code, a.label_type, a.printed_by, a.unlock_reason,a.unlock_reason_remarks,a.unlocked_by,a.unlock_date,c.label_kind, d.label_type_name) x "+
						  " where 1=1";
					if (!LOTNO.equals("")) sql += " and x.RUNCARD_NO='"+ LOTNO+"'";
					if (!LABEL_NAME.equals("")) sql += " and upper(x.LABEL_TEMPFILE) like '"+LABEL_NAME.toUpperCase()+"%'";
					if (!SDATE.equals("")) sql += " and x.print_date >= '"+SDATE+"000000'";
					if (!EDATE.equals("")) sql += " and x.print_date <= '"+EDATE+"235959'";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);  
					int i = 1;
					//out.println(sql);
					while (rs.next())
					{
						seq ++;
						//sourceLot="";
						//sql = " SELECT distinct a.lot_no  FROM oraddman.tscust_label_px a  WHERE a.px_lot_no='"+rs.getString("orig_lotno") +"'";
						////out.println(sql);
						//Statement statement1=con.createStatement();
						//ResultSet rs1=statement1.executeQuery(sql);
						//while (rs1.next())
						//{
						//	if (sourceLot.length()>0) sourceLot+="<br>";
						//	sourceLot += rs1.getString("lot_no");
						//}
						//rs1.close();
						//statement1.close();
						//if (sourceLot.length()==0) sourceLot="&nbsp;";
						out.println("<tr>");
						//if ((UserRoles.equals("admin")|| UserRoles.indexOf("UNLOCK_USER")>0) && !rs.getString("orig_lotno").endsWith("*") && rs.getString("label_tempfile").equals("TSYEW_083.lbl"))
						//if (rs.getString("sys_kind").equals("NEW")) out.println( rs.getString("orig_lotno")+"xxx");
						if ((UserRoles.equals("admin")|| UserRoles.indexOf("UNLOCK_USER")>0) && rs.getString("orig_lotno") != null && !rs.getString("orig_lotno").endsWith("*"))
						{
							out.println("<td align='center' style='font-size:12px;font-family:arial;'><input type='button' name='Unlock"+i+"' value='解鎖' style='background-color:#66CC00;color:#ffffff' onClick='setSubmit1("+'"'+"../jsp/subwindow/TSCMfgLabelUnlockReasonList.jsp?ActionCode=Unlock&SYS_NAME="+rs.getString("sys_kind")+"&LOTNO="+rs.getString("runcard_no")+"&LABEL="+rs.getString("label_tempfile")+'"'+")'></td>");
							i++;
						}
						else
						{
							out.println("<td align='center'>-------</td>");
						}
						out.println("<td>"+seq+"</td>");
						out.println("<td>"+rs.getString("sys_kind")+"</td>");
						out.println("<td>"+rs.getString("runcard_no")+"</td>");
						out.println("<td>"+rs.getString("label_tempfile")+"</td>");
						out.println("<td>"+rs.getString("statname")+"</td>");
						out.println("<td>"+rs.getString("printed_date")+"</td>");
						out.println("<td>"+rs.getString("CREATED_BY")+"</td>");
						out.println("<td>"+(rs.getString("SOURCE_LOT_LIST")==null?"&nbsp;":rs.getString("SOURCE_LOT_LIST"))+"</td>");
						out.println("<td>"+(rs.getString("unlock_reason")==null?"&nbsp;":rs.getString("unlock_reason"))+"</td>");
						out.println("<td>"+(rs.getString("unlock_reason_remarks")==null?"&nbsp;":rs.getString("unlock_reason_remarks"))+"</td>");
						out.println("</tr>");
						
					}
					rs.close();
					statement.close();
				}
			}
			catch (Exception e)
			{
				out.println(e.getMessage());
			}
%>				
			</table>
		</td>
	</tr>
<%
	if (seq ==0)
	{
	%>
		<tr><td align="center" style="color:#0000ff;font-size:14px">查無資料,請重新確認!!</td></tr>
	<%
	}
%>	
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

