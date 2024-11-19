<%
try
{          

 conMES.commit();      
 conMES.setAutoCommit(true);   
 mespoolBean.releaseConnection(conMES); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>