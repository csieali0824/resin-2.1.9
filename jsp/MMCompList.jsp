<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="QryAllChkBoxEditBean" %>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<script>
var checkflag = "false";
function check(field) {
	if (checkflag == "false") {
		for (i = 0; i < field.length; i++) {
			field[i].checked = true;
		}
		checkflag = "true";
		return "取消全選"; 
	} else {
		for (i = 0; i < field.length; i++) {
			field[i].checked = false; 
		}
		checkflag = "false";
		return "全選"; 
	} // end if-else
}// end function

function NeedConfirm () {
	flag=confirm("確定要刪除嗎?"); 
	return flag;
}

</script>
<html>
<head>
<title>公司授權清單</title>
</head>

<body>
<%
	String searchString=request.getParameter("SEARCHSTRING"); 
	String scrollRow=request.getParameter("SCROLLROW");  
	String where = "";
	if (searchString==null) { searchString =""; }
	if (!searchString.equals("")) {		
		where = " AND (upper(ROLENAME) like '%"+searchString.toUpperCase()+"%' "
		+" or upper(MCDESC) like '%"+searchString.toUpperCase()+"%')"; 
	}

%>
<FORM ACTION="../jsp/MMCompDel.jsp" METHOD="POST" NAME="MYFORM" onSubmit='return NeedConfirm()'>
<strong><font color="#0080C0" size="5">公司授權清單</font></strong>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A>
&nbsp;&nbsp;
<a href="MMCompNew.jsp">新增公司授權</a>
<br><br>

<input name="button" type="button" onClick='this.value=check(this.form.CH)' value='全選'>
<INPUT TYPE="submit" value='刪除'>
<strong><font color="#400040" size="2">關鍵字</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 value="<%if (searchString!=null) out.println(searchString);%>"> 
<input name="search" type="button" onClick='setSubmit("MMCompList.jsp")' value='搜尋'>

<% 
	int pageRow = 30;
	int maxrow=0;//查詢資料總筆數 
	int currentPageNumber=0,totalPageNumber=0,rowNumber=0;
	try {   
		String sql = "SELECT count(*) FROM ORADDMAN.wsrole_comp "+
		" WHERE comp IS NOT NULL "+where;
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		rs.next();   
		maxrow=rs.getInt(1);
		rs.close();
		statement.close();
		out.println("<FONT SIZE='2'>(");
		%>總共<%
		out.println(maxrow);
		%>筆<%
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
				//out.println("next row3="+rowNumber);				
				if (rowNumber<=0) { rowNumber=1; currentPageNumber=1;
				} else {
					if (rowNumber>=maxrow) {
						if (maxrow>pageRow) {rowNumber=maxrow-pageRow;} else {rowNumber=1;}
						currentPageNumber=totalPageNumber;
					} else {
						currentPageNumber=rowNumber/pageRow+1;				
					}// end if-else
				} // end if-else
				qryAllChkBoxEditBean.setRowNumber(rowNumber);
			} // end if-else
		}  // end if-else
		if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
	} //end of try
	catch (Exception e){
		out.println("Exception:"+e.getMessage());
	}   
%>
<br> <!--換行 -->
<A HREF="../jsp/MMCompList.jsp?SCROLLROW=FIRST&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font color="#FF0080">第一頁</font></strong>
</A>

<A HREF="../jsp/MMAuthList.jsp?SCROLLROW=30&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font>下一頁</font></strong>
</A>

<A HREF="../jsp/MMAuthList.jsp?SCROLLROW=-30&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font>上一頁</font></strong>
</A>
 
<A HREF="../jsp/MMAuthList.jsp?SCROLLROW=LAST&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font color="#FF0080">最後一頁</font></strong>
</A>

<font>(第<%=currentPageNumber%>頁/共<%=totalPageNumber%>頁)</font>

<% 
try {  
	String sSql = "SELECT ROLENAME,comp FROM ORADDMAN.wsrole_comp "+
	" WHERE comp IS NOT NULL  "+where+" ORDER BY ROLENAME,comp ";
	//out.println(sSql);
	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	ResultSet rs=statement.executeQuery(sSql);
	if (rowNumber==1)  {
		rs.beforeFirst(); //移至第一筆資料列  
	} else {
		if (rowNumber<=maxrow) { //若小於總筆數時才繼續換頁
			rs.absolute(rowNumber); //移至指定資料列
		} //end if
	} //end if-else

	qryAllChkBoxEditBean.setPageURL("../jsp/MMCompEdit.jsp");//小圖示連結到修改的網頁
	String a[]={"ROLENAME","COMP"};
	qryAllChkBoxEditBean.setSearchKeyArray(a);
	qryAllChkBoxEditBean.setFieldName("CH");
	qryAllChkBoxEditBean.setRowColor1("B0E0E6");
	qryAllChkBoxEditBean.setRowColor2("ADD8E6");
	qryAllChkBoxEditBean.setRs(rs);   
	out.println(qryAllChkBoxEditBean.getRsString());
   rs.close(); 
   statement.close();    
} //end of try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }
%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

