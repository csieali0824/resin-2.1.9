<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean"%>
<html>
<head>
<title>INVBatchIssStatus.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function searchRepNo(statusID,pageURL) 
{   
  location.href="../jsp/INVBatchIssStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value  
}

function submitCheck()
{  
   if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm("確定要REJECT?");      
   if (flag==false)  return(false);
  } 

  if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  { 
   alert("請先選擇您欲執行之動作後再存檔!!");   
   return(false);
  }   
   return(true);      
}  
</script>
<%   
  String searchString=request.getParameter("SEARCHSTRING");
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  //String svrTypeNo=request.getParameter("SVRTYPENO");  

  String ISSCENTERNO="";
  String ISSCREATEDATE="";
  String ISSCREATEUSER="";
  
  //String REQREASON_="";
  String WHS="";
  String LOC="";


  int maxrow=0;//查詢資料總筆數 
  //以下為做為換頁之參數url======================
  String firstpageurl="",lastpageurl="",nextpageurl="",prevpageurl="";
   if (searchString!=null) 
   {
     firstpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=FIRST&SEARCHSTRING="+searchString;
	 lastpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=LAST&SEARCHSTRING="+searchString;
	 nextpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=15&SEARCHSTRING="+searchString;
	 prevpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=-15&SEARCHSTRING="+searchString;
   } else {
     firstpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=FIRST";
	 lastpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=LAST";
	 nextpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=15";
	 prevpageurl="STATUSID="+statusID+"&PAGEURL="+pageURL+"&SCROLLROW=-15";	  
   }
  //===============================
 //out.println("Step0");   
 
try
{  //out.println("Step1"); 
   Statement statement=con.createStatement();
   ResultSet  rs=statement.executeQuery("select STATUSDESC,STATUSNAME from WSWFSTATUS where STATUSID='"+statusID+"'");
   String sql=null;
   rs.next();
   statusDesc=rs.getString("STATUSDESC");
   statusName=rs.getString("STATUSNAME");      
   rs.close();  
   
   //out.println(statusDesc);
  
   //取得資料總筆數  
    if (UserRoles.indexOf("Admin")>=0 ) //若角色為Admin可看到所有人的資料
	{ //out.println("Step2");
	  if (searchString!=null) //如果有搜尋特定單號則另下SQL
	  {
	    sql = "select count(*) from INV_M_ISS where  ISSSTATID='"+statusID+"' and (ISSCREATENO like '"+searchString+"%')";	
	  } 
	  else 
	  {
	    sql = "select count(*) from INV_M_ISS where  ISSSTATID='"+statusID+"'";
	  }	
 	  rs=statement.executeQuery(sql);	 
    } 
	else 
	{	//out.println("Step3");
	   if (statusID.equals("011")) //為批次領料單倉管確認中,可看到其所管轄倉庫之所有批次領用申請案件
  	   { //out.println("Step4");
	     if (searchString!=null) //如果有搜尋特定單號則另下SQL
	     {
	       sql = "select count(*) from INV_M_ISS where  ISSSTATID='"+statusID+"' and ISSCENTERNO='"+userActCenterNo+"' and (ISSCREATENO like '"+searchString+"%')";	
	     } 
		 else 
		 {
	       sql = "select count(*) from INV_M_ISS where  ISSSTATID='"+statusID+"' and ISSCENTERNO='"+userActCenterNo+"'";
	     }	
 	     rs=statement.executeQuery(sql);	 
       }
	}	  //out.println("Step8");    
   rs.next();   
   maxrow=rs.getInt(1);
   //out.println("Step9"); 
   statement.close();
   rs.close();
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
} 
%>
<%
String scrollRow=request.getParameter("SCROLLROW");       
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-25;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow)-1;
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/25+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/26+1;  
  } else {
    currentPageNumber=rowNumber/25+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>
<body><FORM NAME="MYFORM"  onsubmit='return submitCheck()' ACTION="../jsp/INVProcess.jsp?FORMID=RD&FROMSTATUSID=<%=statusID%>" METHOD="post"> 
<strong><font color="#0080C0" size="5">批次領料案件處理</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;狀態:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2>(總共<%=maxrow%>筆記錄)</FONT>
<table width="75%" border="0">
  <tr>
    <td> <!--input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取"-->
      &nbsp;<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;</td>
    <td><strong><font color="#400040" size="2">領料單號:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchRepNo('<%=statusID%>','<%=pageURL%>')" value="<-搜尋"> 
    </td>
  </tr>
</table>
<A HREF="../jsp/INVIssStatus.jsp?<%=firstpageurl%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp<A HREF="../jsp/INVIssStatus.jsp?<%=lastpageurl%>"><font size="2"><strong><font color="#FF0080">最後一頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;<A HREF="../jsp/INVIssStatus.jsp?<%=nextpageurl%>">下一頁</A>&nbsp;&nbsp;<A HREF="../jsp/INVIssStatus.jsp?<%=prevpageurl%>">上一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>頁/共<%=totalPageNumber%>頁)</font></strong></font> 
<%    
  try
  {   
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;

    if (UserRoles.indexOf("Admin")>=0 ) //若角色為Admin可看到所有人建的資料
	{ 
	  if (searchString!=null) //如果有搜尋特定單號則另下SQL
	  {
	    sql = "select ISSCREATENO,ISSCENTERNO,ISSCREATEDATE,ISSCREATEUSER,ISSSTATID,ISSSTAT from INV_M_ISS where ISSSTATID='"+statusID+"' and (ISSCREATENO like '"+searchString+"%') order by ISSCREATENO";	     
      } 
	  else 
	  {
	    sql = "select ISSCREATENO,ISSCENTERNO,ISSCREATEDATE,ISSCREATEUSER,ISSSTATID,ISSSTAT from INV_M_ISS where ISSSTATID='"+statusID+"' order by ISSCREATENO";
	  }		
	  rs=statement.executeQuery(sql);	  
    } 
	else 
	{
	   if (statusID.equals("011")) //為批次領料單倉管確認中,可看到其所管轄倉庫之所有批次領料申請案件
	   { 
	     if (searchString!=null) //如果有搜尋特定單號則另下SQL
	     {
	       sql = "select ISSCREATENO,ISSCENTERNO,ISSCREATEDATE,ISSCREATEUSER,ISSSTATID,ISSSTAT from INV_M_ISS where ISSSTATID='"+statusID+"' and ISSCENTERNO='"+userActCenterNo+"' and (ISSCREATENO like '"+searchString+"%') order by ISSCREATENO";	     
         } 
		 else 
		 {
	       sql = "select ISSCREATENO,ISSCENTERNO,ISSCREATEDATE,ISSCREATEUSER,ISSSTATID,ISSSTAT from INV_M_ISS where ISSSTATID='"+statusID+"' and ISSCENTERNO='"+userActCenterNo+"' order by ISSCREATENO";
	     }		
	     rs=statement.executeQuery(sql);	    	  
	   }      
	}		
	//out.println(sql);
/////////////////////////////////////////////////////////
   if (rowNumber==1 || rowNumber<0)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else { 
      if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  {
        rs.absolute(rowNumber); //移至指定資料列	 
	  }	
   }
   	
   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setSearchKey("ISSCREATENO");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(25);
       
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();
   rs.close();
   //取得維修處理狀態      
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %> 
      <!--%
	  try
      {       
	   if (statusID.equals("011"))
	   {
         Statement statement=con.createStatement();
         ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from WSWORKFLOW x1,WSWFACTION x2 WHERE FORMID='RD' AND FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID");
         comboBoxBean.setRs(rs);
	     comboBoxBean.setFieldName("ACTIONID");	 
		 //out.println("</font></strong></td><TR><TR><td>附註:<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table><BR>");
	     out.println("<strong><font color='#FF0000'>可執行動作-&gt;</font></strong>");
         out.println(comboBoxBean.getRsString());           
	     rs=statement.executeQuery("select COUNT (*) from WSWORKFLOW x1,WSWFACTION x2 WHERE FORMID='RD' AND FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID");
	     rs.next();
	     if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	     {	      
           out.println("<INPUT TYPE='submit' NAME='submit' value='執行'>");
		   //out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>e-Mail通知");
	     } 
		 
		 statement.close();
         rs.close();       
		} //end of if 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
 %-->  
<BR>
    <!-- 表單參數 -->  
    
    <input name="STATUSID" type="HIDDEN" value="<%=statusID %>">
	<input name="ISSCENTERNO" type="HIDDEN" value="<%= ISSCENTERNO %>" >
	<input name="ISSCREATEDATE" type="HIDDEN" value="<%= ISSCREATEDATE %>" >    
	<input name="ISSCREATEUSER" type="HIDDEN" value="<%= ISSCREATEUSER %>" >  
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
