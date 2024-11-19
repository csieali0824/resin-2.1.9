<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllRepairBean2" %>
<%@ page import="QryAllChkBoxEditBean" %>
<html>
<head>
<title>LCShow.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
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
function NeedConfirm()
{ 
 flag=confirm("是否確定Create?"); 
 return flag;
}

function searchRepNo(searchString,LCNO,pageURL) 
{   
  location.href="../jsp/LCShow.jsp?searchString="+searchString+"&LCNO="+LCNO+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value 
}
</script>
<body background="../image/b01.jpg" topmargin="0">
<jsp:useBean id="queryAllRepairBean" scope="session" class="QueryAllRepairBean2"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<FORM ACTION="../jsp/LCinster.jsp" METHOD="POST" NAME="MYFORM" onSubmit="return NeedConfirm()">
  &nbsp;&nbsp; <strong></strong> 

  <%   
  int maxrow=0;//查詢資料總筆數 
  String searchString=request.getParameter("SEARCHSTRING");
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");
  String LCNO=request.getParameter("LCNO");
  String PORD=request.getParameter("PORD");
  String LCID="";
  String LCCUR="";
  String LPOCUR="";
  String POCUR="";
  //out.print(searchString);
  float LCAMT = 0;
  float LCUSAGE;
  float LCAMTTATLE;
   //out.print("LCAMT:"+LCAMT);
  String SearchKeyA="";
  
  String scrollRow=request.getParameter("SCROLLROW");  
  int rowNumber=queryAllRepairBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   queryAllRepairBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {
     rowNumber=-1;	 
   } else {
     rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     queryAllRepairBean.setRowNumber(rowNumber);
   }	 
  }     
  int currentPageNumber=0,totalPageNumber=0;
%>

  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A><BR>
<table width="100%" height="31" border="1" dwcopytype="CopyTableRow">
  <tr>
    <td width="50%"><font size="+2"><strong>DBTEL</strong></font></td>
    <td width="50%"><font size="+2"><strong>L/C Maintenance</strong></font></td>
  </tr>
</table>
<%
 Statement statementq=ifxshoescon.createStatement();  
  String sql = "select * from HLCM where LCNO='"+LCNO+"' ";
  ResultSet rsq=statementq.executeQuery(sql);
  if(rsq.next()){
     LCAMT=rsq.getFloat("LCAMT");
	 LCUSAGE=rsq.getFloat("LCUSAGE");
	 LCID=rsq.getString("LCID");
	 LCCUR=rsq.getString("LCCUR");
out.print("<table width=100% height=31 border=1 dwcopytype=CopyTableRow>");
  out.print("<tr>");
    out.print("<td >LCNO:"+LCNO +"</td>");
    out.print("<td >LCAMT:"+LCAMT +"</td>");
    out.print("<td >LCUSAGE:"+LCUSAGE +"</td>");
  out.print("</tr>");
out.print("</table>");
out.print("LCID:"+LCID );
out.print("LCCUR:"+LCCUR );
} 
if(LCID.equals("HZ")){
response.sendRedirect("../jsp/LC.jsp");
}
   statementq.close();
   rsq.close();
%>
 
<table width="75%" border="0">
  <tr>
      <td width="22%"><input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取">
        <INPUT name="submit" TYPE="submit" value="Create"></td>
      <td width="78%"><strong><font color="#400040" size="2">PO NO:</font></strong> 
        <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>> 
      <input name="search" type=button onClick="searchRepNo('<%=searchString%>','<%=LCNO%>','<%=pageURL%>')" value="<-搜尋">
      </td>
  </tr>
</table>

  <input type="hidden" name="PORD" value="<%= searchString %>" >
  <input type="hidden" name="LCNO" value="<%= LCNO %>" >
<% 
  try
  {  
   if (searchString!=null){
  // Statement statement1=ifxshoescon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   Statement statement=ifxshoescon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   String sSql = "select LPORD,LPLINE,LPPROD,LPQORD,LPECST,LPOCUR from POLC where LPSTAT='S' and LPORD='"+searchString+"' ";
   //out.println(sSql);
   ResultSet rs=statement.executeQuery(sSql);
    //ResultSet rs=null;
   if (rs.next())
   { out.println("step1");  
    if (searchString!=null) //如果有搜尋特定單號則另下SQL
	{
       out.println("step2"); 
	   boolean flgeLCCUR=false;
       SearchKeyA="LPLINE";
	   //out.print("key"+SearchKeyA);
	   String SSS="select LPORD,LPLINE,LPPROD,LPQORD,LPECST,LPOCUR from POLC where LPSTAT='S' and LPORD='"+searchString+"'";
       rs=statement.executeQuery(SSS);
	      if(rs.next()){
		     LPOCUR=rs.getString("LPOCUR");
			 //out.print("LPOCUR:"+LPOCUR+"<br>");
			 //out.print("LCCUR:"+LCCUR);
			        if(LPOCUR==LCCUR || LPOCUR.equals(LCCUR)){
					      
                         } else{
						    flgeLCCUR=true;
						   
                             response.sendRedirect("../jsp/LC.jsp?flgeLCCUR="+flgeLCCUR+"");
						 }
		  }	
	   //out.println(SSS);   
     }	   
   } else { //out.println("step2.5"); 
    if (searchString!=null) //如果有搜尋特定單號則另下SQL
     { 	 out.println("step3"); 
	   boolean flgeLCCUR=false;
	   SearchKeyA="PLINE";
	   //out.print("key"+SearchKeyA);
	   rs=statement.executeQuery("select PORD,PLINE,PPROD,PQORD,PECST,POCUR from HPO where PORD = '"+searchString+"' and POPTM='0' and ((PVEND between 85000 and 85999) or (PVEND between 89000 and 89999))");
	   	 if(rs.next()){
		     POCUR=rs.getString("POCUR");
			 			 //out.print("POCUR:"+POCUR+"<br>");
			             //out.print("LCCUR:"+LCCUR);
			             if(POCUR==LCCUR || POCUR.equals(LCCUR)){

                         } else{
						   flgeLCCUR=true;
                           response.sendRedirect("../jsp/LC.jsp?flgeLCCUR="+flgeLCCUR+"");
						 }
		  }
     } //	out.println("step4");   
   }	
   

   if (rowNumber==1)
   {  //out.println("step5");
     rs.beforeFirst(); //移至第一筆資料列 
	 //out.println("step6"); 
   } else {
     if (rowNumber==-1)
	 {
	   rs.absolute(-30);
	 } else {
      rs.absolute(rowNumber); //移至指定資料列
	 }
   }
  //out.println("step7");    
  /* queryAllRepairBean.setPageURL("../jsp/BBB.jsp");//小圖示連結到修改的網頁  
   queryAllRepairBean.setSearchKey("USERID");//傳到下一個網頁以那一個變數為主
   queryAllRepairBean.setRs(rs);
   queryAllRepairBean.setScrollRowNumber(30);
   out.println(queryAllRepairBean.getRsString());*/
   //另外一種呈現方式 ,沒有checkbox的
   
   qryAllChkBoxEditBean.setPageURL("../jsp/PONoEdit.jsp?LPORD="+searchString+"&");//小圖示連結到修改的網頁?flgeLCCUR="+flgeLCCUR+"
   //qryAllChkBoxEditBean.setPageURL2("../jsp/LCorderEdit.jsp");
   qryAllChkBoxEditBean.setHeaderArray(null);
   String AA[]={"","","PORD","PLINE","PPROD","PQORD","PECST","POCUR"};
   qryAllChkBoxEditBean.setHeaderArray(AA);
   //out.println("step8");
   //String at[]={"PORD","PODESC"};//下一頁直接以String ADDRESS=request.getParameter("ADDRESS");接及可
   //qryAllChkBoxEditBean.setSearchKeyArray(at);//以陣列傳到下一個網頁以那一個變數為主
   qryAllChkBoxEditBean.setSearchKey(SearchKeyA);//out.println("step9");//傳到下一個網頁以那一個變數為主out.println("step6");
   qryAllChkBoxEditBean.setFieldName("CH");//out.println("step10");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");//out.println("step11");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");//out.println("step12");
   qryAllChkBoxEditBean.setRs(rs);//out.println("step13");   
   out.println(qryAllChkBoxEditBean.getRsString());//out.println("step14");

   
   
   statement.close();      
   rs.close();    
   }  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }

 %>


</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
