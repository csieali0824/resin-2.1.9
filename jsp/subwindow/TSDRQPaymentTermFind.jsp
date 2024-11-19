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
String name=request.getParameter("NAME");
String searchString=request.getParameter("SEARCHSTRING");
String FuncName=request.getParameter("FUNC");  //add by Peggy 20120215
if (FuncName==null) FuncName="D1007";          //add by Peggy 20120215

try
{
	if (searchString==null)
   	{     
		searchString="%"; 
   	} 
    else 
	{  //out.println("NULL input");
	}
} 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}   
%>
<html>
<head>
<title>Page for choose Payment Term List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(primaryFlag,name,code)
{
  //alert(primaryFlag);alert(name);
	if (document.SITEFORM.FUNC.value =="D1001")
	{  
  		window.opener.document.MYFORM.PAYTERMID.value=primaryFlag; 
  		window.opener.document.MYFORM.PAYTERM.value=name;
	}
	else if (document.SITEFORM.FUNC.value =="D9002" || document.SITEFORM.FUNC.value =="D11001")
	{
  		window.opener.document.MYFORM.PAYTERMID.value=primaryFlag; 
  		window.opener.document.MYFORM.PAYMENTTERM.value=code;
	}
	else
	{
  		window.opener.document.DISPLAYREPAIR.PAYTERMID.value=primaryFlag; 
  		window.opener.document.DISPLAYREPAIR.PAYTERM.value=name;
	}
  	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQPaymentTermFind.jsp" NAME=SITEFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgPaymentTerm"/><jsp:getProperty name="rPH" property="pgName"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgPaymentTerm"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
<BR>
<%  
Statement statement=con.createStatement();
try
{ 
	if (searchString!="" && searchString!=null) 
	{  	    
		String sql = "select a.TERM_ID, a.NAME, a.DESCRIPTION "+
		             "from RA_TERMS_VL a "+
		             "where a.IN_USE ='Y' "+
					 "and (a.NAME like '"+searchString+"%' or a.TERM_ID like '"+searchString+"%') order by a.name";
						 
        ResultSet rs=statement.executeQuery(sql);
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
         	colLabel[i]=md.getColumnLabel(i);
         	out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
		String code=""; //add by Peggy 20130604
        while (rs.next())
        {
			name=rs.getString("NAME")+"("+rs.getString("DESCRIPTION")+")";
		 	description=rs.getString("DESCRIPTION");
		 	code=rs.getString("NAME");  //add by Peggy 20130604
		 	if (primaryFlag==rs.getString("TERM_ID") || primaryFlag.equals(rs.getString("TERM_ID")))				 	 
		 	{ 
				trBgColor = "FFCC66"; 
			}
		 	else 
			{ 
				trBgColor = "E3E3CF"; 
			}
		 	primaryFlag=rs.getString("TERM_ID");
		 	buttonContent="this.value=sendToMainWindow("+'"'+primaryFlag+'"'+","+'"'+name+'"'+","+'"'+code+'"'+")";		
         	out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 	out.println("' onClick='"+buttonContent+"'></TD>");		
         	for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         	{
          		String s=(String)rs.getString(i);
          		out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         	} //end of for
          	out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
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
<INPUT TYPE="hidden" NAME="NAME" SIZE=30 value="<%=name%>" >
<INPUT TYPE="hidden" NAME="FUNC" SIZE=5 value="<%=FuncName%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
