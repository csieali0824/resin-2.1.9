<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="DateBean,WorkingDateBean,WriteLogToFileBean"%>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnILNAssistPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnTPEAssistPoolPage.jsp"%-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<%
String patchDate=request.getParameter("PATCHDATE"); 
String tableName=request.getParameter("TABLENAME");  // 將更新的 SQL  資料表名稱傳入

if (tableName==null) tableName ="Person";

%>
<html>
<head>
<title>TTNewEmployNoUpdate.jsp</title>
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
     // Step1. 先將 Mapping Table 的資料找出來,以它為更新行政系統的基礎
     Statement statement=con.createStatement();
     ResultSet rs=null;
	  //sSql="select b.EMPLOYNO, b.CNAME, b.DEPT, b.WORKTYPE, c.STDWORKTIME, a.IDNO, a.READCARDNUM, a.RECNUM "+
	 String sSql="select * from TT_NEWEMPLOY_MAP where CNAME != '陳慧玲' ";   	  
	 
	 //tpe70iLncon
	   Statement stateAssist=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); // 正式
	 // Statement stateAssist=tpe70iLncon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); // 測試
	  ResultSet rsAssist=null;
	  
	  rs=statement.executeQuery(sSql);
	  while (rs.next())
      { 
	     String cName = rs.getString("CNAME");
		 String newEmployNo = rs.getString("NEWEMPNO");	
		 String oldEmployNo = rs.getString("OLDEMPNO");  // 取舊的工號
		 	 
	     	   
		   String sSqPostN = null;
		  //                  "update "+tableName+" set EMPLOYNO='"+newEmployNo+"' "+
		  //                   "where EMPLOYNO = '"+oldEmployNo+"' ";
		  
		   if (   tableName.equals("PersonAdjust") || tableName.equals("PersonExper") || tableName.equals("PersonFamily") 
		       || tableName.equals("PersonLeave") || tableName.equals("PersonOvers") || tableName.equals("PersonQuitJob")
			   || tableName.equals("PersonRetainJob") || tableName.equals("PersonSalary") || tableName.equals("PersonSchool")
			   || tableName.equals("PersonTrain") 
		      )
		   {
		     sSqPostN = "update "+tableName+" set EMPLOYNO='"+newEmployNo+"' "+
		                "where EMPLOYNO = '"+oldEmployNo+"' ";
		   } else {
		            sSqPostN = "update "+tableName+" set EMPLOYNO='"+newEmployNo+"' "+
		                       "where CNAME = '"+cName+"' and CNAME != '陳慧玲' ";
		          } 
		    
		  // PreparedStatement stmtPostN=tpe70iLncon.prepareStatement(sSqPostN);	// 更新測試	  
           PreparedStatement stmtPostN=ilnAsistcon.prepareStatement(sSqPostN);  // 更新正式          
           stmtPostN.executeUpdate();		
           stmtPostN.close(); 
		   
	     	
		 
		// 開始寫至 Log File 每次更新記錄
		//writeLogToFileBean.setTextString(readCardNum+"    "+recNum+"      "+idNo+"  "+employNo+"  "+cName+"  "+dept+"  "+workType+"  "+stdWorkTime+"\n");
		//System.out.println(writeLogToFileBean.getTextString());	   
	  }      // End of While      
      rs.close();  
	  statement.close(); 
	  
	  
	  out.println("已完成更新資料表:"+tableName+" 新工號欄位...<BR>");
	 //stateAssist.close();	  
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
<!--%@ include file="/jsp/include/ReleaseConnTPEAssistPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnILNAssistPage.jsp"%>
<!--=================================-->
</html>
