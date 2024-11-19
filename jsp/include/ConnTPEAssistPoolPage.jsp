<%@ page import="PoolBean"%>
<jsp:useBean id="msTpe70poolBean" scope="application" class="PoolBean"/>
<%
// Start Connect MSSQL Server (TPE70 ILNAssist Database) 
    Connection tpe70iLncon=null;
    try
    {
    	 
	 if (msTpe70poolBean.getDriver()==null)
     {
      //msTpe70poolBean.setDriver("com.microsoft.jdbc.sqlserver.SQLServerDriver");
	  msTpe70poolBean.setDriver("sun.jdbc.odbc.JdbcOdbcDriver");
      msTpe70poolBean.setURL(application.getInitParameter("TPE70_ILNASSIST_JDBC_URL"));
	  msTpe70poolBean.setURL2(application.getInitParameter("TPE70_ILNASSIST_JDBC_URL"));
	  msTpe70poolBean.setURL3(application.getInitParameter("TPE70_ILNASSIST_JDBC_URL"));
	  msTpe70poolBean.setUsername("sa");
      msTpe70poolBean.setPassword("motorola");        
      msTpe70poolBean.setSize(3);
      msTpe70poolBean.initializePool();
     } //end of if
     msTpe70poolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERID")+")");
     msTpe70poolBean.setBeanID("msTpe70poolBean");
     msTpe70poolBean.setUsingURL(request.getRequestURL().toString());
     tpe70iLncon=msTpe70poolBean.getConnection();	  
     tpe70iLncon.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤 
	         
    } //end of try
    catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());
   }
   
// End of Connect MSSQL Server(TPE70 ILNAssist Database)

%>

