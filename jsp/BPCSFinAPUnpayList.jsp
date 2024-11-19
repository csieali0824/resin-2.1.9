<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%-->
<!--=================================-->
<%@ page import="QueryAllRepairBean2" %>
<%@ page import="QryAllChkBoxEditBean" %>
<html>
<head>
<!--=================================-->
<title>BPCS應付帳款---未付清單</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function searchRepNo(pageURL) 
{   
  out.println(vendorNo);
  location.href="../jsp/BPCSFinAPUnpayList.jsp?VENDORNO="+document.MYFORM.vendorNo.value  
}
</script>
<body>
<jsp:useBean id="queryAllRepairBean" scope="session" class="QueryAllRepairBean2"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<FORM>

  <p><font color="#0080C0" size="5">查詢BPCS所有應付帳款---未付清單</font></p>
<%   
  int maxrow=0;//查詢資料總筆數 
  String vendorNo=request.getParameter("VENDORNO");
  if (vendorNo==null)
  { }
  String vendorName=request.getParameter("VENDORNAME");
  String tda=request.getParameter("PAYDATE");
  String statusPay=request.getParameter("STATUSPAY");
  String sref=request.getParameter("AMHREF");
  String sub=request.getParameter("AMHSUB");
  String serial=request.getParameter("SERIAL");
  String amt=request.getParameter("AMHPAM");
  String curr=request.getParameter("AMHCUR");
  
  String scrollRow=request.getParameter("SCROLLROW");  
  int rowNumber=queryAllRepairBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   queryAllRepairBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {
     rowNumber=-1;	 
   } else {
     rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     queryAllRepairBean.setRowNumber(rowNumber);
   }	 
  }     
    
  int currentPageNumber=0,totalPageNumber=0;
  
  try
  {   
   Statement statement =ifxTestCon.createStatement(); 
   //Statement statement =ifxDbtelcon.createStatement(); 
   ResultSet rs=null;
   if ( vendorNo !=null) //如果有搜尋特定單號則另下SQL
   {  
     rs=statement.executeQuery("select count(*) from AMH where  AMHVND='"+vendorNo+"' and AMHSTS='A'  ");
   } 
   else {
     rs=statement.executeQuery("select count(*) from AMH where AMHSTS='A' ");
   }	 
   
   rs.next();   
   maxrow=rs.getInt(1);
   out.println("<FONT COLOR=BLACK SIZE=2>(總共"+maxrow+"筆記錄)</FONT>"); 
   statement.close();
   rs.close();
   
    
    totalPageNumber=maxrow/30+1;
    if (rowNumber==0 || rowNumber<0)
    {
      currentPageNumber=rowNumber/31+1;  
    } else {
      currentPageNumber=rowNumber/30+1; 
    }	
    if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
<table width="82%" border="0">
    <tr>
      <td><A HREF="/wins/WinsMainMenu.jsp">回首頁</A></td>
      <td> 廠商代號 : 
        <input type="text" name="VENDORNO" size=16 <%if (vendorNo!=null) out.println("value="+vendorNo);%>>
       <input name="search" type=button onClick="searchRepNo('<%=vendorNo%>')" value="<-搜尋"></td>
    </tr>
  </table>
  <A HREF="../jsp/BPBCFinAPUnpayList.jsp?VENDORNO=<%=vendorNo%>&SCROLLROW=FIRST"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A><A HREF="../jsp/BPBCFinAPUnpayList.jsp?VENDORNO=<%=vendorNo%>&SCROLLROW=LAST"><font size="2"><strong><font color="#FF0080">最後一頁</font></strong></font></A><font color="#FF0080"><strong><font size="2"><A HREF="../jsp/BPBCFinAPUnpayList.jsp?VENDORNO=<%=vendorNo%>&SCROLLROW=30">下一頁</A><A HREF="../jsp/BPBCFinAPUnpayList.jsp?VENDORNO=<%=vendorNo%>&SCROLLROW=-30">上一頁</A>(第頁<%=currentPageNumber%>/共<%=totalPageNumber%>頁)</font></strong></font>  
<% 	
 try
  {  
   Statement statement=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
    ResultSet rs=null;
    String sSql=""; 
	
	//如果有搜尋特定單號則另下SQL
	if ( vendorNo!=null) 
	{ 	 
	   sSql="select AMHVND,AMHTDA,AMHCUR,AMHPAM,AMHREF,AMHSUB,AMHSTS,AMHCPC,h.SERIALCOLUMN as SERIAL from AMH h,AVM v where v.VENDOR=h.AMHVND and AMHSTS='A' and AMHVND='"+vendorNo+"' order by AMHTDA"; 
	   rs=statement.executeQuery(sSql);
     } else {
	   sSql="select AMHVND,AMHTDA,AMHCUR,AMHPAM,AMHREF,AMHSUB,AMHSTS,AMHCPC,h.SERIALCOLUMN as SERIAL from AMH h,AVM v where v.VENDOR=h.AMHVND and AMHSTS='A'  order by AMHTDA"; 
	   rs=statement.executeQuery(sSql);
	 }	   
   //out.println(sSql); 

   if (rowNumber==1)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else {
     if (rowNumber==-1)
	 {
	   rs.absolute(-30);
	 } else {
      rs.absolute(rowNumber); //移至指定資料列
	 }
   }
      
   queryAllRepairBean.setPageURL("../jsp/BPCSFinAPStatusEdit.jsp");//小圖示連結到修改的網頁  
   queryAllRepairBean.setSearchKey("SERIAL");//傳到下一個網頁以那一個變數為主
   queryAllRepairBean.setRs(rs);
   queryAllRepairBean.setScrollRowNumber(30);
   out.println(queryAllRepairBean.getRsString());
   //另外一種呈現方式 ,沒有checkbox的
   
  // qryAllChkBoxEditBean.setPageURL("../jsp/BPCSFinAPStatusUpdate.jsp");//小圖示連結到修改的網頁
   //qryAllChkBoxEditBean.setSearchKey("SERIAL");//傳到下一個網頁以那一個變數為主
   //qryAllChkBoxEditBean.setFieldName("CH");
//   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
 //  qryAllChkBoxEditBean.setRowColor2("ADD8E6");
 //  qryAllChkBoxEditBean.setRs(rs);   
//   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();    
   rs.close();     
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</FORM>

</body>
<!--=============以下區段為釋放連結池==========-->
<!--@ import file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%-->