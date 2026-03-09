<%@ page language="java" import="java.sql.*"  %>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="bean.QryAllChkBoxEditBean,bean.ComboBoxBean,bean.ArrayComboBoxBean,bean.DateBean"%>
<html>
<head>
<title>Query All Cancel PR that need to approve </title>
</head>
<%-- �U�誺��ƬO�Ψӱ���O�_�R�����T�{�ʧ@ --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function searchDocNo() 
{   
  location.href="../jsp/WSCancelPRApproveQueryAll.jsp?SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value;
}
function submitCheck()
{  
  if (document.MYFORM.ACTION.value=="--")  //��ܨS�����ʧ@
  {       
   return(false);
  }   
  
  flag=confirm("Submit Confirm with "+document.MYFORM.ACTION.value+"?");  
  if (flag!=true)
  {
   return flag;   
  } 
 
  document.MYFORM.submit();      
}  
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="bean.QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="bean.ArrayComboBoxBean"/>
<%   
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString=""; 
  int maxrow=0;//�d�߸���`���� 
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  ResultSet  rs=null;   
  String sql="";
    
 try
  {         
   if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
   {	
	 sql="select count(*) from PSALES_FORE_APP_HD where STATUS='IN_PROGRESS' and DOCNO like '"+searchString+"%' and TYPE='999'";	
   } else {    
	 sql="select count(*) from PSALES_FORE_APP_HD where STATUS='IN_PROGRESS' and TYPE='999'";	  
   }   
   
   //���o����`����
   if (UserRoles.indexOf("admin")>=0) //�Y��Admin�h�i�ݨ����
   {	    
	  rs=statement.executeQuery(sql);	 
   } else {     
	  rs=statement.executeQuery(sql+" and NEXTPRCSMAN='"+userID+"'");	 	 
   }   
   rs.next();   
   maxrow=rs.getInt(1);    
   
   rs.close();   
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  } 
  
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
	 rowNumber=maxrow-100;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/100+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/101+1;  
  } else {
    currentPageNumber=rowNumber/100+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>
<body>
<FORM NAME="MYFORM" onsubmit='return submitCheck()' ACTION="WSCancelPRBatchProcess.jsp" METHOD="POST"> 
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font></font></font> 
<font color="#000000" size="+2" face="Times New Roman"><strong><font color="#FF0000">Cancel
PR</font></strong></font><strong><font color="#FF0000" size="+2" face="Times New Roman"> Approval </font></strong>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>
&nbsp;&nbsp;&nbsp;&nbsp;Doc No:
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
<input name="search" type=button onClick="searchDocNo()" value='<-search'>
<table width="100%" border="0">
  <tr bgcolor="0099CC">
    <td width="9%">
&nbsp;
<input name="button" type=button onClick="this.value=check(this.form.CH)" value='Select All'></td>
    <td width="25%"><font color="#333399" face="Arial Black">ACTION:</font>
      <%
try
{   
   if (true)
   {      
     String a[]={"AGREE","REJECT"};	
	 arrayComboBoxBean.setArrayString(a);  
   } else {
     String a[]={""};	
	 arrayComboBoxBean.setArrayString(a);
   }         		 
   arrayComboBoxBean.setFieldName("ACTION");	             		    	
   out.println(arrayComboBoxBean.getArrayString());		
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}	
%>
      <input name="Button" type="Button" onClick='submitCheck()' value="Submit"></td>
    <td width="66%" class="style2"><font color="#333399" face="Arial Black"><strong>Comment:</strong></font>
      <input name="COMMENT" type="text" size="40">
    </td>
  </tr>
  <tr>
    <td colspan="3"><%    
 try
  {         
   if (searchString!=null && !searchString.equals("")) //�p�G���j�M�S�w�渹�h�t�USQL
   {	
	 sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSLOCALE,WSUSER where COUNTRY=LOCALE and STATUS='IN_PROGRESS' and NEXTPRCSMAN=WEBID and DOCNO like '"+searchString+"%' and TYPE='999'";	
   } else {    
	 sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSLOCALE,WSUSER where COUNTRY=LOCALE and STATUS='IN_PROGRESS' and NEXTPRCSMAN=WEBID and TYPE='999'";	  
   }    
   
   if (UserRoles.indexOf("admin")>=0) //�Y��Admin�h�i�ݨ����
   {	    
	  rs=statement.executeQuery(sql);	 
   } else {     
	  rs=statement.executeQuery(sql+" and NEXTPRCSMAN='"+userID+"'");	 	 
   }   
   
   if (rowNumber==1 || rowNumber<0)
   {
     rs.beforeFirst(); //���ܲĤ@����ƦC  
   } else { 
      if (rowNumber<=maxrow) //�Y�p���`���Ʈɤ~�~�򴫭�
	  {
        rs.absolute(rowNumber); //���ܫ��w��ƦC	 
	  }	
   }
   
   String a[]={"","","DOC NO","REGION","COUNTRY","STATUS","NEXT PROCESS BY","TARGET DATE"};	
   qryAllChkBoxEditBean.setPageURL("../jsp/WSCancelPRApprove.jsp");
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(a);
   qryAllChkBoxEditBean.setSearchKey("DOCNO");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(100);
       
   out.println(qryAllChkBoxEditBean.getRsString());   
  
   rs.close();  
   //���o���׳B�z���A      
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %></td>
  </tr>
</table>
</FORM>
</body>
<%
 statement.close();
%>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
