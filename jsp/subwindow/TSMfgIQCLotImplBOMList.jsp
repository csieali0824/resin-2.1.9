<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 

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
}
</script>
<body > 
<FORM METHOD="post" ACTION="TSMfgIQCLotImplBOMList.jsp">   
<%

 String woType=request.getParameter("WOTYPE"); 
 String marketType=request.getParameter("MARTETTYPE"); 
 String organizationId = request.getParameter("ORGANIZATIONID");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 
 String waferResist=request.getParameter("WFRESIST"); 
 String diceSize=request.getParameter("DICESIZE");
 String lotNo=request.getParameter("LOT"); 
 
 String searchString=request.getParameter("SEARCHSTRING");
 
 String supplierLot=request.getParameter("SUPPLIERLOT"); 
 
 //if (supplierLot==null || supplierLot.equals("") || supplierLot.equals("undefined")) supplierLot = "";
 
  
 //out.println("lotNo="+lotNo);
 
 if (woType==null || woType.equals("")) woType="1";
 
 String runCardDesc = null; // ItemDesc
 String runCardGet = "";  // itemCodeGet
 int runCardGetLength = 0;   // itemCodeGetLength
 
 
%>
  <input type="hidden" name="SEARCHSTRING" size=30 value=<%=searchString%> >
  </font> 
  <BR>
  <font size="-1" color="#000099">-----Wafer Inspection Lot BOM List-------------------------------------------</font>     
  <BR>  
  <span class="style1">IQC晶片(粒)批號 原料展BOM表明細</span><BR>
  <%  
   
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	          
		  String sql = "";
		  String where= "";
		  String order = "";
	      
		         //  **** 2006/12/30 先將暫時查詢檔寫入
		         //sqlCNT = "select count(IQCH.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD,ORADDMAN.TSCIQC_WAFER_TYPE IQCWT  ";
	             sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY ICQ收料數量, IQCD.INV_ITEM, IQCD.INV_ITEM_ID, REPLACE(IQCD.INV_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC,IQCH.INSPLOT_NO as WAFERIQCNO , "+
		                     "           IQCH.SUPPLIER_SITE_NAME,decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME,IQCH.WF_RESIST , "+
	   				         "           IQCD.UOM, IQCD.INV_ITEM_ID,IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                         " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, "+
			                 "      ORADDMAN.TSCIQC_WAFER_TYPE IQCWT ";
	      	     where=" where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                      "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 加入已經驗收入庫或經特採入庫的檢驗批							  
							  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "+ // Clone 後PO方有存在
							  "   and IQCD.ORGANIZATION_ID = '"+organizationId+"' "+
		                      "   and ( IQCD.SUPPLIER_LOT_NO= '"+lotNo+"' or IQCD.SUPPLIER_LOT_NO like '%"+lotNo+"%' ) ";
		         order = "order by IQCD.INV_ITEM, INSPECT_DATE, WAFERLOT ";		
				 
				 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) 
				 {
				   where = where + " ";
				 }
		
				     sql = sql + where + order;	
			         //out.println(sql);
					 int pp = 0; 
					 
					 out.println("<table cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='center' borderColorLight='#ffffff' border='0'>");
					 out.println("<tr><td>項次</td><td>晶片檢驗批號</td><td>收料料號</td><td>料號說明</td></tr>");
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sql);				   
				     while (rsPrev.next())
					 {	
					     pp++;
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
	                     // out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	                     csBOMInfo.close(); 						 
						 
						 out.println("<tr><td>"+pp+"</td><td>"+rsPrev.getString("WAFERLOT")+"</td><td>"+rsPrev.getString("INV_ITEM")+"</td><td>"+rsPrev.getString("INV_ITEM_DESC")+"</td></tr>");
						 
					 }
					 rsPrev.close();
					 statePrev.close();
					 out.println("</table><BR>");
					 
					// ******** Step2. 再組合一次SQL取被展開ITEM Where Used 的清單
					sql = " select DISTINCT CURRENT_LEVEL as 階層, decode(YBI.ORGANIZATION_ID,'326','內銷','327','外銷') as 內外銷,  "+
					        "               PARENT_ITEM_ID as 各階識別碼, PARENT_INV_ITEM as 各階料號, PARENT_ITEM_DESC as 各階規格說明 "+
					       // "               IQC_INV_ITEM as INV_ITEM, IQC_ITEM_ID, MSI.DESCRIPTION as INV_ITEM_DESC "+														 	
							"   from YEW_BOM_IMPL_TMP YBI, MTL_SYSTEM_ITEMS MSI ";
					where =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+	
					        "    and YBI.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+	
							"    and YBI.IQC_ITEM_ID = MSI.INVENTORY_ITEM_ID "+														 
							"    and YBI.QUERY_TYPE = 'FAKE'  "+  
							"    and ( substr(YBI.PARENT_INV_ITEM,1,3) in ('10-','11-','1A-') or length(YBI.PARENT_INV_ITEM) = 13 or length(YBI.PARENT_INV_ITEM) = 22 )  "+
							"    and ( IQC_WAFER_LOT= '"+lotNo+"' or IQC_WAFER_LOT like '%"+lotNo+"%' ) ";  
					order = "order by 1  ";
		         

		            // 需要改為取特定索引 SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  /			           				 
	  	
		sql = sql + where + order;
        //out.println("sql="+sql); 		 
        ResultSet rs=statement.executeQuery(sql);		  
		int j=0; 		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='center' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#CCCC99'>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {		  
         colLabel[i]=md.getColumnLabel(i);
		 out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");		  
        } //end of for 
        out.println("</TR>");
		String description=null;      		
        String buttonContent=null;
		String trBgColor = "";	 		  
        while (rs.next())
        {  
			j++; // 
			
				
			// 取 Item Where Use的 Procedure_迄 
		
		     //buttonContent="this.value=sendToMainWindow("+'"'+waferLot+'"'+","+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+waferVendor+'"'+","+'"'+waferQty+'"'+","+'"'+waferUom+'"'+","+'"'+waferYld+'"'+","+'"'+waferElect+'"'+","+'"'+waferIqcNo+'"'+","+'"'+waferKind+'"'+","+'"'+itemId+'"'+","+'"'+woUom+'"'+","+'"'+waferLineNo+'"'+")";
 	          out.println("<TR bgcolor='#CCCC99'>");	 
               for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
               {		   
                 String s=(String)rs.getString(i);		   
                 out.println("<TD nowrap><FONT>"+s+"</TD>");// 列印各欄位資料
               } //end of for
           out.println("</TR>");	 
	     
        } //end of while
        out.println("</TABLE>");		
        rs.close(); 
	   
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
	         //delete from APPS.YEW_BOM_IMPL_TMP where to_char(IMPLOSION_DATE,'YYYYMMDDHH24MI') ='"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+"'
	          PreparedStatement stmtDelTmp=con.prepareStatement("delete from APPS.YEW_BOM_IMPL_TMP ");          
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
