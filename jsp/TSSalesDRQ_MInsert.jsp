<!-- 20140811 by Peggy ,INSERT TSDELIVERY_NOTICE_DETAIL.END_CUSTOMER_ID-->
<!-- 20141007 by Peggy ,slow moving check pass to D1-010(STATUS CODE=014)-->
<!-- 20150114 by Peggy,Lead Time reason insert-->
<!-- 20150409 by Peggy,check Arrow End customer item-->
<!-- 20150515 by Peggy,add column "tsch orderl line id" for tsch case-->
<!-- 20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!-- 20160219 by Peggy,上海內銷012 end customer設為必填-->
<!-- 20160308 by Peggy,for sample order add direct_ship_to_cust column-->
<!-- 20160707 by Peggy,HK S1M R2詢YEW條件取消-->
<!-- 20170216 by Peggy,add sales region for bi-->
<!-- 20170511 by Peggy,add end cust ship to id-->
<!-- 20170714 by Peggy,元利,茂荃,MUSTARD於備註欄標示產品有效須為一年以上-->
<!-- 20171221 by Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<!-- 20190225 by Peggy,add End customer part name-->
<%@ page language="java" import="java.sql.*,java.util.*" %>
<html>
<head>
<title>Sales Delivery Request Data Insert</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function alertRFQNotSuccess(msRFQCreateMsg)
{
   alert(msRFQCreateMsg);
}

function insertSuccess(url) {
	if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")")) {
		document.location.href = url;
	}
}

function insertFail(url) {
	if (confirm("Insert Fail!!")) {
		document.location.href = url;
	}
}

</script>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean,SendMailBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>
<body>
<FORM METHOD="post" NAME="MYFORM">
<%
//out.println("<BR>1<BR>");
try
{
	String serverHostName=request.getServerName();
  	String mailHost=application.getInitParameter("MAIL_HOST"); //Serverweb.xmlXmail serverhost name
  	String sProgramName=request.getParameter("PROGRAMNAME");
  	if (sProgramName==null || sProgramName.equals("")) sProgramName="";
  	String docNo=request.getParameter("DOCNO"); 
  	String customerId=request.getParameter("CUSTOMERID");
  	String salesAreaNo=request.getParameter("SALESAREANO"); 
  	String salesPersonID=request.getParameter("SALESPERSONID"); 
  	String customerPO=request.getParameter("CUSTOMERPO");
  	customerPO = customerPO.trim();  //add by Peggychen 20110610
  	String receptDate=request.getParameter("RECEPTDATE");
  	String curr=request.getParameter("CURR"); 
  	String remark=request.getParameter("REMARK");
  	String requireReason=request.getParameter("REQUIREREASON"); 
  	String preOrderType=request.getParameter("PREORDERTYPE"); 
	String preOrderTypeCode=""; //ADD BY PEGGY 20210802
  	String salesPerson=request.getParameter("SALESPERSON"); 
  	String toPersonID=request.getParameter("TOPERSONID"); 
  	String modelN = request.getParameter("modelN");
  	String groupByType = request.getParameter("groupByType");
	String detailJsp ="../jsp/TSCModelNDetail.jsp?requestSalesNo=" + salesAreaNo;
	String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//oثe}Ce
   	//if (a!=null) 
   	//{
    //	for (int ac=0;ac<a.length;ac++)
	// 	{    	        
    //    	for (int subac=1;subac<a[ac].length;subac++)
	//     	{
	//			if (request.getParameter("MONTH"+ac+"-"+subac)!=null && request.getParameter("MONTH"+ac+"-"+subac).trim()!="")
	//	      	{
	//	    		a[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
	//			}
	//	   	}
	// 	} 
   	//  	arrayRFQDocumentInputBean.setArray2DString(a);
   	//} 
  	String seqno=null;
  	String seqkey=null;
  	String dateString=null;
  	String formID=request.getParameter("FORMID");
  	String typeNo=request.getParameter("TYPENO");
  	String fromStatusID=request.getParameter("FROMSTATUSID");
  	String actionID=request.getParameter("ACTIONID");
  	String recPersonID=userID;
  	String custAROverdue=request.getParameter("CUSTOMERAROVERDUE");
  	String sourceInput=request.getParameter("SOURCEINPUT");
  	String sampleOrder=request.getParameter("SORDERCHECK");  
 	String sampleCharge=request.getParameter("SAMPLECHARGE");
  	String tscProdGroup="";
	String strRes="";
	String autoCreate_Flag="";  //add by Peggy 20120301
	String orderTypeId="";      //add by Peggy 20120301
	String orderType="";        //add by Peggy 20120301
	String rfqType = request.getParameter("RFQTYPE");    //add by Peggy 20120305
	String custItemID="";       //add by Peggy 20120306
	String custItemType = "";   //add by Peggy 20120306
	if (rfqType==null) rfqType="";
	
  	if (receptDate==null || receptDate.equals("")) receptDate=dateBean.getYearMonthDay();
  	if (curr==null || curr.equals("")) curr="";
  	if (remark==null || remark.equals("")) remark="";
  	if (customerPO==null || customerPO.equals("")) customerPO="";
  	if (typeNo==null || typeNo.equals("")) typeNo="001"; // Ȯɥ߰ݳ, w] "001"
  	if (preOrderType==null || preOrderType.equals("--")) preOrderType="0";
  
  	if (sourceInput==null) sourceInput = "01";
  
  	//out.println("sampleOrder ="+sampleOrder);
  	if (sampleOrder==null || sampleOrder.equals("") || sampleOrder.equals("null")) 
  	{ 
		sampleOrder = "N"; 
	}
  	else if (sampleOrder.equals("on") ) 
	{ 
		sampleOrder = "Y"; 
	}
  
  	if (sampleCharge==null || sampleCharge.equals("")) sampleCharge="";

  	String customer="";
	String defaultLineType="";
	String otherJamDesc=request.getParameter("OTHERJAMDESC");
   	int RepTimes=0;
	String agentNo=request.getParameter("AGENTNO"); //gP/Nzӽs
	String recType=request.getParameter("RECTYPE"); //ӷA
	String qty=request.getParameter("QTY"); //ƶq
	String fromPage=request.getParameter("FROMPAGE");
	String repeatInput=request.getParameter("REPEATINPUT");
	String computeSSD="N";
	String custMarketGroup =""; //add by Peggy 20120303	
	String priceList = request.getParameter("FIRMPRICELIST"); //modify by Peggy 20120301
	String shipToOrg = request.getParameter("SHIPTOORG"); //modify by Peggy 20120301
	String shipMethod = request.getParameter("SHIPVIA"); //modify by Peggy 20120312
	String fobPoint = request.getParameter("FOBPOINT"); //modify by Peggy 20120301
	String payTermID = request.getParameter("PAYTERMID"); //modify by Peggy 20120301
	String billTo = request.getParameter("BILLTO"); //modify by Peggy 20120301
	String stepNo = "";
	String deliveryToOrg = request.getParameter("DELIVERYTO");        //add by Peggy 20130220
	if (deliveryToOrg==null || deliveryToOrg.equals("")) deliveryToOrg="0";
	String shipToContactID = request.getParameter("SHIPTOCONTACTID"); //add by Peggy 20130220
	if (shipToContactID==null || shipToContactID.equals("")) shipToContactID="0";
	String taxCode = request.getParameter("TAXCODE");  //add by Peggy 201304011
	if (taxCode==null) taxCode="";  
	int ipendingcnt =0;  //add by Peggy 20140122 
	String END_CUST_SHORT_NAME ="";  //add by Peggy 20140811
	String tscdesc=""; //add by Peggy 20141007
	boolean slowmoving_flag = false; //add by Peggy 20141007
	String pc_lead_time ="";         //add by Peggy 20150114
	String end_cust_id ="";          //add by Peggy 20150518
	String end_cust_ship_to =null;   //add by Peggy 20160219
	String UPLOAD_TEMP_ID = request.getParameter("UPLOAD_TEMP_ID");
	if (UPLOAD_TEMP_ID==null) UPLOAD_TEMP_ID="";  //add by Peggy 20160309
	String sql_e="";
	String line_remarks ="";  //add by Pegy 20170714
	String SUPPLIER_NUMBER=request.getParameter("SUPPLIER_NUMBER"); //add by Peggy 20220428
	if (SUPPLIER_NUMBER==null) SUPPLIER_NUMBER="";
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
	
  	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	cs1.setString(1,userParOrgID);  // ~ȭParOrgID
  	cs1.execute();
  	cs1.close();
	
	//add by Peggy 20140827
	String sqlk = "	SELECT distinct c.customer_id,c.customer_number"+
				  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
				  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+salesAreaNo+"') d"+
				  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
				  " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
				  " and a.STATUS = b.STATUS "+
				  " and a.ORG_ID = b.ORG_ID "+										
				  //" and a.ORG_ID = d.PAR_ORG_ID"+
				  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
				  " and c.STATUS='A'"+
				  " order by c.customer_id";
	Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rss = statements.executeQuery(sqlk);
			
	//add by Peggy 20141007
	/*String sqlh = " SELECT  a.area"+
                  ",a.inventory_item_id"+
                  ",a.item_name"+
                  ",a.item_desc"+
                  ",a.date_code"+
                  ",(a.idle_qty/1000) idle_qty"+
                  ",a.sales"+
                  ",a.customer"+
                  ",a.remarks"+
                  ",a.item_desc1"+
                  ",a.seq_no"+
                  ",tsc_om_category(a.inventory_item_id,49,'TSC_PROD_GROUP') tsc_prod_group"+
                  " FROM oraddman.tsc_idle_stock_detail a"+
                  " where exists (select 1 from (select VERSION_ID from oraddman.tsc_idle_stock_header  where VERSION_FLAG='A' order by UPDATE_DATE desc) b where rownum=1 and b.version_id=a.version_id)";*/
	String sqlh = " SELECT  a.area"+
                  ",a.inventory_item_id"+
                  ",a.item_name"+
                  ",a.item_desc"+
                  ",a.date_code"+
                  ",(a.idle_qty/1000) idle_qty"+
                  ",a.sales"+
                  ",a.customer"+
                  ",a.remarks"+
                  ",a.item_desc1"+
                  ",a.seq_no"+
                  ",tsc_inv_category(a.inventory_item_id,49,1100000003) tsc_prod_group"+
                  ",b.row_seq"+
                  " FROM oraddman.tsc_idle_stock_detail a,(select x.*,row_number() over (partition by x.VERSION_FLAG order by x.UPDATE_DATE  desc ) row_seq from oraddman.tsc_idle_stock_header x where x.VERSION_FLAG='A' )  b "+
                  " where a.version_id=b.version_id"+
                  " and b.row_seq=1";
	Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rsh = statementh.executeQuery(sqlh);

	try
	{  
   		if (docNo==null || docNo.equals(""))
   		{  
    		dateString=dateBean.getYearMonthDay();
    		seqkey="TS"+salesAreaNo+dateString; // 2006/01/10 Hܪ~ȦaϥNͳ渹
    		Statement statement=con.createStatement();
    		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
  
    		if (rs.next()==false)
    		{   
     			String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";   
     			PreparedStatement seqstmt=con.prepareStatement(seqSql);     
     			seqstmt.setString(1,seqkey);
     			seqstmt.setInt(2,1);   
     			seqstmt.executeUpdate();
     			seqno=seqkey+"-001";
     			seqstmt.close();   
    		} 
    		else 
    		{
     			int lastno=rs.getInt("LASTNO");
     			String sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"'"+
				" and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
			     ResultSet rs2=statement.executeQuery(sql); 
     			if (rs2.next())
     			{         
       				lastno++;
       				String numberString = Integer.toString(lastno);
       				String lastSeqNumber="000"+numberString;
       				lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
       				seqno=seqkey+"-"+lastSeqNumber;     
   
       				String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
       				PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       				seqstmt.setInt(1,lastno);   
	
       				seqstmt.executeUpdate();   
       				seqstmt.close(); 
     			} 
     			else
     			{
       				String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE "+
					" where substr(DNDOCNO,1,13)='"+seqkey+"' ";
       				ResultSet rs3=statement.executeQuery(sSql);
	   				
					if (rs3.next()==true)
	   				{
        				int lastno_r=rs3.getInt("LASTNO");
	    				lastno_r++;
	  
	    				String numberString_r = Integer.toString(lastno_r);
        				String lastSeqNumber_r="000"+numberString_r;
        				lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
        				seqno=seqkey+"-"+lastSeqNumber_r;  
	 
	    				String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
        				PreparedStatement seqstmt=con.prepareStatement(seqSql);        
        				seqstmt.setInt(1,lastno_r);   
	
        				seqstmt.executeUpdate();   
        				seqstmt.close();  
	   				}  // End of if (rs3.next()==true)
      			} // End of Else  //===========(BzD)
     		} // End of Else    
	 		docNo = seqno; // 쪺XJ
   		} // End of if (docNo==null || docNo.equals(""))	
   		else 
		{
		   seqno = docNo;
        }	
  
  		Statement getStatusStat=con.createStatement();  
  		ResultSet getStatusRs=getStatusStat.executeQuery("select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFSTATUS x2 "+
		" WHERE FORMID='"+formID+"' AND TYPENO='"+typeNo+"' AND FROMSTATUSID='"+fromStatusID+"' "+
		" AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'");  
  		getStatusRs.next();

	  	//w]qLine Type
   		Statement stateLType=con.createStatement();
   		String sqlOrgInf = "select a.DEFAULT_ORDER_LINE_TYPE "+
		              "from ORADDMAN.TSAREA_ORDERCLS a, APPS.OE_TRANSACTION_TYPES_V b "+
			          "where a.DEFAULT_ORDER_LINE_TYPE=b.TRANSACTION_TYPE_ID and to_char(a.OTYPE_ID) = '"+preOrderType+"' "+
					  "and a.SAREA_NO = '"+userActCenterNo+"' and a.ACTIVE ='Y' ";
   		ResultSet rsLType=stateLType.executeQuery(sqlOrgInf);
   		if (rsLType.next())
   		{
     		defaultLineType = rsLType.getString("DEFAULT_ORDER_LINE_TYPE");
   		} 
   		else 
		{ 
			defaultLineType ="0"; 
		} //Y OrderType䤣Line Type hw] "0"
   		rsLType.close();
   		stateLType.close();
  //
  		if (sampleOrder.equals("Y")) //P_˫~q,BO,]Ship Only LineType__
  		{
    		if (sampleCharge.equals("") || sampleCharge.equals("N"))
			{
	  			if (preOrderType.equals("1022")) 
	  			{
	     			defaultLineType = "1013"; // Standard Order Ship Only LineType
	  			} 
				else if (preOrderType.equals("1154")) 
	         	{  
			   		defaultLineType = "1161";  // Drop Ship Ship Only LineType
			 	}
			}
  		} 
  
  		//add by Peggy 20120305
  	    if (rfqType.equals("NORMAL"))
		{
			Statement stateflag=con.createStatement();
			String sqlflag = "select a.autocreate_flag "+
						  " from oraddman.tssales_area a "+
						  " where a.sales_area_no= '"+salesAreaNo+"' ";
			ResultSet rsflag=stateflag.executeQuery(sqlflag);
			if (rsflag.next())
			{
				autoCreate_Flag = rsflag.getString("autocreate_flag");
			} 
			else 
			{ 
				autoCreate_Flag ="N"; 
			}
			rsflag.close();
			stateflag.close();  
		}
		else
		{
			autoCreate_Flag ="N"; 
		}
		
  		//add by Peggy 20120303
		Statement stateA=con.createStatement();
		ResultSet rsA=stateA.executeQuery("select  c.ATTRIBUTE2 market_group from APPS.AR_CUSTOMERS c where  c.CUSTOMER_ID='"+customerId+"'"); 
		if (rsA.next())
		{
			custMarketGroup =  rsA.getString("market_group");
		}
		rsA.close();
		stateA.close();  
		 
		//modify by Peggy 20120303 從line移到header		
		Statement statementc=con.createStatement();
		ResultSet rsx=statementc.executeQuery("select SSD_FLAG from ORADDMAN.TSSALES_AREA where SALES_AREA_NO='"+salesAreaNo+"'");  
		if (rsx.next())
		{
			computeSSD=rsx.getString("SSD_FLAG");  //add by Peggychen 20110621
		}
		rsx.close();
		statementc.close();		

  		Statement stateCustInfo=con.createStatement();
  		String sqlCustInfo =  "select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1,  "+		
				               "a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION "+  
							   "from AR_SITE_USES_V a,RA_ADDRESSES_ALL b, RA_TERMS_VL c "+  
							   "where a.ADDRESS_ID = b.ADDRESS_ID and a.STATUS=b.STATUS and a.STATUS='A' and a.PAYMENT_TERM_ID = c.TERM_ID(+) "+		
							   "and a.PRIMARY_FLAG='Y' and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL "+		
							                                                "where CUST_ACCOUNT_ID ='"+customerId+"') "+
							   "and a.SITE_USE_CODE <> 'DELIVER_TO' "+
							   "order by a.SITE_USE_CODE DESC";
							   
  		ResultSet rsCustInfo=stateCustInfo.executeQuery(sqlCustInfo);	
  		while (rsCustInfo.next())		
  		{
        	if (rsCustInfo.getString("SITE_USE_CODE")=="SHIP_TO" || rsCustInfo.getString("SITE_USE_CODE").equals("SHIP_TO"))
		 	{ 
		  		if (priceList==null || priceList.equals("")) priceList=rsCustInfo.getString("PRICE_LIST_ID");
		  		if (shipToOrg==null || shipToOrg.equals("")) shipToOrg=rsCustInfo.getString("SITE_USE_ID");		
		  		if (shipMethod==null || shipMethod.equals("")) shipMethod=rsCustInfo.getString("SHIP_VIA");
		  		if (fobPoint==null || fobPoint.equals("")) fobPoint=rsCustInfo.getString("FOB_POINT");			 
		  		if (payTermID==null || payTermID.equals("")) payTermID=rsCustInfo.getString("PAYMENT_TERM_ID");
		 	}
		 	if (rsCustInfo.getString("SITE_USE_CODE")=="BILL_TO" || rsCustInfo.getString("SITE_USE_CODE").equals("BILL_TO"))
		 	{  
		    	if (billTo==null || billTo.equals("")) billTo=rsCustInfo.getString("SITE_USE_ID");			
				if (priceList==null || priceList=="0") priceList=rsCustInfo.getString("PRICE_LIST_ID");			
				if (payTermID==null || payTermID=="0") payTermID=rsCustInfo.getString("PAYMENT_TERM_ID"); 			
		 	} 
			//add by Peggy 20130220
        	if (rsCustInfo.getString("SITE_USE_CODE")=="DELIVER_TO" || rsCustInfo.getString("SITE_USE_CODE").equals("DELIVER_TO"))
		 	{ 
		  		if (deliveryToOrg==null || deliveryToOrg.equals("")) deliveryToOrg=rsCustInfo.getString("SITE_USE_ID");		
			}
  		} // End of while
  		rsCustInfo.close();
  		stateCustInfo.close();		
  		if (priceList==null || priceList.equals("")) priceList = "0";
  		if (shipToOrg==null || shipToOrg.equals("")) shipToOrg = "0";
  		if (payTermID==null || payTermID.equals("")) payTermID = "0";
  		if (billTo==null || billTo.equals("")) billTo = "0";
  		if (deliveryToOrg==null || deliveryToOrg.equals("")) deliveryToOrg = "0";  //add by Peggy 20130220

		 //CUSTOMER Y TSCA,TSCK,TSCH,TSCJ,Border_type =1141(id=1022)w]line type=1008,1152(id=1154) hw]line type=1160   2006/02/20 lily add 3/29o{򥢸ɤW
  		if ((customerId .equals("1019") || customerId .equals("1393") || customerId .equals("4777") || customerId .equals("5274")) && (preOrderType .equals("1154")) ) 
   		{ defaultLineType = "1160" ;  }
  		if ((customerId .equals("1019") || customerId .equals("1393") || customerId .equals("4777")	|| customerId .equals("5274")) && (preOrderType .equals("1022")) )
   		{ defaultLineType = "1008" ;  }
  
  		String sql="insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,"+
                     "AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,REMARK,STATUSID,STATUS,CREATION_DATE,CREATED_BY,"+
					 "LAST_UPDATE_DATE,LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,SALESPERSON,"+
					 "BILL_TO_ORG,PAYTERM_ID,SHIPMETHOD,FOB_POINT,AR_OVERDUE,SOURCE_CODE,SAMPLE_ORDER,SAMPLE_CHARGE,AUTOCREATE_FLAG,RFQ_TYPE"+  //add by Peggy 20120301 autocreate_flag
					 ",SHIP_TO_CONTACT_ID,DELIVERY_TO_ORG,TAX_CODE)"+//TAX_CODE add by Peggy 20130411
             " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  		PreparedStatement pstmt=con.prepareStatement(sql);  
	  	pstmt.setString(1,seqno);  // ߰ݳ渹
	  	pstmt.setString(2,salesAreaNo); // ~ȦaϧONX
	  	pstmt.setString(3,salesPersonID);  // ~ȤHNX
	  	pstmt.setString(4,requireReason);  // ݨD]
	  	pstmt.setString(5,customerId); // ȤNX
	  	try  // ȤW
	  	{   
			Statement statement=con.createStatement();
		 	ResultSet rs=null;				      									  
		 	//String sqlSold = "select CUSTOMER_NAME,STATUS  from APPS.RA_CUSTOMERS where CUSTOMER_ID = '"+customerId+"' "; 					   
			String sqlSold = "select CUSTOMER_NAME,STATUS  from APPS.AR_CUSTOMERS where CUSTOMER_ID = '"+customerId+"' "; 					   
	 		rs=statement.executeQuery(sqlSold);
	 		if (rs.next())
	 		{ 
	  			if (rs.getString("STATUS")==null || !rs.getString("STATUS").equals("A"))    
	  			{ 
	    		%>
		  		<script language="javascript">
		     		alert(" Warning !!\n The Customer what you choose should be set ACTIVE in Oracle."); 
		  		</script>
				<%
	 			}	
	  			customer = rs.getString(1);                             
     			} 
				else 
				{
	          		customer = "";    
            	}  
	 			rs.close();        	 
  			} //end of try		 
  		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}  
  		pstmt.setString(6,customer); //ȤW
  		pstmt.setString(7,customerPO); //Ȥqʳ渹
  		pstmt.setString(8,curr);  // O
  		pstmt.setInt(9,0);  // `B(amount)
  		pstmt.setString(10,receptDate+dateBean.getHourMinuteSecond());  // ݨD鰲]=+ sɮɶ  
  		pstmt.setString(11,"");  // PC T{
  		pstmt.setString(12,""); // ut^нT{
  		pstmt.setString(13,""); // ͲutNX
  		pstmt.setString(14,remark); // YƵ
  		pstmt.setString(15,getStatusRs.getString("TOSTATUSID"));//gJSTATUSID
  		pstmt.setString(16,getStatusRs.getString("STATUSNAME"));//gJAW
  		pstmt.setString(17,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //gJ + ɶ
  		pstmt.setString(18,userID); //gJUser ID
  		pstmt.setString(19,dateBean.getYearMonthDay()); //̫s
  		pstmt.setString(20,userID); //̫sUser
  		pstmt.setString(21,toPersonID); // ݫȤtd~ȤHID
  		pstmt.setInt(22,Integer.parseInt(preOrderType));  // w q
  		pstmt.setInt(23,Integer.parseInt(customerId)); // Sold To ORG (ȤID)
  		pstmt.setInt(24,Integer.parseInt(priceList)); // Price List
  		pstmt.setInt(25,Integer.parseInt(shipToOrg)); // Ship To Org 
  		pstmt.setString(26,salesPerson); // ݫȤtd~ȤHSALES PERSON  
  		pstmt.setInt(27,Integer.parseInt(billTo)); // BILL_TO_ORG (Bill To)
  		pstmt.setInt(28,Integer.parseInt(payTermID)); // PAYMENT TERM ID (Payment Term Id)
  		pstmt.setString(29,shipMethod); // SHIPPING METHOD (Shipping Method)
  		pstmt.setString(30,fobPoint); // FOB (FOB POINT)
  		pstmt.setString(31,custAROverdue); // AR OVERDUE (ATTRIBUTE3)
  		pstmt.setString(32,sourceInput); // SOURCE_CODE
 		pstmt.setString(33,(preOrderType.equals("1743")?"Y":sampleOrder)); // SAMPLE_ORDER 2006/05/30,8121=sample order modify by Peggy 20201111 
  		pstmt.setString(34,(preOrderType.equals("1743")?"N":sampleCharge)); // SAMPLE_CHARGE 2006/06/12,8121=sample order modify by Peggy 20201111 
  		pstmt.setString(35,autoCreate_Flag); // AUTOCREATE_FLAG add by Peggy 20120301
		pstmt.setString(36,(rfqType.toUpperCase().equals("FORECAST")?"2":"1")); //add by Peggy 20120327
  		pstmt.setInt(37,Integer.parseInt(shipToContactID));  //shipToContactID,add by Peggy 20130220
  		pstmt.setInt(38,Integer.parseInt(deliveryToOrg));    //deliveryToOrg,add by Peggy 20130220
  		pstmt.setString(39,taxCode);     //Tax Code,add by Peggy 20130411
		pstmt.executeQuery();
  		//pstmt.executeUpdate(); 
  		//pstmt.close();
  		// Step2. gJ߰ݳ��
		
		//add by Peggy 20170714
		line_remarks ="";
		if (salesAreaNo.equals("006"))
		{
			sql = " SELECT 'Date Code須'||VALID_MONTHS/12||'年內'"+
				  " FROM tsc.tsc_cust_shipping_dc_check a"+
				  " WHERE ? LIKE CUSTOMER_NAME"+
				  " AND ?=?";
			PreparedStatement statementss = con.prepareStatement(sql);
			statementss.setString(1,customer);
			statementss.setString(2,salesAreaNo);
			statementss.setString(3,"006");
			ResultSet rssx=statementss.executeQuery();	
			if (rssx.next())
			{
				line_remarks =new String(rssx.getString(1).getBytes("ISO8859-1"),"utf8");	
			}
			rssx.close();
			statementss.close();					  
		}
		
  		if (a!=null) // P_JYsession Array Ȥnull
  		{  
			int lineCnt =0; //add by Peggy 20111107
    		// 20110209 Marvie Update : Add Field  SPQ MOQ PROGRAM_NAME
    		String sqlDtl="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,LINE_NO,INVENTORY_ITEM_ID,"+
					  "ITEM_SEGMENT1,QUANTITY,UOM,LIST_PRICE,REQUEST_DATE,SHIP_DATE,"+
                      "PROMISE_DATE,LINE_TYPE,PRIMARY_UOM,REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LSTATUSID,LSTATUS,"+
					  "ITEM_DESCRIPTION,MOQP,ASSIGN_MANUFACT,CUST_PO_NUMBER,NSPQ_CHECK, TSC_PROD_GROUP, SPQ, MOQ, PROGRAM_NAME, "+
					  "CUST_REQUEST_DATE,SHIPPING_METHOD,ORDER_TYPE_ID,AUTOCREATE_FLAG,SELLING_PRICE,ORDERED_ITEM,ORDERED_ITEM_ID,ITEM_ID_TYPE,FOB"+  //add by Peggychen 20110621
					  ",CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER,END_CUSTOMER_ID,PC_LEADTIME,ORIG_SO_LINE_ID"+ //add ORIG_SO_LINE_ID by Peggy 20150515
					  ",END_CUSTOMER_SHIP_TO_ORG_ID,DIRECT_SHIP_TO_CUST,BI_REGION,END_CUSTOMER_PARTNO,SUPPLIER_NUMBER)"+ //add by Peggy 20160308 //add SUPPLIER_NUMBER by Peggy 20220428
                      " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
   			for (int ac=0;ac<a.length;ac++)
  	 		{
				if (a[ac][3] != null)
				{
					PreparedStatement pstmtDtl=con.prepareStatement(sqlDtl);  
					pstmtDtl.setString(1,seqno);  // ߰ݳ渹
					String invItemID = "";	
					String uom = "";
					String itemFactory = "";
					String priceCategory = null;
					Statement statement=con.createStatement();
					ResultSet rs=null;	
					slowmoving_flag =false; tscdesc="";//add by Peggy 20141007
					pc_lead_time="";//add by Peggy 20150114					
					sql = "select a.INVENTORY_ITEM_ID, a.PRIMARY_UOM_CODE, NVL(a.ATTRIBUTE3,'N/A') ATTRIBUTE3, b.SEGMENT1   "+
					",NVL(upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_Package')),'N/A') as TSC_PACKAGE "+ //add by Peggy 20120303
					",upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_PROD_GROUP')) as TSC_PROD_GROUP "+ //modify by Peggy 20120303合併sql
					//",substr(a.description,0,decode(INSTR(a.description,'-'),0,length(a.description)-length(apps.tsc_get_item_packing_code(a.organization_id,a.inventory_item_id))-1,INSTR(a.description,'-')-1)) tsc_desc"+ //add by Peggy 20141007
					",case when apps.tsc_get_item_packing_code (49,a.inventory_item_id) in ('QQ','QQG') THEN a.description ELSE substr(a.description,0,decode(INSTR(a.description,'-'),0,length(a.description)-length(apps.tsc_get_item_packing_code(a.organization_id,a.inventory_item_id))-1,INSTR(a.description,'-')-1)) end tsc_desc"+ //add by Peggy 20220726
					" from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b "+
					" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
					" and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
					" and NVL(a.CUSTOMER_ORDER_FLAG,'N')='Y'"+         //add by Peggy  20151008
					" and NVL(a.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+ //add by Peggy  20151008													  								 			  
					" and a.ORGANIZATION_ID = '49'"+
					" and b.CATEGORY_SET_ID = 6 "+
					" and a.SEGMENT1 = '"+a[ac][1]+"' ";						  								 			  
					rs=statement.executeQuery(sql);
					if (rs.next())
					{
						invItemID = rs.getString("INVENTORY_ITEM_ID");
						uom =  rs.getString("PRIMARY_UOM_CODE");
						priceCategory = rs.getString("SEGMENT1");
						tscProdGroup =  rs.getString("TSC_PROD_GROUP");
						tscdesc = rs.getString("tsc_desc");  //add by Peggy 20141007
						    
						//modify by Peggy 20140425            
						if (salesAreaNo.equals("001"))
						{	
							if (rs.getString("ATTRIBUTE3").equals("008") && (rs.getString("TSC_PACKAGE").equals("SMA") && (!customerId.equals("2155") && custMarketGroup.equals("AU"))))
							{
								itemFactory ="002";
								a[ac][16]="1156";  //add by Peggy 20140425
								
								sql = " select wf.LINE_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl"+ 
										" where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
										" and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
										" and c.SAREA_NO = '"+salesAreaNo+"' and c.ORDER_NUM='"+a[ac][16]+"')"+
										" and END_DATE_ACTIVE is NULL and vl.name like 'S%Finished Goods_Affiliated'";
								Statement state11=con.createStatement();										
								ResultSet rs11=state11.executeQuery(sql);
								if (rs11.next())
								{
									a[ac][17] = rs11.getString("LINE_TYPE_ID");
								} 
								rs11.close();
								state11.close();		
							}
							else
							{
								itemFactory = a[ac][13];
								//itemFactory = rs.getString("ATTRIBUTE3");
							}													
						}
						else if (salesAreaNo.equals("012") && (a[ac][16].trim().equals("4131") || a[ac][16].trim().equals("4121"))) //add by Peggy 20140114
						{
							itemFactory ="002";
						}
						//else if (salesAreaNo.equals("002") && UserName.equals("COCO"))  //add by Peggy 20140409
						else if (salesAreaNo.equals("018"))  //add by Peggy 20171221
						{
							//汽車客戶,S1M R2品質issue,須從山東出貨,add by Peggy 20140409
							//S1M R2已無品質issue,且22D已將TEW及YEW分開定義,add by Peggy 20160707
							//if ( ((a[ac][8].indexOf("BUEHLER MOTOR")>0 || a[ac][8].indexOf("Marelli(Guangzhou)")>0 ) && rs.getString("ATTRIBUTE3").equals("008")) || a[ac][2].equals("S1M R2"))
							if ( ((a[ac][8].indexOf("BUEHLER MOTOR")>0 || a[ac][8].indexOf("Marelli(Guangzhou)")>0 ) && rs.getString("ATTRIBUTE3").equals("008")))
							{
								itemFactory="002";
								a[ac][16]="1156";
								
								sql = " select wf.LINE_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl"+ 
										" where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
										" and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
										" and c.SAREA_NO = '"+salesAreaNo+"' and c.ORDER_NUM='"+a[ac][16]+"')"+
										" and END_DATE_ACTIVE is NULL and vl.name like 'S%Finished Goods_Affiliated'";
								Statement state11=con.createStatement();										
								ResultSet rs11=state11.executeQuery(sql);
								if (rs11.next())
								{
									a[ac][17] = rs11.getString("LINE_TYPE_ID");
								} 
								rs11.close();
								state11.close();								
							}
							else
							{
								//itemFactory = rs.getString("ATTRIBUTE3");							
								itemFactory = a[ac][13];
							}
							
							//FABRICATORS D/C一年內,ADD BY PEGGY 20200512
							sql = " SELECT 'Date Code需'||VALID_MONTHS/12||'年內'"+
								  " FROM tsc.tsc_cust_shipping_dc_check a"+
								  " WHERE INSTR(upper(?),CUSTOMER_NAME)>0"+
								  " AND ?=?";
							PreparedStatement statementss = con.prepareStatement(sql);
							statementss.setString(1,a[ac][8]);
							statementss.setString(2,salesAreaNo);
							statementss.setString(3,"018");
							ResultSet rssx=statementss.executeQuery();	
							if (rssx.next())
							{
								line_remarks =new String(rssx.getString(1).getBytes("ISO8859-1"),"utf8");	
							}
							rssx.close();
							statementss.close();								
						}
						else
						{
							//itemFactory = rs.getString("ATTRIBUTE3");
							itemFactory = a[ac][13];
						}	
						//add by Peggy 20150114
						sql = "select tsc_get_pc_lead_time('"+itemFactory +"',trunc(sysdate),'"+invItemID +"') from dual";
						Statement statementxx=con.createStatement();
						ResultSet rsxx=statementxx.executeQuery(sql);
						if (rsxx.next())
						{
							pc_lead_time = rsxx.getString(1); 
						}
						rsxx.close();
						statementxx.close();							
					}	
					else 
					{ 
						throw new Exception("line:"+(ac+1)+" The item is not exist!!");
						//invItemID="0"; itemFactory="N/A"; uom="N/A"; priceCategory = ""; tscProdGroup = "";
					}		
					rs.close();   
					statement.close(); 	

	
					double listPrice = 0;
					Statement stateListPrice=con.createStatement();
					String sqlLPrice = "select OPERAND from ORADDMAN.TSITEM_LIST_PRICE "+
					" where LIST_HEADER_ID =  '"+priceList+"' and PRODUCT_ATTR_VAL_DISP = '"+priceCategory+"' ";
					ResultSet rsLPrice=stateListPrice.executeQuery(sqlLPrice); 
					if (rsLPrice.next())
					{
						listPrice = rsLPrice.getDouble("OPERAND");  
					}
					rsLPrice.close();
					stateListPrice.close(); 
					
					//add by Peggy 20120306
					if (!a[ac][14].trim().equals("") && !a[ac][14].trim().equals("N/A") && !a[ac][14].trim().equals("&nbsp;") && a[ac][14].trim()!= null)
					{
						Statement statecust=con.createStatement();
						String sqlcust = " SELECT item_id, item_identifier_type item_type,item cust_item, inventory_item,sold_to_org_id"+
										 " FROM oe_items_v a"+
										 " where cross_ref_status <>'INACTIVE'"+
										 " and item='"+a[ac][14].trim()+"'"+
										 " and inventory_item='"+a[ac][1].trim()+"'"+
										 " and sold_to_org_id='"+customerId+"'";
						ResultSet rscust=statecust.executeQuery(sqlcust); 
						if (rscust.next())
						{
							custItemID = rscust.getString("item_id");  
							custItemType = rscust.getString("item_type");
						}
						else
						{
							throw new Exception("line:"+(ac+1)+" The customer item is not available!!"+sqlcust);
						}					
						rscust.close();
						statecust.close(); 
					}
					else
					{
						a[ac][14]="N/A";
						custItemID = "0";  
						custItemType = "INT";						
					}					
					
					//add by Peggychen 20120301
					if (autoCreate_Flag.equals("Y") || (!a[ac][16].trim().equals("N/A") && !a[ac][16].trim().equals("") && a[ac][16].trim() != null))
					{
						if (!orderType.equals(a[ac][16].trim()))
						{
							Statement stateodrtype=con.createStatement();
							ResultSet rsodrtype=stateodrtype.executeQuery("SELECT  a.otype_id  "+
							" FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
							" where b.order_num=a.order_num"+
							" and a.order_num='"+a[ac][16]+"' and a.SAREA_NO ='"+salesAreaNo+"' and a.active='Y'"+
							" and b.MANUFACTORY_NO='"+itemFactory+"' and b.ACTIVE='Y'");  
							if (rsodrtype.next())
							{
								orderTypeId=rsodrtype.getString("otype_id");  
							}
							else
							{
								throw new Exception("line:"+(ac+1)+" The order type is not exist!!");
							}
							rsodrtype.close();
							stateodrtype.close();
							orderType= a[ac][16].trim();
						}
						
						//CHECK LINE TYPE是否正確
						if (a[ac][17].trim() ==null || a[ac][17].trim().equals(""))
						{
							Statement stateB=con.createStatement();
							ResultSet rsB=stateB.executeQuery(" select DEFAULT_ORDER_LINE_TYPE from ORADDMAN.TSAREA_ORDERCLS c  where c.SAREA_NO = '"+salesAreaNo+"' and c.OTYPE_ID='"+preOrderType+"'");
							if (rsB.next())
							{
								a[ac][17]=rsB.getString(1);
							}
							stateB.close();
							rsB.close();
							if (a[ac][17].trim() ==null || a[ac][17].trim().equals(""))
							{
								throw new Exception("line:"+(ac+1)+" The line type can not empty!!");
							}															  
						}
						else
						{						
							Statement stateB=con.createStatement();
							ResultSet rsB=stateB.executeQuery(" select wf.LINE_TYPE_ID, vl.name as LINE_TYPE"+
																   " from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl "+
																   " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID "+
																   " and wf.LINE_TYPE_ID is not null"+ 
																   " and vl.language = 'US' "+
																   " and END_DATE_ACTIVE is NULL "+
																   " and wf.LINE_TYPE_ID ='"+a[ac][17].trim() +"'"+
																   " and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
																   " and c.SAREA_NO = '"+salesAreaNo+"' and c.ORDER_NUM='"+orderType+"')"); 
							if (!rsB.next())
							{
								throw new Exception("line:"+(ac+1)+" The line type is not exist!!");
							}
							stateB.close();
							rsB.close();
						}
					}
					
					//modify by Peggychen 20110610
					if (a[ac][8]==null || a[ac][8].trim().equals("")) 
					{  
						a[ac][8] = customerPO;   
					}
					else
					{
						a[ac][8] = a[ac][8].trim();
					}
					a[ac][8] =a[ac][8].replace("（","(").replace("）",")"); //20130304 by Peggy:全形轉半形
					
					if (a[ac][10]==null || a[ac][10].equals("") || a[ac][10].equals("null")) // 20090520 liling add
					{  
						a[ac][10] = "N";   
					}
			
					//check slow moving stock,add by Peggy 20141007
					if (actionID.equals("002") && !a[ac][16].equals("1121") && !a[ac][16].equals("4121"))
 					if (actionID.equals("002") && !a[ac][16].equals("1121") && !a[ac][16].equals("4121") && !salesAreaNo.equals("018") && !customerId.equals("601290")) //TSCH RFQ在7訂單已經檢查過FROM RITA 20221207 //from rita:onsemi的料因为都是特殊making/packing/label, 所以是没办法和其他客户互相消化的 add by Peggy 20230207
					{
						if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
						while (rsh.next())
						{
							if (rsh.getString("item_desc1")!=null && rsh.getString("item_desc1").equals(tscdesc))
							{
								slowmoving_flag=true;
								break;
							}
						}
					}
					
					//check arrow end customer item,add by Peggy 20150409
					if (customerId.equals("7147"))
					{
						sql = " SELECT b.customer_number,nvl(b.customer_name_phonetic, b.customer_name) customer_name"+
							  " FROM oraddman.tsce_arrow_end_customer a,ar_customers b"+
							  "  where NVL(a.ACTIVE_FLAG,'I') =? "+
							  " AND a.end_customer_id=b.customer_id "+
							  " and trim(a.item_desc)=trim(?)";
						PreparedStatement state88 = con.prepareStatement(sql);
						state88.setString(1,"A");
						state88.setString(2,a[ac][2]);
						ResultSet rs88=state88.executeQuery();
						if (rs88.next())
						{
							a[ac][21]=rs88.getString(1);
							a[ac][24]=rs88.getString(2);
						}	
						rs88.close();
						state88.close();
					}
					
					pstmtDtl.setInt(2,ac+1); // Line_No // ƶǸ	  
					pstmtDtl.setString(3,invItemID); // Inventory_Item_ID	  
					pstmtDtl.setString(4,a[ac][1]); // Inventory_Item_Segment1
					pstmtDtl.setFloat(5,Float.parseFloat(a[ac][3])); // Order Qty
					pstmtDtl.setString(6,uom); // Primary Unit of Measure
					pstmtDtl.setDouble(7,listPrice); // List Price
					pstmtDtl.setString(8,a[ac][7]+dateBean.getHourMinuteSecond()); // Request Date
					pstmtDtl.setString(9,a[ac][7]+dateBean.getHourMinuteSecond()); // Ship Date( w]PݨDۦP,iѤutwƥ,ͺ޽T{η~ȳ̫ͦqɭק )
					pstmtDtl.setString(10,a[ac][7]+dateBean.getHourMinuteSecond()); // Promise Date( ȤݨD,w]PݨDۦP,iѷ~ȳ̫ͦqɭק )
					if (autoCreate_Flag.equals("Y") || (!a[ac][16].trim().equals("N/A") && !a[ac][16].trim().equals("") && a[ac][16].trim() != null)) //modify by Peggy 20120301
					{
						pstmtDtl.setInt(11,Integer.parseInt(a[ac][17])); 
					}
					else
					{
						pstmtDtl.setInt(11,Integer.parseInt(defaultLineType)); // Default Order Line Type
					}
					pstmtDtl.setString(12,a[ac][4]); // Primary Unit of Measure
					pstmtDtl.setString(13,(a[ac][9].replace("&nbsp;","")).startsWith("&nbsp")?"":a[ac][9].replace("&nbsp;","")+(line_remarks.length()>0?",":"")+line_remarks); // Remark
					pstmtDtl.setString(14,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //gJ
					pstmtDtl.setString(15,userID); //gJUser ID
					pstmtDtl.setString(16,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //̫s
					pstmtDtl.setString(17,userID); //̫sUser
					//add by Peggy 20141007
					if (slowmoving_flag)
					{
						pstmtDtl.setString(18,"014"); 
						pstmtDtl.setString(19,"PENDING"); 
					}
					else
					{
						pstmtDtl.setString(18,getStatusRs.getString("TOSTATUSID")); //Line Status ID
						pstmtDtl.setString(19,getStatusRs.getString("STATUSNAME")); //Line Status Name
					}
					pstmtDtl.setString(20,a[ac][2]); //xb~
					pstmtDtl.setString(21,"0"); //̤p]˭qʶq	  
					pstmtDtl.setString(22,itemFactory); //ITEMͲa  
					pstmtDtl.setString(23,a[ac][8]); // END-CUST PO NUMBER	
					pstmtDtl.setString(24,a[ac][10]); // NONE SPQ CHECK Y=SPECIAL ITEM NO NEED CHECK
					pstmtDtl.setString(25,tscProdGroup);  // tsc prod group category
					// 20110209 Marvie Add : Add Field  SPQ MOQ PROGRAM_NAME
					float fSPQ = 0;
					if (a[ac].length > 9) 
					{
						if (a[ac][11]==null || a[ac][11].equals("") || a[ac][11].equals("null")) a[ac][11]="0";
						fSPQ = Float.valueOf(a[ac][11]).floatValue();
					}
					pstmtDtl.setFloat(26,fSPQ); // SPQ
					float fMOQ = 0;
					if (a[ac].length > 10) 
					{
						if (a[ac][12]==null || a[ac][12].equals("") || a[ac][12].equals("null")) a[ac][12]="0";
						fMOQ = Float.valueOf(a[ac][12]).floatValue();
					}
					pstmtDtl.setFloat(27,fMOQ); // MOQ
					pstmtDtl.setString(28,sProgramName+"I"); // PROGRAM_NAME
					pstmtDtl.setString(29,(computeSSD.equals("Y")||computeSSD.equals("X"))?a[ac][5]:null); //CRD ,Add by Peggychen 20110621
					//pstmtDtl.setString(30,(computeSSD.equals("Y"))?a[ac][6]:null); //SHIPPING METHOD,Add by Peggychen 20110621
					pstmtDtl.setString(30,(computeSSD.equals("Y")||computeSSD.equals("S")||computeSSD.equals("X"))?(a[ac][6].startsWith("&nbsp")?null:a[ac][6]):null); //modify by Peggychen 20120209
					pstmtDtl.setString(31, (orderTypeId.equals("")?null:orderTypeId)); //ordertype add by Peggy 20120301
					pstmtDtl.setString(32, autoCreate_Flag); //AUTOCREATE_FLAG add by Peggy 20120301
					pstmtDtl.setString(33, a[ac][15].trim()); //selling price add by Peggy 20120301
					pstmtDtl.setString(34, (a[ac][14].trim()==null?"N/A":a[ac][14].trim())); //CUSTOMER ORDER ITEM ,add by Peggy 20120306
					pstmtDtl.setString(35, custItemID); //CUSTOMER ORDER ITEM ID ,add by Peggy 20120306
					pstmtDtl.setString(36, custItemType); //CUSTOMER ORDER ITEM TYPE ,add by Peggy 20120306
					pstmtDtl.setString(37, (a[ac][18].trim()==null||a[ac][18].trim().equals(""))?fobPoint:a[ac][18].trim()); //CUSTOMER ORDER ITEM TYPE ,add by Peggy 20120306
					pstmtDtl.setString(38, (a[ac][19].startsWith("&nbsp"))?null:a[ac][19].trim()); //CUSTOMER PO LINE NO,Add by Peggy 20120531
					pstmtDtl.setString(39, (a[ac][20].startsWith("&nbsp"))?null:a[ac][20].trim()); //QUOTER NUMBER,Add by Peggy 20120905
					pstmtDtl.setString(40, (a[ac][24].startsWith("&nbsp"))?null:a[ac][24].trim()); //END CUSTOMER,Add by Peggy 20140811
					end_cust_id =null;
					if (a[ac][21].startsWith("&nbsp") || a[ac][21] == null || a[ac][21].equals("") )
					{
						pstmtDtl.setString(41,null);
					}
					else
					{
						if (rss.isBeforeFirst() ==false) rss.beforeFirst();
						while (rss.next())
						{
							if (rss.getString("customer_number").equals(a[ac][21]))
							{
								end_cust_id = rss.getString("customer_id"); //END CUSTOMER ID,Add by Peggy 20140811
								break;
							}
						}
						if (end_cust_id==null) 
						{
							sql = " SELECT customer_id  from ar_customers a where customer_number=?";
							PreparedStatement statecust = con.prepareStatement(sql);
							statecust.setString(1,a[ac][21]);
							ResultSet rscust=statecust.executeQuery();
							if (rscust.next())
							{
								end_cust_id=rscust.getString(1);
							}	
							rscust.close();
							statecust.close();	
						}
						if (end_cust_id==null)
						{						
							throw new Exception("line:"+(ac+1)+"End customer number="+a[ac][21]+" not found!!");
						}
						else
						{
							pstmtDtl.setString(41, end_cust_id); //END CUSTOMER ID,Add by Peggy 20140811
						}
					}
					
					//check 業務區012 end customer是否有效,add by Peggy 20160219
					if (salesAreaNo.equals("012"))
					{
						sql_e = " select SITE_USE_ID from  AR.HZ_CUST_SITE_USES_ALL a,APPS.HZ_CUST_ACCT_SITES_ALL b"+
														   " where A.SITE_USE_CODE='SHIP_TO' "+
														   " AND A.STATUS='A' "+
														   " AND A.ORG_ID=325"+
														   " AND A.CUST_ACCT_SITE_ID = B.CUST_ACCT_SITE_ID "+
														   " AND TO_CHAR(B.CUST_ACCOUNT_ID) ='"+end_cust_id+"'";
						if (!a[ac][28].startsWith("&nbsp")&& !a[ac][28].startsWith("--")&& !a[ac][28].equals(""))  //add by Peggy 20170511
						{
							sql_e += " AND a.LOCATION='"+a[ac][28]+"'";
						}	
						else
						{
							sql_e += "	AND A.PRIMARY_FLAG='Y' ";
						}
						//out.println(sql_e);				
						Statement state81=con.createStatement();
						ResultSet rs81=state81.executeQuery(sql_e);
						if (!rs81.next())
						{
							throw new Exception("line:"+(ac+1)+" end customer("+end_cust_id+") ship to("+a[ac][28]+") not found!!");
						}
						else
						{
							end_cust_ship_to = rs81.getString(1);
						}
						state81.close();
						rs81.close();	
					}
					else
					{	
						end_cust_ship_to =null;
					}					
					pstmtDtl.setString(42, pc_lead_time); //add by Peggy 20150114
					pstmtDtl.setString(43, (a[ac][25].startsWith("&nbsp")||a[ac][25].equals(""))?null:a[ac][25].trim()); //add by Peggy 20150515
					pstmtDtl.setString(44, end_cust_ship_to); //add by Peggy 20160219
					pstmtDtl.setString(45, (a[ac][26].startsWith("&nbsp")||a[ac][26].startsWith("--"))?null:a[ac][26].trim()); //add by Peggy 2016308,sample order direct to cust flag
					pstmtDtl.setString(46, (a[ac][27].startsWith("&nbsp")||a[ac][27].startsWith("--"))?null:a[ac][27].trim()); //add by Peggy 20170218,BI REGION
					pstmtDtl.setString(47, (a[ac][29].startsWith("&nbsp")||a[ac][29].startsWith("--"))?null:a[ac][29].trim()); //add by Peggy 20190225,END CUST PARTNO
					pstmtDtl.setString(48, SUPPLIER_NUMBER);  //add by Peggy 20220428 SUPPLIER_NUMBER
					pstmtDtl.executeQuery();
					//pstmtDtl.executeUpdate();
					//pstmtDtl.close();
	
	
					//add by Peggy 20130304,insert data to tsdelivery_notice_remarks table
					if (a[ac][22] != null && !a[ac][22].equals("") && !a[ac][22].equals("&nbsp;") && a[ac][23] != null && !a[ac][23].equals("") && !a[ac][23].equals("&nbsp;"))
					{
						PreparedStatement pstmtDt11=con.prepareStatement("insert into oraddman.tsdelivery_notice_remarks(dndocno, line_no, shipping_marks, remarks,creation_date, created_by, last_update_date,last_updated_by, customer) values(?,?,?,?,sysdate,?,sysdate,?,CASE WHEN ?='ARROW' THEN 'ARROW HONG KONG' ELSE ? END)");  
						pstmtDt11.setString(1,seqno); 
						pstmtDt11.setInt(2,ac+1); // Line_No 
						pstmtDt11.setString(3, (a[ac][22].startsWith("&nbsp"))?null:a[ac][22].trim()); //SHIPPING MARKS,Add by Peggy 20130304
						pstmtDt11.setString(4, (a[ac][23].startsWith("&nbsp"))?null:a[ac][23].trim()); //REMARKS,Add by Peggy 20130304
						pstmtDt11.setString(5,UserName); //User
						pstmtDt11.setString(6,UserName);   //User
						pstmtDt11.setString(7, (a[ac][8].indexOf("(")<0?a[ac][8]:a[ac][8].substring(a[ac][8].indexOf("(")+1,a[ac][8].lastIndexOf(")"))));   //customer,modify by Peggy 20130729,抓最右邊的右括號
						pstmtDt11.setString(8, (a[ac][8].indexOf("(")<0?a[ac][8]:a[ac][8].substring(a[ac][8].indexOf("(")+1,a[ac][8].lastIndexOf(")"))));   //customer,modify by Peggy 20130729,抓最右邊的右括號
						pstmtDt11.executeQuery();
						pstmtDt11.close();
					}

					//add by Peggy 20150518, update tsc.TSC_OM_REQUISITION when columen oraddman.tsdelivery_notice_detail.ORIG_SO_LINE_ID is not null
					if (a[ac][25] != null && !a[ac][25].equals("") && !a[ac][25].equals("&nbsp;"))
					{
						//add by Peggy 20231011
						if (salesAreaNo.equals("008"))
						{
							PreparedStatement pstmtDt11=con.prepareStatement(" update tsca.ta_om_request_supply a set rfq_no=? ,rfq_line=? where LINE_ID=? ");  
							pstmtDt11.setString(1,seqno);
							pstmtDt11.setString(2,""+(ac+1));
							pstmtDt11.setString(3,a[ac][25]); // ORIG ORDER LINE ID 
							pstmtDt11.executeQuery();
							pstmtDt11.close();						
						}
						else
						{
							PreparedStatement pstmtDt11=con.prepareStatement(" update TSC_OM_REQUISITION set FLOW_STATUS_CODE=? where LINE_ID=? ");  
							pstmtDt11.setString(1,"AWAITING_RFQ"); 
							pstmtDt11.setString(2,a[ac][25]); // ORIG ORDER LINE ID 
							pstmtDt11.executeQuery();
							pstmtDt11.close();
						}
					}
						
					//MARK BY Peggy 20220406
					// 20110209 Marvie Add : Add Field  SPQ MOQ PROGRAM_NAME
					/*if (a[ac][1].length() >= 21 && fSPQ == 0) 
					{
						sendMailBean.setMailHost(mailHost);
						sendMailBean.setReception("marvie@ts.com.tw");		        
						sendMailBean.setFrom(UserName);
						sendMailBean.setSubject("RFQ system moq,spq check notice");
						sendMailBean.setUrlName("Please check tsdelivery_notice_detail DOCNO:"+seqno+" LINENO:"+(ac+1));   	 
						sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQHistoryQueryAll.jsp?DNDOCNO="+seqno);
						sendMailBean.sendMail();
					}
					*/
					
					lineCnt ++; //add by Peggy 20111107
				}
   			} //enf of for
			
			//add by Peggy 20140115
			if (sProgramName.equals("D4-004") || sProgramName.equals("D4-012") || sProgramName.equals("D4-013") || sProgramName.equals("D4-015") || sProgramName.equals("D4-017")  || sProgramName.equals("D4-018") || sProgramName.equals("D4-003")  || sProgramName.equals("D4-019") || sProgramName.equals("D4-016")) //add D4-003 by Peggy 20140310
			{
				if (sProgramName.equals("D4-017")||sProgramName.equals("D4-018") || sProgramName.equals("D4-016"))
				{
					String sqlx="update oraddman.tsc_rfq_upload_temp SET CREATE_FLAG=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=sysdate WHERE CREATE_FLAG=? AND TEMP_ID=?";   
					PreparedStatement seqstmt=con.prepareStatement(sqlx);        
					seqstmt.setString(1,"Y");   
					seqstmt.setString(2,UserName);   
					seqstmt.setString(3,"N");   
					seqstmt.setString(4,UPLOAD_TEMP_ID);   
					seqstmt.executeQuery();
					seqstmt.close(); 

					ipendingcnt =0;
					sqlx = " SELECT count(1) FROM oraddman.tsc_rfq_upload_temp a "+
						   " where a.create_flag=?";
					if ( sProgramName.equals("D4-016"))
					{
						sqlx += " and a.program_name=?";
					}
					else
					{
						sqlx += " and a.salesareano=?";			
					}
					PreparedStatement stk = con.prepareStatement(sqlx);
					stk.setString(1,"N");
					if ( sProgramName.equals("D4-016"))
					{
						stk.setString(2,"D4-016");
					}
					else
					{
						stk.setString(2,salesAreaNo);
					}
					ResultSet rsk = stk.executeQuery();		
					if (rsk.next())		
					{
						ipendingcnt = rsk.getInt(1);		
					}
					rsk.close();
					stk.close();
				
				}
				else
				{				
					String sqlx="update oraddman.tsc_rfq_upload_temp SET CREATE_FLAG=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=sysdate WHERE CREATE_FLAG=? AND CUSTOMER_ID=? AND CUSTOMER_PO= nvl(?, customer_po) AND salesareano=?";
					PreparedStatement seqstmt=con.prepareStatement(sqlx);
					seqstmt.setString(1,"Y");   
					seqstmt.setString(2,UserName);   
					seqstmt.setString(3,"N");   
					seqstmt.setString(4,customerId );   
					seqstmt.setString(5, Arrays.asList(new String[]{"byCustNo", null, ""}).contains(groupByType) ? null : customerPO);
					seqstmt.setString(6,salesAreaNo );
					seqstmt.executeQuery();
					seqstmt.close();

					ipendingcnt =0;
					sqlx = " SELECT count(1) FROM oraddman.tsc_rfq_upload_temp a "+
						   " where a.create_flag=?"+
						   " and a.salesareano=?"+
						   " and (CUSTOMER_PO<> ?"+
						   " OR CUSTOMER_ID<> ? )"; //add by Peggy 20140225
					//out.println(sqlx);		
					//out.println(customerId);
					//out.println(customerPO);
					//out.println(shipToOrg);   
					PreparedStatement stk = con.prepareStatement(sqlx);
					stk.setString(1,"N");
					stk.setString(2,salesAreaNo);
					stk.setString(3,customerPO ); 
					stk.setString(4,customerId);  //add by Peggy 20140225
					ResultSet rsk = stk.executeQuery();
					if (rsk.next())		
					{
						ipendingcnt = rsk.getInt(1);		
					}
					rsk.close();
					stk.close();
				}
			}			
			//add by Peggy 20111107
			if (lineCnt >0)
			{
				con.commit();
			}
			else
			{
				throw new Exception("No Detail Data!!");
			}
  		}  // End of if (a!=null) 
		else
		{
			throw new Exception("No Detail Data!!");
		}
  		out.println("insert into Sales Delivery Request value(");%><jsp:getProperty name="rPH" property="pgQDocNo"/><%out.println(":<font color=#FF0000>"+seqno+"</font>- (");%><%out.println(":<font color=#660000>"+RepTimes+"</font>) OK!<BR>");    
  		out.println("<A HREF='/oradds/OraddsMainMenu.jsp'>");%><jsp:getProperty name="rPH" property="pgHOME"/><%out.println("</A>&nbsp;&nbsp;");
  		out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSSalesDRQHistoryQueryAll.jsp?DNDOCNO="+seqno+"'>");%><jsp:getProperty name="rPH" property="pgTSDRQNoHistory"/><%out.println("(by Devivery Request No.)</A>");
  		out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSSalesDRQ_Create.jsp'>");%><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgDRQInputPage"/><%out.println("(by RequestNo.)</A>");
  
		getStatusRs.close();
  		pstmt.close();  
	} //end of try
	catch (Exception e)
	{	
		strRes=e.getMessage().toString()+stepNo;
 		out.println("<font color='red'>"+e.getMessage().toString()+"</font>");
		con.rollback();
	}//end of catch
	
	rss.close();
	statements.close();
	rsh.close();
	statementh.close();	
%>
<table width="591" border="1">
  <tr>
    <td width="278"><jsp:getProperty name="rPH" property="pgDRQDocProcess"/></td>
    <td width="297"><jsp:getProperty name="rPH" property="pgDRQInquiryReport"/></td>    
  </tr>
  <tr>
    <td>
<%
	try  
	{
    	String MODEL = "D1";    
		Statement statement=con.createStatement();
		//    ResultSet rs=statement.executeQuery("select distinct ADDRESS,PROGRAMMERNAME,lineno from RPPROGRAMMER WHERE ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') AND  MODEL='"+MODEL+"'  order by lineno");    
    	ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
		//out.println("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");
    	while(rs.next())
    	{
      		String ADDRESS = rs.getString("FADDRESS");
			String PROGRAMMERNAME= rs.getString("FDESC");
			out.println("<font size=-1><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a><br>");
		}
      	rs.close(); 
	  	statement.close();
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
  	{	
    	String MODEL = "D2";    
		Statement statement=con.createStatement(); 
    	ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    	while(rs.next())
    	{
      		String ADDRESS = rs.getString("FADDRESS");
			String PROGRAMMERNAME= rs.getString("FDESC");
			out.println("<font size=-1><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a><br>");
		}
      	rs.close(); 
	  	statement.close();
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
<%  // P_O_\ͳ
	try  
	{    
		Statement statement=con.createStatement(); 
    	ResultSet rs=statement.executeQuery("SELECT DNDOCNO FROM ORADDMAN.TSDELIVERY_NOTICE WHERE DNDOCNO='"+seqno+"' ");    
    	if (!rs.next())
    	{
%>
		<script language="javascript">
			alertRFQNotSuccess("<jsp:getProperty name='rPH' property='pgAlertRFQCreateMsg'/>");
		</script>
<%
		} 
		else 
		{
			Statement stateDtl=con.createStatement(); 
        	ResultSet rsDtl=stateDtl.executeQuery("select DNDOCNO from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+seqno+"' ");
			if (!rsDtl.next())   
			{
%>
			<script language="javascript">
			alert("<jsp:getProperty name='rPH' property='pgAlertRFQCreateDtlMsg'/>");
			</script>
<%
			}
			rsDtl.close();
			stateDtl.close();	   	         
		} // YY(TSDELIVERY_NOTICE)AP_O_ͩ,YLhĵiϥΪ_
    	rs.close(); 
		statement.close();
	} //end of try
	catch (Exception e)
	{
		e.printStackTrace();
    	out.println(e.getMessage());
	}//end of catch  
%>
    <input name="PRESEQNO" type="HIDDEN" value="<%=seqno%>">	   
	<input name="REPTIMES" type="HIDDEN" value="<%=RepTimes%>">  <!--P_O_wGٴyz-->
<%
    arrayCheckBoxBean.setArray2DString(null); //NbeanȲMťHPcaseiHsB@
	arrayRFQDocumentInputBean.setArray2DString(null);//NbeanȲMťHPcaseiHsB@
%>
<!--=============HUϬqs==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
    //response.sendRedirect("TSSalesDRQ_Create.jsp");
    // Modify by Jingker for Order Import Redirect 2006/03/07

	if (repeatInput!=null && !repeatInput.equals(""))
	{
		if (strRes.length() >0)
		{
			if (sProgramName.equals("D4-012")) { //add by Peggy 20130104
				String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCROWImportHistory.jsp";
			%>
				<script> insertFail("<%=url%>")</script>
			<%
			}
			else if (sProgramName.equals("D4-013")) { //add by Peggy 20140115
				String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCKBufferImport.jsp?ACTIONCODE=DETAIL";
			%>
				<script> insertFail("<%=url%>")</script>
			<%
			}
			else if (sProgramName.equals("D4-015")) { //add by Peggy 20151116
				String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCTDABufferImport.jsp?ACTIONCODE=DETAIL";
			%>
				<script> insertFail("<%=url%>")</script>
			<%
			}	
			else if (sProgramName.equals("D4-016"))  
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
				if (confirm("Insert Fail!!"))
				{
					document.location.href="../jsp/TSCCK3ToRFQUpload.jsp?ACTIONCODE=DETAIL";
				}
				</script>	
			<%
			}			
			else if (sProgramName.equals("D4-017")) { //add by Peggy 20160225
				String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCCSHAbroadRFQImport.jsp?ACTIONCODE=DETAIL";
			%>
				<script> insertFail("<%=url%>")</script>
			<%
			}
			else if (sProgramName.equals("D4-004") && modelN.equals("Y")) { //add by Peggy 20160225
			%>
				<script> insertFail("<%=detailJsp%>")</script>
			<%
			}
			else if (sProgramName.equals("D4-018"))  //add by Peggy 20170213
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
				if (confirm("Insert Fail!!"))
				{
					document.location.href="../jsp/TSCSampleBufferImport.jsp?ACTIONCODE=DETAIL";
				}
				</script>	
			<%
			}							
			else if (sProgramName.equals("D4-003"))  //add by Peggy 20140310
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
				if (confirm("Insert Fail!!"))
				{
					document.location.href="../jsp/TSCEBufferImport.jsp?ACTIONCODE=DETAIL";
				}
				</script>	
			<%
			}	
			else if (sProgramName.equals("D4-019")) { //add by Peggy 20181205
				String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCTDistyBufferImport.jsp?ACTIONCODE=DETAIL";
			%>
				<script> insertFail("<%=url%>")</script>
			<%
			}
			//else
			//{
				//response.sendRedirect("TSSalesDRQ_Create.jsp?PREDNDOCNO=Create Action Fail("+strRes+")");
			//}
		}
		else if (sProgramName.equals("D4-012")) { //add by Peggy 20130104
			String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCROWImportHistory.jsp";
		%>
			<script> insertSuccess("<%=url%>")</script>
		<%	
		}
		else if (sProgramName.equals("D4-013") && ipendingcnt >0) { //add by Peggy 20140115
			String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCKBufferImport.jsp?ACTIONCODE=DETAIL";
		%>
			<script> insertSuccess("<%=url%>")</script>
		<%
		}
		else if (sProgramName.equals("D4-015") && ipendingcnt >0) { //add by Peggy 20151116
			String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCTDABufferImport.jsp?ACTIONCODE=DETAIL";
		%>
			<script> insertSuccess("<%=url%>")</script>
		<%
		}	
		else if (sProgramName.equals("D4-016") && ipendingcnt >0) 
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")"))
			{
				document.location.href="../jsp/TSCCK3ToRFQUpload.jsp?ACTIONCODE=DETAIL";
			}
			</script>	
		<%
		}			
		else if (sProgramName.equals("D4-017") && ipendingcnt >0) { //add by Peggy 20160225
			String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCCSHAbroadRFQImport.jsp?ACTIONCODE=DETAIL";
		%>
			<script> insertSuccess("<%=url%>")</script>
		<%
		}	
		else if (sProgramName.equals("D4-018") && ipendingcnt >0)  //add by Peggy 20170213
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")"))
			{
				document.location.href="../jsp/TSCSampleBufferImport.jsp?ACTIONCODE=DETAIL";
			}
			</script>	
		<%
		}				
		else if (sProgramName.equals("D4-003") && ipendingcnt >0)  //add by Peggy 20140310
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")"))
			{
				document.location.href="../jsp/TSCEBufferImport.jsp?ACTIONCODE=DETAIL";
			}
			</script>	
		<%
		}
		else if (sProgramName.equals("D4-004")) { //add by Peggy 20220610
			String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCABufferImport.jsp";
		%>
			<script> insertSuccess("<%=url%>")</script>
		<%
		}
		else if (sProgramName.equals("TSCC")) { //add by Peggy 20220610
			String headerId =session.getAttribute("headerId").toString();
			String isEmptyRow = request.getParameter("isEmptyRow");
			String url = "../jsp/TSCCIntermediate.jsp?requestHeaderId="+headerId;
		%>
			<script>
				if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")")) {
					if('<%=isEmptyRow%>'==='N') {
						document.location.href = "<%=url%>";
					}
				}
			</script>
		<%
		}
	else if (sProgramName.equals("D4-019") && ipendingcnt >0) { //add by Peggy 20181205
			String url = modelN.equals("Y") ? detailJsp : "../jsp/TSCTDistyBufferImport.jsp?ACTIONCODE=DETAIL";
		%>
			<script> insertSuccess("<%=url%>")</script>
		<%
		}
		else if (sProgramName.equals("D4-006P"))  //add by Peggy 20190711
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")"))
			{
				document.location.href="../jsp/TSCTTantronImport.jsp";
			}
			</script>	
		<%
		}							
		else if (sProgramName.equals("D4-008P"))  //add by Peggy 20190711
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")"))
			{
				document.location.href="../jsp/TSCTMustardImport.jsp";
			}
			</script>	
		<%
		}	
		else if (sProgramName.equals("D4-020"))  //add by Peggy 20231011
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
			if (confirm("Insert Successfully!!(RFQ:"+ document.MYFORM.PRESEQNO.value+")"))
			{
				document.location.href="../jsp/TSCAPurchaseOrderToRFQ.jsp";
			}
			</script>	
		<%
		}								
		else
		{ 
  			response.sendRedirect("TSSalesDRQ_Create.jsp?PREDNDOCNO="+seqno);
		}
    }
	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
    PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
    pstmt2.close();			 
}
catch(Exception e)
{
	out.println("error:"+e.getMessage());
}
%>
</FORM>
</body>
</html>
