<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Shipment Statistic Report</title>
</head>
<body>
<FORM METHOD="post">
<% 
//取得傳入參數
String sModelNo=request.getParameter("MODELNO");
String modelArray[]=null; //做為存model的陣列		 
Statement statDBTEL=bpcscon.createStatement(); 
ResultSet rsDBTEL=null;		   
Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE); 
Statement subStat=con.createStatement();
ResultSet rs=null,subRs=null;
int cc=0;
try
{ 
  rs=statement.executeQuery("select u.PROJECTCODE,u.ACT_LAUNCHDATE from PIMASTER u where act_launchdate is null");    
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
	    
    rsDBTEL=statDBTEL.executeQuery("select distinct ILDATE from SIL WHERE ILQTY>0 and ILNET>0 and ILPROD in ("+itemStr+")  order by ildate");
	if (rsDBTEL.next())
	{
	  String act_LaunchDate=rsDBTEL.getString("ILDATE");	 	  
	  //若取得庫存數則更新條件選出之結果集內容		 
	  rs.updateString("ACT_LAUNCHDATE",act_LaunchDate);
	  rs.updateRow();
	  cc++;
	}  	
	rsDBTEL.close();  
  } //end of main while loop   
  rs.close(); 
}
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}                             			
statDBTEL.close();
statement.close();	
out.println("There are "+cc+" records been processesed !");
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>