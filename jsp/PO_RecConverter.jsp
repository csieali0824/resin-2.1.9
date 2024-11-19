<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!-- =============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<!-- include file="/jsp/include/ConnBPCSPoolPage.jsp"%>-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title> PO -> Receive Converter </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
</script>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="PO_Ready2RecQueryAll.jsp">待驗收採購通知單(PO)</A><BR> 
<strong><font color="#004080" size="4">PO RECEIVING STATUS</font></strong><BR>
<%@ include file="/jsp/include/TelnetToTPE_BPCS.jsp"%>
<%
if (telnetBean_TPE.getInuse()==false) //如果telnetBean_TPE無人在使用才能進入
{   
   if (telnetBean_TPE.isMonReady==true)  //測試連線是否正常且可以正常使用
   {
		telnetBean_TPE.setOpMan(UserName); 
		telnetBean_TPE.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());
		telnetBean_TPE.setInuse(true); //第一件事即先設定成使用中
		 
		String [] chChoose=request.getParameterValues("CH");//取得前一頁之選擇項目
		String chChooseStr=null;		
		String thisDayString=dateBean.getYearMonthDay();
		String thisTimeString=dateBean.getHourMinute();
		String sSql="";
		//Statement statement=ifxdistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		Statement statement=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		ResultSet rs=null;
		PreparedStatement pstmt=null;
		
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
			 } //end of chChoose for
			 
			   //先將先前轉換收料未成功的資料改回其原狀態
			  sSql="UPDATE PR2PO set READY2REC_FLAG='N',RECEIVED_DATE='',RECEIVED_TIME='' where READY2REC_FLAG='Y' and received_flag!='Y'";
			  pstmt=ifxTestCon.prepareStatement(sSql);          
			  pstmt.executeUpdate(); 	
			  pstmt.close();	  	
			   //-----------------------------------------------------			 
			 
			  //先將選取的資料記錄其預計將收料的FLAG
			  sSql="UPDATE PR2PO set READY2REC_FLAG='Y',RECEIVED_DATE='"+thisDayString+"',RECEIVED_TIME='"+thisTimeString+"' where PO_NO in ("+chChooseStr+")";
			  pstmt=ifxTestCon.prepareStatement(sSql);          
			  pstmt.executeUpdate(); 	
			  pstmt.close();	  	
			   //-----------------------------------------------------		  			    	   			 
			  
			  	//~~~~~~~~~~~~~~~~~~以下為執行telnetBean_TPE傳送shell command~~~~~~~~~~~~~~~~~~~~~~~
				try
				{      
				  telnetBean_TPE.specialRunComnd("/home/pgsrc/cron610/pr2po_rec_test.sh test "+userMail); //因為是執行SMG,故用specialRunComnd				 
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);
					  rs=statement.executeQuery("select unique 'BPCS PO --'||phord||' has been received successfully!' from HPH where phstat=2 and phord in ("+chChooseStr+")");			  
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>120) //若等待時間超過10分鐘則停止作業
					  {	    
						telnetBean_TPE.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線主機異常...請稍後再試!!</font></strong>");
						break; 	    
					  }	else {
						if (rs.next())
						{
						  out.println("<BR>");				  
						  out.println("<strong><font color='BLUE' size=3>"+rs.getString(1)+"</font></strong>");
						  out.println("<BR>");
						  while (rs.next())
						  {
							out.println("<strong><font color='BLUE' size=3>"+rs.getString(1)+"</font></strong>");
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
		telnetBean_TPE.setInuse(false); //設定為離開使用中狀態
   } else {
      out.println("<BR><strong><font color='RED' size=3>連線主機異常...請稍後再試!!</font></strong>");
   } //end of if -> telnetBean_TPE.isMonReady		
} else { 
  out.println("<BR><strong><font color='RED' size=3>連線資料庫忙碌中...請稍後再試!!</font></strong>");
} //end of if -> telnetBean.getInuse()==false	
%>
</FORM>
</body>
</HTML>
<!--=============以下區段為釋放連結池==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>