<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ page import="DateBean,RsCountBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title> PO -> CO Converter </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
</script>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="PO_To_CO_ConvertQueryAll(TPE).jsp">台北PO轉上海CO</A><BR> 
<strong><font color="#004080" size="4">PO->CO CONVERTING STATUS</font></strong><BR>
<%@ include file="/jsp/include/TelnetToSH_BPCS.jsp"%>
<%
if (telnetBean.getInuse()==false) //如果telnetBean無人在使用才能進入
{   
   if (telnetBean.isMonReady==true)  //測試連線是否正常且可以正常使用
   {
		telnetBean.setOpMan(UserName); 
		telnetBean.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());
		telnetBean.setInuse(true); //第一件事即先設定成使用中
		 
		String [] chChoose=request.getParameterValues("CH");//取得前一頁之選擇項目
		String chChooseStr=null;
		int maxrow=0;
		String thisDayString=dateBean.getYearMonthDay();
		String thisTimeString=dateBean.getHourMinute();
		String sSql="";
		Statement statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		ResultSet rs=null;
		PreparedStatement pstmt=null;
		String prodType="",orderClass="",whse="",fac="",partClass="";
		try
		{    		 
		  if (chChoose!=null) 
		   {   
			 for (int i=0;i<chChoose.length;i++)
			 {
			   if (chChooseStr==null)
			   {
			     chChooseStr=chChoose[i];
			   } else {
			     chChooseStr=chChooseStr+","+chChoose[i];
			   }
			 
			   //先刪除資料庫中有先前未轉完成之同號碼的記錄
			   sSql="delete from TPPO2SHCO where pord="+chChoose[i]+" and trans_flag!='Y'";
			   pstmt=bpcscon.prepareStatement(sSql);          
			   pstmt.executeUpdate(); 	
			   pstmt.close();	  	
			   //-----------------------------------------------------
			 
			   prodType="";orderClass="";whse="";fac="";partClass="";
			   prodType=request.getParameter(chChoose[i]+"-PROD"); //取得前一頁之內容
			   partClass=request.getParameter(chChoose[i]+"-CLASS");	   
			   switch (partClass.charAt(0))
			   {
				 case 'F':
					orderClass="4";
					if (prodType.equals("VOIP")) {whse="C9";fac="CP"; } else { whse="G9";fac="GS";  }
					break;  
				 case 'C':
					orderClass="102";
					if (prodType.equals("VOIP")) {whse="C1";fac="CP";  } else {whse="G1";fac="GS";}
					break;	 
				 case 'A':				    
					orderClass="102"; //因為DBHOLDING沒有104這個CLASS,故以102代替
					if (prodType.equals("VOIP")) {whse="CS";fac="CP";  } else {whse="GS";fac="GS";}					
					break;		
			   } //END OF SWITCH->partClass	   
			   
			   sSql="insert into TPPO2SHCO(pord,co_customer,pwhse,fin_reasoncde,pocur,co_ordercls,pofac,pprod,pqord,pline,pddte,prod_type,"+
					"co_unitprice,trans_date,trans_time,trans_flag,user_mail)"+
					" select pord,'240014','"+whse+"','BILNG',pocur,"+orderClass+",'"+fac+"',pprod,pqord,pline,pddte,'"+prodType+"',pecst,'"+thisDayString+"','"+thisTimeString+"','N','"+userMail+"' from HPO"+
					" where PORD="+chChoose[i];
			   pstmt=bpcscon.prepareStatement(sSql);          
			   pstmt.executeUpdate(); 	
			   pstmt.close();				   	   
			 } //end of chChoose for
			 
			 //~~~~~~~~~~~~~~~~~~以下為執行telnetBean傳送shell command~~~~~~~~~~~~~~~~~~~~~~~
				try
				{      
				  telnetBean.specialRunComnd("/home/pgsrc/cron610/tppo2shco_test.sh test "+userMail); //因為是執行SMG,故用specialRunComnd
				  //telnetBean.specialRunComnd("/home/pgsrc/cron610/tppo2shco_all.sh dbexp "+userMail); //因為是執行SMG,故用specialRunComnd
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);
					  rs=statement.executeQuery("select unique 'Shanghai CO --'||sh_co,' Taipei PO --'||pord from TPPO2SHCO where PORD in ("+chChooseStr+") and trans_flag='Y'");			  
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>120) //若等待時間超過10分鐘則停止作業
					  {	    
						telnetBean.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線上海主機異常...請稍後再試!!</font></strong>");
						break; 	    
					  }	else {
						if (rs.next())
						{
						  out.println("<BR>");				  
						  out.println("<strong><font color='BLUE' size=3>"+rs.getString(2)+" to "+rs.getString(1)+"</font></strong>");
						  out.println("<BR>");
						  while (rs.next())
						  {
							out.println("<strong><font color='BLUE' size=3>"+rs.getString(2)+" to "+rs.getString(1)+"</font></strong>");
							out.println("<BR>");
						  }
						  break;
						} 	  
					  }
					  cc++;
					  rs.close();  
					} //enf of while -> 等待迴圈	  
				  
				} //end of try
				catch (Exception e)
				{
				 out.println("JSP Exception:"+e.getMessage());
				}
				//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 	   
		   } //end of chChoose array if null   
		} //end of try
		catch (Exception e)
		{
		   out.println("Exception:"+e.getMessage());
		}		
		
		statement.close(); 
		telnetBean.setInuse(false); //設定為離開使用中狀態
   } else {
      out.println("<BR><strong><font color='RED' size=3>連線上海主機異常...請稍後再試!!</font></strong>");
   } //end of if -> telnetBean.isMonReady		
} else { 
  out.println("<BR><strong><font color='RED' size=3>連線上海資料庫忙碌中...請稍後再試!!</font></strong>");
} //end of if -> telnetBean.getInuse()==false	
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>