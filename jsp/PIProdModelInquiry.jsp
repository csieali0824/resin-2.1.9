<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%><html>
<script language="JavaScript" type="text/JavaScript">
function Wopen()
{   
  subWin=window.open("PIColorMasterInquiry.jsp?","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
</script>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Product Model Inqury</title>

</head>
<body>
<p><font color="#0080FF" size="4"><strong>機種料號查詢</strong></font>
  <%
	String sModel = request.getParameter("MODEL");
	//out.println(sModel);
	String sCountry = request.getParameter("COUNTRY"); 
	//out.println(sCountry);
	String sColor = request.getParameter("COLOR"); 
	String sel = request.getParameter("SEL"); //控制進入時不要將資料顯示

%>
<form ACTION="PIProdModelInquiry.jsp?SEL=1" METHOD="post" NAME="MYFORM">
<table>
	<tr>
		<td>MODEL
		<%
		try {
			Statement st=con.createStatement();
			ResultSet rs = st.executeQuery("SELECT DISTINCT MPROJ,MPROJ AS PROJ FROM PRODMODEL WHERE SUBSTR(MITEM,1,1)='0' ORDER BY MPROJ");
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(sModel);
			comboBoxBean.setFieldName("MODEL");	   
			out.println(comboBoxBean.getRsString());
			rs.close();
			st.close();
		}
		catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
		}
		
		%>
		</td>
		<td>COUNTRY
		<%
		try {
			Statement st=con.createStatement();
			ResultSet rs = st.executeQuery("SELECT DISTINCT MCOUNTRY,LOCALE_NAME FROM PRODMODEL,WSLOCALE WHERE MCOUNTRY=LOCALE AND SUBSTR(MITEM,1,1)='0' ORDER BY MCOUNTRY");
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(sCountry);
			comboBoxBean.setFieldName("COUNTRY");   
			out.println(comboBoxBean.getRsString());
			rs.close();
			st.close();
		} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
		}
		%>
		
		</td>
		<td>COLOR
		<%
		try {
			Statement st=con.createStatement();
			ResultSet rs = st.executeQuery("SELECT DISTINCT MCOLOR,COLORDESC FROM PRODMODEL,PICOLOR_MASTER WHERE MCOLOR=COLORCODE ORDER BY COLORDESC");
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(sColor);
			comboBoxBean.setFieldName("COLOR");   
			out.println(comboBoxBean.getRsString());
			rs.close();
			st.close();
		} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
		}
		%>
		
		</td>
		<td><input name="Search" type="submit" value="Query"></td>
	</tr>
</table>
<%
//共有多少個國碼, 用來宣告a[][]
int cnt = 0;
try {
	if (sel!=null) {
	Statement st=con.createStatement();
	String sSql = "SELECT COUNT(*) AS CNT FROM WSLOCALE";
	if (sCountry!=null && !sCountry.equals("--")) { sSql = sSql + " WHERE LOCALE='"+sCountry+"'";}
	ResultSet rs=st.executeQuery(sSql);
	rs.next();
	cnt = rs.getInt("CNT");
	//out.println(i);
	rs.close();
	st.close();
	} // end if
} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}// end try
String a[][] = new String[cnt][2];

//有多少個已使用的國碼, 用來宣告array aCountry[][]
try {
	if (sel!=null) { //
		Statement st=con.createStatement();
		String sSql = "SELECT DISTINCT MCOUNTRY,LOCALE_NAME FROM PRODMODEL,WSLOCALE "+
		" WHERE MCOUNTRY=LOCALE AND SUBSTR(MITEM,1,1)='0' ";
		if (sCountry!=null && !sCountry.equals("--")) { sSql = sSql + " AND MCOUNTRY='"+sCountry+"'"; }
		if (sModel!=null && !sModel.equals("--")) { sSql = sSql + " AND MPROJ='"+sModel+"'"; }
		if (sColor!=null && !sColor.equals("--")) { sSql = sSql + " AND MCOLOR='"+sColor+"'"; }
		sSql = sSql + " ORDER BY MCOUNTRY";
		//out.println(sSql);
		ResultSet rs=st.executeQuery(sSql);
		int i = 0;
		while (rs.next()) {
			a[i][0]=rs.getString("MCOUNTRY");
			a[i][1]=rs.getString("LOCALE_NAME");
			//out.println(j+":"+a[i][0]+a[i][1]);
			i++;
		} // end while
		rs.close();
		st.close();
		cnt = i;
		//out.println(i);
	}//end if
} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try

String aCountry[][]=new String[cnt][2];
//把a[][]放到aCountry[][]
try {
	for (int j=0;j<aCountry.length;j++) {
		aCountry[j][0]=a[j][0];
		aCountry[j][1]=a[j][1];
		//out.println(j+":"+aCountry[j][0]+aCountry[j][1]);
	} // for
} // end try
catch (Exception ee) { out.println("Exception:"+ee.getMessage()); }
%>
<table border="1">
	<tr>
		<% if (sel!=null) {%>
		<td><font face="Arial" size="1">MODEL</font></td>
		<% for(int j=0;j<aCountry.length;j++) { %>
		<td><font face="Arial" size="1"><%=aCountry[j][1]+"("+aCountry[j][0]+")"%></font></td>
		<% } // end for %>
		<%} // end if %>
	</tr>
<%
try {
	if (sel!=null) {
		Statement st=con.createStatement();
		String sSql = "SELECT DISTINCT MPROJ FROM PRODMODEL WHERE MPROJ IS NOT NULL ";
		if (sCountry!=null && !sCountry.equals("--")) { sSql = sSql + " AND MCOUNTRY='"+sCountry+"'"; }
		if (sModel!=null && !sModel.equals("--")) { sSql = sSql + " AND MPROJ='"+sModel+"'"; }
		if (sColor!=null && !sColor.equals("--")) { sSql = sSql + " AND MCOLOR='"+sColor+"'"; }
		sSql = sSql + " ORDER BY MPROJ";
		//out.println(sSql);
		ResultSet rs=st.executeQuery(sSql);
		while (rs.next()) {
%>
	<tr>
		<td><a href="PIDataDisplayPage.jsp?PROJECTCODE=<%=rs.getString("MPROJ")%>"><font face="Arial" size="1"><%=rs.getString("MPROJ")%></font></a></td>
<%
			for (int j=0;j<aCountry.length;j++) {
				Statement stItem=con.createStatement();
				String sSqlItem = "SELECT MITEM,MCOLOR,COLORDESC FROM PRODMODEL,PICOLOR_MASTER"+
				" WHERE substr(MITEM,1,1)='0' AND MCOLOR=COLORCODE "+
				" AND MPROJ='"+rs.getString("MPROJ")+"' "+
				" AND MCOUNTRY='"+aCountry[j][0]+"' ";
				if (sColor!=null && !sColor.equals("--")) { sSqlItem = sSqlItem + " AND MCOLOR='"+sColor+"'"; }
				sSqlItem = sSqlItem + " ORDER BY MCOLOR";
				ResultSet rsItem=stItem.executeQuery(sSqlItem);
				boolean rs_hasData = rsItem.next();
				if (rs_hasData) {
%>
		<td>
			<table>
					<% while (rs_hasData) { %>
				<tr>
					<td><font face="Arial" size="1"><%=rsItem.getString("MITEM")%></font></td>
					<td><font face="Arial" size="1" ><a href="javaScript:Wopen()"><%=rsItem.getString("MCOLOR")%></a></font></td>
				</tr>
					<%	
							rs_hasData = rsItem.next();
						} // end while
					%>
			</table>
		</td>
<%
				} // end if
				else { out.println("<td>&nbsp;</td>");}
				rsItem.close();
				stItem.close();
			} // end for
%>
	</tr>
<%
		} // end while
		rs.close();
		st.close();
	}// end if
} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}// end try
%>
</table>
</form>
</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
