<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String primaryFlag=request.getParameter("PRIMARYFLAG");
if (primaryFlag==null) primaryFlag="";
//String description=request.getParameter("DESCRIPTION");
String searchString=request.getParameter("SEARCHSTRING");
if (searchString==null) searchString="";
//add by Peggy 20120209
String sType = request.getParameter("sType");
if (sType == null) sType = "";
try
{
	if (searchString==null || searchString.equals(""))
   	{     
		searchString="%"; 
   	} 
} 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}   
%>
<html>
<head>
<title>Page for choose Shipping Method List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(shippingMethod,shippingMethodName)
{ 
	//add by Peggy 20120209
	if (document.SHIPFORM.sType.value == "D1001" ||document.SHIPFORM.sType.value == "D1009")
	{
		window.opener.document.MYFORM.SHIPPINGMETHOD.value=shippingMethod;      
	}
	else if (document.SHIPFORM.sType.value.indexOf("D15002")>=0)  //add by Peggy 20210713
	{
		window.opener.document.MYFORM.elements["shipmethod_"+document.SHIPFORM.sType.value.replace("D15002_","")].value=shippingMethodName;      
	}
	else
	{
		window.opener.document.DISPLAYREPAIR.SHIPMETHOD.value=shippingMethod;      
	}
  	this.window.close();
}

</script>
<body >  
<FORM NAME="SHIPFORM" METHOD="post" ACTION="TSDRQShippingMethodFind.jsp">
<font size="-1"><jsp:getProperty name="rPH" property="pgShippingMethod"/><jsp:getProperty name="rPH" property="pgName"/>: 
<input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
</font> 
<INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
-----<jsp:getProperty name="rPH" property="pgShippingMethod"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
<BR>
<%  
	Statement statement=con.createStatement();
	int iCnt =0; //add by Peggy 20120507
	try
    { 
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();
				
		if (searchString!="" && searchString!=null) 
	   	{  	    
	    	String sql = " select SHIPPING_METHOD, a.DESCRIPTION,a.SHIPPING_METHOD_CODE "+
		             " from ASO_I_SHIPPING_METHODS_V a "+
		             " where (a.SHIPPING_METHOD_CODE like '"+searchString+"' OR SHIPPING_METHOD ='"+searchString+"') "+
					 " and a.SHIPPING_METHOD_CODE<>'TNT EXPRESS'"+ //排除錯誤CODE by Peggy 20201104
					 " order by 1";
					 //"and TO_CHAR(a.END_DATE_ACTIVE,'YYYYMMDD') >='"+dateBean.getYearMonthDay()+"'  ";
        	ResultSet rs=statement.executeQuery(sql);
			//out.println("sql="+sql);       		
	    	ResultSetMetaData md=rs.getMetaData();
        	int colCount=md.getColumnCount();
        	String colLabel[]=new String[colCount+1]; 
			out.println("<input type='hidden' name='sType' value='"+sType+"' >");       
        	out.println("<TABLE>");      
        	out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        	for (int i=1;i<=colCount;i++) // 
        	{
         		colLabel[i]=md.getColumnLabel(i);
         		out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        	} //end of for 
        	out.println("</TR>");
			String shippingMethod=null;
			String shippingMethodName=null; //add by Peggy 20210721
      		
        	String buttonContent=null;
			String trBgColor = "";
        	while (rs.next())
        	{
		 		//primaryFlag=rs.getString("TERM_ID");
		 		shippingMethod=rs.getString("SHIPPING_METHOD_CODE");
				shippingMethodName=rs.getString("SHIPPING_METHOD"); //add by Peggy 20210721
		 		//description=rs.getString("DESCRIPTION");
		 
		 		if (primaryFlag==rs.getString("SHIPPING_METHOD_CODE") || primaryFlag.equals(rs.getString("SHIPPING_METHOD_CODE")))				 	 
		 		{ 
					trBgColor = "FFCC66"; 
				}
		 		else 
				{ 
					trBgColor = "E3E3CF"; 
				}
		 		buttonContent="this.value=sendToMainWindow("+'"'+shippingMethod+'"'+","+'"'+shippingMethodName+'"'+")";		
         		out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 		out.println("' onClick='"+buttonContent+"'></TD>");		
         		for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         		{
          			String s=(String)rs.getString(i);
          			out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         		} //end of for
          		out.println("</TR>");	
				out.println("<input type='hidden' name='SHIPPINGMETHOD' value='"+shippingMethod+"' >");    
				out.println("<input type='hidden' name='SHIPPINGMETHODNAME' value='"+shippingMethodName+"' >");    
				iCnt++;
        	} //end of while
        	out.println("</TABLE>");						
        	rs.close();   
			if (iCnt ==1) //add by Peggy 20120507
			{
			%>
		    <script LANGUAGE="JavaScript">		
				if (document.SHIPFORM.sType.value == "D1001" || document.SHIPFORM.sType.value == "D1009")
				{
					window.opener.document.MYFORM.SHIPPINGMETHOD.value=document.SHIPFORM.SHIPPINGMETHOD.value;      
				}
				else if (document.SHIPFORM.sType.value.indexOf("D15002")>=0) //add by Peggy 202100713
				{
					window.opener.document.MYFORM.elements["shipmethod_"+document.SHIPFORM.sType.value.replace("D15002_","")].value=document.SHIPFORM.SHIPPINGMETHODNAME.value; 
				}
				else
				{
					window.opener.document.DISPLAYREPAIR.SHIPMETHOD.value=document.SHIPFORM.SHIPPINGMETHOD.value;  
				}
				this.window.close();
            </script>
			<%
			}    
	   	}//end of while
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
%>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
