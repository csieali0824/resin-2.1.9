<%
try
{          
 tewcon.commit();      
 tewcon.setAutoCommit(true);   
 mssqlpoolBean.releaseConnection(tewcon);
 
 
 //mssqlpoolBean.releaseConnection(ilan70con);
 //tewcon.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>
