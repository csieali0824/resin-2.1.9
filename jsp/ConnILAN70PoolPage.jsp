<%@ page import="PoolBean"%>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<%
// Start Connect MSSQL Server (ILN70 ILNAssist Database) 
    Connection ilan70con=null;
    try
    {
    	 
	 if (mssqlpoolBean.getDriver()==null)
     {
      //mssqlpoolBean.setDriver("com.microsoft.jdbc.sqlserver.SQLServerDriver");
	  mssqlpoolBean.setDriver("sun.jdbc.odbc.JdbcOdbcDriver");
      mssqlpoolBean.setURL(application.getInitParameter("ILAN70_JDBC_URL"));
	  mssqlpoolBean.setURL2(application.getInitParameter("ILAN70_JDBC_URL"));
	  mssqlpoolBean.setUsername("kerwin");
      mssqlpoolBean.setPassword("kerwinchen");        
      mssqlpoolBean.setSize(3);
      mssqlpoolBean.initializePool();
     } //end of if
     mssqlpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERID")+")");
     mssqlpoolBean.setBeanID("mssqlpoolBean");
     mssqlpoolBean.setUsingURL(request.getRequestURL().toString());
     ilan70con=mssqlpoolBean.getConnection();	  
     ilan70con.setAutoCommit(false);//3]cwAutoCommit?¢Xfalse¢DH¡L??ioo¡Mo3s?u2¡±¡Ó`RE£go¢DI?u?~ 
	         
    } //end of try
    catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());
   }
   
// End of Connect MSSQL Server(ILN70 ILNAssist Database)

%>