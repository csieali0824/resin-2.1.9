<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*"%>
<%@ page import="java.text.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%

		String dateStringBegin=request.getParameter("DATEBEGIN");
		String dateStringEnd=request.getParameter("DATEEND");
		
		String dateSetBegin=request.getParameter("DATESETBEGIN");
		String dateSetEnd=request.getParameter("DATESETEND");
		
		
		String YearFr=request.getParameter("YEARFR");
		String MonthFr=request.getParameter("MONTHFR");
		String DayFr=request.getParameter("DAYFR");
			if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr+DayFr;
		
		String YearTo=request.getParameter("YEARTO");
		String MonthTo=request.getParameter("MONTHTO");
		String DayTo=request.getParameter("DAYTO");
			if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo+DayTo; 


%>

<meta http-equiv=Content-Type content="text/html; charset=big5">
</head>
<body>
<p><A href=""><STRONG>回首頁</STRONG></A> </p>
<form name=MYFORM > 
<table cellSpacing="1" borderColorDark="#99cc99" cellPadding="1" width="100%" align="left" borderColorLight="#ffffff" border="0">


 
<tr>
<td>
 <table cellSpacing='0' bordercolordark='#006666'  cellPadding='1' width='640' align='left' borderColorLight='#ffffff' border='1'>
  <tr>
    <td nowrap colspan="2"><font color="#006666" size="2"><strong>
 
      <jsp:getProperty name="rPH" property="pgCDate"/>
      </strong></font>
        <%
		//  String CurrYear = null;	     		 
	    // try
        // {       
        //  String a[]={"2006","2007","2008","2009","2010","2011","2012"};
        //  arrayComboBoxBean.setArrayString(a);
		//  if (YearFr==null)
		//  {
		//    CurrYear=dateBean.getYearString();
		//    arrayComboBoxBean.setSelection(CurrYear);
		//  } 
		//  else 
		//  {
		//    arrayComboBoxBean.setSelection(YearFr);
		//  }
	    //  arrayComboBoxBean.setFieldName("YEARFR");	   
        //  out.println(arrayComboBoxBean.getArrayString());		      		 
        // } //end of try
        // catch (Exception e)
        // {
        //  out.println("Exception  year:"+e.getMessage());
        // }
		//modify by Peggy 20150105
		try
		{     
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2006 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearFr==null?dateBean.getYearString():YearFr));
			arrayComboBoxBean.setFieldName("YEARFR");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}

		  String CurrMonth = null;	     		 
	     try
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
        <font color="#CC3366" size="2" face="Arial Black">&nbsp;</font> <font color="#CC3366" size="2" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayFr==null)
		  {
		    CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayFr);
		  }
	      arrayComboBoxBean.setFieldName("DAYFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#006666" size="2"><strong>
        <jsp:getProperty name="rPH" property="pgWorkOrder"/>  
        <jsp:getProperty name="rPH" property="pgCDate"/>  
        </strong></font>
        <%
		 // String CurrYearTo = null;	     		 
	     //try
         //{       
         // String a[]={"2007"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearTo==null)
		 // {
		 //   CurrYearTo=dateBean.getYearString();
		 //   arrayComboBoxBean.setSelection(CurrYearTo);
		 // } 
		 // else 
		 // {
		 //   arrayComboBoxBean.setSelection(YearTo);
		 // }
	      //arrayComboBoxBean.setFieldName("YEARTO");	   
          //out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         // out.println("Exception:"+e.getMessage());
         //}
		//modify by Peggy 20150105
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2006 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearTo==null?dateBean.getYearString():YearTo));
			arrayComboBoxBean.setFieldName("YEARTO");	
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}		 
       %>
        <%
		  String CurrMonthTo = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthTo==null)
		  {
		    CurrMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonthTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthTo);
		  }
	      arrayComboBoxBean.setFieldName("MONTHTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <%
		  String CurrDayTo = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayTo==null)
		  {
		    CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayTo);
		  }
	      arrayComboBoxBean.setFieldName("DAYTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
    </td>
    <td colspan="2">
      <INPUT name="button" TYPE="button" onClick='setSubmit("../jsp/TSCMfgWoQuery.jsp")'  value='<jsp:getProperty name="rPH" property="pgQuery"/>' align="middle" >
      <input type="reset" name="RESET" align="middle"  value='<jsp:getProperty name="rPH" property="pgReset"/>' onClick='setSubmit2("../jsp/TSCMfgWoQuery.jsp")' >
    </td>
  </tr>
  <tr>
    <td nowrap colspan="2"><font size='2'>工廠選擇 :</font>
      <select name="select">
    </select>
      <font size= '2'>製造部門選擇 :</font>
      <select name="select2">
      </select> </td>
    <td colspan="2">&nbsp;</td>
  </tr>
</table>
</td>
</tr>
<br>
<tr>
<td>
<table width="700" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark='#FFFFFF'>
<tr bgcolor="#99CC99">
<td width="100"><font size='2' color='#006666' face='Arial'>製造單位</font></td>
<td width="150"><font size='2' color='#006666' face='Arial'>Package分類</font></td>
<td width="150"><font size='2' color='#006666' face='Arial'>最高產能</font></td>
<td width="100"><font size='2' color='#006666' face='Arial'>工廠產能</font></td>
<td width="100"><font size='2' color='#006666' face='Arial'>剩餘產能</font></td>
<td width="100"><font size='2' color='#006666' face='Arial'>滿載率</font></td>
<td width="100"><font size='2' color='#006666' face='Arial'>按時達成率</font></td>
</tr>

<%
			String sql =" select f.packge_id , f.packages , f.dep_name ,f.cap_max,f.wo_qty,f.cap_max-f.wo_qty reminder, "+
						" round((f.wo_qty/f.cap_max)*100,2) ||'%' percent  from  "+
						" (select  to_number(tafm.s_packge_id) packge_id,tcu.packages packages, "+
						" tcu.mfg_dept_name dep_name,tcu.cap_max,sum(tafm.s_wo_qty) wo_qty "+
						" from ( select distinct mfg_dept_no,packages,mfg_dept_name,cap_max   "+
						" from  oraddman.tsdnrfq_capacity_upload tcu  "+
						" ) tcu , tsc_analysis_factory_make tafm "+
						" where tcu.packages = tafm.s_packge "+
						" group by tcu.packages,tcu.mfg_dept_name,tcu.cap_max, to_number(tafm.s_packge_id) "+
						" order by tcu.mfg_dept_name, to_number(tafm.s_packge_id)	) f "+
						" order by to_number(f.packge_id)  ";




			//" select s_max_capacity,s_order_total,s_wip_reminder,s_fullload_rate, "+
			//" s_complete_rate,s_packge,s_dept_name,s_creation_date from tsc_factory_make_analysis";
			
 			String S_Max_Capacity = "";
			String S_Order_Total = "";
			String S_Wip_Reminder = "";
			String S_Fullload_Rate = "";
			String S_Complete_Rate = "";
			String S_Packge	="";
			String S_Dept_Name ="";
			//String S_Dept_Realname ="";
			int row_Color = 1;
			String colorStr = ""; 
			String S_Wo_Qty = "";

			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next())
			{
				S_Packge= rs.getString("packages");
				S_Max_Capacity = rs.getString("cap_max");
 
				S_Wip_Reminder = rs.getString("reminder");
				S_Fullload_Rate = rs.getString("percent");
 
				S_Wo_Qty = rs.getString("wo_qty");
				S_Dept_Name = rs.getString("dep_name");
 
				 if ((row_Color % 2) == 0){
				   colorStr = "#ffffff";
				 }
				else{ colorStr = "#DDF7F4"; }
				
				 
				out.println("<tr bgcolor="+colorStr+">"); 
				out.println("<td><div align='left'><font size='2' color='#006666' face='Arial'>"+S_Dept_Name+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='left'><font size='2' color='#006666' face='Arial'>"+S_Packge+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+S_Max_Capacity+"&nbsp;KPC</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+S_Wo_Qty+"&nbsp;KPC</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+S_Wip_Reminder+"&nbsp;KPC</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+S_Fullload_Rate+"</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+S_Complete_Rate+"&nbsp;</font></div></td>"); 
				out.println("</tr>"); 
				row_Color =row_Color+1;


			}  // End of while
				rs.next();
				statement.close(); 


%>
</table>
</td>
</tr> 
	<tr>
		<td>
			<table>
				<%//@ include file="/jsp/TSWipMakeAnalysisRateChart.jsp"%>	
			</table> 
		</td>
	</tr>
</table>



</TABLE>
</form>
                    

</body>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>