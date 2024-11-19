<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="java.text.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<%

String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME == null) ITEMNAME = "";
String DC=request.getParameter("DC");
if (DC== null) DC = "";
String LNO=request.getParameter("LNO");
if (LNO==null) LNO="";
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(DC_YYWW,iCnt)
{ 
	if (iCnt<0)
	{
		if (window.opener.document.MYFORM.ITEMDESC.value === 'TQL821CSV33-01 RLG'
			&& /\d$/.test(window.opener.document.MYFORM.elements["DateCode"+document.SITEFORM.LNO.value].value)) {
			alert(window.opener.document.MYFORM.elements["DateCode"+document.SITEFORM.LNO.value].value+" 末碼不能輸入1~9")
		} else if (window.opener.document.MYFORM.ITEMDESC.value === 'TQL821CSV33 RLG'
			  &&  /[a-zA-Z]$/.test(window.opener.document.MYFORM.elements["DateCode"+document.SITEFORM.LNO.value].value)) {
			alert(window.opener.document.MYFORM.elements["DateCode"+document.SITEFORM.LNO.value].value+" 末碼不能輸入A~Z")
		} else {
			window.opener.document.MYFORM.elements["DC_YYWW" + document.SITEFORM.LNO.value].value = "";
			window.opener.document.MYFORM.elements["DateCode" + document.SITEFORM.LNO.value].value = "";
			window.opener.document.MYFORM.elements["DateCode" + document.SITEFORM.LNO.value].focus();
			alert("Date Code不正確!!");
		}
	}
	else if (iCnt==1)
	{
		window.opener.document.MYFORM.elements["DC_YYWW"+document.SITEFORM.LNO.value].value=DC_YYWW;
	}
	else if (iCnt==0)
	{
		window.opener.document.MYFORM.elements["DC_YYWW"+document.SITEFORM.LNO.value].value="";
		alert("查無Date Code對應的年周資訊!!");
	}
	else
	{
		window.opener.document.MYFORM.elements["DC_YYWW"+document.SITEFORM.LNO.value].value="";
		alert("異常!!Date Code對應一筆以上年周?請通知系統管理人員協助,謝謝!");
	}
  	this.window.close();
}
</script>
<title>Page for choose Item dc yyww</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCPMDDateCodeInfoFind.jsp" NAME="SITEFORM">
<input type="hidden" name="ITEMNAME" value="<%=ITEMNAME%>">
<input type="hidden" name="DC" value="<%=DC%>">
<input type="hidden" name="LNO" value="<%=LNO%>">
<%
int queryCount=0;
String dc_yyww="",sql ="";
try
{
	sql = " SELECT nvl(a.date_code_example,a.date_code_rule) date_code_example, a.item_description"+
          " FROM oraddman.tspmd_item_date_code a,inv.mtl_system_items_b b"+
          " where a.item_description=b.description"+
          " and b.segment1=?"+
          " and b.organization_id=?";
	//out.println(sql);
	//out.println(ITEMNAME);
	PreparedStatement state1 = con.prepareStatement(sql);
	state1.setString(1,ITEMNAME);
	state1.setInt(2,49);
	ResultSet rs1=state1.executeQuery();

	while (rs1.next())
	{
		if ("TQL821CSV33-01 RLG".equals(rs1.getString(2)) && DC.matches(".*\\d$")
		   || "TQL821CSV33 RLG".equals(rs1.getString(2)) && DC.matches(".*[a-zA-Z]$")) {
			queryCount = -997;
			break;
		} else {
			if (rs1.getString(1).length() != DC.length()) {
				queryCount = -999;
				break;
			} else {
				for (int i = 0; i < rs1.getString(1).length(); i++) {
					if (!rs1.getString(1).substring(i, i + 1).equals("_")) continue;
					if (!DC.substring(i, i + 1).equals("_")) {
						queryCount = -998;
						break;
					}
				}
			}
		}
	}
	rs1.close();
	state1.close();
	
	//out.println(queryCount);
	if (queryCount<0)
	{
		out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+""+'"'+","+queryCount+")</script>"); 
	}
		  
	sql =" select tsc_get_calendar_week(D_DATE,null),count(1) over (partition by 1) ROW_CNT"+
	     " from table(TSC_GET_ITEM_DATE_INFO(?,?))  WHERE D_TYPE=?";
	state1 = con.prepareStatement(sql);
	state1.setString(1,(ITEMNAME.equals("X06G-LIPRFTS1970500000")?DC:DC.replace("_","")));
	state1.setString(2,ITEMNAME);
	state1.setString(3,"MAKE");
	rs1=state1.executeQuery();
	if (rs1.next())
	{	
		dc_yyww=rs1.getString(1).substring(rs1.getString(1).length()-4);
		queryCount=rs1.getInt(2);
	}
	rs1.close();
	state1.close();
	out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+dc_yyww+'"'+","+queryCount+")</script>"); 
}
catch(Exception e)
{
	out.println("<font color='red'>Exception"+e.getMessage()+"</font>");
	out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+dc_yyww+'"'+",-1000)</script>"); 
}

%>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
