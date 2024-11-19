<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Revise for Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	if (document.MYFORM.SALESGROUP.value=="--" || document.MYFORM.SALESGROUP.value=="")
	{
		alert("請指定查詢業務區!");
		return false;
	}
	
	if ((document.MYFORM.YEARFR.value=="--"|| document.MYFORM.YEARFR.value=="")
	|| (document.MYFORM.MONTHFR.value=="--"|| document.MYFORM.MONTHFR.value=="")
	||(document.MYFORM.YEARTO.value=="--"|| document.MYFORM.YEARTO.value=="")
	|| (document.MYFORM.MONTHTO.value=="--"|| document.MYFORM.MONTHTO.value==""))
	{
		alert("請指定查詢年月!");
		return false;
	}
		
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setExcel(URL)
{
	if (document.MYFORM.SALESGROUP.value=="--" || document.MYFORM.SALESGROUP.value=="")
	{
		alert("請指定查詢業務區!");
		return false;
	}
	
	if ((document.MYFORM.YEARFR.value=="--"|| document.MYFORM.YEARFR.value=="")
	|| (document.MYFORM.MONTHFR.value=="--"|| document.MYFORM.MONTHFR.value=="")
	||(document.MYFORM.YEARTO.value=="--"|| document.MYFORM.YEARTO.value=="")
	|| (document.MYFORM.MONTHTO.value=="--"|| document.MYFORM.MONTHTO.value==""))
	{
		alert("請指定查詢年月!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

</script>
<%
String sql = "",sql1="",sql2="",sql3="",sql4="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String YearFr= request.getParameter("YEARFR");
if (YearFr==null) YearFr="";
String MonthFr= request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="";
String YearTo= request.getParameter("YEARTO");
if (YearTo==null) YearTo="";
String MonthTo= request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String ACODE=request.getParameter("ACODE");
if ( ACODE==null) ACODE="";
int colnum=1;
if (ACODE.equals("$$$$$") || UserName.indexOf("PEGGY_CHEN")>=0) colnum=0;
String strBackColor="";
int rowcnt=0,colcnt=0;


%>
<body> 
<FORM ACTION="../jsp/TSRFQMonthlyReportQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">RFQ Request Qty Query </div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='1' bgcolor="#E4F0F1" bordercolor="#CCCCCC">
	<tr>
		<td width="10%" align="right">Sales Group：</td>
		<td width="10%">
		<%
		try
		{   
			sql = " SELECT DISTINCT  A.ALNAME AS SALES_GROUP,A.ALNAME "+
                  " FROM oraddman.tssales_area a,oraddman.tsrecperson b,oraddman.wsgroupuserrole c"+
                  " WHERE a.SALES_AREA_NO=CASE WHEN INSTR(c.ROLENAME,'admin')>0 then  a.SALES_AREA_NO ELSE b.TSSALEAREANO END"+
                  " AND b.USERNAME=c.GROUPUSERNAME"+
                  " AND b.USERNAME='"+UserName+"'"+
                  " AND a.SALES_AREA_NO<>'002'"+
                  " UNION ALL"+
                  " SELECT DISTINCT tog.group_name  SALES_GROUP,tog.group_name FROM tsc_om_group tog where tog.group_name in ('TSCC-FSC','TSCC-SZ','TSCC-SH','TSCH-HK') "+
                  " AND 1 <=(SELECT COUNT(1) FROM oraddman.tssales_area a,oraddman.tsrecperson b,oraddman.wsgroupuserrole c"+
                  " WHERE a.SALES_AREA_NO=CASE WHEN INSTR(c.ROLENAME,'admin')>0 then  a.SALES_AREA_NO ELSE b.TSSALEAREANO END "+
                  " AND b.USERNAME=c.GROUPUSERNAME"+
                  " AND b.USERNAME='"+UserName+"'"+
                  " AND a.SALES_AREA_NO='002')"+
                  " ORDER BY 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFieldName("SALESGROUP");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>	
		</td>
		<td width="10%" align="right">Customer：</td>
		<td width="15%"><input type="text" name="CUST" value="<%=CUST%>" style="font-family:Tahoma,Georgia;font-size:11px" size="30"></td>
		<td width="10%" align="right">Item Desc：</td> 
		<td width="15%"><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" style="font-family:Tahoma,Georgia;font-size:11px" size="22"></td>
		<td width="10%" align="right">Request Month：</td>
		<td width="20%">
		<%
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2016+1];
			for (int i = 2016; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearFr==null?dateBean.getYearString():YearFr));
			arrayComboBoxBean.setFieldName("YEARFR");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} 
		catch (Exception e)
		{
			out.println("Exception1:"+e.getMessage());
		}
			  
		try
		{  
			int  j =0; 
			String b[]= new String[12];
			for (int i =1;i <= 12;i++)
			{
				if (i <10)	b[j++] = "0"+i;
				else b[j++] = ""+i;		
			}
			arrayComboBoxBean.setArrayString(b);
			arrayComboBoxBean.setSelection((MonthFr==null?dateBean.getMonthString():MonthFr));
			arrayComboBoxBean.setFieldName("MONTHFR");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} 
		catch (Exception e)
		{
			out.println("Exception2:"+e.getMessage());
		}
		%>
		~
		<%
		try
		{  
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2016+1];
			for (int i = 2016; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearTo==null?dateBean.getYearString():YearTo));
			arrayComboBoxBean.setFieldName("YEARTO");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		}
		catch (Exception e)
		{
			out.println("Exception4:"+e.getMessage());
		}
		
		try
		{   
			int  j =0; 
			String b[]= new String[12];
			for (int i =1;i <= 12;i++)
			{
				if (i <10)	b[j++] = "0"+i;
				else b[j++] = ""+i;		
			}
			arrayComboBoxBean.setArrayString(b);
			arrayComboBoxBean.setSelection((MonthTo==null?dateBean.getMonthString():MonthTo));
			arrayComboBoxBean.setFieldName("MONTHTO");	   
			out.println(arrayComboBoxBean.getArrayString());		    
		}
		catch (Exception e)
		{
			out.println("Exception5:"+e.getMessage());
		}
		%>		
		</td>
	</tr>
	<tr>
	  <td colspan="8" align="center"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSRFQMonthlyReportQuery.jsp?RTYPE=Q')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSRFQMonthlyReport.jsp?UserName=<%=UserName%>')"></td>
	</tr>
</TABLE>
<hr>
<%
try
{ 
	if (RTYPE.equals("Q"))
	{
		sql = " SELECT TOG.GROUP_NAME sales_group"+
			  ",c.customer"+
			  ",CASE WHEN TOG.GROUP_NAME='TSCH-HK' THEN case when INSTR(a.cust_po_number,'(')>0 then substr(a.cust_po_number,instr(a.cust_po_number,'(')+1,instr(a.cust_po_number,')',-1)-instr(a.cust_po_number,'(')-1) else a.cust_po_number end ELSE NVL(ACS.customer_name_phonetic, ACS.CUSTOMER_NAME) END as end_customer"+
			  ",a.item_segment1 item_name"+
			  ",a.item_description item_desc"+
			  //",substr(listagg( '0'||to_char(selling_price)||',', '') within group (order by TOG.GROUP_NAME,a.creation_date desc),1,instr(listagg( to_char(selling_price)||',', '') within group (order by TOG.GROUP_NAME,a.creation_date desc),',')) selling_price"+
			  ",a.uom";
		Statement statement1=con.createStatement(); 
		sql1 =" SELECT to_char(ADD_MONTHS(TO_DATE('"+YearFr+MonthFr+"01','YYYYMMDD'),ROWNUM-1),'yyyymm') mon_value"+
		      ",TO_CHAR(ADD_MONTHS(TO_DATE('"+YearFr+MonthFr+"01','YYYYMMDD'),ROWNUM-1),'YYYY MON') MONTHS "+
			  ",(MONTHS_BETWEEN(to_date('"+YearTo+MonthTo+"01','yyyymmdd'),to_date('"+YearFr+MonthFr+"01','yyyymmdd'))+1)-rownum row_cnt"+
			  " FROM DUAL CONNECT BY ROWNUM<=MONTHS_BETWEEN(to_date('"+YearTo+MonthTo+"01','yyyymmdd'),to_date('"+YearFr+MonthFr+"01','yyyymmdd'))+1";
		//out.println(sql1);
		ResultSet rs1=statement1.executeQuery(sql1);
		while (rs1.next()) 
		{ 	
			sql += ",sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity else 0 end) as \""+rs1.getString(2)+"\"";
			if (rs1.getInt(3)==1 || rs1.getInt(3)==2  || rs1.getInt(3)==3)
			{
				if (!sql2.equals("")) sql2+= "+";
				sql2 += " sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity else 0 end)";
			}
			if (rs1.getInt(3)==0)
			{
				sql3 =" ,round((sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity else 0 end)-sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity else 0 end))/ case when sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity else 0 end)=0 then 1 else sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity else 0 end) end *100,2) as \"當月下單率(與上月比)\""+
				      " ,sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity*NVL(a.selling_price,0)*1000 else 0 end)-sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity*NVL(a.selling_price,0)*1000 else 0 end) as \"當月金額差(與上月比)\"";
				sql4 =" sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity*NVL(a.selling_price,0)*1000 else 0 end)-sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity*NVL(a.selling_price,0)*1000 else 0 end)";
			}
		}
		rs1.close();
		statement1.close();
		
		if (!sql2.equals(""))
		{
			sql +=",to_char(round(("+sql2+")/3,2),'99990D099') \"前三個月平圴下單量\"";
		}
		if (!sql3.equals(""))
		{
			sql += sql3;
		}
				 
		sql += " FROM oraddman.tsdelivery_notice_detail a"+
			  ",oraddman.tsdelivery_notice c"+
			  ",HZ_CUST_SITE_USES_ALL hcsu"+
			  ",TSC_OM_GROUP TOG "+
			  ",AR_CUSTOMERS ACS"+
			  " WHERE SUBSTR(A.CREATION_DATE,1,6)>="+YearFr+MonthFr+
			  " AND SUBSTR(A.CREATION_DATE,1,6)<="+YearTo+MonthTo+
			  " AND A.DNDOCNO=C.DNDOCNO"+
			  " AND C.SHIP_TO_ORG=hcsu.SITE_USE_ID "+
			  " AND TO_NUMBER(hcsu.ATTRIBUTE1) = TOG.GROUP_ID"+
			  " AND A.END_CUSTOMER_ID=ACS.CUSTOMER_ID(+)"+
			  " AND A.LSTATUSID NOT IN ('012','001')";
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " AND TOG.GROUP_NAME='"+salesGroup+"'";
			}
			/*
			else if (UserRoles.indexOf("admin")<0)
			{
				sql += " and (exists ( SELECT 1 FROM oraddman.wsuser x,fnd_user y, per_all_people_f z, jtf_rs_salesreps js,tsc_om_group_salesrep tos,tsc_om_group tog"+
						   "                WHERE x.username ='"+UserName+"'"+
						   "                AND x.erp_user_id=y.user_id"+
						   "                and y.employee_id = z.person_id"+
						   " AND z.employee_number = js.salesrep_number"+
						   " AND nvl2(tos.salesrep_id,js.salesrep_id,y.user_id) = nvl(tos.salesrep_id,tos.user_id)"+
						   " and tos.group_id=tog.group_id"+
						   " and tog.group_name=a.sales_group)"+
						   " or exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"'"+
						   " and case when c.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=TOG.GROUP_NAME))";
						   
			}
			*/
			if (!CUST.equals(""))
			{
				sql += " and CASE WHEN TOG.GROUP_NAME='TSCH-HK' THEN case when INSTR(a.cust_po_number,'(')>0 then substr(a.cust_po_number,instr(a.cust_po_number,'(')+1,instr(a.cust_po_number,')',-1)-instr(a.cust_po_number,'(')-1) else a.cust_po_number end ELSE NVL(NVL(ACS.customer_name_phonetic, ACS.CUSTOMER_NAME),c.customer) END like '%"+CUST+"%'";
			}
		
			if (!ITEMDESC.equals(""))
			{
				sql += " and a.item_description like '"+ITEMDESC+"%'";
			}	
			
			sql += " group by TOG.GROUP_NAME,c.tscustomerid,c.customer,CASE WHEN TOG.GROUP_NAME='TSCH-HK' THEN case when INSTR(a.cust_po_number,'(')>0 then substr(a.cust_po_number,instr(a.cust_po_number,'(')+1,instr(a.cust_po_number,')',-1)-instr(a.cust_po_number,'(')-1) else a.cust_po_number end ELSE NVL(ACS.customer_name_phonetic, ACS.CUSTOMER_NAME) END ,a.item_segment1,a.item_description,a.uom"+
				   " order by ("+sql4+"),item_description,end_customer,a.item_segment1";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next()) 
		{ 	
			if (rowcnt==0)
			{
			%>
	<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="1" bordercolor="#9ADADA">
		<tr style="background-color:#9ADADA;color:#000000">
			<%
				ResultSetMetaData md=rs.getMetaData();
				colcnt=md.getColumnCount();
				for(int icol =1 ; icol <= colcnt-colnum ; icol++)
				{
					if (icol ==2 || icol==3 || icol==4 || icol==5)
					{
				%>
						<td width="10%" align="center"><%=md.getColumnLabel(icol)%></td>
				<%
					}
					else
					{
				%>
						<td width="3%" align="center"><%=md.getColumnLabel(icol)%></td>
				<%
					}
				}
			%>
		</tr>
			<%
			}
			rowcnt++;
			%>
		<tr id="tr<%=rowcnt%>">
			<%
			for(int icol =1 ; icol <= colcnt-colnum ; icol++)
			{	
				if (icol>=7)
				{
					if (icol == colcnt)
					{
						if (rs.getInt(icol)<0)
						{
						%>
							<td align="right" style="color:#ff0000"><%=(rs.getString(icol)==null?"&nbsp;":"("+rs.getString(icol).replace("-","")+")")%></td>
						<%
						}
						else
						{
						%>
							<td align="right" style="color:#000000"><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%></td>
						<%
						}
					}
					else if (icol == colcnt-1)
					{
						if (rs.getInt(icol)<=-30)
						{
			%>
						<td align="right" style="background-color:#FFCCCC"><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%>%</td>
			<%
						}
						else if (rs.getInt(icol)>=50)
						{
			%>
						<td align="right" style="background-color:#FFFF66"><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%>%</td>
			<%
						}
						else
						{
			%>
						<td align="right"><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%>%</td>
			<%
						}
					}
					else if (icol == colcnt-2)
					{
			%>
						<td align="right" style="background-color:#CCFF99"><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%></td>
			<%
					}
					else
					{	
			%>
						<td align="right"><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%></td>
			<%
					}
				}
				else
				{
			%>	
				<td><%=(rs.getString(icol)==null?"&nbsp;":rs.getString(icol))%></td>
			<%
				}
			}
			%>
		</tr>
			<%
		}
		rs.close();
		statement.close();
	
		if (rowcnt >0) 
		{
		%>
	</table>
		<%
		}
	}
}
catch(Exception e)
{
	out.println("<br><font color='red'>Error:"+e.getMessage()+"</font>");
}
%>
	
<hr>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

