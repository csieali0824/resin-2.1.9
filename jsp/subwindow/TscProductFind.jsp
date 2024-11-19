<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<!--=============???????????==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
 
<%
	String primaryFlag=request.getParameter(java.net.URLDecoder.decode("PRIMARYFLAG"));
	// java.net.URLDecoder.decode(PRIMARYFLAG)
	String line_no=request.getParameter("line_no");
	String inventory_Item_ID=request.getParameter("inventory_Item_ID");
	String customerPO=request.getParameter("customerPO");
	String keyID=request.getParameter("ID");
	String keyCode=request.getParameter("KEYCODE");
	String searchString=request.getParameter("SEARCHSTRING");
	String customerNumber=request.getParameter("CUSTOMERNUMBER");
  	String sourcePage=request.getParameter("sourcepg");
	if (sourcePage == null) sourcePage = "";
	String ITEMDESC = request.getParameter("ITEMDESC"); //add by Peggy 20120924
	if (ITEMDESC == null) ITEMDESC ="";
	String CARTON=request.getParameter("CARTON");    //add by Peggy 20210225
	if (CARTON==null) CARTON="";
	String INVOICE=request.getParameter("INVOICE");  //add by Peggy 20210225
	if (INVOICE==null) INVOICE="";
	String ship_itemid="0";       //add by Peggy 20210225
	
	String url_page = "";
	if (sourcePage.equals("D1010"))
	{
		url_page  = "../jsp/Tsc1211SpecialCustConfirm.jsp";
	}
	else 
	{
		url_page = "../jsp/Tsc1211ConfirmDetailList.jsp";
	}

	String p_Item = "";
	String p_Item_ID = "";
	String p_Item_Description = "";
	String p_Inventory_Item_ID = "";
	String p_Inventory_Item = "";
	String p_Item_Identifier = "";
	String p_Sold_To_Org_ID = "";
	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	//cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
	cs1.execute();
	//out.println("Procedure : Execute Success !!! ");
	cs1.close();
	
	//String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	//PreparedStatement pstmt=con.prepareStatement(sql1);
	//pstmt.executeUpdate(); 
	//pstmt.close();		
%>
<html>
<head>
<title>Page for choose Product List</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
	window.opener.document.MYFORM.action=URL;
	window.opener.document.MYFORM.submit(); 
 	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form1">
<TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Item Number Select :</strong></font></TD>
<%
	out.println("<br>");
	out.println("<br>");
    Statement statement=con.createStatement();
	primaryFlag = java.net.URLDecoder.decode(primaryFlag);
	out.println("<table width='640' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
	out.println("<tr bgcolor='#EEEEEE'>");
	out.println("<td width='10'><font size='2'>&nbsp;</font></td>");
	out.println("<td width='170'><font size='2'>客戶料號</font></td>");
	out.println("<td width='90'><font size='2'>客戶料號代號</font></td>");
	out.println("<td width='70'><font size='2'>台半料號</font></td>");
	out.println("<td width='50'><font size='2'>Internal Item代號</font></td>");
	out.println("<td width='170'><font size='2'>Internal Item</font></td>");
 	out.println("<td width='10%'><font size='2'>Item Identifier Type</font></td>");
	out.println("<td width='60'><font size='2'>客戶代號</font></td>");
	out.println("</tr>");
	   
	try
	{ 
		//add by Peggy 20210225
		String sql = " SELECT  DISTINCT INVENTORY_ITEM_ID"+
                     " FROM (select packing_no,ITEM_DESCRIPTION, INVENTORY_ITEM_ID from tsc_packing_lines"+
                     " WHERE packing_no=REPLACE(CASE WHEN SUBSTR(TRIM('"+INVOICE+"'),-1)='.' THEN SUBSTR(TRIM('"+INVOICE+"'),1,LENGTH(TRIM('"+INVOICE+"'))-1) ELSE TRIM('"+INVOICE+"') END ,'_','')"+
                     " AND ITEM_DESCRIPTION='"+ITEMDESC+"'"+
                     " AND CARTON_NO='"+CARTON+"'"+
                     " UNION ALL"+
                     " SELECT packing_no,ITEM_DESCRIPTION, INVENTORY_ITEM_ID from tsc_t_packing_l_fairchild"+
                     " WHERE packing_no=REPLACE(CASE WHEN SUBSTR(TRIM('"+INVOICE+"'),-1)='.' THEN SUBSTR(TRIM('"+INVOICE+"'),1,LENGTH(TRIM('"+INVOICE+"'))-1) ELSE TRIM('"+INVOICE+"') END ,'_','')"+
                     " AND ITEM_DESCRIPTION='"+ITEMDESC+"'"+
                     " AND CARTON_NO='"+CARTON+"') pkg";
		//out.println(sql);
		ResultSet rs1=statement.executeQuery(sql);
		if (rs1.next())
		{
			ship_itemid=rs1.getString(1);
		}
		else
		{
			ship_itemid="0";
		}
		rs1.close();
		//statement.close();
		
 		sql = " select ITEM ,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM ,"+
					 " ITEM_IDENTIFIER_TYPE,SOLD_TO_ORG_ID , "+
					 " decode(item_identifier_type, 'INT', (select meaning from oe_lookups where lookup_type='ITEM_IDENTIFIER_TYPE' and lookup_code = 'INT'),'CUST', (select meaning from oe_lookups where lookup_type = 'ITEM_IDENTIFIER_TYPE' and lookup_code = 'CUST'),item_identifier_type) item_identifier_type_meaning "+
		             " from oe_items_v   "+
		             " where Item ='"+primaryFlag+"' and (sold_to_org_id = '"+customerNumber+"' or sold_to_org_id is null) "+
					 " and CROSS_REF_STATUS <> 'INACTIVE'"; //add by Peggy 20111031
		if (!ITEMDESC.equals("")) sql += " and ITEM_DESCRIPTION='"+ITEMDESC+"'";
		if (!ship_itemid.equals("0")) sql += " and INVENTORY_ITEM_ID="+ship_itemid+"";  //add by Peggy 20210225
		//out.println(sql);
		ResultSet rs=statement.executeQuery(sql);
		if(rs==null)
		{
			rs.close();  
			//statement.close();
			sql = " select ITEM ,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM ,"+
				  " ITEM_IDENTIFIER_TYPE,SOLD_TO_ORG_ID ,"+
				  " decode(item_identifier_type, 'INT', (select meaning from oe_lookups where lookup_type='ITEM_IDENTIFIER_TYPE' and lookup_code = 'INT'),'CUST', (select meaning from oe_lookups where lookup_type = 'ITEM_IDENTIFIER_TYPE' and lookup_code = 'CUST'),item_identifier_type) item_identifier_type_meaning "+
				  " from oe_items_v   "+
				  " where Item like '%"+primaryFlag+"%' and (sold_to_org_id = '"+customerNumber+"' or sold_to_org_id is null) "+
				  " and CROSS_REF_STATUS <> 'INACTIVE'"; //add by Peggy 20111031
			if (!ITEMDESC.equals("")) sql += " and ITEM_DESCRIPTION='"+ITEMDESC+"'";
			if (!ship_itemid.equals("0")) sql += " and INVENTORY_ITEM_ID="+ship_itemid+"";  //add by Peggy 20210225
			rs=statement.executeQuery(sql); 
		}
		
		if(rs!=null)
		{
			while(rs.next())
			{
				p_Item = rs.getString("ITEM");
				p_Item_ID = rs.getString("ITEM_ID");
				if (p_Item_ID==null)
				{
					p_Item_ID="0";
				}
				p_Item_Description = rs.getString("ITEM_DESCRIPTION");
				p_Inventory_Item_ID = rs.getString("INVENTORY_ITEM_ID");
				p_Inventory_Item = rs.getString("INVENTORY_ITEM");
				p_Item_Identifier  = rs.getString("ITEM_IDENTIFIER_TYPE");
				p_Sold_To_Org_ID = rs.getString("SOLD_TO_ORG_ID");
				out.println("<tr bgcolor='#E6FFE6'>");
				if (sourcePage.equals("D1010")) //modify by Peggy 20120924
				{
					out.println("<td><input type='button'  value='set' onClick='setSubmit("+'"'+url_page+"?ID="+keyID+"&p_line_no="+line_no+"&inventory_Item_ID="+p_Inventory_Item_ID+"&inventory_Item="+p_Inventory_Item+"&Item="+p_Item+"&p_Item_Description="+p_Item_Description+"&p_Item_Identifier="+p_Item_Identifier+"&p_Item_ID="+p_Item_ID+'"'+")'></td>");
				}
				else
				{
					out.println("<td><input type='button'  value='set' onClick='setSubmit("+'"'+url_page+"?ID="+keyID+"&keyCode="+keyCode+"&p_line_no="+line_no+"&inventory_Item_ID="+p_Inventory_Item_ID+"&inventory_Item="+p_Inventory_Item+"&Item="+p_Item+"&p_Item_Description="+p_Item_Description+"&p_Item_Identifier="+p_Item_Identifier+"&p_Item_ID="+p_Item_ID+'"'+")'></td>");
				}
				out.println("<td><div align='right'><font size='2'>"+p_Item+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Item_ID+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Item_Description+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Inventory_Item_ID+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Inventory_Item+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Item_Identifier+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Sold_To_Org_ID+"</font></div></td>");
				out.println("</tr>");
			}
			rs.close();
			statement.close();
		}
		else
		{
			out.println("<tr bgcolor='#E6FFE6'>");
			out.println("<td colspan='8'><div align='center'><font size='2'>No Data !!</font></div></td>");
			out.println("</tr>");
		} //end  if
	}
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());
	}
 	out.println("</table>");
    %>
	<BR>
    <!--%表單參數%-->
    <INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%= primaryFlag%>" >
    </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
 </body>
</html>
