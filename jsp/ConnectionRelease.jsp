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
<jsp:useBean id="msTpe70poolBean" scope="application" class="PoolBean"/>

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
String [] msTpe70poolBeanChoice=request.getParameterValues("MSTPE70POOLBEANCHOICE");

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

  if (dmpoolBeanChoice!=null)
  {   
    int [] a=new int[dmpoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<dmpoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(dmpoolBeanChoice[i]);
	}
    dmpoolBean.releaseWhichConn(a);           
  } //end of if  
  
  if (pdmPoolBeanChoice!=null)
  {   
    int [] a=new int[pdmPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<pdmPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(pdmPoolBeanChoice[i]);
	}
    pdmPoolBean.releaseWhichConn(a);           
  } //end of if  
  
  if (cqPoolBeanChoice!=null)
  {   
    int [] a=new int[cqPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<cqPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(cqPoolBeanChoice[i]);
	}
    cqPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (repairpoolBeanChoice!=null)
  {   
    int [] a=new int[repairpoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<repairpoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(repairpoolBeanChoice[i]);
	}
    repairpoolBean.releaseWhichConn(a);           
  } //end of if  
  
  if (ifxPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxPoolBeanChoice[i]);
	}
    ifxpoolBean.releaseWhichConn(b);         	    
  } //end of if 
  
  if (ifxDbexpPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxDbexpPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxDbexpPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxDbexpPoolBeanChoice[i]);
	}
    ifxDbexpPoolBean.releaseWhichConn(b);         	    
  } //end of if   
  
  if (ifxShoesPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxShoesPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxShoesPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxShoesPoolBeanChoice[i]);
	}
    ifxShoesPoolBean.releaseWhichConn(b);         	    
  } //end of if     
  
   if (ifxDistPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxDistPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxDistPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxDistPoolBeanChoice[i]);
	}
    ifxDistPoolBean.releaseWhichConn(b);         	    
  } //end of if   
  
  if (ifxDbglobalPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxDbglobalPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxDbglobalPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxDbglobalPoolBeanChoice[i]);
	}
    ifxDbglobalPoolBean.releaseWhichConn(b);         	    
  } //end of if
  
  if (ifxTestPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxTestPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxTestPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxTestPoolBeanChoice[i]);
	}
    ifxTestPoolBean.releaseWhichConn(b);         	    
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
  
  if (msTpe70poolBeanChoice!=null)
  {   
    int [] c=new int[msTpe70poolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<msTpe70poolBeanChoice.length;i++)
	{
	  c[i]=Integer.parseInt(msTpe70poolBeanChoice[i]);
	}
    msTpe70poolBean.releaseWhichConn(c);         
  } //end of if
  
  if (mesPoolBeanChoice!=null)
  {   
    int [] c=new int[mesPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<mesPoolBeanChoice.length;i++)
	{
	  c[i]=Integer.parseInt(mesPoolBeanChoice[i]);
	}
    mespoolBean.releaseWhichConn(c);         
  } //end of if  
  
  if (bpcsPoolBeanChoice!=null)
  {   
    int [] d=new int[bpcsPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<bpcsPoolBeanChoice.length;i++)
	{
	  d[i]=Integer.parseInt(bpcsPoolBeanChoice[i]);
	}
    bpcsPoolBean.releaseWhichConn(d);         
  } //end of if  
  
  if (ifxDbgroupPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxDbgroupPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxDbgroupPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxDbgroupPoolBeanChoice[i]);
	}
    ifxDbgroupPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (ifxTechPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxTechPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxTechPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxTechPoolBeanChoice[i]);
	}
    ifxTechPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (ifxNetPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxNetPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxNetPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxNetPoolBeanChoice[i]);
	}
    ifxNetPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (ifxdbintPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxdbintPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxdbintPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxdbintPoolBeanChoice[i]);
	}
    ifxdbintPoolBean.releaseWhichConn(a);           
  } //end of if   
  
  if (ifxmicroPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxmicroPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxmicroPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxmicroPoolBeanChoice[i]);
	}
    ifxmicroPoolBean.releaseWhichConn(a);           
  } //end of if   
  
  if (ifxaresPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxaresPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxaresPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxaresPoolBeanChoice[i]);
	}
    ifxaresPoolBean.releaseWhichConn(a);           
  } //end of if   
  
  if (ifxTstexpPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxTstexpPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxTstexpPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxTstexpPoolBeanChoice[i]);
	}
    ifxTstexpPoolBean.releaseWhichConn(b);         	    
  } //end of if   
  
  if (ifxwwwPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxwwwPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxwwwPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxwwwPoolBeanChoice[i]);
	}
    ifxwwwPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (ifxDbtelPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxDbtelPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxDbtelPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxDbtelPoolBeanChoice[i]);
	}
    ifxDbtelPoolBean.releaseWhichConn(a);           
  } //end of if 
  
   if (ifxNSalTestPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxNSalTestPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxNSalTestPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxNSalTestPoolBeanChoice[i]);
	}
    ifxNSalTestPoolBean.releaseWhichConn(a);           
  } //end of if 
  
   if (ifxNotesSalPoolBeanChoice!=null)
  {   
    int [] a=new int[ifxNotesSalPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxNotesSalPoolBeanChoice.length;i++)
	{
	  a[i]=Integer.parseInt(ifxNotesSalPoolBeanChoice[i]);
	}
    ifxNotesSalPoolBean.releaseWhichConn(a);           
  } //end of if 
  
  if (ifxTmpBOMPoolBeanChoice!=null)
  {   
   int [] b=new int[ifxTmpBOMPoolBeanChoice.length]; //字串轉成數字
    for (int i=0;i<ifxTmpBOMPoolBeanChoice.length;i++)
	{
	  b[i]=Integer.parseInt(ifxTmpBOMPoolBeanChoice[i]);
	}
    ifxTmpBOMPoolBean.releaseWhichConn(b);         	    
  } //end of if   
  
  response.sendRedirect("ConnectionStatus.jsp");
  return;
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
// End of Connect to WINSDB
%>

