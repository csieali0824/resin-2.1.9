<%@ page contentType="text/html" language="java" import="java.sql.*"  %>
<%@ page import="QryAllChkBoxEditBean" %>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>


<script language="JavaScript" type="text/JavaScript">


var checkflag = "false";
function check(field,ms1,ms2) {
	if (checkflag == "false") {
		for (i = 0; i < field.length; i++) {
			field[i].checked = true;
		}
		checkflag = "true";
		return ms1; 
	} else {
		for (i = 0; i < field.length; i++) {
			field[i].checked = false; 
		}
		checkflag = "false";
		return ms2; 
	} // end if-else
}// end function

function NeedConfirm(ms1) { 
	flag=confirm(ms1); 
	return flag;
}

function setSubmit(URL) {   
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></title>
</head>

<body>

<%
	String searchString=request.getParameter("SEARCHSTRING");
	String scrollRow=request.getParameter("SCROLLROW");  
	String where = "";
	if (searchString==null) { searchString =""; }
	if (!searchString.equals("")) {
		where = " AND (upper(rolename) like '%"+searchString.toUpperCase()+"%' or upper(roledesc) like '%"+searchString.toUpperCase()+"%')";
	}
	//out.println(where);


%>
<FORM ACTION="../jsp/MMRoleDel.jsp" METHOD="POST" NAME="MYFORM" onSubmit='return NeedConfirm("<jsp:getProperty name='rPH' property='pgDelete'/>")'>
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></font></strong>
<br><br>
<A HREF="/oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRoleNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></a>
<br><br>

<input name="button" type=button onClick='this.value=check(this.form.CH,"<jsp:getProperty name='rPH' property='pgCancelSelect'/>","<jsp:getProperty name='rPH' property='pgSelectAll'/>")' value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
<INPUT TYPE="submit" value='<jsp:getProperty name="rPH" property="pgDelete"/>'>
<strong><font color="#400040" size="2"><jsp:getProperty name="rPH" property="pgRole"/></font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 value="<%if (searchString!=null) out.println(searchString);%>"> 
<input name="search" type=button onClick="setSubmit('./MMRoleList.jsp')" value='<jsp:getProperty name="rPH" property="pgSearch"/>'>

<%   
	int pageRow = 30;
	int maxrow=0;//查詢資料總筆數 
	int currentPageNumber=0,totalPageNumber=0,rowNumber=0;
  
	try {   
		String sql = "select count(*) from ORADDMAN.WSROLE where ROLENAME is not null "+where;
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		rs.next();   
		maxrow=rs.getInt(1);
		rs.close();
		statement.close();
		out.println("<FONT SIZE='2'>(");
		%><jsp:getProperty name="rPH" property="pgTotal"/><%
		out.println(maxrow);
		%><jsp:getProperty name="rPH" property="pgRecord"/><%
		out.println(")</FONT>");
    
		totalPageNumber=maxrow/pageRow+1;
		rowNumber=qryAllChkBoxEditBean.getRowNumber();
		//out.println("row="+rowNumber);
		if (scrollRow==null || scrollRow.equals("FIRST")) {
		   rowNumber=1;
		   currentPageNumber=1;
		   //out.println("next row1="+rowNumber);
		   qryAllChkBoxEditBean.setRowNumber(rowNumber);
		} else {
			if (scrollRow.equals("LAST")) {
				 if (maxrow>pageRow) {rowNumber=maxrow-pageRow;} else {rowNumber=1;}
				 currentPageNumber=totalPageNumber;
				 //out.println("next row2="+rowNumber);
				 qryAllChkBoxEditBean.setRowNumber(rowNumber);	 
			} else {
				rowNumber=rowNumber+Integer.parseInt(scrollRow);
				if (rowNumber<=0) { rowNumber=1; currentPageNumber=1;
				} else {
					if (rowNumber>=maxrow) {
						if (maxrow>pageRow) {rowNumber=maxrow-pageRow;} else {rowNumber=1;}
						currentPageNumber=totalPageNumber;
					} else {
						currentPageNumber=rowNumber/pageRow+1;				
					}// end if-else
				} // end if-else
				//out.println("next row3="+rowNumber);
				qryAllChkBoxEditBean.setRowNumber(rowNumber);
			} // end if-else
		}  // end if-else
		if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
	
	} //end of try
	catch (Exception e)  {   out.println("Exception:"+e.getMessage());  }   
%>
<br> <!--換行 -->
<A HREF="../jsp/MMRoleList.jsp?SCROLLROW=FIRST&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgFirst"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>

<A HREF="../jsp/MMRoleList.jsp?SCROLLROW=30&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font><jsp:getProperty name="rPH" property="pgNext"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>

<A HREF="../jsp/MMRoleList.jsp?SCROLLROW=-30&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>
 
<A HREF="../jsp/MMRoleList.jsp?SCROLLROW=LAST&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgLast"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>

<font>(<jsp:getProperty name="rPH" property="pgTheNo"/><%=currentPageNumber%><jsp:getProperty name="rPH" property="pgPage"/>/<jsp:getProperty name="rPH" property="pgTotal"/><%=totalPageNumber%><jsp:getProperty name="rPH" property="pgPage"/>)</font>

<% 
try { 
	String sql =  "select ROLENAME,ROLEDESC from ORADDMAN.WSROLE where ROLENAME is not null "+where+" order by ROLENAME";
	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	ResultSet rs=statement.executeQuery(sql);
	if (rowNumber==1)  {
		rs.beforeFirst(); //移至第一筆資料列  
	} else {
		if (rowNumber<=maxrow) { //若小於總筆數時才繼續換頁
			rs.absolute(rowNumber); //移至指定資料列
		} //end if
	} //end if-else
 
   qryAllChkBoxEditBean.setPageURL("../jsp/MMRoleEdit.jsp");//小圖示連結到修改的網頁
   qryAllChkBoxEditBean.setSearchKey("ROLENAME");//傳到下一個網頁以那一個變數為主
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   out.println(qryAllChkBoxEditBean.getRsString());
   statement.close();    
   rs.close();     
} catch (Exception e) { out.println("Exception:"+e.getMessage());
} // end try-catch
%>
</FORM>
</body>
</html>

<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
