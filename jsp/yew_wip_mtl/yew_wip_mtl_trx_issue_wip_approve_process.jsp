<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
<html>
<head>
<title>WIP領料線上簽核作業 - 領料簽核 - Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<br>
<%   
//===============interface 變數宣告_起===============
String groupId="";
String sqlInsMMT="";
String sqlInsMMTLot="";
String errorMsg="";
String grpHeaderID = "";
String devStatus = "";
String devMessage = "";
String sqlError= "";
String woPassFlag = "";
String respID = "50775"; // 預設值為 YEW_INV_SEMI_SU
//===============interface 變數宣告_迄===============

Statement statement;
ResultSet rs;
Statement statement1;
ResultSet rs2;
PreparedStatement prestatement;
PreparedStatement prestatement2;
CallableStatement cs;
String sql="";
int i, j, errflag=0;

int orgid=Integer.parseInt(request.getParameter("orgid"));
String wono=request.getParameter("wono");  
int wipid=Integer.parseInt(request.getParameter("wipid"));  
int num=Integer.parseInt(request.getParameter("num"));
int act_num=Integer.parseInt(request.getParameter("act_num"));
String action_code=request.getParameter("action_code");
float fixed_qty;

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
float[]  original_qty;
original_qty = new float[num];
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
int[]  action;
action = new int[num];

for (i=0;i<num;i++)
{
	try{trx_id[i]=Integer.parseInt(request.getParameter("trx_id"+(i+1)));}catch (Exception e){}
	try{item_id[i]=Integer.parseInt(request.getParameter("item_id"+(i+1)));}catch (Exception e){}
	item_no[i]=request.getParameter("item_no"+(i+1));
	sub_inv[i]=request.getParameter("sub_inv"+(i+1));
	try{locator_id[i]=Integer.parseInt(request.getParameter("locator_id"+(i+1)));}catch (Exception e){}
	locator[i]=request.getParameter("locator"+(i+1));
	try{original_qty[i]=Float.parseFloat(request.getParameter("original_qty"+(i+1)));}catch (Exception e){}
	try{trx_qty[i]=Float.parseFloat(request.getParameter("trx_qty"+(i+1)));}catch (Exception e){}
	uom[i]=request.getParameter("uom"+(i+1));
	try{op_seq[i]=Integer.parseInt(request.getParameter("op_seq"+(i+1)));}catch (Exception e){}
	try{dept_id[i]=Integer.parseInt(request.getParameter("dept_id"+(i+1)));}catch (Exception e){}
	try{lot[i]=Integer.parseInt(request.getParameter("lot"+(i+1)));}catch (Exception e){}
	try{lot_qty[i]=Float.parseFloat(request.getParameter("lot_qty"+(i+1)));}catch (Exception e){}
	try{reason_id[i]=Integer.parseInt(request.getParameter("reason_id"+(i+1)));}catch (Exception e){}
	ref[i]=request.getParameter("ref"+(i+1));
	try{action[i]=Integer.parseInt(request.getParameter("action"+(i+1)));}catch (Exception e){}
}

//檢查傳遞值
/*
out.println("wipid="+wipid+"<br>");
out.println("wono="+wono+"<br>");
out.println("act_num="+act_num+"<br>");
out.println("num="+num+"<br>");
out.println("action_code="+action_code+"<br>");
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
	out.println("lot_qty"+(i+1)+"="+lot_qty[i]+"<br>");
	out.println("reason_id"+(i+1)+"="+reason_id[i]+"<br>");
	out.println("ref"+(i+1)+"="+ref[i]+"<br>");
	out.println("action"+(i+1)+"="+action[i]+"<br>");
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
//*/

try
{
	for (i=0;i<num;i++)
	{
		if (action[i]==1)
		{
			if (action_code.indexOf("REJECT")>=0) //REJECT
			{
				errflag = 100;
				sql="";
				sql=sql+"UPDATE yew_wip_mtl_trx ";
				sql=sql+"   SET last_update_date = SYSDATE, ";
				sql=sql+"       last_updated_by = ?, ";
				sql=sql+"       action_sequence_num = ?, ";
				sql=sql+"       action_code = ?, ";
				sql=sql+"       action_date = SYSDATE, ";
				sql=sql+"       closed_code = ? ";
				sql=sql+" WHERE closed_code = 'OPEN' AND trx_id = "+trx_id[i];
				prestatement=con.prepareStatement(sql); 
				prestatement.setInt(1,Integer.parseInt(userMfgUserID)); //LAST_UPDATED_BY
				prestatement.setInt(2,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
				prestatement.setString(3,"REJECT"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
				prestatement.setString(4,"REJECTED"); //CLOSED_CODE OPEN, CLOSED, REJECTED, CANCELED
				prestatement.executeUpdate();
				prestatement.close();
				//YEW_WIP_MTL_ACTION_HISTORY
				errflag = 200;
				sql="";
				sql=sql+"INSERT INTO yew_wip_mtl_action_history ";
				sql=sql+"            (trx_id, action_sequence_num, action_code, action_date, action_by ";
				sql=sql+"            ) ";
				sql=sql+"     VALUES (?, ?, ?, SYSDATE, ? ";
				sql=sql+"            ) ";
				prestatement=con.prepareStatement(sql); 
				prestatement.setInt(1,trx_id[i]); //TRX_ID
				prestatement.setInt(2,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
				prestatement.setString(3,"REJECT"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
				prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //ACTION_BY
				prestatement.executeUpdate();
				prestatement.close();
				out.print("<br>  工令:"+wono+"     料號:"+item_no[i]+"    數量:"+trx_qty[i]+"  "+action_code+"!!<br>"); 
			}
			else if (sub_inv[i].indexOf("06")>=0) //06倉
			{
				errflag = 1100;
				// ######################### 呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_起
				try
				{   //out.println("Step1. 寫入MMT Interface<BR>");	
					// -- 取此次MMT 的Transaction ID 作為Group ID
					errflag = 1105;
					statement=con.createStatement();	             
					rs=statement.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
					if (rs.next()) groupId = rs.getString(1);
					rs.close();
					statement.close();
					errflag = 1110;
					//out.println("Stepa.寫入MMT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
					sql="";
					sql=sql+"INSERT INTO mtl_transactions_interface ";
					sql=sql+"            (transaction_interface_id, source_code, source_header_id, ";
					sql=sql+"             source_line_id, process_flag, transaction_mode, ";
					sql=sql+"             inventory_item_id, organization_id, subinventory_code, ";
					sql=sql+"             locator_id, loc_segment1, transaction_quantity, transaction_uom, ";
					sql=sql+"             transaction_date, transaction_source_id, transaction_type_id, ";
					sql=sql+"             wip_entity_type, operation_seq_num, department_id, last_update_date, ";
					sql=sql+"             last_updated_by, creation_date, created_by, lock_flag, ";
					sql=sql+"             transaction_header_id, final_completion_flag, ";
					sql=sql+"             transaction_source_type_id, reason_id, transaction_reference) ";
					sql=sql+"   SELECT "+groupId+" transaction_interface_id, 'WIP' source_code, ";
					sql=sql+"          wip_entity_id source_header_id, wip_entity_id source_line_id, ";
					sql=sql+"          1 process_flag, 2 transaction_mode, inventory_item_id, ";
					sql=sql+"          organization_id, subinventory_code, ";
					sql=sql+"          DECODE (locator_id, 0, NULL, locator_id) locator_id, loc_segment1, ";
					sql=sql+"          transaction_quantity, transaction_uom, SYSDATE transaction_date, ";
					sql=sql+"          wip_entity_id transaction_source_id, 35 transaction_type_id, ";
					sql=sql+"          1 wip_entity_type, operation_seq_num, department_id, SYSDATE last_update_date, ";
					sql=sql+"          "+userMfgUserID+" last_updated_by, creation_date, created_by, 1 lock_flag, ";
					sql=sql+"          "+groupId+" transaction_header_id, 'Y' final_completion_flag, ";
					sql=sql+"          5 transaction_source_type_id, ";
					sql=sql+"          DECODE (reason_id, 0, NULL, reason_id) reason_id, ";
					sql=sql+"          transaction_reference ";
					sql=sql+"     FROM yew_wip_mtl_trx ";
					sql=sql+"    WHERE trx_id = " + trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.executeUpdate();
					prestatement.close();
					errflag = 1120;
					//out.println("Step2. 寫入MMT Lot Interface<BR>");
					sql="";
					sql=sql+"INSERT INTO mtl_transaction_lots_interface ";
					sql=sql+"            (transaction_interface_id, lot_number, transaction_quantity, ";
					sql=sql+"             last_update_date, last_updated_by, creation_date, created_by) ";
					sql=sql+"   SELECT "+groupId+" transaction_interface_id, lot_number, transaction_quantity, ";
					sql=sql+"          SYSDATE last_update_date, "+userMfgUserID+" last_updated_by, creation_date, ";
					sql=sql+"          created_by ";
					sql=sql+"     FROM yew_wip_mtl_lots ";
					sql=sql+"    WHERE trx_id = " + trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.executeUpdate();
					prestatement.close();
					//out.println("Stepb.寫入MMT LOT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
				} // End of try
				catch (Exception e)
				{
					out.println("("+errflag+")Exception MMT & LOT Interface:"+e.getMessage());
				}	
				//執行 MMT及MMT LOT Interface Submit Request
				errorMsg = "";
				try
				{
					errflag = 1130;
					statement=con.createStatement();	   
					rs=statement.executeQuery("SELECT DISTINCT responsibility_id FROM fnd_responsibility_tl WHERE application_id = '401' AND responsibility_name = 'YEW_INV_SEMI_SU' "); 
					if (rs.next()) respID = rs.getString("responsibility_id");
					rs.close();
					statement.close();	  			 
				
					// -- 取此次MMT 的Transaction Header ID 作為Group Header ID
					grpHeaderID = "";
					devStatus = "";
					devMessage = "";
					statement=con.createStatement();	             
					rs=statement.executeQuery("SELECT transaction_header_id FROM mtl_transactions_interface WHERE transaction_interface_id = "+groupId+" ");
					if (rs.next()) grpHeaderID = rs.getString(1);
					rs.close();
					statement.close();	
					errflag = 1140;
					cs = con.prepareCall("{CALL wip_mtlinterfaceproc_pub.processInterface(?,?,?,?)}");			 
					cs.setInt(1,Integer.parseInt(grpHeaderID));     //   p_txnIntID	
					cs.setString(2,"T");          //   fnd_api.g_false = "TRUE"					 			 
					cs.registerOutParameter(3, Types.VARCHAR);  //回傳 x_returnStatus
					cs.registerOutParameter(4, Types.VARCHAR);  //回傳 x_errorMsg				
					cs.execute();
					out.println("Procedure : Execute Success !!! ");	             
					devStatus = cs.getString(3);    // 回傳 x_returnStatus
					devMessage = cs.getString(4);   // 回傳 x_errorMsg
					cs.close();
					errflag = 1150;
					//java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷				 
					statement=con.createStatement();
					sql= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
					//out.println("sqlError="+sqlError+"<BR>");					                                     
					rs=statement.executeQuery(sql);	
					if (rs.next() && rs.getString("ERROR_CODE")!=null && !rs.getString("ERROR_CODE").equals("")) // 存在 ERROR 的資料,對Interface而言會寫ErrorCode欄位
					{ 
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>MMT Transaction fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rs.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rs.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
						woPassFlag="N";						   
						errorMsg = errorMsg+"&nbsp;"+ rs.getString("ERROR_EXPLANATION");	  				  
					}
					rs.close();
					statement.close();
					errflag = 1160;
					if (errorMsg.equals("")) //若ErrorMessage為空值,則表示Interface成功被寫入MMT,回應成功Request ID
					{	
						out.println("Success Submit !!! "+"<BR>");
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
						woPassFlag="Y";	// 成功寫入的旗標
						con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
					}
				
				}// end of try
				catch (Exception e)
				{
					out.println("("+errflag+")Exception WIP_MMT_REQUEST:"+e.getMessage());
				}	
				// ######################### 呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄
				//更新YEW_WIP_MTL_TRX狀態
				if (woPassFlag=="Y" || woPassFlag.equals("Y"))
				{
					errflag = 1200;
					sql="";
					sql=sql+"UPDATE yew_wip_mtl_trx ";
					sql=sql+"   SET transaction_set_id = ?, ";
					sql=sql+"       last_update_date = SYSDATE, ";
					sql=sql+"       last_updated_by = ?, ";
					sql=sql+"       action_sequence_num = ?, ";
					sql=sql+"       action_code = ?, ";
					sql=sql+"       action_date = SYSDATE, ";
					sql=sql+"       closed_code = ? ";
					sql=sql+" WHERE closed_code = 'OPEN' AND trx_id = "+trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.setInt(1,Integer.parseInt(grpHeaderID)); //TRANSACTION_ID
					prestatement.setInt(2,Integer.parseInt(userMfgUserID)); //LAST_UPDATED_BY
					prestatement.setInt(3,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
					prestatement.setString(4,"APPROVE"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
					prestatement.setString(5,"CLOSED"); //CLOSED_CODE OPEN, CLOSED, REJECTED, CANCELED
					prestatement.executeUpdate();
					prestatement.close();
					//寫入YEW_WIP_MTL_TRX_HISTORY記錄
					errflag = 1300;
					sql="";
					sql=sql+"INSERT INTO yew_wip_mtl_action_history ";
					sql=sql+"            (trx_id, action_sequence_num, action_code, action_date, action_by ";
					sql=sql+"            ) ";
					sql=sql+"     VALUES (?, ?, ?, SYSDATE, ? ";
					sql=sql+"            ) ";
					prestatement=con.prepareStatement(sql); 
					prestatement.setInt(1,trx_id[i]); //TRX_ID
					prestatement.setInt(2,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
					prestatement.setString(3,"APPROVE"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
					prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //ACTION_BY
					prestatement.executeUpdate();
					prestatement.close();
					out.print("<br>  工令:"+wono+"     料號:"+item_no[i]+"    數量:"+trx_qty[i]+"  領料成功!!<br>");
				}
			}
			else if (action_code.indexOf("APPROVE")>=0) //APPROVE
			{
				//更新數量
				/*取消 SHIN20100209
				if (original_qty[i] != trx_qty[i])
				{
					errflag = 2100;
					sql="";
					sql=sql+"UPDATE yew_wip_mtl_trx ";
					sql=sql+"   SET last_update_date = SYSDATE, ";
					sql=sql+"       last_updated_by = ?, ";
					sql=sql+"       transaction_quantity = ? ";
					sql=sql+" WHERE trx_id = "+trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.setInt(1,Integer.parseInt(userMfgUserID)); //LAST_UPDATED_BY
					prestatement.setFloat(2,-trx_qty[i]); //TRANSACTION_QUANTITY        	   
					prestatement.executeUpdate();
					prestatement.close();
				}
				*/
				//更新lot
				if (lot[i]==2)
				{
					//先刪除yew_wip_mtl_trx_temp
					errflag = 2200;
					sql="";
					sql=sql+"DELETE FROM yew_wip_mtl_lots WHERE trx_id = "+trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.executeUpdate();
					prestatement.close();	      	
					errflag = 2250;
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
					errflag = 2300;
					sql="";
					sql=sql+"DELETE FROM yew_wip_mtl_lots_temp WHERE trx_id = "+trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.executeUpdate();
					prestatement.close();
				}
				//拋Interface
				errflag = 2400;
				// ######################### 呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_起
				try
				{   //out.println("Step1. 寫入MMT Interface<BR>");	
					// -- 取此次MMT 的Transaction ID 作為Group ID
					errflag = 2405;
					statement=con.createStatement();	             
					rs=statement.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
					if (rs.next()) groupId = rs.getString(1);
					rs.close();
					statement.close();
					errflag = 2410;
					//out.println("Stepa.寫入MMT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
					sql="";
					sql=sql+"INSERT INTO mtl_transactions_interface ";
					sql=sql+"            (transaction_interface_id, source_code, source_header_id, ";
					sql=sql+"             source_line_id, process_flag, transaction_mode, ";
					sql=sql+"             inventory_item_id, organization_id, subinventory_code, ";
					sql=sql+"             locator_id, loc_segment1, transaction_quantity, transaction_uom, ";
					sql=sql+"             transaction_date, transaction_source_id, transaction_type_id, ";
					sql=sql+"             wip_entity_type, operation_seq_num, department_id, last_update_date, ";
					sql=sql+"             last_updated_by, creation_date, created_by, lock_flag, ";
					sql=sql+"             transaction_header_id, final_completion_flag, ";
					sql=sql+"             transaction_source_type_id, reason_id, transaction_reference) ";
					sql=sql+"   SELECT "+groupId+" transaction_interface_id, 'WIP' source_code, ";
					sql=sql+"          wip_entity_id source_header_id, wip_entity_id source_line_id, ";
					sql=sql+"          1 process_flag, 2 transaction_mode, inventory_item_id, ";
					sql=sql+"          organization_id, subinventory_code, ";
					sql=sql+"          DECODE (locator_id, 0, NULL, locator_id) locator_id, loc_segment1, ";
					sql=sql+"          transaction_quantity , transaction_uom, SYSDATE transaction_date, ";
					sql=sql+"          wip_entity_id transaction_source_id, 35 transaction_type_id, ";
					sql=sql+"          1 wip_entity_type, operation_seq_num, department_id, SYSDATE last_update_date, ";
					sql=sql+"          "+userMfgUserID+" last_updated_by, creation_date, created_by, 1 lock_flag, ";
					sql=sql+"          "+groupId+" transaction_header_id, 'Y' final_completion_flag, ";
					sql=sql+"          5 transaction_source_type_id, ";
					sql=sql+"          DECODE (reason_id, 0, NULL, reason_id) reason_id, ";
					sql=sql+"          transaction_reference ";
					sql=sql+"     FROM yew_wip_mtl_trx ";
					sql=sql+"    WHERE trx_id = " + trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.executeUpdate();
					prestatement.close();
					errflag = 2420;
					//out.println("Step2. 寫入MMT Lot Interface<BR>");
					sql="";
					sql=sql+"INSERT INTO mtl_transaction_lots_interface ";
					sql=sql+"            (transaction_interface_id, lot_number, transaction_quantity, ";
					sql=sql+"             last_update_date, last_updated_by, creation_date, created_by) ";
					sql=sql+"   SELECT "+groupId+" transaction_interface_id, lot_number, transaction_quantity, ";
					sql=sql+"          SYSDATE last_update_date, "+userMfgUserID+" last_updated_by, creation_date, ";
					sql=sql+"          created_by ";
					sql=sql+"     FROM yew_wip_mtl_lots ";
					sql=sql+"    WHERE trx_id = " + trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.executeUpdate();
					prestatement.close();
					//out.println("Stepb.寫入MMT LOT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
				} // End of try
				catch (Exception e)
				{
					out.println("("+errflag+")Exception MMT & LOT Interface:"+e.getMessage());
				}	
				//執行 MMT及MMT LOT Interface Submit Request
				errorMsg = "";
				try
				{
					errflag = 2430;
					statement=con.createStatement();	   
					rs=statement.executeQuery("SELECT DISTINCT responsibility_id FROM fnd_responsibility_tl WHERE application_id = '401' AND responsibility_name = 'YEW_INV_SEMI_SU' "); 
					if (rs.next()) respID = rs.getString("responsibility_id");
					rs.close();
					statement.close();	  			 
				
					// -- 取此次MMT 的Transaction Header ID 作為Group Header ID
					grpHeaderID = "";
					devStatus = "";
					devMessage = "";
					statement=con.createStatement();	             
					rs=statement.executeQuery("SELECT transaction_header_id FROM mtl_transactions_interface WHERE transaction_interface_id = "+groupId+" ");
					if (rs.next()) grpHeaderID = rs.getString(1);
					rs.close();
					statement.close();	
					errflag = 2440;
					cs = con.prepareCall("{CALL wip_mtlinterfaceproc_pub.processInterface(?,?,?,?)}");			 
					cs.setInt(1,Integer.parseInt(grpHeaderID));     //   p_txnIntID	
					cs.setString(2,"T");          //   fnd_api.g_false = "TRUE"					 			 
					cs.registerOutParameter(3, Types.VARCHAR);  //回傳 x_returnStatus
					cs.registerOutParameter(4, Types.VARCHAR);  //回傳 x_errorMsg				
					cs.execute();
					out.println("Procedure : Execute Success !!! ");	             
					devStatus = cs.getString(3);    // 回傳 x_returnStatus
					devMessage = cs.getString(4);   // 回傳 x_errorMsg
					cs.close();
					errflag = 2450;
					//java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷				 
					statement=con.createStatement();
					sql= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
					//out.println("sqlError="+sqlError+"<BR>");					                                     
					rs=statement.executeQuery(sql);	
					if (rs.next() && rs.getString("ERROR_CODE")!=null && !rs.getString("ERROR_CODE").equals("")) // 存在 ERROR 的資料,對Interface而言會寫ErrorCode欄位
					{ 
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>MMT Transaction fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rs.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rs.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
						woPassFlag="N";						   
						errorMsg = errorMsg+"&nbsp;"+ rs.getString("ERROR_EXPLANATION");	  				  
					}
					rs.close();
					statement.close();
					errflag = 2460;
					if (errorMsg.equals("")) //若ErrorMessage為空值,則表示Interface成功被寫入MMT,回應成功Request ID
					{	
						out.println("Success Submit !!! "+"<BR>");
						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
						woPassFlag="Y";	// 成功寫入的旗標
						con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
					}
				
				}// end of try
				catch (Exception e)
				{
					out.println("("+errflag+")Exception WIP_MMT_REQUEST:"+e.getMessage());
				}	
				// ######################### 呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄
				errflag = 2500;
				//更新YEW_WIP_MTL_TRX狀態
				if (woPassFlag=="Y" || woPassFlag.equals("Y"))
				{
					sql="";
					sql=sql+"UPDATE yew_wip_mtl_trx ";
					sql=sql+"   SET transaction_set_id = ?, ";
					sql=sql+"       last_update_date = SYSDATE, ";
					sql=sql+"       last_updated_by = ?, ";
					sql=sql+"       action_sequence_num = ?, ";
					sql=sql+"       action_code = ?, ";
					sql=sql+"       action_date = SYSDATE, ";
					sql=sql+"       closed_code = ? ";
					sql=sql+" WHERE closed_code = 'OPEN' AND trx_id = "+trx_id[i];
					prestatement=con.prepareStatement(sql); 
					prestatement.setInt(1,Integer.parseInt(grpHeaderID)); //TRANSACTION_ID
					prestatement.setInt(2,Integer.parseInt(userMfgUserID)); //LAST_UPDATED_BY
					prestatement.setInt(3,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
					prestatement.setString(4,"APPROVE"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
					prestatement.setString(5,"CLOSED"); //CLOSED_CODE OPEN, CLOSED, REJECTED, CANCELED
					prestatement.executeUpdate();
					prestatement.close();
					errflag = 2700;
					//YEW_WIP_MTL_ACTION_HISTORY
					sql="";
					sql=sql+"INSERT INTO yew_wip_mtl_action_history ";
					sql=sql+"            (trx_id, action_sequence_num, action_code, action_date, action_by ";
					sql=sql+"            ) ";
					sql=sql+"     VALUES (?, ?, ?, SYSDATE, ? ";
					sql=sql+"            ) ";
					prestatement=con.prepareStatement(sql); 
					prestatement.setInt(1,trx_id[i]); //TRX_ID
					prestatement.setInt(2,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
					prestatement.setString(3,"APPROVE"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
					prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //ACTION_BY
					prestatement.executeUpdate();
					prestatement.close();
					out.print("<br>  工令:"+wono+"     料號:"+item_no[i]+"    數量:"+trx_qty[i]+"  領料成功!!<br>");
				}
			}
			else if (action_code.indexOf("FORWARD")>=0) //FORWARD
			{
				errflag = 3000;
				sql="";
				sql=sql+"UPDATE yew_wip_mtl_trx ";
				sql=sql+"   SET last_update_date = SYSDATE, ";
				sql=sql+"       last_updated_by = ?, ";
				sql=sql+"       action_sequence_num = ?, ";
				sql=sql+"       action_code = ?, ";
				sql=sql+"       action_date = SYSDATE, ";
				sql=sql+"       closed_code = ? ";
				sql=sql+" WHERE closed_code = 'OPEN' AND trx_id = "+trx_id[i];
				prestatement=con.prepareStatement(sql); 
				prestatement.setInt(1,Integer.parseInt(userMfgUserID)); //LAST_UPDATED_BY
				prestatement.setInt(2,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
				prestatement.setString(3,"FORWARD"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
				prestatement.setString(4,"OPEN"); //CLOSED_CODE OPEN, CLOSED, REJECTED, CANCELED
				prestatement.executeUpdate();
				prestatement.close();
				//YEW_WIP_MTL_ACTION_HISTORY
				errflag = 3100;
				sql="";
				sql=sql+"INSERT INTO yew_wip_mtl_action_history ";
				sql=sql+"            (trx_id, action_sequence_num, action_code, action_date, action_by ";
				sql=sql+"            ) ";
				sql=sql+"     VALUES (?, ?, ?, SYSDATE, ? ";
				sql=sql+"            ) ";
				prestatement=con.prepareStatement(sql); 
				prestatement.setInt(1,trx_id[i]); //TRX_ID
				prestatement.setInt(2,act_num); //ACTION_SEQUENCE_NUM 0=送出, 10=產線主管, 20=生管, 30=倉管       	   
				prestatement.setString(3,"FORWARD"); //ACTION_CODE SUBMIT, FORWARD, APPROVE, REJECT
				prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //ACTION_BY
				prestatement.executeUpdate();
				prestatement.close();
				out.print("<br>  工令:"+wono+"     料號:"+item_no[i]+"    數量:"+trx_qty[i]+"  "+action_code+"!!<br>"); 
			}
		}
	}
}
catch (Exception e)
{
	e.printStackTrace();
	out.println("("+errflag+")"+e.getMessage());
}//end of catch  
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

