<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String sql = "";
String NO = request.getParameter("NO");
if (NO==null) NO="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TEW Advise No List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(PICK_NO,REQUEST_TYPE)
{
	window.opener.document.MYFORM.PICK_NO.value = PICK_NO;
	window.opener.document.MYFORM.REQUEST_TYPE.value = REQUEST_TYPE;
	this.window.close();
}
</script>
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
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<body >  
<FORM METHOD="post" ACTION="TSA01WIPPickNotFind.jsp" NAME="SUBFORM">
<%
	try
	{ 
					
		sql = " select DISTINCT c.type_name,a.pick_no,b.request_type"+
              " from oraddman.tsa01_request_lines_all a"+
			  ",oraddman.tsa01_request_headers_all b "+
			  ",(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c"+
              " where a.request_no=b.request_no "+
              " and b.REQUEST_TYPE=c.TYPE_VALUE(+)"+
              " and a.status IN ('CONFIRMED','PICKED')"+
              " AND EXISTS (SELECT 1 FROM oraddman.tsa01_request_lines_all x,oraddman.tsa01_request_headers_all y where x.request_no||'_'||x.line_no=? and x.request_no=y.request_no and y.request_type=b.request_type)";
			  //out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,NO);
		ResultSet rs=statement.executeQuery();
		int vline=0;
		while (rs.next())
		{
			if (vline==0)
			{
				out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
				out.println("<TR bgcolor='#cccccc'><TH width='5%' style='font-size:12px;font-family:arial'>&nbsp;</TH>");        
				out.println("<TH width='15%' style='font-size:12px;font-family:arial'>類別</TH>");
				out.println("<TH width='15%' style='font-size:12px;font-family:arial'>撿貨單號</TH>");
				out.println("</TR>");
			}
			out.println("<TR id='tr_"+vline+"'>");
			out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick="+'"'+"setSubmit('"+rs.getString("pick_no")+"','"+rs.getString("request_type")+"')"+'"'+"></TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("type_name")+"</TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("pick_no")+"</TD>");
			out.println("</TR>");
			vline++;
		}
		if (vline>0)
		{
			out.println("</TABLE>");	
		}
		else
		{
			out.println("<div><font color='red'>查無符合條件資料</font></div>");
		}
		rs.close();  
		statement.close();     
	}
	catch (Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
