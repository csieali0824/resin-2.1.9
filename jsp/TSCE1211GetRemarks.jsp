<!--  取 alternaateRouting及Routing Id	還有error ,先disable   2006/9/29-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<html>
<head>
<title>MFG System Work Order Data Save</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function alertRFQNotSuccess(msRFQCreateMsg)
{
   alert(msRFQCreateMsg);
}
</script>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<%@ page import="bean.DateBean,bean.ArrayCheckBoxBean,bean.Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="bean.ArrayCheckBoxBean"/>
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="bean.Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
	String woNo=request.getParameter("WONO"); 
   

//out.println("userParOrgID="+userParOrgID);

 

  	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
  	cs1.execute();
  	cs1.close();
	
	
      
try
{  // EXCEPTION 3:		
	  
	 
	 // 確認工令Inventory_Item_ID 為正確的ID
	 String sqlInvItem = " select DISTINCT MO_NO from ORADDMAN.TSC_1211_REMARKS where REMARKS is null  " ;
	 //out.print("sqli="+sqli);
	 Statement stateInvItem=con.createStatement();
     ResultSet rsInvItem=stateInvItem.executeQuery(sqlInvItem);
	 while (rsInvItem.next())
	 { 	
	      String longRemark = "";
	      String sqlLong =    " select  d.LONG_TEXT "+
                              "   from FND_ATTACHED_DOCS_FORM_VL a, OE_ORDER_HEADERS_ALL b, FND_DOCUMENTS_TL c, FND_DOCUMENTS_LONG_TEXT d "+
                              "  where a.ENTITY_NAME = 'OE_ORDER_HEADERS' and a.PK1_VALUE = b.HEADER_ID "+
                              "    and c.MEDIA_ID = d.MEDIA_ID "+
                              "    and a.DOCUMENT_ID = c.DOCUMENT_ID and c.LANGUAGE='US' "+
                              "    and a.CATEGORY_DESCRIPTION = 'REMARKS' "+
	                          "    and a.FUNCTION_NAME = 'TSCOEORD' "+                               
                              "    and b.ORDER_NUMBER = '"+rsInvItem.getString("MO_NO")+"' "+
					          "    and ROWNUM=1       " ;
	      //out.print("sqli="+sqli);
	      Statement stateLong=con.createStatement();
          ResultSet rsLong=stateLong.executeQuery(sqlLong);
		  if (rsLong.next()) longRemark = rsLong.getString(1);
		  rsLong.close();
		  stateLong.close();
	     
	      String seqSql="update ORADDMAN.TSC_1211_REMARKS SET REMARKS=? WHERE MO_NO='"+rsInvItem.getString("MO_NO")+"' ";   
          PreparedStatement seqstmt=con.prepareStatement(seqSql);        
          seqstmt.setString(1,longRemark);   	
          seqstmt.executeUpdate();   
          seqstmt.close(); 
     } // End of while
	 rsInvItem.close();
     stateInvItem.close(); 	
	 

 
} //end of try
catch (Exception e)
{
  e.printStackTrace();
  out.println("EXCEPTION 3:"+e.getMessage());
}//end of catch
%>  
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<%
    
%>
</html>

