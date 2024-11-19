<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="PoolBean"%>
<jsp:useBean id="poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="authPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="oraddspoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="dmpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="bpcsPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mespoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssql65poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbexpPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbglobalPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTestPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDistPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxShoesPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="repairpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTstexpPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="cqPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="pdmPoolBean" scope="application" class="PoolBean"/>

<jsp:useBean id="ifxNetPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxdbintPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbgroupPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTechPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxmicroPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxaresPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxwwwPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbtelPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxNSalTestPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxNotesSalPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTmpBOMPoolBean" scope="application" class="PoolBean"/>

<%
String [] poolBeanChoice=request.getParameterValues("POOLBEANCHOICE");
String [] authPoolBeanChoice=request.getParameterValues("AUTHPOOLBEANCHOICE");
String [] oraddspoolBeanChoice=request.getParameterValues("ORADDSPOOLBEANCHOICE");
String [] dmpoolBeanChoice=request.getParameterValues("DMPOOLBEANCHOICE");
String [] cqPoolBeanChoice=request.getParameterValues("CQPOOLBEANCHOICE");
String [] pdmPoolBeanChoice=request.getParameterValues("PDMPOOLBEANCHOICE");
String [] ifxPoolBeanChoice=request.getParameterValues("IFXPOOLBEANCHOICE");
String [] mesPoolBeanChoice=request.getParameterValues("MESPOOLBEANCHOICE");
String [] bpcsPoolBeanChoice=request.getParameterValues("BPCSPOOLBEANCHOICE");
String [] mssqlpoolBeanChoice=request.getParameterValues("MSSQLPOOLBEANCHOICE");
String [] mssql65poolBeanChoice=request.getParameterValues("MSSQL65POOLBEANCHOICE");

String [] ifxDbexpPoolBeanChoice=request.getParameterValues("IFXDBEXPPOOLBEANCHOICE");
String [] ifxDbglobalPoolBeanChoice=request.getParameterValues("IFXDBGLOBALPOOLBEANCHOICE");
String [] ifxTestPoolBeanChoice=request.getParameterValues("IFXTESTPOOLBEANCHOICE");
String [] ifxDistPoolBeanChoice=request.getParameterValues("IFXDISTPOOLBEANCHOICE");
String [] ifxShoesPoolBeanChoice=request.getParameterValues("IFXSHOESPOOLBEANCHOICE");
String [] repairpoolBeanChoice=request.getParameterValues("REPAIRPOOLBEANCHOICE");
String [] ifxTstexpPoolBeanChoice=request.getParameterValues("IFXTSTEXPPOOLBEANCHOICE");

String [] ifxDbgroupPoolBeanChoice=request.getParameterValues("IFXDBGROUPPOOLBEANCHOICE");
String [] ifxTechPoolBeanChoice=request.getParameterValues("IFXTECHPOOLBEANCHOICE");
String [] ifxNetPoolBeanChoice=request.getParameterValues("IFXNETPOOLBEANCHOICE");
String [] ifxdbintPoolBeanChoice=request.getParameterValues("IFXDBINTPOOLBEANCHOICE");

String [] ifxmicroPoolBeanChoice=request.getParameterValues("IFXMICROPOOLBEANCHOICE");
String [] ifxaresPoolBeanChoice=request.getParameterValues("IFXARESPOOLBEANCHOICE");
String [] ifxwwwPoolBeanChoice=request.getParameterValues("IFXWWWPOOLBEANCHOICE");
String [] ifxDbtelPoolBeanChoice=request.getParameterValues("IFXDBTELPOOLBEANCHOICE");

String [] ifxNSalTestPoolBeanChoice=request.getParameterValues("IFXNOTESALTESTPOOLBEANCHOICE");
String [] ifxNotesSalPoolBeanChoice=request.getParameterValues("IFXNOTESSALPOOLBEANCHOICE");
String [] ifxTmpBOMPoolBeanChoice=request.getParameterValues("IFXNOTESSALPOOLBEANCHOICE");

try
{    
  if (poolBeanChoice!=null)
  {   
    int [] a=new int[poolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<poolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(poolBeanChoice[i]);
	}
    poolBean.releaseWhichConn(a);           
  } //end of if  
  
  if (authPoolBeanChoice!=null)
  {   
    int [] a=new int[authPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<authPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(authPoolBeanChoice[i]);
	}
    authPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (oraddspoolBeanChoice!=null)
  {   
    int [] a=new int[oraddspoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<oraddspoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(oraddspoolBeanChoice[i]);
	}
    oraddspoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (mssqlpoolBeanChoice!=null)
  {   
    int [] c=new int[mssqlpoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<mssqlpoolBeanChoice.length;i++)
	{
	  c[i]=Integer.parseInt(mssqlpoolBeanChoice[i]);
	}
    mssqlpoolBean.releaseWhichConn(c);         
  } //end of if
  
  if (mssql65poolBeanChoice!=null)
  {   
    int [] c=new int[mssql65poolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<mssql65poolBeanChoice.length;i++)
	{
	  c[i]=Integer.parseInt(mssql65poolBeanChoice[i]);
	}
    mssql65poolBean.releaseWhichConn(c);         
  } //end of if  
  
  response.sendRedirect("ConnectionALLStatus.jsp?RELEASEFLAG=N");
  return;
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
// End of Connect to WINSDB
%>

