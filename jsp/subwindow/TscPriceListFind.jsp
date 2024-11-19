<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<%
 
 	//String line_no=request.getParameter("line_no");
 	String customerPO=request.getParameter("customerPO");
	String Currency_code=request.getParameter("Currency_code");
	String keyID=request.getParameter("ID");
  	String sourcePage=request.getParameter("sourcepg");
	if (sourcePage == null) sourcePage = "";
	String url_page = "";
	if (sourcePage.equals("D1010"))
	{
		url_page  = "../jsp/Tsc1211SpecialCustConfirm.jsp";
	}
	else 
	{
		url_page = "../jsp/Tsc1211ConfirmDetailList.jsp";
	}
  	String p_List_Header_ID="";
  	String p_List_Code="";
  	String p_Currency_Code="";
 
   //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
   //cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
   cs1.execute();
   //out.println("Procedure : Execute Success !!! ");
   cs1.close();
 
 

  
  
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
</script>
<body >  
<FORM METHOD="post" name ="form1">
<TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Price List Select :</strong></font></TD>
  

<%
 //out.println("<input type='submit' name='Submit' value='complete' onClick='setCreate("+'"'+"TscProductFind.jsp?PRIMARYFLAG="+new+"&customerPO="+customerPO+"&line_no="+line_no+'"'+")'>");
%>

	<br>
  <br>
      <%  
       
	   //primaryFlag = java.net.URLDecoder.decode(primaryFlag);
	   //out.println(primaryFlag);
	   out.println("<table width='450' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'");
	   out.println("<tr bgcolor='#EEEEEE'>");
	   out.println("<td width='10'><font size='2'></font></td>");
	   out.println("<td width='150'><font size='2'>LIST_HEADER_ID</font></td>");
	   out.println("<td width='250'><font size='2'>LIST_CODE</font></td>");
	   out.println("<td width='40'><font size='2'>CURRENCY_CODE</font></td>");
	   out.println("</tr>");
	   
	   
	try{ 
	   String sql = "select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
					"from qp_list_headers_v "+
					"where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' and CURRENCY_CODE= '"+Currency_code+"' "; 					
 		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql);
 		
		//out.println("sql12="+sql);
 
			while (rs.next()){
					 p_List_Header_ID =rs.getString("LIST_HEADER_ID");
					 p_List_Code =rs.getString("LIST_CODE");
					 p_Currency_Code =rs.getString("CURRENCY_CODE");
					out.println("<tr bgcolor='#E6FFE6'>");
					out.println("<td><input type='button'  value='set' onClick='setSubmit("+'"'+url_page+"?ID="+keyID+"&p_List_Header_ID="+p_List_Header_ID+"&p_Currency_Code="+p_Currency_Code+'"'+")'></td>");
					//out.println("<td><input type='button'  value='set' onClick='sendToMainWindow("+'"'+p_Inventory_Item+'"'+","+'"'+line_no+'"'+")'></td>");
					out.println("<td><div align='right'><font size='2'>"+p_List_Header_ID+"</font></div></td>");
					out.println("<td><div align='right'><font size='2'>"+p_List_Code+"</font></div></td>");
					//out.println("<td><div align='right'><font size='2'>"+p_Item_ID+"</font></div></td>");
					out.println("<td><div align='right'><font size='2'>"+p_Currency_Code+"</font></div></td>");
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
    
 
    
    </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
