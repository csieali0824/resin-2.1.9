<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(Subinventory)
{ 
	window.opener.document.MYFORM.SUBINVENTORY.value=Subinventory;
  	this.window.close();
}
</script>
<title>Page for choose Subinventory List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCPMDSubinventoryFind.jsp" NAME=SITEFORM>
<BR>
<%  
	Statement statement=con.createStatement();
	try
    { 
		String sql = " select SECONDARY_INVENTORY_NAME,DESCRIPTION FROM MTL_SECONDARY_INVENTORIES a"+
                     " WHERE  (DISABLE_DATE IS NULL OR NVL(DISABLE_DATE,TRUNC(SYSDATE)+1) > TRUNC(SYSDATE))"+
                     " and a.ORGANIZATION_ID=49"+
                     //" and SECONDARY_INVENTORY_NAME like '6%'"+
					 " and substr(SECONDARY_INVENTORY_NAME,1,1)  in ('6','7','8')"+//modify by Peggy 20161109
                     " order by SECONDARY_INVENTORY_NAME";
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		String StockCode="";
		String StockName="";
		int queryCount=0;
		String buttonContent=null;		
		while (rs.next())
		{
			if (queryCount==0)
			{
				out.println("<font face='Arial'><TABLE>");      
				out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
				for (int i=1;i<=colCount;i++) 
				{
					colLabel[i]=md.getColumnLabel(i);
					out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
				} //end of for 
				out.println("</TR>");
			}
			
			StockCode=rs.getString("SECONDARY_INVENTORY_NAME");
			StockName=rs.getString("DESCRIPTION");
			buttonContent="this.value=sendToMainWindow("+'"'+StockCode+'"'+")";		
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				out.println("<TD align='left'><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT></TD>");
			} //end of for
			out.println("</TR>");
			out.println("<input type='hidden' name='STOCKCODE' value='"+StockCode+"' >");
			queryCount++;	
		} //end of while
		rs.close();       
		if (queryCount>0)
		{		
			out.println("</TABLE></font>");						
		}
		else
		{
			out.println("<font color='red'>查無資料!!!</font>");
		}
	    if (queryCount==1) //若取到的查詢數 == 1
	    {
	     %>
		    <script LANGUAGE="JavaScript">		
				window.opener.document.MYFORM.SUBINVENTORY.value=document.SITEFORM.STOCKCODE.value;
				this.window.close(); 
            </script>
		 <%
	    }
		
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
%>
 <BR>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
