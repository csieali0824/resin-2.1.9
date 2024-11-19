<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<%

 String woType     = request.getParameter("WOTYPE"); 
 String marketType = request.getParameter("MARTETTYPE"); 
 String mfgDeptNo  = request.getParameter("MFGDEPTNO");
 String prodSource = request.getParameter("PRODSOURCE");
 String cellSource = request.getParameter("CELLSOURCE");
 String organizationId = "";
 String invItem     = request.getParameter("INVITEM"); 
 String itemDesc    = request.getParameter("ITEMDESC");
 String waferResist = request.getParameter("WFRESIST"); 
 String diceSize    = request.getParameter("DICESIZE");
 String waferLot    = request.getParameter("WAFERLOT"); 
 String searchLot   = request.getParameter("SUPPLIERLOT");
 String searchString= request.getParameter("SEARCHSTRING");
 String waferVendor = null,waferQty=null,waferUom=null,waferIqcNo=null,waferYld=null,waferKind=null,waferElect=null ;
 String woUom       = null,itemId=null ,woWaferIqcNo=null,woWaferQty=null,waferLineNo=null,waferAmp=null;
 String defaultWoQty=null,frontRunCard=null;
 String result=null;
 float avaibleQty=0;
 
 float accWoQty = 0;
 float leftAddQty = 0;
 
 //if (marketType.equals("1")) {  organizationId = "306";  }
 //else if (marketType.equals("2")) {   organizationId = "307";  }
 
   String orgID = "";
   Statement stateID=con.createStatement();   
   ResultSet rsID=stateID.executeQuery("select ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE ='MARKETTYPE' and  CODE= '"+marketType+"' ");
   if (rsID.next())
   {
     organizationId = rsID.getString(1);
   }
   rsID.close();
   stateID.close();

 String q[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容	
 String runCardDesc   = null; // ItemDesc
 String runCardGet    = "";   // itemCodeGet
 int runCardGetLength = 0;    // itemCodeGetLength
 
     if (q!=null) 
	 {	// 由陣列內容作為下一次不落入條件的依據		   
      //out.println(shpArray2DPageBean.getArray2DTempString());
	   out.println(arrayWODocumentInputBean.getArray2DIQCString());
	   if (q.length>0)
	   {
	      for (int i=0;i<q.length;i++)
	      {
		     out.println(q[i][18]+"<BR>");
			 runCardDesc = q[i][18];
			 runCardGet = runCardGet+"'"+runCardDesc+"'"+",";

			 if (q[i][3]!=null && !q[i][3].equals(""))
			 {
			   accWoQty = accWoQty + Float.parseFloat(q[i][3]);  // 累加先前選定數量		
			 } else {
			          q[i][3] = "0";
					  accWoQty = accWoQty + Float.parseFloat(q[i][3]);  // 累加先前選定數量
			        }
		  }
		  out.println(accWoQty); 

		    // 取得not in 條件_起
		    if (runCardGet.length()>0)
            {   out.println(runCardGet);     
             runCardGetLength = runCardGet.length()-1;
             runCardGet = runCardGet.substring(0,runCardGetLength); 
            } 
		    // 取得not in 條件_迄
	   }
     } else {
	          out.println("No get!");
	         }

 try
 {
  if (searchString==null)
   {
    if (waferResist!=null && !waferResist.equals(""))
	{ searchString= waferResist.toUpperCase(); }	
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
  
  .nav           { text-decoration: underline; color:#000000 }
  .nav:link      { text-decoration: underline; color:#000000 }
  .nav:visited   { text-decoration: underline; color:#000000 }
  .nav:active    { text-decoration: underline; color:#FF0000 }
  .nav:hover     { text-decoration: none; color:#FF0000 }
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
  .mod           { text-decoration: none; color:#000000 }
  .mod:link      { text-decoration: none; color:#000000 }
  .mod:visited   { text-decoration: none; color:#000080 }
  .mod:active    { text-decoration: none; color:#FF0000 }
  .mod:hover     { text-decoration: underline; color:#FF0000 }  
  .thd           { text-decoration: none; color:#808080 }
  .thd:link      { text-decoration: underline; color:#808080 }
  .thd:visited   { text-decoration: underline; color:#808080 }
  .thd:active    { text-decoration: underline; color:#FF0000 }
  .thd:hover     { text-decoration: underline; color:#FF0000 }
  .curpage       { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page          { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link     { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited  { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover    { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject       { font-family: Tahoma,Georgia; font-size: 12px }
  .text          { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle     { padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext     { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member        { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle      { background-color: #5D7790; border-width:2; 
                   border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
                   font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle      { background-color: #FFFFFF; border-bottom: black 1px solid; 
                   border-left: black 1px solid; border-right: black 1px solid; 
                   border-top: black 1px solid; color: #000000; cursor: hand; 
                   font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle      { background-color: #FFFFFF; border-bottom: black 1px solid; 
                   border-left: black 1px solid; border-right: black 1px solid; 
                   border-top: black 1px solid; color: #000000; 
                   font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
                 {
                   COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
                   padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
function sendToMainWindow(jNo,waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind,itemId,woUom,waferLineNo,defaultWoQty,woType,frontRunCard,chkCutAsbFlag,chkSubAsbFlag,waferAmp)
{ 
           window.opener.document.MYFORM.WAFERLOT.value=waferLot;            
           window.opener.document.MYFORM.WAFERVENDOR.value=waferVendor; 
           window.opener.document.MYFORM.WAFERQTY.value=waferQty; 
           window.opener.document.MYFORM.WAFERUOM.value=waferUom;
           window.opener.document.MYFORM.WAFERYLD.value=waferYld; 
           window.opener.document.MYFORM.WAFERELECT.value=waferElect;  
           window.opener.document.MYFORM.WAFERIQCNO.value=waferIqcNo;
           window.opener.document.MYFORM.WAFERKIND.value=waferKind;            
           window.opener.document.MYFORM.WOUOM.value=woUom;  
           window.opener.document.MYFORM.WAFERLINENO.value=waferLineNo; 
		   window.opener.document.MYFORM.WOQTY.value=defaultWoQty;
		   window.opener.document.MYFORM.TSCAMP.value=waferAmp;
		   if (woType=="1")
		   {
		      if (chkCutAsbFlag=="N")
			  {
			    alert("找不到切割晶片對應的晶粒製成品號\n 請相關人員至Oracle設定該BOM表!!!");
				return false;
			  } else {
			            window.opener.document.MYFORM.ITEMID.value=itemId; 
			            window.opener.document.MYFORM.INVITEM.value=invItem; 
                        window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
			          }
		   }
		   else if (woType=="2")
		        { 
				   // 若是前段工令,再將取的的切割工令號帶回
		           if (frontRunCard==null || frontRunCard=="null") frontRunCard="";
		           window.opener.document.MYFORM.FRONTRUNCARD.value=frontRunCard;
				   				
				   if (chkSubAsbFlag=="N")
			       {
			         alert("找不到切割晶片對應的前段半成品號\n 請相關人員至Oracle設定該BOM表!!!");
					 return false;
			       } else {
			                window.opener.document.MYFORM.ITEMID.value=itemId; 
			                window.opener.document.MYFORM.INVITEM.value=invItem; 
                            window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
			               }
				   
		        }
           //alert(waferLineNo);
           this.window.close();
	//  } 
}
</script>
<body > 
<FORM METHOD="post" ACTION="TSMfgWaferWipFind.jsp">
  <font size="-1">前段生產阻值或晶粒尺寸: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  -----Wafer Inspection Lot Find-------------------------------------------     
  <BR>
  <%  
     //out.println("organizationId="+organizationId);
  
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	
	   
	// 2007/01/22 找舊庫存 CELL 批
		String sql = "select  'ACCEPT' as RESULT, b.LOT_NUMBER as WAFERLOT, 'OLD_SUBINV' as CELL前段工令, c.SEGMENT1 as 製成半成品號, "+
		             "        c.SEGMENT1 as INV_ITEM, REPLACE(c.DESCRIPTION,'"+"\""+"',' inch ') as ITEM_DESC, "+
					 "        'IQCNO' as WAFERIQCNO, 'WAFER_VENDOR' as SUPPLIER_SITE_NAME, 'YIELD' as TOTAL_YIELD, "+
					 "        'KIND' as WF_TYPE_NAME, '' as WF_RESIST , a.PRIMARY_TRANSACTION_QUANTITY as WO_COMPLETED_QTY, a.TRANSACTION_UOM_CODE as WO_UOM, "+
					 "        c.INVENTORY_ITEM_ID, 1 as LINE_NO, '20061231120000' as INSPECT_DATE, '' as WAFER_AMP	"+
		             "  from MTL_ONHAND_QUANTITIES_DETAIL a  "+
		             "      ,MTL_LOT_NUMBERS b "+
		             "      ,MTL_SYSTEM_ITEMS c ";
		String where=" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID  "+
		             "  and b.INVENTORY_ITEM_ID  = c.INVENTORY_ITEM_ID "+
		             "  and a.ORGANIZATION_ID    = b.ORGANIZATION_ID "+
		             "  and b.ORGANIZATION_ID    = c.ORGANIZATION_ID "+
					 "  and c.ORGANIZATION_ID    = "+organizationId+" and a.LOT_NUMBER = b.LOT_NUMBER "+
					 "  and a.ORGANIZATION_ID    = "+organizationId+" ";
		String order = "  ";
		if (searchLot!=null && !searchLot.equals("")) where = where + " and (a.LOT_NUMBER like '"+searchLot+"%' or a.LOT_NUMBER ='"+searchLot+"' or c.SEGMENT1 = '"+searchLot+"' ) ";
		// 2007/01/07 將前段CELL已完工工令作UNION
		String sqlCELL =  " select 'ACCEPT' as RESULT, WAFER_LOT_NO as WAFERLOT, YWA.WO_NO as CELL前段工令, ASI.SEGMENT1 as 製成半成品號, YWA.INV_ITEM, REPLACE(YWA.ITEM_DESC,'"+"\""+"',' inch ') as ITEM_DESC, WAFER_IQC_NO as WAFERIQCNO,  "+
		                  "         WAFER_VENDOR as SUPPLIER_SITE_NAME, WAFER_YIELD as TOTAL_YIELD, WAFER_KIND as WF_TYPE_NAME, '' as WF_RESIST , "+
						  "         YRA.RUNCARD_QTY , YWA.WO_UOM, YWA.INVENTORY_ITEM_ID, to_number(YWA.WAFER_LINE_NO) as LINE_NO, 'N/A' as INSPECT_DATE,  YWA.WAFER_AMP as WAFER_AMP "+	
		                  "    from YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA, "+
						  "        ( select /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */ b.ASSEMBLY_ITEM_ID, COMPONENT_ITEM_ID, MSI.SEGMENT1, MSI.DESCRIPTION "+
				                   "  from BOM_COMPONENTS_B a   "+
				                   "      ,BOM_STRUCTURES_B b   "+
				                   "      ,MTL_SYSTEM_ITEMS MSI "+
					               " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID "+
								   "   and b.ASSEMBLY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+	
								   "   and MSI.ITEM_TYPE         = 'SA' "+
								   "   and length(MSI.SEGMENT1) != 22 "+
							       "   and b.ORGANIZATION_ID     = MSI.ORGANIZATION_ID "+
					 		       "   and b.ORGANIZATION_ID     = "+organizationId+" ) ASI ";
		String whereCELL = " where YWA.WO_NO = YRA.WO_NO   "+
		                   "   and YWA.DEPT_NO in (1, 2)   "+
		                   "   and YWA.WORKORDER_TYPE = 2  "+
		                   "   and YWA.STATUSID>= '048'    "+
		                   "   and YWA.STATUSID != '050'   "+
						   "   and YWA.INVENTORY_ITEM_ID = ASI.COMPONENT_ITEM_ID ";
		if (invItem   != null && !invItem.equals("")  ) whereCELL = whereCELL + " and (YWA.INV_ITEM = '"+searchLot+"'  or YWA.INV_ITEM like '%"+searchLot+"%' ) ";				   
		if (searchLot != null && !searchLot.equals("")) whereCELL = whereCELL + " and (YWA.WO_NO like '"+searchLot+"%' or YWA.WO_NO = '"+searchLot+"' or YRA.RUNCARD_NO = '"+searchLot+"' or upper(YWA.INV_ITEM) = '"+searchLot.toUpperCase()+"' ) ";
		
		if (searchString =="%" || searchString.equals("%"))			
		{  
		 whereCELL = whereCELL + " and (YWA.WO_NO like '%') ";
		}
		else 
		{ 
		 whereCELL = whereCELL + "  and (upper(YWA.INV_ITEM) = '"+searchLot.toUpperCase()+"' or upper(YWA.ITEM_DESC) like '"+searchLot.toUpperCase()+"%' or upper(YWA.WO_NO) like '"+searchLot.toUpperCase()+"%' or YWA.WO_NO like '"+searchLot+"%' or YWA.WO_NO = '"+searchLot+"' ) ";
		} 
					
		sql = sqlCELL + whereCELL +" UNION "+ sql + where + order;	

		Statement statePrev=con.createStatement();		
		ResultSet rsPrev=statePrev.executeQuery(sql);
		while (rsPrev.next())
	    {			
		// 取 Item Where Use的 Procedure_起
		String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
		//out.println("prevSubItem ="+prevSubItem);
		
		CallableStatement csBOMInfo = con.prepareCall("{call YEW_BOM_IMPLODER_SUBASB(?,?,?,?,?,?,?,?,?)}");
	    csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 			             
	    csBOMInfo.setInt(2,rsPrev.getInt("INVENTORY_ITEM_ID")); 	                    
	    csBOMInfo.registerOutParameter(3, Types.INTEGER);   // 回傳 Parent Item ID
	    csBOMInfo.registerOutParameter(4, Types.VARCHAR);   // 回傳 Parent Inv Item
	    csBOMInfo.registerOutParameter(5, Types.VARCHAR);   // 回傳 Parent Item Desc
	    csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // 回傳 Error Message
	    csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // 回傳 Error Code
		csBOMInfo.registerOutParameter(8, Types.INTEGER);   // 回傳 此次筆數				        
		csBOMInfo.setString(9,"SA");                        // 正式查詢
	    csBOMInfo.execute();
		int parentInvItemID   = csBOMInfo.getInt(3);
	    String parentInvItem  = csBOMInfo.getString(4);       //  回傳 REQUEST 執行狀況
	    String parentItemDesc = csBOMInfo.getString(5);
	    String errorMessage   = csBOMInfo.getString(6);      //  回傳 REQUEST 執行狀況
	    String errorCode      = csBOMInfo.getString(7);         //  回傳 REQUEST 執行狀況訊息
	    int rowNum = csBOMInfo.getInt(8);	                 //  回傳 此次 筆數
	    // out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	    csBOMInfo.close(); 
		}
		rsPrev.close();
		statePrev.close();
		
	  if (cellSource.equals("1"))
	  { // WIP 第一次CELL工令入庫批(使用者輸入前段工令號或流程卡號(批號))
	           sql = "select DISTINCT 'ACCEPT' as RESULT, e.WAFER_LOT_NO as WAFERLOT, d.RUNCARD_NO as CELL前段批號, a.PARENT_INV_ITEM as 製成半成品號, "+
		             "        c.SEGMENT1 as INV_ITEM, REPLACE(c.DESCRIPTION,'"+"\""+"',' inch ') as ITEM_DESC, "+
					 "        e.WAFER_IQC_NO as WAFERIQCNO, e.WAFER_VENDOR as SUPPLIER_SITE_NAME, e.WAFER_YIELD as TOTAL_YIELD, "+
					 "        e.WAFER_KIND as WF_TYPE_NAME, e.WFRESIST as WF_RESIST , f.PRIMARY_TRANSACTION_QUANTITY as WO_COMPLETED_QTY, f.TRANSACTION_UOM_CODE as WO_UOM, "+
					 "        a.PARENT_ITEM_ID as INVENTORY_ITEM_ID, e.WAFER_LINE_NO as LINE_NO, '20061231120000' as INSPECT_DATE, e.WAFER_AMP as WAFER_AMP	"+
			         "  from APPS.YEW_BOM_IMPL_TEMP a  "+
			         "      ,MTL_LOT_NUMBERS        b  "+
			         "      ,MTL_SYSTEM_ITEMS       c  "+
			         "      ,YEW_RUNCARD_ALL        d  "+
			         "      ,YEW_WORKORDER_ALL      e  "+
			         "      ,MTL_ONHAND_QUANTITIES_DETAIL f  ";
		     where = " where a.CURRENT_ITEM_ID = b.INVENTORY_ITEM_ID   "+
		             "   and a.CURRENT_ITEM_ID = c.INVENTORY_ITEM_ID "+
					 "   and b.INVENTORY_ITEM_ID = d.PRIMARY_ITEM_ID  "+
					 "   and a.CURRENT_ITEM_ID = d.PRIMARY_ITEM_ID "+
					 "   and a.ORGANIZATION_ID = d.ORGANIZATION_ID "+
					 "   and d.WO_NO           = e.WO_NO "+
					 "   and f.ORGANIZATION_ID = d.ORGANIZATION_ID "+
					 "   and f.LOT_NUMBER      = b.LOT_NUMBER      "+
					 "   and d.RUNCARD_NO      = b.LOT_NUMBER      "+
					 "   and a.CURRENT_LEVEL  != 0 "+
					 "   and a.ORGANIZATION_ID = c.ORGANIZATION_ID  "+
					 "   and b.ORGANIZATION_ID = c.ORGANIZATION_ID  "+
					 "   and length(a.PARENT_INV_ITEM) = 13         "+
					 "   and a.ORGANIZATION_ID = "+organizationId+" ";
		     if (searchLot!=null && !searchLot.equals("")) where = where + " and (b.LOT_NUMBER like '"+searchLot+"%' or b.LOT_NUMBER ='"+searchLot+"' or c.SEGMENT1 = '"+searchLot+"' or d.WO_NO = '"+searchLot+"'  or d.RUNCARD_NO = '"+searchLot+"' ) ";	
			 
	  } else if (cellSource.equals("2")) // 舊系統庫存批(使用者輸入庫存半成品號完整)
	         {
		
		       sql = "select DISTINCT 'ACCEPT' as RESULT       "+
		             "      ,b.LOT_NUMBER      as WAFERLOT     "+
		             "      ,b.LOT_NUMBER      as CELL前段批號 "+
		             "      ,a.PARENT_INV_ITEM as 製成半成品號 "+
		             "      ,c.SEGMENT1        as INV_ITEM "+
		             "      ,REPLACE(c.DESCRIPTION,'"+"\""+"',' inch ') as ITEM_DESC, "+
					 "        'IQCNO' as WAFERIQCNO, 'WAFER_VENDOR' as SUPPLIER_SITE_NAME, 'YIELD' as TOTAL_YIELD, "+
					 "        'KIND' as WF_TYPE_NAME, '' as WF_RESIST , d.PRIMARY_TRANSACTION_QUANTITY as WO_COMPLETED_QTY, d.TRANSACTION_UOM_CODE as WO_UOM, "+
					 "        a.PARENT_ITEM_ID as INVENTORY_ITEM_ID, 1 as LINE_NO, '20061231120000' as INSPECT_DATE, '' as WAFER_AMP	"+
			         "  from APPS.YEW_BOM_IMPL_TEMP a,  MTL_LOT_NUMBERS b, MTL_SYSTEM_ITEMS c, MTL_ONHAND_QUANTITIES_DETAIL d ";
		     where = " where a.CURRENT_ITEM_ID   = b.INVENTORY_ITEM_ID "+
		             "   and a.CURRENT_ITEM_ID   = c.INVENTORY_ITEM_ID "+
					 "   and b.INVENTORY_ITEM_ID = d.INVENTORY_ITEM_ID "+
					 "   and a.CURRENT_ITEM_ID   = d.INVENTORY_ITEM_ID "+
					 "   and a.ORGANIZATION_ID   = d.ORGANIZATION_ID "+
					 "   and d.LOT_NUMBER        = b.LOT_NUMBER  "+
					 "   and a.CURRENT_LEVEL    != 0 "+
					 "   and a.ORGANIZATION_ID   = c.ORGANIZATION_ID  "+
					 "   and b.ORGANIZATION_ID   = c.ORGANIZATION_ID  "+
					 "   and length(a.PARENT_INV_ITEM) = 13  "+
					 "   and a.ORGANIZATION_ID = "+organizationId+" ";
		       if (searchLot!=null && !searchLot.equals("")) where = where + " and (b.LOT_NUMBER like '"+searchLot+"%' or b.LOT_NUMBER ='"+searchLot+"' or c.SEGMENT1 = '"+searchLot+"' ) ";	 
	         }
		sql = sql + where;
//charlie		out.println("sql="+sql); 	
        ResultSet rs=statement.executeQuery(sql);
		//out.println("TT2");
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='left' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN SIZE=1>項次</TD>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
		  if (i==3)
		  {
		           if (woType.equals("2")) // 前段工令再多帶一切割流程卡號
		           {
		             //out.println("<TD nowrap><FONT COLOR=BROWN SIZE=1>前段CELL流程卡號"+"</TD>");
			         //out.println("<TD nowrap><FONT COLOR=BROWN SIZE=1>製成半成品號"+"</TD>");
		           }
		  }
		 if (i==11) out.println("<TD nowrap><FONT COLOR=BROWN>剩餘數"+"</TD>");
         colLabel[i]=md.getColumnLabel(i);
		 if (i==4) 
		 {  
		    out.println("<TD nowrap><FONT COLOR=BLUE><strong>"+colLabel[i]+"</strong></FONT></TD>");
		 }
		 else {
		          out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</FONT></TD>");
		      }
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
		int j = 0; //項次數
		float sumWOCretedQty = 0;
		float accAvailQty = 0;
        while (rs.next())
        {
		    String cutAsbItemId   = "";
			String cutAsbInvItem  = "";
			String cutAsbItemDesc = "";
			String subAsbItemId   = "";
			String subAsbInvItem  = "";
			String subAsbItemDesc = "";
			String chkCutAsbFlag  = "N";
			String chkSubAsbFlag  = "N";
		
		 Statement stateWOCr=con.createStatement();
		 String sqlWoCr = "select SUM(WO_QTY) from YEW_WORKORDER_ALL where WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"' and WAFER_LINE_NO='"+rs.getString("LINE_NO")+"'  "+
	                      "   and DEPT_NO in ('1', '2') and WORKORDER_TYPE ='2' and PROD_SOURCE = '2' ";  // 此子視窗必為製二使用開立兩張前段工令				 	 

		 ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		 if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		 sumWOCretedQty = 0;
		 rsWOCr.close();
		 stateWOCr.close();	 

		 if (woType.equals("2")) // 若為前段工令,則嘗試去尋找切割流程卡號(工令)
		 {
		   Statement stateFront=con.createStatement();
		   String sqlFront = "select b.RUNCARD_NO from YEW_WORKORDER_ALL a,YEW_RUNCARD_ALL b where a.WO_NO = b.WO_NO and a.WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"' and WAFER_LINE_NO='"+rs.getString("LINE_NO")+"'  "+
		                     " and a.DEPT_NO in ('1', '2') and a.WORKORDER_TYPE = '2' and PROD_SOURCE = '2' "; // 找先前已開過的流程卡號(工令)								  
		   ResultSet rsFront=stateFront.executeQuery(sqlFront);
		   if (rsFront.next()) frontRunCard = rsFront.getString(1);
		   else frontRunCard = "";
		   rsFront.close();
		   stateFront.close();	
		 }		 
		 result       = rs.getString("RESULT");
		 waferLot     = rs.getString("WAFERLOT");		
		 invItem      = rs.getString("INV_ITEM");
		 itemDesc     = rs.getString("ITEM_DESC");	
		 waferVendor  = rs.getString("SUPPLIER_SITE_NAME");
 		 waferQty     = rs.getString("WO_COMPLETED_QTY"); // 2006/11/06改成取累計工令完工數
		 waferUom     = rs.getString("WO_UOM");
		 waferYld     = rs.getString("TOTAL_YIELD");
		 waferElect   = rs.getString("WF_RESIST");
		 waferIqcNo   = rs.getString("WAFERIQCNO");	
		 waferKind    = rs.getString("WF_TYPE_NAME");
		 waferAmp     = rs.getString("WAFER_AMP");		 
		 itemId       = rs.getString("INVENTORY_ITEM_ID");	
		 waferLineNo  = rs.getString("LINE_NO");
		 accAvailQty  = Float.parseFloat(waferQty) - sumWOCretedQty; // 可開單數 = IQC收料數 - 累積工單開立數
		 defaultWoQty = Float.toString(accAvailQty); // 當成這次可開立數
		 
		 //out.print("invItem="+invItem);
		          Statement stateMSI=con.createStatement();
		          ResultSet rsMSI=stateMSI.executeQuery("select INVENTORY_ITEM_ID, SEGMENT1, DESCRIPTION from MTL_SYSTEM_ITEMS where SEGMENT1 = '"+rs.getString(4)+"' and ORGANIZATION_ID ="+organizationId+" ");
		          if (rsMSI.next()) 
			      { 
			        subAsbItemId = rsMSI.getString(1); 
			        subAsbInvItem = rsMSI.getString(2);
			        subAsbItemDesc = rsMSI.getString(3);
			        itemId = subAsbItemId;
			        invItem = subAsbInvItem;
			        itemDesc = subAsbItemDesc;	
					chkSubAsbFlag = "Y";				 
			      } else {				  
				          chkSubAsbFlag = "N";		
						 }    
		          rsMSI.close();
		          stateMSI.close();
      
		//-----抓取存在工單檔裡的檢驗批 ------
		String sqla2= "  select wafer_lot_no, wafer_qty from APPS.YEW_WORKORDER_ALL  where WAFER_LOT_NO = '"+waferIqcNo+"' and WAFER_LINE_NO= '"+waferLineNo+"'";
		if (woType!=null) sqla2 = sqla2+ " and WORKORDER_TYPE = '"+woType+"' "; // 依切割或前段工令區別找出已開數量及IQC批號	    
	    Statement statea2=con.createStatement();
		//out.print("sqla1="+sqla2);
        ResultSet rsa2=statea2.executeQuery(sqla2);
		//out.print("sqla1="+sqla2);
    	 if (rsa2.next())
		 { 
		    	woWaferIqcNo   = rsa2.getString("WAFER_LOT_NO");   
	   		    woWaferQty     = rsa2.getString("WAFER_QTY");
		 }
		 else {woWaferQty="0";}  
	    rsa2.close();
        statea2.close();		

		avaibleQty=( Float.parseFloat(waferQty)- Float.parseFloat(woWaferQty));
		waferQty=String.valueOf(avaibleQty);
		
		//抓計量單位
		String sqla1= " select PRIMARY_UNIT_OF_MEASURE WOUOM  from apps.mtl_system_items_b "+
					  "    where Organization_id=43  and segment1= '"+invItem +"'";

	    Statement statea1=con.createStatement();
        ResultSet rsa1=statea1.executeQuery(sqla1);
		//out.print("sqla1="+sqla1);
    	if (rsa1.next())
		{ 	 woUom   = rsa1.getString("WOUOM");   }
	    rsa1.close();
        statea1.close();
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
//	if (accAvailQty>0)  // if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示此列(資料也不顯示)
//	{
		out.print("<TR BGCOLOR='"+"#D2D0AA"+"'><TD nowrap>");
		j++; // 項次數 
		if (accAvailQty>0)  // if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示此列(資料顯示,但無法點擊帶入鈕)
	    { 
		%>
		<INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=j%>","<%=waferLot%>","<%=invItem%>","<%=itemDesc%>","<%=waferVendor%>","<%=waferQty%>","<%=waferUom%>","<%=waferYld%>","<%=waferElect%>","<%=waferIqcNo%>","<%=waferKind%>","<%=itemId%>","<%=woUom%>","<%=waferLineNo%>","<%=defaultWoQty%>","<%=woType%>","<%=frontRunCard%>","<%=chkCutAsbFlag%>","<%=chkSubAsbFlag%>","<%=waferAmp%>")'>
		<%
		}  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料顯示,但無法點擊帶入鈕)
		else { 
		      j--; //不計入
		      out.println("<em><font color='#FF0000'>無餘額</font></em>");
			 }
		 out.print("</TD>");		
		 out.print("<TD>"+j+"</TD>");
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         {
		    if (i==3) //前段工令再多帶一切割流程卡號_起
		    {
			       if (woType.equals("2")) // 前段工令再多帶一切割流程卡號
		           {
		             //out.println("<TD nowrap><FONT COLOR=BROWN SIZE=1>"+frontRunCard+"</TD>");
					 //out.println("<TD nowrap><FONT COLOR=BROWN SIZE=1>"+subAsbInvItem+"</TD>");
		           }
		    } // 前段工令再多帶一切割流程卡號_迄		 
		   if (i==11) out.println("<TD nowrap><FONT SIZE=2>"+accAvailQty+"</TD>");
           String s=(String)rs.getString(i);
		   if (i==4) 
		   {  out.println("<TD nowrap><FONT SIZE=2 COLOR='BLUE'><strong>"+s+"</strong></FONT></TD>"); }
		   else {
                 out.println("<TD nowrap><FONT SIZE=2>"+s+"</FONT></TD>");
				}
         } //end of for
          out.println("</TR>");	
	//	 }  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料也不顯示)
        }
        out.println("</TABLE>");						
        rs.close(); 	
	   }
      }
      catch (SQLException e)
      {
       out.println("Exception2:"+e.getMessage());
      }
	  statement.close();
     %>
  <BR>
  <%
	           PreparedStatement stmtDelTmp=con.prepareStatement("delete from APPS.YEW_BOM_IMPL_TEMP ");          
	           stmtDelTmp.executeUpdate();
               stmtDelTmp.close();	 
     // 作完查詢刪除找ITEM WHERE USER 寫入的TEMP Table_迄
  %>
<!--%表單參數%-->
<input name="MARTETTYPE" type="HIDDEN" value="<%=marketType%>">
<input name="WOTYPE" type="HIDDEN" value="<%=woType%>">
<input name="PRODSOURCE" type="HIDDEN" value="<%=prodSource%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

