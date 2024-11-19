<!--20151002 Peggy,add excel format condition-->
<!--20160630 Peggy,add new field-改單申請單號-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function openSubWindow(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setExportXLS(URL)
{   
	if (document.MYFORM.ODRTYPE.value =="" || document.MYFORM.ODRTYPE.value=="null" || document.MYFORM.ODRTYPE.value=="--") 
	{
		alert("請先選擇交易類型!");
		document.MYFORM.ODRTYPE.focus();
		return false;
	}
	if (document.MYFORM.EXLTYPE.value =="" || document.MYFORM.EXLTYPE.value=="null" || document.MYFORM.EXLTYPE.value=="--") 
	{
		alert("請先選擇Excel格式!");
		document.MYFORM.EXLTYPE.focus();
		return false;		
	}
	document.MYFORM.action="../jsp/TSCEDIExceptionExcel.jsp?EXLFMT="+document.MYFORM.EXLTYPE.value;
 	document.MYFORM.submit();
}
//function setChange()
//{
//	if (document.MYFORM.ODRTYPE.value =="ORDCHG" || document.MYFORM.ODRTYPE.value =="ORDERS")
//	{
//		document.getElementById("excel").style.visibility="visible"; 	
//	}
//	else
//	{
//		document.getElementById("excel").style.visibility="hidden"; 
//	} 
//}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>EDI Transaction Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String ODRTYPE = request.getParameter("ODRTYPE");
if (ODRTYPE == null) ODRTYPE ="--";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO ="";
String CYEARFR = request.getParameter("CYEARFR");
if (CYEARFR==null) CYEARFR="--";
String CMONTHFR = request.getParameter("CMONTHFR");
if (CMONTHFR==null) CMONTHFR="--";
String CDAYFR = request.getParameter("CDAYFR");
if (CDAYFR==null) CDAYFR="--";
String CYEARTO = request.getParameter("CYEARTO");
if (CYEARTO==null) CYEARTO="--";
String CMONTHTO = request.getParameter("CMONTHTO");
if (CMONTHTO==null) CMONTHTO="--";
String CDAYTO = request.getParameter("CDAYTO");
if (CDAYTO==null) CDAYTO="--";
String EXLTYPE = request.getParameter("EXLTYPE");
if (EXLTYPE == null) EXLTYPE ="D12001";
String ORDERS = "ORDERS",ORDCHG="ORDCHG";
String sql = "";
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCEDIExceptionQuery.jsp" METHOD="post" NAME="MYFORM">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=20);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-size:18px;color:#000099">RFQ異常及OrderChange待確認</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr>
		<td>
  			<table cellSpacing='0' bordercolordark='#A289B1'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1' bgcolor="#CFD1C0" bordercolor="#cccccc">
     			<tr>
					<td width="6%" colspan="1" nowrap><font color="#006666" ><strong>交易類型:</strong></font></td> 
					<td width="10%"><select name="ODRTYPE" style="font-size:12;font-family:arial">
									<option value="--">--
									<option value="<%=ORDERS%>" <%if (ODRTYPE.equals(ORDERS)) out.println("selected");%>>NEW ORDER
									<option value="<%=ORDCHG%>" <%if (ODRTYPE.equals(ORDCHG)) out.println("selected");%>>ORDER CHANGE
									</select>
					</td>
					<td width="6%"><font color="#006666" ><strong>客戶:</strong></font></td>   
					<td width="20%">
					<%
					try
					{
						sql = " select CUSTOMER_ID,'('|| CUSTOMER_NUMBER ||')' || CUSTOMER_NAME from ar_customers a"+
						      " where exists (select 1 from tsc_edi_customer b where b.CUSTOMER_ID=a.CUSTOMER_ID"+
							  " and (b.INACTIVE_DATE is null or trunc(b.INACTIVE_DATE) > trunc(sysdate))";
						if (UserRoles!="admin" && !UserRoles.equals("admin")) 
						{ 
							sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
						}
						sql +=")";
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);		
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(CUSTOMER); 
						comboBoxBean.setFieldName("CUSTOMER");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close(); 
					}
					catch(Exception e)
					{
						out.println("<font color='red'>Exception Error</font>");
					}
					%>
					</td>    
					<td width="6%"><font color="#006666" ><strong>客戶PO:</strong></font></td>
					<td width="10%"><input type="text" name="CUSTPO" value="<%=CUSTPO%>" size="18"></td>
					<td width="6%"><font color="#006666" ><strong>建立日期:</strong></font></td>
					<td width="23%">
					<%
					try
					{     
						int  j =0; 
						String a[]= new String[Integer.parseInt(dateBean.getYearString())-2013+1];
						for (int i = 2013; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
						{
							a[j++] = ""+i; 
						}
						arrayComboBoxBean.setArrayString(a);
						arrayComboBoxBean.setSelection(CYEARFR);
						arrayComboBoxBean.setFieldName("CYEARFR");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
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
						arrayComboBoxBean.setSelection(CMONTHFR);
						arrayComboBoxBean.setFieldName("CMONTHFR");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
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
						arrayComboBoxBean.setSelection(CDAYFR);
						arrayComboBoxBean.setFieldName("CDAYFR");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>
					~
					<%
					try
					{       
						int  j =0; 
						String a[]= new String[Integer.parseInt(dateBean.getYearString())-2013+1];
						for (int i = 2013; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
						{
							a[j++] = ""+i; 
						}
						arrayComboBoxBean.setArrayString(a);
						arrayComboBoxBean.setSelection(CYEARTO);
						arrayComboBoxBean.setFieldName("CYEARTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
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
						arrayComboBoxBean.setSelection(CMONTHTO);
						arrayComboBoxBean.setFieldName("CMONTHTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
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
						arrayComboBoxBean.setSelection(CDAYTO);
						arrayComboBoxBean.setFieldName("CDAYTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>
					</td>
					<td width="8%"><font color="#006666" ><strong>Excel Format:</strong></font></td>
					<td width="5%"><select name="EXLTYPE" style="font-size:12;font-family:arial">
									<option value="--">--
									<option value="D12001" <%if (EXLTYPE.equals("D12001")) out.println("selected");%>>D12-001
									<option value="D4009" <%if (EXLTYPE.equals("D4009")) out.println("selected");%>>D4-009
									</select>
					</td>										
				</tr>
				<tr>
				  <td colspan="10" align="center">
		    			<INPUT TYPE="button" name="submit1" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCEDIExceptionQuery.jsp")' >&nbsp;&nbsp;
		    			<INPUT name="excel" TYPE="button" onClick='setExportXLS()'  value='匯出EXCEL' align="middle"></td>
   				</tr>
			</table>  
		</td>
	</tr>
	<tr>
		<td width="15">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="0" cellspacing="1" bordercolorlight="#ffffff" bordercolordark="#A289B1" bordercolor="#99CCFF" >
				<tr bgcolor="#99CCFF"> 
					<td width="3%" height="20" nowrap><div align="center"><font color="#006666">序號</font></div></td>
					<td width="8%" nowrap><div align="center"><font color="#006666">交易類型</font></div></td>
					<td width="20%" nowrap><div align="center"><font color="#006666">客戶</font></div></td>            
					<td width="8%" nowrap><div align="center"><font color="#006666">客戶訂單</font></div></td>
					<td width="10%" nowrap><div align="center"><font color="#006666">申請單號</font></div></td>
					<td width="10%" nowrap><div align="center"><font color="#006666">狀態</font></div></td> 
					<td width="9%" nowrap><div align="center"><font color="#006666">建立日期</font></div></td> 
					<td width="9%" nowrap><div align="center"><font color="#006666">建立人員</font></div></td>                    
					<td width="8%" nowrap><div align="center"><font color="#006666">改單申請單號</font></div></td>                    
				</tr>
				<%
				try
				{
					sql = "";
					//if (ODRTYPE.equals("") || ODRTYPE.equals("--") || ODRTYPE.equals(ORDERS))
					//{
					//	if (sql.length()>0) sql += " union all";
					//	sql += " select distinct '"+ORDERS+"' order_type,a.dndocno,to_number(a.tscustomerid) TSCUSTOMERID,'NEW ORDER' as order_type_name,CUSTOMER,a.STATUS,a.CUST_PO,to_char(to_date(CREATION_DATE,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi') CREATION_DATE,b.SALES_CONTACT created_by "+
					//		  " from oraddman.tsdelivery_notice a  ,tsc_edi_customer b where to_number(a.tscustomerid)=b.CUSTOMER_ID and a.STATUSID='015'";
					//	if (UserRoles!="admin" && !UserRoles.equals("admin")) 
					//	{ 
					//		sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
					//	}
					//}
					//if (ODRTYPE.equals("") || ODRTYPE.equals("--") || ODRTYPE.equals(ORDCHG))
					//{
					//	if (sql.length()>0) sql += " union all";
					//	sql += " select distinct '"+ORDCHG+"' order_type,a.REQUEST_NO dndocno,a.ERP_CUSTOMER_ID as TSCUSTOMERID,'ORDER CHANGE' as order_type_name,c.CUSTOMER_NAME CUSTOMER,'AWAITING_CONFIRM' STATUS,a.CUSTOMER_PO CUST_PO,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE,c.SALES_CONTACT created_by "+
					//		  " from TSC_EDI_ORDERS_HIS_H a,TSC_EDI_ORDERS_HIS_D b,tsc_edi_customer c where a.REQUEST_NO = b.REQUEST_NO and a.ERP_CUSTOMER_ID = b.ERP_CUSTOMER_ID and b.ERP_CUSTOMER_ID=c.CUSTOMER_ID  AND b.DATA_FLAG='N'";
					//	if (UserRoles!="admin" && !UserRoles.equals("admin")) 
					//	{ 
					//		sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=c.SALES_AREA_NO)";
					//	}
					//}
					sql = " select distinct a.ORDER_TYPE,a.REQUEST_NO REQUEST_NO,a.ERP_CUSTOMER_ID as TSCUSTOMERID,decode(a.order_type,'"+ORDCHG+"','ORDER CHANGE','"+ORDERS+"','NEW ORDER',a.order_type) as order_type_name,'('||d.customer_number||')'|| c.CUSTOMER_NAME CUSTOMER,'AWAITING_CONFIRM' STATUS,a.CUSTOMER_PO CUST_PO,a.CREATION_DATE,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') C_DATE,c.SALES_CONTACT created_by "+
					      ", (select listagg('<a href=\"../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO='||request_no||'&CUSTPO='||SOURCE_CUSTOMER_PO||'\">'||request_no||'</a>','<br>')  within group (order by request_no) request_no from oraddman.TSC_OM_SALESORDERREVISE_REQ x where x.CUSTOMER_PO_REF=b.request_no and x.CUSTOMER_PO_LINE_REF=b.CUST_PO_LINE_NO and x.CUSTOMER_ID_REF=b.ERP_CUSTOMER_ID  and x.STATUS not in ('CLOSED') group by x.request_no) revise_request_no"+ //add by Peggy 20160630
						  " from TSC_EDI_ORDERS_HIS_H a"+
						  ",TSC_EDI_ORDERS_HIS_D b"+
						  ",tsc_edi_customer c"+
						  ",ar_customers d"+  //add by Peggy 20210304
						  " where a.REQUEST_NO = b.REQUEST_NO"+
						  " and a.ERP_CUSTOMER_ID = b.ERP_CUSTOMER_ID"+
						  " and b.ERP_CUSTOMER_ID=c.CUSTOMER_ID "+
						  " and c.CUSTOMER_ID=d.customer_id(+)"+  //add by Peggy 20210304
						  " AND b.DATA_FLAG='N'";
					if (UserRoles!="admin" && !UserRoles.equals("admin")) 
					{ 
							sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=c.SALES_AREA_NO)";
					}
					if (!ODRTYPE.equals("--") && !ODRTYPE.equals(""))
					{
						sql += " AND a.ORDER_TYPE='"+ODRTYPE+"'";
					}
					sql = " select a.* from ("+sql+") a where 1=1";
					if (!CUSTPO.equals(""))
					{
						sql += " and a.CUST_PO ='"+CUSTPO+"'";
					}
					if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
					{
						sql += " and to_char(a.TSCUSTOMERID) = '" + CUSTOMER +"'";
					}
				  	sql += " and trunc(a.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
					if (CYEARTO.equals("--")) CYEARTO = ""+dateBean.getYearString();
					if (CMONTHTO.equals("--")) CMONTHTO = ""+dateBean.getMonthString();
					if (CDAYTO.equals("--"))
					{
						if (CMONTHTO.equals("01") || CMONTHTO.equals("03") || CMONTHTO.equals("05") || CMONTHTO.equals("07") || CMONTHTO.equals("08") || CMONTHTO.equals("10") || CMONTHTO.equals("12"))
						{
							CDAYTO="31";
						}
						else if (CMONTHTO.equals("04") || CMONTHTO.equals("06") || CMONTHTO.equals("09") || CMONTHTO.equals("11"))
						{
							CDAYTO="30";
						}
						else
						{
							if (Integer.parseInt(CYEARTO)%4==0)
							{
								CDAYTO="29";
							}
							else
							{
								CDAYTO="28";
							}
						}
					}
					sql += " and  to_date('"+CYEARTO+"-"+CMONTHTO+"-"+CDAYTO+"','yyyy-mm-dd')";
					sql += " order by 1,2";
					
					if (sql.length()<=0)
					{	
						throw new Exception("查無資料,請洽系統管理人員,謝謝!");
					}
					//out.println(sql);
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);	
					int i =0;	
					while (rs.next())
					{
						i++;
						if (rs.getString("order_type").equals(ORDERS))
						{
							out.println("<tr bgColor='#FFFF99' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#FFFF99',style.color='#000000';this.style.fontWeight='normal'"+'"'+"  title='按下滑鼠左鍵,進入確認畫面!' onclick='openSubWindow("+'"'+"../jsp/TSCEDIORDERSDetail.jsp?REQUESTNO="+rs.getString("REQUEST_NO")+"&ERPCUSTOMERID="+rs.getString("TSCUSTOMERID")+"&CUSTPO="+rs.getString("CUST_PO")+'"'+");' >");   					
						}
						else if (rs.getString("order_type").equals(ORDCHG))
						{
							out.println("<tr bgColor='#D2EDD1' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#D2EDD1',style.color='#000000';;this.style.fontWeight='normal'"+'"'+"  title='按下滑鼠左鍵,進入確認畫面!' onclick='openSubWindow("+'"'+"../jsp/TSCEDIORDCHGDetail.jsp?REQUESTNO="+rs.getString("REQUEST_NO")+"&ERPCUSTOMERID="+rs.getString("TSCUSTOMERID")+"&CUSTPO="+rs.getString("CUST_PO")+'"'+");' >");    					
						}
						else
						{
							out.println("<tr bgcolor='#CFD1C0'>");
						}
						out.println("<td align='center'>"+(i)+"</td>");
						out.println("<td align='center'>"+rs.getString("order_type_name")+"</td>");
						out.println("<td align='left'>"+rs.getString("CUSTOMER")+"</td>");
						out.println("<td align='center'>"+rs.getString("CUST_PO")+"</td>");
						if (rs.getString("order_type").equals(ORDERS))
						{
							out.println("<td align='center'>"+rs.getString("REQUEST_NO")+"</td>");
						}
						else if (rs.getString("order_type").equals(ORDCHG))
						{
							out.println("<td align='center'>"+rs.getString("REQUEST_NO")+"</td>");
						}
						else
						{
							out.println("<td align='center'>"+rs.getString("REQUEST_NO")+"</td>");
						}
						out.println("<td align='center'>"+rs.getString("STATUS")+"</td>");
						out.println("<td align='center'>"+rs.getString("C_DATE")+"</td>");
						out.println("<td align='center'>"+rs.getString("CREATED_BY")+"</td>");
						out.println("<td align='center'>"+(rs.getString("REVISE_REQUEST_NO")==null?"&nbsp;":rs.getString("REVISE_REQUEST_NO"))+"</td>");
						out.println("</tr>");
					}
					rs.close();
					statement.close();
				}
				catch(Exception e)
				{
					out.println("<div align='center'><font color='red'>~~ "+e.getMessage()+" ~~</font></div>");
				}
				%>
			</table>
		</td>
	</tr>
</table>
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

