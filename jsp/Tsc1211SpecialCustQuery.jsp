<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC DELTA 1211 Order Query</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeane" scope="page" class="DateBean"/>
<style type="text/css">
 .style1   {font-family:Arial; font-size:12px; background-color:#A9E1E7; color:#000000; text-align:left;}
 .style2   {font-family:Arial; font-size:12px; color:#000000; text-align:left;}
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Arial; font-size:12px; color: #000000; text-align:center}
 .style5   {font-family:Arial; font-size:12px; background-color:#AEF199; color:#000000; text-align:left;}
 .style6   {font-family:Arial; font-size:12px; background-color:#AEF199; color:#000000; text-align:center;}
 .style7   {font-family:Arial; font-size:12px; background-color:#AEF199; color:#000000; text-align:right;}
 .style8   {font-family:Arial; font-size:12px; background-color:#E5FFCB; color:#000000; text-align:left;}
 .style13  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:left;}
 .style14  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:center;}
 .style15  {font-family:標楷體; font-size:16px; background-color:#6699CC; color:#FFFFFF; text-align:center;}
 .style16  {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
</style>
<%
String qSDate =	request.getParameter("qSDate");
String qEDate =	request.getParameter("qEDate");
if (qSDate == null)
{
	dateBeans.setAdjDate(-2);
	qSDate = dateBeans.getYearMonthDay();
}
if (qEDate == null)
{
	qEDate = dateBeane.getYearMonthDay();
}
String qPlant	= request.getParameter("qPlant");
String qStatus	= request.getParameter("qStatus");
String qCust =	request.getParameter("qCust");
String qCreatedBY  = request.getParameter("qCreatedBY");
String sql = "";
StringBuffer sb = new StringBuffer();
String strColor = "";
String qType = request.getParameter("qType");
if (qType == null) qType="0";
if (qType.equals("0")) qStatus="OPEN";
Statement st = con.createStatement();
ResultSet rs =null;
%>
</head>
<body>
<form name="form1" method="post" action="Tsc1211SpecialCustQuery.jsp?qType=1">
 <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<p>
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong>DELTA 1211 Order Query</strong>
  </font>
  <P>
 <table width="80%" bgcolor="#D8E6E7" cellspacing="0" cellpadding="0" bordercolordark="#990000">
 	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#000000" cellpadding="1" width="100%" height="15" align="left">
				<TR>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
    							<TD width="10%"  height="70%" class="style13" title="回首頁!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#FFFFFF">
									<STRONG>回首頁</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>
					<TD width="10%" class="style15">
						<STRONG>資料查詢</STRONG>
					</TD>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入資料上傳功能!">
									<A HREF="Tsc1211SpecialCustUpload.jsp" style="text-decoration:none;color:#FFFFFF">
									<STRONG>資料上傳</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</td>
					<TD width="70%" class="style16"><a href="samplefiles/D4-010_User_Guide.doc">Download User Guide</a>&nbsp;</TD>
  				</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>
 	<tr>
 		<td>
			<table cellspacing="0" bordercolordark="#998811"  cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
  				<tr >
    				<td colspan="6" class="style1" >請輸入查詢條件:</td>
    			</tr>
  				<tr>
    				<td bgcolor="#FFFFFF" class="style1">CUSTOMER NAME：</td>
					<td class="style3">
					<%
	   				try
	   				{   
		 				Statement st1=con.createStatement();
		 				ResultSet rs1=null;
		 				sql = " select CUSTOMERNAME as qCust, CUSTOMERNAME "+
						             " from TSC_OE_AUTO_HEADERS  WHERE SALES_REGION ='DELTA'"+
									 " group by CUSTOMERNAME"+
									 " order by CUSTOMERNAME";
		 				rs1=st1.executeQuery(sql);
		 				comboBoxBean.setRs(rs1);
						comboBoxBean.setFontSize(14);
		 				comboBoxBean.setFieldName("qCust");	   
		 				comboBoxBean.setSelection(qCust);
		 				out.println(comboBoxBean.getRsString());				    
						rs1.close();   
						st1.close();     	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					} 
					%>					
					</td>
    				<td class="style1">CREATION DATE(S)：</td>
					<td class="style3"><input class="style2" name="qSDate" type="text" id="qSDate" size="12" value="<%=qSDate%>" readonly>
       			    <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.qSDate);return false;'>
					<IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A>
					</td>
    				<td class="style1">CREATION DATE(E)：</td>
					<td class="style3"><input class="style2" name="qEDate" type="text" id="qEDate" size="12" value="<%=qEDate%>" readonly>
       			    <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.qEDate);return false;'>
					<IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A>
					</td>
				</tr>
				<tr>
					<td class="style1">PLANT CODE：</td>
					<td class="style3">
					<%
	   				try
	   				{   
		 				Statement st1=con.createStatement();
		 				ResultSet rs1=null;
		 				sql = " select PLANT_CODE as qPlant ,PLANT_CODE"+
						             " from TSC_OE_AUTO_HEADERS  "+
									 "  WHERE SALES_REGION ='DELTA'"+
									 " group by PLANT_CODE"+
									 " order by PLANT_CODE";
		 				rs1=st1.executeQuery(sql);
		 				comboBoxBean.setRs(rs1);
						comboBoxBean.setFontSize(14);
		 				comboBoxBean.setFieldName("qPlant");	   
		 				comboBoxBean.setSelection(qPlant);
		 				out.println(comboBoxBean.getRsString());				    
						rs1.close();   
						st1.close();     	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					} 
					%>					
					</td>
					<td class="style1">ORDER STATUS：</td>
					<td class="style3">
					<%
	   				try
	   				{   
		 				Statement st1=con.createStatement();
		 				ResultSet rs1=null;
		 				sql = " select DISTINCT status as qStatus , status "+
						             " from TSC_OE_AUTO_HEADERS "+
									 " WHERE SALES_REGION ='DELTA' ";  
		 				rs1=st1.executeQuery(sql);
						comboBoxBean.setRs(rs1);
						comboBoxBean.setFontSize(14);
		 				comboBoxBean.setFieldName("qStatus");	  
	 					comboBoxBean.setSelection(qStatus); 
		 				out.println(comboBoxBean.getRsString());				    
						rs1.close();   
						st1.close();     	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					} 
					%> 					
					</td>
					<td class="style1">CREATED BY：</td>
					<td class="style3">
					<%
			       	try
                   	{   
		            	Statement st1=con.createStatement();
                     	ResultSet rs1=null;
			         	sql = " select created_By as qCreatedBY, created_By "+
						              " from TSC_OE_AUTO_HEADERS  "+
									  " WHERE SALES_REGION ='DELTA'" +
									  " group by created_By"+
									  " order by created_By";
                     	rs1=st1.executeQuery(sql);
		             	comboBoxBean.setRs(rs1);
						comboBoxBean.setFontSize(14);
	                 	comboBoxBean.setFieldName("qCreatedBY");	   
		             	comboBoxBean.setSelection(qCreatedBY);
                     	out.println(comboBoxBean.getRsString());				   
		            	rs1.close();   
						st1.close();     	 
                 	} 
                 	catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					} 
					%>
					</td>
				</tr>	
				<tr>
			      <td colspan="6" bgcolor="#FFFFFF">
				  	<input class="style4" name="search" type="submit" id="search" value="Search" title="請按我,謝謝!">
				  </td>
				</tr>
			</table>
		</td>
	</tr>
	<TR><TD>&nbsp;</td></tr>
	<tr>
		<td>
  		<%
		try
		{
			sb.append(" select ID,CUSTOMERNAME,PLANT_CODE,CREATION_DATE,CREATED_BY,STATUS,ORDER_NUMBER"+
					   " from TSC_OE_AUTO_HEADERS "+
					   " where SALES_REGION='DELTA' ");
			if (qCust != null && !qCust.equals("--"))
			{
				sb.append(" and CUSTOMERNAME like '%"+qCust+"%'");
			}
			if (qSDate != null)
			{
				sb.append(" and to_date(creation_date ,'yyyy-mm-dd') >= to_date('"+qSDate+"','yyyy-mm-dd')");
			}
			if (qEDate != null)
			{
				sb.append(" and to_date(creation_date ,'yyyy-mm-dd') <= to_date('"+qEDate+"','yyyy-mm-dd')");
			}
			if (qStatus != null && !qStatus.equals("--"))
			{
				sb.append(" and STATUS = '" + qStatus+"'");
			}
			if (qPlant != null && !qPlant.equals("--"))
			{
				sb.append(" and PLANT_CODE = '" + qPlant + "'");
			}
			if (qCreatedBY != null && !qCreatedBY.equals("--"))
			{
				sb.append(" and CREATED_BY = '" + qCreatedBY + "'");
			}
			sb.append(" order by to_date(c_Date,'yyyy-mm-dd') desc,id desc ");
			rs = st.executeQuery(sb.toString());
			int i = 0;
			while(rs.next())
			{
				if (i==0)
				{
					out.println("<table cellspacing='0' bordercolordark='#998811'  cellpadding='1' width='100%' "+
					" align='left' bordercolorlight='#ffffff' border='1'>");
					out.println("<tr>");
					out.println("<td class='style6'>ID Nnumber</td>");
					out.println("<td class='style5'>Customer Name</td>");
					out.println("<td class='style5'>Plant Code</td>");
					out.println("<td class='style6'>Creation Date</td>");
					out.println("<td class='style6'>Created By</td>");
					out.println("<td class='style6'>Status</td>");
					out.println("<td class='style6'>ERP Order Number</td>");
					out.println("</tr>");
				}
				if (i % 2==0)
				{
					strColor = "#FFFFFF";
				}
				else
				{
					strColor = "#E5FFFB";
				}
				out.println("<tr bgcolor='"+strColor+"'>");
				out.println("<td class='style4' title='請按我進入Detail畫面!'>"+
				"<A HREF='../jsp/Tsc1211SpecialCustConfirm.jsp?KeyID="+rs.getString("ID")+"'>"+rs.getString("ID")+"</a></td>");
				out.println("<td class='style2'>"+rs.getString("CUSTOMERNAME")+"</td>");
				out.println("<td class='style2'>"+rs.getString("PLANT_CODE")+"</td>");
				out.println("<td class='style4'>"+rs.getString("CREATION_DATE")+"</td>");
				out.println("<td class='style4'>"+rs.getString("CREATED_BY")+"</td>");
				out.println("<td class='style4'>"+rs.getString("STATUS")+"</td>");
				if (rs.getString("ORDER_NUMBER") == null)
				{
					out.println("<td class='style4'>&nbsp;</td>");
				}else{
					out.println("<td class='style4'>"+rs.getString("ORDER_NUMBER")+"</td>");
				}
				out.println("</tr>"); 
				i++;
			}
		
			if (i>0)
			{
				out.println("</table>");
			}
			else
			{
				out.println("<font color='red' size='2'>查無相關資料，請重新確認查詢條件，謝謝!</font>");
			}
		}
		catch(SQLException e)
		{
			out.println(e.toString()+"<br>"+sql);
		}
		finally
		{
			rs.close();
			st.close();
		}
		%>
		</td>
	</tr>
</table>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
