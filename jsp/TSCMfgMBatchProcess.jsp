<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<html>
<head>
<title>Work Order M Data Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--FOR MATERIAL USAGE-->
<jsp:useBean id="array2DAssignFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 企劃分派產地-->
<jsp:useBean id="array2DEstimateFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工廠安排交期確認中-->
<jsp:useBean id="array2DArrangedFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工廠回覆交期確認-->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String pageURL=request.getParameter("PAGEURL");//承接前一頁所傳來之參數
String [] choice=request.getParameterValues("CH");
String woNo=request.getParameter("WO_NO");
String formID=request.getParameter("FORMID");
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");


out.print("<hr>");
  
// 若使用者未於批次作業點選任一Check Box	  
if (choice==null || choice[0].equals(null))    // 2004/11/25 for fileter user don't choosen any item to process // 2004/11/25
{ 
  out.println("<font color='#FF0000' face='ARIAL BLACK' size='3'> Warning !!!</font>,<font color='#000099' face='ARIAL'><strong>Nothing gonna to Process,Please choice Case .</strong></font>"); 
} 
else 
{

 try
 { 
      
  for (int k=0;k<choice.length ;k++)    
  { 
    String sqlStat = "";
	String whereStat = "";
	
	 sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
	 whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
     sqlStat = sqlStat+whereStat;

     Statement getStatusStat=con.createStatement();  
     ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
     getStatusRs.next();
  
  // 工令結案_起 (ACTION=015)
  if (actionID=="015" || actionID.equals("015")) 
  {	   
		woNo=choice[k];
		
		//更改YEW_WORKORDER_ALL　的狀態為'052,CLOSED'   
		String woSql=" update APPS.YEW_WORKORDER_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=? "+		                  
		             " where WO_NO= '"+woNo+"' "; 	
              PreparedStatement woStmt=con.prepareStatement(woSql);
			  woStmt.setInt(1,Integer.parseInt(userMfgUserID));
	          woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
			  woStmt.setString(3,"052"); 
	          woStmt.setString(4,"CLOSED");			 
			  woStmt.executeUpdate();   
              woStmt.close();
		
		//寫入紀錄至YEW_WO_TRANSACTION	  
		String woSqla=" insert into  APPS.YEW_WO_TRANSACTIONS (WO_NO,CREATION_DATE,CREATION_BY,UPDATED_REASON ) values (?,?,?,?) ";	                  
               PreparedStatement woStmta=con.prepareStatement(woSqla);
              woStmta.setString(1,woNo);
	          woStmta.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
			  woStmta.setString(3,userMfgUserName);			  
	          woStmta.setString(4,"CLOSED");				  		 
			  woStmta.executeUpdate();   
              woStmta.close();	

		//更改YEW_RUNCARD_ALL　的狀態為'052,CLOSED'   
		String woSqlb=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=? "+		                  
		              " where WO_NO= '"+woNo+"' "; 	
              PreparedStatement woStmtb=con.prepareStatement(woSqlb);
			  woStmtb.setInt(1,Integer.parseInt(userMfgUserID));
	          woStmtb.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
			  woStmtb.setString(3,"052"); 
	          woStmtb.setString(4,"CLOSED");			 
			  woStmtb.executeUpdate();   
              woStmtb.close();
     
	 out.print("<font color='#000099' face='ARIAL'>  工令號: <strong>"+woNo+"</strong></font><br>");			  
			  	  
    }  // End of if (actionID.equals("015"))
  } //end of for (int k=0;k<choice.length;k++)
  out.println("<font color='#000099' face='ARIAL'>Processing Work Order Closed OK!</font>");
  out.println("<BR><HR>");
    
 } //end of try
 catch (Exception e)
 {
	e.printStackTrace();
   out.println(e.getMessage());
 }//end of catch
}  // End of if (choice==null || choice[0].equals(null)) for fileter user don't choosen any item to process // 2004/11/25
%>

<table width="480" border="1">
  <tr>
    <td width="180">WIP單據處理</td>
    <td width="162">WIP查詢及報表</td>  
  </tr>
  <tr>
    <td>
<%
  try  
  {
    String MODEL = "E5";    
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
   // out.print("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");
	while(rs.next())
    {
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<font size=-1><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a><br>");
	}
      rs.close(); 
	  statement.close();
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch     
%>   </td>
    <td><%
  try  
  {
    String MODEL = "E6";    
	Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    while(rs.next())
    {
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<font size=-1><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a><br>");
	}
      rs.close(); 
	  statement.close();
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch     
%></td>
    
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
