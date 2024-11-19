<%@ page import="PoolBean"%>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<%
// Start Connect MSSQL Server (POS IMEI) 
    Connection mssqlcon=null;
    try
    {
     if (mssqlpoolBean.getDriver()==null)
    {
      mssqlpoolBean.setDriver("com.microsoft.jdbc.sqlserver.SQLServerDriver");
      mssqlpoolBean.setURL(application.getInitParameter("POS_JDBC_URL"));
      mssqlpoolBean.setUsername("sa");
      mssqlpoolBean.setPassword(""); 
      mssqlpoolBean.setHostInfo(request.getRemoteAddr()+"("+request.getRemoteHost()+")");   
      mssqlpoolBean.setSize(3);
      mssqlpoolBean.initializePool();
     } //end of if
     mssqlpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERID")+")");
     mssqlcon=mssqlpoolBean.getConnection();	          
    } //end of try
    catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());
   }
   
// End of Connect MSSQL Server(POS IMEI)

%>
