<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<%@ page import="DateBean,WorkingDateBean,ComboBoxBean,ArrayComboBoxBean" %>
<!--=============Open connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Process Start==========-->
<%//@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>MPS</title>
</head>
<body>
<FORM ACTION="../jsp/PisMpsAllModelRpt.jsp" METHOD="post" NAME="MYFORM" >
    <%
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO"); 
		String sYearFr=request.getParameter("YEARFR");
		String sMonthFr=request.getParameter("MONTHFR"); 
		
		//out.println(sModelNo);
		//out.println(sYearFr);
		//out.println(sMonthFr);
	
		int iYearSelect;
		int iMonthSelect;
		int iMaxMonthDays;
		String sDateSelectFr = "";
		String sDateSelectTo = "";
		int n = 1;
		
		
		if (sYearFr==null || sYearFr.equals("--")) 
		{ 
			sYearFr = dateBean.getYearString();
			iYearSelect = dateBean.getYear();
		}
		else iYearSelect = Integer.parseInt(sYearFr);
		
		if (sMonthFr==null || sMonthFr.equals("--")) 
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
		
		String week = workingDateBean.getWeekString();
		String weekDateFr = workingDateBean.getFirstDateOfWorkingWeek();
		String weekDateTo = workingDateBean.getLastDateOfWorkingWeek();
		//out.println("week date "+weekDateFr+","+weekDateTo);
		String month [] = workingDateBean.getWWArrayOfMonth(iMonthSelect);
		String m [][] = new String [month.length][3];
		for (int i=0;i<month.length;i++) {
			//out.println(month[i]);
			workingDateBean.setAdjWeek(Integer.parseInt(month[i])-Integer.parseInt(workingDateBean.getWeekString()));
			//out.println(workingDateBean.getFirstDateOfWorkingWeek());
			//out.println(workingDateBean.getLastDateOfWorkingWeek());
			m[i][0]=month[i];
			m[i][1]=workingDateBean.getFirstDateOfWorkingWeek();
			m[i][2]=workingDateBean.getLastDateOfWorkingWeek();
			//out.println("week "+m[i][0]+" from "+m[i][1]+" to "+m[i][2]);
		}
		
		
		
	%> 
  
<p><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL MPS</strong></font></p>

  <table border="0"  >

		<tr bgcolor="#FFFFFE" > 

			<td ><font color="#333399" face="Arial Black"><strong>MODEL</strong></font>
				<%
					try // get ModelNo
					{
						String sSqlModel="";
						String sModel = "";
						
						sSqlModel = "SELECT DISTINCT mproj FROM prodmodel ORDER BY mproj ";
						//out.println(sSqlModel);
						Statement stateModel=con.createStatement();
						ResultSet rsModel=stateModel.executeQuery(sSqlModel);
						out.println("<select NAME='MODELNO'>");
						out.println("<OPTION VALUE=-->--");
						while (rsModel.next())
						{
							//out.println(rsModel.getString("MODELNO"));
							sModel = rsModel.getString("mproj");
							if (sModel.equals(sModelNo)) {out.println("<OPTION VALUE='"+sModelNo+"' SELECTED>"+sModelNo);}
							else {out.println("<OPTION VALUE='"+sModel+"'>"+sModel);}
							
						} // end of while rsModel.next()
						
						out.println("</select>");
						
						rsModel.close();
						stateModel.close();
						
						
					} //end of try modelno
					catch (Exception ee) { out.println("Exception:"+ee.getMessage());
					%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
					}
				%>
			</td>
			
			<!--
			<td ><font color="#333399" face="Arial Black"><strong>Year</strong></font>
				<%
				/*
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
				*/
				%>
			</td>	
			-->
			<!--
			<td> <font color="#330099" face="Arial Black"><strong>Month</strong></font> 
				<%
				/*
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
				*/
				%> 
			</td>	
			-->
			<td width="24%"><input name="submit"  type="submit" value="Query">
			</td>	
			
		</tr>
  </table>
	
	<table border="1">

		<tr>
			<td><font size="2" face="Arial"><strong>ModelNo</strong></font></td>
			
				<%
					n = 0;
					while (n<m.length)
					{				
						out.println("<td align='center'>");
						out.println("<table>");
						out.println("<tr><td align='center'><font face='Arial' size=-1 ><strong>第"+m[n][0]+"週</strong></font></td></tr>");
						out.println("<tr><td align='center'><font face='Arial' size=-1 ><strong>"+m[n][1]+"~"+m[n][2]+"</strong></font></td></tr>");
						out.println("</table>");
						out.println("</td>");
						n = n + 1;
					}
					out.println("<td align='center' width='100'><font face='Arial' size=-1 ><strong>"+"SUM"+"</strong></font></td>");
					
				%>
		</tr>	
		

		
		
		<%
		try {
						
			//String sn = "";
			String sqlMM = "";
			int sumRow = 0;
			int [] sumCol = new int [m.length];
			n = 0;
			while (n<m.length) {
				sumCol[n] = 0;
				n++;
			}
			Statement stateMM=dmcon.createStatement();
			sqlMM = "SELECT DISTINCT mproj FROM prodmodel WHERE (mflag=1 or rflag=1) "; //限重點機種及3個月內有出貨或forecast
			if (sModelNo!=null && !sModelNo.equals("--")) { sqlMM = sqlMM + " AND mproj='"+sModelNo+"' "; }
			sqlMM = sqlMM + " ORDER BY mproj";
			PreparedStatement ps = con.prepareStatement(sqlMM);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				sumRow = 0;
				out.println("<tr>");
				out.println("<td><font face='Arial' size=-1 >"+rs.getString("mproj")+"</font></td>");
				n = 0;
				while (n<m.length) {
					//if (n<=9) {sn=sYearFr+"/"+sMonthFr+"/"+"0"+String.valueOf(n);}
					//else {sn=sYearFr+"/"+sMonthFr+"/"+String.valueOf(n);}
					String d1 = m[n][1].substring(0,4)+"/"+m[n][1].substring(4,6)+"/"+m[n][1].substring(6,8);
					String d2 = m[n][2].substring(0,4)+"/"+m[n][2].substring(4,6)+"/"+m[n][2].substring(6,8);
					//out.println(d1);
					sqlMM = "SELECT model,SUM(qty) as qty from mps "
					+ " WHERE m_date >='"+d1+"' AND m_date<='"+d2+"' AND model='"+rs.getString("mproj")+"'"
					+ " GROUP BY model";
					//out.println(sqlMM);
					ResultSet rsMM=stateMM.executeQuery(sqlMM);
					boolean rsMM_isEmpty = !rsMM.next();		
					boolean rsMM_hasData = !rsMM_isEmpty;
					if (rsMM_isEmpty) {
						out.println("<td align='right'><font face='Arial' size=-1 >"+"0"+"</font></td>");
					} else {
						out.println("<td align='right'><font face='Arial' size=-1 >"+rsMM.getString("qty")+"</font></td>");
						sumRow = sumRow + rsMM.getInt("qty");
						sumCol[n] = sumCol[n] + rsMM.getInt("qty");
					} // end if-else
					n++;

					rsMM.close();
				} //end of while 
				out.println("<td align='right' bgcolor='#99FFFF'><font face='Arial' size=-1 >"+sumRow+"</font></td>");
		
				out.println("</tr>");
			} // end while
			
			rs.close();
			ps.close();
			stateMM.close();
			n = 0;
			out.println("<tr bgcolor='#99FFFF'>");
			out.println("<td><strong><font face='Arial' size=-1 >"+"SUM"+"</font></strong></td>");
			while (n<m.length) {
				out.println("<td align='right'><strong><font face='Arial' size=-1 >"+sumCol[n]+"</font></strong></td>");
				n++;
			}
			out.println("</tr>");
		} catch (Exception ee) { out.println("Exception:"+ee.getMessage());		  
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
		}  // end try-catch
			
		%>
		
		</tr>
		
	</table>

</FORM>
</body>
</html>

<!--=============Process End==========-->
<%//@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->