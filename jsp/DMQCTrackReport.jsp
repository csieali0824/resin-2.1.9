<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============Open connection==========-->
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
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>YIELD RATE</title>
</head>
<body>
<FORM ACTION="../jsp/DMQCTrackReport.jsp" METHOD="post" NAME="MYFORM" >
    <%
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO"); 
		String sYearFr=request.getParameter("YEARFR");
		String sMonthFr=request.getParameter("MONTHFR"); 
		
		out.println(sModelNo);
		out.println(sYearFr);
		out.println(sMonthFr);

	%>	
    <%
	
		int iYearSelect;
		int iMonthSelect;
		int iMaxMonthDays;
		String sDateSelectFr = "";
		String sDateSelectTo = "";
		int n = 1;
		
		
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
		//out.println(iMaxMonthDays);
		
		sDateSelectFr = sYearFr + sMonthFr + "01";
		sDateSelectTo = sYearFr + sMonthFr + String.valueOf(iMaxMonthDays);
		
		//out.println(sDateSelectFr);
		//out.println(sDateSelectTo);
		
		
	%> 
  
<p>
	  <font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
	  <font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> MONTHLY YIELD RATE</strong></font>
</p>

  <table border="0"  >

		<tr bgcolor="#FFFFFE" > 
		
		<input name="MODELNO" type="hidden" value="<%out.println(sModelNo);%>">

		<!-- Model 改成自上一頁帶入
			<td ><font color="#333399" face="Arial Black"><strong>MODELNO</strong></font>
				<%
				 /*
					try // get ModelNo
					{
						String sSqlModel="";
						String sModel = "";
						
						sSqlModel = "SELECT DISTINCT MODELNO FROM dailyprod";
						//out.println(sSqlModel);
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
	
	<table  border="1" ><font size="-3">
		<tr bgcolor="#FFFFFE" >
			<td ><div align="center"><font color="#000000" size="2" face="Arial"><strong></strong>ModelNo</strong></font></div>
			</td>
				<%
		
					n = 1;
					while (n<=15)  //上半個月
					{				
						out.println("<td><div align='center'><font face='Arial' size=-2 >"+n+"</font></td>");
						n = n + 1;
					}
				%>
		</tr>	
		
		<tr bgcolor="#FFFFFE">
		
			<td><div align='center'><font color="#000000" face='Arial' size=-2 >
				<% if (sModelNo!=null) {out.println(sModelNo);}%></font></div>
			</td>
		
		
				<%
					try // 上半個月
					{
						
						String sqlMM = "";
						String sWhere = "";
						String sn = "";
						String sRate = "";
						
						
						Statement stateMM=dmcon.createStatement();							
						n = 1;
						while ( n<=15 &&  sModelNo!=null) // 上半個月
						{
							if (n<=9) {sn=sYearFr+sMonthFr+"0"+String.valueOf(n);}
							else {sn=sYearFr+sMonthFr+String.valueOf(n);}
							
							sqlMM = "select (1-ROUND(SUM((INQTY-OUTQTY)/INQTY),4))*100 as YIELD from dailyprod ";
							sqlMM = sqlMM + "WHERE INQTY>0 AND OUTQTY>0 AND STANUM IN ('PT','MT','FCT')"+
							" AND GENDATE ="+sn+
							" AND MODELNO='"+sModelNo.trim()+"'";
							//out.println(sqlMM);
							ResultSet rsMM=stateMM.executeQuery(sqlMM);
							boolean rsMM_isEmpty = !rsMM.next();		
							boolean rsMM_hasData = !rsMM_isEmpty;
							if (rsMM_hasData)
							{
								
								//sRate = String.valueOf(Math.round(rsMM.getFloat("YIELD")*100));
								sRate = rsMM.getString("YIELD");
								if (sRate==null || sRate.equals(""))
									{out.println("<td><div align='right'><font face='Arial' size=-2 >"+"0.0%"+"</font></td>");}
								else {out.println("<td><div align='right'><font face='Arial' size=-2 >"+sRate+"%"+"</font></td>");}
									
							}
							else {out.println("<td><div align='right'><font face='Arial' size=-2 >"+"  "+"</font></td>");}
						
							
							n = n + 1;
	
							rsMM.close();
						} //end of while 上半個月
						stateMM.close();
		
					}//end of try 
				
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());		  
					}  
				
			%>
			
		</tr>
		
		
		<tr  bgcolor="#FFFFFE" >
			<td ><div align="center"><font color="#000000" size="2" face="Arial">ModelNo</font></div>
			</td>
			<%
				n = 16;
				while (n<=iMaxMonthDays) //下半個月
				{				
					out.println("<td><div align='center'><font face='Arial' size=-2 >"+n+"</font></td>");
					n = n + 1;
				}
			%>			
		</tr>
		
		<tr bgcolor="#FFFFFE" >
			<td><div align='center'><font color="#000000" face='Arial' size=-2 >
				<%if (sModelNo!=null) {out.println(sModelNo);}%></font></div>
			</td>
		
		
		<%
			try //
			{
				String sqlMM = "";
				String sWhere = "";
				String sn = "";
				String sRate = "";
				Statement stateMM=dmcon.createStatement();
				
				
				n = 16;
				while (n<=iMaxMonthDays && sModelNo!=null) //下半個月
				{
					if (n<=9) {sn=sYearFr+sMonthFr+"0"+String.valueOf(n);}
					else {sn=sYearFr+sMonthFr+String.valueOf(n);}
					
					sqlMM = "select (1-ROUND(SUM((INQTY-OUTQTY)/INQTY),4))*100 as YIELD from dailyprod ";
					sqlMM = sqlMM + "WHERE INQTY>0 AND OUTQTY>0  AND STANUM IN ('PT','MT','FCT')"+
					" AND GENDATE ="+sn+
					" AND MODELNO='"+sModelNo.trim()+"'";
					//out.println(sqlMM);
					ResultSet rsMM=stateMM.executeQuery(sqlMM);
					boolean rsMM_isEmpty = !rsMM.next();		
					boolean rsMM_hasData = !rsMM_isEmpty;
					if (rsMM_hasData)
					{
					
						//sRate = String.valueOf(Math.round(rsMM.getFloat("YIELD")*100));
						sRate = rsMM.getString("YIELD");
						if (sRate==null)
							{out.println("<td><div align='right'><font face='Arial' size=-2 >"+"0.0%"+"</font></td>");}
						else {out.println("<td><div align='right'><font face='Arial' size=-2 >"+sRate+"%"+"</font></td>");}
					}
					else {out.println("<td><div align='right'><font face='Arial' size=-2 >"+" "+"</font></td>");}
					
					n = n + 1;
					rsMM.close();
				}//end of while
				
				
				stateMM.close();
			
			} //end of try
			catch (Exception e)
			{
				out.println("Exception:"+e.getMessage());		  
			}  
			
			
		%>		
		</tr>
		
	</font>
	</table>
	
	
<font color="#FF0000" size=-2 face='Arial' >註一:此表以PT,MT,FCT為統計基準</font>


</FORM>
<%
	try
	{
		out.println("<img src='DMQCTrackComboChart.jsp?MODELNO="+sModelNo+"&YEAR="+sYearFr+"&MONTH="+sMonthFr+" '>&nbsp;&nbsp;");
	}
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());		  
	}
%>
</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->