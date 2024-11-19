<%
try
{          

 conTst2.commit();      
 conTst2.setAutoCommit(true);   
 oradTst2poolBean.releaseConnection(conTst2); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>