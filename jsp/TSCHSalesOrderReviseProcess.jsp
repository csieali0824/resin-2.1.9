<!-- 20160517 by Peggy,簡稱不使用 Name Pronuncication ,改採用 Account Description-->
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
<title>TSCH Sales Order Revise Process</title>
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
function setExcel(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCHSalesOrderReviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql11="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt11=con.prepareStatement(sql11);
pstmt11.executeUpdate(); 
pstmt11.close();

String sql ="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";

try
{
	if (ACODE.equals("SAVE"))
	{
		String tsc_temp_id="",tsch_temp_id="",tsc_request_no="",tsch_request_no="",revise_group_id="";
		int tsc_seq_id=0,error=0;
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			for(int i=0; i< chk.length ;i++)
			{
				if (i==0)
				{
					sql = "select tsch_order_revise_pkg.GET_TSCH_REQUEST_NO(to_char(sysdate,'yyyymmdd')) from dual";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					if (!rs.next())
					{
						throw new Exception("TSCH No Data Found!!");
					}
					else
					{
						tsch_request_no=rs.getString(1);
					}
					rs.close();
					statement.close();	
						
					statement=con.createStatement();
					rs=statement.executeQuery(" SELECT TSCH_ORDER_REVISE_TEMP_ID_S.nextval from dual");
					if (rs.next())
					{
						tsch_temp_id = rs.getString(1);
					}
					else
					{
						throw new Exception("Get TSCH Temp ID fail!!");
					}
					rs.close();
					statement.close();		
													
					sql = "select tsc_order_revise_pkg.GET_REQUEST_NO(to_char(sysdate,'yyyymmdd')) from dual";
					statement=con.createStatement();
					rs=statement.executeQuery(sql);
					if (!rs.next())
					{
						throw new Exception("TSC No Data Found!!");
					}
					else
					{
						tsc_request_no=rs.getString(1);
					}
					rs.close();
					statement.close();	
					
					statement=con.createStatement();
					rs=statement.executeQuery(" SELECT TSC_ORDER_REVISE_TEMP_ID_S.nextval from dual");
					if (rs.next())
					{
						tsc_temp_id = rs.getString(1);
					}
					else
					{
						throw new Exception("Get TSC Temp ID fail!!");
					}
					rs.close();
					statement.close();											
				}
				
				//add by Peggy 20160919
				if (Integer.parseInt(request.getParameter("TSC_ORDER_CNT_"+chk[i])) == Integer.parseInt(request.getParameter("TSC_ORDER_CLOSE_CNT_"+chk[i])))
				{
					if (revise_group_id.equals(""))
					{	
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery("select apps.tsc_order_revise_group_id_s.nextval from dual");
						if (!rs.next())
						{
							throw new Exception("Revise Group ID not Found!!");
						}
						else
						{
							revise_group_id = rs.getString(1);
						}
						rs.close();
						statement.close();						
					}
				}
				
				sql = " insert into oraddman.tsc_om_salesorderrevise_temp"+
				      " ("+
					  " temp_id"+               //1
					  ",seq_id"+                //2
					  ",SALES_GROUP"+           //3
					  ",so_no"+                 //4
					  ",line_no"+               //5
					  ",so_header_id"+          //6
					  ",so_line_id"+            //7
					  ",source_customer_id"+    //8
					  ",source_item_id"+        //9
					  ",source_item_desc"+      //10
					  ",source_cust_item_id"+   //11
					  ",source_cust_item_name"+ //12
					  ",source_customer_po"+    //13
					  ",source_so_qty"+         //14  
					  ",source_ssd"+            //15
					  ",source_request_date"+   //16
					  ",tsc_prod_group"+        //17
					  ",packing_instructions"+  //18
					  ",plant_code"+            //19
					  ",so_qty"+                //20
					  ",request_date"+          //21
					  ",schedule_ship_date"+    //22
					  ",remarks"+               //23
					  ",org_id"+                //24
 				      ",CHANGE_REASON"+         //25
					  ",CHANGE_COMMENTS"+       //26
					  ",REVISE_GROUP_ID"+       //27,add by Peggy 20160919
					  ",CREATED_BY"+            //28
					  ",CREATION_DATE"+         //29
					  " )"+
					  " select "+
					  "?"+                                                //1
					  ","+(i+1)+""+                                       //2
					  ",'TSCH-HK'"+                                       //3
					  ",b.order_number"+                                  //4
					  ",a.line_number||'.'||a.shipment_number"+           //5
					  ",a.header_id"+                                     //6
					  ",a.line_id"+                                       //7
					  ",b.sold_to_org_id"+                                //8
					  ",a.inventory_item_id"+                             //9
					  ",c.description"+                                   //10
					  ",a.ordered_item_id"+                               //11
					  ",a.ordered_item"+                                  //12
					  ",nvl(a.customer_line_number,a.cust_po_number)"+    //13
					  ",?"+                                               //14
					  ",a.schedule_ship_date"+                            //15
					  ",to_date(?,'yyyymmdd')"+                           //16
					  ",tsc_om_category(c.organization_id,c.inventory_item_id,'TSC_PROD_GROUP')"+   //17
					  ",null"+                                            //18
					  ",null"+                                            //19
					  ",?"+                                               //20
					  ",to_date(?,'yyyymmdd')"+                           //21
					  ",null"+                                            //22
					  ",?"+                                               //23
					  ",b.org_id"+                                        //24
					  ",?"+                                               //25
					  ",?"+                                               //26
					  ",?"+                                               //27,add by Peggy 20160919
					  ",?"+                                               //28,add by Peggy 20160919
					  ",sysdate"+                                         //29,add by Peggy 20160919
					  " from ont.oe_order_lines_all a,ont.oe_order_headers_all b,inv.mtl_system_items_b c"+
					  " where a.header_id=b.header_id"+
					  " and a.org_id=b.org_id"+
					  " and a.inventory_item_id=c.inventory_item_id"+
					  " and a.ship_from_org_id=c.organization_id"+
					  " and a.org_id=?"+
					  " and a.Line_id=?";
				//out.println(sql);
				//out.println(tsch_temp_id);
				//out.println(request.getParameter("QTY_"+chk[i]));
				//out.println(request.getParameter("LINE_"+chk[i]));
				//out.println(request.getParameter("TSC_ORDER_CNT_"+chk[i]));
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,tsch_temp_id);
				pstmtDt.setString(2,request.getParameter("QTY_"+chk[i]));
				pstmtDt.setString(3,request.getParameter("CRD_"+chk[i]));
				pstmtDt.setString(4,(request.getParameter("NEW_QTY_"+chk[i])==null?"":request.getParameter("NEW_QTY_"+chk[i])));
				pstmtDt.setString(5,(request.getParameter("NEW_CRD_"+chk[i])==null?"":request.getParameter("NEW_CRD_"+chk[i])));
				pstmtDt.setString(6, null);
				pstmtDt.setString(7,"Customer Require");
				pstmtDt.setString(8, null);
				pstmtDt.setString(9,(Integer.parseInt(request.getParameter("TSC_ORDER_CNT_"+chk[i])) == Integer.parseInt(request.getParameter("TSC_ORDER_CLOSE_CNT_"+chk[i]))?revise_group_id:null));
				pstmtDt.setString(10,UserName);
				pstmtDt.setInt(11,806);
				pstmtDt.setString(12,request.getParameter("LINE_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();	

				for (int j =1 ; j <= Integer.parseInt(request.getParameter("TSC_ORDER_CNT_"+chk[i])) ; j++)
				{
					if ((request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j) != null && !(request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j)).equals("") && request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j) != request.getParameter("TSC_ORIG_SSD_"+chk[i]+"_"+j))
					    || (request.getParameter("TSC_NEW_QTY_"+chk[i]+"_"+j) != null && !(request.getParameter("TSC_NEW_QTY_"+chk[i]+"_"+j)).equals("") && request.getParameter("TSC_NEW_QTY_"+chk[i]+"_"+j) != request.getParameter("TSC_ORIG_QTY_"+chk[i]+"_"+j))
						)
					{

						tsc_seq_id++;	
						sql = " insert into oraddman.TSC_OM_SALESORDERREVISE_TEMP "+
							  "(TEMP_ID"+                //1
							  ",SEQ_ID"+                 //2
							  ",CREATED_BY"+             //3
							  ",CREATION_DATE"+          //4
							  ",SALES_GROUP"+            //5
							  ",SO_NO"+                  //6
							  ",LINE_NO"+                //7
							  ",SOURCE_ITEM_DESC"+       //8
							  ",SOURCE_CUSTOMER_PO"+     //9
							  ",SOURCE_SO_QTY"+          //10
							  ",SOURCE_REQUEST_DATE"+    //11
							  ",SOURCE_SSD"+             //12
							  ",ORDER_TYPE"+             //13
							  ",CUSTOMER_NUMBER"+        //14
							  ",CUSTOMER_NAME"+          //15
							  ",SHIP_TO_LOCATION_ID"+    //16
							  ",BILL_TO_LOCATION_ID"+    //17
							  ",DELIVER_TO_LOCATION_ID"+ //18
							  ",ITEM_NAME"+              //19
							  ",CUST_ITEM_NAME"+         //20
							  ",CUSTOMER_PO"+            //21
							  ",SHIPPING_METHOD"+        //22
							  ",SO_QTY"+                 //23
							  ",SCHEDULE_SHIP_DATE"+     //24
							  ",REQUEST_DATE"+           //25
							  ",FOB"+                    //26
							  ",REMARKS"+                //27
							  ",CHANGE_REASON"+          //28
							  ",CHANGE_COMMENTS"+        //29
							  ",TSCH_TEMP_ID"+           //30
							  ",TSCH_SEQ_ID"+            //31
							  ",ORG_ID"+                 //32
							  ")"+
							  " select "+
							  " ?"+                                                  //TEMP_ID
							  ","+tsc_seq_id+""+
							  ",?"+                                                  //CREATED_BY
							  ",sysdate"+
							  ",Tsc_Intercompany_Pkg.get_sales_group(a.header_id)"+  //SALES_GROUP
							  ",a.order_number"+                                     //SO_NO
							  ",b.line_number||'.'||b.shipment_number"+              //LINE_NO
							  ",c.description"+                                      //SOURCE_ITEM_DESC
							  ",nvl(b.customer_line_number,b.cust_po_number)"+       //SOURCE_CUSTOMER_PO
							  ",?"+                                                  //SOURCE_SO_QTY
							  ",b.REQUEST_DATE"+                                     //SOURCE_REQUEST_DATE
							  ",to_date(?,'yyyymmdd')"+                              //SOURCE_SSD
							  ",null"+                                               //ORDER_TYPE
							  ",null"+                                               //CUSTOMER_NUMBER
							  ",null"+                                               //CUSTOMER_NAME
							  ",null"+                                               //SHIP_TO_LOCATION_ID
							  ",null"+                                               //BILL_TO_LOCATION_ID
							  ",null"+                                               //DELIVER_TO_LOCATION_ID
							  ",null"+                                               //ITEM_NAME
							  ",null"+                                               //CUST_ITEM_NAME
							  ",null"+                                               //CUSTOMER_PO
							  ",null"+                                               //SHIPPING_METHOD
							  ",?"+                                                  //SO_QTY
							  ",to_date(?,'yyyymmdd')"+                              //SCHEDULE_SHIP_DATE
							  //",to_date(?,'yyyymmdd')"+                              //REQUEST_DATE
							  ",null"+                                               //REQUEST_DATE,sansan說request date不改(8/18會議上),modify by Peggy 20160819
							  ",null"+                                               //FOB
							  ",?"+                                                  //REMARKS
							  ",?"+                                                  //CHANGE_REASON
							  ",?"+                                                  //CHANGE_COMMENTS
							  ",?"+                                                  //tsch_temp_id                                             
							  ",?"+                                                  //tsch_seq_id
							  ",a.org_id"+                                           //org_id
							  " from ont.oe_order_headers_all a"+
							  ",ont.oe_order_lines_all b"+
							  ",inv.mtl_system_items_b c"+
							  ",ar_customers d"+
							  " where a.header_id=b.header_id"+
							  " and b.inventory_item_id=c.inventory_item_id"+
							  " and b.ship_from_org_id=c.organization_id"+
							  " and a.sold_to_org_id=d.customer_id"+
							  " and a.org_id=b.org_id"+
							  " and a.org_id=?"+
							  " and b.line_id=?";
						//out.println(sql);
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,tsc_temp_id);
						pstmtDt.setString(2,UserName);
						pstmtDt.setString(3,request.getParameter("TSC_ORIG_QTY_"+chk[i]+"_"+j));
						pstmtDt.setString(4,request.getParameter("TSC_ORIG_SSD_"+chk[i]+"_"+j));
						pstmtDt.setString(5,(request.getParameter("TSC_NEW_QTY_"+chk[i]+"_"+j)==null?"":request.getParameter("TSC_NEW_QTY_"+chk[i]+"_"+j)));
						pstmtDt.setString(6,(request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j)==null?"":request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j)));
						//pstmtDt.setString(7,(request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j)==null?"":request.getParameter("TSC_NEW_SSD_"+chk[i]+"_"+j)));
						pstmtDt.setString(7,(request.getParameter("REMARKS_"+chk[i]+"_"+j)==null?"":request.getParameter("REMARKS_"+chk[i]+"_"+j)));
						pstmtDt.setString(8,"Customer Require");
						pstmtDt.setString(9,null);
						pstmtDt.setString(10,tsch_temp_id);
						pstmtDt.setString(11,""+(i+1));
						pstmtDt.setInt(12,41);
						pstmtDt.setString(13,request.getParameter("TSC_MO_LINE_ID_"+chk[i]+"_"+j));
						pstmtDt.executeQuery();
						pstmtDt.close();				  
					}
				}
			}
			CallableStatement cs = con.prepareCall("{call tsch_order_revise_pkg.revise_data_check(?,?)}");
			cs.setString(1,tsch_temp_id);
			cs.setString(2,UserName);
			cs.execute();
			cs.close();	
						
			cs = con.prepareCall("{call tsc_order_revise_pkg.revise_data_check(?,?)}");
			cs.setString(1,tsc_temp_id);
			cs.setString(2,UserName);
			cs.execute();
			cs.close();	
			
			Statement statement=con.createStatement();
			sql = " select a.SEQ_ID,a.SALES_GROUP,b.so_no,b.line_no,b.SOURCE_ITEM_DESC,b.SOURCE_CUSTOMER_PO,a.SO_NO ,a.LINE_NO,TO_CHAR(a.SOURCE_SSD,'yyyymmdd') TSC_SSD,A.ERROR_MESSAGE||' '||b.error_message error_message "+
			      " from oraddman.TSC_OM_SALESORDERREVISE_TEMP a,oraddman.tsc_om_salesorderrevise_temp b "+
				  " WHERE a.TEMP_ID='"+tsc_temp_id+"'"+
				  " and a.PASS_FLAG='N'"+
				  " and a.tsch_temp_id=b.temp_id"+
				  " and a.tsch_seq_id=b.seq_id";
			//out.println(sql);				  
			ResultSet rs=statement.executeQuery(sql);
			ResultSetMetaData md=rs.getMetaData();
			while (rs.next())
			{
				if (error==0)
				{
					out.println("<div style='color:#FF0000;font-size:12px'>Action Fail~~</div><table width='90%' border='1'>");
					out.println("<tr style='font-size:12px;background-color:#cccccc'>");
					out.println("<td>Row</td><td>TSCH MO#</td><td>TSCH Line#</td><td>TSC PARTNO</td><td>CUST PO</td><td>TSC MO#</td><td>TSC Line#</td><td>TSC SSD</td><td>Error Message</td>");
					out.println("</tr>");
					out.println("<tr>");
				}
				out.println("<td align='center'>"+rs.getString(1)+"</td>");
				for (int m = 3 ; m <= md.getColumnCount() ; m++)
				{
					out.println("<td"+(m==md.getColumnCount()?" style='color:#FF0000'":"")+">"+(rs.getString(m)==null?"&nbsp;":rs.getString(m).replace("\n","<br>"))+"</tr>");
				}
				out.println("</tr>");
				error++;
			}
			rs.close();
			statement.close();			
		}
		if (error >0)
		{
			out.println("</table>");
			throw new Exception("");
		}
		else
		{
			sql = " insert into oraddman.tsc_om_salesorderrevise_tsch"+
				  " ("+
				  " request_no"+                   //1
				  ",temp_id"+                      //2
				  ",seq_id"+                       //3
				  ",so_no"+                        //4
				  ",line_no"+                      //5
				  ",so_header_id"+                 //6
				  ",so_line_id"+                   //7
				  ",source_customer_id"+           //8
				  ",source_item_id"+               //9
				  ",source_item_desc"+             //10
				  ",source_cust_item_id"+          //11
				  ",source_cust_item_name"+        //12
				  ",source_customer_po"+           //13
				  ",source_so_qty"+                //14
				  ",source_ssd"+                   //15
				  ",source_request_date"+          //16
				  ",tsc_prod_group"+               //17
				  ",packing_instructions"+         //18
				  ",plant_code"+                   //19
				  ",so_qty"+                       //20
				  ",request_date"+                 //21
				  ",schedule_ship_date"+           //22
				  ",remarks"+                      //23
				  ",status"+                       //24
				  ",created_by"+                   //25
				  ",creation_date"+                //26
				  ",last_updated_by"+              //27
				  ",last_update_date"+             //28
				  ",org_id"+                       //29
				  ",CHANGE_REASON"+                //30
				  ",CHANGE_COMMENTS"+              //31
				  ",SOURCE_CUSTOMER_NAME"+         //32
				  ",PROGRAM_NAME"+                 //33
				  ",GROUP_ID"+                     //34,add by Peggy 20160920
				  ",TEMP_GROUP_ID"+                //35,add by Peggy 20160920
				  " )"+
				  " select "+
				  " ?"+                            //1
				  ",a.temp_id"+                    //2
				  ",a.seq_id"+                     //3
				  ",a.so_no"+                      //4
				  ",a.line_no"+                    //5
				  ",a.so_header_id"+               //6
				  ",a.so_line_id"+                 //7
				  ",a.source_customer_id"+         //8
				  ",a.source_item_id"+             //9
				  ",a.source_item_desc"+           //10
				  ",a.source_cust_item_id"+        //11
				  ",a.source_cust_item_name"+      //12
				  ",a.source_customer_po"+         //13
				  ",a.source_so_qty"+              //14
				  ",a.source_ssd"+                 //15
				  ",a.source_request_date"+        //16
				  ",a.tsc_prod_group"+             //17
				  ",a.packing_instructions"+       //18
				  ",a.plant_code"+                 //19
				  ",a.so_qty"+                     //20
				  ",a.request_date"+               //21
				  ",a.schedule_ship_date"+         //22
				  ",a.remarks"+                    //23
				  ",?"+                            //24
				  ",?"+                            //25
				  ",sysdate"+                      //26
				  ",?"+                            //27
				  ",sysdate"+                      //28
				  ",a.org_id"+                     //29
				  ",a.CHANGE_REASON"+              //30
				  ",a.CHANGE_COMMENTS"+            //31
				  ",nvl(HCA.ACCOUNT_NAME,b.customer_name)"+  //32
				  ",'D13-001'"+                    //33
				  ",a.revise_group_id"+            //34,add by Peggy 20160920
				  ",a.revise_group_id"+            //35,add by Peggy 20160920
				  " from oraddman.tsc_om_salesorderrevise_temp a,ar_customers b,HZ_CUST_ACCOUNTS HCA"+
				  " where temp_id=? "+
				  " AND B.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID"+ //add by Peggy 20160517
				  " and a.source_customer_id=b.customer_id";				  
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,tsch_request_no);
			pstmtDt.setString(2,"AWAITING_CONFIRM");
			pstmtDt.setString(3,UserName);
			pstmtDt.setString(4,UserName);
			pstmtDt.setString(5,tsch_temp_id);
			pstmtDt.executeQuery();
			pstmtDt.close();					  
				
		
			sql = "insert into oraddman.tsc_om_salesorderrevise_req"+
				  "("+
				  " sales_group"+
				  ",so_no"+
				  ",line_no"+
				  ",source_customer_id"+
				  ",so_header_id"+
				  ",so_line_id"+
				  ",order_type"+
				  ",customer_number"+
				  ",customer_name"+
				  ",ship_to_org_id"+
				  ",ship_to"+
				  ",tsc_prod_group"+
				  ",inventory_item_id"+
				  ",item_name"+
				  ",item_desc"+
				  ",cust_item_id"+
				  ",cust_item_name"+
				  ",customer_po"+
				  ",shipping_method"+
				  ",so_qty"+
				  ",Request_date"+
				  ",schedule_ship_date"+
				  ",packing_instructions"+
				  ",plant_code"+
				  ",change_reason"+
				  ",change_comments"+
				  ",created_by"+
				  ",creation_date"+
				  ",last_updated_by"+
				  ",last_update_date"+
				  ",status"+
				  ",temp_id"+
				  ",seq_id"+
				  ",remarks"+	
				  ",CUSTOMER_ID_REF"+
				  ",CUSTOMER_PO_REF"+		  
				  ",CUSTOMER_PO_LINE_REF"+
				  ",VERSION_ID_REF"+
				  ",SOURCE_CUSTOMER_PO"+
				  ",SOURCE_REQUEST_DATE"+
				  ",SOURCE_SSD"+
				  ",SOURCE_SO_QTY"+
				  ",SOURCE_ITEM_ID"+
				  ",SOURCE_ITEM_DESC"+
				  ",SOURCE_CUST_ITEM_ID"+
				  ",SOURCE_CUST_ITEM_NAME"+
				  ",SOURCE_SHIP_FROM_ORG_ID"+
				  ",SOURCE_SHIPPING_METHOD"+
				  ",SOURCE_SHIP_TO_ORG_ID"+
				  ",SHIP_TO_LOCATION_ID"+
				  ",DELIVER_TO_LOCATION_ID"+
				  ",DELIVER_TO_ORG_ID"+
				  ",DELIVER_TO"+
				  ",SOURCE_DELIVER_TO_ORG_ID"+
				  ",BILL_TO_LOCATION_ID"+
				  ",BILL_TO_ORG_ID"+
				  ",BILL_TO"+
				  ",SOURCE_BILL_TO_ORG_ID"+			  
				  ",REQUEST_NO"+
				  ",SOURCE_BILL_TO_LOCATION_ID"+
				  ",SOURCE_SHIP_TO_LOCATION_ID"+
				  ",SOURCE_DELIVER_TO_LOCATION_ID"+
				  ",FOB_POINT_CODE"+
				  ",SOURCE_FOB_POINT_CODE"+
				  ",FOB"+
				  ",TAX_CODE"+
				  ",TSCH_TEMP_ID"+
				  ",TSCH_SEQ_ID"+
				  ",SCHEDULE_SHIP_DATE_TW"+
				  ",TO_TW_DAYS"+
				  ")"+
				  " SELECT "+
				  " sales_group"+
				  ",so_no"+
				  ",line_no"+
				  ",source_customer_id"+
				  ",so_header_id"+
				  ",so_line_id"+
				  ",order_type"+
				  ",customer_number"+
				  ",customer_name"+
				  ",ship_to_org_id"+
				  ",ship_to"+
				  ",tsc_prod_group"+
				  ",inventory_item_id"+
				  ",item_name"+
				  ",item_desc"+
				  ",cust_item_id"+
				  ",cust_item_name"+
				  ",customer_po"+
				  ",shipping_method"+
				  ",so_qty"+
				  ",Request_date"+
				  ",schedule_ship_date"+
				  ",packing_instructions"+
				  ",plant_code"+
				  ",change_reason"+
				  ",change_comments"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",temp_id"+
				  ",seq_id"+	
				  ",remarks"+	
				  ",CUSTOMER_ID_REF"+
				  ",CUSTOMER_PO_REF"+		  
				  ",CUSTOMER_PO_LINE_REF"+
				  ",VERSION_ID_REF"+
				  ",SOURCE_CUSTOMER_PO"+
				  ",SOURCE_REQUEST_DATE"+
				  ",SOURCE_SSD"+
				  ",SOURCE_SO_QTY"+
				  ",SOURCE_ITEM_ID"+
				  ",SOURCE_ITEM_DESC"+
				  ",SOURCE_CUST_ITEM_ID"+
				  ",SOURCE_CUST_ITEM_NAME"+
				  ",SOURCE_SHIP_FROM_ORG_ID"+
				  ",SOURCE_SHIPPING_METHOD"+
				  ",SOURCE_SHIP_TO_ORG_ID"+
				  ",SHIP_TO_LOCATION_ID"+
				  ",DELIVER_TO_LOCATION_ID"+
				  ",DELIVER_TO_ORG_ID"+
				  ",DELIVER_TO"+
				  ",SOURCE_DELIVER_TO_ORG_ID"+	
				  ",BILL_TO_LOCATION_ID"+
				  ",BILL_TO_ORG_ID"+
				  ",BILL_TO"+
				  ",SOURCE_BILL_TO_ORG_ID"+					  
				  ",?"+	  
				  ",SOURCE_BILL_TO_LOCATION_ID"+
				  ",SOURCE_SHIP_TO_LOCATION_ID"+
				  ",SOURCE_DELIVER_TO_LOCATION_ID"+
				  ",FOB_POINT_CODE"+
				  ",SOURCE_FOB_POINT_CODE"+
				  ",FOB"+
				  ",TAX_CODE"+
				  ",TSCH_TEMP_ID"+
				  ",TSCH_SEQ_ID"+
				  ",SCHEDULE_SHIP_DATE_TW"+
				  ",TO_TW_DAYS"+				  
				  " from oraddman.tsc_om_salesorderrevise_temp a"+
				  " where temp_id=?";
			//out.println(sql);
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,UserName);
			pstmtDt.setString(2,UserName);
			pstmtDt.setString(3,"AWAITING_CONFIRM");
			pstmtDt.setString(4,tsc_request_no);
			pstmtDt.setString(5,tsc_temp_id);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			//add by Peggy 20160920
			if (!revise_group_id.equals(""))
			{
				CallableStatement cs = con.prepareCall("{call tsch_order_revise_pkg.main(?,?,?)}");
				cs.setString(1,revise_group_id);
				cs.setString(2,UserName);
				cs.setString(3,"D13");
				cs.execute();
				cs.close();	
			}						
			con.commit();
			
			Statement statement=con.createStatement();
			sql = " select a.request_no,a.source_customer_name customer_name,a.so_no,a.line_no,a.source_item_desc item_desc,a.source_customer_po customer_po, to_char(a.source_request_date,'yyyy/mm/dd') crd,a.source_so_qty"+
			      " ,tsch_order_revise_pkg.get_revise_desc(a.temp_id,a.seq_id) tsch_revise_detail"+
				  " ,tsc_order_revise_pkg.get_revise_desc(b.temp_id,b.seq_id,'ALL') tsc_revise_detail"+
                  " ,b.request_no tsc_request_no"+
				  " ,a.group_id,a.error_message"+
                  " ,row_number() over (partition by a.request_no,a.so_no,a.line_no order by decode(nvl(a.so_qty,a.source_so_qty),a.source_so_qty,1,2),decode(nvl(a.request_date,a.source_request_date),a.source_request_date,1,2),nvl(a.request_date,a.source_request_date)) line_cnt"+
				  " ,b.so_no"+
                  " from oraddman.tsc_om_salesorderrevise_tsch a,oraddman.tsc_om_salesorderrevise_req b"+
                  " where a.request_no='"+tsch_request_no+"'"+
				  " and a.temp_id=b.tsch_temp_id(+)"+
				  " and a.seq_id=b.tsch_seq_id(+)"+
				  " order by a.request_no,a.source_customer_name,a.so_no,a.line_no";
			//out.println(sql);				  
			ResultSet rs=statement.executeQuery(sql);
			ResultSetMetaData md=rs.getMetaData();
			int icnt=0;
			while (rs.next())
			{
				if (icnt==0)
				{
					out.println("<div style='color:#000000;font-size:12px'>Process result as follows~~</div><table width='100%' border='1'>");
					out.println("<tr style='font-size:12px;background-color:#cccccc'>");
					out.println("<td>Request#</td><td>Customer</td><td>TSCH SO#</td><td>TSCH SO Line#</td><td>TSC PARTNO</td><td>CUST PO</td><td>CRD</td><td>SO Qty</td><td>TSCH Revise Detail</td><td>TSC Revise Detail</td><td width='20%'>Result</td>");
					out.println("</tr>");
				}
				out.println("<tr style='font-size:12px'>");
				for (int m = 1 ; m <= md.getColumnCount()-4; m++)
				{
					if (m==md.getColumnCount()-4)
					{
						if (rs.getString(m+1)==null)
						{
							out.println("<td>"+(rs.getString(m)==null?"&nbsp;":"已轉工廠確認中(申請單:<a href="+'"'+"../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO="+rs.getString(m)+"&MONO="+rs.getString(m+4)+'"'+">"+rs.getString(m)+"</a>)")+"</tr>");
						}
						else
						{
							out.println("<td>"+(rs.getString(m+2)==null?"<font color='#0000ff'>訂單修改成功</font>":"<font color='#ff0000'>訂單修改失敗(錯誤原因:"+rs.getString(m+2)+")</font>")+"</tr>");
						}
					}
					else
					{
						out.println("<td>"+(rs.getString(m)==null?"&nbsp;":rs.getString(m).replace("\n","<br>"))+"</tr>");
					}
				}
				out.println("</tr>");
				icnt++;
			}
			rs.close();
			statement.close();	
			if (icnt >0)
			{
				out.println("</table>");
				out.println("<p><table width='100%' align='center'>");
				out.println("<tr><td align='center'><div align='center' style='color:#0000ff;font-size:14x;'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
				%>
				<jsp:getProperty name="rPH" property="pgHOME"/>
				<%
				out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TSCHSalesOrderReviseRequest.jsp'>回 TSCH訂單變更申請作業</font></a></td></tr>");
				out.println("</table>");				
			}		
				  
		
		%>
			<!--<script language="JavaScript" type="text/JavaScript">
				alert("TSCH Request No:<%=tsch_request_no%>"+"\n TSC Request No:<%=tsc_request_no%>");
				//setSubmit("../jsp/TSCHSalesOrderReviseQuery.jsp?REQUESTNO=<%=tsch_request_no%>");
				setSubmit("../jsp/TSCHSalesOrderReviseRequest.jsp");
			</script>-->
		<%	
		}		
	}
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>Exceution Fail!!Please contact MIS!!<br>"+e.getMessage()+"<br><br><a href='TSCHSalesOrderReviseRequest.jsp'>回TSCH訂單變更申請作業</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

