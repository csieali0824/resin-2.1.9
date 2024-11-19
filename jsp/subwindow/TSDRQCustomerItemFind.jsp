<!--20190225 Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String customerID=request.getParameter("CUSTOMERID"); 
String itemName=request.getParameter("INVITEM");
if (itemName==null) itemName="";
String custItem = request.getParameter("CUSTITEM");  //add by Peggy 20130412
if (custItem==null) custItem=""; 
String PROGID = request.getParameter("PROGID");  //add by Peggy 20130604
if (PROGID==null) PROGID="";
String LINENO = request.getParameter("LINENO");  //add by Peggy 20130604
if (LINENO==null) LINENO="";
String INVDESC= request.getParameter("INVDESC"); //add by Peggy 20130604
if (INVDESC==null) INVDESC=""; 
String tscItemID="";
%>
<html>
<head>
<title>Page for choose Payment Term List</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(custItemNo,custItemID,custItemType,tscItem,tscItemID,endCustItemName,tscItemDesc)
{    
	if (document.CUSTFORM.PROGID.value=="D9002" || document.CUSTFORM.PROGID.value=="D11001")
	{
		var lineno = document.CUSTFORM.LINENO.value;
		window.opener.document.MYFORM.elements["CUST_ITEM_"+lineno].value=custItemNo;
		window.opener.document.MYFORM.elements["CUST_ITEM_ID_"+lineno].value=custItemID;
		window.opener.document.MYFORM.elements["ITEM_ID_TYPE_"+lineno].value=custItemType;
		window.opener.document.MYFORM.elements["TSC_ITEM_"+lineno].value=tscItem;
		window.opener.document.MYFORM.elements["TSC_ITEM_ID_"+lineno].value=tscItemID;
		if (window.opener.document.MYFORM.SALESAREANO.value=="001")
		{
			window.opener.document.MYFORM.elements["END_CUST_ITEM_"+lineno].value=endCustItemName; //add by Peggy 20190306
		}
		window.opener.document.MYFORM.elements["TSC_ITEM_DESC_"+lineno].value=tscItemDesc;     //add by Peggy 20190307
		window.opener.document.getElementById("btnitem_"+lineno).click();
	}
	else
	{
		window.opener.document.MYFORM.CITEMDESC.value=custItemNo;
		if (window.opener.document.MYFORM.SALESAREANO.value=="001")
		{
		  	window.opener.document.MYFORM.EndCustPartNo.value=endCustItemName; //add by Peggy 20190225
		}

		//add by Peggy 20130412
		if (custItemNo!="N/A" && window.opener.document.MYFORM.INVITEM.value == null || window.opener.document.MYFORM.INVITEM.value =="")
		{
			alert(custItemNo);			
			window.opener.document.MYFORM.INVITEM.value = tscItem;
			window.opener.document.MYFORM.INVFLAG.value = "1";
			window.opener.document.MYFORM.INVITEM.focus();
		}
	}
  	this.window.close();  
}
</script>
<body>  
<FORM METHOD="post" ACTION="TSDRQCustItemInfoFind.jsp" NAME=CUSTFORM>
<INPUT TYPE="hidden" NAME="PROGID" value="<%=PROGID%>">
<BR>
<%  
	// 為顯示說明考量,將語系先設為美國
    String sql_lang = ""; 
	sql_lang="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
    PreparedStatement pstmt=con.prepareStatement(sql_lang);  
    pstmt=con.prepareStatement(sql_lang);
    pstmt.executeUpdate(); 
    pstmt.close();
	//完成存檔後回復
  
	int icnt =0;  //add by Peggy 20130412
	String custItemID=null,custItemNo=null,custItemDesc=null,custItemType=null,custItemTypeMeaning=null,invItemNo=null,endCustItemName=null; //add by Peggy 20190225
    Statement statement=con.createStatement();
	try
    { 
		CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
		cs1.setString(1,"41");
		cs1.execute();
		String sql = " select a.item_id, a.item Cust_Item, a.item_description, a.item_identifier_type Item_Type,"+
					 " decode(a.item_identifier_type, 'INT', 'Inventory Item Number','CUST','Customer Item Number',a.item_identifier_type) Type_Meaning, a.Inventory_Item  "+
 					 ",nvl(b.ATTRIBUTE1,'') END_CUSTOMER_PARTNO  "+ //add by Peggy 20190223
					 ",a.inventory_item_id"+ //add by Peggy 20130604
					 " from oe_items_v a,MTL_CUSTOMER_ITEM_XREFS b "+                														  
					 " where (to_char(a.sold_to_org_id) = '"+customerID+"' or a.sold_to_org_id is null) "+     	
					 " and a.ITEM_ID=b.CUSTOMER_ITEM_ID"+
                     " and a.INVENTORY_ITEM_ID=b.INVENTORY_ITEM_ID"+
					 " and nvl(a.cross_ref_status,'ACTIVE') <> 'INACTIVE' "+
					 " AND nvl(b.ATTRIBUTE2,'N')='N'"; //add by Peggy 20190613
		if (!itemName.equals("")) sql+= " and a.INVENTORY_ITEM ='"+itemName+"'";
		if (!custItem.equals("")) sql+= " and a.item ='" + custItem + "'"; 
		//if (!custItem.equals("")) sql+= " and '"+custItem+"' in (a.item ,b.attribute1)";  //add by Peggy 20190225
		if (!INVDESC.equals("")) sql+= " and a.item_description='"+INVDESC+"'"; //add by Peggy 20130604
		if (!custItem.equals(""))
		{
			sql = sql +" union all "+sql.replace("and a.item ="," and b.attribute1 =") + " and a.item<>b.attribute1";
		}
		//out.println(sql);
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
		for (int i=2;i<=colCount-1;i++) // 不顯示第一欄資料, 故 for 由 2開始
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
		}
		out.println("</TR>");
		
		String buttonContent=null;
		String trBgColor = "YELLOW";
	
		custItemID="0";
		custItemNo="N/A";
		custItemDesc="N/A";
		custItemType="INT";		
		custItemTypeMeaning="N/A";
		invItemNo="N/A";
		tscItemID="0"; //add by Peggy 20130604		
		endCustItemName="N/A";  //add by Peggy 20190225  
		//out.println("<input type='hidden' name='CUSTITEMID' value='"+custItemID+"' >");
		//out.println("<input type='hidden' name='CUSTITEMNO' value='"+custItemNo+"' >");
		//out.println("<input type='hidden' name='CUSTITEMDESC' value='"+custItemDesc+"' >");		 
		//out.println("<input type='hidden' name='CUSTITEMTYPE' value='"+custItemType+"' >");
		//out.println("<input type='hidden' name='CUSTITEMTYPEMEANING' value='"+custItemTypeMeaning+"' >");
		//out.println("<input type='hidden' name='INVITEMNO' value='"+invItemNo+"' >");		 
		buttonContent="this.value=sendToMainWindow("+'"'+custItemNo+'"'+","+'"'+custItemID+'"'+","+'"'+custItemType+'"'+","+'"'+tscItemID+'"'+","+'"'+endCustItemName+'"'+","+'"'+custItemDesc+'"'+")";		
		out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		out.println("' onClick='"+buttonContent+"'></TD>");	
		out.println("<TD><FONT SIZE=2>");
		%><jsp:getProperty name="rPH" property="pgAbortBefore"/><jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgSetup"/><BR><jsp:getProperty name="rPH" property="pgChoice"/><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgPart"/><%
		out.println("</TD><TD><FONT SIZE=2>"+custItemDesc+"</TD>");
		out.println("</TD><TD><FONT SIZE=2>"+custItemType+"</TD>");
		out.println("</TD><TD><FONT SIZE=2>"+custItemTypeMeaning+"</TD>");		 
		out.println("</TD><TD><FONT SIZE=2>"+invItemNo+"</TD>"); 		 
		out.println("</TD><TD><FONT SIZE=2>"+endCustItemName+"</TD>"); 	 //add by Peggy 20190225	 
		out.println("</TR>");	
	 
		while (rs.next())
		{		 
			custItemID=rs.getString(1);
			custItemNo=rs.getString(2);
			custItemDesc=rs.getString(3);
			custItemType=rs.getString(4);
			custItemTypeMeaning=rs.getString(5);
			invItemNo=rs.getString(6);
 			endCustItemName=rs.getString(7);  //add by Peggy 20190225
			if (endCustItemName==null ||endCustItemName.equals("null")) endCustItemName="";
			tscItemID=rs.getString(8);  //add by Peggy 20130604
			
			out.println("<input type='hidden' name='CUSTITEMID' value='"+custItemID+"' >");
			out.println("<input type='hidden' name='CUSTITEMNO' value='"+custItemNo+"' >");
			out.println("<input type='hidden' name='CUSTITEMDESC' value='"+custItemDesc+"' >");		 
			out.println("<input type='hidden' name='CUSTITEMTYPE' value='"+custItemType+"' >");
			out.println("<input type='hidden' name='CUSTITEMTYPEMEANING' value='"+custItemTypeMeaning+"' >");
			out.println("<input type='hidden' name='INVITEMNO' value='"+invItemNo+"' >");		 
			out.println("<input type='hidden' name='ENDCUSTITEMNAME' value='"+endCustItemName+"' >");		 
			 
			if (custItemNo==null) 
			{ 
				trBgColor = "E3E3CF"; 
			}
			else if (custItemNo==rs.getString(2) || custItemNo.equals(rs.getString(2)))				 	 
			{ 
				trBgColor = "FFCC66"; 
			}
			else 
			{ 
				trBgColor = "E3E3CF"; 
			}
			buttonContent="this.value=sendToMainWindow("+'"'+custItemNo+'"'+","+'"'+custItemID+'"'+","+'"'+custItemType+'"'+","+'"'+invItemNo+'"'+","+'"'+tscItemID+'"'+","+'"'+endCustItemName+'"'+","+'"'+custItemDesc+'"'+")";		
			out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=2;i<=colCount-1;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				out.println("<TD><FONT SIZE=2>"+s+"</TD>");
			} 
			out.println("</TR>");	
			icnt++;  //add by Peggy 20130412
		}
		out.println("</TABLE>");						
	
		rs.close();       
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
	
	if (icnt ==1)
	{
	%>
		<script LANGUAGE="JavaScript">	
			sendToMainWindow("<%=custItemNo%>","<%=custItemID%>","<%=custItemType%>","<%=invItemNo%>","<%=tscItemID%>","<%=endCustItemName%>","<%=custItemDesc%>");	
		/*
		if (document.CUSTFORM.PROGID.value!="D9002")
		{
			//add by Peggy 20130412
			if (window.opener.document.MYFORM.INVITEM.value == null || window.opener.document.MYFORM.INVITEM.value =="")
			{
				window.opener.document.MYFORM.CITEMDESC.value=document.CUSTFORM.CUSTITEMNO.value;
				window.opener.document.MYFORM.INVITEM.value = document.CUSTFORM.INVITEMNO.value;
				window.opener.document.MYFORM.INVFLAG.value = "1";
				window.opener.document.MYFORM.INVITEM.focus();
				this.window.close(); 
			}
		}
		*/
		</script>
	<%
	}
%>
<BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="CUSTOMERID" SIZE=10 value="<%=customerID%>" >
<INPUT TYPE="hidden" NAME="ITEMNAME" SIZE=10 value="<%=itemName%>" >
<INPUT TYPE="hidden" NAME="CUSTITEM" SIZE=10 value="<%=custItem%>" >
<INPUT TYPE="hidden" NAME="LINENO" value="<%=LINENO%>">
<INPUT TYPE="hidden" NAME="INVDESC" value="<%=INVDESC%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->

<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
