<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp/"%>
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Inventory Inquiry</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function rstart2(){
	showimage.style.visibility = '';
	blockDiv.style.display = '';
	init();
	slide();
	location.href='SHAInventoryInquiry.jsp';
}
</script>
<body>
<%
String sWarehouse=request.getParameter("WAREHOUSE");
String sPartNumber=request.getParameter("PARTNUMBER");
if (sPartNumber==null || sPartNumber.equals("") )
{
  sPartNumber="";
}
int qty=0;  
String bgColor="#FFFFFF";

Statement st=ifxshoescon.createStatement();
Statement expStmt=ifxdbexpcon.createStatement();
ResultSet rs=null;
%>
<form ACTION="SHAInventoryInquiry.jsp" METHOD="post" NAME="MYFORM">
<font color="#009999" face="Times New Roman" size="+3"><strong>上海大霸庫存查詢</strong></font>
<font color="#000000" face="Times New Roman" size="+2"><strong>Inventory Inquiry</strong></font>
<br>
<A HREF="../WinsMainMenu.jsp">HOME</A>
<table width="500" border="1">
<tr>
<td width="35%"><font face="Arial" color="#000000" size="+1"><strong>倉別:</strong></font><font face="Arial" color="#000000" size="+1"><strong>
<%
	try {		
		String warehouse[][]={{"AS-內銷成品","BE-內銷半成品","RM-內銷原料","G9-外銷成品","G8-外銷半成品","G3-外銷原料","G1-外銷原料"},{"AS","BE","RM","G9","G8","G3","G1"}};	
		arrayComboBoxBean.setArrayString2D(warehouse);   
		arrayComboBoxBean.setSelection(sWarehouse);  
	    arrayComboBoxBean.setFieldName("WAREHOUSE");
	    out.println(arrayComboBoxBean.getArrayString2D());					
	} //end try
	catch (Exception e){out.println("Exception:"+e.getMessage());	}
%>
	</strong></font></td>
<td width="50%" bgcolor="#FFFFFF"><font face="Arial" color="#000000" size="+1"><strong>料號:</strong></font>
     <input type="TEXT" NAME='PARTNUMBER' SIZE=20 value='<%=sPartNumber%>'></td>
<td width="20%"><font face="Arial" color="#000000" size="+1"><strong>
	<input type="submit" name="Query"  value="QUERY">
	</strong></font>
</td>
</tr>
</table>

<table border="1">
<tr>
	<td><font face="Arial" color="#000000" size="1"><strong>倉別</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>料號</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>料號說明</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>單位</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>庫存</strong></font></td>
</tr>

<%
try {
       if (sPartNumber==null || sPartNumber.equals("") )
       {
         sPartNumber="-";
       }

	 if ( sWarehouse!=null && !sWarehouse.equals("--") ) 
	 {				
		String sql="";		
		//依據所選倉別決定取用哪一個資料庫
		if (sWarehouse.equals("G1") || sWarehouse.equals("G3") || sWarehouse.equals("G8") || sWarehouse.equals("G9"))
		{
		    sql = "SELECT wwhs,wprod,idesc||idsce as desc,iums,wopb+wrct-wiss+wadj as inv"+
		          " FROM IWI,IIM "+
		          " WHERE wid='WI' and iprod=wprod and wwhs in ('G1','G3','G8','G9') and wwhs='"+sWarehouse+"' and wprod like '"+sPartNumber+"%'";		
		    sql = sql + " ORDER BY wprod";		
		    rs = expStmt.executeQuery(sql); 
		} else {			
 		    sql = "SELECT wwhs,wprod,idesc||idsce as desc,iums,wopb+wrct-wiss+wadj as inv"+
		          " FROM IWI,IIM "+
		          " WHERE wid='WI' and iprod=wprod and wwhs in ('RM','BE','AS') and wwhs='"+sWarehouse+"' and wprod like '"+sPartNumber+"%'";		
		    sql = sql + " ORDER BY wprod";		
		    rs = st.executeQuery(sql);
		} //end of if  => sWarehouse.equals("G1")		
		
		while (rs.next()) 
		{
		  qty=rs.getInt("inv");  
		  if (qty>0) 
		  { 
		    bgColor="#CCCCFF";
		  } else {
		    bgColor="#FFFFFF";
		  }		  	
%>
	<tr bgcolor="<%=bgColor%>">
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("wwhs")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("wprod")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("desc")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("iums")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getInt("inv")%></strong></font></td>
	</tr>
<%
		} // end while
		rs.close();		
	} // end if	
} // end try
catch (Exception ec)
{
  out.println("Exception:"+ec.getMessage());	
  %>
  <%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
  <%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
  <%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
  <%
}
st.close();	
expStmt.close();
%>
</table>
</form>

</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>