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
String item=request.getParameter("ITEM");
String itemDesc=request.getParameter("ITEMDESC");
String uomcode = request.getParameter("UOMCODE");
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
  String sWhere = " where SEQTYPE='C' and SEQDATE='"+strDateTime+"' ";		 
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
	  
	  itemcreateNo = "C" + strDateTime + itemcreateNo1;  //取得新的shippNo
	  iDate = Integer.parseInt(sDate);
	  iSeq = Integer.parseInt(itemcreateNo1);
	
	  String sqlC = "select ITEMNO from INV_ITEM where ITEMNO='"+item+"' ";		 
	  Statement stateC=con.createStatement();
	  ResultSet rsC=stateC.executeQuery(sqlC);
	  if (rsC.next()==false)
	  {
		  String sql="insert into INV_ITEM(ITEMNO,ITEMDESC,ITEMUOM,ITEMCREATEUSER,ITEMCREATEDATE,ITEMCREATENO,SERIALCOLUMN) values(?,?,?,?,?,?,?)";
		  PreparedStatement pstmt=con.prepareStatement(sql);  
		  pstmt.setString(1,item);
		  pstmt.setString(2,itemDesc); 
		  pstmt.setString(3,uomcode);
		  pstmt.setString(4,userID); 
		  pstmt.setInt(5,iDate);
		  pstmt.setString(6,itemcreateNo); 
		  pstmt.setInt(7,0);   
		  
		  pstmt.executeUpdate();
		
		  if (sNew=="Y")
		  {
			String sqlN="insert into INV_SEQ(SEQTYPE,SEQDESC,SEQDATE,SEQMAX) values(?,?,?,?)";
			PreparedStatement pstmtN=con.prepareStatement(sqlN);  
			pstmtN.setString(1,"C");
			pstmtN.setString(2,"料號"); 
			pstmtN.setString(3,sDate);
			pstmtN.setInt(4,iSeq);   
		  
			pstmtN.executeUpdate();  
		  }
		  else
		  {
			String sqlN="update INV_SEQ set SEQMAX = '"+iSeq+"' where SEQTYPE = 'C' and SEQDATE = '"+sDate+"' ";
			PreparedStatement pstmtN=con.prepareStatement(sqlN);  
		  
			pstmtN.executeUpdate();    
		  }
		
		  out.println("Item insert OK!! <BR><BR><BR>Item:"+item+"<BR>ItemDesc:"+itemDesc+"<BR>UOM:"+uomcode+"<BR>User:"+userID+"<BR>Date:"+iDate+"<BR>Number:"+itemcreateNo+"<BR><BR><BR>");
		  pstmt.close();	  
	  }
	  else
	  {
		  out.println("Item:"+item+" exists!! <BR><BR><BR>");
	  }  
	  rsC.close();
	  stateC.close();
	  //out.println("<A HREF=../jsp/INVItemCreate.jsp>Item Create FORM<BR><BR></A><A HREF=/wins/WinsMainMenu.jsp>回首頁</A>");			  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<BR>
<A HREF=../jsp/INVItemCreate.jsp>新增料號</A>
<BR>
<A HREF=/wins/WinsMainMenu.jsp>回首頁</A>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
