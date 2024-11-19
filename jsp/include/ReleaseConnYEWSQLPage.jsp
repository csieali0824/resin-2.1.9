<%
try
{          
 yewcon.commit();      
 yewcon.setAutoCommit(true);   
 mssql65poolBean.releaseConnection(yewcon); 
 
 //mssql65poolBean.releaseConnection(yewcon);
 //yewcon.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>