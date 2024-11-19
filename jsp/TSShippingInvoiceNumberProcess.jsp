<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="MOShipBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSShippingInvoiceNumberProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="",err_msg="",irow="",v_batch_id="";
int rowcnt=0,err_cnt=0;
String invoice_year = request.getParameter("INVOICE_YEAR");
if (invoice_year==null) invoice_year="";
String ATYPE=request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String INVOICENO="";

try
{
	sql = "select APPS.TSC_GET_INVOICE_BATCH_ID_S.NEXTVAL from dual";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (!rs.next())
	{
		throw new Exception("No Data Found!!");
	}
	else
	{
		v_batch_id=rs.getString(1);
	}
	rs.close();
	statement.close();
	
	String v_autochk = request.getParameter("AUTOCHK");
	if (v_autochk==null) v_autochk="";
	if (v_autochk.equals("Y"))
	{
		String v_invoice_cnt = request.getParameter("INVOICECNT");
		if (v_invoice_cnt==null) v_invoice_cnt="";
		String v_invoice_sno = request.getParameter("INVOICESNO");
		if (v_invoice_sno==null) v_invoice_sno="";		
		String rdoValue=request.getParameter("rdo1");
		if (rdoValue==null) rdoValue="";	
		if (v_invoice_cnt.equals("") || rdoValue.equals("") || invoice_year.equals(""))
		{
			throw new Exception("Invoice create fail!!");
		}		
		
		String S_INVOICE_NO="",E_INVOICE_NO="";
		int cntError =0;
		CallableStatement cs1 = con.prepareCall("{call tsc_shipping_invoice_pkg.GET_INVOICE(?,?,?,?,?,?,?,?,?)}");
		cs1.setString(1, invoice_year);    
		cs1.setString(2, v_invoice_cnt);    
		cs1.setString(3, UserName);    
		cs1.setString(4, v_batch_id);    
		cs1.setString(5,rdoValue);    
		cs1.setString(6,v_invoice_sno);    
		cs1.registerOutParameter(7, Types.VARCHAR);   
		cs1.registerOutParameter(8, Types.VARCHAR);   
		cs1.setString(9,"N"); //人工取號,ADD BY PEGGY 20211013
		cs1.execute();
		S_INVOICE_NO = cs1.getString(7);                    
		E_INVOICE_NO = cs1.getString(8);                  
		cs1.close();
		
		if (!S_INVOICE_NO.startsWith("T-") || !E_INVOICE_NO.startsWith("T-"))
		{
			throw new Exception("action error!!");
		}
	}
	else
	{
		String chk[]= request.getParameterValues("chk");
		String chk1[]=null;
		int chk_cnt=0;
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			if (ATYPE.equals(""))
			{
				sql = " SELECT INVOICE_SEQ,INVOICE_NUMBER,last_updated_by,to_char(invoice_date,'yyyymmdd') invoice_date,sum(case when INVOICE_NUMBER IS not NULL then 1 else 0 end) OVER (PARTITION BY 1) tot_cnt FROM oraddman.TSC_SHIPPING_INVOICE_DETAIL a"+
					  " WHERE INVOICE_SEQ IN (";
				for(int i=0; i< chk.length ;i++)
				{
					sql +=(i>0?",":"")+"'"+request.getParameter("INVOICESEQ_"+chk[i])+"'";
					
				}
				sql += " ) for update OF INVOICE_NUMBER";
				//out.println(sql);
				statement=con.createStatement(); 
				rs=statement.executeQuery(sql);
				while (rs.next()) 
				{ 
					chk_cnt=0;
					if (rs.getInt("tot_cnt")==0)
					{
						irow=request.getParameter(rs.getString("INVOICE_SEQ"));
						
						//檢查來源單據號+客戶是否重複申請,add by Peggy 20230616
						sql = "select count(1) from oraddman.TSC_SHIPPING_INVOICE_DETAIL x where nvl(SOURCE_REFERENCE_NO,'-1111')='"+(request.getParameter("SOURCENO_"+irow)==null||request.getParameter("SOURCENO_"+irow).equals("")?"-1111":request.getParameter("SOURCENO_"+irow))+"' and nvl(SHIPPING_MARKS,'-2222')='"+(request.getParameter("SHIPPINGMARKS_"+irow)==null||request.getParameter("SHIPPINGMARKS_"+irow).equals("")?"-2222":request.getParameter("SHIPPINGMARKS_"+irow))+"'";
						Statement statement2=con.createStatement();
						ResultSet rs2=statement2.executeQuery(sql);
						//out.println(sql);
						if (rs2.next())
						{
							chk_cnt=rs2.getInt(1);
						}
						rs2.close();
						statement2.close();
						
					
						if (chk_cnt>0)
						{
							err_msg += "來源單據號碼:"+request.getParameter("SOURCENO_"+irow)+" 客戶:"+request.getParameter("SHIPPINGMARKS_"+irow)+" 已有取號記錄,不可重複申請\n";
						}
						else
						{
							sql = " update oraddman.TSC_SHIPPING_INVOICE_DETAIL "+
								  " set INVOICE_DATE=TO_DATE(?,'YYYYMMDD')"+
								  " ,INVOICE_NUMBER=?"+
								  " ,SALES_GROUP=?"+
								  " ,SHIPPING_MARKS=?"+
								  " ,SHIPPING_METHOD=?"+
								  " ,CURRENCY_CODE=?"+
								  " ,ORDER_TYPE=?"+
								  " ,SOURCE_REFERENCE_NO=?"+
								  " ,LAST_UPDATE_DATE=sysdate"+
								  " ,LAST_UPDATED_BY=?"+
								  " ,REMARKS=?"+
								  " ,BATCH_ID=?"+
								  ", AUTO_FLAG=?"+  //人工取號,ADD BY PEGGY 20211013
								  " where INVOICE_SEQ=?"+
								  " and INVOICE_NUMBER is null";
							//out.println(sql);
							PreparedStatement pstmtDt=con.prepareStatement(sql);
							pstmtDt.setString(1,request.getParameter("INVOICEDATE_"+irow));
							pstmtDt.setString(2,request.getParameter("INVOICENO_"+irow));
							pstmtDt.setString(3,request.getParameter("SALSEGROUP_"+irow));
							pstmtDt.setString(4,request.getParameter("SHIPPINGMARKS_"+irow));
							pstmtDt.setString(5,request.getParameter("SHIPMETHOD_"+irow));
							pstmtDt.setString(6,request.getParameter("CURRENCY_"+irow));
							pstmtDt.setString(7,request.getParameter("ORDER_"+irow));
							pstmtDt.setString(8,request.getParameter("SOURCENO_"+irow));
							pstmtDt.setString(9,UserName);
							pstmtDt.setString(10,request.getParameter("REMARKS_"+irow));
							pstmtDt.setString(11,v_batch_id);
							pstmtDt.setString(12,"N");
							pstmtDt.setString(13,rs.getString("INVOICE_SEQ"));
							pstmtDt.executeQuery();
							pstmtDt.close();
							rowcnt++;
						}
					}
					else if (rs.getString("INVOICE_NUMBER")!=null)
					{
						err_msg += rs.getString("INVOICE_SEQ")+"在"+rs.getString("invoice_date")+"已被"+rs.getString("last_updated_by")+"取用\n";
					}
				}
				rs.close();
				statement.close();
				
				if (!err_msg.equals("") || rowcnt==0)
				{
					//con.rollback();
					throw new Exception(err_msg);
				}
				else
				{
					con.commit();
				}
			}
			else
			{
				for(int i=0; i< chk.length ;i++)
				{
					sql = " update oraddman.TSC_SHIPPING_INVOICE_DETAIL "+
						  " set SHIPPING_MARKS=?"+
						  " ,SOURCE_REFERENCE_NO=?"+
						  " ,LAST_UPDATE_DATE=sysdate"+
						  " ,LAST_UPDATED_BY=?"+
						  " ,REMARKS=?"+
						  " where INVOICE_SEQ=?";
					//out.println(sql);
					PreparedStatement pstmtDt=con.prepareStatement(sql);
					pstmtDt.setString(1,request.getParameter("SHIPPINGMARKS_"+chk[i]));
					pstmtDt.setString(2,request.getParameter("SOURCENO_"+chk[i]));
					pstmtDt.setString(3,UserName);
					pstmtDt.setString(4,request.getParameter("REMARKS_"+chk[i]));
					pstmtDt.setString(5,request.getParameter("INVOICESEQ_"+chk[i]));
					pstmtDt.executeQuery();
					pstmtDt.close();
					INVOICENO=request.getParameter("INVOICESEQ_"+chk[i]);
				}
				con.commit();
			}
		}	
	}
	
	if (ATYPE.equals(""))
	{
		sql = " select row_number() over (order by INVOICE_SEQ) row_seq,a.* from oraddman.TSC_SHIPPING_INVOICE_DETAIL a "+
			  " WHERE BATCH_ID="+v_batch_id+""+
			  " order by INVOICE_SEQ";
		statement=con.createStatement();
		rs=statement.executeQuery(sql);
		while (rs.next())
		{
			if (rs.getInt(1)==1)
			{ 
				out.println("<div style='color:#0000FF;font-size:12px'>取號完成,結果如下....</div><table width='100%' border='1'>");
				out.println("<tr style='color:#000000'>");
				out.println("<td>序號</td>");
				out.println("<td>發票號碼</td>");
				out.println("<td>備註</td>");
				out.println("<td>來源單據號碼</td>");
				out.println("<td>業務區</td>");
				out.println("<td>客戶</td>");
				out.println("<td>出貨方式</td>");
				out.println("<td>幣別</td>");
				out.println("<td>訂單號碼</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td>"+rs.getString("ROW_SEQ")+"</td>");
			out.println("<td>"+rs.getString("INVOICE_NUMBER")+"</td>");
			out.println("<td>"+(rs.getString("REMARKS")==null?"&nbsp;":rs.getString("REMARKS"))+"</td>");
			out.println("<td>"+(rs.getString("SOURCE_REFERENCE_NO")==null?"&nbsp;":rs.getString("SOURCE_REFERENCE_NO"))+"</td>");
			out.println("<td>"+(rs.getString("SALES_GROUP")==null?"&nbsp;":rs.getString("SALES_GROUP"))+"</td>");
			out.println("<td>"+(rs.getString("SHIPPING_MARKS")==null?"&nbsp;":rs.getString("SHIPPING_MARKS"))+"</td>");
			out.println("<td>"+(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))+"</td>");
			out.println("<td>"+(rs.getString("CURRENCY_CODE")==null?"&nbsp;":rs.getString("CURRENCY_CODE"))+"</td>");
			out.println("<td>"+(rs.getString("ORDER_TYPE")==null?"&nbsp;":rs.getString("ORDER_TYPE"))+"</td>");
			out.println("</tr>");
		}
		rs.close();
		statement.close();
		out.println("</table>");
%>
	<br>
	<br>
	<div align="center"><a href="TSShippingInvoiceNumberQuery.jsp" style="font-size:12px">回發票歷史記錄畫面</a></div>
<%
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("修改成功!!");
			setSubmit("../jsp/TSShippingInvoiceNumberQuery.jsp?rdo_status=USED&INVOICE_NO=<%=INVOICENO%>");
		</script>	
	<%		
	}
	
}
catch(Exception e)
{
	con.rollback();
	out.println("<font color='#ff0000' size='2'>取號動作失敗!\n"+e.getMessage()+"!請洽系統維護人員...<font>");
	out.println("<br>");
	out.println("<font size='2'><a href='TSShippingInvoiceNumberQuery.jsp'>回發票平台畫面</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

