<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.math.*"%>
<%@ page import="java.text.*" %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>

<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<META http-equiv=Content-Type content="text/html; charset=big5">

</HEAD>
<BODY>

 <!--<link href="/jsp/images/website.css" rel="stylesheet" type="text/css">-->
<p><A href=""><STRONG>回首頁</STRONG></A> </p>
<form name="form1"  METHOD="post"> 
<table  cellSpacing="1" borderColorDark="#99cc99" cellPadding="1" width="100%" align="left" borderColorLight="#ffffff" border="0">
<%
	String searchCondition =request.getParameter("searchCondition");
	
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

	String s_Group_Master_Name = request.getParameter("s_Group_Master_Name");
	String sqlTotalQty  = "";
	String sql = "";
	//String s_Group_Master_Name ="";
	String s_Group_Name1 = request.getParameter("s_Group_Name1");
	String s_Group_Name = "";
	String s_Wo_Qty = "";
	String s_Wo_Qty2 = "";
	String s_Package = "";
	String valueTotalQty = "";
	String colorStr  = "";
	int row_Color = 1;


%>

<tr>
<td>
 <table cellSpacing='0' bordercolordark='#006666'  cellPadding='1' width='640' align='left' borderColorLight='#ffffff' border='1'>
  <tr>
    <td nowrap colspan="2"><font color="#006666" size="2"><strong>預計出貨日起</strong></font>
        <%
		 // String CurrYear = null;	     		 
	     //try
         //{       
         // String a[]={"2006","2007","2008","2009","2010","2011","2012"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearFr==null)
		 // {
		 //   CurrYear=dateBean.getYearString();
		 //   arrayComboBoxBean.setSelection(CurrYear);
		 // } 
		 // else 
		 // {
		 //   arrayComboBoxBean.setSelection(YearFr);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARFR");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         // out.println("Exception  year:"+e.getMessage());
         //}
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
        預計出貨日
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
	     // arrayComboBoxBean.setFieldName("YEARTO");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
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
       %>    </td>
    <td colspan="2">
          </td>
  </tr>
  <tr>
    <td nowrap colspan="2"><font size= '2'>業務區域 :</font>
		<%

		 Statement st2=con.createStatement();
		 ResultSet rs2=null;
		 String sql2 = "select distinct s_Group_Master_Name,s_Group_Master_Name from  tsc_analysis_sales_areademand	 ";   //要傳兩個變數
		 rs2 = st2.executeQuery(sql2);
		 comboBoxBean.setRs(rs2);
		 comboBoxBean.setSelection(s_Group_Master_Name);
		 comboBoxBean.setFieldName("s_Group_Master_Name");	   
		 out.println(comboBoxBean.getRsString());				    
			rs2.close();   
			st2.close();     	
	%> 	  
 
    <td colspan="2">&nbsp;</td>
  </tr>
</table>
</td>
</tr>
<tr>
<td>


<%

	


		//searchCondition ="Master";
	if(searchCondition=="Detail" || searchCondition.equals("Detail")){


			sqlTotalQty = " select sum(s_demond_qty) totalqty "+
						  " from tsc_analysis_sales_areademand "+
						  " where  S_GROUP_NAME = '"+s_Group_Name1+"'";
			
			Statement statement1 =con.createStatement();
			ResultSet rs1=statement1.executeQuery(sqlTotalQty);

			while (rs1.next())
			{
					valueTotalQty = rs1.getString("totalqty");
			} 
				rs1.next();
				statement1.close(); 


			sql = 	"	select s_group_master_name,s_group_name,to_number(s_package_id),s_package, "+
					" 	decode(sum(s_demond_qty),null,0, sum(s_demond_qty)) S_DEMOND_QTY "+
					"	from  tsc_analysis_sales_areademand		"+
					"	WHERE S_GROUP_NAME = '"+s_Group_Name1+"'	"+
					"	group by s_package,s_group_master_name,s_group_name,to_number(s_package_id) "+
					"	order by to_number(s_package_id), s_group_name,s_group_master_name ";




				out.println("<table width='520' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#999999' bordercolordark='#FFFFFF'>");
				out.println("<tr bgcolor='#FFCC99'><td bgcolor='#FFCC99' colspan='5'><div align='right'><font size ='3'color='#006666' face='Arial'>業務區域:"+s_Group_Name1+".總訂購數為&nbsp;:&nbsp;"+valueTotalQty+"</font></div></td></tr>");
				out.println("<tr bgcolor='#99CC99'>");
				out.println("<td bgcolor='#FFCC99' width='80'><div align='left'><font size='2' color='#006666' face='Arial'>業務總區域</font></div></td>");
				out.println("<td bgcolor='#FFCC99' width='80'><div align='left'><font size='2' color='#006666' face='Arial'>業務分區</font></div></td>");
				out.println("<td bgcolor='#FFCC99' width='100'><div align='right'><font size='2' color='#006666' face='Arial'>產品名稱</font></div></td>");
				out.println("<td bgcolor='#FFCC99' width='60'><div align='right'><font size='2' color='#006666' face='Arial'>需求數量</font></div></td>");
				out.println("<td bgcolor='#FFCC99' width='80'><div align='right'><font size='2' color='#006666' face='Arial'>完成狀態</font></div></td>");
				out.println("</tr>");

			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next())
			{
				
				s_Group_Master_Name = rs.getString("s_group_master_name");
				s_Group_Name =  rs.getString("S_GROUP_NAME");
				s_Wo_Qty  =    new java.text.DecimalFormat("#,###.#").format(Double.parseDouble(rs.getString("S_DEMOND_QTY")));
				s_Package = rs.getString("s_Package");
				 if ((row_Color % 2) == 0){
				   colorStr = "#D8E6E7";
				 }
				else{ colorStr = "#BBD3E1"; }
				
				//String num = "1234567";   
				//String format1 = new java.text.DecimalFormat("#,##0.##").format(Double.parseDouble(num));   
				//out.print(format1);   

				
				//out.println("S_Wo_Qty"+S_Wo_Qty+"<br>");
				//out.println("valueTotalQty"+valueTotalQty+"<br>");
				//out.println("valueTotalQty2"+(S_Wo_Qty/valueTotalQty)+"<br>");
				out.println("<tr bgcolor="+colorStr+">"); 
				out.println("<td><div align='left'><font size='2' color='#006666' face='Arial'>"+s_Group_Master_Name+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='left'><font size='2' color='#006666' face='Arial'>"+s_Group_Name+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+s_Package+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+s_Wo_Qty+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>&nbsp;</font></div></td>"); 
				out.println("</tr>"); 
				row_Color =row_Color+1;
			}  // End of while
				rs.next();
				statement.close(); 
			out.println("</table></td></tr></table>");
	} else if(searchCondition=="Master" || searchCondition.equals("Master")   ||   searchCondition == null   ) {

			sqlTotalQty = " select sum(s_demond_qty) totalqty "+
						  " from tsc_analysis_sales_areademand ";
			
			Statement statement1 =con.createStatement();
			ResultSet rs1=statement1.executeQuery(sqlTotalQty);

			while (rs1.next())
			{
					valueTotalQty = rs1.getString("totalqty");
			} 
				rs1.next();
				statement1.close(); 

			
			sql = " select s_group_master_name,s_group_name,sum(s_demond_qty) S_DEMOND_QTY "+
						" from tsc_analysis_sales_areademand "+
						" group by s_group_master_name,s_group_name "+
						" order by  S_DEMOND_QTY desc ";
						
				//" select s_group_master_name ,s_package,to_number(s_package_id),sum(s_demond_qty) "+
				//" from tsc_analysis_sales_areademand "+
				//" group by s_package,s_group_master_name,to_number(s_package_id) "+
				//" order by s_group_master_name,to_number(s_package_id) ";
			

			out.println("<table width='520' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#999999' bordercolordark='#FFFFFF'>");
			out.println("<tr bgcolor='#FFCC99'><td bgcolor='#FFCC99' colspan='6'><div align='right'><font size ='3' color = '#ffffff'>全業務區總訂購數為&nbsp;:&nbsp;"+valueTotalQty+"</font></div></td></tr>");
			out.println("<tr bgcolor='#99CC99'>");
			out.println("<td bgcolor='#FFCC99' width='80'><div align='left'><font size='2' color='#006666' face='Arial'>業務總區域</font></div></td>");
			out.println("<td bgcolor='#FFCC99' width='80'><div align='left'><font size='2' color='#006666' face='Arial'>業務分區</font></div></td>");
			out.println("<td bgcolor='#FFCC99' width='100'><div align='right'><font size='2' color='#006666' face='Arial'>產品需求總量</font></div></td>");
			out.println("<td bgcolor='#FFCC99' width='100'><div align='right'><font size='2' color='#006666' face='Arial'>佔總需求比例</font></div></td>");
			out.println("<td bgcolor='#FFCC99' width='60'><div align='right'><font size='2' color='#006666' face='Arial'>細節連結</font></div></td>");
			out.println("<td bgcolor='#FFCC99' width='100'><div align='right'><font size='2' color='#006666' face='Arial'>延遲工單連結</font></div></td>");
			out.println("</tr>");

			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next())
			{
				s_Group_Master_Name = rs.getString("s_group_master_name");
				s_Group_Name = rs.getString("S_GROUP_NAME");
				s_Wo_Qty  = rs.getString("S_DEMOND_QTY");
				s_Wo_Qty2  =   new java.text.DecimalFormat("#,##0.##").format(Double.parseDouble(s_Wo_Qty));
				BigDecimal bd = new BigDecimal(( Float.parseFloat(s_Wo_Qty)/Float.parseFloat(valueTotalQty))*100 );
				bd = bd.setScale(2,BigDecimal.ROUND_HALF_UP);
				 if ((row_Color % 2) == 0){
				   colorStr = "#D8E6E7";
				 }
				else{ colorStr = "#BBD3E1"; }
				
				//out.println("S_Wo_Qty"+S_Wo_Qty+"<br>");
				//out.println("valueTotalQty"+valueTotalQty+"<br>");
				//out.println("valueTotalQty2"+(S_Wo_Qty/valueTotalQty)+"<br>");
				out.println("<tr bgcolor="+colorStr+">"); 
				out.println("<td><div align='left'><font size='2' color='#006666' face='Arial'>"+s_Group_Master_Name+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='left'><font size='2' color='#006666' face='Arial'>"+s_Group_Name+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+s_Wo_Qty2+"&nbsp;</font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>"+bd+"&nbsp;%</font></div></td>"); 
				//out.println("<td><div align='right'><font size='2'><INPUT TYPE='button'  value='...' onClick='subDetail('Detail',"+'"'+s_Group_Name+'"'+")'></font></div></td>");
				out.println("<td><div align='center'><font size='2' color='#006666' face='Arial'><a href='TSWipanAlysisSaleAreaDataPage.jsp?searchCondition=Detail&s_Group_Name1="+s_Group_Name+"' ><img src='../image/docLink.gif' width='16' height='16'></a></font></div></td>"); 
				out.println("<td><div align='right'><font size='2' color='#006666' face='Arial'>&nbsp;</font></div></td>"); 
				out.println("</tr>"); 
				row_Color =row_Color+1;
			}  // End of while
				rs.next();
				statement.close(); 
			out.println("</table></td></tr></table>");	} else {
		out.println("No Seach Condition!");
	}
			
			
			
%>

</table>


</form>
</body>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>