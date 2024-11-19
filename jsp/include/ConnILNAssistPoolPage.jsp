<%@ page import="PoolBean"%>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<%
// Start Connect MSSQL Server (ILN70 ILNAssist Database) 
    Connection ilnAsistcon=null;
    try
    {
    	 
	 if (mssqlpoolBean.getDriver()==null)
     {
      //mssqlpoolBean.setDriver("com.microsoft.jdbc.sqlserver.SQLServerDriver");
	  mssqlpoolBean.setDriver("sun.jdbc.odbc.JdbcOdbcDriver");
      mssqlpoolBean.setURL(application.getInitParameter("ILNASSIST_JDBC_URL"));
	  mssqlpoolBean.setURL2(application.getInitParameter("ILNASSIST_JDBC_URL"));
	  mssqlpoolBean.setURL3(application.getInitParameter("ILNASSIST_JDBC_URL"));
	  mssqlpoolBean.setUsername("kerwin");
      mssqlpoolBean.setPassword("kerwinchen");        
      mssqlpoolBean.setSize(3);
      mssqlpoolBean.initializePool();
     } //end of if
     mssqlpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERID")+")");
     mssqlpoolBean.setBeanID("mssqlpoolBean");
     mssqlpoolBean.setUsingURL(request.getRequestURL().toString());
     ilnAsistcon=mssqlpoolBean.getConnection();	  
     ilnAsistcon.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤 
	         
    } //end of try
    catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());
   }
   
// End of Connect MSSQL Server(ILN70 ILNAssist Database)

%>

