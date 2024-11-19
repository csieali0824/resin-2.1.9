<!--20140724 by Peggy,客戶品號或台半品號與上版不同時,在exception notice欄位提示user -->
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
function setExportXLS()
{   
	if (document.MYFORM.EXLTYPE.value =="" || document.MYFORM.EXLTYPE.value=="null" || document.MYFORM.EXLTYPE.value=="--") 
	{
		alert("請先選擇Excel格式!");
		document.MYFORM.EXLTYPE.focus();
		return false;		
	}
	document.MYFORM.action="../jsp/TSCE1214ExceptionExcel.jsp?EXLFMT="+document.MYFORM.EXLTYPE.value;
 	document.MYFORM.submit();
}
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
<title>TSCE Hub PO Confirm</title>
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
String ORDERS = "ORDERS",ORDCHG="ORDCHG",exception_err="";
String sql = "";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCE1214ExceptionQuery.jsp" METHOD="post" NAME="MYFORM">
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
<strong><font style="font-size:18px;color:#000099">New PO資料異常及PO Change確認</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr>
		<td>
  			<table cellSpacing='0' bordercolordark='#A289B1'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1' bgcolor="#D1DEDD">
     			<tr>
					<td width="8%" colspan="1" nowrap><font color="#006666" ><strong>Order Type:</strong></font></td> 
					<td width="10%"><select name="ODRTYPE" style="font-size:12;font-family:arial">
									<option value="--">--
									<option value="<%=ORDERS%>" <%if (ODRTYPE.equals(ORDERS)) out.println("selected");%>>NEW ORDER
									<option value="<%=ORDCHG%>" <%if (ODRTYPE.equals(ORDCHG)) out.println("selected");%>>ORDER CHANGE
									</select>
					</td>
					<td width="8%"><font color="#006666" ><strong>End Customer:</strong></font></td>   
					<td width="10%"><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-family:arial" size="15"></td>    
					<td width="8%"><font color="#006666" ><strong>Customer PO:</strong></font></td>
					<td width="10%"><input type="text" name="CUSTPO" value="<%=CUSTPO%>" style="font-family:arial" size="15"></td>
					<td width="8%"><font color="#006666" ><strong>Creation Date:</strong></font></td>
					<td width="25%">
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
		    			<INPUT TYPE="button" name="submit1" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCE1214ExceptionQuery.jsp")' style="font-family:arial" >&nbsp;&nbsp;
		    			<INPUT name="excel" TYPE="button" onClick='setExportXLS("../jsp/TSCE1214ExceptionExcel.jsp")'  value='Export to EXCEL' style="font-family:arial" align="middle"></td>
   				</tr>
			</table>  
		</td>
	</tr>
	<tr>
		<td width="15">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#ffffff" bordercolordark="#A289B1">
				<tr bgcolor="#C5D1B4"> 
					<td width="5%" height="20" nowrap><div align="center"><font color="#006666">Seq No</font></div></td>
					<td width="10%" nowrap><div align="center"><font color="#006666">Order Type</font></div></td>
					<td width="20%" nowrap><div align="center"><font color="#006666">End Customer</font></div></td>            
					<td width="10%" nowrap><div align="center"><font color="#006666">Customer PO</font></div></td>
					<td width="10%" nowrap><div align="center"><font color="#006666">Creation Date</font></div></td> 
					<td width="22%" nowrap><div align="center"><font color="#006666">Exception Notice</font></div></td> 
					<td width="8%" nowrap><div align="center"><font color="#006666">Revise No</font></div></td> 
				</tr>
				<%
				try
				{
					sql = " SELECT distinct tot.ORDER_TYPE,tot.CUSTOMER_NAME,tot.CUSTOMER_PO,tot.CREATION_DATE,tot.VERSION_ID,tot.parent_version_id,tot.revise_request_no "+
                          ",nvl((select count(1) from ORADDMAN.TSCE_PURCHASE_ORDER_LINES c where c.version_id = tot.comparison_version_id  and c.customer_po = tot.customer_po and c.po_line_no = tot.po_line_no and (c.cust_part_no<>tot.cust_part_no or c.tsc_part_no <> tot.tsc_part_no)),0) ERR_CNT"+//add by Peggy 20140724,check客戶品號及台半品號是否與前版相同
					      " FROM (SELECT case when a.VERSION_ID = 0 THEN 'ORDERS' ELSE 'ORDCHG' END as ORDER_TYPE"+
					      "      ,a.CUSTOMER_NAME"+
						  "      ,a.CUSTOMER_PO"+
						  "      ,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE"+
						  "      ,a.VERSION_ID "+
						  "      ,a.parent_version_id "+
                          //",nvl((select count(1) from ORADDMAN.TSCE_PURCHASE_ORDER_LINES c where c.version_id = a.parent_version_id  and c.customer_po = a.customer_po and c.customer_po = b.customer_po and c.po_line_no = b.po_line_no and (c.cust_part_no<>b.cust_part_no or c.tsc_part_no <> b.tsc_part_no)),0) ERR_CNT"+//add by Peggy 20140724,check客戶品號及台半品號是否與前版相同
                          "      ,b.PO_LINE_NO"+ //add by Peggy 20210805
						  "      ,b.TSC_PART_NO"+//add by Peggy 20210805
						  "      ,b.CUST_PART_NO"+//add by Peggy 20210805
                          "      ,nvl((select max(version_id) from oraddman.tsce_purchase_order_lines x where x.customer_po=b.customer_po and x.po_line_no=b.po_line_no and x.version_id < b.version_id and x.data_flag not in ('X','I')),0) comparison_version_id"+ //add by Peggy 20210805
					      "      ,(select listagg('<a href=\"../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO='||request_no||'&CUSTPO='||SOURCE_CUSTOMER_PO||'\">'||request_no||'</a>','<br>')  within group (order by request_no) request_no "+
						//" from oraddman.TSC_OM_SALESORDERREVISE_REQ x "+
						  "       from (select distinct request_no,customer_po_ref,customer_po_line_ref,customer_id_ref,version_id_ref,status,SOURCE_CUSTOMER_PO"+
				  		  "            ,TO_CHAR(NVL(REQUEST_DATE,SOURCE_REQUEST_DATE),'yyyymmdd') CRD,NVL(ITEM_DESC,SOURCE_ITEM_DESC) TSC_PART_NO"+
 				  		  "            ,NVL(CUST_ITEM_NAME,SOURCE_CUST_ITEM_NAME) CUST_PART_NO, NVL(SO_QTY,SOURCE_SO_QTY) QUANTITY "+ //add by Peggy 20220315
						  "            from oraddman.tsc_om_salesorderrevise_req) x"+
						  "       where x.CUSTOMER_PO_REF=b.CUSTOMER_PO "+
						  "       and x.CUSTOMER_PO_LINE_REF=b.PO_LINE_NO "+
						  "       and x.CUSTOMER_ID_REF=a.ERP_CUSTOMER_ID "+
						  "       and (x.VERSION_ID_REF=b.VERSION_ID"+ // CRD/TSC PN/CUST PN/QUANTITY四欄位比對或版次符合 add by Peggy 20220322
				          "       or  (x.CRD=b.CRD"+  //add by Peggy 20220315
				          "       and x.TSC_PART_NO=b.TSC_PART_NO"+   //add by Peggy 20220315
				          "       and x.CUST_PART_NO=b.CUST_PART_NO "+  //add by Peggy 20220315
        				  "       and x.QUANTITY=b.QUANTITY)) "+  //add by Peggy 20220315
						  "       AND x.status<>'CLOSED') revise_request_no"+ //add by Peggy 20160630
					      "       FROM ORADDMAN.TSCE_PURCHASE_ORDER_HEADERS a "+
						  "       ,ORADDMAN.TSCE_PURCHASE_ORDER_LINES b"+
						  "       where b.DATA_FLAG ='E' "+
						  "       AND b.CUSTOMER_PO = a.CUSTOMER_PO"+
						  "       AND b.VERSION_ID = a.VERSION_ID";
						  //" WHERE EXISTS (SELECT 1 FROM ORADDMAN.TSCE_PURCHASE_ORDER_LINES b where b.DATA_FLAG ='E' AND b.CUSTOMER_PO = a.CUSTOMER_PO AND b.VERSION_ID = a.VERSION_ID)";
					if (ODRTYPE.equals(ORDERS))
					{
						sql += " AND a.VERSION_ID = 0";
					}
					else if (ODRTYPE.equals(ORDCHG))
					{
						sql += " AND a.VERSION_ID > 0";
					}
					if (!CUSTPO.equals(""))
					{
						sql += " and a.CUSTOMER_PO LIKE '"+CUSTPO+"%'";
					}
					if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
					{
						sql += " and a.CUSTOMER_NAME LIKE'" + CUSTOMER +"%'";
					}
				  	sql += " and trunc(a.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
					if (CYEARTO.equals("--")) CYEARTO = dateBean.getYearString();
					if (CMONTHTO.equals("--")) CMONTHTO = dateBean.getMonthString();
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
					sql += " and  to_date('"+CYEARTO+"-"+CMONTHTO+"-"+CDAYTO+"','yyyy-mm-dd')) tot"+
						   " order by 1,2";
					
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
							out.println("<tr bgColor='#BDE1B9' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#BDE1B9',style.color='#000000';this.style.fontWeight='normal'"+'"'+"  title='按下滑鼠左鍵,進入確認畫面!' onclick='openSubWindow("+'"'+"../jsp/TSCE1214ORDERSDetail.jsp?CUSTPO="+rs.getString("CUSTOMER_PO")+"&VERSIONID="+rs.getString("VERSION_ID")+'"'+");' >");   					
						}
						else if (rs.getString("order_type").equals(ORDCHG))
						{
							out.println("<tr bgcolor='#D0CCF2' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#D0CCF2',style.color='#000000';;this.style.fontWeight='normal'"+'"'+"  title='按下滑鼠左鍵,進入確認畫面!' onclick='openSubWindow("+'"'+"../jsp/TSCE1214ORDCHGDetail.jsp?CUSTPO="+rs.getString("CUSTOMER_PO")+"&VERSIONID="+rs.getString("VERSION_ID")+'"'+");' >"); 
						}
						else
						{
							out.println("<tr bgcolor='#CFD1C0'>");
						}
						out.println("<td align='center'>"+(i)+"</td>");
						out.println("<td align='center'>"+(rs.getString("order_type").equals(ORDERS)?"New Order":"Order Change")+"</td>");
						out.println("<td align='left'>"+rs.getString("CUSTOMER_NAME")+"</td>");
						out.println("<td align='center'>"+rs.getString("CUSTOMER_PO")+"</td>");
						out.println("<td align='center'>"+rs.getString("CREATION_DATE")+"</td>");
						exception_err="";
						if (rs.getInt("err_cnt")>0) //客戶品號及台半品號是否與上版不符,add by Peggy 20140724
						{
							/*sql = " select a.po_line_no,a.cust_part_no,a.tsc_part_no,b.cust_part_no orig_cust_part_no,b.tsc_part_no orig_tsc_part_no"+
                                  " from ORADDMAN.TSCE_PURCHASE_ORDER_LINES a,ORADDMAN.TSCE_PURCHASE_ORDER_LINES b"+
                                  " where a.version_id="+rs.getString("version_id")+""+
                                  " and a.customer_po='"+rs.getString("customer_po")+"'"+
                                  " and b.version_id="+rs.getString("parent_version_id")+""+
                                  " and b.customer_po='"+rs.getString("customer_po")+"'"+
								  " and a.customer_po=b.customer_po"+
                                  " and a.po_line_no=b.po_line_no"+
                                  " and (b.cust_part_no <> a.cust_part_no"+
                                  " or b.tsc_part_no <> a.tsc_part_no)";
							*/
							sql = " select a.po_line_no,a.cust_part_no,a.tsc_part_no,b.cust_part_no orig_cust_part_no,b.tsc_part_no orig_tsc_part_no"+
                                  " from ORADDMAN.TSCE_PURCHASE_ORDER_LINES a"+
								  " ,(select c.*  from (select b.*,row_number() over (partition by b.customer_po,b.po_line_no order by b.version_id desc) line_rank from ORADDMAN.TSCE_PURCHASE_ORDER_LINES b"+
                                  "  where b.customer_po='"+rs.getString("customer_po")+"'"+
								  "  and b.version_id < "+rs.getString("version_id")+""+
								  "  and b.data_flag not in ('X','I')) c) b"+
                                  " where a.version_id="+rs.getString("version_id")+""+
                                  " and a.customer_po='"+rs.getString("customer_po")+"'"+
								  " and a.customer_po=b.customer_po(+)"+
                                  " and a.po_line_no=b.po_line_no(+)"+
                                  " and (b.cust_part_no <> a.cust_part_no"+
                                  " or b.tsc_part_no <> a.tsc_part_no)"+
								  " and a.DATA_FLAG ='E'"; //add by Peggy 20210825							
							//out.println(sql);
							Statement statement1=con.createStatement();
							ResultSet rs1=statement1.executeQuery(sql);	
							while (rs1.next())
							{
								if (!rs1.getString("cust_part_no").equals(rs1.getString("orig_cust_part_no")))
								{
									exception_err+="項次:"+rs1.getString("po_line_no")+"  客戶品號:"+rs1.getString("cust_part_no")+"與上一版"+rs1.getString("orig_cust_part_no")+"不符<br>";
								}
								if (!rs1.getString("tsc_part_no").equals(rs1.getString("orig_tsc_part_no")))
								{
									exception_err+="項次:"+rs1.getString("po_line_no")+"  台半品號:"+rs1.getString("tsc_part_no")+"與上一版"+rs1.getString("orig_tsc_part_no")+"不符<br>";
								}
							}
							rs1.close();
							statement1.close();
						}
						out.println("<td align='left'>"+(exception_err.equals("")?"&nbsp;":"<font color='red'>"+exception_err+"</font>")+"</td>");
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

