<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="TSCCSHBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>TSCC-SH 1211 EXL訂單轉入s</title>
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
<FORM ACTION="TSCCSH1211ExcelUploadProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
try
{
	String ORDER[][]=TSCCSHBean.getArray2DContent();
	if (ORDER==null)
	{	
		throw new Exception("無資料可新增,請重新確認,謝謝!");
	}
	String CUSTOMER = request.getParameter("CUSTOMER");
	if (CUSTOMER==null || CUSTOMER.equals("--")) CUSTOMER="";
	String SHIPTO = request.getParameter("SHIPTO");
	if (SHIPTO==null) SHIPTO="";
	String SHIPADDRESS = request.getParameter("SHIPADDRESS");
	if (SHIPADDRESS==null) SHIPADDRESS="";
	String SHIPCOUNTRY = request.getParameter("SHIPCOUNTRY");
	if (SHIPCOUNTRY==null) SHIPCOUNTRY="";
	String BILLTO = request.getParameter("BILLTO");
	if (BILLTO==null) BILLTO="";
	String BILLADDRESS = request.getParameter("BILLADDRESS");
	if (BILLADDRESS==null) BILLADDRESS="";
	String BILLCOUNTRY = request.getParameter("BILLCOUNTRY");
	if (BILLCOUNTRY==null) BILLCOUNTRY="";
	String CURRENCY = request.getParameter("CURRENCY");
	if (CURRENCY==null) CURRENCY="";
	String PRICELISTID = request.getParameter("PRICELISTID");
	if (PRICELISTID==null) PRICELISTID="";
	String PRICELIST = request.getParameter("PRICELIST");
	if (PRICELIST==null) PRICELIST="";
	String FOBPOINT = request.getParameter("FOBPOINT");
	if (FOBPOINT==null) FOBPOINT="";
	String PAYMENTTERMID = request.getParameter("PAYMENTTERMID");
	if (PAYMENTTERMID==null) PAYMENTTERMID="";
	String PAYMENTTERM = request.getParameter("PAYMENTTERM");
	if (PAYMENTTERM==null) PAYMENTTERM="";
	String TAXCODE = request.getParameter("TAXCODE");
	if (TAXCODE==null) TAXCODE="";
	String SHIPTOCONTACTID = request.getParameter("SHIPTOCONTACTID");
	if (SHIPTOCONTACTID==null) SHIPTOCONTACTID="";
	String SHIPTOCONTACT = request.getParameter("SHIPTOCONTACT");
	if (SHIPTOCONTACT==null) SHIPTOCONTACT="";
	String PackingListNumber = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();
	Hashtable hashtb = new Hashtable();
	int LineNO=0;
	 			
	for( int i=0 ; i < ORDER.length ; i++ ) 
	{
		if ((String)hashtb.get(ORDER[i][2]+PackingListNumber)==null)
		{
			LineNO =1;
			sql = "Insert into TSC_OE_AUTO_HEADERS " + 
			      "(CUSTOMERPO"+              //1
			      ",C_DATE"+                  //2
			      ",CUSTOMERNAME"+            //3
			      ",SHIPMENTTERMS"+           //4
			      ",SHIPTOID"+                //5
			      ",BILLTOID"+                //6
			      ",COMMENTS"+                //7
			      ",SALESPERSON"+             //8
			      ",STATUS"+                  //9
			      ",PACKINGLISTNUMBER"+       //10
			      ",CREATED_BY"+              //11
			      ",CREATION_DATE"+           //12
			      ",CURRENCY"+                //13 
			      ",CUSTOMERID"+              //14
			      ",ORDER_TYPE_ID"+           //15
			      ",PAYTERM_ID"+              //16
			      ",PRICE_LIST"+              //17
			      ",CUSTOMERNUMBER"+          //18
			      ",ID"+                      //19
			      ",SALES_REGION" +           //20
			      ",ORIG_CUSTOMER_ID"+        //21
			      ",ORIG_SHIPTOID"+           //22
			      ",ORIG_BILLTOID"+           //23
				  ",SHIP_TO_CONTACT_ID"+      //24
				  ",TAX_CODE"+                //25
			      ")"+ 
			      " SELECT "+
				  " ?"+                       //1
				  ",to_char(trunc(sysdate),'yyyy/mm/dd')"+   //2
				  ",CUSTOMER_NAME"+                          //3
				  ",?"+                       //4
				  ",?"+                       //5
				  ",?"+                       //6
				  ",?"+                       //7
				  ",?"+                       //8
				  ",?"+                       //9
				  ",?"+                       //10
				  ",?"+                       //11
				  ",to_char(trunc(sysdate),'yyyy/mm/dd')"+   //12
				  ",?"+                       //13
				  ",CUSTOMER_ID"+             //14
				  ",?"+                       //15
				  ",?"+                       //16
				  ",?"+                       //17
				  ",CUSTOMER_ID"+             //18
				  ",?"+                       //19
				  ",?"+                       //20
				  ",CUSTOMER_ID"+             //21
				  ",?"+                       //22
				  ",?"+                       //23
				  ",?"+                       //24
				  ",?"+                       //25
				  " FROM ar_customers where customer_id="+CUSTOMER+"";
			PreparedStatement pstmtDtl=con.prepareStatement(sql);  
			pstmtDtl.setString(1,ORDER[i][2]); 
			pstmtDtl.setString(2,FOBPOINT); 
			pstmtDtl.setString(3,SHIPTO); 
			pstmtDtl.setString(4,BILLTO); 
			pstmtDtl.setString(5,""); 
			pstmtDtl.setString(6,""); 
			pstmtDtl.setString(7,"OPEN"); 
			pstmtDtl.setString(8,PackingListNumber); 
			pstmtDtl.setString(9,UserName); 
			pstmtDtl.setString(10,CURRENCY); 
			pstmtDtl.setString(11,"1091"); 
			pstmtDtl.setString(12,PAYMENTTERMID); 
			pstmtDtl.setString(13,PRICELISTID); 
			pstmtDtl.setString(14,ORDER[i][2]+PackingListNumber); 
			pstmtDtl.setString(15,"TSCC-SH"); 
			pstmtDtl.setString(16,SHIPTO); 
			pstmtDtl.setString(17,BILLTO); 
			pstmtDtl.setString(18,SHIPTOCONTACTID); 
			pstmtDtl.setString(19,TAXCODE); 
			pstmtDtl.executeQuery();
			pstmtDtl.close();
		}
		else
		{
			LineNO = Integer.parseInt((String)hashtb.get(ORDER[i][2]+PackingListNumber))+1;
		}
		hashtb.put(ORDER[i][2]+PackingListNumber,""+LineNO);
	
		sql =  "Insert into TSC_OE_AUTO_LINES " + 
			   "(CUSTOMERPO"+                 //1
			   ",LINE_NO"+                    //2    
			   ",ITEM_DESCRIPTION"+           //3
			   ",INVENTORY_ITEM_ID"+          //4
			   ",CUSTOMERPRODUCTNUMBER"+      //5
			   ",LINE_TYPE"+                  //6
			   ",SHIP_DATE"+                  //7
			   ",LIST_PRICE"+                 //8
			   ",SELLING_PRICE"+              //9
			   ",UOM"+                        //10 
			   ",QUANTITY"+                   //11
			   ",CURRENCY"+                   //12
			   ",AMOUNT"+                     //13
			   ",PACKINGLISTNUMBER"+          //14
			   ",CARTONNUMBER"+               //15
			   ",AWB"+                        //16
			   ",SHIPPING_INSTRUCTIONS"+      //17
			   ",OR_LINENO"+                  //18
			   ",CREATED_BY"+                 //19
			   ",CREATION_DATE"+              //20
			   ",LAST_UPDATE_DATE"+           //21
			   ",LAST_UPDATED_BY"+            //22 
			   ",INVENTORY_ITEM"+             //23
			   ",ITEM_IDENTIFIER_TYPE"+       //24
			   ",CUSTOMERPRODUCT_ID"+         //25
			   ",ID"+                         //26
			   ",ORIG_ITEM_DESCRIPTION"+      //27
			   ")"+ 
			   " VALUES "+
			   "(?"+            //1
			   ",?"+            //2
			   ",?"+            //3
			   ",?"+            //4
			   ",?"+            //5
			   ",?"+            //6
			   //",to_char(to_date(?,'yyyy-mm-dd'),'yyyy/mm/dd')"+      //7
			   ",?"+            //7
			   ",?"+            //8
			   ",?"+            //9
			   ",?"+            //10
			   ",?"+            //11
			   ",?"+            //12
			   ",?"+            //13
			   ",?"+            //14
			   ",?"+            //15
			   ",?"+            //16
			   ",?"+            //17
			   ",?"+            //18
			   ",?"+            //19
			   ",to_char(trunc(sysdate),'yyyy/mm/dd')"+            //20
			   ",to_char(trunc(sysdate),'yyyy/mm/dd')"+            //21 
			   ",?"+            //22
			   ",?"+            //23
			   ",?"+            //24
			   ",?"+            //25
			   ",?"+            //26
			   ",?)";           //27
		PreparedStatement pstmtDtl=con.prepareStatement(sql); 
		pstmtDtl.setString(1,ORDER[i][2]); 
		pstmtDtl.setString(2,""+LineNO); 
		pstmtDtl.setString(3,ORDER[i][4]); 
		pstmtDtl.setString(4,ORDER[i][10]); 
		pstmtDtl.setString(5,ORDER[i][3]); 
		pstmtDtl.setString(6,"1007"); 
		pstmtDtl.setString(7,ORDER[i][1]); 
		pstmtDtl.setString(8,ORDER[i][7]); 
		pstmtDtl.setString(9,ORDER[i][7]); 
		pstmtDtl.setString(10,"PCE"); 
		pstmtDtl.setString(11,ORDER[i][6]); 
		pstmtDtl.setString(12,CURRENCY); 
		pstmtDtl.setString(13,ORDER[i][8]); 
		pstmtDtl.setString(14,PackingListNumber); 
		pstmtDtl.setString(15,"0"); 
		pstmtDtl.setString(16,""); 
		pstmtDtl.setString(17,ORDER[i][0]); 
		pstmtDtl.setString(18,""); 
		pstmtDtl.setString(19,UserName); 
		pstmtDtl.setString(20,UserName); 
		pstmtDtl.setString(21,ORDER[i][5]); 
		pstmtDtl.setString(22,ORDER[i][12]); 
		pstmtDtl.setString(23,ORDER[i][11]); 
		pstmtDtl.setString(24,ORDER[i][2]+PackingListNumber); 
		pstmtDtl.setString(25,ORDER[i][4]); 
		pstmtDtl.executeQuery();
		pstmtDtl.close();
	}
	TSCCSHBean.setArray2DString(null); 	
	con.commit();
	
	sql = "SELECT distinct ERP_USER_ID USER_ID FROM ORADDMAN.WSUSER WHERE USERNAME = '"+UserName+"'";
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sql);
	String user_ID="";
	while(rs.next())
	{
		user_ID = rs.getString("USER_ID") ;
	}
	rs.close();   
	st.close(); 

	CallableStatement cs3 = con.prepareCall("{call TSC_OM_SO_CREATE_B(?,?,?,?,?,?)}");			 
	cs3.registerOutParameter(1, Types.VARCHAR);  // Errbuf
	cs3.registerOutParameter(2, Types.VARCHAR);  // Retcode
	cs3.setString(3, PackingListNumber);                     // Key ID
	cs3.setInt(4,Integer.parseInt(user_ID));     // User ID
	cs3.registerOutParameter(5, Types.VARCHAR);  // status
	cs3.registerOutParameter(6, Types.VARCHAR);  // order number
	cs3.execute();
	String processStatus = cs3.getString(5);
	String orderNo = cs3.getString(6);
	String errorMessage = cs3.getString(1);
	cs3.close();
	if (processStatus==null) processStatus="";
	if (processStatus.equals("S"))
	{
	%>
		<div align="center" style="font-weight:bold;color:#0000FF;font-size:16px;font-family:Tahoma,Georgia"> 動作成功!!</div>
		<br>
		<div align="center" style="font-weight:bold;color:#0000FF;font-size:16px;font-family:Tahoma,Georgia"><font color="#000000">ERP訂單號碼：</font><%=orderNo%></div>
		<br>
		<br>
	<%
	}
	else
	{
	%>
		<div align="center" style="color:#FF0000;font-size:16px;font-family:Tahoma,Georgia"> 動作失敗!!</div>
		<div align="center" style="color:#FF0000;font-size:12px;font-family:Tahoma,Georgia"> 異常原因:<%=errorMessage%></div>
		<br>
		<br>
	<%
	}
	%>
	<div align="center" style="color:#0000FF;font-size:12px;font-family:Tahoma,Georgia"><a href='TSCCSH1211ExcelUpload.jsp'>回 TSCC-SH 1211訂單轉入功能</a></div>	
<%
}
catch(Exception e)
{	
	con.rollback();
	TSCCSHBean.setArray2DString(null); 
	out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+(UserName.toUpperCase().equals("PEGGY_CHEN")?"("+sql+")":"")+"<br><br></font><font color='blue'><a href='TSCCSH1211ExcelUpload.jsp'>回 TSCC-SH 1211訂單轉入功能</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

