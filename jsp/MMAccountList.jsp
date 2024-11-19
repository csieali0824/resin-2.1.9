<%@ page contentType="text/html" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean" %>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<!--=============for multi-language==========-->
<%@ include file="../jsp/include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgID"/><jsp:getProperty name="rPH" property="pgList"/></title>
</head>
<script language="JavaScript" type="text/JavaScript">

var checkflag = "false";
function check(field,ms1,ms2) 
{
	if (checkflag == "false") 
	{
		for (i = 0; i < field.length; i++) 
		{
			field[i].checked = true;
		}
		checkflag = "true";
		return ms1; 
	} 
	else 
	{
		for (i = 0; i < field.length; i++) 
		{
			field[i].checked = false; 
		}
		checkflag = "false";
		return ms2; 
	} // end if-else
}// end function

function NeedConfirm(ms1) 
{ 
	flag=confirm(ms1); 
	return flag;
}

function setSubmit(URL)
{   
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>

<body>
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgID"/><jsp:getProperty name="rPH" property="pgList"/></font></strong> 
<br> <!--���� -->
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
<A HREF="./MMAccountNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgID"/></A>
<%
	String searchString=request.getParameter("SEARCHSTRING");
	String scrollRow=request.getParameter("SCROLLROW");  
	String where = "";
	if (searchString==null) { searchString =""; }
	if (!searchString.equals(""))
	{		
		where = " AND (upper(USERNAME) like '%"+searchString.toUpperCase()
		+"%' or upper(USERNAME) like '%"+searchString.toUpperCase()+"%' or upper(WEBID) like '%"+searchString.toUpperCase()+"%')"; 
	}
%>

<FORM ACTION="./MMAccountDel.jsp" METHOD="POST" NAME="MYFORM" onSubmit='return NeedConfirm("<jsp:getProperty name='rPH' property='pgDelete'/>")'>
<input name="button" type="button" onClick='this.value=check(this.form.CH,"<jsp:getProperty name='rPH' property='pgCancelSelect'/>","<jsp:getProperty name='rPH' property='pgSelectAll'/>")' value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
<INPUT TYPE="submit" value='<jsp:getProperty name="rPH" property="pgDelete"/>'>
<strong><font color="#400040" size="2"><jsp:getProperty name="rPH" property="pgAccount"/></font></strong> 
<INPUT type="text" name="SEARCHSTRING" size=16 value="<%if (searchString!=null) out.println(searchString);%>"> 
<input name="search" type="button" onClick="setSubmit('./MMAccountList.jsp')" value='<jsp:getProperty name="rPH" property="pgSearch"/>' >
<%   
int pageRow = 30;
int maxrow=0;//�d�߸���`���� 
int currentPageNumber=0,totalPageNumber=0,rowNumber=0;
try 
{   
	String sql = "select count(*) from ORADDMAN.WSUSER WHERE LOCKFLAG != 'Y' and username is not null "+ where;
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
	if (scrollRow==null || scrollRow.equals("FIRST")) 
	{
		rowNumber=1;
		currentPageNumber=1;
		qryAllChkBoxEditBean.setRowNumber(rowNumber);
	} 
	else 
	{
		if (scrollRow.equals("LAST")) 
		{
			if (maxrow>pageRow) 
			{
				rowNumber=maxrow-pageRow;
			} 
			else 
			{
				rowNumber=1;
			}
			currentPageNumber=totalPageNumber;
			qryAllChkBoxEditBean.setRowNumber(rowNumber);	 
		} 
		else 
		{
			rowNumber=rowNumber+Integer.parseInt(scrollRow);
			if (rowNumber<=0) 
			{ 
				rowNumber=1; currentPageNumber=1;
			} 
			else 
			{
				if (rowNumber>=maxrow) 
				{
					if (maxrow>pageRow) 
					{
						rowNumber=maxrow-pageRow;
					} 
					else 
					{
						rowNumber=1;
					}
					currentPageNumber=totalPageNumber;
				} 
				else 
				{
					currentPageNumber=rowNumber/pageRow+1;				
				}// end if-else
			} // end if-else
			qryAllChkBoxEditBean.setRowNumber(rowNumber);
		} // end if-else
	}  // end if-else
	if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}   
%>
<br> <!--���� -->
<A HREF="../jsp/MMAccountList.jsp?SCROLLROW=FIRST&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgFirst"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>

<A HREF="../jsp/MMAccountList.jsp?SCROLLROW=30&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font><jsp:getProperty name="rPH" property="pgNext"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>

<A HREF="../jsp/MMAccountList.jsp?SCROLLROW=-30&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>
 
<A HREF="../jsp/MMAccountList.jsp?SCROLLROW=LAST&SEARCHSTRING=<%if (searchString!=null) out.println(searchString);%>">
<strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgLast"/><jsp:getProperty name="rPH" property="pgPage"/></font></strong>
</A>

<font>(<jsp:getProperty name="rPH" property="pgTheNo"/><%=currentPageNumber%><jsp:getProperty name="rPH" property="pgPage"/>/<jsp:getProperty name="rPH" property="pgTotal"/><%=totalPageNumber%><jsp:getProperty name="rPH" property="pgPage"/>)</font>
<% 
try 
{  
	String sql = "select USERNAME,WEBID,USERMAIL,USERPROFILE from ORADDMAN.WSUSER "+
	             " where LOCKFLAG != 'Y' and USERNAME is not null "+where+" order by USERNAME ";
	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	ResultSet rs=statement.executeQuery(sql);
	if (rowNumber==1)  
	{
		rs.beforeFirst(); //���ܲĤ@����ƦC  
	} 
	else 
	{
		if (rowNumber<=maxrow) 
		{ //�Y�p���`���Ʈɤ~�~�򴫭�
			rs.absolute(rowNumber); //���ܫ��w��ƦC
		} //end if
	} //end if-else
	qryAllChkBoxEditBean.setPageURL("../jsp/MMAccountEdit.jsp");//�p�ϥܳs����ק諸����
	qryAllChkBoxEditBean.setHeaderArray(null);  
	qryAllChkBoxEditBean.setSearchKey("USERNAME");//�Ǩ�U�@�Ӻ����H���@���ܼƬ��D
	qryAllChkBoxEditBean.setFieldName("CH");		 
	qryAllChkBoxEditBean.setRowColor1("B0E0E6");
	qryAllChkBoxEditBean.setRowColor2("ADD8E6");
	qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
	qryAllChkBoxEditBean.setRs(rs); 
	qryAllChkBoxEditBean.setScrollRowNumber(30);  
	out.println(qryAllChkBoxEditBean.getRsString());
	rs.close();     
	statement.close();    
} //end of try
catch (Exception e) 
{
  	e.printStackTrace();
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
</body>
</html>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnORADDSPage.jsp"%>
