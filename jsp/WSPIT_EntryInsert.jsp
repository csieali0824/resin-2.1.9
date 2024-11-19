<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayChkBox4PITBean" %>
<jsp:useBean id="ArrayChkBox4PITBean" scope="session" class="ArrayChkBox4PITBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Function Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<%
String dateString="",seqkey="",seqno="";
String product=request.getParameter("PRODUCT");
String model=request.getParameter("MODEL");
String objectname=request.getParameter("OBJECTNAME");
String object=request.getParameter("OBJECT");
String version=request.getParameter("VERSION");
String source=request.getParameter("SOURCE");
String fromStatus=request.getParameter("FROMSTATUS");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String action=request.getParameter("ACTION");
String a[][]=ArrayChkBox4PITBean.getArray2DContent();//取得目前陣列內容   
int i=0,j=0,k=0;
String sql="",sFunc=""; 
dateString=dateBean.getYearMonthDay(); 
Statement statement=con.createStatement();
ResultSet rs=null;
try
{  
    if (a!=null) 
   {   
    //*********取得下一個流程資訊**********************************
    String nextStatus="",nextStatusName="";  
    rs=statement.executeQuery("select TOSTATUSID,STATUSNAME from WSWORKFLOW w,WSWFSTATUS s where TOSTATUSID=STATUSID and FORMID='"+formID+"' and TYPENO='"+typeNo+"' and FROMSTATUSID='"+fromStatus+"' and ACTIONID='"+action+"'");
    if (rs.next())
    {
      nextStatus=rs.getString("TOSTATUSID");  
	  nextStatusName=rs.getString("STATUSNAME");        
    }    
    rs.close();  
    //************END OF 取得下一個流程資訊**************************  
	for (i=0;i<a.length;i++)
	{
	 sql="select code from pit_function where name='"+a[i][2]+"'";		
	 rs=statement.executeQuery(sql);
	 while (rs.next()) //main loop			 	    				
	 {
	   sFunc=rs.getString("code");
     } 
      rs.close();   
 		  //to get the series number   
		  
		  seqkey="PIT"+dateString.substring(2); //this is the key,ex:PIT050603
		  rs=statement.executeQuery("select * from DOCSEQ where header='"+seqkey+"'");  
		  if (rs.next()==false)
		  {   
			String seqSql="insert into DOCSEQ values(?,?)";   
			PreparedStatement seqstmt=con.prepareStatement(seqSql);     
			seqstmt.setString(1,seqkey);
			seqstmt.setInt(2,1);   	
			seqstmt.executeUpdate();
			seqno=seqkey+"-0001";
			seqstmt.close();   
		  } else {   
			int lastno=rs.getInt("LASTNO");
			lastno++;
			String numberString = Integer.toString(lastno);
			String lastSeqNumber="0000"+numberString;
			lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-4);
			seqno=seqkey+"-"+lastSeqNumber;  
			String seqSql="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
			PreparedStatement seqstmt=con.prepareStatement(seqSql);        
			seqstmt.setInt(1,lastno);   	
			seqstmt.executeUpdate();   
			seqstmt.close(); 
            rs.close(); 
		  }
		//============end of get series ================================= 
		
          		sql="insert into PIT_MASTER(TICKETNO,PRODUCT,MODEL,T_OBJECT,T_VERSION,MFUNCTION,SFUNCTION,ENTRYDATE,ENTRYTIME,ENTRYBY,T_SOURCE,S_LEVEL,PBBT,PHNMN,LOCATION,COMPARISON,ISP_SIM,ISP_NETWORK,RESULT,STATUSID,STATUS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement pstmt=con.prepareStatement(sql);  
     		    pstmt.setString(1,seqno);
       		    pstmt.setString(2,product);  
        		pstmt.setString(3,model);
        		pstmt.setString(4,object);
         		pstmt.setString(5,version);
        		pstmt.setString(6,a[i][1]); //MFUNCTION
         		pstmt.setString(7,a[i][3]); //SFOUNCTION
         		pstmt.setString(8,dateBean.getYearMonthDay()); //ENTRYDATE
         		pstmt.setString(9,dateBean.getHourMinute()); //ENTRYTIME
         		pstmt.setString(10,userID); //ENTRYBY
         		pstmt.setString(11,source); //T_SOURCE
         		pstmt.setString(12,a[i][5]); //LEVEL
         		pstmt.setString(13,a[i][6]); //PROBABILITY
         		pstmt.setString(14,a[i][12]); //PHENOMENON
         		pstmt.setString(15,a[i][11]); //LOCATION
         		pstmt.setString(16,a[i][10]); //COMPARISON
         		pstmt.setString(17,a[i][7]); //SIM
         		pstmt.setString(18,a[i][8]); //NETWORK
         		pstmt.setString(19,a[i][9]); //RESULT  
				if (a[i][7].equals("NG")) 
				{
				   pstmt.setString(20,nextStatus); //STATUSID  
         		   pstmt.setString(21,nextStatusName); //STATUS  
				}
				else
				{
				   pstmt.setString(20,"109"); //STATUSID  
         		   pstmt.setString(21,"CLOSE"); //STATUS  

				}
				
 			    pstmt.executeUpdate();			
		 k++;
	}
   } 
  out.println("insert into Data OK!! <BR>");
  out.println("<A HREF=../jsp/WSPIT_QueryAll.jsp>Query All</A>&nbsp;&nbsp;<A HREF=../jsp/WSPIT_Entry.jsp>繼續新增</A>");
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

