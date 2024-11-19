<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.io.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>SG PO Receive Process</title>
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
<FORM ACTION="TSSGPOReceiveProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String v_rcv_group_id="",strProgram="",FileName="",return_trx_id="";
int chk_cnt=0;
OutputStream os =null;


if (TRANSTYPE.equals("RECEIVE"))
{
	try
	{
		chk_cnt =1;strProgram="TSCSGPOInspect.jsp";
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無收貨交易!!");
		}
		
		String LotArray[][]=POReceivingBean.getArray2DContent();
		if (LotArray==null)
		{
			throw new Exception("未輸入收貨批號明細!!");
		}
		
		for(int i=0; i< chk.length ;i++)
		{
			if (i==0)
			{
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery("select SG_RECEIVE_SEQ_ID_S.nextval from dual");
				if (!rs.next())
				{
					throw new Exception("ID not Found!!");
				}
				else
				{
					v_rcv_group_id = rs.getString(1);
				}
				rs.close();
				statement.close();				
			}
				
			for( int j=0 ; j< LotArray.length ; j++ ) 
			{
				//line_location_id
				if (LotArray[j][0] != null && LotArray[j][0].equals(chk[i]))
				{
					sql = " insert into oraddman.tssg_po_receive_detail"+
						  "(rcv_group_id"+           //1
						  ",po_no"+                  //2
						  ",po_header_id"+           //3
						  ",po_line_id"+             //4
						  ",po_line_location_id"+    //5
						  ",organization_id"+        //6
						  ",inventory_item_id"+      //7
						  ",item_name"+              //8
						  ",item_desc"+              //9
						  ",creation_date"+          //10
						  ",created_by"+             //11
						  ",last_update_date"+       //12
						  ",last_updated_by"+        //13
						  ",vendor_name"+            //14
						  ",vendor_site_id"+         //15
						  ",lot_number"+             //16
						  ",date_code"+              //17
						  ",rcv_qty"+                //18
						  ",receive_date "+          //19
						  ",remarks"+                //20
						  ",no_match_fifo_reason "+  //21
						  ",status"+                 //22
						  ",receive_trx_id "+        //23
						  ",lot_expiration_date "+   //24
						  ",vendor_carton_no "+      //25,add by Peggy 2020416
						  ",delivery_type"+          //26,add by Peggy 20200424
						  ",nw"+                     //27,add by Peggy 20200426
						  ",gw"+                     //28,add by Peggy 20200426
						  ",dc_yyww"+               //29,add by Peggy 20220721
						  ")"+
						  " values"+
						  "(?"+                      //1
						  ",?"+                      //2
						  ",?"+                      //3
						  ",?"+                      //4
						  ",?"+                      //5
						  ",?"+                      //6
						  ",?"+                      //7
						  ",?"+                      //8
						  ",?"+                      //9
						  ",sysdate"+                //10
						  ",?"+                      //11
						  ",sysdate"+                //12
						  ",?"+                      //13
						  ",?"+                      //14
						  ",?"+                      //15
						  ",?"+                      //16
						  ",?"+                      //17
						  ",?*1000"+                 //18
						  ",to_date(?,'yyyymmdd')"+  //19
						  ",?"+                      //20
						  ",?"+                      //21
						  ",?"+                      //22
						  ",SG_RECEIVE_TRX_ID_S.nextval"+  //23
						  ",(SELECT D_DATE FROM TABLE(TSC_GET_ITEM_DATE_INFO(?,?)) WHERE D_TYPE='VALID')"+ //24
						  ",?"+                     //25,add by Peggy 20200416
						  ",?"+                     //26,add by Peggy 20200424
						  ",?"+                     //27,add by Peggy 20200426
						  ",?"+                     //28,add by Peggy 20200426
						  ",?"+                     //29,add by Peggy 20220721
						  ")";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,v_rcv_group_id); 
					pstmtDt.setString(2,request.getParameter("PO_NO_"+chk[i]));
					pstmtDt.setString(3,request.getParameter("PO_HEADER_ID_"+chk[i])); 
					pstmtDt.setString(4,request.getParameter("PO_LINE_ID_"+chk[i]));
					pstmtDt.setString(5,chk[i]); 
					pstmtDt.setString(6,request.getParameter("ORG_ID_"+chk[i]));
					pstmtDt.setString(7,request.getParameter("ITEM_ID_"+chk[i])); 
					pstmtDt.setString(8,request.getParameter("ITEM_NAME_"+chk[i]));
					pstmtDt.setString(9,request.getParameter("ITEM_DESC_"+chk[i])); 
					pstmtDt.setString(10,UserName);
					pstmtDt.setString(11,UserName);
					pstmtDt.setString(12,request.getParameter("VENDOR_NAME_"+chk[i]));
					pstmtDt.setString(13,request.getParameter("VENDOR_SITE_ID_"+chk[i]));
					pstmtDt.setString(14,LotArray[j][2]); 
					pstmtDt.setString(15,LotArray[j][3]); 
					pstmtDt.setString(16,LotArray[j][4]); 
					pstmtDt.setString(17,LotArray[j][1]); 
					pstmtDt.setString(18,LotArray[j][5]); 
					pstmtDt.setString(19,LotArray[j][6]); 					
					pstmtDt.setString(20,TRANSTYPE); 					
					pstmtDt.setString(21,LotArray[j][3]); 					
					pstmtDt.setString(22,request.getParameter("ITEM_NAME_"+chk[i])); 					
					pstmtDt.setString(23,LotArray[j][7]); 					
					pstmtDt.setString(24,LotArray[j][8]); 					
					pstmtDt.setString(25,LotArray[j][9]); 					
					pstmtDt.setString(26,LotArray[j][10]); 					
					pstmtDt.setString(27,LotArray[j][11]); 	  //add by Peggy 20220721				
					pstmtDt.executeQuery();
					pstmtDt.close();
				}
			}
		}	
		
		CallableStatement cs3 = con.prepareCall("{call apps.TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
		cs3.setString(1,"RECEIVE"); 
		cs3.setString(2,v_rcv_group_id); 
		cs3.setString(3,UserName); 
		cs3.execute();
		cs3.close();
		con.commit();
		POReceivingBean.setArray2DString(null);	
		
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("收貨動作成功!!");
			setSubmit("../jsp/TSCSGPOReceive.jsp");
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		POReceivingBean.setArray2DString(null);	
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGPOReceive.jsp'>回倉管收貨功能</a></font>");
	}
}
else if (TRANSTYPE.equals("INSPECT"))
{
	try
	{
		String id="",qc_id="";
		int rej_chk_cnt=0;
		strProgram="TSCSGPOBuyer.jsp";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select apps.sg_inspect_seq_id_s.nextval from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				qc_id = rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			for(int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tssg_po_receive_detail a"+
					  " set inspect_result=?"+
					  ",inspect_reason=?"+
					  ",inspect_remark=?"+
					  ",inspect_group_id=?"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  ",inspection_date=sysdate"+
					  ",inspected_by=?"+
					  ",status=?"+
					  ",wave_flag=?"+
					  ",check_num=?"+
					  ",RCV_RETURN_TRX_ID=case when ?='R' then ?*-1 else null end"+
					  ",RETURN_GROUP_ID=case when ?='R' then ?*-1 else null end"+
					  ",RETURN_QTY=case when ?='R' then RCV_QTY  else null end"+
					  ",RETURN_REASON=case when ?='R' then ? else null end"+
					  ",RETURNED_DATE=case when ?='R' then sysdate else null end"+
					  ",RETURNED_BY=case when ?='R' then CREATED_BY else null end"+
					  ",RETURN_APPROVE_DATE=case when ?='R' then sysdate  else null end"+
					  ",RETURN_APPROVED_BY=case when ?='R' then ? else null end"+
					  ",RETURN_APPROVE_RESULT=case when ?='R' then ? else null end"+
					  " WHERE receive_trx_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(2,request.getParameter("qcrej_"+chk[i]));
				pstmtDt.setString(3,request.getParameter("qcremark_"+chk[i]));
				pstmtDt.setString(4,qc_id);
				pstmtDt.setString(5,UserName);
				pstmtDt.setString(6,UserName);
				pstmtDt.setString(7,(request.getParameter("rdo_"+chk[i]).equals("R")?"REJECT":"ACCEPT"));
				pstmtDt.setString(8,(request.getParameter("rdo_"+chk[i]).equals("W")?"Y":"N"));
				pstmtDt.setString(9,request.getParameter("chknum_"+chk[i]));
				pstmtDt.setString(10,request.getParameter("rdo_"+chk[i]));  //RCV_RETURN_TRX_ID
				pstmtDt.setString(11,qc_id);
				pstmtDt.setString(12,request.getParameter("rdo_"+chk[i]));  //RETURN_GROUP_ID
				pstmtDt.setString(13,qc_id);
				pstmtDt.setString(14,request.getParameter("rdo_"+chk[i]));  //RETURN_QTY
				pstmtDt.setString(15,request.getParameter("rdo_"+chk[i]));  //RETURN_REASON
				pstmtDt.setString(16,request.getParameter("qcrej_"+chk[i]));
				pstmtDt.setString(17,request.getParameter("rdo_"+chk[i]));  //RETURNED_DATE
				pstmtDt.setString(18,request.getParameter("rdo_"+chk[i]));  //RETURNED_BY
				pstmtDt.setString(19,request.getParameter("rdo_"+chk[i]));  //RETURN_APPROVE_DATE
				pstmtDt.setString(20,request.getParameter("rdo_"+chk[i]));  //RETURN_APPROVED_BY
				pstmtDt.setString(21,UserName);
				pstmtDt.setString(22,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(23,"AGREE");
				pstmtDt.setString(24,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				if (!request.getParameter("rdo_"+chk[i]).equals("R"))
				{
					chk_cnt++;
				}
				else
				{
					rej_chk_cnt++;
				}
			}
			
			//add by Peggy 20201127
			if (rej_chk_cnt>0)
			{
				sql = " INSERT INTO oraddman.tssg_stock_overview"+
					  " SELECT TSSG_STOCK_ID_S.NEXTVAL,X.* "+
					  " FROM (SELECT A.INVENTORY_ITEM_ID"+
					  "      ,A.ITEM_NAME"+
					  "      ,A.ITEM_DESC"+
					  "      ,A.ORGANIZATION_ID"+
					  "      ,case when UPPER(nvl(A.delivery_type,' '))='Y' THEN '02' ELSE '01' END"+
					  "      ,A.LOT_NUMBER"+
					  "      ,A.DATE_CODE"+
					  "      ,TRUNC(RECEIVE_DATE) RECEIVE_DATE"+
					  "      ,SUM(RCV_QTY) RCV_QTY"+
					  "      ,0 ALLOCATE_IN_QTY"+
					  "      ,0 ALLOCATE_OUT_QTY"+
					  "      ,SUM(NVL(RETURN_QTY,0)) RETURN_QTY"+
					  "      ,0 SHIPPED_QTY,PO_LINE_LOCATION_ID"+
					  "      ,B.PO_HEADER_ID"+
					  "      ,NULL FROM_SG_STOCK_ID"+
					  "      ,NULL REMARKS"+
					  "      ,MIN(A.CREATION_DATE) CREATION_DATE"+
					  "      ,A.CREATED_BY"+
					  "      ,MAX(A.LAST_UPDATE_DATE) LAST_UPDATE_DATE"+
					  "      ,A.LAST_UPDATED_BY"+
					  "      ,A.VENDOR_SITE_ID "+
					  "      ,C.VENDOR_SITE_CODE"+
					  "      ,VENDOR_CARTON_NO"+
					  "      ,NW"+
					  "      ,GW"+
					  "      ,'' cust_partno"+
					  "      ,A.RECEIPT_NUM"+
					  "      ,a.DC_YYWW"+  //add by Peggy 20220721
					  "      from oraddman.tssg_po_receive_detail A"+
					  "      ,PO.PO_LINE_LOCATIONS_ALL B"+
					  "      ,AP_SUPPLIER_SITES_ALL C"+
					  "      WHERE A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID"+
					  "      AND A.VENDOR_SITE_ID=C.VENDOR_SITE_ID"+
					  "      AND A.inspect_group_id=?"+
					  "      AND A.inspect_result=?"+
					  "      GROUP BY A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,RECEIVE_DATE,VENDOR_CARTON_NO,A.CREATED_BY,A.LAST_UPDATED_BY,B.PO_HEADER_ID,C.VENDOR_SITE_CODE,NW,GW,A.RECEIPT_NUM,A.delivery_type,A.DC_YYWW"+
					  "      ORDER BY LOT_NUMBER,DATE_CODE) x";
				PreparedStatement pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,qc_id);
				pstmtDt1.setString(2,"R");
				pstmtDt1.executeQuery();
				pstmtDt1.close();	
			}			

			CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
			cs3.setString(1,TRANSTYPE); 
			cs3.setString(2,qc_id); 
			cs3.setString(3,UserName); 
			cs3.execute();
			cs3.close();
			con.commit();

			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
					setSubmit("../jsp/TSCSGPOInspect.jsp");
				</script>
			<%
		}
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGPOInspect.jsp'>回品管檢驗功能</a></font>");
	}	
}
else if (TRANSTYPE.equals("BUYERCHECK"))
{
	try
	{
		String id="",qc_id="";
		int rej_chk_cnt=0;
		strProgram="TSCSGPOApprove.jsp";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select apps.sg_acceptchk_seq_id_s.nextval from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				qc_id = rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			for(int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tssg_po_receive_detail a"+
					  " set buyer_result=?"+
					  ",buyer_reason=?"+
					  ",buyer_remark=?"+
					  ",buyer_group_id=?"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  ",buyer_date=sysdate"+
					  ",buyer_by=?"+
					  ",status=?"+
					  ",RCV_RETURN_TRX_ID=case when ?='R' then ?*-1 else null end"+
					  ",RETURN_GROUP_ID=case when ?='R' then ?*-1 else null end"+
					  ",RETURN_QTY=case when ?='R' then RCV_QTY  else null end"+
					  ",RETURN_REASON=case when ?='R' then ? else null end"+
					  ",RETURNED_DATE=case when ?='R' then sysdate else null end"+
					  ",RETURNED_BY=case when ?='R' then CREATED_BY else null end"+
					  ",RETURN_APPROVE_DATE=case when ?='R' then sysdate  else null end"+
					  ",RETURN_APPROVED_BY=case when ?='R' then ? else null end"+
					  ",RETURN_APPROVE_RESULT=case when ?='R' then ? else null end"+					  
					  " WHERE receive_trx_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(2,request.getParameter("qcrej_"+chk[i]));
				pstmtDt.setString(3,request.getParameter("qcremark_"+chk[i]));
				pstmtDt.setString(4,qc_id);
				pstmtDt.setString(5,UserName);
				pstmtDt.setString(6,UserName);
				pstmtDt.setString(7,(request.getParameter("rdo_"+chk[i]).equals("R")?"REJECT":"CHECKED"));
				pstmtDt.setString(8,request.getParameter("rdo_"+chk[i]));  //RCV_RETURN_TRX_ID
				pstmtDt.setString(9,qc_id);
				pstmtDt.setString(10,request.getParameter("rdo_"+chk[i]));  //RETURN_GROUP_ID
				pstmtDt.setString(11,qc_id);
				pstmtDt.setString(12,request.getParameter("rdo_"+chk[i]));  //RETURN_QTY
				pstmtDt.setString(13,request.getParameter("rdo_"+chk[i]));  //RETURN_REASON
				pstmtDt.setString(14,request.getParameter("qcrej_"+chk[i]));
				pstmtDt.setString(15,request.getParameter("rdo_"+chk[i]));  //RETURNED_DATE
				pstmtDt.setString(16,request.getParameter("rdo_"+chk[i]));  //RETURNED_BY
				pstmtDt.setString(17,request.getParameter("rdo_"+chk[i]));  //RETURN_APPROVE_DATE
				pstmtDt.setString(18,request.getParameter("rdo_"+chk[i]));  //RETURN_APPROVED_BY
				pstmtDt.setString(19,UserName);
				pstmtDt.setString(20,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(21,"AGREE");				
				pstmtDt.setString(22,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				if (!request.getParameter("rdo_"+chk[i]).equals("R"))
				{
					chk_cnt++;
				}
				else
				{
					rej_chk_cnt++;	
				}
				
			}

			//add by Peggy 20201127
			if (rej_chk_cnt>0)
			{
				sql = " INSERT INTO oraddman.tssg_stock_overview"+
					  " SELECT TSSG_STOCK_ID_S.NEXTVAL,X.* "+
					  " FROM (SELECT A.INVENTORY_ITEM_ID"+
					  "      ,A.ITEM_NAME"+
					  "      ,A.ITEM_DESC"+
					  "      ,A.ORGANIZATION_ID"+
					  "      ,case when UPPER(nvl(A.delivery_type,' '))='Y' THEN '02' ELSE '01' END"+
					  "      ,A.LOT_NUMBER"+
					  "      ,A.DATE_CODE"+
					  "      ,TRUNC(RECEIVE_DATE) RECEIVE_DATE"+
					  "      ,SUM(RCV_QTY) RCV_QTY"+
					  "      ,0 ALLOCATE_IN_QTY"+
					  "      ,0 ALLOCATE_OUT_QTY"+
					  "      ,SUM(NVL(RETURN_QTY,0)) RETURN_QTY"+
					  "      ,0 SHIPPED_QTY,PO_LINE_LOCATION_ID"+
					  "      ,B.PO_HEADER_ID"+
					  "      ,NULL FROM_SG_STOCK_ID"+
					  "      ,NULL REMARKS"+
					  "      ,MIN(A.CREATION_DATE) CREATION_DATE"+
					  "      ,A.CREATED_BY"+
					  "      ,MAX(A.LAST_UPDATE_DATE) LAST_UPDATE_DATE"+
					  "      ,A.LAST_UPDATED_BY"+
					  "      ,A.VENDOR_SITE_ID "+
					  "      ,C.VENDOR_SITE_CODE"+
					  "      ,VENDOR_CARTON_NO"+
					  "      ,NW"+
					  "      ,GW"+
					  "      ,'' cust_partno"+
					  "      ,A.RECEIPT_NUM"+
					  "      ,A.DC_YYWW"+  //add by Peggy 20220721
					  "      from oraddman.tssg_po_receive_detail A"+
					  "      ,PO.PO_LINE_LOCATIONS_ALL B"+
					  "      ,AP_SUPPLIER_SITES_ALL C"+
					  "      WHERE A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID"+
					  "      AND A.VENDOR_SITE_ID=C.VENDOR_SITE_ID"+
					  "      AND A.buyer_group_id=?"+
					  "      AND A.buyer_result=?"+
					  "      GROUP BY A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,RECEIVE_DATE,VENDOR_CARTON_NO,A.CREATED_BY,A.LAST_UPDATED_BY,B.PO_HEADER_ID,C.VENDOR_SITE_CODE,NW,GW,A.RECEIPT_NUM,A.delivery_type,A.DC_YYWW"+
					  "      ORDER BY LOT_NUMBER,DATE_CODE) x";
				PreparedStatement pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,qc_id);
				pstmtDt1.setString(2,"R");
				pstmtDt1.executeQuery();
				pstmtDt1.close();		
			}	

			CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
			cs3.setString(1,TRANSTYPE); 
			cs3.setString(2,qc_id); 
			cs3.setString(3,UserName); 
			cs3.execute();
			cs3.close();
			con.commit();
			
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
					setSubmit("../jsp/TSCSGPOBuyer.jsp");
				</script>
			<%
		}
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGPOBuyer.jsp'>回採購點收功能</a></font>");
	}	
}
else if (TRANSTYPE.equals("APPROVE"))
{
	String STATUS="CHECKED",STATUS1="RETURN";
	String deliver_user ="",return_user="";
	String open_qty="",return_qty="";
	try
	{
		String id="",warehouse_id="";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select apps.sg_deliver_seq_id_s.nextval from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				warehouse_id = rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			for(int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tssg_po_receive_detail a";
				if (request.getParameter("status_"+chk[i]).equals(STATUS))
				{
					deliver_user=request.getParameter("createdby_"+chk[i]);
					sql += " set deliver_result=case status when ? then case when ?=? then ? else ? end else ? end"+
						   ",deliver_group_id=?"+
						   ",approve_date=sysdate"+
						   ",approved_by=?"+
						   ",RCV_RETURN_TRX_ID=case status when ? then case when ?=? then null else ?*-1 end else null end"+
						   ",RETURN_GROUP_ID=case status when ? then case when ?=? then null else ?*-1 end else null end"+
						   ",RETURN_QTY=case status when ? then case when ?=? then null else RCV_QTY end else null end"+
						   ",RETURN_REASON=case status when ? then case when ?=? then null else ? end else null end"+
						   ",RETURNED_DATE=case status when ? then case when ?=? then null else sysdate end else null end"+
						   ",RETURNED_BY=case status when ? then case when ?=? then null else CREATED_BY end else null end"+
						   ",RETURN_APPROVE_DATE=case status when ? then case when ?=? then null else sysdate end else null end"+
						   ",RETURN_APPROVED_BY=case status when ? then case when ?=? then null else ? end else null end"+
						   ",RETURN_APPROVE_RESULT=case status when ? then case when ?=? then null else ? end else null end"+
						   ",DELIVER_REMARK=?";
				}
				else
				{
					return_user=request.getParameter("createdby_"+chk[i]);
					sql += " set return_approve_result=case status when ? then case when ?=? then ? else ? end else ? end"+
						   ",return_group_id=?"+
						   ",return_approve_date=sysdate"+
						   ",return_approved_by=?";
				}
				sql += ",last_updated_by=?"+
					   ",last_update_date=sysdate"+
					   ",status=?"+
					   //",subinventory_code=(select case when mp.organization_code in ('SG1','SG2') then '01' else case when TSC_INV_Category(a.inventory_item_id, 43, 1100000003) ='SSD' then '12' else '14' end end from inv.mtl_parameters mp where mp.organization_id=a.organization_id)"+
					   ",subinventory_code= case when UPPER(nvl(delivery_type,' '))='Y' THEN '02' ELSE '01' END"+ //modify Peggy 20200424
				       " where receive_trx_id=?";
				if (request.getParameter("status_"+chk[i]).equals(STATUS))
				{					   
					sql +=" and DELIVER_GROUP_ID is null";  //ADD BY PEGGY 20210914
				}
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				if (request.getParameter("status_"+chk[i]).equals(STATUS))
				{
					pstmtDt.setString(1,STATUS);
					pstmtDt.setString(2,request.getParameter("ACTIONTYPE"));
					pstmtDt.setString(3,"AGREE");
					pstmtDt.setString(4,"DELIVER");
					pstmtDt.setString(5,"RETURN TO VENDOR");
					pstmtDt.setString(6,request.getParameter("ACTIONTYPE"));
					pstmtDt.setString(7,warehouse_id);
					pstmtDt.setString(8,UserName);
					pstmtDt.setString(9,STATUS);
					pstmtDt.setString(10,request.getParameter("ACTIONTYPE")); //RCV_RETURN_TRX_ID
					pstmtDt.setString(11,"AGREE");
					pstmtDt.setString(12,warehouse_id);
					pstmtDt.setString(13,STATUS);
					pstmtDt.setString(14,request.getParameter("ACTIONTYPE")); //RETURN_GROUP_ID
					pstmtDt.setString(15,"AGREE");
					pstmtDt.setString(16,warehouse_id);
					pstmtDt.setString(17,STATUS);
					pstmtDt.setString(18,request.getParameter("ACTIONTYPE"));//RETURN_QTY
					pstmtDt.setString(19,"AGREE");
					pstmtDt.setString(20,STATUS);
					pstmtDt.setString(21,request.getParameter("ACTIONTYPE"));//RETURN_REASON
					pstmtDt.setString(22,"AGREE");
					pstmtDt.setString(23,request.getParameter("REMARKS_"+chk[i])); 
					pstmtDt.setString(24,STATUS);
					pstmtDt.setString(25,request.getParameter("ACTIONTYPE")); //RETURNED_DATE
					pstmtDt.setString(26,"AGREE");
					pstmtDt.setString(27,STATUS);
					pstmtDt.setString(28,request.getParameter("ACTIONTYPE")); //RETURNED_BY
					pstmtDt.setString(29,"AGREE");
					pstmtDt.setString(30,STATUS);
					pstmtDt.setString(31,request.getParameter("ACTIONTYPE")); //RETURN_APPROVE_DATE
					pstmtDt.setString(32,"AGREE");
					pstmtDt.setString(33,STATUS);
					pstmtDt.setString(34,request.getParameter("ACTIONTYPE")); //RETURN_APPROVED_BY
					pstmtDt.setString(35,"AGREE");
					pstmtDt.setString(36,UserName);
					pstmtDt.setString(37,STATUS);
					pstmtDt.setString(38,request.getParameter("ACTIONTYPE")); //RETURN_APPROVE_RESULT
					pstmtDt.setString(39,"AGREE");
					pstmtDt.setString(40,"AGREE");
					pstmtDt.setString(41,request.getParameter("REMARKS_"+chk[i])); 
					pstmtDt.setString(42,UserName);
					pstmtDt.setString(43,"CLOSED");
					pstmtDt.setString(44,chk[i]);
				}
				else
				{				
					pstmtDt.setString(1,STATUS);
					pstmtDt.setString(2,request.getParameter("ACTIONTYPE"));
					pstmtDt.setString(3,"AGREE");
					pstmtDt.setString(4,"DELIVER");
					pstmtDt.setString(5,"RETURN TO VENDOR");
					pstmtDt.setString(6,request.getParameter("ACTIONTYPE"));
					pstmtDt.setString(7,warehouse_id);
					pstmtDt.setString(8,UserName);
					pstmtDt.setString(9,UserName);
					pstmtDt.setString(10,"CLOSED");
					pstmtDt.setString(11,chk[i]);
				}
				pstmtDt.executeQuery();
				pstmtDt.close();
			}

			if (!deliver_user.equals(""))
			{	
				sql = " INSERT INTO oraddman.tssg_stock_overview"+
                      " SELECT TSSG_STOCK_ID_S.NEXTVAL,X.* "+
					  " FROM (SELECT A.INVENTORY_ITEM_ID"+
					  "      ,A.ITEM_NAME"+
					  "      ,A.ITEM_DESC"+
					  "      ,A.ORGANIZATION_ID"+
					  "      ,A.SUBINVENTORY_CODE"+
					  "      ,A.LOT_NUMBER"+
					  "      ,A.DATE_CODE"+
					  //"      ,TRUNC(RECEIVE_DATE) RECEIVE_DATE"+
					  "      ,trunc(APPROVE_DATE)  RECEIVE_DATE"+  //add by Peggy 20210726
					  "      ,SUM(RCV_QTY) RCV_QTY"+
					  "      ,0 ALLOCATE_IN_QTY"+
					  "      ,0 ALLOCATE_OUT_QTY"+
					  "      ,NVL(SUM(RETURN_QTY),0) RETURN_QTY"+
					  "      ,0 SHIPPED_QTY,PO_LINE_LOCATION_ID"+
					  "      ,B.PO_HEADER_ID"+
					  "      ,NULL FROM_SG_STOCK_ID"+
					  "      ,NULL REMARKS"+
					  "      ,MIN(A.CREATION_DATE) CREATION_DATE"+
					  "      ,A.CREATED_BY"+
					  "      ,MAX(A.LAST_UPDATE_DATE) LAST_UPDATE_DATE"+
					  "      ,A.LAST_UPDATED_BY"+
					  "      ,A.VENDOR_SITE_ID "+
					  "      ,C.VENDOR_SITE_CODE"+
					  "      ,VENDOR_CARTON_NO"+
					  "      ,NW"+
					  "      ,GW"+
					  "      ,'' cust_partno"+
					  "      ,A.RECEIPT_NUM"+
					  "      ,A.DC_YYWW"+ //add by Peggy 20220721
                      "      from oraddman.tssg_po_receive_detail A"+
					  "      ,PO.PO_LINE_LOCATIONS_ALL B"+
					  "      ,AP_SUPPLIER_SITES_ALL C"+
                      "      WHERE A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID"+
                      "      AND A.VENDOR_SITE_ID=C.VENDOR_SITE_ID"+
                      "      AND A.DELIVER_GROUP_ID=?"+
                      //"      GROUP BY A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,RECEIVE_DATE,VENDOR_CARTON_NO,A.CREATED_BY,A.LAST_UPDATED_BY,B.PO_HEADER_ID,C.VENDOR_SITE_CODE,NW,GW,A.RECEIPT_NUM"+
					  //"      GROUP BY A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,trunc(APPROVE_DATE),VENDOR_CARTON_NO,A.CREATED_BY,A.LAST_UPDATED_BY,B.PO_HEADER_ID,C.VENDOR_SITE_CODE,NW,GW,A.RECEIPT_NUM"+
					  "      GROUP BY A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,A.ITEM_NAME,A.ITEM_DESC,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,trunc(APPROVE_DATE),VENDOR_CARTON_NO,A.CREATED_BY,A.LAST_UPDATED_BY,B.PO_HEADER_ID,C.VENDOR_SITE_CODE,NW,GW,A.RECEIPT_NUM,A.DC_YYWW"+
                      "      ORDER BY LOT_NUMBER,DATE_CODE) x";
				PreparedStatement pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,warehouse_id);
				pstmtDt1.executeQuery();
				pstmtDt1.close();
					  
				CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
				cs3.setString(1,"DELIVER"); 
				cs3.setString(2,warehouse_id); 
				cs3.setString(3,deliver_user); 
				cs3.execute();
				cs3.close();
			}

			if (!return_user.equals(""))
			{
				sql = " SELECT A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,to_char(RECEIVE_DATE,'yyyymmdd') RECEIVE_DATE,VENDOR_CARTON_NO,SUM(RETURN_QTY) RETURN_QTY,RECEIPT_NUM"+
				      " ,NW,GW"+ //add by Peggy 20211230
                      " from oraddman.tssg_po_receive_detail A,PO.PO_LINE_LOCATIONS_ALL B,AP_SUPPLIER_SITES_ALL C"+
                      " WHERE A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID"+
                      " AND A.VENDOR_SITE_ID=C.VENDOR_SITE_ID"+
                      " AND A.RETURN_GROUP_ID='"+warehouse_id+"'"+
                      " GROUP BY A.VENDOR_SITE_ID,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,SUBINVENTORY_CODE,LOT_NUMBER,DATE_CODE,PO_LINE_LOCATION_ID,to_char(RECEIVE_DATE,'yyyymmdd'),VENDOR_CARTON_NO,RECEIPT_NUM"+
				      " ,NW,GW"+ //add by Peggy 20211230
                      " ORDER BY LOT_NUMBER,DATE_CODE";
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(sql);
				while (rs1.next())
				{
					open_qty = rs1.getString("RETURN_QTY");
					sql = " SELECT sg_stock_id,NVL(A.RECEIVED_QTY,0)+NVL(A.ALLOCATE_IN_QTY,0)-NVL(A.RETURN_QTY,0)-NVL(A.ALLOCATE_OUT_QTY,0)-NVL(A.SHIPPED_QTY,0)+"+
					      " NVL((SELECT SUM(TPCL.QTY) QTY FROM TSC_PICK_CONFIRM_LINES TPCL,TSC_PICK_CONFIRM_HEADERS TPCH WHERE TPCH.PICK_CONFIRM_DATE IS NULL AND TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID),0) onhand"+
						  " FROM oraddman.tssg_stock_overview a"+
					      " WHERE VENDOR_SITE_ID=?"+
						  " and ORGANIZATION_ID=?"+
						  " and INVENTORY_ITEM_ID=?"+
						  " and SUBINVENTORY_CODE=?"+
						  " and LOT_NUMBER=?"+
						  " and DATE_CODE=?"+
						  " and PO_LINE_LOCATION_ID=?"+
						  //" and to_char(RECEIVED_DATE,'yyyymmdd')=?"+
						  " and to_char(CREATION_DATE,'yyyymmdd')=?"+   //MODIFY BY PEGGY 20210813
						  " and NVL(VENDOR_CARTON_NO,'-999')=nvl(?,'-999')"+
						  " and nvl(a.RECEIPT_NUM,'-1')=nvl(?,-1)"+
						  " and nvl(a.NW,-1)=nvl(?,-1)"+  //add by Peggy 20211230
						  " and nvl(a.GW,-1)=nvl(?,-1)";  //add by Peggy 20211230
					PreparedStatement statement9 = con.prepareStatement(sql);
					statement9.setString(1,rs1.getString("VENDOR_SITE_ID"));
					statement9.setString(2,rs1.getString("ORGANIZATION_ID"));
					statement9.setString(3,rs1.getString("INVENTORY_ITEM_ID"));
					statement9.setString(4,rs1.getString("SUBINVENTORY_CODE"));
					statement9.setString(5,rs1.getString("LOT_NUMBER")); 
					statement9.setString(6,rs1.getString("DATE_CODE")); 
					statement9.setString(7,rs1.getString("PO_LINE_LOCATION_ID")); 
					statement9.setString(8,rs1.getString("RECEIVE_DATE")); 
					statement9.setString(9,rs1.getString("VENDOR_CARTON_NO")); 
					statement9.setString(10,rs1.getString("RECEIPT_NUM")); 
					statement9.setString(11,rs1.getString("NW"));  //add by Peggy 20211230
					statement9.setString(12,rs1.getString("GW"));  //add by Peggy 20211230 
					ResultSet rs9=statement9.executeQuery();
					while (rs9.next())
					{	
						if (Double.parseDouble(rs9.getString("onhand"))<Double.parseDouble(open_qty))
						{
							return_qty = rs9.getString("onhand");
						}
						else
						{
							return_qty = open_qty;
						}
						open_qty = ""+(Double.parseDouble(open_qty) - Double.parseDouble(return_qty));
						
						sql = " update oraddman.tssg_stock_overview"+
							  " set RETURN_QTY=nvl(RETURN_QTY,0)+?"+
							  " where sg_stock_id=?";
							  //" where VENDOR_SITE_ID=?"+
							  //" and ORGANIZATION_ID=?"+
							  //" and INVENTORY_ITEM_ID=?"+
							  //" and SUBINVENTORY_CODE=?"+
							  //" and LOT_NUMBER=?"+
							  //" and DATE_CODE=?"+
							  //" and PO_LINE_LOCATION_ID=?"+
							  //" and to_char(RECEIVED_DATE,'yyyymmdd')=?"+
							  //" and NVL(VENDOR_CARTON_NO,'-999')=nvl(?,'-999')";
						PreparedStatement pstmtDt1=con.prepareStatement(sql);  
						pstmtDt1.setString(1,""+return_qty);
						pstmtDt1.setString(2,rs9.getString("sg_stock_id"));
						//pstmtDt1.setString(2,rs1.getString("VENDOR_SITE_ID"));
						//pstmtDt1.setString(3,rs1.getString("ORGANIZATION_ID"));
						//pstmtDt1.setString(4,rs1.getString("INVENTORY_ITEM_ID"));
						//pstmtDt1.setString(5,rs1.getString("SUBINVENTORY_CODE"));
						//pstmtDt1.setString(6,rs1.getString("LOT_NUMBER"));
						//pstmtDt1.setString(7,rs1.getString("DATE_CODE"));
						//pstmtDt1.setString(8,rs1.getString("PO_LINE_LOCATION_ID"));
						//pstmtDt1.setString(9,rs1.getString("RECEIVE_DATE"));
						//pstmtDt1.setString(10,rs1.getString("VENDOR_CARTON_NO"));
						pstmtDt1.executeQuery();
						pstmtDt1.close();
					}
					rs9.close();
					statement9.close();
					
					if (Double.parseDouble(open_qty)>0)
					{
						throw new Exception("Lot:"+rs1.getString("LOT_NUMBER") +" 庫存不足,退庫失敗!");
					}
				}
				rs1.close();
				statement1.close();	

					  
				CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
				cs3.setString(1,"RETURN"); 
				cs3.setString(2,warehouse_id); 
				cs3.setString(3,return_user); 
				cs3.execute();
				cs3.close();
			}
			con.commit();
			
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
					setSubmit("../jsp/TSCSGPOApprove.jsp");
				</script>
			<%
		}
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGPOApprove.jsp'>回主管核淮功能</a></font>");
	}	

}
else if (TRANSTYPE.equals("RETURN"))
{
	try
	{
		chk_cnt=1;
		String id="",warehouse_id="";
		return_trx_id="";
		strProgram="TSCSGPOApprove.jsp";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			//Statement statement=con.createStatement();
			//ResultSet rs=statement.executeQuery("select apps.sg_deliver_seq_id_s.nextval from dual");
			//if (!rs.next())
			//{
			//	throw new Exception("ID not Found!!");
			//}
			//else
			//{
			//	warehouse_id = rs.getString(1);
			//}
			//rs.close();
			//statement.close();	
			
			//add by Peggy 20220104		
			for(int i=0; i< chk.length ;i++)
			{
				if (return_trx_id.equals(""))
				{ 
					return_trx_id=chk[i];
				}
				else
				{
					return_trx_id =return_trx_id+","+chk[i];
				}
				
				sql = " update oraddman.tssg_po_receive_detail a"+
					  " set return_qty=?*1000"+
					  ",return_reason=?"+
					  ",returned_by=?"+
					  ",returned_date=sysdate"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  ",status=?"+
					  " where receive_trx_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("return_qty_"+chk[i]));
				pstmtDt.setString(2,request.getParameter("return_reason_"+chk[i]));
				pstmtDt.setString(3,UserName);
				pstmtDt.setString(4,UserName);
				pstmtDt.setString(5,TRANSTYPE);
				pstmtDt.setString(6,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}

			//CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
			//cs3.setString(1,TRANSTYPE); 
			//cs3.setString(2,warehouse_id); 
			//cs3.setString(3,UserName); 
			//cs3.execute();
			//cs3.close();
			con.commit();
			
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
					setSubmit("../jsp/TSCSGPOReturn.jsp");
				</script>
			<%
		}
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGPOReturn.jsp'>回驗收退庫功能</a></font>");
	}	
}
else if (TRANSTYPE.equals("ALLOCATE"))  //add by Peggy 20210105
{
	try
	{
		String allocate_id="";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select SG_ALLOCATE_BATCH_ID_S.NEXTVAL from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				allocate_id= rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			for(int i=0; i< chk.length ;i++)
			{
				sql = " insert into oraddman.tssg_stock_allocate_detail "+
				      " (sg_stock_id"+
					  ",inventory_item_id"+
					  ",item_name"+
					  ",item_desc"+
					  ",from_organization_id"+
					  ",from_subinventory_code"+
					  ",to_organization_id"+
					  ",to_subinventory_code"+
					  ",lot_number"+
					  ",date_code"+
					  ",allocated_qty"+
					  ",remarks"+
					  ",allocated_date"+
					  ",allocated_by"+
					  ",allocate_batch_id"+
					  ",dc_yyww"+ 
					  ",transaction_type_id"+ //add by Peggy 20231226
					  ")"+
					  " select sg_stock_id"+
					  ",inventory_item_id"+
					  ",item_name"+
					  ",item_desc"+
					  ",organization_id"+
					  ",subinventory_code"+
					  ",?"+
					  ",?"+
					  ",lot_number"+
					  ",date_code"+
					  ",?*1000"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+
					  ",sysdate"+
					  ",?"+
					  ",?"+
					  ",dc_yyww"+ //add by Peggy 20220721
					  ",?"+ //add by Peggy 20231226
					  " from oraddman.tssg_stock_overview "+
					  " where sg_stock_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TO_ORG_"+chk[i])); 
				pstmtDt.setString(2,request.getParameter("TO_SUBINV_"+chk[i])); 
				pstmtDt.setString(3,request.getParameter("TO_TRANFER_QTY_"+chk[i])); 
				pstmtDt.setString(4,request.getParameter("remark_"+chk[i])); 
				pstmtDt.setString(5,UserName);
				pstmtDt.setString(6,allocate_id); //RETURNED_DATE
				pstmtDt.setInt(7,3); //transaction type id
				pstmtDt.setString(8,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " update oraddman.tssg_stock_overview"+
				      " set ALLOCATE_OUT_QTY=NVL(ALLOCATE_OUT_QTY,0)+?*1000"+
					  " where sg_stock_id=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TO_TRANFER_QTY_"+chk[i])); 
				pstmtDt.setString(2,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " INSERT INTO  oraddman.tssg_stock_overview"+
                      " (sg_stock_id"+
                      ",inventory_item_id"+
                      ",item_name"+
                      ",item_desc"+
                      ",organization_id"+
                      ",subinventory_code"+
                      ",lot_number"+
                      ",date_code"+
                      ",received_date"+
                      ",received_qty"+
                      ",allocate_in_qty"+
                      ",allocate_out_qty"+
                      ",return_qty"+
                      ",shipped_qty"+
                      ",po_line_location_id"+
                      ",po_header_id"+
                      ",from_sg_stock_id"+
                      ",remarks"+
                      ",creation_date"+
                      ",created_by"+
                      ",last_update_date"+
                      ",last_updated_by"+
                      ",vendor_site_id"+
                      ",vendor_site_code"+
                      ",vendor_carton_no"+
                      ",nw"+
                      ",gw"+
                      ",cust_partno"+
                      ",receipt_num"+
					  ",DC_YYWW"+
                      " )"+
                      " select TSSG_STOCK_ID_S.NEXTVAL"+
                      ",inventory_item_id"+
                      ",item_name"+
                      ",item_desc"+
                      ",?"+
					  ",?"+
                      ",lot_number"+
                      ",date_code"+
                      ",SYSDATE"+
                      ",0"+
                      ",?*1000"+
                      ",0"+
                      ",0"+
                      ",0"+
                      ",NULL"+
                      ",NULL"+
                      ",sg_stock_id"+
                      ",NULL"+
                      ",SYSDATE"+
                      ",?"+
                      ",SYSDATE"+
                      ",?"+
                      ",(SELECT a.VENDOR_SITE_ID FROM AP_SUPPLIER_SITES_ALL a,AP_SUPPLIER_SITES_ALL b"+
					  "  where a.ORG_ID=906 and a.vendor_id=b.vendor_id and a.vendor_site_id<>tso.VENDOR_SITE_ID"+
                      "  and b.vendor_site_id=tso.VENDOR_SITE_ID)"+
                      ",(SELECT a.VENDOR_SITE_CODE FROM AP_SUPPLIER_SITES_ALL a,AP_SUPPLIER_SITES_ALL b"+
					  "  where a.ORG_ID=906 and a.vendor_id=b.vendor_id and a.vendor_site_id<>tso.VENDOR_SITE_ID"+
                      "  and b.vendor_site_id=tso.VENDOR_SITE_ID)"+
                      ",VENDOR_CARTON_NO"+
                      ",NULL"+
                      ",NULL"+
                      ",NULL"+
                      ",NULL"+
					  ",DC_YYWW"+ //add by Peggy 20220721
					  " from oraddman.tssg_stock_overview tso "+
                      " where sg_stock_id=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TO_ORG_"+chk[i])); 
				pstmtDt.setString(2,request.getParameter("TO_SUBINV_"+chk[i])); 
				pstmtDt.setString(3,request.getParameter("TO_TRANFER_QTY_"+chk[i])); 
				pstmtDt.setString(4,UserName);
				pstmtDt.setString(5,UserName); 
				pstmtDt.setString(6,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
							  
			}

			CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
			cs3.setString(1,"ALLOCATE"); 
			cs3.setString(2,allocate_id); 
			cs3.setString(3,UserName); 
			cs3.execute();
			cs3.close();
			con.commit();
			
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
					setSubmit("../jsp/TSCSGStockInterOrgTransfer.jsp");
				</script>
			<%
		}
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGStockInterOrgTransfer.jsp'>回內外銷庫存調撥功能</a></font>");
	}	
}
else if (TRANSTYPE.equals("SUBINVTRX"))  //add by Peggy 20231226
{
	try
	{
		String allocate_id="";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select SG_ALLOCATE_BATCH_ID_S.NEXTVAL from dual");
			if (!rs.next())
			{
				throw new Exception("ID not Found!!");
			}
			else
			{
				allocate_id= rs.getString(1);
			}
			rs.close();
			statement.close();	
					
			for(int i=0; i< chk.length ;i++)
			{
				sql = " insert into oraddman.tssg_stock_allocate_detail "+
				      " (sg_stock_id"+
					  ",inventory_item_id"+
					  ",item_name"+
					  ",item_desc"+
					  ",from_organization_id"+
					  ",from_subinventory_code"+
					  ",to_organization_id"+
					  ",to_subinventory_code"+
					  ",lot_number"+
					  ",date_code"+
					  ",allocated_qty"+
					  ",remarks"+
					  ",allocated_date"+
					  ",allocated_by"+
					  ",allocate_batch_id"+
					  ",dc_yyww"+ 
					  ",transaction_type_id"+ //add by Peggy 20231226
					  ")"+
					  " select sg_stock_id"+
					  ",inventory_item_id"+
					  ",item_name"+
					  ",item_desc"+
					  ",organization_id"+
					  ",subinventory_code"+
					  ",?"+
					  ",?"+
					  ",lot_number"+
					  ",date_code"+
					  ",?*1000"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+
					  ",sysdate"+
					  ",?"+
					  ",?"+
					  ",dc_yyww"+ 
					  ",?"+ //add by Peggy 20231226
					  " from oraddman.tssg_stock_overview "+
					  " where sg_stock_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TO_ORG_"+chk[i])); 
				pstmtDt.setString(2,request.getParameter("TO_SUBINV_"+chk[i])); 
				pstmtDt.setString(3,request.getParameter("TO_TRANFER_QTY_"+chk[i])); 
				pstmtDt.setString(4,request.getParameter("remark_"+chk[i])); 
				pstmtDt.setString(5,UserName);
				pstmtDt.setString(6,allocate_id); //RETURNED_DATE
				pstmtDt.setInt(7,2); //transaction type id
				pstmtDt.setString(8,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " update oraddman.tssg_stock_overview"+
				      " set ALLOCATE_OUT_QTY=NVL(ALLOCATE_OUT_QTY,0)+?*1000"+
					  " where sg_stock_id=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TO_TRANFER_QTY_"+chk[i])); 
				pstmtDt.setString(2,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " INSERT INTO  oraddman.tssg_stock_overview"+
                      " (sg_stock_id"+
                      ",inventory_item_id"+
                      ",item_name"+
                      ",item_desc"+
                      ",organization_id"+
                      ",subinventory_code"+
                      ",lot_number"+
                      ",date_code"+
                      ",received_date"+
                      ",received_qty"+
                      ",allocate_in_qty"+
                      ",allocate_out_qty"+
                      ",return_qty"+
                      ",shipped_qty"+
                      ",po_line_location_id"+
                      ",po_header_id"+
                      ",from_sg_stock_id"+
                      ",remarks"+
                      ",creation_date"+
                      ",created_by"+
                      ",last_update_date"+
                      ",last_updated_by"+
                      ",vendor_site_id"+
                      ",vendor_site_code"+
                      ",vendor_carton_no"+
                      ",nw"+
                      ",gw"+
                      ",cust_partno"+
                      ",receipt_num"+
					  ",DC_YYWW"+
                      " )"+
                      " select TSSG_STOCK_ID_S.NEXTVAL"+
                      ",inventory_item_id"+
                      ",item_name"+
                      ",item_desc"+
                      ",?"+
					  ",?"+
                      ",lot_number"+
                      ",date_code"+
                      ",SYSDATE"+
                      ",0"+
                      ",?*1000"+
                      ",0"+
                      ",0"+
                      ",0"+
                      ",po_line_location_id"+
                      ",po_header_id"+
                      ",sg_stock_id"+
                      ",NULL"+
                      ",SYSDATE"+
                      ",?"+
                      ",SYSDATE"+
                      ",?"+
                      ",tso.VENDOR_SITE_ID"+
                      ",tso.VENDOR_SITE_CODE"+
                      ",VENDOR_CARTON_NO"+
                      ",nw"+
                      ",gw"+
                      ",NULL"+
                      ",receipt_num"+
					  ",DC_YYWW"+ //add by Peggy 20220721
					  " from oraddman.tssg_stock_overview tso "+
                      " where sg_stock_id=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TO_ORG_"+chk[i])); 
				pstmtDt.setString(2,request.getParameter("TO_SUBINV_"+chk[i])); 
				pstmtDt.setString(3,request.getParameter("TO_TRANFER_QTY_"+chk[i])); 
				pstmtDt.setString(4,UserName);
				pstmtDt.setString(5,UserName); 
				pstmtDt.setString(6,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
							  
			}

			CallableStatement cs3 = con.prepareCall("{call TSSG_RCV_PKG.SG_RCV_JOB(?,?,?)}");
			cs3.setString(1,"ALLOCATE"); 
			cs3.setString(2,allocate_id); 
			cs3.setString(3,UserName); 
			cs3.execute();
			cs3.close();
			con.commit();
			
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("Success!!");
					setSubmit("../jsp/TSCSGStockSubinvTransfer.jsp");
				</script>
			<%
		}
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TSCSGStockSubinvTransfer.jsp'>回庫房移轉功能</a></font>");
	}	
}


if ((TRANSTYPE.equals("RECEIVE") || TRANSTYPE.equals("INSPECT") || TRANSTYPE.equals("BUYERCHECK") || TRANSTYPE.equals("RETURN")) && chk_cnt>0 )
{
	Properties props = System.getProperties();
	props.put("mail.transport.protocol","smtp");
	props.put("mail.smtp.host", "mail.ts.com.tw");
	props.put("mail.smtp.port", "25");
	String remarks="";
	
	Session s = Session.getInstance(props, null);
	javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
	message.setSentDate(new java.util.Date());
	message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
	if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
	{
		remarks="(This is a test letter, please ignore it)";
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
	}
	else
	{
		remarks="";
		if (TRANSTYPE.equals("RECEIVE"))
		{			
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("aiping@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("qc_owner@mail.tew.com.cn"));
		}
		else if (TRANSTYPE.equals("INSPECT"))
		{
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("coco@mail.tew.com.cn"));
		}
		else if (TRANSTYPE.equals("BUYERCHECK"))
		{
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));  
		}
		else if (TRANSTYPE.equals("RETURN"))
		{
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("coco@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("outsourcingpc1@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("outsource1@mail.tew.com.cn"));  
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("wws@mail.tew.com.cn"));  
		}			
	}
	
	message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		
 	message.setSubject("Reminder -SG "+(TRANSTYPE.equals("RETURN")? "return":"arrival")+" is waiting for your approval"+remarks);
	javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
	javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
	mbp.setContent("SG "+(TRANSTYPE.equals("RETURN")? "return":"arrival")+ " Notification,<p>Please login at:<a href="+'"'+"http://rfq134.ts.com.tw:8080/oradds/jsp/"+strProgram+'"'+">http://rfq134.ts.com.tw:8080/oradds/jsp/"+strProgram+"</a> to approve.", "text/html;charset=UTF-8");
	mp.addBodyPart(mbp);

	//add by Peggy 20220104
	if (TRANSTYPE.equals("RETURN"))
	{
		int reccnt=0,col=0,row=0,fontsize=8;
		WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		
		//英文內文水平垂直置左-正常-格線   
		WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
		ALeftL.setAlignment(jxl.format.Alignment.LEFT);
		ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftL.setWrap(true);
		
		//英文內文水平垂直置中-粗體-格線-底色綠
		WritableCellFormat ACenterBLGY = new WritableCellFormat(font_bold);   
		ACenterBLGY.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLGY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLGY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLGY.setBackground(jxl.write.Colour.LIGHT_GREEN ); 
		ACenterBLGY.setWrap(true);			
				
		sql = " SELECT a.return_reason"+
			  " ,case b.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else b.organization_code end as organization_name"+
			  ",a.receipt_num"+
			  ",a.po_no"+
			  ",nvl(d.vendor_site_code,a.vendor_name) vendor_name"+
			  ",tsc_inv_category(a.inventory_item_id,43,1100000003) tsc_prod_group"+
			  ",a.item_desc"+
			  ",a.lot_number"+
			  ",a.date_code"+
			  ",a.return_qty /1000 return_qty"+
			  ",to_char(a.receive_date,'yyyy/mm/dd') receive_date"+
			  ",a.item_name"+
			  " FROM (select x.*,(select count(1) from oraddman.tssg_po_receive_detail y where y.receipt_num=x.receipt_num) tot_cnt from oraddman.tssg_po_receive_detail x) a"+
			  ",mtl_parameters b"+
			  " ,ap.ap_supplier_sites_all d"+
			  " where a.organization_id=b.organization_id"+
			  " and a.vendor_site_id=d.vendor_site_id"+
			  " and a.receive_trx_id in ("+return_trx_id+")";
		//out.println(sql);
		FileName ="SG PO Return"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		WritableSheet ws = null;
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		wwb.createSheet("Sheet1", 0);
		
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		//String sheetname [] = wwb.getSheetNames();
		while (rs.next()) 
		{ 	
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet("Sheet1");
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				sst.setVerticalFreeze(1);  //凍結窗格
				
				//Return cause
				ws.addCell(new jxl.write.Label(col, row, "Return cause" , ACenterBLGY));
				ws.setColumnView(col,15);	
				col++;
									
				//內外銷
				ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;					

				//Receipt Num
				ws.addCell(new jxl.write.Label(col, row, "Receipt Num" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
				
				//PO NO
				ws.addCell(new jxl.write.Label(col, row, "PO NO" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
				
				//Vendor Name
				ws.addCell(new jxl.write.Label(col, row, "Vendor Name" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
				
				//TSC Prod Group
				ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;		
				
				//Item Desc
				ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLGY));
				ws.setColumnView(col,20);	
				col++;	
				
				//Lot Number
				ws.addCell(new jxl.write.Label(col, row, "Lot Number" , ACenterBLGY));
				ws.setColumnView(col,20);	
				col++;		

				//Date Code
				ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;		

				//Qty(K)
				ws.addCell(new jxl.write.Label(col, row, "Qty(K)" , ACenterBLGY));
				ws.setColumnView(col,10);	
				col++;	
				
				//Receive Date
				ws.addCell(new jxl.write.Label(col, row, "Receive Date" , ACenterBLGY));
				ws.setColumnView(col,12);	
				col++;	
				row++;						
			}
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("RETURN_REASON"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_NAME"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_NAME"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("RETURN_QTY"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIVE_DATE"),ALeftL));
			col++;	
			row++;
			reccnt++;
		}	
		rs.close();
		statement.close();
		wwb.write(); 
		wwb.close();
	
		javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		mbp = new javax.mail.internet.MimeBodyPart();
		mbp.setDataHandler(new javax.activation.DataHandler(fds));
		mbp.setFileName(fds.getName());
		mp.addBodyPart(mbp);
	}
	
	// create the Multipart and add its parts to it
	message.setContent(mp);
	Transport.send(message);	
	if (TRANSTYPE.equals("RETURN"))
	{
		os.close();  
		out.close(); 	
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

