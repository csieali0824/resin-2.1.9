<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,DateBean"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean"%>
<html>
<head>
<title>MRQAllStatus.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
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
  location.href="../jsp/LCConfirmShow2.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value  
}

function submitCheck()
{  
   if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm("確定要CANCEL?");      
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
   String EDITION=null;
	 String dateString=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;

  String searchString=request.getParameter("SEARCHSTRING");
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");  
  String repCenterNo="",reccenter=""; 
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

 <%
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

<body><FORM NAME="MYFORM"  onsubmit='return submitCheck()' ACTION="../jsp/LCProcess.jsp?LCSTAT=A&LCRDTE=<%=EDITION%>&LCRCTM=<%=TIME%>" METHOD="post"> 
<strong><font color="#0080C0" size="5">LC確認</font></strong> 
<table width="75%" border="0">
  <tr>
    <td> <input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取">
      &nbsp;<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;</td>
    <td><strong><font color="#400040" size="2">LC NO:</font></strong> 
      <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchRepNo('<%=statusID%>','<%=pageURL%>')" value="<-搜尋"> 
    </td>
  </tr>
</table>
<%    
  try
  {   
  if (searchString!=null){
   Statement statement=ifxshoescon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;


	
	  if (searchString!=null) //如果有搜尋特定單號則另下SQL
	  {
	    sql = "select LPORD,LPLINE,LPPROD,LPQORD,LPECST,LPOCUR,PLCNO from POLC where PLCNO = '"+searchString+"'";	     
      } 		
	  rs=statement.executeQuery(sql);	  
      
	
	
	
	
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
   qryAllChkBoxEditBean.setSearchKey("PLCNO");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(25);
       
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();
   rs.close();
   //取得維修處理狀態  
   }    
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>

  
 <strong><font color='#FF0000'>可執行動作-&gt;</font></strong> 
          <select name="ACTIONID" size="1">
            <option>CONFIRM</option>
          </select>
          <INPUT TYPE='submit' NAME='submit' value='執行'> 
 
  <%
	  /*try
      {       
	   if (statusID.equals("025") || statusID.equals("014") || statusID.equals("024") )
	   {
         Statement statement=ifxshoescon.createStatement();
         ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from RPWORKFLOW x1,RPWFACTION x2 WHERE FORMID='RI' AND FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID");
         comboBoxBean.setRs(rs);
	     comboBoxBean.setFieldName("ACTIONID");	 
		 //out.println("</font></strong></td><TR><TR><td>附註:<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table><BR>");
	     out.println("<strong><font color='#FF0000'>可執行動作-&gt;</font></strong>");
         out.println(comboBoxBean.getRsString());           
	     rs=statement.executeQuery("select COUNT (*) from RPWORKFLOW x1,RPWFACTION x2 WHERE FORMID='RI' AND FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID");
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
       }*/
       %>  
  

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
