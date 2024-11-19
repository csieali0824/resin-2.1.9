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
 String parOrgID = "";

  try
  {
     Statement stateORG=con.createStatement();	 
     ResultSet rsORG=stateORG.executeQuery("select PAR_ORG_ID, ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE = 'MARKETTYPE' and CODE ='"+marketType+"' ");
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
function sendToMainWindow(jNo,runCardNo,itemId,invItem,itemDesc,woQty, finalInvItemID, finalInvItem, finalItemDesc)
{
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
<FORM METHOD="post" ACTION="TSMfgMoFind.jsp">
  <font color="#000099">請輸入開立工令之半成品料號: <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
   <font color="#000099">-----已完工前段工令半成品號--------------------------------------------</font> 
  <BR>
  <%  
      Statement statement=con.createStatement();
	  try
      { 
  	      CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
  	      cs1.setString(1,parOrgID); // By Choose market Set Client info
	      cs1.execute();	 
	 // 組合MO單下的成品料號對應出半成品料號,作為找前段流程卡依據_起	 
	 String semiItemDesc = null;
     String semiItemCodeGet = "";
     int semiItemCodeGetLength = 0;   
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
			 
            // 取當月條件內的機種成品料號 //
            if (itemCodeGet.length()>0)
            {   out.println(itemCodeGet);     
             itemCodeGetLength = itemCodeGet.length()-1;
             itemCodeGet = itemCodeGet.substring(0,itemCodeGetLength);
            } 
			      
		  // 取BOM_COMPONENT 內動應的半成品料號_起			 
		  if (itemCodeGet!=null && !itemCodeGet.equals(""))			 
		  {
			 Statement stateBC=con.createStatement(); 
             ResultSet rsBC=stateBC.executeQuery(" select  /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */  COMPONENT_ITEM_ID "+
			                                     " from bom_components_b a, BOM_STRUCTURES_B b "+
												 " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and b.ASSEMBLY_ITEM_ID in ("+itemCodeGet+") ");
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
	   String where = "";
	   String orderby = "";
	   if (searchString!="" && searchString!=null) 
	   {  	 

		 sql =   " select DISTINCT a.INVENTORY_ITEM_ID as 半成品識別碼, b.SEGMENT1 as 半成品品號, b.DESCRIPTION as 品號規格說明   "+
		         "   from MTL_LOT_NUMBERS a, MTL_SYSTEM_ITEMS b ";
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
		   where = where + "and ( a.LOT_NUMBER = '"+runCardNo+"' or b.SEGMENT1 like '%"+runCardNo+"%' or b.DESCRIPTION like '%"+runCardNo+"%' )  "; 		
		} 	
		sql = sql + where + orderby;	
		out.println("sql="+sql); 		 
        ResultSet rs=statement.executeQuery(sql);

	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];           
		out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='50%' align='left' borderColorLight='#ffffff' border='0'>");          
		out.println("<TR BGCOLOR='#CCCC99'><TD><FONT>&nbsp;</TD><TD><FONT COLOR=BROWN>項次</TD>"); 

        for (int i=1;i<=colCount;i++) // 不顯示第一,二欄資料ITEMID, 故 for 由 2開始
        {
          colLabel[i]=md.getColumnLabel(i);		
          out.println("<TD><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");		
        }
		out.println("<TD><FONT COLOR=BROWN>舊系統庫存批(是/否)"+"</TD>");
        out.println("</TR>");
      		
        String buttonContent=null;
		String trBgColor = "";
		int j = 0; //項次數
        while (rs.next())
        { 		 
		 runCardNo  = "";
		 runCardQty = "0";
		 itemId     = rs.getString(1);	
		 invItem    = rs.getString(2);
		 itemDesc   = rs.getString(3);		
		 woQty      = runCardQty ;			 
		 	 
		 String finalInvItemID = "";
		 String finalInvItem = "";
		 String finalItemDesc = "";

		 if (runCardNo!=null && !runCardNo.equals("")) // 若輸入前段流程卡號查詢
	     {	   
	      String organizationID = "";
          Statement stateItemDesc=con.createStatement(); 
          ResultSet rsItemDesc=stateItemDesc.executeQuery("select  /* + ORDERED index(a BOM_COMPONENTS_B_N2)  */ "+    // 
		                                                   "      b.ASSEMBLY_ITEM_ID, c.ORGANIZATION_ID "+
		                                                   " from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, YEW_RUNCARD_ALL c "+
		                                                   " where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and COMPONENT_ITEM_ID=c.PRIMARY_ITEM_ID "+
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
          ResultSet rsRC=stateRC.executeQuery("select RUNCARD_NO from YEW_RUNCARD_ALL where INV_ITEM = '"+rs.getString(2)+"' ");	 
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
		 out.print("<TD>"+j+"</TD>");		
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
         {
           String s=(String)rs.getString(i);
		   out.println("<TD><FONT>"+s+"</TD>");
         }
		 out.println("<TD><FONT>"+wipCreateLot+"</TD>");
         out.println("</TR>");	
        }
        out.println("</TABLE>");						
        rs.close();       
	   }
      }
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
