<!-- modify by Peggy 20140808,新增對應erp customer-->
<!-- modify by Peggy 20171124,erp customer1必填-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/> 
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 14px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 14px } 
  TD        { font-family: Tahoma,Georgia;font-size: 14px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 14px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 14px }
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setLink(URL)
{  
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function setSubmit(URL)
{ 
	if (document.MYFORM.CUSTOMERID.value == null || document.MYFORM.CUSTOMERID.value == "")
	{
    	alert("請輸入CUSTOMER ID!!");
     	document.MYFORM.CUSTOMERID.focus();
   		return false;
	}
	if (document.MYFORM.CUSTNAME.value == null || document.MYFORM.CUSTNAME.value == "")
	{
    	alert("請輸入CUSTOMER NAME!!");
     	document.MYFORM.CUSTNAME.focus();
   		return false;
	}
	if (document.MYFORM.CURRENCYCODE.value == null || document.MYFORM.CURRENCYCODE.value == "")
	{
    	alert("請選擇Currency Code!");
     	document.MYFORM.CURRENCYCODE.focus();
   		return false;
	}
	if (document.MYFORM.ERPCUSTOMER1.value == null || document.MYFORM.ERPCUSTOMER1.value =="")
	{
    	alert("請選擇對應的ERP Customer!");
     	document.MYFORM.ERPCUSTOMER1.focus();
   		return false;	
	}
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnCancel.disabled=true;
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.clientHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setCustInfoFind(custName,objid)
{      
	subWin=window.open("../jsp/subwindow/TSCE1214CustInfoFind.jsp?CNAME="+custName+"&ID="+objid,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

</script>
<title>PMD Item AVL creation and modify</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSCE1214CustomerUpdate.jsp" METHOD="POST"> 
<%
String btnName = "Save";
String CUSTOMERID = request.getParameter("CUSTOMERID");
if (CUSTOMERID == null) CUSTOMERID="";
String ORIGCUSTOMERID = request.getParameter("ORIGCUSTOMERID");
if (ORIGCUSTOMERID == null) ORIGCUSTOMERID="";
String CUSTNAME = request.getParameter("CUSTNAME");
if (CUSTNAME == null) CUSTNAME = "";
String CURRENCYCODE = request.getParameter("CURRENCYCODE");
if (CURRENCYCODE == null) CURRENCYCODE = "";
String CURR = request.getParameter("CURR");
if (CURR==null) CURR="";
String STATUS= request.getParameter("STATUS");
if (STATUS==null) STATUS="A";
String ActionMode = request.getParameter("ACTIONMODE");
if (ActionMode ==null) ActionMode="NEW";
String strActionCode = request.getParameter("ACTIONCODE");
if (strActionCode ==null) strActionCode="";
String ERPCUSTOMER1 = request.getParameter("ERPCUSTOMER1");  //add by Peggy 20140808
if (ERPCUSTOMER1==null) ERPCUSTOMER1="";
String ERPCUSTOMER2 = request.getParameter("ERPCUSTOMER2");  //add by Peggy 20140808
if (ERPCUSTOMER2==null) ERPCUSTOMER2=""; 
String ERPCUSTOMER3 = request.getParameter("ERPCUSTOMER3");  //add by Peggy 20140808
if (ERPCUSTOMER3==null) ERPCUSTOMER3="";
String ERPCUSTOMER4 = request.getParameter("ERPCUSTOMER4");  //add by Peggy 20140808
if (ERPCUSTOMER4==null) ERPCUSTOMER4="";
String ERPCUSTOMER5 = request.getParameter("ERPCUSTOMER5");  //add by Peggy 20140808
if (ERPCUSTOMER5==null) ERPCUSTOMER5="";
String ERPCUSTID1 = request.getParameter("ERPCUSTID1");      //add by Peggy 20140808
if (ERPCUSTID1==null) ERPCUSTID1="";
String ERPCUSTID2 = request.getParameter("ERPCUSTID2");      //add by Peggy 20140808
if (ERPCUSTID2==null) ERPCUSTID2="";
String ERPCUSTID3 = request.getParameter("ERPCUSTID3");      //add by Peggy 20140808
if (ERPCUSTID3==null) ERPCUSTID3="";
String ERPCUSTID4 = request.getParameter("ERPCUSTID4");      //add by Peggy 20140808
if (ERPCUSTID4==null) ERPCUSTID4="";
String ERPCUSTID5 = request.getParameter("ERPCUSTID5");      //add by Peggy 20140808
if (ERPCUSTID5==null) ERPCUSTID5="";
String bordercolor = "";

if (strActionCode.equals("Save"))
{
	try
	{  
		String sql = " SELECT 1 FROM oraddman.TSCE_END_CUSTOMER_LIST a"+
				 " WHERE CUSTOMER_ID ='"+CUSTOMERID+"' AND CURRENCY_CODE='"+CURR+"'"; //ADD CURR BY PEGGY 20210526
		if (!ActionMode.equals("NEW"))	sql +=" AND '"+CUSTOMERID+"' <> '"+ORIGCUSTOMERID+"'";
		ResultSet rs=con.createStatement().executeQuery(sql);
		if ( rs.next())
		{	
			//if (ActionMode.equals("NEW"))
			//{	
				out.println("<script language = 'JavaScript'>");
				out.println("alert('更新失敗!!此筆資料已存在!')");
				out.println("</script>");
			//}
			//else
			//{
		}
		else
		{		
	
			if (ActionMode.equals("NEW"))
			{	
		
				sql = " insert into oraddman.TSCE_END_CUSTOMER_LIST "+
					  " (customer_id, customer_name, currency_code,creation_date, created_by, last_update_date, last_updated_by, active_flag"+
					  " ,ERP_CUSTOMER_ID_1,ERP_CUSTOMER_ID_2,ERP_CUSTOMER_ID_3,ERP_CUSTOMER_ID_4,ERP_CUSTOMER_ID_5)"+ //add by Peggy 20140808
					  " values"+
					  " (?,?,?,sysdate,?,sysdate,?,?,?,?,?,?,?)";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,CUSTOMERID);	
				st1.setString(2,CUSTNAME);
				st1.setString(3,CURRENCYCODE); 
				st1.setString(4,UserName); 
				st1.setString(5,UserName); 
				st1.setString(6,STATUS); 
				st1.setString(7,ERPCUSTID1); 
				st1.setString(8,ERPCUSTID2); 
				st1.setString(9,ERPCUSTID3); 
				st1.setString(10,ERPCUSTID4); 
				st1.setString(11,ERPCUSTID5); 
				st1.executeUpdate();
				st1.close();
				out.println("<script language = 'JavaScript'>");
				out.println("alert('資料新增成功!')");
				out.println("</script>");
				//清空變數值
				CUSTOMERID ="";CUSTNAME="";CURRENCYCODE="";STATUS="";
				ERPCUSTID1="";ERPCUSTID2="";ERPCUSTID3="";ERPCUSTID4="";ERPCUSTID5="";  //add by Peggy 20140808
			}
			else
			{
				sql = " update oraddman.TSCE_END_CUSTOMER_LIST "+
					  " set CUSTOMER_ID =?"+
					  ",CUSTOMER_NAME =?"+
					  ",CURRENCY_CODE=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",ACTIVE_FLAG=?"+
					  ",ERP_CUSTOMER_ID_1=?"+
					  ",ERP_CUSTOMER_ID_2=?"+
					  ",ERP_CUSTOMER_ID_3=?"+
					  ",ERP_CUSTOMER_ID_4=?"+
					  ",ERP_CUSTOMER_ID_5=?"+
					  " where CUSTOMER_ID ='"+ORIGCUSTOMERID+"'";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,CUSTOMERID);
				st1.setString(2,CUSTNAME);
				st1.setString(3,CURRENCYCODE);  
				st1.setString(4,UserName); 
				st1.setString(5,STATUS); 
				st1.setString(6,(ERPCUSTOMER1.equals("")?"":ERPCUSTID1)); 
				st1.setString(7,(ERPCUSTOMER2.equals("")?"":ERPCUSTID2)); 
				st1.setString(8,(ERPCUSTOMER3.equals("")?"":ERPCUSTID3)); 
				st1.setString(9,(ERPCUSTOMER4.equals("")?"":ERPCUSTID4)); 
				st1.setString(10,(ERPCUSTOMER5.equals("")?"":ERPCUSTID5)); 				
				st1.executeUpdate();
				st1.close();
				out.print("<script type=\"text/javascript\">setLink("+'"'+"../jsp/TSCE1214CustomerListView.jsp"+'"'+")</script>"); 			
			
				//out.println("<script language = 'JavaScript'>");
				//out.println("alert('修改失敗!!查無此筆資料,請重新確認,謝謝!')");
				//out.println("</script>");
			}
		}
		rs.close();
	}
	catch (Exception e)
	{
		out.println(e.getMessage());
		out.println("<script language = 'JavaScript'>");
		out.println("alert('動作失敗,請洽系統管理人員,謝謝!')");
		out.println("</script>");		
	} 
}
else
{
	if (ActionMode.equals("MODIFY"))
	{
		bordercolor = "border:#FFFFFF;";
		String sql = " SELECT a.* "+
				     ",(select '('||customer_number||')' || customer_name from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_1) erp_customer_1"+
					 ",(select '('||customer_number||')' || customer_name from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_2) erp_customer_2"+
					 ",(select '('||customer_number||')' || customer_name from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_3) erp_customer_3"+
					 ",(select '('||customer_number||')' || customer_name from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_4) erp_customer_4"+
					 ",(select '('||customer_number||')' || customer_name from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_5) erp_customer_5"+
					 " FROM  oraddman.TSCE_END_CUSTOMER_LIST a"+
				     " WHERE a.CUSTOMER_ID ='"+CUSTOMERID+"'"+
					 " AND a.CURRENCY_CODE='"+CURR+"'";
		ResultSet rs=con.createStatement().executeQuery(sql);
		if ( rs.next())
		{	
			CUSTOMERID = rs.getString("CUSTOMER_ID");
			ORIGCUSTOMERID = rs.getString("CUSTOMER_ID");
			CUSTNAME = rs.getString("CUSTOMER_NAME");
			CURRENCYCODE= rs.getString("CURRENCY_CODE");
			STATUS = rs.getString("ACTIVE_FLAG");
			ERPCUSTID1 = rs.getString("ERP_CUSTOMER_ID_1");   //add by Peggy 20140808
			if (ERPCUSTID1==null) ERPCUSTID1="";
			ERPCUSTID2 = rs.getString("ERP_CUSTOMER_ID_2");   //add by Peggy 20140808
			if (ERPCUSTID2==null) ERPCUSTID2="";
			ERPCUSTID3 = rs.getString("ERP_CUSTOMER_ID_3");   //add by Peggy 20140808
			if (ERPCUSTID3==null) ERPCUSTID3="";
			ERPCUSTID4 = rs.getString("ERP_CUSTOMER_ID_4");   //add by Peggy 20140808
			if (ERPCUSTID4==null) ERPCUSTID4="";
			ERPCUSTID5 = rs.getString("ERP_CUSTOMER_ID_5");   //add by Peggy 20140808
			if (ERPCUSTID5==null) ERPCUSTID5="";
			ERPCUSTOMER1 =rs.getString("erp_customer_1");     //add by Peggy 20140808
			if (ERPCUSTOMER1==null) ERPCUSTOMER1="";
			ERPCUSTOMER2 =rs.getString("erp_customer_2");     //add by Peggy 20140808
			if (ERPCUSTOMER2==null) ERPCUSTOMER2="";
			ERPCUSTOMER3 =rs.getString("erp_customer_3");     //add by Peggy 20140808
			if (ERPCUSTOMER3==null) ERPCUSTOMER3="";
			ERPCUSTOMER4 =rs.getString("erp_customer_4");     //add by Peggy 20140808
			if (ERPCUSTOMER4==null) ERPCUSTOMER4="";
			ERPCUSTOMER5 =rs.getString("erp_customer_5");     //add by Peggy 20140808
			if (ERPCUSTOMER5==null) ERPCUSTOMER5="";
		}
		rs.close();
	}
}
%>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 500px; width: 370px; height: 50px;"> 
  <br>
<table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
	<tr>
    	<td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料儲存中,請稍候.....</font> <BR>
      		<DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 100px;"></div>
		</td>
  	</tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table align="center" width="70%">
	<tr>
		<td align="center">
			<font color="#003366" size="+3" face="Arial Black"><em>TSCE Customer <%=ActionMode.equals("NEW")?" AddNew":"Update"%></strong> </em></font>
		</td>
	</tr>
	<tr>
		<td align="right">
			<A HREF="TSCE1214CustomerListView.jsp"><font size="2">回上頁</font></A>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>Customer ID：</td>
					<td nowrap><input type="hidden" name="ORIGCUSTOMERID" VALUE="<%=ORIGCUSTOMERID%>"><input type="text" name="CUSTOMERID" value="<%=CUSTOMERID%>" size="50" style="font-family:Tahoma,Georgia;<%=bordercolor%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57"></td>
				</tr>
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>Customer Name：</td>
					<td nowrap><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>" style="font-family:Tahoma,Georgia" size="50" ></td>
				</tr>
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6"  nowrap>Currency Code：</td>
					<td nowrap>
						<select NAME="CURRENCYCODE"  style="font-family:Tahoma,Georgia;font-size:14px;<%=bordercolor%>">
							<OPTION VALUE ="" <% if (CURRENCYCODE.equals("")){ out.println("selected");}%>>--
							<OPTION VALUE ="USD" <% if (CURRENCYCODE.equals("USD")){ out.println("selected");}%>>USD
							<OPTION VALUE ="EUR" <% if (CURRENCYCODE.equals("EUR")){ out.println("selected");}%>>EUR
						</select>
					</td>
				</tr>
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>ERP Customer 1：</td>
					<td nowrap><input type="hidden" name="ERPCUSTID1" value="<%=ERPCUSTID1%>"><input type="text" name="ERPCUSTOMER1" value="<%=ERPCUSTOMER1%>" style="font-family:Tahoma,Georgia" size="70"><input type="button" name="c1" value=".." onClick="setCustInfoFind(this.form.ERPCUSTOMER1.value,'1')"></td>
				</tr>	
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>ERP Customer 2：</td>
					<td nowrap><input type="hidden" name="ERPCUSTID2" value="<%=ERPCUSTID2%>"><input type="text" name="ERPCUSTOMER2" value="<%=ERPCUSTOMER2%>" style="font-family:Tahoma,Georgia" size="70"><input type="button" name="c2" value=".." onClick="setCustInfoFind(this.form.ERPCUSTOMER2.value,'2')"></td>
				</tr>	
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>ERP Customer 3：</td>
					<td nowrap><input type="hidden" name="ERPCUSTID3" value="<%=ERPCUSTID3%>"><input type="text" name="ERPCUSTOMER3" value="<%=ERPCUSTOMER3%>" style="font-family:Tahoma,Georgia" size="70"><input type="button" name="c3" value=".." onClick="setCustInfoFind(this.form.ERPCUSTOMER3.value,'3')"></td>
				</tr>	
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>ERP Customer 4：</td>
					<td nowrap><input type="hidden" name="ERPCUSTID4" value="<%=ERPCUSTID4%>"><input type="text" name="ERPCUSTOMER4" value="<%=ERPCUSTOMER4%>" style="font-family:Tahoma,Georgia" size="70"><input type="button" name="c4" value=".." onClick="setCustInfoFind(this.form.ERPCUSTOMER4.value,'4')"></td>
				</tr>	
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6" nowrap>ERP Customer 5：</td>
					<td nowrap><input type="hidden" name="ERPCUSTID5" value="<%=ERPCUSTID5%>"><input type="text" name="ERPCUSTOMER5" value="<%=ERPCUSTOMER5%>" style="font-family:Tahoma,Georgia" size="70"><input type="button" name="c5" value=".." onClick="setCustInfoFind(this.form.ERPCUSTOMER5.value,'5')"></td>
				</tr>																				
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6"  nowrap>Status：</td>
					<td nowrap><input type="radio" name="STATUS" value="A"  <%if (ActionMode.equals("NEW") || STATUS.equals("A")){out.println("checked");}%>><font style="font-family:'Times New Roman';font-size:14px">Active</font>
						       <input type="radio" name="STATUS" value="I"  <%if (STATUS.equals("I")){out.println("checked");}%>><font style="font-family:'Times New Roman';font-size:14px">Inactive</font>
					</td>
				</tr>
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6"  nowrap>Update Date：</td>
					<td nowrap><font style="font-family:'Times New Roman';font-size:14px"><%=dateBean.getYearMonthDay()%></font></td>
				</tr>
				<tr>
					<td width="30%" height="25" bgcolor="#A0BEB6"  nowrap>Updated By：</td>
					<td nowrap><font style="font-family:'Times New Roman';font-size:14px"><%=UserName%></font></td>
				 </tr>    
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input name="btnSubmit" type=button onClick='setSubmit("../jsp/TSCE1214CustomerUpdate.jsp?ACTIONMODE=<%=ActionMode%>&ACTIONCODE=Save")' value="Save" style="font-family:'Times New Roman';font-size:14px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type=button onClick='setLink("../jsp/TSCE1214CustomerListView.jsp")' value="Cancel" style="font-family:'Times New Roman';font-size:14px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
</FORM>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
