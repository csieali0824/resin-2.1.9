<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<%

 String woType=request.getParameter("WOTYPE"); 
 String marketType=request.getParameter("MARTETTYPE"); 
 String organizationId = request.getParameter("ORGANIZATIONID");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 String waferResist=request.getParameter("WFRESIST"); 
 String diceSize=request.getParameter("DICESIZE");
 String waferLot=request.getParameter("WAFERLOT"); 
 String supplierLot=request.getParameter("SUPPLIERLOT");
 String searchString=request.getParameter("SEARCHSTRING");
 String waferVendor=null,waferQty=null,waferUom=null,waferIqcNo=null,waferYld=null,waferKind=null,waferElect=null ;
 String woUom=null,itemId=null ,woWaferIqcNo=null,woWaferQty=null,waferLineNo=null,waferAmp=null;
 String defaultWoQty=null,frontRunCard=null,cutterRCNo=null;
 String result=null;
 float avaibleQty=0;
 
 float accWoQty = 0;
 float leftAddQty = 0;
 String IQC_GRAINQTY=null;
 if (supplierLot==null || supplierLot.equals("") || supplierLot.equals("undefined")) supplierLot = "";
 
   String orgID = "";
   Statement stateID=con.createStatement();   
   ResultSet rsID=stateID.executeQuery("select ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE ='MARKETTYPE' and  CODE= '"+marketType+"' ");
   if (rsID.next())
   {
     organizationId = rsID.getString(1);
   }
   rsID.close();
   stateID.close();

//判斷該lot 是否有不良_____start  //20091205 liling add
     String iqcRemark="";
     String sqliqc=" SELECT INSPECT_REMARK  FROM ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD "+
			   // "  WHERE TLD.ORGANIZATION_ID = '"+organizationId+"' AND TLD.SUPPLIER_LOT_NO= '"+supplierLot+"'  ";
			    "  WHERE TLD.ORGANIZATION_ID = '"+organizationId+"' AND TLD.SUPPLIER_LOT_NO= '"+supplierLot+"' and  INSPECT_REMARK is not null ";	//20111223 LILING			
	 Statement stateLot=con.createStatement();
	 ResultSet rsLot=stateLot.executeQuery(sqliqc);
	 if (rsLot.next())
	  {  
		iqcRemark  = rsLot.getString("INSPECT_REMARK");
        if ( iqcRemark == "N/A" || iqcRemark.equals("N/A"))
         { }
        else{
          %>
           <input type="hidden" name="IQCREMARK" value="<%=iqcRemark%>">
		    <script language="javascript">
			    alert("請注意此批IQC備註不良");
			 </script>
         <% }
	  }
	  rsLot.close();
 	  stateLot.close();						 
//判斷該lot 是否有不良_____start   
		
	  //add by Peggy 20170612
	  sqliqc=" select distinct WAIVE_REMARK from oraddman.tsciqc_lotinspect_history a where a.WAIVE_REMARK is not null and a.WAIVE_REMARK <>'N/A' and exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where tld.INSPLOT_NO=a.INSPLOT_NO and tld.line_no=a.line_no and  TLD.ORGANIZATION_ID = '"+organizationId+"' AND TLD.SUPPLIER_LOT_NO= '"+supplierLot+"')";
	  stateLot=con.createStatement();
	  rsLot=stateLot.executeQuery(sqliqc);
	  if (rsLot.next())
	  {
	  	iqcRemark += (iqcRemark.length()>0?",":"")+rsLot.getString("WAIVE_REMARK");	   		
	  }
	  rsLot.close();
 	  stateLot.close();	
	  
 if (woType==null || woType.equals("")) woType="1";
 
 String q[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容	
 
 String runCardDesc = null; // ItemDesc
 String runCardGet = "";  // itemCodeGet
 int runCardGetLength = 0;   // itemCodeGetLength

     if (q!=null) 
	 {	// 由陣列內容作為下一次不落入條件的依據		   
      //out.println(shpArray2DPageBean.getArray2DTempString());
	   out.println(arrayWODocumentInputBean.getArray2DString());
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
	          //out.println("No get!");
	         }
  //out.println("supplierLot="+supplierLot);
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
 
 //out.println("supplierLot="+supplierLot);
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
	// }  End of 先進先出
}

</script>
<body > 
<FORM METHOD="post" ACTION="TSMfgWaferCharactFind.jsp">
  <font size="-1" color="#000099">生產阻值或晶粒尺寸:</font> 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>  
  <a href="TSMfgIQCLotImplBOMList.jsp?LOT=<%=supplierLot%>&ORGANIZATIONID=<%=organizationId%>" onMouseOver='this.T_WIDTH=120;this.T_OPACITY=80;return escape("輸入批號:<%=supplierLot%>查詢可點選檢視BOM表資訊")'>批號原料BOM表資訊</a><BR>
  <font size="-1" color="#000099">-----Wafer Inspection Lot Find-------------------------------------------</font>     
  <BR>
  <% 

    if (woType.equals("2")) // 前段工令來源由切割工令
    {
  %>
  <span class="style1">開立前段工令由IQC檢驗批</span><BR>
  <%  
    } 
      if(iqcRemark=="N/A" || iqcRemark.equals("N/A")) {} else {out.print("      <span class=style1>IQC不良原因: "+iqcRemark+"</span>");}  //20091205 liling add
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	
	      String sqlCNT = "";
		  String sql = "";
		  String where= "";
		  String order = "";
		  String sqlOld = "";
		  String whereOld = "";
	      if (woType.equals("1")) // 切割工令
		  {
		     //  **** 2006/12/30 先將暫時查詢檔寫入

	             sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY ICQ收料數量,IQCD.GRAINQTY, IQCD.INV_ITEM, IQCD.INV_ITEM_ID, REPLACE(IQCD.INV_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC,IQCH.INSPLOT_NO as WAFERIQCNO , "+
		                     "           IQCH.SUPPLIER_SITE_NAME,decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME,IQCH.WF_RESIST , "+
	   				         "           IQCD.UOM, IQCD.INV_ITEM_ID,IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                         " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, "+
			                 "      ORADDMAN.TSCIQC_WAFER_TYPE IQCWT ";
	      	     where=" where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                      "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 加入已經驗收入庫或經特採入庫的檢驗批							  
							  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "+ // Clone 後PO方有存在
							  "   and IQCD.ORGANIZATION_ID = '"+organizationId+"' ";
		         order = "order by IQCD.INV_ITEM, INSPECT_DATE, WAFERLOT ";		
		         if (runCardGet!=null && !runCardGet.equals(""))	 where = where + " and IQCD.SUPPLIER_LOT_NO not in ("+runCardGet+") "; // 先前已在清單內的WaferLot不得出現 
		
		         if (invItem!=null && !invItem.equals("")) where = where + " and ( IQCD.INV_ITEM = '"+invItem+"' or IQCD.INV_ITEM like '%"+invItem+"%' ) ";

		         if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--")) where = where + "and ( IQCH.WF_RESIST = '"+waferResist+"' or IQCH.WF_RESIST like '%"+waferResist+"%' )   ";
		         if (diceSize!=null && !diceSize.equals("")  && !diceSize.equals("--")) where = where + "and ( IQCD.DICE_SIZE= '"+diceSize+"' and IQCD.DICE_SIZE like '%"+diceSize+"%' ) ";
				 
				 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) where = where + "and ( IQCD.SUPPLIER_LOT_NO= '"+supplierLot+"' or IQCD.SUPPLIER_LOT_NO like '%"+supplierLot+"%' ) ";
		

		         // 需要改為取特定索引 SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		         if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		         {  
		           where = where + " and (IQCD.SUPPLIER_LOT_NO like '%') ";
		         }
		         else 
		            { 
		              where = where + "  and ( upper(IQCD.INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                  "         OR upper(IQCD.INV_ITEM_DESC) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM_DESC) like '"+searchString.toUpperCase()+"%' "+									  
									  "         OR upper(IQCD.SUPPLIER_LOT_NO) = '"+searchString.toUpperCase()+"' or upper(IQCD.SUPPLIER_LOT_NO) like '"+searchString.toUpperCase()+"%' ) ";
	                } 		  
					
				     sql = sql + where + order;	
					 //out.println(sql); 
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sql);				   
				     while (rsPrev.next())
					 {			
					     // 取 Item Where Use的 Procedure_起
				         String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
			  
			             CallableStatement csBOMInfo = con.prepareCall("{call TSC_BOM_IMPLODER_PARENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	                     csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			             csBOMInfo.setString(2,woType);
	                     csBOMInfo.setInt(3,rsPrev.getInt("INV_ITEM_ID")); 
	                     csBOMInfo.setString(4,prevSubItem);                 // 原子階料號前三碼( 判定 11-, 10- 或 1A- )
	                     csBOMInfo.registerOutParameter(5, Types.INTEGER);   // 回傳 Parent Item ID
	                     csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // 回傳 Parent Inv Item
	                     csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // 回傳 Parent Item Desc
	                     csBOMInfo.registerOutParameter(8, Types.VARCHAR);   // 回傳 Error Message
	                     csBOMInfo.registerOutParameter(9, Types.VARCHAR);   // 回傳 Error Code
				         csBOMInfo.registerOutParameter(10, Types.INTEGER);  // 回傳 此次 SEQUENCE ID
				         csBOMInfo.setString(11,"");                         // 切割, 
				         csBOMInfo.setString(12,rsPrev.getString("WAFERLOT"));   // 給Wafer Lot
				         csBOMInfo.setString(13,rsPrev.getString("WAFERIQCNO")); // 給IQC No.
				         csBOMInfo.setInt(14,rsPrev.getInt("LINE_NO"));          // 給IQC Line No.
				         csBOMInfo.setString(15,"FAKE");                     // 正式查詢
	                     csBOMInfo.execute();
			             int parentInvItemID = csBOMInfo.getInt(5);
	                     String parentInvItem = csBOMInfo.getString(6);       //  回傳 REQUEST 執行狀況
	                     String parentItemDesc = csBOMInfo.getString(7);
	                     String errorMessage = csBOMInfo.getString(8);      //  回傳 REQUEST 執行狀況
	                     String errorCode = csBOMInfo.getString(9);         //  回傳 REQUEST 執行狀況訊息
	                     int seqID = csBOMInfo.getInt(10);	                 //  回傳 此次 SEQUENCE ID
	                     csBOMInfo.close(); 
					 }
					 rsPrev.close();
					 statePrev.close();
					 
					// ******** Step2. 再組合一次SQL取被展開ITEM Where Used 的清單
					sql = " select DISTINCT decode(YBI.ORGANIZATION_ID,'326','內銷','327','外銷') as 內外銷, IQC_RESULT as RESULT, IQC_WAFER_LOT as WAFERLOT, IQC_RECEPT_QTY as IQC收料數量, IQC_GRAINQTY as IQC晶片數,IQC_INV_ITEM as INV_ITEM, IQC_ITEM_ID as INV_ITEM_ID, MSI.DESCRIPTION as INV_ITEM_DESC, IQC_INSP_NO as WAFERIQCNO ,  "+					       
							"               IQC_VENDOR_NAME as SUPPLIER_SITE_NAME, IQC_YIELD as TOTAL_YIELD, IQC_WAFER_TYPE as WF_TYPE_NAME, IQC_WAFER_RESIST as WF_RESIST , "+
							"               IQC_UOM as UOM, IQC_ITEM_ID as INV_ITEM_ID, IQC_LINE_NO as LINE_NO, IQC_INSPDATE as INSPECT_DATE, IQC_WAFER_AMP as WAFER_AMP, "+
						 	"               PARENT_ITEM_ID, PARENT_INV_ITEM, PARENT_ITEM_DESC "+
							"   from YEW_BOM_IMPL_TEMP1 YBI, MTL_SYSTEM_ITEMS MSI ";
					where =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+	
					        "    and YBI.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+	
							"    and YBI.IQC_ITEM_ID = MSI.INVENTORY_ITEM_ID "+														 
							"    and YBI.QUERY_TYPE = 'FAKE' and YBI.WO_TYPE = 1 "+ // 只找切割工令的
							"    and substr(YBI.PARENT_INV_ITEM,1,3) in ('1A-','1B-' ) ";  //20151225 liling add 1B-
					order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT "; 
					
					if (runCardGet!=null && !runCardGet.equals("")) where = where + " and IQC_WAFER_LOT not in ("+runCardGet+") "; // 先前已在清單內的WaferLot不得出現 		
		            if (invItem!=null && !invItem.equals("")) where = where + " and ( QRY_INV_ITEM = '"+invItem+"' or QRY_INV_ITEM like '%"+invItem+"%' ) ";		                 
		            if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--")) where = where + "and ( IQC_WAFER_RESIST = '"+waferResist+"' or IQC_WAFER_RESIST like '%"+waferResist+"%' )   ";
		            if (diceSize!=null && !diceSize.equals("") && !diceSize.equals("--")) where = where + "and ( IQC_DICE_SIZE= '"+diceSize+"' and IQC_DICE_SIZE like '%"+diceSize+"%' ) ";
		
		            if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) where = where + "and ( IQC_WAFER_LOT= '"+supplierLot+"' or IQC_WAFER_LOT like '%"+supplierLot+"%' ) ";

		             // 需要改為取特定索引 SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  /			 
		             if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		             {  
		                    where = where + " and ( IQC_WAFER_LOT like '%' ) ";
		                    //sql = sql + "and (a.SEGMENT1 = '%') ";   
		             }
		             else 
		                 { 
		                    where = where + "  and ( upper(IQC_INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQC_INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                        "         OR upper(QRY_INV_ITEM) =  '"+searchString.toUpperCase()+"' or upper(QRY_INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+
									        "         OR upper(IQC_WAFER_LOT) = '"+searchString.toUpperCase()+"' or upper(IQC_WAFER_LOT) like '"+searchString.toUpperCase()+"%' ) ";
	                     } 
					  
				   // *********** Step2. 再由暫存表做一次關連_迄
					 
		  } else if (woType.equals("2")) // 前段工令
		         {				 
				         //sqlCNT = "select count(IQCH.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD,ORADDMAN.TSCIQC_WAFER_TYPE IQCWT, "+
						 //     "    BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, MTL_SYSTEM_ITEMS MSI";
/* //20091124 liling update performance issue
	              sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY IQC收料數量,IQCD.GRAINQTY,  "+		   
				                      "          MSI.SEGMENT1 as INV_ITEM, REPLACE(MSI.DESCRIPTION,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
		                              "          IQCH.SUPPLIER_SITE_NAME, decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST , "+	   	   
		                              //"          IQCD.UOM, BSB.ASSEMBLY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
									  "          IQCD.UOM, IQCD.INV_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                                  " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, ORADDMAN.TSCIQC_WAFER_TYPE IQCWT, "+
			                         "       MTL_SYSTEM_ITEMS MSI ";					                 
	      	             where=       " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                              "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 加入已經驗收入庫或經特採入庫的檢驗批
									  "   and IQCD.INV_ITEM_ID = MSI.INVENTORY_ITEM_ID and IQCD.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+
									  "   and MSI.ORGANIZATION_ID = "+organizationId+" "+
									  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "; // Clone 後PO方有存在									 
		                 order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
	*/
	              sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY IQC收料數量,IQCD.GRAINQTY,  "+		   
				                      "          IQCD.INV_ITEM, REPLACE(IQCD.INV_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
		                              "          IQCH.SUPPLIER_SITE_NAME, decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST , "+	   	   
		                              //"          IQCD.UOM, BSB.ASSEMBLY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
									  "          IQCD.UOM, IQCD.INV_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                                  " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, ORADDMAN.TSCIQC_WAFER_TYPE IQCWT ";					                 
	      	             where=       " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                              "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 加入已經驗收入庫或經特採入庫的檢驗批
									  "   and IQCD.ORGANIZATION_ID = "+organizationId+" "+
									  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "; // Clone 後PO方有存在									 
		                 order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
	
		                 if (runCardGet!=null && !runCardGet.equals("")) where = where + " and IQCD.SUPPLIER_LOT_NO not in ("+runCardGet+") "; // 先前已在清單內的WaferLot不得出現 
		
		                 if (invItem!=null && !invItem.equals("")) where = where + " and ( IQCD.INV_ITEM = '"+invItem+"' or IQCD.INV_ITEM like '%"+invItem+"%' ) ";
		                  //if (itemDesc!=null && !itemDesc.equals("")) where = where + "and INV_ITEM_DESC = '"+itemDesc+"' ";
		                 // out.println("waferResist="+waferResist);
		                 if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--") && !waferResist.equals("0")) where = where + "and ( IQCH.WF_RESIST = '"+waferResist+"' or IQCH.WF_RESIST like '%"+waferResist+"%' )   ";
		                 if (diceSize!=null && !diceSize.equals("") && !diceSize.equals("--") && !diceSize.equals("0")) where = where + "and ( IQCD.DICE_SIZE= '"+diceSize+"' and IQCD.DICE_SIZE like '%"+diceSize+"%' ) ";
		
		                 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) 
						 { 
						 
						   where = where +  " and ( IQCD.SUPPLIER_LOT_NO= '"+supplierLot+"' or IQCD.SUPPLIER_LOT_NO like '%"+supplierLot+"%' "+
						                    "         OR upper(IQCD.INV_ITEM) = '"+supplierLot.toUpperCase()+"' or upper(IQCD.INV_ITEM) like '"+supplierLot.toUpperCase()+"%'  "+ 
					                        "         OR upper(IQCD.INV_ITEM_DESC) = '"+supplierLot.toUpperCase()+"' or upper(IQCD.INV_ITEM_DESC) like '"+supplierLot.toUpperCase()+"%' "+
						                    " ) ";
						 }

		                 // 需要改為取特定索引 SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		                 if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		                 {  
		                    where = where + " and ( IQCD.SUPPLIER_LOT_NO like '%' ) ";
		                   //sql = sql + "and (a.SEGMENT1 = '%') ";   
		                 }
		                 else 
		                 { 
						    		
	                     } 					 							
					
				     //  先把資料存至暫存檔_起 	
					 // *********** Step1. 先由第一次的條件組合寫入暫存表					 
					 sql = sql + where + order;	 // 2007/01/17 因舊庫存尚有晶粒批
					 //out.println("sql="+sql);
					
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sql);				   
				     while (rsPrev.next())
					 {					 
					      // 取 Item Where Use的 Procedure_起
				          String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
			              //out.println("prevSubItem ="+prevSubItem);			  
			              CallableStatement csBOMInfo = con.prepareCall("{call TSC_BOM_IMPLODER_PARENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	                      csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			              csBOMInfo.setString(2,woType);
	                      csBOMInfo.setInt(3,rsPrev.getInt("INV_ITEM_ID")); 
	                      csBOMInfo.setString(4,prevSubItem);                 // 原子階料號前三碼( 判定 11-, 10- 或 1A- )
	                      csBOMInfo.registerOutParameter(5, Types.INTEGER);   // 回傳 Parent Item ID
	                      csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // 回傳 Parent Inv Item
	                      csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // 回傳 Parent Item Desc
	                      csBOMInfo.registerOutParameter(8, Types.VARCHAR);   // 回傳 Error Message
	                      csBOMInfo.registerOutParameter(9, Types.VARCHAR);   // 回傳 Error Code
						  csBOMInfo.registerOutParameter(10, Types.INTEGER);  // 回傳 此次 SEQUENCE ID
						  csBOMInfo.setString(11,"");                         // 先不依Sort Code取回 母階資訊
						  csBOMInfo.setString(12,rsPrev.getString("WAFERLOT"));   // 給Wafer Lot
						  csBOMInfo.setString(13,rsPrev.getString("WAFERIQCNO")); // 給IQC No.
						  csBOMInfo.setInt(14,rsPrev.getInt("LINE_NO"));          // 給IQC Line No.
						  csBOMInfo.setString(15,"FAKE");                         // 預先查詢
	                      csBOMInfo.execute();
			              int parentInvItemID = csBOMInfo.getInt(5);
	                      String parentInvItem = csBOMInfo.getString(6);       //  回傳 REQUEST 執行狀況
	                      String parentItemDesc = csBOMInfo.getString(7);
	                      String errorMessage = csBOMInfo.getString(8);      //  回傳 REQUEST 執行狀況
	                      String errorCode = csBOMInfo.getString(9);         //  回傳 REQUEST 執行狀況訊息
						  int seqID = csBOMInfo.getInt(10);	                 // 回傳 此次 SEQUENCE ID
	                      //out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	                      csBOMInfo.close(); 
					 } // End of while
					 rsPrev.close();
					 statePrev.close();
				    //  先把資料存至暫存檔_迄
					// *********** Step2. 再由暫存表做一次關連_起						
					
					  //out.println("organizationId="+organizationId);
					  sql = " select DISTINCT decode(YBI.ORGANIZATION_ID,'326','內銷','327','外銷') as 內外銷, IQC_RESULT as RESULT, IQC_WAFER_LOT as WAFERLOT, IQC_RECEPT_QTY as IQC收料數量, IQC_GRAINQTY as IQC晶片數,"+
					        "        QRY_INV_ITEM as INV_ITEM, REPLACE(QRY_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQC_INSP_NO as WAFERIQCNO, "+
							"        IQC_VENDOR_NAME as SUPPLIER_SITE_NAME, IQC_YIELD as TOTAL_YIELD, IQC_WAFER_TYPE as WF_TYPE_NAME, IQC_WAFER_RESIST as WF_RESIST , "+
							"        IQC_UOM as UOM, QRY_ITEM_ID as INV_ITEM_ID, IQC_LINE_NO as LINE_NO, IQC_INSPDATE as INSPECT_DATE, IQC_WAFER_AMP as WAFER_AMP, "+
						 	"        PARENT_ITEM_ID, PARENT_INV_ITEM, PARENT_ITEM_DESC "+
							"   from YEW_BOM_IMPL_TEMP1 YBI ";
					where =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+																 
							"    and YBI.QUERY_TYPE = 'FAKE'  and YBI.WO_TYPE = 2 "+ // 只找前段工令
						//	"    and length(YBI.PARENT_INV_ITEM) = 13 and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151224 liling add 1B
                            "    and length(YBI.PARENT_INV_ITEM) IN (13, 16, 17, 20) and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151224 liling add 1B, 20170922 ADD 16	,20171005 ADD 20						
					order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
					     if (runCardGet!=null && !runCardGet.equals("")) where = where + " and IQC_WAFER_LOT not in ("+runCardGet+") "; // 先前已在清單內的WaferLot不得出現 		
		                 if (invItem!=null && !invItem.equals("")) where = where + " and ( QRY_INV_ITEM = '"+invItem+"' or QRY_INV_ITEM like '%"+invItem+"%' ) ";		                 
		                 if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--") && !waferResist.equals("0")) where = where + "and ( IQC_WAFER_RESIST = '"+waferResist+"' or IQC_WAFER_RESIST like '%"+waferResist+"%' )   ";
		                 if (diceSize!=null && !diceSize.equals("") && !diceSize.equals("--") && !diceSize.equals("0")) where = where + "and ( IQC_DICE_SIZE= '"+diceSize+"' and IQC_DICE_SIZE like '%"+diceSize+"%' ) ";
		
                         if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) 
						 {  
						   where = where + " and ( IQC_WAFER_LOT= '"+supplierLot+"' or IQC_WAFER_LOT like '%"+supplierLot+"%'  "+
						                    "         OR upper(IQC_INV_ITEM) = '"+supplierLot.toUpperCase()+"' or upper(IQC_INV_ITEM) like '"+supplierLot.toUpperCase()+"%'  "+ 
						                    " ) ";
						   
						 }

		                 // 需要改為取特定索引 SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  /			 
		                 if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		                 {  
		                    where = where + " and ( IQC_WAFER_LOT like '%' ) ";		                     
		                 }
		                 else 
		                 { 
						   /*
		                    where = where + "  and ( upper(IQC_INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQC_INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                        "         OR  upper(QRY_INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(QRY_INV_ITEM) like '"+searchString.toUpperCase()+"%' "+
									        "         OR upper(IQC_WAFER_LOT) = '"+searchString.toUpperCase()+"' or upper(IQC_WAFER_LOT) like '"+searchString.toUpperCase()+"%' ) ";
						   */				
	                     } 					  
				   // *********** Step2. 再由暫存表做一次關連_迄
				   
				     sqlOld = "select decode(a.ORGANIZATION_ID,'326','內銷','327','外銷') as  內外銷,'01' as RESULT, a.LOT_NUMBER as WAFERLOT, a.PRIMARY_TRANSACTION_QUANTITY as IQC收料數量, "+
					                 "       b.SEGMENT1 as INV_ITEM, REPLACE(b.DESCRIPTION,'"+"\""+"',' inch ') as INV_ITEM_DESC, 'IQC0120070101-106' as WAFERIQCNO, "+
									 "       'SUPPLIER' as SUPPLIER_SITE_NAME, 'N/A' as TOTAL_YIELD, 'N/A' as WF_TYPE_NAME, 'N/A' as WF_RESIST, "+
									 "       a.TRANSACTION_UOM_CODE as UOM, a.INVENTORY_ITEM_ID as INV_ITEM_ID, 1 as LINE_NO,to_char(a.DATE_RECEIVED,'YYYY/MM/DD HH24:MI:SS')  as INSPECT_DATE, 'N/A' as WAFER_AMP, "+
									 "       a.INVENTORY_ITEM_ID as PARENT_ITEM_ID, b.SEGMENT1 as PARENT_INV_ITEM, b.DESCRIPTION as PARENT_ITEM_DESC  "+
					                 " from MTL_ONHAND_QUANTITIES_DETAIL a, MTL_SYSTEM_ITEMS b ";
					 whereOld =" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
									  "   and a.ORGANIZATION_ID = b.ORGANIZATION_ID and a.ORGANIZATION_ID = "+organizationId+" ";
					 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) whereOld = whereOld + "and ( a.LOT_NUMBER= '"+supplierLot+"' or a.LOT_NUMBER like '%"+supplierLot+"%' ) ";			
				   
				   
				 } // End of else if (woType.equals("2"))	           	
		sql = sql + where + order;
        //out.println("sql="+sqlOld+whereOld); 		 
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='center' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>項次</TD>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
		  if (i==5)
		  {
		    if (woType.equals("1"))
			{
			 out.println("<TD nowrap><FONT COLOR=BROWN>剩餘數"+"</TD>");
		     out.println("<TD nowrap><FONT COLOR=BLUE><strong>製成晶粒品號"+"</strong></TD>");
			 out.println("<TD nowrap><FONT COLOR=BROWN>可用晶片數"+"</TD>");
			} else if (woType.equals("2")) // 前段工令再多帶一切割流程卡號
		           {
				     out.println("<TD nowrap><FONT COLOR=BROWN>剩餘數"+"</TD>");
		             //out.println("<TD nowrap><FONT COLOR=BLUE><strong>切割流程卡號"+"</strong></TD>");
			         out.println("<TD nowrap><FONT COLOR=BLUE><strong>製成半成品號"+"</strong></TD>");
					 out.println("<TD nowrap><FONT COLOR=BROWN>可用晶片數"+"</TD>");
		           }
		  }
		 //if (i==11) out.println("<TD nowrap><FONT COLOR=BROWN>剩餘數"+"</TD>");
         colLabel[i]=md.getColumnLabel(i);
		 out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");
		  
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
		int j = 0; //項次數
		float sumWOCretedQty = 0;
		float accAvailQty = 0;
		float sumWOCretedQty1 = 0;
		float accAvailQty1 = 0;
		    String cutAsbItemId = "";
			String cutAsbInvItem = "";
			String cutAsbItemDesc = "";
			
			String subAsbItemId = "";
			String subAsbInvItem = "";
			String subAsbItemDesc = "";
			String waferLotTmp = null; // 每次取到的Lot 給暫存
			String cutAsbInvItemTmp = null; // 每次取到的製成品給暫存
			float cutterWoQty = 0; // 切割段工令產出數
        while (rs.next())
        {
			String chkCutAsbFlag = "N";
			String chkSubAsbFlag = "N";		
			String cutWoList = "已開切割工令<BR>";
			String frontWoList = "已開切割、前段工令<BR>";	
			String IQCItemList = "IQC料號資訊<BR>"; 		
		 
		 // 取切割工令完成品之料號資訊_起
		 if (woType.equals("1")) // 如為切割工令
		 {	    
			int parentInvItemID = rs.getInt("PARENT_ITEM_ID");
	        String parentInvItem = rs.getString("PARENT_INV_ITEM");      //  回傳 REQUEST 執行狀況
	        String parentItemDesc = rs.getString("PARENT_ITEM_DESC"); 					  
				 
			// 取 Item Where Use的 Procedure_迄 
		 
		   result=rs.getString("RESULT");
		   waferLot=rs.getString("WAFERLOT");		
		   invItem=rs.getString("INV_ITEM");
		   itemDesc=rs.getString("INV_ITEM_DESC");	
		   waferVendor=rs.getString("SUPPLIER_SITE_NAME");
 		   waferQty=rs.getString(4); //rs.getString("RECEIPT_QTY");
		   IQC_GRAINQTY = rs.getString(5);
		   waferUom=rs.getString("UOM");  // 2007/01/30 晶片的單位,如為PCE, 則計算扣除已開數需以晶片片數為基準
		   waferYld=rs.getString("TOTAL_YIELD");
		   waferElect=rs.getString("WF_RESIST");
		   waferIqcNo=rs.getString("WAFERIQCNO");	
		   waferKind=rs.getString("WF_TYPE_NAME");
		   itemId=rs.getString("INV_ITEM_ID");	
		   waferLineNo=rs.getString("LINE_NO");
		   waferAmp=rs.getString("WAFER_AMP");     

			 if (parentInvItemID!=0)
			 {
			   cutAsbItemId = Integer.toString(parentInvItemID);
			   cutAsbInvItem = parentInvItem;;
			   cutAsbItemDesc = parentItemDesc;
			   itemId = cutAsbItemId;
			   invItem = cutAsbInvItem; //out.println("cutAsbInvItem="+cutAsbInvItem);
			   itemDesc = cutAsbItemDesc;	
			   chkCutAsbFlag = "Y";
			 }
			 else if (parentInvItemID==0 || parentInvItem=="" || parentInvItem.equals(""))
	         {
	                 cutAsbInvItem="<font color=#CC0033><em>無對應切割完工品號</em></font>";
			         chkCutAsbFlag = "N";
	         }
            Statement stateWOCr1=con.createStatement();
		             String sqlWoCr1 = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr1 = sqlWoCr1+ " and WORKORDER_TYPE in ('1','2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		             ResultSet rsWOCr1=stateWOCr1.executeQuery(sqlWoCr1);
		             if (rsWOCr1.next()) sumWOCretedQty1 = rsWOCr1.getFloat(1);
					 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1;
		             rsWOCr1.close();
		             stateWOCr1.close(); 
		   if (waferUom.equals("KPC")) // 2007/01/30 晶片的單位,如為PCE, 則計算扣除已開數需以晶片片數為基準
		   {		   
		     // 累加切割、前段已開工令的已開數_起(因為IQC 晶片來源為共用於切割及前段)
		     Statement stateWOCr=con.createStatement();
		     String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                    "   where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
							"     and WAFER_IQC_NO in ( select ORDER_NO from YEW_MFG_TRAVELS_ALL where ( PRIMARY_NO='"+rs.getString("WAFERIQCNO")+"' ) )  ";
		     if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1','2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		     ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		     if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		     rsWOCr.close();
		     stateWOCr.close(); 	 
		     // 累加切割、前段已開工令的已開數_迄(因為IQC 晶片來源為共用於切割及前段)
		   } else if (waferUom.equals("PCE")) // 來料為晶片,以片數扣除已開數
		          {
				     Statement stateWOCr=con.createStatement();
		             String sqlWoCr = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1','2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		             ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		             if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		             rsWOCr.close();
		             stateWOCr.close(); 	
				  }
			 
			  // 列表依廠商批號_起			   
			   Statement stateWOLst=con.createStatement();
		       String sqlWoLst = "select DISTINCT WO_NO||'(數量='||WO_QTY||',單耗量='||WO_UNIT_QTY||')' from YEW_WORKORDER_ALL "+
		                         " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
		                         "   and WORKORDER_TYPE in ('1','2') "; // 依切割工令及廠商批號找出累計已開數量	 
		       ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		       while (rsWOLst.next()) 
			   {
			     cutWoList = cutWoList + rsWOLst.getString(1)+"<BR>";
			   }
		       rsWOLst.close();
		       stateWOLst.close();
			   
			   if (cutWoList.equals("已開切割工令<BR>"))  cutWoList = "已開切割工令<BR>無";
			// 列表依廠商批號_迄
			
			// 列表取IQC的購買料號_起			   
			   Statement stateIQCLst=con.createStatement();
		       String sqlIQCLst = "select INV_ITEM_ID||'(料號='||INV_ITEM||')' from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL  "+
		                         " where SUPPLIER_LOT_NO = '"+rs.getString("WAFERLOT")+"' and INSPLOT_NO='"+rs.getString("WAFERIQCNO")+"' "+
								 "   and LINE_NO= '"+rs.getString("LINE_NO")+"' ";		                      
		       ResultSet rsIQCLst=stateIQCLst.executeQuery(sqlIQCLst);
		       if (rsIQCLst.next()) 
			   {
			     IQCItemList = rsIQCLst.getString(1);
			   }
		       rsIQCLst.close();
		       stateIQCLst.close();			   
			   //if (IQCItemList.equals("IQC收料料號<BR>")) IQCItemList = "已開切割工令<BR>無";
			// 列表取IQC的購買料號_迄

		   // 切割工令的累計可用餘額
		   accAvailQty = Float.parseFloat(waferQty) - sumWOCretedQty; // 可開單數 = IQC收料數 - 累積工單開立數
		  
		   defaultWoQty=Float.toString(accAvailQty); // 當成這次可開立數    		   
		   
		   
		 } // 取切割工令完成品之料號資訊_迄
		 else if (woType.equals("2")) // 如為前段工令,則由Item Master的ItemType先取得晶粒料號(1A-XXX),再對應取得半成品(15碼)料號
		      {

				  String prevSubItem = rs.getString("INV_ITEM").substring(0,3);			  

			  // 取 Item Where Use的 Procedure_迄 
			      int parentInvItemID = rs.getInt("PARENT_ITEM_ID");
	              String parentInvItem = rs.getString("PARENT_INV_ITEM");      //  回傳 REQUEST 執行狀況
	              String parentItemDesc = rs.getString("PARENT_ITEM_DESC"); 			      
			    
				  // Step1. 取對應晶粒料號(1A-XXXX)
				  
				  result=rs.getString("RESULT");
		          waferLot=rs.getString("WAFERLOT");		
		          invItem=rs.getString("INV_ITEM");
		          itemDesc=rs.getString("INV_ITEM_DESC");	
		          waferVendor=rs.getString("SUPPLIER_SITE_NAME");
 		          waferQty=rs.getString(4); //rs.getString("RECEIPT_QTY"); // IQC 收料數量
				  //out.println("waferQty="+waferQty);
				  IQC_GRAINQTY = rs.getString(5);
		          waferUom=rs.getString("UOM"); // 2007/01/30 晶片的單位,如為PCE, 則計算扣除已開數需以晶片片數為基準
		          waferYld=rs.getString("TOTAL_YIELD");
		          waferElect=rs.getString("WF_RESIST");
		          waferIqcNo=rs.getString("WAFERIQCNO");	
		          waferKind=rs.getString("WF_TYPE_NAME");
		          itemId=rs.getString("INV_ITEM_ID");	
		          waferLineNo=rs.getString("LINE_NO");
		          waferAmp=rs.getString("WAFER_AMP");		
		
		        // 2006/12/16 Fix By Kerwin  以 Item Where Used 的Procedure 取製成品號資訊
		        if (parentInvItemID!=0)
			    {
				    subAsbItemId = Integer.toString(parentInvItemID) ; 
			        subAsbInvItem = parentInvItem;
			        subAsbItemDesc = parentItemDesc;
			        itemId = subAsbItemId;
			        invItem = subAsbInvItem;
			        itemDesc = subAsbItemDesc;	
					chkSubAsbFlag = "Y";	
					//out.println("parentInvItemID="+parentInvItemID);			 
			      } 
				    else if (parentInvItemID==0 || parentInvItem=="" || parentInvItem.equals(""))
				         {				  
				            chkSubAsbFlag = "N";
							//out.println("parentInvItemID="+parentInvItemID);		
						 }    
						 
			   // 列表依廠商批號_起
			 //out.println("RRRR2<BR>");   
			 
			   Statement stateWOLst=con.createStatement();
		       String sqlWoLst = " select DISTINCT WO_NO||'(數量='||WO_QTY||',單耗量='||WO_UNIT_QTY||')' "+
			                     " from YEW_WORKORDER_ALL "+
		                         " where STATUSID !='050'  AND WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
								// " and INV_ITEM= '"+parentInvItem+"' "+  // 此檢驗批列表已開切割工令號
		                         " and WORKORDER_TYPE in ('1', '2') "; // 依切割工令及廠商批號找出累計已開數量	 
		        //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		       while (rsWOLst.next()) 
			   {
			     frontWoList = frontWoList + rsWOLst.getString(1)+"<BR>";
			   }
		       rsWOLst.close();
		       stateWOLst.close();
			   
			   if (frontWoList.equals("已開前段工令<BR>")) frontWoList = "已開前段工令<BR>無";			   
		// 列表依廠商批號_迄		
		
		// 列表取IQC的購買料號_起			   
			   Statement stateIQCLst=con.createStatement();
		       String sqlIQCLst = "select INV_ITEM_ID||'(料號='||INV_ITEM||')' from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL  "+
		                          " where SUPPLIER_LOT_NO = '"+rs.getString("WAFERLOT")+"' and INSPLOT_NO='"+rs.getString("WAFERIQCNO")+"' "+
								  "   and LINE_NO= '"+rs.getString("LINE_NO")+"' ";		                      
		       //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsIQCLst=stateIQCLst.executeQuery(sqlIQCLst);
		       if (rsIQCLst.next()) 
			   {
			     IQCItemList = rsIQCLst.getString(1);
			   }
		       rsIQCLst.close();
		       stateIQCLst.close();			   
			   //if (IQCItemList.equals("IQC收料料號<BR>")) IQCItemList = "已開切割工令<BR>無";
		// 列表取IQC的購買料號_迄 
			  
				//out.println("RRRR3<BR>");	  	
	//out.println("RRRR3<BR>");		
				//  若為前段工令,則嘗試去尋找切割流程卡號(工令)_起
			    if (woType.equals("2")) // 若為前段工令,則嘗試去尋找切割流程卡號(工令)
		        {
		           Statement stateFront=con.createStatement();
		           String sqlFront = " select b.RUNCARD_NO, a.WO_QTY, b.COMPLETION_QTY, a.WO_UNIT_QTY "+
		                     "  from YEW_WORKORDER_ALL a,YEW_RUNCARD_ALL b, YEW_MFG_TRAVELS_ALL c "+ 
							 "  where a.WO_NO = b.WO_NO and a.WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"' "+
							 "    and a.WO_NO = c.EXTEND_NO and c.PRIMARY_TYPE = '0' "+
							 "    and c.PRIMARY_NO = '"+rs.getString("WAFERLOT")+"' and c.EXTEND_TYPE = '1' "+							
		                     "    and a.WORKORDER_TYPE = '1' and b.STATUSID = '048' "; // 找切割流程卡號(工令)	

		           ResultSet rsFront=stateFront.executeQuery(sqlFront);
		           if (rsFront.next()) 
		           { 
		              frontRunCard = rsFront.getString(1);
			          cutterWoQty = rsFront.getFloat(3);// 取切割段工令完工數 
			          if (cutterWoQty==0) cutterWoQty = rsFront.getFloat(2);// 如果切割段未完工,則以工令數作為計算基礎			 
			          cutterRCNo=frontRunCard; 
					  
			          if (waferUom.equals("KPC")) // 2007/01/30 晶片的單位,如為PCE, 則計算扣除已開數需以晶片片數為基準
		              {	
			             // 累加切割、前段已開工令的已開數_起
		                 Statement stateWOCr=con.createStatement();
		                 String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                                  " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
							              "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+									  
									      "   and WAFER_IQC_NO in ( select ORDER_NO from YEW_MFG_TRAVELS_ALL where ( PRIMARY_NO='"+rs.getString("WAFERIQCNO")+"' ) ) "; // RuncardNo
		                 if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE ='2' "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		                 //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                 ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                 if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                 rsWOCr.close();
		                 stateWOCr.close(); 	 
		                 // 累加切割、前段已開工令的已開數_迄	
					   } else if (waferUom.equals("PCE")) // 來料為晶片,則以片數累計為計算基礎
					          {
					            // 累加切割、前段已開工令的已開數_起
		                        Statement stateWOCr=con.createStatement();
		                        String sqlWoCr = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                                         " where STATUSID!='050' "+
							                     "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+									  
									             "   and WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"'  "; // RuncardNo
		                        if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1','2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		                        //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                        ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                        if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                        rsWOCr.close();
		                        stateWOCr.close(); 	 
		                        // 累加切割、前段已開工令的已開數_迄  
					          }	
					Statement stateWOCr1=con.createStatement();
		             String sqlWoCr1 = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr1 = sqlWoCr1+ " and WORKORDER_TYPE in ('1','2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		             ResultSet rsWOCr1=stateWOCr1.executeQuery(sqlWoCr1);
		             if (rsWOCr1.next()) sumWOCretedQty1 = rsWOCr1.getFloat(1);
					 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1;
		             rsWOCr1.close();
		             stateWOCr1.close(); 
                              //out.println("RRRR3.22<BR>");			 
		            }
		            else 
		            {  // 找不到,則可能是直接選取IQC 檢驗批號,故傳回時應將IQC號碼作為追溯序號
		   
		                     frontRunCard =rs.getString("WAFERIQCNO");
			                 cutterRCNo="";
							 Statement stateWOCr1=con.createStatement();
		             String sqlWoCr1 = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr1 = sqlWoCr1+ " and WORKORDER_TYPE in ('1','2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		             ResultSet rsWOCr1=stateWOCr1.executeQuery(sqlWoCr1);
		             if (rsWOCr1.next()) sumWOCretedQty1 = rsWOCr1.getFloat(1);
					 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1;
		             rsWOCr1.close();
		             stateWOCr1.close(); 
			             if (waferUom.equals("KPC")) // 2007/01/30 晶片的單位,如為PCE, 則計算扣除已開數需以晶片片數為基準
						 {
			                 // 累加切割、前段已開工令的已開數_起
		                     Statement stateWOCr=con.createStatement();
		                     String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                                      " where STATUSID!='050' and WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"' "+
											  "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+
											  "   and WAFER_IQC_NO in ( select ORDER_NO from YEW_MFG_TRAVELS_ALL where PRIMARY_NO='"+rs.getString("WAFERIQCNO")+"' )";
		                      if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE ='2' "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		                      //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                      ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                      if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                      rsWOCr.close();
		                      stateWOCr.close(); 	 
		                      // 累加切割、前段已開工令的已開數_迄	
						} else if (waferUom.equals("PCE"))
						       {
							      Statement stateWOCr=con.createStatement();
		                          String sqlWoCr = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                                           " where STATUSID!='050' "+
											       "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+							                      
											       "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"' ";
		                          if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1', '2') "; // 依切割或前段工令區別找出已開數量及IQC批號	 
		                          //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                          ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                          if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                          rsWOCr.close();
		                          stateWOCr.close(); 
							   } // End of else if (PCE)		 
                      //out.println("RRRR3.33<BR>");			 
		             } // End of else 
		             rsFront.close();
		             stateFront.close();	 
		   
		          }	// End of if (woType.equals("2")) // 若為前段工令,則嘗試去尋找切割流程卡號(工令)
 //out.println("RRRR4<BR>");		
				// 若為前段工令,則嘗試去尋找切割流程卡號(工令)_迄
				 //  ******#$$$$&&&&&$$$$$$ 計算可用餘額 $$$$$$$$$$$$&&&&&&&&77 ********* //
		       
				     accAvailQty = Float.parseFloat(waferQty) - sumWOCretedQty;    // 可開單剩餘數 = IQC收料數 - 累積工單開立數
		             defaultWoQty=Float.toString(accAvailQty); // 當成這次可開立數		
				  	 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1; 	 
		         //  ******#$$$$&&&&&$$$$$$ 計算可用餘額 $$$$$$$$$$$$&&&&&&&&77 ********* //	
					  
			  } //End of else if (line 568) 如為前段工令,則由Item Master的ItemType取得半成品(15碼)料號
		
		 
		 //out.print("invItem="+invItem);
      
		//-----抓取存在工單檔裡的檢驗批 ------
		String sqla2= "  select wafer_lot_no, wafer_qty from APPS.YEW_WORKORDER_ALL  where STATUSID !='050' and WAFER_LOT_NO = '"+waferIqcNo+"' and WAFER_LINE_NO= '"+waferLineNo+"'";
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
		
		
		if (accAvailQty<0) accAvailQty = 0;
		if (accAvailQty1<0) accAvailQty1 = 0;
		if (accAvailQty>0)  // if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示此列(資料顯示,但無法點擊帶入鈕)
	    { 
		  if (waferLot!=waferLotTmp && !waferLot.equals(waferLotTmp) && cutAsbInvItem!=cutAsbInvItemTmp && cutAsbInvItem.equals(cutAsbInvItemTmp)) // 每次取到的製成品給暫存)// 可能BOM 對到一個以上的製成品號,若是,則序號不累加
		  {
		     j++; // 項次數
		  }
		%>
		<INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=j%>","<%=waferLot%>","<%=invItem%>","<%=itemDesc%>","<%=waferVendor%>","<%=waferQty%>","<%=waferUom%>","<%=waferYld%>","<%=waferElect%>","<%=waferIqcNo%>","<%=waferKind%>","<%=itemId%>","<%=woUom%>","<%=waferLineNo%>","<%=defaultWoQty%>","<%=woType%>","<%=waferIqcNo%>","<%=chkCutAsbFlag%>","<%=chkSubAsbFlag%>","<%=waferAmp%>")'>
		<%
		}  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料顯示,但無法點擊帶入鈕)
		else { 
		     // j--; //不計入
		      out.println("<em><font color='#FF0000'>無餘額</font></em>");
			 }
		if (accAvailQty1<0)  // if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示此列(資料顯示,但無法點擊帶入鈕)
	 
	         { 
		     // j--; //不計入
		      out.println("<em><font color='#FF0000'>無餘額</font></em>");
			 }
		 out.print("</TD>");		
		 out.print("<TD>"+j+"</TD>");
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         {
		    if (i==5) //前段工令再多帶一切割流程卡號_起
		    {			  
			  if (woType.equals("1"))
			  {
			    out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
			    out.println("<TD nowrap><FONT COLOR=BLUE><strong>"+cutAsbInvItem+"</strong></TD>");
				out.println("<TD nowrap><FONT>"+accAvailQty1+"</TD>");
			  }
			  else if (woType.equals("2")) // 前段工令再多帶一切割流程卡號
		           {
				     out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");		            
					 out.println("<TD nowrap><FONT COLOR=BLUE face='Georgia'><strong>"+subAsbInvItem+"</strong></TD>");					                     out.println("<TD nowrap><FONT>"+accAvailQty1+"</TD>");
		           }
		    } // 前段工令再多帶一切割流程卡號_迄		 
		 
		   //if (i==11) out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
		   
           String s=(String)rs.getString(i);
		   if (i==3)
		   { 
		      if (woType.equals("1"))
			  {
			    s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("+'"'+cutWoList+'"'+")'>"+s+"</a></strong></font>";
			  } else if (woType.equals("2"))
			         {
					   s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("+'"'+frontWoList+'"'+")'>"+s+"</a></strong></font>";
					 } 
		   } else if (i==7)
		          {
				     if (woType.equals("2"))
			         {
					   s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+IQCItemList+'"'+")'>"+s+"</a></strong></font>";
					 } 					  
				  }	 else if (i==8)
				          {
						     if (woType.equals("1"))
			                 {
					           s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+IQCItemList+'"'+")'>"+s+"</a></strong></font>";
					         } 
						  }
           out.println("<TD nowrap><FONT>"+s+"</TD>");// 列印各欄位資料
         } //end of for
          out.println("</TR>");	
		  
	      //	 }  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料也不顯示)
		  // %%%%%%%%%%%%%%%%%%%%%%
		  waferLotTmp = waferLot; // 晶片批號給暫存
		  cutAsbInvItemTmp = cutAsbInvItem; // 製成品號給暫存
		  // %%%%%%%%%%%%%%%%%%%%%%
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
 <hr>
  <% 
    if (woType.equals("2")) // 前段工令來源由切割工令
    {
  %>
  <span class="style1">開立前段工令由切割流程卡</span><BR>
  <%
    } // end of if (woType.equals("2"))
    // 將來自於檢驗批與來自切割流程卡選單區分開來
	  // 此為來自於WIP 切割完工工令的清單
	  try
	  {
	        //String sqlCNT = "";
		   String sqlCutRC = "";
		   String whereCutRC= "";
		   String orderCutRC = "";
		   
	       Statement stateCutRC=con.createStatement();
           if (woType.equals("2")) // 前段工令
		   {	   
		    // ************* Step1. 先取得暫存表的內容
	                     sqlCutRC = " select  DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.GRAINQTY,YRA.RUNCARD_NO as 切割流程卡號, YRA.COMPLETION_QTY as 切割流程卡完工數, "+
						           // "       ASI.SEGMENT1 as INV_ITEM, REPLACE(ASI.DESCRIPTION,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
								      "       YRA.INV_ITEM as INV_ITEM, REPLACE(YRA.ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
		                              "       IQCH.SUPPLIER_SITE_NAME, decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST , "+
	   				               // "       IQCD.UOM, ASI.INVENTORY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(YRA.CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
									  "       IQCD.UOM, YRA.PRIMARY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(YRA.CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                                  " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, ORADDMAN.TSCIQC_WAFER_TYPE IQCWT, "+
			                          "      BOM_COMPONENTS_B BCB, BOM_STRUCTURES_B BSB, MTL_SYSTEM_ITEMS MSI, "+
									  "      YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA, "+
									  "    ( select /* + orderCutRCED index(a BOM_COMPONENTS_B_N2)  */ COMPONENT_ITEM_ID, b.ASSEMBLY_ITEM_ID, MSIT.SEGMENT1, MSIT.DESCRIPTION, MSIT.INVENTORY_ITEM_ID, MSIT.ITEM_TYPE "+
				                      "        from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, MTL_SYSTEM_ITEMS MSIT "+
					                  "       where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and b.ASSEMBLY_ITEM_ID = MSIT.INVENTORY_ITEM_ID "+									  
							          "         and MSIT.ITEM_TYPE = 'SA' "+ // ItemType 是 subassembly
							         // "         and COMPONENT_ITEM_ID = "+cutAsbItemId+" "+ // 原晶粒料號(1A-XXXXXX)
							          "         and b.ORGANIZATION_ID = MSIT.ORGANIZATION_ID "+
					 		          // "         and b.ORGANIZATION_ID = "+organizationId+"  "+ // 2006/11/10 BOM Resource不能分Organization Id
									  "     ) ASI ";					                 
	      	             whereCutRC= " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                              "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 加入已經驗收入庫或經特採入庫的檢驗批
									  "   and YWA.WAFER_IQC_NO = IQCH.INSPLOT_NO and YWA.WAFER_LOT_NO = IQCD.SUPPLIER_LOT_NO "+
									  "   and YWA.WO_NO = YRA.WO_NO "+
									  "   and YRA.STATUSID = '048' and YWA.WORKORDER_TYPE = '1' "+  // 已經入庫的切割工令
									  "   and BCB.BILL_SEQUENCE_ID = BSB.BILL_SEQUENCE_ID and BSB.ASSEMBLY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+
							         //    "   and substr(MSI.SEGMENT1,3,LENGTH(MSI.SEGMENT1)) = substr(IQCD.INV_ITEM,3,LENGTH(IQCD.INV_ITEM)) "+
							          "   and BCB.COMPONENT_ITEM_ID = IQCD.INV_ITEM_ID "+ // 原IQC 收料晶片料號(11-XXXXXX)
							          "   and BSB.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+									
					 		          //  "   and BSB.ORGANIZATION_ID = "+organizationId+" "+ // 2006/11/10 BOM Resource不能分Organization Id
									  "   and ASI.COMPONENT_ITEM_ID = BSB.ASSEMBLY_ITEM_ID ";
		                     //   "   and IQCH.INSPLOT_NO = YWA.WAFER_IQC_NO(+) and IQCD.RECEIPT_QTY > ( select sum(WO_QTY) from YEW_WORKorderCutRC_ALL where WAFER_IQC_NO = YWA.WAFER_IQC_NO) "+  //"and IQCD.RECEIPT_QTY > DECODE(YWA.WO_QTY,null,0,YWA.WO_QTY) ";
		                 orderCutRC = "order by INSPECT_DATE ";
		
		                 if (runCardGet!=null && !runCardGet.equals(""))	 whereCutRC = whereCutRC + " and IQCD.SUPPLIER_LOT_NO not in ("+runCardGet+") "; // 先前已在清單內的WaferLot不得出現 
		
		                 // if (invItem!=null && !invItem.equals("")) whereCutRC = whereCutRC + "and IQCD.INV_ITEM = '"+invItem+"' ";
		                 // if (itemDesc!=null && !itemDesc.equals("")) whereCutRC = whereCutRC + "and INV_ITEM_DESC = '"+itemDesc+"' ";
		                 // out.println("waferResist="+waferResist);
		                 if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--")) whereCutRC = whereCutRC + "and ( IQCH.WF_RESIST = '"+waferResist+"' or IQCH.WF_RESIST like '%"+waferResist+"%' )   ";
		                 if (diceSize!=null && !diceSize.equals("")  && !diceSize.equals("--")) whereCutRC = whereCutRC + "and ( IQCD.DICE_SIZE= '"+diceSize+"' or IQCD.DICE_SIZE like '%"+diceSize+"%' ) ";
		            
					     if (supplierLot!=null && !supplierLot.equals("")) whereCutRC = whereCutRC + "and ( IQCD.SUPPLIER_LOT_NO= '"+supplierLot+"' or IQCD.SUPPLIER_LOT_NO like '%"+supplierLot+"%' ) ";

		                 // 需要改為取特定索引 SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */						  	 
		                 if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		                 {  
		                    whereCutRC = whereCutRC + " and (IQCD.SUPPLIER_LOT_NO like '%') ";		                   
		                 }
		                 else 
		                 { 						   		                   
						   whereCutRC = whereCutRC + "  and ( upper(IQCD.INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                                 "         OR upper(IQCD.INV_ITEM_DESC) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM_DESC) like '"+searchString.toUpperCase()+"%' "+
									                 "         OR upper(IQCD.SUPPLIER_LOT_NO) = '"+searchString.toUpperCase()+"' or upper(IQCD.SUPPLIER_LOT_NO) like '"+searchString.toUpperCase()+"%' ) ";
	                     } 		
						 
					 //  先把資料存至暫存檔_起 	
					 // *********** Step2. 先由第一次的條件組合寫入暫存表					 
					 sqlCutRC = sqlCutRC + whereCutRC + orderCutRC;	 
					 //out.println("sqlCutRC"+sqlCutRC);
					 
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sqlCutRC);				   
				     while (rsPrev.next())
					 {					 
					      // 取 Item Where Use的 Procedure_起
				          String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
			              //out.println("prevSubItem ="+prevSubItem);			  
			              CallableStatement csBOMInfo = con.prepareCall("{call TSC_BOM_IMPLODER_PARENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	                      csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			              csBOMInfo.setString(2,woType);
	                      csBOMInfo.setInt(3,rsPrev.getInt("INV_ITEM_ID")); 
	                      csBOMInfo.setString(4,prevSubItem);                 // 原子階料號前三碼( 判定 11-, 10- 或 1A- )
	                      csBOMInfo.registerOutParameter(5, Types.INTEGER);   // 回傳 Parent Item ID
	                      csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // 回傳 Parent Inv Item
	                      csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // 回傳 Parent Item Desc
	                      csBOMInfo.registerOutParameter(8, Types.VARCHAR);   // 回傳 Error Message
	                      csBOMInfo.registerOutParameter(9, Types.VARCHAR);   // 回傳 Error Code
						  csBOMInfo.registerOutParameter(10, Types.INTEGER);  // 回傳 此次 SEQUENCE ID
						  csBOMInfo.setString(11,"");                         // 先不依Sort Code取回 母階資訊
						  csBOMInfo.setString(12,rsPrev.getString("WAFERLOT"));   // 給Wafer Lot
						  csBOMInfo.setString(13,rsPrev.getString("WAFERIQCNO")); // 給IQC No.
						  csBOMInfo.setInt(14,rsPrev.getInt("LINE_NO"));          // 給IQC Line No.
						  csBOMInfo.setString(15,"FAKE");                         // 預先查詢
	                      csBOMInfo.execute();
			              int parentInvItemID = csBOMInfo.getInt(5);
	                      String parentInvItem = csBOMInfo.getString(6);     //  回傳 REQUEST 執行狀況
	                      String parentItemDesc = csBOMInfo.getString(7);
	                      String errorMessage = csBOMInfo.getString(8);      //  回傳 REQUEST 執行狀況
	                      String errorCode = csBOMInfo.getString(9);         //  回傳 REQUEST 執行狀況訊息
						  int seqID = csBOMInfo.getInt(10);	                 // 回傳 此次 SEQUENCE ID
	                      //out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	                      csBOMInfo.close(); 
					 } // End of while
					 rsPrev.close();
					 statePrev.close();
				    //  先把資料存至暫存檔_迄   	 
					
					// Step3. 再組合一次sql由暫存表內得到的關連資料_起
					   
					// Step3. 再組合一次sql由暫存表內得到的關連資料_迄	 		      
		            sqlCutRC = " select DISTINCT decode(YBI.ORGANIZATION_ID,'326','內銷','327','外銷') as 內外銷, IQC_RESULT as RESULT, IQC_WAFER_LOT as WAFERLOT, YRA.RUNCARD_NO as 切割流程卡號, YRA.COMPLETION_QTY as 切割流程卡完工數, "+
					           "        QRY_INV_ITEM as INV_ITEM, REPLACE(QRY_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQC_INSP_NO as WAFERIQCNO, "+
							   "        IQC_VENDOR_NAME as SUPPLIER_SITE_NAME, IQC_YIELD as TOTAL_YIELD, IQC_WAFER_TYPE as WF_TYPE_NAME, IQC_WAFER_RESIST as WF_RESIST , "+
							   "        IQC_UOM as UOM, QRY_ITEM_ID as INV_ITEM_ID, IQC_LINE_NO as LINE_NO, IQC_INSPDATE as INSPECT_DATE, IQC_WAFER_AMP as WAFER_AMP, "+
						 	   "        PARENT_ITEM_ID, PARENT_INV_ITEM, PARENT_ITEM_DESC "+
							   "   from YEW_BOM_IMPL_TEMP YBI,  YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA ";
					whereCutRC =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+	
					                "    and YWA.WAFER_LOT_NO = YBI.IQC_WAFER_LOT  "+	
									"    and YWA.WO_NO = YRA.WO_NO "+  // 工令及流程卡
									"    and YRA.STATUSID >= '048' and YWA.WORKORDER_TYPE = '1' "+  // 已經入庫的切割工令														 
							        "    and YBI.QUERY_TYPE = 'FAKE'  "+ //
							     //   "    and length(YBI.PARENT_INV_ITEM) = 13 and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151225 liling add 1B
							        "    and length(YBI.PARENT_INV_ITEM) IN (13, 16,17 ,20) and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151225 liling add 1B 	,20170922 ADD 16	 ,20171005 ADD 20							 
					orderCutRC = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
		sqlCutRC = sqlCutRC + whereCutRC + orderCutRC;	
		//out.println("<BR>sqlCutRC="+sqlCutRC); 		 
        ResultSet rsCutRC=stateCutRC.executeQuery(sqlCutRC);
		//out.println("sqlCutRC="+sqlCutRC);       		
	    ResultSetMetaData md=rsCutRC.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='left' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>項次</TD>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
		  if (i==6)
		  {
		     if (woType.equals("2")) // 前段工令再多帶一切割流程卡號
		     {
		      //out.println("<TD nowrap><FONT COLOR=BLUE><strong>切割流程卡號"+"</strong></TD>");
			     out.println("<TD nowrap><FONT COLOR=BROWN>剩餘數"+"</TD>");
			     out.println("<TD nowrap><FONT COLOR=BLUE><strong>製成半成品號"+"</strong></TD>");
				 out.println("<TD nowrap><FONT COLOR=BROWN>可用晶片數"+"</TD>");
		     }
		  }
		 //if (i==11) out.println("<TD nowrap><FONT COLOR=BROWN>剩餘數"+"</TD>");
         colLabel[i]=md.getColumnLabel(i);
		 if (i==4) colLabel[i]="<font color=BLUE face='Georgia'><strong>"+colLabel[i]+"</strong></font>";
		 out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");
		  
        } //end of for 
        out.println("</TR>");
		String description=null;      		
        String buttonContent=null;
		String trBgColor = "";
		String GRAINQTY = null;
		int j = 0; //項次數
		float sumWOCretedQty = 0;
		float accAvailQty = 0;
		float sumWOCretedQty1 = 0;
		float accAvailQty1 = 0;
		    String cutAsbItemId = "";
			String cutAsbInvItem = "";
			String cutAsbItemDesc = "";
			String subAsbItemId = "";
			String subAsbInvItem = "";
			String subAsbItemDesc = "";
			String waferLotTmp = null; // 每次取到的Lot 給暫存
			String cutAsbInvItemTmp = null; 
			float cutterWoQty = 0; // 切割段工令產出數
        while (rsCutRC.next())
		{ 
		    String chkCutAsbFlag = "N";
			String chkSubAsbFlag = "N";		
			String IQCItemList = "IQC料號資訊<BR>"; 
			
			// 列表依廠商批號_起
			   String cutWoList = "已開前段工令<BR>";			   
			   Statement stateWOLst=con.createStatement();
		       String sqlWoLst = "select DISTINCT WO_NO||'(數量='||WO_QTY||',單耗量='||WO_UNIT_QTY||')' from YEW_WORKORDER_ALL "+
		                         " where STATUSID!='050' and WAFER_LOT_NO = '"+rsCutRC.getString("WAFERLOT")+"' "+
								//  " and INV_ITEM= '"+rsCutRC.getString("INV_ITEM")+"' "+  // 此檢驗批列表已開切割工令號(不管那去作哪一個製成品,只要用於前段工令)
								 " and WO_NO in (select EXTEND_NO from YEW_MFG_TRAVELS_ALL where PRIMARY_NO='"+rsCutRC.getString(3)+"') "+
		                         " and WORKORDER_TYPE = '2' "; // 依切割工令及廠商批號找出累計已開數量	 
		        //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		       while (rsWOLst.next()) 
			   {
			     cutWoList = cutWoList + rsWOLst.getString(1)+"<BR>";
			   }
		       rsWOLst.close();
		       stateWOLst.close();
			   if (cutWoList.equals("已開前段工令<BR>"))  cutWoList = "已開前段工令<BR>無";
			// 列表依廠商批號_迄
			
			// 列表取IQC的購買料號_起			   
			   Statement stateIQCLst=con.createStatement();
		       String sqlIQCLst = "select INV_ITEM_ID||'(料號='||INV_ITEM||')' from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL  "+
		                         " where SUPPLIER_LOT_NO = '"+rsCutRC.getString("WAFERLOT")+"' and INSPLOT_NO='"+rsCutRC.getString("WAFERIQCNO")+"' "+
								 "   and LINE_NO= '"+rsCutRC.getString("LINE_NO")+"' ";		                      
		       //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsIQCLst=stateIQCLst.executeQuery(sqlIQCLst);
		       if (rsIQCLst.next()) 
			   {
			     IQCItemList = rsIQCLst.getString(1);
			   }
		       rsIQCLst.close();
		       stateIQCLst.close();			   
			   //if (IQCItemList.equals("IQC收料料號<BR>")) IQCItemList = "已開切割工令<BR>無";
	    	// 列表取IQC的購買料號_迄 
			
				  int parentInvItemID = rsCutRC.getInt("PARENT_ITEM_ID");
	              String parentInvItem = rsCutRC.getString("PARENT_INV_ITEM");      //  回傳 REQUEST 執行狀況
	              String parentItemDesc = rsCutRC.getString("PARENT_ITEM_DESC"); 			
			
			      result=rsCutRC.getString("RESULT");
		          waferLot=rsCutRC.getString("WAFERLOT");
				  GRAINQTY=rsCutRC.getString("GRAINQTY");		
		          invItem=rsCutRC.getString("INV_ITEM");
		          itemDesc=rsCutRC.getString("INV_ITEM_DESC");	
		          waferVendor=rsCutRC.getString("SUPPLIER_SITE_NAME");
				  frontRunCard=rsCutRC.getString(5);
 		          cutterWoQty=rsCutRC.getFloat(6); //rsCutRC.getFloat("COMPLETION_QTY"); // WO RUNCARD_NO 完工數量
		          waferUom=rsCutRC.getString("UOM");
		          waferYld=rsCutRC.getString("TOTAL_YIELD");
		          waferElect=rsCutRC.getString("WF_RESIST");
		          waferIqcNo=rsCutRC.getString("WAFERIQCNO");	
		          waferKind=rsCutRC.getString("WF_TYPE_NAME");
		          itemId=rsCutRC.getString("INV_ITEM_ID");	
		          waferLineNo=rsCutRC.getString("LINE_NO");
		          waferAmp=rsCutRC.getString("WAFER_AMP");		  
				  
				 
				   // 2006/12/16 Fix By Kerwin  以 Item Where Used 的Procedure 取製成品號資訊
		         if (parentInvItemID!=0)
				 {
				    subAsbItemId = Integer.toString(parentInvItemID) ; 
			        subAsbInvItem = parentInvItem;
			        subAsbItemDesc = parentItemDesc;
			        itemId = subAsbItemId;
			        invItem = subAsbInvItem;
			        itemDesc = subAsbItemDesc;	
					chkSubAsbFlag = "Y";				 
			      } else if (parentInvItemID==0 || parentInvItem=="" || parentInvItem.equals(""))
				         {				  
				            chkSubAsbFlag = "N";		
						 }    	
						 
						 
				  // 累加切割已開工令的已開數_起
				  
		          Statement stateWOCr=con.createStatement();
		          String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                           " where STATUSID!='050' and WAFER_LOT_NO = '"+rsCutRC.getString("WAFERLOT")+"' "+
							       //"   and INV_ITEM= '"+subAsbInvItem+"' "+  // 此檢驗批以於工令檔開的累計數量
							       "   and WO_NO in (select EXTEND_NO from YEW_MFG_TRAVELS_ALL where PRIMARY_NO='"+rsCutRC.getString(3)+"')"; // "RUNCARD_NO"
		          if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('2') "; // 依切割工令及廠商批號找出累計已開數量	 
			              
		          //out.println("<BR>sqlWoCr="+sqlWoCr+"<BR>");
		          ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		          if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		          rsWOCr.close();
		          stateWOCr.close(); 	 
		          // 累加切割已開工令的已開數_迄	
				  
				 //  ******#$$$$&&&&&$$$$$$ 計算可用餘額 $$$$$$$$$$$$&&&&&&&&77 ********* //
				   accAvailQty =  cutterWoQty - sumWOCretedQty;  // 可開單剩餘數 = 切割完工(工令)數 - 累積工單開立數
				   //out.println("cutterWoQty="+cutterWoQty+"<BR>");
				   //out.println("sumWOCretedQty="+sumWOCretedQty+"<BR>");
				   //out.println("accAvailQty="+accAvailQty+"<BR>");
				 //  ******#$$$$&&&&&$$$$$$ 計算可用餘額 $$$$$$$$$$$$&&&&&&&&77 ********* //  
				 
				 defaultWoQty=Float.toString(accAvailQty); // 當成這次可開立數	
				 waferQty = Float.toString(cutterWoQty);// 把切割工令數當成此次晶粒數		 
									 
				 //抓計量單位
		         String sqla1= " select PRIMARY_UNIT_OF_MEASURE WOUOM  from apps.mtl_system_items_b "+
					           "    where Organization_id=43  and segment1= '"+invItem +"'";
	             Statement statea1=con.createStatement();
                 ResultSet rsa1=statea1.executeQuery(sqla1);
		         //out.print("sqla1="+sqla1);
    	         if (rsa1.next())
		         { 	woUom   = rsa1.getString("WOUOM");   }
	             rsa1.close();
                 statea1.close();		 
				
				 out.print("<TR BGCOLOR='"+"#D2D0AA"+"'><TD nowrap>");		
		
		         if (accAvailQty>0)  // if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示此列(資料顯示,但無法點擊帶入鈕)
	             { 
		            if ( (waferLot!=waferLotTmp && !waferLot.equals(waferLotTmp) ) || (cutAsbInvItem!=cutAsbInvItemTmp && !cutAsbInvItem.equals(cutAsbInvItemTmp)) )// 可能BOM 對到一個以上的製成品號,若是,則序號不累加
		            {
		                j++; // 項次數
		            }
		            %>
		             <INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=j%>","<%=waferLot%>","<%=invItem%>","<%=itemDesc%>","<%=waferVendor%>","<%=waferQty%>","<%=waferUom%>","<%=waferYld%>","<%=waferElect%>","<%=waferIqcNo%>","<%=waferKind%>","<%=itemId%>","<%=woUom%>","<%=waferLineNo%>","<%=accAvailQty%>","<%=woType%>","<%=frontRunCard%>","<%=chkCutAsbFlag%>","<%=chkSubAsbFlag%>","<%=waferAmp%>")'>
		            <%
		         }  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料顯示,但無法點擊帶入鈕)
		         else { 
		                 // j--; //不計入
		                out.println("<em><font color='#FF0000'>無餘額</font></em>");
			          }
		if (accAvailQty1<0)
		        out.println("<em><font color='#FF0000'>無餘額</font></em>");
		        out.print("</TD>");		
		        out.print("<TD>"+j+"</TD>");
                for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
                {
				   			
		            if (i==6) //前段工令再多帶一切割流程卡號_起
		            {
			          if (woType.equals("2")) // 前段工令再多帶一切割流程卡號
		              { 
					    if (accAvailQty<0) accAvailQty = 0;
		                // out.println("<TD nowrap><FONT COLOR=BLUE face='Georgia'><strong>"+cutterRCNo+"</strong></TD>");
						 out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
					     out.println("<TD nowrap><FONT COLOR=BLUE face='Georgia'><strong>"+subAsbInvItem+"</strong></TD>");
						 out.println("<TD nowrap><FONT>"+accAvailQty1+"</TD>");
		              }
		            } // 前段工令再多帶一切割流程卡號_迄		 
		 
		           //if (i==11) out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
                   String s=(String)rsCutRC.getString(i);
				   if (i==3)
				   {
					  s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("+'"'+cutWoList+'"'+")'>"+s+"</a></strong></font>";
				   }
				   if (i==4) s="<font color=BLUE face='Georgia'><strong>"+s+"</strong></font>";
				   else if (i==8)
				        {
						   s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+IQCItemList+'"'+")'>"+s+"</a></strong></font>";
						}
                   out.println("<TD nowrap><FONT>"+s+"</TD>");
               } //end of for
          out.println("</TR>");	
		  
	      //	 }  // end of if (accAvailQty>0) 如果剩餘可開立數 > 0才顯示列(資料也不顯示)
		  // %%%%%%%%%%%%%%%%%%%%%%
		  waferLotTmp = waferLot; // 晶片批號給暫存
		  cutAsbInvItemTmp = cutAsbInvItem; // 製成品號給暫存 
		  // %%%%%%%%%%%%%%%%%%%%%%       
        
		 
	   } // end of while
	   out.println("</TABLE>");		        			 
	   rsCutRC.close();  	
	  } // End of if (woType.equals("2"))	   	 
      stateCutRC.close();
    } //end of try
    catch (Exception e)
    {
       out.println("Exception:"+e.getMessage());
    }
  
  %>
  
 <%
     // 作完查詢刪除找ITEM WHERE USER 寫入的TEMP Table_起	         
	    PreparedStatement stmtDelTmp=con.prepareStatement("delete from APPS.YEW_BOM_IMPL_TEMP ");  			        
	           stmtDelTmp.executeUpdate();
               stmtDelTmp.close();	 
     // 作完查詢刪除找ITEM WHERE USER 寫入的TEMP Table_迄
 %>
<!--%表單參數%-->
<input type="hidden" name="WOTYPE" value="<%=woType%>">
<input type="hidden" name="ORGANIZATIONID" value="<%=organizationId%>">
<input type="hidden" name="MARKETTYPE" value="<%=marketType%>">
<input type="hidden" name="WFRESIST" value="<%=waferResist%>">
<input type="hidden" name="DICESIZE" value="<%=diceSize%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
</body>
</html>
