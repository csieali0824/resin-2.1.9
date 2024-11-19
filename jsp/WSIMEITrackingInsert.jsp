<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%
     //String RepUserID=(String)session.getAttribute("USERID");   	 
	 //String UserName=(String)session.getAttribute("USERNAME");      
     //String RpCenterNo=(String)session.getAttribute("USERREPCENTERNO");
	 //String topicID=request.getParameter("TOPICID");
     //String topicType=request.getParameter("TOPICTYPE");
	 //String topicName=request.getParameter("TOPICNAME");
	 //String askerName=request.getParameter("ASKERNAME");
	 //String askerSex=request.getParameter("ASKERSEX");
	 //String askerEMail=request.getParameter("ASKEREMAIL");
	 String userID=request.getParameter("USERID");
	 String imei=request.getParameter("IMEI");
	 String repCenterNo=request.getParameter("REPCENTERNO");
	 String locale=request.getParameter("LOCALE");
	 String unitNo=request.getParameter("UNITNO");
	 String custName=request.getParameter("CUSTNAME");
	 //String custNo=request.getParameter("CUSTNO");    //
	 String custNo="";   //
	 String contactTel=request.getParameter("CONTACTTEL");
	 String contactFax=request.getParameter("CONTACTFAX");
	 String custAddress=request.getParameter("CUSTADDRESS");
	 String contact=request.getParameter("CONTACT");
	 
	 //String userName="";
	 //String dateString="";
     //String seqkey="";
     //String seqno="";
	 
        //  int replyCount = 0;
	 
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
	 //int iDateTime = Integer.parseInt(strDateTime);
	 
	 //if (topicType==null || topicType.equals("") || topicType.equals("--")){ topicType = "03"; }   // 若使用者未選擇特定類別,則歸納為其他類 //
	 

	/*
	 Statement stateU=con.createStatement();
	 ResultSet rsU=stateU.executeQuery("select USERNAME from RPUSER where USERID='"+RepUserID+"' ");
     if (rsU.next()){ userName = rsU.getString("USERNAME"); }
	 rsU.close();
	 stateU.close();
	*/ 
%>
<%
// Startup取最大技術文件單號
	 //********先取得流水號****************************************************
	 //dateString=dateBean.getYearMonthDay();     
	 //seqkey="TE"+RpCenterNo+dateString;   // 改抓隸屬維修中心別
	// seqkey="TE"+userRepCenterNo+dateString;   // 改抓session隸屬維修中心別
     Statement statement=con.createStatement();
     ResultSet rs=statement.executeQuery("select * from IMEI_TRACKING where IMEI='"+imei+"'");
     //若不存在,則新增
     if (rs.next()==false)
     {   
	   // 抓最大客戶編號,起
	   String sqlLast = "select max(substr(AGENTNO,5,3)) as LASTNO from WSCUST_AGENT  where substr(AGENTNO,1,3)='"+repCenterNo+"' and AGENTNAME='"+custName+"' ";
	   ResultSet rsLast=statement.executeQuery(sqlLast);
	   if (rsLast.next()) 
	   { 
	     int lastno = rsLast.getInt("LASTNO"); 
		 lastno++;
		// if (lastno>= 0 && lastno <=9) { strLastNo = "00"+Integer.toString(lastno);}
		// else if (lastno>=10 && lastno <=99) { strLastNo = "0"+Integer.toString(lastno);}
		 String numberString = Integer.toString(lastno);
         String lastSeqNumber="000"+numberString;
         lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
		 custNo = repCenterNo+"-"+lastSeqNumber;     
	   }
	   else
	  {
	     custNo = repCenterNo+"-001";
	  }   // end of if (rsLast.next()) 
	  rsLast.close();
	 // 抓最大客戶編號,迄
	 // 2004/03/16 add check from mes_wip_tracking
	  ResultSet rsMES=statement.executeQuery("select IMEI from MES_WIP_TRACKING where IMEI='"+imei+"'");
	  if (rsMES.next())  // 若存在於MES工廠包裝出貨記錄內,則允許寫入
	  {	 
         String seqSql="insert into IMEI_TRACKING(IMEI,IN_DATETIME,IN_USER,IN_CENTERNO,IN_LOCALE,UNIT_NO,CUST_NAME,CUST_NO,CONTACT_TEL,CONTACT_FAX,CUST_ADDRESS,CONTACT_NAME) values(?,?,?,?,?,?,?,?,?,?,?,?)";   
         PreparedStatement seqstmt=con.prepareStatement(seqSql);     
         //seqstmt.setString(1,"123456789012345");
	     seqstmt.setString(1,imei);
         seqstmt.setString(2,strDateTime); 
	     //seqstmt.setString(2,"12345678901234"); 
	     seqstmt.setString(3,userID);
	     //seqstmt.setString(3,"B01815");
	     //seqstmt.setString(4,"003");
	     seqstmt.setString(4,repCenterNo);
	     seqstmt.setString(5,locale);
	     //seqstmt.setString(5,"886");
	     seqstmt.setString(6,unitNo);
	     seqstmt.setString(7,custName);
	     //seqstmt.setString(8,custNo);    //
	     seqstmt.setString(8,custNo);  //
	     seqstmt.setString(9,contactTel);
	     seqstmt.setString(10,contactFax);
	     seqstmt.setString(11,custAddress);
	     seqstmt.setString(12,contact);
	
         seqstmt.executeUpdate();
         //seqno=seqkey+"-001";
         seqstmt.close();   
	     //Statement statement=con.createStatement();
        ResultSet rsCust=statement.executeQuery("select * from WSCUST_AGENT where AGENTNAME='"+custName+"' ");
	    if (rsCust.next()==false)
	   {  
	     String sSqlIns="insert into WSCUST_AGENT(AGENTNO, LOCALE, AGENTNAME, AGENTADDR, AGENTTEL, AGENTFAX, AGENT_UNITNO, CONTACTMAN) "+
	                             "values(?,?,?,?,?,?,?,?)";   
         PreparedStatement seqstmtIns=con.prepareStatement(sSqlIns);     
       
	     seqstmtIns.setString(1,custNo);
         seqstmtIns.setString(2,locale); 	  
	     seqstmtIns.setString(3,custName);
	     seqstmtIns.setString(4,custAddress);
	     seqstmtIns.setString(5,contactTel);
	     seqstmtIns.setString(6,contactFax);
	     seqstmtIns.setString(7,unitNo);
	     seqstmtIns.setString(8,contact);
	     seqstmtIns.executeUpdate();      
         seqstmtIns.close();   
	    }
	    else   // 若已存在,則更新客戶資料內容
	   {
	     String sSqlUpd="update WSCUST_AGENT set AGENTNO=?, LOCALE=?, AGENTADDR=?, AGENTTEL=?, AGENTFAX=?, AGENT_UNITNO=?, CONTACTMAN=? "+
	                              "where AGENTNAME='"+custName+"' ";   
         PreparedStatement seqstmtUpd=con.prepareStatement(sSqlUpd);   
	     seqstmtUpd.setString(1,custNo);
         seqstmtUpd.setString(2,locale); 	  
	     //seqstmtUpd.setString(3,custName);
	     seqstmtUpd.setString(3,custAddress);
	     seqstmtUpd.setString(4,contactTel);
	     seqstmtUpd.setString(5,contactFax);
	     seqstmtUpd.setString(6,unitNo);
	     seqstmtUpd.setString(7,contact);
	     seqstmtUpd.executeUpdate();      
         seqstmtUpd.close();   
	   }
	    rsCust.close();
	    response.sendRedirect("../jsp/WSIMEITracking.jsp?DUPIMEI=N&IMEIEXIST=Y");	   
	   } // 
	   else 
	   {
	      response.sendRedirect("../jsp/WSIMEITracking.jsp?DUPIMEI=N&IMEIEXIST=N");	  
	   }  // end of if (rsMES.next() )
	   rsMES.close();
      }   // 否則,導向原頁面並Prompt Error(Call Java Script)
	  else
     {
	   response.sendRedirect("../jsp/WSIMEITracking.jsp?DUPIMEI=Y");
     }	 
      statement.close();
      rs.close();
     //out.println("Insert New Technolog Document Success !!!");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>新增IMEI內容</title>
</head>
<body>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
