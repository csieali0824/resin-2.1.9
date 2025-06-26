<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllRepairBean2" %>
<jsp:useBean id="queryAllRepairBean" scope="application" class="QueryAllRepairBean2"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Query All Sales Delivery Requst Data for History Record</title>
</head>
<%
int maxrow=0;//查詢資料總筆數 
int currentPageNumber=0,totalPageNumber=0;
int rowNumber=0;
String scrollRow=request.getParameter("SCROLLROW");
String pageURL=request.getParameter("PAGEURL"); 
try 
{
   Statement statement=con.createStatement();
   ResultSet rs=null;
   
   //取得資料總筆數
    if (UserRoles.equals("admin"))
   {   
     rs=statement.executeQuery("select COUNT(*) from ORADDMAN.TSDELIVERY_NOTICE order by DNDOCNO");
   } else {
     //rs=statement.executeQuery("select COUNT(*) from ORADDMAN.TSDELIVERY_NOTICE where TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userProdCenterNo+"') order by DNDOCNO");
	 //modify by Peggy 20111125
	 rs=statement.executeQuery("select count(1) from ORADDMAN.TSDELIVERY_NOTICE a "+
	 " where exists (select 1 from ORADDMAN.TSRECPERSON b where  b.TSSALEAREANO= a.TSAREANO "+
	 " and (b.USERID='"+UserName+"' or b.USERNAME='"+UserName+"') and b.PRIMARY_REGION ='Y') or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userProdCenterNo+"') order by DNDOCNO");
   }
   rs.next();   
   maxrow=rs.getInt(1);     
   
  rowNumber=queryAllRepairBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   queryAllRepairBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 queryAllRepairBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-15;	 	 	   
   } else {
     rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     queryAllRepairBean.setRowNumber(rowNumber);
   }	    
  }    
  
  totalPageNumber=maxrow/15+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/16+1;  
  } else {
    currentPageNumber=rowNumber/15+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;
  
   statement.close();
   rs.close();
} catch (Exception e) {
  out.println("Exception:"+e.getMessage());  
}
%>
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>  
<BR><font color="#008080" size="5"><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgQuery"/></font>
<BR><A HREF="../jsp/TSSalesDRQHistoryQueryAll.jsp?PAGEURL=<%=pageURL%>&SCROLLROW=FIRST"><font size="2"><strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgFirst"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSAlesDRQHistoryQueryAll.jsp?&PAGEURL=<%=pageURL%>&SCROLLROW=LAST"><font size="2"><strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgLast"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQHistoryQueryAll.jsp?PAGEURL=<%=pageURL%>&SCROLLROW=15"><jsp:getProperty name="rPH" property="pgNext"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQHistoryQueryAll.jsp?PAGEURL=<%=pageURL%>&SCROLLROW=-15"><jsp:getProperty name="rPH" property="pgPrevious"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>
(<jsp:getProperty name="rPH" property="pgTheNo"/><%=currentPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/>/<jsp:getProperty name="rPH" property="pgTotal"/><%=totalPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPages"/>)</font></strong></font> 
<%   
try
{        
  out.println("<FONT COLOR=BLACK SIZE=2>(");%><jsp:getProperty name="rPH" property="pgTotal"/><%out.println(maxrow);%><jsp:getProperty name="rPH" property="pgRecord"/><%out.println(")</FONT>");                         
  
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;   
   
   if (UserRoles.equals("admin"))
   {   
     rs=statement.executeQuery("select DNDOCNO,TSAREANO,CUSTOMER,CUST_PO,REQUIRE_DATE,STATUS from ORADDMAN.TSDELIVERY_NOTICE order by DNDOCNO");
   } else {
     //rs=statement.executeQuery("select DNDOCNO,TSAREANO,CUSTOMER,CUST_PO,REQUIRE_DATE,STATUS from ORADDMAN.TSDELIVERY_NOTICE where TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userProdCenterNo+"') order by DNDOCNO");
	 //modify by Peggy 20111125
	 rs=statement.executeQuery("select DNDOCNO,TSAREANO,CUSTOMER,CUST_PO,REQUIRE_DATE,STATUS "+
	 " from ORADDMAN.TSDELIVERY_NOTICE a "+
	 " where exists (select 1 from ORADDMAN.TSRECPERSON b where  b.TSSALEAREANO= a.TSAREANO "+
	 " and (b.USERID='"+UserName+"' or b.USERNAME='"+UserName+"') and b.PRIMARY_REGION ='Y') or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userProdCenterNo+"') order by DNDOCNO");
   }
     if (rowNumber==1 || rowNumber<0)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else {     
      rs.absolute(rowNumber); //移至指定資料列	 
   }
   	
   queryAllRepairBean.setPageURL("../jsp/TSSalesDRQHistoryDetail.jsp");
   queryAllRepairBean.setSearchKey("DNDOCNO");   
   queryAllRepairBean.setRs(rs);   
   queryAllRepairBean.setScrollRowNumber(30);
       
   out.println(queryAllRepairBean.getRsString());
   
   statement.close();
   rs.close();                              
 
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
  
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
