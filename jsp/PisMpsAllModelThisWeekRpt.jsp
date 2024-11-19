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
<FORM ACTION="../jsp/PisMpsAllModelThisWeekRpt.jsp" METHOD="post" NAME="MYFORM" >
    <%
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO"); 
		String sYearFr=request.getParameter("YEARFR");
		String sMonthFr=request.getParameter("MONTHFR"); 
		//out.println(sModelNo+sYearFr+sMonthFr);
	
		int iYearSelect;
		int iMonthSelect;
		int iMaxMonthDays;
		
		if (sYearFr==null || sYearFr.equals("--")) { 
			sYearFr = dateBean.getYearString();
			iYearSelect = dateBean.getYear();
		} else iYearSelect = Integer.parseInt(sYearFr);
		
		if (sMonthFr==null || sMonthFr.equals("--")) {
			sMonthFr = dateBean.getMonthString();
			iMonthSelect = dateBean.getMonth();
		} else iMonthSelect = Integer.parseInt(sMonthFr);
		
		iMaxMonthDays = dateBean.getMonthMaxDay();
		//out.println(iMaxMonthDays);
		
		//今天是第幾週, 日期起迄
		String week = workingDateBean.getWeekString();
		String weekDateFr = workingDateBean.getFirstDateOfWorkingWeek();
		String weekDateTo = workingDateBean.getLastDateOfWorkingWeek();
		//out.println("current week:"+week+" week date:"+weekDateFr+"~"+weekDateTo);
		dateBean.setDate(Integer.parseInt(weekDateFr.substring(0,4)),Integer.parseInt(weekDateFr.substring(4,6)),Integer.parseInt(weekDateFr.substring(6,8)));
		String w [] = new String [7];
		w[0] = dateBean.getYearMonthDay();
		for (int i=1;i<7;i++) {
			dateBean.setAdjDate(1);
			w[i] = dateBean.getYearMonthDay();
			//out.println(w[i]);
		}
		
		//這個月有幾週, 日期起迄
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
		
		String s1 = "''"; // 本月有forecast
		String s2 ="''"; // 本月有排MPS
		
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
						
						Statement stateModel=con.createStatement();
						ResultSet rsModel=null;
						/*
						sSqlModel = "select DISTINCT f.fmprjcd as fmprjcd from PSALES_FORE_MONTH f,prodmodel m "
						+" where f.FMCOUN='886' AND f.fmqty>0 "+" and f.FMTYPE='001' " //FMTYPE=001表示為SALES
						+" and f.FMYEAR='"+sYearFr+"' AND f.FMMONTH='"+sMonthFr+"' " 
						+" and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)"
						+" and f.fmprjcd=m.mproj AND f.fmcolor=m.mcolor AND f.fmcoun=m.mcountry ";
						*/
						//不考慮顏色的問題
						sSqlModel = "select DISTINCT f.fmprjcd as fmprjcd from PSALES_FORE_MONTH f "
						+" where f.FMCOUN='886' AND f.fmqty>0 "+" and f.FMTYPE='001' " //FMTYPE=001表示為SALES
						+" and f.FMYEAR='"+sYearFr+"' AND f.FMMONTH='"+sMonthFr+"' " 
						+" and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)";
						//out.println(sSqlModel);
						rsModel = stateModel.executeQuery(sSqlModel);
						while (rsModel.next()) { s1 = s1 + ",'"+rsModel.getString("fmprjcd")+"'"; }
						rsModel.close();
						//out.println("F="+s1);
						
						
						sSqlModel = "SELECT DISTINCT model as model from mps "
						+ " WHERE mdate >="+sYearFr+sMonthFr+"01"+" AND mdate<"+sYearFr+sMonthFr+"31";
						//out.println(sqlMM);
						PreparedStatement ps = dmcon.prepareStatement(sSqlModel);
						ResultSet rs = ps.executeQuery();
						while (rs.next()) { s2 = s2 + ",'"+rs.getString("model")+"'"; }
						rs.close();
						ps.close();
						//out.println("P="+s2);
						
						sSqlModel = "SELECT DISTINCT mproj FROM prodmodel WHERE mcountry='886' AND (mproj IN ("+s1+") OR mproj IN ("+s2+")) ORDER BY mproj ";
						//out.println(sSqlModel);
						
						rsModel=stateModel.executeQuery(sSqlModel);
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
			<td><strong><font face="Arial" size="-1">當月銷售預測</font></strong></td>
			<td><strong><font face="Arial" size="-1">本月本週之前合計</font></strong></td>
				<%
					for (int i=0;i<7;i++) {				
						out.println("<td align='center'><font face='Arial' size=-1 ><strong>"+w[i]+"</strong></font></td>");
					} // end for
					
				%>
			<td><strong><font face="Arial" size="-1">本月本週之後合計</font></strong></td>
			<td><strong><font face="Arial" size="-1">本月合計</font></strong></td>
		</tr>	
		
		<%
		try {
						
			int sumRow = 0;
			int cols = 10;
			int [] sumCol = new int [cols];
			for (int i=0;i<cols;i++) { sumCol[i] = 0;}

			String sqlMM = "";
			Statement stateMM=dmcon.createStatement();
			ResultSet rsMM=null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			//取得顯示model
			sqlMM = "SELECT DISTINCT mproj FROM prodmodel WHERE mcountry='886' "; //限台灣規
			if (sModelNo!=null && !sModelNo.equals("--")) { sqlMM = sqlMM + " AND mproj='"+sModelNo+"' "; 
			} else { sqlMM = sqlMM + " AND ( mproj IN ("+s1+") OR mproj IN ("+s2+") )"; //限有forecast或排MPS
			}
			sqlMM = sqlMM + " ORDER BY mproj";
			//out.println(sqlMM);
			ps = con.prepareStatement(sqlMM);
			rs = ps.executeQuery();
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td><font face='Arial' size=-1 >"+rs.getString("mproj")+"</font></td>");
				//當月銷售預測
				String color = "''";
				PreparedStatement psColor = con.prepareStatement("SELECT DISTINCT mcolor FROM prodmodel WHERE mcountry='886' AND mproj='"+rs.getString("mproj")+"'");
				ResultSet rsColor = psColor.executeQuery();
				//if (rsColor.next()) { color = "'"+rsColor.getString("mcolor")+"'"; }
				while (rsColor.next()) { color = color +",'"+rsColor.getString("mcolor")+"'"; }
				rsColor.close();
				psColor.close();
				sqlMM = "select SUM(f.FMQTY)*1000 as qty from PSALES_FORE_MONTH f "
				+" where f.FMCOUN='886' and f.FMPRJCD='"+rs.getString("mproj")+"' "
				+" and f.FMYEAR='"+sYearFr+"' AND f.FMMONTH='"+sMonthFr+"'"
				+" and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)"
				+" and f.FMTYPE='001' " ; //FMTYPE=001表示為SALES
				//+" and f.fmcolor IN ("+color+") "
				//out.println(sqlMM);
				Statement stWS=con.createStatement();
				ResultSet rsWS=stWS.executeQuery(sqlMM);
				if (rsWS.next()) {
					if (rsWS.getString("qty")==null) {
						out.println("<td align='right' bgcolor='#99FFCC'><font face='Arial' size='-1'>0</font></td>");
					} else {
						out.println("<td align='right' bgcolor='#99FFCC'><font face='Arial' size='-1'>"+rsWS.getString("qty")+"</font></td>");
						sumCol[0] = sumCol[0] + rsWS.getInt("qty");
					}
				} else { out.println("<td align='right' bgcolor='#99FFCC'><font face='Arial' size='-1'>0</font></td>");
				}
				rsWS.close();
				stWS.close();
				
				sumRow = 0;
				//本月本週之前合計
				sqlMM = "SELECT model,sum(qty) as qty from mps "
				+ " WHERE mdate >="+sYearFr+sMonthFr+"01"+" AND mdate<"+weekDateFr+" AND model='"+rs.getString("mproj")+"' group by model ";
				//out.println(sqlMM);
				rsMM=stateMM.executeQuery(sqlMM);
				if (rsMM.next()) {
					if (rsMM.getString("qty")==null) {
						out.println("<td align='right'><font face='Arial' size='-1'>0</font></td>");
					} else {
						out.println("<td align='right'><font face='Arial' size='-1'>"+rsMM.getString("qty")+"</font></td>");
						sumRow = sumRow + rsMM.getInt("qty");
						sumCol[1] = sumCol[1] + rsMM.getInt("qty");
					}
				} else { out.println("<td align='right'><font face='Arial' size='-1'>0</font></td>");
				}
				rsMM.close();
				//本月本週
				sqlMM = "SELECT model,mdate,sum(qty) as qty from mps "
				+ " WHERE mdate >="+weekDateFr+" AND mdate<="+weekDateTo+" AND model='"+rs.getString("mproj")+"' group by model,mdate ";
				//out.println(sqlMM);
				rsMM=stateMM.executeQuery(sqlMM);
				boolean rsMM_hasData = rsMM.next();
				boolean rsMM_isEmpty = !rsMM_hasData;
				for (int i=0;i<7;i++) {
					if (rsMM_isEmpty) {
						out.println("<td align='right' bgcolor='#FFFF99'><font face='Arial' size=-1 >"+"0"+"</font></td>");
					} else {
						if (w[i].equals(rsMM.getString("mdate"))) {
							out.println("<td align='right' bgcolor='#FFFF99'><font face='Arial' size=-1 >"+rsMM.getString("qty")+"</font></td>");
							sumRow = sumRow + rsMM.getInt("qty");
							sumCol[i+2] = sumCol[i+2] + rsMM.getInt("qty");
							rsMM_hasData = rsMM.next(); rsMM_isEmpty = !rsMM_hasData;
						} else {
							out.println("<td align='right' bgcolor='#FFFF99'><font face='Arial' size=-1 >"+"0"+"</font></td>");
						} // end if-else
					} // end if-else
				} // end for
				rsMM.close();
				//本月本週之後合計
				sqlMM = "SELECT model,sum(qty) as qty from mps "
				+ " WHERE mdate>"+weekDateTo+" AND mdate<="+sYearFr+sMonthFr+iMaxMonthDays+" AND model='"+rs.getString("mproj")+"' group by model ";
				//out.println(sqlMM);
				rsMM=stateMM.executeQuery(sqlMM);
				if (rsMM.next()) {
					if (rsMM.getString("qty")==null) {
						out.println("<td align='right'><font face='Arial' size='-1'>0</font></td>");
					} else {
						out.println("<td align='right'><font face='Arial' size='-1'>"+rsMM.getString("qty")+"</font></td>");
						sumRow = sumRow + rsMM.getInt("qty");
						sumCol[9] = sumCol[9] + rsMM.getInt("qty");
					}
				} else { out.println("<td align='right'><font face='Arial' size='-1'>0</font></td>");
				}
				rsMM.close();
				
				out.println("<td align='right' bgcolor='#99FFFF'><strong><font face='Arial' size=-1 >"+sumRow+"</font></strong></td>");
				
				out.println("</tr>");
			} // end while
			rs.close();
			ps.close();
			stateMM.close();
			out.println("<tr>");
			out.println("<td><strong><font face='Arial' size=-1 >總計</font></strong></td>");
			sumRow = 0;
			out.println("<td align='right' bgcolor='#99FFCC'><strong><font face='Arial' size=-1 >"+sumCol[0]+"</font></strong></td>");
			for (int i=1;i<cols;i++) {
				out.println("<td align='right' bgcolor='#99FFFF'><strong><font face='Arial' size=-1 >"+sumCol[i]+"</font></strong></td>");
				sumRow = sumRow + sumCol[i];
			} // end for
			out.println("<td align='right' bgcolor='#99FFFF'><strong><font face='Arial' size=-1 >"+sumRow+"</font></strong></td>");
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