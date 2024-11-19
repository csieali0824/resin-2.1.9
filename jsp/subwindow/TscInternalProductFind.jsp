<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>

<%
 String primaryFlag=request.getParameter("PRIMARYFLAG");
 String line_no=request.getParameter("line_no");
 String keyID = request.getParameter("ID");
 String inventory_Item_ID=request.getParameter("inventory_Item_ID");
 String customerPO=request.getParameter("customerPO");
 String searchString=request.getParameter("SEARCHSTRING");
 out.println(customerPO);
 out.println(line_no);
 
  String p_Item = "";
  String p_Item_ID = "";
  String p_Item_Description = "";
  String p_Inventory_Item_ID = "";
  String p_Inventory_Item = "";
  String p_Item_Identifier = "";
  String p_Sold_To_Org_ID = "";
%>
<html>
<head>
<title>Page for choose Product List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
 
//function setSubmit(primaryFlag,customerPO,line_no) 
//{    
 // subWin=window.opener( );  
//}
function setSubmit(URL)
{  
  //alert(document.DISPLAYREPAIR.CHKFLAG.length); 
    //chkFlag="TURE";   
 //var linkURL = "#test";
 //alert(linkURL);
 window.opener.document.form1.action=URL;
 window.opener.document.form1.submit(); 
 this.window.close();
}

function sendToMainWindow(INVENTORY_ITEM,line_no)
{ 
  // alert(line_no);
  //object  vv = line_no;
  alert(INVENTORY_ITEM+line_no);
  
  //window.opener.document.form1.INVENTORY_ITEM.value=INVENTORY_ITEM; 
       
  this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form" >
 
 <TD colspan="0"><font size="2">TSC Internal Item search</font></TD>
    <BR>
  <%  
       Statement statement=con.createStatement();
	   primaryFlag = java.net.URLDecoder.decode(primaryFlag);
	   //out.println(primaryFlag);
	   out.println("<table width='500' border='0' align='left' cellpadding='0' cellspacing='1'>");
	   out.println("<tr bgcolor='#EEEEEE'>");
	   out.println("<td width='8%'><font size='2'></font></td>");
	   out.println("<td width='12%'><font size='2'>客戶料號</font></td>");
	   out.println("<td width='15%'><font size='2'>客戶料號代號</font></td>");
	   out.println("<td width='15%'><font size='2'>台半料號</font></td>");
	   out.println("<td width='20%'><font size='2'>Internal Item代號</font></td>");
	   out.println("<td width='30%'><font size='2'>Internal Item</font></td>");
 	   //out.println("<td width='10%'><font size='2'>ITEM_IDENTIFIER_TYPE</font></td>");
	   out.println("<td width='15%'><font size='2'>客戶代號</font></td>");
	   out.println("</tr>");
	   
	   
	try{ 
 		String sql = "select ITEM ,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM ,"+
					 "ITEM_IDENTIFIER_TYPE,SOLD_TO_ORG_ID "+
		             "from oe_items_v   "+
		             "where Item ='"+primaryFlag+"'";

        ResultSet rs=statement.executeQuery(sql);
		
		while (rs.next()){
			//if(rs.next()==false){
			//	out.println("<tr>");
   			//	out.println("<td colspan='6'  bgcolor='#E6FFE6' >&nbsp;</td>");
  			//	out.println("</tr>");
			//}else{		
				p_Item = rs.getString("ITEM");
				p_Item_ID = rs.getString("ITEM_ID");
				p_Item_Description = rs.getString("ITEM_DESCRIPTION");
				p_Inventory_Item_ID = rs.getString("INVENTORY_ITEM_ID");
				p_Inventory_Item = rs.getString("INVENTORY_ITEM");
				p_Item_Identifier  = rs.getString("ITEM_IDENTIFIER_TYPE");
				p_Sold_To_Org_ID = rs.getString("SOLD_TO_ORG_ID");
				out.println("<tr bgcolor='#E6FFE6'>");
				out.println("<td><input type='button'  value='set' onClick='setSubmit("+'"'+"../jsp/Tsc1211ConfirmDetailList.jsp?ID="+keyID+"&p_line_no="+line_no+"&inventory_Item_ID="+p_Inventory_Item_ID+"&inventory_Item="+p_Inventory_Item+'"'+")'></td>");
				//out.println("<td><input type='button'  value='set' onClick='sendToMainWindow("+'"'+p_Inventory_Item+'"'+","+'"'+line_no+'"'+")'></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Item+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Item+"</font></div></td>");
				//out.println("<td><div align='right'><font size='2'>"+p_Item_ID+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Item_Description+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Inventory_Item_ID+"</font></div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Inventory_Item+"</font></div></td>");
				//out.println("<td><div align='right'>"+p_Item_Identifier+"</div></td>");
				out.println("<td><div align='right'><font size='2'>"+p_Sold_To_Org_ID+"</font></div></td>");
				out.println("</tr>");
			//}
		} 
		
	}catch (Exception e){
		out.println("Exception:"+e.getMessage());
	}
 	out.println("</table>");
     %>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >

</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
