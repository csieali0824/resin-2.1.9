<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ page import="DateBean,ArrayComboBoxBean,RsCountBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title>Query All BPCS unclosed PO </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function setSubmit(URL)
{  
  flag=confirm("確定要將選取的PO轉成CO嗎?"); 
  if (flag==0)
  {
    return(false);
  } else {
    rstart();
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }  
}
function rstart2(){
	showimage.style.visibility = '';
	blockDiv.style.display = '';
	init();
	slide();
	location.href='PO_To_CO_Converter(TPE).jsp';
}
function poDetail(pono,database)
{ 
  subWin=window.open("PODetailQuery.jsp?PONO="+pono+"&DATABASE="+database,"subwin","width=520,height=400,scrollbars=yes,menubar=no");  
}
</script>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String searchString=request.getParameter("SEARCHSTRING"); 
int maxrow=0;
String poArray[][]=null;
String prodType[]={"GSM","VOIP"};	
String partClass[][]={{"材料","成品","半成品"},{"C","F","A"}};	//first Dimension means the selection Name,and second Dimension means the selection value 
arrayComboBoxBean.setNoNull("Y");    

String thisDayString=dateBean.getYearMonthDay();
String sSql="";
Statement statement=null;
ResultSet rs=null;
try
{  
   statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   sSql="select PHORD,PHCOMP,PHWHSE,PHVEND,PHNAME,PHENDT,PHCMT,PHRQID from HPH"+
        " where PHID!='PZ' and PHVEND in ('91002','91080') and length(PHSHIP)<6 and PHORD<99999 and PHENDT >=20050129"+ //20050129代表上線日期
		" and PHORD not in (select PORD from TPPO2SHCO where trans_flag='Y')";
   if (UserRoles.indexOf("admin")<0) //若角色不是admin,則只能看到屬於自己的PO
   {
      sSql=sSql+" and PHRQID='T"+userID+"'";
   }		
   
   if (searchString!=null && !searchString.equals(""))
   {
     sSql=sSql+" and PHORD="+searchString;
   }		
   sSql=sSql+" ORDER BY PHORD DESC";
   rs=statement.executeQuery(sSql);
   rsCountBean.setRs(rs); 
   maxrow=rsCountBean.getRsCount(); 
   poArray=new String[maxrow][8];
   int poi=0;
   while (rs.next())
   {
     poArray[poi][0]=rs.getString("PHORD");
	 poArray[poi][1]=rs.getString("PHCOMP");
	 poArray[poi][2]=rs.getString("PHWHSE");
	 poArray[poi][3]=rs.getString("PHVEND");
	 poArray[poi][4]=rs.getString("PHNAME");
	 poArray[poi][5]=rs.getString("PHENDT");
	 poArray[poi][6]=rs.getString("PHCMT");
	 poArray[poi][7]=rs.getString("PHRQID");
     poi++;
   } 
 
   //queryAllCheckBoxBean.setFieldName("CH");   
   statement.close();
   rs.close();   
} //end of try
catch (Exception e)
{
   out.println("Exception:"+e.getMessage());
}
%>
<FORM ACTION="PO_To_CO_ConvertQueryAll(TPE).jsp" METHOD="POST" NAME="MYFORM" onSubmit="rstart()"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A><BR> 
<strong><font color="#004080" size="4">PO->CO CONVERTER</font></strong>
<table width="71%" border="1">
<tr>
<td width="36%">PO NO.:
  <INPUT type="text" name="SEARCHSTRING" size=10 <%if (searchString!=null) out.println("value="+searchString);%>></td>
<td width="20%"><INPUT name="button" TYPE="submit"  value="Query" ></td>
<td width="44%"><INPUT name="button2" TYPE="button"  onClick='setSubmit("PO_To_CO_Converter(TPE).jsp")' value="CONVERT"> </td>
</tr>
</table> 
<%
int arrayIdx=0;
try 
{
  if (maxrow>0)
  {
%> 
<TABLE width="71%" border="1" cellspacing="0">
  <tr bgcolor="#66CCCC">
    <td width="2%"><font size="2">&nbsp;&nbsp;</font></td>
    <td width="12%"><strong><font size="2">PO No.</font></strong></td>
    <td width="5%"><strong><font size="2">COMP</font></strong></td>
	<td width="5%"><strong><font size="2">WHS</font></strong></td>
	<td width="10%"><strong><font size="2">VENDOR</font></strong></td>
	<td width="25%"><strong><font size="2">PO DESC</font></strong></td>
	<td width="10%"><strong><font size="2">DATE</font></strong></td>
	<td width="20%"><strong><font size="2">COMMENT</font></strong></td>
	<td width="10%"><strong><font size="2">USER</font></strong></td>
	<td width="10%"><strong><font size="2">PROD</font></strong></td>
	<td width="10%"><strong><font size="2">CLASS</font></strong></td>
  </tr>	
<%
	  for (int i=0;i<poArray.length;i++)
	  {
%>	  	
   <tr >
    <td ><font size="2"><INPUT TYPE=checkbox NAME='CH' value='<%=poArray[arrayIdx][0]%>'></font></td>
    <td ><font size="2"><A href='javaScript:poDetail("<%=poArray[arrayIdx][0]%>","dbtel")'><%=poArray[arrayIdx][0]%></A></font></td>
    <td ><font size="2"><%=poArray[arrayIdx][1]%></font></td>
	<td ><font size="2"><%=poArray[arrayIdx][2]%></font></td>
	<td ><font size="2"><%=poArray[arrayIdx][3]%></font></td>
	<td ><font size="2"><%=poArray[arrayIdx][4]%></font></td>
	<td ><font size="2"><%=poArray[arrayIdx][5]%></font></td>
	<td ><font size="2"><%=poArray[arrayIdx][6]%></font></td>
	<td ><font size="2"><%=poArray[arrayIdx][7]%></font></td>
	<td ><font size="2">
	<%		 
	    arrayComboBoxBean.setArrayString(prodType);     
	    arrayComboBoxBean.setFieldName(poArray[arrayIdx][0]+"-PROD");
	    out.println(arrayComboBoxBean.getArrayString());	
	%>
	</font></td>
	<td ><font size="2">
	<%		 
	    arrayComboBoxBean.setArrayString2D(partClass);     
	    arrayComboBoxBean.setFieldName(poArray[arrayIdx][0]+"-CLASS");
	    out.println(arrayComboBoxBean.getArrayString2D());	
	%>
	</font></td>
  </tr>	
<%    
		  arrayIdx++;		
	  } //end of poArray for
   } else {
      out.println("There is no record found!!");	  
   } //end of maxrow>0 if	  
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());		  
}  
%>	 	
</TABLE>	
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
