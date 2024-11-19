<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理完成開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Top 3 Issue Tracking</title>

</head>
<body>
<FORM ACTION="../jsp/DMTop3DefectReport.jsp" METHOD="post" NAME="MYFORM">
	
	<%
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO");
		String sYearFr=request.getParameter("YEARFR");
		String sMonthFr=request.getParameter("MONTHFR"); 
		
		//out.println(sModelNo);
		
	%>

	<%

		int iYearSelect;
		int iMonthSelect;
		int iMaxMonthDays;
		String sDateSelectFr = "";
		String sDateSelectTo = "";
		
		if (sYearFr==null) 
		{ 
			sYearFr = dateBean.getYearString();
			iYearSelect = dateBean.getYear();
		}
		else iYearSelect = Integer.parseInt(sYearFr);
		
		if (sMonthFr==null) 
		{
			sMonthFr = dateBean.getMonthString();
			iMonthSelect = dateBean.getMonth();
		}
		else iMonthSelect = Integer.parseInt(sMonthFr);
		
		dateBean.setDate(iYearSelect, iMonthSelect, 1);
		iMaxMonthDays = dateBean.getMonthMaxDay();
		
		sDateSelectFr = sYearFr + sMonthFr + "01";
		sDateSelectTo = sYearFr + sMonthFr + String.valueOf(iMaxMonthDays);


	%>
<P>	  
	<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
	<font color="#000000" size="+2" face="Times New Roman"><strong><%out.println(sModelNo);%> TOP 3 Defect</strong></font>
</P>

<table border="0"  >
	<tr bgcolor="#FFFFFE"> 
	
		<input name="MODELNO" type="hidden" value="<%out.println(sModelNo);%>">
		
		<!--
			<td ><font color="#333399" face="Arial Black"><strong>MODELNO</strong></font>
				<% 
				/*
					try // get ModelNo
					{
						String sSqlModel="";
						String sModel = "";
						
						sSqlModel = "SELECT DISTINCT MODELNO FROM qcprod";
						Statement stateModel=dmcon.createStatement();
						ResultSet rsModel=stateModel.executeQuery(sSqlModel);
						out.println("<select NAME='ModelNo'>");
						out.println("<OPTION VALUE=-->--");
						while (rsModel.next())
						{
							//out.println(rsModel.getString("MODELNO"));
							sModel = rsModel.getString("MODELNO");
							if (sModel.equals(sModelNo)) {out.println("<OPTION VALUE='"+sModelNo+"' SELECTED>"+sModelNo);}
							else {out.println("<OPTION VALUE='"+sModel+"'>"+sModel);}
							
						} // end of while rsModel.next()
						
						out.println("</select>");
						
						rsModel.close();
						stateModel.close();
						
						
					} //end of try modelno
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				*/
				%>
			</td>
			-->
						<td ><font color="#333399" face="Arial Black"><strong>Year</strong></font> 
				<%
					String CurrYear = null;	     		 
					try //get year
					{       
						String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
						arrayComboBoxBean.setArrayString(a);
						if (sYearFr==null)
						{
							CurrYear=dateBean.getYearString();
							arrayComboBoxBean.setSelection(CurrYear);
						} 
						else 
						{
							arrayComboBoxBean.setSelection(sYearFr);
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
			
			<td  > <font color="#330099" face="Arial Black"><strong>Month</strong></font> 
				<%
					String CurrMonth = null;	     		 
					try  //get month
					{       
						String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
						arrayComboBoxBean.setArrayString(b);
						if (sMonthFr==null)
						{
						CurrMonth=dateBean.getMonthString();
						arrayComboBoxBean.setSelection(CurrMonth);
						} 
						else 
						{
						arrayComboBoxBean.setSelection(sMonthFr);
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
			<td width="24%"><input name="submit"  type="submit" value="Query">
			</td>

	</tr>
</table>

<table  border="1">
	<tr bgcolor="#0072A8" > 
		<td  > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			Date</strong></font></div></td>
		<td > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			LINENO.</strong></font></div></td>
		<td > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			不良率%</strong></font></div></td>
		<td > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			不良現象</strong></font></div></td>
		<td > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			原因分析</strong></font></div></td>
		<td > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			短期改善對策</strong></font></div></td>
		<td > <div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			PIC</strong></font></div></td>
		<td ><div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			Due Date </strong></font></div></td>
		<td ><div align="center"><font color="#FFFFFF" size="2" face="Arial"><strong>
			STATUS</strong></font></div></td>
	</tr>
	

	<%      
	try
	{  
		String sqlTC =  "SELECT MODELNO,LINENUM,STANUM,GENDATE,NGQTY,DRATE,NGPHE,NGREA,NGWAY,NGPER,SDATE,ADATE,STAT "+
			   " FROM Qcprod "+
			   " WHERE (STAT!='CLOSED' OR STAT IS NULL) "+
			   " AND GENDATE >="+sDateSelectFr+" AND GENDATE <="+sDateSelectTo+
			   " AND MODELNO='"+sModelNo.trim()+"' "+
			   " ORDER BY GENDATE";		
		//out.println(sqlTC);
		Statement statementTC=dmcon.createStatement();    
		ResultSet rsTC=statementTC.executeQuery(sqlTC);	          

		while (rsTC.next()) 
		{		    

	%>

		<tr bgcolor="#CCFFFF"> 
		
		<td width="8%"> <div align="left"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("GENDATE")!=null ) { out.println(rsTC.getString("GENDATE")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		<td width="8%"><div align="left"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("LINENUM")!=null ) { out.println(rsTC.getString("LINENUM")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>


		<td> <div align="right"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getFloat("DRATE")!=0) { out.println(rsTC.getFloat("DRATE")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		<td> <div align="left"><font color="#000000" size="2" face="Arial"> 
			<%   
				if (rsTC.getString("NGPHE")!=null) { out.println(rsTC.getString("NGPHE")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		<td> <div align="left"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("NGREA")!=null ) { out.println(rsTC.getString("NGREA")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		<td> <div align="left"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("NGWAY")!=null ) { out.println(rsTC.getString("NGWAY")); } 
				else { out.println("&nbsp;"); }					  
			%></font></div>
		</td>
		<td> <div align="center"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("NGPER")!=null ) { out.println(rsTC.getString("NGPER")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		<td><div align="center"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("SDATE")!=null ) { out.println(rsTC.getString("SDATE")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		<td><div align="center"><font color="#000000" size="2" face="Arial"> 
			<% 
				if (rsTC.getString("STAT")!=null ) { out.println(rsTC.getString("STAT")); } 
				else { out.println("&nbsp;"); }
			%></font></div>
		</td>
		</tr>
	
	
	<%     }//end of while	     

			rsTC.close();
			statementTC.close();
		} //end of try
		catch (Exception e)
		{
		out.println("Exception:"+e.getMessage());
		}   
	%>
	

	
</table>


</FORM>   

</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

