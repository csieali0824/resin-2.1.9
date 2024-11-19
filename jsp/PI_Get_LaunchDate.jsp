<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Shipment Statistic Report</title>
</head>
<body>
<FORM METHOD="post">
<% 
Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE); 
Statement subStat=con.createStatement();
ResultSet rs=null,subRs=null;
int cc=0;
try
{ 
  rs=statement.executeQuery("select u.PROJECTCODE,u.LAUNCHDATE,substr(u.ACT_LAUNCHDATE,1,6) as ACT_LAUNCHDATE from PIMASTER u where substr(LAUNCHDATE,5,2)='--'");    
  while (rs.next())  
  {
    String itemStr=null;
    subRs=subStat.executeQuery("select MITEM from PRODMODEL where MPROJ='"+rs.getString("PROJECTCODE")+"'"); 
    while (subRs.next())  //取出該model所屬所有料號	
	{
	  if (itemStr==null)
	  {
	    itemStr="'"+subRs.getString("MITEM")+"'";
	  } else {
	    itemStr=itemStr+",'"+subRs.getString("MITEM")+"'"; 
	  }	
	} 
	subRs.close();	
	
	//由Sales Forecast取得其預計上市日期    
    subRs=subStat.executeQuery("SELECT distinct FMYEAR||FMMONTH as FORE_YEAR_MONTH FROM PSALES_FORE_MONTH WHERE FMPRJCD='"+rs.getString("PROJECTCODE")+"' and FMQTY>'0' and FMTYPE='001' order by FMYEAR||FMMONTH ");
	if (subRs.next())
	{
	  String launchDate=subRs.getString("FORE_YEAR_MONTH");	 	  
	  //如果還沒有實際上市日期或抓到之預計上市日期小於實際上市日期,就更新PIMASTER中之資料
	  if (rs.getString("ACT_LAUNCHDATE")==null || Integer.parseInt(launchDate)<=Integer.parseInt(rs.getString("ACT_LAUNCHDATE")))
	  {	  	 
	    rs.updateString("LAUNCHDATE",launchDate+"01");
	    rs.updateRow();
	    cc++;
	  }	
	}  	
	subRs.close();  
  } //end of main while loop   
  rs.close(); 
}
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}                          			
statement.close();	
out.println("There are "+cc+" records been processesed!(GET LAUNCH DATE FROM FORECAST)");
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>