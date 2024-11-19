<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 工令領料 - Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<%   
Statement statement;
PreparedStatement prestatement;
PreparedStatement prestatement2;
ResultSet rs;
String sql="";
int i, j, errflag=0;

int orgid=Integer.parseInt(request.getParameter("orgid"));
String wono=request.getParameter("wono");  
int wipid=Integer.parseInt(request.getParameter("wipid"));  
int num=Integer.parseInt(request.getParameter("num"));
String cancel=request.getParameter("cancel");  

int[]  item_id;
item_id = new int[num];
String[]  item_no;
item_no = new String[num];
String[]  sub_inv;
sub_inv = new String[num];
int[]  locator_id;
locator_id = new int[num];
String[]  locator;
locator = new String[num];
float[]  trx_qty;
trx_qty = new float[num];
String[]  uom;
uom = new String[num];
int[]  op_seq;
op_seq = new int[num];
int[]  dept_id;
dept_id = new int[num];
int[]  lot;
lot = new int[num];
float[]  lot_qty;
lot_qty = new float[num];
int[]  reason_id;
reason_id = new int[num];
String[]  ref;
ref = new String[num];
int[]  trx_id;
trx_id = new int[num];

for (i=0;i<num;i++)
{
	try{trx_id[i]=Integer.parseInt(request.getParameter("trx_id"+(i+1)));}catch (Exception e){}
	try{item_id[i]=Integer.parseInt(request.getParameter("item_id"+(i+1)));}catch (Exception e){}
	item_no[i]=request.getParameter("item_no"+(i+1));
	sub_inv[i]=request.getParameter("sub_inv"+(i+1));
	try{locator_id[i]=Integer.parseInt(request.getParameter("locator_id"+(i+1)));}catch (Exception e){}
	locator[i]=request.getParameter("locator"+(i+1));
	try{trx_qty[i]=Float.parseFloat(request.getParameter("trx_qty"+(i+1)));}catch (Exception e){}
	uom[i]=request.getParameter("uom"+(i+1));
	try{op_seq[i]=Integer.parseInt(request.getParameter("op_seq"+(i+1)));}catch (Exception e){}
	try{dept_id[i]=Integer.parseInt(request.getParameter("dept_id"+(i+1)));}catch (Exception e){}
	try{lot[i]=Integer.parseInt(request.getParameter("lot"+(i+1)));}catch (Exception e){}
	try{lot_qty[i]=Float.parseFloat(request.getParameter("lot_qty"+(i+1)));}catch (Exception e){}
	try{reason_id[i]=Integer.parseInt(request.getParameter("reason_id"+(i+1)));}catch (Exception e){}
	ref[i]=request.getParameter("ref"+(i+1));
}

//檢查傳遞值
/*
out.println("orgid="+orgid+"<br>");
out.println("wono="+wono+"<br>");
out.println("wipid="+wipid+"<br>");
out.println("num="+num+"<br>");
for (i=0;i<num;i++)
{
	out.println("===============================================<br>");
	out.println("trx_id"+(i+1)+"="+trx_id[i]+"<br>");
	out.println("item_id"+(i+1)+"="+item_id[i]+"<br>");
	out.println("item_no"+(i+1)+"="+item_no[i]+"<br>");
	out.println("sub_inv"+(i+1)+"="+sub_inv[i]+"<br>");
	out.println("locator_id"+(i+1)+"="+locator_id[i]+"<br>");
	out.println("locator"+(i+1)+"="+locator[i]+"<br>");
	out.println("trx_qty"+(i+1)+"="+trx_qty[i]+"<br>");
	out.println("uom"+(i+1)+"="+uom[i]+"<br>");
	out.println("op_seq"+(i+1)+"="+op_seq[i]+"<br>");
	out.println("dept_id"+(i+1)+"="+dept_id[i]+"<br>");
	out.println("lot"+(i+1)+"="+lot[i]+"<br>");
	out.println("lot_qty"+(i+1)+"="+lot_qty[i]+"<br>");
	out.println("reason_id"+(i+1)+"="+reason_id[i]+"<br>");
	out.println("ref"+(i+1)+"="+ref[i]+"<br>");
	//讀取YEW_WIP_MTL_LOTS_TEMP
	sql="";
	sql=sql+"SELECT lot_number, transaction_quantity ";							
	sql=sql+"	FROM yew_wip_mtl_lots_temp ";
	sql=sql+"	WHERE trx_id = "+trx_id[i];
	statement=con.createStatement();
	rs=statement.executeQuery(sql); 
	while (rs.next())
	{
		out.println("-----------------------------------------------<br>");
		out.println("lot_number="+rs.getString("lot_number")+"<br>");
		out.println("lot_quantity="+rs.getFloat("transaction_quantity")+"<br>");
	}
	rs.close();
	statement.close();
}
out.println("===============================================<br>");
out.println("userMfgUserID="+userMfgUserID+"<br>");
*/
	
if (cancel==null)
{
	//新增yew_wip_mtl_trx, yew_wip_mtl_lots
	try
	{
		for (i=0;i<num;i++)
		{
			if (trx_qty[i]>0)
			{
				//建立yew_wip_mtl_trx
				errflag = 100;
				sql="";
				sql=sql+"INSERT INTO YEW_WIP_MTL_TRX ";
				sql=sql+"	(trx_id, inventory_item_id, organization_id, last_update_date, last_updated_by, ";
				sql=sql+"		creation_date, created_by, subinventory_code, locator_id, loc_segment1, ";
				sql=sql+"		wip_entity_id, wip_entity_name, operation_seq_num, department_id, transaction_type_id, ";
				sql=sql+"		transaction_uom, transaction_quantity, reason_id, transaction_reference, transaction_set_id, ";
				sql=sql+"		action_sequence_num, action_code, action_date, closed_code) ";
				sql=sql+"	VALUES(?, ?, ?, sysdate, ?, ";
				sql=sql+"		sysdate, ?, ?, ?, ?, ";
				sql=sql+"		?, ?, ?, ?, ?, ";
				sql=sql+"		?, ?, ?, ?, null, ";
				sql=sql+"		?, ?, sysdate, ?) ";
				prestatement=con.prepareStatement(sql); 
				prestatement.setInt(1,trx_id[i]); //TRX_ID
				prestatement.setInt(2,item_id[i]); //INVENTORY_ITEM_ID
				prestatement.setInt(3,orgid); //ORGANIZATION_ID
				prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //LAST_UPDATED_BY
				prestatement.setInt(5,Integer.parseInt(userMfgUserID)); //CREATED_BY
				prestatement.setString(6,sub_inv[i]); //SUBINVENTORY_CODE   
				prestatement.setInt(7,locator_id[i]); //LOCATOR_ID        	   
				prestatement.setString(8,locator[i]); //LOC_SEGMENT1
				prestatement.setInt(9,wipid); //WIP_ENTITY_ID        	   
				prestatement.setString(10,wono); //WIP_ENTITY_NAME        	   
				prestatement.setInt(11,op_seq[i]); //OPERATION_SEQ_NUM        	   
				prestatement.setInt(12,dept_id[i]); //DEPARTMENT_ID        	   
				prestatement.setInt(13,35); //TRANSACTION_TYPE_ID 35=Issue Components to WIP, 43=Return Components from WIP       	   
				prestatement.setString(14,uom[i]); //TRANSACTION_UOM       	   
				prestatement.setFloat(15,-trx_qty[i]); //TRANSACTION_QUANTITY        	   
				prestatement.setInt(16,reason_id[i]); //REASON_ID       	   
				prestatement.setString(17,ref[i]); //TRANSACTION_REFERENCE       	   
				prestatement.setInt(18,0); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
				prestatement.setString(19,"SUBMIT"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
				prestatement.setString(20,"OPEN"); //CLOSED_CODE OPEN, CLOSED, REJECTED, CANCELED
				prestatement.executeUpdate();
				prestatement.close();
				if (lot[i]==2)
				{
					if (lot_qty[i]>0)
					{
						//建立yew_wip_mtl_lot
						errflag = 200;
						sql="";
						sql=sql+"INSERT INTO yew_wip_mtl_lots ";
						sql=sql+"            (trx_id, lot_number, inventory_item_id, organization_id, ";
						sql=sql+"             last_update_date, last_updated_by, creation_date, created_by, ";
						sql=sql+"             transaction_quantity) ";
						sql=sql+"   SELECT trx_id, lot_number, inventory_item_id, organization_id, ";
						sql=sql+"          sysdate, last_updated_by, sysdate, created_by, ";
						sql=sql+"          transaction_quantity ";
						sql=sql+"     FROM yew_wip_mtl_lots_temp ";
						sql=sql+"    WHERE trx_id = "+trx_id[i];
						prestatement2=con.prepareStatement(sql); 
						prestatement2.executeUpdate();
						prestatement2.close();
					}
					else out.print("<br>  工令:"+wono+"     料號:"+item_no[i]+"(LOT控管)    數量:"+trx_qty[i]+"  無LOT，送出失敗!!"); 
				}
				//YEW_WIP_MTL_ACTION_HISTORY
				errflag = 550;
				sql="";
				sql=sql+"INSERT INTO yew_wip_mtl_action_history ";
				sql=sql+"            (trx_id, action_sequence_num, action_code, action_date, action_by ";
				sql=sql+"            ) ";
				sql=sql+"     VALUES (?, ?, ?, SYSDATE, ? ";
				sql=sql+"            ) ";
				prestatement=con.prepareStatement(sql); 
				prestatement.setInt(1,trx_id[i]); //TRX_ID
				prestatement.setInt(2,0); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
				prestatement.setString(3,"SUBMIT"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
				prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //ACTION_BY
				prestatement.executeUpdate();
				prestatement.close();
				out.print("<br>  工令:"+wono+"     料號:"+item_no[i]+"    數量:"+trx_qty[i]+"  己送出!!"); 
			}	      	
		}
	}
	catch (Exception e)
	{
		e.printStackTrace();
		out.println("("+errflag+")"+e.getMessage());
	}//end of catch  
}

try
{
	//刪除yew_wip_mtl_lots_temp
	errflag = 300;
	sql="";
	sql=sql+"DELETE FROM yew_wip_mtl_lots_temp WHERE created_by = "+Integer.parseInt(userMfgUserID)+" ";
	prestatement=con.prepareStatement(sql); 
	prestatement.executeUpdate();
	prestatement.close();	      	
	//刪除yew_wip_mtl_trx_temp
	errflag = 400;
	sql="";
	sql=sql+"DELETE FROM yew_wip_mtl_trx_temp WHERE created_by = "+Integer.parseInt(userMfgUserID)+" ";
	prestatement=con.prepareStatement(sql); 
	prestatement.executeUpdate();
	prestatement.close();	      	
}
catch (Exception e)
{
	e.printStackTrace();
	out.println("("+errflag+")"+e.getMessage());
}//end of catch  

if (cancel!=null)
{	
	response.sendRedirect("yew_wip_mtl_trx_issue_wip_query.jsp?orgid="+orgid+"&wono="+wono);
}
%>


	<table width="60%" border="1" cellpadding="0" cellspacing="0" >
		<tr>
			<td width="278"><font size="2">WIP領料管理</font></td>
			<td width="297"><font size="2">WIP查詢及報表</font></td>    
		</tr>
		<tr>   
			<td>
<%
try  
{ out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
	String MODEL = "E8";    
	String sqlE3 = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ";
	statement=con.createStatement();
	rs=statement.executeQuery(sqlE3);    	
	while(rs.next())
	{
		//out.println("FSEQ="+rs.getString("FSEQ"));
		String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
	rs.close(); 
	statement.close();
	out.println("</table>");  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println(e.getMessage());
}//end of catch  

%>   
			</td> 
			<td>
<%
try  
{ out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
	String MODEL = "E6";    
	statement=con.createStatement(); 
	rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
	while(rs.next())
	{
		String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td><td>");
	}
	rs.close(); 
	statement.close();
	out.println("</table>"); 
} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println(e.getMessage());
}//end of catch   

%>
			</td>    
		</tr>
	</table>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

