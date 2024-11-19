<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Sales Forecast Cost Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String comp=request.getParameter("COMP");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");
String type=request.getParameter("TYPE");
String curr=request.getParameter("CURR");
String cUser=request.getParameter("CUSER");

String repCenterNo=request.getParameter("REPCENTERNO");
String locale=request.getParameter("LOCALE");
String custNo="";   //

String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //

String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容

try
{  

  String sql="";
  PreparedStatement pstmt=null;
   if (a!=null) 
   {   
     String ym[]=array2DimensionInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)
     { 	 
            // Startup取最大技術文件單號
	 //********先取得流水號****************************************************
	 //dateString=dateBean.getYearMonthDay();     
	 //seqkey="TE"+RpCenterNo+dateString;   // 改抓隸屬維修中心別
	 // seqkey="TE"+userRepCenterNo+dateString;   // 改抓session隸屬維修中心別
     Statement statement=con.createStatement();
     ResultSet rs=statement.executeQuery("select * from IMEI_TRACKING where IMEI='"+a[ac][0]+"'");
     //若不存在,則新增
     if (rs.next()==false)
     {   
	   // 抓最大客戶編號,起
	   String sqlLast = "select max(substr(AGENTNO,5,3)) as LASTNO from WSCUST_AGENT  where substr(AGENTNO,1,3)='"+repCenterNo+"' and AGENTNAME='"+a[ac][2]+"' ";
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
	  }
	  rsLast.close();
     }
	 // 抓最大客戶編號,迄
	   //for (int subac=1;subac<a[ac].length;subac++)
	   //{
	     //String tpym=ym[subac+1]; 
	     //String tpy=tpym.substring(0,4); //get year String
		 //String tpm=tpym.substring(5,7); //get month String
		 //String c_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位
          // sql="insert into PSALES_FORE_COST(FCCOMP,FCYEAR,FCMONTH,FCREG,FCCOUN,FCTYPE,FCPRJCD,FCCOST,FCMVER,FCLUSER,FCCURR) values(?,?,?,?,?,?,?,?,?,?,?)";
           sql="insert into IMEI_TRACKING(IMEI,IN_DATETIME,IN_USER,IN_CENTERNO,IN_LOCALE,UNIT_NO,CUST_NAME,CUST_NO,CONTACT_TEL,CONTACT_FAX,CUST_ADDRESS,CONTACT_NAME) values(?,?,?,?,?,?,?,?,?,?,?,?)";
           //sql="insert into PRPRODUCT_CENTER(INTER_MODEL,CREATE_USER) values(?,?)";
           pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,a[ac][0]);
           pstmt.setString(2,strDateTime);
           pstmt.setString(3,userID); 
           //pstmt.setString(3,"B01815");  
           pstmt.setString(4,repCenterNo);
           pstmt.setString(5,locale);
           pstmt.setString(6,a[ac][1]);  // UnitNo 
           pstmt.setString(7,a[ac][2]);   // custName
           pstmt.setString(8,custNo);      
           pstmt.setString(9,a[ac][3]); // contactTel
           pstmt.setString(10,a[ac][4]);   //contactFax                            
           pstmt.setString(11,a[ac][5]);  //custAddress
           pstmt.setString(12,a[ac][6]);   //contact           
         /* 
         */
           pstmt.executeUpdate();
           pstmt.close();

           ResultSet rsCust=statement.executeQuery("select * from WSCUST_AGENT where AGENTNAME='"+a[ac][2]+"' ");
	       if (rsCust.next()==false)
	       {           
	   
	        String sSqlIns="insert into WSCUST_AGENT(AGENTNO, LOCALE, AGENTNAME, AGENTADDR, AGENTTEL, AGENTFAX, AGENT_UNITNO, CONTACTMAN) "+
	                       "values(?,?,?,?,?,?,?,?)";   
            PreparedStatement seqstmtIns=con.prepareStatement(sSqlIns);     
       
	        seqstmtIns.setString(1,custNo);
            seqstmtIns.setString(2,locale); 	  
	        seqstmtIns.setString(3,a[ac][2]); // custName
	        seqstmtIns.setString(4,a[ac][5]); //custAddress
	        seqstmtIns.setString(5,a[ac][3]);// contactTel
	        seqstmtIns.setString(6,a[ac][4]);//contactFax
	        seqstmtIns.setString(7,a[ac][1]); // unitNo
	        seqstmtIns.setString(8,a[ac][6]);//contact
	        seqstmtIns.executeUpdate();      
            seqstmtIns.close();   
	      }
	      else   // 若已存在,則更新客戶資料內容
	      {
	        String sSqlUpd="update WSCUST_AGENT set AGENTNO=?, LOCALE=?, AGENTADDR=?, AGENTTEL=?, AGENTFAX=?, AGENT_UNITNO=?, CONTACTMAN=? "+
	                       "where AGENTNAME='"+a[ac][2]+"' ";   
            PreparedStatement seqstmtUpd=con.prepareStatement(sSqlUpd);   
	        seqstmtUpd.setString(1,custNo);
            seqstmtUpd.setString(2,locale); 	  
	   //seqstmtUpd.setString(3,custName);
	        seqstmtUpd.setString(3,a[ac][5]);
	        seqstmtUpd.setString(4,a[ac][3]);
	        seqstmtUpd.setString(5,a[ac][4]);
	        seqstmtUpd.setString(6,a[ac][1]);
	        seqstmtUpd.setString(7,a[ac][6]);
	        seqstmtUpd.executeUpdate();      
            seqstmtUpd.close();   
	      }
          rs.close();
	      rsCust.close();        
          statement.close();         
		//} //end of sub for   
	} //enf of for	
  } //end of array if null
  
  out.println("Input IMEI Data Successfully!!<BR>");
  //out.println("<A HREF=../jsp/WSForePriCostEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Price & Cost of Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Sales Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to C&F Sub Menu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  out.println("<A HREF=/wins/WinsMainMenu.jsp>首頁</A>"); 
  out.println("&nbsp;&nbsp;");
  out.println("<A HREF=/wins/jsp/WSIMEITrackingInput.jsp>客戶/經銷商優惠活動IMEI碼輸入頁面</A>");   
  
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(array2DimensionInputBean.getResultString());		
     array2DimensionInputBean.setArray2DString(null);  // 印完後即釋放arrayBean的內容		   	 
   }	//enf of a!=null if         
 
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
