<%
try
{             
 ifxTestPoolBean.releaseConnection(ifxTestCon); 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>