<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
 String invItem=request.getParameter("INVITEM");
 String itemDesc=request.getParameter("ITEMDESC");
 String sampleOrdCh=request.getParameter("SAMPLEORDCH");
 String searchString=request.getParameter("SEARCHSTRING");
 
 
 try
 {
   if (searchString==null)
   {
    if (invItem!=null && !invItem.equals(""))
	{ searchString= invItem.toUpperCase(); }
	else if (itemDesc != null && !itemDesc.equals(""))
	{  searchString = itemDesc.toUpperCase(); }
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
	//out.println("invItem="+invItem+"<BR>");
	//out.println("itemDesc="+itemDesc+"<BR>");
	//out.println("searchString="+searchString+"<BR>");
   }
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose TSC Item or Item Description to add to Sales DRQ Item List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(invItem,itemDesc,sPQP,MOQP)
{   
 window.opener.document.MYFORM.INVITEM.value=invItem; 
 window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
 window.opener.document.MYFORM.SPQP.value=sPQP;
 window.opener.document.MYFORM.MOQP.value=MOQP; 
                if (window.opener.document.MYFORM.ORDERQTY.value==null || window.opener.document.MYFORM.ORDERQTY.value=="")
				{ 
				 window.opener.document.MYFORM.ORDERQTY.focus();
				}
				else {
				       window.opener.document.MYFORM.REQUESTDATE.focus();   
				      }		
 this.window.close();
}

</script>
<body onBlur="this.focus();">  
<FORM METHOD="post" ACTION="TSMfgItemPackageFind.jsp" name=ITEMFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
  <%  
      int queryCount = 0, querySPQCount = 0;
      Statement statement=con.createStatement();
	  try
      { 
	   if (searchString!="" && searchString!=null) 
	   {  	   
	    String sqlCNT = "select /*+ ORDERED index(b MTL_ITEM_CATEGORIES_N1)  */ count(a.SEGMENT1) from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b, APPS.MTL_ITEM_CATEGORIES_V c ";
	    String sql = "select /*+ ORDERED index(b MTL_ITEM_CATEGORIES_N1)  */ a.SEGMENT1, a.DESCRIPTION, b.SEGMENT1 as TSC_PACKAGE, c.SEGMENT1 AS TSC_FAMILY "+
		             //"       b.CATEGORY_SET_NAME as PACKAGE_CATEGORY_SET, c.CATEGORY_SET_NAME as FAMILY_CATEGORY_SET   "+
		             "  from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b, APPS.MTL_ITEM_CATEGORIES_V c ";
		             //"where a.ORGANIZATION_ID = b.ORGANIZATION_ID and a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
					 //"and a.ORGANIZATION_ID = '49' and CATEGORY_SET_ID=23 "; // 取 TSC_Package 的分類
		String where="where a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
		             "  and a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
					 "  and b.CATEGORY_SET_ID = 23 "+
					 "  and a.ORGANIZATION_ID = c.ORGANIZATION_ID "+
		             "  and a.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
					 "  and c.CATEGORY_SET_ID = 21 "+
					 "  and a.ORGANIZATION_ID = '49' "+
					 "  and a.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' "+
					 "  and a.DESCRIPTION not like '%Disable%' "; //// 取 TSC_Package 及 TSC_Family 的分類, 且不包含已被設定為 Disable的料項
		if (searchString=="%" || searchString.equals("%"))			
		{  
		 where = where + "and (a.SEGMENT1 = '%') ";
		 //sql = sql + "and (a.SEGMENT1 = '%') "; 
		}
		else 
		{ 
		 where = where + "and (upper(a.SEGMENT1) like '"+searchString.toUpperCase()+"%' or upper(DESCRIPTION) like '"+searchString.toUpperCase()+"%') ";
		 //sql = sql + "and (a.SEGMENT1 like '"+searchString.toUpperCase()+"%' or DESCRIPTION like '"+searchString.toUpperCase()+"%') "; 
		}    
		
		Statement stateCNT=con.createStatement();
		sqlCNT=sqlCNT+where;
		ResultSet rsCNT = stateCNT.executeQuery(sqlCNT);
		if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		rsCNT.close();
		stateCNT.close();
		
		if (queryCount==0) //若取到的查詢數 == 0 ,若找不到半筆,則可能是無設定於包裝Category內(賣零散無包裝產品),那麼,就檢核料件主檔即可
	    {
		  sql = "select a.SEGMENT1, a.DESCRIPTION, 'NO PACKAGE' as TSC_PACKAGE, 'NO FAMILY' as TSC_FAMILY "+
		        //" 'NO Package Category' as PACKAGE_CATEGORY_SET, 'NO Family Category' as FAMILY_CATEGORY_SET "+
		        "  from APPS.MTL_SYSTEM_ITEMS a ";
	      where=" where a.ORGANIZATION_ID = '49' and a.DESCRIPTION not like '%Disable%' and a.DESCRIPTION not like '%disable%' ";
		  if (searchString=="%" || searchString.equals("%"))			
		  {  
		   where = where + "and (a.SEGMENT1 = '%') ";		   
		  }
		  else 
		  { 
		   where = where + "and (upper(a.SEGMENT1) like '"+searchString.toUpperCase()+"%' or upper(DESCRIPTION) like '"+searchString.toUpperCase()+"%') ";		   
		  }    
		}  // End of if (queryCount==0)
		
		sql = sql + where;
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];   
		    
        out.println("<TABLE>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++)
        {    
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 		    
		
		if (sampleOrdCh ==null || sampleOrdCh.equals("false"))
		{ // 未選定為樣品訂單,則以 MOQ 為限定值回傳
		 out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+"SPQP (KPC)"+"</TH>"); // 最後一欄帶入訂購最小包裝量
		} else if (sampleOrdCh.equals("true")) 
		       {
			     out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+"SPQP (KPC)"+"</TH>"); // 最後一欄帶入訂購最小包裝量
			   }    
		out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+"MOQP (KPC)"+"</TH>"); // 最小包裝量		
        out.println("</TR>");
		//String packingCategoryName=null,tscPacking=null,familyCategoryName=null,tscFamily=null,sPQP=null;
		String tscPacking=null,tscFamily=null,sPQP=null,sMOP=null;
      		
        String buttonContent=null;		
        while (rs.next())
        {
		 invItem=rs.getString("SEGMENT1");
		 itemDesc=rs.getString("DESCRIPTION");
		 //packingCategoryName=rs.getString("PACKAGE_CATEGORY_SET");
		 tscPacking=rs.getString("TSC_PACKAGE");	
		 //familyCategoryName=rs.getString("FAMILY_CATEGORY_SET");
		 tscFamily=rs.getString("TSC_FAMILY");			 
		 String packMethodCode = itemDesc.substring(itemDesc.length()-2,itemDesc.length());		// 業務單位給定料號說明編碼 最後兩碼為Package Code之原則
		 out.println("<input type='hidden' name='INVITEM' value='"+invItem+"' >");
		 out.println("<input type='hidden' name='ITEMDESC' value='"+itemDesc+"' >");
		 
		 //out.println("select REEL from ORADDMAN.TSITEM_PACKING_CATE where trim(OUTLINE)='"+category.trim()+"' and trim(PACKAGE_CODE)='"+packMethodCode.trim()+"' ");		
		 // 取料件對應的包裝方式檔及其最小包裝量檔內容

		Statement stateSPQCNT=con.createStatement();
		ResultSet rsSPQCNT = stateSPQCNT.executeQuery("select count(SPQ) from ORADDMAN.TSITEM_PACKING_CATE a "+
		                                               " where trim(a.TSC_OUTLINE)='"+tscPacking.trim()+"' "+
												       "   and trim(a.PACKAGE_CODE)='"+packMethodCode.trim()+"' "+
													   "   and trim(a.TSC_FAMILY) is not null "+
													   "   and trim(a.TSC_FAMILY)='"+tscFamily.trim()+"' "+ // 2006/05/30 加入找最新MOQ/SPQ 檔版本條件
													   "   and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b " +
					                                                             " where b.TSC_OUTLINE = a.TSC_OUTLINE "+        
											                                     "   and b.PACKAGE_CODE = a.PACKAGE_CODE "+
											                                     "   and b.TSC_FAMILY = a.TSC_FAMILY ) "); 	
		if (rsSPQCNT.next()) querySPQCount = rsSPQCNT.getInt(1);
		rsSPQCNT.close();
		stateSPQCNT.close();		
		String sqlSPQ= "";
		
		if (querySPQCount!=0)      
		   {   
            sqlSPQ = "select (SPQ / 1000) SPQ, (MOQ / 1000) MOQ from ORADDMAN.TSITEM_PACKING_CATE a "+
		             " where trim(a.TSC_OUTLINE)='"+tscPacking.trim()+"' "+
					 "   and trim(a.PACKAGE_CODE)='"+packMethodCode.trim()+"' "+
					 "   and trim(a.TSC_FAMILY) is not null "+
					 "   and trim(a.TSC_FAMILY)='"+tscFamily.trim()+"' "+  // 2006/05/30 加入找最新MOQ/SPQ 檔版本條件
					 "   and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b " +
					                           " where b.TSC_OUTLINE = a.TSC_OUTLINE "+        
											   "   and b.PACKAGE_CODE = a.PACKAGE_CODE "+
											   "   and b.TSC_FAMILY = a.TSC_FAMILY ) ";
			} else {
            sqlSPQ = "select (SPQ / 1000) SPQ, (MOQ / 1000) MOQ from ORADDMAN.TSITEM_PACKING_CATE a "+
		             " where trim(a.TSC_OUTLINE)='"+tscPacking.trim()+"' "+
					 "   and trim(a.PACKAGE_CODE)='"+packMethodCode.trim()+"' "+
					 "   and trim(a.TSC_FAMILY) is null "+  // 2006/05/30 加入找最新MOQ/SPQ 檔版本條件
					 "   and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b " +
					                           " where b.TSC_OUTLINE = a.TSC_OUTLINE "+        
											   "   and b.PACKAGE_CODE = a.PACKAGE_CODE "+
											   "   and b.TSC_FAMILY = a.TSC_FAMILY ) ";
					 /*
					 "   and trim(TSC_FAMILY) not in (select TSC_FAMILY from ORADDMAN.TSITEM_PACKING_CATE "+
					 "                                 where trim(TSC_OUTLINE)='"+tscPacking.trim()+"' "+
					 "                                   and trim(PACKAGE_CODE)='"+packMethodCode.trim()+"' "+
					 "                                   and trim(TSC_FAMILY) is not null) "; */
	        } 	
            
            //out.println("<BR>sqlSPQ="+sqlSPQ);		 
		    Statement stateSPQP=con.createStatement();
		    ResultSet rsSPQP=stateSPQP.executeQuery(sqlSPQ); 														
												 
		 if (rsSPQP.next())
		 {
		   sPQP = rsSPQP.getString("SPQ");
		   sMOP = rsSPQP.getString("MOQ");
		   
		  
		   if (sampleOrdCh==null || sampleOrdCh.equals("false"))
		   { // 未選定為樣品訂單,則以 MOQ 為限定值回傳
		       out.println("<input type=hidden name='SPQP' value='"+sPQP+"' >");
		       out.println("<input type=hidden name='MOQ' value='"+sMOP+"' >");
			   
			   buttonContent="this.value=sendToMainWindow("+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+sMOP+'"'+","+'"'+sPQP+'"'+")";		
		   }
		   else if (sampleOrdCh.equals("true"))
		         { // 若選定為樣品訂單    
				   out.println("<input type=hidden name='SPQP' value='"+sPQP+"' >");
		           out.println("<input type=hidden name='MOQ' value='"+sMOP+"' >");   
				   
				   buttonContent="this.value=sendToMainWindow("+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+sPQP+'"'+","+'"'+sMOP+'"'+")";		     
		         }
		   
		   //out.println("<input type=hidden name='SPQP' value='"+sPQP+"' >");
		   //out.println("<input type=hidden name='MOQ' value='"+sMOP+"' >");			   
		      
		 } else {
		         sPQP = "0"; sMOP = "0";
				 buttonContent="this.value=sendToMainWindow("+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+sPQP+'"'+","+'"'+sMOP+'"'+")";		
				} // 找不到則設定mOQP = 0
		 rsSPQP.close();
		 stateSPQP.close();		 
		 
         out.println("<TR BGCOLOR=E3E3CF><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 out.println("' onClick='"+buttonContent+"'></TD>");		
         for (int i=1;i<=colCount;i++)
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");		 
         } //end of for
		   if (sampleOrdCh==null || sampleOrdCh.equals("false"))
		   { // 未選定為樣品訂單,則以 MOQ 為限定值回傳
		       out.println("<TD><FONT SIZE=2>"+sPQP+"</TD>");  // 最後一欄帶入訂購最小包裝量 
			   out.println("<TD><FONT SIZE=2>"+sMOP+"</TD>");  // 最後一欄帶入訂購最小包裝量     
		   }
		   else if (sampleOrdCh.equals("true"))
		         { // 若選定為樣品訂單    
				    out.println("<TD><FONT SIZE=2>"+sPQP+"</TD>");  // 最後一欄帶入訂購最小包裝量 
					out.println("<TD><FONT SIZE=2>"+sMOP+"</TD>");  // 最後一欄帶入訂購最小包裝量     
		         }
		 //out.println("<TD><FONT SIZE=2>"+sPQP+"</TD>");  // 最後一欄帶入訂購最小包裝量		 
		 //out.println("<TD><FONT SIZE=2>"+sMOP+"</TD>");  // 最後一欄帶入訂購最小包裝量		 
         out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	   }//end of while
	   // out.println("queryCount="+queryCount);
	   
	   if (queryCount==1) //若取到的查詢數 == 1
	   {  //out.println("queryCount="+queryCount);
	       if (sampleOrdCh==null || sampleOrdCh.equals("false"))
		   { // 未選定為樣品訂單,則以 MOQ 為限定值回傳
	       %>
		    <script LANGUAGE="JavaScript">	
			  //alert("TEST");			   	   
				window.opener.document.MYFORM.INVITEM.value= document.ITEMFORM.INVITEM.value;			  
				window.opener.document.MYFORM.ITEMDESC.value= document.ITEMFORM.ITEMDESC.value; 			 	
				window.opener.document.MYFORM.SPQP.value= document.ITEMFORM.MOQ.value;  
				window.opener.document.MYFORM.MOQP.value= document.ITEMFORM.SPQP.value; 
				if (window.opener.document.MYFORM.ORDERQTY.value==null || window.opener.document.MYFORM.ORDERQTY.value=="")
				{ 
				 window.opener.document.MYFORM.ORDERQTY.focus();
				}
				else {
				       window.opener.document.MYFORM.REQUESTDATE.focus();   
				      }			   	
				//this.window.close(); 			  	
            </script>
		   <%
		 } else if (sampleOrdCh.equals("true"))
		           { // 若選定為樣品訂單   
				        %>
		                 <script LANGUAGE="JavaScript">	
			             //alert("TEST");			   	   
				         window.opener.document.MYFORM.INVITEM.value= document.ITEMFORM.INVITEM.value;			  
				         window.opener.document.MYFORM.ITEMDESC.value= document.ITEMFORM.ITEMDESC.value; 			 	
				         window.opener.document.MYFORM.SPQP.value= document.ITEMFORM.SPQP.value;  
				         window.opener.document.MYFORM.MOQP.value= document.ITEMFORM.MOQ.value; 
				         if (window.opener.document.MYFORM.ORDERQTY.value==null || window.opener.document.MYFORM.ORDERQTY.value=="")
				         { 
				          window.opener.document.MYFORM.ORDERQTY.focus();
				         }
				         else {
				                window.opener.document.MYFORM.REQUESTDATE.focus();   
				               }			   	
				         this.window.close(); 			  	
                         </script>
		               <%
				   }  // End of 
		 
		     
	   }
	   
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
	  statement.close();
     %>
  <BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
