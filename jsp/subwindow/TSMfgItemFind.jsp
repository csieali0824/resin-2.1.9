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
 if (invItem==null || invItem.equals("")) invItem="";
 if (itemDesc==null || itemDesc.equals("")) itemDesc="";
 String organizationId=session.getAttribute("ITEM_FIND-ORGANIZATIONID").toString();
 String searchString=request.getParameter("SEARCHSTRING");
 String woUom=null,itemId=null;
 try
 {
  if (searchString==null) {
    if (invItem!=null && !invItem.equals(""))
	{
        searchString= invItem.toUpperCase(); }
	else if (itemDesc != null && !itemDesc.equals(""))
	{  searchString = itemDesc.toUpperCase(); }
    else { searchString="%"; //out.println("NULL input");
	%>
	      <script  type="text/JavaScript">
            flag=confirm("This query could take a long time. Do you wish to continue?");
            if (flag==false)  { this.window.close(); } //alert("test");}//
          </script> 
	<%   }
   
   } else {
          if (searchString!=null && !searchString.equals("")) {
              invItem= searchString.toUpperCase();
              itemDesc = "";
          } else if ((itemDesc != null && !itemDesc.equals(""))&& (itemDesc != null && !invItem.equals(""))) {
              searchString = itemDesc.toUpperCase();
          } else {
              searchString = "%";
          }
      }
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
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
function sendToMainWindow(itemId,invItem,itemDesc,woUom)
{ 
 window.opener.document.MYFORM.ITEMID.value=itemId; 
 window.opener.document.MYFORM.INVITEM.value=invItem; 
 window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
 window.opener.document.MYFORM.WOUOM.value=woUom;
 
 this.window.close();
}

</script>
<body>  
<FORM METHOD="post" ACTION="TSMfgItemFind.jsp">
  <font color="#000099">Please Input Item: <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----Item Information--------------------------------------------     
  <BR>
  <%  
      Statement statement=con.createStatement();
	  try
      {
	   if (searchString!="" && searchString!=null) 
	   {
	    String sqlCNT = "select count(SEGMENT1) from MTL_SYSTEM_ITEMS_B A  ";
	    String sql = " select A.INVENTORY_ITEM_ID, A.SEGMENT1, REPLACE(A.DESCRIPTION,'\''',' ') as DESCRIPTION, A.PRIMARY_UNIT_OF_MEASURE as WOUOM  "+
					 " from MTL_SYSTEM_ITEMS_B A" ;			 
		String where = " where A.ORGANIZATION_ID = "+organizationId+" and A.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' "+
      				 " and A.DESCRIPTION not like '%Disable%' ";
					 
		// 需要改為取特定索引 SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		if (searchString =="%" || searchString.equals("%"))			
		{  
		 where = where + " and (A.SEGMENT1 like '%') ";
		 //sql = sql + "and (a.SEGMENT1 = '%') ";   
		}
		else 
		{
		 where = where + "  and (upper(A.SEGMENT1) like '"+invItem.toUpperCase()+"%' and upper(A.DESCRIPTION) like '"+itemDesc.toUpperCase()+"%') ";
		}  
		
		sql = sql + where;
		//out.println("sql="+sql);
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='center' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#999966'><TD>&nbsp;</TD>");        
        for (int i=2;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TD nowrap><font color='#FFFFFF'>"+colLabel[i]+"</font></TD>");
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {
		 itemId=rs.getString("INVENTORY_ITEM_ID");	 
		 invItem=rs.getString("SEGMENT1");      // "SEGMENT1"
		 itemDesc=rs.getString("DESCRIPTION");	// "DESCRIPTION"
		 woUom=rs.getString("WOUOM");		    // "WOUOM"
 
		buttonContent="this.value=sendToMainWindow("+'"'+itemId+'"'+","+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+woUom+'"'+")";
		
		
		out.println("<TR BGCOLOR='"+"#CCCC99"+"'><TD>");
		%>
		<INPUT TYPE=button NAME='button' VALUE='<jsp:getProperty name="rPH" property="pgFetch"/>' onClick='sendToMainWindow("<%=itemId%>","<%=invItem%>","<%=itemDesc%>","<%=woUom%>")'>
		<%
		 out.println("</TD>");		
         for (int i=2;i<=colCount;i++) // 不顯示第一欄資料ITEMID, 故 for 由 2開始
         {
          String s=(String)rs.getString(i);
          out.println("<TD>"+s+"</TD>");
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
