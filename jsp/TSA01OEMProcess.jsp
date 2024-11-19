<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<title>A01 OEM Process</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.DFORM.action=URL;
	document.DFORM.submit();
}
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSA01OEMProcess.jsp" METHOD="post" NAME="DFORM">
<%
String TRANSCODE = request.getParameter("TRANSCODE");
if (TRANSCODE==null) TRANSCODE="";
String sql ="",lot_list="";
// 為存入日期格式為US考量,將語系先設為美國
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();

try
{	
	if (TRANSCODE.equals("Submit"))
	{
		String err_msg="";
		sql =" select count(1)"+
             " from (select distinct wip_no from oraddman.tsa01_oem_headers_all a where status=? and wip_no=?"+
             "       union all"+ 
             " select a.wip_entity_name  from wip_entities a,wip_discrete_jobs b where a.organization_id=? and b.status_type<>? and a.wip_entity_id=b.wip_entity_id and a.wip_entity_name=?) x";
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,"Approved");
		statement1.setString(2,request.getParameter("WIP_NO"));
		statement1.setInt(3,606);
		statement1.setInt(4,7);
		statement1.setString(5,request.getParameter("WIP_NO"));
		ResultSet rs1=statement1.executeQuery();
		if (rs1.next())
		{
			if (rs1.getInt(1)>0)
			{
				err_msg = "工單號碼重複,請重新確認!!";
			}
		}
		rs1.close();		
		statement1.close();	
		
		if (!err_msg.equals(""))
		{
			throw new Exception(err_msg);
		}		
							 
		String chk[]= request.getParameterValues("chk");
		String hold_flag =request.getParameter("HOLD_FLAG");
		if (hold_flag==null) hold_flag="N";
		if (hold_flag.equals("N"))
		{
			for (int i=0 ; i<chk.length ; i++)
			{
				sql = " SELECT MQOD.INVENTORY_ITEM_ID"+
                      ",MQOD.SUBINVENTORY_CODE"+
                      ",MQOD.LOT_NUMBER"+
                      ",MQOD.TRANSACTION_QUANTITY-(SELECT SUM(NVL(WAFER_QTY,0)-NVL(ISSUE_QTY,0)) "+
                      " FROM ORADDMAN.TSA01_OEM_LINES_ALL X"+
                      " ,ORADDMAN.TSA01_OEM_HEADERS_ALL Y "+
                      " WHERE X.REQUEST_NO=Y.REQUEST_NO "+
                      " AND X.VERSION_ID=Y.VERSION_ID "+
                      " AND Y.ORGANIZATION_ID=MQOD.ORGANIZATION_ID"+
                      " AND X.INVENTORY_ITEM_ID=MQOD.INVENTORY_ITEM_ID "+
                      " AND X.SUBINVENTORY_CODE=MQOD.SUBINVENTORY_CODE "+
                      " AND X.LOT_NUMBER=MQOD.LOT_NUMBER)-to_number(?) ONHAND"+
                      ",MQOD.TRANSACTION_UOM_CODE "+
                      " FROM INV.MTL_ONHAND_QUANTITIES_DETAIL MQOD"+
                      " WHERE MQOD.INVENTORY_ITEM_ID=?"+
                      " AND MQOD.ORGANIZATION_ID=?"+
                      " AND MQOD.SUBINVENTORY_CODE=?"+
                      " AND MQOD.LOT_NUMBER=?";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,request.getParameter("WAFERQTY_D_"+chk[i]));
				statement.setString(2,request.getParameter("ITEMID_D_"+chk[i]));
				statement.setInt(3,606);
				statement.setString(4,request.getParameter("SUBINV_D_"+chk[i]));
				statement.setString(5,request.getParameter("LOT_D_"+chk[i]));
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{
					if (rs.getInt("ONHAND")<0)
					{
						err_msg += "LOT:"+request.getParameter("LOT_D_"+chk[i])+" 庫存不足(onhand="+rs.getInt("ONHAND")+")<br>";
					}
				}
				rs.close();		
				statement.close();			  
			}
				
			if (!err_msg.equals(""))
			{
				throw new Exception(err_msg);
			}
		}
		
		for (int i=0 ; i<chk.length ; i++)
		{
			sql = " insert into oraddman.tsa01_oem_lines_all"+
				  "(request_no"+
				  ",version_id"+
				  ",line_no"+
				  ",inventory_item_id"+
				  ",inventory_item_name"+
				  ",subinventory_code"+
				  ",lot_number"+
				  ",date_code"+
				  ",wafer_number"+
				  ",wafer_qty"+
				  ",completion_date"+
				  ",creation_date"+
				  ",created_by"+
				  ",last_update_date"+
				  ",last_updated_by"+
				  //",B_qty"+
				  ")"+
				  " values"+
				  "(?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  //",?"+
				  ")";
			PreparedStatement pstmt1=con.prepareStatement(sql);
			pstmt1.setString(1,request.getParameter("REQUEST_NO"));          //申請單號
			pstmt1.setString(2,request.getParameter("VERSION_NO"));          //版次
			pstmt1.setString(3,chk[i]);                                      //項次
			pstmt1.setString(4,request.getParameter("ITEMID_D_"+chk[i]));    //item id
			pstmt1.setString(5,request.getParameter("ITEMNAME_D_"+chk[i]));  //item name
			pstmt1.setString(6,request.getParameter("SUBINV_D_"+chk[i]));    //subinventory code
			pstmt1.setString(7,request.getParameter("LOT_D_"+chk[i]));       //lot
			pstmt1.setString(8,request.getParameter("DATECODE_D_"+chk[i]));  //date code
			pstmt1.setString(9,request.getParameter("WAFERNO_D_"+chk[i]));   //wafer number
			pstmt1.setString(10,request.getParameter("WAFERQTY_D_"+chk[i])); //wafer qty
			pstmt1.setString(11,request.getParameter("COMPLETION_DATE"));    //completion_date
			pstmt1.setString(12,UserName);                                   //CREATED_BY
			pstmt1.setString(13,UserName);                                   //LAST_UPDATED_BY
			//pstmt1.setString(14,(request.getParameter("HOLD_FLAG")==null?request.getParameter("WAFERQTY_D_"+chk[i]):null)); //ISSUE qty
			pstmt1.executeQuery();
			
			if (!lot_list.equals("")) lot_list+="\n";
			lot_list +=(request.getParameter("LOT_D_"+chk[i])+"  "+(request.getParameter("WAFERNO_D_"+chk[i])==null?"":request.getParameter("WAFERNO_D_"+chk[i])));
			
			for (int j=1 ; j<=Integer.parseInt(request.getParameter("WAFERQTY_D_"+chk[i])) ; j++)
			{
				sql = " insert into oraddman.tsa01_oem_wafers_all"+
					  "(request_no"+
					  ",version_id"+
					  ",lot_number"+
					  ",wafer_no"+
					  ",wafer_seq_no"+
					  ",issue_qty"+
					  ",receive_qty"+
					  ",scrap_qty"+
					  ",creation_date"+
					  ",created_by"+
					  ",last_update_date"+
					  ",last_updated_by"+
					  ")"+
					  " values"+
					  "(?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ")";
				PreparedStatement pstmt2=con.prepareStatement(sql);
				pstmt2.setString(1,request.getParameter("REQUEST_NO"));          //申請單號
				pstmt2.setString(2,request.getParameter("VERSION_NO"));          //版次
				pstmt2.setString(3,request.getParameter("LOT_D_"+chk[i]));       //lot
				pstmt2.setInt(4,j);   //wafer no
				pstmt2.setInt(5,1);   //wafer seq 
				pstmt2.setInt(6,1);   //wafer qty
				pstmt2.setInt(7,0);   //receive_qty
				pstmt2.setInt(8,0);   //scrap_qty
				pstmt2.setString(9,UserName);                                    //CREATED_BY
				pstmt2.setString(10,UserName);                                   //LAST_UPDATED_BY
				pstmt2.executeQuery();	
			}		
		}
			
		sql = " insert into oraddman.tsa01_oem_headers_all "+
			  " (request_no"+              //1
			  ",version_id"+               //2
			  ",wip_type_no"+              //3
			  ",vendor_id"+                //4
			  ",vendor_code"+              //5
			  ",vendor_name"+              //6
			  ",vendor_site_id"+           //7
			  ",vendor_contact"+           //8
			  ",currency_code"+            //9
			  ",request_date"+             //10
			  ",organization_id"+          //11
			  ",subinventory_code"+        //12
			  ",inventory_item_id"+        //13
			  ",inventory_item_name"+      //14
			  ",item_description"+         //15
			  ",tsc_prod_group"+           //16
			  ",tsc_package"+              //17
			  ",die_item_id"+              //18
			  ",die_name"+                 //19
			  ",die_desc"+                 //20
			  ",quantity"+                 //21
			  ",unit_price"+               //22
			  ",unit_price_uom"+           //23
			  ",packing"+                  //24
			  ",package_spec"+             //25
			  ",test_spec"+                //26
			  ",assembly"+                 //27
			  ",testing"+                  //28
			  ",taping_reel"+              //29
			  ",lapping"+                  //30
			  ",others"+                   //31
			  ",remarks"+                  //32
			  ",marking"+                  //33
			  ",completion_date"+          //34
			  ",status"+                   //35
			  ",creation_date"+            //36
			  ",created_by"+               //37
			  ",last_update_date"+         //38
			  ",last_updated_by"+          //39
			  ",wip_issue_hold_flag"+      //40
			  ",bill_sequence_id"+         //41
			  ",die_qty"+                  //42
			  ",new_item_id"+              //43
			  ",new_item_name"+            //44
			  ",new_item_desc"+            //45
              ",vendor_item_name"+         //46
			  ",wip_no"+                   //47
			  ")"+
			  " values"+
			  " (?"+                       //1
			  " ,?"+                       //2
			  " ,?"+                       //3
			  " ,?"+                       //4
			  " ,?"+                       //5
			  " ,?"+                       //6
			  " ,?"+                       //7
			  " ,?"+                       //8
			  " ,?"+                       //9
			  " ,?"+                       //10
			  " ,?"+                       //11
			  " ,?"+                       //12
			  " ,?"+                       //13
			  " ,?"+                       //14
			  " ,?"+                       //15
			  " ,tsc_inv_category(?,?,1100000003)"+                       //16
			  " ,?"+                       //17
			  " ,?"+                       //18
			  " ,?"+                       //19
			  " ,?"+                       //20
			  " ,?"+                       //21
			  " ,?"+                       //22
			  " ,?"+                       //23
			  " ,?"+                       //24
			  " ,?"+                       //25
			  " ,?"+                       //26
			  " ,?"+                       //27
			  " ,?"+                       //28
			  " ,?"+                       //29
			  " ,?"+                       //30
			  " ,?"+                       //31
			  " ,?"+                       //32
			  " ,?"+                       //33
			  " ,to_date(?,'yyyymmdd')"+   //34
			  " ,?"+                       //35
			  " ,sysdate"+                 //36
			  " ,?"+                       //37
			  " ,sysdate"+                 //38
			  " ,?"+                       //39
			  " ,?"+                       //40
			  " ,?"+                       //41
			  " ,?"+                       //42
			  " ,?"+                       //43
			  " ,?"+                       //44
			  " ,?"+                       //45
			  " ,?"+                       //46
			  " ,?"+                       //47
			  " )";
		PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.setString(1,request.getParameter("REQUEST_NO"));         //申請單號
		pstmt.setString(2,request.getParameter("VERSION_NO"));         //版次
		pstmt.setString(3,request.getParameter("WIP_TYPE"));           //工單類型
		pstmt.setString(4,request.getParameter("VENDOR_ID"));          //供應商ID
		pstmt.setString(5,request.getParameter("VENDOR_CODE"));        //供應商代碼
		pstmt.setString(6,request.getParameter("VENDOR_NAME"));        //供應商名稱
		pstmt.setString(7,request.getParameter("VENDOR_SITE_ID"));     //供應商SITE ID
		pstmt.setString(8,request.getParameter("VENDOR_CONTACT"));     //供應商之聯絡人
		pstmt.setString(9,request.getParameter("CURR_CODE"));          //CURR
		pstmt.setString(10,request.getParameter("ISSUE_DATE"));         //REQUEST DATE
		pstmt.setInt(11,606);                                           //ORGANIZATION ID
		pstmt.setString(12,request.getParameter("SUBINVENTORY_CODE"));  //SUBINVENTORY CODE
		pstmt.setString(13,request.getParameter("ITEMID"));             //ITEMID
		pstmt.setString(14,request.getParameter("ITEMNAME"));           //ITEMNAME
		pstmt.setString(15,request.getParameter("ITEMDESC"));          //ITEMDESC 
		pstmt.setString(16,request.getParameter("ITEMID"));            //TSC PROD GROUP
		pstmt.setInt(17,606);                                          //TSC PROD GROUP
		pstmt.setString(18,request.getParameter("PACKAGE"));           //PACKAGE
		pstmt.setString(19,request.getParameter("DIEID"));             //DIEID
		pstmt.setString(20,request.getParameter("DIENAME"));           //DIENAME
		pstmt.setString(21,request.getParameter("DIEDESC"));           //DIEDESC
		pstmt.setString(22,request.getParameter("QTY"));               //QTY
		pstmt.setString(23,request.getParameter("UNITPRICE"));         //UNITPRICE
		pstmt.setString(24,request.getParameter("UOM2"));              //UOM
		pstmt.setString(25,request.getParameter("PACKING"));           //PACKING
		pstmt.setString(26,request.getParameter("PACKAGESPEC"));       //PACKAGESPEC
		pstmt.setString(27,request.getParameter("TESTSPEC"));          //TESTSPEC
		pstmt.setString(28,(request.getParameter("CHKASSEMBLY")==null?"N":request.getParameter("CHKASSEMBLY")));       //CHKASSEMBLY
		pstmt.setString(29,(request.getParameter("CHKTESTING")==null?"N":request.getParameter("CHKTESTING")));        //CHKTESTING
		pstmt.setString(30,(request.getParameter("CHKTAPING")==null?"N":request.getParameter("CHKTAPING")));         //CHKTAPING
		pstmt.setString(31,(request.getParameter("CHKLAPPING")==null?"N":request.getParameter("CHKLAPPING")));        //CHKLAPPING
		pstmt.setString(32,(request.getParameter("CHKOTHERS")!=null && request.getParameter("CHKOTHERS").equals("Y")?request.getParameter("OTHERS"):""));         //OTHERS
		pstmt.setString(33,request.getParameter("REMARKS").replace("LOT:","LOT:"+lot_list));           //REMARKS
		pstmt.setString(34,(request.getParameter("MARKING")==null?"N/A":request.getParameter("MARKING")));           //MARKING
		pstmt.setString(35,request.getParameter("COMPLETION_DATE"));   //COMPLETION_DATE
		pstmt.setString(36,TRANSCODE);                                 //STATUS
		pstmt.setString(37,UserName);                                  //CREATED_BY
		pstmt.setString(38,UserName);                                  //LAST_UPDATED_BY
		pstmt.setString(39,(request.getParameter("HOLD_FLAG")==null?"":request.getParameter("HOLD_FLAG")));         //HOLD_FLAG    
		pstmt.setString(40,(request.getParameter("BILLSEQID")==null?"":request.getParameter("BILLSEQID")));         //BILLSEQID  
		pstmt.setString(41,request.getParameter("DIEQTY"));                                        //DIE QTY
		pstmt.setString(42,(request.getParameter("NEWITEMID")==null?"":request.getParameter("NEWITEMID")));         //NEWITEMID 
		pstmt.setString(43,(request.getParameter("NEWITEMNAME")==null?"":request.getParameter("NEWITEMNAME")));     //NEWITEMNAME
		pstmt.setString(44,(request.getParameter("NEWITEMDESC")==null?"":request.getParameter("NEWITEMDESC")));     //NEWITEMDESC
		pstmt.setString(45,(request.getParameter("VENDORITEMNAME")==null?"":request.getParameter("VENDORITEMNAME"))); //VENDORITEMNAME 
		pstmt.setString(46,(request.getParameter("WIP_NO")==null?"":request.getParameter("WIP_NO"))); //WIP_NO
		pstmt.executeQuery();
		
			
		sql=" insert into oraddman.tsa01_oem_action_history(request_no, version_id, action_name, action_date,actor, remarks)"+
			" values(?,?,?,sysdate,?,?)";
		//out.println(sql);
		pstmt=con.prepareStatement(sql);
		pstmt.setString(1,request.getParameter("REQUEST_NO"));  //申請單號
		pstmt.setString(2,request.getParameter("VERSION_NO"));  //版次
		pstmt.setString(3,TRANSCODE);                           //狀態
		pstmt.setString(4,UserName);                            //操作者名稱
		pstmt.setString(5,"");                                  //備註
		pstmt.executeQuery();	
			
		con.commit();	
		
		CallableStatement cs3 = con.prepareCall("{call TSA01_OEM_PKG.REQ_REMINDER_NOTICE(?,?)}");
		cs3.setString(1,request.getParameter("REQUEST_NO")+"-"+request.getParameter("VERSION_NO")); 
		cs3.setString(2,"Submit"); 
		cs3.execute();
		cs3.close();		
		
	%>
		<script language="JavaScript" type="text/JavaScript">
		if (confirm("申請成功!若要繼續下一筆請按確定鍵,否則按下取消鍵回首頁!"))
		{
			setSubmit("../jsp/TSA01OEMCreate.jsp");
		}
		else
		{
			setSubmit("../ORADDSMainMenu.jsp");
		}
		</script>
	<%		
	}	
	else if (TRANSCODE.equals("Confirm"))
	{
		sql = " update oraddman.tsa01_oem_headers_all a"+
		      " set approve_date=sysdate"+
			  " ,approved_by=?"+
			  " ,approve_remark=?"+
			  " ,status=?"+
			  " where a.request_no||'-'||a.version_id=?";
		PreparedStatement pstmt1=con.prepareStatement(sql);
		pstmt1.setString(1,UserName);                            //APPROVED BY 
		pstmt1.setString(2,request.getParameter("REMARKS"));     //備註
		pstmt1.setString(3,request.getParameter("STATUS"));      //狀態
		pstmt1.setString(4,request.getParameter("REQNO"));       //申請單號
		pstmt1.executeQuery();
			
		sql=" insert into oraddman.tsa01_oem_action_history(request_no, version_id, action_name, action_date,actor,remarks)"+
			" select request_no,version_id,?,sysdate,?,? from oraddman.tsa01_oem_headers_all a where a.request_no||'-'||a.version_id=?";
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.setString(1,request.getParameter("STATUS"));        //狀態
		pstmt.setString(2,UserName);                              //操作者名稱
		pstmt.setString(3,request.getParameter("REMARKS"));       //備註
		pstmt.setString(4,request.getParameter("REQNO"));         //申請單號
		pstmt.executeQuery();	
		con.commit();
			
		try
		{	
			if (!request.getParameter("STATUS").equals("Reject"))
			{				
				CallableStatement cs3 = con.prepareCall("{call TSA01_OEM_PKG.SUBMIT_REQ(?,?)}");
				cs3.setString(1,request.getParameter("REQNO")); 
				cs3.setString(2,"WIP"); 
				cs3.execute();
				cs3.close();	
			%>
				<script language="JavaScript" type="text/JavaScript">
				if (confirm("核准成功!若要繼續審核下一筆請按確定鍵,否則按下取消鍵回首頁!"))
				{
					setSubmit("../jsp/TSA01OEMConfirm.jsp");
				}
				else
				{
					setSubmit("../ORADDSMainMenu.jsp");
				}
				</script>
			<%	
			}
			else
			{
				CallableStatement cs3 = con.prepareCall("{call TSA01_OEM_PKG.REQ_REMINDER_NOTICE(?,?)}");
				cs3.setString(1,request.getParameter("REQNO")); 
				cs3.setString(2,request.getParameter("STATUS")); 
				cs3.execute();
				cs3.close();	
			%>
				<script language="JavaScript" type="text/JavaScript">
				if (confirm("退件成功!若要繼續審核下一筆請按確定鍵,否則按下取消鍵回首頁!"))
				{
					setSubmit("../jsp/TSA01OEMConfirm.jsp");
				}
				else
				{
					setSubmit("../ORADDSMainMenu.jsp");
				}
				</script>
			<%							
			}
		}
		catch(Exception e)
		{
			sql = " update oraddman.tsa01_oem_headers_all a"+
		          " set approve_date=null"+
			      " ,approved_by=null"+
			      " ,approve_remark=null"+
			      " ,status=?"+
			      " where a.request_no||'-'||a.version_id=?";
			pstmt1=con.prepareStatement(sql);
			pstmt1.setString(1,"Submit");      //狀態
			pstmt1.setString(2,request.getParameter("REQNO"));       //申請單號
			pstmt1.executeQuery();
			con.commit();	
		%>		
			<script language="JavaScript" type="text/JavaScript">
				alert("交易異常,請重新核准!");
				setSubmit("../jsp/TSA01OEMConfirm.jsp");
			</script>
		<%	
		}			
	}
	else if (TRANSCODE.equals("Issue"))
	{	
		String trans_id="";
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select APPS.TSA01_OEM_LINES_TRANS_ALL_S.nextval from dual");
		if (!rs.next())
		{
			throw new Exception("ID not Found!!");
		}
		else
		{
			trans_id = rs.getString(1);
		}
		rs.close();
		statement.close();		
		
		String chk[]= request.getParameterValues("chk");
		for (int i=0 ; i<chk.length ; i++)
		{
			sql = " UPDATE ORADDMAN.TSA01_OEM_LINES_ALL A"+
			      " SET A.ISSUE_QTY=NVL(A.ISSUE_QTY,0)+?"+
				  " WHERE A.REQUEST_NO||'-'|| A.VERSION_ID ||'.'|| A.LINE_NO=?";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,request.getParameter("issue_qty_"+chk[i]));
			pstmt.setString(2,chk[i]);    
			pstmt.executeQuery();
			
			sql = " INSERT INTO ORADDMAN.TSA01_OEM_LINES_TRANS_ALL A"+
			      " SELECT ?,?,REQUEST_NO,VERSION_ID,LINE_NO,INVENTORY_ITEM_ID,INVENTORY_ITEM_NAME,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,?,0,NULL,NULL,NULL,NULL,NULL,NULL,?,SYSDATE,NULL"+
				  " FROM ORADDMAN.TSA01_OEM_LINES_ALL B"+
				  " WHERE B.REQUEST_NO||'-'|| B.VERSION_ID ||'.'|| B.LINE_NO=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,trans_id);    
			pstmt.setString(2,"ISSUE");    
			pstmt.setString(3,request.getParameter("issue_qty_"+chk[i]));
			pstmt.setString(4,UserName);    
			pstmt.setString(5,chk[i]);    
			pstmt.executeQuery();				  	
		}	
		con.commit();
		
		try
		{
			CallableStatement cs3 = con.prepareCall("{call TSA01_OEM_PKG.SUBMIT_REQ(?,?)}");
			cs3.setString(1,trans_id); 
			cs3.setString(2,"WIPISSUE"); 
			cs3.execute();
			cs3.close();	
			
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("送出成功!若要繼續下一筆請按確定鍵,否則按下取消鍵回首頁!"))
			{
				setSubmit("../jsp/TSA01OEMWIPIssue.jsp");
			}
			else
			{
				setSubmit("../ORADDSMainMenu.jsp");
			}
			</script>
		<%			
		}
		catch(Exception e)
		{
			sql = " UPDATE ORADDMAN.TSA01_OEM_LINES_ALL A"+
                  " SET ISSUE_QTY=NVL(ISSUE_QTY,0)-(SELECT SUM(QUANTITY) FROM ORADDMAN.TSA01_OEM_LINES_TRANS_ALL B"+
                  "                              WHERE B.REQUEST_NO=A.REQUEST_NO"+
                  "                              AND B.VERSION_ID=A.VERSION_ID"+
                  "                              AND B.LINE_NO=A.LINE_NO"+
                  "                              AND B.TRANS_NO=?)"+
                  " WHERE EXISTS (SELECT 1 FROM ORADDMAN.TSA01_OEM_LINES_TRANS_ALL C"+
                  "               WHERE C.TRANS_NO=? AND C.REQUEST_NO=A.REQUEST_NO AND C.VERSION_ID=A.VERSION_ID)";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,trans_id);
			pstmt.setString(2,trans_id);
			pstmt.executeQuery();				  

            sql =" DELETE ORADDMAN.TSA01_OEM_LINES_TRANS_ALL A"+
                  " WHERE TRANS_NO=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,trans_id);
			pstmt.executeQuery();
			con.commit();	
		%>		
			<script language="JavaScript" type="text/JavaScript">
				alert("交易異常,請重新作業!");
				setSubmit("../jsp/TSA01OEMWIPIssue.jsp");
			</script>
		<%							  
		}
	}
	else if (TRANSCODE.equals("Receive"))
	{	
		String trans_id="";
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select APPS.TSA01_OEM_LINES_TRANS_ALL_S.nextval from dual");
		if (!rs.next())
		{
			throw new Exception("ID not Found!!");
		}
		else
		{
			trans_id = rs.getString(1);
		}
		rs.close();
		statement.close();		
		
		String chk[]= request.getParameterValues("chk");
		for (int i=0 ; i<chk.length ; i++)
		{
			sql = " UPDATE ORADDMAN.TSA01_OEM_LINES_ALL A"+
			      " SET A.RECEIVE_QTY=NVL(A.RECEIVE_QTY,0)+?"+
				  " WHERE A.REQUEST_NO||'-'|| A.VERSION_ID ||'.'|| A.LINE_NO=?";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,request.getParameter("rcv_qty_"+chk[i]));
			pstmt.setString(2,chk[i]);    
			pstmt.executeQuery();
			
			sql = " INSERT INTO ORADDMAN.TSA01_OEM_LINES_TRANS_ALL A"+
			      " SELECT ?,?,REQUEST_NO,VERSION_ID,LINE_NO,INVENTORY_ITEM_ID,INVENTORY_ITEM_NAME,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,?,?,TO_DATE(?,'YYYYMMDD'),NULL,NULL,NULL,NULL,NULL,?,SYSDATE,?"+
				  " FROM ORADDMAN.TSA01_OEM_LINES_ALL B"+
				  " WHERE B.REQUEST_NO||'-'|| B.VERSION_ID ||'.'|| B.LINE_NO=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,trans_id);    
			pstmt.setString(2,"RECEIVE");    
			pstmt.setString(3,request.getParameter("rcv_qty_"+chk[i]));
			pstmt.setString(4,request.getParameter("rcv_new_qty_"+chk[i]));
			pstmt.setString(5,request.getParameter("exp_date_"+chk[i]));
			pstmt.setString(6,UserName);    
			pstmt.setString(7,request.getParameter("lot_seq_"+chk[i]));  //add by Peggy 20220812   
			pstmt.setString(8,chk[i]);    
			pstmt.executeQuery();				  	
		}	
		con.commit();

		try
		{
			CallableStatement cs3 = con.prepareCall("{call TSA01_OEM_PKG.SUBMIT_REQ(?,?)}");
			cs3.setString(1,trans_id); 
			cs3.setString(2,"WIPCOMPLETE"); 
			cs3.execute();
			cs3.close();	
			
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("送出成功!若要繼續下一筆請按確定鍵,否則按下取消鍵回首頁!"))
			{
				setSubmit("../jsp/TSA01OEMWIPCompletion.jsp");
			}
			else
			{
				setSubmit("../ORADDSMainMenu.jsp");
			}
			</script>
		<%			
		}
		catch(Exception e)
		{
			sql = " UPDATE ORADDMAN.TSA01_OEM_LINES_ALL A"+
                  " SET RECEIVE_QTY=NVL(RECEIVE_QTY,0)-(SELECT SUM(QUANTITY) FROM ORADDMAN.TSA01_OEM_LINES_TRANS_ALL B"+
                  "                              WHERE B.REQUEST_NO=A.REQUEST_NO"+
                  "                              AND B.VERSION_ID=A.VERSION_ID"+
                  "                              AND B.LINE_NO=A.LINE_NO"+
                  "                              AND B.TRANS_NO=?)"+
                  " WHERE EXISTS (SELECT 1 FROM ORADDMAN.TSA01_OEM_LINES_TRANS_ALL C"+
                  "               WHERE C.TRANS_NO=? AND C.REQUEST_NO=A.REQUEST_NO AND C.VERSION_ID=A.VERSION_ID)";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,trans_id);
			pstmt.setString(2,trans_id);
			pstmt.executeQuery();				  

            sql =" DELETE ORADDMAN.TSA01_OEM_LINES_TRANS_ALL A"+
                  " WHERE TRANS_NO=?";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,trans_id);
			pstmt.executeQuery();
			con.commit();	
		%>		
			<script language="JavaScript" type="text/JavaScript">
				alert("交易異常,請重新作業!");
				setSubmit("../jsp/TSA01OEMWIPCompletion.jsp");
			</script>
		<%							  
		}			
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<font color='red'>交易失敗,請速洽系統工程師,謝謝!!<br>"+e.getMessage()+"</font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

