<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 

<%
 String runCardNo=request.getParameter("RUNCARDNO");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 String itemId=request.getParameter("ITEMID"); 
 String semiItemID=request.getParameter("SEMIITEMID");
 
 String oeOrderNo=request.getParameter("OEORDERNO"); 
 String oeLineQtyCh=request.getParameter("OELINEQTY"); 
 String searchString=request.getParameter("SEARCHSTRING");
 String marketType=request.getParameter("MARKETTYPE");
 String woType=request.getParameter("WOTYPE");
 String alternateRouting=request.getParameter("ALTERNATEROUTING");
 String organizationId=request.getParameter("ORGANIZATIONID");
 String customerName=null,customerPo=null,woQty=null,woUom=null,endDate=null;
 String oeHeaderId=null,oeLineId=null,customerId=null;
 String ordORGID="",bookStatus="",shipFromOrgId="",cancelFlag="";
 
 String defaultWoQty=null,frontRunCard=null,oeLineQty=null,moUom=null;
 String tscAmp=null,tscFamily=null,tscPackage=null,tscPacking=null;
 String dateCode=null;

 if (marketType==null || marketType.equals("326"))  marketType = "1"; 
 else if (marketType.equals("327"))  marketType = "2"; 
 
 if (woType==null || woType.equals(""))  woType = "3";  // 預設是後段工令
 
 float leftAddQty = 0;
 
 if (oeLineQtyCh==null || oeLineQtyCh.equals("")) oeLineQtyCh = "0";
 
 String runCardDesc = null; // ItemDesc
 String runCardGet = "";  // itemCodeGet
 int runCardGetLength = 0;   // itemCodeGetLength
  
 //By Choose MarketType Pick Organization_id--Kerwin
  String parOrgID = "";
  try
  {
     Statement stateORG=con.createStatement();	 
     ResultSet rsORG=stateORG.executeQuery("select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
	 //out.println("select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
     if (rsORG.next()) 
	 {
	   parOrgID = rsORG.getString(1);
	   organizationId = rsORG.getString(2); 
	 } else {
	            %>			 
				 <script language="javascript">
					   alert("No Org found , Please Choose Market Type !!!");					   
					   window.opener.document.MYFORM.MARKETTYPE.focus();
					  // this.window.close(); 
				 </script>
			   <%
	        }
	 rsORG.close();
	 stateORG.close();
  }
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  } 
 //By Choose MarketType Pick Organization_id--Kerwin
 
 float moQty=0;
 String exceedFlag = "N";

// out.println("organizationId="+organizationId);
  
  
 try
 {
  if (searchString==null)
   {
    if (invItem!=null && !invItem.equals(""))
	{ searchString= invItem.toUpperCase(); }
	else if (itemDesc != null && !itemDesc.equals(""))
	{  searchString = itemDesc.toUpperCase(); }
	else if (oeOrderNo != null && !oeOrderNo.equals(""))
	{  searchString = oeOrderNo.toUpperCase(); }	
    else { searchString="%"; //out.println("NULL input");
	%>
	      <script LANGUAGE="JavaScript"> 
          <!-- 
		    //alert("test");
           
            flag=confirm("This query could take a long time. Do you wish to continue?");
            if (flag==false)  { this.window.close(); } //alert("test");}//
            //else  return(false);
           
          // --> 
          </script> 
	<%   }
   
   } //end if
 }
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose Item List</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
</head>
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
function sendToMainWindow(jNo,oeOrderNo,invItem,itemDesc,woQty,woUom,endDate,customerName,customerPo,oeHeaderId,oeLineId,itemId,customerId,defaultWoQty,frontRunCard,oeLineQty,moUom,exceedFlag,tscAmp,tscFamily,tscPackage,tscPacking,dateCode,unShipMoQty)
{
 /*
  if (jNo!= "0" && jNo!= "1")
  {
    alert("依預計出貨日排序,您必需選擇項次1 MO單為後段工令\n             此為項次"+jNo+"不允許做為後段工令依據");
  } else { 
 */
          if (exceedFlag=="Y")
		  {
		    alert("加入此項次後,累計選定數量已大於MO單需求數!!!\n           此張流程卡剩餘數將為下次所使用");
		  }
		  
          //alert(tscPackage);
		  
		  //alert(tscFamily);
		  
		  //alert(tscPacking);
		  
		  if (customerPo==null || customerPo=="null") customerPo="";
		  
          window.opener.document.MYFORM.OEORDERNO.value=oeOrderNo; 
		  window.opener.document.MYFORM.OELINEQTY.value=oeLineQty; 
		  window.opener.document.MYFORM.OEQTYUOM.value=moUom;
          window.opener.document.MYFORM.INVITEM.value=invItem; 
          window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
          window.opener.document.MYFORM.WOQTY.value=woQty;
          window.opener.document.MYFORM.WOUOM.value=woUom; 
          window.opener.document.MYFORM.ENDDATE.value=endDate; 
          window.opener.document.MYFORM.CUSTOMERNAME.value=customerName; 
          window.opener.document.MYFORM.CUSTOMERPO.value=customerPo;   
          window.opener.document.MYFORM.OEHEADERID.value=oeHeaderId;   
          window.opener.document.MYFORM.OELINEID.value=oeLineId;  
          window.opener.document.MYFORM.ITEMID.value=itemId;   
          window.opener.document.MYFORM.CUSTOMERID.value=customerId;  
          window.opener.document.MYFORM.FRONTRUNCARD.value=frontRunCard;
		  window.opener.document.MYFORM.TSCPACKAGE.value=tscPackage;
		  window.opener.document.MYFORM.TSCFAMILY.value=tscFamily;
		  window.opener.document.MYFORM.TSCPACKING.value=tscPacking;
		  window.opener.document.MYFORM.DATECODE.value=dateCode;
		  window.opener.document.MYFORM.ORDERQTY.value=unShipMoQty;
          this.window.close();
	// } 
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSMfgMoAdmFind.jsp">
<%
  if (UserRoles.indexOf("YEW_WIP_QUERY")>=0)
  {  //管理員
%>
  <font color="#000099">請輸入MO單開立之成品料號: <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  <font color="#000099">-----依MO單開立後段工令資訊-------------------------------------------- </font>     
  <BR>
  MO單成品BOM資訊
  <BR>
<%
  } // End of if (UserRoles.indexOf("YEW_WIP_QUERY")
%>  
<%  
    ordORGID = "325";

    int ordStrLength = oeOrderNo.length(); //判斷查詢訂單字串長度是否>4
    String orderPrefix = "";
    if (ordStrLength>4)
    {
      orderPrefix = oeOrderNo.substring(0,4); // 是則取前四碼判斷訂單類型
    }
  
    if (orderPrefix=="1156" || orderPrefix.equals("1156"))
	{
	   ordORGID = "41";  // Intercompany 訂單只有一張,故取台半的 ORG_ID
	}
  
  Statement statement=con.createStatement();
  try
  { 
  	      //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	      cs1.setString(1,parOrgID); // By Choose market Set Client info
	      cs1.execute();	     
	 
	    String sql = " select OOH.ORDER_NUMBER MO單號, "+
		             "  OOL.ORDERED_QUANTITY 訂單數量, "+
		             "  OOH.FLOW_STATUS_CODE as 訂單狀態, "+
					 "  OOH.SHIP_FROM_ORG_ID as 出貨地, "+
					 "  OOL.CANCELLED_FLAG as 項目已取消, "+	
					 "  OOL.ORDERED_QUANTITY 未開工令數, "+					
					 "  OOL.ORDER_QUANTITY_UOM as MO單位, "+
					 "  to_char(OOL.SCHEDULE_SHIP_DATE,'YYYYMMDD') as 預計出貨日, "+
					 "  OOL.CUSTOMER_LINE_NUMBER as 客戶訂單號, "+					
					 "  OOH.HEADER_ID as MO單識別碼, OOL.LINE_ID as MO單項次識別碼, "+
					 "  MSI.INVENTORY_ITEM_ID 製成品品號識別碼, "+
					 "  MSI.SEGMENT1 as 成品料號, REPLACE(MSI.DESCRIPTION,'\''',' ') as 品號規格說明, OOH.SOLD_TO_ORG_ID "+					
  					 " from APPS.OE_ORDER_HEADERS_ALL OOH, APPS.OE_ORDER_LINES_ALL OOL, APPS.MTL_SYSTEM_ITEMS MSI ";					     		
		String where = " where OOH.HEADER_ID=OOL.HEADER_ID "+
		               //" and OOL.CANCELLED_FLAG !='Y' "+
					   " AND OOL.FLOW_STATUS_CODE !='SHIPPED' "+
		               //  "   and OOH.FLOW_STATUS_CODE = 'BOOKED' "+
		               "   and OOL.FLOW_STATUS_CODE != 'CLOSED' and OOL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID  "+
					   "   and OOL.LINE_CATEGORY_CODE = 'ORDER' "+
					   "   and OOL.SHIP_FROM_ORG_ID="+organizationId+" "+  // 訂單項次從各自ORG
					   "   and OOH.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID "+
					   "   and OOH.ORG_ID = '"+ordORGID+"' ";
					  // " and OOH.SHIP_FROM_ORG_ID="+organizationId+" ";	
				
		if (oeOrderNo!=null && !oeOrderNo.equals("")) 
		where = where + "and ( to_char(OOH.ORDER_NUMBER) = '"+oeOrderNo+"' or to_char(OOH.ORDER_NUMBER) like '"+oeOrderNo+"%' ) "; 
										   
		String orderby= "	order by to_char(OOL.SCHEDULE_SHIP_DATE,'YYYYMMDD'), OOH.ORDER_NUMBER ";//" OOH.ORDER_NUMBER, OOL.SCHEDULE_SHIP_DATE ";
		
	 					 
		// 需要改為取特定索引 SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)   /			 
		if (searchString =="%" || searchString.equals("%"))			
		{  
		   where = where + " and (MSI.SEGMENT1 = '%') "; //		  
		}
		else 
		{ 
		   where = where + "and ( to_char(OOH.ORDER_NUMBER) = '"+oeOrderNo+"' or to_char(OOH.ORDER_NUMBER) like '"+oeOrderNo+"%' ) ";	     
		}  
 
		sql = sql + where + orderby;	
		//out.println("sql="+sql); 		 
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];           
		out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='left' borderColorLight='#ffffff' border='0'>");          
		out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT COLOR=BROWN>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>說明</TD>"); 
        //out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一,二欄資料ITEMID, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);         
		 out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");		 
        } //end of for 
		//out.println("<TD nowrap color='#FF0000'><FONT COLOR=BROWN>系統判定訂單異常訊息"+"</TD>");	
        out.println("</TR>");
		
        String moNoTmp = null; // 每次取到的MO號給暫存MoNoTmp
        String buttonContent=null;
		String trBgColor = "";
		int j = 0; //項次數
        while (rs.next())
        { 		 		 
		     oeOrderNo=rs.getString(1); //rs.getString("ORDER_NUMBER");
			 oeLineQty=rs.getString(2); //rs.getString("ORDERED_QUANTITY");	   
		     oeHeaderId=rs.getString(10); //rs.getString("HEADER_ID");
		     oeLineId=rs.getString(11); //rs.getString("LINE_ID");				     
    	     itemId=rs.getString(12); //rs.getString("INVENTORY_ITEM_ID");
			 bookStatus=rs.getString(3); // 訂單Booked狀態
		     shipFromOrgId=rs.getString(4); //rs.getString("SHIP_FROM_ORG_ID");		
			 cancelFlag=rs.getString(5); //rs.getString("CANCELLED_FLAG");		
			 woUom = "KPC";    // 工令生產單位
			 endDate=rs.getString(8); //rs.getString("SCH_SHIP_DATE");
			 customerPo=rs.getString(9);//rs.getString("CUSTOMER_LINE_NUMBER");
			 invItem=rs.getString(13); //rs.getString("INV_ITEM");
			 itemDesc=rs.getString(14);//rs.getString("DESCRIPTION");
			 customerId=rs.getString(15); //rs.getString("SOLD_TO_ORG_ID");	
			 
			 moUom=rs.getString(7); //rs.getString("UOM");				 
			 
			 woQty=Float.toString(Float.parseFloat(rs.getString(6))/1000);
			 
			 if (endDate==null || endDate.equals("")) endDate = dateBean.getYearMonthDay();
			
	    out.print("<TR BGCOLOR='"+"#D2D0AA"+"'><TD>");
		
	if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_MFG_PC")>=0 || woType.equals("4") || woType.equals("7"))
	{  // {管理員}或{重工}或{工程實驗}才可以看並帶入_起
	        // Step0. 取料號族群,包裝及安培數	
	          String sqltsc = " SELECT TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Family') TSC_FAMILY, "+
                              "    TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Package') TSC_PACKAGE, "+
                              "    TSC_OM_CATEGORY("+itemId+","+organizationId+",'TSC_Amp') TSC_AMP from dual  "; 				  
              // out.print("<BR>sqltsc="+sqltsc+"<br>");
	          Statement statetsc=con.createStatement();
              ResultSet rstsc=statetsc.executeQuery(sqltsc);
	          if (rstsc.next())
	          { 	
		        tscAmp       = rstsc.getString("TSC_AMP"); 
		        tscFamily    = rstsc.getString("TSC_FAMILY"); 
		        tscPackage   = rstsc.getString("TSC_PACKAGE");
		        tscPacking	= itemDesc.substring(itemDesc.length()-2,itemDesc.length());	 
	          }
	          rstsc.close();
              statetsc.close(); 
			  
			// Step1. 取本Package下對應的年月份 Date Code_起					  
		  	 String sqlDCode = "select DATE_CODE from YEW_DATE_CODE where TSC_PACKAGE = '"+tscPackage+"' "+
			                   "   and PERIOD = '"+dateBean.getYearString()+"/"+dateBean.getMonthString()+"' ";
			 if (alternateRouting==null)
			 {
			   //out.println("alternateRouting="+alternateRouting);
			 }				   
			 else if (alternateRouting=="1" || alternateRouting.equals("1"))
			 {
			   sqlDCode = sqlDCode + " and TSC_MAKEBUY = 'TSC' "; // 自製
			 } else if (alternateRouting=="2" || alternateRouting.equals("2"))
			        {
					   sqlDCode = sqlDCode + " and TSC_MAKEBUY = 'PUR' ";   // 外購
					} else {
					          // sqlDCode = sqlDCode + " and TSC_MAKEBUY = 'TSC' ";	// 之外亦取				  
					       }
	         Statement stateDCode=con.createStatement();
             ResultSet rsDCode=stateDCode.executeQuery(sqlDCode);
			 if (rsDCode.next())
			 {			 
			   dateCode =  rsDCode.getString(1);			   
			 }
			 rsDCode.close();
			 stateDCode.close();
	        // 取本Package下對應的年月份 Date Code_迄
			
			// Step2. 抓客戶名稱
			 
	          String sqlCust = " SELECT CUSTOMER_NAME FROM APPS.RA_CUSTOMERS where CUSTOMER_ID like " +customerId;
		      Statement stateCust=con.createStatement();
	       	  // out.print("sqlCust"+sqlCust);
  		      ResultSet rsCust=stateCust.executeQuery(sqlCust);
		      if (rsCust.next())
		      {  customerName  = rsCust.getString("CUSTOMER_NAME");  }
  		      rsCust.close();
              stateCust.close();
	
       %>       
	   <INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=j%>","<%=oeOrderNo%>","<%=invItem%>","<%=itemDesc%>","<%=woQty%>","<%=woUom%>","<%=endDate%>","<%=customerName%>","<%=customerPo%>","<%=oeHeaderId%>","<%=oeLineId%>","<%=itemId%>","<%=customerId%>","<%=defaultWoQty%>","<%=frontRunCard%>","<%=oeLineQty%>","<%=moUom%>","<%=exceedFlag%>","<%=tscAmp%>","<%=tscFamily%>","<%=tscPackage%>","<%=tscPacking%>","<%=dateCode%>","<%=oeLineQty%>")'>
       <%
	} else {
	         out.println("&nbsp;");		 
	       }
		 out.print("</TD>");		
		 //out.print("<TD nowrap>"+j+"</TD>");		
		  String abnormalDesc = "";
		  if (bookStatus.equals("BOOKED") && (shipFromOrgId.equals("326") || shipFromOrgId.equals("327")) && cancelFlag.equals("N"))
          {   
		    abnormalDesc = "&nbsp;"; 
		    out.print("<TD nowrap>"+abnormalDesc+"</TD>");
		  } // 無異常訊息,可選
          else
          {
             //out.println("<BR>系統判定訂單異常訊息如下 :<BR>");  
             if (bookStatus!=null && !bookStatus.equals("BOOKED"))
             {
                abnormalDesc="<font color='FF0000'><strong>訂單尚未BOOKED(確認)</strong></font>";
             }
  
             if (shipFromOrgId!=null && !shipFromOrgId.equals("326") && !shipFromOrgId.equals("327"))
             {
                abnormalDesc="/<font color='FF0000'><strong>出貨地不為山東廠</strong></font>";
             }
  
             if (cancelFlag!=null && !cancelFlag.equals("N"))
             {
               abnormalDesc="/<font color='FF0000'><strong>訂單項目已取消(CANCELED)</strong></font>";
             }	
		     out.print("<TD nowrap>"+abnormalDesc+"</TD>");
		     //out.println("<TD nowrap><FONT COLOR=BROWN>"+abnormalDesc+"</TD>");// 說明欄位,依訂單狀況給異常說明
		   } // End of else 
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
         {		  
          String s=(String)rs.getString(i);	
		  out.println("<TD nowrap><FONT COLOR=BROWN>"+s+"</TD>");	
         } //end of for		 
		  	 
		   	 
           out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	   //}//end of while
    } //end of try
    catch (Exception e)
    {
       out.println("Exception:"+e.getMessage());
    }
    statement.close();
  %>
  <BR>  
 <%  
   //out.println("<BR>bookStatus="+bookStatus);
   //out.println("shipFromOrgId="+shipFromOrgId);
   //out.println("cancelFlag="+cancelFlag);
   
 %>
<!--%表單參數%-->
<input type="hidden" name="ORGANIZATIONID" value="<%=organizationId%>">
<input type="hidden" name="MARKETTYPE" value="<%=marketType%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
</body>
</html>

