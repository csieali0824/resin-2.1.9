<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- 20181211 by Peggy,客戶=駱騰, 箱碼固定為I,且放置在箱數前面,例I1,I2..-->
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
}
</STYLE>
<title>TEW PO Allot Detail</title>
</head> 
<FORM ACTION="../jsp/TEWPOAllotDetail.jsp" METHOD="post" NAME="MYFORMD" >
<%
String seqid=request.getParameter("seqid");
String type=request.getParameter("type");  //add by Peggy 20140820
if (type==null) type=""; 
int i=0;
try
{
	Statement statement=con.createStatement();
	String sql = "SELECT a.tew_advise_no,b.REGION_CODE,b.so_no,b.SO_LINE_NUMBER"+
	            //",a.carton_num||c.POST_FIX_CODE carton_num"+
		        ",case when length(b.SHIPPING_REMARK) >=12 and substr(b.SHIPPING_REMARK,0,12) ='CHANNEL WELL' or instr(b.SHIPPING_REMARK,'駱騰')>0 then c.POST_FIX_CODE||a.carton_num else a.carton_num||c.POST_FIX_CODE end as carton_num"+ //modify by Peggy 20140902
                ",b.SHIPPING_REMARK, to_char(b.SCHEDULE_SHIP_DATE,'yyyy-mm-dd') SCHEDULE_SHIP_DATE,a.allot_qty/1000 allot_qty"+
				" FROM oraddman.tew_lot_allot_detail a,tsc.tsc_shipping_advise_lines b,tsc.tsc_shipping_advise_headers c"+
				" where seq_id='"+seqid+"'"+
				" and a.advise_line_id = b.advise_line_id"+
				" and b.advise_header_id = c.advise_header_id";
	if (type.equals(""))
	{
		sql += " and a.confirm_flag<>'Y'";
	}
	else
	{
		sql += " and a.confirm_flag='Y'";
	}
	sql += " order by a.tew_advise_no,b.REGION_CODE,a.carton_num,b.so_no,b.SO_LINE_NUMBER";
    ResultSet rs=statement.executeQuery(sql);
    while (rs.next())
    {
		if (i==0)
		{
		%>
			  <table cellspacing="0" bordercolordark="#999999" cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
				 <tr bgcolor="#CCCCCC">
				 	<td width="12%" align="center">Advise No</td>
					<td width="11%" align="center">出貨日</td>
					<td width="12%" align="center">業務區</td>
					<td width="25%" align="center">嘜頭</td>
					<td width="12%" align="center">訂單號碼</td>
					<td width="10%" align="center">訂單項次</td>
					<td width="8%" align="center">箱號</td>
					<td width="10%" align="center"><%=(type.equals("")?"撿貨數量":"出貨數量")%>(K)</td>
				 </tr>
		<%
		}
		%>
				<tr>
					<td align="center"><%=rs.getString("tew_advise_no")%></td>
					<td align="center"><%=rs.getString("SCHEDULE_SHIP_DATE")%></td>
					<td><%=rs.getString("REGION_CODE")%></td>
					<td><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
					<td align="center"><%=rs.getString("so_no")%></td>
					<td align="center"><%=rs.getString("SO_LINE_NUMBER")%></td>
					<td align="center"><%=rs.getString("carton_num")%></td>
					<td align="right"><%=(new DecimalFormat("######0.####")).format(rs.getFloat("allot_qty"))%></td>
				</tr>
		<%
		i++;
    } 
	if (i>0)
	{
%>
	</table>
<%
	}
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%> 
</form>
</body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

