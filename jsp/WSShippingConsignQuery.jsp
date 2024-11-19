<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function Submit(URL)
{  
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>寄售查詢</title>
</head>

<body>
<font color="#3366FF" size="+2" face="Arial"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Arial"><strong>寄售查詢</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<form ACTION="WSShippingConsignQuery.jsp?" METHOD="post" NAME="MYFORM" >
<%
	String flag = request.getParameter("FLAG"); //控制是否從本頁submit
	//out.println(flag);
	String Center = request.getParameter("CENTER");
	//out.println(Center);
	String CustNo = request.getParameter("CUSTNO");
	String YearFr = request.getParameter("YEARFR");
	//out.println(YearFr);
	String MonthFr = request.getParameter("MONTHFR");
	//out.println(MonthFr);
	String carIMEI = request.getParameter("CARIMEI");
	if (carIMEI==null) carIMEI = "";
	String isAdmin = "N";  //資料處理權限控管
%>


<table>
	<tr>
		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black">Center
		<% 		 		 		 
		try
		{	
			Statement statement=con.createStatement();
			ResultSet rs = statement.executeQuery("SELECT * FROM  wsgroupuserrole where ROLENAME='admin' AND groupusername='"+UserName+"'");
			if (rs.next()) 
			{ 
				isAdmin = "Y";
				ResultSet rsT=statement.executeQuery("select unique CENTERNO,ALNAME from WSSHP_CENTER,WSSHIP_IMEI_T where IN_CENTERNO = CENTERNO AND (SHP_NOTES IS NULL OR SHP_NOTES NOT IN ('D','R','C'))");
				comboBoxBean.setRs(rsT);		  
				comboBoxBean.setSelection(userActCenterNo);
				comboBoxBean.setFieldName("CENTER");	   
				out.println(comboBoxBean.getRsString());
				rsT.close();      
			
			}
			else 
			{
				ResultSet rsS=statement.executeQuery("select ALNAME from WSSHP_CENTER "+
				"where CENTERNO ='"+userActCenterNo+"'");
				boolean rs_isEmpty = !rsS.next();
				boolean rs_hasData = !rs_isEmpty;
				if (rs_hasData) { out.println(rsS.getString("ALNAME"));}
				rsS.close();      
			}
			
			rs.close();
			statement.close();		
			 
		} //end try
		catch (Exception e){out.println("Exception:"+e.getMessage());	}
		%>
		</font>
		</td>
		<td bgcolor="#CCFFCC" colspan="3"><font color="#333399" font size="2" face="Arial Black">Customer 
		<%
		try // get customer
		{
			out.println("<select NAME='CUSTNO' onChange='setSubmit("+'"'+"../jsp/WSShippingConsignEntry.jsp?RESET=1"+'"'+")'>");
			out.println("<OPTION VALUE=-->--");
			String sqlCust = "SELECT DISTINCT ERP_CUSTNO,ERP_CUSTNAME FROM WSSHIP_IMEI_T "+
			"WHERE ERP_CUSTNO IS NOT NULL AND ERP_CUSTNAME IS NOT NULL ";
			if (isAdmin.equals("N")) { sqlCust = sqlCust + " AND IN_CENTERNO='"+userActCenterNo+"'"; }
			sqlCust = sqlCust + " ORDER BY ERP_CUSTNO";
			Statement statCust=con.createStatement();
			ResultSet rsCust=statCust.executeQuery(sqlCust);
			while(rsCust.next())
			{
				String s1 = rsCust.getString("ERP_CUSTNO");
				String s2 = rsCust.getString("ERP_CUSTNAME");
				if (s1.equals(CustNo)) { out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s1+"-"+s2); }
				else { out.println("<OPTION VALUE='"+s1+"' >"+s1+"-"+s2); }
			
			} // end of while get cust
			rsCust.close();    
			statCust.close();
			out.println("</select>");
		
		} // end of try get cust
		catch (Exception e) {out.println("Exception:"+e.getMessage());}
		
		%>
			</font>					
		</td>
	</tr>
	<tr>
		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black">Year</font> 
			<%
				String CurrYear = null;	     		 
				try //get year
				{       
					String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
					arrayComboBoxBean.setArrayString(a);
					if (YearFr==null)
					{
						CurrYear=dateBean.getYearString();
						arrayComboBoxBean.setSelection(CurrYear);
					} 
					else 
					{
						arrayComboBoxBean.setSelection(YearFr);
					}
					arrayComboBoxBean.setFieldName("YEARFR");	   
					out.println(arrayComboBoxBean.getArrayString());		      		 
				} //end of try
				catch (Exception e)
				{
					out.println("Exception:"+e.getMessage());
				}
			%>
		</td>	
		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black">Month</font> 
			<%
				String CurrMonth = null;	     		 
				try  //get month
				{       
					String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
					arrayComboBoxBean.setArrayString(b);
					if (MonthFr==null)
					{
					CurrMonth=dateBean.getMonthString();
					arrayComboBoxBean.setSelection(CurrMonth);
					} 
					else 
					{
					arrayComboBoxBean.setSelection(MonthFr);
					}
					arrayComboBoxBean.setFieldName("MONTHFR");	   
					out.println(arrayComboBoxBean.getArrayString());		      		 
				} //end of try
				catch (Exception e)
				{
					out.println("Exception:"+e.getMessage());				
				}
			%> 
		</td>	

		<td bgcolor="#CCFFCC"><font color="#333399" font size="2" face="Arial Black">Carton No./IMEI No.
			<input type="text" name="CARIMEI"  size="30" maxlength="21" value="<%=carIMEI%>">
			</font>
		</td>
		<td><input name="Search"  type="submit" value="Query" onClick='return Submit("../jsp/WSShippingConsignQuery.jsp?FLAG=1")'></td>
	</tr>

</table>

<table border="1">
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">ITEM</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">IMEI</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CARTON</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">VERSION</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">PRODUCTION DATE</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">SHIPPING DATE</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CENTER</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CUSTOMER</font></td>
	</tr>
<%
try
{
	
	if (flag!=null){
	String sWhere = "";	
	if (Center!=null && !Center.equals("--")) { sWhere = sWhere + " AND IN_CENTERNO='"+Center+"'";}
	if (CustNo!=null && !CustNo.equals("--")) { sWhere = sWhere + " AND ERP_CUSTNO='"+CustNo+"'";}
	if (carIMEI!=null && !carIMEI.equals("")) { sWhere = sWhere + " AND (MES_CARTON_NO='"+carIMEI+"' OR IMEI='"+carIMEI+"')";}
	if (YearFr!=null && !YearFr.equals("--")) { sWhere = sWhere + " AND SUBSTR(INSERT_DTIME,0,4)='"+YearFr+"'";}
	if (MonthFr!=null && !MonthFr.equals("--")) { sWhere = sWhere + " AND SUBSTR(INSERT_DTIME,5,2)='"+MonthFr+"'";}
	
	String sql = "select ERP_ITEMNO,IMEI,VERSION,"+
	"SUBSTR(IN_DATETIME,0,4)||SUBSTR(IN_DATETIME,6,2)||SUBSTR(IN_DATETIME,9,2) AS IN_DATETIME,"+
	"SUBSTR(SHIPPNO,6,8) AS SHIPDATE,ALNAME, ERP_CUSTNAME, MES_CARTON_NO"+
	" from WSSHIP_IMEI_T,WSSHP_CENTER "+
	" WHERE IN_CENTERNO = CENTERNO AND SHP_NOTES = 'S' "+sWhere;
	if (isAdmin.equals("N")) { sql = sql + " AND IN_CENTERNO='"+userActCenterNo+"'";}
	sql = sql + " ORDER BY ALNAME, ERP_CUSTNAME ";
	//out.println(sql);
	Statement state1=con.createStatement();
	ResultSet rs1=state1.executeQuery(sql);
	boolean rs_isEmpty = !rs1.next();
	boolean rs_hasData = !rs_isEmpty;
	if (rs_hasData)
	{
		while(rs_hasData)
		{
%>
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("ERP_ITEMNO")%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("IMEI")%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("MES_CARTON_NO")%></font></td>
		<% String sVer=rs1.getString("VERSION"); if (sVer==null) { sVer="";} %>
		<td><font color="#333399" font size="2" face="Arial Black"><%=sVer%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("IN_DATETIME")%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("SHIPDATE")%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("ALNAME")%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=rs1.getString("ERP_CUSTNAME")%></font></td>
	</tr>
<%
			rs_isEmpty = !rs1.next();
			rs_hasData = !rs_isEmpty;
		} // end while
	
	} // end if (rs_hasData)
	else {out.println("DATA NOT FOUND");}
	rs1.close();
	state1.close();
	} //end if

} // end try
catch (Exception e) {out.println("Exception:"+e.getMessage());}
%>
</table>

</form>
</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
