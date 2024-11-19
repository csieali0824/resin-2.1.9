<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit2(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle AddsOn System Order Import Create Test Page</title>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
</head>
<%
   String organizationId =request.getParameter("ORGPARID");
   String orderType=request.getParameter("ORDERTYPE");
   String soldToOrg=request.getParameter("SOLDTOORG");
   String priceList=request.getParameter("PRICELIST");
   String lineType=request.getParameter("LINETYPE");

   
   if (priceList==null) {  priceList = "0"; }
%>
<body>
 <FORM ACTION="../jsp/TestOrderImportCreateSubmit.jsp" METHOD="post" NAME="MYFORM">
   <p>　</p>
   <p>&nbsp;</p>
   <table cellSpacing="0" borderColorDark="#FF9933"  cellPadding="1" width="95%" align="center" borderColorLight="#ffffff" border="1">
     <tbody>
	     <tr><td colspan="6"><font color="#FF3300"><span class="style1">&nbsp;</span>Sales Order Import</font></td></tr>
		 <tr><td bgcolor="#FFCC99" colspan="3"><font face="Arial"><span class="style1">&nbsp;</span>Organization</font></td>
		     <td colspan="3">
			   <%
			       try
                   {   
		             Statement statement=con.createStatement();
                     ResultSet rs=null;	
			         String sql = "select DISTINCT c.organization_id_parent, c.organization_id_parent || '('||d.name|| ')' "+
			                            "from mtl_parameters a, hr_organization_units b, per_org_structure_elements c, hr_organization_units d "+
			                            "where a.organization_id = b.organization_id and a.organization_id = c.organization_id_child "+		
										"and c.organization_id_parent = d.organization_id "+						  
								        "order by 1 ";  			  
                     rs=statement.executeQuery(sql);
		             comboBoxBean.setRs(rs);
		             comboBoxBean.setSelection(organizationId);
	                 comboBoxBean.setFieldName("ORGPARID");	   
                     out.println(comboBoxBean.getRsString());				    
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }                     
			   %>
		     </td></tr>
	     <tr>
		   <td width="14%" bgcolor="#FFCC99"><font size="2" face="Arial"><span class="style1">&nbsp;</span>Order Type ID</font></td>
           <td width="19%" bgColor="#ffffff"><font face="Arial"><!--%<input maxLength="40" size="15" name="ORDERTYPE">%-->
		     <%
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select TRANSACTION_TYPE_ID, TRANSACTION_TYPE_ID||'('||NAME||')' as TRANSACTION_TYPE_CODE "+
			                          "from oe_transaction_types_tl "+
			                          "where LANGUAGE = 'US'  "+								  
								      "order by 2 ";  
			  
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(orderType);
	               comboBoxBean.setFieldName("ORDERTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   /*
		           out.println("<select NAME='ORDERTYPE' onChange='setSubmit("+'"'+"../jsp/TestOrderImportCreate.jsp"+'"'+")'>");
		           out.println("<OPTION VALUE=-->--");     
		           while (rs.next())
		           {            
		             String s1=(String)rs.getString(1); 
		             String s2=(String)rs.getString(2); 
                        
		             if (s1.equals(organizationId)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
					  organizationCode = s2;                                  
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
		            } //end of while
		            out.println("</select>"); 	
					*/  		  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
		   </font></td>
           <td width="13%" bgColor="#FFCC99"><font face="Arial" size="2">Sold to Org ID</font></td>
           <td width="18%" bgColor="#ffffff"><font face="Arial"><!--%<input maxLength="40" size="15" name="SOLDTOORG">%-->
		      <%
			     try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlSold = "select CUST_ACCOUNT_ID, CUST_ACCOUNT_ID||'('||SALES_CHANNEL_CODE||')' as TRANSACTION_TYPE_CODE, PRICE_LIST_ID "+
			                          "from hz_cust_accounts "+
			                          "where status = 'A' and SALES_CHANNEL_CODE IS NOT NULL and PRICE_LIST_ID IS NOT NULL  "+								  
								      "order by cust_account_id ";  
			  
                   rs=statement.executeQuery(sqlSold);
		           out.println("<select NAME='SOLDTOORG' onChange='setSubmit("+'"'+"../jsp/TestOrderImportCreate.jsp"+'"'+")'>");
		           out.println("<OPTION VALUE=-->--");     
		           while (rs.next())
		           {            
		             String s1=(String)rs.getString(1); 
		             String s2=(String)rs.getString(2); 
                     
		             if (s1.equals(soldToOrg)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
					  soldToOrg = s2;  
					  priceList = rs.getString(3);                                 
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
		            } //end of while
		            out.println("</select>"); 
				    statement.close();		  		  
		            rs.close();        	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }       
			  %>
		   </font></td>
           <td width="11%" bgColor="#FFCC99"><font face="Arial" size="2">Price List ID</font></td>
           <td width="25%" bgColor="#ffffff"><font face="Arial">
		      <%
			     String listCode = "";
			     try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sql = "select LIST_HEADER_ID||'('||NAME||'-'||DESCRIPTION||')' as LIST_CODE "+
			                          "from qp_list_headers_tl "+
			                          "where LANGUAGE = 'US' and TO_CHAR(LIST_HEADER_ID) = '"+priceList+"' ";
                   rs=statement.executeQuery(sql);
		           if (rs.next())
				   { listCode = rs.getString(1); }	  		  
		           rs.close();   
				   statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
			  %>
		   <input maxLength="40" size="25" name="LISTCODE" value="<%=listCode%>" readonly>
		   <input type="hidden" size="25" name="PRICELIST" value="<%=priceList%>" readonly>
		   </font></td> 
	     </tr>
		 <tr>
		   <td width="14%" bgcolor="#FFCC99"><font size="2" face="Arial"><span class="style1">&nbsp;</span>Inventory Item ID</font></td>
           <td width="19%" bgColor="#ffffff"><font face="Arial"><input maxLength="40" size="15" name="INVITEM"></font></td>
           <td width="13%" bgColor="#FFCC99"><font face="Arial" size="2">Order Q'ty</font></td>
           <td width="18%" bgColor="#ffffff"><font face="Arial"><input maxLength="40" size="15" name="ORDERQTY"></font></td>
           <td width="11%" bgColor="#FFCC99"><font face="Arial" size="2">Line Type ID</font></td>
           <td width="25%" bgColor="#ffffff"><font face="Arial"><!--%<input maxLength="40" size="15" name="LINETYPE">%-->
		      <%
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sql = "select TRANSACTION_TYPE_ID, TRANSACTION_TYPE_ID||'('||NAME||')' as TRANSACTION_TYPE_CODE "+
			                          "from OE_TRANSACTION_TYPES_TL "+
			                          "where LANGUAGE = 'US'  "+								  
								      "order by 2 ";  			  
                   rs=statement.executeQuery(sql);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(lineType);
	               comboBoxBean.setFieldName("LINETYPE");	   
                   out.println(comboBoxBean.getRsString());				     		  
		           rs.close();   
				   statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>	   
		   </font></td> 
	     </tr>
		 <tr>
		   <td bgcolor="#FFCC99" colspan="6"><font size="2" face="Arial"><span class="style1">&nbsp;</span><input name="Submit" type="submit" value="送出"></font></td>            
	     </tr>
    </tbody>
   </table>
  </FORM>
  <!--=============以下區段為釋放連結池==========-->
  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <!--=================================-->
</body>
</html>
