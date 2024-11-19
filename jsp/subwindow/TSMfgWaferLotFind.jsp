<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<%
 String marketType=request.getParameter("MARKETTYPE");
 String organizationId = request.getParameter("ORGANIZATIONID");
 String primaryFlag=request.getParameter("PRIMARYFLAG");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 String waferLot=request.getParameter("WAFERLOT"); 
 String searchString=request.getParameter("SEARCHSTRING");
 String waferVendor=null,waferQty=null,waferUom=null,waferIqcNo=null,waferYld=null,waferKind=null,waferElect=null ;
 String woUom=null,itemId=null ,woWaferIqcNo=null,woWaferQty=null,waferLineNo=null,result=null,waferAmp=null;
 float avaibleQty=0;
 
   String orgID = "";
   Statement stateID=con.createStatement();   
   ResultSet rsID=stateID.executeQuery("select ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE ='MARKETTYPE' and  CODE= '"+marketType+"' ");
   if (rsID.next())
   {
     organizationId = rsID.getString(1);
   }
   rsID.close();
   stateID.close();
  
 try
 {
  if (searchString==null)
   {
    if (invItem!=null && !invItem.equals(""))
	{ searchString= invItem.toUpperCase(); }
	else if (itemDesc != null && !itemDesc.equals(""))
	{  searchString = itemDesc.toUpperCase(); }
	else if (waferLot != null && !waferLot.equals(""))
	{  searchString = waferLot.toUpperCase(); }
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
<title>Page for choose IQC Wafer Lot List</title>
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
.style1 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
}
</STYLE>
</head>
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind,itemId,woUom,waferLineNo)
{ 
 window.opener.document.MYFORM.WAFERLOT.value=waferLot;  
 window.opener.document.MYFORM.INVITEM.value=invItem; 
 window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
 window.opener.document.MYFORM.WAFERVENDOR.value=waferVendor; 
 window.opener.document.MYFORM.WAFERQTY.value=waferQty; 
 window.opener.document.MYFORM.WAFERUOM.value=waferUom;
 window.opener.document.MYFORM.WAFERYLD.value=waferYld; 
 window.opener.document.MYFORM.WAFERELECT.value=waferElect;  
 window.opener.document.MYFORM.WAFERIQCNO.value=waferIqcNo;
 window.opener.document.MYFORM.WAFERKIND.value=waferKind;  
 window.opener.document.MYFORM.ITEMID.value=itemId; 
 window.opener.document.MYFORM.WOUOM.value=woUom;  
 window.opener.document.MYFORM.WAFERLINENO.value=waferLineNo; 
 //alert(waferLineNo);
 this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSMfgWaferLotFind.jsp">
  <font size="-1">批號或半成品料號: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  -----批號或半成品料號資訊-------------------------------------------     
  <BR>
  <%  
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	
	      String sql = "select 'ACCEPT' as RESULT, b.LOT_NUMBER as WAFERLOT, b.LOT_NUMBER as 半成品批號, c.SEGMENT1 as 製成半成品號, "+
		               "        c.SEGMENT1, REPLACE(c.DESCRIPTION,'"+"\""+"',' inch ') as ITEM_DESC, "+
					   "        'IQCNO' as WAFERIQCNO, 'WAFER_VENDOR' as SUPPLIER_SITE_NAME, 'YIELD' as TOTAL_YIELD, "+
					   "        'KIND' as WF_TYPE_NAME, '' as WF_RESIST , a.PRIMARY_TRANSACTION_QUANTITY as WO_COMPLETED_QTY, a.TRANSACTION_UOM_CODE as WO_UOM, "+
				 	   "        c.INVENTORY_ITEM_ID, 1 as LINE_NO, b.CREATION_DATE as CREATION_DATE, '' as WAFER_AMP	"+
		               "  from MTL_ONHAND_QUANTITIES_DETAIL a,  MTL_LOT_NUMBERS b, MTL_SYSTEM_ITEMS c ";
		  String where=" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID and b.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID"+
		               "  and a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
				       "  and c.ORGANIZATION_ID = "+organizationId+" and a.LOT_NUMBER = b.LOT_NUMBER "+
					   // "  and length(c.SEGMENT1)=13 "+
					   "  and a.ORGANIZATION_ID = "+organizationId+" ";
					 
		  if (searchString =="%" || searchString.equals("%"))			
		  {  
		   where = where + " and (b.LOT_NUMBER != '%') ";
		   //sql = sql + "and (a.SEGMENT1 = '%') ";   
		  }
		  else 
		  { 
		   where = where + "  and (upper(b.LOT_NUMBER) = '"+waferLot.toUpperCase()+"' or upper(b.LOT_NUMBER) like '"+waferLot.toUpperCase()+"%') ";
		  }  	
		 sql = sql + where;	
		 Statement statePrev=con.createStatement();
		 ResultSet rsPrev=statePrev.executeQuery(sql);				   
		 while (rsPrev.next())
		 {			 
			             CallableStatement csBOMInfo = con.prepareCall("{call YEW_BOM_IMPLODER_SUBASB(?,?,?,?,?,?,?,?,?)}");
	                     csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 			             
	                     csBOMInfo.setInt(2,rsPrev.getInt("INVENTORY_ITEM_ID")); 	                    
	                     csBOMInfo.registerOutParameter(3, Types.INTEGER);   // 回傳 Parent Item ID
	                     csBOMInfo.registerOutParameter(4, Types.VARCHAR);   // 回傳 Parent Inv Item
	                     csBOMInfo.registerOutParameter(5, Types.VARCHAR);   // 回傳 Parent Item Desc
	                     csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // 回傳 Error Message
	                     csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // 回傳 Error Code
				         csBOMInfo.registerOutParameter(8, Types.INTEGER);  // 回傳 此次筆數				        
				         csBOMInfo.setString(9,"SA");                     // 正式查詢半成品
	                     csBOMInfo.execute();
			             int parentInvItemID = csBOMInfo.getInt(3);
	                     String parentInvItem = csBOMInfo.getString(4);       //  回傳 REQUEST 執行狀況
	                     String parentItemDesc = csBOMInfo.getString(5);
	                     String errorMessage = csBOMInfo.getString(6);      //  回傳 REQUEST 執行狀況
	                     String errorCode = csBOMInfo.getString(7);         //  回傳 REQUEST 執行狀況訊息
	                     int rowNum = csBOMInfo.getInt(8);	                 //  回傳 此次 筆數
	                     // out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	                     csBOMInfo.close(); 		 
		      
	     } // End of while
		 rsPrev.close();
		 statePrev.close();
		 
	         sql = "select DISTINCT 'ACCEPT' as RESULT, b.LOT_NUMBER as WAFERLOT, b.LOT_NUMBER as 半成品批號, a.PARENT_INV_ITEM as 製成半成品號, "+
		             "     a.PARENT_INV_ITEM, REPLACE(a.PARENT_ITEM_DESC,'"+"\""+"',' inch ') as ITEM_DESC, "+
					 "     'IQCNO' as WAFERIQCNO, 'WAFER_VENDOR' as SUPPLIER_SITE_NAME, 'YIELD' as TOTAL_YIELD, "+
					 "     'KIND' as WF_TYPE_NAME, '' as WF_RESIST , d.PRIMARY_TRANSACTION_QUANTITY as WO_COMPLETED_QTY, d.TRANSACTION_UOM_CODE as WO_UOM, "+
					 "     a.PARENT_ITEM_ID as INVENTORY_ITEM_ID, 1 as LINE_NO, to_char(b.CREATION_DATE,'YYYYMMDDHH24MISS') as INSPECT_DATE, '' as WAFER_AMP	"+
			         "  from APPS.YEW_BOM_IMPL_TEMP a,  MTL_LOT_NUMBERS b, MTL_SYSTEM_ITEMS c, MTL_ONHAND_QUANTITIES_DETAIL d ";
		     where = " where a.LOWEST_ITEM_ID = b.INVENTORY_ITEM_ID and a.LOWEST_ITEM_ID = c.INVENTORY_ITEM_ID "+
					 "   and b.INVENTORY_ITEM_ID = d.INVENTORY_ITEM_ID and a.LOWEST_ITEM_ID = d.INVENTORY_ITEM_ID "+
					 "   and a.ORGANIZATION_ID = d.ORGANIZATION_ID "+
					 "   and d.LOT_NUMBER = b.LOT_NUMBER and a.CURRENT_LEVEL != 0 "+
					 "   and a.ORGANIZATION_ID = c.ORGANIZATION_ID and b.ORGANIZATION_ID = c.ORGANIZATION_ID  "+
					 //"   and to_char(b.CREATION_DATE,'YYYYMMDD')<= '20070102' "+
					 "   and length(a.PARENT_INV_ITEM) = 13 and a.ORGANIZATION_ID = "+organizationId+" ";
		// 需要改為取特定索引 SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		if (searchString =="%" || searchString.equals("%"))			
		{  
		 where = where + " and (b.LOT_NUMBER != '%') ";
		 //sql = sql + "and (a.SEGMENT1 = '%') ";   
		}
		else 
		{ 
		 where = where + "  and (upper(b.LOT_NUMBER) = '"+waferLot.toUpperCase()+"' or upper(b.LOT_NUMBER) like '"+waferLot.toUpperCase()+"%') ";
		}  	
		sql = sql + where;	
		//out.println("sql="+sql); 		 
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE>");      
        out.println("<TR><TD BGCOLOR=BULE nowrap><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TD BGCOLOR=BULE nowrap><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        { //out.println("Step1");
	 
		  String sqlQCLot = "select d.RESULT, h.INSPLOT_NO, d.LINE_NO, h.SUPPLIER_NAME, h.TOTAL_YIELD, t.WF_TYPE_NAME,  "+
		                    "       h.SUPPLIER_SITE_NAME, h.WF_RESIST, h.WAFER_AMP, d.RECEIPT_QTY , h.UOM "+
		                    "  from ORADDMAN.TSCIQC_LOTINSPECT_HEADER h, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d, ORADDMAN.TSCIQC_WAFER_TYPE t "+
						    " where h.INSPLOT_NO = d.INSPLOT_NO and d.WAFER_TYPE = t.WF_TYPE_ID "+
						    "   and d.SUPPLIER_LOT_NO = '"+rs.getString("WAFERLOT")+"'  ";
		 Statement stateQCLot=con.createStatement();					
		 ResultSet rsQCLot=stateQCLot.executeQuery(sqlQCLot);
		 if (rsQCLot.next())
		 {		
		    result = rsQCLot.getString("RESULT");
		    waferVendor=rsQCLot.getString("SUPPLIER_SITE_NAME");
 		    waferQty=rsQCLot.getString("RECEIPT_QTY");
		    waferUom=rsQCLot.getString("UOM");
		    waferYld=rsQCLot.getString("TOTAL_YIELD");
		    waferElect=rsQCLot.getString("WF_RESIST");
		    waferIqcNo=rsQCLot.getString("INSPLOT_NO");	
		    waferKind=rsQCLot.getString("WF_TYPE_NAME");
		    waferLineNo=rsQCLot.getString("LINE_NO");
			waferAmp=rsQCLot.getString("WAFER_AMP");
			
		// out.println("Step2");
		 } // End of if (IQC Lot Info.next())
		 rsQCLot.close();
		 stateQCLot.close();	
	 
		 waferLot=rs.getString(2);		
		 invItem=rs.getString(5);
		 itemDesc=rs.getString(6);		
		 itemId=rs.getString(14);	 // 取Inventory_item_id		 
		 
		 //out.print("invItem="+invItem);
  
		 //-----抓取存在工單檔裡的檢驗批 ------
		 String sqla2= "  select wafer_lot_no,wafer_qty from APPS.YEW_WORKORDER_ALL  where WAFER_LOT_NO = '"+waferIqcNo+"' and WAFER_LINE_NO= '"+waferLineNo+"'";
	    Statement statea2=con.createStatement();
		//out.print("sqla1="+sqla2);
        ResultSet rsa2=statea2.executeQuery(sqla2);
		//out.print("sqla1="+sqla2);
    	 if (rsa2.next())
		 { 	//woWaferIqcNo   = rsa2.getString("WAFER_LOT_NO");   
	   		    woWaferQty     = rsa2.getString("WAFER_QTY");
		 }
		 else { woWaferQty="0"; }  
	    rsa2.close();
        statea2.close();
		
//out.println("Step3");
        if (waferQty==null || waferQty.equals("")) waferQty = "0";
 
		avaibleQty=( Float.parseFloat(waferQty)- Float.parseFloat(woWaferQty));
		waferQty=String.valueOf(avaibleQty);
		
		//抓計量單位
		String sqla1= " select PRIMARY_UNIT_OF_MEASURE WOUOM  from apps.mtl_system_items_b "+
					  "  where Organization_id=43  and segment1= '"+invItem +"'";	     
 
	    Statement statea1=con.createStatement();
        ResultSet rsa1=statea1.executeQuery(sqla1);
		//out.print("sqla1="+sqla1);
    	 if (rsa1.next())
		 { 	woUom   = rsa1.getString("WOUOM");   }
	    rsa1.close();
        statea1.close();
//out.println("Step4");		
		%>
		<INPUT TYPE="hidden" NAME="WAFERLOT" SIZE=10 value="<%=waferLot%>" >
		<INPUT TYPE="hidden" NAME="INVITEM" SIZE=10 value="<%=invItem%>" >
		<INPUT TYPE="hidden" NAME="ITEMDESC" SIZE=10 value="<%=itemDesc%>" >
		<INPUT TYPE="hidden" NAME="WAFERVENDOR" SIZE=10 value="<%=waferVendor%>" >
		<INPUT TYPE="hidden" NAME="WAFERQTY" SIZE=10 value="<%=waferQty%>" >
		<INPUT TYPE="hidden" NAME="WAFERUOM" SIZE=10 value="<%=waferUom%>" >
		<INPUT TYPE="hidden" NAME="WAFERYLD" SIZE=10 value="<%=waferYld%>" >
		<INPUT TYPE="hidden" NAME="WAFERELECT" SIZE=10 value="<%=waferElect%>" >
		<INPUT TYPE="hidden" NAME="WAFERIQCNO" SIZE=10 value="<%=waferIqcNo%>" >
		<INPUT TYPE="hidden" NAME="WAFERKIND" SIZE=10 value="<%=waferKind%>" >
		<INPUT TYPE="hidden" NAME="ITEMID" SIZE=10 value="<%=itemId%>" >
		<INPUT TYPE="hidden" NAME="WOUOM" SIZE=10 value="<%=woUom%>" >
		<INPUT TYPE="hidden" NAME="WAFERLINENO" SIZE=10 value="<%=waferLineNo%>" >
		
<%	
		//buttonContent="this.value=sendToMainWindow("+'"'+waferLot+'"'+","+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+waferVendor+'"'+","+'"'+waferQty+'"'+","+'"'+waferUom+'"'+","+'"'+waferYld+'"'+","+'"'+waferElect+'"'+","+'"'+waferIqcNo+'"'+","+'"'+waferKind+'"'+","+'"'+itemId+'"'+","+'"'+woUom+'"'+","+'"'+waferLineNo+'"'+")";
		out.print("<TR BGCOLOR='"+"#DDFFDD"+"'><TD>");
		%>
		<INPUT TYPE=button NAME='button' VALUE='帶入' onClick='this.value=sendToMainWindow("<%=waferLot%>","<%=invItem%>","<%=itemDesc%>","<%=waferVendor%>","<%=waferQty%>","<%=waferUom%>","<%=waferYld%>","<%=waferElect%>","<%=waferIqcNo%>","<%=waferKind%>","<%=itemId%>","<%=woUom%>","<%=waferLineNo%>")'>
    <%
		 out.print("</TD>");		
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         {		   		 
           String s=(String)rs.getString(i);
		   
		   if (i==1)  {  out.println("<TD nowrap><FONT SIZE=2>"+result+"</TD>");  } 
		   else if (i==7) {  out.println("<TD nowrap><FONT SIZE=2>"+waferIqcNo+"</TD>");  }
		   else if (i==8) {  out.println("<TD nowrap><FONT SIZE=2>"+waferVendor+"</TD>");  }
		   else if (i==9) {  out.println("<TD nowrap><FONT SIZE=2>"+waferYld+"</TD>");  }
		   else if (i==10) {  out.println("<TD nowrap><FONT SIZE=2>"+waferKind+"</TD>");  }
		   else if (i==11) {  out.println("<TD nowrap><FONT SIZE=2>"+waferElect+"</TD>");  }
		   else if (i==15) {  out.println("<TD nowrap><FONT SIZE=2>"+waferLineNo+"</TD>");  }
		   else if (i==17) {  out.println("<TD nowrap><FONT SIZE=2>"+waferAmp+"</TD>");  }		   
           else {  out.println("<TD nowrap><FONT SIZE=2>"+s+"</TD>");  }
		    
		   //out.println("<TD nowrap><FONT SIZE=2>"+s+"</TD>"); 
          } //end of for
          out.println("</TR>");	
		//out.println("Step5");  
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
   <%
     // 作完查詢刪除找ITEM WHERE USER 寫入的TEMP Table_起
	         //delete from APPS.YEW_BOM_IMPL_TEMP where to_char(IMPLOSION_DATE,'YYYYMMDDHH24MI') ='"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+"'
	          PreparedStatement stmtDelTmp=con.prepareStatement("delete from APPS.YEW_BOM_IMPL_TEMP ");          
	          stmtDelTmp.executeUpdate();
              stmtDelTmp.close();	 
     // 作完查詢刪除找ITEM WHERE USER 寫入的TEMP Table_迄
  %>
  <hr>
  <font color="#FF0000">批號庫存資訊</font><br>
  <%
       //抓OnHand數
	    out.println("");
	    out.println("<table cellSpacing='1' bordercolordark='#B5B89A' cellPadding='1' width='87%' align='left' bordercolorlight='#FFFFFF'  border='0'>");
		out.println("<tr bgcolor='#CCCC99'><td nowrap>內/外銷別</td><td nowrap>倉別</td><td nowrap>批號</td><td nowrap>料號</td><td nowrap>品名規格</td><td nowrap>庫存OnHand數</td><td nowrap>單位</td></tr>");
	 	String sqlOH= " select decode(a.ORGANIZATION_ID,'326','內銷','327','外銷') as MARKETTYPE, a.SUBINVENTORY_CODE, a.LOT_NUMBER,  b.SEGMENT1, b.DESCRIPTION, a.PRIMARY_TRANSACTION_QUANTITY, a.TRANSACTION_UOM_CODE, a.ORIG_DATE_RECEIVED "+
		              " from MTL_ONHAND_QUANTITIES_DETAIL a, MTL_SYSTEM_ITEMS b "+
					  "  where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
					  "    and a.ORGANIZATION_ID= "+organizationId+"   "+
					  "    and a.ORGANIZATION_ID = b.ORGANIZATION_ID     "+
					  "    and a.LOT_NUMBER= '"+waferLot+"' ";	      
	    Statement stateOH=con.createStatement();
        ResultSet rsOH=stateOH.executeQuery(sqlOH);
		while (rsOH.next())
		{
		    out.println("<tr bgcolor='#CCCC99'>");
			out.println("<td>"+rsOH.getString("MARKETTYPE")+"</td><td>"+rsOH.getString("SUBINVENTORY_CODE")+"</td><td nowrap>"+rsOH.getString("LOT_NUMBER")+"</td><td nowrap>"+rsOH.getString("SEGMENT1")+"</td><td nowrap>"+rsOH.getString("DESCRIPTION")+"</td><td nowrap>"+rsOH.getString("PRIMARY_TRANSACTION_QUANTITY")+"</td><td nowrap>"+rsOH.getString("TRANSACTION_UOM_CODE")+"</td>");
			out.println("</tr>");
		
		}
		rsOH.close();
		stateOH.close();
  %>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
</body>
</html>
