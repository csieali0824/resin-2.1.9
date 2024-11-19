<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>SG Shipping Advise Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCSGToTWShippingAdviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

String sql ="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String BATCH_ID=request.getParameter("BATCH_ID");
if (BATCH_ID==null) BATCH_ID="";
int v_fail_cnt=0;

if (TRANSTYPE.equals("INSERT"))
{
	try
	{
		String ERPUSERID = request.getParameter("ERPUSERID");
		String PC_ADVISE_ID="";
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無出貨通知交易!!");
		}
		for(int i=0; i< chk.length ;i++)
		{
			sql = " update TSC_SHIPPING_ADVISE_PC_TMP TSAP"+
				  " set SELECT_FLAG=?"+ 
				  ",SHIP_QTY=?"+
				  ",PC_CONFIRM_QTY=?"+
				  ",PC_SCHEDULE_SHIP_DATE=to_date(?,'yyyymmdd')"+
				  ",SHIPPING_FROM=?"+
			      " where so_line_id=?"+
				  " and BATCH_ID=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"Y");
			pstmtDt.setString(2,request.getParameter("ACT_SHIP_QTY_"+chk[i]));
			pstmtDt.setString(3,request.getParameter("ACT_SHIP_QTY_"+chk[i]));
			pstmtDt.setString(4,request.getParameter("ACT_SHIP_DATE_"+chk[i]));
			pstmtDt.setString(5,"宜蘭");
			pstmtDt.setString(6,chk[i]);
			pstmtDt.setString(7,BATCH_ID);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}	
				  
		CallableStatement cs3 = con.prepareCall("{call TSCOMF006_PKG.INSERT_ADVISE_PC(?,?,?)}");			 
		cs3.setString(1,BATCH_ID); 
		cs3.registerOutParameter(2, Types.VARCHAR);
		cs3.registerOutParameter(3, Types.VARCHAR); 
		cs3.execute();
		if (!cs3.getString(2).equals("S"))
		{
			throw new Exception("資料寫入失敗!");			
		}
		cs3.close();	
		
		for(int i=0; i< chk.length ;i++)
		{
			sql = " update TSC_SHIPPING_ADVISE_PC A"+
				  " set CREATED_BY=(SELECT ERP_USER_ID FROM oraddman.wsuser B WHERE B.USERNAME=?)"+ 
				  ",LAST_UPDATED_BY=(SELECT ERP_USER_ID FROM oraddman.wsuser B WHERE B.USERNAME=?)"+
				  " where so_line_id=?"+
				  " and CREATED_BY IS NULL";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,UserName);
			pstmtDt.setString(2,UserName);
			pstmtDt.setString(3,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
		}	
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("動作成功!!若要進行出貨通知確認動作,請按確定鍵,否則按下取消鍵,回到SG回台出貨通知排定功能!!"))
			{
				setSubmit("../jsp/TSCSGToTWShippingAdviseQuery.jsp");
			}
			else
			{
				setSubmit("../jsp/TSCSGToTWShippingAdvise.jsp");
			}
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGtToTWShippingAdvise.jsp'>SG回台出貨通知排定功能</a></font>");
	}
}
else if (TRANSTYPE.equals("DELETE"))
{
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無刪除資料!!");
		}	
		else
		{
			v_fail_cnt=0;
			PreparedStatement statement=null;
			PreparedStatement pstmtDt=null;
			ResultSet rs =null;
			for (int i=0; i< chk.length ;i++)
			{
				sql = "select 1 from tsc.tsc_shipping_advise_lines b where b.pc_advise_id=?";
				statement = con.prepareStatement(sql);
				statement.setString(1,chk[i]);
				rs=statement.executeQuery();		
				if (rs.next())
				{
					v_fail_cnt ++;
				}						
				else
				{			
					sql = " delete tsc.TSC_SHIPPING_ADVISE_PC a"+
						  " where PC_ADVISE_ID=?"+
						  " and not exists (select 1 from tsc.tsc_shipping_advise_lines b where b.pc_advise_id=a.pc_advise_id)";
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,chk[i]);
					pstmtDt.executeQuery();
					pstmtDt.close();
				}		
				rs.close();
				statement.close();
			}
			con.commit();
			out.println("<table width='80%' valign='center' align='center'><tr><td align='center' colspan='2'><div align='cneter' style='color:#0000ff;font-size:16px'>動作完成!!</DIV></td></tr>");
			out.println("<tr><td colspan='2' align='center'><font style='font-size:13px'>已刪除筆數:"+(chk.length-v_fail_cnt)+"&nbsp;&nbsp;&nbsp;&nbsp;未刪除筆數:"+v_fail_cnt+"</font></td></tr>");
			out.println("<tr><td width='45%' align='center'><div align='right' style='color:#0000ff;font-size:12x;'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
			%>
			<jsp:getProperty name="rPH" property="pgHOME"/>
			<%
			out.println("</A></DIV></td>");
		    out.println("<td width='55%' ><div align='left'>&nbsp;&nbsp;&nbsp;<a href='TSCSGToTWShippingAdviseQuery.jsp'>SG回台出貨通知查詢功能</font></a></div></td>");
			out.println("</tr>");
			out.println("</table>");
		}		
	}
	catch(Exception e)
	{
        con.rollback();
		out.println("<table width='80%' align='center'><tr><td align='center'>");
		out.println("<div align='center'><font color='red'>交易失敗,請速洽系統管理人員,謝謝!!</font></div><br>");
		out.println("</td></tr>");
		out.println("<tr><td align='center'>");
		out.println("<div align='center'><font color='red'>"+e.getMessage()+"</font></div><br>");
		out.println("</td></tr>");
		out.println("<tr><td align='center'>");
		out.println("<div align='center'><a href='TSCSGToTWShippingAdviseQuery.jsp'>SG回台出貨通知查詢功能</font></a></div>");
		out.println("</td></tr>");
		out.println("</table>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

