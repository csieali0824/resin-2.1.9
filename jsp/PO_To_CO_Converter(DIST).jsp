<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
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
<A HREF="/wins/WinsMainMenu.jsp">Home</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="PO_To_CO_ConvertQueryAll(DIST).jsp">安捷立PO轉大霸CO</A><BR> 
<strong><font color="#004080" size="4">安捷立PO->大霸CO CONVERTING STATUS</font></strong><BR>
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
		int maxrow=0;
		String thisDayString=dateBean.getYearMonthDay();
		String thisTimeString=dateBean.getHourMinute();
		String sSql="";
		Statement statement=ifxdistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
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
			   sSql="delete from TPODIST001 where pord="+chChoose[i]+" and TRANS_FLAG!='Y'";
			   pstmt=ifxdistcon.prepareStatement(sSql);          
			   pstmt.executeUpdate(); 	
			   pstmt.close();	  	
			   //-----------------------------------------------------
			 
			   prodType="";orderClass="";whse="";fac="TW";partClass="";
			   prodType=request.getParameter(chChoose[i]+"-PROD"); //取得前一頁之內容
			   partClass=request.getParameter(chChoose[i]+"-CLASS");	   
			   switch (partClass.charAt(0))
			   {
				 case 'F':
					orderClass="4";
					if (prodType.equals("DECT")) {whse="91";} else { whse="52"; }
					break;  
				 case 'C':
					orderClass="102";
					if (prodType.equals("DECT")) {whse="91";} else {whse="01";}
					break;	 
				 case 'A':				    
					orderClass="102"; 
					//因為DECT有104這個OrderClass故下方再另行修改
					if (prodType.equals("DECT")) {whse="91";orderClass="104"; } else {whse="01";}					
					break;		
			   } //END OF SWITCH->partClass	   
			   
			   sSql="insert into TPODIST001(pord,co_customer,pwhse,tpe_co,tpco_line,co_ordercls,fin_reasoncde,"+
                    "pocur,pofac,pprod,pline,pqord,pddte,co_unitprice,trans_date,trans_time,trans_flag,po_scn)"+					
					" select PORD,210040,'"+whse+"',0,0,'"+orderClass+"','BILNG',pocur,'"+fac+"',pprod,pline,pqord,pddte,pecst*1.05,"+thisDayString+","+thisTimeString+",'N',serialcolumn from HPO"+
					" where PORD="+chChoose[i]+" and PID!='PZ'";
			   pstmt=ifxdistcon.prepareStatement(sSql);          
			   pstmt.executeUpdate(); 	
			   pstmt.close();				   	   
			 } //end of chChoose for
			 
			 //~~~~~~~~~~~~~~~~~~以下為執行telnetBean_TPE傳送shell command~~~~~~~~~~~~~~~~~~~~~~~
				try
				{      
				  telnetBean_TPE.specialRunComnd("/home/pgsrc/cron610/tpodist.sh dbtel "+userMail); //因為是執行SMG,故用specialRunComnd				 
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);
					  rs=statement.executeQuery("select unique '大霸CO --'||tpe_co,' 安捷立PO --'||pord from TPODIST001 where PORD in ("+chChooseStr+") and trans_flag='Y'");			  
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>120) //若等待時間超過10分鐘則停止作業
					  {	    
						telnetBean_TPE.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線台北大霸主機異常...請稍後再試!!</font></strong>");
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
		telnetBean_TPE.setInuse(false); //設定為離開使用中狀態
   } else {
      out.println("<BR><strong><font color='RED' size=3>連線台北大霸主機異常...請稍後再試!!</font></strong>");
   } //end of if -> telnetBean_TPE.isMonReady		
} else { 
  out.println("<BR><strong><font color='RED' size=3>連線台北大霸資料庫忙碌中...請稍後再試!!</font></strong>");
} //end of if -> telnetBean.getInuse()==false	
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>