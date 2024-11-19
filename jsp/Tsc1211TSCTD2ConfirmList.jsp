<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC轉出訂單頁面</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
String  sSql = "";
String  keyID = "";
String  customerPO        = "";
String  packingListNumber = "";   
String  customerName      = "";
String  shipmentTerms     = "";
String  c_Date            = "";     
String  status 			  = "";
String  sys_status 		  = "N";
String  created_By 		  = "";
String  orderNumber		  = "";
String  invoiceNumber 	  = "";


//String	q_customer			= 	request.getParameter("q_customer");
String	q_begin_date	=	request.getParameter("q_begin_date");
String	q_end_date		=	request.getParameter("q_end_date");

String	q_status		=	request.getParameter("q_status");
String	q_customerName		=	request.getParameter("q_customerName");
String  q_created_By 		  =request.getParameter("q_created_By");
//String	created_By	=	request.getParameter("created_By");
 
String	str_q_customer	=	""; 
String	str_q_begin_date	=	"";
String	str_q_end_date		=	"";
String	str_q_status		=	"";
String	str_created_By		=	"";

//out.println("q_customerName="+q_customerName);
//out.println("q_status="+q_status);

 
	if(q_customerName==null || q_customerName.equals("--")){
		str_q_customer  = "   WHERE  CUSTOMERNAME <> 'suming' ";
	}else{
		
		str_q_customer  = "  WHERE CUSTOMERNAME= '"+q_customerName+"'";		
	}
	 
	if(q_status==null || q_status.equals("--")){
		str_q_status=" and  status= 'OPEN'";
	}else{
		str_q_status =" and  status= '"+q_status+"'";		
	}
	
	
	if(q_created_By==null || q_created_By.equals("--")){
		str_created_By=" ";
	}else{
		str_created_By =" and CREATED_BY= '"+q_created_By+"'";		
	}
	
// if (q_begin_date!="" &&  q_end_date!="" ){
 //	str_q_begin_date = " and C_DATE between  '"+q_begin_date+"' and '"+q_end_date+"'";
 //}else{
 //	str_q_begin_date = " ";
// }


	//if q_cust_no = "" then
	//	str_q_cust_no = ""
	//else
	//	str_q_cust_no = " and a.cust_no = '"& q_cust_no &"'"
	//end if








%>
<style type="text/css">
<!--
.style1 {color: #000000}
-->
</style>
</head>

<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<body>
<form name="form1" method="post" action="Tsc1211confirmList.jsp">
 <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<p>
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Order Temp List </strong></font></p>
 <BR>
 
 <%@ include file="Tsc1211head.jsp"%>
 <br>
<table cellSpacing="0" borderColorDark="#aaaaaa"  cellPadding="0" width="100%" align="center" borderColorLight="#ffffff" border="1">
  <tr >
    <td colspan="7" bgcolor="#99CCFF" class="tableTitle" ><span class="style1"><font face='Arial'  size="2">文件搜尋選擇 :</font></span></td>
    </tr>
  <tr>
    <td width="58" bgcolor="#99CCFF" class="tableTitle" ><span class="style1"><font face='Arial'  size= "2">客戶名稱</font></span></td>
    <td width="172">
	<%
	   try
	   {   
		 Statement st1=con.createStatement();
		 ResultSet rs1=null;
		 String sql = "select DISTINCT CUSTOMERNAME, CUSTOMERNAME from TSC_OE_AUTO_HEADERS ";   //要傳兩個變數
		 rs1=st1.executeQuery(sql);
		 comboBoxBean.setRs(rs1);
		 comboBoxBean.setSelection(q_customerName);
		 comboBoxBean.setFieldName("q_customerName");	   
		 out.println(comboBoxBean.getRsString());				    
			rs1.close();   
			st1.close();     	 
		} //end of try		 
		catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	
	%>
	</td>
    <td bgcolor="#99CCFF" class="tableTitle" width="82" ><span class="style1"><font face='Arial'   size= "2">搜尋開始時間</font></span></td>
    <td width="157"><input name="q_begin_date" type="text" id="q_begin_date" size="15" readonly value="">
        <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_begin_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
    <td bgcolor="#99CCFF" class="tableTitle" width="81" ><span class="style1"><font  face='Arial'  size= "2">搜尋結束時間</font></span></td>
    <td width="147"><input name="q_end_date" type="text" id="q_end_date" size="15" readonly value="" >
        <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_end_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
    <td width="46">&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#99CCFF" class="tableTitle" ><span class="style1"><font face='Arial'  size="2">訂單狀態</font></span></td>
    <td>
		<%
	   try
	   {   
		 Statement st1=con.createStatement();
		 ResultSet rs1=null;
		 String sql = "select DISTINCT status , status from TSC_OE_AUTO_HEADERS ";   //要傳兩個變數
		 rs1=st1.executeQuery(sql);
		 comboBoxBean.setRs(rs1);
		 comboBoxBean.setSelection(q_status);
		 comboBoxBean.setFieldName("q_status");	   
		 out.println(comboBoxBean.getRsString());				    
			rs1.close();   
			st1.close();     	 
		} //end of try		 
		catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	
	%> 
    </td> 
    <td bgcolor="#99CCFF" class="tableTitle" ><span class="style1"><font face='Arial'  size="2">建立人員</font></span></td>
    <td>
		<%
			       try
                   {   
		             Statement st2=con.createStatement();
                     ResultSet rs2=null;
			         String sql2 = "select DISTINCT created_By , created_By from TSC_OE_AUTO_HEADERS ";   //要傳兩個變數
                     rs2=st2.executeQuery(sql2);
		             comboBoxBean.setRs(rs2);
		             comboBoxBean.setSelection(q_created_By);
	                 comboBoxBean.setFieldName("q_created_By");	   
                     out.println(comboBoxBean.getRsString());				   
		            	rs2.close();   
						st2.close();     	 
                 	} //end of try		 
                 	catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	
	%>
	</td>
    <td bgcolor="#99CCFF" class="tableTitle" >&nbsp;</td>
    <td>&nbsp;</td>
    <td width="46"><input name="search" type="submit" id="search" value="search"></td>
  </tr>
</table>
<br>
<table width="1000"   bordercolordark="#99CCFF" border="0" cellpadding="0" cellspacing="1" class="innTable" bordercolorlight="#ffffff"  background="#334455">
  <tr bgcolor="#99CCFF" >
     <td width="10%"><div align="center"><font face='Arial' color="#000000"  size= "2">Packing Number</font></div></td>
    <td width="13%"><div align="center"><font face='Arial' color="#000000" size= "2">Customer PO</font></div></td>
    <td width="45%"><div align="center"><font face='Arial' color="#000000" size= "2">Customer</font></div></td>
    
    <td width="10%"><div align="center"><font face='Arial' color="#000000" size= "2">Creation Date</font></div></td>
    <td width="7%"><div align="center"><font face='Arial' color="#000000" size= "2">Status</font></div></td>
    
	  <td width="10%" height="15"><div align="center"><font face='Arial' color="#000000" size="2">Order Number </font></div></td>
	  <td width="5%" height="15"><div align="center"><font face='Arial' color="#000000" size="2">&nbsp;</font></div></td>
  </tr>
  <%
		  if(sys_status =="N"){
		  //out.println("sys_status"+sys_status);
			  try{
					 sSql="select * ";
					 sSql=sSql+" from TSC_OE_AUTO_HEADERS ";
					 sSql=sSql+"  ";
					 sSql=sSql+str_q_customer;
					 sSql=sSql+str_q_status;
					 sSql=sSql+str_created_By;
					 sSql=sSql+ " order by c_Date desc ";
					 //sSql=sSql+str_q_begin_date;
					 //out.println("sSql="+sSql);
					 
					 Statement st = con.createStatement();
					 ResultSet rs = st.executeQuery(sSql);
					 int i = 1;
					
						while(rs.next()){
						    customerPO		  = rs.getString("CUSTOMERPO");
							packingListNumber = rs.getString("PACKINGLISTNUMBER");
							customerName      = rs.getString("CUSTOMERNAME");
							shipmentTerms     = rs.getString("SHIPMENTTERMS");
							c_Date            = rs.getString("C_DATE");
							status 			  = rs.getString("status");
							orderNumber 	  = rs.getString("ORDER_NUMBER");
							keyID 	  		  = rs.getString("ID");
							//invoiceNumber	  = rs.getString("SHIPPING_INSTRUCTIONS");
							 
						if(status=="OPEN"||status.equals("OPEN")){
						//out.println("status1="+status);
							out.println("<tr bgcolor='#FFDDAA'>"); 
						}else{
						//out.println("status2="+status);
							out.println("<tr bgcolor='#FFEEEE'>");
						}
						out.println("<td><div align='left'><font face='Arial'  size=2>"+packingListNumber+"</font></div></td>");
						out.println("<td><div align='left'><font face='Arial' size=2>"+customerPO+"</font></div></td>");
						out.println("<td><div align='left'><font face='Arial'  size=2 >"+customerName+"</font></div></td>");
						//out.println("<td><div align='center'><font size=2>"+invoiceNumber+"</font></div></td>");
						//out.println("<td><div align='center'><font face='Arial' size=2>"+shipmentTerms+"</font></div></td>");
						out.println("<td><div align='center'><font face='Arial' size=2>"+c_Date +"</font></div></td>");
						out.println("<td><div align='center'><font face='Arial' size=2>"+status+"</font></div></td>");
						 
						out.println("<td><div align='center'><font face='Arial' size=2>"+orderNumber+"</font></div></td>");
						//out.println("customerPO=" +java.net.URLEncoder.encode("A"+customerPO+"V"));
						out.println("<td><div align='center'><font face='Arial' size=2><a href='Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID)+"'>Detail</a></font></div></td>");
						out.println("</tr>"); 
						
						
						
						
						
						
							i++;
						} 
				 }catch(SQLException e){
					out.println(e.toString());
				 }
			}else{
		  %>
		 
  <tr>
    <td height="10" colspan="8" align="center"><em><font size= "2">Not Data !!</font></em></td>
  </tr>
  <% } %>


</table>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%
//rs.close();
//st.close();
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>