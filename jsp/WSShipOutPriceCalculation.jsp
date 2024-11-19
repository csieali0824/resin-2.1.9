<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbglobalPoolPage.jsp"%>
<%@ page import="DateBean,SendMailBean" %>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<script language="JavaScript" type="text/JavaScript">
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Daily Ship-out Price Calculation</title>
</head>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM METHOD="post" NAME="MYFORM">
<font color="#54A7A7" face="Times New Roman" size="5"><STRONG>DBTEL</font><font color="#000000" size="5" face="Times New Roman"> <strong>Ship-out
 Price Calcuation </strong></font><BR>
 <font color="#000000" size="+2" face="Times New Roman"><strong> </strong></font><A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSExwPriCogsEntry.jsp">Entry
Ship-Out Price/COGs</A> 
</FORM> 
<%	
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String interModel="";
String region="";
String country="";
int newRecords=0;
int updateRecords=0;
try 
{ 
  String  countrySql="",countryWhere="",countryOrder;  
  Statement countryStmt=con.createStatement();  
  countrySql="select count (*) from PSALES_COUNTRY_FACTOR,WSLOCALE";
  countryWhere=" where COUNTRY=LOCALE"; 
  countrySql=countrySql+countryWhere; 
  ResultSet countryRs=countryStmt.executeQuery(countrySql); 
  int arrayIdx=0;
  if (countryRs.next()) 
  {
   arrayIdx=countryRs.getInt(1);      
  }   
  String countryArray[][]=new String[arrayIdx][7]; 
  countryRs.close();
  countrySql="select CURR,REGION,COUNTRY,EXW_ADJ,BASECOUNTRY from PSALES_COUNTRY_FACTOR";
  countryWhere="";  
  countryOrder=" order by REGION,COUNTRY";
  countrySql=countrySql+countryWhere+countryOrder; 
  countryRs=countryStmt.executeQuery(countrySql); 
  int countryCount=0;  
  while (countryRs.next())
  {    
    countryArray[countryCount][0]=countryRs.getString("COUNTRY");
	countryArray[countryCount][1]=countryRs.getString("CURR"); //CURRENCY
	countryArray[countryCount][2]=countryRs.getString("REGION");	
	countryArray[countryCount][3]=countryRs.getString("EXW_ADJ"); //EXW-PRICE Adjustment of country
	countryArray[countryCount][4]=countryRs.getString("BASECOUNTRY"); //TO GET BASECOUNTRY			
	countryCount++;
  }  
  countryRs.close();
  countryStmt.close();
  
  String sSql = "",subSql="";
  String sWhere = "",subWhere="";
  String sOrder = "",subOrder="";  
  float exw_adj=1; //EXW-PRICE Adjustment of country
  float exw_price=0,b_exw_price=0; //EXW PRICE
  float brand_adj=1; //算若無出廠價時用來由零售價推算出出廠價調整因子
  float t_exw_price=0;//計算出來之出廠價
  float smallerExwPrice=0;//較小之出廠價
  float biggerExwPrice=0;
  String brand="";

  //取得基準國vat
  float vatAdj=1;
  String baseCurr="";//基準國之幣別
  Statement vatStmt=con.createStatement(); 
  ResultSet vatRs=vatStmt.executeQuery("select VAT,CURR from PSALES_COUNTRY_FACTOR where COUNTRY='"+countryArray[0][4]+"'");
  if (vatRs.next()) vatAdj=1+vatRs.getFloat("VAT"); baseCurr=vatRs.getString("CURR");
  vatRs.close();
  vatStmt.close();
  
  Statement exStmt=ifxdbglobalcon.createStatement();  
  for (int cac=0;cac<countryArray.length;cac++)
  {	
    //取得各國對basecountry之匯率	    
    ResultSet exRs=exStmt.executeQuery("select CCNVFC,CCNVDT FROM GCC where CCFRCR='"+baseCurr+"' and CCTOCR='"+countryArray[cac][1]+"' order by CCNVDT DESC");  
    if (exRs.next()) 
	{ 
   	  countryArray[cac][6]=exRs.getString("CCNVFC"); //各國對basecountry之匯率
	} else {
	  countryArray[cac][6]="1"; //各國對basecountry之匯率
	}
	exRs.close();
  } //end of countryArray for	 
  exStmt.close(); 
  	  
  //sSql = "select trim(INTER_MODEL) as INTERMODEL,BRAND_ADJ from PSALES_PROD_CENTER x,PIBRAND y";
  sSql = "select trim(PROJECTCODE) as INTERMODEL,BRAND_ADJ from PIMASTER x,PIBRAND y";
  sWhere = " where x.BRAND=y.BRAND";   
  sOrder = " order by x.BRAND,INTERMODEL";		 
  sSql = sSql+sWhere+sOrder;		
 		  		      
  Statement statement=con.createStatement();  
  ResultSet rs=statement.executeQuery(sSql); 
  Statement subStmt=con.createStatement();	  
  ResultSet subRs=null;  
  
  while (rs.next()) //round 所有model
  {           
   dateBean.setDate(thisDateBean.getYear(),thisDateBean.getMonth(),1);  
   dateBean.setAdjMonth(-3); //設定為運算當日前3個月為啟始日
   
    interModel=rs.getString("INTERMODEL");
    brand_adj=rs.getFloat("BRAND_ADJ");  
	for (int cac=0;cac<countryArray.length;cac++)
	{	
   	 countryArray[cac][5]="999999999"; //此為第一個月的出廠價,初始值設為極大值
	} //end of countryArray for			
	
	for (int monthcount=1;monthcount<19;monthcount++) //計算從啟始日期開始到之後18個月
	{	 
       //============取得BASECOUNTRY零售價並計算出出廠價===========================================
	   subSql="select FPPRI from PSALES_FORE_PRICE"; 
	   subWhere=" where FPCURR='"+baseCurr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+dateBean.getYearString()+"' and FPMONTH='"+dateBean.getMonthString()+"' order by FPMVER DESC"; 	 	
	   subSql=subSql+subWhere;  	
 	   subRs=subStmt.executeQuery(subSql);
	   if (subRs.next()) { t_exw_price=(subRs.getInt("FPPRI")/vatAdj)*brand_adj; } else { t_exw_price=0;}		
	   subRs.close(); 	 
	   //=========================================================  
	   //取得實際輸入之basecountry出廠價
	   subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 		 	
	   subWhere=" where FPCURR='"+baseCurr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+dateBean.getYearString()+"' and FPMONTH='"+dateBean.getMonthString()+"' order by FPMVER DESC"; 
	   subSql=subSql+subWhere;
       subRs=subStmt.executeQuery(subSql);	  
	   if (subRs.next())
       {	   
	     b_exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	   } else {
	     b_exw_price=0;
	   }		
	   subRs.close(); 			
	   smallerExwPrice=Math.min(b_exw_price,t_exw_price);		  
	   biggerExwPrice=Math.max(b_exw_price,t_exw_price);
	   if (smallerExwPrice>0) { b_exw_price=smallerExwPrice;} else { b_exw_price=biggerExwPrice;}	
	
	   //計算各國之出廠價資訊
	   for (int cac=0;cac<countryArray.length;cac++)
	   {	  	 	   
	     region=countryArray[cac][2]; 
		 country=countryArray[cac][0]; 
		 //取得各國實際輸入之出廠價
		 subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 		 	
	     subWhere=" where FPCURR='"+countryArray[cac][1]+"' and FPCOUN='"+country+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+dateBean.getYearString()+"' and FPMONTH='"+dateBean.getMonthString()+"' order by FPMVER DESC"; 
	     subSql=subSql+subWhere;
         subRs=subStmt.executeQuery(subSql);	  
		 if (subRs.next())  
    	 {	   
	       exw_price=subRs.getInt("FPEXWPRI")/Float.parseFloat(countryArray[cac][6]);	//換算成basecountry之幣別  	      	   	   
	     } else {
	       exw_price=0;
	     }		
	     subRs.close(); 		 
		
	     smallerExwPrice=Math.min(exw_price,b_exw_price);		  
	     biggerExwPrice=Math.max(exw_price,b_exw_price);
	     if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}	           
	      exw_adj=Float.parseFloat(countryArray[cac][3]); //各國出廠價之調整因子	
	      if (exw_price>0)
	      {
		    int final_shipout_price=0;
			if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	        {	           		                     			   
			   final_shipout_price=Math.round(exw_price*exw_adj); //FINAL SHIPOUT PRICE	
	        } else {
			   final_shipout_price=Integer.parseInt(countryArray[cac][5]); //FINAL SHIPOUT PRICE	 
		    } 			
		    //77777777CHECK SHIPOUT_PRICE是否已存在且價格一致,若價格已變動則重新寫入之77777777777
			subSql="select SPPRI from PSALES_SHIPOUT_PRICE"; 		 	
	        subWhere=" where SPCURR='"+baseCurr+"' and SPREG='"+region+"' and SPCOUN="+country+" and SPPRJCD='"+interModel+"' and SPYEAR='"+dateBean.getYearString()+"' and SPMONTH='"+dateBean.getMonthString()+"' order by SPMVER DESC"; 
	        subSql=subSql+subWhere;
            subRs=subStmt.executeQuery(subSql);	  			
		    if (subRs.next()) 
    	    {	
			  //如果存在但價格不一致			  
			  if (subRs.getInt("SPPRI")!=final_shipout_price)
			  {			   
			    updateRecords++; 
			    String sql="insert into PSALES_SHIPOUT_PRICE(SPYEAR,SPMONTH,SPREG,SPCOUN,SPPRJCD,SPPRI,SPMVER,SPLUSER,SPCURR) values(?,?,?,?,?,?,?,?,?)";
                PreparedStatement pstmt=con.prepareStatement(sql);              
                pstmt.setString(1,dateBean.getYearString());  
                pstmt.setString(2,dateBean.getMonthString());
                pstmt.setString(3,region);
                pstmt.setString(4,country);
                pstmt.setString(5,interModel); //MODEL                		   			 
	            pstmt.setInt(6,final_shipout_price); //FINAL SHIPOUT PRICE		            	      
			    pstmt.setString(7,thisDateBean.getYearMonthDay()+thisDateBean.getHourMinute());
                pstmt.setString(8,"WSADMIN");
		        pstmt.setString(9,baseCurr);
			
			    pstmt.executeUpdate();
			    pstmt.close(); 		 			 			
			  }//end of 價格不一 if	
			} else {   //如果不存在		
			  newRecords++;	  		    
	          String sql="insert into PSALES_SHIPOUT_PRICE(SPYEAR,SPMONTH,SPREG,SPCOUN,SPPRJCD,SPPRI,SPMVER,SPLUSER,SPCURR) values(?,?,?,?,?,?,?,?,?)";
              PreparedStatement pstmt=con.prepareStatement(sql);              
              pstmt.setString(1,dateBean.getYearString());  
              pstmt.setString(2,dateBean.getMonthString());
              pstmt.setString(3,region);
              pstmt.setString(4,country);
              pstmt.setString(5,interModel); //MODEL         		   			 	                   		                     			   
			  pstmt.setInt(6,final_shipout_price); //SHIPOUT PRICE         			           
			  pstmt.setString(7,thisDateBean.getYearMonthDay()+thisDateBean.getHourMinute());
              pstmt.setString(8,"WSADMIN");
		      pstmt.setString(9,baseCurr);
			
			  pstmt.executeUpdate();
			  pstmt.close(); 		 			 
	        } //END OF 檢查正式出廠價是否已存在且價格相同 IF 	
			countryArray[cac][5]=String.valueOf(final_shipout_price); //設當月值做為下一個月之計算用
	        subRs.close(); 
			//7777777777777777777777777777 	  		    
	      }	//END OF 出廠價EXW PRICE>0      							 	  		  
	   } //end of countryArray for		
	   dateBean.setAdjMonth(1); //往後加一個月
	} //end of 計算18個月      
    
  } //end of rs.next While   
  rs.close();   
  subStmt.close();
  statement.close();
  
  //to send mail to Administrator
  sendMailBean.setMailHost(mailHost);
  sendMailBean.setReception("roger_chang@dbtel.com.tw");
  sendMailBean.setFrom("WSADMIN");     	 	 
  sendMailBean.setSubject("Daily Ship-out Price Calculation");	 
  sendMailBean.setBody("New Records:"+newRecords+" has been added. \n Old records:"+updateRecords+" had been updated.");	
  sendMailBean.sendMail();       
 %>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbglobalPage.jsp"%>
<!--=================================-->  
<%
  response.sendRedirect("WSRetailerPriceInqueryNew.jsp");
  return;
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
   //to send mail to Administrator
  sendMailBean.setMailHost(mailHost);
  sendMailBean.setReception("roger_chang@dbtel.com.tw");
  sendMailBean.setFrom("WSADMIN");     	 	 
  sendMailBean.setSubject("ERROR:Daily Ship-out Price Calculation");	 
  sendMailBean.setBody("Exception:"+e.getMessage());	
  sendMailBean.sendMail();  
}   
%>    
</body>
</html>
