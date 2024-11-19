<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%> 
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>1211 Order Create Process</title>
<%@ page import="DateBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%
String sourcepg=request.getParameter("sourcepg");
String url_page = "",user_ID  = "";
if (sourcepg == null) sourcepg ="D4001";
if (sourcepg.equals("D4001"))
{
	url_page = "Tsc1211ConfirmList.jsp";
}
else if (sourcepg.equals("D1010"))
{
	url_page = "Tsc1211SpecialCustQuery.jsp";
}

try
{
	String sql = "SELECT distinct ERP_USER_ID USER_ID FROM ORADDMAN.WSUSER WHERE UPPER(USERNAME) =  upper('"+(String)session.getAttribute("USERNAME")+"')";
	//out.println("sql="+sql+"<br>");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sql);
	while(rs.next())
	{
		user_ID = rs.getString("USER_ID") ;
		//out.println("USER_ID="+user_ID);
	}
	rs.close();   
	st.close(); 
}
catch(SQLException e)
{
	out.println(e.toString());
}
 
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);
String processStatus = "";
int headerID = 0;   // 把第二次的更新 Header ID 取到
String orderNo = "";
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
java.sql.Date shipdate 	  = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Schedule Ship Date
java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Request Date
java.sql.Date pricedate   = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date
String customerPO = ""; //add by Peggy 20121001
String status =request.getParameter("status");
String customerID =request.getParameter("customerID");
String keyID = request.getParameter("ID");
if (sourcepg.equals("D1010")) keyID = keyID.replace("DELTA",""); //add by Peggy 20121001
String customerNumberPre = request.getParameter("CUSTOMER_NUMBER");//
if (customerNumberPre == null) customerNumberPre =""; //add by Peggy 20120925
String packing_List_Number = request.getParameter("packing_List_Number"); //add by Peggy 20120726
if (packing_List_Number == null) packing_List_Number = "";
String customer_Name = request.getParameter("customer_Name"); //add by Peggy 20120726
if (customer_Name == null) customer_Name="";
if (sourcepg.equals("D1010")) customer_Name="DELTA";  //add by Peggy 20120925
//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
String taxCode =request.getParameter("TAXCODE");  //add by Peggy 20190412
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
cs1.execute();
cs1.close();
String oraUserID="3077", respID="50124", sourceTypeCode="";   
int errCnt =0; //add by Peggy 20120928	

try
{   
	Statement st_break=con.createStatement();
	ResultSet rs_break=null;
	String sql_break ="";
	if (sourcepg.equals("D4001"))
	{
		sql_break = "update  TSC_OE_AUTO_HEADERS  set TAX_CODE=?  where packinglistnumber='"+keyID+"'  and  customerID ='"+customerID +"' AND ORDER_NUMBER IS NULL";
		PreparedStatement pstmt=con.prepareStatement(sql_break);            
		pstmt.setString(1,taxCode); 
		pstmt.executeUpdate(); 
		pstmt.close();	
		
		sql_break = "select customerpo,ORDER_NUMBER , status from tsc_oe_auto_headers where  packinglistnumber='"+keyID+"' and  customerID ='"+customerID +"' AND ORDER_NUMBER IS NULL";
		rs_break=st_break.executeQuery(sql_break);
		while (rs_break.next())
		{
			customerPO += (rs_break.getString("customerpo")+"<br>");
			if (rs_break.getString("status").equals("CLOSED"))
			{
				if (errCnt ==0)
				{
					out.println("<table width='100%' height='100%' border='0' align='center' cellpadding='0' cellspacing='1'   bordercolor='#FFFFFF'>");
					out.println("<tr><td width='30%'>&nbsp;</td><td width='40%'>");
					out.println("<table width='100%' height='74' border='1' align='center' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
					out.println("<tr><td style='font-family:arial;font-size:14px'>Customer PO</td><td style='font-family:arial;font-size:14px'>訂單號碼</td></tr>");
				}
				out.println("<tr><td style='font-family:arial;font-size:14px'>"+rs_break.getString("customerpo")+"</td><td style='font-family:arial;font-size:14px'>"+(rs_break.getString("ORDER_NUMBER")==null?"&nbsp;":rs_break.getString("ORDER_NUMBER"))+"</td></tr>");
				errCnt++;
			}
		}
		if (errCnt>0)
		{
			out.println("<tr><td colspan='2' style='font-family:arial;font-size:14px;color:#FF0000'>以上PO已生成訂單號碼，不允許重覆生成訂單!!</td></TR></table></td><td width='30%'>&nbsp;</td></tr>");
			out.println("<tr><td></td><td></td><td align='center'><A HREF='"+url_page+"'><font style='font-size:18px;font-family:標楷體'>回訂單轉出頁面</font></a></td></tr>");
			out.println("</table>");
		}
		rs_break.close();   
		st_break.close(); 
	}
	else
	{
		customerPO = keyID;
		sql_break = "select ORDER_NUMBER , status from tsc_oe_auto_headers where  packinglistnumber='"+keyID+"' and status = '"+"CLOSED"+"' and  customerID ='"+customerID +"'";
		rs_break=st_break.executeQuery(sql_break);
		if (rs_break.next()==true)
		{
			out.println("<table width='400' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
			out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>這筆資料已經生成訂單了</font></div></td></tr>");
			out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>單號為"+rs_break.getString("ORDER_NUMBER")+"</font></div></td></tr>");
			out.println("<tr><td><div><font  face='Arial' size= '2' color='#red'><hr></font></div></td></tr>");
			out.println("</table><br>");
			errCnt++;
		}
		rs_break.close();   
		st_break.close(); 
	}
	
	if (errCnt ==0)
	{
		try
		{   
			if (customerPO.length()>0)
			{
				//這個try是用來跑Call API產生訂單資訊的資料
				//out.println("<table width='400' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
				CallableStatement cs3 = con.prepareCall("{call TSC_OM_SO_CREATE_B(?,?,?,?,?,?)}");			 
				cs3.registerOutParameter(1, Types.VARCHAR);  // Errbuf
				cs3.registerOutParameter(2, Types.VARCHAR);  // Retcode
				cs3.setString(3, keyID);                     // Key ID
				cs3.setInt(4,Integer.parseInt(user_ID));     // User ID
				cs3.registerOutParameter(5, Types.VARCHAR);  // status
				cs3.registerOutParameter(6, Types.VARCHAR);  // order number
				cs3.execute();
				processStatus = cs3.getString(5);
				orderNo = cs3.getString(6);
				String errorMessage = cs3.getString(1);
				cs3.close();
				if (processStatus==null) processStatus="";
				out.println("<table width='100%' height='100%' border='0' align='center' cellpadding='0' cellspacing='1'   bordercolor='#FFFFFF'>");
				out.println("<tr height='40%'><td width='10%'>&nbsp;</td><td width='70%'>");
				out.println("<table width='60%' border='1' align='center' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
				out.println("<tr><td bgcolor='#CCCCCC' width='30%'><font style='font-size:16px;color:#000000;font-family:標楷體'>&nbsp;客戶名稱</font></td><td width='70%'><font style='font-size:16px;font-family:arial'>"+(!customerNumberPre.equals("")?"&nbsp;("+customerNumberPre+")":"")+customer_Name+"</font></td></tr>");
				out.println("<tr><td bgcolor='#CCCCCC' width='30%'><font style='font-size:16px;color:#000000;font-family:標楷體'>&nbsp;包裝號碼</font></td><td width='70%'><font style='font-size:16px;font-family:arial'>"+((packing_List_Number==null || packing_List_Number.equals(""))?"&nbsp;":packing_List_Number)+"</font></td></tr>");
				out.println("<tr><td bgcolor='#CCCCCC' width='30%'><font style='font-size:16px;color:#000000;font-family:標楷體'>&nbsp;客戶訂單號碼</font></td><td width='70%'><font style='font-size:16px;font-family:arial'>"+((customerPO==null || customerPO.equals(""))?"&nbsp;":customerPO)+"</font></td></tr>");
				out.println("<tr><td bgcolor='#CCCCCC' width='30%'><font style='font-size:16px;color:#000000;font-family:標楷體'>&nbsp;執行結果</font></td><td width='70%'>&nbsp;"+((processStatus.equals("S"))?"<font style='font-size:16px;color:blue;font-family:標楷體'>成功</font>":"<font style='font-size:16px;color:red;font-family:標楷體'>失敗</font>")+"</td></tr>");
				if (processStatus.equals("S"))
				{
					out.println("<tr><td bgcolor='#CCCCCC' width='30%'><font style='font-size:16px;color:#000000;font-family:標楷體'>&nbsp;ERP訂單號碼</font></td><td width='70%'><font style='font-size:18px;font-family:arial'>"+orderNo+"</font></td></tr>");
				}
				else
				{
					out.println("<tr><td bgcolor='#CCCCCC' width='30%'><font style='font-size:16px;color:#000000;font-family:標楷體'>&nbsp;錯誤訊息</font></td><td width='70%'><font style='font-size:16px;font-family:arial;color=#FF00000'>"+errorMessage+"</font></td></tr>");
				}
				out.println("</table>");
			}
			out.println("</td><td>&nbsp;</td></tr>");
			out.println("<tr height='30%'><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
			out.println("<tr height='30%'><td>&nbsp;</td><td>&nbsp;</td><td><A HREF='"+url_page+"'><font style='font-size:18px;font-family:標楷體'>繼續處理下一筆</font></A></td></tr>");
		}
		catch (Exception e) 
		{ 
			out.println("Exception34:"+e.getMessage()); 
		} 
	}
}
catch (Exception e) 
{ 
	out.println("Exception1:"+e.getMessage()); 
} 
customerPO=null;
status =null;
customerID =null;
keyID = null;
customerNumberPre =null;//
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

<!--=================================-->
</html>
