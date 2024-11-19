<!-- 20170427 by Peggy,已發oc的po不可刪除-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean,javax.mail.*,javax.mail.internet.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
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
String SEQNO = request.getParameter("SEQNO");
if (SEQNO==null) SEQNO="";
String VERSIONID = request.getParameter("VER");
if (VERSIONID==null) VERSIONID="";
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
String sql ="",DateNoFound="N";
int v_fonud_cnt=0;

try
{
	if (ACTION_TYPE.equals(""))
	{
		sql = " SELECT PO_LINE_NO,TSC_PART_NO,data_flag,remarks from oraddman.tsce_purchase_order_lines "+
			  " where CUSTOMER_PO=?"+
			  " and VERSION_ID=?"+
			  " and PO_LINE_NO=?";		
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,CUSTPO);
		statement.setString(2,VERSIONID);
		statement.setString(3,SEQNO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			CUST_PO_LINE_NO = rs.getString("PO_LINE_NO");
			if (CUST_PO_LINE_NO==null) CUST_PO_LINE_NO="";
			TSC_ITEM_NAME = rs.getString("TSC_PART_NO");
			if (TSC_ITEM_NAME==null) TSC_ITEM_NAME="";
			CHK_FLAG = rs.getString("data_flag");
			if (CHK_FLAG ==null) CHK_FLAG ="";
			REMARKS = rs.getString("REMARKS");
			if (REMARKS==null) REMARKS="";
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
						<input type="hidden" name="VER" value="<%=VERSIONID%>">
						<input type="hidden" name="SEQNO"  value="<%=SEQNO%>"></td>
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
						<td><font class="style3"><br>Remarks:</font><br>
						<textarea cols="70" rows="5" name="REMARKS" class="style2"><%=REMARKS%></textarea>
						</td>
					</tr>
					<tr>
						<td><br><br><input type="button" name="save" class="style2" value="Submit" onClick="setsubmit('../jsp/TSCE1214DetailNotice.jsp?ACTION_TYPE=SAVE');"></td>
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
		sql = " update oraddman.tsce_purchase_order_lines a"+
			  " set DATA_FLAG=?"+
			  ",REMARKS=?"+
			  //",LAST_UPDATED_BY=?"+        //mark by Peggy 20220922 Emily要求不update
			  //",LAST_UPDATE_DATE=sysdate"+ //mark by Peggy 20220922 Emily要求不update
			  " where CUSTOMER_PO=?"+
			  " and VERSION_ID=?"+
			  " and PO_LINE_NO=?";
		//out.println(sql);
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,(CHK_FLAG.equals("")?"Y":CHK_FLAG));
		pstmtDt.setString(2,REMARKS);
		//pstmtDt.setString(3,UserName);
		pstmtDt.setString(3,CUSTPO);
		pstmtDt.setString(4,VERSIONID);
		pstmtDt.setString(5,SEQNO);
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		if (CHK_FLAG.equals("C")) //訂單取消
		{
			sql = " SELECT COUNT(1) from oraddman.tsce_purchase_order_lines  A "+
				  " where A.CUSTOMER_PO=?"+
				  " and A.VERSION_ID=?"+
				  " and A.data_flag<>'C'";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,CUSTPO);
			statement.setString(2,VERSIONID);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{	
				if (rs.getInt(1)==0)
				{
					//add by Peggy 20170427,未發oc的po才允許刪除
					sql = "select count(1) from daphne_pi_temp where cust_po_number=?";
					PreparedStatement statementx = con.prepareStatement(sql);
					statementx.setString(1,CUSTPO);
					ResultSet rsx=statementx.executeQuery();
					if (rsx.next())
					{	
						if (rsx.getInt(1)==0)
						{
							sql = " delete APPS.TSC_CUST_PO_UPLOAD A WHERE EXISTS (SELECT 1 FROM APPS.TSC_CUST_PO_HEADER B WHERE B.CUST_PO_NUM=? AND B.DOC_ID=A.DOC_ID)";
							pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,CUSTPO);
							pstmtDt.executeQuery();
							pstmtDt.close();
						
							sql = " delete APPS.TSC_CUST_PO_HEADER WHERE CUST_PO_NUM=?";
							pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,CUSTPO);
							pstmtDt.executeQuery();
							pstmtDt.close();
						}
					}
					rsx.close();
					statementx.close();
				}
			}
			rs.close();
			statement.close();		
			
			//ADD BY PEGGY 20210805,針對未BOOK前DELETE且只有一筆PO LINE補上OC資訊,以利發OC
			v_fonud_cnt=0;
			sql = " SELECT COUNT(1) "+
                  " FROM ONT.OE_ORDER_HEADERS_ALL OHA,ONT.OE_ORDER_LINES_ALL OLA "+
                  " WHERE OHA.ORG_ID=?"+
                  " AND OHA.HEADER_ID=OLA.HEADER_ID"+
                  " AND substr(OHA.ORDER_NUMBER,1,4) = ?"+
                  //" AND Tsc_Intercompany_Pkg.get_sales_group(OHA.HEADER_ID)=?"+
				  " AND TSC_OM_Get_Sales_Group(OHA.HEADER_ID)=?"+
                  " AND OLA.CUSTOMER_LINE_NUMBER=?";
			//out.println(sql);
			PreparedStatement statementk = con.prepareStatement(sql);
			statementk.setInt(1,41);
			statementk.setString(2,"1214");
			statementk.setString(3,"TSCE");
			statementk.setString(4,CUSTPO);
			ResultSet rsk=statementk.executeQuery();
			if (rsk.next())
			{
				v_fonud_cnt = rsk.getInt(1);
			}
			rsk.close();
			statementk.close();		
			
			if (v_fonud_cnt==0)
			{
				sql = " insert into apps.daphne_proforma_temp"+
					  " (ORDER_NUMBER"+
					  ",CUST_PO_NUMBER"+
					  ",CUSTOMER_NAME"+
					  ",FLAG"+
					  ",CUSTOMER_NO"+
					  ",CREATION_DATE"+
					  ",REGION1)"+
					  " VALUES"+
					  "(to_char(sysdate,'ymmddhh24mi')"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')"+
					  ",?)";
				//out.println(sql);
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,CUSTPO);
				pstmtDt.setString(2,"TAIWAN SEMICONDUCTOR EUROPE GMBH");
				pstmtDt.setString(3,"Y");
				pstmtDt.setString(4,"1202");
				pstmtDt.setString(5,"TSCE");
				pstmtDt.executeQuery();
				pstmtDt.close();				
			}						  
		}
		else
		{
			//add by Peggy 20170815,不取消要把資料再補回OC
			sql = "select 1 from APPS.TSC_CUST_PO_HEADER where CUST_PO_NUM=?";
			PreparedStatement statementx = con.prepareStatement(sql);
			statementx.setString(1,CUSTPO);
			ResultSet rsx=statementx.executeQuery();
			if (!rsx.next())
			{							
				sql = " insert into APPS.TSC_CUST_PO_HEADER(DOC_ID,CUST_PO_NUM,CUST_NAME,CUST_NO,CREATED_BY,CREATED_DATE,REGION1)"+
                      //" SELECT (SELECT MAX (doc_id) + 1 FROM tsc_cust_po_header),a.customer_po,ac.customer_name,party.party_number,(select B.USER_NAME from oraddman.wsuser a,fnd_user b where a.ERP_USER_ID=b.user_id and a.username=?),SYSDATE,'TSCE'"+
                      " SELECT (SELECT MAX (doc_id) + 1 FROM tsc_cust_po_header),a.customer_po,ac.customer_name,ac.customer_number,(select B.USER_NAME from oraddman.wsuser a,fnd_user b where a.ERP_USER_ID=b.user_id and a.username=?),SYSDATE,'TSCE'"+  //Party_Number 改用Customer_number寫入 modify by Peggy 20210916
                      " FROM oraddman.tsce_purchase_order_headers a,hz_cust_accounts cust, hz_parties party ,AR_CUSTOMERS ac"+
                      " WHERE a.customer_po = ?"+
                      " AND cust.party_id = party.party_id"+
                      " AND cust.status = 'A'"+
                      " AND cust.cust_account_id =a.erp_customer_id"+
                      " AND a.erp_customer_id=ac.customer_id";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName);
				pstmtDt.setString(2,CUSTPO);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " INSERT INTO APPS.TSC_CUST_PO_UPLOAD(DOC_ID,VERSION,IS_NEWEST,REMARKS,UPDATED_BY,UPDATED_TIME,STATUS,REGION1)"+
                      " SELECT DOC_ID,'0','Y','none',(select B.USER_NAME from oraddman.wsuser a,fnd_user b where a.ERP_USER_ID=b.user_id and a.username=?),SYSDATE,'Y','TSCE' FROM APPS.TSC_CUST_PO_HEADER WHERE CUST_PO_NUM=?";				  
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName);
				pstmtDt.setString(2,CUSTPO);
				pstmtDt.executeQuery();
				pstmtDt.close();			
			}
			rsx.close();
			statementx.close();
		}
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
		out.println("<font color=red>資料更新失敗!"+e.getMessage()+"</font>");
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