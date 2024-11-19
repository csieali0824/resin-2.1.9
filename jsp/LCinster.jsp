<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,DateBean" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title>LCinster.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<body>
 <A HREF="/wins/WinsMainMenu.jsp">回首頁</A><br>
<%
     String EDITION=null;
	 String dateString=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;

  
  
 try
    {
	Statement statement=ifxshoescon.createStatement();
	
	 dateString=dateBean.getYearMonthDay();
     Month=dateBean.getMonthString();
     Day=dateBean.getDayString();
     Hour=dateBean.getHourMinute();
	 HourSecond=dateBean.getHourMinuteSecond();
	 EDITION=dateString;
	 TIME=HourSecond;
     NEWSID=Month+Day+Hour;
	 //out.print(TIME+"<br>");
	 //out.print(EDITION+"<br>");
	 //out.print(NEWSID);
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }

%>
<%
String [] choice=request.getParameterValues("CH");
String choiceString=null;
String PORD=request.getParameter("PORD");
String LCNO=request.getParameter("LCNO");
float LCAMT=0;
float LCUSAGE=0;
float LCAMTTATLE=0;
float SubTOTAL=0;
float SubLCUSAGETOTAL=0;

float PQORD=0;
float PECST=0;
float HSubTOTAL=0;
float HSubLCUSAGETOTAL=0;
float LCAMTTOTALCHAE=0;
float LCUSAMTSUM=0;
float LPECSTLPQORDTOTAL=0;
float C=0;
float D=0;
float AAA=0;
float BBB=0;
float LCAMTTATLElcusamt=0;
float LCAMTTATLES=0;

//out.print("PORD:"+PORD+"<br>");
//out.print("LCNO:"+LCNO+"<br>");

String PLINE="";
String PPROD="";
String PODESC="";
String POCUR="";

String lpline="";
String lpprod="";
String lpocur="";

try
{  
  Statement statementq=ifxshoescon.createStatement();  
  String sql = "select * from HLCM where LCNO='"+LCNO+"' ";
  ResultSet rsq=statementq.executeQuery(sql);
  if(rsq.next()){
     LCAMT=rsq.getFloat("LCAMT");
	 LCUSAGE=rsq.getFloat("LCUSAGE");
	 LCAMTTATLE=LCAMT-LCUSAGE;
	 //out.print("LCAMTqqqqqq:"+LCAMT+"<br>");
     //out.print("LCUSAGEqqqqqqq:"+LCUSAGE+"<br>");
     //out.print("LCAMTTATLEqqqqqqqq:"+LCAMTTATLE+"<br>");
	 }
	
////////////////////////////////////////////////////////////////////////////////////////	
   Statement statement=ifxshoescon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   String sSql = "select * from POLC where LPORD='"+PORD+"' ";
   //out.println(sSql);
   ResultSet rs=statement.executeQuery(sSql);
if (rs.next())
{//out.println("S1");
  //rs=statement.executeQuery("select LPQORD,LPECST,LCUSAMT from POLC where  LPORD='"+PORD+"'");
  for (int k=0;k<choice.length ;k++)
  {//out.println("S2");
   //if (choiceString==null) 
   //{out.println("S3");
   String sSqls ="select * from POLC where LPORD='"+PORD+"' and LPLINE='"+choice[k]+"'";
   
     rs=statement.executeQuery(sSqls);
	 //out.println(sSqls+"<br>");
	 if (rs.next())
	 {
	   float lpqord=rs.getFloat("LPQORD");
	   float lpecst=rs.getFloat("LPECST");
	   float lcusamt=rs.getFloat("LCUSAMT");
	   lpline=rs.getString("LPLINE");
	   lpprod=rs.getString("LPPROD");
	   lpocur=rs.getString("LPOCUR");
	   //out.print("LPQORD:"+lpqord+"<br>");
	   //out.print("LPECST:"+lpecst+"<br>");
	   //out.print("LCUSAMT:"+lcusamt+"<br>");
	   float TOTAL=lpqord*lpecst;
	   //out.print("TOTAL:"+TOTAL+"<br>");
	   float Chae = TOTAL - lcusamt;
	   //out.print("CHAE:"+Chae+"<br>");
	   SubTOTAL=SubTOTAL+TOTAL;
	   //out.print("SubTOTAL:"+SubTOTAL+"<br>");
	    
		  
	       if( Chae <= LCAMTTATLE ){//現在的餘額<=可用餘額
		      //out.print("a1"+"<br>");
			  
			  if(lcusamt>0){//如果大於0就inster差額,在UPDATE舊的S改成F
              //out.print("a2"+"<br>");
			   out.print("PORD='"+PORD+"'PLINE='"+choice[k]+"'+OK!<br>");
			  String sqlbbb="insert into POLC(LPORD,LPLINE,PLCNO,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPOPRT,LPSTAT,LPRES,LPOENUS,LPOENDT,LPOENTM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	          PreparedStatement pstmt=ifxshoescon.prepareStatement(sqlbbb);
			      pstmt.setString(1,PORD);
	              pstmt.setString(2,lpline);
	              pstmt.setString(3,LCNO);
	              pstmt.setString(4,lpprod);
	              pstmt.setFloat(5,lpqord);
	              pstmt.setFloat(6,lpecst);
	              pstmt.setString(7,lpocur); 
	              pstmt.setFloat(8,Chae);
	              pstmt.setString(9,"Y");
	              pstmt.setString(10,"F");
	              pstmt.setString(11," ");
	              pstmt.setString(12,userID);
				  pstmt.setString(13,EDITION);
				  pstmt.setString(14,TIME);
                  pstmt.executeUpdate(); 
	              pstmt.close();
				  	   String updateChae="UPDATE HLCM SET LCUSAGE='"+Chae+"' WHERE LCNO='"+LCNO+"'";
			           statement.executeUpdate(updateChae);
				  String updateSTAT="UPDATE POLC SET LPSTAT='F' where LPORD='"+PORD+"' and LPLINE='"+choice[k]+"' and LPSTAT='S'";
	              statement.executeUpdate(updateSTAT);//餘額夠的話,把原本不夠的補足S->F
                  } else{//不然的話就直接UPDATE單價*數量的TOTAL
				 // out.print("a3"+"<br>");
				   out.print("PORD='"+PORD+"'PLINE='"+choice[k]+"'+OK!<br>");
				  	   String updateChae2="UPDATE HLCM SET LCUSAGE='"+TOTAL+"' WHERE LCNO='"+LCNO+"'";
			           statement.executeUpdate(updateChae2);
				   String sql_update="UPDATE POLC SET LPSTAT='F',LCUSAMT='"+TOTAL+"',PLCNO='"+LCNO+"' WHERE LPLINE='"+choice[k]+"'";
			       statement.executeUpdate(sql_update);
	               //statement.close();

		           LCAMTTATLE=LCAMTTATLE-TOTAL;
			        //out.print("LCAMTTATLE:"+LCAMTTATLE+"<br>");
			  
			       String updateHPO="UPDATE HPO SET POPTM='1' where PORD='"+PORD+"' and PLINE='"+choice[k]+"'";
	                statement.executeUpdate(updateHPO);//update過的POPTM欄位改為1
				  }
		
			  } else{
			  //out.print("b1"+"<br>");
			                  LCAMTTOTALCHAE=LCAMTTATLE+lcusamt;
							  //out.print("LCAMTTATLE:"+LCAMTTATLE+"<br>");
							  //out.print("LCAMTTOTALCHAE:"+LCAMTTOTALCHAE+"<br>");
			                  if(LCAMTTOTALCHAE>=TOTAL)
							  {//out.print("b2"+"<br>");
							       out.print("PORD='"+PORD+"'PLINE='"+choice[k]+"'+OK!<br>");
							       LCAMTTATLElcusamt=LCAMTTATLE-lcusamt;
							       String sqlB="insert into POLC(LPORD,LPLINE,PLCNO,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPOPRT,LPSTAT,LPRES,LPOENUS,LPOENDT,LPOENTM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	                               PreparedStatement pstmt=ifxshoescon.prepareStatement(sqlB);
			                       pstmt.setString(1,PORD);
	                               pstmt.setString(2,lpline);
	                               pstmt.setString(3,LCNO);
	                               pstmt.setString(4,lpprod);
	                               pstmt.setFloat(5,lpqord);
	                               pstmt.setFloat(6,lpecst);
	                               pstmt.setString(7,lpocur); 
	                               pstmt.setFloat(8,LCAMTTATLElcusamt);
	                               pstmt.setString(9,"Y");
	                               pstmt.setString(10,"F");
	                               pstmt.setString(11," ");
	                               pstmt.setString(12,userID);
				                   pstmt.setString(13,EDITION);
				                   pstmt.setString(14,TIME);
                                   pstmt.executeUpdate(); 
	                               pstmt.close();
								  String updateLCAMTTATLElcusamt="UPDATE HLCM SET LCUSAGE='"+LCAMTTATLElcusamt+"' WHERE LCNO='"+LCNO+"'";
			                      statement.executeUpdate(updateLCAMTTATLElcusamt);
								  
				                   String updateSTAT="UPDATE POLC SET LPSTAT='F' where LPORD='"+PORD+"' and LPLINE='"+choice[k]+"' and LPSTAT='S'";
	                               statement.executeUpdate(updateSTAT);//餘額夠的話,把原本不夠的補足S->F

							  } else {//out.print("b3"+"<br>");
							      String sqlB="insert into POLC(LPORD,LPLINE,PLCNO,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPOPRT,LPSTAT,LPRES,LPOENUS,LPOENDT,LPOENTM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	                              PreparedStatement pstmt=ifxshoescon.prepareStatement(sqlB);
			                      pstmt.setString(1,PORD);
	                              pstmt.setString(2,lpline);
	                              pstmt.setString(3,LCNO);
	                              pstmt.setString(4,lpprod);
	                              pstmt.setFloat(5,lpqord);
	                              pstmt.setFloat(6,lpecst);
	                              pstmt.setString(7,lpocur); 
								  	 String sSqlSUMS ="select SUM(LCUSAMT) LCUSAMTSUM,LPECST*LPQORD LPECSTLPQORDTOTAL from POLC where LPORD='"+PORD+"' and LPLINE='"+choice[k]+"' GROUP BY 2";
                                     rs=statement.executeQuery(sSqlSUMS);
	                                 //out.println(sSqlSUM+"<br>");
	                                 if(rs.next())
	                                 {
									     	  LCUSAMTSUM=rs.getFloat("LCUSAMTSUM");
	                                          LPECSTLPQORDTOTAL=rs.getFloat("LPECSTLPQORDTOTAL");
											  //out.print("LCUSAMTSUM:"+LCUSAMTSUM+"<br>");
	                                          //out.print("LPECSTLPQORDTOTAL:"+LPECSTLPQORDTOTAL+"<br>");
									 }
								      LCUSAMTSUM=LCUSAMTSUM+LCAMTTATLE;
									  //out.print("LCUSAMTSUM2:"+LCUSAMTSUM+"<br>");
									  //out.print("LPECSTLPQORDTOTAL:"+LPECSTLPQORDTOTAL+"<br>");
									  if(LCUSAMTSUM >= LPECSTLPQORDTOTAL)
									  {       //out.print("LCUSAMTSUM >= LPECSTLPQORDTOTAL"+"<br>");
								              C=LCUSAMTSUM-LPECSTLPQORDTOTAL;
											  LCAMTTATLE=LCAMTTATLE-C;
											  //out.print("LCAMTTATLE:"+LCAMTTATLE+"<br>");
									  }
	                              pstmt.setFloat(8,LCAMTTATLE);
	                              pstmt.setString(9,"Y");
	                              pstmt.setString(10,"S");
	                              pstmt.setString(11," ");
	                              pstmt.setString(12,userID);
				                  pstmt.setString(13,EDITION);
				                  pstmt.setString(14,TIME);
                                  pstmt.executeUpdate(); 
	                              pstmt.close();
								      if(LCAMTTATLE>=LCAMT){//判斷LC是否為HZ
								      String updateLCAMTTATLE="UPDATE HLCM SET LCUSAGE='"+LCAMTTATLE+"',LCID='HZ' WHERE LCNO='"+LCNO+"'";
			                          statement.executeUpdate(updateLCAMTTATLE);
								      out.print("<font color=#FF0000>金額不足:</font><br>");
				                      out.print("<font color=#FF0000>PORD='"+PORD+"'PLINE='"+choice[k]+"'</font><br>");
								      } else {
								      String updateLCAMTTATLE2="UPDATE HLCM SET LCUSAGE='"+LCAMTTATLE+"' WHERE LCNO='"+LCNO+"'";
			                          statement.executeUpdate(updateLCAMTTATLE2);
									   out.print("PORD='"+PORD+"'PLINE='"+choice[k]+"'+OK!<br>");
								      }
								  
								     String sSqlSUM ="select SUM(LCUSAMT) AAA,LPECST*LPQORD BBB from POLC where LPORD='"+PORD+"' and LPLINE='"+choice[k]+"' GROUP BY 2";
                                     rs=statement.executeQuery(sSqlSUM);
	                                 //out.println(sSqlSUM+"<br>");
	                                 if(rs.next())
	                                 {
									     	  AAA=rs.getFloat("AAA");
	                                          BBB=rs.getFloat("BBB");
											  //out.print("AAA:"+AAA+"<br>");
	                                          //out.print("BBB:"+BBB+"<br>");
									 }
								      
									  if(AAA >= BBB)
									  {       //out.print("AAA >= BBB"+"<br>");
									      	  String updateSTAT="UPDATE POLC SET LPSTAT='F' where LPORD='"+PORD+"' and LPSTAT='S'";
	                                          statement.executeUpdate(updateSTAT);//餘額夠的話,把原本不夠的補足S->F    
									  }

 
							  }//end of else 
	       
		      LCAMTTATLE=0;
			  
			  String updateHPO="UPDATE HPO SET POPTM='1' where PORD='"+PORD+"' and PLINE='"+choice[k]+"'";
	          statement.executeUpdate(updateHPO);//update過的POPTM欄位改為1
			}
      }//end of if (rs.next())
             choiceString="'"+choice[k]+"'";	  
  } //end of for
  //out.println(choiceString);
  //out.println("S5");  
	
	statement.close();
	rs.close();
}else{//end of if(rs.next)
     Statement statementu=ifxshoescon.createStatement();
	 ResultSet rsu=null;
   for (int k=0;k<choice.length ;k++)
   {//out.println("S22");
    //out.println("PORD:"+PORD);   
     rsu=statementu.executeQuery("select PORD,PLINE,PPROD,PODESC,PQORD,PECST,POCUR from HPO where PORD='"+PORD+"' and PLINE='"+choice[k]+"'");
	 if(rsu.next())//////////////////////////////////////////////////////////////////////
	 {
	    
	   //PORD=rsu.getString("PORD");
	   PLINE=rsu.getString("PLINE");
	   PPROD=rsu.getString("PPROD");
	   //PODESC=rsu.getString("PODESC");
	   PQORD=rsu.getFloat("PQORD");
	   PECST=rsu.getFloat("PECST");
	   POCUR=rsu.getString("POCUR");
	   //out.print("HPO/////////////////////////////////////////////////////////////"+"<br>");
	   //out.print("PORD:"+PORD+"<br>");
	   //out.print("PLINE:"+PLINE+"<br>");
	   //out.print("PPROD:"+PPROD+"<br>");
	   //out.print("PQORD:"+PQORD+"<br>");
	   //out.print("PECST:"+PECST+"<br>");
	   //out.print("POCUR:"+POCUR+"<br>");
	   float HTOTAL=PQORD*PECST;
	   //out.print("HTOTAL:"+HTOTAL+"<br>");
	   
	   HSubTOTAL=HSubTOTAL+HTOTAL;
	   //out.print("HSubTOTAL:"+HSubTOTAL+"<br>");

	   
                  
				  
				  if(HTOTAL <= LCAMTTATLE ){
				  //out.print("ccc"+"<br>");
				  out.print("PORD='"+PORD+"'PLINE='"+choice[k]+"'+OK!<br>");
                  LCAMTTATLE=LCAMTTATLE-HTOTAL;
	              //out.print("LCAMTTATLE:"+LCAMTTATLE+"<br>");
				  
				  String sql1="insert into POLC(LPORD,LPLINE,PLCNO,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPOPRT,LPSTAT,LPRES,LPOENUS,LPOENDT,LPOENTM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	              PreparedStatement pstmt=ifxshoescon.prepareStatement(sql1);
                  pstmt.setString(1,PORD);
	              pstmt.setString(2,PLINE);
	              pstmt.setString(3,LCNO);
	              pstmt.setString(4,PPROD);
	              pstmt.setFloat(5,PQORD);
	              pstmt.setFloat(6,PECST);
	              pstmt.setString(7,POCUR); 
	              pstmt.setFloat(8,HTOTAL);
	              pstmt.setString(9,"Y");
	              pstmt.setString(10,"F");
	              pstmt.setString(11," ");
	              pstmt.setString(12,userID);
				  pstmt.setString(13,EDITION);
				  pstmt.setString(14,TIME);
                  pstmt.executeUpdate(); 
	              pstmt.close();

				  
				  String updateHPO="UPDATE HPO SET POPTM='1' where PORD='"+PORD+"' and PLINE='"+choice[k]+"'";
	              statementu.executeUpdate(updateHPO);//inster過的POPTM欄位改為1
				  
				  /*String updateSTAT="UPDATE POLC SET LPSTAT='F' where LPORD='"+PORD+"' and LPLINE='"+choice[k]+"' and LPSTAT='S'";
	              statementu.executeUpdate(updateSTAT);//餘額夠的話,把原本不夠的補足S->F*/
				  } else {
				  out.print("<font color=#FF0000>金額不足:</font><br>");
				  out.print("<font color=#FF0000>PORD='"+PORD+"'PLINE='"+choice[k]+"'</font><br>");
				  //HSubTOTAL=HSubTOTAL+HTOTAL;
				  
				  String sql2="insert into POLC(LPORD,LPLINE,PLCNO,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPOPRT,LPSTAT,LPRES,LPOENUS,LPOENDT,LPOENTM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				  PreparedStatement pstmt=ifxshoescon.prepareStatement(sql2);
				  pstmt.setString(1,PORD);
	              pstmt.setString(2,PLINE);
	              pstmt.setString(3,LCNO);
	              pstmt.setString(4,PPROD);
	              pstmt.setFloat(5,PQORD);
	              pstmt.setFloat(6,PECST);
	              pstmt.setString(7,POCUR);
	              pstmt.setFloat(8,LCAMTTATLE);
	              pstmt.setString(9,"Y");
	              pstmt.setString(10,"S");
	              pstmt.setString(11," ");
	              pstmt.setString(12,userID);
				  pstmt.setString(13,EDITION);
				  pstmt.setString(14,TIME);
                  pstmt.executeUpdate(); 
	              pstmt.close();
				  LCAMTTATLE=0;
				  
				  
				  String updateHPO="UPDATE HPO SET POPTM='1' where PORD='"+PORD+"' and PLINE='"+choice[k]+"'";
	              statementu.executeUpdate(updateHPO);//inster過的POPTM欄位改為1
				  }
		
	 }//end of if(rsu.next())
    }//end of for
	
	                 /////////未打勾打的inster
				     rsu=statementu.executeQuery("select PORD,PLINE,PPROD,PQORD,PECST,POCUR,POPTM  from HPO where PORD='"+PORD+"' and  POPTM='0'");
	                 while(rsu.next())
	                 {
					   	 PLINE=rsu.getString("PLINE");
	                     PPROD=rsu.getString("PPROD");
	                     PQORD=rsu.getFloat("PQORD");
	                     PECST=rsu.getFloat("PECST");
	                     POCUR=rsu.getString("POCUR");
					     String sql1="insert into POLC(LPORD,LPLINE,PLCNO,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPOPRT,LPSTAT,LPRES,LPOENUS,LPOENDT,LPOENTM) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	                     PreparedStatement pstmt=ifxshoescon.prepareStatement(sql1);
                         pstmt.setString(1,PORD);
	                     pstmt.setString(2,PLINE);
	                     pstmt.setString(3," ");
	                     pstmt.setString(4,PPROD);
	                     pstmt.setFloat(5,PQORD);
	                     pstmt.setFloat(6,PECST);
	                     pstmt.setString(7,POCUR);
	                     pstmt.setFloat(8,0);
	                     pstmt.setString(9,"Y");
	                     pstmt.setString(10,"S");
	                     pstmt.setString(11," ");
	                     pstmt.setString(12,userID);
				         pstmt.setString(13,EDITION);
				         pstmt.setString(14,TIME);
                         pstmt.executeUpdate(); 
	                     pstmt.close();
					 }
	
	
    if(HSubTOTAL>=LCAMT){
	        
	 		String update="UPDATE HLCM SET LCUSAGE='"+LCAMT+"',LCID='HZ' WHERE LCNO='"+LCNO+"'";
			statement.executeUpdate(update);
	} else{
	        HSubLCUSAGETOTAL=HSubTOTAL+LCUSAGE;
	   		String update="UPDATE HLCM SET LCUSAGE='"+HSubLCUSAGETOTAL+"' WHERE LCNO='"+LCNO+"'";
			statement.executeUpdate(update);
	}
	
	 statementu.close();
	 rsu.close();
}//end of else
  
   Statement statementHPH=ifxshoescon.createStatement();
   int maxrow=0;
   String sSqlHPH = "select Count(*) from POLC where LPORD='"+PORD+"' and LPSTAT='S'";
   //out.println(sSql);
   ResultSet rsHPH=statementHPH.executeQuery(sSqlHPH);
   //String HPH="";
   rsHPH.next();   
   maxrow=rsHPH.getInt(1);
  if (maxrow>=1)
  {
     	String updateHPH="UPDATE HPH SET PHLTM='0' WHERE PHORD='"+PORD+"'";
		//out.print("88");
		statementHPH.executeUpdate(updateHPH); 
  
    // HPH =  HPH+","+rsHPH.getString("LPSTAT");
	 //out.print("LCAMT:"+LCAMT+"<br>");
	 /*HPH=rsHPH.getString("LPSTAT");
	 out.print("HPH:"+HPH+"<br>");
	   if(HPH.indexOf("S")>=0){
	 	String updateHPH="UPDATE HPH SET PHLTM='1' WHERE PHORD='"+PORD+"'";
		out.print("88");
		statementHPH.executeUpdate(updateHPH);
	   }*/
  } else {
       	String updateHPH="UPDATE HPH SET PHLTM='1' WHERE PHORD='"+PORD+"'";
		//out.print("88");
		statementHPH.executeUpdate(updateHPH); 
  }
  	 statementHPH.close();
	 rsHPH.close();
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
