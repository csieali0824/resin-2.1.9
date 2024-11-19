<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
 String primaryFlag=request.getParameter("PRIMARYFLAG");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 String searchString=request.getParameter("SEARCHSTRING");
 String woUom=null,tscPackage=null,tscFamily=null,tscAmp=null,tscPacking=null,itemId=null;
  
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
</head>
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
function sendToMainWindow(itemId,invItem,itemDesc,woUom,tscPackage,tscFamily,tscAmp,tscPacking)
{ 
 window.opener.document.MYFORM.ITEMID.value=itemId; 
 window.opener.document.MYFORM.INVITEM.value=invItem; 
 window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
 window.opener.document.MYFORM.WOUOM.value=woUom;
 window.opener.document.MYFORM.TSCPACKAGE.value=tscPackage; 
 window.opener.document.MYFORM.TSCFAMILY.value=tscFamily; 
 window.opener.document.MYFORM.TSCAMP.value=tscAmp;
 window.opener.document.MYFORM.TSCPACKING.value=tscPacking; 
 
 this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSMfgItemFind.jsp">
  <font size="-1">Please Input Item: <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgPaymentTerm"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
  <%  
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	    
	    String sqlCNT = "select count(IQCH.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD,ORADDMAN.TSCIQC_WAFER_TYPE IQCWT  ";
	    String sql = " select A.INVENTORY_ITEM_ID,A.SEGMENT1, A.DESCRIPTION,A.PRIMARY_UNIT_OF_MEASURE WOUOM,B.SEGMENT1 TSC_PACKAGE, "+
	   				 "     C.SEGMENT1 as TSC_FAMILY,D.SEGMENT1 as TSC_AMP,SUBSTR(A.DESCRIPTION,-2,2) TSC_PACKING "+
  					 " from APPS.MTL_SYSTEM_ITEMS_B A,APPS.MTL_ITEM_CATEGORIES_V B, "+
     				 "  APPS.MTL_ITEM_CATEGORIES_V C,APPS.MTL_ITEM_CATEGORIES_V D ";			 
		String where ="  where A.ORGANIZATION_ID = B.ORGANIZATION_ID   and A.INVENTORY_ITEM_ID = B.INVENTORY_ITEM_ID "+
      				 " and A.ORGANIZATION_ID = D.ORGANIZATION_ID  and A.ORGANIZATION_ID = C.ORGANIZATION_ID "+
	  				 " and A.INVENTORY_ITEM_ID = C.INVENTORY_ITEM_ID  and A.INVENTORY_ITEM_ID = D.INVENTORY_ITEM_ID "+
  	  				 " and B.CATEGORY_SET_ID = 23   and C.CATEGORY_SET_ID = 21  and D.CATEGORY_SET_ID = 17    "+
      				 " and A.ORGANIZATION_ID = '49' and A.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' "+
      				 " and A.DESCRIPTION not like '%Disable%' ";
					 
		// 需要改為取特定索引 SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		if (searchString =="%" || searchString.equals("%"))			
		{  
		 where = where + " and (A.SEGMENT1 = '%') ";
		 //sql = sql + "and (a.SEGMENT1 = '%') ";   
		}
		else 
		{ 
		 where = where + "  and (upper(A.SEGMENT1) like '"+invItem.toUpperCase()+"%' and upper(A.DESCRIPTION) like '"+itemDesc.toUpperCase()+"%') ";
		}  
		
		sql = sql + where;	
		//out.println("sql="+sql); 		 
        ResultSet rs=statement.executeQuery(sql);
		out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE borderColorLight='#ffffff'>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=2;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BULE><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {
		 itemId=rs.getString("INVENTORY_ITEM_ID");
		 invItem=rs.getString("SEGMENT1");
		 itemDesc=rs.getString("DESCRIPTION");	
		 woUom=rs.getString("WOUOM");		 
		 tscPackage=rs.getString("TSC_PACKAGE");
 		 tscFamily=rs.getString("TSC_FAMILY");
		 tscAmp=rs.getString("TSC_AMP");
		 tscPacking=rs.getString("TSC_PACKING");
 
		buttonContent="this.value=sendToMainWindow("+'"'+itemId+'"'+","+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+woUom+'"'+","+'"'+tscPackage+'"'+","+'"'+tscFamily+'"'+","+'"'+tscAmp+'"'+","+'"'+tscPacking+'"'+")";
		
		
		out.println("<TR BGCOLOR='"+"#CCFFDD"+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		
		 out.println("' onClick='"+buttonContent+"'></TD>");		
         for (int i=2;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
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
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >

</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
