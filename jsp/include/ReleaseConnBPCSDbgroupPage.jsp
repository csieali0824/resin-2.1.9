<%
try
{             
 ifxDbgroupPoolBean.releaseConnection(ifxdbgroupcon); 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>