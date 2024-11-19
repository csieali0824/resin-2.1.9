<!--20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20160804 by Peggy,add reject action-->
<!--20160830 by Peggy,reject email notice-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Sales Slow Moving Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
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
<FORM ACTION="TSSalesDRQSlowMovingProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

String sql ="",line_no="",choose_line="";
String dnDocNo=request.getParameter("DNDOCNO");
String SALESAREANO=request.getParameter("SALESAREANO");
String actionID=request.getParameter("ACTIONID");
String fromStatusID=request.getParameter("FROMSTATUSID");
String REJECT_REASON=request.getParameter("REJ_REASON");
if (REJECT_REASON==null) REJECT_REASON="";
String sToStatusID = "";
String sToStatusName = "";
int found_cnt =0,execute_cnt=0;

try
{
  	sql = " select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 "+
  	      " WHERE FROMSTATUSID='"+fromStatusID+"' "+
		  " AND ACTIONID='"+actionID+"' "+
		  " AND x1.TOSTATUSID=x2.STATUSID "+
		  " and  x1.LOCALE='"+locale+"'";
  	if (UserRoles.equals("admin")) 
	{
		sql += "and FORMID='TS' "; //預設TS
	} 
  	else if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) 
	{
		sql += "and FORMID='SH' "; // 若是上海內銷辦事處
	}
  	else 
	{
		sql += "and FORMID='TS' "; // 否則一律皆為外銷流程
	}
	
  	Statement getStatusStat=con.createStatement();  
  	ResultSet getStatusRs=getStatusStat.executeQuery(sql);  
  	if (getStatusRs.next()) 
	{
    	sToStatusID = getStatusRs.getString("TOSTATUSID");
		sToStatusName = getStatusRs.getString("STATUSNAME");
  	}
  	getStatusStat.close();
  	getStatusRs.close(); 
	
	String chk[]= request.getParameterValues("chk");	
	if (chk.length <=0)
	{
		throw new Exception("無待處理交易!!");
	}
	String IDLE_QTY="",IDLE_REMARK="",RFQ_QTY="",SHIPDATE="",SLOWSEQID="",newitemid="",newitemname="",newitemdesc="";
	for(int i=0; i< chk.length ;i++)
	{
		sql = "select 1 from oraddman.tsdelivery_notice_detail  where DNDOCNO =? and LINE_NO =? and LSTATUSID=? ";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,dnDocNo);
		statement1.setString(2,chk[i]);
		statement1.setString(3,"014");
		ResultSet rs1=statement1.executeQuery();
		if (rs1.next())
		{
			found_cnt=1;
		}
		else
		{
			found_cnt=0;
		}	
		rs1.close();
		statement1.close();
		
		if (found_cnt==0) continue;
		
		if (actionID.equals("005"))  //add by Peggy 20160804
		{
			IDLE_QTY="0";
			IDLE_REMARK = request.getParameter("IDLE_REMARK"+chk[i]);
			if (IDLE_REMARK == null || IDLE_REMARK.equals("")) IDLE_REMARK=REJECT_REASON;
			RFQ_QTY = request.getParameter("QTY_"+chk[i]);
			if (RFQ_QTY == null || RFQ_QTY.equals("")) RFQ_QTY="0";
			SHIPDATE="";
		}
		else
		{
			IDLE_QTY = request.getParameter("IDLE_QTY"+chk[i]);
			if (IDLE_QTY == null || IDLE_QTY.equals("")) IDLE_QTY="0";
			IDLE_REMARK = request.getParameter("IDLE_REMARK"+chk[i]);
			if (IDLE_REMARK == null || IDLE_REMARK.equals(""))IDLE_REMARK="";
			RFQ_QTY = request.getParameter("RFQ_QTY"+chk[i]);
			if (RFQ_QTY == null || RFQ_QTY.equals("")) RFQ_QTY="0";
			SHIPDATE = request.getParameter("SHIPDATE"+chk[i]);
			if (SHIPDATE==null || SHIPDATE.equals("")) SHIPDATE="";

		}	
		choose_line += (","+chk[i]);
		SLOWSEQID = request.getParameter("SLOWSEQID"+chk[i]);
		if (SLOWSEQID==null || SLOWSEQID.equals("")) SLOWSEQID="";	
		if (!SLOWSEQID.equals(""))
		{	
			sql = " select a.inventory_item_id, a.item_name,a.item_desc"+
			      ",'同意消化:'||a.REGION || case when trim(a.area)<>trim(a.REGION) then ' '||a.area else '' end || case when trim(a.customer)<>trim(a.area) or trim(a.customer)<>trim(a.REGION) then ' '|| a.customer else '' end ||' 庫存型號:'||a.item_desc||case when a.date_code is not null then ' D/C:'||a.date_code else '' end as stock_info"+
         		  " from oraddman.tsc_idle_stock_detail	a"+
				  " where a.seq_no=?";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,SLOWSEQID);
			ResultSet rs=statement.executeQuery();
			while(rs.next())
			{	
				newitemid=rs.getString("inventory_item_id");
				newitemname=rs.getString("item_name");	
				newitemdesc=rs.getString("item_desc");	
				IDLE_REMARK=rs.getString("stock_info");
			}
			rs.close();	
			statement.close();			
		}
				
		sql = " update oraddman.tsdelivery_notice_detail a "+
			  " set QUANTITY=?"+
			  ",SMC_QTY=?"+
			  ",REASON_CODE=?"+
			  ",REASONDESC=?"+
			  ",SMC_REMARKS=?"+
			  ",LSTATUSID=?"+
			  ",LSTATUS=?"+
			  ",AUTOCREATE_FLAG=case when '"+actionID+"'=? then 'R' ELSE CASE WHEN ?=0 and AUTOCREATE_FLAG<>'N' then 'Y' ELSE AUTOCREATE_FLAG END END "+
			  ",LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
			  ",LAST_UPDATED_BY=?"+
			  ",SHIP_DATE=case when ?=0 then '"+SHIPDATE+"' else SHIP_DATE END"+
			  ",FTACPDATE=case when ?=0 then ship_date else 'N/A' END"+
			  ",PC_COMMENT=case when '"+actionID+"'=? then ? ELSE ? END"+
			  ",EDIT_CODE=CASE WHEN '"+actionID+"'=? THEN 'R' ELSE EDIT_CODE END"+ 
			  ",INVENTORY_ITEM_ID=case ? when '0' then case when a.INVENTORY_ITEM_ID<>? then ? else a.INVENTORY_ITEM_ID end else a.INVENTORY_ITEM_ID end"+     //add by Peggy 20230203
			  ",ITEM_SEGMENT1=case ? when '0' then case when a.INVENTORY_ITEM_ID<>? then ? else a.ITEM_SEGMENT1 end else a.ITEM_SEGMENT1 end"+                 //add by Peggy 20230203
			  ",ITEM_DESCRIPTION=case ? when '0' then case when a.INVENTORY_ITEM_ID<>? then ? else a.ITEM_DESCRIPTION end else a.ITEM_DESCRIPTION end"+        //add by Peggy 20230203
			  ",ORIG_ITEM_ID=case ? when '0' then case when a.INVENTORY_ITEM_ID<>? then a.INVENTORY_ITEM_ID else null end else null end"+                      //add by Peggy 20230203
			  ",ORIG_ITEM_DESC=case ? when '0' then case when a.INVENTORY_ITEM_ID<>? then a.ITEM_DESCRIPTION else null end else null end"+                      //add by Peggy 20230203
			  //",slowmoving_seqid=case ? when '0' then ? else null end"+ //add by Peggy 20230204
			  ",slowmoving_seqid=?"+ //add by Peggy 20230208
			  " where DNDOCNO =?"+
			  " and LINE_NO =?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,(RFQ_QTY.equals("0")?IDLE_QTY:RFQ_QTY));
		pstmtDt.setString(2,IDLE_QTY);
		pstmtDt.setString(3,(RFQ_QTY.equals("0")?"08":"00"));
		pstmtDt.setString(4,(RFQ_QTY.equals("0")?IDLE_REMARK:"N/A"));
		pstmtDt.setString(5,IDLE_REMARK);
		//pstmtDt.setString(6,(RFQ_QTY.equals("0")?"008":"003"));
		//pstmtDt.setString(7,(RFQ_QTY.equals("0")?"CONFIRMED":"ESTIMATING"));
		pstmtDt.setString(6,(RFQ_QTY.equals("0")?"008":sToStatusID));
		pstmtDt.setString(7,(RFQ_QTY.equals("0")?"CONFIRMED":sToStatusName));
		pstmtDt.setString(8,"005");
		pstmtDt.setString(9,RFQ_QTY);
		pstmtDt.setString(10,userID);
		pstmtDt.setString(11,RFQ_QTY);
		pstmtDt.setString(12,RFQ_QTY);
		pstmtDt.setString(13,"005");
		pstmtDt.setString(14,REJECT_REASON);
		pstmtDt.setString(15,(RFQ_QTY.equals("0")?IDLE_REMARK:""));
		pstmtDt.setString(16,"005");
		pstmtDt.setString(17,RFQ_QTY);
		pstmtDt.setString(18,newitemid);
		pstmtDt.setString(19,newitemid);
		pstmtDt.setString(20,RFQ_QTY);
		pstmtDt.setString(21,newitemname);
		pstmtDt.setString(22,newitemname);	
		pstmtDt.setString(23,RFQ_QTY);
		pstmtDt.setString(24,newitemdesc);
		pstmtDt.setString(25,newitemdesc);				
		pstmtDt.setString(26,RFQ_QTY);
		pstmtDt.setString(27,newitemid);
		pstmtDt.setString(28,RFQ_QTY);
		pstmtDt.setString(29,newitemid);
		//pstmtDt.setString(30,RFQ_QTY);
		pstmtDt.setString(30,SLOWSEQID);								
		pstmtDt.setString(31,dnDocNo);
		pstmtDt.setString(32,chk[i]); 
		pstmtDt.executeQuery();
		pstmtDt.close();			  
			
		sql=" insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
      		" ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,"+
		    " CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME,ARRANGED_DATE,PC_REMARK) "+
			" SELECT DNDOCNO,?,(select STATUSNAME from ORADDMAN.TSWFStatus where STATUSID=?),?,(select ACTIONNAME from oraddman.tswfaction where ACTIONID=?),?,?,?,ASSIGN_MANUFACT,?,?,?,LINE_NO,?,SHIP_DATE,? FROM  oraddman.tsdelivery_notice_detail a "+
			" where dndocno =? and line_no=?";
		PreparedStatement historystmt=con.prepareStatement(sql);   
		historystmt.setString(1,fromStatusID); 
		historystmt.setString(2,fromStatusID);
		historystmt.setString(3,actionID); 
		historystmt.setString(4,actionID); 
		historystmt.setString(5,userID); 
		historystmt.setString(6,dateBean.getYearMonthDay()); 
		historystmt.setString(7,dateBean.getHourMinuteSecond());
		historystmt.setString(8,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
		historystmt.setString(9,(actionID.equals("005")?REJECT_REASON:(RFQ_QTY.equals("0")?IDLE_REMARK:"N/A")));
		historystmt.setInt(10,0);
		historystmt.setFloat(11,0);		
		historystmt.setString(12,(actionID.equals("005")?REJECT_REASON:""));
		historystmt.setString(13,dnDocNo);
		historystmt.setString(14,chk[i]);
		historystmt.executeQuery();
		historystmt.close();
			
		//if (Float.parseFloat(IDLE_QTY)>0 && Float.parseFloat(RFQ_QTY)>0)
		if (!actionID.equals("005") && Float.parseFloat(IDLE_QTY)>0 && Float.parseFloat(RFQ_QTY)>0)  //modify by Peggy 20160804
		{
			Statement statement2=con.createStatement();
			ResultSet rs2=statement2.executeQuery("SELECT MAX(line_no)+1 new_line FROM  oraddman.tsdelivery_notice_detail b where b.DNDOCNO='"+dnDocNo+"' ");
			if (rs2.next())
			{
				line_no = rs2.getString("new_line");
				
				choose_line += (","+line_no);				
			}
			rs2.close();
			statement2.close();
					
			//create new line
			sql = " INSERT INTO oraddman.tsdelivery_notice_detail"+
				  " (dndocno, line_no, inventory_item_id, item_segment1, quantity, uom, list_price, request_date, ship_date,"+
				  " promise_date, line_type, primary_uom, remark,creation_date, created_by, last_update_date,"+
				  " last_updated_by, assign_manufact, assign_lno,source_type, pccfmdate, ftacpdate, sascodate, orderno,"+
				  " lstatusid, lstatus, selling_price, pcacpdate,item_description, or_lineno, moqp, rerequest_date,"+
				  " sdrq_exceed, ordered_item, ordered_item_id, item_id_type, reason_code, reasondesc, edit_code, cust_po_number,"+
				  " tsc_prod_group, nspq_check, pc_comment, spq, moq, program_name, cust_request_date, shipping_method,"+
				  " order_type_id, fob, autocreate_flag, cust_po_line_no, quote_number, end_customer, orig_line_no,end_customer_id,"+
				  " orig_so_line_id,END_CUSTOMER_SHIP_TO_ORG_ID,DIRECT_SHIP_TO_CUST,BI_REGION,END_CUSTOMER_PARTNO,orig_item_id,orig_item_desc,slowmoving_seqid,SUPPLIER_NUMBER)"+
				  " SELECT dndocno, ?,case when a.inventory_item_id<>? then ? else a.inventory_item_id end"+
				  " ,case when a.inventory_item_id<>? then ? else a.item_segment1 end"+
				  " ,a.SMC_QTY, a.uom, a.list_price, a.request_date, ?, a.promise_date,a.line_type , a.primary_uom, null,"+
				  " a.creation_date, a.created_by, a.last_update_date,a.last_updated_by, a.assign_manufact, a.assign_lno,"+
				  " a.source_type, a.pccfmdate, a.ship_date, a.last_update_date, a.orderno,'008', 'CONFIRMED', a.selling_price, a.pcacpdate,"+
				  " case when a.inventory_item_id<>? then ? else a.item_description end , a.or_lineno, a.moqp, a.rerequest_date,a.sdrq_exceed, a.ordered_item, a.ordered_item_id, a.item_id_type,"+
				  " '08', '"+IDLE_REMARK+"', a.edit_code, a.cust_po_number,a.tsc_prod_group, a.nspq_check, '"+IDLE_REMARK+"', a.spq, a.moq,"+
				  " a.program_name, a.cust_request_date, a.shipping_method, a.order_type_id, a.fob, 'Y', a.cust_po_line_no,"+
				  " a.quote_number, a.end_customer,a.line_no,a.end_customer_id"+
				  ",a.ORIG_SO_LINE_ID"+ //add by Peggy 20150519 
				  ",a.END_CUSTOMER_SHIP_TO_ORG_ID,a.DIRECT_SHIP_TO_CUST,a.BI_REGION,a.END_CUSTOMER_PARTNO"+
				  ",case when a.inventory_item_id<>? then a.inventory_item_id else null end"+ //add by Peggy 20230203
				  ",case when a.inventory_item_id<>? then a.item_description else null end "+ //add by Peggy 20230203
				  ",?"+
				  ",a.SUPPLIER_NUMBER"+ //add by Peggy 20240402
				  " FROM oraddman.tsdelivery_notice_detail a"+
				  " WHERE a.dndocno =?"+
				  " AND a.line_no =?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,line_no);
			pstmtDt.setString(2,newitemid);
			pstmtDt.setString(3,newitemid);
			pstmtDt.setString(4,newitemid);
			pstmtDt.setString(5,newitemname);
			pstmtDt.setString(6,SHIPDATE);			
			pstmtDt.setString(7,newitemid);
			pstmtDt.setString(8,newitemdesc);						
			pstmtDt.setString(9,newitemid);
			pstmtDt.setString(10,newitemid);
			pstmtDt.setString(11,SLOWSEQID);						
			pstmtDt.setString(12,dnDocNo);
			pstmtDt.setString(13,chk[i]); 
			pstmtDt.executeQuery();
			pstmtDt.close();			  

			sql = " insert into  oraddman.tsdelivery_notice_remarks "+
				  " (dndocno, line_no, customer, shipping_marks, remarks,creation_date, created_by, last_update_date,last_updated_by)"+
				  " select dndocno, ?,customer, shipping_marks, remarks,creation_date, created_by, sysdate,last_updated_by"+
				  " from oraddman.tsdelivery_notice_remarks a"+
				  " WHERE a.dndocno = ? AND a.line_no =?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,line_no);
			pstmtDt.setString(2,dnDocNo);
			pstmtDt.setString(3,chk[i]); 
			pstmtDt.executeQuery();
			pstmtDt.close();		
			
			sql=" insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,"+
				" ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,"+
				" CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME,ARRANGED_DATE,PC_REMARK) "+
				" SELECT DNDOCNO,?,(select STATUSNAME from ORADDMAN.TSWFStatus where STATUSID=?),?,(select ACTIONNAME from oraddman.tswfaction where ACTIONID=?),?,?,?,ASSIGN_MANUFACT,?,?,?,LINE_NO,?,SHIP_DATE,? FROM  oraddman.tsdelivery_notice_detail a "+
				" where dndocno =? and line_no=?";
			historystmt=con.prepareStatement(sql);   
			historystmt.setString(1,fromStatusID); 
			historystmt.setString(2,fromStatusID);
			historystmt.setString(3,actionID); 
			historystmt.setString(4,actionID); 
			historystmt.setString(5,userID); 
			historystmt.setString(6,dateBean.getYearMonthDay()); 
			historystmt.setString(7,dateBean.getHourMinuteSecond());
			historystmt.setString(8,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
			historystmt.setString(9,IDLE_REMARK);
			historystmt.setInt(10,0);
			historystmt.setFloat(11,0);		
			historystmt.setString(12,"Orig Line:"+chk[i]);
			historystmt.setString(13,dnDocNo);
			historystmt.setString(14,line_no);
			historystmt.executeQuery();
			historystmt.close();						  
		}
		execute_cnt++;
	}	
	
	if (execute_cnt >0)
	{
		con.commit();		
		
		//if (!choose_line.equals(""))
		if (!actionID.equals("005") && !choose_line.equals(""))  //modify by Peggy 20160804
		{
			CallableStatement cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.SLOW_MOVING_STOCK_EMAIL_NOTICE(?,?)}");			 
			cs3.setString(1,dnDocNo); 
			cs3.setString(2,choose_line+","); 
			cs3.execute();
			cs3.close();			
		}	
		else if (actionID.equals("005") & !choose_line.equals(""))  //reject notice,add by Peggy 20160830
		{
			CallableStatement cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.SLOW_MOVING_REJECT_NOTICE(?,?)}");			 
			cs3.setString(1,dnDocNo); 
			cs3.setString(2,choose_line+","); 
			cs3.execute();
			cs3.close();			
		}
		
		out.println("<table width='100%'>");
		out.println("<tr>");
		out.println("<td width='15%'>&nbsp;</td>");
		out.println("<td tyle='color:#0000FF' width='70%'><div align='center'>動作成功!!</div></td>");
		out.println("<td width='15%'>&nbsp;</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td>&nbsp;</td>");
		out.println("<td><div align='center'><A href='/oradds/ORADDSMainMenu.jsp'>");
		%><jsp:getProperty name="rPH" property="pgHOME"/>
		<%out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=014&PAGEURL=TSSalesDRQPendingPage.jsp'>繼續處理下一筆</a></div></td>");
		out.println("<td>&nbsp;</td>");
		out.println("</tr>");
		out.println("</table>");
	}
	else
	{
		out.println("<font color='red'>無可處理資料,請重新確認,謝謝!!<br><br><a href='TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=014&PAGEURL=TSSalesDRQPendingPage.jsp'>回Slow Moving庫存確認中</a></font>");
	}	
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSSalesDRQQueryHeadAllStatus.jsp?STATUSID=014&PAGEURL=TSSalesDRQPendingPage.jsp'>回Slow Moving庫存確認中</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

