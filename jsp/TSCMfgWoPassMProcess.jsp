<%@ page contentType="text/html; charset=utf-8"  language="java" import="java.sql.*,java.util.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%-->

<html><head>
<title>MFG System Work Order Process Page</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<%
String serverHostName=request.getServerName();
String hostInfo=request.getRequestURL().toString();//REQUEST URL
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String inspLotNo=request.getParameter("INSPLOTNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");

String woNo=request.getParameter("WO_NO");   //工單號

//String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL

String [] choice=request.getParameterValues("CH"); //add by Peggy 20131216

String actionName=null;

//out.println("<BR>工令號: "+woNo);
//out.println("<BR>Update by "+UserName);
//out.println("<BR>actionID="+actionID+"<br>fromStatusID="+fromStatusID);
%>
<p>
<table width="100%" border="0" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
			<table width="40%" border="1" cellpadding="0" cellspacing="0" style="font-size:12px" bordercolor="#99CCCC" >
				<tr>
					<td  width="40%" style="background-color:#CCCCCC;font-family:'新細明體'" align="center">工令號</td>
					<td  width="30%" style="background-color:#CCCCCC;font-family:'新細明體'" align="center">執行動作</td>
					<td  width="30%" style="background-color:#CCCCCC;font-family:'新細明體'" align="center">結果</td>
				</tr>
<%
try
{
	//取得ERP_USER_ID
	String ERPUserID = "";
	Statement getERPID=con.createStatement();  
	ResultSet getERPIDRs=getERPID.executeQuery("SELECT ERP_USER_ID FROM oraddman.wsuser WHERE username = '"+UserName+"' ");  
	if (getERPIDRs.next())
	{
		ERPUserID = getERPIDRs.getString("ERP_USER_ID");
	}
	getERPIDRs.close();
	getERPID.close();

	// 取得執行動作名稱_起
	Statement getActionName=con.createStatement();  
	ResultSet getActionRs=getActionName.executeQuery("select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID = '"+actionID+"' ");  
	if (getActionRs.next())
	{
		actionName = getActionRs.getString("ACTIONNAME");
	}
	getActionRs.close();
	getActionName.close();
	// 取得執行動作名稱_迄
	//out.println("<BR>執行動作: "+actionName);

	// 先取得下一狀態及狀態描述並作流程狀態更新   
	String sqlStat = "";
	String whereStat = "";
	//out.println("FORMID="+formID);
	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
	whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
	sqlStat = sqlStat+whereStat;
	Statement getStatusStat=con.createStatement();  
	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
	getStatusRs.next();

	//=======工令資料確認...起	(ACTION=029, 005)   工令資料040->工令資料確認041 / 工令資料退回058   add by SHIN 2009/07/09
	if ((actionID.equals("029") && fromStatusID.equals("040")) || (actionID.equals("005") && fromStatusID.equals("040")))   // 
	{   
		if (choice==null)
		{
			out.println("<tr>");
			out.println("<td align='center' style='font-family:arial'>"+woNo+"</td>");
			out.println("<td align='center' style='font-family:arial'>"+actionName+"</td>");
			try
			{
				String woSql=" update APPS.YEW_WORKORDER_ALL set STATUSID=?,STATUS=?,LAST_UPDATE_DATE=?,LAST_UPDATED_BY=? "+
							" where WO_NO= '"+woNo+"' "; 	
				PreparedStatement woStmt=con.prepareStatement(woSql);
				woStmt.setString(1,getStatusRs.getString("TOSTATUSID")); 
				woStmt.setString(2,getStatusRs.getString("STATUSNAME"));
				woStmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
				woStmt.setInt(4,Integer.parseInt(ERPUserID));
				woStmt.executeUpdate();   
				woStmt.close(); 
				out.println("<td align='center' style='font-family:arial;color=#0000ff'>Success</td>");
			}
			catch(Exception e)
			{
				out.println("<td align='center' style='font-family:arial;color=#ff0000'>Error</td>");
			}
			out.println("</tr>");
			
		}
		else
		{
			//add by Peggy 20131216
			for (int k =0 ; k < choice.length ; k++)
			{
				out.println("<tr>");
				out.println("<td align='center' style='font-family:arial'>"+choice[k]+"</td>");
				out.println("<td align='center' style='font-family:arial'>"+actionName+"</td>");
				try
				{
					String woSql=" update APPS.YEW_WORKORDER_ALL set STATUSID=?,STATUS=?,LAST_UPDATE_DATE=?,LAST_UPDATED_BY=? "+
								" where WO_NO= '"+choice[k]+"' "; 	
					PreparedStatement woStmt=con.prepareStatement(woSql);
					woStmt.setString(1,getStatusRs.getString("TOSTATUSID")); 
					woStmt.setString(2,getStatusRs.getString("STATUSNAME"));
					woStmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					woStmt.setInt(4,Integer.parseInt(ERPUserID));
					woStmt.executeUpdate();   
					woStmt.close(); 
					out.println("<td align='center' style='font-family:arial;color=#0000ff'>Success</td>");
				}
				catch(Exception e)
				{
					out.println("<td align='center' style='font-family:arial;color=#ff0000'>Error</td>");
				}
				out.println("</tr>");
			}
		}
	}
	//=======工令資料確認...迄	(ACTION=029, 005)   工令資料040->工令資料確認041 / 工令資料退回058   add by SHIN 2009/07/09
	getStatusStat.close();
	getStatusRs.close();  
  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println("<BR>Error!!<BR>");
	out.println(e.getMessage());
}//end of catch
%>
			</table>
		<td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="60%" border="1" cellpadding="0" cellspacing="0" >
				<tr>
			    	<td width="278"><font size="2">WIP單據處理</font></td>
			    	<td width="297"><font size="2">WIP查詢及報表</font></td>    
			  	</tr>
		  		<tr>   
		    		<td>
<%
try  
{
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
	String MODEL = "E5";    
	String sqlE3 = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sqlE3);    	
	while(rs.next())
	{
		//out.println("FSEQ="+rs.getString("FSEQ"));
		String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
	rs.close(); 
	statement.close();
	out.println("</table>");  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println(e.getMessage());
}//end of catch  

%>   
 					</td> 
 					<td>
 <%
  try  
  { out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E6";    
	Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    while(rs.next())
    {
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td><td>");
	}
	rs.close(); 
	statement.close();
	out.println("</table>"); 
	} //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch   
   
%>
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>

</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>


