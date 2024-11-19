<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="DateBean,WorkingDateBean,WriteLogToFileBean"%>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnILNAssistPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<html>
<head>
<title>ILNAssistEmployeeShow.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<body>

<FORM ACTION="../jsp/EmployeeDel.jsp" METHOD="POST" NAME="MYFORM" onSubmit="return NeedConfirm()">
<strong><font color="#0080C0" size="5">所有人員記錄</font></strong> 
<%
  String patchDate = "";
  Statement statement=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);    
  ResultSet rs=null;
%>
<BR> 

<% out.println("Step1");

  //workingDateBean.setAdjDay(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  patchDate = workingDateBean.getYearString()+"/"+workingDateBean.getMonthString()+"/"+workingDateBean.getDayString();  // 取得更新日期
  out.println("patchDate="+patchDate);  
  try
  {  
        
     out.println("Step2");
     String sSql=""; 
	 
	//  out.println("<table>");
	  
	  //sSql="select b.EMPLOYNO, b.CNAME, b.DEPT, b.WORKTYPE, c.STDWORKTIME, a.IDNO, a.READCARDNUM, a.RECNUM "+
	  sSql="select a.READCARDNUM, a.READCARDNUM, a.RECNUM, a.IDNO, b.EMPLOYNO, b.CNAME, b.DEPT, b.WORKTYPE, c.STDWORKTIME "+
	       "from CARDDATA a, PERSON b, WORKTYPE c "+
           "where a.IDNO = b.DILIGENCENO and b.WORKTYPE = c.WORKTYPE "+
           // "and b.EMPLOYNO = 'AG000019' "+
           // "and a.READCARDDATE = '"+patchDate+"' "+
		   "and a.READCARDDATE = '2005/10/26' "+
		   "order by b.DEPT, b.EMPLOYNO"; 
	  
	  //sSql="select a.IDNO, a.EMPLOYNO, a.WORKTYPE, a.READCARDNUM, a.RECNUM "+
	 //      "from CARDDATA a "+
     //      "where a.READCARDDATE = '"+patchDate+"' "; 
	 writeLogToFileBean.setTextString("卡號"+"  "+"讀卡次數"+"  "+"ID編號  "+"  "+"員工工號"+"  "+"中文姓名"+"  "+"部門"+"  "+"班別"+"  "+"工作時間"+"\n");
	 System.out.println(writeLogToFileBean.getTextString()); 
	 writeLogToFileBean.setTextString("===="+"  "+"========"+"  "+"========"+"  "+"========"+"  "+"========"+"  "+"===="+"  "+"===="+"  "+"========"+"\n");
	 System.out.println(writeLogToFileBean.getTextString()); 
	  out.println(sSql); 
	  rs=statement.executeQuery(sSql);
	  while (rs.next())
      {
	   //out.println("<tr>");
	   /*
	   out.println("<td>"+rs.getString("EMPLOYNO")+"</td><td>"+rs.getString("CNAME")+
	               rs.getString("DEPT")+"</td><td>"+rs.getString("WORKTYPE")+"</td><td>"+
				   rs.getString("STDWORKTIME")+"</td><td>"+rs.getString("READCARDNUM")+"</td><td>"+rs.getString("RECNUM")+"</td>");
	  */
	  // out.println("<td>"+rs.getString("IDNO")+"</td><td>"+rs.getString("EMPLOYNO")+rs.getString("WORKTYPE")+"</td><td>"+
				//   "</td><td>"+rs.getString("READCARDNUM")+"</td><td>"+rs.getString("RECNUM")+"</td><td>");			   
	  // out.println("</tr>");
	   
	   String readCardNum = rs.getString("READCARDNUM");
	   String recNum = rs.getString("RECNUM");
	   String idNo = rs.getString("IDNO");
	   String employNo = rs.getString("EMPLOYNO");
	   String cName = rs.getString("CNAME");
	   String dept = rs.getString("DEPT");
	   String workType = rs.getString("WORKTYPE");	   
	   String stdWorkTime = rs.getString("STDWORKTIME");
	   
	   //out.println(rs.getString("IDNO"));
	   
	   // String sSqPostN="update CARDDATA set EMPLOYNO=(select DISTINCT b.EMPLOYNO from PERSON b where b.DILIGENCENO= '"+idNo+"' ), "+
		//                "CNAME=(select DISTINCT c.CNAME from PERSON c where c.DILIGENCENO= '"+idNo+"' ) , "+
						//"WORKTYPE=(select DISTINCT d.WORKTYPE from PERSON d where d.DILIGENCENO= '"+idNo+"' ) "+
						
		String sSqPostN="update CARDDATA set EMPLOYNO='"+employNo+"',CNAME='"+cName+"', DEPT='"+dept+"',WORKTYPE='"+workType+"', STDWORKTIME='"+stdWorkTime+"' "+
		                "where IDNO = '"+idNo+"' "+
						//"and READCARDDATE='"+patchDate+"' "+
						"and READCARDDATE='2005/10/26' "+
						"and READCARDNUM = '"+readCardNum+"' and RECNUM = '"+recNum+"' ";   
        //out.println("sSqPostN="+sSqPostN);
		//Statement stmtPostN=ilnAsistcon.createStatement();
        PreparedStatement stmtPostN=ilnAsistcon.prepareStatement(sSqPostN); 
        //stmtPostN.setString(1,rs.getString("EMPLOYNO")); 
		//stmtPostN.setString(2,rs.getString("CNAME")); 
		//stmtPostN.setString(3,rs.getString("DEPT")); 
		//stmtPostN.setString(4,rs.getString("WORKTYPE")); 
		//stmtPostN.setString(5,rs.getString("STDWORKTYPE"));     
        stmtPostN.executeUpdate();		
        stmtPostN.close(); 
		// 開始寫至 Log File 每次更新記錄
		writeLogToFileBean.setTextString(readCardNum+"    "+recNum+"      "+idNo+"  "+employNo+"  "+cName+"  "+dept+"  "+workType+"  "+stdWorkTime+"\n");
		System.out.println(writeLogToFileBean.getTextString());	
	   
	   /*
	  try
      { 
	    Statement statePostN=ilnAsistcon.createStatement(); 
	    sSql="select READCARDNUM from CARDDATA a "+
             "where a.READCARDDATE = '"+patchDate+"' and EMPLOYNO  = 'AG000019' order by EMPLOYNO "; 
	    out.println(sSql); 
	    ResultSet rsPostN=statement.executeQuery(sSql);
	    if (rsPostN.next())
	    {
	     out.println(rsPostN.getString("READCARDNUM"));
	    }
	    rsPostN.close();
	    statePostN.close();
		
	   } //end of try
       catch (Exception e)
       {
       out.println("Exception:"+e.getMessage());
       }
	  */
	  }            
      rs.close();  
	  statement.close(); 
	  
	  //out.println("</table>");  
	  //out.println("Step3"); 
	  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
   // 設定存檔路徑並存檔
   writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/ILN70Assist/EmployeeDetailFix"+dateBean.getYearMonthDay()+".log");
   writeLogToFileBean.StrSaveToFile();
 %>
</FORM>
<% // 日期調整回復
    //workingDateBean.setAdjDay(1); 
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnILNAssistPage.jsp"%>
<!--=================================-->
</html>
