<!-- 20180919 Peggy,CS同仁依所屬業務區顯示查詢結果及維護資料-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setQuery()
{ 
	if (document.MYFORM.txt_year.length !=4)
	{
		alert("請確認年度是否正確!");
		return false;
	}
 	document.MYFORM.submit();
}
function setSubmit(URL)
{ 
	var chk_cnt =0;
	if (document.MYFORM.txt_ship_from.value==null || document.MYFORM.txt_ship_from.value =="" || document.MYFORM.txt_ship_from.value=="--")
	{
		alert("請選擇Ship From!");
		return false;
	}
	for (var i =0 ; i < document.MYFORM.chk.length ;i++)
	{
		if (document.MYFORM.chk[i].checked)
		{
			if (document.MYFORM.chk[i].value.substring(0,4) != document.MYFORM.txt_year.value)
			{
				alert("年度不符,請重新確認!");
				return false;
			}
			chk_cnt ++;
		}
	}
	if (chk_cnt ==0)
	{	
		alert("請選擇出貨日!");
		return false;
	}
	document.MYFORM.btnSave.disabled =true;
	document.MYFORM.btnClear.disabled =true;
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function clearAll()
{
	if (confirm("您確定要清除畫面資料?"))
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked=false;
			document.getElementById(i+1).style.backgroundColor ="#FFFFFF";
		}
	}
}
function onCheck(v_id)
{
	if (document.MYFORM.chk[v_id-1].checked)
	{
		document.MYFORM.chk[v_id-1].checked=false;
		document.getElementById(v_id).style.backgroundColor ="#FFFFFF";
	}
	else
	{
		document.MYFORM.chk[v_id-1].checked=true;
		document.getElementById(v_id).style.backgroundColor ="#CCFF66";
	}
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
  .style1  {font-family:Tahoma,Georgia;font-size:12px; color:#000000}  
</STYLE>
<title>TSC Delivery Schedule</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSCDeliveryScheduleUpdate.jsp" METHOD="POST"> 
<%
String delivery_schedule_id = request.getParameter("DELIVERY_ID");
if (delivery_schedule_id==null) delivery_schedule_id="";
String txt_year=request.getParameter("txt_year");
if (txt_year==null) txt_year=dateBean.getYearString();
String txt_ship_from=request.getParameter("txt_ship_from");
if (txt_ship_from==null) txt_ship_from="";
String txt_sales_region =request.getParameter("txt_sales_region");
if (txt_sales_region==null) txt_sales_region="";
String shipping_method =request.getParameter("shipping_method");
if (shipping_method==null) shipping_method="";
String ATYPE=request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="NEW";
String v_yymm="",s_id="",s_chk="",s_td="",sql="",s_style="";
int icnt=0,col_num=4,i_mon_week=0,obj_id=0;

if (ATYPE.equals("UPDATE"))
{
	sql = " select * from  oraddman.tsc_delivery_schedule_header where DELIVERY_SCHEDULE_ID=?";
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,delivery_schedule_id);
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{	
		txt_year = rs1.getString("DELIVERY_YEAR");
		txt_ship_from = rs1.getString("SHIP_FROM");
		txt_sales_region = rs1.getString("SALES_REGION");
		if (txt_sales_region==null) txt_sales_region="";
		shipping_method = rs1.getString("SHIPPING_METHOD");
		if (shipping_method==null) shipping_method="";
	}
	rs1.close();
	statement1.close();
}
%>
<table align="center" width="100%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">TSC Delivery Schedule Setup</font></strong>
		</td>
	</tr>
	<td>&nbsp;</td></TR>
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF" width="100%">
				<tr>
					<td style="font-family:Tahoma,Georgia;font-size:12px;" width="6%">Year：</td>
					<td width="7%" colspan="4"><input type="text" name="txt_year" value="<%=txt_year%>" class="style1" size="5" onBlur="setQuery()" <%=(ATYPE.equals("UPDATE")?" disabled":"")%>>(輸入年度後,請按下Enter鍵更新日曆)</td>
					<td colspan="7">&nbsp;</td>
				</tr>
				<tr>
					<td width="6%" style="font-family:Tahoma,Georgia;font-size:12px;">Ship From：</td>
					<td width="7%">
					<%
					try
					{
						sql = " select distinct A_VALUE,A_VALUE from oraddman.tsc_rfq_setup where A_CODE='V_SHIP_PLANT'";
						if (ATYPE.equals("UPDATE")) sql += " AND A_VALUE='"+ txt_ship_from+"'";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(txt_ship_from);
						comboBoxBean.setFieldName("txt_ship_from");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>
					</td>
					<td width="7%" style="font-family:Tahoma,Georgia;font-size:12px;">Sales Region：</td>
					<td width="8%">
					<%
					try
					{   
						sql = "select MASTER_GROUP_NAME,MASTER_GROUP_NAME from tsc_om_group_master a where a.ORG_ID=41";
						if (ATYPE.equals("UPDATE"))
						{
							sql += " AND MASTER_GROUP_NAME='"+ txt_sales_region+"'";
						}
						else if (UserRoles.indexOf("Delivery_Schedule_CS")>0)
						{
					  		sql += " and exists (select 1 from oraddman.tsrecperson b, oraddman.tssales_area c"+
                   	               " where b.USERNAME='"+UserName+"'"+
								   " and b.TSSALEAREANO=c.SALES_AREA_NO"+
					               " and c.ALNAME=a.MASTER_GROUP_NAME)";						
						}
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(txt_sales_region);
						comboBoxBean.setFieldName("txt_sales_region");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();      	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					} 	
					%>
					</td>
					<td width="8%" style="font-family:Tahoma,Georgia;font-size:12px;">Shipping Method：</td>
					<td width="11%">
					<%
					try
					{   
						sql = "SELECT SHIPPING_METHOD,SHIPPING_METHOD FROM ASO_I_SHIPPING_METHODS_V ";
						if (ATYPE.equals("UPDATE")) sql += " where SHIPPING_METHOD='"+ shipping_method+"'";
						sql += "  ORDER BY 1";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(shipping_method);
						comboBoxBean.setFieldName("shipping_method");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();      	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception:"+e.getMessage()); 
					} 	
					%>					
					</td>
					<td width="5%" align="center"><input type="button" name="btnSave" value="Save" style="font-family: Tahoma,Georgia;font-size:12px" onClick="setSubmit('../jsp/TSCDeliveryScheduleProcess.jsp')"></td>
					<td width="5%" align="center"><input type="button" name="btnClear" value="Clear All" style="font-family: Tahoma,Georgia;font-size:12px" onClick="clearAll()"></td>
					<td align="right" width="40%"><a href="TSCDeliveryScheduleQuery.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a> &nbsp;&nbsp;&nbsp;<A href="/oradds/ORADDSMainMenu.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>註1:日曆紅字表示台灣放假日 &nbsp;&nbsp;
		    註2:出貨日在日曆上以綠底標示
		</td>
	</tr>
	<%
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
				
	sql = " select  m.V_YM"+
	      ",V_END_MONTH"+
		  ",V_WEEK_OF_MONTH"+
		  ",V_WEEK"+
		  ",V_SUN"+
		  ",NVL(n.SUN_ON,'') SUN_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_SUN),'N') SUN_CHK"+
          ",V_MON"+
		  ",NVL(n.MON_ON,'') MON_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_MON),'N') MON_CHK"+
          ",V_TUE"+
		  ",NVL(n.TUE_ON,'') TUE_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_TUE),'N') TUE_CHK"+
          ",V_WED"+
		  ",NVL(n.WED_ON,'') WED_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_WED),'N') WED_CHK"+
          ",V_THU"+
		  ",NVL(n.THU_ON,'') THU_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_THU),'N') THU_CHK"+
          ",V_FRI"+
		  ",NVL(n.FRI_ON,'') FRI_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_FRI),'N') FRI_CHK"+
          ",V_SAT"+
		  ",NVL(n.SAT_ON,'') SAT_ON"+
          ",NVL((select 'Y' from oraddman.tsc_delivery_schedule_lines n where DELIVERY_SCHEDULE_ID=? and to_char(DELIVERY_SCHEDULE_DATE,'yyyymm')=v_ym and TO_NUMBER(to_char(DELIVERY_SCHEDULE_DATE,'dd'))=V_SAT),'N') SAT_CHK"+
          " from (SELECT V_YM"+
	      ",TO_CHAR(TO_DATE(V_YM||'01','YYYYMMDD'),'MONTH') V_END_MONTH"+
		  ",V_WEEK_OF_MONTH"+
		  ",SUM(CASE WHEN SUM(SUN)>0 OR SUBSTR(V_YM,5,2) ='01' AND V_WEEK_OF_MONTH=1 THEN 1 ELSE 0 END) OVER ( PARTITION BY SUBSTR(V_YM,1,4) ORDER BY V_YM,V_WEEK_OF_MONTH) V_WEEK"+
		  ",SUM(SUN) V_SUN"+
		  ",SUM(MON) V_MON"+
		  ",SUM(TUE) V_TUE"+
		  ",SUM(WED) V_WED"+
		  ",SUM(THU) V_THU"+
		  ",SUM(FRI) V_FRI"+
		  ",SUM(SAT) V_SAT"+
		  " FROM ( SELECT TO_CHAR(I_YEAR+ROWNUM-1,'YYYYMM') V_YM "+
		  "        ,TRUNC ((TO_CHAR (I_YEAR+ROWNUM-1, 'DD') + MOD (( TO_CHAR (I_YEAR+ROWNUM-1, 'J') + 2 - TO_CHAR (I_YEAR+ROWNUM-1, 'DD')),7)+ 6)/ 7) V_WEEK_OF_MONTH"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'SUN' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END SUN"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'MON' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END MON"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'TUE' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END TUE"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'WED' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END WED"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'THU' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END THU"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'FRI' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END FRI"+
		  "        ,CASE SUBSTR(TO_CHAR(I_YEAR+ROWNUM-1,'DAY'),1,3) WHEN 'SAT' THEN TO_CHAR(I_YEAR+ROWNUM-1,'DD') ELSE '' END SAT"+
		  "        FROM (SELECT to_date(?,'yyyymmdd') I_YEAR from dual) CONNECT BY  ROWNUM<=add_months(trunc(to_date(?,'yyyymmdd')),12) - trunc(to_date(?,'yyyymmdd'))) X "+
		  " GROUP BY V_YM,V_WEEK_OF_MONTH"+
		  " ORDER BY V_YM,V_WEEK_OF_MONTH) m,(SELECT * FROM bom_calendar_weeks_view  WHERE CALENDAR_CODE='TSC_AHR' AND YEAR=?)  n"+
         " where SUBSTR(m.V_YM,1,4)=n.YEAR(+)"+
         " and TO_NUMBER(substr(m.V_YM,5,2))=n.MONTH_NUM(+)"+
         " AND m.V_WEEK_OF_MONTH=n.WEEK(+)"+
         " ORDER BY V_YM,V_WEEK";
	//out.println(sql);
	//out.println(txt_year+"0101");
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,delivery_schedule_id);
	statement.setString(2,delivery_schedule_id);
	statement.setString(3,delivery_schedule_id);
	statement.setString(4,delivery_schedule_id);
	statement.setString(5,delivery_schedule_id);
	statement.setString(6,delivery_schedule_id);
	statement.setString(7,delivery_schedule_id);
	statement.setString(8,txt_year+"0101");
	statement.setString(9,txt_year+"0101");
	statement.setString(10,txt_year+"0101");
	statement.setString(11,txt_year);
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	
		//out.println(rs.getString("V_WEEK_OF_MONTH"));
		if (icnt==0)
		{
		%>
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolorlight="#666666">
		<%
		}
		if (!v_yymm.equals(rs.getString("v_ym")))
		{
			if (!v_yymm.equals(""))
			{
				for (int x =i_mon_week+1 ; x<=6 ; x++)
				{
					out.println("<tr>");
					for (int y=1 ; y<=8 ; y++)
					{
						out.println("<td>&nbsp;</td>");
					}
					out.println("</tr>");					
				}
				out.println("</table>");			
				out.println("</td>");			
				if (Integer.parseInt(rs.getString("v_ym").substring(4,6))%col_num==1) out.println("</tr>");
				i_mon_week=0;
			}
			if (Integer.parseInt(rs.getString("v_ym").substring(4,6))%col_num==1) out.println("<tr>");
			out.println("<td width='25%'>");
			out.println("<table width='100%' height='170' border='1' cellpadding='1' cellspacing='0' bordercolorlight='#cccccc' bordercolor='#CCCCCC'>");
			out.println("<tr>");
			out.println("<td colspan='8' align='center' style='background-color:#CCFFCC'>"+rs.getString("V_YM").substring(0,4)+"/"+rs.getString("V_END_MONTH")+"</td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td width='16%' align='center' style='background-color:#CCCCCC'>Week</td>");
			out.println("<td width='12%' align='center' style='color:#ff0000;background-color:#FFCCCC'>Sun</td>");
			out.println("<td width='12%' align='center'>Mon</td>");
			out.println("<td width='12%' align='center'>Tue</td>");
			out.println("<td width='12%' align='center'>Wed</td>");
			out.println("<td width='12%' align='center'>Thu</td>");
			out.println("<td width='12%' align='center'>Fri</td>");
			out.println("<td width='12%' align='center' style='color:#ff0000;background-color:#FFCCCC'>Sat</td>");
			out.println("</tr>");
			v_yymm = rs.getString("v_ym");
		}
		out.println("<tr>");
		out.println("<td align='center' style='background-color:#CCCCCC'>"+rs.getString("V_WEEK")+"</td>");
		if (rs.getString("V_SUN")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_SUN")).substring(("0"+rs.getString("V_SUN")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0'" + (rs.getString("SUN_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("SUN_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("SUN_ON") !=null && rs.getString("SUN_ON").equals("*")?"color:#FF0000;":"")+"'");
		}
		out.println("<td "+s_td+" align='center' "+  s_style+">"+s_chk+(rs.getString("V_SUN")==null?"&nbsp;":rs.getString("V_SUN"))+"</td>");
		if (rs.getString("V_MON")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_MON")).substring(("0"+rs.getString("V_MON")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0'" + (rs.getString("MON_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("MON_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("MON_ON") !=null && rs.getString("MON_ON").equals("*")?"color:#FF0000;":"")+"'");
		}		
		out.println("<td "+s_td+" align='center' "+  s_style+">"+s_chk+(rs.getString("V_MON")==null?"&nbsp;":rs.getString("V_MON"))+"</td>");
		if (rs.getString("V_TUE")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_TUE")).substring(("0"+rs.getString("V_TUE")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0'" + (rs.getString("TUE_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("TUE_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("TUE_ON") !=null && rs.getString("TUE_ON").equals("*")?"color:#FF0000;":"")+"'");
		}			
		out.println("<td "+s_td+" align='center' "+  s_style+">"+s_chk+(rs.getString("V_TUE")==null?"&nbsp;":rs.getString("V_TUE"))+"</td>");
		if (rs.getString("V_WED")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_WED")).substring(("0"+rs.getString("V_WED")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0'" + (rs.getString("WED_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("WED_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("WED_ON") !=null && rs.getString("WED_ON").equals("*")?"color:#FF0000;":"")+"'");
		}	
		out.println("<td "+s_td+" align='center' "+  s_style+">"+s_chk+(rs.getString("V_WED")==null?"&nbsp;":rs.getString("V_WED"))+"</td>");
		if (rs.getString("V_THU")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_THU")).substring(("0"+rs.getString("V_THU")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0'" + (rs.getString("THU_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("THU_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("THU_ON") !=null && rs.getString("THU_ON").equals("*")?"color:#FF0000;":"")+"'");
		}			
		out.println("<td "+s_td+" align='center' "+ s_style+">"+s_chk+(rs.getString("V_THU")==null?"&nbsp;":rs.getString("V_THU"))+"</td>");
		if (rs.getString("V_FRI")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_FRI")).substring(("0"+rs.getString("V_FRI")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0'" + (rs.getString("FRI_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("FRI_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("FRI_ON") !=null && rs.getString("FRI_ON").equals("*")?"color:#FF0000;":"")+"'");
		}		
		out.println("<td "+s_td+" align='center' "+  s_style+">"+s_chk+(rs.getString("V_FRI")==null?"&nbsp;":rs.getString("V_FRI"))+"</td>");
		if (rs.getString("V_SAT")==null)
		{
			s_chk="";s_td="";s_style="";
		}
		else
		{
			obj_id++;
			s_id = rs.getString("V_YM")+("0"+rs.getString("V_SAT")).substring(("0"+rs.getString("V_SAT")).length()-2);
			s_chk = "<input type='checkbox'  name='chk' value='"+s_id+"' style='visibility:hidden;height:0;width:0' "+ (rs.getString("SAT_CHK").equals("Y")?"checked":"")+">";
			s_td = " id='"+obj_id +"' onClick='onCheck("+obj_id+")'";
			s_style=("style='"+(rs.getString("SAT_CHK").equals("Y")?"background-color:#CCFF66;":"background-color:#FFFFFF;")+(rs.getString("SAT_ON") !=null && rs.getString("SAT_ON")!=null && rs.getString("SAT_ON").equals("*")?"color:#FF0000;":"")+"'");
		}		
		out.println("<td "+s_td+" align='center' "+ s_style+">"+s_chk+(rs.getString("V_SAT")==null?"&nbsp;":rs.getString("V_SAT"))+"</td>");
		out.println("</tr>");
		icnt++;i_mon_week++;
	}
	rs.close();
	statement.close();	
			 
	if (icnt>0)
	{
				for (int x =i_mon_week+1 ; x<=6 ; x++)
				{
					out.println("<tr>");
					for (int y=1 ; y<=8 ; y++)
					{
						out.println("<td>&nbsp;</td>");
					}
					out.println("</tr>");					
				}	
				out.println("</table>");			
				out.println("</td>");			
				out.println("</tr>");	
	%>
			</table>
		</td>	
	</tr>
	<%
	}
	%>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<input type="hidden" NAME="ATYPE" VALUE="<%=ATYPE%>">
<input type="hidden" NAME="DELIVERY_ID" VALUE="<%=delivery_schedule_id%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
