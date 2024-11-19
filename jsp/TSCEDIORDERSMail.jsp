<!--20150721 by Peggy,tsc_edi_pkg.GET_SPQ_MOQ參數異動-->
<!--20151209 Peggy,TSC_PROD_GROUP Issue-->
<!--20181222 by Peggy,新增original customer part no-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean,javax.mail.*,javax.mail.internet.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html> 
<head>
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit()
{
	document.SUBFORM.ACTION_TYPE.value="S";
	document.SUBFORM.send.disabled=true;
	document.SUBFORM.submit();	
}
</script>
</head>
<%
String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
if (ERPCUSTOMERID==null) ERPCUSTOMERID="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO==null) CUSTPO="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String chk[]= request.getParameterValues("CHKBOX");	
String PO_LIST = request.getParameter("PO_LIST");
if (PO_LIST==null) PO_LIST="";
String ACTION_TYPE = request.getParameter("ACTION_TYPE");
if (ACTION_TYPE==null) ACTION_TYPE="";
String MAIL_TO= request.getParameter("MAIL_TO");
if (MAIL_TO==null) MAIL_TO ="";
String MAIL_CC= request.getParameter("MAIL_CC");
if (MAIL_CC==null) MAIL_CC="";
String MAIL_SUBJECT=request.getParameter("MAIL_SUBJECT");
if (MAIL_SUBJECT==null) MAIL_SUBJECT="";
String MIN_ORDER_FLAG="",MIN_ORDER_AMT="",MIN_ORDER_CURR="";
float TOT_ORDER_AMT=0;
String MAIL_BODY="",CUSTNAME="",CURRENCY="",REQUEST_DATE="";
String sql="",remarks="",CUSTOMER_NUMBER="",CUSTOMER_NAME="",REGION_CODE="";
StringBuffer sb = new StringBuffer();
if (chk!=null)
{
	for(int i=0; i< chk.length ;i++)
	{
		if (PO_LIST.length() >0) PO_LIST +=",";
		PO_LIST += "'"+request.getParameter("SEQ_NO_"+chk[i])+"'";
	}
}

if (ERPCUSTOMERID.equals("") || CUSTPO.equals("") || REQUESTNO.equals("") || PO_LIST.equals(""))
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("資訊不完整,無法進行mail寄送作業,謝謝!");
		location.href="../jsp/TSCEDIExceptionQuery.jsp";
	</script>
<%
}

try
{
	sql = " SELECT b.CUSTOMER_NUMBER,b.CUSTOMER_NAME_PHONETIC,a.MAIL_TO,a.MAIL_CC,c.REQUEST_DATE,c.CURRENCY_CODE,a.REGION1,b.CUSTOMER_NAME "+
		  ",nvl(a.MIN_ORDER_FLAG,'N') MIN_ORDER_FLAG,nvl(a.MIN_ORDER_AMT,0) MIN_ORDER_AMT,nvl(a.MIN_ORDER_CURR,'') MIN_ORDER_CURR"+ //add by Peggy 20140801
		  " from tsc_edi_customer a"+
		  ",AR_CUSTOMERS b "+
		  ",tsc_edi_orders_his_h c"+
		  " where a.CUSTOMER_ID=? "+
		  " and a.CUSTOMER_ID=b.CUSTOMER_ID"+
		  " and a.CUSTOMER_ID=c.ERP_CUSTOMER_ID"+
		  " and c.REQUEST_NO=?"+
		  " and c.CUSTOMER_PO=?";		
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,ERPCUSTOMERID);
	statement.setString(2,REQUESTNO);
	statement.setString(3,CUSTPO);
	ResultSet rs=statement.executeQuery();
	if (rs.next())
	{
		CUSTOMER_NUMBER = rs.getString("CUSTOMER_NUMBER");
		CUSTOMER_NAME = rs.getString("CUSTOMER_NAME");
		REGION_CODE = rs.getString("REGION1");
		if (!ACTION_TYPE.equals("S"))
		{
			MAIL_TO = rs.getString("MAIL_TO");
			MAIL_CC = rs.getString("MAIL_CC");
			MAIL_SUBJECT = "TSC EDI Order Issue Notice - "+rs.getString("CUSTOMER_NAME_PHONETIC")+ " PO: "+CUSTPO;
		}
		CUSTNAME = rs.getString("CUSTOMER_NAME_PHONETIC");
		CURRENCY = rs.getString("CURRENCY_CODE");
		REQUEST_DATE = rs.getString("REQUEST_DATE");
		MIN_ORDER_FLAG=rs.getString("MIN_ORDER_FLAG");         //add by Peggy 20140801
		MIN_ORDER_AMT =rs.getString("MIN_ORDER_AMT");          //add by Peggy 20140801
		MIN_ORDER_CURR = rs.getString("MIN_ORDER_CURR");       //add by Peggy 20140801		
	}
	rs.close();
	statement.close();	
	
	if (MAIL_CC.indexOf(userMail)<0) MAIL_CC += ","+userMail;

	sb.append("<table align='left' width='100%' border='1' bordercolorlight='#E3E3E3' bordercolordark='#CCCCFF' cellpadding='0' cellspacing='1' bgcolor='#FFFFFF'>");
	sb.append("<tr>");
	sb.append("<td>");
	sb.append("<table width='100%' border='1' bordercolordark='#000000' bordercolorlight='#E3E3E3' cellpadding='0' cellspacing='1'>");
	sb.append("<tr height='25'>");
	sb.append("<td width='13%' bgcolor='#DAEBFE'><font face='Tahoma,Georgia' size='2'>Customer Name</font></td>");
	sb.append("<td width='20%'><font face='Tahoma,Georgia' size='2'>"+CUSTNAME+"</font></td>");
	sb.append("<td width='10%' bgcolor='#DAEBFE'><font face='Tahoma,Georgia' size='2'>P/O No.</font></td>");
	sb.append("<td width='15%'><font face='Tahoma,Georgia' size='2'>"+CUSTPO+"<font></td>");
	sb.append("<td width='10%' bgcolor='#DAEBFE'><font face='Tahoma,Georgia' size='2'>Currency</font></td>");
	sb.append("<td width='10%'><font face='Tahoma,Georgia' size='2'>"+CURRENCY+"</font></td>");
	sb.append("<td width='12%' bgcolor='#DAEBFE'><font face='Tahoma,Georgia' size='2'>Request Date</font></td>");
	sb.append("<td width='10%'><font face='Tahoma,Georgia' size='2'>"+REQUEST_DATE+"</font></td>");							
	sb.append("</tr>");
	sb.append("<tr bgcolor='#DAEBFE'><td colspan='8'><font face='arial' size='2'>Description</font></td></tr>");
	sb.append("<tr>");
	sb.append("<td colspan='8'>");
	sb.append("<table width='100%' border='1' bordercolordark='#000000' bordercolorlight='#E3E3E3' cellpadding='1' cellspacing='1'>");
	sb.append("<tr bgcolor='#DAEBFE'>");
	sb.append("<td width='8%'><font face='Tahoma,Georgia' size='2'>PO Line No.</font></td>");
	sb.append("<td width='12%'><font face='Tahoma,Georgia' size='2'>Customer P/N</font></td>");
	sb.append("<td width='12%'><font face='Tahoma,Georgia' size='2'>Part Number</font></td>");
	sb.append("<td width='8%'><font face='Tahoma,Georgia' size='2'>Qty</font></td>");
	sb.append("<td width='5%'><font face='Tahoma,Georgia' size='2'>UOM</font></td>");
	sb.append("<td width='7%'><font face='Tahoma,Georgia' size='2'>U/P</font></td>");
	sb.append("<td width='8%'><font face='Tahoma,Georgia' size='2'>CRD</font></td>");
	sb.append("<td width='18%'><font face='Tahoma,Georgia' size='2'>Order abnormal Type</font></td>");
	sb.append("<td width='22%'><font face='Tahoma,Georgia' size='2'>Remarks</font></td>");
	sb.append("</tr>");
	try
	{
		sql = " select CUST_PO_LINE_NO,CUST_ITEM_NAME,TSC_ITEM_NAME ,QUANTITY ,UNIT_PRICE ,UOM,CUST_REQUEST_DATE,SEQ_NO"+
		      ",(select count(1) from tsc_edi_orders_his_d b where b.request_no=a.request_no and b.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID and b.CUST_PO_LINE_NO=a.CUST_PO_LINE_NO) po_line_cnt "+
			  ",(select sum(QUANTITY*UNIT_PRICE) from  tsc_edi_orders_his_d x where x.request_no=a.request_no and x.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID) ORDER_AMT"+ //add by Peggy 20140801
		      " FROM tsc_edi_orders_his_d a"+
			  " where request_no=?"+
			  " and ERP_CUSTOMER_ID =?"+
			  " and SEQ_NO in ("+PO_LIST+") order by CUST_PO_LINE_NO,SEQ_NO ";
		statement = con.prepareStatement(sql);
		statement.setString(1,REQUESTNO);
		statement.setString(2,ERPCUSTOMERID);
		rs=statement.executeQuery();
		String po_line_no="",Abnormal_Type="",SPQ="",MOQ="",Remarks="";
		int irow=0;
		while (rs.next())
		{
			Abnormal_Type="";Remarks="";irow++;
			sb.append("<tr>");
			if (!po_line_no.equals(rs.getString("CUST_PO_LINE_NO")))
			{
				sb.append("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'><font face='Tahoma,Georgia' size='2'>"+rs.getString("CUST_PO_LINE_NO")+"</font></td>");
				po_line_no=rs.getString("CUST_PO_LINE_NO");
			}
			sb.append("<td><font face='Tahoma,Georgia' size='2'>"+rs.getString("CUST_ITEM_NAME")+"</font></td>");
			sb.append("<td><font face='Tahoma,Georgia' ?01>"+rs.getString("TSC_ITEM_NAME")+"</font></td>");
			sb.append("<td><font face='Tahoma,Georgia' ?02>"+rs.getString("QUANTITY")+"</font></td>");
			sb.append("<td><font face='Tahoma,Georgia' size='2'>"+rs.getString("UOM")+"</font></td>");
			sb.append("<td><font face='Tahoma,Georgia' size='2'>"+(new DecimalFormat("#####0.####")).format(rs.getFloat("UNIT_PRICE"))+"</font></td>");
			sb.append("<td><font face='Tahoma,Georgia' size='2'>"+rs.getString("CUST_REQUEST_DATE")+"</font></td>");
			
			//add by Peggy 20140801
			if (MIN_ORDER_FLAG.equals("Y") && irow==1)
			{
				if (rs.getFloat("ORDER_AMT") < Float.parseFloat(MIN_ORDER_AMT))
				{
					Abnormal_Type += "Order value less than 200 USD\r\n";
					Remarks+="Order Amount:"+rs.getString("ORDER_AMT") +" < "+MIN_ORDER_AMT+" "+ MIN_ORDER_CURR+"\r\n";
					if (sb.indexOf("?02") >=0) sb.replace(sb.indexOf("?02"),sb.indexOf("?02")+3,"size='3' color='#ff0000'");
				}
				if (!CURRENCY.equals(MIN_ORDER_CURR))
				{
					Abnormal_Type += "Currency check\r\n";
					Remarks+="Currency:"+CURRENCY +" <> "+ MIN_ORDER_CURR+"\r\n";
				}
			}
					
			sql = " SELECT  msi.segment1,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3,msi.inventory_item_id,"+
				  " NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE,"+
				  " NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY,"+
				  " CASE WHEN NVL(msi.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP"+
				  " from inv.mtl_system_items_b msi"+
				  " ,oraddman.tsprod_manufactory d"+ //by Peggy 20151209
				  " where  msi.ORGANIZATION_ID =?"+
				  " and msi.inventory_item_status_code <> ?"+
				  " and msi.attribute3=d.MANUFACTORY_NO(+)"+
				  " and msi.description =?";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,"49");
			statement1.setString(2,"Inactive");
			statement1.setString(3,rs.getString("TSC_ITEM_NAME"));
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())				  
			{
				//CallableStatement cse = con.prepareCall("{call tsc_edi_pkg.GET_SPQ_MOQ(?,?,?,?,?,?)}");
				//cse.setString(1,rs1.getString("TSC_PACKAGE"));      
				//cse.setString(2,rs1.getString("TSC_PROD_GROUP"));                   
				//cse.setString(3,rs1.getString("TSC_FAMILY"));                   
				//cse.setString(4,rs1.getString("SEGMENT1"));    
				//cse.registerOutParameter(5, Types.VARCHAR);    
				//cse.registerOutParameter(6, Types.VARCHAR);  
				//cse.execute();
				//SPQ = ""+(Float.parseFloat(cse.getString(5)));                     
				//MOQ = ""+(Float.parseFloat(cse.getString(6)));                
				//cse.close();	
				//modify by Peggy 20150721
				CallableStatement cse = con.prepareCall("{call tsc_edi_pkg.GET_SPQ_MOQ(?,?,?,?)}");
				cse.setString(1,rs1.getString("INVENTORY_ITEM_ID"));
				cse.setString(2,rs1.getString("ATTRIBUTE3"));      
				cse.registerOutParameter(3, Types.VARCHAR);  
				cse.registerOutParameter(4, Types.VARCHAR);  
				cse.execute();
				SPQ = ""+(cse.getFloat(3)/1000);                     
				MOQ = ""+(cse.getFloat(4)/1000); 						            
				cse.close();					
				
				if (SPQ.equals("0") || MOQ.equals("0") || rs.getFloat("QUANTITY")%Float.parseFloat(SPQ) !=0 || rs.getFloat("QUANTITY")<Float.parseFloat(MOQ))
				{
					Abnormal_Type += "SPQ/MOQ check\r\n";
					Remarks+="SPQ:"+(new DecimalFormat("#####0.####")).format(Float.parseFloat(SPQ))+ "   MOQ:"+(new DecimalFormat("#####0.####")).format(Float.parseFloat(MOQ))+"\r\n";
					if (sb.indexOf("?02") >=0) sb.replace(sb.indexOf("?02"),sb.indexOf("?02")+3,"size='3' color='#ff0000'");
				}
			}
			else
			{
				Abnormal_Type += "Material Part Number Error\r\n";
				if (sb.indexOf("?01") >=0) sb.replace(sb.indexOf("?01"),sb.indexOf("?01")+3,"size='3' color='#ff0000'");
			}
			rs1.close();
			statement1.close();

			if (sb.indexOf("?01") >=0) sb.replace(sb.indexOf("?01"),sb.indexOf("?01")+3,"size='2' color='#000000'");
			if (sb.indexOf("?02") >=0) sb.replace(sb.indexOf("?02"),sb.indexOf("?02")+3,"size='2' color='#000000'");
				
			if (!ACTION_TYPE.equals("S"))
			{	

				sb.append("<td><textarea cols='30' rows='6' name='ISSUETYPE_"+irow+"'>"+(Abnormal_Type.equals("")?"&nbsp;":Abnormal_Type)+"</textarea>"+"</td>");
				sb.append("<td><textarea cols='35' rows='6' name='REMARKS_"+irow+"'>"+(Remarks.equals("")?"&nbsp;":Remarks)+"</textarea>"+"</td>");
			}
			else
			{
				sql = " update TSC_EDI_ORDERS_HIS_D a"+
					  " set ISSUE_REASON=?"+
					  " where REQUEST_NO=?"+
					  " and ERP_CUSTOMER_ID=?"+
					  " and CUST_PO_LINE_NO =?"+
					  " and SEQ_NO =?";
				PreparedStatement pstmtDt2=con.prepareStatement(sql);  
				pstmtDt2.setString(1,request.getParameter("ISSUETYPE_"+irow)); 
				pstmtDt2.setString(2,REQUESTNO);
				pstmtDt2.setString(3,ERPCUSTOMERID);
				pstmtDt2.setString(4,rs.getString("CUST_PO_LINE_NO")); 
				pstmtDt2.setString(5,rs.getString("SEQ_NO")); 
				pstmtDt2.executeUpdate();
				pstmtDt2.close();		
					
				sb.append("<td><font face='Tahoma,Georgia' size='2' color='#ff0000'>"+request.getParameter("ISSUETYPE_"+irow).replace("\r\n","<br>")+"</font></td>");
				sb.append("<td><font face='Tahoma,Georgia' size='2' color='#0000ff'>"+request.getParameter("REMARKS_"+irow).replace("\r\n","<br>")+"</font></td>");
			}
			sb.append("</tr>");			
		}	
		rs.close();  
		statement.close();
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}												
	sb.append("</table>");
	sb.append("</td>");
	sb.append("</tr>");
	sb.append("</table>");
	sb.append("</td>");
	sb.append("</tr>");
	sb.append("</table>");
}
catch(Exception e)
{
	out.println(e.getMessage());
	%>
		<script language="javascript">
		alert("客戶資料查詢失敗!!");
		location.href="../jsp/TSCEDIExceptionQuery.jsp";
		</script>
	<%
}
%>
<body>
<form name="SUBFORM"  METHOD="post" ACTION="TSCEDIORDERSMail.jsp">
<input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>">
<input type="hidden" name="CUSTPO" value="<%=CUSTPO%>">
<input type="hidden" name="REQUESTNO" value="<%=REQUESTNO%>">
<input type="hidden" name="PO_LIST" value="<%=PO_LIST%>">
<input type="hidden" name="ACTION_TYPE" value="">
	<table align="center" width="80%" border="0" bordercolorlight="#E3E3E3" bordercolordark="#E4E4E4" cellpadding="0" cellspacing="1" bgcolor="#E0E3FE">
		<tr style="height:35" bgcolor="#E0E3FE">
			<td rowspan="3" width="10%" align="center"><input type="button" name="send" value="傳送" style="width:70;height:80" onClick="setSubmit()"></td>
			<td width="7%">收件者：</td>
			<td width="83%"><input type="text" name="MAIL_TO" value="<%=MAIL_TO%>" style="height:25;font-family:Tahoma,Georgia" size="100"></td>
		</tr>	
		<tr style="height:35" bgcolor="#E0E3FE">
			<td>副本：</td>
			<td><input type="text" name="MAIL_CC" value="<%=MAIL_CC%>" style="height:25;font-family:Tahoma,Georgia" size="100"></td>
		</tr>			
		<tr style="height:35" bgcolor="#E0E3FE">
			<td>主旨：</td>
			<td><input type="text" name="MAIL_SUBJECT" value="<%=MAIL_SUBJECT%>" style="height:25;font-family:Tahoma,Georgia" size="100"></td>
		</tr>
		<tr>
			<td colspan="3">
				<%=sb.toString()%>
			</td>
		</tr>			
	</table>
<%
if (ACTION_TYPE.equals("S"))
{
	try
	{
		sql = "SELECT 1 FROM daphne_proforma_temp a where CUST_PO_NUMBER=? and CUSTOMER_NO=?";
		PreparedStatement state1 = con.prepareStatement(sql);
		state1.setString(1,CUSTPO);
		state1.setString(2,CUSTOMER_NUMBER);
		ResultSet rs1=state1.executeQuery();
		if (!rs1.next())
		{
			sql=" insert into daphne_proforma_temp (ORDER_NUMBER, CUST_PO_NUMBER,CUSTOMER_NAME, FLAG, CUSTOMER_NO ,CREATION_DATE,REGION1)"+
				" values(?,?,?,?,?,to_char(sysdate,'yyyymmddhh24miss'),?)";
			PreparedStatement pstmtDt3=con.prepareStatement(sql);  
			pstmtDt3.setString(1,"1141"+(CUSTPO.length()>=5?CUSTPO.substring(CUSTPO.length()-5):CUSTPO)); 
			pstmtDt3.setString(2,CUSTPO);
			pstmtDt3.setString(3,CUSTOMER_NAME); 
			pstmtDt3.setString(4,"Y"); 
			pstmtDt3.setString(5,CUSTOMER_NUMBER); 
			pstmtDt3.setString(6,REGION_CODE); 
			pstmtDt3.executeQuery();
			pstmtDt3.close();		
		}
		rs1.close();
		state1.close();
		
		sql = "SELECT 1 FROM tsc_edi_orders_header a  where ERP_CUSTOMER_ID=?  and CUSTOMER_PO=?";
		PreparedStatement state2 = con.prepareStatement(sql);
		state2.setString(1,ERPCUSTOMERID);
		state2.setString(2,CUSTPO);
		ResultSet rs2=state2.executeQuery();
		if (!rs2.next())
		{
			sql=" insert into tsc_edi_orders_header(erp_customer_id, customer_po, version_id, request_date, by_code, dp_code, se_code, currency_code,creation_date, data_flag)"+
				" select a.erp_customer_id,a.customer_po,0,a.request_date,a.by_code,a.dp_code,a.se_code,a.currency_code,sysdate,'Y' from tsc_edi_orders_his_h a  "+     
				" where a.request_no=?"+
				" and a.erp_customer_id=?"+
				" and a.customer_po=?";
			PreparedStatement pstmtDt3=con.prepareStatement(sql);  
			pstmtDt3.setString(1,REQUESTNO); 
			pstmtDt3.setString(2,ERPCUSTOMERID);
			pstmtDt3.setString(3,CUSTPO); 
			pstmtDt3.executeQuery();
			pstmtDt3.close();
		}
		rs2.close();
		state2.close(); 
			
		sql = " delete 	tsc_edi_orders_detail a"+
			  " where erp_customer_id=?"+
			  " and customer_po=?"+
			  " and exists (select 1 from tsc_edi_orders_his_d b where b.request_no=?"+
			  " and b.erp_customer_id=?"+
			  " and b.seq_no IN ("+PO_LIST+")"+
			  " and b.cust_po_line_no=a.cust_po_line_no)";
		PreparedStatement pstmtDt2=con.prepareStatement(sql);  
		pstmtDt2.setString(1,ERPCUSTOMERID); 
		pstmtDt2.setString(2,CUSTPO);
		pstmtDt2.setString(3,REQUESTNO); 
		pstmtDt2.setString(4,ERPCUSTOMERID);
		pstmtDt2.executeQuery();
		pstmtDt2.close();
				  
		sql = " insert into tsc_edi_orders_detail(erp_customer_id, customer_po, version_id, cust_po_line_no, seq_no, cust_item_name, tsc_item_name,quantity, uom, unit_price, cust_request_date,creation_date,DATA_FLAG,REMARKS,MAILED_DATE,MAILED_BY,ISSUE_REASON,orig_cust_item_name,orig_tsc_item_name)"+  //add orig_cust_item_name by Peggy 20181222
						  " select a.erp_customer_id,c.customer_po,0,a.cust_po_line_no,a.cust_po_line_no||'.'||to_char(nvl((select count(1) from tsc_edi_orders_detail b where b.customer_po=c.customer_po and b.erp_customer_id=a.erp_customer_id and b.cust_po_line_no=a.cust_po_line_no),1)+1) ,a.cust_item_name,a.tsc_item_name,a.quantity,a.uom,a.unit_price,a.cust_request_date,sysdate,?,?,sysdate,?,a.ISSUE_REASON,a.orig_cust_item_name,a.orig_tsc_item_name"+ //add orig_cust_item_name by Peggy 20181222
						  " from tsc_edi_orders_his_d a,tsc_edi_orders_his_h c"+
						  " where a.request_no=?"+
						  " and a.erp_customer_id=?"+
						  " and c.customer_po=?"+
						  " and a.seq_no IN ("+PO_LIST+")"+
						  " and a.request_no=c.request_no"+
						  " and a.erp_customer_id=c.erp_customer_id";
		pstmtDt2=con.prepareStatement(sql);  
		pstmtDt2.setString(1,"P"); 
		pstmtDt2.setString(2,"");
		pstmtDt2.setString(3,UserName);
		pstmtDt2.setString(4,REQUESTNO); 
		pstmtDt2.setString(5,ERPCUSTOMERID);
		pstmtDt2.setString(6,CUSTPO); 
		pstmtDt2.executeQuery();
		pstmtDt2.close();
		
		sql = " update TSC_EDI_ORDERS_HIS_D a"+
		      " set MAILED_DATE=sysdate"+
			  ",LAST_UPDATED_BY=?"+
			  ",LAST_UPDATE_DATE=sysdate"+
			  ",DATA_FLAG=?"+
			  " where REQUEST_NO=?"+
			  " and ERP_CUSTOMER_ID=?"+
			  " and seq_no IN ("+PO_LIST+")";
		pstmtDt2=con.prepareStatement(sql);  
		pstmtDt2.setString(1,UserName); 
		pstmtDt2.setString(2,"N");
		pstmtDt2.setString(3,REQUESTNO);
		pstmtDt2.setString(4,ERPCUSTOMERID); 
		pstmtDt2.executeQuery();
		pstmtDt2.close();	
			
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&  request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			//String mail_to_list [] = (MAIL_TO.replace(";",",")).split(",");
			//for (int k = 0 ; k < mail_to_list.length ; k++)
			//{
			//	message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(mail_to_list[k]));
			//}			
			//String mail_cc_list [] = (MAIL_CC.replace(";",",")).split(",");
			//for (int m = 0 ; m < mail_cc_list.length ; m++)
			//{
			//	message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress(mail_cc_list[m]));
			//}			
		}
		else
		{
			remarks="";
			String mail_to_list [] = (MAIL_TO.replace(";",",")).split(",");
			for (int k = 0 ; k < mail_to_list.length ; k++)
			{
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(mail_to_list[k]));
			}
			String mail_cc_list [] = (MAIL_CC.replace(";",",")).split(",");
			for (int m = 0 ; m < mail_cc_list.length ; m++)
			{
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress(mail_cc_list[m]));
			}
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject(MAIL_SUBJECT+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		mbp.setContent("<table align='left' width='80%'><tr><td>"+sb.toString()+"</td></tr></table>", "text/html;charset=UTF-8");
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
	
		con.commit();
	%>
		<script language="javascript">
		location.href="../jsp/TSCEDIExceptionQuery.jsp";
		alert("寄送成功!!");
		</script>
	<%		
	}
	catch(Exception e)
	{
		con.rollback();
		//out.println(sql);
	%>
		<script language="javascript">
		location.href="../jsp/TSCEDIORDERSDetail.jsp?REQUESTNO="+document.SUBFORM.REQUESTNO.value+"&ERPCUSTOMERID="+document.SUBFORM.ERPCUSTOMERID.value+"&CUSTPO="+document.SUBFORM.CUSTPO.value;
		alert("寄送失敗!!");
		</script>		
	<%
	}
}
%>
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>