<%
try
{          
 ilan70con.commit();      
 ilan70con.setAutoCommit(true);   
 mssqlpoolBean.releaseConnection(ilan70con);
 
 
 //mssqlpoolBean.releaseConnection(ilan70con);
 ilan70con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>