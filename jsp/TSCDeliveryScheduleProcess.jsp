<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Delivery Schedule Process</title>
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
<FORM ACTION="TSCDeliveryScheduleProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String delivery_schedule_id ="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();	

try
{
	String chk[]= request.getParameterValues("chk");	
	if (chk.length <=0)
	{
		throw new Exception("未選擇出貨日!!");
	}
	for(int i=0; i< chk.length ;i++)
	{
		if (i==0)
		{	
			if (ATYPE.equals("NEW"))
			{
				sql = " select tsc_delivery_schedule_id_s.nextval from dual";
				Statement statement2=con.createStatement(); 
				ResultSet rs2=statement2.executeQuery(sql);
				if (rs2.next()) 
				{ 
					delivery_schedule_id = rs2.getString(1);
				}
				rs2.close();
				statement2.close();
								
				sql = " INSERT INTO ORADDMAN.TSC_DELIVERY_SCHEDULE_HEADER"+
						  "(DELIVERY_SCHEDULE_ID"+      //1
						  ",DELIVERY_YEAR"+             //2
						  ",SHIP_FROM"+                 //3
						  ",SALES_REGION"+              //4
						  ",SHIPPING_METHOD"+           //5 
						  ",CREATION_DATE"+             //6 
						  ",CREATED_BY"+                //7
						  ",LAST_UPDATE_DATE"+          //8
						  ",LAST_UPDATED_BY"+           //9
						  ")"+             
						  " values"+
						  "(?"+ //1
						  ",?"+                         //2
						  ",?"+                         //3
						  ",?"+                         //4
						  ",?"+                         //5
						  ",sysdate"+                   //6
						  ",?"+                         //7
						  ",sysdate"+                   //8
						  ",?"+                         //9
						  ")";                     
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,delivery_schedule_id);
				pstmtDt.setString(2,request.getParameter("txt_year"));
				pstmtDt.setString(3,request.getParameter("txt_ship_from")); 
				pstmtDt.setString(4,(request.getParameter("txt_sales_region").equals("--")?"":request.getParameter("txt_sales_region")));
				pstmtDt.setString(5,(request.getParameter("shipping_method").equals("--")?"":request.getParameter("shipping_method")));
				pstmtDt.setString(6,UserName); 
				pstmtDt.setString(7,UserName);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			else
			{
				delivery_schedule_id = request.getParameter("DELIVERY_ID");
				
				sql = " update ORADDMAN.TSC_DELIVERY_SCHEDULE_HEADER"+
					  " set LAST_UPDATE_DATE=sysdate"+  
					  " ,LAST_UPDATED_BY=?"+          
					  " where DELIVERY_SCHEDULE_ID=?";                     
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName); 
				pstmtDt.setString(2,delivery_schedule_id);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = "delete ORADDMAN.TSC_DELIVERY_SCHEDULE_LINES"+
					  " where DELIVERY_SCHEDULE_ID=?";                     
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,delivery_schedule_id);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
		}
		sql = " INSERT INTO ORADDMAN.TSC_DELIVERY_SCHEDULE_LINES"+
			  " (DELIVERY_SCHEDULE_ID"+      //1
			  " ,DELIVERY_SCHEDULE_DATE"+    //2
			  " )"+
			  " VALUES"+
			  " ("+
			  " ?"+
			  ",to_date(?,'yyyymmdd')"+
			  " )";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,delivery_schedule_id);
		pstmtDt.setString(2,chk[i]);
		pstmtDt.executeQuery();
		pstmtDt.close();
	}	
	con.commit();
	
	out.println("<table width='80%' align='center'>");
	out.println("<tr><td align='center' colspan='2'><div align='cneter' style='font-weight:bold;color:#0000ff;font-size:16px'>資料寫入成功!!</DIV></td></tr>");
	out.println("<tr><td align='center' colspan='2'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
	%>
	<jsp:getProperty name="rPH" property="pgHOME"/>
	<%
	out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	out.println("<a href='TSCDeliveryScheduleQuery.jsp'>回船期查詢功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TSCDeliveryScheduleUpdate.jsp'>回船期維護功能</a></td></tr>");
	out.println("</table>");		
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href=''TSCDeliveryScheduleUpdate.jsp'>回船期維護功能</a></font>");
}

%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

