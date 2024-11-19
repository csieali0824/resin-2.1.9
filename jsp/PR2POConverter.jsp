<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!-- =============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<!-- include file="/jsp/include/ConnBPCSPoolPage.jsp"%>-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<%@ page import="DateBean,RsCountBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title> PR -> PO Converter </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
</script>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A>&nbsp;&nbsp;&nbsp;&nbsp;<BR> 
<strong><font color="#004080" size="4">PR->PO CONVERTING STATUS</font></strong><BR>
<%@ include file="/jsp/include/TelnetToTPE_BPCS.jsp"%>
<%
String PRNO=request.getParameter("PRNO");
String itemTotalStr=request.getParameter("ITEM_TOTAL"); //取得申購項目總數
int itemTotal=Integer.parseInt(itemTotalStr); 
String applyType=request.getParameter("APPLYTYPE");
String applyTypeName=request.getParameter("APPLYTYPENAME");
String applyDate=request.getParameter("APPLYDATE");
String applicant=request.getParameter("APPLICANT");
String vendorNo=request.getParameter("VENDORNO");
String deptNo=request.getParameter("DEPTNO"); //取得部門代碼做為SHIPTO欄位的值

//Statement statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
Statement statement=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet rs=null;
try 
{
  rs=statement.executeQuery("select IPROD from IIM where IPROD='PR-"+applyType+"-999'"); //查詢是否有該申購類別之申購料號
  if (rs.next())  //若該申購類別之申購料號存在才進行以下動作
  {
   String itemCode="PR-"+applyType+"-999"; 
	 if (telnetBean_TPE.getInuse()==false) //如果telnetBean_TPE無人在使用才能進入
		{   
		   if (telnetBean_TPE.isMonReady==true)  //測試連線是否正常且可以正常使用
		   {
				telnetBean_TPE.setOpMan(UserName); 
				telnetBean_TPE.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());
				telnetBean_TPE.setInuse(true); //第一件事即先設定成使用中
				 
				String prLine[]=new String[itemTotal]; 
				String prDesc[]=new String[itemTotal];
				String prQty[]=new String[itemTotal];
				String prPrice[]=new String[itemTotal];
				String prCurr[]=new String[itemTotal];
				String prNeedDate[]=new String[itemTotal];
				
				for (int i=0;i<itemTotal;i++)
				{			 
				  prLine[i]=request.getParameter("LINE-"+i);//取得前一頁之項目
				  prDesc[i]=request.getParameter("DESC-"+i);//取得前一頁之項目
				  prQty[i]=request.getParameter("QTY-"+i);//取得前一頁之項目
				  prPrice[i]=request.getParameter("PRICE-"+i);//取得前一頁之項目
				  prCurr[i]=request.getParameter("CURR-"+i);//取得前一頁之項目
				  prNeedDate[i]=request.getParameter("NEEDDATE-"+i);//取得前一頁之項目
				}	
				
				String thisDayString=dateBean.getYearMonthDay();
				String thisTimeString=dateBean.getHourMinute();
				String sSql="";		
				
				PreparedStatement pstmt=null;				
				try
				{    		 
				  if (itemTotal>0) 
				   {  
				     //-----先刪除資料庫中有先前未轉完成之同號碼的記錄---------
					 sSql="delete from PR2PO where pr_no='"+PRNO+"' and (TRANS_FLAG is null  or TRANS_FLAG!='Y')";
					 //pstmt=bpcscon.prepareStatement(sSql);
					 pstmt=ifxTestCon.prepareStatement(sSql);         
					 pstmt.executeUpdate(); 	
					 pstmt.close();	  	
					 //-----------------------------------------------------				    
					 for (int i=0;i<itemTotal;i++)
					 {				 					   
					   sSql="insert into PR2PO(vendorcode,currency,shiptocode,warehouse,pr_no,pr_line,itemcode,noninventory,itemdescription,duedate,quantity,unitcost,unitofmeasure,trans_date,trans_time,trans_flag,user_mail,pr_applicant,pr_applytype,pr_applytypename,pr_applydate,received_flag,ready2rec_flag,paid_flag)"+
					        " values("+vendorNo+",'"+prCurr[i]+"','"+deptNo+"','99','"+PRNO+"',"+prLine[i]+",'"+itemCode+"','No','"+prDesc[i]+"',"+prNeedDate[i]+","+prQty[i]+","+prPrice[i]+",'EA',"+thisDayString+","+thisTimeString+",'N','"+userMail+"','"+applicant+"','"+applyType+"','"+applyTypeName+"','"+applyDate+"','N','N','N')";
					   //pstmt=bpcscon.prepareStatement(sSql);          
					   pstmt=ifxTestCon.prepareStatement(sSql); 
					   pstmt.executeUpdate(); 	
					   pstmt.close();				   	   
					 } //end of for => itemTotal迴圈
					 
					  //~~~~~~~~~~~~~~~~~~以下為執行telnetBean_TPE傳送shell command~~~~~~~~~~~~~~~~~~~~~~~
					  try
					  {      
						  telnetBean_TPE.specialRunComnd("/home/pgsrc/cron610/pr2po_test.sh test "+userMail); //因為是執行SMG,故用specialRunComnd						
							int cc=0;
							while (true)
							{
							  java.lang.Thread.sleep(5000);
							  rs=statement.executeQuery("select unique 'BPCS PO --'||phord,' NOTES PR --'||phcmt from hph where phcmt='"+PRNO+"'");			  
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
								  out.println("<strong><font color='BLUE' size=3>"+rs.getString(2)+" to "+rs.getString(1)+"</font></strong>");
								  out.println("<BR>");
								  while (rs.next())
								  {
									out.println("<strong><font color='BLUE' size=3>"+rs.getString(2)+" to "+rs.getString(1)+"</font></strong>");
									out.println("<BR>");
								  }
								  java.lang.Thread.sleep(5000);
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
				   } //end of if =>itemTotal>0   
				} //end of try
				catch (Exception e)
				{
				   out.println("Exception:"+e.getMessage());
				}				
				
				telnetBean_TPE.setInuse(false); //設定為離開使用中狀態
		   } else {
			  out.println("<BR><strong><font color='RED' size=3>連線主機異常...請稍後再試!!</font></strong>");
		   } //end of if -> telnetBean_TPE.isMonReady		
		} else { 
		  out.println("<BR><strong><font color='RED' size=3>連線資料庫忙碌中...請稍後再試!!</font></strong>");
		} //end of if -> telnetBean_TPE.getInuse()==false	
  } else {  
    out.println("ERROR:抱歉!目前ERP(BPCS)系統中並無該類別之採購料號,導致無法自動產生採購通知單(PO);請聯絡資訊部人員建立之。");
  }//end of if ->rs.next()若該申購類別之申購料號存在才進行以上動作		
   rs.close();
} //end of main try -
catch (Exception e)
{
   out.println("JSP Exception:"+e.getMessage());
} 
	
statement.close(); 
%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>