<!-- 20160313 by Peggy,add sample order direct ship to cust flag-->
<!-- 20160517 by Peggy,簡稱不使用 Name Pronuncication ,改採用 Account Description-->
<!-- 20170512 by Peggy,add end cust ship to id-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ page import="java.util.*"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1(URL)
{
	document.MYFORM.save1.disabled=true;
	document.MYFORM.exit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到上頁功能嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TSCH Order Pass To RFQ</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
int rfq_cnt=0,tot_cnt=0,i=0,err_cnt=0;
String sql = "",salesAreaNo="018",shippingMarks="",remarks="",customerPO="",orderTypeID ="",customerID="",currency="",salesPersonID="",salesPerson="",err_msg="";
String bb[][] = null;
String cc[][] = null;
String HEADER_ID = request.getParameter("HEADER_ID");
if (HEADER_ID == null) HEADER_ID="";
if (HEADER_ID.equals("")) 
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("Header ID can not empty!");
		this.window.close();	
	</script>
<%
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCHOrderToRFQ.jsp" METHOD="post" NAME="MYFORM">
<BR>
<%
if (!HEADER_ID.equals(""))
{
	try
	{
		CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
		cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
		cs1.execute();
		cs1.close();
	
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();	

		sql = " SELECT 1  FROM oraddman.tsrecperson a  where USERNAME=? AND TSSALEAREANO=?";
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,UserName);
		statement1.setString(2,salesAreaNo);
		ResultSet rs1=statement1.executeQuery();
		if (!rs1.next())
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("您無此業務區權限,請重新確認,謝謝!");
				this.window.close();	
			</script>
		<%
		}  
		rs1.close();
		statement1.close();
				
		Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rss = null;
		
		sql = " SELECT TH.*"+
		      " ,CASE WHEN TH.QUANTITY <> TH.RFQ_QTY THEN '客戶只需'||(TH.QUANTITY)||'K' ELSE '' END AS RFQ_REMARK"+
              " FROM (SELECT A.HEADER_ID"+
              "      ,A.LINE_ID"+
              "      ,A.INVENTORY_ITEM_ID ITEM_ID"+
              "      ,E.SEGMENT1 ITEM_NAME"+
              "      ,E.DESCRIPTION ITEM_DESC"+
              "      ,A.UNIT_PRICE"+
              "      ,TO_CHAR(A.REQUEST_DATE,'yyyymmdd') REQUEST_DATE"+
              "      ,A.FACTORY_CODE"+
              "      ,A.SHIPPING_METHOD_CODE SHIPPING_METHOD"+
              "      ,J.lookup_code SHIPPING_METHOD_CODE"+
              "      ,A.FOB_POINT_CODE "+
              "      ,M.FOB"+
              "      ,A.FLOW_STATUS_CODE TSCH_ORDER_STATUS"+
              "      ,A.SUPPLY_ORG_ID "+
              "      ,A.SUPPLY_CUSTOMER_ID"+
              "      ,K.CUSTOMER_NUMBER SUPPLY_CUSTOMER_NUMBER"+
              "      ,K.CUSTOMER_NAME SUPPLY_CUSTOMER_NAME"+
              "      ,K.CUSTOMER_NAME_PHONETIC SUPPLY_CUSTOMER_NAME_PHONETIC"+
              "      ,nvl(B.CUST_PO_NUMBER,b.CUSTOMER_LINE_NUMBER) CUST_PO_NUMBER "+
              "      ,DECODE(B.ORDERED_ITEM_ID ,B.INVENTORY_ITEM_ID, null ,B.ORDERED_ITEM) ORDERED_ITEM"+
              "      ,CASE WHEN B.ORDERED_ITEM_ID =B.INVENTORY_ITEM_ID THEN 0 ELSE NVL(( SELECT x.ITEM_ID FROM oe_items_v x WHERE x.ITEM=B.ORDERED_ITEM AND x.INVENTORY_ITEM_ID=B.INVENTORY_ITEM_ID AND x.SOLD_TO_ORG_ID = A.SUPPLY_CUSTOMER_ID AND x.ITEM_STATUS='ACTIVE' AND x.CROSS_REF_STATUS='ACTIVE'),0) END AS  ORDERED_ITEM_ID"+
              "      ,D.CUSTOMER_ID TSCH_CUSTOMER_ID"+
              "      ,D.CUSTOMER_NUMBER TSCH_CUSTOMER_NUMBER"+
              "      ,D.CUSTOMER_NAME TSCH_CUSTOMER_NAME"+
			  //"      ,NVL(D.CUSTOMER_NAME_PHONETIC,D.CUSTOMER_NAME) CUSTOMER_NAME_PHONETIC"+
			  "      ,NVL(HCA.ACCOUNT_NAME,D.CUSTOMER_NAME) CUSTOMER_NAME_PHONETIC"+  //modify by Peggy 20160517
              "      ,C.SALESREP_ID"+
			  "      ,B.CUSTOMER_SHIPMENT_NUMBER CUST_PO_LINE_NO"+
              "      ,F.NAME SALESREP_NAME"+
              "      ,C.TRANSACTIONAL_CURR_CODE CURRENCY"+
              "      ,E.INVENTORY_ITEM_STATUS_CODE ITEM_STATUS"+
              "      ,G.ORDER_NUMBER SUPPLY_SO_NO"+
              //"      ,TSC_RFQ_CREATE_ERP_ODR_PKG.TSC_GET_ORDER_TYPE(A.FACTORY_CODE) AS ORDER_TYPE"+
			  "      ,TSC_RFQ_CREATE_ERP_ODR_PKG.TSC_GET_ORDER_TYPE(E.INVENTORY_ITEM_ID) AS ORDER_TYPE"+  //modify by Peggy 20191122
			  "      ,I.OTYPE_ID OTYPE_ID"+
			  "      ,I.DEFAULT_ORDER_LINE_TYPE LINE_TYPE"+
              "      ,A.QUANTITY/1000 QUANTITY"+
              "      ,A.SPQ/1000 SPQ"+
              "      ,A.MOQ/1000 MOQ"+
              "      ,A.SAMPLE_SPQ/1000 SAMPLE_SPQ"+
			  "      ,B.LINE_NUMBER||'.'||B.SHIPMENT_NUMBER LINE_NO"+
              //"      ,(CASE WHEN A.MOQ >0 THEN CASE WHEN A.QUANTITY <= A.MOQ THEN A.MOQ ELSE FLOOR(A.QUANTITY/A.MOQ)*A.MOQ+A.SPQ END ELSE A.QUANTITY END)/1000 AS RFQ_QTY"+
              "      ,(CASE WHEN A.MOQ >0 THEN CASE WHEN A.QUANTITY <= A.MOQ THEN A.MOQ ELSE CEIL(A.QUANTITY/A.SPQ)*A.SPQ END ELSE A.QUANTITY END)/1000 AS RFQ_QTY"+
			  "      ,TSC_ITEM_GREEN_CHECK(E.ORGANIZATION_ID,E.INVENTORY_ITEM_ID)  GREEN_FLAG"+
              "      ,CASE WHEN TRUNC(A.REQUEST_DATE) < TRUNC(SYSDATE)+7 THEN 'Y' ELSE 'N' END AS REQUEST_DATE_FLAG "+
              "      ,CASE WHEN A.FACTORY_CODE IS NULL OR A.FACTORY_CODE='' OR A.FACTORY_CODE NOT IN ('002','005','006','008','010','011') THEN 'Y' ELSE 'N' END AS FACTORY_CODE_FLAG"+
              "      ,COUNT(A.LINE_ID) OVER (PARTITION BY A.HEADER_ID ORDER BY A.LINE_ID DESC) LINE_SEQ"+
			  "      ,tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate)) pcn_flag"+  //add by Peggy 20230210
              "      FROM (SELECT toq.*"+
              "            ,NVL((select SPQ from table(tsc_get_item_spq_moq(toq.INVENTORY_ITEM_ID,'TS',toq.FACTORY_CODE))),0) AS SPQ"+
              "            ,NVL((select MOQ from table(tsc_get_item_spq_moq(toq.INVENTORY_ITEM_ID,'TS',toq.FACTORY_CODE))),0) AS MOQ"+
              "            ,NVL((select SAMPLE_SPQ from table(tsc_get_item_spq_moq(toq.INVENTORY_ITEM_ID,'TS',toq.FACTORY_CODE))),0) AS SAMPLE_SPQ"+
              "            FROM TSC_OM_REQUISITION toq "+
              "            WHERE HEADER_ID=? AND QUANTITY>0) A "+
              "     ,ONT.OE_ORDER_LINES_ALL B "+
              "     ,ONT.OE_ORDER_HEADERS_ALL C"+
              "     ,AR_CUSTOMERS D"+
			  "     ,HZ_CUST_ACCOUNTS HCA"+
              "     ,INV.MTL_SYSTEM_ITEMS_B E"+
              //"     ,(SELECT * FROM JTF_RS_SALESREPS WHERE STATUS='A' AND (END_DATE_ACTIVE IS NULL OR END_DATE_ACTIVE > TRUNC(SYSDATE))) F "+
			  "     ,(SELECT rs.SALESREP_ID,res.resource_name name FROM JTF_RS_SALESREPS rs, JTF_RS_RESOURCE_EXTNS_VL RES WHERE STATUS='A' and rs.resource_id = res.resource_id AND (res.END_DATE_ACTIVE IS NULL OR res.END_DATE_ACTIVE > TRUNC(SYSDATE))) F "+ 
              "     ,ONT.OE_ORDER_HEADERS_ALL G"+
              "     ,ONT.OE_ORDER_LINES_ALL H"+
			  "     ,(SELECT * FROM ORADDMAN.TSAREA_ORDERCLS WHERE SAREA_NO=?) I"+
			  "     ,(SELECT lookup_code,meaning FROM fnd_lookup_values lv WHERE language = 'US' AND view_application_id = 3 AND lookup_type = 'SHIP_METHOD' AND security_group_id = 0 AND ENABLED_FLAG='Y'  AND (end_date_active IS NULL OR end_date_active > SYSDATE)) J"+
			  "     ,AR_CUSTOMERS K"+
			  "     ,OE_FOBS_ACTIVE_V M"+
              "     WHERE A.ORG_ID=B.ORG_ID"+
              "     AND A.HEADER_ID=B.HEADER_ID "+
              "     AND A.LINE_ID=B.LINE_ID"+
              "     AND B.HEADER_ID=C.HEADER_ID"+
              "     AND B.ORG_ID=C.ORG_ID"+
              "     AND C.SOLD_TO_ORG_ID=D.CUSTOMER_ID "+
			  "     AND D.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID"+ //add by Peggy 20160517
              "     AND A.INVENTORY_ITEM_ID = E.INVENTORY_ITEM_ID"+
              "     AND E.ORGANIZATION_ID=?"+
              "     AND C.SALESREP_ID=F.SALESREP_ID(+)"+
              "     AND A.SUPPLY_ORG_ID=H.ORG_ID(+)"+
              "     AND A.SUPPLY_LINE_ID=H.LINE_ID(+)"+
              "     AND H.HEADER_ID=G.HEADER_ID(+)"+
              "     AND H.ORG_ID=G.ORG_ID(+)"+
			  "     AND A.SHIPPING_METHOD_CODE=J.meaning(+)"+
			  "     AND A.SUPPLY_CUSTOMER_ID=K.CUSTOMER_ID(+)"+
			  "     AND A.FOB_POINT_CODE = M.FOB_CODE(+)"+
			  //"     AND TSC_RFQ_CREATE_ERP_ODR_PKG.TSC_GET_ORDER_TYPE(A.FACTORY_CODE)=I.ORDER_NUM) TH "+
			  "     AND TSC_RFQ_CREATE_ERP_ODR_PKG.TSC_GET_ORDER_TYPE(E.INVENTORY_ITEM_ID)=I.ORDER_NUM) TH "+  //modify by Peggy 20191122
              "     ORDER BY HEADER_ID,LINE_SEQ DESC";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,HEADER_ID);
		statement.setString(2,salesAreaNo);
		statement.setInt(3,49);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{
			if (i==0)
			{
				String oneDArray[] = {"No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust Po Line No","Quote#","End Cust ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust PartNo"};
				arrayRFQDocumentInputBean.setArrayString(oneDArray);
				bb = new String[rs.getInt("line_seq")][oneDArray.length];
				cc = new String[rs.getInt("line_seq")][oneDArray.length];
				customerPO = rs.getString("CUST_PO_NUMBER");
				orderTypeID = rs.getString("OTYPE_ID");
				customerID = rs.getString("SUPPLY_CUSTOMER_ID");
				currency = rs.getString("CURRENCY");
				salesPersonID = rs.getString("SALESREP_ID");
				if (salesPersonID==null) salesPersonID="";
				salesPerson = rs.getString("SALESREP_NAME");
				if (salesPerson==null) salesPerson="";
				
				sql =" SELECT x.*"+
                     " FROM (SELECT a.CUSTOMER,a.ORDER_TYPE,a.SHIPPING_MARKS, a.REMARKS,ROW_NUMBER() OVER(PARTITION BY a.ORDER_TYPE ORDER BY CASE WHEN INSTR(a.CUSTOMER,'"+rs.getString("CUSTOMER_NAME_PHONETIC")+"')>0 THEN 1 ELSE 2 END) REC_SEQ"+
                     " FROM oraddman.tsc_om_remarks_setup a "+
                     " where TSAREANO='"+salesAreaNo+"'"+
                     //" AND USER_NAME ='"+UserName+"'"+
                     " AND ('"+(rs.getString("CUSTOMER_NAME_PHONETIC").startsWith("ARROW")?"ARROW HONG KONG":rs.getString("CUSTOMER_NAME_PHONETIC"))+"' LIKE CUSTOMER||'%' OR CUSTOMER='ALL')) x WHERE x.REC_SEQ =1";
				//out.println(sql);
				rss = statements.executeQuery(sql);					 
			}
			//out.println(sql);
			shippingMarks="";remarks="";err_msg="";
			if (!rs.getString("TSCH_ORDER_STATUS").equals("ENTERED"))
			{
				err_msg += " 轉單狀態必須為ENTERED<br>";
			}
			if (rs.getString("SUPPLY_SO_NO")!=null && !rs.getString("SUPPLY_SO_NO").equals(""))
			{
				err_msg += " 已轉TSC訂單:"+rs.getString("SUPPLY_SO_NO")+"<br>";
			}
			if (!rs.getString("ITEM_STATUS").toUpperCase().equals("ACTIVE") && !rs.getString("ITEM_STATUS").toUpperCase().equals("COND"))
			{
				err_msg += " 料號狀態不是可下單<br>";
			}
			if (rs.getString("PCN_FLAG").equals("Y")) //add by Peggy 20230210
			{
				err_msg += " 料號已IN/PCN/PD<br>";
			}			
			if (rs.getString("REQUEST_DATE_FLAG").equals("Y"))
			{
				err_msg += " Request Date必須大於系統日+7<br>";
			}	
			if (rs.getString("SHIPPING_METHOD_CODE")==null || rs.getString("SHIPPING_METHOD_CODE").equals(""))
			{
				err_msg += " 出貨方式不存在<br>";
			}
			if (rs.getString("FACTORY_CODE_FLAG").equals("Y"))
			{
				err_msg += " 工廠代碼錯誤<br>";
			}
			if (rs.getString("FOB")==null || rs.getString("FOB").equals(""))
			{
				err_msg += " FOB錯誤<br>";
			}
			if (rs.getString("ORDERED_ITEM") != null && !rs.getString("ORDERED_ITEM").equals("") && rs.getString("ORDERED_ITEM_ID").equals("0"))
			{
				err_msg += " 尚未建立客戶品號:"+rs.getString("ORDERED_ITEM")+"與台半品號:"+rs.getString("ITEM_DESC")+"關係<br>";
			}
			if (rs.getString("CUST_PO_NUMBER")==null || rs.getString("CUST_PO_NUMBER").equals(""))
			{
				err_msg += " CUSTOMER PO不可空白<br>";
			}
			
			if (!err_msg.equals(""))
			{
				if (err_cnt ==0)
				{
					out.println("<div style='font-size:13px;color:#0000FF'>資料異常,請參考下表Error Message欄位說明,謝謝!</div>");
					out.println("<table cellspacing='1' bordercolordark='#FFFFFF' cellpadding='1' width='100%' align='center' bordercolorlight='#64B077' border='1'>");
					out.println("<tr>");
					out.println("<td width='6%'  bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Line No</td>");
					out.println("<td width='8%' bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Order Status</td>");
					out.println("<td width='11%' bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>TSC Item Name</td>");
					out.println("<td width='10%' bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>TSC Item Desc</td>");
					out.println("<td width='5%' bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>tem Status</td>");
					out.println("<td width='10%' bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Customer Item</td>");
					out.println("<td width='3%'  bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Qty(K)</td>");
					out.println("<td width='6%'  bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Request Date</td>");
					out.println("<td width='10%'  bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Shipping Method</td>");
					out.println("<td width='6%'  bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>FOB</td>");
					out.println("<td width='5%'  bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Plant Code</td>");
					out.println("<td width='19%' bgcolor='#64B077' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Error Message</td>");
					out.println("</tr>");
				}
				out.println("<tr>");
				out.println("<td>"+rs.getString("LINE_NO")+"</td>");
				out.println("<td>"+rs.getString("TSCH_ORDER_STATUS")+"</td>");
				out.println("<td>"+rs.getString("ITEM_NAME")+"</td>");
				out.println("<td>"+rs.getString("ITEM_DESC")+"</td>");
				out.println("<td>"+rs.getString("ITEM_STATUS")+"</td>");
				out.println("<td>"+(rs.getString("ORDERED_ITEM")==null?"":rs.getString("ORDERED_ITEM"))+"</td>");
				out.println("<td>"+rs.getString("QUANTITY")+"</td>");
				out.println("<td>"+rs.getString("REQUEST_DATE")+"</td>");
				out.println("<td>"+rs.getString("SHIPPING_METHOD")+"</td>");
				out.println("<td>"+rs.getString("FOB_POINT_CODE")+"</td>");
				out.println("<td>"+rs.getString("FACTORY_CODE")+"</td>");
				out.println("<td style='color:#ff0000'>"+err_msg+"</td>");
				out.println("</tr>");
				err_cnt++;
			}
			else
			{
				if (rss.isBeforeFirst() ==false) rss.beforeFirst();
				while (rss.next())
				{	
					if (rss.getString("ORDER_TYPE").equals(rs.getString("ORDER_TYPE")))
					{
						shippingMarks= rss.getString("SHIPPING_MARKS");
						//shippingMarks = shippingMarks.replace("?01",rs.getString("CUSTOMER_NAME_PHONETIC"));
						shippingMarks = shippingMarks.replace("?01",(rs.getString("CUSTOMER_NAME_PHONETIC").startsWith("ARROW")?"ARROW HONG KONG":rs.getString("CUSTOMER_NAME_PHONETIC")));
						remarks = rss.getString("REMARKS");
						remarks = remarks.replace("?02",(rs.getString("GREEN_FLAG").equals("Y")?"green compound":""));
						break;
					}
				}
				bb[i][0]=""+(i+1);                                //序號
				bb[i][1]=rs.getString("ITEM_NAME");               //料號
				bb[i][2]=rs.getString("ITEM_DESC");               //品名
				bb[i][3]=rs.getString("RFQ_QTY");                 //數量
				bb[i][4]="KPC";                                   //數量單位
				bb[i][5]="";                                //CRD 
				bb[i][7]=rs.getString("REQUEST_DATE");            //業務需求日
				//ARTS,OSRAM ASIA,IN SHIN沒有customer po,add by Peggy 20160630
				if (!rs.getString("TSCH_CUSTOMER_NUMBER").equals("23075") && !rs.getString("TSCH_CUSTOMER_NUMBER").equals("23125") && !rs.getString("TSCH_CUSTOMER_NUMBER").equals("23174"))
				{
					bb[i][8]=rs.getString("CUST_PO_NUMBER")+"("+rs.getString("CUSTOMER_NAME_PHONETIC")+")";          //CUST PO
				}
				else
				{
					bb[i][8]=rs.getString("CUSTOMER_NAME_PHONETIC");
				}
				bb[i][9]=(rs.getString("RFQ_REMARK")==null?"":rs.getString("RFQ_REMARK"));              //REMARK
				bb[i][10]="N";                                    //SPQ CHECK
				bb[i][11]=rs.getString("SPQ");                    //SPQ
				bb[i][12]=rs.getString("MOQ");                    //MOQ
				bb[i][13]=rs.getString("FACTORY_CODE");           //工廠別
				bb[i][14]=(rs.getString("ORDERED_ITEM")==null?"":rs.getString("ORDERED_ITEM"));           //客戶品號 
				bb[i][15]=rs.getString("UNIT_PRICE");             //單價
				bb[i][16]=rs.getString("ORDER_TYPE");             //訂單類型
				bb[i][17]=rs.getString("LINE_TYPE");              //LINE TYPE
				if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("23080") || rs.getString("TSCH_CUSTOMER_NUMBER").equals("26851") || rs.getString("TSCH_CUSTOMER_NUMBER").equals("30032"))
				{
					if  (rs.getString("ORDER_TYPE").equals("1141")) //GE 23080,Future-HK 26851 1141 FOB=FOB TAIWAN,add by Peggy 20190109,add 30032 ENCSMLYSSDNBDH by Peggy 20210702
					{
						bb[i][18]="FOB TAIWAN";         //FOB  
					}
					else
					{
						bb[i][18]="FOB TIANJIN";         //FOB  
					}
					
					if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("23080"))
					{
						bb[i][6]="SEA";
					}
					else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("26851"))
					{
						if (rs.getString("ORDER_TYPE").equals("1141")) {
							bb[i][6] = "DHL";
						} else {
							bb[i][6] = "FEDEX ECNOMY";
						}
					}
					else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("30032")) //add by Peggy 20210702
					{
						bb[i][6]="DHL";
						if (rs.getString("ORDER_TYPE").equals("1156")) //add by Peggy 20211123
						{
							bb[i][18]="FOB CHINA";         
						}
					}
					else
					{
						bb[i][6]=rs.getString("SHIPPING_METHOD_CODE");    //出貨方式
					}
				}
				else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("26971")) //Conti Malaysia ,ADD BY PEGGY 20210623
				{
					bb[i][6]="DHL";
					//bb[i][18]=rs.getString("FOB_POINT_CODE");         //FOB 
					bb[i][18]="DAP  MALAYSIA";  //modify by Peggy 20220317
				}
				else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("31332")) //Conti Philippines ,ADD BY PEGGY 20220802
				{
					bb[i][6]="DHL";
					bb[i][18]="DAP PHILIPPINES";  
				}
				else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("33652")) //Conti Philippines ,ADD BY Mars 20241219
				{
					bb[i][6]="DHL";
					bb[i][18]="DAP PHILIPPINES";
				}
				else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("29612")) //Conti Singapore ,ADD BY Mars 20250310
				{
					bb[i][6]="DHL";
					bb[i][18]="DAP SINGAPORE";
				}
				else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("23121")) //LITE ON-2680 ,ADD BY Mars 20250603
				{
					bb[i][6]= "000001_TRUCK_R_P2P";    //出貨方式改為LAND
					bb[i][18]=rs.getString("FOB_POINT_CODE");         //FOB
				}
				else if (rs.getString("TSCH_CUSTOMER_NUMBER").equals("31912") || rs.getString("TSCH_CUSTOMER_NUMBER").equals("32932")) //GPV ,ADD BY PEGGY 20230406, GPV(THAILAND) add by Peggy 20240304
				{
					bb[i][6]="DHL";
					if  (rs.getString("ORDER_TYPE").equals("1141"))
					{
						bb[i][18]="FOB TAIWAN";  
					}
					else
					{
						bb[i][18]="FOB CHINA";  
					}
				}				
				else
				{
					bb[i][6]=rs.getString("SHIPPING_METHOD_CODE");    //出貨方式
					bb[i][18]=rs.getString("FOB_POINT_CODE");         //FOB  
				}
				bb[i][19]=(rs.getString("CUST_PO_LINE_NO")==null?"":rs.getString("CUST_PO_LINE_NO"));        //客戶訂單項次      
				bb[i][20]="";                               //Quote#     
				bb[i][21]=rs.getString("TSCH_CUSTOMER_NUMBER");   //End Customer Number    
				bb[i][22]=shippingMarks;   
				bb[i][23]=remarks;          
				bb[i][24]=rs.getString("CUSTOMER_NAME_PHONETIC"); //END CUSTOME NAME
				bb[i][25]=rs.getString("LINE_ID");                //TSCH LINE ID
				bb[i][26]="";                               //20160313 by Peggy
				bb[i][27]="";                               //20170301 by Peggy
				bb[i][28]="";                               //20170512 by Peggy
				bb[i][29]="";                               //20190313 by Peggy
				cc[i][0]=""+(i+1);
				cc[i][1]="D";
				cc[i][2]="D";
				cc[i][3]="U";
				cc[i][4]="U";
				cc[i][5]="D";
				cc[i][6]="D";
				cc[i][7]="U";
				cc[i][8]="U";
				cc[i][9]="U";
				cc[i][10]="P";
				cc[i][11]="P";
				cc[i][12]="P";
				cc[i][13]="D";
				cc[i][14]="D";
				cc[i][15]="D";
				cc[i][16]="D";
				cc[i][17]="D";
				cc[i][18]="D";
				cc[i][19]="D"; 
				cc[i][20]="D"; 
				cc[i][21]="D"; 
				cc[i][22]="T"; 
				cc[i][23]="T"; 
				cc[i][24]="D"; 
				cc[i][25]="D"; 
				cc[i][26]="D"; 
				cc[i][27]="D"; 
				cc[i][28]="D";
				cc[i][29]="D";
			}
			i++;
		}
		rss.close();
		statements.close();
		
		rs.close();
		statement.close();
		
		if (err_cnt>0)
		{
			out.println("</table><p><p>");
			out.println("<div align='center'>");
		%><A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHome"/></A><%out.println("</div>");	
		}
		else if (i >0)
		{
			rss.close();
			arrayRFQDocumentInputBean.setArray2DString(bb);
			arrayRFQDocumentInputBean.setArray2DCheck(cc);
			String urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(customerID)+
		                    "&SPQCHECKED=Y"+
		                    "&SALESAREANO="+java.net.URLEncoder.encode(salesAreaNo)+
		                    "&SALESPERSON="+java.net.URLEncoder.encode(salesPerson)+
							"&TOPERSONID="+java.net.URLEncoder.encode(salesPersonID)+
		                    "&CUSTOMERPO="+java.net.URLEncoder.encode(customerPO)+
		                    "&CURR="+java.net.URLEncoder.encode(currency)+
		                    "&PREORDERTYPE="+java.net.URLEncoder.encode(orderTypeID)+
                  		    "&CUSTOMERIDTMP="+java.net.URLEncoder.encode(customerID)+
		                    "&INSERT=Y"+
                 		    "&RFQTYPE=NORMAL"+
                   		    "&PROGRAMNAME=TSCH";
			//out.println(urlDir);
			response.sendRedirect(urlDir);
		}
	}
	catch(Exception e)
	{
		out.println("<font style='color:#ff0000;font-size:12px'>搜尋資料發生異常!!請洽系統管理人員,謝謝!"+e.getMessage()+"</font>");
	}
}
%>
<input type="hidden" name="HEADER_ID" value="<%=HEADER_ID%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

