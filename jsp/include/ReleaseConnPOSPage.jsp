<%
try
{          
 mssqlcon.commit();      
 mssqlcon.setAutoCommit(true);   
 mssqlpoolBean.releaseConnection(mssqlcon);
 
 
 mssqlpoolBean.releaseConnection(mssqlcon);
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>