<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="DateBean,WorkingDateBean,WriteLogToFileBean"%>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnILNAssistPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<%
String patchDate=request.getParameter("PATCHDATE"); 

%>
<html>
<head>
<title>TTEmployeeMappingUpdate.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<body>

<FORM ACTION="../jsp/EmployeeDel.jsp" METHOD="POST" NAME="MYFORM" onSubmit="return NeedConfirm()">
<strong><font color="#0080C0" size="5">所有人員記錄</font></strong> 
<%
 
  //Statement statement=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);   
 
%>
<BR> 

<% //out.println("Step1");

  //workingDateBean.setAdjDay(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  if (patchDate==null)
  {
   patchDate = workingDateBean.getYearString()+"/"+workingDateBean.getMonthString()+"/"+workingDateBean.getDayString();  // 取得更新日期
  }
  out.println("patchDate="+patchDate);  
  try
  {  
     Statement statement=con.createStatement();
     ResultSet rs=null;
	  //sSql="select b.EMPLOYNO, b.CNAME, b.DEPT, b.WORKTYPE, c.STDWORKTIME, a.IDNO, a.READCARDNUM, a.RECNUM "+
	 String sSql="select * from TT_NEWEMPLOY_MAP ";         
	  
	 
	// writeLogToFileBean.setTextString("卡號"+"  "+"讀卡次數"+"  "+"ID編號  "+"  "+"員工工號"+"  "+"中文姓名"+"  "+"部門"+"  "+"班別"+"  "+"工作時間"+"\n");
	// System.out.println(writeLogToFileBean.getTextString()); 
	// writeLogToFileBean.setTextString("===="+"  "+"========"+"  "+"========"+"  "+"========"+"  "+"========"+"  "+"===="+"  "+"===="+"  "+"========"+"\n");
	// System.out.println(writeLogToFileBean.getTextString()); 
	 //out.println(sSql); 
	  Statement stateAssist=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	  ResultSet rsAssist=null;
	  
	  rs=statement.executeQuery(sSql);
	  while (rs.next())
      { 
	     String cName = rs.getString("CNAME");
		 
	      
	   
	     String sSqlAssist="select b.EMPLOYNO, b.CNAME, b.DEPT from PERSON b  "+
                           "where b.CNAME = '"+cName+"' "+		  
		                   "order by b.DEPT, b.EMPLOYNO "; 
		 rsAssist=stateAssist.executeQuery(sSqlAssist);	   
	     if (rsAssist.next())
		 {
		   
	       String employNo = rsAssist.getString("EMPLOYNO");	       
	       String dept = rsAssist.getString("DEPT");
		   
		   String sSqPostN="update TT_NEWEMPLOY_MAP set OLDEMPNO='"+employNo+"', OLDDEPT='"+dept+"' "+
		                   "where CNAME = '"+rs.getString("CNAME")+"' ";          
           PreparedStatement stmtPostN=con.prepareStatement(sSqPostN);             
           stmtPostN.executeUpdate();		
           stmtPostN.close(); 
		   
	     }
						
		 
		// 開始寫至 Log File 每次更新記錄
		//writeLogToFileBean.setTextString(readCardNum+"    "+recNum+"      "+idNo+"  "+employNo+"  "+cName+"  "+dept+"  "+workType+"  "+stdWorkTime+"\n");
		//System.out.println(writeLogToFileBean.getTextString());	   
	  }      // End of While      
      rs.close();  
	  statement.close(); 
	  
	   stateAssist.close();
	// rsAssist.close(); 		
	 
	  
	  //out.println("</table>");  
	  //out.println("Step3"); 
	  
  } //end of try
  catch (SQLException e)
  {
   out.println("QQ Exception:"+e.getMessage());
  }
   // 設定存檔路徑並存檔
  // writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/ILN70Assist/EmployeeDetailFix"+dateBean.getYearMonthDay()+".log");
  // writeLogToFileBean.StrSaveToFile();
   
   
   
 %>
</FORM>
<% // 日期調整回復
    //workingDateBean.setAdjDay(1); 
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnILNAssistPage.jsp"%>
<!--=================================-->
</html>
