<%@ page import="PoolBean"%>
<jsp:useBean id="mssql65poolBean" scope="application" class="PoolBean"/>
<%
// Start Connect MSSQL Server (ILN70 ILNAssist Database) 
    Connection ilan70con=null;
    try
    {
    	 
	 if (mssql65poolBean.getDriver()==null)
     {
      //mssqlpoolBean.setDriver("com.microsoft.jdbc.sqlserver.SQLServerDriver");
	  mssql65poolBean.setDriver("sun.jdbc.odbc.JdbcOdbcDriver");
      mssql65poolBean.setURL(application.getInitParameter("ILAN70_JDBC_URL"));
	  mssql65poolBean.setURL2(application.getInitParameter("ILAN70_JDBC_URL"));
	  mssql65poolBean.setURL3(application.getInitParameter("ILAN70_JDBC_URL"));
	  mssql65poolBean.setUsername("kerwin");
      mssql65poolBean.setPassword("kerwinchen");        
      mssql65poolBean.setSize(3);
      mssql65poolBean.initializePool();
     } //end of if
     mssql65poolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERID")+")");
     mssql65poolBean.setBeanID("mssql65poolBean");
     mssql65poolBean.setUsingURL(request.getRequestURL().toString());
     ilan70con=mssql65poolBean.getConnection();	  
     ilan70con.setAutoCommit(false);//3]cwAutoCommit?¢Xfalse¢DH¡L??ioo¡Mo3s?u2¡±¡Ó`RE£go¢DI?u?~ 
	         
    } //end of try
    catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());
   }
   
// End of Connect MSSQL Server(ILN70 ILNAssist Database)

%>