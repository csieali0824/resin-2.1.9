<%
try
{          
 ilnAsistcon.commit();      
 ilnAsistcon.setAutoCommit(true);   
 mssqlpoolBean.releaseConnection(ilnAsistcon);
 
 
 mssqlpoolBean.releaseConnection(ilnAsistcon);
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>
