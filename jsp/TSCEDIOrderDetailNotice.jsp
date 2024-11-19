<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean,javax.mail.*,javax.mail.internet.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html> 
<head>
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Verdana; color: #000000; font-size: 12px }
  P         { font-family: Verdana; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Verdana; font-size: 12px }
  TD        { font-family: Verdana; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  .style1   {font-weight:bold;color:#000000;font-size:12px;font-family:Verdana;}
  .style2   {font-family:Verdana;font-size:12px;}
  .style3   {font-family:Verdana;font-weight:bold;font-size:12px;color:#000000;}
  .style4   {color:#999999;font-family:Verdana;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0px";
		window.opener.document.getElementById("alpha").style.height="0px";
		this.window.close();				
    }  
} 
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	this.window.close();				
}
function setsubmit(URL)
{
	if (document.SUBFORM.CHK_FLAG.checked==true)
	{
		if (document.SUBFORM.REMARKS.value ==null ||  document.SUBFORM.REMARKS.value=="")
		{
			alert("請輸入訂單取消原因!");
			return false;
		}
	}
	document.SUBFORM.action=URL;
 	document.SUBFORM.submit();
}

</script>
</head>
<%
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO==null) CUSTPO="";
String CUSTID = request.getParameter("CUSTID");
if (CUSTID==null) CUSTID="";
String SEQNO = request.getParameter("SEQNO");
if (SEQNO==null) SEQNO="";
String ACTION_TYPE = request.getParameter("ACTION_TYPE");
if (ACTION_TYPE==null) ACTION_TYPE="";
String REMARKS= request.getParameter("REMARKS");
if (REMARKS==null) REMARKS="";
String CHK_FLAG = request.getParameter("CHK_FLAG");
if (CHK_FLAG==null) CHK_FLAG="";
String CUST_PO_LINE_NO = request.getParameter("CUST_PO_LINE_NO");
if (CUST_PO_LINE_NO==null) CUST_PO_LINE_NO="";
String TSC_ITEM_NAME = request.getParameter("TSC_ITEM_NAME");
if (TSC_ITEM_NAME==null) TSC_ITEM_NAME="";
String REGION_CODE = request.getParameter("REGION_CODE");           //add by Peggy 20141202
if (REGION_CODE==null) REGION_CODE="";
String CUSTOMER_NUMBER = request.getParameter("CUSTOMER_NUMBER");   //add by Peggy 20141202
if (CUSTOMER_NUMBER==null) CUSTOMER_NUMBER="";
String CUSTOMER_NAME = request.getParameter("CUSTOMER_NAME");       //add by Peggy 20141202
if (CUSTOMER_NAME==null) CUSTOMER_NAME="";
String ODRCHG_NOTICE_FLAG=request.getParameter("ODRCHG_NOTICE_FLAG");
if (ODRCHG_NOTICE_FLAG==null) ODRCHG_NOTICE_FLAG="";                //add by Peggy 20190403
String sql ="",DateNoFound="N";

try
{
	if (ACTION_TYPE.equals(""))
	{
		sql = " SELECT a.CUST_PO_LINE_NO,a.TSC_ITEM_NAME,a.data_flag,a.remarks,b.REGION1,c.CUSTOMER_NUMBER,c.CUSTOMER_NAME,a.ORDER_CHANGE_NOTICE_FLAG "+
		      " from apps.tsc_edi_orders_detail a,apps.tsc_edi_customer b,ar_customers c"+
			  " where a.ERP_CUSTOMER_ID=?"+
			  " and a.CUSTOMER_PO=?"+
			  " and a.SEQ_NO=?"+
			  " and a.ERP_CUSTOMER_ID=b.CUSTOMER_ID"+
			  " and b.CUSTOMER_ID=c.CUSTOMER_ID";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,CUSTID);
		statement.setString(2,CUSTPO);
		statement.setString(3,SEQNO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			CUST_PO_LINE_NO = rs.getString("CUST_PO_LINE_NO");
			if (CUST_PO_LINE_NO==null) CUST_PO_LINE_NO="";
			TSC_ITEM_NAME = rs.getString("TSC_ITEM_NAME");
			if (TSC_ITEM_NAME==null) TSC_ITEM_NAME="";
			CHK_FLAG = rs.getString("data_flag");
			if (CHK_FLAG ==null) CHK_FLAG ="";
			REMARKS = rs.getString("REMARKS");
			if (REMARKS==null) REMARKS="";
			CUSTOMER_NAME=rs.getString("CUSTOMER_NAME");     //add by Peggy 20141202
			REGION_CODE=rs.getString("REGION1");             //add by Peggy 20141202
			CUSTOMER_NUMBER=rs.getString("CUSTOMER_NUMBER"); //add by Peggy 20141202  
			ODRCHG_NOTICE_FLAG=rs.getString("ORDER_CHANGE_NOTICE_FLAG"); //add by Peggy 20190403
			if (ODRCHG_NOTICE_FLAG==null) ODRCHG_NOTICE_FLAG="";
			DateNoFound="Y";
		}
		rs.close();
		statement.close();	
		
		if (!DateNoFound.equals("Y"))
		{
		%>
			<script language="javascript">
			alert("No Data Found!!");
			setClose();
			</script>
		<%
		}
	}
}
catch(Exception e)
{
	out.println(e.getMessage());
}

%>
<body bgcolor="#EFF4DD">
<form name="SUBFORM"  METHOD="post" ACTION="TSCEDIOrderDetailNotice.jsp">
	<table align="center" width="60%" border="1" bordercolorlight="#E3E3E3" bordercolordark="#E4E4E4" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="1"n bgcolor="#FFFFFF">
					<tr>
						<td width="100%" class="style1">Customer PO:<%=CUSTPO%>
						<input type="hidden" name="CUSTPO" value="<%=CUSTPO%>">
						<input type="hidden" name="CUSTID" value="<%=CUSTID%>">
						<input type="hidden" name="SEQNO"  value="<%=SEQNO%>">
						<input type="hidden" name="CUSTOMER_NAME"  value="<%=CUSTOMER_NAME%>">
						<input type="hidden" name="REGION_CODE"  value="<%=REGION_CODE%>">
						<input type="hidden" name="CUSTOMER_NUMBER"  value="<%=CUSTOMER_NUMBER%>">
						</td>
					</tr>
					<tr>
						<td width="100%" class="style1">Customer PO Line:<%=CUST_PO_LINE_NO%>
						<input type="hidden" name="CUST_PO_LINE_NO" value="<%=CUST_PO_LINE_NO%>">
						</td>
					</tr>					
					<tr>
						<td width="100%" class="style1">TSC Item Desc:<%=TSC_ITEM_NAME%>
						<input type="hidden" name="TSC_ITEM_NAME" value="<%=TSC_ITEM_NAME%>">
						</td>
					</tr>					
					<TR><TD>&nbsp;</TD></TR>
					<tr>
						<td><input type="checkbox" name="CHK_FLAG" value="C" <%=(CHK_FLAG.equals("C")?"CHECKED":"")%>>訂單取消</td>
					</tr>
					<tr>
						<td><input type="checkbox" name="ODRCHG_NOTICE_FLAG" value="Y" <%=(ODRCHG_NOTICE_FLAG.equals("Y")?"CHECKED":"")%>>
						Order Change Warnning </td>
					</tr>
					<tr>
						<td><font class="style3"><br>Remarks:</font><br>
						<textarea cols="70" rows="5" name="REMARKS" class="style2"><%=REMARKS%></textarea>
						</td>
					</tr>
					<tr>
						<td><br><br><input type="button" name="save" class="style2" value="Submit" onClick="setsubmit('../jsp/TSCEDIOrderDetailNotice.jsp?ACTION_TYPE=SAVE');">
						&nbsp;&nbsp;&nbsp;<input type="button" name="closed" class="style2" value="Closed" onClick="setClose()">
						</td>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
<%
if (ACTION_TYPE.equals("SAVE"))
{
	try
	{
		sql = " update apps.tsc_edi_orders_detail a"+
			  " set DATA_FLAG=?"+
			  ",REMARKS=?"+
			  ",ORDER_CHANGE_NOTICE_FLAG=?"+
			  " where ERP_CUSTOMER_ID=?"+
			  " and CUSTOMER_PO=?"+
			  " and SEQ_NO=?";
		//out.println(sql);
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,CHK_FLAG);
		pstmtDt.setString(2,REMARKS);
		pstmtDt.setString(3,ODRCHG_NOTICE_FLAG);
		pstmtDt.setString(4,CUSTID);
		pstmtDt.setString(5,CUSTPO);
		pstmtDt.setString(6,SEQNO);
		pstmtDt.executeQuery();
		pstmtDt.close();

		sql = "SELECT count(1),SUM(CASE WHEN DATA_FLAG='C' THEN 1 ELSE 0 END) CANCEL_CNT FROM apps.tsc_edi_orders_detail a where ERP_CUSTOMER_ID=? and CUSTOMER_PO=?";
		PreparedStatement state1 = con.prepareStatement(sql);
		state1.setString(1,CUSTID);
		state1.setString(2,CUSTPO);
		ResultSet rs1=state1.executeQuery();
		if (rs1.next())
		{
			if (rs1.getInt(1)==1 || rs1.getInt(1)==rs1.getInt(2))
			{
				//sql = "SELECT 1 FROM daphne_proforma_temp a where CUST_PO_NUMBER=? and CUSTOMER_NO=?";
				//modify by Peggy 20200824
				sql = " select count(a.cust_po_number) po_cnt,count(b.order_number) mo_cnt,nvl(a.ORDER_NUMBER,'0') mo "+
				      " from daphne_proforma_temp a,ont.oe_order_headers_all b"+
				      " where a.CUST_PO_NUMBER=?"+
					  " and a.CUSTOMER_NO=?"+
                      " and a.order_number=b.order_number(+)"+
					  " group by nvl(a.ORDER_NUMBER,'0')";			
				PreparedStatement state2 = con.prepareStatement(sql);
				state2.setString(1,CUSTPO);
				state2.setString(2,CUSTOMER_NUMBER);
				ResultSet rs2=state2.executeQuery();
				if (rs2.next())
				{
					//erp查無訂單,add by Peggy 20200824
					if (rs2.getInt(2)==0 && rs2.getString(3).length()!=9)
					{
						sql= " update daphne_proforma_temp "+
						     " set CUST_PO_NUMBER=CUST_PO_NUMBER||?"+
							 ",UPDATED_BY=?"+
							 ",UPDATED_DATE=SYSDATE"+
						     " where CUST_PO_NUMBER=?"+
      					     " and CUSTOMER_NO=?";
						PreparedStatement pstmtDt3=con.prepareStatement(sql);  
						pstmtDt3.setString(1,"DELETE"); 
						pstmtDt3.setString(2,"RFQ");
						pstmtDt3.setString(3,CUSTPO); 
						pstmtDt3.setString(4,CUSTOMER_NUMBER); 
						pstmtDt3.executeQuery();
						pstmtDt3.close();							
					}				
					
					if (rs2.getInt(1)==0 || (rs2.getInt(2)==0 && rs2.getString(3).length()!=9))
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
				}
				else
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
				rs2.close();
				state2.close();
			}
		}
		rs1.close();
		state1.close();
		
		con.commit();
		
	%>
	<script language="javascript">
		if (document.SUBFORM.CHK_FLAG.checked==true)
		{
			window.opener.document.getElementById("flag_"+document.SUBFORM.SEQNO.value).style.color = "#FF0000";
			window.opener.document.getElementById("flag_"+document.SUBFORM.SEQNO.value).innerHTML = "Cancelled";
		}
		else
		{
			window.opener.document.getElementById("flag_"+document.SUBFORM.SEQNO.value).innerHTML = "&nbsp;";
		}
		window.opener.document.getElementById("remark_"+document.SUBFORM.SEQNO.value).style.color = "#FF0000";
		if (document.SUBFORM.REMARKS.value==null || document.SUBFORM.REMARKS.value=="")
		{
			window.opener.document.getElementById("remark_"+document.SUBFORM.SEQNO.value).innerHTML  = "&nbsp;";
		}
		else
		{
			window.opener.document.getElementById("remark_"+document.SUBFORM.SEQNO.value).innerHTML  = document.SUBFORM.REMARKS.value;
		}
		setClose();
	</script>		
	<%
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<div style='color:#ff0000'>交易失敗!請洽系統管理人員,謝謝!("+e.getMessage()+")</div>");
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