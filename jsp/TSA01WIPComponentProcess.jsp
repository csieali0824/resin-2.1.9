<!--20161028 Peggy,新增倉別讓user指定退料倉-->
<!--20170814 Peggy,新增21 : 原物料-重驗合格倉 22 : 半成品-重驗合格倉-->
<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="FrontWIPBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="WaferBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="WIPMISCBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>TS A01 WIP Process</title>
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
<FORM ACTION="TSA01WIPComponentProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

String sql ="";
String PROGRAM = request.getParameter("PROGRAM");
if (PROGRAM==null) PROGRAM="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
int lineno=0;

if (PROGRAM.equals("K2-001"))
{
	try
	{
		String TRANS_TYPE = request.getParameter("TRANS_TYPE");
		if (TRANS_TYPE==null) TRANS_TYPE="";	
		String REQUEST_NO = request.getParameter("REQUEST_NO");
		if (REQUEST_NO==null) REQUEST_NO="";
		String REQUEST_DATE=request.getParameter("REQUEST_DATE");
		if (REQUEST_DATE==null) REQUEST_DATE="";
		String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
		if (ORGANIZATION_ID==null) ORGANIZATION_ID="606";		
		if (!TRANS_TYPE.equals("MISC") & !TRANS_TYPE.equals("RDMISC") && !TRANS_TYPE.equals("QCMISC"))
		{
			String WIP_NO = request.getParameter("WIP_NO");
			if (WIP_NO==null) WIP_NO="";
			String WIP_ID = request.getParameter("WIP_ID");
			if (WIP_ID==null) WIP_ID="";
			String ITEM_ID=request.getParameter("ITEM_ID");
			if (ITEM_ID==null) ITEM_ID="";
			String ITEM_NAME=request.getParameter("ITEM_NAME");
			if (ITEM_NAME==null) ITEM_NAME="";
			String TSC_PACKAGE=request.getParameter("TSC_PACKAGE");
			if (TSC_PACKAGE==null) TSC_PACKAGE="";

			String chk[]= request.getParameterValues("chk");	
			if (chk.length <=0)
			{
				throw new Exception("無申請資料!!");
			}
			for(int i=0; i< chk.length ;i++)
			{
				if (Double.parseDouble(request.getParameter("REQUEST_QTY_"+chk[i]))<=0)
				{
					continue;
				}
				lineno++;
				String ShipArray[][]=FrontWIPBean.getArray2DContent();
				if (ShipArray!=null && TRANS_TYPE.equals("ISSUE"))
				{
					for( int j=0 ; j< ShipArray.length ; j++ ) 
					{
						if (ShipArray[j][0].equals(WIP_NO) && ShipArray[j][2].equals(chk[i]))
						{
							sql = " INSERT INTO ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL"+
								  " (REQUEST_NO"+              //1
								  " ,LINE_NO"+                 //2
								  " ,ORGANIZATION_ID"+         //3
								  " ,INVENTORY_ITEM_ID"+       //4
								  " ,ITEM_NAME"+               //5
								  " ,LOT"+                     //6
								  " ,LOT_QTY"+                 //7
								  " ,UOM"+                     //8
								  " ,REMARKS"+                 //9
								  " ,CREATED_BY"+              //10
								  " ,CREATION_DATE"+           //11
								  " ,LAST_UPDATED_BY"+         //12
								  " ,LAST_UPDATE_DATE"+        //13
								  ", WIP_NO"+                  //14
								  ", WAFER_LINE_ID"+           //15
								  ", MISCELLANEOUS_FLAG"+      //16
								  ")"+
								  " VALUES"+
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
								  " ,SYSDATE"+                 //11
								  " ,?"+                       //12
								  " ,SYSDATE"+                 //13
								  " ,?"+                       //14
								  " ,TSA01_WAFER_ID_S.NEXTVAL"+ //15
								  " ,?"+                        //16
								  ")";
							PreparedStatement pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,REQUEST_NO);
							pstmtDt.setString(2,""+lineno);
							pstmtDt.setString(3,ORGANIZATION_ID);
							pstmtDt.setString(4,request.getParameter("COM_ITEM_ID_"+chk[i]));
							pstmtDt.setString(5,ShipArray[j][1]);
							pstmtDt.setString(6,ShipArray[j][4].trim());
							pstmtDt.setString(7,ShipArray[j][5]);
							pstmtDt.setString(8,request.getParameter("UOM_"+chk[i]));
							pstmtDt.setString(9,(ShipArray[j][6]==null||ShipArray[j][6].equals("&nbsp;")?"":ShipArray[j][6]));
							pstmtDt.setString(10,UserName);
							pstmtDt.setString(11,UserName);
							pstmtDt.setString(12,ShipArray[j][3]);
							pstmtDt.setString(13,"N");
							pstmtDt.executeQuery();
							pstmtDt.close();
						}
					}
				}
	
				String LotArray[][]=WaferBean.getArray2DContent();
				if (LotArray!=null && TRANS_TYPE.equals("ISSUE"))
				{
					for( int j=0 ; j< LotArray.length ; j++ ) 
					{
						if (LotArray[j][0].equals(WIP_NO) && LotArray[j][1].equals(chk[i]))
						{
							sql = " INSERT INTO ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL"+
								  " (REQUEST_NO"+              //1
								  " ,LINE_NO"+                 //2
								  " ,ORGANIZATION_ID"+         //3
								  " ,INVENTORY_ITEM_ID"+       //4
								  " ,ITEM_NAME"+               //5
								  " ,LOT"+                     //6
								  " ,LOT_QTY"+                 //7
								  " ,UOM"+                     //8
								  " ,REMARKS"+                 //9
								  " ,CREATED_BY"+              //10
								  " ,CREATION_DATE"+           //11
								  " ,LAST_UPDATED_BY"+         //12
								  " ,LAST_UPDATE_DATE"+        //13
								  ", MISCELLANEOUS_FLAG"+      //15,add by Peggy 20161207
								  ", TRANSACTIONS_TYPE_ID"+    //16,add by Peggy 20161207
								  ", WAFER_LINE_ID"+           //17,add by Peggy 20170630
								  ", TRANSACTION_SOURCE_ID"+   //18,add by Peggy 20170630
								  ", SUBINVENTORY_CODE"+       //19,add by Peggy 20170630
								  ", EXPIRES_ON"+              //20,add by Peggy 20170630
								  ")"+ 
								  " VALUES"+
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
								  " ,SYSDATE"+                 //11
								  " ,?"+                       //12
								  " ,SYSDATE"+                 //13
								  " ,?"+                       //15
								  " ,?"+                       //16
								  " ,TSA01_WAFER_ID_S.NEXTVAL"+ //17
								  " ,?"+                        //18
								  " ,?"+                        //19
								  " ,CASE WHEN ?='Y' THEN trunc(sysdate)+30 ELSE NULL END"+        //20
								  ")";
							PreparedStatement pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,REQUEST_NO);
							pstmtDt.setString(2,""+lineno);
							pstmtDt.setString(3,ORGANIZATION_ID);
							pstmtDt.setString(4,LotArray[j][2]);
							pstmtDt.setString(5,request.getParameter("COM_ITEM_"+chk[i]));
							pstmtDt.setString(6,LotArray[j][3].trim());
							pstmtDt.setString(7,LotArray[j][4]);
							pstmtDt.setString(8,request.getParameter("UOM_"+chk[i]));
							pstmtDt.setString(9,LotArray[j][5]);
							pstmtDt.setString(10,UserName);
							pstmtDt.setString(11,UserName);
							pstmtDt.setString(12,LotArray[j][6]);
							pstmtDt.setString(13,(LotArray[j][7]==null?"":LotArray[j][7]));
							pstmtDt.setString(14,(LotArray[j][8]==null?"":LotArray[j][8]));  //transaction_source_id,add by Peggy 20170630
							pstmtDt.setString(15,(LotArray[j][9]==null?"":LotArray[j][9]));  //SUBINVENTORY_CODE,add by Peggy 20170630
							pstmtDt.setString(16,LotArray[j][6]);
							pstmtDt.executeQuery();
							pstmtDt.close();
						}
					}
				}
				
				sql = " insert into oraddman.tsa01_request_lines_all "+
					  " (request_no"+          //1
					  ", line_no"+             //2
					  ", comp_type_no"+        //3
					  ", organization_id"+     //4
					  ", component_item_id"+   //5
					  ", component_name"+      //6
					  ", uom"+                 //7
					  ", required_qty"+        //8
					  ", request_qty"+         //9
					  ", spq"+                 //10
					  ", moq"+                 //11
					  ", change_rate"+         //12
					  ", remarks "+            //13
					  ", op_seq_num"+          //14
					  ", status"+              //15
					  ", created_by"+          //16
					  ", creation_date"+       //17
					  " )"+
					  "  values"+
					  " ("+
					  "  ?"+                   //1
					  ", ?"+                   //2
					  ", ?"+                   //3
					  ", ?"+                   //4
					  ", ?"+                   //5
					  ", ?"+                   //6
					  ", ?"+                   //7
					  ", ?"+                   //8
					  ", ?"+                   //9
					  ", ?"+                   //10
					  ", ?"+                   //11
					  ", ?"+                   //12
					  ", ?"+                   //13
					  ", ?"+                   //14
					  ",(SELECT TYPE_NAME FROM oraddman.tsa01_base_setup a WHERE TYPE_CODE='REQ_STATUS' AND TYPE_GROUP=?)"+    //15
					  ", ?"+                   //16
					  ", sysdate"+             //17
					  "  )";            
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,REQUEST_NO);
				pstmtDt.setString(2,""+lineno);
				pstmtDt.setString(3,request.getParameter("COMP_TYPE_"+chk[i]));
				pstmtDt.setString(4,ORGANIZATION_ID);
				pstmtDt.setString(5,request.getParameter("COM_ITEM_ID_"+chk[i]));
				pstmtDt.setString(6,request.getParameter("COM_ITEM_"+chk[i]));
				pstmtDt.setString(7,request.getParameter("UOM_"+chk[i]));
				pstmtDt.setString(8,request.getParameter("REQUIRED_QTY_"+chk[i]));
				pstmtDt.setString(9,request.getParameter("REQUEST_QTY_"+chk[i]));
				pstmtDt.setString(10,request.getParameter("SPQ_"+chk[i]));
				pstmtDt.setString(11,request.getParameter("MOQ_"+chk[i]));
				pstmtDt.setString(12,(request.getParameter("CHANGE_RATE_"+chk[i])==null||request.getParameter("CHANGE_RATE_"+chk[i]).equals("null")?null:request.getParameter("CHANGE_RATE_"+chk[i])));
				pstmtDt.setString(13,request.getParameter("REMARKS_"+chk[i]));
				pstmtDt.setString(14,request.getParameter("OPERATION_SEQ_NUM_"+chk[i]));
				pstmtDt.setString(15,PROGRAM);
				pstmtDt.setString(16,UserName);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}	
		
				sql = " insert into oraddman.tsa01_request_headers_all "+
					  " (request_no"+         //1
					  ", request_type"+       //2
					  ", organization_id"+    //3
					  ", wip_entity_name"+    //4
					  ", wip_entity_id"+      //5
					  ", inventory_item_id"+  //6
					  ", item_name"+          //7
					  ", tsc_package"+        //8
					  ", created_by"+         //9
					  ", creation_date"+      //10
					  ", last_updated_by"+    //11
					  ", last_update_date"+   //12
					  ", status"+             //13
					  ", version_id"+         //14
					  " )"+
					  "  values"+
					  " ("+
					  "  ?"+                   //1
					  ", ?"+                   //2
					  ", ?"+                   //3
					  ", ?"+                   //4
					  ", ?"+                   //5
					  ", ?"+                   //6
					  ", ?"+                   //7
					  ", ?"+                   //8
					  ", ?"+                   //9
					  ", sysdate"+             //10
					  ", ?"+                   //11
					  ", sysdate"+             //12
					  ",(SELECT TYPE_NAME FROM oraddman.tsa01_base_setup a WHERE TYPE_CODE='REQ_STATUS' AND TYPE_GROUP=?)"+      //13
					  ", ?"+                   //14
					  "  )";            
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,REQUEST_NO);
				pstmtDt.setString(2,TRANS_TYPE);
				pstmtDt.setString(3,ORGANIZATION_ID);
				pstmtDt.setString(4,WIP_NO);
				pstmtDt.setString(5,WIP_ID);
				pstmtDt.setString(6,ITEM_ID);
				pstmtDt.setString(7,ITEM_NAME);
				pstmtDt.setString(8,TSC_PACKAGE);
				pstmtDt.setString(9,UserName);
				pstmtDt.setString(10,UserName);
				pstmtDt.setString(11,PROGRAM);
				pstmtDt.setString(12,"0");
				pstmtDt.executeQuery();
				pstmtDt.close();
			
			sql = " insert into oraddman.tsa01_request_history"+
				  "(request_no"+
				  ",version_id"+
				  ",seq"+
				  ",trans_name"+
				  ",created_by"+
				  ",creation_date"+
				  ",remarks)"+
				  " values"+
				  "("+
				  " ?"+
				  ",?"+
				  ",(select nvl(max(seq),0)+1 from oraddman.tsa01_request_history where request_no=?)"+
				  ",(SELECT TYPE_NAME FROM oraddman.tsa01_base_setup a WHERE TYPE_CODE='REQ_STATUS' AND TYPE_GROUP=?)"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ")";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,REQUEST_NO);
			pstmtDt.setString(2,"0");
			pstmtDt.setString(3,REQUEST_NO);
			pstmtDt.setString(4,PROGRAM);
			pstmtDt.setString(5,UserName);
			pstmtDt.setString(6,null);
			pstmtDt.executeQuery();
			pstmtDt.close();
		} 
		else
		{
			int reqno=0;
			String MISCArray[][]=WIPMISCBean.getArray2DContent();
			if (MISCArray!=null && (TRANS_TYPE.equals("MISC")||TRANS_TYPE.equals("RDMISC")||TRANS_TYPE.equals("QCMISC")))
			{
				for( int j=0 ; j< MISCArray.length ; j++ ) 
				{
					lineno=0;
					if (MISCArray[j][6].equals("Y")) continue;
					for (int k=j; k<MISCArray.length ; k++ )
					{
						if (MISCArray[k][6].equals("Y") || !MISCArray[j][0].equals(MISCArray[k][0])) continue;
						
						lineno++;
						if (lineno==1) reqno++;
						sql = " insert into oraddman.tsa01_request_lines_all "+
							  " (request_no"+          //1
							  ", line_no"+             //2
							  ", comp_type_no"+        //3
							  ", organization_id"+     //4
							  ", component_item_id"+   //5
							  ", component_name"+      //6
							  ", uom"+                 //7
							  ", required_qty"+        //8
							  ", request_qty"+         //9
							  ", spq"+                 //10
							  ", moq"+                 //11
							  ", change_rate"+         //12
							  ", remarks "+            //13
							  ", op_seq_num"+          //14
							  ", status"+              //15
							  ", created_by"+          //16
							  ", creation_date"+       //17
							  " )"+
							  "  values"+
							  " ("+
							  "  ?"+                   //1
							  ", ?"+                   //2
							  ", nvl((select comp_type_no from oraddman.tsa01_component_detail x where x.item_name=?),'C005')"+      //3
							  ", ?"+                   //4
							  ", (select inventory_item_id from inv.mtl_system_items_b x where x.segment1=? and x.organization_id=?)"+  //5
							  ", ?"+                   //6
							  ", ?"+                   //7
							  ", ?"+                   //8
							  ", ?"+                   //9
							  ", ?"+                   //10
							  ", ?"+                   //11
							  ", ?"+                   //12
							  ", ?"+                   //13
							  ", ?"+                   //14
							  ",(SELECT TYPE_NAME FROM oraddman.tsa01_base_setup a WHERE TYPE_CODE='REQ_STATUS' AND TYPE_GROUP=?)"+    //15
							  ", ?"+                   //16
							  ", sysdate"+             //17
							  "  )";            
						PreparedStatement pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,REQUEST_NO+"-"+reqno);
						pstmtDt.setString(2,""+lineno);
						pstmtDt.setString(3,MISCArray[k][1]);
						pstmtDt.setString(4,ORGANIZATION_ID);
						pstmtDt.setString(5,MISCArray[k][1]);
						pstmtDt.setString(6,ORGANIZATION_ID);
						pstmtDt.setString(7,MISCArray[k][1]);
						pstmtDt.setString(8,"KPC");
						pstmtDt.setString(9,MISCArray[k][5]);
						pstmtDt.setString(10,MISCArray[k][5]);
						pstmtDt.setString(11,"0");
						pstmtDt.setString(12,"0");
						pstmtDt.setString(13,"");
						pstmtDt.setString(14,"");
						pstmtDt.setString(15,"");
						pstmtDt.setString(16,PROGRAM);
						pstmtDt.setString(17,UserName);
						pstmtDt.executeQuery();
						pstmtDt.close();	
						MISCArray[k][6]="Y";	
						
						
						sql = " INSERT INTO ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL"+
							  " (REQUEST_NO"+              //1
							  " ,LINE_NO"+                 //2
							  " ,ORGANIZATION_ID"+         //3
							  " ,INVENTORY_ITEM_ID"+       //4
							  " ,ITEM_NAME"+               //5
							  " ,LOT"+                     //6
							  " ,LOT_QTY"+                 //7
							  " ,UOM"+                     //8
							  " ,REMARKS"+                 //9
							  " ,CREATED_BY"+              //10
							  " ,CREATION_DATE"+           //11
							  " ,LAST_UPDATED_BY"+         //12
							  " ,LAST_UPDATE_DATE"+        //13
							  ", MISCELLANEOUS_FLAG"+      //15
							  ", TRANSACTIONS_TYPE_ID"+    //16
							  ", WAFER_LINE_ID"+           //17
							  ", TRANSACTION_SOURCE_ID"+   //18
							  ", SUBINVENTORY_CODE"+       //19
							  ", EXPIRES_ON"+              //20
							  ")"+ 
							  " SELECT "+
							  "  ?"+                       //1
							  " ,?"+                       //2
							  " ,?"+                       //3
							  " ,x.inventory_item_id "+    //4
							  " ,?"+                       //5
							  " ,?"+                       //6
							  " ,?"+                       //7
							  " ,?"+                       //8
							  " ,?"+                       //9
							  " ,?"+                       //10
							  " ,SYSDATE"+                 //11
							  " ,?"+                       //12
							  " ,SYSDATE"+                 //13
							  " ,?"+                       //15
							  " ,(SELECT type_value FROM oraddman.tsa01_base_setup  WHERE TYPE_CODE='TRANS_TYPE' AND TYPE_NAME ='"+TRANS_TYPE+"' AND TYPE_ATTRIBUTE1 =CASE WHEN ? <0 THEN -1 ELSE 1 END) "+   //16
							  " ,TSA01_WAFER_ID_S.NEXTVAL"+ //17
							  " ,(SELECT y.type_value FROM oraddman.tsa01_base_setup x,oraddman.tsa01_base_setup y WHERE x.TYPE_CODE='TRANS_TYPE' AND x.TYPE_NAME='"+TRANS_TYPE+"'  AND x.TYPE_ATTRIBUTE1 =CASE WHEN ? <0 THEN -1 ELSE 1 END AND y.TYPE_CODE='TRANS_SOURCE_ID' AND x.TYPE_NAME=y.TYPE_GROUP AND y.TYPE_NAME=x.type_value)"+  //18
							  " ,case x.item_type when 'SA' THEN '02' WHEN 'FG' THEN '03' ELSE '01' END SUBINV"+ //19
							  " ,y.EXPIRATION_DATE" +        //20
							  " FROM inv.mtl_system_items_b x,(select * from inv.mtl_lot_numbers where organization_id=? and lot_number=?) y"+
							  " where x.inventory_item_id=y.inventory_item_id(+)"+
                              " and x.organization_id=y.organization_Id(+)"+
							  " and x.segment1=? "+
							  " and x.organization_id=?";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,REQUEST_NO+"-"+reqno);
						pstmtDt.setString(2,""+lineno);
						pstmtDt.setString(3,ORGANIZATION_ID);
						pstmtDt.setString(4,MISCArray[k][1]);
						pstmtDt.setString(5,MISCArray[k][2]);
						pstmtDt.setString(6,MISCArray[k][5]);
						pstmtDt.setString(7,"KPC");
						pstmtDt.setString(8,"");
						pstmtDt.setString(9,UserName);
						pstmtDt.setString(10,UserName);
						pstmtDt.setString(11,"Y");						
						pstmtDt.setString(12,MISCArray[k][5]);
						pstmtDt.setString(13,MISCArray[k][5]);
						pstmtDt.setString(14,ORGANIZATION_ID);
						pstmtDt.setString(15,MISCArray[k][2]);
						pstmtDt.setString(16,MISCArray[k][1]);
						pstmtDt.setString(17,ORGANIZATION_ID);
						pstmtDt.executeQuery();
						pstmtDt.close();
										
					}
					if (lineno >0)
					{
						sql = " insert into oraddman.tsa01_request_headers_all "+
							  " (request_no"+         //1
							  ", request_type"+       //2
							  ", organization_id"+    //3
							  ", wip_entity_name"+    //4
							  ", wip_entity_id"+      //5
							  ", inventory_item_id"+  //6
							  ", item_name"+          //7
							  ", tsc_package"+        //8
							  ", created_by"+         //9
							  ", creation_date"+      //10
							  ", last_updated_by"+    //11
							  ", last_update_date"+   //12
							  ", status"+             //13
							  ", version_id"+         //14
							  " )"+
							  "  select "+
							  "  ?"+                   //1
							  ", ?"+                   //2
							  ", wp.organization_id"+  //3
							  ", WIP_ENTITY_NAME"+     //4
							  ", WIP_ENTITY_ID"+       //5
							  ", msi.inventory_item_id"+ //6
							  ", msi.segment1"+        //7
							  ", tsc_inv_category(msi.inventory_item_id,msi.organization_id,23) "+ //8
							  ", ?"+                   //9
							  ", sysdate"+             //10
							  ", ?"+                   //11
							  ", sysdate"+             //12
							  ",(SELECT TYPE_NAME FROM oraddman.tsa01_base_setup a WHERE TYPE_CODE='REQ_STATUS' AND TYPE_GROUP=?)"+      //13
							  ", ?"+                   //14
							  " from wip.wip_entities wp,inv.mtl_system_items_b msi"+
                              " where wp.organization_id=msi.organization_id"+
                              " and wp.primary_item_id=msi.inventory_item_id"+
							  " and wp.WIP_ENTITY_NAME=?"+
							  " and wp.ORGANIZATION_ID=?";
						PreparedStatement pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,REQUEST_NO+"-"+reqno);
						pstmtDt.setString(2,TRANS_TYPE);
						pstmtDt.setString(3,UserName);
						pstmtDt.setString(4,UserName);
						pstmtDt.setString(5,PROGRAM);
						pstmtDt.setString(6,"0");
						pstmtDt.setString(7,MISCArray[j][0]);
						pstmtDt.setString(8,ORGANIZATION_ID);
						pstmtDt.executeQuery();
						pstmtDt.close();
						
						sql = " insert into oraddman.tsa01_request_history"+
							  "(request_no"+
							  ",version_id"+
							  ",seq"+
							  ",trans_name"+
							  ",created_by"+
							  ",creation_date"+
							  ",remarks)"+
							  " values"+
							  "("+
							  " ?"+
							  ",?"+
							  ",(select nvl(max(seq),0)+1 from oraddman.tsa01_request_history where request_no=?)"+
							  ",(SELECT TYPE_NAME FROM oraddman.tsa01_base_setup a WHERE TYPE_CODE='REQ_STATUS' AND TYPE_GROUP=?)"+
							  ",?"+
							  ",sysdate"+
							  ",?"+
							  ")";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,REQUEST_NO+"-"+reqno);
						pstmtDt.setString(2,"0");
						pstmtDt.setString(3,REQUEST_NO+"-"+reqno);
						pstmtDt.setString(4,PROGRAM);
						pstmtDt.setString(5,UserName);
						pstmtDt.setString(6,null);
						pstmtDt.executeQuery();
						pstmtDt.close();						
					}
				}
			}
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("申請成功!!若要繼續下一筆工單,請按確定鍵,否則按下取消鍵,回到首頁!!"))
			{
				setSubmit("../jsp/TSA01WIPComponentRequest.jsp");
			}
			else
			{
				setSubmit("/oradds/ORADDSMainMenu.jsp");
			}
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSA01WIPComponentRequest.jsp'>回 A01領退料申請作業</a></font>");
	}
}
else if (PROGRAM.equals("K2-002"))
{
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無工單交易!!");
		}
		for (int i=0; i< chk.length ;i++)
		{
			sql = " update oraddman.tsa01_request_headers_all a"+
				  " set LAST_UPDATED_BY=?"+
				  ",LAST_UPDATE_DATE=sysdate"+
				  ",STATUS=?"+
				  " where REQUEST_NO=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,UserName);
			pstmtDt.setString(2,STATUS);
			pstmtDt.setString(3,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			sql = " update oraddman.tsa01_request_lines_all a"+
				  " set APPROVED_BY=?"+
				  ",APPROVE_DATE=sysdate"+
				  ",LAST_UPDATED_BY=?"+
				  ",LAST_UPDATE_DATE=sysdate"+
				  ",STATUS=?"+
				  " where REQUEST_NO=?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,UserName);
			pstmtDt.setString(2,UserName);
			pstmtDt.setString(3,STATUS);
			pstmtDt.setString(4,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
						
			sql = " insert into oraddman.tsa01_request_history"+
				  "(request_no"+
				  ",version_id"+
				  ",seq"+
				  ",trans_name"+
				  ",created_by"+
				  ",creation_date"+
				  ",remarks)"+
				  " values"+
				  "("+
				  " ?"+
				  ",(select version_id from oraddman.tsa01_request_headers_all where request_no=?)"+
				  ",(select nvl(max(seq),0)+1 from oraddman.tsa01_request_history where request_no=?)"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ")";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,chk[i]);
			pstmtDt.setString(2,chk[i]);
			pstmtDt.setString(3,chk[i]);
			pstmtDt.setString(4,STATUS);
			pstmtDt.setString(5,UserName);
			pstmtDt.setString(6,request.getParameter("REJ_REASON"));
			pstmtDt.executeQuery();
			pstmtDt.close();
		}
				
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("簽核成功!!若要繼續下一筆工單,請按確定鍵,否則按下取消鍵,回到首頁!!"))
			{
				setSubmit("../jsp/TSA01WIPComponentApprove.jsp");
			}
			else
			{
				setSubmit("/oradds/ORADDSMainMenu.jsp");
			}
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSA01WIPComponentApprove.jsp'>回 A01領退料主管審核作業</a></font>");
	}	
}
else if  (PROGRAM.equals("K2-003"))
{
	try
	{
		if (STATUS.equals("CONFIRMED"))
		{
			if (PICK_NO.equals(""))
			{		
				CallableStatement cs1 = con.prepareCall("{call TSA01_WIP_PKG.GET_PROCESS_NO(?,?,?,?)}");
				cs1.setString(1,"PICK_NO");    
				cs1.setString(2, "P"+dateBean.getYearMonthDay());    
				cs1.setInt(3, 2);    
				cs1.registerOutParameter(4, Types.VARCHAR);   
				cs1.execute();
				PICK_NO= cs1.getString(4);                    
				cs1.close();
			}
		}
		else
		{
			PICK_NO="";
		}
		
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無領退料工單資料!!");
		}	
		else
		{
			String warehouse_id = "";
			sql = " select TSA01_WAREHOUSE_CONFIRM_ID_S.NEXTVAL FROM DUAL";
			//out.println(sql);
			PreparedStatement statementx = con.prepareStatement(sql);
			ResultSet rsx=statementx.executeQuery();
			if (rsx.next())
			{	
				warehouse_id = rsx.getString(1);
			}
			rsx.close();
			statementx.close();
			
			for (int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tsa01_request_lines_all"+
				      " set pick_no=?"+
					  ",STATUS=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",WAREHOUSE_GROUP_ID=?"+
					  ",PICK_GROUP_ID=null"+
					  " where request_no||'_'||line_no=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,PICK_NO);
				pstmtDt.setString(2,STATUS);
				pstmtDt.setString(3,UserName);
				pstmtDt.setString(4,warehouse_id);
				pstmtDt.setString(5,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
			}
			
			sql = " insert into oraddman.tsa01_request_history"+
				  "(request_no"+
				  ",version_id"+
				  ",seq"+
				  ",trans_name"+
				  ",created_by"+
				  ",creation_date"+
				  ",remarks)"+
				  "select xx.request_no"+
				  ",xx.version_id"+
				  ",(select nvl(max(seq),0)+1 from oraddman.tsa01_request_history k where k.request_no=xx.request_no) seqno"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",'"+(request.getParameter("REJ_REASON")==null?"":request.getParameter("REJ_REASON"))+"'|| case when NOPICK_CNT >0 then item_list else '' end as remarks"+
				  " from ( SELECT x.request_no,x.version_id,(select count(1) from oraddman.tsa01_request_lines_all b where  nvl(b.WAREHOUSE_GROUP_ID,0)<>? and b.request_no=x.request_no) nopick_cnt"+
				  "       ,(select listagg(rpad(a.COMPONENT_NAME,16,' ')||'  '||to_char(a.REQUEST_QTY,'99990D999')||a.uom,chr(10)) within group(order by a.line_no)  from oraddman.tsa01_request_lines_all a where a.WAREHOUSE_GROUP_ID=? and a.request_no=x.request_no)  item_list"+
				  "        FROM oraddman.tsa01_request_headers_all x"+
				  " where exists (select 1 from oraddman.tsa01_request_lines_all  y where nvl(y.WAREHOUSE_GROUP_ID,0)=? AND y.request_no=x.request_no)) xx";
			PreparedStatement pstmtDt=con.prepareStatement(sql); 				  
			pstmtDt.setString(1,STATUS);
			pstmtDt.setString(2,UserName);
			pstmtDt.setString(3,warehouse_id);
			pstmtDt.setString(4,warehouse_id);
			pstmtDt.setString(5,warehouse_id);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			if (STATUS.equals("CONFIRMED"))
			{
				CallableStatement cs1 = con.prepareCall("{call TSA01_WIP_PKG.WIP_PICK_LOT_TRX(?,?,?,?)}");
				cs1.setString(1,PICK_NO);    
				cs1.setInt(2,606);    
				cs1.setString(3,UserName);    
				cs1.setString(4,warehouse_id);
				cs1.execute();
				cs1.close();
			}
			else if (STATUS.equals("DISAGREE"))  //add by Peggy 20180222
			{
				CallableStatement cs1 = con.prepareCall("{call TSA01_WIP_PKG.WIP_TRANSACTION_NOTICE(?,?,?)}");
				cs1.setString(1,warehouse_id);    
				cs1.setString(2,(request.getParameter("REJ_REASON")==null?"":request.getParameter("REJ_REASON")));    
				cs1.setString(3,null);    
				cs1.execute();
				cs1.close();
			}

			con.commit();
			
			if (STATUS.equals("CONFIRMED"))
			{
				//out.println("<table width='80%' align='center'><tr><td align='center'><div align='cneter' style='color:#0000ff;font-size:16px'>動作成功!!已產生撿貨單號："+PICK_NO+"</DIV></td></tr>");
				//out.println("<tr><td align='center'><div align='center' style='color:#0000ff;font-size:14x;'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
				%>
				<!--<jsp:getProperty name="rPH" property="pgHOME"/>-->
				<%
				//out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TSA01WIPWareHouseApprove.jsp'>回 A01倉庫審核確認功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TSA01WIPWareHousePickExcel.jsp?PICK_NO="+PICK_NO+'"'+">下載撿貨單</a></td></tr>");
				//out.println("</table>");
			%>
			<script language="JavaScript" type="text/JavaScript">
				if (confirm("動作成功!!若要到下一關撿貨確認,請按確定鍵,否則按下取消鍵,回到首頁!!"))
				{
					setSubmit("../jsp/TSA01WIPWareHousePick.jsp?PICK_NO=<%=PICK_NO%>");
				}
				else
				{
					setSubmit("/oradds/ORADDSMainMenu.jsp");
				}
			</script>
			<%					
			}
			else 
			{
		%>
			<script language="JavaScript" type="text/JavaScript">
				if (confirm("退件成功!!若要繼續處理下一筆,請按確定鍵,否則按下取消鍵,回到首頁!!"))
				{
					setSubmit("../jsp/TSA01WIPWareHouseApprove.jsp");
				}
				else
				{
					setSubmit("/oradds/ORADDSMainMenu.jsp");
				}
			</script>
		<%				
			}
		}		
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSA01WIPWareHouseApprove.jsp'>回 A01倉庫審核確認功能</a></font>");
	}
}
else if  (PROGRAM.equals("K2-004"))
{
	try
	{
		int icnt=0;
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無撿貨確認資料!!");
		}
		String pick_id = "";
		sql = " select TSA01_PICK_GROUP_ID_S.NEXTVAL FROM DUAL";
		//out.println(sql);
		PreparedStatement statementx = con.prepareStatement(sql);
		ResultSet rsx=statementx.executeQuery();
		if (rsx.next())
		{	
			pick_id = rsx.getString(1);
		}
		rsx.close();
		statementx.close();	
				
		for (int i=0; i< chk.length ;i++)
		{
			if (STATUS.toUpperCase().equals("CANCELLED"))
			{
				sql = " update oraddman.tsa01_request_lines_all a"+
					  " set STATUS=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",PICK_NO=null"+
					  ",WAREHOUSE_GROUP_ID=null"+
					  ",ISSUE_QTY=null"+
					  ",PICK_GROUP_ID=?"+
					  " where request_no||'_'||line_no=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"APPROVED");
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,pick_id);
				pstmtDt.setString(4,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
				
				sql = " delete oraddman.tsa01_request_line_lots_all a"+
					  " where request_no||'_'||line_no=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();				
				
			}
			else
			{
				sql = " update oraddman.tsa01_request_lines_all a"+
					  " set STATUS=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",PICK_GROUP_ID=?"+
					  " where request_no||'_'||line_no=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,STATUS);
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,pick_id);
				pstmtDt.setString(4,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();						
			
			}
		}	
		sql = " insert into oraddman.tsa01_request_history"+
			  "(request_no"+
			  ",version_id"+
			  ",seq"+
			  ",trans_name"+
			  ",created_by"+
			  ",creation_date"+
			  ",remarks)"+
			  "select xx.request_no"+
			  ",xx.version_id"+
			  ",(select nvl(max(seq),0)+1 from oraddman.tsa01_request_history k where k.request_no=xx.request_no) seqno"+
			  ",?"+
			  ",?"+
			  ",sysdate"+
			  ",'"+(request.getParameter("REJ_REASON")==null?"":request.getParameter("REJ_REASON"))+"'|| case when NOPICK_CNT >0 then item_list else '' end as remarks"+
			  " from ( SELECT x.request_no,x.version_id,(select count(1) from oraddman.tsa01_request_lines_all b where  nvl(b.PICK_GROUP_ID,0)<>? and b.request_no=x.request_no) nopick_cnt"+
			  "       ,(select listagg(rpad(a.COMPONENT_NAME,16,' ')||'  '||to_char(a.REQUEST_QTY,'99990D999')||a.uom,chr(10)) within group(order by a.line_no)  from oraddman.tsa01_request_lines_all a where a.PICK_GROUP_ID=? and a.request_no=x.request_no)  item_list"+
			  "        FROM oraddman.tsa01_request_headers_all x"+
			  " where exists (select 1 from oraddman.tsa01_request_lines_all  y where nvl(y.PICK_GROUP_ID,0)=? AND y.request_no=x.request_no)) xx";
		PreparedStatement pstmtDt=con.prepareStatement(sql); 				  
		pstmtDt.setString(1,STATUS);
		pstmtDt.setString(2,UserName);
		pstmtDt.setString(3,pick_id);
		pstmtDt.setString(4,pick_id);
		pstmtDt.setString(5,pick_id);
		pstmtDt.executeQuery();
		pstmtDt.close();	
			
		con.commit();
			
		if (STATUS.equals("PICKED"))
		{
		%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("動作成功!!若要到下一關發退料確認,請按確定鍵,否則按下取消鍵,回到首頁!!"))
			{
				setSubmit("../jsp/TSA01WIPWareHouseConfirm.jsp");
			}
			else
			{
				setSubmit("/oradds/ORADDSMainMenu.jsp");
			}
		</script>
		<%	
		}
		else
		{
		%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("取消成功!!若繼續撿貨確認,請按確定鍵,否則按下取消鍵,回到首頁!!"))
			{
				setSubmit("../jsp/TSA01WIPWareHousePick.jsp");
			}
			else
			{
				setSubmit("/oradds/ORADDSMainMenu.jsp");
			}
		</script>
		<%		
		}	
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSA01WIPWareHousePick.jsp'>回 A01倉庫撿貨確認功能</a></font>");
	}
}
else if  (PROGRAM.equals("K2-005"))
{
	try
	{
		int icnt=0;
		String group_id = "";
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無確認資料!!");
		}
		sql = " select TSA01_CONFIRM_GROUP_ID_S.NEXTVAL FROM DUAL";
		//out.println(sql);
		PreparedStatement statementx = con.prepareStatement(sql);
		ResultSet rsx=statementx.executeQuery();
		if (rsx.next())
		{	
			group_id = rsx.getString(1);
		}
		rsx.close();
		statementx.close();		
		
		for (int i=0; i< chk.length ;i++)
		{
			if (STATUS.toUpperCase().equals("GOBACK"))
			{
				sql = " update oraddman.tsa01_request_lines_all a"+
					  " set STATUS=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",CONFIRM_GROUP_ID=?"+
					  ",PICK_GROUP_ID=null"+
					  " where request_no||'_'||line_no=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"CONFIRMED");
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,group_id);
				pstmtDt.setString(4,request.getParameter("strkey_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				sql = " delete oraddman.tsa01_request_line_lots_all a"+
					  " where request_no||'_'||line_no=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("strkey_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();						
			}
			else
			{
				//檢查倉別
				sql = " SELECT 1  FROM inv.mtl_secondary_inventories a"+
                      " where exists (select 1 from oraddman.tsa01_request_lines_all x where  x.organization_id=a.organization_id and x.request_no||'_'||x.line_no='"+request.getParameter("strkey_"+chk[i])+"')"+
                      " and (DISABLE_DATE is null or trunc(DISABLE_DATE)> trunc(sysdate))"+
                      " and SECONDARY_INVENTORY_NAME ='"+request.getParameter("SUBINV_"+chk[i])+"'";
				//out.println(sql);
				PreparedStatement statementk = con.prepareStatement(sql);
				ResultSet rsk=statementk.executeQuery();
				if (!rsk.next())
				{	
					throw new Exception("ERP無"+request.getParameter("SUBINV_"+chk[i])+"倉別,請重新確認!!");
				}
				rsk.close();
				statementk.close();		
					
				sql = " update oraddman.tsa01_request_lines_all a"+
					  " set STATUS=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",CONFIRM_GROUP_ID=?"+
					  " where request_no||'_'||line_no=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,STATUS);
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,group_id);
				pstmtDt.setString(4,request.getParameter("strkey_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();	
				
				//add by Peggy 20161028
				sql = " update oraddman.tsa01_request_line_lots_all a"+
					  " set LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",SUBINVENTORY_CODE=?"+ 
					  ",WAREHOUSE_REMARKS=?"+ //add by Peggy 20170815
					  " where request_no||'_'||line_no||'_'||SUBINVENTORY_CODE=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName);
				pstmtDt.setString(2,(request.getParameter("SUBINV_"+chk[i])==null?"":request.getParameter("SUBINV_"+chk[i])));
				pstmtDt.setString(3,(request.getParameter("REMARKS_"+chk[i])==null?"":request.getParameter("REMARKS_"+chk[i])));
				pstmtDt.setString(4,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();						
									
			}
		}
		
		if (STATUS.toUpperCase().equals("CLOSED"))
		{	
			CallableStatement cs1 = con.prepareCall("{call TSA01_WIP_PKG.SUBMIT_REQ(?,?)}");
			cs1.setString(1,group_id); 	
			cs1.setString(2,UserName); 	
			cs1.execute();
			cs1.close();	
		}
		else
		{		
			sql = " insert into oraddman.tsa01_request_history"+
				  "(request_no"+
				  ",version_id"+
				  ",seq"+
				  ",trans_name"+
				  ",created_by"+
				  ",creation_date"+
				  ",remarks)"+
				  "select xx.request_no"+
				  ",xx.version_id"+
				  ",(select nvl(max(seq),0)+1 from oraddman.tsa01_request_history k where k.request_no=xx.request_no) seqno"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",'"+(request.getParameter("REJ_REASON")==null?"":request.getParameter("REJ_REASON"))+"'|| case when NOPICK_CNT >0 then item_list else '' end as remarks"+
				  " from ( SELECT x.request_no,x.version_id,(select count(1) from oraddman.tsa01_request_lines_all b where  nvl(b.CONFIRM_GROUP_ID,0)<>? and b.request_no=x.request_no) nopick_cnt"+
				  "       ,(select listagg(rpad(a.COMPONENT_NAME,16,' ')||'  '||to_char(a.REQUEST_QTY,'99990D999')||a.uom,chr(10)) within group(order by a.line_no)  from oraddman.tsa01_request_lines_all a where a.CONFIRM_GROUP_ID=? and a.request_no=x.request_no)  item_list"+
				  "        FROM oraddman.tsa01_request_headers_all x"+
				  " where exists (select 1 from oraddman.tsa01_request_lines_all  y where nvl(y.CONFIRM_GROUP_ID,0)=? AND y.request_no=x.request_no)) xx";
			PreparedStatement pstmtDt=con.prepareStatement(sql); 				  
			pstmtDt.setString(1,STATUS);
			pstmtDt.setString(2,UserName);
			pstmtDt.setString(3,group_id);
			pstmtDt.setString(4,group_id);
			pstmtDt.setString(5,group_id);
			pstmtDt.executeQuery();
			pstmtDt.close();		
		}
			
		con.commit();
		%>			
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("動作成功!!若要繼續處理下一筆,請按確定鍵,否則按下取消鍵,回到首頁!!"))
			{
				setSubmit("../jsp/TSA01WIPWareHouseConfirm.jsp");
			}
			else
			{
				setSubmit("/oradds/ORADDSMainMenu.jsp");
			}
		</script>		
		<%		
		
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSA01WIPWareHouseConfirm.jsp'>回 A01倉庫發退料確認功能</a></font>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

