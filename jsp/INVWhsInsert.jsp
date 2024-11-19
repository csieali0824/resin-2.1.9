<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayListCheckBoxBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Item Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String whs=request.getParameter("WHS");
String whsDesc=request.getParameter("WHSDESC");
String loc = request.getParameter("LOC");
// 取文件新增日期時間 //
//String strDateTime ="C"+dateBean.getYearMonthDay();
String strDateTime =dateBean.getYearMonthDay();
String itemcreateNo="";
String itemcreateNo1 = "00001";
String sDate = dateBean.getYearMonthDay();
int iDate = 0;
String userID = "B02260";
String sNew = "N"; //記錄是否為當日第一筆資料
int iSeq = 0;
try
{ 
  String sqlS = "select trim(to_char(SEQMAX+1,'00000')) ITEMCREATENO from INV_SEQ ";
  String sWhere = " where SEQTYPE='W' and SEQDATE='"+strDateTime+"' ";		 
  sqlS = sqlS+sWhere;
  Statement stateS=con.createStatement();
  ResultSet rsS=stateS.executeQuery(sqlS);
  if (rsS.next()==false)
  { itemcreateNo1 = "00001";
    sNew = "Y";
  }
  else
  { 
    itemcreateNo1 = rsS.getString("ITEMCREATENO");			
	sNew = "N";	 
    if (itemcreateNo1==null || itemcreateNo1.equals(""))
	{
	  itemcreateNo1 = "00001";
	}
  }  
  rsS.close();
  stateS.close();
  
  itemcreateNo = "W" + strDateTime + itemcreateNo1;  //取得新的shippNo
  iDate = Integer.parseInt(sDate);
  iSeq = Integer.parseInt(itemcreateNo1);

	  String sqlC = "select WHSWHS,WHSLOC from INV_WHS where WHSWHS='"+whs+"' and WHSLOC='"+loc+"' ";		 
	  Statement stateC=con.createStatement();
	  ResultSet rsC=stateC.executeQuery(sqlC);
	  if (rsC.next()==false)
	  {
		  String sql="insert into INV_WHS(WHSWHS,WHSLOC,WHSDESC,WHSCREATEUSER,WHSCREATEDATE,WHSCREATENO) values(?,?,?,?,?,?)";
		  PreparedStatement pstmt=con.prepareStatement(sql);  
		  pstmt.setString(1,whs);
		  pstmt.setString(2,loc); 
		  pstmt.setString(3,whsDesc);
		  pstmt.setString(4,userID); 
		  pstmt.setInt(5,iDate);
		  pstmt.setString(6,itemcreateNo);  
		  
		  pstmt.executeUpdate();
		  
		  if (sNew=="Y")
		  {
			String sqlN="insert into INV_SEQ(SEQTYPE,SEQDESC,SEQDATE,SEQMAX) values(?,?,?,?)";
			PreparedStatement pstmtN=con.prepareStatement(sqlN);  
			pstmtN.setString(1,"W");
			pstmtN.setString(2,"倉號"); 
			pstmtN.setString(3,sDate);
			pstmtN.setInt(4,iSeq);   
		  
			pstmtN.executeUpdate();  
		  }
		  else
		  {
			String sqlN="update INV_SEQ set SEQMAX = '"+iSeq+"' where SEQTYPE = 'W' and SEQDATE = '"+sDate+"' ";
			PreparedStatement pstmtN=con.prepareStatement(sqlN);  
		  
			pstmtN.executeUpdate();    
		  }
		
		  out.println("Whs insert OK!! <BR><BR><BR>Whs:"+whs+"<BR>whsDesc:"+whsDesc+"<BR>Loc:"+loc+"<BR>User:"+userID+"<BR>Date:"+iDate+"<BR>Number:"+itemcreateNo+"<BR><BR><BR>");
		  pstmt.close(); 
   	  }
	  else
	  {
	      out.println("Warehouse:"+whs+" Location:"+loc+" exists!! <BR><BR><BR>");
	  }
	  rsC.close();
	  stateC.close();	  
	  //out.println("<A HREF=../jsp/INVWhsCreate.jsp>Whs Create FORM<BR><BR></A><A HREF=/wins/WinsMainMenu.jsp>HOME</A>");		 
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<br>
<A HREF=../jsp/INVWhsCreate.jsp>新增倉別/架位</A>
<br>
<A HREF=/wins/WinsMainMenu.jsp>回首頁</A>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
