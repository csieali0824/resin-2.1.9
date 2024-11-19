<!-- 20151008 liling show  SA STOCK QTY -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
 String runCardNo=request.getParameter("RUNCARD_NO");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 String oeOrderNo=request.getParameter("OEORDERNO"); 
 String itemId=request.getParameter("ITEMID"); 
 String semiItemID=request.getParameter("SEMIITEMID"); 
 
 String woNo=""; 
 String searchString=request.getParameter("SEARCHSTRING");
 String marketType=request.getParameter("MARKETTYPE");
 String organizationId="";
 String woQty=null;
 String runCardQty=null;
 String defaultWoQty=null;
 
 String dateShipSugDate=null; // 出貨日前5天的日期
 
 //out.println("marketType="+marketType);
 
 //By Choose MarketType Pick Organization_id--Kerwin
  String parOrgID = "";
  try
  {
     Statement stateORG=con.createStatement();	 
     ResultSet rsORG=stateORG.executeQuery("select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
//out.println("<BR>select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
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

  
 try
 {
  if (searchString==null)
   {
    if (invItem!=null && !invItem.equals(""))
	{ searchString= invItem.toUpperCase(); }
	else if (itemDesc != null && !itemDesc.equals(""))
	{  searchString = itemDesc.toUpperCase(); }
	else if (runCardNo != null && !runCardNo.equals(""))
	{  searchString = runCardNo.toUpperCase(); }	
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
function sendToMainWindow(jNo,runCardNo,itemId,invItem,itemDesc,woQty, finalInvItemID, finalInvItem, finalItemDesc)
{
  //alert(finalInvItemID);
  //alert(finalInvItem);
  //alert(finalItemDesc);
 
          //window.opener.document.MYFORM.FRONTRUNCARD.value=runCardNo; 
		  window.opener.document.MYFORM.SEMIITEMID.value=itemId; 
          window.opener.document.MYFORM.SEMIINVITEM.value=invItem; 
          window.opener.document.MYFORM.SEMIITEMDESC.value=itemDesc; 
		  window.opener.document.MYFORM.SEMIITEMTITLE.value="半成品料號:"; 
		  window.opener.document.MYFORM.WOQTY.value=woQty; 	  
		  
		  window.opener.document.MYFORM.ITEMID.value=finalInvItemID;   
		  window.opener.document.MYFORM.INVITEM.value=finalInvItem; 
          window.opener.document.MYFORM.ITEMDESC.value=finalItemDesc; 
		  window.opener.document.MYFORM.OEORDERNO.focus();
                     
          this.window.close();
		
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSMfgRunCardFind.jsp">
  <font color="#000099">請輸入開立工令之半成品料號: <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
   <font color="#000099">-----已完工前段工令半成品號--------------------------------------------</font> 
  <BR>
  <%    
      Statement statement=con.createStatement();
	  try
      { 
  	      //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	      cs1.setString(1,parOrgID); // By Choose market Set Client info
	      cs1.execute();	 
		  
	 // 組合MO單下的成品料號對應出半成品料號,作為找前段流程卡依據_起	 
	 String semiItemDesc = null;
     String semiItemCodeGet = "";
     int semiItemCodeGetLength = 0;   
//out.println("<BR>oeOrderNo="+oeOrderNo);
	 if (oeOrderNo!=null && !oeOrderNo.equals("")) // MO 單號不為空值,表示User以MO單查詢
	 {
	         String ItemDesc = null;
             String itemCodeGet = "";
             int itemCodeGetLength = 0;     
             Statement stateItemDesc=con.createStatement(); 
             ResultSet rsItemDesc=stateItemDesc.executeQuery("select ORDERED_ITEM_ID from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER ='"+oeOrderNo+"' ");
             while (rsItemDesc.next()) 
             { 
              ItemDesc = rsItemDesc.getString(1);
	          itemCodeGet = itemCodeGet+"'"+ItemDesc+"'"+","; 
             }
             rsItemDesc.close();
             stateItemDesc.close(); 
			 
            //out.println("select ORDERED_ITEM_ID from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER ='"+oeOrderNo+"' ");
            // 取當月條件內的機種成品料號 //
            if (itemCodeGet.length()>0)
            {   out.println(itemCodeGet);     
             itemCodeGetLength = itemCodeGet.length()-1;
             itemCodeGet = itemCodeGet.substring(0,itemCodeGetLength);
            } 
			
			//out.println("itemCodeGet="+itemCodeGet);
			      
		  // 取BOM_COMPONENT 內動應的半成品料號_起			 
		  if (itemCodeGet!=null && !itemCodeGet.equals(""))			 
		  {
			 Statement stateBC=con.createStatement(); 
             ResultSet rsBC=stateBC.executeQuery(" select  /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */  COMPONENT_ITEM_ID "+
			                                     " from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b "+
												 " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and b.ASSEMBLY_ITEM_ID in ("+itemCodeGet+")  and a.DISABLE_DATE is null ");  //20130925 liling  add a.DISABLE_DATE is null
             while (rsBC.next()) 
             { 
              semiItemDesc = rsBC.getString(1);
	          semiItemCodeGet = semiItemCodeGet+"'"+semiItemDesc+"'"+","; 
             }
             rsBC.close();
             stateBC.close(); 
			 
			 if (semiItemCodeGet.length()>0)
             {        
              semiItemCodeGetLength = semiItemCodeGet.length()-1;            
              semiItemCodeGet = semiItemCodeGet.substring(0,semiItemCodeGetLength); // 取到對應半成品料號ID
             } 
			
			} // End of if (itemCodeGet!=null)
			// 取BOM_COMPONENT 內動應的半成品料號_迄			
			
	 }
	 // 組合MO單下的成品料號對應出半成品料號,作為找前段流程卡依據_迄	  
	   String sql = "";
	   String sqlRC = "";
	   String where = "";
	   String whereRC = "";
	   String orderby = "";
	   String orderbyRC = "";
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	 
	       
	     sqlRC = " select DISTINCT decode(YWA.ORGANIZATION_ID,'326','內銷','327','外銷',YWA.ORGANIZATION_ID) as 內外銷別, YRA.PRIMARY_ITEM_ID as 半成品識別碼, YRA.INV_ITEM as 半成品品號, REPLACE(YRA.ITEM_DESC,'\''',' ') as 品號規格說明 "+					
					 //"   to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as 前段展開日期 "+
			     " ,YEW_ONHAND_F(ywa.INVENTORY_ITEM_ID,ywa.ORGANIZATION_ID,'02') as 半成倉庫存 "+ //20151008 liling
  				" from YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA ";			 
		 whereRC = "  where YWA.WO_NO=YRA.WO_NO and YWA.WORKORDER_TYPE in (2,7) "+ // 取前段流程卡已開立的作為開後段工令條件					   
					   // " and YRA.STATUSID in ( '048', '049' ) and YRA.COMPLETION_QTY > YRA.WIP_USED_QTY "+ //2006/11/10 更正為前段已開立工令
					   "  "; // 先前開過的前段流程卡不能被選到
		//String orderby= "	order by to_char(to_date(YRA.CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') ";//" OOH.ORDER_NUMBER, OOL.SCHEDULE_SHIP_DATE ";		
		
		//if (invItem!=null && !invItem.equals("")) where = where + "and YRA.INV_ITEM = '"+invItem+"' ";
		if (semiItemID!=null && !semiItemID.equals("")) whereRC = whereRC + "and YRA.PRIMARY_ITEM_ID = '"+semiItemID+"' ";
		
		if (semiItemCodeGet!=null && !semiItemCodeGet.equals("")) // MO 單號不為空值,表示User以MO單查詢
		{
		  whereRC = whereRC +" and YRA.PRIMARY_ITEM_ID in ("+semiItemCodeGet+") ";  // 以MO成品料號的ID對應的半成品料號ID作為找流程卡的條件
		}
		
		if (runCardNo!=null && !runCardNo.equals("")) 
		{  // 若輸入流程卡號欄位作查詢,則可能以流程卡號或料號或料號說明作查詢依據_起
		   // 20091125 Marvie Update : Performance Issue
		   //whereRC = whereRC + "and ( YRA.RUNCARD_NO = '"+runCardNo+"' or YRA.INV_ITEM = '"+runCardNo+"'  or YRA.INV_ITEM like '"+runCardNo+"%' or YRA.ITEM_DESC like '%"+runCardNo+"%' )  "; 		
		   whereRC = whereRC + "and YRA.INV_ITEM = '"+runCardNo+"' "; 		
		} 					 
		// 需要改為取特定索引 SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)   /			 
		if (searchString =="%" || searchString.equals("%"))			
		{  
		 whereRC = whereRC + " and (YRA.INV_ITEM like '%') "; //  若都沒輸入則全部尋找符合完工的前段流程卡
		 //sql = sql + "and (a.SEGMENT1 = '%') ";   
		}			 
		
		 sql =   " select DISTINCT decode(a.ORGANIZATION_ID,'326','內銷','327','外銷',a.ORGANIZATION_ID) as 內外銷別, "+
		         "       a.INVENTORY_ITEM_ID as 半成品識別碼, b.SEGMENT1 as 半成品品號, b.DESCRIPTION as 品號規格說明   "+
				 "       ,YEW_ONHAND_F(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'02') as 半成倉庫存  "+  //20151008 liling
		         "  from MTL_LOT_NUMBERS a, MTL_SYSTEM_ITEMS b ";
		where = "  where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
				"    and b.ITEM_TYPE ='SA' and substr(b.SEGMENT1,5,1) = '-' and length(b.SEGMENT1) != 22  "; 			   
	    orderby= "  ";
		 
		if (semiItemID!=null && !semiItemID.equals("")) where = where + "and a.INVENTORY_ITEM_ID = '"+semiItemID+"' ";
		
		if (semiItemCodeGet!=null && !semiItemCodeGet.equals("")) // MO 單號不為空值,表示User以MO單查詢
		{
		  where = where +" and a.INVENTORY_ITEM_ID in ("+semiItemCodeGet+") ";  // 以MO成品料號的ID對應的半成品料號ID作為找流程卡的條件
		}
		
		if (runCardNo!=null && !runCardNo.equals("")) 
		{  // 若輸入流程卡號欄位作查詢,則可能以流程卡號或料號或料號說明作查詢依據_起
		   // 20091125 Marvie Update : Performance Issue
		   //where = where + "and ( a.LOT_NUMBER = '"+runCardNo+"' or b.SEGMENT1 = '"+runCardNo+"' or b.SEGMENT1 like '"+runCardNo+"%' or b.DESCRIPTION like '%"+runCardNo+"%' )  "; 		
		   where = where + "and b.SEGMENT1 = '"+runCardNo+"' "; 		
		} 	
				
		sql = sql + where + " UNION "+ sqlRC + whereRC + orderby;
		
//out.println("<BR>sql="+sql);
        ResultSet rs=statement.executeQuery(sql);
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];           
		out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='50%' align='left' borderColorLight='#ffffff' border='0'>");          
		out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>項次</TD>"); 
        //out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一,二欄資料ITEMID, 故 for 由 2開始
        {
          colLabel[i]=md.getColumnLabel(i);		
          out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");		
        } //end of for 		
		out.println("<TD nowrap><FONT COLOR=BROWN>舊系統庫存批(是/否)"+"</TD>");
		//out.println("<TD nowrap><FONT COLOR=BROWN>成品BOM(有/無)"+"</TD>");
        out.println("</TR>");
      		
        String buttonContent=null;
		String trBgColor = "";
		String prodBOMFlag = "有";
		int j = 0; //項次數
        while (rs.next())
        {   /*		
		        try // 2007/01/06 將取到的半成品找其成品階資訊
	            {
	                     CallableStatement csBOMInfo = con.prepareCall("{call YEW_BOM_IMPLODER_SUBASB(?,?,?,?,?,?,?,?)}");
	                     csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			             csBOMInfo.setString(2,rs.getString(2));	                     
	                     csBOMInfo.registerOutParameter(3, Types.INTEGER);   // 回傳 Parent Item ID
	                     csBOMInfo.registerOutParameter(4, Types.VARCHAR);   // 回傳 Parent Inv Item
	                     csBOMInfo.registerOutParameter(5, Types.VARCHAR);   // 回傳 Parent Item Desc
	                     csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // 回傳 Error Message
	                     csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // 回傳 Error Code
				         csBOMInfo.registerOutParameter(8, Types.INTEGER);   // 回傳 此次成品階筆數				        
	                     csBOMInfo.execute();
						 
			             int parentInvItemID = csBOMInfo.getInt(3);
	                     String parentInvItem = csBOMInfo.getString(4);     //  回傳 REQUEST 執行狀況
	                     String parentItemDesc = csBOMInfo.getString(5);    //  回傳 Parent Item Desc
	                     String errorMessage = csBOMInfo.getString(6);      //  回傳 REQUEST 執行狀況
	                     String errorCode = csBOMInfo.getString(7);         //  回傳 REQUEST 執行狀況訊息
	                     int rowNum = csBOMInfo.getInt(8);	                //  回傳 此次成品階筆數
	                     out.println("parentInvItem ="+parentInvItem);
						 out.println("errorMessage ="+errorMessage+"<BR>");
	                     csBOMInfo.close(); 	  
						 
						//String prodBOMFlag = "有";
						 if (parentInvItem==null || parentInvItem.equals("") || parentInvItem.equals("null")) 
						 { prodBOMFlag = "無"; }
	  
	            } //end of try
                catch (SQLException e)
                {
                   out.println("Exception with Imploder BOM:"+e.getMessage());
                }		
		  */
		 
		 // runCardNo=rs.getString(1);//rs.getString("RUNCARD_NO");
		 //runCardQty=rs.getString(2);//rs.getString("WO_QTY");
		 runCardNo="";
		 runCardQty="0";
		 itemId=rs.getString(2);	
		 invItem=rs.getString(3);
		 itemDesc=rs.getString(4);		
    	
		 woQty = runCardQty ;			 
		 	 
		 String finalInvItemID = "";
		 String finalInvItem = "";
		 String finalItemDesc = "";		
		 
		 if (runCardNo!=null && !runCardNo.equals("")) // 若輸入前段流程卡號查詢
	     {	   
	      String organizationID = "";
          Statement stateItemDesc=con.createStatement(); 
		  String a="select  /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */ "+    // 
		                                                   "      b.ASSEMBLY_ITEM_ID, c.ORGANIZATION_ID "+
		                                                   " from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, YEW_RUNCARD_ALL c "+
		                                                   " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and COMPONENT_ITEM_ID=c.PRIMARY_ITEM_ID "+
														   "   and a.DISABLE_DATE is null "+ //20130925 liling add
														   "   and c.RUNCARD_NO = '"+runCardNo+"' ";
														   
		   
          ResultSet rsItemDesc=stateItemDesc.executeQuery("select  /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */ "+    // 
		                                                   "      b.ASSEMBLY_ITEM_ID, c.ORGANIZATION_ID "+
		                                                   " from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, YEW_RUNCARD_ALL c "+
		                                                   " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and COMPONENT_ITEM_ID=c.PRIMARY_ITEM_ID "+
														   "    and a.DISABLE_DATE is null  "+ //20130925 liling add
														   "   and c.RUNCARD_NO = '"+runCardNo+"' ");
             if (rsItemDesc.next()) 
             { 
                finalInvItemID = rsItemDesc.getString(1);
			    organizationID = rsItemDesc.getString(2);
			    //再取可組成之成品料號
			    Statement statefinInvItem=con.createStatement();
			    ResultSet rsfinInvItem=statefinInvItem.executeQuery("select SEGMENT1, DESCRIPTION from MTL_SYSTEM_ITEMS where ORGANIZATION_ID ='"+organizationID+"' and INVENTORY_ITEM_ID = "+finalInvItemID+" ");
			    if (rsfinInvItem.next())
			    {
			     finalInvItem = rsfinInvItem.getString(1);
				 finalItemDesc = rsfinInvItem.getString(2);
			    } else {
				        finalInvItemID = "";
						finalInvItem = "";
						finalItemDesc = "";			
				       }
			    rsfinInvItem.close();
			    statefinInvItem.close();
	         
              }
              rsItemDesc.close();
              stateItemDesc.close(); 
        } // 若輸入前段流程卡號查詢 
		
		  String wipCreateLot = "是";		  
		  Statement stateRC=con.createStatement(); 
		//  out.print("select RUNCARD_NO from YEW_RUNCARD_ALL where INV_ITEM = '"+rs.getString(3)+"' ");
		  
          ResultSet rsRC=stateRC.executeQuery("select RUNCARD_NO from YEW_RUNCARD_ALL where INV_ITEM = '"+rs.getString(3)+"' ");	 
		  if (rsRC.next())
		  {
		     wipCreateLot = "否"; 
		  } else {   wipCreateLot = "是";  }
	      rsRC.close();
		  stateRC.close();		   
	    out.print("<TR BGCOLOR='"+"#D2D0AA"+"'><TD>");	
		j++; // 項次數 		
		//buttonContent="this.value=sendToMainWindow("+'"'+oeOrderNo+'"'+","+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+woQty+'"'+","+'"'+woUom+'"'+","+'"'+endDate+'"'+","+'"'+customerName+'"'+","+'"'+customerPo+'"'+","+'"'+oeHeaderId+'"'+","+'"'+oeLineId+'"'+","+'"'+itemId+'"'+","+'"'+customerId+'"'+")";	 
       %>
       <INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=j%>","<%=runCardNo%>","<%=itemId%>","<%=invItem%>","<%=itemDesc%>","<%=woQty%>","<%=finalInvItemID%>","<%=finalInvItem%>","<%=finalItemDesc%>")'>
       <%
		
		 out.print("</TD>");		
		 out.print("<TD nowrap>"+j+"</TD>");		
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
         {
           String s=(String)rs.getString(i);
		   out.println("<TD nowrap><FONT>"+s+"</TD>");			
         } //end of for		 
		 out.println("<TD nowrap><FONT>"+wipCreateLot+"</TD>");
		/* 
		 if (prodBOMFlag.equals("有"))
		 {
		   out.println("<TD nowrap><FONT>"+prodBOMFlag+"</TD>");
		 } else { 
		            out.println("<TD nowrap><strong><FONT color='#FF0000'><em>"+prodBOMFlag+"</em></font></strong></TD>");
		        }
		*/
         out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	   }//end of while
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
	  statement.close();
     %>
  <BR>
<!--%表單參數%-->
<input type="hidden" name="MARKETTYPE" value="<%=marketType%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
