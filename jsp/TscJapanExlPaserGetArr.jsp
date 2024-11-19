<!--add by Peggy 20140822,新增ERP END CUSTOMER ID欄位-->
<!--add by Peggy 20160525,依ship to抓預設sales-->
<!-- 20160929 by Peggy,add customer p/n-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="jxl.*" %> 
<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.File.*"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>無標題文件</title>
</head>
<body>
<%
//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
cs1.execute();
cs1.close();
//String customer = "TAIWAN SEMICONDUCTOR JAPAN CO.,LTD";
String customer = request.getParameter("CUSTOMERNAME");        //modify by Peggy 20120224       
//String sales_Area_No = "003";
String sales_Area_No = request.getParameter("SalesAreaNo");    //modify by Peggy 20120224 
//String tscCustomerID = "4777";
String tscCustomerID = request.getParameter("CUSTOMERNO");     //modify by Peggy 20120224 
//String sold_To_Org   = "4777";      //SOLD_TO_ORG
String sold_To_Org  = request.getParameter("CUSTOMERNO");      //modify by Peggy 20120224
//String price_List    = "6038";      //PRICE_LIST
String price_List   = request.getParameter("FIRMPRICELIST");   //modify by Peggy 20120224
//String payterm_ID    = "1034";	   	//PAYTERM_ID
String payterm_ID   = request.getParameter("PAYTERMID");       //modify by Peggy 20120224
//String bill_To_Org   = "7088";      //BILL_TO_ORG
String bill_To_Org =  request.getParameter("BILLTO");          //modify by Peggy 20120224
String remark		 = "Order Import from file";
String requireReason = "";
String a[][] = array2DimensionInputBean.getArray2DContent();
String seqno = request.getParameter("seqno");
String customerPO_Easy = request.getParameter("customerPO_Easy");
String ship_To_Org   = request.getParameter("SHIPTOORG");  //add by Peggy 20120224
//String toPersonID ="100000438";
//String salesPerson="Alice_Lee";
String toPersonID ="";
String salesPerson="";
String sError_Flag = "N";
String STATUSID ="001";
String STATUSCODE= "CREATING";
String order_Type_ID = "";
String line_Type     = "";
String order_Type    = "";
String AUTOCREATE_FLAG = "";
String FOB_POINT = request.getParameter("FOBPOINT");          //modify by Peggy 20120224 
String lineFob = "";       //add by Peggy 20120329
String orderTypeCode = ""; //add by Peggy 20120430
String orderItem = "",orderItemID = "";     //add by Peggy 20121112
int lineCnt =0;
out.println("<BR>seqno="+seqno+"<BR>");
for(int i=1;i<a[0].length;i++ ) 
{
	for(int j=0 ;j<a.length;j++) 
	{
		out.println(" "+a[j][i]);
  	}
  	out.println("<br>");
}
try 
{
	if(seqno!=null)
	{
		if (a!=null)
		{ 	
			//add by Peggy 20120224
			Statement statea=con.createStatement();
			String sqla = " select AUTOCREATE_FLAG "+
			 		      " from oraddman.tssales_area a "+
						  " where SALES_AREA_NO = '"+sales_Area_No+"' ";
			ResultSet rsa=statea.executeQuery(sqla);
			if (rsa.next())
			{
				AUTOCREATE_FLAG = rsa.getString("AUTOCREATE_FLAG");
			} 
			else 
			{ 
				AUTOCREATE_FLAG = "N";
			} 
			rsa.close();
			statea.close();
					
			orderTypeCode =request.getParameter("odrType1");	
			if (order_Type != orderTypeCode )
			{
				Statement stateX=con.createStatement();
				String sqlX = " select a.OTYPE_ID, a.DEFAULT_ORDER_LINE_TYPE "+
								   " from ORADDMAN.TSAREA_ORDERCLS a "+
								   " where to_char(a.order_num) = '"+orderTypeCode+"' "+
								   " and a.SAREA_NO = '"+sales_Area_No+"' and a.ACTIVE ='Y' ";
				ResultSet rsX=stateX.executeQuery(sqlX);
				if (rsX.next())
				{
					order_Type_ID = rsX.getString("OTYPE_ID");
					if (orderTypeCode.equals("1156"))
					{
						line_Type = "1173"; //add by Peggy 20120430
					}
					else
					{
						line_Type = rsX.getString("DEFAULT_ORDER_LINE_TYPE");
					}
				} 
				else 
				{ 
					order_Type_ID = "0";
					line_Type ="0"; 
				} 
				rsX.close();
				stateX.close();	
				
				if (order_Type_ID.equals("0") || order_Type_ID.equals(""))
				{
					throw new Exception("(1)Order Type is not available!!");
				}
				
				Statement stateLType=con.createStatement();
				String sqlOrgInf = " select  b.TRANSACTION_TYPE_ID "+
								   " from APPS.OE_TRANSACTION_TYPES_V b "+
								   " where b.TRANSACTION_TYPE_ID='"+line_Type+"'";
				ResultSet rsLType=stateLType.executeQuery(sqlOrgInf);
				if (!rsLType.next())
				{
					line_Type ="0"; 
				} 
				rsLType.close();
				stateLType.close();	
				
				order_Type = orderTypeCode;
			}		
		
			//add by Peggy 20160525
			Statement statement=con.createStatement();
			String sSql = " select b.PRIMARY_SALESREP_ID, c.NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,jtf_rs_salesreps c "+
						  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and a.CUST_ACCOUNT_ID ='"+tscCustomerID+"' "+
						  " and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID "+
						  " and b.site_use_id='"+ship_To_Org+"'"+
						  " and a.ORG_ID ='41'"+
						  " and c.SALESREP_ID  = b.PRIMARY_SALESREP_ID "+
						  " and b.STATUS = 'A'"; //add by Peggy 20140623
			//out.println(sSql);
			ResultSet rsSalsPs=statement.executeQuery(sSql);	 
			if (rsSalsPs.next()==true)
			{  
				salesPerson = rsSalsPs.getString("NAME");
				toPersonID = rsSalsPs.getString("PRIMARY_SALESREP_ID");		
			}
			rsSalsPs.close();	
			statement.close();
					
			String sql=	"insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,"+
						"AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,REMARK,STATUSID,STATUS,CREATION_DATE,CREATED_BY,"+
						"LAST_UPDATE_DATE,LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,SALESPERSON,BILL_TO_ORG"+ 
						",PAYTERM_ID,"+
						" AUTOCREATE_FLAG,FOB_POINT,SHIPMETHOD,RFQ_TYPE)"+ //add by Peggy 20120224
						" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement pstmt=con.prepareStatement(sql);  
			pstmt.setString(1,seqno);  // 詢問單號\
			pstmt.setString(2,sales_Area_No); // 業務地區別代碼
			pstmt.setString(3,userID);  // 業務人員代碼
			pstmt.setString(4,requireReason);  // 需求原因說明
			pstmt.setString(5,tscCustomerID); // 客戶代碼
			pstmt.setString(6,customer); //客戶名稱
			pstmt.setString(7,customerPO_Easy); //客戶訂購單號
			pstmt.setString(8,"USD");  // 幣別
			pstmt.setInt(9,0);  // 總金額(amount)
			pstmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  // 需求日假設=收件日+ 存檔時間  
			pstmt.setString(11,"");  // PC 確認日期
			pstmt.setString(12,""); // 工廠回覆確認日
			pstmt.setString(13,""); // 生產工廠代碼
			pstmt.setString(14,remark); // 表頭備註
			pstmt.setString(15,STATUSID);//寫入STATUSID    ??
			pstmt.setString(16,STATUSCODE);//寫入狀態名稱    ??
			pstmt.setString(17,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入日期 + 時間
			pstmt.setString(18,userID); //寫入User ID
			pstmt.setString(19,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //最後更新日期
			pstmt.setString(20,userID); //最後更新User
			pstmt.setString(21,toPersonID); // 所屬客戶負責業務人員ID   100000008
			pstmt.setInt(22,Integer.parseInt(order_Type_ID));  // 預選 訂單類型   1007
			pstmt.setInt(23,Integer.parseInt(sold_To_Org)); // Sold To ORG
			pstmt.setInt(24,Integer.parseInt(price_List)); // Price List
			pstmt.setInt(25,Integer.parseInt(ship_To_Org)); // Ship To Org 
			pstmt.setString(26,salesPerson); // 所屬客戶負責業務人員SALES PERSON
			pstmt.setString(27,bill_To_Org);
			pstmt.setString(28,payterm_ID);
			pstmt.setString(29,AUTOCREATE_FLAG); //add by Peggy 20120224
			pstmt.setString(30,FOB_POINT); //fob,add by Peggy 20120224
			pstmt.setString(31,a[3][1].toUpperCase()); //出貨方式,add by Peggy 20120224
			pstmt.setString(32,"1"); //add by Peggy 20120327
			//pstmt.executeUpdate(); 
			pstmt.executeQuery(); //modify by Peggy 20111202
			pstmt.close();
 
			// 判斷入若session Array 內值不為null  
			String sqlDtl="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,"+
						  "LINE_NO,INVENTORY_ITEM_ID,ITEM_SEGMENT1,QUANTITY,UOM,LIST_PRICE,REQUEST_DATE,SHIP_DATE,"+
						  "PROMISE_DATE,LINE_TYPE,PRIMARY_UOM,REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,"+
						  "LSTATUSID,LSTATUS,ITEM_DESCRIPTION,MOQP,SELLING_PRICE,ASSIGN_MANUFACT,CUST_PO_NUMBER,"+ 
						  "ORDER_TYPE_ID,AUTOCREATE_FLAG,SHIPPING_METHOD,PROGRAM_NAME,TSC_PROD_GROUP,FOB,CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER,"+ //add by Peggy 20121107
						  "ORDERED_ITEM,ORDERED_ITEM_ID,"+  //add by Peggy 20121112
 						  "END_CUSTOMER_ID)" + //add by Peggy 20140822
						  " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			for (int ac=1;ac<a[0].length;ac++)
			{ 	 
				orderTypeCode =request.getParameter("odrType"+ac);	
				if (order_Type !=orderTypeCode )
				{
					Statement stateX=con.createStatement();
					String sqlX = " select a.OTYPE_ID, a.DEFAULT_ORDER_LINE_TYPE "+
									   " from ORADDMAN.TSAREA_ORDERCLS a "+
									   " where to_char(a.order_num) = '"+orderTypeCode+"' "+
									   " and a.SAREA_NO = '"+sales_Area_No+"' and a.ACTIVE ='Y' ";
					ResultSet rsX=stateX.executeQuery(sqlX);
					if (rsX.next())
					{
						order_Type_ID = rsX.getString("OTYPE_ID");
						if (orderTypeCode.equals("1156"))
						{
							line_Type = "1173"; //add by Peggy 20120430
						}
						else
						{
							line_Type = rsX.getString("DEFAULT_ORDER_LINE_TYPE");
						}
					} 
					else 
					{ 
						order_Type_ID = "0";
						line_Type ="0"; 
					} 
					rsX.close();
					stateX.close();	
					
					if (order_Type_ID.equals("0") || order_Type_ID.equals(""))
					{
						throw new Exception("Line"+ac+":(2)Order Type is not available!!");
					}
					
					Statement stateLType=con.createStatement();
					String sqlOrgInf = " select  b.TRANSACTION_TYPE_ID "+
									   " from APPS.OE_TRANSACTION_TYPES_V b "+
									   " where b.TRANSACTION_TYPE_ID='"+line_Type+"'";
					ResultSet rsLType=stateLType.executeQuery(sqlOrgInf);
					if (!rsLType.next())
					{
						line_Type ="0"; 
					} 
					rsLType.close();
					stateLType.close();	
					
					order_Type = orderTypeCode;
				}		
				//add by Peggy 20120329
				lineFob = request.getParameter("FOB"+ac);
				if (lineFob == null || lineFob.equals(""))
				{
					lineFob = FOB_POINT;
				}
				
				////add by Peggy 20121112
				//Statement stateb=con.createStatement();
				//String sqlb = " select  DISTINCT a.item,a.item_id, a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
                //              " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID "+
                //              " from oe_items_v a,inv.mtl_system_items_b msi "+
                //              " where a.SOLD_TO_ORG_ID = '"+tscCustomerID+"'"+
                //              " and a.INVENTORY_ITEM_ID = '"+a[4][ac]+"'"+
                //              " and a.organization_id = msi.organization_id"+
                //              " and a.inventory_item_id = msi.inventory_item_id"+
                //              " and msi.ORGANIZATION_ID = '49'"+
                //              " and a.CROSS_REF_STATUS='ACTIVE'";
				//ResultSet rsb=stateb.executeQuery(sqlb);
				//if (rsb.next())
				//{
				//	orderItem =rsb.getString("item");
				//	orderItemID = rsb.getString("item_id");
				//} 
				//else
				//{
				//	orderItem ="N/A";
				//	orderItemID = "0";
				//}
				//rsb.close();
				//stateb.close();	
				
				PreparedStatement pstmtDtl=con.prepareStatement(sqlDtl);  
				pstmtDtl.setString(1,seqno);  // 詢問單號
				String invItemID = "";	
				String uom = "";
				pstmtDtl.setInt(2,ac); // Line_No // 給料項序號	  
				pstmtDtl.setString(3,a[4][ac]); // Inventory_Item_ID	 
				pstmtDtl.setString(4,a[5][ac]); // Inventory_Item_Segment1
				pstmtDtl.setFloat(5,Float.parseFloat(a[1][ac])/1000); // Order Qty
				pstmtDtl.setString(6,a[12][ac]); // Primary Unit of Measure
				pstmtDtl.setFloat(7,Float.parseFloat(a[14][ac])); // List Price
				pstmtDtl.setString(8,a[10][ac]+dateBean.getHourMinuteSecond()); // Request Date
				pstmtDtl.setString(9,a[10][ac]+dateBean.getHourMinuteSecond()); // Ship Date( 預設與需求日相同,但可由工廠於安排交期,生管確認交期及業務最後於生成訂單時修改 )
				pstmtDtl.setString(10,a[10][ac]+dateBean.getHourMinuteSecond()); // Promise Date( 客戶需求日,預設與需求日相同,但可由業務最後於生成訂單時修改 )
				pstmtDtl.setInt(11,Integer.parseInt(line_Type)); // Default Order Line Type
				pstmtDtl.setString(12,a[12][ac]); // Primary Unit of Measure
				pstmtDtl.setString(13,a[15][ac]); // Remark
				pstmtDtl.setString(14,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入日期
				pstmtDtl.setString(15,userID); //寫入User ID
				pstmtDtl.setString(16,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //最後更新日期
				pstmtDtl.setString(17,userID); //最後更新User
				pstmtDtl.setString(18,STATUSID); //Line Status ID
				pstmtDtl.setString(19,STATUSCODE); //Line Status Name
				pstmtDtl.setString(20,a[6][ac]); //台半品號
				pstmtDtl.setString(21,"0"); //最小包裝訂購量	 
				pstmtDtl.setString(22,a[2][ac]); //最小包裝訂購量
				pstmtDtl.setString(23,a[11][ac]); //ITEM生產地 
				pstmtDtl.setString(24,a[16][ac]); //LINE CUST_PO_NUMBER 
				pstmtDtl.setInt(25,Integer.parseInt(order_Type_ID)); //訂單類型id,add by Peggy 20120222
				pstmtDtl.setString(26,AUTOCREATE_FLAG); //自動生成訂單,add by Peggy 20120224
				pstmtDtl.setString(27,a[3][ac].toUpperCase()); //出貨方式,add by Peggy 20120224
				pstmtDtl.setString(28,"D4-002I"); //programg code,add by Peggy 20120308
				pstmtDtl.setString(29,a[17][ac]); //TSC_PROD_GROUP,add by Peggy 20120308
				pstmtDtl.setString(30,lineFob); //FOB,add by Peggy 20120329
				pstmtDtl.setString(31,""); //CUST PO LINE NO,add by Peggy 20120601
				pstmtDtl.setString(32,""); //QUOTE NUMBER,add by Peggy 20120917
				pstmtDtl.setString(33,a[23][ac]); //END CUSTOMER,add by Peggy 2040822
				//pstmtDtl.setString(34,orderItem);   //add by Peggy 20121112
				//pstmtDtl.setString(35,orderItemID); //add by Peggy 20121112
				pstmtDtl.setString(34,a[26][ac]);   //add by Peggy 20160929
				pstmtDtl.setString(35,a[25][ac]);   //add by Peggy 20160929
				pstmtDtl.setString(36,a[20][ac]);   //End Customer ID,add by Peggy 20140822
				//pstmtDtl.executeUpdate(); 
				pstmtDtl.executeQuery(); //modify by Peggy 20111202
				pstmtDtl.close();
				
				//add by Peggy 20130304,insert data to tsdelivery_notice_remarks table
				if (a[21][ac] != null && !a[21][ac].equals("&nbsp;") && a[22][ac] != null && !a[22][ac].equals("&nbsp;"))
				{
					PreparedStatement pstmtDt11=con.prepareStatement("insert into oraddman.tsdelivery_notice_remarks(dndocno, line_no, shipping_marks, remarks,creation_date, created_by, last_update_date,last_updated_by, customer) values(?,?,?,?,sysdate,?,sysdate,?,?)");  
					pstmtDt11.setString(1,seqno); 
					pstmtDt11.setInt(2,ac); // Line_No 
					pstmtDt11.setString(3, (a[21][ac].startsWith("&nbsp"))?null:a[21][ac].trim()); //SHIPPING MARKS,Add by Peggy 20130304
					pstmtDt11.setString(4, (a[22][ac].startsWith("&nbsp"))?null:a[22][ac].trim()); //REMARKS,Add by Peggy 20130304
					pstmtDt11.setString(5,UserName); //User
					pstmtDt11.setString(6,UserName);   //User
					pstmtDt11.setString(7, a[16][ac].substring(a[16][ac].indexOf("(")+1,a[16][ac].indexOf(")")));   //customer
					pstmtDt11.executeQuery();
				}
				
				lineCnt ++; //add by Peggy 20111202
			} //enf of for	
		}
		//add by Peggy 20111202
		if (lineCnt >0)
		{
			con.commit();
		}
		else
		{
			throw new Exception("No Detail Data!!");
		}
  	}  // End of if (a!=null) 
}
catch(Exception e)
{
	con.rollback();
	e.printStackTrace();
    out.println(e.getMessage());
    // 20110427 Marvie Add : error handle
    sError_Flag = "Y";
}
%>

</body>
</html>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
// 20110427 Marvie Add : error handle
if (sError_Flag == "N") 
{
	//response.sendRedirect("TSSalesDRQTemporaryPage.jsp?DNDOCNO="+seqno+"&LSTATUSID=001");
	response.sendRedirect("TSSalesDRQTemporaryPage.jsp?DNDOCNO="+seqno+"&LSTATUSID=001&PROGRAMNAME=D4-002I");  //新增PROGRAMNAME參數,add by Peggy 20170920
}
%>