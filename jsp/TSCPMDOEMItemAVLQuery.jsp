<!-- 20161108 Peggy,新增prd 外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAddNew(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setModify(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setInactive(URL,STATUS)
{
	var str ="停用";
	if (STATUS=="Y") str ="啟用";
	if (confirm("您確定要將資料狀態改為"+str+"?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function chgObj()
{
	document.MYFORM.STATUS1.value = "--";
	document.MYFORM.YEARFR.value = "--";
	document.MYFORM.MONTHFR.value = "--";
	document.MYFORM.DAYFR.value = "--";
	document.MYFORM.YEARTO.value = "--";
	document.MYFORM.MONTHTO.value = "--";
	document.MYFORM.DAYTO.value = "--";
}
</script>
<html>
<head>
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
  input[type="text"] {font-family: Tahoma,Georgia;  font-size: 11px}

</STYLE>
<title>AVL資料查詢</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<% /* 建立本頁面資料庫連線  */ %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM  METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
String VENDOR = request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String VENDORCODE = request.getParameter("VENDORCODE");
if (VENDORCODE==null) VENDORCODE="";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID==null) ITEMID="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE = "";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="N";
String STATUS1 = request.getParameter("STATUS1");
if (STATUS1==null) STATUS1="";	
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr="--";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";	

	
if (ACTIONCODE.equals("CANCEL"))
{
	String sql = " update oraddman.tspmd_item_avl set ACTIVE_FLAG='"+STATUS+"'"+
		  " where INVENTORY_ITEM_ID ='"+ITEMID+"' AND VENDOR_CODE='"+ VENDORCODE+"'";
	PreparedStatement st1 = con.prepareStatement(sql);
	st1.executeUpdate();
	st1.close();
	out.println("<script language = 'JavaScript'>");
	out.println("alert('資料狀態更新完成!')");
	out.println("</script>");
}
%>
<table cellspacing="0" cellpadding="1" width="100%" align="center">	
	<tr>
		<td><font style="color:#003366;font-size:22px;font-family:'Arial Black'">AVL</font>
			<font style="color:#000000;font-size:22px;font-family:'標楷體';font-weight:bold">資料查詢</font>
		</td>
	</tr>
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"  style="font-size:12px;font-family:細明體;text-decoration:none;color:#0000FF">回首頁</A></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#999966" cellpadding="0" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
				<tr BGCOLOR='#999966'>
					<td width="5%" nowrap style="font-size:12px;color:#FFFFFF;">供應商</td> 
					<td width="15%"><INPUT TYPE="text" NAME="VENDOR" value="<%=VENDOR%>" style="font-family: Tahoma,Georgia;  font-size: 12px" size="25" onKeyPress="chgObj();"></td>
					<td width="5%" nowrap style="font-size:12px;color:#FFFFFF;">料號/品名</td> 
					<td width="15%"><INPUT TYPE="text" NAME="ITEM" value="<%=ITEM%>" style="font-family: Tahoma,Georgia;  font-size: 12px" size="25"  onKeyPress="chgObj();"></td>
					<td width="5%" nowrap style="font-size:12px;color:#FFFFFF;">狀態</td> 
					<td width="5%">
					<select NAME="STATUS1" style="Tahoma,Georgia; font-size: 12px ">
					<OPTION VALUE=-- <%if (STATUS1.equals("")) out.println("selected");%>>--</OPTION>
					<OPTION VALUE="Y" <%if (STATUS1.equals("Y")) out.println("selected");%>>啟用</OPTION>
					<OPTION VALUE="N" <%if (STATUS1.equals("N")) out.println("selected");%>>停用</OPTION>
					</select>
					</td>
					<td width="5%" nowrap style="font-size:12px;color:#FFFFFF;">異動日</td> 
					<td width="25%">
					<%
					String CurrYear = null;	 
					try
					{       
						int  j =0; 
						String a[]= new String[Integer.parseInt(dateBean.getYearString())-2013+1];
						for (int i = 2013; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
						{
							a[j++] = ""+i; 
						}
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
					} 
					catch (Exception e)
					{
						out.println("Exception1:"+e.getMessage());
					}
						  
					String CurrMonth = null;	     		 
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
					} 
					catch (Exception e)
					{
						out.println("Exception2:"+e.getMessage());
					}
				
					String CurrDay = null;	     		 
					try
					{       
						int  j =0; 
						String c[]= new String[31];
						for (int i =1;i <= 31;i++)
						{
							if (i <10)	c[j++] = "0"+i;
							else c[j++] = ""+i;		
						}	
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
					} 
					catch (Exception e)
					{
						out.println("Exception3:"+e.getMessage());
					}	
				%>
						~</strong></font>
				<%
					String CurrYearTo = null;	     		 
					try
					{  
						int  j =0; 
						String a[]= new String[Integer.parseInt(dateBean.getYearString())-2013+1];
						for (int i = 2013; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
						{
							a[j++] = ""+i; 
						}
						arrayComboBoxBean.setArrayString(a);
						if (YearTo==null)
						{
							CurrYearTo=dateBean.getYearString();
							arrayComboBoxBean.setSelection(CurrYearTo);
						} 
						else 
						{
							arrayComboBoxBean.setSelection(YearTo);
						}
						arrayComboBoxBean.setFieldName("YEARTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					}
					catch (Exception e)
					{
						out.println("Exception4:"+e.getMessage());
					}
					
					String CurrMonthTo = null;	     		 
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
					}
					catch (Exception e)
					{
						out.println("Exception5:"+e.getMessage());
					}
					
					String CurrDayTo = null;	     		 
					try
					{     
						int  j =0; 
						String c[]= new String[31];
						for (int i =1;i <= 31;i++)
						{
							if (i <10)	c[j++] = "0"+i;
							else c[j++] = ""+i;		
						}	
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
					}
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>    
					</td>  
					<td width="20%">
					<INPUT TYPE="button" id='Query' value='查詢' onClick='setSubmit("../jsp/TSCPMDOEMItemAVLQuery.jsp")'>&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='button' id='AddNew' value='資料新增' onClick='setAddNew("../jsp/TSCPMDOEMItemAVLUpdate.jsp")'>
					</td>							
				</tr>
			</table>
		</td>
   	</tr>
   	<tr>
   		<td>&nbsp;</td>
	</tr>
<%
			int i =0;
			try
			{
				String sourceLot = "";
				String sql = " SELECT a.inventory_item_id, a.item_name, a.item_description, a.vendor_code, a.vendor_name, a.package_spec, a.test_spec,"+
                             " to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date, a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date,a.last_updated_by, a.active_flag  "+
							 ",(select count(1) from  oraddman.tspmd_item_avl b where 1=1 ";
				if (!ITEM.equals("")) sql += " and (b.item_name like '"+ ITEM +"%' or b.item_description like '"+ ITEM +"%')";
				if (!VENDOR.equals("")) sql += " and b.vendor_name like '"+VENDOR +"%'";
                sql += " ) rowcnt ,a.organization_id,a.tsc_prod_group FROM 	oraddman.tspmd_item_avl a where 1=1 ";
				if (!ITEM.equals("")) sql += " and (item_name like '"+ ITEM +"%' or item_description like '"+ ITEM +"%')";
				if (!VENDOR.equals("")) sql += " and a.vendor_name like '"+VENDOR +"%'";
				if (!STATUS1.equals("") && !STATUS1.equals("--")) sql += " and a.active_flag = '"+STATUS1 +"'";
				if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
				{
					sql += " AND to_char(a.last_update_date,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2013":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
				}
				if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
				{
					sql += " AND to_char(a.last_update_date,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
				}
				
   				Statement statement=con.createStatement();
			    ResultSet rs=statement.executeQuery(sql);  
				//out.println(sql);
			    while (rs.next())
				{
					i++;
					if (i==1)
					{
						out.println("<tr><td style='font-size:16px'>查詢筆數共<font style='color:#0000ff;font-size:16px;font-weight:bold;'>"+rs.getString("rowcnt")+"</font>筆資料</td></tr>");
						out.println("<tr>");
						out.println("<td>");
						out.println("<table cellspacing='0' bordercolordark='#FFFFFF' cellpadding='1' width='100%' align='center' bordercolorlight='#CCCC99' border='1'>");	
						out.println("<tr bgcolor='#CCCC99'>");
						out.println("<td width='2%' align='center'>&nbsp;</td>");
						out.println("<td width='6%' align='center'>&nbsp;</td>");
						out.println("<td align='center' width='6%' valign='middle' style='font-size:12px'>TSC Prod Group</td>");
						out.println("<td align='center' width='11%' valign='middle' style='font-size:12px'>料號</td>");
						out.println("<td align='center' width='9%' style='font-size:12px'>品名</td>");
						out.println("<td align='center' width='16%' style='font-size:12px'>供應商</td>");
						out.println("<td align='center' width='16%' style='font-size:12px'>封裝規格</td>");
						out.println("<td align='center' width='17%' style='font-size:12px'>測試規格</td>");
						out.println("<td align='center' width='4%' style='font-size:12px'>狀態</td>");
						//out.println("<td align='center' width='7%' align='center'>建立日期</td>");
						//out.println("<td align='center' width='7%' align='center'>建立人員</td>");
						out.println("<td align='center' width='7%' align='center' style='font-size:12px'>最後更新日</td>");
						out.println("<td align='center' width='7%' align='center' style='font-size:12px'>最後更新人員</td>");
						out.println("</tr>");
					}
					out.println("<tr style='font-size:11px;'>");
					out.println("<td align='center'>"+i+"</td>");
					out.println("<td align='center'>");
					out.println("<input type='button' id='UPD"+i+"' value='修改' style='font-size:11px' onclick='setModify("+'"'+"../jsp/TSCPMDOEMItemAVLUpdate.jsp?ACTIONMODE=MODIFY&SUPPLIERNO="+rs.getString("VENDOR_CODE")+"&ITEMID="+rs.getString("inventory_item_id")+'"'+")'>");
					if (rs.getString("ACTIVE_FLAG").equals("Y"))
					{
						out.println("<input type='button' id='CANCEL"+i+"' value='停用' style='font-size:11px' onclick='setInactive("+'"'+"../jsp/TSCPMDOEMItemAVLQuery.jsp?ACTIONCODE=CANCEL&VENDORCODE="+rs.getString("VENDOR_CODE")+"&ITEMID="+rs.getString("inventory_item_id")+"&STATUS=N"+'"'+","+'"'+"N"+'"'+")'>");
					}
					else
					{
						out.println("<input type='button' id='CANCEL"+i+"' value='啟用' style='font-size:11px' onclick='setInactive("+'"'+"../jsp/TSCPMDOEMItemAVLQuery.jsp?ACTIONCODE=CANCEL&VENDORCODE="+rs.getString("VENDOR_CODE")+"&ITEMID="+rs.getString("inventory_item_id")+"&STATUS=Y"+'"'+","+'"'+"Y"+'"'+")'>");
					}
					out.println("</td>");
					out.println("<td>"+rs.getString("TSC_PROD_GROUP")+"</td>");
					out.println("<td>"+rs.getString("ITEM_NAME")+"</td>");
					out.println("<td>"+rs.getString("ITEM_DESCRIPTION")+"</td>");
					out.println("<td>"+"("+rs.getString("VENDOR_CODE")+")"+rs.getString("VENDOR_NAME")+"</td>");
					out.println("<td>"+(rs.getString("PACKAGE_SPEC")==null?"&nbsp;":rs.getString("PACKAGE_SPEC"))+"</td>");
					out.println("<td>"+(rs.getString("TEST_SPEC")==null?"&nbsp;":rs.getString("TEST_SPEC"))+"</td>");
					out.println("<td align='center'>"+(rs.getString("ACTIVE_FLAG").equals("Y")?"<font color='blue'>啟用</font>":"<font color='red'>停用</font>")+"</td>");
					//out.println("<td style='font-size:11px;font-family:arial;' align='center'>"+(rs.getString("CREATION_DATE")==null?"&nbsp;":rs.getString("CREATION_DATE"))+"</td>");
					//out.println("<td style='font-size:11px;font-family:arial;' align='center'>"+(rs.getString("CREATED_BY")==null?"&nbsp;":rs.getString("CREATED_BY"))+"</td>");
					out.println("<td>"+(rs.getString("last_update_date")==null?"&nbsp;":rs.getString("last_update_date"))+"</td>");
					out.println("<td>"+rs.getString("last_updated_by")+"</td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();
			}
			catch (Exception e)
			{
				out.println(e.getMessage());
			}
			if (i>0)
			{
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
			}
			else
			{
				out.println("<tr><td align='center' style='color:#ff0000;font-size:16px'>查無資料!!</td></tr>");
			}
%>				
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

