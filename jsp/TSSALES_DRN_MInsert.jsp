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
</script>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
  String docNo=request.getParameter("DOCNO"); 
    
  String customerId=request.getParameter("CUSTOMERID"); 
  String salesAreaNo=request.getParameter("SALESAREANO"); 
  String salesPersonID=request.getParameter("SALESPERSONID"); 
  String customerPO=request.getParameter("CUSTOMERPO"); 
  String receptDate=request.getParameter("RECEPTDATE");
  String curr=request.getParameter("CURR"); 
  String remark=request.getParameter("REMARK"); 
  String preOrderType=request.getParameter("PREORDERTYPE"); 
    
  String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容
  String seqno=null;
  String seqkey=null;
  String dateString=null;
  String formID=request.getParameter("FORMID");
  String typeNo=request.getParameter("TYPENO");
  String fromStatusID=request.getParameter("FROMSTATUSID");
  String actionID=request.getParameter("ACTIONID");
  String recPersonID=userID;
  
  if (receptDate==null || receptDate.equals("")) receptDate=dateBean.getYearMonthDay();
  if (curr==null || curr.equals("")) curr="";
  if (remark==null || remark.equals("")) remark="";
  if (customerPO==null || customerPO.equals("")) customerPO="";
  if (typeNo==null || typeNo.equals("")) typeNo="001"; // 暫時未分詢問單類型, 預設 "001"
  
////
  String customer="";

//String [][] jamDesc=arrayCheckBoxBean.getArray2DContent();//取得session中目前陣列內容;
//String jamDescString="";
//String jamFreq=request.getParameter("JAMFREQ");
//String warrType=request.getParameter("WARRTYPE");
//String warrNo=request.getParameter("WARRNO");
//String seqno=null;
//String seqkey=null;
//String dateString=null;
//String formID=request.getParameter("FORMID");
//String typeNo=request.getParameter("TYPENO");
//String fromStatusID=request.getParameter("FROMSTATUSID");
//String actionID=request.getParameter("ACTIONID");
//String itemNo=request.getParameter("ITEMNO");
//String svrDocNo=request.getParameter("SVRDOCNO");
//String repLvlNo=request.getParameter("REPLVLNO");
//String zip=request.getParameter("ZIP");
//String [] recItemNo=request.getParameterValues("RECITEMNO");
//String recItemString="";
String repCenterNo=request.getParameter("REPCENTERNO");

//String remark=request.getParameter("REMARK");
String otherJamDesc=request.getParameter("OTHERJAMDESC");
   int RepTimes=0;

String agentNo=request.getParameter("AGENTNO"); //經銷/代理商編號
String recType=request.getParameter("RECTYPE"); //收件來源型態
String qty=request.getParameter("QTY"); //收件數量


String fromPage=request.getParameter("FROMPAGE");


//out.println("repeatInput="+repeatInput);


try
{  
  // 判段若未取到詢問單號,則由序號表內動態取得
   if (docNo==null || docNo.equals(""))
   {  
    dateString=dateBean.getYearMonthDay();
    seqkey="TS"+userActCenterNo+dateString;
    //====先取得流水號=====  
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
      
     String sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
     ResultSet rs2=statement.executeQuery(sql); 
     //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
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
       //===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
       String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' ";
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
   
      } // End of Else  //===========(處理跳號問題)
     } // End of Else    
	 docNo = seqno; // 把取到的號碼給本次輸入
   } // End of if (docNo==null || docNo.equals(""))	
   else {
           // 有取到號碼,則由輸入頁面傳過來的單號為 seqno
		   seqno = docNo;
        }	
  
  
  //=============================================================================   
  // 取得 詢問單Flow 狀態   
  Statement getStatusStat=con.createStatement();  
  ResultSet getStatusRs=getStatusStat.executeQuery("select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND TYPENO='"+typeNo+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'");  
  getStatusRs.next();
  
  // 暫時未分詢問單類型
  //Statement svrTypeStat=con.createStatement(); //取得詢問單類型 
  //ResultSet svrTypeRs=svrTypeStat.executeQuery("select SVRTYPENO,SVRTYPENAME from RPSVRTYPE WHERE SVRTYPENO='"+typeNo+"' and LOCALE='"+locale+"'");  
  //svrTypeRs.next();
 
  //String sql="insert into rprepair values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  String sql="insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,"+
                     "AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,REMARK,STATUSID,STATUS,CREATION_DATE,CREATED_BY,"+
					 "LAST_UPDATE_DATE,LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG)"+ 
             " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,seqno);  // 詢問單號
  pstmt.setString(2,salesAreaNo); // 業務地區別代碼
  pstmt.setString(3,salesPersonID);  // 業務人員代碼
  pstmt.setString(4,"");  // 需求原因說明
  pstmt.setString(5,customerId); // 客戶代碼
  try  // 取客戶名稱
  {   
	 Statement statement=con.createStatement();
     ResultSet rs=null;				      									  
	 String sqlSold = "select CUSTOMER_NAME  "+
			          "from APPS.RA_CUSTOMERS where status = 'A' and CUSTOMER_ID = '"+customerId+"' "; 					   
	 rs=statement.executeQuery(sqlSold);
	 if (rs.next())
	 {     
	  customer = rs.getString(1);                             
     } else {
	          customer = "";    
            }  
	 //statement.close();		  		  
	 rs.close();        	 
  } //end of try		 
  catch (Exception e) { out.println("Exception:"+e.getMessage()); }   
  pstmt.setString(6,customer); //客戶名稱
  pstmt.setString(7,customerPO); //客戶訂購單號
  pstmt.setString(8,curr);  // 幣別
  pstmt.setInt(9,0);  // 總金額(amount)
  pstmt.setString(10,receptDate);  // 需求日假設=收件日  
  pstmt.setString(11,"");  // PC 確任日期
  pstmt.setString(12,""); // 工廠回覆確認日
  pstmt.setString(13,""); // 生產工廠代碼
  pstmt.setString(14,remark); // 表頭備註
  pstmt.setString(15,getStatusRs.getString("TOSTATUSID"));//寫入STATUSID
  pstmt.setString(16,getStatusRs.getString("STATUSNAME"));//寫入狀態名稱
  pstmt.setString(17,dateBean.getYearMonthDay()); //寫入日期
  pstmt.setString(18,userID); //寫入User ID
  pstmt.setString(19,dateBean.getYearMonthDay()); //最後更新日期
  pstmt.setString(20,userID); //最後更新User
  pstmt.setString(21,""); //下一個流程
  pstmt.setInt(22,Integer.parseInt(preOrderType));  // 預選 訂單類型
  pstmt.setInt(23,0); // Sold To ORG
  pstmt.setInt(24,0); // Price List
  pstmt.setInt(25,0); // Ship To Org 
  pstmt.executeUpdate(); 
  pstmt.close();
  // Step2. 寫入詢問單表身明細檔
  if (a!=null) // 判斷入若session Array 內值不為null
  {  
    String sqlDtl="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,INVENTORY_ITEM_ID,ITEM_SEGMENT1,QUANTITY,UOM,LIST_PRICE,REQUEST_DATE,SHIP_DATE,"+
                      "PROMISE_DATE,LINE_TYPE,REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY)"+ 
                      " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
   for (int ac=0;ac<a.length;ac++)
   { 	 
      PreparedStatement pstmtDtl=con.prepareStatement(sqlDtl);  
      pstmtDtl.setString(1,seqno);  // 詢問單號
	  String invItemID = "";	
	  String uom = "";
	  Statement statement=con.createStatement();
      ResultSet rs=null;	
	  sql = "select INVENTORY_ITEM_ID,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and SEGMENT1 = '"+a[ac][0]+"' ";						  								 			  
      rs=statement.executeQuery(sql);
	  if (rs.next())
	  {
		invItemID = rs.getString("INVENTORY_ITEM_ID");
		uom =  rs.getString("PRIMARY_UOM_CODE");
	  }			
	  out.println(sql);    
	  rs.close();   
	  statement.close(); 	  
      pstmtDtl.setString(2,invItemID); // Inventory_Item_ID	  
	  pstmtDtl.setString(3,a[ac][0]); // Inventory_Item_Segment1
	  pstmtDtl.setInt(4,Integer.parseInt(a[ac][1])); // Order Qty
	  pstmtDtl.setString(5,uom); // Primary Unit of Measure
	  pstmtDtl.setInt(6,0); // List Price
	  pstmtDtl.setString(7,a[ac][2]); // Request Date
	  pstmtDtl.setString(8,""); // Ship Date
	  pstmtDtl.setString(9,""); // Promise Date
	  pstmtDtl.setInt(10,0); // Line Type
	  pstmtDtl.setString(11,a[ac][3]); // Remark
	  pstmtDtl.setString(12,dateBean.getYearMonthDay()); //寫入日期
      pstmtDtl.setString(13,userID); //寫入User ID
      pstmtDtl.setString(14,dateBean.getYearMonthDay()); //最後更新日期
      pstmtDtl.setString(15,userID); //最後更新User
	  pstmtDtl.executeUpdate(); 
      pstmtDtl.close();
   } //enf of for	
   
  }  // End of if (a!=null) 
  /*

     if (actionID.equals("008"))
     {
	  String nextLvlRepCenterNo="";
	  Statement nextLvlStat=con.createStatement();
	  ResultSet nextLvlRs ;
      if (svrTypeRs.getString("SVRTYPENO").equals("001"))
       { nextLvlRs=nextLvlStat.executeQuery("SELECT DEPENDENCY FROM RPCENTERDEPENDENCY WHERE REPCENTERNO='"+userRepCenterNo+"' ORDER BY DEPENDENCY DESC"); }//ORDER BY DEPENDENCY DESC 
      else
       { nextLvlRs=nextLvlStat.executeQuery("SELECT DEPENDENCY FROM RPCENTERDEPENDENCY WHERE REPCENTERNO='"+userRepCenterNo+"' ORDER BY DEPENDENCY ASC"); }//ORDER BY DEPENDENCY ASC 
	  if (nextLvlRs.next()) 
	  {
	    nextLvlRepCenterNo=nextLvlRs.getString("DEPENDENCY");
	  }
	  nextLvlRs.close();
	  nextLvlStat.close();
      sql="update RPREPAIR set ISTRANSMITTED='Y',REPCENTERNO='"+nextLvlRepCenterNo+"' where REPNO='"+seqno+"'"; 
      pstmt=con.prepareStatement(sql);  
  
      pstmt.executeUpdate();
      pstmt.close();  
	 }

  

  //2005-05-11 ADD
//  out.println(recCenterNo);
//  out.println(svrTypeRs.getString("SVRTYPENO"));
//  out.println(DOAPSelected);
//  out.println(recType);

 */
/*
  //===以下動作為若為新建客戶則寫入客戶基本資料檔     
  Statement getCmrStat=con.createStatement();  
  ResultSet getCmrRs=getCmrStat.executeQuery("select IMEI,WARRLIMIT from RPCUSTOMER WHERE trim(IMEI)='"+imei+"'");  
  
  if (getCmrRs.next()==false)
  {
    sql="insert into RPCUSTOMER(IMEI,DSN,CMRNAME,CMRTEL,CMRCELL,CMRADDR,BUYPLACE,BUYDATE,MODEL,COLOR,WARRNO,CREATEDATE,ZIP,WARRLIMIT) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    pstmt=con.prepareStatement(sql);  
 
    //if (typeNo.equals("002") || typeNo.equals("003")) //若為DOA/DAP則寫入置換之IMEI
	//{
	//  pstmt.setString(1,swapIMEI);
    //} else {	 
	pstmt.setString(1,imei);
	//}
    pstmt.setString(2,dsn);
    pstmt.setString(3,cmrName);
    pstmt.setString(4,cmrTel);
    pstmt.setString(5,cmrCell);
    pstmt.setString(6,cmrAddr);
    pstmt.setString(7,buyPlace);
    pstmt.setString(8,buyYear+buyMonth+buyDate);
    pstmt.setString(9,model);
    pstmt.setString(10,color);  
	pstmt.setString(11,warrNo);
	pstmt.setString(12,dateString);
	pstmt.setString(13,zip);
	pstmt.setString(14,Limit);
       
    pstmt.executeUpdate(); 
  }	             
  else  //2005-06-16 add
  {  
    if (getCmrRs.getString(2) == null || getCmrRs.getString(2).equals("") )  
      {
        sql="update RPCUSTOMER set WARRLIMIT= ? where IMEI= ? ";
        pstmt=con.prepareStatement(sql);  
    	pstmt.setString(1,Limit);
    	pstmt.setString(2,imei);
        pstmt.executeUpdate(); 
	  }
  }
*/
  out.println("insert into Sales Delivery Request value(");%><jsp:getProperty name="rPH" property="pgQDocNo"/><%out.println(":<font color=#FF0000>"+seqno+"</font>- (");%><jsp:getProperty name="rPH" property="pgFreqReturn"/><%out.println(":<font color=#660000>"+RepTimes+"</font>) OK!<BR>");    
  out.println("<A HREF='/oradds/OraddsMainMenu.jsp'>");%><jsp:getProperty name="rPH" property="pgHOME"/><%out.println("</A>&nbsp;&nbsp;");
  out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/CustRepHistoryQueryAll.jsp?RDOCNO="+seqno+"'>");%><jsp:getProperty name="rPH" property="pgRepHistory"/><%out.println("(by RequestNo.)</A>");
  out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/TSSALES_DRN_Create.jsp'>");%><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgDRQInputPage"/><%out.println("(by RequestNo.)</A>");
  
  getStatusRs.close();
  //svrTypeRs.close();  
  //statement.close();
  //rs.close(); 
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<table width="591" border="1">
  <tr>
    <td width="214"></td>
    <td width="162"></td>
    <td width="162"></td>
  </tr>
  <tr>
    <td>
<!--%
  try  
  {
    String MODEL = "D1";    
	Statement statement=con.createStatement();
    //ResultSet rs=statement.executeQuery("select distinct ADDRESS,PROGRAMMERNAME,lineno from RPPROGRAMMER WHERE ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') AND  MODEL='"+MODEL+"' and ADDRESS IS NOT NULL and LOCALE='"+locale+"' order by lineno");    
	ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM RPMENUFUNCTION,RPPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LAN FROM RPLOCALE_T WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') ORDER BY FSEQ ");
    while(rs.next())
    {
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<font size='-1'><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font><br>");
	}
      rs.close(); 
	  statement.close();
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch     
%-->   </td>
    <td>
<!--%
  
  try  
  {
    String MODEL = "F1";    
	String doaLink ="";
	Statement statement=con.createStatement();		
	String sql = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM RPMENUFUNCTION,RPPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LAN FROM RPLOCALE_T WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') ORDER BY FSEQ ";
	                  //"and PROGRAMMERNAME in ('DOA後送工廠在途中','DOA直送1,2級在途中','DOA工廠收件中','DOA已交1,2級維修已收件','DOA工廠派工','DOA收件派工中', 'DOA工廠品檢判定中','DOA工廠維修中','DOA收件判定中','DOA倉管發料中','DOA準備後送中', 'DOA已完修','DOA已入庫','DOA已出貨') order by lineno ";
    ResultSet rs=statement.executeQuery(sql);    				
    while(rs.next())
    {   
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");		
		//out.println("<font size='-1'><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font><br>"); 
		doaLink = doaLink+"<font size='-1'><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font><br>";		
	}
      rs.close(); 
	  statement.close();
	if (repeatInput ==null || repeatInput.equals(""))  
	{ out.println(doaLink);  }
	
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch  
  
%--></td>
    <td><!--%
  try  
  {
    String MODEL = "G1";    
	String dapLink ="";
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM RPMENUFUNCTION,RPPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LAN FROM RPLOCALE_T WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') ORDER BY FSEQ ");    	
    while(rs.next())
    { 
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");		
		//out.println("<font size='-1'><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font><br>"); 
		dapLink =  dapLink+"<font size='-1'><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font><br>";
	}
      rs.close(); 
	  statement.close();
	 if (repeatInput ==null || repeatInput.equals(""))   out.println(dapLink);
	 
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch     
%--></td>
  </tr>
</table>
<!-- 表單參數 -->  
    <input name="PRESEQNO" type="HIDDEN" value="<%=seqno%>">	   
	<input name="REPTIMES" type="HIDDEN" value="<%=RepTimes%>">  <!--做為判斷是否已選取故障描述-->
<%
    arrayCheckBoxBean.setArray2DString(null); //將此bean值清空以為不同case可以重新運作
	array2DimensionInputBean.setArray2DString(null);
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<!--%
 
    if (repeatInput ==null || repeatInput.equals(""))
	{ }
	else
	{
	   if (fromPage =="RepairInputPage.jsp" || fromPage.equals("RepairInputPage.jsp"))
       {    response.sendRedirect("RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
	    else if (fromPage =="(3)RepairInputPage.jsp" || fromPage.equals("(3)RepairInputPage.jsp"))
	          {    response.sendRedirect("(3)RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
	           else if (fromPage =="(X)RepairInputPage.jsp" || fromPage.equals("(X)RepairInputPage.jsp"))
	                 {    response.sendRedirect("(X)RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
  	                else if (fromPage =="(0)RepairInputPage.jsp" || fromPage.equals("(0)RepairInputPage.jsp"))
	                     {    response.sendRedirect("(0)RepairInputPage.jsp?PREREPNO="+seqno+"&PREIMEI="+imei+"&REPTIMES="+RepTimes);  }
	}
	
%-->
</body>
</html>
