<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbglobalPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>-->
<%@ page import="DateBean,SendMailBean" %>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<script language="JavaScript" type="text/JavaScript">
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Monthly Retailer Price Calculation</title>
</head>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM METHOD="post" NAME="MYFORM">
</FORM> 
<%	
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String interModel="";
String region="";
String country="";

int newRecords=0;
int updateRecords=0;
int newBPCSRecords=0;
int updateBPCSRecords=0;
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
  countrySql="select VAT,CURR,REGION,COUNTRY,BASECOUNTRY from PSALES_COUNTRY_FACTOR";
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
	countryArray[countryCount][3]=countryRs.getString("VAT"); //VAT
	countryArray[countryCount][4]=countryRs.getString("BASECOUNTRY"); //TO GET BASECOUNTRY			
	countryCount++;
  }  
  countryRs.close();
  countryStmt.close();
  
  String sSql = "",subSql="";
  String sWhere = "",subWhere="";
  String sOrder = "",subOrder="";    
  float rt_price=0; //retailer PRICE  
  float t_rt_price=0;//計算出來之零售價 
  float channelGM=1;
  String brand="";

  //取得基準國CURRENCY
  
  String baseCurr="";//基準國之幣別
  Statement vatStmt=con.createStatement(); 
  ResultSet vatRs=vatStmt.executeQuery("select CURR from PSALES_COUNTRY_FACTOR where COUNTRY='"+countryArray[0][4]+"'");
  if (vatRs.next()) baseCurr=vatRs.getString("CURR");
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
  //Statement bpcsSubStmt=bpcscon.createStatement();	
  Statement bpcsSubStmt=ifxTestCon.createStatement();  
  ResultSet bpcsSubRs=null;   
  
  while (rs.next()) //round 所有model
  {           
   dateBean.setDate(thisDateBean.getYear(),thisDateBean.getMonth(),1);  
   dateBean.setAdjMonth(-3); //設定為運算當日前3個月為啟始日
   
    interModel=rs.getString("INTERMODEL");
	channelGM=(1-rs.getFloat("BRAND_ADJ"));      
	for (int cac=0;cac<countryArray.length;cac++)
	{	
   	 countryArray[cac][5]="999999999"; //此為第一個月的零售價,初始值設為極大值
	} //end of countryArray for			
	
	for (int monthcount=1;monthcount<19;monthcount++) //計算從啟始日期開始到之後18個月	
	{		    	     	  	  	
	   //計算各國之零售價資訊
	   for (int cac=0;cac<countryArray.length;cac++)
	   {	
	     int local_rt_price=0; //local retailer PRICE with local currency  
	     String isExistRtPrice="N";//用來判斷是否存在有各國實際輸之零售價
	     float vatAdj=1;  	 	
		 vatAdj=1+Float.parseFloat(countryArray[cac][3]);//各國之VAT調整值
	     region=countryArray[cac][2]; 
		 country=countryArray[cac][0]; 
		  //先取得實際輸入之各國的零售價-----------------------------------	     
		 subSql="select FPMVER,FPPRI from PSALES_FORE_PRICE"; 		 	
	     subWhere=" where FPCURR='"+countryArray[cac][1]+"' and FPCOUN='"+country+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+dateBean.getYearString()+"' and FPMONTH='"+dateBean.getMonthString()+"' order by FPMVER DESC"; 
	     subSql=subSql+subWhere;
         subRs=subStmt.executeQuery(subSql);	  
	     if (subRs.next())
         {	   
	       rt_price=Math.round((subRs.getInt("FPPRI")/vatAdj)/Float.parseFloat(countryArray[cac][6]));//換算成basecountry之幣別  	      	   	   
		   local_rt_price=subRs.getInt("FPPRI");
		   isExistRtPrice="Y";
	     } else {
	       rt_price=0;
	     }		
	     subRs.close();
		 //------------------------------------------------------------------- 			
		 
		 if (rt_price<=0) //如果沒有實際輸入之零售價才取得計算出之零售價
		 {		 
		   //取得各國之最終出廠價
		   subSql="select SPMVER,SPPRI from PSALES_SHIPOUT_PRICE"; 		 	
	       subWhere=" where SPCURR='"+baseCurr+"' and SPCOUN='"+country+"' and SPPRJCD='"+interModel+"' and SPYEAR='"+dateBean.getYearString()+"' and SPMONTH='"+dateBean.getMonthString()+"' order by SPMVER DESC"; 
		   //用base country 的currency之原因為出廠價一律換算成base country之幣別
	       subSql=subSql+subWhere;
           subRs=subStmt.executeQuery(subSql);	  
		   if (subRs.next())  
    	   {	  		     
	         rt_price=Math.round(subRs.getInt("SPPRI")/(1-channelGM)); //演算成最低零售價      	   	   			 
	       } else {
	         rt_price=0;
	       }		
	       subRs.close(); 	
	     }     
	     
	      if (rt_price>0)
	      {		
		    int final_rt_price=0;
			if (Integer.parseInt(countryArray[cac][5])>=rt_price)  
	        {	           		                     			   
			   final_rt_price=Math.round(rt_price); //FINAL RETAILER PRICE	
	        } else {
			    if (isExistRtPrice.equals("Y") )//若存在輸入之實際零售價
				{
				   final_rt_price=Math.round(rt_price); //FINAL RETAILER PRICE	
				} else {
			       final_rt_price=Integer.parseInt(countryArray[cac][5]); //FINAL RETAILER PRICE 
				}  
		    } 		      
		    //77777777CHECK RETAILER_PRICE是否已存在且價格一致,若價格已變動則重新寫入之77777777777
			subSql="select RPMVER,RPPRI from PSALES_RETAILER_PRICE"; 		 	
	        subWhere=" where RPCURR='"+baseCurr+"' and RPREG='"+region+"' and RPCOUN="+country+" and RPPRJCD='"+interModel+"' and RPYEAR='"+dateBean.getYearString()+"' and RPMONTH='"+dateBean.getMonthString()+"' order by RPMVER DESC"; 
	        subSql=subSql+subWhere;
            subRs=subStmt.executeQuery(subSql);	  			
		    if (subRs.next()) 
    	    {	
			  //如果存在但價格不一致			  
			  if (subRs.getInt("RPPRI")!=final_rt_price)
			  {			   
			    updateRecords++; 
			    String sql="insert into PSALES_RETAILER_PRICE(RPYEAR,RPMONTH,RPREG,RPCOUN,RPPRJCD,RPPRI,RPMVER,RPLUSER,RPCURR) values(?,?,?,?,?,?,?,?,?)";
                PreparedStatement pstmt=con.prepareStatement(sql);              
                pstmt.setString(1,dateBean.getYearString());  
                pstmt.setString(2,dateBean.getMonthString());
                pstmt.setString(3,region);
                pstmt.setString(4,country);
                pstmt.setString(5,interModel); //MODEL                		   			 
	            pstmt.setInt(6,final_rt_price); //FINAL RETAILER PRICE		            	      
			    pstmt.setString(7,thisDateBean.getYearMonthDay()+thisDateBean.getHourMinute());
                pstmt.setString(8,"WSADMIN");
		        pstmt.setString(9,baseCurr);
			
			    pstmt.executeUpdate();
			    pstmt.close(); 		 			 			
			  }//end of 價格不一 if	
			} else {   //如果不存在			
			  newRecords++;  	    
	          String sql="insert into PSALES_RETAILER_PRICE(RPYEAR,RPMONTH,RPREG,RPCOUN,RPPRJCD,RPPRI,RPMVER,RPLUSER,RPCURR) values(?,?,?,?,?,?,?,?,?)";
              PreparedStatement pstmt=con.prepareStatement(sql);              
              pstmt.setString(1,dateBean.getYearString());  
              pstmt.setString(2,dateBean.getMonthString());
              pstmt.setString(3,region);
              pstmt.setString(4,country);
              pstmt.setString(5,interModel); //MODEL                		   			 
	          pstmt.setInt(6,final_rt_price); //FINAL RETAILER PRICE	      			  			          
			  pstmt.setString(7,thisDateBean.getYearMonthDay()+thisDateBean.getHourMinute());
              pstmt.setString(8,"WSADMIN");
		      pstmt.setString(9,baseCurr);
			
			  pstmt.executeUpdate();
			  pstmt.close(); 			  
	        } //END OF 檢查正式零售價是否已存在且價格相同 IF 	
			countryArray[cac][5]=String.valueOf(final_rt_price); //設當月值做為下一個月之計算用
	        subRs.close(); 
			//7777777777777777777777777777 	 			
			
			//8888888888888888 CHECK BPCS中之RETAILER_PRICE是否已存在且價格一致,若價格已變動則重新寫入之888888888
			if (country.equals("886")) //只有當國內內銷才需寫入
			{
				int comparePrice=0;
				if (isExistRtPrice.equals("Y") )//若存在輸入之實際零售價
				{
				  comparePrice=local_rt_price;			  
				} else {
				  comparePrice=Math.round(vatAdj*final_rt_price*Float.parseFloat(countryArray[cac][6]));
				}			
				subSql="select PVER,PFCT from TESP"; 		 	
				subWhere=" where trim(PCURR)='"+countryArray[cac][1]+"' and PCOMP="+country+" and trim(PRKEY)='"+interModel+"' and PSDTE="+dateBean.getYearString()+dateBean.getMonthString()+" order by PVER DESC"; 
				subSql=subSql+subWhere;
				bpcsSubRs=bpcsSubStmt.executeQuery(subSql);	  						  			
				if (bpcsSubRs.next()) 
				{	
				  //如果存在但價格不一致			  	  
				  if (bpcsSubRs.getInt("PFCT")!=comparePrice)
				  {			    
					updateBPCSRecords++;
					System.err.println("重覆 BPCS:country="+countryArray[cac][0]+";MODEL="+interModel+";Year="+dateBean.getYearString()+";Month="+dateBean.getMonthString()+";RETAILER price="+final_rt_price);
					String sql="insert into TESP(spid,prkey,pqty,pfct,psdte,pver,pcurr,pcomp,spendt,spentm,spenus,serialcolumn) values(?,?,?,?,?,?,?,?,?,?,?,?)";
					//PreparedStatement pstmt=bpcscon.prepareStatement(sql); 
					PreparedStatement pstmt=ifxTestCon.prepareStatement(sql);     
					pstmt.setString(1,"SP"); 
					pstmt.setString(2,interModel); //MODEL   
					pstmt.setFloat(3,1); //QTY
					pstmt.setFloat(4,comparePrice); //FINAL RETAILER PRICE	
					pstmt.setString(5,dateBean.getYearString()+dateBean.getMonthString()); 
					pstmt.setString(6,thisDateBean.getYearMonthDay()+thisDateBean.getHourMinute()); 	
					pstmt.setString(7,countryArray[cac][1]); 
					pstmt.setString(8,country);
					pstmt.setString(9,thisDateBean.getYearMonthDay()); 
					pstmt.setString(10,thisDateBean.getHourMinute()); 
					pstmt.setString(11,"WSADMIN");				
					pstmt.setInt(12,0);                     
				
					pstmt.executeUpdate();
					pstmt.close(); 		 			 			
				  }//end of 價格不一 if	
				} else {   //如果不存在
				  newBPCSRecords++; 	         
				  System.err.println("BPCS: NEVER EXIST##country="+countryArray[cac][0]+";MODEL="+interModel+";Year="+dateBean.getYearString()+";Month="+dateBean.getMonthString()+";RETAILER price="+(final_rt_price*Float.parseFloat(countryArray[cac][6])));
				  String sql="insert into TESP(spid,prkey,pqty,pfct,psdte,pver,pcurr,pcomp,spendt,spentm,spenus,serialcolumn) values(?,?,?,?,?,?,?,?,?,?,?,?)";
				  //PreparedStatement pstmt=bpcscon.prepareStatement(sql);
				  PreparedStatement pstmt=ifxTestCon.prepareStatement(sql);     
				  pstmt.setString(1,"SP"); 
				  pstmt.setString(2,interModel); //MODEL   
				  pstmt.setFloat(3,1); //QTY
				  pstmt.setFloat(4,comparePrice); //FINAL RETAILER PRICE	
				  pstmt.setString(5,dateBean.getYearString()+dateBean.getMonthString()); 
				  pstmt.setString(6,thisDateBean.getYearMonthDay()+thisDateBean.getHourMinute()); 	
				  pstmt.setString(7,countryArray[cac][1]); 
				  pstmt.setString(8,country);
				  pstmt.setString(9,thisDateBean.getYearMonthDay()); 
				  pstmt.setString(10,thisDateBean.getHourMinute()); 
				  pstmt.setString(11,"WSADMIN");			 
				  pstmt.setInt(12,0);                     
				
				  pstmt.executeUpdate();
				  pstmt.close(); 		 			 						 
				} //END OF 檢查BPCS正式零售價是否已存在且價格相同 IF	
				bpcsSubRs.close(); 
			 } //end of if<=(country.equals('886')) //只有當國內內銷才需寫入	
	  	    //88888888888888888888888888888888888888888888888888 								 		    
	      }	//END OF 零售價>0      							 	  		  
	   } //end of countryArray for		
	   dateBean.setAdjMonth(1); //往後加一個月
	} //end of 計算18個月      
    
  } //end of rs.next While   
  rs.close();   
  subStmt.close();
  bpcsSubStmt.close();
  statement.close();  
  
  //to send mail to Administrator
  sendMailBean.setMailHost(mailHost);
  sendMailBean.setReception("roger_chang@dbtel.com.tw");
  sendMailBean.setFrom("WSADMIN");     	 	 
  sendMailBean.setSubject("Daily Retailer Price Calculation");	 
  sendMailBean.setBody("New Records:"+newRecords+" has been added. \n Old records:"+updateRecords+" had been updated. \n New BPCS Records:"+newBPCSRecords+" has been added. \n Old BPCS records:"+updateBPCSRecords+" had been updated.");	
  sendMailBean.sendMail();  
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbglobalPage.jsp"%>
<!--%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>-->
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
  sendMailBean.setSubject("ERROR:Daily Retailer Price Calculation");	 
  sendMailBean.setBody("Exception:"+e.getMessage());	
  sendMailBean.sendMail();  
}   
%>    
</body>
</html>
